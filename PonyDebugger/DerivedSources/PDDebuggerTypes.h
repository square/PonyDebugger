#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


@class PDRuntimeRemoteObject;


// Location in the source code.
@interface PDDebuggerLocation : PDObject

// Script identifier as reported in the <code>Debugger.scriptParsed</code>.
@property (nonatomic, retain) NSString *scriptId;

// Line number in the script.
// Type: integer
@property (nonatomic, retain) NSNumber *lineNumber;

// Column number in the script.
// Type: integer
@property (nonatomic, retain) NSNumber *columnNumber;

@end


// Information about the function.
@interface PDDebuggerFunctionDetails : PDObject

// Location of the function.
@property (nonatomic, retain) PDDebuggerLocation *location;

// Name of the function. Not present for anonymous functions.
// Type: string
@property (nonatomic, retain) NSString *name;

// Display name of the function(specified in 'displayName' property on the function object).
// Type: string
@property (nonatomic, retain) NSString *displayName;

// Name of the function inferred from its initial assignment.
// Type: string
@property (nonatomic, retain) NSString *inferredName;

@end


// JavaScript call frame. Array of call frames form the call stack.
@interface PDDebuggerCallFrame : PDObject

// Call frame identifier. This identifier is only valid while the virtual machine is paused.
@property (nonatomic, retain) NSString *callFrameId;

// Name of the JavaScript function called on this call frame.
// Type: string
@property (nonatomic, retain) NSString *functionName;

// Location in the source code.
@property (nonatomic, retain) PDDebuggerLocation *location;

// Scope chain for this call frame.
// Type: array
@property (nonatomic, retain) NSArray *scopeChain;

// <code>this</code> object for this call frame.
@property (nonatomic, retain) PDRuntimeRemoteObject *this;

@end


// Scope description.
@interface PDDebuggerScope : PDObject

// Scope type.
// Type: string
@property (nonatomic, retain) NSString *type;

// Object representing the scope. For <code>global</code> and <code>with</code> scopes it represents the actual object; for the rest of the scopes, it is artificial transient object enumerating scope variables as its properties.
@property (nonatomic, retain) PDRuntimeRemoteObject *object;

@end


