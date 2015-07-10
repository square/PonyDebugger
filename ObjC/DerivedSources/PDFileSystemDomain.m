//
//  PDFileSystemDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDFileSystemDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDFileSystemTypes.h>


@interface PDFileSystemDomain ()
//Commands

@end

@implementation PDFileSystemDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"FileSystem";
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
    } else if ([methodName isEqualToString:@"requestFileSystemRoot"] && [self.delegate respondsToSelector:@selector(domain:requestFileSystemRootWithOrigin:type:callback:)]) {
        [self.delegate domain:self requestFileSystemRootWithOrigin:[params objectForKey:@"origin"] type:[params objectForKey:@"type"] callback:^(NSNumber *errorCode, PDFileSystemEntry *root, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (errorCode != nil) {
                [params setObject:errorCode forKey:@"errorCode"];
            }
            if (root != nil) {
                [params setObject:root forKey:@"root"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"requestDirectoryContent"] && [self.delegate respondsToSelector:@selector(domain:requestDirectoryContentWithUrl:callback:)]) {
        [self.delegate domain:self requestDirectoryContentWithUrl:[params objectForKey:@"url"] callback:^(NSNumber *errorCode, NSArray *entries, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (errorCode != nil) {
                [params setObject:errorCode forKey:@"errorCode"];
            }
            if (entries != nil) {
                [params setObject:entries forKey:@"entries"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"requestMetadata"] && [self.delegate respondsToSelector:@selector(domain:requestMetadataWithUrl:callback:)]) {
        [self.delegate domain:self requestMetadataWithUrl:[params objectForKey:@"url"] callback:^(NSNumber *errorCode, PDFileSystemMetadata *metadata, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (errorCode != nil) {
                [params setObject:errorCode forKey:@"errorCode"];
            }
            if (metadata != nil) {
                [params setObject:metadata forKey:@"metadata"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"requestFileContent"] && [self.delegate respondsToSelector:@selector(domain:requestFileContentWithUrl:readAsText:start:end:charset:callback:)]) {
        [self.delegate domain:self requestFileContentWithUrl:[params objectForKey:@"url"] readAsText:[params objectForKey:@"readAsText"] start:[params objectForKey:@"start"] end:[params objectForKey:@"end"] charset:[params objectForKey:@"charset"] callback:^(NSNumber *errorCode, NSString *content, NSString *charset, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];

            if (errorCode != nil) {
                [params setObject:errorCode forKey:@"errorCode"];
            }
            if (content != nil) {
                [params setObject:content forKey:@"content"];
            }
            if (charset != nil) {
                [params setObject:charset forKey:@"charset"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"deleteEntry"] && [self.delegate respondsToSelector:@selector(domain:deleteEntryWithUrl:callback:)]) {
        [self.delegate domain:self deleteEntryWithUrl:[params objectForKey:@"url"] callback:^(NSNumber *errorCode, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (errorCode != nil) {
                [params setObject:errorCode forKey:@"errorCode"];
            }

            responseCallback(params, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDFileSystemDomain)

- (PDFileSystemDomain *)fileSystemDomain;
{
    return [self domainForName:@"FileSystem"];
}

@end
