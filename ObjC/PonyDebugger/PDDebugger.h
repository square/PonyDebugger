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


#pragma mark - Preprocessor

// Remote logging definitions. Use preprocessor hackery to make this work nicely.
#define PDLog(...)                  _PDLog(@"log", ##__VA_ARGS__)
#define PDLogD(...)                 _PDLog(@"debug", ##__VA_ARGS__)
#define PDLogW(...)                 _PDLog(@"warn", ##__VA_ARGS__)
#define PDLogI(...)                 _PDLog(@"info", ##__VA_ARGS__)
#define PDLogE(...)                 _PDLog(@"error", ##__VA_ARGS__)

#define PDLogObjects(...)           _PDLogObjects(@"log", ##__VA_ARGS__)

#define _PDLog(sev, ...)            _PDLogObjectsImpl(sev, @[[NSString stringWithFormat:__VA_ARGS__]]);
#define _PDLogObjects(sev, ...)     _PDLogObjectsImpl(sev, @[__VA_ARGS__]);


#pragma mark - Definitions

@class SRWebSocket;
@class PDDomainController;
@protocol PDPrettyStringPrinting;

extern void _PDLogObjectsImpl(NSString *severity, NSArray *arguments);


#pragma mark - Public Interface

@interface PDDebugger : NSObject

+ (PDDebugger *)defaultInstance;

- (id)domainForName:(NSString *)name;
- (void)sendEventWithName:(NSString *)string parameters:(id)params;

#pragma mark Connect/Disconnect
- (void)autoConnect;
- (void)autoConnectToBonjourServiceNamed:(NSString*)serviceName;
- (void)connectToURL:(NSURL *)url;
- (BOOL)isConnected;
- (void)disconnect;

#pragma mark Network Debugging
- (void)enableNetworkTrafficDebugging;
- (void)forwardAllNetworkTraffic;
- (void)forwardNetworkTrafficFromDelegateClass:(Class)cls;
+ (void)registerPrettyStringPrinter:(id<PDPrettyStringPrinting>)prettyStringPrinter;
+ (void)unregisterPrettyStringPrinter:(id<PDPrettyStringPrinting>)prettyStringPrinter;

#pragma mark Core Data Debugging
- (void)enableCoreDataDebugging;
- (void)addManagedObjectContext:(NSManagedObjectContext *)context;
- (void)addManagedObjectContext:(NSManagedObjectContext *)context withName:(NSString *)name;
- (void)removeManagedObjectContext:(NSManagedObjectContext *)context;

#pragma mark View Hierarchy Debugging
- (void)enableViewHierarchyDebugging;
- (void)setDisplayedViewAttributeKeyPaths:(NSArray *)keyPaths;

#pragma mark Remote Logging
- (void)enableRemoteLogging;
- (void)clearConsole;

@end
