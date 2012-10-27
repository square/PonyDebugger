//
//  PDDOMDomainController.m
//  PonyDebugger
//
//  Created by Ryan Olson on 2012-09-19.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDDOMDomainController.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

// Constants defined in the DOM Level 2 Core: http://www.w3.org/TR/DOM-Level-2-Core/core.html#ID-1950641247
static const int kPDDOMNodeTypeElement = 1;
static const int kPDDOMNodeTypeAttribute = 2;
static const int kPDDOMNodeTypeText = 3;
static const int kPDDOMNodeTypeComment = 8;
static const int kPDDOMNodeTypeDocument = 9;

static NSString *const kPDDOMAttributeParsingRegex = @"[\"'](.*)[\"']";

@interface PDDOMDomainController ()

// Use mirrored dictionaries to map between objets and node ids with fast lookup in both directions
@property (nonatomic, strong) NSMutableDictionary *objectsForNodeIds;
@property (nonatomic, strong) NSMutableDictionary *nodeIdsForObjects;
@property (nonatomic, assign) NSUInteger nodeIdCounter;

@property (nonatomic, strong) UIView *viewToHighlight;
@property (nonatomic, strong) UIView *highlightOverlay;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, assign) CGPoint lastPanPoint;
@property (nonatomic, assign) CGRect originalPinchFrame;
@property (nonatomic, assign) CGPoint originalPinchLocation;

@end

@implementation PDDOMDomainController

#pragma mark - NSObject

- (id)init;
{
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowHidden:) name:UIWindowDidBecomeHiddenNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowShown:) name:UIWindowDidBecomeVisibleNotification object:nil];
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesure:)];
        self.panGestureRecognizer.maximumNumberOfTouches = 1;
        self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    }
    return self;
}

- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Class Methods

+ (PDDOMDomainController *)defaultInstance;
{
    static PDDOMDomainController *defaultInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultInstance = [[PDDOMDomainController alloc] init];
    });
    return defaultInstance;
}

+ (void)startMonitoringUIViewChanges;
{
    // Swizzle UIView add/remove methods to monitor changes in the view hierarchy
    // Only do it once to avoid swapping back if this method is called again
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method original, swizzle;
        Class viewClass = [UIView class];
        
        original = class_getInstanceMethod(viewClass, @selector(addSubview:));
        swizzle = class_getInstanceMethod(viewClass, @selector(pd_swizzled_addSubview:));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(viewClass, @selector(bringSubviewToFront:));
        swizzle = class_getInstanceMethod(viewClass, @selector(pd_swizzled_bringSubviewToFront:));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(viewClass, @selector(sendSubviewToBack:));
        swizzle = class_getInstanceMethod(viewClass, @selector(pd_swizzled_sendSubviewToBack:));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(viewClass, @selector(removeFromSuperview));
        swizzle = class_getInstanceMethod(viewClass, @selector(pd_swizzled_removeFromSuperview));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(viewClass, @selector(insertSubview:atIndex:));
        swizzle = class_getInstanceMethod(viewClass, @selector(pd_swizzled_insertSubview:atIndex:));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(viewClass, @selector(insertSubview:aboveSubview:));
        swizzle = class_getInstanceMethod(viewClass, @selector(pd_swizzled_insertSubview:aboveSubview:));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(viewClass, @selector(insertSubview:belowSubview:));
        swizzle = class_getInstanceMethod(viewClass, @selector(pd_swizzled_insertSubview:belowSubview:));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(viewClass, @selector(exchangeSubviewAtIndex:withSubviewAtIndex:));
        swizzle = class_getInstanceMethod(viewClass, @selector(pd_swizzled_exchangeSubviewAtIndex:withSubviewAtIndex:));
        method_exchangeImplementations(original, swizzle);
    });
}

+ (Class)domainClass;
{
    return [PDDOMDomain class];
}

#pragma mark - Setter Overrides

- (void)setViewKeyPathsToDisplay:(NSArray *)viewKeyPathsToDisplay;
{
    if (![_viewKeyPathsToDisplay isEqualToArray:viewKeyPathsToDisplay]) {
        // Stop tracking all the views to remove KVO
        [self stopTrackingAllViews];
        
        // Now that the observers have been removed, it's safe to change the keyPaths array
        _viewKeyPathsToDisplay = viewKeyPathsToDisplay;
        
        // Refresh the DOM tree to see the new attributes
        [self.domain documentUpdated];
    }
}

#pragma mark - PDDOMCommandDelegate

