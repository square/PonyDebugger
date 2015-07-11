//    
//  PDDebuggerTypes.h
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


@class PDRuntimeRemoteObject;
@class PDDebugger;
@class PDConsoleAsyncStackTrace;
@class PDConsoleCallFrame;


/// Location in the source code.
@interface PDDebuggerLocation : PDObject

/// Script identifier as reported in the <code>Debugger.scriptParsed</code>.
@property (nonatomic, strong) NSString *scriptId;

/// Line number in the script (0-based).
/// Type: integer
@property (nonatomic, strong) NSNumber *lineNumber;

/// Column number in the script (0-based).
/// Type: integer
@property (nonatomic, strong) NSNumber *columnNumber;

@end


/// Information about the function.
@interface PDDebuggerFunctionDetails : PDObject

/// Location of the function, none for native functions.
@property (nonatomic, strong) PDDebuggerLocation *location;

/// Name of the function.
/// Type: string
@property (nonatomic, strong) NSString *functionName;

/// Whether this is a generator function.
/// Type: boolean
@property (nonatomic, strong) NSNumber *isGenerator;

/// Scope chain for this closure.
/// Type: array
@property (nonatomic, strong) NSArray *scopeChain;

@end


/// Information about the generator object.
@interface PDDebuggerGeneratorObjectDetails : PDObject

/// Generator function.
@property (nonatomic, strong) PDRuntimeRemoteObject *function;

/// Name of the generator function.
/// Type: string
@property (nonatomic, strong) NSString *functionName;

/// Current generator object status.
/// Type: string
@property (nonatomic, strong) NSString *status;

/// If suspended, location where generator function was suspended (e.g. location of the last 'yield'). Otherwise, location of the generator function.
@property (nonatomic, strong) PDDebuggerLocation *location;

@end


/// Collection entry.
@interface PDDebuggerCollectionEntry : PDObject

/// Entry key of a map-like collection, otherwise not provided.
@property (nonatomic, strong) PDRuntimeRemoteObject *key;

/// Entry value.
@property (nonatomic, strong) PDRuntimeRemoteObject *value;

@end


/// JavaScript call frame. Array of call frames form the call stack.
@interface PDDebuggerCallFrame : PDObject

/// Call frame identifier. This identifier is only valid while the virtual machine is paused.
@property (nonatomic, strong) NSString *callFrameId;

/// Name of the JavaScript function called on this call frame.
/// Type: string
@property (nonatomic, strong) NSString *functionName;

/// Location in the source code.
@property (nonatomic, strong) PDDebuggerLocation *functionLocation;

/// Location in the source code.
@property (nonatomic, strong) PDDebuggerLocation *location;

/// Scope chain for this call frame.
/// Type: array
@property (nonatomic, strong) NSArray *scopeChain;

/// <code>this</code> object for this call frame.
@property (nonatomic, strong) PDRuntimeRemoteObject *this;

/// The value being returned, if the function is at return point.
@property (nonatomic, strong) PDRuntimeRemoteObject *returnValue;

@end


/// JavaScript call stack, including async stack traces.
@interface PDDebuggerStackTrace : PDObject

/// Call frames of the stack trace.
/// Type: array
@property (nonatomic, strong) NSArray *callFrames;

/// String label of this stack trace. For async traces this may be a name of the function that initiated the async call.
/// Type: string
@property (nonatomic, strong) NSString *objectDescription;

/// Async stack trace, if any.
@property (nonatomic, strong) PDDebuggerStackTrace *asyncStackTrace;

@end


/// Scope description.
@interface PDDebuggerScope : PDObject

/// Scope type.
/// Type: string
@property (nonatomic, strong) NSString *type;

/// Object representing the scope. For <code>global</code> and <code>with</code> scopes it represents the actual object; for the rest of the scopes, it is artificial transient object enumerating scope variables as its properties.
@property (nonatomic, strong) PDRuntimeRemoteObject *object;

@end


/// Detailed information on exception (or error) that was thrown during script compilation or execution.
@interface PDDebuggerExceptionDetails : PDObject

/// Exception text.
/// Type: string
@property (nonatomic, strong) NSString *text;

/// URL of the message origin.
/// Type: string
@property (nonatomic, strong) NSString *url;

/// Script ID of the message origin.
/// Type: string
@property (nonatomic, strong) NSString *scriptId;

/// Line number in the resource that generated this message.
/// Type: integer
@property (nonatomic, strong) NSNumber *line;

/// Column number in the resource that generated this message.
/// Type: integer
@property (nonatomic, strong) NSNumber *column;

/// JavaScript stack trace for assertions and error messages.
@property (nonatomic, strong) NSArray *stackTrace;

@end


/// Error data for setScriptSource command. compileError is a case type for uncompilable script source error.
@interface PDDebuggerSetScriptSourceError : PDObject

/// Type: object
@property (nonatomic, strong) PDDebugger *compileError;

@end


/// Information about the promise. All fields but id are optional and if present they reflect the new state of the property on the promise with given id.
@interface PDDebuggerPromiseDetails : PDObject

/// Unique id of the promise.
/// Type: integer
@property (nonatomic, strong) NSNumber *identifier;

/// Status of the promise.
/// Type: string
@property (nonatomic, strong) NSString *status;

/// Id of the parent promise.
/// Type: integer
@property (nonatomic, strong) NSNumber *parentId;

/// Top call frame on promise creation.
@property (nonatomic, strong) PDConsoleCallFrame *callFrame;

/// Creation time of the promise.
/// Type: number
@property (nonatomic, strong) NSNumber *creationTime;

/// Settlement time of the promise.
/// Type: number
@property (nonatomic, strong) NSNumber *settlementTime;

/// JavaScript stack trace on promise creation.
@property (nonatomic, strong) NSArray *creationStack;

/// JavaScript asynchronous stack trace on promise creation, if available.
@property (nonatomic, strong) PDConsoleAsyncStackTrace *asyncCreationStack;

/// JavaScript stack trace on promise settlement.
@property (nonatomic, strong) NSArray *settlementStack;

/// JavaScript asynchronous stack trace on promise settlement, if available.
@property (nonatomic, strong) PDConsoleAsyncStackTrace *asyncSettlementStack;

@end


/// Information about the async operation.
@interface PDDebuggerAsyncOperation : PDObject

/// Unique id of the async operation.
/// Type: integer
@property (nonatomic, strong) NSNumber *identifier;

/// String description of the async operation.
/// Type: string
@property (nonatomic, strong) NSString *objectDescription;

/// Stack trace where async operation was scheduled.
@property (nonatomic, strong) NSArray *stackTrace;

/// Asynchronous stack trace where async operation was scheduled, if available.
@property (nonatomic, strong) PDConsoleAsyncStackTrace *asyncStackTrace;

@end


/// Search match for resource.
@interface PDDebuggerSearchMatch : PDObject

/// Line number in resource content.
/// Type: number
@property (nonatomic, strong) NSNumber *lineNumber;

/// Line with match content.
/// Type: string
@property (nonatomic, strong) NSString *lineContent;

@end


