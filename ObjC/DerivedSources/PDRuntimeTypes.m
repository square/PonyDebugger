//
//  PDRuntimeTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

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
                    @"className",@"classNameString",
                    @"value",@"value",
                    @"description",@"objectDescription",
                    @"objectId",@"objectId",
                    @"preview",@"preview",
                    @"customPreview",@"customPreview",
                    nil];
    });

    return mappings;
}

@dynamic type;
@dynamic subtype;
@dynamic classNameString;
@dynamic value;
@dynamic objectDescription;
@dynamic objectId;
@dynamic preview;
@dynamic customPreview;
 
@end

@implementation PDRuntimeCustomPreview

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"header",@"header",
                    @"hasBody",@"hasBody",
                    @"formatterObjectId",@"formatterObjectId",
                    @"configObjectId",@"configObjectId",
                    nil];
    });

    return mappings;
}

@dynamic header;
@dynamic hasBody;
@dynamic formatterObjectId;
@dynamic configObjectId;
 
@end

@implementation PDRuntimeObjectPreview

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"type",@"type",
                    @"subtype",@"subtype",
                    @"description",@"objectDescription",
                    @"lossless",@"lossless",
                    @"overflow",@"overflow",
                    @"properties",@"properties",
                    @"entries",@"entries",
                    nil];
    });

    return mappings;
}

@dynamic type;
@dynamic subtype;
@dynamic objectDescription;
@dynamic lossless;
@dynamic overflow;
@dynamic properties;
@dynamic entries;
 
@end

@implementation PDRuntimePropertyPreview

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"name",@"name",
                    @"type",@"type",
                    @"value",@"value",
                    @"valuePreview",@"valuePreview",
                    @"subtype",@"subtype",
                    nil];
    });

    return mappings;
}

@dynamic name;
@dynamic type;
@dynamic value;
@dynamic valuePreview;
@dynamic subtype;
 
@end

@implementation PDRuntimeEntryPreview

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"key",@"key",
                    @"value",@"value",
                    nil];
    });

    return mappings;
}

@dynamic key;
@dynamic value;
 
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
                    @"isOwn",@"isOwn",
                    @"symbol",@"symbol",
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
@dynamic isOwn;
@dynamic symbol;
 
@end

@implementation PDRuntimeInternalPropertyDescriptor

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"name",@"name",
                    @"value",@"value",
                    nil];
    });

    return mappings;
}

@dynamic name;
@dynamic value;
 
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
                    @"type",@"type",
                    nil];
    });

    return mappings;
}

@dynamic value;
@dynamic objectId;
@dynamic type;
 
@end

@implementation PDRuntimeExecutionContextDescription

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"id",@"identifier",
                    @"type",@"type",
                    @"origin",@"origin",
                    @"name",@"name",
                    @"frameId",@"frameId",
                    nil];
    });

    return mappings;
}

@dynamic identifier;
@dynamic type;
@dynamic origin;
@dynamic name;
@dynamic frameId;
 
@end

