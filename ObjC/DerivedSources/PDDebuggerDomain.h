//
//  PDDebuggerDomain.h
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

@class PDDebuggerGeneratorObjectDetails;
@class PDDebuggerExceptionDetails;
@class PDDebuggerLocation;
@class PDDebuggerStackTrace;
@class PDDebuggerPromiseDetails;
@class PDDebuggerAsyncOperation;
@class PDDebuggerFunctionDetails;
@class PDRuntimeRemoteObject;
@class PDRuntimeCallArgument;

@protocol PDDebuggerCommandDelegate;

// Debugger domain exposes JavaScript debugging capabilities. It allows setting and removing breakpoints, stepping through execution, exploring stack traces, etc.
@interface PDDebuggerDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDDebuggerCommandDelegate, PDCommandDelegate> delegate;

// Events

// Called when global has been cleared and debugger client should reset its state. Happens upon navigation or reload.
- (void)globalObjectCleared;

// Fired when virtual machine parses script. This event is also fired for all known and uncollected scripts upon enabling debugger.
// Param scriptId: Identifier of the script parsed.
// Param url: URL or name of the script parsed (if any).
// Param startLine: Line offset of the script within the resource with given URL (for script tags).
// Param startColumn: Column offset of the script within the resource with given URL.
// Param endLine: Last line of the script.
// Param endColumn: Length of the last line of the script.
// Param isContentScript: Determines whether this script is a user extension script.
// Param isInternalScript: Determines whether this script is an internal script.
// Param sourceMapURL: URL of source map associated with script (if any).
// Param hasSourceURL: True, if this script has sourceURL.
- (void)scriptParsedWithScriptId:(NSString *)scriptId url:(NSString *)url startLine:(NSNumber *)startLine startColumn:(NSNumber *)startColumn endLine:(NSNumber *)endLine endColumn:(NSNumber *)endColumn isContentScript:(NSNumber *)isContentScript isInternalScript:(NSNumber *)isInternalScript sourceMapURL:(NSString *)sourceMapURL hasSourceURL:(NSNumber *)hasSourceURL;

// Fired when virtual machine fails to parse the script.
// Param scriptId: Identifier of the script parsed.
// Param url: URL or name of the script parsed (if any).
// Param startLine: Line offset of the script within the resource with given URL (for script tags).
// Param startColumn: Column offset of the script within the resource with given URL.
// Param endLine: Last line of the script.
// Param endColumn: Length of the last line of the script.
// Param isContentScript: Determines whether this script is a user extension script.
// Param isInternalScript: Determines whether this script is an internal script.
// Param sourceMapURL: URL of source map associated with script (if any).
// Param hasSourceURL: True, if this script has sourceURL.
- (void)scriptFailedToParseWithScriptId:(NSString *)scriptId url:(NSString *)url startLine:(NSNumber *)startLine startColumn:(NSNumber *)startColumn endLine:(NSNumber *)endLine endColumn:(NSNumber *)endColumn isContentScript:(NSNumber *)isContentScript isInternalScript:(NSNumber *)isInternalScript sourceMapURL:(NSString *)sourceMapURL hasSourceURL:(NSNumber *)hasSourceURL;

// Fired when breakpoint is resolved to an actual script and location.
// Param breakpointId: Breakpoint unique identifier.
// Param location: Actual breakpoint location.
- (void)breakpointResolvedWithBreakpointId:(NSString *)breakpointId location:(PDDebuggerLocation *)location;

// Fired when the virtual machine stopped on breakpoint or exception or any other stop criteria.
// Param callFrames: Call stack the virtual machine stopped on.
// Param reason: Pause reason.
// Param data: Object containing break-specific auxiliary properties.
// Param hitBreakpoints: Hit breakpoints IDs
// Param asyncStackTrace: Async stack trace, if any.
- (void)pausedWithCallFrames:(NSArray *)callFrames reason:(NSString *)reason data:(NSDictionary *)data hitBreakpoints:(NSArray *)hitBreakpoints asyncStackTrace:(PDDebuggerStackTrace *)asyncStackTrace;

// Fired when the virtual machine resumed execution.
- (void)resumed;

