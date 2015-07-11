//    
//  PDAnimationTypes.h
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


@class PDAnimationAnimationEffect;
@class PDAnimationKeyframesRule;


/// Animation instance.
@interface PDAnimationAnimation : PDObject

/// <code>Animation</code>'s id.
/// Type: string
@property (nonatomic, strong) NSString *identifier;

/// <code>Animation</code>'s internal paused state.
/// Type: boolean
@property (nonatomic, strong) NSNumber *pausedState;

/// <code>Animation</code>'s play state.
/// Type: string
@property (nonatomic, strong) NSString *playState;

/// <code>Animation</code>'s playback rate.
/// Type: number
@property (nonatomic, strong) NSNumber *playbackRate;

/// <code>Animation</code>'s start time.
/// Type: number
@property (nonatomic, strong) NSNumber *startTime;

/// <code>Animation</code>'s current time.
/// Type: number
@property (nonatomic, strong) NSNumber *currentTime;

/// <code>Animation</code>'s source animation node.
@property (nonatomic, strong) PDAnimationAnimationEffect *source;

/// Animation type of <code>Animation</code>.
/// Type: string
@property (nonatomic, strong) NSString *type;

@end


/// AnimationEffect instance
@interface PDAnimationAnimationEffect : PDObject

/// <code>AnimationEffect</code>'s delay.
/// Type: number
@property (nonatomic, strong) NSNumber *delay;

/// <code>AnimationEffect</code>'s end delay.
/// Type: number
@property (nonatomic, strong) NSNumber *endDelay;

/// <code>AnimationEffect</code>'s playbackRate.
/// Type: number
@property (nonatomic, strong) NSNumber *playbackRate;

/// <code>AnimationEffect</code>'s iteration start.
/// Type: number
@property (nonatomic, strong) NSNumber *iterationStart;

/// <code>AnimationEffect</code>'s iterations.
/// Type: number
@property (nonatomic, strong) NSNumber *iterations;

/// <code>AnimationEffect</code>'s iteration duration.
/// Type: number
@property (nonatomic, strong) NSNumber *duration;

/// <code>AnimationEffect</code>'s playback direction.
/// Type: string
@property (nonatomic, strong) NSString *direction;

/// <code>AnimationEffect</code>'s fill mode.
/// Type: string
@property (nonatomic, strong) NSString *fill;

/// <code>AnimationEffect</code>'s name.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// <code>AnimationEffect</code>'s target node.
@property (nonatomic, strong) NSNumber *backendNodeId;

/// <code>AnimationEffect</code>'s keyframes.
@property (nonatomic, strong) PDAnimationKeyframesRule *keyframesRule;

/// <code>AnimationEffect</code>'s timing function.
/// Type: string
@property (nonatomic, strong) NSString *easing;

@end


/// Keyframes Rule
@interface PDAnimationKeyframesRule : PDObject

/// CSS keyframed animation's name.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// List of animation keyframes.
/// Type: array
@property (nonatomic, strong) NSArray *keyframes;

@end


/// Keyframe Style
@interface PDAnimationKeyframeStyle : PDObject

/// Keyframe's time offset.
/// Type: string
@property (nonatomic, strong) NSString *offset;

/// <code>AnimationEffect</code>'s timing function.
/// Type: string
@property (nonatomic, strong) NSString *easing;

@end


