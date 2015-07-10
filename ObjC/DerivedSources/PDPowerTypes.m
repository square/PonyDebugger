//
//  PDPowerTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDPowerTypes.h"

@implementation PDPowerPowerEvent

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"type",@"type",
                    @"timestamp",@"timestamp",
                    @"value",@"value",
                    nil];
    });

    return mappings;
}

@dynamic type;
@dynamic timestamp;
@dynamic value;
 
@end

