//
//  PDTAppDelegate.h
//  PDTwitterTest
//
//  Created by Mike Lewis on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import <SocketRocket/SRWebSocket.h>
#import <UIKit/UIKit.h>
#import "PDDebugger.h"
#import "PDDynamicDebuggerDomain.h"
#import "PDNetworkDomain.h"
#import "PDDomainController.h"

static NSString *const PDClientIDKey = @"org.lolrus.PDDebugger.clientID";


@interface PDDebugger () <SRWebSocketDelegate>

@end


@implementation PDDebugger {
    NSMutableDictionary *_domains;
    NSMutableDictionary *_controllers;
    __strong SRWebSocket *_socket;
    BOOL _forceDisconnected;
}

- (id)init;
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _domains = [[NSMutableDictionary alloc] init];
    _controllers = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void)addController:(PDDomainController *)controller;
{
    Class cls = [[controller class] domainClass];
    NSString *domainName = [cls domainName];
    PDDynamicDebuggerDomain *domain = [(PDDynamicDebuggerDomain *)[cls alloc] initWithDebuggingServer:self];
    [_domains setObject:domain forKey:domainName];
    
    controller.domain = domain;
    domain.delegate = controller;
}

- (void)connectToURL:(NSURL *)url;
{
    [_socket close];
    _socket.delegate = nil;
    
    _socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:url]];
    _socket.delegate = self;
    [_socket open];
}

- (id)domainForName:(NSString *)name;
{
    return [_domains valueForKey:name];
}

- (void)sendEventWithName:(NSString *)methodName parameters:(id)params;
{
    NSDictionary *obj = [[NSDictionary alloc] initWithObjectsAndKeys:methodName, @"method", [params PD_JSONObject], @"params", nil];

    NSData *data = [NSClassFromString(@"NSJSONSerialization") dataWithJSONObject:obj options:0 error:nil];
    NSString *encodedData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

   [_socket send:encodedData];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{

    NSString *clientID = [[NSUserDefaults standardUserDefaults] stringForKey:PDClientIDKey];
    if (!clientID) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        clientID = CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        assert(clientID);
        CFRelease(uuid);

        [[NSUserDefaults standardUserDefaults] setObject:clientID forKey:PDClientIDKey];
    }

    UIDevice *device = [UIDevice currentDevice];

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     clientID, @"device_id",
                                                     device.name, @"device_name",
                                                     device.localizedModel, @"device_model",
                                                     [[NSBundle mainBundle] bundleIdentifier], @"app_id",
                                                     nil];
    assert(parameters);

    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendEventWithName:@"Gateway.registerDevice" parameters:parameters];
    });
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString *)message;
{
    NSDictionary *obj = [NSClassFromString(@"NSJSONSerialization") JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];

    NSString *fullMethodName = [obj objectForKey:@"method"];
    NSInteger dotPosition = [fullMethodName rangeOfString:@"."].location;
    NSString *domainName = [fullMethodName substringToIndex:dotPosition];
    NSString *methodName = [fullMethodName substringFromIndex:dotPosition + 1];

    NSString *objectID = [obj objectForKey:@"id"];

    PDResponseCallback responseCallback = ^(NSDictionary *result, id error) {
        NSMutableDictionary *response = [[NSMutableDictionary alloc] initWithCapacity:2];
        [response setValue:objectID forKey:@"id"];

        if (result) {
            NSMutableDictionary *newResult = [[NSMutableDictionary alloc] initWithCapacity:result.count];
            [result enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop) {
                [newResult setObject:[val PD_JSONObjectCopy] forKey:key];
            }];
            [response setObject:newResult forKey:@"result"];
        }

        if (error) {
            [response setObject:[error PD_JSONObjectCopy] forKey:@"error"];
        } else {
            [response setObject:[NSNull null] forKey:@"error"];
        }

        NSData *data = [NSClassFromString(@"NSJSONSerialization") dataWithJSONObject:response options:0 error:nil];
        NSString *encodedData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        [webSocket send:encodedData];
    };

    PDDynamicDebuggerDomain *domain = [self domainForName:domainName];

    if (domain) {
        [domain handleMethodWithName:methodName parameters:[obj objectForKey:@"params"] responseCallback:[responseCallback copy]];
    } else {
        responseCallback(nil, [NSString stringWithFormat:@"unknown domain %@", domainName]);
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"Debugger closed");
    _socket.delegate = nil;
    _socket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@"Debugger failed");
    _socket.delegate = nil;
    _socket = nil;
}

- (void)disconnect;
{
    _forceDisconnected = YES;
    
    [_socket close];
    _socket.delegate = nil;
    _socket = nil;

    _domains = nil;
}


+ (PDDebugger *)defaultInstance;
{
    static dispatch_once_t onceToken;
    static PDDebugger *defaultInstance = nil;
    dispatch_once(&onceToken, ^{
        defaultInstance = [[[self class] alloc] init];
    });
    return defaultInstance;
}

@end

@implementation NSDate (PDDebugger)

+ (NSNumber *)PD_timestamp;
{
    return [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
}

@end
