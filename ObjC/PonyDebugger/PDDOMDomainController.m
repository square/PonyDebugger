//
//  PDDOMDomainController.m
//  PonyDebugger
//
//  Created by Ryan Olson on 2012-09-19.
//
//

#import "PDDOMDomainController.h"

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