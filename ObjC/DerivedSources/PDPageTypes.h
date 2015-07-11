//    
//  PDPageTypes.h
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


/// Information about the Frame on the page.
@interface PDPageFrame : PDObject

/// Frame unique identifier.
/// Type: string
@property (nonatomic, strong) NSString *identifier;

/// Parent frame identifier.
/// Type: string
@property (nonatomic, strong) NSString *parentId;

/// Identifier of the loader associated with this frame.
@property (nonatomic, strong) NSString *loaderId;

/// Frame's name as specified in the tag.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// Frame document's URL.
/// Type: string
@property (nonatomic, strong) NSString *url;

/// Frame document's security origin.
/// Type: string
@property (nonatomic, strong) NSString *securityOrigin;

/// Frame document's mimeType as determined by the browser.
/// Type: string
@property (nonatomic, strong) NSString *mimeType;

@end


/// Information about the Frame hierarchy along with their cached resources.
@interface PDPageFrameResourceTree : PDObject

/// Frame information for this tree item.
@property (nonatomic, strong) PDPageFrame *frame;

/// Child frames.
/// Type: array
@property (nonatomic, strong) NSArray *childFrames;

/// Information about frame resources.
/// Type: array
@property (nonatomic, strong) NSArray *resources;

@end


/// Navigation history entry.
@interface PDPageNavigationEntry : PDObject

/// Unique id of the navigation history entry.
/// Type: integer
@property (nonatomic, strong) NSNumber *identifier;

/// URL of the navigation history entry.
/// Type: string
@property (nonatomic, strong) NSString *url;

/// Title of the navigation history entry.
/// Type: string
@property (nonatomic, strong) NSString *title;

@end


/// Screencast frame metadata
@interface PDPageScreencastFrameMetadata : PDObject

/// Top offset in DIP.
/// Type: number
@property (nonatomic, strong) NSNumber *offsetTop;

/// Page scale factor.
/// Type: number
@property (nonatomic, strong) NSNumber *pageScaleFactor;

/// Device screen width in DIP.
/// Type: number
@property (nonatomic, strong) NSNumber *deviceWidth;

/// Device screen height in DIP.
/// Type: number
@property (nonatomic, strong) NSNumber *deviceHeight;

/// Position of horizontal scroll in CSS pixels.
/// Type: number
@property (nonatomic, strong) NSNumber *scrollOffsetX;

/// Position of vertical scroll in CSS pixels.
/// Type: number
@property (nonatomic, strong) NSNumber *scrollOffsetY;

/// Frame swap timestamp.
/// Type: number
@property (nonatomic, strong) NSNumber *timestamp;

@end


