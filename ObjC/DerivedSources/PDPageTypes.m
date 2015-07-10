//
//  PDPageTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDPageTypes.h"

@implementation PDPageFrame

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"id",@"identifier",
                    @"parentId",@"parentId",
                    @"loaderId",@"loaderId",
                    @"name",@"name",
                    @"url",@"url",
                    @"securityOrigin",@"securityOrigin",
                    @"mimeType",@"mimeType",
                    nil];
    });

    return mappings;
}

@dynamic identifier;
@dynamic parentId;
@dynamic loaderId;
@dynamic name;
@dynamic url;
@dynamic securityOrigin;
@dynamic mimeType;
 
@end

@implementation PDPageFrameResourceTree

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"frame",@"frame",
                    @"childFrames",@"childFrames",
                    @"resources",@"resources",
                    nil];
    });

    return mappings;
}

@dynamic frame;
@dynamic childFrames;
@dynamic resources;
 
@end

@implementation PDPageNavigationEntry

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"id",@"identifier",
                    @"url",@"url",
                    @"title",@"title",
                    nil];
    });

    return mappings;
}

@dynamic identifier;
@dynamic url;
@dynamic title;
 
@end

@implementation PDPageScreencastFrameMetadata

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"offsetTop",@"offsetTop",
                    @"pageScaleFactor",@"pageScaleFactor",
                    @"deviceWidth",@"deviceWidth",
                    @"deviceHeight",@"deviceHeight",
                    @"scrollOffsetX",@"scrollOffsetX",
                    @"scrollOffsetY",@"scrollOffsetY",
                    @"timestamp",@"timestamp",
                    nil];
    });

    return mappings;
}

@dynamic offsetTop;
@dynamic pageScaleFactor;
@dynamic deviceWidth;
@dynamic deviceHeight;
@dynamic scrollOffsetX;
@dynamic scrollOffsetY;
@dynamic timestamp;
 
@end

