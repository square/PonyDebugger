//
//  PDDebuggerDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebuggerDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebuggerTypes.h>
#import <PonyDebugger/PDRuntimeTypes.h>


@interface PDDebuggerDomain ()
//Commands

@end

@implementation PDDebuggerDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Debugger";
}

// Events

// Called when global has been cleared and debugger client should reset its state. Happens upon navigation or reload.
- (void)globalObjectCleared;
{
    [self.debuggingServer sendEventWithName:@"Debugger.globalObjectCleared" parameters:nil];
}

// Fired when virtual machine parses script. This event is also fired for all known and uncollected scripts upon enabling debugger.
- (void)scriptParsedWithScriptId:(NSString *)scriptId url:(NSString *)url startLine:(NSNumber *)startLine startColumn:(NSNumber *)startColumn endLine:(NSNumber *)endLine endColumn:(NSNumber *)endColumn isContentScript:(NSNumber *)isContentScript isInternalScript:(NSNumber *)isInternalScript sourceMapURL:(NSString *)sourceMapURL hasSourceURL:(NSNumber *)hasSourceURL;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];

    if (scriptId != nil) {
        [params setObject:[scriptId PD_JSONObject] forKey:@"scriptId"];
    }
    if (url != nil) {
        [params setObject:[url PD_JSONObject] forKey:@"url"];
    }
    if (startLine != nil) {
        [params setObject:[startLine PD_JSONObject] forKey:@"startLine"];
    }
    if (startColumn != nil) {
        [params setObject:[startColumn PD_JSONObject] forKey:@"startColumn"];
    }
    if (endLine != nil) {
        [params setObject:[endLine PD_JSONObject] forKey:@"endLine"];
    }
    if (endColumn != nil) {
        [params setObject:[endColumn PD_JSONObject] forKey:@"endColumn"];
    }
    if (isContentScript != nil) {
        [params setObject:[isContentScript PD_JSONObject] forKey:@"isContentScript"];
    }
    if (isInternalScript != nil) {
        [params setObject:[isInternalScript PD_JSONObject] forKey:@"isInternalScript"];
    }
    if (sourceMapURL != nil) {
        [params setObject:[sourceMapURL PD_JSONObject] forKey:@"sourceMapURL"];
    }
    if (hasSourceURL != nil) {
        [params setObject:[hasSourceURL PD_JSONObject] forKey:@"hasSourceURL"];
    }
    
    [self.debuggingServer sendEventWithName:@"Debugger.scriptParsed" parameters:params];
}

// Fired when virtual machine fails to parse the script.
- (void)scriptFailedToParseWithScriptId:(NSString *)scriptId url:(NSString *)url startLine:(NSNumber *)startLine startColumn:(NSNumber *)startColumn endLine:(NSNumber *)endLine endColumn:(NSNumber *)endColumn isContentScript:(NSNumber *)isContentScript isInternalScript:(NSNumber *)isInternalScript sourceMapURL:(NSString *)sourceMapURL hasSourceURL:(NSNumber *)hasSourceURL;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];

    if (scriptId != nil) {
        [params setObject:[scriptId PD_JSONObject] forKey:@"scriptId"];
    }
    if (url != nil) {
        [params setObject:[url PD_JSONObject] forKey:@"url"];
    }
    if (startLine != nil) {
        [params setObject:[startLine PD_JSONObject] forKey:@"startLine"];
    }
    if (startColumn != nil) {
        [params setObject:[startColumn PD_JSONObject] forKey:@"startColumn"];
    }
    if (endLine != nil) {
        [params setObject:[endLine PD_JSONObject] forKey:@"endLine"];
    }
    if (endColumn != nil) {
        [params setObject:[endColumn PD_JSONObject] forKey:@"endColumn"];
    }
    if (isContentScript != nil) {
        [params setObject:[isContentScript PD_JSONObject] forKey:@"isContentScript"];
    }
    if (isInternalScript != nil) {
        [params setObject:[isInternalScript PD_JSONObject] forKey:@"isInternalScript"];
    }
    if (sourceMapURL != nil) {
        [params setObject:[sourceMapURL PD_JSONObject] forKey:@"sourceMapURL"];
    }
    if (hasSourceURL != nil) {
        [params setObject:[hasSourceURL PD_JSONObject] forKey:@"hasSourceURL"];
    }
    
    [self.debuggingServer sendEventWithName:@"Debugger.scriptFailedToParse" parameters:params];
}

