//
//  PDRuntimeDomain.h
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

@class PDRuntimeExecutionContextDescription;
@class PDRuntimeRemoteObject;
@class PDDebuggerExceptionDetails;

@protocol PDRuntimeCommandDelegate;

// Runtime domain exposes JavaScript runtime by means of remote evaluation and mirror objects. Evaluation results are returned as mirror object that expose object type, string representation and unique identifier that can be used for further object reference. Original objects are maintained in memory unless they are either explicitly released or are released along with the other objects in their object group.
@interface PDRuntimeDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDRuntimeCommandDelegate, PDCommandDelegate> delegate;

// Events

// Issued when new execution context is created.
// Param context: A newly created execution contex.
- (void)executionContextCreatedWithContext:(PDRuntimeExecutionContextDescription *)context;

// Issued when execution context is destroyed.
// Param executionContextId: Id of the destroyed context
- (void)executionContextDestroyedWithExecutionContextId:(NSNumber *)executionContextId;

// Issued when all executionContexts were cleared in browser
- (void)executionContextsCleared;

@end

@protocol PDRuntimeCommandDelegate <PDCommandDelegate>
@optional

/// Evaluates expression on global object.
// Param expression: Expression to evaluate.
// Param objectGroup: Symbolic group name that can be used to release multiple objects.
// Param includeCommandLineAPI: Determines whether Command Line API should be available during the evaluation.
// Param doNotPauseOnExceptionsAndMuteConsole: Specifies whether evaluation should stop on exceptions and mute console. Overrides setPauseOnException state.
// Param contextId: Specifies in which isolated context to perform evaluation. Each content script lives in an isolated context and this parameter may be used to specify one of those contexts. If the parameter is omitted or 0 the evaluation will be performed in the context of the inspected page.
// Param returnByValue: Whether the result is expected to be a JSON object that should be sent by value.
// Param generatePreview: Whether preview should be generated for the result.
// Callback Param result: Evaluation result.
// Callback Param wasThrown: True if the result was thrown during the evaluation.
// Callback Param exceptionDetails: Exception details.
- (void)domain:(PDRuntimeDomain *)domain evaluateWithExpression:(NSString *)expression objectGroup:(NSString *)objectGroup includeCommandLineAPI:(NSNumber *)includeCommandLineAPI doNotPauseOnExceptionsAndMuteConsole:(NSNumber *)doNotPauseOnExceptionsAndMuteConsole contextId:(NSNumber *)contextId returnByValue:(NSNumber *)returnByValue generatePreview:(NSNumber *)generatePreview callback:(void (^)(PDRuntimeRemoteObject *result, NSNumber *wasThrown, PDDebuggerExceptionDetails *exceptionDetails, id error))callback;

/// Calls function with given declaration on the given object. Object group of the result is inherited from the target object.
// Param objectId: Identifier of the object to call function on.
// Param functionDeclaration: Declaration of the function to call.
// Param arguments: Call arguments. All call arguments must belong to the same JavaScript world as the target object.
// Param doNotPauseOnExceptionsAndMuteConsole: Specifies whether function call should stop on exceptions and mute console. Overrides setPauseOnException state.
// Param returnByValue: Whether the result is expected to be a JSON object which should be sent by value.
// Param generatePreview: Whether preview should be generated for the result.
// Callback Param result: Call result.
// Callback Param wasThrown: True if the result was thrown during the evaluation.
- (void)domain:(PDRuntimeDomain *)domain callFunctionOnWithObjectId:(NSString *)objectId functionDeclaration:(NSString *)functionDeclaration arguments:(NSArray *)arguments doNotPauseOnExceptionsAndMuteConsole:(NSNumber *)doNotPauseOnExceptionsAndMuteConsole returnByValue:(NSNumber *)returnByValue generatePreview:(NSNumber *)generatePreview callback:(void (^)(PDRuntimeRemoteObject *result, NSNumber *wasThrown, id error))callback;

/// Returns properties of a given object. Object group of the result is inherited from the target object.
// Param objectId: Identifier of the object to return properties for.
// Param ownProperties: If true, returns properties belonging only to the element itself, not to its prototype chain.
// Param accessorPropertiesOnly: If true, returns accessor properties (with getter/setter) only; internal properties are not returned either.
// Param generatePreview: Whether preview should be generated for the results.
// Callback Param result: Object properties.
// Callback Param internalProperties: Internal object properties (only of the element itself).
// Callback Param exceptionDetails: Exception details.
- (void)domain:(PDRuntimeDomain *)domain getPropertiesWithObjectId:(NSString *)objectId ownProperties:(NSNumber *)ownProperties accessorPropertiesOnly:(NSNumber *)accessorPropertiesOnly generatePreview:(NSNumber *)generatePreview callback:(void (^)(NSArray *result, NSArray *internalProperties, PDDebuggerExceptionDetails *exceptionDetails, id error))callback;

/// Releases remote object with given id.
// Param objectId: Identifier of the object to release.
- (void)domain:(PDRuntimeDomain *)domain releaseObjectWithObjectId:(NSString *)objectId callback:(void (^)(id error))callback;

/// Releases all remote objects that belong to a given group.
// Param objectGroup: Symbolic object group name.
- (void)domain:(PDRuntimeDomain *)domain releaseObjectGroupWithObjectGroup:(NSString *)objectGroup callback:(void (^)(id error))callback;

/// Tells inspected instance(worker or page) that it can run in case it was started paused.
- (void)domain:(PDRuntimeDomain *)domain runWithCallback:(void (^)(id error))callback;

/// Enables reporting of execution contexts creation by means of <code>executionContextCreated</code> event. When the reporting gets enabled the event will be sent immediately for each existing execution context.
- (void)domain:(PDRuntimeDomain *)domain enableWithCallback:(void (^)(id error))callback;

/// Disables reporting of execution contexts creation.
- (void)domain:(PDRuntimeDomain *)domain disableWithCallback:(void (^)(id error))callback;
// Callback Param result: True if the Runtime is in paused on start state.
- (void)domain:(PDRuntimeDomain *)domain isRunRequiredWithCallback:(void (^)(NSNumber *result, id error))callback;
- (void)domain:(PDRuntimeDomain *)domain setCustomObjectFormatterEnabledWithEnabled:(NSNumber *)enabled callback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDRuntimeDomain)

@property (nonatomic, readonly, strong) PDRuntimeDomain *runtimeDomain;

@end
