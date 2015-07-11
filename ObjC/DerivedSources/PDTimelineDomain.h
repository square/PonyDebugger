//
//  PDTimelineDomain.h
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

@class PDTimelineTimelineEvent;

@protocol PDTimelineCommandDelegate;

// Timeline domain is deprecated. Please use Tracing instead.
@interface PDTimelineDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDTimelineCommandDelegate, PDCommandDelegate> delegate;

// Events

// Deprecated.
// Param record: Timeline event record data.
- (void)eventRecordedWithRecord:(PDTimelineTimelineEvent *)record;

@end

@protocol PDTimelineCommandDelegate <PDCommandDelegate>
@optional

/// Deprecated.
- (void)domain:(PDTimelineDomain *)domain enableWithCallback:(void (^)(id error))callback;

/// Deprecated.
- (void)domain:(PDTimelineDomain *)domain disableWithCallback:(void (^)(id error))callback;

/// Deprecated.
// Param maxCallStackDepth: Samples JavaScript stack traces up to <code>maxCallStackDepth</code>, defaults to 5.
// Param bufferEvents: Whether instrumentation events should be buffered and returned upon <code>stop</code> call.
// Param liveEvents: Coma separated event types to issue although bufferEvents is set.
// Param includeCounters: Whether counters data should be included into timeline events.
// Param includeGPUEvents: Whether events from GPU process should be collected.
- (void)domain:(PDTimelineDomain *)domain startWithMaxCallStackDepth:(NSNumber *)maxCallStackDepth bufferEvents:(NSNumber *)bufferEvents liveEvents:(NSString *)liveEvents includeCounters:(NSNumber *)includeCounters includeGPUEvents:(NSNumber *)includeGPUEvents callback:(void (^)(id error))callback;

/// Deprecated.
- (void)domain:(PDTimelineDomain *)domain stopWithCallback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDTimelineDomain)

@property (nonatomic, readonly, strong) PDTimelineDomain *timelineDomain;

@end
