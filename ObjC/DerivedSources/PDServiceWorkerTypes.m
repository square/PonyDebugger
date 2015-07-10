//
//  PDServiceWorkerTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDServiceWorkerTypes.h"

@implementation PDServiceWorkerServiceWorkerRegistration

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"registrationId",@"registrationId",
                    @"scopeURL",@"scopeURL",
                    @"isDeleted",@"isDeleted",
                    nil];
    });

    return mappings;
}

@dynamic registrationId;
@dynamic scopeURL;
@dynamic isDeleted;
 
@end

@implementation PDServiceWorkerServiceWorkerVersion

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"versionId",@"versionId",
                    @"registrationId",@"registrationId",
                    @"scriptURL",@"scriptURL",
                    @"runningStatus",@"runningStatus",
                    @"status",@"status",
                    @"scriptLastModified",@"scriptLastModified",
                    @"scriptResponseTime",@"scriptResponseTime",
                    @"controlledClients",@"controlledClients",
                    nil];
    });

    return mappings;
}

@dynamic versionId;
@dynamic registrationId;
@dynamic scriptURL;
@dynamic runningStatus;
@dynamic status;
@dynamic scriptLastModified;
@dynamic scriptResponseTime;
@dynamic controlledClients;
 
@end

@implementation PDServiceWorkerServiceWorkerErrorMessage

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"errorMessage",@"errorMessage",
                    @"registrationId",@"registrationId",
                    @"versionId",@"versionId",
                    @"sourceURL",@"sourceURL",
                    @"lineNumber",@"lineNumber",
                    @"columnNumber",@"columnNumber",
                    nil];
    });

    return mappings;
}

@dynamic errorMessage;
@dynamic registrationId;
@dynamic versionId;
@dynamic sourceURL;
@dynamic lineNumber;
@dynamic columnNumber;
 
@end

@implementation PDServiceWorkerTargetInfo

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"id",@"identifier",
                    @"type",@"type",
                    @"title",@"title",
                    @"url",@"url",
                    nil];
    });

    return mappings;
}

@dynamic identifier;
@dynamic type;
@dynamic title;
@dynamic url;
 
@end

