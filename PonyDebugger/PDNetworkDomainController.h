//
//  PDAFNetworkDomainController.h
//  PonyDebugger
//
//  Created by Mike Lewis on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <PonyDebugger/PDDomainController.h>
#import <PonyDebugger/DerivedSources/PDNetworkTypes.h>
#import <PonyDebugger/DerivedSources/PDNetworkDomain.h>

@interface PDNetworkDomainController : PDDomainController <PDNetworkCommandDelegate>

+ (PDNetworkDomainController *)defaultInstance;

@property (nonatomic, retain) PDNetworkDomain *domain;

// Call this after you finished accumulating the body
- (void)setResponse:(NSData *)response forRequestID:(NSString *)requestID isBinary:(BOOL)isBinary;

@end

@interface PDNetworkDomainController (NSURLConnectionHelpers)

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

- (void)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection responseBody:(NSData *)responseBody;

@end


@interface PDNetworkRequest (PDNetworkHelpers)

- (id)initWithURLRequest:(NSURLRequest *)request;
+ (PDNetworkRequest *)networkRequestWithURLRequest:(NSURLRequest *)request;

@end


@interface PDNetworkResponse (PDNetworkHelpers)

- (id)initWithURLResponse:(NSURLResponse *)response request:(NSURLRequest *)request;
+ (PDNetworkResponse *)networkResponseWithURLResponse:(NSURLResponse *)response request:(NSURLRequest *)request;

@end


@interface NSURLResponse (PDNetworkHelpers)

- (NSString *)PD_responseType;

@end
