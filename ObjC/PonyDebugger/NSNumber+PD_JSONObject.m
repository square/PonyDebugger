//
//  NSNumber+PD_JSONObject.m
//  PonyDebugger
//
//  Created by Brian King on 1/2/14.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "NSNumber+PD_JSONObject.h"

@implementation NSNumber (PD_JSONObject)

- (id)PD_JSONObject;
{
    if ([self isEqualToNumber:[NSDecimalNumber notANumber]]) {
        return @"NaN";
    } else if ([self compare:[NSDecimalNumber maximumDecimalNumber]] == NSOrderedDescending) {
        return @"Infinity";
    } else if ([self compare:[NSDecimalNumber minimumDecimalNumber]] == NSOrderedAscending) {
        return @"-Infinity";
    } else {
        return self;
    }
}

@end
