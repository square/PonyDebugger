//
//  PDTAppDelegate.h
//  PDTwitterTest
//
//  Created by Mike Lewis on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SRWebSocket;
@class PDDomainController;

@interface PDDebugger : NSObject

+ (PDDebugger *)defaultInstance;

// Registers a controller
- (void)addController:(PDDomainController *)controller;

- (void)sendEventWithName:(NSString *)string parameters:(id)params;

- (void)disconnect;

- (void)connectToURL:(NSURL *)url;

- (id)domainForName:(NSString *)name;

@end


@interface NSDate (PDDebugger)

+ (NSNumber *)PD_timestamp;

@end
