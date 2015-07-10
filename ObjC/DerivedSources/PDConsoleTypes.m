//
//  PDConsoleTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDConsoleTypes.h"

@implementation PDConsoleConsoleMessage

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"source",@"source",
                    @"level",@"level",
                    @"text",@"text",
                    @"type",@"type",
                    @"scriptId",@"scriptId",
                    @"url",@"url",
                    @"line",@"line",
                    @"column",@"column",
                    @"repeatCount",@"repeatCount",
                    @"parameters",@"parameters",
                    @"stackTrace",@"stackTrace",
                    @"asyncStackTrace",@"asyncStackTrace",
                    @"networkRequestId",@"networkRequestId",
                    @"timestamp",@"timestamp",
                    @"executionContextId",@"executionContextId",
                    @"messageId",@"messageId",
                    @"relatedMessageId",@"relatedMessageId",
                    nil];
    });

    return mappings;
}

@dynamic source;
@dynamic level;
@dynamic text;
@dynamic type;
@dynamic scriptId;
@dynamic url;
@dynamic line;
@dynamic column;
@dynamic repeatCount;
@dynamic parameters;
@dynamic stackTrace;
@dynamic asyncStackTrace;
@dynamic networkRequestId;
@dynamic timestamp;
@dynamic executionContextId;
@dynamic messageId;
@dynamic relatedMessageId;
 
@end

@implementation PDConsoleCallFrame

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"functionName",@"functionName",
                    @"scriptId",@"scriptId",
                    @"url",@"url",
                    @"lineNumber",@"lineNumber",
                    @"columnNumber",@"columnNumber",
                    nil];
    });

    return mappings;
}

@dynamic functionName;
@dynamic scriptId;
@dynamic url;
@dynamic lineNumber;
@dynamic columnNumber;
 
@end

@implementation PDConsoleAsyncStackTrace

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

