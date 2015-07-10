//
//  PDAnimationTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDAnimationTypes.h"

@implementation PDAnimationAnimation

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"id",@"identifier",
                    @"pausedState",@"pausedState",
                    @"playState",@"playState",
                    @"playbackRate",@"playbackRate",
                    @"startTime",@"startTime",
                    @"currentTime",@"currentTime",
                    @"source",@"source",
                    @"type",@"type",
                    nil];
    });

    return mappings;
}

@dynamic identifier;
@dynamic pausedState;
@dynamic playState;
@dynamic playbackRate;
@dynamic startTime;
@dynamic currentTime;
@dynamic source;
@dynamic type;
 
@end

@implementation PDAnimationAnimationEffect

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"delay",@"delay",
                    @"endDelay",@"endDelay",
                    @"playbackRate",@"playbackRate",
                    @"iterationStart",@"iterationStart",
                    @"iterations",@"iterations",
                    @"duration",@"duration",
                    @"direction",@"direction",
                    @"fill",@"fill",
                    @"name",@"name",
                    @"backendNodeId",@"backendNodeId",
                    @"keyframesRule",@"keyframesRule",
                    @"easing",@"easing",
                    nil];
    });

    return mappings;
}

@dynamic delay;
@dynamic endDelay;
@dynamic playbackRate;
@dynamic iterationStart;
@dynamic iterations;
@dynamic duration;
@dynamic direction;
@dynamic fill;
@dynamic name;
@dynamic backendNodeId;
@dynamic keyframesRule;
@dynamic easing;
 
@end

@implementation PDAnimationKeyframesRule

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"name",@"name",
                    @"keyframes",@"keyframes",
                    nil];
    });

    return mappings;
}

@dynamic name;
@dynamic keyframes;
 
@end

@implementation PDAnimationKeyframeStyle

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"offset",@"offset",
                    @"easing",@"easing",
                    nil];
    });

    return mappings;
}

@dynamic offset;
@dynamic easing;
 
@end

