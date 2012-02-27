#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


@class PDDebuggerLocation;


// DOM interaction is implemented in terms of mirror objects that represent the actual DOM nodes. DOMNode is a base node mirror type.
@interface PDDOMNode : PDObject

// Node identifier that is passed into the rest of the DOM messages as the <code>nodeId</code>. Backend will only push node with given <code>id</code> once. It is aware of all requested nodes and will only fire DOM events for nodes known to the client.
@property (nonatomic, retain) NSNumber *nodeId;

// <code>Node</code>'s nodeType.
// Type: integer
@property (nonatomic, retain) NSNumber *nodeType;

// <code>Node</code>'s nodeName.
// Type: string
@property (nonatomic, retain) NSString *nodeName;

// <code>Node</code>'s localName.
// Type: string
@property (nonatomic, retain) NSString *localName;

// <code>Node</code>'s nodeValue.
// Type: string
@property (nonatomic, retain) NSString *nodeValue;

// Child count for <code>Container</code> nodes.
// Type: integer
@property (nonatomic, retain) NSNumber *childNodeCount;

// Child nodes of this node when requested with children.
// Type: array
@property (nonatomic, retain) NSArray *children;

// Attributes of the <code>Element</code> node in the form of flat array <code>[name1, value1, name2, value2]</code>.
// Type: array
@property (nonatomic, retain) NSArray *attributes;

// Document URL that <code>Document</code> or <code>FrameOwner</code> node points to.
// Type: string
@property (nonatomic, retain) NSString *documentURL;

// <code>DocumentType</code>'s publicId.
// Type: string
@property (nonatomic, retain) NSString *publicId;

// <code>DocumentType</code>'s systemId.
// Type: string
@property (nonatomic, retain) NSString *systemId;

// <code>DocumentType</code>'s internalSubset.
// Type: string
@property (nonatomic, retain) NSString *internalSubset;

// <code>Document</code>'s XML version in case of XML documents.
// Type: string
@property (nonatomic, retain) NSString *xmlVersion;

// <code>Attr</code>'s name.
// Type: string
@property (nonatomic, retain) NSString *name;

// <code>Attr</code>'s value.
// Type: string
@property (nonatomic, retain) NSString *value;

// Content document for frame owner elements.
@property (nonatomic, retain) PDDOMNode *contentDocument;

@end


// DOM interaction is implemented in terms of mirror objects that represent the actual DOM nodes. DOMNode is a base node mirror type.
@interface PDDOMEventListener : PDObject

// <code>EventListener</code>'s type.
// Type: string
@property (nonatomic, retain) NSString *type;

// <code>EventListener</code>'s useCapture.
// Type: boolean
@property (nonatomic, retain) NSNumber *useCapture;

// <code>EventListener</code>'s isAttribute.
// Type: boolean
@property (nonatomic, retain) NSNumber *isAttribute;

// Target <code>DOMNode</code> id.
@property (nonatomic, retain) NSNumber *nodeId;

// Event handler function body.
// Type: string
@property (nonatomic, retain) NSString *handlerBody;

// Handler code location.
@property (nonatomic, retain) PDDebuggerLocation *location;

@end


// A structure holding an RGBA color.
@interface PDDOMRGBA : PDObject

// The red component, in the [0-255] range.
// Type: integer
@property (nonatomic, retain) NSNumber *r;

// The green component, in the [0-255] range.
// Type: integer
@property (nonatomic, retain) NSNumber *g;

// The blue component, in the [0-255] range.
// Type: integer
@property (nonatomic, retain) NSNumber *b;

// The alpha component, in the [0-1] range (default: 1).
// Type: number
@property (nonatomic, retain) NSNumber *a;

@end


// Configuration data for the highlighting of page elements.
@interface PDDOMHighlightConfig : PDObject

// Whether the node info tooltip should be shown (default: false).
// Type: boolean
@property (nonatomic, retain) NSNumber *showInfo;

// The content box highlight fill color (default: transparent).
@property (nonatomic, retain) PDDOMRGBA *contentColor;

// The padding highlight fill color (default: transparent).
@property (nonatomic, retain) PDDOMRGBA *paddingColor;

// The border highlight fill color (default: transparent).
@property (nonatomic, retain) PDDOMRGBA *borderColor;

// The margin highlight fill color (default: transparent).
@property (nonatomic, retain) PDDOMRGBA *marginColor;

@end


