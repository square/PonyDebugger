#import "PDDOMStorageTypes.h"

@implementation PDDOMStorageEntry

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"host",@"host",
                    @"isLocalStorage",@"isLocalStorage",
                    @"id",@"identifier",
                    nil];
    });

    return mappings;
}

@dynamic host;
@dynamic isLocalStorage;
@dynamic identifier;
 
@end

