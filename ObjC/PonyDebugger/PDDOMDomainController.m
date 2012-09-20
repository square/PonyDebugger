//
//  PDDOMDomainController.m
//  PonyDebugger
//
//  Created by Ryan Olson on 2012-09-19.
//
//

#import "PDDOMDomainController.h"
#import <objc/runtime.h>

@interface PDDOMDomainController ()

@end

@implementation PDDOMDomainController

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

#pragma mark - View Hierarchy Changes

- (void)removeView:(UIView *)view;
{
    // Remove view from the hierarchy tree in the elements pannel and stop tracking changes to it
}

- (void)addView:(UIView *)view;
{
    // Add view to the hierarcy tree in the elements pannel and start tracking changes to it 
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