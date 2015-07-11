//    
//  PDProfilerTypes.h
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


/// CPU Profile node. Holds callsite information, execution statistics and child nodes.
@interface PDProfilerCPUProfileNode : PDObject

/// Function name.
/// Type: string
@property (nonatomic, strong) NSString *functionName;

/// Script identifier.
@property (nonatomic, strong) NSString *scriptId;

/// URL.
/// Type: string
@property (nonatomic, strong) NSString *url;

/// 1-based line number of the function start position.
/// Type: integer
@property (nonatomic, strong) NSNumber *lineNumber;

/// 1-based column number of the function start position.
/// Type: integer
@property (nonatomic, strong) NSNumber *columnNumber;

/// Number of samples where this node was on top of the call stack.
/// Type: integer
@property (nonatomic, strong) NSNumber *hitCount;

/// Call UID.
/// Type: number
@property (nonatomic, strong) NSNumber *callUID;

/// Child nodes.
/// Type: array
@property (nonatomic, strong) NSArray *children;

/// The reason of being not optimized. The function may be deoptimized or marked as don't optimize.
/// Type: string
@property (nonatomic, strong) NSString *deoptReason;

/// Unique id of the node.
/// Type: integer
@property (nonatomic, strong) NSNumber *identifier;

/// An array of source position ticks.
/// Type: array
@property (nonatomic, strong) NSArray *positionTicks;

@end


/// Profile.
@interface PDProfilerCPUProfile : PDObject

@property (nonatomic, strong) PDProfilerCPUProfileNode *head;

/// Profiling start time in seconds.
/// Type: number
@property (nonatomic, strong) NSNumber *startTime;

/// Profiling end time in seconds.
/// Type: number
@property (nonatomic, strong) NSNumber *endTime;

/// Ids of samples top nodes.
/// Type: array
@property (nonatomic, strong) NSArray *samples;

/// Timestamps of the samples in microseconds.
/// Type: array
@property (nonatomic, strong) NSArray *timestamps;

@end


/// Specifies a number of samples attributed to a certain source position.
@interface PDProfilerPositionTickInfo : PDObject

/// Source line number (1-based).
/// Type: integer
@property (nonatomic, strong) NSNumber *line;

/// Number of samples attributed to the source line.
/// Type: integer
@property (nonatomic, strong) NSNumber *ticks;

@end


