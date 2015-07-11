//    
//  PDInputTypes.h
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


@interface PDInputTouchPoint : PDObject

/// State of the touch point.
/// Type: string
@property (nonatomic, strong) NSString *state;

/// X coordinate of the event relative to the main frame's viewport.
/// Type: integer
@property (nonatomic, strong) NSNumber *x;

/// Y coordinate of the event relative to the main frame's viewport. 0 refers to the top of the viewport and Y increases as it proceeds towards the bottom of the viewport.
/// Type: integer
@property (nonatomic, strong) NSNumber *y;

/// X radius of the touch area (default: 1).
/// Type: integer
@property (nonatomic, strong) NSNumber *radiusX;

/// Y radius of the touch area (default: 1).
/// Type: integer
@property (nonatomic, strong) NSNumber *radiusY;

/// Rotation angle (default: 0.0).
/// Type: number
@property (nonatomic, strong) NSNumber *rotationAngle;

/// Force (default: 1.0).
/// Type: number
@property (nonatomic, strong) NSNumber *force;

/// Identifier used to track touch sources between events, must be unique within an event.
/// Type: number
@property (nonatomic, strong) NSNumber *identifier;

@end


