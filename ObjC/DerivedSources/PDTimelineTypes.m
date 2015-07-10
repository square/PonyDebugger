//
//  PDTimelineTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDTimelineTypes.h"

@implementation PDTimelineTimelineEvent

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"type",@"type",
                    @"data",@"data",
                    @"startTime",@"startTime",
                    @"endTime",@"endTime",
                    @"children",@"children",
                    @"thread",@"thread",
                    @"stackTrace",@"stackTrace",
                    @"frameId",@"frameId",
                    nil];
    });

    return mappings;
}

@dynamic type;
@dynamic data;
@dynamic startTime;
@dynamic endTime;
@dynamic children;
@dynamic thread;
@dynamic stackTrace;
@dynamic frameId;
 
@end

