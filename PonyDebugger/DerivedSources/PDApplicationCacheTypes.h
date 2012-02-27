#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


// Detailed application cache resource information.
@interface PDApplicationCacheApplicationCacheResource : PDObject

// Resource url.
// Type: string
@property (nonatomic, retain) NSString *url;

// Resource size.
// Type: integer
@property (nonatomic, retain) NSNumber *size;

// Resource type.
// Type: string
@property (nonatomic, retain) NSString *type;

@end


// Detailed application cache information.
@interface PDApplicationCacheApplicationCache : PDObject

// Manifest URL.
// Type: string
@property (nonatomic, retain) NSString *manifestURL;

// Application cache size.
// Type: number
@property (nonatomic, retain) NSNumber *size;

// Application cache creation time.
// Type: number
@property (nonatomic, retain) NSNumber *creationTime;

// Application cache update time.
// Type: number
@property (nonatomic, retain) NSNumber *updateTime;

// Application cache resources.
// Type: array
@property (nonatomic, retain) NSArray *resources;

@end


// Frame identifier - manifest URL pair.
@interface PDApplicationCacheFrameWithManifest : PDObject

// Frame identifier.
@property (nonatomic, retain) NSString *frameId;

// Manifest URL.
// Type: string
@property (nonatomic, retain) NSString *manifestURL;

// Application cache status.
// Type: integer
@property (nonatomic, retain) NSNumber *status;

@end


