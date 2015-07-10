//
//  PDServiceWorkerDomain.h
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

@class PDServiceWorkerServiceWorkerErrorMessage;
@class PDServiceWorkerTargetInfo;

@protocol PDServiceWorkerCommandDelegate;

@interface PDServiceWorkerDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDServiceWorkerCommandDelegate, PDCommandDelegate> delegate;

// Events
- (void)workerCreatedWithWorkerId:(NSString *)workerId url:(NSString *)url;
- (void)workerTerminatedWithWorkerId:(NSString *)workerId;
- (void)dispatchMessageWithWorkerId:(NSString *)workerId message:(NSString *)message;
- (void)workerRegistrationUpdatedWithRegistrations:(NSArray *)registrations;
- (void)workerVersionUpdatedWithVersions:(NSArray *)versions;
- (void)workerErrorReportedWithErrorMessage:(PDServiceWorkerServiceWorkerErrorMessage *)errorMessage;
- (void)debugOnStartUpdatedWithDebugOnStart:(NSNumber *)debugOnStart;

@end

@protocol PDServiceWorkerCommandDelegate <PDCommandDelegate>
@optional
- (void)domain:(PDServiceWorkerDomain *)domain enableWithCallback:(void (^)(id error))callback;
- (void)domain:(PDServiceWorkerDomain *)domain disableWithCallback:(void (^)(id error))callback;
- (void)domain:(PDServiceWorkerDomain *)domain sendMessageWithWorkerId:(NSString *)workerId message:(NSString *)message callback:(void (^)(id error))callback;
- (void)domain:(PDServiceWorkerDomain *)domain stopWithWorkerId:(NSString *)workerId callback:(void (^)(id error))callback;
- (void)domain:(PDServiceWorkerDomain *)domain unregisterWithScopeURL:(NSString *)scopeURL callback:(void (^)(id error))callback;
- (void)domain:(PDServiceWorkerDomain *)domain updateRegistrationWithScopeURL:(NSString *)scopeURL callback:(void (^)(id error))callback;
- (void)domain:(PDServiceWorkerDomain *)domain startWorkerWithScopeURL:(NSString *)scopeURL callback:(void (^)(id error))callback;
- (void)domain:(PDServiceWorkerDomain *)domain stopWorkerWithVersionId:(NSString *)versionId callback:(void (^)(id error))callback;
- (void)domain:(PDServiceWorkerDomain *)domain inspectWorkerWithVersionId:(NSString *)versionId callback:(void (^)(id error))callback;
- (void)domain:(PDServiceWorkerDomain *)domain skipWaitingWithVersionId:(NSString *)versionId callback:(void (^)(id error))callback;
- (void)domain:(PDServiceWorkerDomain *)domain setDebugOnStartWithDebugOnStart:(NSNumber *)debugOnStart callback:(void (^)(id error))callback;
- (void)domain:(PDServiceWorkerDomain *)domain deliverPushMessageWithOrigin:(NSString *)origin registrationId:(NSString *)registrationId data:(NSString *)data callback:(void (^)(id error))callback;
- (void)domain:(PDServiceWorkerDomain *)domain getTargetInfoWithTargetId:(NSString *)targetId callback:(void (^)(PDServiceWorkerTargetInfo *targetInfo, id error))callback;
- (void)domain:(PDServiceWorkerDomain *)domain activateTargetWithTargetId:(NSString *)targetId callback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDServiceWorkerDomain)

@property (nonatomic, readonly, strong) PDServiceWorkerDomain *serviceWorkerDomain;

@end
