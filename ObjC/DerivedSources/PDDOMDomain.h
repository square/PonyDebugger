//
//  PDDOMDomain.h
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

@class PDDOMHighlightConfig;
@class PDDOMRGBA;
@class PDRuntimeRemoteObject;
@class PDDOMBoxModel;
@class PDDOMNode;

@protocol PDDOMCommandDelegate;

// This domain exposes DOM read/write operations. Each DOM Node is represented with its mirror object that has an <code>id</code>. This <code>id</code> can be used to get additional information on the Node, resolve it into the JavaScript object wrapper, etc. It is important that client receives DOM events only for the nodes that are known to the client. Backend keeps track of the nodes that were sent to the client and never sends the same node twice. It is client's responsibility to collect information about the nodes that were sent to the client.<p>Note that <code>iframe</code> owner elements will return corresponding document elements as their child nodes.</p>
@interface PDDOMDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDDOMCommandDelegate, PDCommandDelegate> delegate;

// Events

// Fired when <code>Document</code> has been totally updated. Node ids are no longer valid.
- (void)documentUpdated;

// Fired when the node should be inspected. This happens after call to <code>setInspectModeEnabled</code>.
// Param backendNodeId: Id of the node to inspect.
- (void)inspectNodeRequestedWithBackendNodeId:(NSNumber *)backendNodeId;

// Fired when backend wants to provide client with the missing DOM structure. This happens upon most of the calls requesting node ids.
// Param parentId: Parent node id to populate with children.
// Param nodes: Child nodes array.
- (void)setChildNodesWithParentId:(NSNumber *)parentId nodes:(NSArray *)nodes;

// Fired when <code>Element</code>'s attribute is modified.
// Param nodeId: Id of the node that has changed.
// Param name: Attribute name.
// Param value: Attribute value.
- (void)attributeModifiedWithNodeId:(NSNumber *)nodeId name:(NSString *)name value:(NSString *)value;

// Fired when <code>Element</code>'s attribute is removed.
// Param nodeId: Id of the node that has changed.
// Param name: A ttribute name.
- (void)attributeRemovedWithNodeId:(NSNumber *)nodeId name:(NSString *)name;

// Fired when <code>Element</code>'s inline style is modified via a CSS property modification.
// Param nodeIds: Ids of the nodes for which the inline styles have been invalidated.
- (void)inlineStyleInvalidatedWithNodeIds:(NSArray *)nodeIds;

// Mirrors <code>DOMCharacterDataModified</code> event.
// Param nodeId: Id of the node that has changed.
// Param characterData: New text value.
- (void)characterDataModifiedWithNodeId:(NSNumber *)nodeId characterData:(NSString *)characterData;

// Fired when <code>Container</code>'s child node count has changed.
// Param nodeId: Id of the node that has changed.
// Param childNodeCount: New node count.
- (void)childNodeCountUpdatedWithNodeId:(NSNumber *)nodeId childNodeCount:(NSNumber *)childNodeCount;

// Mirrors <code>DOMNodeInserted</code> event.
// Param parentNodeId: Id of the node that has changed.
// Param previousNodeId: If of the previous siblint.
// Param node: Inserted node data.
- (void)childNodeInsertedWithParentNodeId:(NSNumber *)parentNodeId previousNodeId:(NSNumber *)previousNodeId node:(PDDOMNode *)node;

// Mirrors <code>DOMNodeRemoved</code> event.
// Param parentNodeId: Parent id.
// Param nodeId: Id of the node that has been removed.
- (void)childNodeRemovedWithParentNodeId:(NSNumber *)parentNodeId nodeId:(NSNumber *)nodeId;

// Called when shadow root is pushed into the element.
// Param hostId: Host element id.
// Param root: Shadow root.
- (void)shadowRootPushedWithHostId:(NSNumber *)hostId root:(PDDOMNode *)root;

// Called when shadow root is popped from the element.
// Param hostId: Host element id.
// Param rootId: Shadow root id.
- (void)shadowRootPoppedWithHostId:(NSNumber *)hostId rootId:(NSNumber *)rootId;

