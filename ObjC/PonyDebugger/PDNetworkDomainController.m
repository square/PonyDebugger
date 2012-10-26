//
//  PDAFNetworkDomainController.m
//  PonyDebugger
//
//  Created by Mike Lewis on 2/27/12.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDNetworkDomainController.h"

#import "NSData+PDB64Additions.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <dispatch/queue.h>


@interface _PDRequestState : NSObject

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *dataAccumulator;
@property (nonatomic, copy) NSString *requestID;

@end


@interface PDNetworkDomainController ()

- (void)setResponse:(NSData *)response forRequestID:(NSString *)requestID isBinary:(BOOL)isBinary;
- (void)performBlock:(dispatch_block_t)block;

@end


@implementation PDNetworkDomainController {
    NSCache *_responseCache;
    NSMutableDictionary *_connectionStates;
    dispatch_queue_t _queue;
}

@dynamic domain;

#pragma mark - Statics

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
        seed = (__bridge NSString *)CFUUIDCreateString(CFAllocatorGetDefault(), uuid);
        CFRelease(uuid);
    });
    
    return [[NSString alloc] initWithFormat:@"%@-%d", seed, ++sequenceNumber];
}

+ (Class)domainClass;
{
    return [PDNetworkDomain class];
}

#pragma mark Delegate Injection Convenience Methods

+ (SEL)swizzledSelectorForSelector:(SEL)selector;
{
    return NSSelectorFromString([NSString stringWithFormat:@"_pd_swizzle_%x_%@", arc4random(), NSStringFromSelector(selector)]);
}

+ (void)domainControllerSwizzleGuardForSwizzledObject:(NSObject *)object selector:(SEL)selector implementationBlock:(void (^)(void))implementationBlock;
{
    void *key = (__bridge void *)[[NSString alloc] initWithFormat:@"PDSelectorGuardKeyForSelector:%@", NSStringFromSelector(selector)];
    if (!objc_getAssociatedObject(object, key)) {
        objc_setAssociatedObject(object, key, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_ASSIGN);
        implementationBlock();
        objc_setAssociatedObject(object, key, nil, OBJC_ASSOCIATION_ASSIGN);
    }
}

+ (BOOL)instanceRespondsButDoesNotImplementSelector:(SEL)selector class:(Class)cls;
{
    if ([cls instancesRespondToSelector:selector]) {
        unsigned int numMethods = 0;
        Method *methods = class_copyMethodList(cls, &numMethods);
        
        BOOL implementsSelector = NO;
        for (int index = 0; index < numMethods; index++) {
            SEL methodSelector = method_getName(methods[index]);
            if (selector == methodSelector) {
                implementsSelector = YES;
                break;
            }
        }
        
        if (!implementsSelector) {
            return YES;
        }
    }
    
    return NO;
}

+ (void)replaceImplementationOfSelector:(SEL)selector withSelector:(SEL)swizzledSelector forClass:(Class)cls withMethodDescription:(struct objc_method_description)methodDescription implementationBlock:(id)implementationBlock undefinedBlock:(id)undefinedBlock;
{
    if ([self instanceRespondsButDoesNotImplementSelector:selector class:cls]) {
        return;
    }

#ifdef __IPHONE_6_0
    IMP implementation = imp_implementationWithBlock((id)([cls instancesRespondToSelector:selector] ? implementationBlock : undefinedBlock));
#else
    IMP implementation = imp_implementationWithBlock((__bridge void *)([cls instancesRespondToSelector:selector] ? implementationBlock : undefinedBlock));
#endif
    
    Method oldMethod = class_getInstanceMethod(cls, selector);
    if (oldMethod) {
        class_addMethod(cls, swizzledSelector, implementation, methodDescription.types);
         
        Method newMethod = class_getInstanceMethod(cls, swizzledSelector);
        
        method_exchangeImplementations(oldMethod, newMethod);
    } else {
        class_addMethod(cls, selector, implementation, methodDescription.types);
    }
}

#pragma mark - Delegate Injection

