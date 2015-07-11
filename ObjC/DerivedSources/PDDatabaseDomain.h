//
//  PDDatabaseDomain.h
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

@class PDDatabaseDatabase;
@class PDDatabaseError;

@protocol PDDatabaseCommandDelegate;

@interface PDDatabaseDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDDatabaseCommandDelegate, PDCommandDelegate> delegate;

// Events
- (void)addDatabaseWithDatabase:(PDDatabaseDatabase *)database;

@end

@protocol PDDatabaseCommandDelegate <PDCommandDelegate>
@optional

/// Enables database tracking, database events will now be delivered to the client.
- (void)domain:(PDDatabaseDomain *)domain enableWithCallback:(void (^)(id error))callback;

/// Disables database tracking, prevents database events from being sent to the client.
- (void)domain:(PDDatabaseDomain *)domain disableWithCallback:(void (^)(id error))callback;
- (void)domain:(PDDatabaseDomain *)domain getDatabaseTableNamesWithDatabaseId:(NSString *)databaseId callback:(void (^)(NSArray *tableNames, id error))callback;
- (void)domain:(PDDatabaseDomain *)domain executeSQLWithDatabaseId:(NSString *)databaseId query:(NSString *)query callback:(void (^)(NSArray *columnNames, NSArray *values, PDDatabaseError *sqlError, id error))callback;

@end

@interface PDDebugger (PDDatabaseDomain)

@property (nonatomic, readonly, strong) PDDatabaseDomain *databaseDomain;

@end