// Called when a pseudo element is added to an element.
// Param parentId: Pseudo element's parent element id.
// Param pseudoElement: The added pseudo element.
- (void)pseudoElementAddedWithParentId:(NSNumber *)parentId pseudoElement:(PDDOMNode *)pseudoElement;

// Called when a pseudo element is removed from an element.
// Param parentId: Pseudo element's parent element id.
// Param pseudoElementId: The removed pseudo element id.
- (void)pseudoElementRemovedWithParentId:(NSNumber *)parentId pseudoElementId:(NSNumber *)pseudoElementId;

// Called when distrubution is changed.
// Param insertionPointId: Insertion point where distrubuted nodes were updated.
// Param distributedNodes: Distributed nodes for given insertion point.
- (void)distributedNodesUpdatedWithInsertionPointId:(NSNumber *)insertionPointId distributedNodes:(NSArray *)distributedNodes;

@end

@protocol PDDOMCommandDelegate <PDCommandDelegate>
@optional

/// Enables DOM agent for the given page.
- (void)domain:(PDDOMDomain *)domain enableWithCallback:(void (^)(id error))callback;

/// Disables DOM agent for the given page.
- (void)domain:(PDDOMDomain *)domain disableWithCallback:(void (^)(id error))callback;

/// Returns the root DOM node to the caller.
// Callback Param root: Resulting node.
- (void)domain:(PDDOMDomain *)domain getDocumentWithCallback:(void (^)(PDDOMNode *root, id error))callback;

/// Requests that children of the node with given id are returned to the caller in form of <code>setChildNodes</code> events where not only immediate children are retrieved, but all children down to the specified depth.
// Param nodeId: Id of the node to get children for.
// Param depth: The maximum depth at which children should be retrieved, defaults to 1. Use -1 for the entire subtree or provide an integer larger than 0.
- (void)domain:(PDDOMDomain *)domain requestChildNodesWithNodeId:(NSNumber *)nodeId depth:(NSNumber *)depth callback:(void (^)(id error))callback;

/// Executes <code>querySelector</code> on a given node.
// Param nodeId: Id of the node to query upon.
// Param selector: Selector string.
// Callback Param nodeId: Query selector result.
- (void)domain:(PDDOMDomain *)domain querySelectorWithNodeId:(NSNumber *)nodeId selector:(NSString *)selector callback:(void (^)(NSNumber *nodeId, id error))callback;

/// Executes <code>querySelectorAll</code> on a given node.
// Param nodeId: Id of the node to query upon.
// Param selector: Selector string.
// Callback Param nodeIds: Query selector result.
- (void)domain:(PDDOMDomain *)domain querySelectorAllWithNodeId:(NSNumber *)nodeId selector:(NSString *)selector callback:(void (^)(NSArray *nodeIds, id error))callback;

/// Sets node name for a node with given id.
// Param nodeId: Id of the node to set name for.
// Param name: New node's name.
// Callback Param nodeId: New node's id.
- (void)domain:(PDDOMDomain *)domain setNodeNameWithNodeId:(NSNumber *)nodeId name:(NSString *)name callback:(void (^)(NSNumber *nodeId, id error))callback;

/// Sets node value for a node with given id.
// Param nodeId: Id of the node to set value for.
// Param value: New node's value.
- (void)domain:(PDDOMDomain *)domain setNodeValueWithNodeId:(NSNumber *)nodeId value:(NSString *)value callback:(void (^)(id error))callback;

/// Removes node with given id.
// Param nodeId: Id of the node to remove.
- (void)domain:(PDDOMDomain *)domain removeNodeWithNodeId:(NSNumber *)nodeId callback:(void (^)(id error))callback;

/// Sets attribute for an element with given id.
// Param nodeId: Id of the element to set attribute for.
// Param name: Attribute name.
// Param value: Attribute value.
- (void)domain:(PDDOMDomain *)domain setAttributeValueWithNodeId:(NSNumber *)nodeId name:(NSString *)name value:(NSString *)value callback:(void (^)(id error))callback;