// Fired when a <code>Promise</code> is created, updated or garbage collected.
// Param eventType: Type of the event.
// Param promise: Information about the updated <code>Promise</code>.
- (void)promiseUpdatedWithEventType:(NSString *)eventType promise:(PDDebuggerPromiseDetails *)promise;

// Fired when an async operation is scheduled (while in a debugger stepping session).
// Param operation: Information about the async operation.
- (void)asyncOperationStartedWithOperation:(PDDebuggerAsyncOperation *)operation;

// Fired when an async operation is completed (while in a debugger stepping session).
// Param id: ID of the async operation that was completed.
- (void)asyncOperationCompletedWithId:(NSNumber *)identifier;

@end

@protocol PDDebuggerCommandDelegate <PDCommandDelegate>
@optional

/// Enables debugger for the given page. Clients should not assume that the debugging has been enabled until the result for this command is received.
- (void)domain:(PDDebuggerDomain *)domain enableWithCallback:(void (^)(id error))callback;

/// Disables debugger for given page.
- (void)domain:(PDDebuggerDomain *)domain disableWithCallback:(void (^)(id error))callback;

/// Activates / deactivates all breakpoints on the page.
// Param active: New value for breakpoints active state.
- (void)domain:(PDDebuggerDomain *)domain setBreakpointsActiveWithActive:(NSNumber *)active callback:(void (^)(id error))callback;

/// Makes page not interrupt on any pauses (breakpoint, exception, dom exception etc).
// Param skipped: New value for skip pauses state.
- (void)domain:(PDDebuggerDomain *)domain setSkipAllPausesWithSkipped:(NSNumber *)skipped callback:(void (^)(id error))callback;

/// Sets JavaScript breakpoint at given location specified either by URL or URL regex. Once this command is issued, all existing parsed scripts will have breakpoints resolved and returned in <code>locations</code> property. Further matching script parsing will result in subsequent <code>breakpointResolved</code> events issued. This logical breakpoint will survive page reloads.
// Param lineNumber: Line number to set breakpoint at.
// Param url: URL of the resources to set breakpoint on.
// Param urlRegex: Regex pattern for the URLs of the resources to set breakpoints on. Either <code>url</code> or <code>urlRegex</code> must be specified.
// Param columnNumber: Offset in the line to set breakpoint at.
// Param condition: Expression to use as a breakpoint condition. When specified, debugger will only stop on the breakpoint if this expression evaluates to true.
// Callback Param breakpointId: Id of the created breakpoint for further reference.
// Callback Param locations: List of the locations this breakpoint resolved into upon addition.
- (void)domain:(PDDebuggerDomain *)domain setBreakpointByUrlWithLineNumber:(NSNumber *)lineNumber url:(NSString *)url urlRegex:(NSString *)urlRegex columnNumber:(NSNumber *)columnNumber condition:(NSString *)condition callback:(void (^)(NSString *breakpointId, NSArray *locations, id error))callback;

/// Sets JavaScript breakpoint at a given location.
// Param location: Location to set breakpoint in.
// Param condition: Expression to use as a breakpoint condition. When specified, debugger will only stop on the breakpoint if this expression evaluates to true.
// Callback Param breakpointId: Id of the created breakpoint for further reference.
// Callback Param actualLocation: Location this breakpoint resolved into.
- (void)domain:(PDDebuggerDomain *)domain setBreakpointWithLocation:(PDDebuggerLocation *)location condition:(NSString *)condition callback:(void (^)(NSString *breakpointId, PDDebuggerLocation *actualLocation, id error))callback;

/// Removes JavaScript breakpoint.
- (void)domain:(PDDebuggerDomain *)domain removeBreakpointWithBreakpointId:(NSString *)breakpointId callback:(void (^)(id error))callback;

/// Continues execution until specific location is reached.
// Param location: Location to continue to.
// Param interstatementLocation: Allows breakpoints at the intemediate positions inside statements.
- (void)domain:(PDDebuggerDomain *)domain continueToLocationWithLocation:(PDDebuggerLocation *)location interstatementLocation:(NSNumber *)interstatementLocation callback:(void (^)(id error))callback;

