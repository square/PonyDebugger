//
//  PDDebuggerTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDDebuggerTypes.h"

@implementation PDDebuggerLocation

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"scriptId",@"scriptId",
                    @"lineNumber",@"lineNumber",
                    @"columnNumber",@"columnNumber",
                    nil];
    });

    return mappings;
}

@dynamic scriptId;
@dynamic lineNumber;
@dynamic columnNumber;
 
@end

@implementation PDDebuggerFunctionDetails

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"location",@"location",
                    @"functionName",@"functionName",
                    @"isGenerator",@"isGenerator",
                    @"scopeChain",@"scopeChain",
                    nil];
    });

    return mappings;
}

@dynamic location;
@dynamic functionName;
@dynamic isGenerator;
@dynamic scopeChain;
 
@end

@implementation PDDebuggerGeneratorObjectDetails

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"function",@"function",
                    @"functionName",@"functionName",
                    @"status",@"status",
                    @"location",@"location",
                    nil];
    });

    return mappings;
}

@dynamic function;
@dynamic functionName;
@dynamic status;
@dynamic location;
 
@end

@implementation PDDebuggerCollectionEntry

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"key",@"key",
                    @"value",@"value",
                    nil];
    });

    return mappings;
}

@dynamic key;
@dynamic value;
 
@end

@implementation PDDebuggerCallFrame

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"callFrameId",@"callFrameId",
                    @"functionName",@"functionName",
                    @"functionLocation",@"functionLocation",
                    @"location",@"location",
                    @"scopeChain",@"scopeChain",
                    @"this",@"this",
                    @"returnValue",@"returnValue",
                    nil];
    });

    return mappings;
}

@dynamic callFrameId;
@dynamic functionName;
@dynamic functionLocation;
@dynamic location;
@dynamic scopeChain;
@dynamic this;
@dynamic returnValue;
 
@end

@implementation PDDebuggerStackTrace

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"callFrames",@"callFrames",
                    @"description",@"objectDescription",
                    @"asyncStackTrace",@"asyncStackTrace",
                    nil];
    });

    return mappings;
}

@dynamic callFrames;
@dynamic objectDescription;
@dynamic asyncStackTrace;
 
@end

@implementation PDDebuggerScope

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"type",@"type",
                    @"object",@"object",
                    nil];
    });

    return mappings;
}

@dynamic type;
@dynamic object;
 
@end

@implementation PDDebuggerExceptionDetails

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"text",@"text",
                    @"url",@"url",
                    @"scriptId",@"scriptId",
                    @"line",@"line",
                    @"column",@"column",
                    @"stackTrace",@"stackTrace",
                    nil];
    });

    return mappings;
}

@dynamic text;
@dynamic url;
@dynamic scriptId;
@dynamic line;
@dynamic column;
@dynamic stackTrace;
 
@end

@implementation PDDebuggerSetScriptSourceError

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"compileError",@"compileError",
                    nil];
    });

    return mappings;
}

@dynamic compileError;
 
@end

@implementation PDDebuggerPromiseDetails

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"id",@"identifier",
                    @"status",@"status",
                    @"parentId",@"parentId",
                    @"callFrame",@"callFrame",
                    @"creationTime",@"creationTime",
                    @"settlementTime",@"settlementTime",
                    @"creationStack",@"creationStack",
                    @"asyncCreationStack",@"asyncCreationStack",
                    @"settlementStack",@"settlementStack",
                    @"asyncSettlementStack",@"asyncSettlementStack",
                    nil];
    });

    return mappings;
}

@dynamic identifier;
@dynamic status;
@dynamic parentId;
@dynamic callFrame;
@dynamic creationTime;
@dynamic settlementTime;
@dynamic creationStack;
@dynamic asyncCreationStack;
@dynamic settlementStack;
@dynamic asyncSettlementStack;
 
@end

@implementation PDDebuggerAsyncOperation

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"id",@"identifier",
                    @"description",@"objectDescription",
                    @"stackTrace",@"stackTrace",
                    @"asyncStackTrace",@"asyncStackTrace",
                    nil];
    });

    return mappings;
}

@dynamic identifier;
@dynamic objectDescription;
@dynamic stackTrace;
@dynamic asyncStackTrace;
 
@end

@implementation PDDebuggerSearchMatch

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"lineNumber",@"lineNumber",
                    @"lineContent",@"lineContent",
                    nil];
    });

    return mappings;
}

@dynamic lineNumber;
@dynamic lineContent;
 
@end

