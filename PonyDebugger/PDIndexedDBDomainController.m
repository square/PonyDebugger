//
//  PDDatabaseDomainController.m
//  PonyDebugger
//
//  Created by Mike Lewis on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDIndexedDBDomainController.h"

@implementation PDIndexedDBDomainController

+ (PDIndexedDBDomainController *)defaultInstance;
{
    static PDIndexedDBDomainController *defaultInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultInstance = [[PDIndexedDBDomainController alloc] init];
    });
    
    return defaultInstance;
}

@end
