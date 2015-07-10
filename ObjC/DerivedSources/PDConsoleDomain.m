//
//  PDConsoleDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDConsoleDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDConsoleTypes.h>


@interface PDConsoleDomain ()
//Commands

@end

@implementation PDConsoleDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Console";
}

// Events

// Issued when new console message is added.
- (void)messageAddedWithMessage:(PDConsoleConsoleMessage *)message;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (message != nil) {
        [params setObject:[message PD_JSONObject] forKey:@"message"];
    }
    
    [self.debuggingServer sendEventWithName:@"Console.messageAdded" parameters:params];
}

// Is not issued. Will be gone in the future versions of the protocol.
- (void)messageRepeatCountUpdatedWithCount:(NSNumber *)count timestamp:(NSNumber *)timestamp;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (count != nil) {
        [params setObject:[count PD_JSONObject] forKey:@"count"];
    }
    if (timestamp != nil) {
        [params setObject:[timestamp PD_JSONObject] forKey:@"timestamp"];
    }
    
    [self.debuggingServer sendEventWithName:@"Console.messageRepeatCountUpdated" parameters:params];
}

// Issued when console is cleared. This happens either upon <code>clearMessages</code> command or after page navigation.
- (void)messagesCleared;
{
    [self.debuggingServer sendEventWithName:@"Console.messagesCleared" parameters:nil];
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"enable"] && [self.delegate respondsToSelector:@selector(domain:enableWithCallback:)]) {
        [self.delegate domain:self enableWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"disable"] && [self.delegate respondsToSelector:@selector(domain:disableWithCallback:)]) {
        [self.delegate domain:self disableWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"clearMessages"] && [self.delegate respondsToSelector:@selector(domain:clearMessagesWithCallback:)]) {
        [self.delegate domain:self clearMessagesWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDConsoleDomain)

- (PDConsoleDomain *)consoleDomain;
{
    return [self domainForName:@"Console"];
}

@end
