//
//  PDConsoleDomainController.h
//  PonyDebugger
//
//  Created by Matthias Plappert on 1/15/13.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PonyDebugger.h>
#import <PonyDebugger/PDConsoleDomain.h>


@interface PDConsoleDomainController : PDDomainController

+ (instancetype)defaultInstance;

@property (nonatomic, strong) PDConsoleDomain *domain;

- (void)sendMessage:(NSString *)text;
- (void)clearMessages;

@end
