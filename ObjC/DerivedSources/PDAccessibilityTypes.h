//    
//  PDAccessibilityTypes.h
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


@class PDAccessibilityAXValue;


/// A single source for a computed AX property.
@interface PDAccessibilityAXPropertySource : PDObject

/// The name/label of this source.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// What type of source this is.
@property (nonatomic, strong) NSString *sourceType;

/// The value of this property source.
/// Type: any
@property (nonatomic, strong) id value;

/// What type the value should be interpreted as.
@property (nonatomic, strong) NSString *type;

/// Whether the value for this property is invalid.
/// Type: boolean
@property (nonatomic, strong) NSNumber *invalid;

/// Reason for the value being invalid, if it is.
/// Type: string
@property (nonatomic, strong) NSString *invalidReason;

@end


@interface PDAccessibilityAXRelatedNode : PDObject

/// The IDRef value provided, if any.
/// Type: string
@property (nonatomic, strong) NSString *idref;

/// The BackendNodeId of the related node.
@property (nonatomic, strong) NSNumber *backendNodeId;

@end


@interface PDAccessibilityAXProperty : PDObject

/// The name of this property.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// The value of this property.
@property (nonatomic, strong) PDAccessibilityAXValue *value;

@end


/// A single computed AX property.
@interface PDAccessibilityAXValue : PDObject

/// The type of this value.
@property (nonatomic, strong) NSString *type;

/// The computed value of this property.
/// Type: any
@property (nonatomic, strong) id value;

/// The related node value, if any.
@property (nonatomic, strong) PDAccessibilityAXRelatedNode *relatedNodeValue;

/// Multiple relted nodes, if applicable.
/// Type: array
@property (nonatomic, strong) NSArray *relatedNodeArrayValue;

/// The sources which contributed to the computation of this property.
/// Type: array
@property (nonatomic, strong) NSArray *sources;

@end


/// A node in the accessibility tree.
@interface PDAccessibilityAXNode : PDObject

/// Unique identifier for this node.
@property (nonatomic, strong) NSString *nodeId;

/// Whether this node is ignored for accessibility
/// Type: boolean
@property (nonatomic, strong) NSNumber *ignored;

/// Collection of reasons why this node is hidden.
/// Type: array
@property (nonatomic, strong) NSArray *ignoredReasons;

/// This <code>Node</code>'s role, whether explicit or implicit.
@property (nonatomic, strong) PDAccessibilityAXValue *role;

/// The accessible name for this <code>Node</code>.
@property (nonatomic, strong) PDAccessibilityAXValue *name;

/// The accessible description for this <code>Node</code>.
@property (nonatomic, strong) PDAccessibilityAXValue *objectDescription;

/// The value for this <code>Node</code>.
@property (nonatomic, strong) PDAccessibilityAXValue *value;

/// Help.
@property (nonatomic, strong) PDAccessibilityAXValue *help;

/// All other properties
/// Type: array
@property (nonatomic, strong) NSArray *properties;

@end


