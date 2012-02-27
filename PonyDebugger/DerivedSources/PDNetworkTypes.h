#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


// Timing information for the request.
@interface PDNetworkResourceTiming : PDObject

// Timing's requestTime is a baseline in seconds, while the other numbers are ticks in milliseconds relatively to this requestTime.
// Type: number
@property (nonatomic, retain) NSNumber *requestTime;

// Started resolving proxy.
// Type: number
@property (nonatomic, retain) NSNumber *proxyStart;

// Finished resolving proxy.
// Type: number
@property (nonatomic, retain) NSNumber *proxyEnd;

// Started DNS address resolve.
// Type: number
@property (nonatomic, retain) NSNumber *dnsStart;

// Finished DNS address resolve.
// Type: number
@property (nonatomic, retain) NSNumber *dnsEnd;

// Started connecting to the remote host.
// Type: number
@property (nonatomic, retain) NSNumber *connectStart;

// Connected to the remote host.
// Type: number
@property (nonatomic, retain) NSNumber *connectEnd;

// Started SSL handshake.
// Type: number
@property (nonatomic, retain) NSNumber *sslStart;

// Finished SSL handshake.
// Type: number
@property (nonatomic, retain) NSNumber *sslEnd;

// Started sending request.
// Type: number
@property (nonatomic, retain) NSNumber *sendStart;

// Finished sending request.
// Type: number
@property (nonatomic, retain) NSNumber *sendEnd;

// Finished receiving response headers.
// Type: number
@property (nonatomic, retain) NSNumber *receiveHeadersEnd;

@end


// HTTP request data.
@interface PDNetworkRequest : PDObject

// Request URL.
// Type: string
@property (nonatomic, retain) NSString *url;

// HTTP request method.
// Type: string
@property (nonatomic, retain) NSString *method;

// HTTP request headers.
@property (nonatomic, retain) NSDictionary *headers;

// HTTP POST request data.
// Type: string
@property (nonatomic, retain) NSString *postData;

@end


// HTTP response data.
@interface PDNetworkResponse : PDObject

// Response URL.
// Type: string
@property (nonatomic, retain) NSString *url;

// HTTP response status code.
// Type: number
@property (nonatomic, retain) NSNumber *status;

// HTTP response status text.
// Type: string
@property (nonatomic, retain) NSString *statusText;

// HTTP response headers.
@property (nonatomic, retain) NSDictionary *headers;

// HTTP response headers text.
// Type: string
@property (nonatomic, retain) NSString *headersText;

// Resource mimeType as determined by the browser.
// Type: string
@property (nonatomic, retain) NSString *mimeType;

// Refined HTTP request headers that were actually transmitted over the network.
@property (nonatomic, retain) NSDictionary *requestHeaders;

// HTTP request headers text.
// Type: string
@property (nonatomic, retain) NSString *requestHeadersText;

// Specifies whether physical connection was actually reused for this request.
// Type: boolean
@property (nonatomic, retain) NSNumber *connectionReused;

// Physical connection id that was actually used for this request.
// Type: number
@property (nonatomic, retain) NSNumber *connectionId;

// Specifies that the request was served from the disk cache.
// Type: boolean
@property (nonatomic, retain) NSNumber *fromDiskCache;

// Timing information for the given request.
@property (nonatomic, retain) PDNetworkResourceTiming *timing;

@end


// WebSocket request data.
@interface PDNetworkWebSocketRequest : PDObject

// HTTP response status text.
// Type: string
@property (nonatomic, retain) NSString *requestKey3;

// HTTP response headers.
@property (nonatomic, retain) NSDictionary *headers;

@end


// WebSocket response data.
@interface PDNetworkWebSocketResponse : PDObject

// HTTP response status code.
// Type: number
@property (nonatomic, retain) NSNumber *status;

// HTTP response status text.
// Type: string
@property (nonatomic, retain) NSString *statusText;

// HTTP response headers.
@property (nonatomic, retain) NSDictionary *headers;

// Challenge response.
// Type: string
@property (nonatomic, retain) NSString *challengeResponse;

@end


// Information about the cached resource.
@interface PDNetworkCachedResource : PDObject

// Resource URL.
// Type: string
@property (nonatomic, retain) NSString *url;

// Type of this resource.
@property (nonatomic, retain) NSString *type;

// Cached response data.
@property (nonatomic, retain) PDNetworkResponse *response;

// Cached response body size.
// Type: number
@property (nonatomic, retain) NSNumber *bodySize;

@end


// Information about the request initiator.
@interface PDNetworkInitiator : PDObject

// Type of this initiator.
// Type: string
@property (nonatomic, retain) NSString *type;

// Initiator JavaScript stack trace, set for Script only.
@property (nonatomic, retain) NSArray *stackTrace;

// Initiator URL, set for Parser type only.
// Type: string
@property (nonatomic, retain) NSString *url;

// Initiator line number, set for Parser type only.
// Type: number
@property (nonatomic, retain) NSNumber *lineNumber;

@end


