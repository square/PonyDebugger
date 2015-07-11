//    
//  PDDOMStorageTypes.h
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


/// DOM Storage identifier.
@interface PDDOMStorageStorageId : PDObject

/// Security origin for the storage.
/// Type: string
@property (nonatomic, strong) NSString *securityOrigin;

/// Whether the storage is local storage (not session storage).
/// Type: boolean
@property (nonatomic, strong) NSNumber *isLocalStorage;

@end