// Fired when breakpoint is resolved to an actual script and location.
- (void)breakpointResolvedWithBreakpointId:(NSString *)breakpointId location:(PDDebuggerLocation *)location;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (breakpointId != nil) {
        [params setObject:[breakpointId PD_JSONObject] forKey:@"breakpointId"];
    }
    if (location != nil) {
        [params setObject:[location PD_JSONObject] forKey:@"location"];
    }
    
    [self.debuggingServer sendEventWithName:@"Debugger.breakpointResolved" parameters:params];
}

// Fired when the virtual machine stopped on breakpoint or exception or any other stop criteria.
- (void)pausedWithCallFrames:(NSArray *)callFrames reason:(NSString *)reason data:(NSDictionary *)data hitBreakpoints:(NSArray *)hitBreakpoints asyncStackTrace:(PDDebuggerStackTrace *)asyncStackTrace;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:5];

    if (callFrames != nil) {
        [params setObject:[callFrames PD_JSONObject] forKey:@"callFrames"];
    }
    if (reason != nil) {
        [params setObject:[reason PD_JSONObject] forKey:@"reason"];
    }
    if (data != nil) {
        [params setObject:[data PD_JSONObject] forKey:@"data"];
    }
    if (hitBreakpoints != nil) {
        [params setObject:[hitBreakpoints PD_JSONObject] forKey:@"hitBreakpoints"];
    }
    if (asyncStackTrace != nil) {
        [params setObject:[asyncStackTrace PD_JSONObject] forKey:@"asyncStackTrace"];
    }
    
    [self.debuggingServer sendEventWithName:@"Debugger.paused" parameters:params];
}

// Fired when the virtual machine resumed execution.
- (void)resumed;
{
    [self.debuggingServer sendEventWithName:@"Debugger.resumed" parameters:nil];
}

// Fired when a <code>Promise</code> is created, updated or garbage collected.
- (void)promiseUpdatedWithEventType:(NSString *)eventType promise:(PDDebuggerPromiseDetails *)promise;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (eventType != nil) {
        [params setObject:[eventType PD_JSONObject] forKey:@"eventType"];
    }
    if (promise != nil) {
        [params setObject:[promise PD_JSONObject] forKey:@"promise"];
    }
    
    [self.debuggingServer sendEventWithName:@"Debugger.promiseUpdated" parameters:params];
}

// Fired when an async operation is scheduled (while in a debugger stepping session).
- (void)asyncOperationStartedWithOperation:(PDDebuggerAsyncOperation *)operation;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (operation != nil) {
        [params setObject:[operation PD_JSONObject] forKey:@"operation"];
    }
    
    [self.debuggingServer sendEventWithName:@"Debugger.asyncOperationStarted" parameters:params];
}

