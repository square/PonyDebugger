#import "PDTimelineTypes.h"

@implementation PDTimelineTimelineEvent

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"type",@"type",
                    @"data",@"data",
                    @"children",@"children",
                    nil];
    });

    return mappings;
}

@dynamic type;
@dynamic data;
@dynamic children;
 
@end

