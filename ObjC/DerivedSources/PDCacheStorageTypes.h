//    
//  PDCacheStorageTypes.h
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//
    
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


/// Data entry.
@interface PDCacheStorageDataEntry : PDObject

/// Request url spec.
/// Type: string
@property (nonatomic, strong) NSString *request;

/// Response stataus text.
/// Type: string
@property (nonatomic, strong) NSString *response;

@end


/// Cache identifier.
@interface PDCacheStorageCache : PDObject

/// An opaque unique id of the cache.
@property (nonatomic, strong) NSString *cacheId;

/// Security origin of the cache.
/// Type: string
@property (nonatomic, strong) NSString *securityOrigin;

/// The name of the cache.
/// Type: string
@property (nonatomic, strong) NSString *cacheName;

@end


