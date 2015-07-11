//
//  PDSecurityDomain.h
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


@protocol PDSecurityCommandDelegate;

// Security
@interface PDSecurityDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDSecurityCommandDelegate, PDCommandDelegate> delegate;

// Events

// The security state of the page changed.
// Param securityState: Security state.
// Param explanations: List of explanations for the security state. If the overall security state is `insecure` or `warning`, at least one corresponding explanation should be included.
- (void)securityStateChangedWithSecurityState:(NSString *)securityState explanations:(NSArray *)explanations;

@end

@protocol PDSecurityCommandDelegate <PDCommandDelegate>
@optional

/// Enables tracking security state changes.
- (void)domain:(PDSecurityDomain *)domain enableWithCallback:(void (^)(id error))callback;

/// Disables tracking security state changes.
- (void)domain:(PDSecurityDomain *)domain disableWithCallback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDSecurityDomain)

@property (nonatomic, readonly, strong) PDSecurityDomain *securityDomain;

@end
