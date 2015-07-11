//    
//  PDLayerTreeTypes.h
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


@class PDDOMRect;


/// Rectangle where scrolling happens on the main thread.
@interface PDLayerTreeScrollRect : PDObject

/// Rectangle itself.
@property (nonatomic, strong) PDDOMRect *rect;

/// Reason for rectangle to force scrolling on the main thread
/// Type: string
@property (nonatomic, strong) NSString *type;

@end


/// Serialized fragment of layer picture along with its offset within the layer.
@interface PDLayerTreePictureTile : PDObject

/// Offset from owning layer left boundary
/// Type: number
@property (nonatomic, strong) NSNumber *x;

/// Offset from owning layer top boundary
/// Type: number
@property (nonatomic, strong) NSNumber *y;

/// Base64-encoded snapshot data.
/// Type: string
@property (nonatomic, strong) NSString *picture;

@end


/// Information about a compositing layer.
@interface PDLayerTreeLayer : PDObject

/// The unique id for this layer.
@property (nonatomic, strong) NSString *layerId;

/// The id of parent (not present for root).
@property (nonatomic, strong) NSString *parentLayerId;

/// The backend id for the node associated with this layer.
@property (nonatomic, strong) NSNumber *backendNodeId;

/// Offset from parent layer, X coordinate.
/// Type: number
@property (nonatomic, strong) NSNumber *offsetX;

/// Offset from parent layer, Y coordinate.
/// Type: number
@property (nonatomic, strong) NSNumber *offsetY;

/// Layer width.
/// Type: number
@property (nonatomic, strong) NSNumber *width;

/// Layer height.
/// Type: number
@property (nonatomic, strong) NSNumber *height;

/// Transformation matrix for layer, default is identity matrix
/// Type: array
@property (nonatomic, strong) NSArray *transform;

/// Transform anchor point X, absent if no transform specified
/// Type: number
@property (nonatomic, strong) NSNumber *anchorX;

/// Transform anchor point Y, absent if no transform specified
/// Type: number
@property (nonatomic, strong) NSNumber *anchorY;

/// Transform anchor point Z, absent if no transform specified
/// Type: number
@property (nonatomic, strong) NSNumber *anchorZ;

/// Indicates how many time this layer has painted.
/// Type: integer
@property (nonatomic, strong) NSNumber *paintCount;

/// Indicates whether this layer hosts any content, rather than being used for transform/scrolling purposes only.
/// Type: boolean
@property (nonatomic, strong) NSNumber *drawsContent;

/// Set if layer is not visible.
/// Type: boolean
@property (nonatomic, strong) NSNumber *invisible;

/// Rectangles scrolling on main thread only.
/// Type: array
@property (nonatomic, strong) NSArray *scrollRects;

@end


