//
//  PDAccessibilityDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDAccessibilityDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDAccessibilityTypes.h>


@interface PDAccessibilityDomain ()
//Commands

@end

@implementation PDAccessibilityDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Accessibility";
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"getAXNode"] && [self.delegate respondsToSelector:@selector(domain:getAXNodeWithNodeId:callback:)]) {
        [self.delegate domain:self getAXNodeWithNodeId:[params objectForKey:@"nodeId"] callback:^(PDAccessibilityAXNode *accessibilityNode, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (accessibilityNode != nil) {
                [params setObject:accessibilityNode forKey:@"accessibilityNode"];
            }

            responseCallback(params, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDAccessibilityDomain)

- (PDAccessibilityDomain *)accessibilityDomain;
{
    return [self domainForName:@"Accessibility"];
}

@end
