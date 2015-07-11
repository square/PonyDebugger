//    
//  PDPowerTypes.h
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


/// PowerEvent item
@interface PDPowerPowerEvent : PDObject

/// Power Event Type.
/// Type: string
@property (nonatomic, strong) NSString *type;

/// Power Event Time, in milliseconds.
/// Type: number
@property (nonatomic, strong) NSNumber *timestamp;

/// Power Event Value.
/// Type: number
@property (nonatomic, strong) NSNumber *value;

@end