/// Steps over the statement.
- (void)domain:(PDDebuggerDomain *)domain stepOverWithCallback:(void (^)(id error))callback;

/// Steps into the function call.
- (void)domain:(PDDebuggerDomain *)domain stepIntoWithCallback:(void (^)(id error))callback;

/// Steps out of the function call.
- (void)domain:(PDDebuggerDomain *)domain stepOutWithCallback:(void (^)(id error))callback;

/// Stops on the next JavaScript statement.
- (void)domain:(PDDebuggerDomain *)domain pauseWithCallback:(void (^)(id error))callback;

/// Resumes JavaScript execution.
- (void)domain:(PDDebuggerDomain *)domain resumeWithCallback:(void (^)(id error))callback;

/// Steps into the first async operation handler that was scheduled by or after the current statement.
- (void)domain:(PDDebuggerDomain *)domain stepIntoAsyncWithCallback:(void (^)(id error))callback;

/// Searches for given string in script content.
// Param scriptId: Id of the script to search in.
// Param query: String to search for.
// Param caseSensitive: If true, search is case sensitive.
// Param isRegex: If true, treats string parameter as regex.
// Callback Param result: List of search matches.
- (void)domain:(PDDebuggerDomain *)domain searchInContentWithScriptId:(NSString *)scriptId query:(NSString *)query caseSensitive:(NSNumber *)caseSensitive isRegex:(NSNumber *)isRegex callback:(void (^)(NSArray *result, id error))callback;

/// Always returns true.
// Callback Param result: True if <code>setScriptSource</code> is supported.
- (void)domain:(PDDebuggerDomain *)domain canSetScriptSourceWithCallback:(void (^)(NSNumber *result, id error))callback;

/// Edits JavaScript source live.
// Param scriptId: Id of the script to edit.
// Param scriptSource: New content of the script.
// Param preview:  If true the change will not actually be applied. Preview mode may be used to get result description without actually modifying the code.
// Callback Param callFrames: New stack trace in case editing has happened while VM was stopped.
// Callback Param result: VM-specific description of the changes applied.
// Callback Param asyncStackTrace: Async stack trace, if any.
- (void)domain:(PDDebuggerDomain *)domain setScriptSourceWithScriptId:(NSString *)scriptId scriptSource:(NSString *)scriptSource preview:(NSNumber *)preview callback:(void (^)(NSArray *callFrames, NSDictionary *result, PDDebuggerStackTrace *asyncStackTrace, id error))callback;

/// Restarts particular call frame from the beginning.
// Param callFrameId: Call frame identifier to evaluate on.
// Callback Param callFrames: New stack trace.
// Callback Param result: VM-specific description.
// Callback Param asyncStackTrace: Async stack trace, if any.
- (void)domain:(PDDebuggerDomain *)domain restartFrameWithCallFrameId:(NSString *)callFrameId callback:(void (^)(NSArray *callFrames, NSDictionary *result, PDDebuggerStackTrace *asyncStackTrace, id error))callback;

/// Returns source for the script with given id.
// Param scriptId: Id of the script to get source for.
// Callback Param scriptSource: Script source.
- (void)domain:(PDDebuggerDomain *)domain getScriptSourceWithScriptId:(NSString *)scriptId callback:(void (^)(NSString *scriptSource, id error))callback;

/// Returns detailed information on given function.
// Param functionId: Id of the function to get details for.
// Callback Param details: Information about the function.
- (void)domain:(PDDebuggerDomain *)domain getFunctionDetailsWithFunctionId:(NSString *)functionId callback:(void (^)(PDDebuggerFunctionDetails *details, id error))callback;

/// Returns detailed information on given generator object.
// Param objectId: Id of the generator object to get details for.
// Callback Param details: Information about the generator object.
- (void)domain:(PDDebuggerDomain *)domain getGeneratorObjectDetailsWithObjectId:(NSString *)objectId callback:(void (^)(PDDebuggerGeneratorObjectDetails *details, id error))callback;

/// Returns entries of given collection.
// Param objectId: Id of the collection to get entries for.
// Callback Param entries: Array of collection entries.
- (void)domain:(PDDebuggerDomain *)domain getCollectionEntriesWithObjectId:(NSString *)objectId callback:(void (^)(NSArray *entries, id error))callback;

