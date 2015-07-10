//
//  PDTimelineDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDTimelineDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDTimelineTypes.h>


@interface PDTimelineDomain ()
//Commands

@end

@implementation PDTimelineDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Timeline";
}

// Events

// Deprecated.
- (void)eventRecordedWithRecord:(PDTimelineTimelineEvent *)record;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (record != nil) {
        [params setObject:[record PD_JSONObject] forKey:@"record"];
    }
    
    [self.debuggingServer sendEventWithName:@"Timeline.eventRecorded" parameters:params];
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
    } else if ([methodName isEqualToString:@"start"] && [self.delegate respondsToSelector:@selector(domain:startWithMaxCallStackDepth:bufferEvents:liveEvents:includeCounters:includeGPUEvents:callback:)]) {
        [self.delegate domain:self startWithMaxCallStackDepth:[params objectForKey:@"maxCallStackDepth"] bufferEvents:[params objectForKey:@"bufferEvents"] liveEvents:[params objectForKey:@"liveEvents"] includeCounters:[params objectForKey:@"includeCounters"] includeGPUEvents:[params objectForKey:@"includeGPUEvents"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"stop"] && [self.delegate respondsToSelector:@selector(domain:stopWithCallback:)]) {
        [self.delegate domain:self stopWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDTimelineDomain)

- (PDTimelineDomain *)timelineDomain;
{
    return [self domainForName:@"Timeline"];
}

@end
