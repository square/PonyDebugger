//
//  PDMemoryDomain.h
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


@protocol PDMemoryCommandDelegate;

@interface PDMemoryDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDMemoryCommandDelegate, PDCommandDelegate> delegate;

@end

@protocol PDMemoryCommandDelegate <PDCommandDelegate>
@optional
- (void)domain:(PDMemoryDomain *)domain getDOMCountersWithCallback:(void (^)(NSNumber *documents, NSNumber *nodes, NSNumber *jsEventListeners, id error))callback;

@end

@interface PDDebugger (PDMemoryDomain)

@property (nonatomic, readonly, strong) PDMemoryDomain *memoryDomain;

@end
