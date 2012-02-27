#import "PDApplicationCacheTypes.h"

@implementation PDApplicationCacheApplicationCacheResource

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"url",@"url",
                    @"size",@"size",
                    @"type",@"type",
                    nil];
    });

    return mappings;
}

@dynamic url;
@dynamic size;
@dynamic type;
 
@end

@implementation PDApplicationCacheApplicationCache

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"manifestURL",@"manifestURL",
                    @"size",@"size",
                    @"creationTime",@"creationTime",
                    @"updateTime",@"updateTime",
                    @"resources",@"resources",
                    nil];
    });

    return mappings;
}

@dynamic manifestURL;
@dynamic size;
@dynamic creationTime;
@dynamic updateTime;
@dynamic resources;
 
@end

@implementation PDApplicationCacheFrameWithManifest

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"frameId",@"frameId",
                    @"manifestURL",@"manifestURL",
                    @"status",@"status",
                    nil];
    });

    return mappings;
}

@dynamic frameId;
@dynamic manifestURL;
@dynamic status;
 
@end

