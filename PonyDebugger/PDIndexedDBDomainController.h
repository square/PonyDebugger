//
//  PDDatabaseDomainController.h
//  PonyDebugger
//
//  Created by Mike Lewis on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <PonyDebugger/PDDomainController.h>
#import <PonyDebugger/PDIndexedDBDomain.h>
#import <PonyDebugger/PDIndexedDBTypes.h>

@interface PDIndexedDBDomainController : PDDomainController <PDIndexedDBCommandDelegate>

+ (PDIndexedDBDomainController *)defaultInstance;

@end
