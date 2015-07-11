//
//  PDPowerDomain.h
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


@protocol PDPowerCommandDelegate;

@interface PDPowerDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDPowerCommandDelegate, PDCommandDelegate> delegate;

// Events
// Param value: List of power events.
- (void)dataAvailableWithValue:(NSArray *)value;

@end

@protocol PDPowerCommandDelegate <PDCommandDelegate>
@optional

/// Start power events collection.
- (void)domain:(PDPowerDomain *)domain startWithCallback:(void (^)(id error))callback;

/// Stop power events collection.
- (void)domain:(PDPowerDomain *)domain endWithCallback:(void (^)(id error))callback;

/// Tells whether power profiling is supported.
// Callback Param result: True if power profiling is supported.
- (void)domain:(PDPowerDomain *)domain canProfilePowerWithCallback:(void (^)(NSNumber *result, id error))callback;

/// Describes the accuracy level of the data provider.
- (void)domain:(PDPowerDomain *)domain getAccuracyLevelWithCallback:(void (^)(NSString *result, id error))callback;

@end

@interface PDDebugger (PDPowerDomain)

@property (nonatomic, readonly, strong) PDPowerDomain *powerDomain;

@end