- (void)domain:(PDDOMDomain *)domain getDocumentWithCallback:(void (^)(PDDOMNode *root, id error))callback;
{
    self.objectsForNodeIds = [[NSMutableDictionary alloc] init];
    self.nodeIdsForObjects = [[NSMutableDictionary alloc] init];
    self.nodeIdCounter = 0;
    callback([self rootNode], nil);
}

- (void)domain:(PDDOMDomain *)domain highlightNodeWithNodeId:(NSNumber *)nodeId highlightConfig:(PDDOMHighlightConfig *)highlightConfig callback:(void (^)(id))callback;
{
    id objectForNodeId = [self.objectsForNodeIds objectForKey:nodeId];
    if ([objectForNodeId isKindOfClass:[UIView class]]) {
        // Add a highlight overlay directly to the window if this is a window, otherwise to the view's window
        self.viewToHighlight = objectForNodeId;
        
        UIWindow *window = self.viewToHighlight.window;
        CGRect highlightFrame = CGRectZero;
        
        if (!window && [self.viewToHighlight isKindOfClass:[UIWindow class]]) {
            window = (UIWindow *)self.viewToHighlight;
            highlightFrame = window.bounds;
        } else {
            highlightFrame = [window convertRect:self.viewToHighlight.frame fromView:self.viewToHighlight.superview];
        }
        
        if (!self.highlightOverlay) {
            self.highlightOverlay = [[UIView alloc] initWithFrame:CGRectZero];
            self.highlightOverlay.layer.borderWidth = 1.0;
            
            [self.highlightOverlay addGestureRecognizer:self.panGestureRecognizer];
            [self.highlightOverlay addGestureRecognizer:self.pinchGestureRecognizer];
        }
        
        self.highlightOverlay.frame = highlightFrame;
        
        // TODO: PDDOMRGBA & PDDOMHighlightConfig objects aren't coming back. Just NSDictionaries
        
        PDDOMRGBA *contentColor = [highlightConfig valueForKey:@"contentColor"];
        NSNumber *r = [contentColor valueForKey:@"r"];
        NSNumber *g = [contentColor valueForKey:@"g"];
        NSNumber *b = [contentColor valueForKey:@"b"];
        NSNumber *a = [contentColor valueForKey:@"a"];
        
        self.highlightOverlay.backgroundColor = [UIColor colorWithRed:[r floatValue] / 255.0 green:[g floatValue] / 255.0 blue:[b floatValue] / 255.0 alpha:[a floatValue]];
        
        PDDOMRGBA *borderColor = [highlightConfig valueForKey:@"borderColor"];
        r = [borderColor valueForKey:@"r"];
        g = [borderColor valueForKey:@"g"];
        b = [borderColor valueForKey:@"b"];
        a = [borderColor valueForKey:@"a"];
        
        self.highlightOverlay.layer.borderColor = [[UIColor colorWithRed:[r floatValue] / 255.0 green:[g floatValue] / 255.0 blue:[b floatValue] / 255.0 alpha:[a floatValue]] CGColor];
        
        [window addSubview:self.highlightOverlay];
    }
    
    callback(nil);
}

- (void)domain:(PDDOMDomain *)domain hideHighlightWithCallback:(void (^)(id))callback;
{
    [self.highlightOverlay removeFromSuperview];
    self.viewToHighlight = nil;
    
    callback(nil);
}

- (void)domain:(PDDOMDomain *)domain removeNodeWithNodeId:(NSNumber *)nodeId callback:(void (^)(id))callback;
{
    UIView *view = [self.objectsForNodeIds objectForKey:nodeId];
    [view removeFromSuperview];
    
    callback(nil);
}

