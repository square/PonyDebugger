//
//  PDProfilerTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDProfilerTypes.h"

@implementation PDProfilerCPUProfileNode

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"functionName",@"functionName",
                    @"scriptId",@"scriptId",
                    @"url",@"url",
                    @"lineNumber",@"lineNumber",
                    @"columnNumber",@"columnNumber",
                    @"hitCount",@"hitCount",
                    @"callUID",@"callUID",
                    @"children",@"children",
                    @"deoptReason",@"deoptReason",
                    @"id",@"identifier",
                    @"positionTicks",@"positionTicks",
                    nil];
    });

    return mappings;
}

@dynamic functionName;
@dynamic scriptId;
@dynamic url;
@dynamic lineNumber;
@dynamic columnNumber;
@dynamic hitCount;
@dynamic callUID;
@dynamic children;
@dynamic deoptReason;
@dynamic identifier;
@dynamic positionTicks;
 
@end

@implementation PDProfilerCPUProfile

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"head",@"head",
                    @"startTime",@"startTime",
                    @"endTime",@"endTime",
                    @"samples",@"samples",
                    @"timestamps",@"timestamps",
                    nil];
    });

    return mappings;
}

@dynamic head;
@dynamic startTime;
@dynamic endTime;
@dynamic samples;
@dynamic timestamps;
 
@end

@implementation PDProfilerPositionTickInfo

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"line",@"line",
                    @"ticks",@"ticks",
                    nil];
    });

    return mappings;
}

@dynamic line;
@dynamic ticks;
 
@end

