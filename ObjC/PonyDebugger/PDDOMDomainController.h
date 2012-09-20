//
//  PDDOMDomainController.h
//  PonyDebugger
//
//  Created by Ryan Olson on 2012-09-19.
//
//

#import <PonyDebugger/PonyDebugger.h>
#import <PonyDebugger/PDDOMDomain.h>
#import <PonyDebugger/PDDOMTypes.h>
#import <UIKit/UIKit.h>

@interface PDDOMDomainController : PDDomainController <PDDOMCommandDelegate>

@property (nonatomic, strong) PDDOMDomain *domain;

+ (PDDOMDomainController *)defaultInstance;
+ (void)startMonitoringUIViewChanges;

- (void)removeView:(UIView *)view;
- (void)addView:(UIView *)view;

@end
