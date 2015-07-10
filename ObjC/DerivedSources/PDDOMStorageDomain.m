//
//  PDDOMStorageDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDOMStorageDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDOMStorageTypes.h>


@interface PDDOMStorageDomain ()
//Commands

@end

@implementation PDDOMStorageDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"DOMStorage";
}

// Events
- (void)domStorageItemsClearedWithStorageId:(PDDOMStorageStorageId *)storageId;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (storageId != nil) {
        [params setObject:[storageId PD_JSONObject] forKey:@"storageId"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOMStorage.domStorageItemsCleared" parameters:params];
}
- (void)domStorageItemRemovedWithStorageId:(PDDOMStorageStorageId *)storageId key:(NSString *)key;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (storageId != nil) {
        [params setObject:[storageId PD_JSONObject] forKey:@"storageId"];
    }
    if (key != nil) {
        [params setObject:[key PD_JSONObject] forKey:@"key"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOMStorage.domStorageItemRemoved" parameters:params];
}
- (void)domStorageItemAddedWithStorageId:(PDDOMStorageStorageId *)storageId key:(NSString *)key newValue:(NSString *)newValue;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];

    if (storageId != nil) {
        [params setObject:[storageId PD_JSONObject] forKey:@"storageId"];
    }
    if (key != nil) {
        [params setObject:[key PD_JSONObject] forKey:@"key"];
    }
    if (newValue != nil) {
        [params setObject:[newValue PD_JSONObject] forKey:@"newValue"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOMStorage.domStorageItemAdded" parameters:params];
}
- (void)domStorageItemUpdatedWithStorageId:(PDDOMStorageStorageId *)storageId key:(NSString *)key oldValue:(NSString *)oldValue newValue:(NSString *)newValue;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:4];

    if (storageId != nil) {
        [params setObject:[storageId PD_JSONObject] forKey:@"storageId"];
    }
    if (key != nil) {
        [params setObject:[key PD_JSONObject] forKey:@"key"];
    }
    if (oldValue != nil) {
        [params setObject:[oldValue PD_JSONObject] forKey:@"oldValue"];
    }
    if (newValue != nil) {
        [params setObject:[newValue PD_JSONObject] forKey:@"newValue"];
    }
    
    [self.debuggingServer sendEventWithName:@"DOMStorage.domStorageItemUpdated" parameters:params];
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"enable"] && [self.delegate respondsToSelector:@selector(domain:enableWithCallback:)]) {
        [self.delegate domain:self enableWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"disable"] && [self.delegate respondsToSelector:@selector(domain:disableWithCallback:)]) {
        [self.delegate domain:self disableWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getDOMStorageItems"] && [self.delegate respondsToSelector:@selector(domain:getDOMStorageItemsWithStorageId:callback:)]) {
        [self.delegate domain:self getDOMStorageItemsWithStorageId:[params objectForKey:@"storageId"] callback:^(NSArray *entries, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (entries != nil) {
                [params setObject:entries forKey:@"entries"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setDOMStorageItem"] && [self.delegate respondsToSelector:@selector(domain:setDOMStorageItemWithStorageId:key:value:callback:)]) {
        [self.delegate domain:self setDOMStorageItemWithStorageId:[params objectForKey:@"storageId"] key:[params objectForKey:@"key"] value:[params objectForKey:@"value"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"removeDOMStorageItem"] && [self.delegate respondsToSelector:@selector(domain:removeDOMStorageItemWithStorageId:key:callback:)]) {
        [self.delegate domain:self removeDOMStorageItemWithStorageId:[params objectForKey:@"storageId"] key:[params objectForKey:@"key"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDDOMStorageDomain)

- (PDDOMStorageDomain *)DOMStorageDomain;
{
    return [self domainForName:@"DOMStorage"];
}

@end
