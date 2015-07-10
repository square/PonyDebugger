//
//  PDInputTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDInputTypes.h"

@implementation PDInputTouchPoint

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"state",@"state",
                    @"x",@"x",
                    @"y",@"y",
                    @"radiusX",@"radiusX",
                    @"radiusY",@"radiusY",
                    @"rotationAngle",@"rotationAngle",
                    @"force",@"force",
                    @"id",@"identifier",
                    nil];
    });

    return mappings;
}

@dynamic state;
@dynamic x;
@dynamic y;
@dynamic radiusX;
@dynamic radiusY;
@dynamic rotationAngle;
@dynamic force;
@dynamic identifier;
 
@end

