//
//  PDDebuggerDomain.m
//  PonyExpress
//
//  Created by Mike Lewis on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PDDynamicDebuggerDomain.h"
#import "PDDebugger.h"
#import <objc/message.h>

@interface PDDynamicDebuggerDomain ()

@property (nonatomic, readwrite) BOOL enabled;
@end

@implementation PDDynamicDebuggerDomain

@synthesize debuggingServer = _debuggingServer;
@synthesize enabled = _enabled;
@synthesize delegate = _delegate;

- (id)initWithDebuggingServer:(PDDebugger *)debuggingServer;
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _debuggingServer = debuggingServer;
    
    return self;
}

- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    
    if ([methodName isEqualToString:@"enable"]) {
        [self enableWithResultHandler:responseCallback];
    } else if ([methodName isEqualToString:@"disable"]) {
        [self disableWithResultHandler:responseCallback];
    } else {
        NSString *errorMessage = [[NSString alloc] initWithFormat:@"unkown method name %@", methodName];
        responseCallback(nil, errorMessage);
        NSLog(@"%@ received unknown method %@", self, methodName);
    }
}

- (void)enableWithResultHandler:(PDResponseCallback)resultHandler;
{
    self.enabled = YES;
    NSLog(@"enabling %@", self);
    resultHandler(nil, nil);
}

- (void)disableWithResultHandler:(PDResponseCallback)resultHandler;
{
    self.enabled = NO;
    resultHandler(nil, nil);
}

+ (NSString *)domainName;
{
    NSAssert(NO, @"Abstract Method");
    return nil;
}


@end
