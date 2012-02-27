#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDTimelineDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDTimelineTypes.h>


@interface PDTimelineDomain ()
//Commands

@end

@implementation PDTimelineDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Timeline";
}


// Events

// Fired for every instrumentation event while timeline is started.
- (void)eventRecordedWithRecord:(PDTimelineTimelineEvent *)record;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (record != nil) {
        [params setObject:[record PD_JSONObject] forKey:@"record"];
    }
    
    [self.debuggingServer sendEventWithName:@"Timeline.eventRecorded" parameters:params];
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"start"] && [self.delegate respondsToSelector:@selector(domain:startWithMaxCallStackDepth:callback:)]) {
        [self.delegate domain:self startWithMaxCallStackDepth:[params objectForKey:@"maxCallStackDepth"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"stop"] && [self.delegate respondsToSelector:@selector(domain:stopWithCallback:)]) {
        [self.delegate domain:self stopWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setIncludeMemoryDetails"] && [self.delegate respondsToSelector:@selector(domain:setIncludeMemoryDetailsWithEnabled:callback:)]) {
        [self.delegate domain:self setIncludeMemoryDetailsWithEnabled:[params objectForKey:@"enabled"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDTimelineDomain)

- (PDTimelineDomain *)timelineDomain;
{
    return [self domainForName:@"Timeline"];
}

@end
