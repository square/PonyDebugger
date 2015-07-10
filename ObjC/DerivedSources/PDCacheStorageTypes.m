//
//  PDCacheStorageTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDCacheStorageTypes.h"

@implementation PDCacheStorageDataEntry

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"request",@"request",
                    @"response",@"response",
                    nil];
    });

    return mappings;
}

@dynamic request;
@dynamic response;
 
@end

@implementation PDCacheStorageCache

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"cacheId",@"cacheId",
                    @"securityOrigin",@"securityOrigin",
                    @"cacheName",@"cacheName",
                    nil];
    });

    return mappings;
}

@dynamic cacheId;
@dynamic securityOrigin;
@dynamic cacheName;
 
@end

