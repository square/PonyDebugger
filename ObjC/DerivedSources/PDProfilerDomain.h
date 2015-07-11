//
//  PDProfilerDomain.h
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

@class PDDebuggerLocation;
@class PDProfilerCPUProfile;

@protocol PDProfilerCommandDelegate;

@interface PDProfilerDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDProfilerCommandDelegate, PDCommandDelegate> delegate;

// Events

// Sent when new profile recodring is started using console.profile() call.
// Param location: Location of console.profile().
// Param title: Profile title passed as argument to console.profile().
- (void)consoleProfileStartedWithId:(NSString *)identifier location:(PDDebuggerLocation *)location title:(NSString *)title;
// Param location: Location of console.profileEnd().
// Param title: Profile title passed as argunet to console.profile().
- (void)consoleProfileFinishedWithId:(NSString *)identifier location:(PDDebuggerLocation *)location profile:(PDProfilerCPUProfile *)profile title:(NSString *)title;

@end

@protocol PDProfilerCommandDelegate <PDCommandDelegate>
@optional
- (void)domain:(PDProfilerDomain *)domain enableWithCallback:(void (^)(id error))callback;
- (void)domain:(PDProfilerDomain *)domain disableWithCallback:(void (^)(id error))callback;

/// Changes CPU profiler sampling interval. Must be called before CPU profiles recording started.
// Param interval: New sampling interval in microseconds.
- (void)domain:(PDProfilerDomain *)domain setSamplingIntervalWithInterval:(NSNumber *)interval callback:(void (^)(id error))callback;
- (void)domain:(PDProfilerDomain *)domain startWithCallback:(void (^)(id error))callback;
// Callback Param profile: Recorded profile.
- (void)domain:(PDProfilerDomain *)domain stopWithCallback:(void (^)(PDProfilerCPUProfile *profile, id error))callback;

@end

@interface PDDebugger (PDProfilerDomain)

@property (nonatomic, readonly, strong) PDProfilerDomain *profilerDomain;

@end
