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

// Enables console domain, sends the messages collected so far to the client by means of the <code>messageAdded</code> notification.
- (void)domain:(PDConsoleDomain *)domain enableWithCallback:(void (^)(id error))callback;
{
}

// Disables console domain, prevents further console messages from being reported to the client.
- (void)domain:(PDConsoleDomain *)domain disableWithCallback:(void (^)(id error))callback;
{
}

// Clears console messages collected in the browser.
- (void)domain:(PDConsoleDomain *)domain clearMessagesWithCallback:(void (^)(id error))callback;
{
}

// Toggles monitoring of XMLHttpRequest. If <code>true</code>, console will receive messages upon each XHR issued.
// Param enabled: Monitoring enabled state.
- (void)domain:(PDConsoleDomain *)domain setMonitoringXHREnabledWithEnabled:(NSNumber *)enabled callback:(void (^)(id error))callback;
{
}


#pragma mark - Public Methods

- (void)logWithArguments:(NSArray *)args;
{
    // Construct the message by creating the runtime objects for each argument provided.
    NSMutableString *text = [[NSMutableString alloc] init];
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    for (NSObject *object in args) {
        PDRuntimeRemoteObject *remoteObject = [object PD_propertyDescriptorValueForObject:object];
        if ([remoteObject.type isEqualToString:@"object"]) {
            remoteObject.objectId = [[PDRuntimeDomainController defaultInstance] registerAndGetKeyForObject:object];
        }

        [text appendFormat:@"%@ ", object];
        [parameters addObject:remoteObject];
    }

    [text deleteCharactersInRange:NSMakeRange(text.length - 1, 1)];

    PDConsoleConsoleMessage *consoleMessage = [[PDConsoleConsoleMessage alloc] init];
    consoleMessage.level = @"log";
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
