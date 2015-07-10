//
//  PDMemoryDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDMemoryDomain.h>
#import <PonyDebugger/PDObject.h>


@interface PDMemoryDomain ()
//Commands

@end

@implementation PDMemoryDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Memory";
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"getDOMCounters"] && [self.delegate respondsToSelector:@selector(domain:getDOMCountersWithCallback:)]) {
        [self.delegate domain:self getDOMCountersWithCallback:^(NSNumber *documents, NSNumber *nodes, NSNumber *jsEventListeners, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];

            if (documents != nil) {
                [params setObject:documents forKey:@"documents"];
            }
            if (nodes != nil) {
                [params setObject:nodes forKey:@"nodes"];
            }
            if (jsEventListeners != nil) {
                [params setObject:jsEventListeners forKey:@"jsEventListeners"];
            }

            responseCallback(params, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDMemoryDomain)

- (PDMemoryDomain *)memoryDomain;
{
    return [self domainForName:@"Memory"];
}

@end
