//
//  PDDOMDebuggerDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDOMDebuggerDomain.h>
#import <PonyDebugger/PDObject.h>


@interface PDDOMDebuggerDomain ()
//Commands

@end

@implementation PDDOMDebuggerDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"DOMDebugger";
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"setDOMBreakpoint"] && [self.delegate respondsToSelector:@selector(domain:setDOMBreakpointWithNodeId:type:callback:)]) {
        [self.delegate domain:self setDOMBreakpointWithNodeId:[params objectForKey:@"nodeId"] type:[params objectForKey:@"type"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"removeDOMBreakpoint"] && [self.delegate respondsToSelector:@selector(domain:removeDOMBreakpointWithNodeId:type:callback:)]) {
        [self.delegate domain:self removeDOMBreakpointWithNodeId:[params objectForKey:@"nodeId"] type:[params objectForKey:@"type"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setEventListenerBreakpoint"] && [self.delegate respondsToSelector:@selector(domain:setEventListenerBreakpointWithEventName:targetName:callback:)]) {
        [self.delegate domain:self setEventListenerBreakpointWithEventName:[params objectForKey:@"eventName"] targetName:[params objectForKey:@"targetName"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"removeEventListenerBreakpoint"] && [self.delegate respondsToSelector:@selector(domain:removeEventListenerBreakpointWithEventName:targetName:callback:)]) {
        [self.delegate domain:self removeEventListenerBreakpointWithEventName:[params objectForKey:@"eventName"] targetName:[params objectForKey:@"targetName"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setInstrumentationBreakpoint"] && [self.delegate respondsToSelector:@selector(domain:setInstrumentationBreakpointWithEventName:callback:)]) {
        [self.delegate domain:self setInstrumentationBreakpointWithEventName:[params objectForKey:@"eventName"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"removeInstrumentationBreakpoint"] && [self.delegate respondsToSelector:@selector(domain:removeInstrumentationBreakpointWithEventName:callback:)]) {
        [self.delegate domain:self removeInstrumentationBreakpointWithEventName:[params objectForKey:@"eventName"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setXHRBreakpoint"] && [self.delegate respondsToSelector:@selector(domain:setXHRBreakpointWithUrl:callback:)]) {
        [self.delegate domain:self setXHRBreakpointWithUrl:[params objectForKey:@"url"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"removeXHRBreakpoint"] && [self.delegate respondsToSelector:@selector(domain:removeXHRBreakpointWithUrl:callback:)]) {
        [self.delegate domain:self removeXHRBreakpointWithUrl:[params objectForKey:@"url"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getEventListeners"] && [self.delegate respondsToSelector:@selector(domain:getEventListenersWithObjectId:callback:)]) {
        [self.delegate domain:self getEventListenersWithObjectId:[params objectForKey:@"objectId"] callback:^(NSArray *listeners, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (listeners != nil) {
                [params setObject:listeners forKey:@"listeners"];
            }

            responseCallback(params, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDDOMDebuggerDomain)

- (PDDOMDebuggerDomain *)DOMDebuggerDomain;
{
    return [self domainForName:@"DOMDebugger"];
}

@end
