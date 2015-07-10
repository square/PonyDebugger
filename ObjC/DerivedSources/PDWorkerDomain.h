//
//  PDWorkerDomain.h
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


@protocol PDWorkerCommandDelegate;

@interface PDWorkerDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDWorkerCommandDelegate, PDCommandDelegate> delegate;

// Events
- (void)workerCreatedWithWorkerId:(NSString *)workerId url:(NSString *)url inspectorConnected:(NSNumber *)inspectorConnected;
- (void)workerTerminatedWithWorkerId:(NSString *)workerId;
- (void)dispatchMessageFromWorkerWithWorkerId:(NSString *)workerId message:(NSString *)message;

@end

@protocol PDWorkerCommandDelegate <PDCommandDelegate>
@optional
- (void)domain:(PDWorkerDomain *)domain enableWithCallback:(void (^)(id error))callback;
- (void)domain:(PDWorkerDomain *)domain disableWithCallback:(void (^)(id error))callback;
- (void)domain:(PDWorkerDomain *)domain sendMessageToWorkerWithWorkerId:(NSString *)workerId message:(NSString *)message callback:(void (^)(id error))callback;
- (void)domain:(PDWorkerDomain *)domain connectToWorkerWithWorkerId:(NSString *)workerId callback:(void (^)(id error))callback;
- (void)domain:(PDWorkerDomain *)domain disconnectFromWorkerWithWorkerId:(NSString *)workerId callback:(void (^)(id error))callback;
- (void)domain:(PDWorkerDomain *)domain setAutoconnectToWorkersWithValue:(NSNumber *)value callback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDWorkerDomain)

@property (nonatomic, readonly, strong) PDWorkerDomain *workerDomain;

@end
