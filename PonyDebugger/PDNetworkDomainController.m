//
//  PDAFNetworkDomainController.m
//  PonyDebugger
//
//  Created by Mike Lewis on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDNetworkDomainController.h"
#import <SocketRocket/NSData+SRB64Additions.h>

@interface _PDRequestState : NSObject

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) NSURLResponse *response;
@property (nonatomic, copy) NSString *requestID;

@end

@implementation PDNetworkDomainController {
    NSCache *_responseCache;
    NSMutableDictionary *_connectionStates;
}

@dynamic domain;

+ (PDNetworkDomainController *)defaultInstance;
{
    static PDNetworkDomainController *defaultInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultInstance = [[PDNetworkDomainController alloc] init];
    });
    return defaultInstance;
}

+ (NSString *)nextRequestID;
{
    static NSInteger sequenceNumber = 0;
    static NSString *seed = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CFUUIDRef uuid = CFUUIDCreate(CFAllocatorGetDefault());
        seed = (NSString *)CFUUIDCreateString(CFAllocatorGetDefault(), uuid);
    });
    return [[NSString alloc] initWithFormat:@"%@-%d", seed, ++sequenceNumber];
}

+ (Class)domainClass;
{
    return [PDNetworkDomain class];
}

- (id)init;
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _connectionStates = [[NSMutableDictionary alloc] init];
    _responseCache = [[NSCache alloc] init];
    return self;
}

- (void)domain:(PDNetworkDomain *)domain canClearBrowserCacheWithCallback:(void (^)(NSNumber *, id))callback;
{
    callback([NSNumber numberWithBool:NO], nil);
}

- (void)domain:(PDNetworkDomain *)domain canClearBrowserCookiesWithCallback:(void (^)(NSNumber *, id))callback
{
    callback([NSNumber numberWithBool:NO], nil);
}

- (void)domain:(PDNetworkDomain *)domain clearBrowserCacheWithCallback:(void (^)(id))callback;
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    callback(nil);
}

- (void)domain:(PDNetworkDomain *)domain getResponseBodyWithRequestId:(NSString *)requestId callback:(void (^)(NSString *, NSNumber *, id))callback;
{
    NSDictionary *response = [_responseCache objectForKey:requestId];
    callback([response objectForKey:@"body"], [response objectForKey:@"base64Encoded"], nil);
}

- (void)setResponse:(NSData *)response forRequestID:(NSString *)requestID isBinary:(BOOL)isBinary
{
    NSString *encodedBody = isBinary ?
                            response.SR_stringByBase64Encoding :
                            [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];

    NSDictionary *responseDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       encodedBody, @"body",
                                                       [NSNumber numberWithBool:isBinary], @"base64Encoded",
                                                       nil];

    [_responseCache setObject:responseDict forKey:requestID cost:[response length]];
}

- (_PDRequestState *)requestStateForConnection:(NSURLConnection *)connection;
{
    NSValue *key = [NSValue valueWithNonretainedObject:connection];
    _PDRequestState *state = [_connectionStates objectForKey:key];
    if (!state) {
        state = [[_PDRequestState alloc] init];
        state.requestID = [[self class] nextRequestID];
        [_connectionStates setObject:state forKey:key];
    }

    return state;
}

- (NSString *)requestIDForConnection:(NSURLConnection *)connection;
{
    return [self requestStateForConnection:connection].requestID;
}

- (void)setResponse:(NSURLResponse *)response forConnection:(NSURLConnection *)connection;
{
    [self requestStateForConnection:connection].response = response;
}

- (NSURLResponse *)responseForConnection:(NSURLConnection *)connection;
{
    return [self requestStateForConnection:connection].response;
}

- (void)setRequest:(NSURLRequest *)request forConnection:(NSURLConnection *)connection;
{
    [self requestStateForConnection:connection].request = request;
}

- (NSURLRequest *)requestForConnection:(NSURLConnection *)connection;
{
    return [self requestStateForConnection:connection].request;
}

// This removes storing the accumulated request/response from the dictionary so we can release connection
- (void)connectionFinished:(NSURLConnection *)connection;
{
    [_connectionStates removeObjectForKey:connection];
}

@end


