//
//  PDRenderingDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDRenderingDomain.h>
#import <PonyDebugger/PDObject.h>


@interface PDRenderingDomain ()
//Commands

@end

@implementation PDRenderingDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Rendering";
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"setShowPaintRects"] && [self.delegate respondsToSelector:@selector(domain:setShowPaintRectsWithResult:callback:)]) {
        [self.delegate domain:self setShowPaintRectsWithResult:[params objectForKey:@"result"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setShowDebugBorders"] && [self.delegate respondsToSelector:@selector(domain:setShowDebugBordersWithShow:callback:)]) {
        [self.delegate domain:self setShowDebugBordersWithShow:[params objectForKey:@"show"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setShowFPSCounter"] && [self.delegate respondsToSelector:@selector(domain:setShowFPSCounterWithShow:callback:)]) {
        [self.delegate domain:self setShowFPSCounterWithShow:[params objectForKey:@"show"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setContinuousPaintingEnabled"] && [self.delegate respondsToSelector:@selector(domain:setContinuousPaintingEnabledWithEnabled:callback:)]) {
        [self.delegate domain:self setContinuousPaintingEnabledWithEnabled:[params objectForKey:@"enabled"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setShowScrollBottleneckRects"] && [self.delegate respondsToSelector:@selector(domain:setShowScrollBottleneckRectsWithShow:callback:)]) {
        [self.delegate domain:self setShowScrollBottleneckRectsWithShow:[params objectForKey:@"show"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDRenderingDomain)

- (PDRenderingDomain *)renderingDomain;
{
    return [self domainForName:@"Rendering"];
}

@end
