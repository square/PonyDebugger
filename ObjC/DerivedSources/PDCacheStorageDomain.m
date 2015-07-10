//
//  PDCacheStorageDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDCacheStorageDomain.h>
#import <PonyDebugger/PDObject.h>


@interface PDCacheStorageDomain ()
//Commands

@end

@implementation PDCacheStorageDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"CacheStorage";
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"requestCacheNames"] && [self.delegate respondsToSelector:@selector(domain:requestCacheNamesWithSecurityOrigin:callback:)]) {
        [self.delegate domain:self requestCacheNamesWithSecurityOrigin:[params objectForKey:@"securityOrigin"] callback:^(NSArray *caches, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (caches != nil) {
                [params setObject:caches forKey:@"caches"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"requestEntries"] && [self.delegate respondsToSelector:@selector(domain:requestEntriesWithCacheId:skipCount:pageSize:callback:)]) {
        [self.delegate domain:self requestEntriesWithCacheId:[params objectForKey:@"cacheId"] skipCount:[params objectForKey:@"skipCount"] pageSize:[params objectForKey:@"pageSize"] callback:^(NSArray *cacheDataEntries, NSNumber *hasMore, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (cacheDataEntries != nil) {
                [params setObject:cacheDataEntries forKey:@"cacheDataEntries"];
            }
            if (hasMore != nil) {
                [params setObject:hasMore forKey:@"hasMore"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"deleteCache"] && [self.delegate respondsToSelector:@selector(domain:deleteCacheWithCacheId:callback:)]) {
        [self.delegate domain:self deleteCacheWithCacheId:[params objectForKey:@"cacheId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"deleteEntry"] && [self.delegate respondsToSelector:@selector(domain:deleteEntryWithCacheId:request:callback:)]) {
        [self.delegate domain:self deleteEntryWithCacheId:[params objectForKey:@"cacheId"] request:[params objectForKey:@"request"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDCacheStorageDomain)

- (PDCacheStorageDomain *)cacheStorageDomain;
{
    return [self domainForName:@"CacheStorage"];
}

@end
