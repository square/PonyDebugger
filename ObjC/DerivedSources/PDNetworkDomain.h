//
//  PDNetworkDomain.h
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>

@class PDNetworkWebSocketFrame;
@class PDNetworkRequest;
@class PDNetworkInitiator;
@class PDNetworkResponse;
@class PDNetworkWebSocketRequest;
@class PDNetworkWebSocketResponse;

@protocol PDNetworkCommandDelegate;

// Network domain allows tracking network activities of the page. It exposes information about http, file, data and other requests and responses, their headers, bodies, timing, etc.
@interface PDNetworkDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDNetworkCommandDelegate, PDCommandDelegate> delegate;

// Events

// Fired when page is about to send HTTP request.
// Param requestId: Request identifier.
// Param frameId: Frame identifier.
// Param loaderId: Loader identifier.
// Param documentURL: URL of the document this request is loaded for.
// Param request: Request data.
// Param timestamp: Timestamp.
// Param wallTime: UTC Timestamp.
// Param initiator: Request initiator.
// Param redirectResponse: Redirect response data.
// Param type: Type of this resource.
- (void)requestWillBeSentWithRequestId:(NSString *)requestId frameId:(NSString *)frameId loaderId:(NSString *)loaderId documentURL:(NSString *)documentURL request:(PDNetworkRequest *)request timestamp:(NSNumber *)timestamp wallTime:(NSNumber *)wallTime initiator:(PDNetworkInitiator *)initiator redirectResponse:(PDNetworkResponse *)redirectResponse type:(NSString *)type;

// Fired if request ended up loading from cache.
// Param requestId: Request identifier.
- (void)requestServedFromCacheWithRequestId:(NSString *)requestId;

// Fired when HTTP response is available.
// Param requestId: Request identifier.
// Param frameId: Frame identifier.
// Param loaderId: Loader identifier.
// Param timestamp: Timestamp.
// Param type: Resource type.
// Param response: Response data.
- (void)responseReceivedWithRequestId:(NSString *)requestId frameId:(NSString *)frameId loaderId:(NSString *)loaderId timestamp:(NSNumber *)timestamp type:(NSString *)type response:(PDNetworkResponse *)response;

// Fired when data chunk was received over the network.
// Param requestId: Request identifier.
// Param timestamp: Timestamp.
// Param dataLength: Data chunk length.
// Param encodedDataLength: Actual bytes received (might be less than dataLength for compressed encodings).
- (void)dataReceivedWithRequestId:(NSString *)requestId timestamp:(NSNumber *)timestamp dataLength:(NSNumber *)dataLength encodedDataLength:(NSNumber *)encodedDataLength;

// Fired when HTTP request has finished loading.
// Param requestId: Request identifier.
// Param timestamp: Timestamp.
// Param encodedDataLength: Total number of bytes received for this request.
- (void)loadingFinishedWithRequestId:(NSString *)requestId timestamp:(NSNumber *)timestamp encodedDataLength:(NSNumber *)encodedDataLength;

// Fired when HTTP request has failed to load.
// Param requestId: Request identifier.
// Param timestamp: Timestamp.
// Param type: Resource type.
// Param errorText: User friendly error message.
// Param canceled: True if loading was canceled.
- (void)loadingFailedWithRequestId:(NSString *)requestId timestamp:(NSNumber *)timestamp type:(NSString *)type errorText:(NSString *)errorText canceled:(NSNumber *)canceled;

// Fired when WebSocket is about to initiate handshake.
// Param requestId: Request identifier.
// Param timestamp: Timestamp.
// Param wallTime: UTC Timestamp.
// Param request: WebSocket request data.
- (void)webSocketWillSendHandshakeRequestWithRequestId:(NSString *)requestId timestamp:(NSNumber *)timestamp wallTime:(NSNumber *)wallTime request:(PDNetworkWebSocketRequest *)request;

// Fired when WebSocket handshake response becomes available.
// Param requestId: Request identifier.
// Param timestamp: Timestamp.
// Param response: WebSocket response data.
- (void)webSocketHandshakeResponseReceivedWithRequestId:(NSString *)requestId timestamp:(NSNumber *)timestamp response:(PDNetworkWebSocketResponse *)response;

// Fired upon WebSocket creation.
// Param requestId: Request identifier.
// Param url: WebSocket request URL.
- (void)webSocketCreatedWithRequestId:(NSString *)requestId url:(NSString *)url;

// Fired when WebSocket is closed.
// Param requestId: Request identifier.
// Param timestamp: Timestamp.
- (void)webSocketClosedWithRequestId:(NSString *)requestId timestamp:(NSNumber *)timestamp;

// Fired when WebSocket frame is received.
// Param requestId: Request identifier.
// Param timestamp: Timestamp.
// Param response: WebSocket response data.
- (void)webSocketFrameReceivedWithRequestId:(NSString *)requestId timestamp:(NSNumber *)timestamp response:(PDNetworkWebSocketFrame *)response;

// Fired when WebSocket frame error occurs.
// Param requestId: Request identifier.
// Param timestamp: Timestamp.
// Param errorMessage: WebSocket frame error message.
- (void)webSocketFrameErrorWithRequestId:(NSString *)requestId timestamp:(NSNumber *)timestamp errorMessage:(NSString *)errorMessage;

// Fired when WebSocket frame is sent.
// Param requestId: Request identifier.
// Param timestamp: Timestamp.
// Param response: WebSocket response data.
- (void)webSocketFrameSentWithRequestId:(NSString *)requestId timestamp:(NSNumber *)timestamp response:(PDNetworkWebSocketFrame *)response;