// Fired when an async operation is completed (while in a debugger stepping session).
- (void)asyncOperationCompletedWithId:(NSNumber *)identifier;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (identifier != nil) {
        [params setObject:[identifier PD_JSONObject] forKey:@"id"];
    }
    
    [self.debuggingServer sendEventWithName:@"Debugger.asyncOperationCompleted" parameters:params];
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
    } else if ([methodName isEqualToString:@"setBreakpointsActive"] && [self.delegate respondsToSelector:@selector(domain:setBreakpointsActiveWithActive:callback:)]) {
        [self.delegate domain:self setBreakpointsActiveWithActive:[params objectForKey:@"active"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setSkipAllPauses"] && [self.delegate respondsToSelector:@selector(domain:setSkipAllPausesWithSkipped:callback:)]) {
        [self.delegate domain:self setSkipAllPausesWithSkipped:[params objectForKey:@"skipped"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setBreakpointByUrl"] && [self.delegate respondsToSelector:@selector(domain:setBreakpointByUrlWithLineNumber:url:urlRegex:columnNumber:condition:callback:)]) {
        [self.delegate domain:self setBreakpointByUrlWithLineNumber:[params objectForKey:@"lineNumber"] url:[params objectForKey:@"url"] urlRegex:[params objectForKey:@"urlRegex"] columnNumber:[params objectForKey:@"columnNumber"] condition:[params objectForKey:@"condition"] callback:^(NSString *breakpointId, NSArray *locations, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (breakpointId != nil) {
                [params setObject:breakpointId forKey:@"breakpointId"];
            }
            if (locations != nil) {
                [params setObject:locations forKey:@"locations"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setBreakpoint"] && [self.delegate respondsToSelector:@selector(domain:setBreakpointWithLocation:condition:callback:)]) {
        [self.delegate domain:self setBreakpointWithLocation:[params objectForKey:@"location"] condition:[params objectForKey:@"condition"] callback:^(NSString *breakpointId, PDDebuggerLocation *actualLocation, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (breakpointId != nil) {
                [params setObject:breakpointId forKey:@"breakpointId"];
            }
            if (actualLocation != nil) {
                [params setObject:actualLocation forKey:@"actualLocation"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"removeBreakpoint"] && [self.delegate respondsToSelector:@selector(domain:removeBreakpointWithBreakpointId:callback:)]) {
        [self.delegate domain:self removeBreakpointWithBreakpointId:[params objectForKey:@"breakpointId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"continueToLocation"] && [self.delegate respondsToSelector:@selector(domain:continueToLocationWithLocation:interstatementLocation:callback:)]) {
        [self.delegate domain:self continueToLocationWithLocation:[params objectForKey:@"location"] interstatementLocation:[params objectForKey:@"interstatementLocation"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"stepOver"] && [self.delegate respondsToSelector:@selector(domain:stepOverWithCallback:)]) {
        [self.delegate domain:self stepOverWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"stepInto"] && [self.delegate respondsToSelector:@selector(domain:stepIntoWithCallback:)]) {
        [self.delegate domain:self stepIntoWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"stepOut"] && [self.delegate respondsToSelector:@selector(domain:stepOutWithCallback:)]) {
        [self.delegate domain:self stepOutWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"pause"] && [self.delegate respondsToSelector:@selector(domain:pauseWithCallback:)]) {
        [self.delegate domain:self pauseWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"resume"] && [self.delegate respondsToSelector:@selector(domain:resumeWithCallback:)]) {
        [self.delegate domain:self resumeWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"stepIntoAsync"] && [self.delegate respondsToSelector:@selector(domain:stepIntoAsyncWithCallback:)]) {
        [self.delegate domain:self stepIntoAsyncWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"searchInContent"] && [self.delegate respondsToSelector:@selector(domain:searchInContentWithScriptId:query:caseSensitive:isRegex:callback:)]) {
        [self.delegate domain:self searchInContentWithScriptId:[params objectForKey:@"scriptId"] query:[params objectForKey:@"query"] caseSensitive:[params objectForKey:@"caseSensitive"] isRegex:[params objectForKey:@"isRegex"] callback:^(NSArray *result, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (result != nil) {
                [params setObject:result forKey:@"result"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"canSetScriptSource"] && [self.delegate respondsToSelector:@selector(domain:canSetScriptSourceWithCallback:)]) {
        [self.delegate domain:self canSetScriptSourceWithCallback:^(NSNumber *result, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (result != nil) {
                [params setObject:result forKey:@"result"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setScriptSource"] && [self.delegate respondsToSelector:@selector(domain:setScriptSourceWithScriptId:scriptSource:preview:callback:)]) {
        [self.delegate domain:self setScriptSourceWithScriptId:[params objectForKey:@"scriptId"] scriptSource:[params objectForKey:@"scriptSource"] preview:[params objectForKey:@"preview"] callback:^(NSArray *callFrames, NSDictionary *result, PDDebuggerStackTrace *asyncStackTrace, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];

            if (callFrames != nil) {
                [params setObject:callFrames forKey:@"callFrames"];
            }
            if (result != nil) {
                [params setObject:result forKey:@"result"];
            }
            if (asyncStackTrace != nil) {
                [params setObject:asyncStackTrace forKey:@"asyncStackTrace"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"restartFrame"] && [self.delegate respondsToSelector:@selector(domain:restartFrameWithCallFrameId:callback:)]) {
        [self.delegate domain:self restartFrameWithCallFrameId:[params objectForKey:@"callFrameId"] callback:^(NSArray *callFrames, NSDictionary *result, PDDebuggerStackTrace *asyncStackTrace, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];

            if (callFrames != nil) {
                [params setObject:callFrames forKey:@"callFrames"];
            }
            if (result != nil) {
                [params setObject:result forKey:@"result"];
            }
            if (asyncStackTrace != nil) {
                [params setObject:asyncStackTrace forKey:@"asyncStackTrace"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getScriptSource"] && [self.delegate respondsToSelector:@selector(domain:getScriptSourceWithScriptId:callback:)]) {
        [self.delegate domain:self getScriptSourceWithScriptId:[params objectForKey:@"scriptId"] callback:^(NSString *scriptSource, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (scriptSource != nil) {
                [params setObject:scriptSource forKey:@"scriptSource"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getFunctionDetails"] && [self.delegate respondsToSelector:@selector(domain:getFunctionDetailsWithFunctionId:callback:)]) {
        [self.delegate domain:self getFunctionDetailsWithFunctionId:[params objectForKey:@"functionId"] callback:^(PDDebuggerFunctionDetails *details, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (details != nil) {
                [params setObject:details forKey:@"details"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getGeneratorObjectDetails"] && [self.delegate respondsToSelector:@selector(domain:getGeneratorObjectDetailsWithObjectId:callback:)]) {
        [self.delegate domain:self getGeneratorObjectDetailsWithObjectId:[params objectForKey:@"objectId"] callback:^(PDDebuggerGeneratorObjectDetails *details, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (details != nil) {
                [params setObject:details forKey:@"details"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getCollectionEntries"] && [self.delegate respondsToSelector:@selector(domain:getCollectionEntriesWithObjectId:callback:)]) {
        [self.delegate domain:self getCollectionEntriesWithObjectId:[params objectForKey:@"objectId"] callback:^(NSArray *entries, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (entries != nil) {
                [params setObject:entries forKey:@"entries"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setPauseOnExceptions"] && [self.delegate respondsToSelector:@selector(domain:setPauseOnExceptionsWithState:callback:)]) {
        [self.delegate domain:self setPauseOnExceptionsWithState:[params objectForKey:@"state"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"evaluateOnCallFrame"] && [self.delegate respondsToSelector:@selector(domain:evaluateOnCallFrameWithCallFrameId:expression:objectGroup:includeCommandLineAPI:doNotPauseOnExceptionsAndMuteConsole:returnByValue:generatePreview:callback:)]) {
        [self.delegate domain:self evaluateOnCallFrameWithCallFrameId:[params objectForKey:@"callFrameId"] expression:[params objectForKey:@"expression"] objectGroup:[params objectForKey:@"objectGroup"] includeCommandLineAPI:[params objectForKey:@"includeCommandLineAPI"] doNotPauseOnExceptionsAndMuteConsole:[params objectForKey:@"doNotPauseOnExceptionsAndMuteConsole"] returnByValue:[params objectForKey:@"returnByValue"] generatePreview:[params objectForKey:@"generatePreview"] callback:^(PDRuntimeRemoteObject *result, NSNumber *wasThrown, PDDebuggerExceptionDetails *exceptionDetails, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];

            if (result != nil) {
                [params setObject:result forKey:@"result"];
            }
            if (wasThrown != nil) {
                [params setObject:wasThrown forKey:@"wasThrown"];
            }
            if (exceptionDetails != nil) {
                [params setObject:exceptionDetails forKey:@"exceptionDetails"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"compileScript"] && [self.delegate respondsToSelector:@selector(domain:compileScriptWithExpression:sourceURL:persistScript:executionContextId:callback:)]) {
        [self.delegate domain:self compileScriptWithExpression:[params objectForKey:@"expression"] sourceURL:[params objectForKey:@"sourceURL"] persistScript:[params objectForKey:@"persistScript"] executionContextId:[params objectForKey:@"executionContextId"] callback:^(NSString *scriptId, PDDebuggerExceptionDetails *exceptionDetails, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (scriptId != nil) {
                [params setObject:scriptId forKey:@"scriptId"];
            }
            if (exceptionDetails != nil) {
                [params setObject:exceptionDetails forKey:@"exceptionDetails"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"runScript"] && [self.delegate respondsToSelector:@selector(domain:runScriptWithScriptId:executionContextId:objectGroup:doNotPauseOnExceptionsAndMuteConsole:callback:)]) {
        [self.delegate domain:self runScriptWithScriptId:[params objectForKey:@"scriptId"] executionContextId:[params objectForKey:@"executionContextId"] objectGroup:[params objectForKey:@"objectGroup"] doNotPauseOnExceptionsAndMuteConsole:[params objectForKey:@"doNotPauseOnExceptionsAndMuteConsole"] callback:^(PDRuntimeRemoteObject *result, PDDebuggerExceptionDetails *exceptionDetails, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (result != nil) {
                [params setObject:result forKey:@"result"];
            }
            if (exceptionDetails != nil) {
                [params setObject:exceptionDetails forKey:@"exceptionDetails"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setVariableValue"] && [self.delegate respondsToSelector:@selector(domain:setVariableValueWithScopeNumber:variableName:newValue:callFrameId:functionObjectId:callback:)]) {
        [self.delegate domain:self setVariableValueWithScopeNumber:[params objectForKey:@"scopeNumber"] variableName:[params objectForKey:@"variableName"] newValue:[params objectForKey:@"newValue"] callFrameId:[params objectForKey:@"callFrameId"] functionObjectId:[params objectForKey:@"functionObjectId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getStepInPositions"] && [self.delegate respondsToSelector:@selector(domain:getStepInPositionsWithCallFrameId:callback:)]) {
        [self.delegate domain:self getStepInPositionsWithCallFrameId:[params objectForKey:@"callFrameId"] callback:^(NSArray *stepInPositions, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (stepInPositions != nil) {
                [params setObject:stepInPositions forKey:@"stepInPositions"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getBacktrace"] && [self.delegate respondsToSelector:@selector(domain:getBacktraceWithCallback:)]) {
        [self.delegate domain:self getBacktraceWithCallback:^(NSArray *callFrames, PDDebuggerStackTrace *asyncStackTrace, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (callFrames != nil) {
                [params setObject:callFrames forKey:@"callFrames"];
            }
            if (asyncStackTrace != nil) {
                [params setObject:asyncStackTrace forKey:@"asyncStackTrace"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"skipStackFrames"] && [self.delegate respondsToSelector:@selector(domain:skipStackFramesWithScript:skipContentScripts:callback:)]) {
        [self.delegate domain:self skipStackFramesWithScript:[params objectForKey:@"script"] skipContentScripts:[params objectForKey:@"skipContentScripts"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setAsyncCallStackDepth"] && [self.delegate respondsToSelector:@selector(domain:setAsyncCallStackDepthWithMaxDepth:callback:)]) {
        [self.delegate domain:self setAsyncCallStackDepthWithMaxDepth:[params objectForKey:@"maxDepth"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"enablePromiseTracker"] && [self.delegate respondsToSelector:@selector(domain:enablePromiseTrackerWithCaptureStacks:callback:)]) {
        [self.delegate domain:self enablePromiseTrackerWithCaptureStacks:[params objectForKey:@"captureStacks"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"disablePromiseTracker"] && [self.delegate respondsToSelector:@selector(domain:disablePromiseTrackerWithCallback:)]) {
        [self.delegate domain:self disablePromiseTrackerWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getPromiseById"] && [self.delegate respondsToSelector:@selector(domain:getPromiseByIdWithPromiseId:objectGroup:callback:)]) {
        [self.delegate domain:self getPromiseByIdWithPromiseId:[params objectForKey:@"promiseId"] objectGroup:[params objectForKey:@"objectGroup"] callback:^(PDRuntimeRemoteObject *promise, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (promise != nil) {
                [params setObject:promise forKey:@"promise"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"flushAsyncOperationEvents"] && [self.delegate respondsToSelector:@selector(domain:flushAsyncOperationEventsWithCallback:)]) {
        [self.delegate domain:self flushAsyncOperationEventsWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setAsyncOperationBreakpoint"] && [self.delegate respondsToSelector:@selector(domain:setAsyncOperationBreakpointWithOperationId:callback:)]) {
        [self.delegate domain:self setAsyncOperationBreakpointWithOperationId:[params objectForKey:@"operationId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"removeAsyncOperationBreakpoint"] && [self.delegate respondsToSelector:@selector(domain:removeAsyncOperationBreakpointWithOperationId:callback:)]) {
        [self.delegate domain:self removeAsyncOperationBreakpointWithOperationId:[params objectForKey:@"operationId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDDebuggerDomain)

- (PDDebuggerDomain *)debuggerDomain;
{
    return [self domainForName:@"Debugger"];
}

@end
