//
//  NSOrderedSet+PDRuntimePropertyDescriptor.m
//  PonyDebugger
//
//  Created by Wen-Hao Lue on 2013-02-03.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "NSOrderedSet+PDRuntimePropertyDescriptor.h"

@implementation NSOrderedSet (PDRuntimePropertyDescriptor)

/**
 * Since this set has order, just grab the object at the index.
 */
- (id)PD_objectAtIndex:(NSUInteger)index;
{
    return [self objectAtIndex:index];
}

@end
