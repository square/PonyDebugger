//
//  PDPowerDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDPowerDomain.h>
#import <PonyDebugger/PDObject.h>


@interface PDPowerDomain ()
//Commands

@end

@implementation PDPowerDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Power";
}

// Events
- (void)dataAvailableWithValue:(NSArray *)value;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (value != nil) {
        [params setObject:[value PD_JSONObject] forKey:@"value"];
    }
    
    [self.debuggingServer sendEventWithName:@"Power.dataAvailable" parameters:params];
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"start"] && [self.delegate respondsToSelector:@selector(domain:startWithCallback:)]) {
        [self.delegate domain:self startWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"end"] && [self.delegate respondsToSelector:@selector(domain:endWithCallback:)]) {
        [self.delegate domain:self endWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"canProfilePower"] && [self.delegate respondsToSelector:@selector(domain:canProfilePowerWithCallback:)]) {
        [self.delegate domain:self canProfilePowerWithCallback:^(NSNumber *result, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (result != nil) {
                [params setObject:result forKey:@"result"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getAccuracyLevel"] && [self.delegate respondsToSelector:@selector(domain:getAccuracyLevelWithCallback:)]) {
        [self.delegate domain:self getAccuracyLevelWithCallback:^(NSString *result, id error) {
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


@implementation PDDebugger (PDPowerDomain)

- (PDPowerDomain *)powerDomain;
{
    return [self domainForName:@"Power"];
}

@end