/// Defines pause on exceptions state. Can be set to stop on all exceptions, uncaught exceptions or no exceptions. Initial pause on exceptions state is <code>none</code>.
// Param state: Pause on exceptions mode.
- (void)domain:(PDDebuggerDomain *)domain setPauseOnExceptionsWithState:(NSString *)state callback:(void (^)(id error))callback;

/// Evaluates expression on a given call frame.
// Param callFrameId: Call frame identifier to evaluate on.
// Param expression: Expression to evaluate.
// Param objectGroup: String object group name to put result into (allows rapid releasing resulting object handles using <code>releaseObjectGroup</code>).
// Param includeCommandLineAPI: Specifies whether command line API should be available to the evaluated expression, defaults to false.
// Param doNotPauseOnExceptionsAndMuteConsole: Specifies whether evaluation should stop on exceptions and mute console. Overrides setPauseOnException state.
// Param returnByValue: Whether the result is expected to be a JSON object that should be sent by value.
// Param generatePreview: Whether preview should be generated for the result.
// Callback Param result: Object wrapper for the evaluation result.
// Callback Param wasThrown: True if the result was thrown during the evaluation.
// Callback Param exceptionDetails: Exception details.
- (void)domain:(PDDebuggerDomain *)domain evaluateOnCallFrameWithCallFrameId:(NSString *)callFrameId expression:(NSString *)expression objectGroup:(NSString *)objectGroup includeCommandLineAPI:(NSNumber *)includeCommandLineAPI doNotPauseOnExceptionsAndMuteConsole:(NSNumber *)doNotPauseOnExceptionsAndMuteConsole returnByValue:(NSNumber *)returnByValue generatePreview:(NSNumber *)generatePreview callback:(void (^)(PDRuntimeRemoteObject *result, NSNumber *wasThrown, PDDebuggerExceptionDetails *exceptionDetails, id error))callback;

/// Compiles expression.
// Param expression: Expression to compile.
// Param sourceURL: Source url to be set for the script.
// Param persistScript: Specifies whether the compiled script should be persisted.
// Param executionContextId: Specifies in which isolated context to perform script run. Each content script lives in an isolated context and this parameter may be used to specify one of those contexts. If the parameter is omitted or 0 the evaluation will be performed in the context of the inspected page.
// Callback Param scriptId: Id of the script.
// Callback Param exceptionDetails: Exception details.
- (void)domain:(PDDebuggerDomain *)domain compileScriptWithExpression:(NSString *)expression sourceURL:(NSString *)sourceURL persistScript:(NSNumber *)persistScript executionContextId:(NSNumber *)executionContextId callback:(void (^)(NSString *scriptId, PDDebuggerExceptionDetails *exceptionDetails, id error))callback;

/// Runs script with given id in a given context.
// Param scriptId: Id of the script to run.
// Param executionContextId: Specifies in which isolated context to perform script run. Each content script lives in an isolated context and this parameter may be used to specify one of those contexts. If the parameter is omitted or 0 the evaluation will be performed in the context of the inspected page.
// Param objectGroup: Symbolic group name that can be used to release multiple objects.
// Param doNotPauseOnExceptionsAndMuteConsole: Specifies whether script run should stop on exceptions and mute console. Overrides setPauseOnException state.
// Callback Param result: Run result.
// Callback Param exceptionDetails: Exception details.
- (void)domain:(PDDebuggerDomain *)domain runScriptWithScriptId:(NSString *)scriptId executionContextId:(NSNumber *)executionContextId objectGroup:(NSString *)objectGroup doNotPauseOnExceptionsAndMuteConsole:(NSNumber *)doNotPauseOnExceptionsAndMuteConsole callback:(void (^)(PDRuntimeRemoteObject *result, PDDebuggerExceptionDetails *exceptionDetails, id error))callback;

