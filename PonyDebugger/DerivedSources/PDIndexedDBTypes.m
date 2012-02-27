#import "PDIndexedDBTypes.h"

@implementation PDIndexedDBSecurityOriginWithDatabaseNames

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"securityOrigin",@"securityOrigin",
                    @"databaseNames",@"databaseNames",
                    nil];
    });

    return mappings;
}

@dynamic securityOrigin;
@dynamic databaseNames;
 
@end

@implementation PDIndexedDBDatabaseWithObjectStores

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"name",@"name",
                    @"version",@"version",
                    @"objectStores",@"objectStores",
                    nil];
    });

    return mappings;
}

@dynamic name;
@dynamic version;
@dynamic objectStores;
 
@end

@implementation PDIndexedDBObjectStore

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"name",@"name",
                    @"keyPath",@"keyPath",
                    @"indexes",@"indexes",
                    nil];
    });

    return mappings;
}

@dynamic name;
@dynamic keyPath;
@dynamic indexes;
 
@end

@implementation PDIndexedDBObjectStoreIndex

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"name",@"name",
                    @"keyPath",@"keyPath",
                    @"unique",@"unique",
                    @"multiEntry",@"multiEntry",
                    nil];
    });

    return mappings;
}

@dynamic name;
@dynamic keyPath;
@dynamic unique;
@dynamic multiEntry;
 
@end

@implementation PDIndexedDBKey

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"type",@"type",
                    @"number",@"number",
                    @"string",@"string",
                    @"date",@"date",
                    @"array",@"array",
                    nil];
    });

    return mappings;
}

@dynamic type;
@dynamic number;
@dynamic string;
@dynamic date;
@dynamic array;
 
@end

@implementation PDIndexedDBKeyRange

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"lower",@"lower",
                    @"upper",@"upper",
                    @"lowerOpen",@"lowerOpen",
                    @"upperOpen",@"upperOpen",
                    nil];
    });

    return mappings;
}

@dynamic lower;
@dynamic upper;
@dynamic lowerOpen;
@dynamic upperOpen;
 
@end

@implementation PDIndexedDBDataEntry

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"key",@"key",
                    @"primaryKey",@"primaryKey",
                    @"value",@"value",
                    nil];
    });

    return mappings;
}

@dynamic key;
@dynamic primaryKey;
@dynamic value;
 
@end

