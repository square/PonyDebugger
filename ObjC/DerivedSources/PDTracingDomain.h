//
//  PDTracingDomain.h
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


@protocol PDTracingCommandDelegate;

@interface PDTracingDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDTracingCommandDelegate, PDCommandDelegate> delegate;

// Events

// Contains an bucket of collected trace events. When tracing is stopped collected events will be send as a sequence of dataCollected events followed by tracingComplete event.
- (void)dataCollectedWithValue:(NSArray *)value;

// Signals that tracing is stopped and there is no trace buffers pending flush, all data were delivered via dataCollected events.
- (void)tracingComplete;
// Param percentFull: A number in range [0..1] that indicates the used size of event buffer as a fraction of its total size.
// Param eventCount: An approximate number of events in the trace log.
// Param value: A number in range [0..1] that indicates the used size of event buffer as a fraction of its total size.
- (void)bufferUsageWithPercentFull:(NSNumber *)percentFull eventCount:(NSNumber *)eventCount value:(NSNumber *)value;

@end

@protocol PDTracingCommandDelegate <PDCommandDelegate>
@optional

/// Start trace events collection.
// Param categories: Category/tag filter
// Param options: Tracing options
// Param bufferUsageReportingInterval: If set, the agent will issue bufferUsage events at this interval, specified in milliseconds
- (void)domain:(PDTracingDomain *)domain startWithCategories:(NSString *)categories options:(NSString *)options bufferUsageReportingInterval:(NSNumber *)bufferUsageReportingInterval callback:(void (^)(id error))callback;

/// Stop trace events collection.
- (void)domain:(PDTracingDomain *)domain endWithCallback:(void (^)(id error))callback;

/// Gets supported tracing categories.
// Callback Param categories: A list of supported tracing categories.
- (void)domain:(PDTracingDomain *)domain getCategoriesWithCallback:(void (^)(NSArray *categories, id error))callback;

@end

@interface PDDebugger (PDTracingDomain)

@property (nonatomic, readonly, strong) PDTracingDomain *tracingDomain;

@end
