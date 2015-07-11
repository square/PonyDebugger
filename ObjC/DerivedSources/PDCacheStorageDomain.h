//
//  PDCacheStorageDomain.h
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


@protocol PDCacheStorageCommandDelegate;

@interface PDCacheStorageDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDCacheStorageCommandDelegate, PDCommandDelegate> delegate;

@end

@protocol PDCacheStorageCommandDelegate <PDCommandDelegate>
@optional

/// Requests cache names.
// Param securityOrigin: Security origin.
// Callback Param caches: Caches for the security origin.
- (void)domain:(PDCacheStorageDomain *)domain requestCacheNamesWithSecurityOrigin:(NSString *)securityOrigin callback:(void (^)(NSArray *caches, id error))callback;

/// Requests data from cache.
// Param cacheId: ID of cache to get entries from.
// Param skipCount: Number of records to skip.
// Param pageSize: Number of records to fetch.
// Callback Param cacheDataEntries: Array of object store data entries.
// Callback Param hasMore: If true, there are more entries to fetch in the given range.
- (void)domain:(PDCacheStorageDomain *)domain requestEntriesWithCacheId:(NSString *)cacheId skipCount:(NSNumber *)skipCount pageSize:(NSNumber *)pageSize callback:(void (^)(NSArray *cacheDataEntries, NSNumber *hasMore, id error))callback;

/// Deletes a cache.
// Param cacheId: Id of cache for deletion.
- (void)domain:(PDCacheStorageDomain *)domain deleteCacheWithCacheId:(NSString *)cacheId callback:(void (^)(id error))callback;

/// Deletes a cache entry.
// Param cacheId: Id of cache where the entry will be deleted.
// Param request: URL spec of the request.
- (void)domain:(PDCacheStorageDomain *)domain deleteEntryWithCacheId:(NSString *)cacheId request:(NSString *)request callback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDCacheStorageDomain)

@property (nonatomic, readonly, strong) PDCacheStorageDomain *cacheStorageDomain;

@end