/// Sets attributes on element with given id. This method is useful when user edits some existing attribute value and types in several attribute name/value pairs.
// Param nodeId: Id of the element to set attributes for.
// Param text: Text with a number of attributes. Will parse this text using HTML parser.
// Param name: Attribute name to replace with new attributes derived from text in case text parsed successfully.
- (void)domain:(PDDOMDomain *)domain setAttributesAsTextWithNodeId:(NSNumber *)nodeId text:(NSString *)text name:(NSString *)name callback:(void (^)(id error))callback;

/// Removes attribute with given name from an element with given id.
// Param nodeId: Id of the element to remove attribute from.
// Param name: Name of the attribute to remove.
- (void)domain:(PDDOMDomain *)domain removeAttributeWithNodeId:(NSNumber *)nodeId name:(NSString *)name callback:(void (^)(id error))callback;

/// Returns node's HTML markup.
// Param nodeId: Id of the node to get markup for.
// Callback Param outerHTML: Outer HTML markup.
- (void)domain:(PDDOMDomain *)domain getOuterHTMLWithNodeId:(NSNumber *)nodeId callback:(void (^)(NSString *outerHTML, id error))callback;

/// Sets node HTML markup, returns new node id.
// Param nodeId: Id of the node to set markup for.
// Param outerHTML: Outer HTML markup to set.
- (void)domain:(PDDOMDomain *)domain setOuterHTMLWithNodeId:(NSNumber *)nodeId outerHTML:(NSString *)outerHTML callback:(void (^)(id error))callback;

/// Searches for a given string in the DOM tree. Use <code>getSearchResults</code> to access search results or <code>cancelSearch</code> to end this search session.
// Param query: Plain text or query selector or XPath search query.
// Param includeUserAgentShadowDOM: True to search in user agent shadow DOM.
// Callback Param searchId: Unique search session identifier.
// Callback Param resultCount: Number of search results.
- (void)domain:(PDDOMDomain *)domain performSearchWithQuery:(NSString *)query includeUserAgentShadowDOM:(NSNumber *)includeUserAgentShadowDOM callback:(void (^)(NSString *searchId, NSNumber *resultCount, id error))callback;

/// Returns search results from given <code>fromIndex</code> to given <code>toIndex</code> from the sarch with the given identifier.
// Param searchId: Unique search session identifier.
// Param fromIndex: Start index of the search result to be returned.
// Param toIndex: End index of the search result to be returned.
// Callback Param nodeIds: Ids of the search result nodes.
- (void)domain:(PDDOMDomain *)domain getSearchResultsWithSearchId:(NSString *)searchId fromIndex:(NSNumber *)fromIndex toIndex:(NSNumber *)toIndex callback:(void (^)(NSArray *nodeIds, id error))callback;

/// Discards search results from the session with the given id. <code>getSearchResults</code> should no longer be called for that search.
// Param searchId: Unique search session identifier.
- (void)domain:(PDDOMDomain *)domain discardSearchResultsWithSearchId:(NSString *)searchId callback:(void (^)(id error))callback;

/// Requests that the node is sent to the caller given the JavaScript node object reference. All nodes that form the path from the node to the root are also sent to the client as a series of <code>setChildNodes</code> notifications.
// Param objectId: JavaScript object id to convert into node.
// Callback Param nodeId: Node id for given object.
- (void)domain:(PDDOMDomain *)domain requestNodeWithObjectId:(NSString *)objectId callback:(void (^)(NSNumber *nodeId, id error))callback;

/// Enters the 'inspect' mode. In this mode, elements that user is hovering over are highlighted. Backend then generates 'inspectNodeRequested' event upon element selection.
// Param enabled: True to enable inspection mode, false to disable it.
// Param inspectUAShadowDOM: True to enable inspection mode for user agent shadow DOM.
// Param highlightConfig: A descriptor for the highlight appearance of hovered-over nodes. May be omitted if <code>enabled == false</code>.
- (void)domain:(PDDOMDomain *)domain setInspectModeEnabledWithEnabled:(NSNumber *)enabled inspectUAShadowDOM:(NSNumber *)inspectUAShadowDOM highlightConfig:(PDDOMHighlightConfig *)highlightConfig callback:(void (^)(id error))callback;