- (void)domain:(PDDOMDomain *)domain setAttributesAsTextWithNodeId:(NSNumber *)nodeId text:(NSString *)text name:(NSString *)name callback:(void (^)(id))callback;
{
    id nodeObject = [self.objectsForNodeIds objectForKey:nodeId];
    const char *typeEncoding = [self typeEncodingForKeyPath:name onObject:nodeObject];
    
    // Try to parse out the value
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kPDDOMAttributeParsingRegex options:0 error:NULL];
    NSTextCheckingResult *firstMatch = [regex firstMatchInString:text options:0 range:NSMakeRange(0, [text length])];
    if (firstMatch) {
        NSString *valueString = [text substringWithRange:[firstMatch rangeAtIndex:1]];
        
        // Note: this is by no means complete...
        // Allow BOOLs to be set with YES/NO
        if (typeEncoding && !strcmp(typeEncoding, @encode(BOOL)) && ([valueString isEqualToString:@"YES"] || [valueString isEqualToString:@"NO"])) {
            BOOL boolValue = [valueString isEqualToString:@"YES"];
            [nodeObject setValue:[NSNumber numberWithBool:boolValue] forKeyPath:name];
        } else if (typeEncoding && !strcmp(typeEncoding, @encode(CGPoint))) {
            CGPoint point = CGPointFromString(valueString);
            [nodeObject setValue:[NSValue valueWithCGPoint:point] forKeyPath:name];
        } else if (typeEncoding && !strcmp(typeEncoding, @encode(CGSize))) {
            CGSize size = CGSizeFromString(valueString);
            [nodeObject setValue:[NSValue valueWithCGSize:size] forKeyPath:name];
        } else if (typeEncoding && !strcmp(typeEncoding, @encode(CGRect))) {
            CGRect rect = CGRectFromString(valueString);
            [nodeObject setValue:[NSValue valueWithCGRect:rect] forKeyPath:name];
        } else {
            NSNumber *number = @([valueString doubleValue]);
            [nodeObject setValue:number forKeyPath:name];
        }
    }
    
    callback(nil);
}

#pragma mark - Gesture Moving and Resizing

- (void)handlePanGesure:(UIPanGestureRecognizer *)panGR;
{
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:
            self.lastPanPoint = [panGR locationInView:self.viewToHighlight.superview];
            break;
            
        default: {
            // Convert to superview coordinates for a consistent basis
            CGPoint newPanPoint = [panGR locationInView:self.viewToHighlight.superview];
            CGFloat deltaX = newPanPoint.x - self.lastPanPoint.x;
            CGFloat deltaY = newPanPoint.y - self.lastPanPoint.y;
            
            CGRect frame = self.viewToHighlight.frame;
            frame.origin.x += deltaX;
            frame.origin.y += deltaY;
            self.viewToHighlight.frame = frame;
            
            self.lastPanPoint = newPanPoint;
            break;
        }
    }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGR;
{
    switch (pinchGR.state) {
        case UIGestureRecognizerStateBegan:
            self.originalPinchFrame = self.viewToHighlight.frame;
            self.originalPinchLocation = [pinchGR locationInView:self.viewToHighlight.superview];
            break;
        
        case UIGestureRecognizerStateChanged: {
            // Scale the frame by the pinch amount
            CGFloat scale = [pinchGR scale];
            CGRect newFrame = self.originalPinchFrame;
            CGFloat scaleByFactor = (scale - 1.0) / 1.0;
            scaleByFactor /= 3.0;
            
            newFrame.size.width *= 1.0 + scaleByFactor;
            newFrame.size.height *= 1.0 + scaleByFactor;
            
            // Translate the center by the difference between the current centroid and the original centroid
            CGPoint location = [pinchGR locationInView:self.viewToHighlight.superview];
            CGPoint center = CGPointMake(floor(CGRectGetMidX(self.originalPinchFrame)), floor(CGRectGetMidY(self.originalPinchFrame)));
            center.x += location.x - self.originalPinchLocation.x;
            center.y += location.y - self.originalPinchLocation.y;
            
            newFrame.origin.x = center.x - newFrame.size.width / 2.0;
            newFrame.origin.y = center.y - newFrame.size.height / 2.0;
            self.viewToHighlight.frame = newFrame;
            break;
        }
        
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            self.viewToHighlight.frame = CGRectIntegral(self.viewToHighlight.frame);
            break;
            
        default:
            break;
    }
}

#pragma mark - View Hierarchy Changes

- (void)windowHidden:(NSNotification *)windowNotification;
{
    [self removeView:windowNotification.object];
}

- (void)windowShown:(NSNotification *)windowNotification;
{
    [self addView:windowNotification.object];
}

- (void)removeView:(UIView *)view;
{
    // Bail early if we're ignoring this view or if the document hasn't been requested yet
    if ([self shouldIgnoreView:view] || !self.objectsForNodeIds) {
        return;
    }
    
    NSNumber *nodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:view]];

    // Only proceed if this is a node we know about
    if ([self.objectsForNodeIds objectForKey:nodeId]) {
        
        NSNumber *parentNodeId = nil;
        
        if (view.superview) {
            parentNodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:view.superview]];
        } else if ([view isKindOfClass:[UIWindow class]]) {
            // Windows are always children of the root element node
            parentNodeId = @(1);
        }
        
        [self stopTrackingView:view];
        [self.domain childNodeRemovedWithParentNodeId:parentNodeId nodeId:nodeId];
    }
}

