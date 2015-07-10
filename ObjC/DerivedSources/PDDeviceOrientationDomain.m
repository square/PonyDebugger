//
//  PDDeviceOrientationDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDeviceOrientationDomain.h>
#import <PonyDebugger/PDObject.h>


@interface PDDeviceOrientationDomain ()
//Commands

@end

@implementation PDDeviceOrientationDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"DeviceOrientation";
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"setDeviceOrientationOverride"] && [self.delegate respondsToSelector:@selector(domain:setDeviceOrientationOverrideWithAlpha:beta:gamma:callback:)]) {
        [self.delegate domain:self setDeviceOrientationOverrideWithAlpha:[params objectForKey:@"alpha"] beta:[params objectForKey:@"beta"] gamma:[params objectForKey:@"gamma"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"clearDeviceOrientationOverride"] && [self.delegate respondsToSelector:@selector(domain:clearDeviceOrientationOverrideWithCallback:)]) {
        [self.delegate domain:self clearDeviceOrientationOverrideWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDDeviceOrientationDomain)

- (PDDeviceOrientationDomain *)deviceOrientationDomain;
{
    return [self domainForName:@"DeviceOrientation"];
}

@end
