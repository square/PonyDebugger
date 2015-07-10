//
//  PDLayerTreeDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDLayerTreeDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDOMTypes.h>


@interface PDLayerTreeDomain ()
//Commands

@end

@implementation PDLayerTreeDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"LayerTree";
}

// Events
- (void)layerTreeDidChangeWithLayers:(NSArray *)layers;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (layers != nil) {
        [params setObject:[layers PD_JSONObject] forKey:@"layers"];
    }
    
    [self.debuggingServer sendEventWithName:@"LayerTree.layerTreeDidChange" parameters:params];
}
- (void)layerPaintedWithLayerId:(NSString *)layerId clip:(PDDOMRect *)clip;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (layerId != nil) {
        [params setObject:[layerId PD_JSONObject] forKey:@"layerId"];
    }
    if (clip != nil) {
        [params setObject:[clip PD_JSONObject] forKey:@"clip"];
    }
    
    [self.debuggingServer sendEventWithName:@"LayerTree.layerPainted" parameters:params];
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
    } else if ([methodName isEqualToString:@"compositingReasons"] && [self.delegate respondsToSelector:@selector(domain:compositingReasonsWithLayerId:callback:)]) {
        [self.delegate domain:self compositingReasonsWithLayerId:[params objectForKey:@"layerId"] callback:^(NSArray *compositingReasons, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (compositingReasons != nil) {
                [params setObject:compositingReasons forKey:@"compositingReasons"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"makeSnapshot"] && [self.delegate respondsToSelector:@selector(domain:makeSnapshotWithLayerId:callback:)]) {
        [self.delegate domain:self makeSnapshotWithLayerId:[params objectForKey:@"layerId"] callback:^(NSString *snapshotId, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (snapshotId != nil) {
                [params setObject:snapshotId forKey:@"snapshotId"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"loadSnapshot"] && [self.delegate respondsToSelector:@selector(domain:loadSnapshotWithTiles:callback:)]) {
        [self.delegate domain:self loadSnapshotWithTiles:[params objectForKey:@"tiles"] callback:^(NSString *snapshotId, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (snapshotId != nil) {
                [params setObject:snapshotId forKey:@"snapshotId"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"releaseSnapshot"] && [self.delegate respondsToSelector:@selector(domain:releaseSnapshotWithSnapshotId:callback:)]) {
        [self.delegate domain:self releaseSnapshotWithSnapshotId:[params objectForKey:@"snapshotId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"profileSnapshot"] && [self.delegate respondsToSelector:@selector(domain:profileSnapshotWithSnapshotId:minRepeatCount:minDuration:clipRect:callback:)]) {
        [self.delegate domain:self profileSnapshotWithSnapshotId:[params objectForKey:@"snapshotId"] minRepeatCount:[params objectForKey:@"minRepeatCount"] minDuration:[params objectForKey:@"minDuration"] clipRect:[params objectForKey:@"clipRect"] callback:^(NSArray *timings, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (timings != nil) {
                [params setObject:timings forKey:@"timings"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"replaySnapshot"] && [self.delegate respondsToSelector:@selector(domain:replaySnapshotWithSnapshotId:fromStep:toStep:scale:callback:)]) {
        [self.delegate domain:self replaySnapshotWithSnapshotId:[params objectForKey:@"snapshotId"] fromStep:[params objectForKey:@"fromStep"] toStep:[params objectForKey:@"toStep"] scale:[params objectForKey:@"scale"] callback:^(NSString *dataURL, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (dataURL != nil) {
                [params setObject:dataURL forKey:@"dataURL"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"snapshotCommandLog"] && [self.delegate respondsToSelector:@selector(domain:snapshotCommandLogWithSnapshotId:callback:)]) {
        [self.delegate domain:self snapshotCommandLogWithSnapshotId:[params objectForKey:@"snapshotId"] callback:^(NSArray *commandLog, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (commandLog != nil) {
                [params setObject:commandLog forKey:@"commandLog"];
            }

            responseCallback(params, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDLayerTreeDomain)

- (PDLayerTreeDomain *)layerTreeDomain;
{
    return [self domainForName:@"LayerTree"];
}

@end
