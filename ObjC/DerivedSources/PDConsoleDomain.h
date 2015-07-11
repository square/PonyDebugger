//
//  PDConsoleDomain.h
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

@class PDConsoleConsoleMessage;

@protocol PDConsoleCommandDelegate;

// Console domain defines methods and events for interaction with the JavaScript console. Console collects messages created by means of the <a href='http://getfirebug.com/wiki/index.php/Console_API'>JavaScript Console API</a>. One needs to enable this domain using <code>enable</code> command in order to start receiving the console messages. Browser collects messages issued while console domain is not enabled as well and reports them using <code>messageAdded</code> notification upon enabling.
@interface PDConsoleDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDConsoleCommandDelegate, PDCommandDelegate> delegate;

// Events

// Issued when new console message is added.
// Param message: Console message that has been added.
- (void)messageAddedWithMessage:(PDConsoleConsoleMessage *)message;

// Is not issued. Will be gone in the future versions of the protocol.
// Param count: New repeat count value.
// Param timestamp: Timestamp of most recent message in batch.
- (void)messageRepeatCountUpdatedWithCount:(NSNumber *)count timestamp:(NSNumber *)timestamp;

// Issued when console is cleared. This happens either upon <code>clearMessages</code> command or after page navigation.
- (void)messagesCleared;

@end

@protocol PDConsoleCommandDelegate <PDCommandDelegate>
@optional

/// Enables console domain, sends the messages collected so far to the client by means of the <code>messageAdded</code> notification.
- (void)domain:(PDConsoleDomain *)domain enableWithCallback:(void (^)(id error))callback;

/// Disables console domain, prevents further console messages from being reported to the client.
- (void)domain:(PDConsoleDomain *)domain disableWithCallback:(void (^)(id error))callback;

/// Clears console messages collected in the browser.
- (void)domain:(PDConsoleDomain *)domain clearMessagesWithCallback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDConsoleDomain)

@property (nonatomic, readonly, strong) PDConsoleDomain *consoleDomain;

@end
