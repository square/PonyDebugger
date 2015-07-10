//
//  PDEmulationTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDEmulationTypes.h"

@implementation PDEmulationViewport

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"scrollX",@"scrollX",
                    @"scrollY",@"scrollY",
                    @"contentsWidth",@"contentsWidth",
                    @"contentsHeight",@"contentsHeight",
                    @"pageScaleFactor",@"pageScaleFactor",
                    @"minimumPageScaleFactor",@"minimumPageScaleFactor",
                    @"maximumPageScaleFactor",@"maximumPageScaleFactor",
                    nil];
    });

    return mappings;
}

@dynamic scrollX;
@dynamic scrollY;
@dynamic contentsWidth;
@dynamic contentsHeight;
@dynamic pageScaleFactor;
@dynamic minimumPageScaleFactor;
@dynamic maximumPageScaleFactor;
 
@end

