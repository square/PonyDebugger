//
//  PDScreenOrientationDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDScreenOrientationDomain.h>
#import <PonyDebugger/PDObject.h>


@interface PDScreenOrientationDomain ()
//Commands

@end

@implementation PDScreenOrientationDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"ScreenOrientation";
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"setScreenOrientationOverride"] && [self.delegate respondsToSelector:@selector(domain:setScreenOrientationOverrideWithAngle:type:callback:)]) {
        [self.delegate domain:self setScreenOrientationOverrideWithAngle:[params objectForKey:@"angle"] type:[params objectForKey:@"type"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"clearScreenOrientationOverride"] && [self.delegate respondsToSelector:@selector(domain:clearScreenOrientationOverrideWithCallback:)]) {
        [self.delegate domain:self clearScreenOrientationOverrideWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDScreenOrientationDomain)

- (PDScreenOrientationDomain *)screenOrientationDomain;
{
    return [self domainForName:@"ScreenOrientation"];
}

@end
