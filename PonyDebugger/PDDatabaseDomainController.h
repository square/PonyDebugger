//
//  PDDatabaseDomainController.h
//  PonyDebugger
//
//  Created by Mike Lewis on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <PonyDebugger/PDDomainController.h>
#import <PonyDebugger/PDDatabaseDomain.h>
#import <PonyDebugger/PDDatabaseTypes.h>

@class NSManagedObjectContext;

@interface PDDatabaseDomainController : PDDomainController <PDDatabaseCommandDelegate>

+ (PDDatabaseDomainController *)defaultInstance;

@property (nonatomic, retain) PDDatabaseDomain *domain;

- (void)addManagedObjectContext:(NSManagedObjectContext *)context;
- (void)removeManagedObjectContext:(NSManagedObjectContext *)context;

@end
