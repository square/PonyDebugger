//
//  PDDOMStorageTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDDOMStorageTypes.h"

@implementation PDDOMStorageStorageId

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"securityOrigin",@"securityOrigin",
                    @"isLocalStorage",@"isLocalStorage",
                    nil];
    });

    return mappings;
}

@dynamic securityOrigin;
@dynamic isLocalStorage;
 
@end

