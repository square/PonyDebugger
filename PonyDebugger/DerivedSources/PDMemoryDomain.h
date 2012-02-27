#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>

@class PDMemoryStringStatistics;

@protocol PDMemoryCommandDelegate;

@interface PDMemoryDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDMemoryCommandDelegate, PDCommandDelegate> delegate;

@end

@protocol PDMemoryCommandDelegate <PDCommandDelegate>
@optional
- (void)domain:(PDMemoryDomain *)domain getDOMNodeCountWithCallback:(void (^)(NSArray *domGroups, PDMemoryStringStatistics *strings, id error))callback;

@end

@interface PDDebugger (PDMemoryDomain)

@property (nonatomic, readonly, retain) PDMemoryDomain *memoryDomain;

@end