/// Highlights given rectangle. Coordinates are absolute with respect to the main frame viewport.
// Param x: X coordinate
// Param y: Y coordinate
// Param width: Rectangle width
// Param height: Rectangle height
// Param color: The highlight fill color (default: transparent).
// Param outlineColor: The highlight outline color (default: transparent).
- (void)domain:(PDDOMDomain *)domain highlightRectWithX:(NSNumber *)x y:(NSNumber *)y width:(NSNumber *)width height:(NSNumber *)height color:(PDDOMRGBA *)color outlineColor:(PDDOMRGBA *)outlineColor callback:(void (^)(id error))callback;

/// Highlights given quad. Coordinates are absolute with respect to the main frame viewport.
// Param quad: Quad to highlight
// Param color: The highlight fill color (default: transparent).
// Param outlineColor: The highlight outline color (default: transparent).
- (void)domain:(PDDOMDomain *)domain highlightQuadWithQuad:(NSArray *)quad color:(PDDOMRGBA *)color outlineColor:(PDDOMRGBA *)outlineColor callback:(void (^)(id error))callback;

/// Highlights DOM node with given id or with the given JavaScript object wrapper. Either nodeId or objectId must be specified.
// Param highlightConfig: A descriptor for the highlight appearance.
// Param nodeId: Identifier of the node to highlight.
// Param backendNodeId: Identifier of the backend node to highlight.
// Param objectId: JavaScript object id of the node to be highlighted.
- (void)domain:(PDDOMDomain *)domain highlightNodeWithHighlightConfig:(PDDOMHighlightConfig *)highlightConfig nodeId:(NSNumber *)nodeId backendNodeId:(NSNumber *)backendNodeId objectId:(NSString *)objectId callback:(void (^)(id error))callback;

/// Hides DOM node highlight.
- (void)domain:(PDDOMDomain *)domain hideHighlightWithCallback:(void (^)(id error))callback;

/// Highlights owner element of the frame with given id.
// Param frameId: Identifier of the frame to highlight.
// Param contentColor: The content box highlight fill color (default: transparent).
// Param contentOutlineColor: The content box highlight outline color (default: transparent).
- (void)domain:(PDDOMDomain *)domain highlightFrameWithFrameId:(NSString *)frameId contentColor:(PDDOMRGBA *)contentColor contentOutlineColor:(PDDOMRGBA *)contentOutlineColor callback:(void (^)(id error))callback;

/// Requests that the node is sent to the caller given its path. // FIXME, use XPath
// Param path: Path to node in the proprietary format.
// Callback Param nodeId: Id of the node for given path.
- (void)domain:(PDDOMDomain *)domain pushNodeByPathToFrontendWithPath:(NSString *)path callback:(void (^)(NSNumber *nodeId, id error))callback;

/// Requests that a batch of nodes is sent to the caller given their backend node ids.
// Param backendNodeIds: The array of backend node ids.
// Callback Param nodeIds: The array of ids of pushed nodes that correspond to the backend ids specified in backendNodeIds.
- (void)domain:(PDDOMDomain *)domain pushNodesByBackendIdsToFrontendWithBackendNodeIds:(NSArray *)backendNodeIds callback:(void (^)(NSArray *nodeIds, id error))callback;

/// Enables console to refer to the node with given id via $x (see Command Line API for more details $x functions).
// Param nodeId: DOM node id to be accessible by means of $x command line API.
- (void)domain:(PDDOMDomain *)domain setInspectedNodeWithNodeId:(NSNumber *)nodeId callback:(void (^)(id error))callback;

/// Resolves JavaScript node object for given node id.
// Param nodeId: Id of the node to resolve.
// Param objectGroup: Symbolic group name that can be used to release multiple objects.
// Callback Param object: JavaScript object wrapper for given node.
- (void)domain:(PDDOMDomain *)domain resolveNodeWithNodeId:(NSNumber *)nodeId objectGroup:(NSString *)objectGroup callback:(void (^)(PDRuntimeRemoteObject *object, id error))callback;

