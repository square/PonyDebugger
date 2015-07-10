//
//  PDProfilerDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDProfilerDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebuggerTypes.h>
#import <PonyDebugger/PDProfilerTypes.h>


@interface PDProfilerDomain ()
//Commands

@end

@implementation PDProfilerDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Profiler";
}

// Events

// Sent when new profile recodring is started using console.profile() call.
- (void)consoleProfileStartedWithId:(NSString *)identifier location:(PDDebuggerLocation *)location title:(NSString *)title;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];

    if (identifier != nil) {
        [params setObject:[identifier PD_JSONObject] forKey:@"id"];
    }
    if (location != nil) {
        [params setObject:[location PD_JSONObject] forKey:@"location"];
    }
    if (title != nil) {
        [params setObject:[title PD_JSONObject] forKey:@"title"];
    }
    
    [self.debuggingServer sendEventWithName:@"Profiler.consoleProfileStarted" parameters:params];
}
- (void)consoleProfileFinishedWithId:(NSString *)identifier location:(PDDebuggerLocation *)location profile:(PDProfilerCPUProfile *)profile title:(NSString *)title;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:4];

    if (identifier != nil) {
        [params setObject:[identifier PD_JSONObject] forKey:@"id"];
    }
    if (location != nil) {
        [params setObject:[location PD_JSONObject] forKey:@"location"];
    }
    if (profile != nil) {
        [params setObject:[profile PD_JSONObject] forKey:@"profile"];
    }
    if (title != nil) {
        [params setObject:[title PD_JSONObject] forKey:@"title"];
    }
    
    [self.debuggingServer sendEventWithName:@"Profiler.consoleProfileFinished" parameters:params];
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
    } else if ([methodName isEqualToString:@"setSamplingInterval"] && [self.delegate respondsToSelector:@selector(domain:setSamplingIntervalWithInterval:callback:)]) {
        [self.delegate domain:self setSamplingIntervalWithInterval:[params objectForKey:@"interval"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"start"] && [self.delegate respondsToSelector:@selector(domain:startWithCallback:)]) {
        [self.delegate domain:self startWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"stop"] && [self.delegate respondsToSelector:@selector(domain:stopWithCallback:)]) {
        [self.delegate domain:self stopWithCallback:^(PDProfilerCPUProfile *profile, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (profile != nil) {
                [params setObject:profile forKey:@"profile"];
            }

            responseCallback(params, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDProfilerDomain)

- (PDProfilerDomain *)profilerDomain;
{
    return [self domainForName:@"Profiler"];
}

@end
