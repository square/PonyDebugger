#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>

@class PDRuntimeRemoteObject;

@protocol PDInspectorCommandDelegate;

@interface PDInspectorDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDInspectorCommandDelegate, PDCommandDelegate> delegate;

// Events
- (void)evaluateForTestInFrontendWithTestCallId:(NSNumber *)testCallId script:(NSString *)script;
- (void)inspectWithObject:(PDRuntimeRemoteObject *)object hints:(NSDictionary *)hints;
- (void)didCreateWorkerWithId:(NSNumber *)identifier url:(NSString *)url isShared:(NSNumber *)isShared;
- (void)didDestroyWorkerWithId:(NSNumber *)identifier;

@end

@protocol PDInspectorCommandDelegate <PDCommandDelegate>
@optional

// Enables inspector domain notifications.
- (void)domain:(PDInspectorDomain *)domain enableWithCallback:(void (^)(id error))callback;

// Disables inspector domain notifications.
- (void)domain:(PDInspectorDomain *)domain disableWithCallback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDInspectorDomain)

@property (nonatomic, readonly, retain) PDInspectorDomain *inspectorDomain;

@end
