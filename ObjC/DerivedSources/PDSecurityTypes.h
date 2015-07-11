//    
//  PDSecurityTypes.h
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


/// An explanation of an factor contributing to the security state.
@interface PDSecuritySecurityStateExplanation : PDObject

/// Security state representing the severity of the factor being explained.
@property (nonatomic, strong) NSString *securityState;

/// Short phrase describing the type of factor.
/// Type: string
@property (nonatomic, strong) NSString *summary;

/// Full text explanation of the factor.
/// Type: string
@property (nonatomic, strong) NSString *objectDescription;

@end


