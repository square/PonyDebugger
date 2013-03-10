//
//  PDConsoleDomainController.m
//  PonyDebugger
//
//  Created by Wen-Hao Lue on 2013-01-30.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDConsoleDomainController.h"
#import "PDRuntimeDomainController.h"
#import "PDDefinitions.h"
#import "PDRuntimeTypes.h"
#import "PDConsoleDomain.h"
#import "PDConsoleTypes.h"
#import "NSObject+PDRuntimePropertyDescriptor.h"


@interface PDConsoleDomainController () <PDConsoleCommandDelegate>
@end


@implementation PDConsoleDomainController

@dynamic domain;

#pragma mark - Statics

+ (PDConsoleDomainController *)defaultInstance;
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

#pragma mark - PDConsoleCommandDelegate

// Clears console messages collected in the browser.
- (void)domain:(PDConsoleDomain *)domain clearMessagesWithCallback:(void (^)(id error))callback;
{
    callback(nil);
}


#pragma mark - Public Methods

- (void)logWithArguments:(NSArray *)args severity:(NSString *)severity
{
    // Construct the message by creating the runtime objects for each argument provided.
    NSMutableString *text = [[NSMutableString alloc] init];
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    for (NSObject *object in args) {
        PDRuntimeRemoteObject *remoteObject = [NSObject PD_remoteObjectRepresentationForObject:object];
        if ([remoteObject.subtype isEqualToString:@"array"]) {
            remoteObject.subtype = nil;
        }
        [text appendFormat:@"%@ ", object];
        [parameters addObject:remoteObject];
    }

    [text deleteCharactersInRange:NSMakeRange(text.length - 1, 1)];

    PDConsoleConsoleMessage *consoleMessage = [[PDConsoleConsoleMessage alloc] init];
    
    // debug, log, warn, info, error
    if ( [severity isEqualToString:@"debug"] ) consoleMessage.level = @"debug";
    else if ( [severity isEqualToString:@"warn"] ) consoleMessage.level = @"warn";
    else if ( [severity isEqualToString:@"info"] ) consoleMessage.level = @"info";
    else if ( [severity isEqualToString:@"error"] ) consoleMessage.level = @"error";
    else consoleMessage.level = @"log";

    consoleMessage.source = @"console-api";
    consoleMessage.stackTrace = [[NSArray alloc] init];
    consoleMessage.parameters = parameters;
    consoleMessage.repeatCount = [NSNumber numberWithInteger:1];
    consoleMessage.text = text;

    [self.domain messageAddedWithMessage:consoleMessage];
}

- (void)clear;
{
    [self.domain messagesCleared];
}

@end