- (void)addView:(UIView *)view;
{
    // Bail early if we're ignoring this view or if the document hasn't been requested yet
    if ([self shouldIgnoreView:view] || !self.objectsForNodeIds) {
        return;
    }

    // Only proceed if we know about this view's superview (corresponding to the parent node)
    NSNumber *parentNodeId = nil;
    if (view.superview) {
        parentNodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:view.superview]];
    }
    
    if ([self.objectsForNodeIds objectForKey:parentNodeId]) {
        
        PDDOMNode *node = [self nodeForView:view];

        // Find the sibling view to insert the node in the right place
        // We're actually looking for the next view in the subviews array. Index 0 holds the back-most view.
        // We essentialy dispay the subviews array backwards.
        NSNumber *previousNodeId = nil;
        NSUInteger indexOfView = [view.superview.subviews indexOfObject:view];
        
        // If this is the last subview in the array, it has no previous node.
        if (indexOfView < [view.superview.subviews count] - 1) {
            UIView *aheadSibling = [view.superview.subviews objectAtIndex:indexOfView + 1];
            previousNodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:aheadSibling]];
        }
        
        [self.domain childNodeInsertedWithParentNodeId:parentNodeId previousNodeId:previousNodeId node:node];
    } else if ([view isKindOfClass:[UIWindow class]]) {
        
        PDDOMNode *node = [self nodeForView:view];
        
        // Look at the other windows to find where to place this window
        NSNumber *previousNodeId = nil;
        NSArray *windows = [[UIApplication sharedApplication] windows];
        NSUInteger indexOfWindow = [windows indexOfObject:view];
        
        if (indexOfWindow > 0) {
            UIWindow *previousWindow = [windows objectAtIndex:indexOfWindow - 1];
            previousNodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:previousWindow]];
        }
        
        // Note that windows are always children of the root element node (id 1)
        [self.domain childNodeInsertedWithParentNodeId:@(1) previousNodeId:previousNodeId node:node];
    }
}

- (void)startTrackingView:(UIView *)view withNodeId:(NSNumber *)nodeId;
{
    NSAssert(view != self.highlightOverlay, @"The highlight overlay should not be tracked. We update its frame in the KVO observe method, so tracking it will lead to infinite recursion");
    
    [self.nodeIdsForObjects setObject:nodeId forKey:[NSValue valueWithNonretainedObject:view]];
    [self.objectsForNodeIds setObject:view forKey:nodeId];
    
    // Use KVO to keep the displayed properties fresh
    for (NSString *keyPath in self.viewKeyPathsToDisplay) {
        [view addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)stopTrackingView:(UIView *)view;
{
    NSValue *viewKey = [NSValue valueWithNonretainedObject:view];
    NSNumber *nodeId = [self.nodeIdsForObjects objectForKey:viewKey];
    
    // Bail early if we weren't tracking this view
    if (!nodeId) {
        return;
    }
    
    // Recurse to get any nested views
    for (UIView *subview in view.subviews) {
        [self stopTrackingView:subview];
    }
    
    // Remove the highlight if necessary
    if (view == self.viewToHighlight) {
        [self.highlightOverlay removeFromSuperview];
        self.viewToHighlight = nil;
    }
    
    // Unregister from KVO
    for (NSString *keyPath in self.viewKeyPathsToDisplay) {
        [view removeObserver:self forKeyPath:keyPath];
    }
    
    // Important that this comes last, so we don't get KVO observations for objects we don't konw about
    [self.nodeIdsForObjects removeObjectForKey:viewKey];
    [self.objectsForNodeIds removeObjectForKey:nodeId];
}

- (void)stopTrackingAllViews;
{
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        [self stopTrackingView:window];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    // Make sure this is a node we know about and a key path we're observing
    NSNumber *nodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:object]];
    
    if ([self.objectsForNodeIds objectForKey:nodeId] && [self.viewKeyPathsToDisplay containsObject:keyPath]) {
        // Update the attributes on the DOM node
        NSString *newValue = [self stringForValue:[change objectForKey:NSKeyValueChangeNewKey] atKeyPath:keyPath onObject:object];
        [self.domain attributeModifiedWithNodeId:nodeId name:keyPath value:newValue];
    }
    
    // If this is the view we're highlighting, update appropriately
    if (object == self.viewToHighlight && [keyPath isEqualToString:@"frame"]) {
        CGRect updatedFrame = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        self.highlightOverlay.frame = [self.viewToHighlight.superview convertRect:updatedFrame toView:nil];
    }
    
    // Note that we do not call [super observeValueForKeyPath:...] because super doesn't implement the method
}

