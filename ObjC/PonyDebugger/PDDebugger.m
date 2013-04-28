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
#import "PDPrettyStringPrinter.h"
#import "PDDomainController.h"

#import "PDNetworkDomainController.h"
#import "PDRuntimeDomainController.h"
#import "PDPageDomainController.h"
#import "PDIndexedDBDomainController.h"
#import "PDDOMDomainController.h"
#import "PDInspectorDomainController.h"
#import "PDConsoleDomainController.h"
#import "NSData+PDB64Additions.h"


static NSString *const PDClientIDKey = @"com.squareup.PDDebugger.clientID";
static NSString *const PDBonjourServiceType = @"_ponyd._tcp";


void _PDLogObjectsImpl(NSString *severity, NSArray *arguments)
{
    [[PDConsoleDomainController defaultInstance] logWithArguments:arguments severity:severity];
}


@interface PDDebugger () <SRWebSocketDelegate, NSNetServiceBrowserDelegate, NSNetServiceDelegate>

- (void)_resolveService:(NSNetService*)service;
- (void)_addController:(PDDomainController *)controller;
- (NSString *)_domainNameForController:(PDDomainController *)controller;
- (BOOL)_isTrackingDomainController:(PDDomainController *)controller;

@end


@implementation PDDebugger {
    NSString *_bonjourServiceName;
    NSNetServiceBrowser *_bonjourBrowser;
    NSMutableArray *_bonjourServices;
    NSNetService *_currentService;
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
    NSLog(@"Debugger failed with web socket error: %@", [error localizedDescription]);
    _socket.delegate = nil;
    _socket = nil;
}

#pragma mark - NSNetServiceBrowserDelegate

- (void)netServiceBrowser:(NSNetServiceBrowser*)netServiceBrowser didFindService:(NSNetService*)service moreComing:(BOOL)moreComing;
{
    const NSStringCompareOptions compareOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    if (_bonjourServiceName != nil && [_bonjourServiceName compare:service.name options:compareOptions] != NSOrderedSame) {
        return;
    }
    
    NSLog(@"Found ponyd bonjour service: %@", service);
    [_bonjourServices addObject:service];
    
    if (!_currentService) {
        [self _resolveService:service];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser*)netServiceBrowser didRemoveService:(NSNetService*)service moreComing:(BOOL)moreComing;
{
    if ([service isEqual:_currentService]) {
        [_currentService stop];
        _currentService.delegate = nil;
        _currentService = nil;
    }
    
    NSUInteger serviceIndex = [_bonjourServices indexOfObject:service];
    if (NSNotFound != serviceIndex) {
        [_bonjourServices removeObjectAtIndex:serviceIndex];
        NSLog(@"Removed ponyd bonjour service: %@", service);
        
        // Try next one
        if (!_currentService && _bonjourServices.count){
            NSNetService* nextService = [_bonjourServices objectAtIndex:(serviceIndex % _bonjourServices.count)];
            [self _resolveService:nextService];
        }
    }
}

#pragma mark - NSNetServiceDelegate

- (void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict;
{
    NSAssert([service isEqual:_currentService], @"Did not resolve incorrect service!");
    _currentService.delegate = nil;
    _currentService = nil;
    
    // Try next one, we may retry the same one if there's only 1 service in _bonjourServices
    NSUInteger serviceIndex = [_bonjourServices indexOfObject:service];
    if (NSNotFound != serviceIndex) {
        if (_bonjourServices.count){
            NSNetService* nextService = [_bonjourServices objectAtIndex:((serviceIndex + 1) % _bonjourServices.count)];
            [self _resolveService:nextService];
        }
    }
}


- (void)netServiceDidResolveAddress:(NSNetService *)service;
{
    NSAssert([service isEqual:_currentService], @"Resolved incorrect service!");

    [self connectToURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:%d/device", [service hostName], [service port]]]];
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

/**
 * Connect to any ponyd service found via Bonjour.
 */
- (void)autoConnect;
{
    [self autoConnectToBonjourServiceNamed:nil];
}

/**
 * Only connect to the specified Bonjour service name, this makes things easier in a teamwork
 * environment where multiple instances of ponyd may run on the same network.
 */
- (void)autoConnectToBonjourServiceNamed:(NSString*)serviceName;
{
    if (_bonjourBrowser) {
        return;
    }
    
    _bonjourServiceName = serviceName;
    _bonjourServices = [NSMutableArray array];
    _bonjourBrowser = [[NSNetServiceBrowser alloc] init];
    [_bonjourBrowser setDelegate:self];
    
    if (_bonjourServiceName) {
        NSLog(@"Waiting for ponyd bonjour service '%@'...", _bonjourServiceName);
    } else {
        NSLog(@"Waiting for ponyd bonjour service...");
    }
    [_bonjourBrowser searchForServicesOfType:PDBonjourServiceType inDomain:@""];
}

- (void)connectToURL:(NSURL *)url;
{
    NSLog(@"Connecting to %@", url);
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
    [_bonjourBrowser stop];
    _bonjourBrowser.delegate = nil;
    _bonjourBrowser = nil;
    _bonjourServiceName = nil;
    _bonjourServices = nil;
    [_currentService stop];
    _currentService.delegate = nil;
    _currentService = nil;
    
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
    [PDNetworkDomainController registerPrettyStringPrinter:[[PDJSONPrettyStringPrinter alloc] init]];
    [PDNetworkDomainController injectIntoAllNSURLConnectionDelegateClasses];
}

- (void)forwardNetworkTrafficFromDelegateClass:(Class)cls;
{
    [PDNetworkDomainController injectIntoDelegateClass:cls];
}

+ (void)registerPrettyStringPrinter:(id<PDPrettyStringPrinting>)prettyStringPrinter;
{
    [PDNetworkDomainController registerPrettyStringPrinter:prettyStringPrinter];
}

+ (void)unregisterPrettyStringPrinter:(id<PDPrettyStringPrinting>)prettyStringPrinter;
{
    [PDNetworkDomainController unregisterPrettyStringPrinter:prettyStringPrinter];
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

#pragma mark Remote Logging

- (void)enableRemoteLogging;
{
    [self _addController:[PDConsoleDomainController defaultInstance]];
}

- (void)clearConsole;
{
    [[PDConsoleDomainController defaultInstance] clear];
}

#pragma mark - Private Methods

- (void)_resolveService:(NSNetService*)service;
{
    NSLog(@"Resolving %@", service);
    _currentService = service;
    _currentService.delegate = self;
    [_currentService resolveWithTimeout:10.f];
}

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
