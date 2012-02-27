//
//  PDDebuggerDomain.h
//  PonyExpress
//
//  Created by Mike Lewis on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PDCommandDelegate;

@class PDDebugger;

// Must call this to send the response
typedef void (^PDResponseCallback)(NSDictionary *result, id error);

@interface PDDynamicDebuggerDomain : NSObject

- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;

- (id)initWithDebuggingServer:(PDDebugger *)debuggingServer;

@property (nonatomic, assign, readonly) PDDebugger * debuggingServer;

@property (nonatomic, assign) id <PDCommandDelegate> delegate;

+ (NSString *)domainName;

@end

@protocol PDCommandDelegate <NSObject>

- (void)domain:(PDDynamicDebuggerDomain *)domain enableWithCallback:(void (^)(id error))callback;
- (void)domain:(PDDynamicDebuggerDomain *)domain disableWithCallback:(void (^)(id error))callback;

@end
