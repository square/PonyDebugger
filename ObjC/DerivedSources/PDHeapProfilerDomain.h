//
//  PDHeapProfilerDomain.h
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

@class PDRuntimeRemoteObject;

@protocol PDHeapProfilerCommandDelegate;

@interface PDHeapProfilerDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDHeapProfilerCommandDelegate, PDCommandDelegate> delegate;

// Events
- (void)addHeapSnapshotChunkWithChunk:(NSString *)chunk;
- (void)resetProfiles;
- (void)reportHeapSnapshotProgressWithDone:(NSNumber *)done total:(NSNumber *)total finished:(NSNumber *)finished;

// If heap objects tracking has been started then backend regulary sends a current value for last seen object id and corresponding timestamp. If the were changes in the heap since last event then one or more heapStatsUpdate events will be sent before a new lastSeenObjectId event.
- (void)lastSeenObjectIdWithLastSeenObjectId:(NSNumber *)lastSeenObjectId timestamp:(NSNumber *)timestamp;

// If heap objects tracking has been started then backend may send update for one or more fragments
// Param statsUpdate: An array of triplets. Each triplet describes a fragment. The first integer is the fragment index, the second integer is a total count of objects for the fragment, the third integer is a total size of the objects for the fragment.
- (void)heapStatsUpdateWithStatsUpdate:(NSArray *)statsUpdate;

@end

@protocol PDHeapProfilerCommandDelegate <PDCommandDelegate>
@optional
- (void)domain:(PDHeapProfilerDomain *)domain enableWithCallback:(void (^)(id error))callback;
- (void)domain:(PDHeapProfilerDomain *)domain disableWithCallback:(void (^)(id error))callback;
- (void)domain:(PDHeapProfilerDomain *)domain startTrackingHeapObjectsWithTrackAllocations:(NSNumber *)trackAllocations callback:(void (^)(id error))callback;
// Param reportProgress: If true 'reportHeapSnapshotProgress' events will be generated while snapshot is being taken when the tracking is stopped.
- (void)domain:(PDHeapProfilerDomain *)domain stopTrackingHeapObjectsWithReportProgress:(NSNumber *)reportProgress callback:(void (^)(id error))callback;
// Param reportProgress: If true 'reportHeapSnapshotProgress' events will be generated while snapshot is being taken.
- (void)domain:(PDHeapProfilerDomain *)domain takeHeapSnapshotWithReportProgress:(NSNumber *)reportProgress callback:(void (^)(id error))callback;
- (void)domain:(PDHeapProfilerDomain *)domain collectGarbageWithCallback:(void (^)(id error))callback;
// Param objectGroup: Symbolic group name that can be used to release multiple objects.
// Callback Param result: Evaluation result.
- (void)domain:(PDHeapProfilerDomain *)domain getObjectByHeapObjectIdWithObjectId:(NSString *)objectId objectGroup:(NSString *)objectGroup callback:(void (^)(PDRuntimeRemoteObject *result, id error))callback;

/// Enables console to refer to the node with given id via $x (see Command Line API for more details $x functions).
// Param heapObjectId: Heap snapshot object id to be accessible by means of $x command line API.
- (void)domain:(PDHeapProfilerDomain *)domain addInspectedHeapObjectWithHeapObjectId:(NSString *)heapObjectId callback:(void (^)(id error))callback;
// Param objectId: Identifier of the object to get heap object id for.
// Callback Param heapSnapshotObjectId: Id of the heap snapshot object corresponding to the passed remote object id.
- (void)domain:(PDHeapProfilerDomain *)domain getHeapObjectIdWithObjectId:(NSString *)objectId callback:(void (^)(NSString *heapSnapshotObjectId, id error))callback;

@end

@interface PDDebugger (PDHeapProfilerDomain)

@property (nonatomic, readonly, strong) PDHeapProfilerDomain *heapProfilerDomain;

@end
