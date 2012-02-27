#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


// Timeline record contains information about the recorded activity.
@interface PDTimelineTimelineEvent : PDObject

// Event type.
// Type: string
@property (nonatomic, retain) NSString *type;

// Event data.
// Type: object
@property (nonatomic, retain) NSDictionary *data;

// Nested records.
// Type: array
@property (nonatomic, retain) NSArray *children;

@end