- (BOOL)shouldIgnoreView:(UIView *)view;
{
    return view == nil || view == self.highlightOverlay;
}

- (NSNumber *)getAndIncrementNodeIdCount;
{
    return @(self.nodeIdCounter++);
}

#pragma mark - Node Generation

- (PDDOMNode *)rootNode;
{
    PDDOMNode *rootNode = [[PDDOMNode alloc] init];
    rootNode.nodeId = [self getAndIncrementNodeIdCount];
    rootNode.nodeType = @(kPDDOMNodeTypeDocument);
    rootNode.nodeName = @"#document";
    rootNode.children = @[ [self rootElement] ];
    
    return rootNode;
}

- (PDDOMNode *)rootElement;
{
    PDDOMNode *rootElement = [[PDDOMNode alloc] init];
    rootElement.nodeId = [self getAndIncrementNodeIdCount];
    rootElement.nodeType = @(kPDDOMNodeTypeElement);
    rootElement.nodeName = @"iosml";
    rootElement.children = [self windowNodes];
    
    return rootElement;
}

- (NSArray *)windowNodes;
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    NSMutableArray *windowNodes = [NSMutableArray arrayWithCapacity:[windows count]];
    
    for (id window in windows) {
        PDDOMNode *windowNode = [self nodeForView:window];
        if (windowNode) {
            [windowNodes addObject:windowNode];
        }
    }
    
    return windowNodes;
}

- (PDDOMNode *)nodeForView:(UIView *)view;
{
    // Don't generate nodes for views we want to ignore
    if ([self shouldIgnoreView:view]) {
        return nil;
    }
    
    // Build the child nodes by recursing on this view's subviews
    NSMutableArray *childNodes = [[NSMutableArray alloc] initWithCapacity:[view.subviews count]];
    for (UIView *subview in [view.subviews reverseObjectEnumerator]) {
        PDDOMNode *childNode = [self nodeForView:subview];
        if (childNode) {
            [childNodes addObject:childNode];
        }
    }
    
    PDDOMNode *viewNode = [self elementNodeForObject:view withChildNodes:childNodes];
    [self startTrackingView:view withNodeId:viewNode.nodeId];
    
    return viewNode;
}

- (PDDOMNode *)elementNodeForObject:(id)object withChildNodes:(NSArray *)children;
{
    PDDOMNode *elementNode = [[PDDOMNode alloc] init];
    elementNode.nodeType = @(kPDDOMNodeTypeElement);
    
    if ([object isKindOfClass:[UIWindow class]]) {
        elementNode.nodeName = @"window";
    } else if ([object isKindOfClass:[UIView class]]) {
        elementNode.nodeName = @"view";
    } else {
        elementNode.nodeName = @"object";
    }
    
    if ([object respondsToSelector:@selector(text)]) {
        NSString *text = [object text];
        if ([text length] > 0) {
            children = [children arrayByAddingObject:[self textNodeForString:[object text]]];
        }
    }
    
    elementNode.children = children;
    elementNode.childNodeCount = @([elementNode.children count]);
    elementNode.nodeId = [self getAndIncrementNodeIdCount];
    elementNode.attributes = [self attributesArrayForObject:object];
    
    return elementNode;
}

- (PDDOMNode *)textNodeForString:(NSString *)string;
{
    PDDOMNode *textNode = [[PDDOMNode alloc] init];
    textNode.nodeId = [self getAndIncrementNodeIdCount];
    textNode.nodeType = @(kPDDOMNodeTypeText);
    textNode.nodeValue = string;
    
    return textNode;
}

#pragma mark - Attribute Generation

- (NSArray *)attributesArrayForObject:(id)object;
{
    // No attributes for a nil object
    if (!object) {
        return nil;
    }
    
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:@[ @"class", [[object class] description] ]];
    
    if ([object isKindOfClass:[UIView class]]) {
        // Get strings for all the key paths in viewKeyPathsToDisplay
        for (NSString *keyPath in self.viewKeyPathsToDisplay) {
            
            NSValue *value = [object valueForKeyPath:keyPath];
            NSString *stringValue = [self stringForValue:value atKeyPath:keyPath onObject:object];
            if (stringValue) {
                [attributes addObjectsFromArray:@[ keyPath, stringValue ]];
            }
        }
    }
    
    return attributes;
}