+ (void)injectIntoAllNSURLConnectionDelegateClasses;
{
    // Only allow swizzling once.
    static BOOL swizzled = NO;
    if (swizzled) {
        return;
    }
    
    swizzled = YES;

    // Swizzle any classes that implement one of these selectors.
    const SEL selectors[] = {
        @selector(connectionDidFinishLoading:),
        @selector(connection:didReceiveResponse:)
    };
    
    const int numSelectors = sizeof(selectors) / sizeof(SEL);

    Class *classes = NULL;
    NSInteger numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0) {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (NSInteger classIndex = 0; classIndex < numClasses; ++classIndex) {
            Class class = classes[classIndex];
            
            if (class_getClassMethod(class, @selector(isSubclassOfClass:)) == NULL) {
                continue;
            }
            
            if (![class isSubclassOfClass:[NSObject class]]) {
                continue;
            }
            
            if ([class isSubclassOfClass:[PDNetworkDomainController class]]) {
                continue;
            }
            
            for (int selectorIndex = 0; selectorIndex < numSelectors; ++selectorIndex) {
                if ([class instancesRespondToSelector:selectors[selectorIndex]]) {
                    [self injectIntoDelegateClass:class];
                    break;
                }
            }
        }
        
        free(classes);
    }
}

+ (void)injectIntoDelegateClass:(Class)cls;
{
    [self injectWillSendRequestIntoDelegateClass:cls];
    [self injectDidReceiveDataIntoDelegateClass:cls];
    [self injectDidReceiveResponseIntoDelegateClass:cls];
    [self injectDidFinishLoadingIntoDelegateClass:cls];
    [self injectDidFailWithErrorIntoDelegateClass:cls];
}

+ (void)injectWillSendRequestIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(connection:willSendRequest:redirectResponse:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDataDelegate);
    if (!protocol) {
        protocol = @protocol(NSURLConnectionDelegate);
    }
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef NSURLRequest *(^NSURLConnectionWillSendRequestBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLRequest *request, NSURLResponse *response);
    
    NSURLConnectionWillSendRequestBlock undefinedBlock = ^NSURLRequest *(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLRequest *request, NSURLResponse *response) {
        [self domainControllerSwizzleGuardForSwizzledObject:slf selector:selector implementationBlock:^{
            [[PDNetworkDomainController defaultInstance] connection:connection willSendRequest:request redirectResponse:response];
        }];
        
        return request;
    };
    
    NSURLConnectionWillSendRequestBlock implementationBlock = ^NSURLRequest *(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLRequest *request, NSURLResponse *response) {
        NSURLRequest *returnValue = objc_msgSend(slf, swizzledSelector, connection, request, response);
        undefinedBlock(slf, connection, request, response);
        return returnValue;
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectDidReceiveResponseIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(connection:didReceiveResponse:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDataDelegate);
    if (!protocol) {
        protocol = @protocol(NSURLConnectionDelegate);
    }
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLConnectionDidReceiveResponseBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLResponse *response);
    
    NSURLConnectionDidReceiveResponseBlock undefinedBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLResponse *response) {
        [self domainControllerSwizzleGuardForSwizzledObject:slf selector:selector implementationBlock:^{
            [[PDNetworkDomainController defaultInstance] connection:connection didReceiveResponse:response];
        }];
    };
    
    NSURLConnectionDidReceiveResponseBlock implementationBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLResponse *response) {
        undefinedBlock(slf, connection, response);
        objc_msgSend(slf, swizzledSelector, connection, response);
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectDidReceiveDataIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(connection:didReceiveData:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDataDelegate);
    if (!protocol) {
        protocol = @protocol(NSURLConnectionDelegate);
    }
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLConnectionDidReceiveDataBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSData *data);
    
    NSURLConnectionDidReceiveDataBlock undefinedBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSData *data) {
        [[PDNetworkDomainController defaultInstance] connection:connection didReceiveData:data];
    };
    
    NSURLConnectionDidReceiveDataBlock implementationBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSData *data) {
        undefinedBlock(slf, connection, data);
        objc_msgSend(slf, swizzledSelector, connection, data);
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectDidFinishLoadingIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(connectionDidFinishLoading:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDataDelegate);
    if (!protocol) {
        protocol = @protocol(NSURLConnectionDelegate);
    }
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLConnectionDidFinishLoadingBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection);
    
    NSURLConnectionDidFinishLoadingBlock undefinedBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection) {
        [[PDNetworkDomainController defaultInstance] connectionDidFinishLoading:connection];
    };
    
    NSURLConnectionDidFinishLoadingBlock implementationBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection) {
        undefinedBlock(slf, connection);
        objc_msgSend(slf, swizzledSelector, connection);
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectDidFailWithErrorIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(connection:didFailWithError:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDelegate);
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLConnectionDidFailWithErrorBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSError *error);
    
    NSURLConnectionDidFailWithErrorBlock undefinedBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSError *error) {
        [[PDNetworkDomainController defaultInstance] connection:connection didFailWithError:error];
    };
    
    NSURLConnectionDidFailWithErrorBlock implementationBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSError *error) {
        undefinedBlock(slf, connection, error);
        objc_msgSend(slf, swizzledSelector, connection, error);
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

#pragma mark - Initialization

- (id)init;
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _connectionStates = [[NSMutableDictionary alloc] init];
    _responseCache = [[NSCache alloc] init];
    _queue = dispatch_queue_create("com.squareup.ponydebugger.PDNetworkDomainController", DISPATCH_QUEUE_SERIAL);
    
    return self;
}

