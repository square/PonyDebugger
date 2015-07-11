//
//  PDRenderingDomain.h
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


@protocol PDRenderingCommandDelegate;

// This domain allows to control rendering of the page.
@interface PDRenderingDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDRenderingCommandDelegate, PDCommandDelegate> delegate;

@end

@protocol PDRenderingCommandDelegate <PDCommandDelegate>
@optional

/// Requests that backend shows paint rectangles
// Param result: True for showing paint rectangles
- (void)domain:(PDRenderingDomain *)domain setShowPaintRectsWithResult:(NSNumber *)result callback:(void (^)(id error))callback;

/// Requests that backend shows debug borders on layers
// Param show: True for showing debug borders
- (void)domain:(PDRenderingDomain *)domain setShowDebugBordersWithShow:(NSNumber *)show callback:(void (^)(id error))callback;

/// Requests that backend shows the FPS counter
// Param show: True for showing the FPS counter
- (void)domain:(PDRenderingDomain *)domain setShowFPSCounterWithShow:(NSNumber *)show callback:(void (^)(id error))callback;

/// Requests that backend enables continuous painting
// Param enabled: True for enabling cointinuous painting
- (void)domain:(PDRenderingDomain *)domain setContinuousPaintingEnabledWithEnabled:(NSNumber *)enabled callback:(void (^)(id error))callback;

/// Requests that backend shows scroll bottleneck rects
// Param show: True for showing scroll bottleneck rects
- (void)domain:(PDRenderingDomain *)domain setShowScrollBottleneckRectsWithShow:(NSNumber *)show callback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDRenderingDomain)

@property (nonatomic, readonly, strong) PDRenderingDomain *renderingDomain;

@end
