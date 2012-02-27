#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


// Mirror object referencing original JavaScript object.
@interface PDRuntimeRemoteObject : PDObject

// Object type.
// Type: string
@property (nonatomic, retain) NSString *type;

// Object subtype hint. Specified for <code>object</code> type values only.
// Type: string
@property (nonatomic, retain) NSString *subtype;

// Object class (constructor) name. Specified for <code>object</code> type values only.
// Type: string
@property (nonatomic, retain) NSString *className;

// Remote object value (in case of primitive values or JSON values if it was requested).
// Type: any
@property (nonatomic, retain) id value;

// String representation of the object.
// Type: string
@property (nonatomic, retain) NSString *objectDescription;

// Unique object identifier (for non-primitive values).
@property (nonatomic, retain) NSString *objectId;

@end


// Object property descriptor.
@interface PDRuntimePropertyDescriptor : PDObject

// Property name.
// Type: string
@property (nonatomic, retain) NSString *name;

// The value associated with the property.
@property (nonatomic, retain) PDRuntimeRemoteObject *value;

// True if the value associated with the property may be changed (data descriptors only).
// Type: boolean
@property (nonatomic, retain) NSNumber *writable;

// A function which serves as a getter for the property, or <code>undefined</code> if there is no getter (accessor descriptors only).
@property (nonatomic, retain) PDRuntimeRemoteObject *get;

// A function which serves as a setter for the property, or <code>undefined</code> if there is no setter (accessor descriptors only).
@property (nonatomic, retain) PDRuntimeRemoteObject *set;

// True if the type of this property descriptor may be changed and if the property may be deleted from the corresponding object.
// Type: boolean
@property (nonatomic, retain) NSNumber *configurable;

// True if this property shows up during enumeration of the properties on the corresponding object.
// Type: boolean
@property (nonatomic, retain) NSNumber *enumerable;

// True if the result was thrown during the evaluation.
// Type: boolean
@property (nonatomic, retain) NSNumber *wasThrown;

@end


// Represents function call argument. Either remote object id <code>objectId</code> or primitive <code>value</code> or neither of (for undefined) them should be specified.
@interface PDRuntimeCallArgument : PDObject

// Primitive value.
// Type: any
@property (nonatomic, retain) id value;

// Remote object handle.
@property (nonatomic, retain) NSString *objectId;

@end


