//
//  PDLayerTreeTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDLayerTreeTypes.h"

@implementation PDLayerTreeScrollRect

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"rect",@"rect",
                    @"type",@"type",
                    nil];
    });

    return mappings;
}

@dynamic rect;
@dynamic type;
 
@end

@implementation PDLayerTreePictureTile

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"x",@"x",
                    @"y",@"y",
                    @"picture",@"picture",
                    nil];
    });

    return mappings;
}

@dynamic x;
@dynamic y;
@dynamic picture;
 
@end

@implementation PDLayerTreeLayer

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"layerId",@"layerId",
                    @"parentLayerId",@"parentLayerId",
                    @"backendNodeId",@"backendNodeId",
                    @"offsetX",@"offsetX",
                    @"offsetY",@"offsetY",
                    @"width",@"width",
                    @"height",@"height",
                    @"transform",@"transform",
                    @"anchorX",@"anchorX",
                    @"anchorY",@"anchorY",
                    @"anchorZ",@"anchorZ",
                    @"paintCount",@"paintCount",
                    @"drawsContent",@"drawsContent",
                    @"invisible",@"invisible",
                    @"scrollRects",@"scrollRects",
                    nil];
    });

    return mappings;
}

@dynamic layerId;
@dynamic parentLayerId;
@dynamic backendNodeId;
@dynamic offsetX;
@dynamic offsetY;
@dynamic width;
@dynamic height;
@dynamic transform;
@dynamic anchorX;
@dynamic anchorY;
@dynamic anchorZ;
@dynamic paintCount;
@dynamic drawsContent;
@dynamic invisible;
@dynamic scrollRects;
 
@end