/// Changes value of variable in a callframe or a closure. Either callframe or function must be specified. Object-based scopes are not supported and must be mutated manually.
// Param scopeNumber: 0-based number of scope as was listed in scope chain. Only 'local', 'closure' and 'catch' scope types are allowed. Other scopes could be manipulated manually.
// Param variableName: Variable name.
// Param newValue: New variable value.
// Param callFrameId: Id of callframe that holds variable.
// Param functionObjectId: Object id of closure (function) that holds variable.
- (void)domain:(PDDebuggerDomain *)domain setVariableValueWithScopeNumber:(NSNumber *)scopeNumber variableName:(NSString *)variableName newValue:(PDRuntimeCallArgument *)newValue callFrameId:(NSString *)callFrameId functionObjectId:(NSString *)functionObjectId callback:(void (^)(id error))callback;

/// Lists all positions where step-in is possible for a current statement in a specified call frame
// Param callFrameId: Id of a call frame where the current statement should be analized
// Callback Param stepInPositions: experimental
- (void)domain:(PDDebuggerDomain *)domain getStepInPositionsWithCallFrameId:(NSString *)callFrameId callback:(void (^)(NSArray *stepInPositions, id error))callback;

/// Returns call stack including variables changed since VM was paused. VM must be paused.
// Callback Param callFrames: Call stack the virtual machine stopped on.
// Callback Param asyncStackTrace: Async stack trace, if any.
- (void)domain:(PDDebuggerDomain *)domain getBacktraceWithCallback:(void (^)(NSArray *callFrames, PDDebuggerStackTrace *asyncStackTrace, id error))callback;

/// Makes backend skip steps in the sources with names matching given pattern. VM will try leave blacklisted scripts by performing 'step in' several times, finally resorting to 'step out' if unsuccessful.
// Param script: Regular expression defining the scripts to ignore while stepping.
// Param skipContentScripts: True, if all content scripts should be ignored.
- (void)domain:(PDDebuggerDomain *)domain skipStackFramesWithScript:(NSString *)script skipContentScripts:(NSNumber *)skipContentScripts callback:(void (^)(id error))callback;

/// Enables or disables async call stacks tracking.
// Param maxDepth: Maximum depth of async call stacks. Setting to <code>0</code> will effectively disable collecting async call stacks (default).
- (void)domain:(PDDebuggerDomain *)domain setAsyncCallStackDepthWithMaxDepth:(NSNumber *)maxDepth callback:(void (^)(id error))callback;

/// Enables promise tracking, information about <code>Promise</code>s created or updated will now be stored on the backend.
// Param captureStacks: Whether to capture stack traces for promise creation and settlement events (default: false).
- (void)domain:(PDDebuggerDomain *)domain enablePromiseTrackerWithCaptureStacks:(NSNumber *)captureStacks callback:(void (^)(id error))callback;

/// Disables promise tracking.
- (void)domain:(PDDebuggerDomain *)domain disablePromiseTrackerWithCallback:(void (^)(id error))callback;

/// Returns <code>Promise</code> with specified ID.
// Param objectGroup: Symbolic group name that can be used to release multiple objects.
// Callback Param promise: Object wrapper for <code>Promise</code> with specified ID, if any.
- (void)domain:(PDDebuggerDomain *)domain getPromiseByIdWithPromiseId:(NSNumber *)promiseId objectGroup:(NSString *)objectGroup callback:(void (^)(PDRuntimeRemoteObject *promise, id error))callback;

/// Fires pending <code>asyncOperationStarted</code> events (if any), as if a debugger stepping session has just been started.
- (void)domain:(PDDebuggerDomain *)domain flushAsyncOperationEventsWithCallback:(void (^)(id error))callback;

/// Sets breakpoint on AsyncOperation callback handler.
// Param operationId: ID of the async operation to set breakpoint for.
- (void)domain:(PDDebuggerDomain *)domain setAsyncOperationBreakpointWithOperationId:(NSNumber *)operationId callback:(void (^)(id error))callback;

/// Removes AsyncOperation breakpoint.
// Param operationId: ID of the async operation to remove breakpoint for.
- (void)domain:(PDDebuggerDomain *)domain removeAsyncOperationBreakpointWithOperationId:(NSNumber *)operationId callback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDDebuggerDomain)

@property (nonatomic, readonly, strong) PDDebuggerDomain *debuggerDomain;

@end
