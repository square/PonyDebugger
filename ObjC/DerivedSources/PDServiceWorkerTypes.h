//    
//  PDServiceWorkerTypes.h
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


/// ServiceWorker registration.
@interface PDServiceWorkerServiceWorkerRegistration : PDObject

/// Type: string
@property (nonatomic, strong) NSString *registrationId;

/// Type: string
@property (nonatomic, strong) NSString *scopeURL;

/// Type: boolean
@property (nonatomic, strong) NSNumber *isDeleted;

@end


/// ServiceWorker version.
@interface PDServiceWorkerServiceWorkerVersion : PDObject

/// Type: string
@property (nonatomic, strong) NSString *versionId;

/// Type: string
@property (nonatomic, strong) NSString *registrationId;

/// Type: string
@property (nonatomic, strong) NSString *scriptURL;

@property (nonatomic, strong) NSString *runningStatus;

@property (nonatomic, strong) NSString *status;

/// The Last-Modified header value of the main script.
/// Type: number
@property (nonatomic, strong) NSNumber *scriptLastModified;

/// The time at which the response headers of the main script were received from the server.  For cached script it is the last time the cache entry was validated.
/// Type: number
@property (nonatomic, strong) NSNumber *scriptResponseTime;

/// Type: array
@property (nonatomic, strong) NSArray *controlledClients;

@end


/// ServiceWorker error message.
@interface PDServiceWorkerServiceWorkerErrorMessage : PDObject

/// Type: string
@property (nonatomic, strong) NSString *errorMessage;

/// Type: string
@property (nonatomic, strong) NSString *registrationId;

/// Type: string
@property (nonatomic, strong) NSString *versionId;

/// Type: string
@property (nonatomic, strong) NSString *sourceURL;

/// Type: integer
@property (nonatomic, strong) NSNumber *lineNumber;

/// Type: integer
@property (nonatomic, strong) NSNumber *columnNumber;

@end


@interface PDServiceWorkerTargetInfo : PDObject

@property (nonatomic, strong) NSString *identifier;

/// Type: string
@property (nonatomic, strong) NSString *type;

/// Type: string
@property (nonatomic, strong) NSString *title;

/// Type: string
@property (nonatomic, strong) NSString *url;

@end


