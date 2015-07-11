//
//  PDPageDomainController.m
//  PonyDebugger
//
//  Created by Wen-Hao Lue on 8/6/12.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDPageDomainController.h"
#import "PDRuntimeDomainController.h"
#import "PDPageDomain.h"
#import "PDPageTypes.h"


@interface PDPageDomainController () <PDPageCommandDelegate>
@end


@implementation PDPageDomainController

@dynamic domain;

#pragma mark - Statics

+ (PDPageDomainController *)defaultInstance;
{
    static PDPageDomainController *defaultInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultInstance = [[PDPageDomainController alloc] init];
    });
    
    return defaultInstance;
}

+ (Class)domainClass;
{
    return [PDPageDomain class];
}

#pragma mark - PDPageCommandDelegate

- (void)domain:(PDPageDomain *)domain getResourceTreeWithCallback:(void (^)(PDPageFrameResourceTree *, id))callback;
{
    PDPageFrame *frame = [[PDPageFrame alloc] init];
    
    frame.identifier = @"0";
    frame.name = @"Root";
    frame.securityOrigin = [[NSBundle mainBundle] bundleIdentifier];
    frame.url = [[NSBundle mainBundle] bundlePath];
    frame.loaderId = @"0";
    
    PDPageFrameResourceTree *resourceTree = [[PDPageFrameResourceTree alloc] init];
    resourceTree.frame = frame;
    resourceTree.resources = @[@{
        @"url": [NSBundle mainBundle].bundleURL.absoluteString,
        @"type": @"Document",
        @"mimeType": @"",
        
    }];
    
    callback(resourceTree, nil);
}

- (void)domain:(PDPageDomain *)domain reloadWithIgnoreCache:(NSNumber *)ignoreCache scriptToEvaluateOnLoad:(NSString *)scriptToEvaluateOnLoad callback:(void (^)(id))callback;
{
    callback(nil);
}

- (void)domain:(PDPageDomain *)domain canScreencastWithCallback:(void (^)(NSNumber *, id))callback;
{
    callback(@NO, nil);
}

- (void)domain:(PDPageDomain *)domain getResourceContentWithFrameId:(NSString *)frameId url:(NSString *)url callback:(void (^)(NSString *content, NSNumber *base64Encoded, id error))callback;
{
    callback(@"", nil, nil);
}

@end