- (void)dealloc
{
    if (_queue) {
        dispatch_release(_queue);
    }
}

#pragma mark - PDNetworkCommandDelegate

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


#pragma mark - Private Methods

- (void)setResponse:(NSData *)response forRequestID:(NSString *)requestID isBinary:(BOOL)isBinary;
{
    NSString *encodedBody = isBinary ?
                            response.PD_stringByBase64Encoding :
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

- (void)setAccumulatedData:(NSMutableData *)data forConnection:(NSURLConnection *)connection;
{
    _PDRequestState *requestState = [self requestStateForConnection:connection];
    requestState.dataAccumulator = data;
}

- (void)addAccumulatedData:(NSData *)data forConnection:(NSURLConnection *)connection;
{
    NSMutableData *dataAccumulator = [self requestStateForConnection:connection].dataAccumulator;
    
    NSAssert(dataAccumulator != nil, @"Data accumulator not initialized before adding to it.");
    
    [dataAccumulator appendData:data];
}

- (NSData *)accumulatedDataForConnection:(NSURLConnection *)connection;
{
    return [self requestStateForConnection:connection].dataAccumulator;
}

// This removes storing the accumulated request/response from the dictionary so we can release connection
- (void)connectionFinished:(NSURLConnection *)connection;
{
    [_connectionStates removeObjectForKey:connection];
}

- (void)performBlock:(dispatch_block_t)block;
{
    dispatch_async(_queue, block);
}

@end


@implementation PDNetworkDomainController (NSURLConnectionHelpers)

- (void)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response;
{
    [self performBlock:^{
        [self setRequest:request forConnection:connection];
        PDNetworkRequest *networkRequest = [PDNetworkRequest networkRequestWithURLRequest:request];
        PDNetworkResponse *networkRedirectResponse = response ? [[PDNetworkResponse alloc] initWithURLResponse:response request:request] : nil;
        
        [self.domain requestWillBeSentWithRequestId:[self requestIDForConnection:connection]
                                            frameId:@""
                                           loaderId:@""
                                        documentURL:[request.URL absoluteString]
                                            request:networkRequest
                                          timestamp:[NSDate PD_timestamp]
                                          initiator:nil
                                   redirectResponse:networkRedirectResponse];
    }];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    [self performBlock:^{

        // If the request wasn't generated yet, then willSendRequest was not called. This appears to be an inconsistency in documentation
        // and behavior.
        NSURLRequest *request = [self requestForConnection:connection];
        if (!request) {
        
            NSLog(@"PonyDebugger Warning: -[PDNetworkDomainController connection:willSendRequest:redirectResponse:] not called, request timestamp may be inaccurate. See Known Issues in the README for more information.");

            request = connection.currentRequest;
            [self setRequest:request forConnection:connection];

            PDNetworkRequest *networkRequest = [PDNetworkRequest networkRequestWithURLRequest:request];
            [self.domain requestWillBeSentWithRequestId:[self requestIDForConnection:connection]
                                                frameId:@""
                                               loaderId:@""
                                            documentURL:[request.URL absoluteString]
                                                request:networkRequest
                                              timestamp:[NSDate PD_timestamp]
                                              initiator:nil
                                       redirectResponse:nil];
        }

        [self setResponse:response forConnection:connection];
        
        NSMutableData *dataAccumulator = nil;
        if (response.expectedContentLength < 0) {
            dataAccumulator = [[NSMutableData alloc] init];
        } else {
            dataAccumulator = [[NSMutableData alloc] initWithCapacity:response.expectedContentLength];
        }
        
        [self setAccumulatedData:dataAccumulator forConnection:connection];
        
        NSString *requestID = [self requestIDForConnection:connection];
        PDNetworkResponse *networkResponse = [PDNetworkResponse networkResponseWithURLResponse:response request:[self requestForConnection:connection]];
        
        [self.domain responseReceivedWithRequestId:requestID
                                           frameId:@""
                                          loaderId:@""
                                         timestamp:[NSDate PD_timestamp]
                                              type:response.PD_responseType
                                          response:networkResponse];
    }];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    // Just to be safe since we're doing this async
    data = [data copy];
    [self performBlock:^{
        [self addAccumulatedData:data forConnection:connection];
        
        NSNumber *length = [NSNumber numberWithInteger:data.length];
        NSString *requestID = [self requestIDForConnection:connection];
        
        [self.domain dataReceivedWithRequestId:requestID
                                     timestamp:[NSDate PD_timestamp]
                                    dataLength:length
                             encodedDataLength:length];
    }];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    [self performBlock:^{
        NSURLResponse *response = [self responseForConnection:connection];
        NSString *requestID = [self requestIDForConnection:connection];
        
        BOOL isBinary = ([response.MIMEType rangeOfString:@"json"].location == NSNotFound) && ([response.MIMEType rangeOfString:@"text"].location == NSNotFound) && ([response.MIMEType rangeOfString:@"xml"].location == NSNotFound);
        
        NSData *accumulatedData = [self accumulatedDataForConnection:connection];
        
        [self setResponse:accumulatedData
             forRequestID:requestID
                 isBinary:isBinary];
        
        [self.domain loadingFinishedWithRequestId:requestID
                                        timestamp:[NSDate PD_timestamp]];
        
        [self connectionFinished:connection];
    }];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
    [self performBlock:^{
        [self.domain loadingFailedWithRequestId:[self requestIDForConnection:connection]
                                      timestamp:[NSDate PD_timestamp]
                                      errorText:[error localizedDescription]
                                       canceled:[NSNumber numberWithBool:NO]];
        
        [self connectionFinished:connection];
    }];

}

@end


@implementation PDNetworkRequest (PDNetworkHelpers)

- (id)initWithURLRequest:(NSURLRequest *)request
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.url = [request.URL absoluteString];
    self.method = request.HTTPMethod;
    self.headers = request.allHTTPHeaderFields;
    
    
    NSData *body = request.HTTPBody;
    
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    // Do some trivial redacting here.  In particular, redact password 
    if (body && contentType && [contentType rangeOfString:@"json"].location != NSNotFound) {
        NSMutableDictionary *obj = [NSJSONSerialization JSONObjectWithData:body options:0 error:NULL];
        if ([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"password"]) {
            obj = [obj mutableCopy];
            [obj setObject:@"[REDACTED]" forKey:@"password"];
            body = [NSJSONSerialization dataWithJSONObject:obj options:0 error:NULL];
        }
    }
     
    // If the data isn't UTF-8 it will just be nil;
    self.postData = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    
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
    if (!self) {
        return nil;
    }
    
    self.url = [response.URL absoluteString];
    
    // TODO: Pretty version of status codes.
    self.statusText = @"";
    
    self.mimeType = response.MIMEType;
    self.requestHeaders = request.allHTTPHeaderFields;
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        self.status = [NSNumber numberWithInteger:((NSHTTPURLResponse *)response).statusCode];
        self.headers = ((NSHTTPURLResponse *)response).allHeaderFields;
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
        type = @"XHR";
    }

    return type;
}

@end


@implementation _PDRequestState

@synthesize request = _request;
@synthesize response = _response;
@synthesize requestID = _requestID;
@synthesize dataAccumulator = _dataAccumulator;

@end
