//
//  PDDomainController.m
//  PonyDebugger
//
//  Created by Mike Lewis on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDDomainController.h"

@interface PDDomainController ()

@property (nonatomic, readwrite) BOOL enabled;

@end

@implementation PDDomainController

@synthesize enabled;
@synthesize domain;

+ (NSString *)domainName;
{
    return [[self domainClass] domainName];
}

+ (Class)domainClass;
{
    NSAssert(NO, @"Abstract Method");
    return Nil;
}

- (void)domain:(PDDynamicDebuggerDomain *)domain disableWithCallback:(void (^)(id error))callback;
{
    self.enabled = NO;
    callback(nil);
}

- (void)domain:(PDDynamicDebuggerDomain *)domain enableWithCallback:(void (^)(id error))callback;
{
    self.enabled = YES;
    callback(nil);
}

@end
