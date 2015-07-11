//
//  PDScreenOrientationDomain.h
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


@protocol PDScreenOrientationCommandDelegate;

@interface PDScreenOrientationDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDScreenOrientationCommandDelegate, PDCommandDelegate> delegate;

@end

@protocol PDScreenOrientationCommandDelegate <PDCommandDelegate>
@optional

/// Overrides the Screen Orientation.
// Param angle: Orientation angle
// Param type: Orientation type
- (void)domain:(PDScreenOrientationDomain *)domain setScreenOrientationOverrideWithAngle:(NSNumber *)angle type:(NSString *)type callback:(void (^)(id error))callback;

/// Clears the overridden Screen Orientation.
- (void)domain:(PDScreenOrientationDomain *)domain clearScreenOrientationOverrideWithCallback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDScreenOrientationDomain)

@property (nonatomic, readonly, strong) PDScreenOrientationDomain *screenOrientationDomain;

@end