/// Returns attributes for the specified node.
// Param nodeId: Id of the node to retrieve attibutes for.
// Callback Param attributes: An interleaved array of node attribute names and values.
- (void)domain:(PDDOMDomain *)domain getAttributesWithNodeId:(NSNumber *)nodeId callback:(void (^)(NSArray *attributes, id error))callback;

/// Creates a deep copy of the specified node and places it into the target container before the given anchor.
// Param nodeId: Id of the node to copy.
// Param targetNodeId: Id of the element to drop the copy into.
// Param insertBeforeNodeId: Drop the copy before this node (if absent, the copy becomes the last child of <code>targetNodeId</code>).
// Callback Param nodeId: Id of the node clone.
- (void)domain:(PDDOMDomain *)domain copyToWithNodeId:(NSNumber *)nodeId targetNodeId:(NSNumber *)targetNodeId insertBeforeNodeId:(NSNumber *)insertBeforeNodeId callback:(void (^)(NSNumber *nodeId, id error))callback;

/// Moves node into the new container, places it before the given anchor.
// Param nodeId: Id of the node to move.
// Param targetNodeId: Id of the element to drop the moved node into.
// Param insertBeforeNodeId: Drop node before this one (if absent, the moved node becomes the last child of <code>targetNodeId</code>).
// Callback Param nodeId: New id of the moved node.
- (void)domain:(PDDOMDomain *)domain moveToWithNodeId:(NSNumber *)nodeId targetNodeId:(NSNumber *)targetNodeId insertBeforeNodeId:(NSNumber *)insertBeforeNodeId callback:(void (^)(NSNumber *nodeId, id error))callback;

/// Undoes the last performed action.
- (void)domain:(PDDOMDomain *)domain undoWithCallback:(void (^)(id error))callback;

/// Re-does the last undone action.
- (void)domain:(PDDOMDomain *)domain redoWithCallback:(void (^)(id error))callback;

/// Marks last undoable state.
- (void)domain:(PDDOMDomain *)domain markUndoableStateWithCallback:(void (^)(id error))callback;

/// Focuses the given element.
// Param nodeId: Id of the node to focus.
- (void)domain:(PDDOMDomain *)domain focusWithNodeId:(NSNumber *)nodeId callback:(void (^)(id error))callback;

/// Sets files for the given file input element.
// Param nodeId: Id of the file input node to set files for.
// Param files: Array of file paths to set.
- (void)domain:(PDDOMDomain *)domain setFileInputFilesWithNodeId:(NSNumber *)nodeId files:(NSArray *)files callback:(void (^)(id error))callback;

/// Returns boxes for the currently selected nodes.
// Param nodeId: Id of the node to get box model for.
// Callback Param model: Box model for the node.
- (void)domain:(PDDOMDomain *)domain getBoxModelWithNodeId:(NSNumber *)nodeId callback:(void (^)(PDDOMBoxModel *model, id error))callback;

/// Returns node id at given location.
// Param x: X coordinate.
// Param y: Y coordinate.
// Callback Param nodeId: Id of the node at given coordinates.
- (void)domain:(PDDOMDomain *)domain getNodeForLocationWithX:(NSNumber *)x y:(NSNumber *)y callback:(void (^)(NSNumber *nodeId, id error))callback;

/// Returns the id of the nearest ancestor that is a relayout boundary.
// Param nodeId: Id of the node.
// Callback Param nodeId: Relayout boundary node id for the given node.
- (void)domain:(PDDOMDomain *)domain getRelayoutBoundaryWithNodeId:(NSNumber *)nodeId callback:(void (^)(NSNumber *nodeId, id error))callback;

/// For testing.
// Param nodeId: Id of the node to get highlight object for.
// Callback Param highlight: Highlight data for the node.
- (void)domain:(PDDOMDomain *)domain getHighlightObjectForTestWithNodeId:(NSNumber *)nodeId callback:(void (^)(NSDictionary *highlight, id error))callback;

@end

@interface PDDebugger (PDDOMDomain)

@property (nonatomic, readonly, strong) PDDOMDomain *DOMDomain;

@end
