//    
//  PDConsoleTypes.h
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


@class PDConsoleAsyncStackTrace;


/// Console message.
@interface PDConsoleConsoleMessage : PDObject

/// Message source.
/// Type: string
@property (nonatomic, strong) NSString *source;

/// Message severity.
/// Type: string
@property (nonatomic, strong) NSString *level;

/// Message text.
/// Type: string
@property (nonatomic, strong) NSString *text;

/// Console message type.
/// Type: string
@property (nonatomic, strong) NSString *type;

/// Script ID of the message origin.
/// Type: string
@property (nonatomic, strong) NSString *scriptId;

/// URL of the message origin.
/// Type: string
@property (nonatomic, strong) NSString *url;

/// Line number in the resource that generated this message.
/// Type: integer
@property (nonatomic, strong) NSNumber *line;

/// Column number in the resource that generated this message.
/// Type: integer
@property (nonatomic, strong) NSNumber *column;

/// Repeat count for repeated messages.
/// Type: integer
@property (nonatomic, strong) NSNumber *repeatCount;

/// Message parameters in case of the formatted message.
/// Type: array
@property (nonatomic, strong) NSArray *parameters;

/// JavaScript stack trace for assertions and error messages.
@property (nonatomic, strong) NSArray *stackTrace;

/// Asynchronous JavaScript stack trace that preceded this message, if available.
@property (nonatomic, strong) PDConsoleAsyncStackTrace *asyncStackTrace;

/// Identifier of the network request associated with this message.
@property (nonatomic, strong) NSString *networkRequestId;

/// Timestamp, when this message was fired.
@property (nonatomic, strong) NSNumber *timestamp;

/// Identifier of the context where this message was created
@property (nonatomic, strong) NSNumber *executionContextId;

/// Message id.
/// Type: integer
@property (nonatomic, strong) NSNumber *messageId;

/// Related message id.
/// Type: integer
@property (nonatomic, strong) NSNumber *relatedMessageId;

@end


/// Stack entry for console errors and assertions.
@interface PDConsoleCallFrame : PDObject

/// JavaScript function name.
/// Type: string
@property (nonatomic, strong) NSString *functionName;

/// JavaScript script id.
/// Type: string
@property (nonatomic, strong) NSString *scriptId;

/// JavaScript script name or url.
/// Type: string
@property (nonatomic, strong) NSString *url;

/// JavaScript script line number.
/// Type: integer
@property (nonatomic, strong) NSNumber *lineNumber;

/// JavaScript script column number.
/// Type: integer
@property (nonatomic, strong) NSNumber *columnNumber;

@end


/// Asynchronous JavaScript call stack.
@interface PDConsoleAsyncStackTrace : PDObject

/// Call frames of the stack trace.
/// Type: array
@property (nonatomic, strong) NSArray *callFrames;

/// String label of this stack trace. For async traces this may be a name of the function that initiated the async call.
/// Type: string
@property (nonatomic, strong) NSString *objectDescription;

/// Next asynchronous stack trace, if any.
@property (nonatomic, strong) PDConsoleAsyncStackTrace *asyncStackTrace;

@end


