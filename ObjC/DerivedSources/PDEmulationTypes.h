//    
//  PDEmulationTypes.h
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


/// Visible page viewport
@interface PDEmulationViewport : PDObject

/// X scroll offset in CSS pixels.
/// Type: number
@property (nonatomic, strong) NSNumber *scrollX;

/// Y scroll offset in CSS pixels.
/// Type: number
@property (nonatomic, strong) NSNumber *scrollY;

/// Contents width in CSS pixels.
/// Type: number
@property (nonatomic, strong) NSNumber *contentsWidth;

/// Contents height in CSS pixels.
/// Type: number
@property (nonatomic, strong) NSNumber *contentsHeight;

/// Page scale factor.
/// Type: number
@property (nonatomic, strong) NSNumber *pageScaleFactor;

/// Minimum page scale factor.
/// Type: number
@property (nonatomic, strong) NSNumber *minimumPageScaleFactor;

/// Maximum page scale factor.
/// Type: number
@property (nonatomic, strong) NSNumber *maximumPageScaleFactor;

@end


