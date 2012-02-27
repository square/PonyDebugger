#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>

@class PDDOMStorageEntry;

@protocol PDDOMStorageCommandDelegate;

@interface PDDOMStorageDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDDOMStorageCommandDelegate, PDCommandDelegate> delegate;

// Events
- (void)addDOMStorageWithStorage:(PDDOMStorageEntry *)storage;
- (void)updateDOMStorageWithStorageId:(NSNumber *)storageId;

@end

@protocol PDDOMStorageCommandDelegate <PDCommandDelegate>
@optional

// Enables storage tracking, storage events will now be delivered to the client.
- (void)domain:(PDDOMStorageDomain *)domain enableWithCallback:(void (^)(id error))callback;

// Disables storage tracking, prevents storage events from being sent to the client.
- (void)domain:(PDDOMStorageDomain *)domain disableWithCallback:(void (^)(id error))callback;
- (void)domain:(PDDOMStorageDomain *)domain getDOMStorageEntriesWithStorageId:(NSNumber *)storageId callback:(void (^)(NSArray *entries, id error))callback;
- (void)domain:(PDDOMStorageDomain *)domain setDOMStorageItemWithStorageId:(NSNumber *)storageId key:(NSString *)key value:(NSString *)value callback:(void (^)(NSNumber *success, id error))callback;
- (void)domain:(PDDOMStorageDomain *)domain removeDOMStorageItemWithStorageId:(NSNumber *)storageId key:(NSString *)key callback:(void (^)(NSNumber *success, id error))callback;

@end

@interface PDDebugger (PDDOMStorageDomain)

@property (nonatomic, readonly, retain) PDDOMStorageDomain *DOMStorageDomain;

@end
