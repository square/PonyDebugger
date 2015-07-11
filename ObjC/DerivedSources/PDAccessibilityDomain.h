//
//  PDAccessibilityDomain.h
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

@class PDAccessibilityAXNode;

@protocol PDAccessibilityCommandDelegate;

@interface PDAccessibilityDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDAccessibilityCommandDelegate, PDCommandDelegate> delegate;

@end

@protocol PDAccessibilityCommandDelegate <PDCommandDelegate>
@optional

/// Fetches the accessibility node for this DOM node, if it exists.
// Param nodeId: ID of node to get accessibility node for.
// Callback Param accessibilityNode: The <code>Accessibility.AXNode</code> for this DOM node, if it exists.
- (void)domain:(PDAccessibilityDomain *)domain getAXNodeWithNodeId:(NSNumber *)nodeId callback:(void (^)(PDAccessibilityAXNode *accessibilityNode, id error))callback;

@end

@interface PDDebugger (PDAccessibilityDomain)

@property (nonatomic, readonly, strong) PDAccessibilityDomain *accessibilityDomain;

@end
