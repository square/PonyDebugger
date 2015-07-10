//
//  PDAnimationDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDAnimationDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDAnimationTypes.h>


@interface PDAnimationDomain ()
//Commands

@end

@implementation PDAnimationDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Animation";
}

// Events

// Event for each animation player that has been created.
- (void)animationCreatedWithPlayer:(PDAnimationAnimation *)player resetTimeline:(NSNumber *)resetTimeline;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (player != nil) {
        [params setObject:[player PD_JSONObject] forKey:@"player"];
    }
    if (resetTimeline != nil) {
        [params setObject:[resetTimeline PD_JSONObject] forKey:@"resetTimeline"];
    }
    
    [self.debuggingServer sendEventWithName:@"Animation.animationCreated" parameters:params];
}

// Event for Animations in the frontend that have been cancelled.
- (void)animationCanceledWithId:(NSString *)identifier;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (identifier != nil) {
        [params setObject:[identifier PD_JSONObject] forKey:@"id"];
    }
    
    [self.debuggingServer sendEventWithName:@"Animation.animationCanceled" parameters:params];
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
    } else if ([methodName isEqualToString:@"getPlaybackRate"] && [self.delegate respondsToSelector:@selector(domain:getPlaybackRateWithCallback:)]) {
        [self.delegate domain:self getPlaybackRateWithCallback:^(NSNumber *playbackRate, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (playbackRate != nil) {
                [params setObject:playbackRate forKey:@"playbackRate"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setPlaybackRate"] && [self.delegate respondsToSelector:@selector(domain:setPlaybackRateWithPlaybackRate:callback:)]) {
        [self.delegate domain:self setPlaybackRateWithPlaybackRate:[params objectForKey:@"playbackRate"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setCurrentTime"] && [self.delegate respondsToSelector:@selector(domain:setCurrentTimeWithCurrentTime:callback:)]) {
        [self.delegate domain:self setCurrentTimeWithCurrentTime:[params objectForKey:@"currentTime"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setTiming"] && [self.delegate respondsToSelector:@selector(domain:setTimingWithPlayerId:duration:delay:callback:)]) {
        [self.delegate domain:self setTimingWithPlayerId:[params objectForKey:@"playerId"] duration:[params objectForKey:@"duration"] delay:[params objectForKey:@"delay"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDAnimationDomain)

- (PDAnimationDomain *)animationDomain;
{
    return [self domainForName:@"Animation"];
}

@end
