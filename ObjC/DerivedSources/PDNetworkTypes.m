//
//  PDNetworkTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDNetworkTypes.h"

@implementation PDNetworkResourceTiming

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"requestTime",@"requestTime",
                    @"proxyStart",@"proxyStart",
                    @"proxyEnd",@"proxyEnd",
                    @"dnsStart",@"dnsStart",
                    @"dnsEnd",@"dnsEnd",
                    @"connectStart",@"connectStart",
                    @"connectEnd",@"connectEnd",
                    @"sslStart",@"sslStart",
                    @"sslEnd",@"sslEnd",
                    @"workerStart",@"workerStart",
                    @"workerReady",@"workerReady",
                    @"sendStart",@"sendStart",
                    @"sendEnd",@"sendEnd",
                    @"receiveHeadersEnd",@"receiveHeadersEnd",
                    nil];
    });

    return mappings;
}

@dynamic requestTime;
@dynamic proxyStart;
@dynamic proxyEnd;
@dynamic dnsStart;
@dynamic dnsEnd;
@dynamic connectStart;
@dynamic connectEnd;
@dynamic sslStart;
@dynamic sslEnd;
@dynamic workerStart;
@dynamic workerReady;
@dynamic sendStart;
@dynamic sendEnd;
@dynamic receiveHeadersEnd;
 
@end

@implementation PDNetworkRequest

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"url",@"url",
                    @"method",@"method",
                    @"headers",@"headers",
                    @"postData",@"postData",
                    nil];
    });

    return mappings;
}

@dynamic url;
@dynamic method;
@dynamic headers;
@dynamic postData;
 
@end

@implementation PDNetworkResponse

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"url",@"url",
                    @"status",@"status",
                    @"statusText",@"statusText",
                    @"headers",@"headers",
                    @"headersText",@"headersText",
                    @"mimeType",@"mimeType",
                    @"requestHeaders",@"requestHeaders",
                    @"requestHeadersText",@"requestHeadersText",
                    @"connectionReused",@"connectionReused",
                    @"connectionId",@"connectionId",
                    @"remoteIPAddress",@"remoteIPAddress",
                    @"remotePort",@"remotePort",
                    @"fromDiskCache",@"fromDiskCache",
                    @"fromServiceWorker",@"fromServiceWorker",
                    @"encodedDataLength",@"encodedDataLength",
                    @"timing",@"timing",
                    @"protocol",@"protocol",
                    nil];
    });

    return mappings;
}

@dynamic url;
@dynamic status;
@dynamic statusText;
@dynamic headers;
@dynamic headersText;
@dynamic mimeType;
@dynamic requestHeaders;
@dynamic requestHeadersText;
@dynamic connectionReused;
@dynamic connectionId;
@dynamic remoteIPAddress;
@dynamic remotePort;
@dynamic fromDiskCache;
@dynamic fromServiceWorker;
@dynamic encodedDataLength;
@dynamic timing;
@dynamic protocol;
 
@end

@implementation PDNetworkWebSocketRequest

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"headers",@"headers",
                    nil];
    });

    return mappings;
}

@dynamic headers;
 
@end

@implementation PDNetworkWebSocketResponse

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"status",@"status",
                    @"statusText",@"statusText",
                    @"headers",@"headers",
                    @"headersText",@"headersText",
                    @"requestHeaders",@"requestHeaders",
                    @"requestHeadersText",@"requestHeadersText",
                    nil];
    });

    return mappings;
}

@dynamic status;
@dynamic statusText;
@dynamic headers;
@dynamic headersText;
@dynamic requestHeaders;
@dynamic requestHeadersText;
 
@end

@implementation PDNetworkWebSocketFrame

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"opcode",@"opcode",
                    @"mask",@"mask",
                    @"payloadData",@"payloadData",
                    nil];
    });

    return mappings;
}

@dynamic opcode;
@dynamic mask;
@dynamic payloadData;
 
@end

@implementation PDNetworkCachedResource

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"url",@"url",
                    @"type",@"type",
                    @"response",@"response",
                    @"bodySize",@"bodySize",
                    nil];
    });

    return mappings;
}

@dynamic url;
@dynamic type;
@dynamic response;
@dynamic bodySize;
 
@end

@implementation PDNetworkInitiator

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"type",@"type",
                    @"stackTrace",@"stackTrace",
                    @"url",@"url",
                    @"lineNumber",@"lineNumber",
                    @"asyncStackTrace",@"asyncStackTrace",
                    nil];
    });

    return mappings;
}

@dynamic type;
@dynamic stackTrace;
@dynamic url;
@dynamic lineNumber;
@dynamic asyncStackTrace;
 
@end

@implementation PDNetworkCookie

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"name",@"name",
                    @"value",@"value",
                    @"domain",@"domain",
                    @"path",@"path",
                    @"expires",@"expires",
                    @"size",@"size",
                    @"httpOnly",@"httpOnly",
                    @"secure",@"secure",
                    @"session",@"session",
                    nil];
    });

    return mappings;
}

@dynamic name;
@dynamic value;
@dynamic domain;
@dynamic path;
@dynamic expires;
@dynamic size;
@dynamic httpOnly;
@dynamic secure;
@dynamic session;
 
@end

