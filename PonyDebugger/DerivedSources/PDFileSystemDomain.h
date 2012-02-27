#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


@protocol PDFileSystemCommandDelegate;

@interface PDFileSystemDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDFileSystemCommandDelegate, PDCommandDelegate> delegate;

@end

@protocol PDFileSystemCommandDelegate <PDCommandDelegate>
@optional

// Enables events from backend.
- (void)domain:(PDFileSystemDomain *)domain enableWithCallback:(void (^)(id error))callback;

// Disables events from backend..
- (void)domain:(PDFileSystemDomain *)domain disableWithCallback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDFileSystemDomain)

@property (nonatomic, readonly, retain) PDFileSystemDomain *fileSystemDomain;

@end
