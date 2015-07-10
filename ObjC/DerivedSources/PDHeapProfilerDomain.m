//
//  PDHeapProfilerDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDHeapProfilerDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDRuntimeTypes.h>


@interface PDHeapProfilerDomain ()
//Commands

@end

@implementation PDHeapProfilerDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"HeapProfiler";
}

// Events
- (void)addHeapSnapshotChunkWithChunk:(NSString *)chunk;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (chunk != nil) {
        [params setObject:[chunk PD_JSONObject] forKey:@"chunk"];
    }
    
    [self.debuggingServer sendEventWithName:@"HeapProfiler.addHeapSnapshotChunk" parameters:params];
}
- (void)resetProfiles;
{
    [self.debuggingServer sendEventWithName:@"HeapProfiler.resetProfiles" parameters:nil];
}
- (void)reportHeapSnapshotProgressWithDone:(NSNumber *)done total:(NSNumber *)total finished:(NSNumber *)finished;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];

    if (done != nil) {
        [params setObject:[done PD_JSONObject] forKey:@"done"];
    }
    if (total != nil) {
        [params setObject:[total PD_JSONObject] forKey:@"total"];
    }
    if (finished != nil) {
        [params setObject:[finished PD_JSONObject] forKey:@"finished"];
    }
    
    [self.debuggingServer sendEventWithName:@"HeapProfiler.reportHeapSnapshotProgress" parameters:params];
}

// If heap objects tracking has been started then backend regulary sends a current value for last seen object id and corresponding timestamp. If the were changes in the heap since last event then one or more heapStatsUpdate events will be sent before a new lastSeenObjectId event.
- (void)lastSeenObjectIdWithLastSeenObjectId:(NSNumber *)lastSeenObjectId timestamp:(NSNumber *)timestamp;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (lastSeenObjectId != nil) {
        [params setObject:[lastSeenObjectId PD_JSONObject] forKey:@"lastSeenObjectId"];
    }
    if (timestamp != nil) {
        [params setObject:[timestamp PD_JSONObject] forKey:@"timestamp"];
    }
    
    [self.debuggingServer sendEventWithName:@"HeapProfiler.lastSeenObjectId" parameters:params];
}

// If heap objects tracking has been started then backend may send update for one or more fragments
- (void)heapStatsUpdateWithStatsUpdate:(NSArray *)statsUpdate;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (statsUpdate != nil) {
        [params setObject:[statsUpdate PD_JSONObject] forKey:@"statsUpdate"];
    }
    
    [self.debuggingServer sendEventWithName:@"HeapProfiler.heapStatsUpdate" parameters:params];
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
    } else if ([methodName isEqualToString:@"startTrackingHeapObjects"] && [self.delegate respondsToSelector:@selector(domain:startTrackingHeapObjectsWithTrackAllocations:callback:)]) {
        [self.delegate domain:self startTrackingHeapObjectsWithTrackAllocations:[params objectForKey:@"trackAllocations"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"stopTrackingHeapObjects"] && [self.delegate respondsToSelector:@selector(domain:stopTrackingHeapObjectsWithReportProgress:callback:)]) {
        [self.delegate domain:self stopTrackingHeapObjectsWithReportProgress:[params objectForKey:@"reportProgress"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"takeHeapSnapshot"] && [self.delegate respondsToSelector:@selector(domain:takeHeapSnapshotWithReportProgress:callback:)]) {
        [self.delegate domain:self takeHeapSnapshotWithReportProgress:[params objectForKey:@"reportProgress"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"collectGarbage"] && [self.delegate respondsToSelector:@selector(domain:collectGarbageWithCallback:)]) {
        [self.delegate domain:self collectGarbageWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getObjectByHeapObjectId"] && [self.delegate respondsToSelector:@selector(domain:getObjectByHeapObjectIdWithObjectId:objectGroup:callback:)]) {
        [self.delegate domain:self getObjectByHeapObjectIdWithObjectId:[params objectForKey:@"objectId"] objectGroup:[params objectForKey:@"objectGroup"] callback:^(PDRuntimeRemoteObject *result, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (result != nil) {
                [params setObject:result forKey:@"result"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"addInspectedHeapObject"] && [self.delegate respondsToSelector:@selector(domain:addInspectedHeapObjectWithHeapObjectId:callback:)]) {
        [self.delegate domain:self addInspectedHeapObjectWithHeapObjectId:[params objectForKey:@"heapObjectId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getHeapObjectId"] && [self.delegate respondsToSelector:@selector(domain:getHeapObjectIdWithObjectId:callback:)]) {
        [self.delegate domain:self getHeapObjectIdWithObjectId:[params objectForKey:@"objectId"] callback:^(NSString *heapSnapshotObjectId, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (heapSnapshotObjectId != nil) {
                [params setObject:heapSnapshotObjectId forKey:@"heapSnapshotObjectId"];
            }

            responseCallback(params, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDHeapProfilerDomain)

- (PDHeapProfilerDomain *)heapProfilerDomain;
{
    return [self domainForName:@"HeapProfiler"];
}

@end
