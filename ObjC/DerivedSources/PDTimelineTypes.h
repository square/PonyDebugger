//    
//  PDTimelineTypes.h
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


/// Timeline record contains information about the recorded activity.
@interface PDTimelineTimelineEvent : PDObject

/// Event type.
/// Type: string
@property (nonatomic, strong) NSString *type;

/// Event data.
/// Type: object
@property (nonatomic, strong) NSDictionary *data;

/// Start time.
/// Type: number
@property (nonatomic, strong) NSNumber *startTime;

/// End time.
/// Type: number
@property (nonatomic, strong) NSNumber *endTime;

/// Nested records.
/// Type: array
@property (nonatomic, strong) NSArray *children;

/// If present, identifies the thread that produced the event.
/// Type: string
@property (nonatomic, strong) NSString *thread;

/// Stack trace.
@property (nonatomic, strong) NSArray *stackTrace;

/// Unique identifier of the frame within the page that the event relates to.
/// Type: string
@property (nonatomic, strong) NSString *frameId;

@end


