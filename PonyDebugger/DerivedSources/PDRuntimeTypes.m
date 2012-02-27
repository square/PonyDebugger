#import "PDRuntimeTypes.h"

@implementation PDRuntimeRemoteObject

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"type",@"type",
                    @"subtype",@"subtype",
                    @"className",@"className",
                    @"value",@"value",
                    @"description",@"objectDescription",
                    @"objectId",@"objectId",
                    nil];
    });

    return mappings;
}

@dynamic type;
@dynamic subtype;
@dynamic className;
@dynamic value;
@dynamic objectDescription;
@dynamic objectId;
 
@end

@implementation PDRuntimePropertyDescriptor

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"name",@"name",
                    @"value",@"value",
                    @"writable",@"writable",
                    @"get",@"get",
                    @"set",@"set",
                    @"configurable",@"configurable",
                    @"enumerable",@"enumerable",
                    @"wasThrown",@"wasThrown",
                    nil];
    });

    return mappings;
}

@dynamic name;
@dynamic value;
@dynamic writable;
@dynamic get;
@dynamic set;
@dynamic configurable;
@dynamic enumerable;
@dynamic wasThrown;
 
@end

@implementation PDRuntimeCallArgument

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"value",@"value",
                    @"objectId",@"objectId",
                    nil];
    });

    return mappings;
}

@dynamic value;
@dynamic objectId;
 
@end

