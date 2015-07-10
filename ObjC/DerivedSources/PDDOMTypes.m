//
//  PDDOMTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDDOMTypes.h"

@implementation PDDOMBackendNode

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"nodeType",@"nodeType",
                    @"nodeName",@"nodeName",
                    @"backendNodeId",@"backendNodeId",
                    nil];
    });

    return mappings;
}

@dynamic nodeType;
@dynamic nodeName;
@dynamic backendNodeId;
 
@end

@implementation PDDOMNode

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"nodeId",@"nodeId",
                    @"nodeType",@"nodeType",
                    @"nodeName",@"nodeName",
                    @"localName",@"localName",
                    @"nodeValue",@"nodeValue",
                    @"childNodeCount",@"childNodeCount",
                    @"children",@"children",
                    @"attributes",@"attributes",
                    @"documentURL",@"documentURL",
                    @"baseURL",@"baseURL",
                    @"publicId",@"publicId",
                    @"systemId",@"systemId",
                    @"internalSubset",@"internalSubset",
                    @"xmlVersion",@"xmlVersion",
                    @"name",@"name",
                    @"value",@"value",
                    @"pseudoType",@"pseudoType",
                    @"shadowRootType",@"shadowRootType",
                    @"frameId",@"frameId",
                    @"contentDocument",@"contentDocument",
                    @"shadowRoots",@"shadowRoots",
                    @"templateContent",@"templateContent",
                    @"pseudoElements",@"pseudoElements",
                    @"importedDocument",@"importedDocument",
                    @"distributedNodes",@"distributedNodes",
                    nil];
    });

    return mappings;
}

@dynamic nodeId;
@dynamic nodeType;
@dynamic nodeName;
@dynamic localName;
@dynamic nodeValue;
@dynamic childNodeCount;
@dynamic children;
@dynamic attributes;
@dynamic documentURL;
@dynamic baseURL;
@dynamic publicId;
@dynamic systemId;
@dynamic internalSubset;
@dynamic xmlVersion;
@dynamic name;
@dynamic value;
@dynamic pseudoType;
@dynamic shadowRootType;
@dynamic frameId;
@dynamic contentDocument;
@dynamic shadowRoots;
@dynamic templateContent;
@dynamic pseudoElements;
@dynamic importedDocument;
@dynamic distributedNodes;
 
@end

@implementation PDDOMRGBA

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"r",@"r",
                    @"g",@"g",
                    @"b",@"b",
                    @"a",@"a",
                    nil];
    });

    return mappings;
}

@dynamic r;
@dynamic g;
@dynamic b;
@dynamic a;
 
@end

@implementation PDDOMBoxModel

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"content",@"content",
                    @"padding",@"padding",
                    @"border",@"border",
                    @"margin",@"margin",
                    @"width",@"width",
                    @"height",@"height",
                    @"shapeOutside",@"shapeOutside",
                    nil];
    });

    return mappings;
}

@dynamic content;
@dynamic padding;
@dynamic border;
@dynamic margin;
@dynamic width;
@dynamic height;
@dynamic shapeOutside;
 
@end

@implementation PDDOMShapeOutsideInfo

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"bounds",@"bounds",
                    @"shape",@"shape",
                    @"marginShape",@"marginShape",
                    nil];
    });

    return mappings;
}

@dynamic bounds;
@dynamic shape;
@dynamic marginShape;
 
@end

@implementation PDDOMRect

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"x",@"x",
                    @"y",@"y",
                    @"width",@"width",
                    @"height",@"height",
                    nil];
    });

    return mappings;
}

@dynamic x;
@dynamic y;
@dynamic width;
@dynamic height;
 
@end

@implementation PDDOMHighlightConfig

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"showInfo",@"showInfo",
                    @"showRulers",@"showRulers",
                    @"showExtensionLines",@"showExtensionLines",
                    @"showLayoutEditor",@"showLayoutEditor",
                    @"contentColor",@"contentColor",
                    @"paddingColor",@"paddingColor",
                    @"borderColor",@"borderColor",
                    @"marginColor",@"marginColor",
                    @"eventTargetColor",@"eventTargetColor",
                    @"shapeColor",@"shapeColor",
                    @"shapeMarginColor",@"shapeMarginColor",
                    nil];
    });

    return mappings;
}

@dynamic showInfo;
@dynamic showRulers;
@dynamic showExtensionLines;
@dynamic showLayoutEditor;
@dynamic contentColor;
@dynamic paddingColor;
@dynamic borderColor;
@dynamic marginColor;
@dynamic eventTargetColor;
@dynamic shapeColor;
@dynamic shapeMarginColor;
 
@end

