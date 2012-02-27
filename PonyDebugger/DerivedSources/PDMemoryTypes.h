#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


// Number of nodes with given name.
@interface PDMemoryNodeCount : PDObject

// Type: string
@property (nonatomic, retain) NSString *nodeName;

// Type: integer
@property (nonatomic, retain) NSNumber *count;

@end


// Number of JS event listeners by event type.
@interface PDMemoryListenerCount : PDObject

// Type: string
@property (nonatomic, retain) NSString *type;

// Type: integer
@property (nonatomic, retain) NSNumber *count;

@end


// Character data statistics for the page.
@interface PDMemoryStringStatistics : PDObject

// Type: integer
@property (nonatomic, retain) NSNumber *dom;

// Type: integer
@property (nonatomic, retain) NSNumber *js;

// Type: integer
@property (nonatomic, retain) NSNumber *shared;

@end


@interface PDMemoryDOMGroup : PDObject

// Type: integer
@property (nonatomic, retain) NSNumber *size;

// Type: string
@property (nonatomic, retain) NSString *title;

// Type: string
@property (nonatomic, retain) NSString *documentURI;

// Type: array
@property (nonatomic, retain) NSArray *nodeCount;

// Type: array
@property (nonatomic, retain) NSArray *listenerCount;

@end


