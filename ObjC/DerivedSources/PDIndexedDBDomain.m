//
//  PDIndexedDBDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDIndexedDBDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDIndexedDBTypes.h>


@interface PDIndexedDBDomain ()
//Commands

@end

@implementation PDIndexedDBDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"IndexedDB";
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
    } else if ([methodName isEqualToString:@"requestDatabaseNames"] && [self.delegate respondsToSelector:@selector(domain:requestDatabaseNamesWithSecurityOrigin:callback:)]) {
        [self.delegate domain:self requestDatabaseNamesWithSecurityOrigin:[params objectForKey:@"securityOrigin"] callback:^(NSArray *databaseNames, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (databaseNames != nil) {
                [params setObject:databaseNames forKey:@"databaseNames"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"requestDatabase"] && [self.delegate respondsToSelector:@selector(domain:requestDatabaseWithSecurityOrigin:databaseName:callback:)]) {
        [self.delegate domain:self requestDatabaseWithSecurityOrigin:[params objectForKey:@"securityOrigin"] databaseName:[params objectForKey:@"databaseName"] callback:^(PDIndexedDBDatabaseWithObjectStores *databaseWithObjectStores, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (databaseWithObjectStores != nil) {
                [params setObject:databaseWithObjectStores forKey:@"databaseWithObjectStores"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"requestData"] && [self.delegate respondsToSelector:@selector(domain:requestDataWithSecurityOrigin:databaseName:objectStoreName:indexName:skipCount:pageSize:keyRange:callback:)]) {
        [self.delegate domain:self requestDataWithSecurityOrigin:[params objectForKey:@"securityOrigin"] databaseName:[params objectForKey:@"databaseName"] objectStoreName:[params objectForKey:@"objectStoreName"] indexName:[params objectForKey:@"indexName"] skipCount:[params objectForKey:@"skipCount"] pageSize:[params objectForKey:@"pageSize"] keyRange:[params objectForKey:@"keyRange"] callback:^(NSArray *objectStoreDataEntries, NSNumber *hasMore, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (objectStoreDataEntries != nil) {
                [params setObject:objectStoreDataEntries forKey:@"objectStoreDataEntries"];
            }
            if (hasMore != nil) {
                [params setObject:hasMore forKey:@"hasMore"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"clearObjectStore"] && [self.delegate respondsToSelector:@selector(domain:clearObjectStoreWithSecurityOrigin:databaseName:objectStoreName:callback:)]) {
        [self.delegate domain:self clearObjectStoreWithSecurityOrigin:[params objectForKey:@"securityOrigin"] databaseName:[params objectForKey:@"databaseName"] objectStoreName:[params objectForKey:@"objectStoreName"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDIndexedDBDomain)

- (PDIndexedDBDomain *)indexedDBDomain;
{
    return [self domainForName:@"IndexedDB"];
}

@end
