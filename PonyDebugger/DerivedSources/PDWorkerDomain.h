#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


@protocol PDWorkerCommandDelegate;

@interface PDWorkerDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDWorkerCommandDelegate, PDCommandDelegate> delegate;

// Events
- (void)workerCreatedWithWorkerId:(NSNumber *)workerId url:(NSString *)url inspectorConnected:(NSNumber *)inspectorConnected;
- (void)workerTerminatedWithWorkerId:(NSNumber *)workerId;
- (void)dispatchMessageFromWorkerWithWorkerId:(NSNumber *)workerId message:(NSDictionary *)message;
- (void)disconnectedFromWorker;

@end

@protocol PDWorkerCommandDelegate <PDCommandDelegate>
@optional
- (void)domain:(PDWorkerDomain *)domain setWorkerInspectionEnabledWithValue:(NSNumber *)value callback:(void (^)(id error))callback;
- (void)domain:(PDWorkerDomain *)domain sendMessageToWorkerWithWorkerId:(NSNumber *)workerId message:(NSDictionary *)message callback:(void (^)(id error))callback;
- (void)domain:(PDWorkerDomain *)domain connectToWorkerWithWorkerId:(NSNumber *)workerId callback:(void (^)(id error))callback;
- (void)domain:(PDWorkerDomain *)domain disconnectFromWorkerWithWorkerId:(NSNumber *)workerId callback:(void (^)(id error))callback;
- (void)domain:(PDWorkerDomain *)domain setAutoconnectToWorkersWithValue:(NSNumber *)value callback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDWorkerDomain)

@property (nonatomic, readonly, retain) PDWorkerDomain *workerDomain;

@end