// Fired when EventSource message is received.
// Param requestId: Request identifier.
// Param timestamp: Timestamp.
// Param eventName: Message type.
// Param eventId: Message identifier.
// Param data: Message content.
- (void)eventSourceMessageReceivedWithRequestId:(NSString *)requestId timestamp:(NSNumber *)timestamp eventName:(NSString *)eventName eventId:(NSString *)eventId data:(NSString *)data;

@end

@protocol PDNetworkCommandDelegate <PDCommandDelegate>
@optional

/// Enables network tracking, network events will now be delivered to the client.
- (void)domain:(PDNetworkDomain *)domain enableWithCallback:(void (^)(id error))callback;

/// Disables network tracking, prevents network events from being sent to the client.
- (void)domain:(PDNetworkDomain *)domain disableWithCallback:(void (^)(id error))callback;

/// Allows overriding user agent with the given string.
// Param userAgent: User agent to use.
- (void)domain:(PDNetworkDomain *)domain setUserAgentOverrideWithUserAgent:(NSString *)userAgent callback:(void (^)(id error))callback;

/// Specifies whether to always send extra HTTP headers with the requests from this page.
// Param headers: Map with extra HTTP headers.
- (void)domain:(PDNetworkDomain *)domain setExtraHTTPHeadersWithHeaders:(NSDictionary *)headers callback:(void (^)(id error))callback;

/// Returns content served for the given request.
// Param requestId: Identifier of the network request to get content for.
// Callback Param body: Response body.
// Callback Param base64Encoded: True, if content was sent as base64.
- (void)domain:(PDNetworkDomain *)domain getResponseBodyWithRequestId:(NSString *)requestId callback:(void (^)(NSString *body, NSNumber *base64Encoded, id error))callback;

/// This method sends a new XMLHttpRequest which is identical to the original one. The following parameters should be identical: method, url, async, request body, extra headers, withCredentials attribute, user, password.
// Param requestId: Identifier of XHR to replay.
- (void)domain:(PDNetworkDomain *)domain replayXHRWithRequestId:(NSString *)requestId callback:(void (^)(id error))callback;

/// Toggles monitoring of XMLHttpRequest. If <code>true</code>, console will receive messages upon each XHR issued.
// Param enabled: Monitoring enabled state.
- (void)domain:(PDNetworkDomain *)domain setMonitoringXHREnabledWithEnabled:(NSNumber *)enabled callback:(void (^)(id error))callback;

/// Tells whether clearing browser cache is supported.
// Callback Param result: True if browser cache can be cleared.
- (void)domain:(PDNetworkDomain *)domain canClearBrowserCacheWithCallback:(void (^)(NSNumber *result, id error))callback;

/// Clears browser cache.
- (void)domain:(PDNetworkDomain *)domain clearBrowserCacheWithCallback:(void (^)(id error))callback;

/// Tells whether clearing browser cookies is supported.
// Callback Param result: True if browser cookies can be cleared.
- (void)domain:(PDNetworkDomain *)domain canClearBrowserCookiesWithCallback:(void (^)(NSNumber *result, id error))callback;

/// Clears browser cookies.
- (void)domain:(PDNetworkDomain *)domain clearBrowserCookiesWithCallback:(void (^)(id error))callback;

/// Returns all browser cookies. Depending on the backend support, will return detailed cookie information in the <code>cookies</code> field.
// Callback Param cookies: Array of cookie objects.
- (void)domain:(PDNetworkDomain *)domain getCookiesWithCallback:(void (^)(NSArray *cookies, id error))callback;

/// Deletes browser cookie with given name, domain and path.
// Param cookieName: Name of the cookie to remove.
// Param url: URL to match cooke domain and path.
- (void)domain:(PDNetworkDomain *)domain deleteCookieWithCookieName:(NSString *)cookieName url:(NSString *)url callback:(void (^)(id error))callback;

/// Tells whether emulation of network conditions is supported.
// Callback Param result: True if emulation of network conditions is supported.
- (void)domain:(PDNetworkDomain *)domain canEmulateNetworkConditionsWithCallback:(void (^)(NSNumber *result, id error))callback;

/// Activates emulation of network conditions.
// Param offline: True to emulate internet disconnection.
// Param latency: Additional latency (ms).
// Param downloadThroughput: Maximal aggregated download throughput.
// Param uploadThroughput: Maximal aggregated upload throughput.
- (void)domain:(PDNetworkDomain *)domain emulateNetworkConditionsWithOffline:(NSNumber *)offline latency:(NSNumber *)latency downloadThroughput:(NSNumber *)downloadThroughput uploadThroughput:(NSNumber *)uploadThroughput callback:(void (^)(id error))callback;

/// Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
// Param cacheDisabled: Cache disabled state.
- (void)domain:(PDNetworkDomain *)domain setCacheDisabledWithCacheDisabled:(NSNumber *)cacheDisabled callback:(void (^)(id error))callback;

/// For testing.
// Param maxTotalSize: Maximum total buffer size.
// Param maxResourceSize: Maximum per-resource size.
- (void)domain:(PDNetworkDomain *)domain setDataSizeLimitsForTestWithMaxTotalSize:(NSNumber *)maxTotalSize maxResourceSize:(NSNumber *)maxResourceSize callback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDNetworkDomain)

@property (nonatomic, readonly, strong) PDNetworkDomain *networkDomain;

@end
