//
//  PDAnimationDomain.h
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

@class PDAnimationAnimation;

@protocol PDAnimationCommandDelegate;

@interface PDAnimationDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDAnimationCommandDelegate, PDCommandDelegate> delegate;

// Events

// Event for each animation player that has been created.
// Param player: Animation that was created.
// Param resetTimeline: Whether the timeline should be reset.
- (void)animationCreatedWithPlayer:(PDAnimationAnimation *)player resetTimeline:(NSNumber *)resetTimeline;

// Event for Animations in the frontend that have been cancelled.
// Param id: Id of the Animation that was cancelled.
- (void)animationCanceledWithId:(NSString *)identifier;

@end

@protocol PDAnimationCommandDelegate <PDCommandDelegate>
@optional

/// Enables animation domain notifications.
- (void)domain:(PDAnimationDomain *)domain enableWithCallback:(void (^)(id error))callback;

/// Disables animation domain notifications.
- (void)domain:(PDAnimationDomain *)domain disableWithCallback:(void (^)(id error))callback;

/// Gets the playback rate of the document timeline.
// Callback Param playbackRate: Playback rate for animations on page.
- (void)domain:(PDAnimationDomain *)domain getPlaybackRateWithCallback:(void (^)(NSNumber *playbackRate, id error))callback;

/// Sets the playback rate of the document timeline.
// Param playbackRate: Playback rate for animations on page
- (void)domain:(PDAnimationDomain *)domain setPlaybackRateWithPlaybackRate:(NSNumber *)playbackRate callback:(void (^)(id error))callback;

/// Sets the current time of the document timeline.
// Param currentTime: Current time for the page animation timeline
- (void)domain:(PDAnimationDomain *)domain setCurrentTimeWithCurrentTime:(NSNumber *)currentTime callback:(void (^)(id error))callback;

/// Sets the timing of an animation node.
// Param playerId: AnimationPlayer id.
// Param duration: Duration of the animation.
// Param delay: Delay of the animation.
- (void)domain:(PDAnimationDomain *)domain setTimingWithPlayerId:(NSString *)playerId duration:(NSNumber *)duration delay:(NSNumber *)delay callback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDAnimationDomain)

@property (nonatomic, readonly, strong) PDAnimationDomain *animationDomain;

@end
