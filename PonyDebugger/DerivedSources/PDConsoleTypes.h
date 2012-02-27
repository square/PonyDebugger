#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


// Console message.
@interface PDConsoleConsoleMessage : PDObject

// Message source.
// Type: string
@property (nonatomic, retain) NSString *source;

// Message severity.
// Type: string
@property (nonatomic, retain) NSString *level;

// Message text.
// Type: string
@property (nonatomic, retain) NSString *text;

// Console message type.
// Type: string
@property (nonatomic, retain) NSString *type;

// URL of the message origin.
// Type: string
@property (nonatomic, retain) NSString *url;

// Line number in the resource that generated this message.
// Type: integer
@property (nonatomic, retain) NSNumber *line;

// Repeat count for repeated messages.
// Type: integer
@property (nonatomic, retain) NSNumber *repeatCount;

// Message parameters in case of the formatted message.
// Type: array
@property (nonatomic, retain) NSArray *parameters;

// JavaScript stack trace for assertions and error messages.
@property (nonatomic, retain) NSArray *stackTrace;

// Identifier of the network request associated with this message.
@property (nonatomic, retain) NSString *networkRequestId;

@end


// Stack entry for console errors and assertions.
@interface PDConsoleCallFrame : PDObject

// JavaScript function name.
// Type: string
@property (nonatomic, retain) NSString *functionName;

// JavaScript script name or url.
// Type: string
@property (nonatomic, retain) NSString *url;

// JavaScript script line number.
// Type: integer
@property (nonatomic, retain) NSNumber *lineNumber;

// JavaScript script column number.
// Type: integer
@property (nonatomic, retain) NSNumber *columnNumber;

@end


