//
//  PDDOMDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDOMDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDOMTypes.h>
#import <PonyDebugger/PDRuntimeTypes.h>


@interface PDDOMDomain ()
//Commands

@end

@implementation PDDOMDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"DOM";
}

// Events

// Fired when <code>Document</code> has been totally updated. Node ids are no longer valid.
- (void)documentUpdated;
{
    [self.debuggingServer sendEventWithName:@"DOM.documentUpdated" parameters:nil];
}

// Fired when the node should be inspected. This happens after call to <code>setInspectModeEnabled</code>.
- (void)inspectNodeRequestedWithBackendNodeId:(NSNumber *)backendNodeId;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (backendNodeId != nil) {
        [params setObject:[backendNodeId PD_JSONObject] forKey:@"backendNodeId"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOM.inspectNodeRequested" parameters:params];
}

// Fired when backend wants to provide client with the missing DOM structure. This happens upon most of the calls requesting node ids.
- (void)setChildNodesWithParentId:(NSNumber *)parentId nodes:(NSArray *)nodes;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (parentId != nil) {
        [params setObject:[parentId PD_JSONObject] forKey:@"parentId"];
    }
    if (nodes != nil) {
        [params setObject:[nodes PD_JSONObject] forKey:@"nodes"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOM.setChildNodes" parameters:params];
}

// Fired when <code>Element</code>'s attribute is modified.
- (void)attributeModifiedWithNodeId:(NSNumber *)nodeId name:(NSString *)name value:(NSString *)value;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];

    if (nodeId != nil) {
        [params setObject:[nodeId PD_JSONObject] forKey:@"nodeId"];
    }
    if (name != nil) {
        [params setObject:[name PD_JSONObject] forKey:@"name"];
    }
    if (value != nil) {
        [params setObject:[value PD_JSONObject] forKey:@"value"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOM.attributeModified" parameters:params];
}

// Fired when <code>Element</code>'s attribute is removed.
- (void)attributeRemovedWithNodeId:(NSNumber *)nodeId name:(NSString *)name;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (nodeId != nil) {
        [params setObject:[nodeId PD_JSONObject] forKey:@"nodeId"];
    }
    if (name != nil) {
        [params setObject:[name PD_JSONObject] forKey:@"name"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOM.attributeRemoved" parameters:params];
}

// Fired when <code>Element</code>'s inline style is modified via a CSS property modification.
- (void)inlineStyleInvalidatedWithNodeIds:(NSArray *)nodeIds;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (nodeIds != nil) {
        [params setObject:[nodeIds PD_JSONObject] forKey:@"nodeIds"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOM.inlineStyleInvalidated" parameters:params];
}

// Mirrors <code>DOMCharacterDataModified</code> event.
- (void)characterDataModifiedWithNodeId:(NSNumber *)nodeId characterData:(NSString *)characterData;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (nodeId != nil) {
        [params setObject:[nodeId PD_JSONObject] forKey:@"nodeId"];
    }
    if (characterData != nil) {
        [params setObject:[characterData PD_JSONObject] forKey:@"characterData"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOM.characterDataModified" parameters:params];
}

// Fired when <code>Container</code>'s child node count has changed.
- (void)childNodeCountUpdatedWithNodeId:(NSNumber *)nodeId childNodeCount:(NSNumber *)childNodeCount;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (nodeId != nil) {
        [params setObject:[nodeId PD_JSONObject] forKey:@"nodeId"];
    }
    if (childNodeCount != nil) {
        [params setObject:[childNodeCount PD_JSONObject] forKey:@"childNodeCount"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOM.childNodeCountUpdated" parameters:params];
}

// Mirrors <code>DOMNodeInserted</code> event.
- (void)childNodeInsertedWithParentNodeId:(NSNumber *)parentNodeId previousNodeId:(NSNumber *)previousNodeId node:(PDDOMNode *)node;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];

    if (parentNodeId != nil) {
        [params setObject:[parentNodeId PD_JSONObject] forKey:@"parentNodeId"];
    }
    if (previousNodeId != nil) {
        [params setObject:[previousNodeId PD_JSONObject] forKey:@"previousNodeId"];
    }
    if (node != nil) {
        [params setObject:[node PD_JSONObject] forKey:@"node"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOM.childNodeInserted" parameters:params];
}

// Mirrors <code>DOMNodeRemoved</code> event.
- (void)childNodeRemovedWithParentNodeId:(NSNumber *)parentNodeId nodeId:(NSNumber *)nodeId;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (parentNodeId != nil) {
        [params setObject:[parentNodeId PD_JSONObject] forKey:@"parentNodeId"];
    }
    if (nodeId != nil) {
        [params setObject:[nodeId PD_JSONObject] forKey:@"nodeId"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOM.childNodeRemoved" parameters:params];
}

// Called when shadow root is pushed into the element.
- (void)shadowRootPushedWithHostId:(NSNumber *)hostId root:(PDDOMNode *)root;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (hostId != nil) {
        [params setObject:[hostId PD_JSONObject] forKey:@"hostId"];
    }
    if (root != nil) {
        [params setObject:[root PD_JSONObject] forKey:@"root"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOM.shadowRootPushed" parameters:params];
}

// Called when shadow root is popped from the element.
- (void)shadowRootPoppedWithHostId:(NSNumber *)hostId rootId:(NSNumber *)rootId;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (hostId != nil) {
        [params setObject:[hostId PD_JSONObject] forKey:@"hostId"];
    }
    if (rootId != nil) {
        [params setObject:[rootId PD_JSONObject] forKey:@"rootId"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOM.shadowRootPopped" parameters:params];
}

// Called when a pseudo element is added to an element.
- (void)pseudoElementAddedWithParentId:(NSNumber *)parentId pseudoElement:(PDDOMNode *)pseudoElement;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (parentId != nil) {
        [params setObject:[parentId PD_JSONObject] forKey:@"parentId"];
    }
    if (pseudoElement != nil) {
        [params setObject:[pseudoElement PD_JSONObject] forKey:@"pseudoElement"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOM.pseudoElementAdded" parameters:params];
}

// Called when a pseudo element is removed from an element.
- (void)pseudoElementRemovedWithParentId:(NSNumber *)parentId pseudoElementId:(NSNumber *)pseudoElementId;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (parentId != nil) {
        [params setObject:[parentId PD_JSONObject] forKey:@"parentId"];
    }
    if (pseudoElementId != nil) {
        [params setObject:[pseudoElementId PD_JSONObject] forKey:@"pseudoElementId"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOM.pseudoElementRemoved" parameters:params];
}

// Called when distrubution is changed.
- (void)distributedNodesUpdatedWithInsertionPointId:(NSNumber *)insertionPointId distributedNodes:(NSArray *)distributedNodes;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (insertionPointId != nil) {
        [params setObject:[insertionPointId PD_JSONObject] forKey:@"insertionPointId"];
    }
    if (distributedNodes != nil) {
        [params setObject:[distributedNodes PD_JSONObject] forKey:@"distributedNodes"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOM.distributedNodesUpdated" parameters:params];
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"enable"] && [self.delegate respondsToSelector:@selector(domain:enableWithCallback:)]) {
        [self.delegate domain:self enableWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"disable"] && [self.delegate respondsToSelector:@selector(domain:disableWithCallback:)]) {
        [self.delegate domain:self disableWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getDocument"] && [self.delegate respondsToSelector:@selector(domain:getDocumentWithCallback:)]) {
        [self.delegate domain:self getDocumentWithCallback:^(PDDOMNode *root, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (root != nil) {
                [params setObject:root forKey:@"root"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"requestChildNodes"] && [self.delegate respondsToSelector:@selector(domain:requestChildNodesWithNodeId:depth:callback:)]) {
        [self.delegate domain:self requestChildNodesWithNodeId:[params objectForKey:@"nodeId"] depth:[params objectForKey:@"depth"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"querySelector"] && [self.delegate respondsToSelector:@selector(domain:querySelectorWithNodeId:selector:callback:)]) {
        [self.delegate domain:self querySelectorWithNodeId:[params objectForKey:@"nodeId"] selector:[params objectForKey:@"selector"] callback:^(NSNumber *nodeId, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (nodeId != nil) {
                [params setObject:nodeId forKey:@"nodeId"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"querySelectorAll"] && [self.delegate respondsToSelector:@selector(domain:querySelectorAllWithNodeId:selector:callback:)]) {
        [self.delegate domain:self querySelectorAllWithNodeId:[params objectForKey:@"nodeId"] selector:[params objectForKey:@"selector"] callback:^(NSArray *nodeIds, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (nodeIds != nil) {
                [params setObject:nodeIds forKey:@"nodeIds"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setNodeName"] && [self.delegate respondsToSelector:@selector(domain:setNodeNameWithNodeId:name:callback:)]) {
        [self.delegate domain:self setNodeNameWithNodeId:[params objectForKey:@"nodeId"] name:[params objectForKey:@"name"] callback:^(NSNumber *nodeId, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (nodeId != nil) {
                [params setObject:nodeId forKey:@"nodeId"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setNodeValue"] && [self.delegate respondsToSelector:@selector(domain:setNodeValueWithNodeId:value:callback:)]) {
        [self.delegate domain:self setNodeValueWithNodeId:[params objectForKey:@"nodeId"] value:[params objectForKey:@"value"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"removeNode"] && [self.delegate respondsToSelector:@selector(domain:removeNodeWithNodeId:callback:)]) {
        [self.delegate domain:self removeNodeWithNodeId:[params objectForKey:@"nodeId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setAttributeValue"] && [self.delegate respondsToSelector:@selector(domain:setAttributeValueWithNodeId:name:value:callback:)]) {
        [self.delegate domain:self setAttributeValueWithNodeId:[params objectForKey:@"nodeId"] name:[params objectForKey:@"name"] value:[params objectForKey:@"value"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setAttributesAsText"] && [self.delegate respondsToSelector:@selector(domain:setAttributesAsTextWithNodeId:text:name:callback:)]) {
        [self.delegate domain:self setAttributesAsTextWithNodeId:[params objectForKey:@"nodeId"] text:[params objectForKey:@"text"] name:[params objectForKey:@"name"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"removeAttribute"] && [self.delegate respondsToSelector:@selector(domain:removeAttributeWithNodeId:name:callback:)]) {
        [self.delegate domain:self removeAttributeWithNodeId:[params objectForKey:@"nodeId"] name:[params objectForKey:@"name"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getOuterHTML"] && [self.delegate respondsToSelector:@selector(domain:getOuterHTMLWithNodeId:callback:)]) {
        [self.delegate domain:self getOuterHTMLWithNodeId:[params objectForKey:@"nodeId"] callback:^(NSString *outerHTML, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (outerHTML != nil) {
                [params setObject:outerHTML forKey:@"outerHTML"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setOuterHTML"] && [self.delegate respondsToSelector:@selector(domain:setOuterHTMLWithNodeId:outerHTML:callback:)]) {
        [self.delegate domain:self setOuterHTMLWithNodeId:[params objectForKey:@"nodeId"] outerHTML:[params objectForKey:@"outerHTML"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"performSearch"] && [self.delegate respondsToSelector:@selector(domain:performSearchWithQuery:includeUserAgentShadowDOM:callback:)]) {
        [self.delegate domain:self performSearchWithQuery:[params objectForKey:@"query"] includeUserAgentShadowDOM:[params objectForKey:@"includeUserAgentShadowDOM"] callback:^(NSString *searchId, NSNumber *resultCount, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (searchId != nil) {
                [params setObject:searchId forKey:@"searchId"];
            }
            if (resultCount != nil) {
                [params setObject:resultCount forKey:@"resultCount"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getSearchResults"] && [self.delegate respondsToSelector:@selector(domain:getSearchResultsWithSearchId:fromIndex:toIndex:callback:)]) {
        [self.delegate domain:self getSearchResultsWithSearchId:[params objectForKey:@"searchId"] fromIndex:[params objectForKey:@"fromIndex"] toIndex:[params objectForKey:@"toIndex"] callback:^(NSArray *nodeIds, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (nodeIds != nil) {
                [params setObject:nodeIds forKey:@"nodeIds"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"discardSearchResults"] && [self.delegate respondsToSelector:@selector(domain:discardSearchResultsWithSearchId:callback:)]) {
        [self.delegate domain:self discardSearchResultsWithSearchId:[params objectForKey:@"searchId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"requestNode"] && [self.delegate respondsToSelector:@selector(domain:requestNodeWithObjectId:callback:)]) {
        [self.delegate domain:self requestNodeWithObjectId:[params objectForKey:@"objectId"] callback:^(NSNumber *nodeId, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (nodeId != nil) {
                [params setObject:nodeId forKey:@"nodeId"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setInspectModeEnabled"] && [self.delegate respondsToSelector:@selector(domain:setInspectModeEnabledWithEnabled:inspectUAShadowDOM:highlightConfig:callback:)]) {
        [self.delegate domain:self setInspectModeEnabledWithEnabled:[params objectForKey:@"enabled"] inspectUAShadowDOM:[params objectForKey:@"inspectUAShadowDOM"] highlightConfig:[params objectForKey:@"highlightConfig"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"highlightRect"] && [self.delegate respondsToSelector:@selector(domain:highlightRectWithX:y:width:height:color:outlineColor:callback:)]) {
        [self.delegate domain:self highlightRectWithX:[params objectForKey:@"x"] y:[params objectForKey:@"y"] width:[params objectForKey:@"width"] height:[params objectForKey:@"height"] color:[params objectForKey:@"color"] outlineColor:[params objectForKey:@"outlineColor"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"highlightQuad"] && [self.delegate respondsToSelector:@selector(domain:highlightQuadWithQuad:color:outlineColor:callback:)]) {
        [self.delegate domain:self highlightQuadWithQuad:[params objectForKey:@"quad"] color:[params objectForKey:@"color"] outlineColor:[params objectForKey:@"outlineColor"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"highlightNode"] && [self.delegate respondsToSelector:@selector(domain:highlightNodeWithHighlightConfig:nodeId:backendNodeId:objectId:callback:)]) {
        [self.delegate domain:self highlightNodeWithHighlightConfig:[params objectForKey:@"highlightConfig"] nodeId:[params objectForKey:@"nodeId"] backendNodeId:[params objectForKey:@"backendNodeId"] objectId:[params objectForKey:@"objectId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"hideHighlight"] && [self.delegate respondsToSelector:@selector(domain:hideHighlightWithCallback:)]) {
        [self.delegate domain:self hideHighlightWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"highlightFrame"] && [self.delegate respondsToSelector:@selector(domain:highlightFrameWithFrameId:contentColor:contentOutlineColor:callback:)]) {
        [self.delegate domain:self highlightFrameWithFrameId:[params objectForKey:@"frameId"] contentColor:[params objectForKey:@"contentColor"] contentOutlineColor:[params objectForKey:@"contentOutlineColor"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"pushNodeByPathToFrontend"] && [self.delegate respondsToSelector:@selector(domain:pushNodeByPathToFrontendWithPath:callback:)]) {
        [self.delegate domain:self pushNodeByPathToFrontendWithPath:[params objectForKey:@"path"] callback:^(NSNumber *nodeId, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (nodeId != nil) {
                [params setObject:nodeId forKey:@"nodeId"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"pushNodesByBackendIdsToFrontend"] && [self.delegate respondsToSelector:@selector(domain:pushNodesByBackendIdsToFrontendWithBackendNodeIds:callback:)]) {
        [self.delegate domain:self pushNodesByBackendIdsToFrontendWithBackendNodeIds:[params objectForKey:@"backendNodeIds"] callback:^(NSArray *nodeIds, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (nodeIds != nil) {
                [params setObject:nodeIds forKey:@"nodeIds"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setInspectedNode"] && [self.delegate respondsToSelector:@selector(domain:setInspectedNodeWithNodeId:callback:)]) {
        [self.delegate domain:self setInspectedNodeWithNodeId:[params objectForKey:@"nodeId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"resolveNode"] && [self.delegate respondsToSelector:@selector(domain:resolveNodeWithNodeId:objectGroup:callback:)]) {
        [self.delegate domain:self resolveNodeWithNodeId:[params objectForKey:@"nodeId"] objectGroup:[params objectForKey:@"objectGroup"] callback:^(PDRuntimeRemoteObject *object, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (object != nil) {
                [params setObject:object forKey:@"object"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getAttributes"] && [self.delegate respondsToSelector:@selector(domain:getAttributesWithNodeId:callback:)]) {
        [self.delegate domain:self getAttributesWithNodeId:[params objectForKey:@"nodeId"] callback:^(NSArray *attributes, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (attributes != nil) {
                [params setObject:attributes forKey:@"attributes"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"copyTo"] && [self.delegate respondsToSelector:@selector(domain:copyToWithNodeId:targetNodeId:insertBeforeNodeId:callback:)]) {
        [self.delegate domain:self copyToWithNodeId:[params objectForKey:@"nodeId"] targetNodeId:[params objectForKey:@"targetNodeId"] insertBeforeNodeId:[params objectForKey:@"insertBeforeNodeId"] callback:^(NSNumber *nodeId, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (nodeId != nil) {
                [params setObject:nodeId forKey:@"nodeId"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"moveTo"] && [self.delegate respondsToSelector:@selector(domain:moveToWithNodeId:targetNodeId:insertBeforeNodeId:callback:)]) {
        [self.delegate domain:self moveToWithNodeId:[params objectForKey:@"nodeId"] targetNodeId:[params objectForKey:@"targetNodeId"] insertBeforeNodeId:[params objectForKey:@"insertBeforeNodeId"] callback:^(NSNumber *nodeId, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (nodeId != nil) {
                [params setObject:nodeId forKey:@"nodeId"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"undo"] && [self.delegate respondsToSelector:@selector(domain:undoWithCallback:)]) {
        [self.delegate domain:self undoWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"redo"] && [self.delegate respondsToSelector:@selector(domain:redoWithCallback:)]) {
        [self.delegate domain:self redoWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"markUndoableState"] && [self.delegate respondsToSelector:@selector(domain:markUndoableStateWithCallback:)]) {
        [self.delegate domain:self markUndoableStateWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"focus"] && [self.delegate respondsToSelector:@selector(domain:focusWithNodeId:callback:)]) {
        [self.delegate domain:self focusWithNodeId:[params objectForKey:@"nodeId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setFileInputFiles"] && [self.delegate respondsToSelector:@selector(domain:setFileInputFilesWithNodeId:files:callback:)]) {
        [self.delegate domain:self setFileInputFilesWithNodeId:[params objectForKey:@"nodeId"] files:[params objectForKey:@"files"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getBoxModel"] && [self.delegate respondsToSelector:@selector(domain:getBoxModelWithNodeId:callback:)]) {
        [self.delegate domain:self getBoxModelWithNodeId:[params objectForKey:@"nodeId"] callback:^(PDDOMBoxModel *model, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (model != nil) {
                [params setObject:model forKey:@"model"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getNodeForLocation"] && [self.delegate respondsToSelector:@selector(domain:getNodeForLocationWithX:y:callback:)]) {
        [self.delegate domain:self getNodeForLocationWithX:[params objectForKey:@"x"] y:[params objectForKey:@"y"] callback:^(NSNumber *nodeId, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (nodeId != nil) {
                [params setObject:nodeId forKey:@"nodeId"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getRelayoutBoundary"] && [self.delegate respondsToSelector:@selector(domain:getRelayoutBoundaryWithNodeId:callback:)]) {
        [self.delegate domain:self getRelayoutBoundaryWithNodeId:[params objectForKey:@"nodeId"] callback:^(NSNumber *nodeId, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (nodeId != nil) {
                [params setObject:nodeId forKey:@"nodeId"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getHighlightObjectForTest"] && [self.delegate respondsToSelector:@selector(domain:getHighlightObjectForTestWithNodeId:callback:)]) {
        [self.delegate domain:self getHighlightObjectForTestWithNodeId:[params objectForKey:@"nodeId"] callback:^(NSDictionary *highlight, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (highlight != nil) {
                [params setObject:highlight forKey:@"highlight"];
            }

            responseCallback(params, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDDOMDomain)

- (PDDOMDomain *)DOMDomain;
{
    return [self domainForName:@"DOM"];
}

@end
