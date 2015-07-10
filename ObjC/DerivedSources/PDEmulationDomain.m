//
//  PDEmulationDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDEmulationDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDEmulationTypes.h>


@interface PDEmulationDomain ()
//Commands

@end

@implementation PDEmulationDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Emulation";
}

// Events

// Fired when a visible page viewport has changed. Only fired when device metrics are overridden.
- (void)viewportChangedWithViewport:(PDEmulationViewport *)viewport;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (viewport != nil) {
        [params setObject:[viewport PD_JSONObject] forKey:@"viewport"];
    }
    
    [self.debuggingServer sendEventWithName:@"Emulation.viewportChanged" parameters:params];
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"setDeviceMetricsOverride"] && [self.delegate respondsToSelector:@selector(domain:setDeviceMetricsOverrideWithWidth:height:deviceScaleFactor:mobile:fitWindow:scale:offsetX:offsetY:screenWidth:screenHeight:positionX:positionY:callback:)]) {
        [self.delegate domain:self setDeviceMetricsOverrideWithWidth:[params objectForKey:@"width"] height:[params objectForKey:@"height"] deviceScaleFactor:[params objectForKey:@"deviceScaleFactor"] mobile:[params objectForKey:@"mobile"] fitWindow:[params objectForKey:@"fitWindow"] scale:[params objectForKey:@"scale"] offsetX:[params objectForKey:@"offsetX"] offsetY:[params objectForKey:@"offsetY"] screenWidth:[params objectForKey:@"screenWidth"] screenHeight:[params objectForKey:@"screenHeight"] positionX:[params objectForKey:@"positionX"] positionY:[params objectForKey:@"positionY"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"clearDeviceMetricsOverride"] && [self.delegate respondsToSelector:@selector(domain:clearDeviceMetricsOverrideWithCallback:)]) {
        [self.delegate domain:self clearDeviceMetricsOverrideWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"resetScrollAndPageScaleFactor"] && [self.delegate respondsToSelector:@selector(domain:resetScrollAndPageScaleFactorWithCallback:)]) {
        [self.delegate domain:self resetScrollAndPageScaleFactorWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setPageScaleFactor"] && [self.delegate respondsToSelector:@selector(domain:setPageScaleFactorWithPageScaleFactor:callback:)]) {
        [self.delegate domain:self setPageScaleFactorWithPageScaleFactor:[params objectForKey:@"pageScaleFactor"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setScriptExecutionDisabled"] && [self.delegate respondsToSelector:@selector(domain:setScriptExecutionDisabledWithValue:callback:)]) {
        [self.delegate domain:self setScriptExecutionDisabledWithValue:[params objectForKey:@"value"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setGeolocationOverride"] && [self.delegate respondsToSelector:@selector(domain:setGeolocationOverrideWithLatitude:longitude:accuracy:callback:)]) {
        [self.delegate domain:self setGeolocationOverrideWithLatitude:[params objectForKey:@"latitude"] longitude:[params objectForKey:@"longitude"] accuracy:[params objectForKey:@"accuracy"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"clearGeolocationOverride"] && [self.delegate respondsToSelector:@selector(domain:clearGeolocationOverrideWithCallback:)]) {
        [self.delegate domain:self clearGeolocationOverrideWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setTouchEmulationEnabled"] && [self.delegate respondsToSelector:@selector(domain:setTouchEmulationEnabledWithEnabled:configuration:callback:)]) {
        [self.delegate domain:self setTouchEmulationEnabledWithEnabled:[params objectForKey:@"enabled"] configuration:[params objectForKey:@"configuration"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setEmulatedMedia"] && [self.delegate respondsToSelector:@selector(domain:setEmulatedMediaWithMedia:callback:)]) {
        [self.delegate domain:self setEmulatedMediaWithMedia:[params objectForKey:@"media"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"canEmulate"] && [self.delegate respondsToSelector:@selector(domain:canEmulateWithCallback:)]) {
        [self.delegate domain:self canEmulateWithCallback:^(NSNumber *result, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (result != nil) {
                [params setObject:result forKey:@"result"];
            }

            responseCallback(params, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDEmulationDomain)

- (PDEmulationDomain *)emulationDomain;
{
    return [self domainForName:@"Emulation"];
}

@end
