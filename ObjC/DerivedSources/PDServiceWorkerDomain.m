//
//  PDServiceWorkerDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDServiceWorkerDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDServiceWorkerTypes.h>


@interface PDServiceWorkerDomain ()
//Commands

@end

@implementation PDServiceWorkerDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"ServiceWorker";
}

// Events
- (void)workerCreatedWithWorkerId:(NSString *)workerId url:(NSString *)url;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (workerId != nil) {
        [params setObject:[workerId PD_JSONObject] forKey:@"workerId"];
    }
    if (url != nil) {
        [params setObject:[url PD_JSONObject] forKey:@"url"];
    }
    
    [self.debuggingServer sendEventWithName:@"ServiceWorker.workerCreated" parameters:params];
}
- (void)workerTerminatedWithWorkerId:(NSString *)workerId;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (workerId != nil) {
        [params setObject:[workerId PD_JSONObject] forKey:@"workerId"];
    }
    
    [self.debuggingServer sendEventWithName:@"ServiceWorker.workerTerminated" parameters:params];
}
- (void)dispatchMessageWithWorkerId:(NSString *)workerId message:(NSString *)message;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (workerId != nil) {
        [params setObject:[workerId PD_JSONObject] forKey:@"workerId"];
    }
    if (message != nil) {
        [params setObject:[message PD_JSONObject] forKey:@"message"];
    }
    
    [self.debuggingServer sendEventWithName:@"ServiceWorker.dispatchMessage" parameters:params];
}
- (void)workerRegistrationUpdatedWithRegistrations:(NSArray *)registrations;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (registrations != nil) {
        [params setObject:[registrations PD_JSONObject] forKey:@"registrations"];
    }
    
    [self.debuggingServer sendEventWithName:@"ServiceWorker.workerRegistrationUpdated" parameters:params];
}
- (void)workerVersionUpdatedWithVersions:(NSArray *)versions;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (versions != nil) {
        [params setObject:[versions PD_JSONObject] forKey:@"versions"];
    }
    
    [self.debuggingServer sendEventWithName:@"ServiceWorker.workerVersionUpdated" parameters:params];
}
- (void)workerErrorReportedWithErrorMessage:(PDServiceWorkerServiceWorkerErrorMessage *)errorMessage;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (errorMessage != nil) {
        [params setObject:[errorMessage PD_JSONObject] forKey:@"errorMessage"];
    }
    
    [self.debuggingServer sendEventWithName:@"ServiceWorker.workerErrorReported" parameters:params];
}
- (void)debugOnStartUpdatedWithDebugOnStart:(NSNumber *)debugOnStart;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (debugOnStart != nil) {
        [params setObject:[debugOnStart PD_JSONObject] forKey:@"debugOnStart"];
    }
    
    [self.debuggingServer sendEventWithName:@"ServiceWorker.debugOnStartUpdated" parameters:params];
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
    } else if ([methodName isEqualToString:@"sendMessage"] && [self.delegate respondsToSelector:@selector(domain:sendMessageWithWorkerId:message:callback:)]) {
        [self.delegate domain:self sendMessageWithWorkerId:[params objectForKey:@"workerId"] message:[params objectForKey:@"message"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"stop"] && [self.delegate respondsToSelector:@selector(domain:stopWithWorkerId:callback:)]) {
        [self.delegate domain:self stopWithWorkerId:[params objectForKey:@"workerId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"unregister"] && [self.delegate respondsToSelector:@selector(domain:unregisterWithScopeURL:callback:)]) {
        [self.delegate domain:self unregisterWithScopeURL:[params objectForKey:@"scopeURL"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"updateRegistration"] && [self.delegate respondsToSelector:@selector(domain:updateRegistrationWithScopeURL:callback:)]) {
        [self.delegate domain:self updateRegistrationWithScopeURL:[params objectForKey:@"scopeURL"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"startWorker"] && [self.delegate respondsToSelector:@selector(domain:startWorkerWithScopeURL:callback:)]) {
        [self.delegate domain:self startWorkerWithScopeURL:[params objectForKey:@"scopeURL"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"stopWorker"] && [self.delegate respondsToSelector:@selector(domain:stopWorkerWithVersionId:callback:)]) {
        [self.delegate domain:self stopWorkerWithVersionId:[params objectForKey:@"versionId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"inspectWorker"] && [self.delegate respondsToSelector:@selector(domain:inspectWorkerWithVersionId:callback:)]) {
        [self.delegate domain:self inspectWorkerWithVersionId:[params objectForKey:@"versionId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"skipWaiting"] && [self.delegate respondsToSelector:@selector(domain:skipWaitingWithVersionId:callback:)]) {
        [self.delegate domain:self skipWaitingWithVersionId:[params objectForKey:@"versionId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setDebugOnStart"] && [self.delegate respondsToSelector:@selector(domain:setDebugOnStartWithDebugOnStart:callback:)]) {
        [self.delegate domain:self setDebugOnStartWithDebugOnStart:[params objectForKey:@"debugOnStart"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"deliverPushMessage"] && [self.delegate respondsToSelector:@selector(domain:deliverPushMessageWithOrigin:registrationId:data:callback:)]) {
        [self.delegate domain:self deliverPushMessageWithOrigin:[params objectForKey:@"origin"] registrationId:[params objectForKey:@"registrationId"] data:[params objectForKey:@"data"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getTargetInfo"] && [self.delegate respondsToSelector:@selector(domain:getTargetInfoWithTargetId:callback:)]) {
        [self.delegate domain:self getTargetInfoWithTargetId:[params objectForKey:@"targetId"] callback:^(PDServiceWorkerTargetInfo *targetInfo, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (targetInfo != nil) {
                [params setObject:targetInfo forKey:@"targetInfo"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"activateTarget"] && [self.delegate respondsToSelector:@selector(domain:activateTargetWithTargetId:callback:)]) {
        [self.delegate domain:self activateTargetWithTargetId:[params objectForKey:@"targetId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDServiceWorkerDomain)

- (PDServiceWorkerDomain *)serviceWorkerDomain;
{
    return [self domainForName:@"ServiceWorker"];
}

@end
