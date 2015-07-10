//
//  PDSecurityDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDSecurityDomain.h>
#import <PonyDebugger/PDObject.h>


@interface PDSecurityDomain ()
//Commands

@end

@implementation PDSecurityDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Security";
}

// Events

// The security state of the page changed.
- (void)securityStateChangedWithSecurityState:(NSString *)securityState explanations:(NSArray *)explanations;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (securityState != nil) {
        [params setObject:[securityState PD_JSONObject] forKey:@"securityState"];
    }
    if (explanations != nil) {
        [params setObject:[explanations PD_JSONObject] forKey:@"explanations"];
    }
    
    [self.debuggingServer sendEventWithName:@"Security.securityStateChanged" parameters:params];
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
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDSecurityDomain)

- (PDSecurityDomain *)securityDomain;
{
    return [self domainForName:@"Security"];
}

@end
