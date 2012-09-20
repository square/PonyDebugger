//
//  PDDOMDomainController.m
//  PonyDebugger
//
//  Created by Ryan Olson on 2012-09-19.
//
//

#import "PDDOMDomainController.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

static const int kPDDOMNodeTypeElement = 1;
static const int kPDDOMNodeTypeAttribute = 2;
static const int kPDDOMNodeTypeText = 3;
static const int kPDDOMNodeTypeComment = 8;
static const int kPDDOMNodeTypeDocument = 9;

@interface PDDOMDomainController ()

@property (nonatomic, strong) NSMutableDictionary * objectsForNodeIds;
@property (nonatomic, strong) NSMutableDictionary * nodeIdsForObjects;
@property (nonatomic, assign) NSUInteger nodeIdCounter;

@property (nonatomic, strong) NSArray *visibleAttributeKeyPaths;

@property (nonatomic, strong) UIView *viewToHighlight;
@property (nonatomic, strong) UIView *highlightOverlay;

@end

@implementation PDDOMDomainController

#pragma mark - NSObject

- (id)init
{
    if (self = [super init]) {
        self.visibleAttributeKeyPaths = @[@"frame", @"opaque", @"clipsToBounds", @"alpha"];
    }
    return self;
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

- (void)setHighlightOverlay:(UIView *)highlightOverlay
{
    [_highlightOverlay removeFromSuperview];
    _highlightOverlay = highlightOverlay;
}

#pragma mark - PDDOMCommandDelegate

- (void)domain:(PDDOMDomain *)domain getDocumentWithCallback:(void (^)(PDDOMNode *root, id error))callback;
{
    self.objectsForNodeIds = [[NSMutableDictionary alloc] init];
    self.nodeIdsForObjects = [[NSMutableDictionary alloc] init];
    self.nodeIdCounter = 0;
    callback([self rootNode], nil);
}

- (void)domain:(PDDOMDomain *)domain highlightNodeWithNodeId:(NSNumber *)nodeId highlightConfig:(PDDOMHighlightConfig *)highlightConfig callback:(void (^)(id))callback
{
    id objectForNodeId = [self.objectsForNodeIds objectForKey:nodeId];
    if ([objectForNodeId isKindOfClass:[UIView class]]) {
        // Add a highlight overlay directly to the window if this is a window, otherwise to the view's window
        self.viewToHighlight = (id)objectForNodeId;
        
        UIWindow *window = self.viewToHighlight.window;
        CGRect highlightFrame = CGRectZero;
        
        if (!window && [self.viewToHighlight isKindOfClass:[UIWindow class]]) {
            window = (UIWindow *)self.viewToHighlight;
            highlightFrame = window.bounds;
        } else {
            highlightFrame = [window convertRect:self.viewToHighlight.frame fromView:self.viewToHighlight.superview];
        }
        
        self.highlightOverlay = [[UIView alloc] initWithFrame:highlightFrame];
        
        // TODO: fix PDDOMRGBA & PDDOMHighlightConfig
        
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
        
        self.highlightOverlay.layer.borderWidth = 1.0;
        
        [window addSubview:self.highlightOverlay];
    }
    
    callback(nil);
}

#pragma mark - View Hierarchy Changes

- (void)removeView:(UIView *)view;
{
    // Bail early if we're ignoring this view
    if ([self shouldIgnoreView:view]) {
        return;
    }
    
    NSNumber *nodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:view]];

    // Only proceed if this is a node we know about
    if ([self.objectsForNodeIds objectForKey:nodeId]) {
        
        NSNumber *parentNodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:view.superview]];
        [self stopTrackingView:view];
        [self.domain childNodeRemovedWithParentNodeId:parentNodeId nodeId:nodeId];
    }
}

- (void)addView:(UIView *)view;
{
    // Bail early if we're ignoring this view
    if ([self shouldIgnoreView:view]) {
        return;
    }

    // Only proceed if we know about this view's superview (corresponding to the parent node)
    NSNumber *parentNodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:view.superview]];
    if ([self.objectsForNodeIds objectForKey:parentNodeId]) {
        
        PDDOMNode *node = [self nodeForView:view];

        // Find the preceeding sibling view to insert in the right place
        NSNumber *previousNodeId = nil;
        NSUInteger indexOfView = [view.superview.subviews indexOfObject:view];
        
        if (indexOfView > 0) {
            UIView *previousSibling = [view.superview.subviews objectAtIndex:indexOfView - 1];
            previousNodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:previousSibling]];
        }
        
        [self.domain childNodeInsertedWithParentNodeId:parentNodeId previousNodeId:previousNodeId node:node];
    }
}

- (void)startTrackingView:(UIView *)view withNodeId:(NSNumber *)nodeId;
{
    [self.nodeIdsForObjects setObject:nodeId forKey:[NSValue valueWithNonretainedObject:view]];
    [self.objectsForNodeIds setObject:view forKey:nodeId];
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
        self.highlightOverlay = nil;
        self.viewToHighlight = nil;
    }
    
    [self.nodeIdsForObjects removeObjectForKey:viewKey];
    [self.objectsForNodeIds removeObjectForKey:nodeId];
}

- (BOOL)shouldIgnoreView:(UIView *)view;
{
    return view == nil;
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
    rootElement.nodeName = @"view_hierarchy";
    rootElement.children = [self windowNodes];
    
    return rootElement;
}

- (NSArray *)windowNodes
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    NSMutableArray *windowNodes = [NSMutableArray arrayWithCapacity:[windows count]];
    
    for (id window in windows) {
        [windowNodes addObject:[self nodeForView:window]];
    }
    
    return windowNodes;
}

- (PDDOMNode *)nodeForView:(UIView *)view;
{
    // Build the child nodes by recursing on this view's subviews
    NSMutableArray *childNodes = [[NSMutableArray alloc] initWithCapacity:[view.subviews count]];
    for (UIView *subview in view.subviews) {
        [childNodes addObject:[self nodeForView:subview]];
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

- (NSArray *)attributesArrayForObject:(id)object
{
    // No attributes for a nil object
    if (!object) {
        return nil;
    }
    
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:@[ @"class", [[object class] description] ]];
    
    if ([object isKindOfClass:[UIView class]]) {
        // Get strings for all the key paths in visibileAttributeKeyPaths
        for (NSString *keyPath in self.visibleAttributeKeyPaths) {
            
            id value = [object valueForKeyPath:keyPath];
            NSString *stringValue = [self stringValueForObject:value];
            if (stringValue) {
                [attributes addObjectsFromArray:@[ keyPath, stringValue ]];
            }
        }
    }
    
    return attributes;
}

- (NSString *)stringValueForObject:(id)object
{
    NSString *stringValue = nil;
    if ([object isKindOfClass:[NSNumber class]]) {
        stringValue = [object stringValue];
    } else if ([object isKindOfClass:[NSValue class]]) {
        NSValue *value = object;
        const char *type = [value objCType];
        
        if (!strcmp(type, @encode(CGRect))) {
            stringValue = NSStringFromCGRect([value CGRectValue]);
        } else if (!strcmp(type, @encode(CGPoint))) {
            stringValue = NSStringFromCGPoint([value CGPointValue]);
        } else if (!strcmp(type, @encode(CGSize))) {
            stringValue = NSStringFromCGSize([value CGSizeValue]);
        }
    }
    return stringValue;
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