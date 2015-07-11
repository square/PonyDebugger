//
//  PDDeviceOrientationDomain.h
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


@protocol PDDeviceOrientationCommandDelegate;

@interface PDDeviceOrientationDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDDeviceOrientationCommandDelegate, PDCommandDelegate> delegate;

@end

@protocol PDDeviceOrientationCommandDelegate <PDCommandDelegate>
@optional

/// Overrides the Device Orientation.
// Param alpha: Mock alpha
// Param beta: Mock beta
// Param gamma: Mock gamma
- (void)domain:(PDDeviceOrientationDomain *)domain setDeviceOrientationOverrideWithAlpha:(NSNumber *)alpha beta:(NSNumber *)beta gamma:(NSNumber *)gamma callback:(void (^)(id error))callback;

/// Clears the overridden Device Orientation.
- (void)domain:(PDDeviceOrientationDomain *)domain clearDeviceOrientationOverrideWithCallback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDDeviceOrientationDomain)

@property (nonatomic, readonly, strong) PDDeviceOrientationDomain *deviceOrientationDomain;

@end