- (NSString *)stringForValue:(id)value atKeyPath:(NSString *)keyPath onObject:(id)object;
{
    NSString *stringValue = nil;
    const char *typeEncoding = [self typeEncodingForKeyPath:keyPath onObject:object];
    
    if (typeEncoding) {
        if (!strcmp(typeEncoding,@encode(BOOL))) {
            stringValue = [(id)value boolValue] ? @"YES" : @"NO";
        } else if (!strcmp(typeEncoding,@encode(CGPoint))) {
            stringValue = NSStringFromCGPoint([value CGPointValue]);
        } else if (!strcmp(typeEncoding,@encode(CGSize))) {
            stringValue = NSStringFromCGSize([value CGSizeValue]);
        } else if (!strcmp(typeEncoding,@encode(CGRect))) {
            stringValue = NSStringFromCGRect([value CGRectValue]);
        }
    }
    
    if (!stringValue && [value isKindOfClass:[NSNumber class]]) {
        stringValue = [(NSNumber *)value stringValue];
    }
    
    return stringValue;
}

- (const char *)typeEncodingForKeyPath:(NSString *)keyPath onObject:(id)object;
{
    const char *encoding = NULL;
    
    // Look for a matching set* method to infer the type
    NSString *selectorString = [NSString stringWithFormat:@"set%@:", [keyPath stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[keyPath substringToIndex:1] uppercaseString]]];
    NSMethodSignature *methodSignature = [object methodSignatureForSelector:NSSelectorFromString(selectorString)];
    if (methodSignature) {
        // We don't care about arg0 (self) or arg1 (_cmd)
        encoding = [methodSignature getArgumentTypeAtIndex:2];
    }
    
    return encoding;
}

@end

@implementation UIView (Hackery)

// There is a different set of view add/remove observation methods that could've been swizzled instead of the ones below.
// Choosing the set below seems safer becuase the UIView implementations of the other methods are documented to be no-ops.
// Custom UIView subclasses may override and not make calls to super for those methods, which would cause us to miss changes in the view hierarchy.

- (void)pd_swizzled_addSubview:(UIView *)subview;
{
    [[PDDOMDomainController defaultInstance] removeView:subview];
    [self pd_swizzled_addSubview:subview];
    [[PDDOMDomainController defaultInstance] addView:subview];
}

- (void)pd_swizzled_bringSubviewToFront:(UIView *)view;
{
    [[PDDOMDomainController  defaultInstance] removeView:view];
    [self pd_swizzled_bringSubviewToFront:view];
    [[PDDOMDomainController defaultInstance] addView:view];
}

- (void)pd_swizzled_sendSubviewToBack:(UIView *)view;
{
    [[PDDOMDomainController  defaultInstance] removeView:view];
    [self pd_swizzled_sendSubviewToBack:view];
    [[PDDOMDomainController defaultInstance] addView:view];
}

- (void)pd_swizzled_removeFromSuperview;
{
    [[PDDOMDomainController defaultInstance] removeView:self];
    [self pd_swizzled_removeFromSuperview];
}

- (void)pd_swizzled_insertSubview:(UIView *)view atIndex:(NSInteger)index;
{
    [[PDDOMDomainController  defaultInstance] removeView:view];
    [self pd_swizzled_insertSubview:view atIndex:index];
    [[PDDOMDomainController defaultInstance] addView:view];
}

- (void)pd_swizzled_insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview;
{
    [[PDDOMDomainController  defaultInstance] removeView:view];
    [self pd_swizzled_insertSubview:view aboveSubview:siblingSubview];
    [[PDDOMDomainController defaultInstance] addView:view];
}

- (void)pd_swizzled_insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview;
{
    [[PDDOMDomainController  defaultInstance] removeView:view];
    [self pd_swizzled_insertSubview:view belowSubview:siblingSubview];
    [[PDDOMDomainController defaultInstance] addView:view];
}

- (void)pd_swizzled_exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2;
{
    [[PDDOMDomainController defaultInstance] removeView:[[self subviews] objectAtIndex:index1]];
    [[PDDOMDomainController defaultInstance] removeView:[[self subviews] objectAtIndex:index2]];
    [self pd_swizzled_exchangeSubviewAtIndex:index1 withSubviewAtIndex:index1];
    [[PDDOMDomainController defaultInstance] addView:[[self subviews] objectAtIndex:index1]];
    [[PDDOMDomainController defaultInstance] addView:[[self subviews] objectAtIndex:index2]];
}

@end