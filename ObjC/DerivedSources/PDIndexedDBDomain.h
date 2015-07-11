//
//  PDIndexedDBDomain.h
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

@class PDIndexedDBKeyRange;
@class PDIndexedDBDatabaseWithObjectStores;

@protocol PDIndexedDBCommandDelegate;

@interface PDIndexedDBDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDIndexedDBCommandDelegate, PDCommandDelegate> delegate;

@end

@protocol PDIndexedDBCommandDelegate <PDCommandDelegate>
@optional

/// Enables events from backend.
- (void)domain:(PDIndexedDBDomain *)domain enableWithCallback:(void (^)(id error))callback;

/// Disables events from backend.
- (void)domain:(PDIndexedDBDomain *)domain disableWithCallback:(void (^)(id error))callback;

/// Requests database names for given security origin.
// Param securityOrigin: Security origin.
// Callback Param databaseNames: Database names for origin.
- (void)domain:(PDIndexedDBDomain *)domain requestDatabaseNamesWithSecurityOrigin:(NSString *)securityOrigin callback:(void (^)(NSArray *databaseNames, id error))callback;

/// Requests database with given name in given frame.
// Param securityOrigin: Security origin.
// Param databaseName: Database name.
// Callback Param databaseWithObjectStores: Database with an array of object stores.
- (void)domain:(PDIndexedDBDomain *)domain requestDatabaseWithSecurityOrigin:(NSString *)securityOrigin databaseName:(NSString *)databaseName callback:(void (^)(PDIndexedDBDatabaseWithObjectStores *databaseWithObjectStores, id error))callback;

/// Requests data from object store or index.
// Param securityOrigin: Security origin.
// Param databaseName: Database name.
// Param objectStoreName: Object store name.
// Param indexName: Index name, empty string for object store data requests.
// Param skipCount: Number of records to skip.
// Param pageSize: Number of records to fetch.
// Param keyRange: Key range.
// Callback Param objectStoreDataEntries: Array of object store data entries.
// Callback Param hasMore: If true, there are more entries to fetch in the given range.
- (void)domain:(PDIndexedDBDomain *)domain requestDataWithSecurityOrigin:(NSString *)securityOrigin databaseName:(NSString *)databaseName objectStoreName:(NSString *)objectStoreName indexName:(NSString *)indexName skipCount:(NSNumber *)skipCount pageSize:(NSNumber *)pageSize keyRange:(PDIndexedDBKeyRange *)keyRange callback:(void (^)(NSArray *objectStoreDataEntries, NSNumber *hasMore, id error))callback;

/// Clears all entries from an object store.
// Param securityOrigin: Security origin.
// Param databaseName: Database name.
// Param objectStoreName: Object store name.
- (void)domain:(PDIndexedDBDomain *)domain clearObjectStoreWithSecurityOrigin:(NSString *)securityOrigin databaseName:(NSString *)databaseName objectStoreName:(NSString *)objectStoreName callback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDIndexedDBDomain)

@property (nonatomic, readonly, strong) PDIndexedDBDomain *indexedDBDomain;

@end
