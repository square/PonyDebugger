//
//  PDTracingDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDTracingDomain.h>
#import <PonyDebugger/PDObject.h>


@interface PDTracingDomain ()
//Commands

@end

@implementation PDTracingDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Tracing";
}

// Events

// Contains an bucket of collected trace events. When tracing is stopped collected events will be send as a sequence of dataCollected events followed by tracingComplete event.
- (void)dataCollectedWithValue:(NSArray *)value;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (value != nil) {
        [params setObject:[value PD_JSONObject] forKey:@"value"];
    }
    
    [self.debuggingServer sendEventWithName:@"Tracing.dataCollected" parameters:params];
}

// Signals that tracing is stopped and there is no trace buffers pending flush, all data were delivered via dataCollected events.
- (void)tracingComplete;
{
    [self.debuggingServer sendEventWithName:@"Tracing.tracingComplete" parameters:nil];
}
- (void)bufferUsageWithPercentFull:(NSNumber *)percentFull eventCount:(NSNumber *)eventCount value:(NSNumber *)value;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];

    if (percentFull != nil) {
        [params setObject:[percentFull PD_JSONObject] forKey:@"percentFull"];
    }
    if (eventCount != nil) {
        [params setObject:[eventCount PD_JSONObject] forKey:@"eventCount"];
    }
    if (value != nil) {
        [params setObject:[value PD_JSONObject] forKey:@"value"];
    }
    
    [self.debuggingServer sendEventWithName:@"Tracing.bufferUsage" parameters:params];
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"start"] && [self.delegate respondsToSelector:@selector(domain:startWithCategories:options:bufferUsageReportingInterval:callback:)]) {
        [self.delegate domain:self startWithCategories:[params objectForKey:@"categories"] options:[params objectForKey:@"options"] bufferUsageReportingInterval:[params objectForKey:@"bufferUsageReportingInterval"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"end"] && [self.delegate respondsToSelector:@selector(domain:endWithCallback:)]) {
        [self.delegate domain:self endWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getCategories"] && [self.delegate respondsToSelector:@selector(domain:getCategoriesWithCallback:)]) {
        [self.delegate domain:self getCategoriesWithCallback:^(NSArray *categories, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (categories != nil) {
                [params setObject:categories forKey:@"categories"];
            }

            responseCallback(params, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDTracingDomain)

- (PDTracingDomain *)tracingDomain;
{
    return [self domainForName:@"Tracing"];
}

@end