@implementation PDNetworkDomainController (NSURLConnectionHelpers)

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
    [self.domain 
     loadingFailedWithRequestId:[self requestIDForConnection:connection] 
     timestamp:[NSDate PD_timestamp] 
     errorText:[error localizedDescription]
     canceled:[NSNumber numberWithBool:NO]];

    [self connectionFinished:connection];
}

- (void)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response;
{
    [self setRequest:request forConnection:connection];
    PDNetworkRequest *networkRequest = [PDNetworkRequest networkRequestWithURLRequest:request];
    PDNetworkResponse *networkRedirectResponse = response ? [[PDNetworkResponse alloc] initWithURLResponse:response request:request] : nil;

    [self.domain
     requestWillBeSentWithRequestId:[self requestIDForConnection:connection]
     frameId:@""
     loaderId:@""
     documentURL:[request.URL absoluteString]
     request:networkRequest
     timestamp:[NSDate PD_timestamp]
     initiator:nil
     stackTrace:nil
     redirectResponse:networkRedirectResponse];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    [self setResponse:response forConnection:connection];
    NSString *requestID = [self requestIDForConnection:connection];

    [self.domain 
     responseReceivedWithRequestId:requestID 
     frameId:@""
     loaderId:@"" 
     timestamp:[NSDate PD_timestamp] 
     type:response.PD_responseType
     response:[PDNetworkResponse
               networkResponseWithURLResponse:response 
               request:[self requestForConnection:connection]]];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    NSNumber *length = [NSNumber numberWithInteger:data.length];
    NSString *requestID = [self requestIDForConnection:connection];
    
    [self.domain 
     dataReceivedWithRequestId:requestID 
     timestamp:[NSDate PD_timestamp] 
     dataLength:length 
     encodedDataLength:length];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection responseBody:(NSData *)responseBody;
{
    NSURLResponse *response = [self responseForConnection:connection];
    NSString *requestID = [self requestIDForConnection:connection];

    BOOL isBinary = ([response.MIMEType rangeOfString:@"json"].location != NSNotFound) && ([response.MIMEType rangeOfString:@"text"].location != NSNotFound);
    
    [self
     setResponse:responseBody 
     forRequestID:requestID
     isBinary:isBinary];
    
    [self.domain
     loadingFinishedWithRequestId:requestID
     timestamp:[NSDate PD_timestamp]];

    [self connectionFinished:connection];
}

@end


@implementation PDNetworkRequest (PDNetworkHelpers)

- (id)initWithURLRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        self.url = [request.URL absoluteString];
        self.method = request.HTTPMethod;
        self.headers = request.allHTTPHeaderFields;
        // If the data isn't UTF-8 it will just be nil;
        self.postData = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    }
    return self;
}

+ (PDNetworkRequest *)networkRequestWithURLRequest:(NSURLRequest *)request;
{
    return [[[self class] alloc] initWithURLRequest:request];
}

@end


@implementation PDNetworkResponse (PDNetworkHelpers)

- (id)initWithURLResponse:(NSURLResponse *)response request:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        self.url = [response.URL absoluteString];
        self.statusText = @"<PonyDebugger TODO>";
        self.mimeType = response.MIMEType;
        self.requestHeaders = request.allHTTPHeaderFields;

        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            self.status = [NSNumber numberWithInteger:((NSHTTPURLResponse *)response).statusCode];
            self.headers = ((NSHTTPURLResponse *)response).allHeaderFields;
        }
    }
    return self;
}

+ (PDNetworkResponse *)networkResponseWithURLResponse:(NSURLResponse *)response request:(NSURLRequest *)request;
{

    return [[[self class] alloc] initWithURLResponse:response request:request];
}

@end


@implementation NSURLResponse (PDNetworkHelpers)

- (NSString *)PD_responseType;
{
    NSString *MIMEType = self.MIMEType;

    NSString *contentType = [MIMEType lowercaseString];

    NSString *type = @"Other";
    if ([contentType rangeOfString:@"image"].length != 0) {
        type = @"Image";
    } else if ([contentType rangeOfString:@"json"].length != 0) {
        type = @"Script";
    }

    return type;
}

@end


@implementation _PDRequestState

@synthesize request = _request;
@synthesize response = _response;
@synthesize requestID = _requestID;

@end
