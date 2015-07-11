//    
//  PDDOMDebuggerTypes.h
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
@class PDRuntimeRemoteObject;


/// Object event listener.
@interface PDDOMDebuggerEventListener : PDObject

/// <code>EventListener</code>'s type.
/// Type: string
@property (nonatomic, strong) NSString *type;

/// <code>EventListener</code>'s useCapture.
/// Type: boolean
@property (nonatomic, strong) NSNumber *useCapture;

/// Handler code location.
@property (nonatomic, strong) PDDebuggerLocation *location;

/// Event handler function value.
@property (nonatomic, strong) PDRuntimeRemoteObject *handler;

@end


