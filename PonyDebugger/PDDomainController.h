//
//  PDDomainController.h
//  PonyDebugger
//
//  Created by Mike Lewis on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>

@interface PDDomainController : NSObject <PDCommandDelegate>

@property (nonatomic, readonly) BOOL enabled;

@property (nonatomic, retain) PDDynamicDebuggerDomain *domain;

+ (NSString *)domainName;

// Abstract... Override this
+ (Class)domainClass;

@end
