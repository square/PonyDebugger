//
//  PDDebugger.h
//  PonyDebugger
//
//  Created by Mike Lewis on 11/5/11.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class SRWebSocket;
@class PDDomainController;


@interface PDDebugger : NSObject

+ (PDDebugger *)defaultInstance;

- (id)domainForName:(NSString *)name;
- (void)sendEventWithName:(NSString *)string parameters:(id)params;

// Connect/Disconnect
- (void)connectToURL:(NSURL *)url;
- (BOOL)isConnected;
- (void)disconnect;

// Network Debugging
- (void)enableNetworkTrafficDebugging;
- (void)forwardAllNetworkTraffic;
- (void)forwardNetworkTrafficFromDelegateClass:(Class)cls;

// Core Data Debugging
- (void)enableCoreDataDebugging;
- (void)addManagedObjectContext:(NSManagedObjectContext *)context;
- (void)addManagedObjectContext:(NSManagedObjectContext *)context withName:(NSString *)name;
- (void)removeManagedObjectContext:(NSManagedObjectContext *)context;

// View Hierarchy Debugging
- (void)enableViewHierarchyDebugging;
- (void)setDisplayedViewAttributeKeyPaths:(NSArray *)keyPaths;

@end

@interface NSDate (PDDebugger)

+ (NSNumber *)PD_timestamp;

@end

