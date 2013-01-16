//
//  PDConsoleDomainController.m
//  PonyDebugger
//
//  Created by Matthias Plappert on 1/15/13.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDConsoleDomainController.h"
#import "PDConsoleTypes.h"


@implementation PDConsoleDomainController

#pragma mark - Statics

+ (instancetype)defaultInstance;
{
    static PDConsoleDomainController *defaultInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultInstance = [[PDConsoleDomainController alloc] init];
    });
    
    return defaultInstance;
}

+ (Class)domainClass;
{
    return [PDConsoleDomain class];
}

#pragma mark - Actions

- (void)sendMessage:(NSString *)text;
{
    PDConsoleConsoleMessage *message = [[PDConsoleConsoleMessage alloc] init];
    message.text = text;
    message.type = @"log";
    
    [self.domain messageAddedWithMessage:message];
}

- (void)clearMessages;
{
    [self.domain messagesCleared];
}

@end
