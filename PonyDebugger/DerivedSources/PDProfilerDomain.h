#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>

@class PDRuntimeRemoteObject;

@protocol PDProfilerCommandDelegate;

@interface PDProfilerDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDProfilerCommandDelegate, PDCommandDelegate> delegate;

// Events
- (void)addProfileHeaderWithHeader:(NSDictionary *)header;
- (void)addHeapSnapshotChunkWithUid:(NSNumber *)uid chunk:(NSString *)chunk;
- (void)finishHeapSnapshotWithUid:(NSNumber *)uid;
- (void)setRecordingProfileWithIsProfiling:(NSNumber *)isProfiling;
- (void)resetProfiles;
- (void)reportHeapSnapshotProgressWithDone:(NSNumber *)done total:(NSNumber *)total;

@end

@protocol PDProfilerCommandDelegate <PDCommandDelegate>
@optional
- (void)domain:(PDProfilerDomain *)domain causesRecompilationWithCallback:(void (^)(NSNumber *result, id error))callback;
- (void)domain:(PDProfilerDomain *)domain isSamplingWithCallback:(void (^)(NSNumber *result, id error))callback;
- (void)domain:(PDProfilerDomain *)domain hasHeapProfilerWithCallback:(void (^)(NSNumber *result, id error))callback;
- (void)domain:(PDProfilerDomain *)domain enableWithCallback:(void (^)(id error))callback;
- (void)domain:(PDProfilerDomain *)domain disableWithCallback:(void (^)(id error))callback;
- (void)domain:(PDProfilerDomain *)domain startWithCallback:(void (^)(id error))callback;
- (void)domain:(PDProfilerDomain *)domain stopWithCallback:(void (^)(id error))callback;
- (void)domain:(PDProfilerDomain *)domain getProfileHeadersWithCallback:(void (^)(NSArray *headers, id error))callback;
- (void)domain:(PDProfilerDomain *)domain getProfileWithType:(NSString *)type uid:(NSNumber *)uid callback:(void (^)(NSDictionary *profile, id error))callback;
- (void)domain:(PDProfilerDomain *)domain removeProfileWithType:(NSString *)type uid:(NSNumber *)uid callback:(void (^)(id error))callback;
- (void)domain:(PDProfilerDomain *)domain clearProfilesWithCallback:(void (^)(id error))callback;
- (void)domain:(PDProfilerDomain *)domain takeHeapSnapshotWithCallback:(void (^)(id error))callback;
- (void)domain:(PDProfilerDomain *)domain collectGarbageWithCallback:(void (^)(id error))callback;
// Param objectGroup: Symbolic group name that can be used to release multiple objects.
// Callback Param result: Evaluation result.
- (void)domain:(PDProfilerDomain *)domain getObjectByHeapObjectIdWithObjectId:(NSNumber *)objectId objectGroup:(NSString *)objectGroup callback:(void (^)(PDRuntimeRemoteObject *result, id error))callback;

@end

@interface PDDebugger (PDProfilerDomain)

@property (nonatomic, readonly, retain) PDProfilerDomain *profilerDomain;

@end
