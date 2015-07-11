//    
//  PDRuntimeTypes.h
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//
    
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


@class PDRuntimeObjectPreview;
@class PDRuntimeCustomPreview;


/// Mirror object referencing original JavaScript object.
@interface PDRuntimeRemoteObject : PDObject

/// Object type.
/// Type: string
@property (nonatomic, strong) NSString *type;

/// Object subtype hint. Specified for <code>object</code> type values only.
/// Type: string
@property (nonatomic, strong) NSString *subtype;

/// Object class (constructor) name. Specified for <code>object</code> type values only.
/// Type: string
@property (nonatomic, strong) NSString *classNameString;

/// Remote object value in case of primitive values or JSON values (if it was requested), or description string if the value can not be JSON-stringified (like NaN, Infinity, -Infinity, -0).
/// Type: any
@property (nonatomic, strong) id value;

/// String representation of the object.
/// Type: string
@property (nonatomic, strong) NSString *objectDescription;

/// Unique object identifier (for non-primitive values).
@property (nonatomic, strong) NSString *objectId;

/// Preview containing abbreviated property values. Specified for <code>object</code> type values only.
@property (nonatomic, strong) PDRuntimeObjectPreview *preview;

@property (nonatomic, strong) PDRuntimeCustomPreview *customPreview;

@end


@interface PDRuntimeCustomPreview : PDObject

/// Type: string
@property (nonatomic, strong) NSString *header;

/// Type: boolean
@property (nonatomic, strong) NSNumber *hasBody;

@property (nonatomic, strong) NSString *formatterObjectId;

@property (nonatomic, strong) NSString *configObjectId;

@end


/// Object containing abbreviated remote object value.
@interface PDRuntimeObjectPreview : PDObject

/// Object type.
/// Type: string
@property (nonatomic, strong) NSString *type;

/// Object subtype hint. Specified for <code>object</code> type values only.
/// Type: string
@property (nonatomic, strong) NSString *subtype;

/// String representation of the object.
/// Type: string
@property (nonatomic, strong) NSString *objectDescription;

/// Determines whether preview is lossless (contains all information of the original object).
/// Type: boolean
@property (nonatomic, strong) NSNumber *lossless;

/// True iff some of the properties or entries of the original object did not fit.
/// Type: boolean
@property (nonatomic, strong) NSNumber *overflow;

/// List of the properties.
/// Type: array
@property (nonatomic, strong) NSArray *properties;

/// List of the entries. Specified for <code>map</code> and <code>set</code> subtype values only.
/// Type: array
@property (nonatomic, strong) NSArray *entries;

@end


@interface PDRuntimePropertyPreview : PDObject

/// Property name.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// Object type. Accessor means that the property itself is an accessor property.
/// Type: string
@property (nonatomic, strong) NSString *type;

/// User-friendly property value string.
/// Type: string
@property (nonatomic, strong) NSString *value;

/// Nested value preview.
@property (nonatomic, strong) PDRuntimeObjectPreview *valuePreview;

/// Object subtype hint. Specified for <code>object</code> type values only.
/// Type: string
@property (nonatomic, strong) NSString *subtype;

@end


@interface PDRuntimeEntryPreview : PDObject

/// Preview of the key. Specified for map-like collection entries.
@property (nonatomic, strong) PDRuntimeObjectPreview *key;

/// Preview of the value.
@property (nonatomic, strong) PDRuntimeObjectPreview *value;

@end


/// Object property descriptor.
@interface PDRuntimePropertyDescriptor : PDObject

/// Property name or symbol description.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// The value associated with the property.
@property (nonatomic, strong) PDRuntimeRemoteObject *value;

/// True if the value associated with the property may be changed (data descriptors only).
/// Type: boolean
@property (nonatomic, strong) NSNumber *writable;

/// A function which serves as a getter for the property, or <code>undefined</code> if there is no getter (accessor descriptors only).
@property (nonatomic, strong) PDRuntimeRemoteObject *get;

/// A function which serves as a setter for the property, or <code>undefined</code> if there is no setter (accessor descriptors only).
@property (nonatomic, strong) PDRuntimeRemoteObject *set;

/// True if the type of this property descriptor may be changed and if the property may be deleted from the corresponding object.
/// Type: boolean
@property (nonatomic, strong) NSNumber *configurable;

/// True if this property shows up during enumeration of the properties on the corresponding object.
/// Type: boolean
@property (nonatomic, strong) NSNumber *enumerable;

/// True if the result was thrown during the evaluation.
/// Type: boolean
@property (nonatomic, strong) NSNumber *wasThrown;

/// True if the property is owned for the object.
/// Type: boolean
@property (nonatomic, strong) NSNumber *isOwn;

/// Property symbol object, if the property is of the <code>symbol</code> type.
@property (nonatomic, strong) PDRuntimeRemoteObject *symbol;

@end


/// Object internal property descriptor. This property isn't normally visible in JavaScript code.
@interface PDRuntimeInternalPropertyDescriptor : PDObject

/// Conventional property name.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// The value associated with the property.
@property (nonatomic, strong) PDRuntimeRemoteObject *value;

@end


/// Represents function call argument. Either remote object id <code>objectId</code> or primitive <code>value</code> or neither of (for undefined) them should be specified.
@interface PDRuntimeCallArgument : PDObject

/// Primitive value, or description string if the value can not be JSON-stringified (like NaN, Infinity, -Infinity, -0).
/// Type: any
@property (nonatomic, strong) id value;

/// Remote object handle.
@property (nonatomic, strong) NSString *objectId;

/// Object type.
/// Type: string
@property (nonatomic, strong) NSString *type;

@end


/// Description of an isolated world.
@interface PDRuntimeExecutionContextDescription : PDObject

/// Unique id of the execution context. It can be used to specify in which execution context script evaluation should be performed.
@property (nonatomic, strong) NSNumber *identifier;

/// Context type. It is used e.g. to distinguish content scripts from web page script.
/// Type: string
@property (nonatomic, strong) NSString *type;

/// Execution context origin.
/// Type: string
@property (nonatomic, strong) NSString *origin;

/// Human readable name describing given context.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// Id of the owning frame. May be an empty string if the context is not associated with a frame.
/// Type: string
@property (nonatomic, strong) NSString *frameId;

@end


