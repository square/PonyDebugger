//    
//  PDDatabaseTypes.h
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


/// Database object.
@interface PDDatabaseDatabase : PDObject

/// Database ID.
@property (nonatomic, strong) NSString *identifier;

/// Database domain.
/// Type: string
@property (nonatomic, strong) NSString *domain;

/// Database name.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// Database version.
/// Type: string
@property (nonatomic, strong) NSString *version;

@end


/// Database error.
@interface PDDatabaseError : PDObject

/// Error message.
/// Type: string
@property (nonatomic, strong) NSString *message;

/// Error code.
/// Type: integer
@property (nonatomic, strong) NSNumber *code;

@end


