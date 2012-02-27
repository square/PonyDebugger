#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>

@class PDRuntimeRemoteObject;

@protocol PDRuntimeCommandDelegate;

// Runtime domain exposes JavaScript runtime by means of remote evaluation and mirror objects. Evaluation results are returned as mirror object that expose object type, string representation and unique identifier that can be used for further object reference. Original objects are maintained in memory unless they are either explicitly released or are released along with the other objects in their object group.
@interface PDRuntimeDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDRuntimeCommandDelegate, PDCommandDelegate> delegate;

@end

@protocol PDRuntimeCommandDelegate <PDCommandDelegate>
@optional

// Evaluates expression on global object.
// Param expression: Expression to evaluate.
// Param objectGroup: Symbolic group name that can be used to release multiple objects.
// Param includeCommandLineAPI: Determines whether Command Line API should be available during the evaluation.
// Param doNotPauseOnExceptions: Specifies whether evaluation should stop on exceptions. Overrides setPauseOnException state.
// Param frameId: Specifies in which frame to perform evaluation.
// Param returnByValue: Whether the result is expected to be a JSON object that should be sent by value.
// Callback Param result: Evaluation result.
// Callback Param wasThrown: True if the result was thrown during the evaluation.
- (void)domain:(PDRuntimeDomain *)domain evaluateWithExpression:(NSString *)expression objectGroup:(NSString *)objectGroup includeCommandLineAPI:(NSNumber *)includeCommandLineAPI doNotPauseOnExceptions:(NSNumber *)doNotPauseOnExceptions frameId:(NSString *)frameId returnByValue:(NSNumber *)returnByValue callback:(void (^)(PDRuntimeRemoteObject *result, NSNumber *wasThrown, id error))callback;

// Calls function with given declaration on the given object. Object group of the result is inherited from the target object.
// Param objectId: Identifier of the object to call function on.
// Param functionDeclaration: Declaration of the function to call.
// Param arguments: Call arguments. All call arguments must belong to the same JavaScript world as the target object.
// Param returnByValue: Whether the result is expected to be a JSON object which should be sent by value.
// Callback Param result: Call result.
// Callback Param wasThrown: True if the result was thrown during the evaluation.
- (void)domain:(PDRuntimeDomain *)domain callFunctionOnWithObjectId:(NSString *)objectId functionDeclaration:(NSString *)functionDeclaration arguments:(NSArray *)arguments returnByValue:(NSNumber *)returnByValue callback:(void (^)(PDRuntimeRemoteObject *result, NSNumber *wasThrown, id error))callback;

// Returns properties of a given object. Object group of the result is inherited from the target object.
// Param objectId: Identifier of the object to return properties for.
// Param ownProperties: If true, returns properties belonging only to the element itself, not to its prototype chain.
// Callback Param result: Object properties.
- (void)domain:(PDRuntimeDomain *)domain getPropertiesWithObjectId:(NSString *)objectId ownProperties:(NSNumber *)ownProperties callback:(void (^)(NSArray *result, id error))callback;

// Releases remote object with given id.
// Param objectId: Identifier of the object to release.
- (void)domain:(PDRuntimeDomain *)domain releaseObjectWithObjectId:(NSString *)objectId callback:(void (^)(id error))callback;

// Releases all remote objects that belong to a given group.
// Param objectGroup: Symbolic object group name.
- (void)domain:(PDRuntimeDomain *)domain releaseObjectGroupWithObjectGroup:(NSString *)objectGroup callback:(void (^)(id error))callback;

// Tells inspected instance(worker or page) that it can run in case it was started paused.
- (void)domain:(PDRuntimeDomain *)domain runWithCallback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDRuntimeDomain)

@property (nonatomic, readonly, retain) PDRuntimeDomain *runtimeDomain;

@end
