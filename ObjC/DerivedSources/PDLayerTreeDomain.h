//
//  PDLayerTreeDomain.h
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>

@class PDDOMRect;

@protocol PDLayerTreeCommandDelegate;

@interface PDLayerTreeDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDLayerTreeCommandDelegate, PDCommandDelegate> delegate;

// Events
// Param layers: Layer tree, absent if not in the comspositing mode.
- (void)layerTreeDidChangeWithLayers:(NSArray *)layers;
// Param layerId: The id of the painted layer.
// Param clip: Clip rectangle.
- (void)layerPaintedWithLayerId:(NSString *)layerId clip:(PDDOMRect *)clip;

@end

@protocol PDLayerTreeCommandDelegate <PDCommandDelegate>
@optional

/// Enables compositing tree inspection.
- (void)domain:(PDLayerTreeDomain *)domain enableWithCallback:(void (^)(id error))callback;

/// Disables compositing tree inspection.
- (void)domain:(PDLayerTreeDomain *)domain disableWithCallback:(void (^)(id error))callback;

/// Provides the reasons why the given layer was composited.
// Param layerId: The id of the layer for which we want to get the reasons it was composited.
// Callback Param compositingReasons: A list of strings specifying reasons for the given layer to become composited.
- (void)domain:(PDLayerTreeDomain *)domain compositingReasonsWithLayerId:(NSString *)layerId callback:(void (^)(NSArray *compositingReasons, id error))callback;

/// Returns the layer snapshot identifier.
// Param layerId: The id of the layer.
// Callback Param snapshotId: The id of the layer snapshot.
- (void)domain:(PDLayerTreeDomain *)domain makeSnapshotWithLayerId:(NSString *)layerId callback:(void (^)(NSString *snapshotId, id error))callback;

/// Returns the snapshot identifier.
// Param tiles: An array of tiles composing the snapshot.
// Callback Param snapshotId: The id of the snapshot.
- (void)domain:(PDLayerTreeDomain *)domain loadSnapshotWithTiles:(NSArray *)tiles callback:(void (^)(NSString *snapshotId, id error))callback;

/// Releases layer snapshot captured by the back-end.
// Param snapshotId: The id of the layer snapshot.
- (void)domain:(PDLayerTreeDomain *)domain releaseSnapshotWithSnapshotId:(NSString *)snapshotId callback:(void (^)(id error))callback;
// Param snapshotId: The id of the layer snapshot.
// Param minRepeatCount: The maximum number of times to replay the snapshot (1, if not specified).
// Param minDuration: The minimum duration (in seconds) to replay the snapshot.
// Param clipRect: The clip rectangle to apply when replaying the snapshot.
// Callback Param timings: The array of paint profiles, one per run.
- (void)domain:(PDLayerTreeDomain *)domain profileSnapshotWithSnapshotId:(NSString *)snapshotId minRepeatCount:(NSNumber *)minRepeatCount minDuration:(NSNumber *)minDuration clipRect:(PDDOMRect *)clipRect callback:(void (^)(NSArray *timings, id error))callback;

/// Replays the layer snapshot and returns the resulting bitmap.
// Param snapshotId: The id of the layer snapshot.
// Param fromStep: The first step to replay from (replay from the very start if not specified).
// Param toStep: The last step to replay to (replay till the end if not specified).
// Param scale: The scale to apply while replaying (defaults to 1).
// Callback Param dataURL: A data: URL for resulting image.
- (void)domain:(PDLayerTreeDomain *)domain replaySnapshotWithSnapshotId:(NSString *)snapshotId fromStep:(NSNumber *)fromStep toStep:(NSNumber *)toStep scale:(NSNumber *)scale callback:(void (^)(NSString *dataURL, id error))callback;

/// Replays the layer snapshot and returns canvas log.
// Param snapshotId: The id of the layer snapshot.
// Callback Param commandLog: The array of canvas function calls.
- (void)domain:(PDLayerTreeDomain *)domain snapshotCommandLogWithSnapshotId:(NSString *)snapshotId callback:(void (^)(NSArray *commandLog, id error))callback;

@end

@interface PDDebugger (PDLayerTreeDomain)

@property (nonatomic, readonly, strong) PDLayerTreeDomain *layerTreeDomain;

@end
