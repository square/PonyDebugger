#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


// DOM Storage entry.
@interface PDDOMStorageEntry : PDObject

// Domain name.
// Type: string
@property (nonatomic, retain) NSString *host;

// True for local storage.
// Type: boolean
@property (nonatomic, retain) NSNumber *isLocalStorage;

// Entry id for further reference.
// Type: number
@property (nonatomic, retain) NSNumber *identifier;

@end


