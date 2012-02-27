#import "PDDatabaseTypes.h"

@implementation PDDatabaseDatabase

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"id",@"identifier",
                    @"domain",@"domain",
                    @"name",@"name",
                    @"version",@"version",
                    nil];
    });

    return mappings;
}

@dynamic identifier;
@dynamic domain;
@dynamic name;
@dynamic version;
 
@end

