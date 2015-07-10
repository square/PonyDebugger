//
//  PDAccessibilityTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDAccessibilityTypes.h"

@implementation PDAccessibilityAXPropertySource

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"name",@"name",
                    @"sourceType",@"sourceType",
                    @"value",@"value",
                    @"type",@"type",
                    @"invalid",@"invalid",
                    @"invalidReason",@"invalidReason",
                    nil];
    });

    return mappings;
}

@dynamic name;
@dynamic sourceType;
@dynamic value;
@dynamic type;
@dynamic invalid;
@dynamic invalidReason;
 
@end

@implementation PDAccessibilityAXRelatedNode

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"idref",@"idref",
                    @"backendNodeId",@"backendNodeId",
                    nil];
    });

    return mappings;
}

@dynamic idref;
@dynamic backendNodeId;
 
@end

@implementation PDAccessibilityAXProperty

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

@implementation PDAccessibilityAXValue

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"type",@"type",
                    @"value",@"value",
                    @"relatedNodeValue",@"relatedNodeValue",
                    @"relatedNodeArrayValue",@"relatedNodeArrayValue",
                    @"sources",@"sources",
                    nil];
    });

    return mappings;
}

@dynamic type;
@dynamic value;
@dynamic relatedNodeValue;
@dynamic relatedNodeArrayValue;
@dynamic sources;
 
@end

@implementation PDAccessibilityAXNode

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"nodeId",@"nodeId",
                    @"ignored",@"ignored",
                    @"ignoredReasons",@"ignoredReasons",
                    @"role",@"role",
                    @"name",@"name",
                    @"description",@"objectDescription",
                    @"value",@"value",
                    @"help",@"help",
                    @"properties",@"properties",
                    nil];
    });

    return mappings;
}

@dynamic nodeId;
@dynamic ignored;
@dynamic ignoredReasons;
@dynamic role;
@dynamic name;
@dynamic objectDescription;
@dynamic value;
@dynamic help;
@dynamic properties;
 
@end

