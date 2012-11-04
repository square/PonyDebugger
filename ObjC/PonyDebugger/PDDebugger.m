//
//  PDDebugger.m
//  PonyDebugger
//
//  Created by Mike Lewis on 11/5/11.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <SocketRocket/SRWebSocket.h>
#import <UIKit/UIKit.h>

#import "PDDebugger.h"
#import "PDDynamicDebuggerDomain.h"
#import "PDNetworkDomain.h"
#import "PDDomainController.h"

#import "PDNetworkDomainController.h"
#import "PDRuntimeDomainController.h"
#import "PDPageDomainController.h"
#import "PDIndexedDBDomainController.h"
#import "PDDOMDomainController.h"
#import "PDInspectorDomainController.h"
#import "NSData+PDB64Additions.h"


static NSString *const PDClientIDKey = @"com.squareup.PDDebugger.clientID";


@interface PDDebugger () <SRWebSocketDelegate>

- (void)_addController:(PDDomainController *)controller;
- (NSString *)_domainNameForController:(PDDomainController *)controller;
- (BOOL)_isTrackingDomainController:(PDDomainController *)controller;

@end


@implementation PDDebugger {
    NSMutableDictionary *_domains;
    NSMutableDictionary *_controllers;
    __strong SRWebSocket *_socket;
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

#pragma mark - SRWebSocketDelegate

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
    
#if TARGET_IPHONE_SIMULATOR
    NSString *deviceName = [NSString stringWithFormat:@"%@'s Simulator", [[[NSProcessInfo processInfo] environment] objectForKey:@"USER"]];
#else
    NSString *deviceName = device.name;
#endif

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        clientID, @"device_id",
        deviceName, @"device_name",
        device.localizedModel, @"device_model",
        [[NSBundle mainBundle] bundleIdentifier], @"app_id",
        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"], @"app_name",
        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], @"app_version",
        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"], @"app_build",
        nil];
    
    NSString *appIconFile = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"];
    if (!appIconFile) {
        NSArray *files = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFiles"];
        if (files.count) {
            appIconFile = [files objectAtIndex:0];
        }
    }
    
    if (appIconFile) {
        UIImage *appIcon = [UIImage imageNamed:appIconFile];
        if (appIcon) {
            NSString *base64IconString = UIImagePNGRepresentation(appIcon).PD_stringByBase64Encoding;
            [parameters setObject:base64IconString forKey:@"app_icon_base64"];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendEventWithName:@"Gateway.registerDevice" parameters:parameters];
    });
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString *)message;
{
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];

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

        NSData *data = [NSJSONSerialization dataWithJSONObject:response options:0 error:nil];
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

#pragma mark - Public Methods

- (id)domainForName:(NSString *)name;
{
    return [_domains valueForKey:name];
}

- (void)sendEventWithName:(NSString *)methodName parameters:(id)params;
{
    NSDictionary *obj = [[NSDictionary alloc] initWithObjectsAndKeys:methodName, @"method", [params PD_JSONObject], @"params", nil];

    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
    NSString *encodedData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (_socket.readyState == SR_OPEN) {
        [_socket send:encodedData];
    }
}

#pragma mark Connect / Disconnect

- (void)connectToURL:(NSURL *)url;
{
    [_socket close];
    _socket.delegate = nil;
    
    _socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:url]];
    _socket.delegate = self;
    [_socket open];
}

- (BOOL)isConnected;
{
    return _socket && _socket.readyState == SR_OPEN;
}

- (void)disconnect;
{
    [_socket close];
    _socket.delegate = nil;
    _socket = nil;
}

#pragma mark - Public Interface

#pragma mark Network Debugging

- (void)enableNetworkTrafficDebugging;
{
    [self _addController:[PDNetworkDomainController defaultInstance]];
}

- (void)forwardAllNetworkTraffic;
{
    [PDNetworkDomainController injectIntoAllNSURLConnectionDelegateClasses];
}

- (void)forwardNetworkTrafficFromDelegateClass:(Class)cls;
{
    [PDNetworkDomainController injectIntoDelegateClass:cls];
}

#pragma mark Core Data Debugging

- (void)enableCoreDataDebugging;
{
    [self _addController:[PDRuntimeDomainController defaultInstance]];
    [self _addController:[PDPageDomainController defaultInstance]];
    [self _addController:[PDIndexedDBDomainController defaultInstance]];
}

- (void)addManagedObjectContext:(NSManagedObjectContext *)context;
{
    [[PDIndexedDBDomainController defaultInstance] addManagedObjectContext:context];
}

- (void)addManagedObjectContext:(NSManagedObjectContext *)context withName:(NSString *)name;
{
    [[PDIndexedDBDomainController defaultInstance] addManagedObjectContext:context withName:name];
}

- (void)removeManagedObjectContext:(NSManagedObjectContext *)context;
{
    [[PDIndexedDBDomainController defaultInstance] removeManagedObjectContext:context];
}

#pragma mark View Hierarchy Debugging

- (void)enableViewHierarchyDebugging;
{
    [self _addController:[PDDOMDomainController defaultInstance]];
    [self _addController:[PDInspectorDomainController defaultInstance]];
    
    // Choosing frame, alpha, and hidden as the default key paths to display
    [[PDDOMDomainController defaultInstance] setViewKeyPathsToDisplay:@[@"frame", @"alpha", @"hidden"]];
    
    [PDDOMDomainController startMonitoringUIViewChanges];
}

- (void)setDisplayedViewAttributeKeyPaths:(NSArray *)keyPaths;
{
    [[PDDOMDomainController defaultInstance] setViewKeyPathsToDisplay:keyPaths];
}

#pragma mark - Private Methods

- (NSString *)_domainNameForController:(PDDomainController *)controller;
{
    Class cls = [[controller class] domainClass];
    return [cls domainName];
}

- (void)_addController:(PDDomainController *)controller;
{
    NSString *domainName = [self _domainNameForController:controller];
    if ([_domains objectForKey:domainName]) {
        return;
    }
    
    Class cls = [[controller class] domainClass];
    PDDynamicDebuggerDomain *domain = [(PDDynamicDebuggerDomain *)[cls alloc] initWithDebuggingServer:self];
    [_domains setObject:domain forKey:domainName];
    
    controller.domain = domain;
    domain.delegate = controller;
}

- (BOOL)_isTrackingDomainController:(PDDomainController *)controller;
{
    NSString *domainName = [self _domainNameForController:controller];
    if ([_domains objectForKey:domainName]) {
        return YES;
    }
    
    return NO;
}

@end


@implementation NSDate (PDDebugger)

+ (NSNumber *)PD_timestamp;
{
    return [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
}

@end
