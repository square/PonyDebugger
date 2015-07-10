//
//  PDPageDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDPageDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDPageTypes.h>
#import <PonyDebugger/PDDOMTypes.h>


@interface PDPageDomain ()
//Commands

@end

@implementation PDPageDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Page";
}

// Events
- (void)domContentEventFiredWithTimestamp:(NSNumber *)timestamp;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (timestamp != nil) {
        [params setObject:[timestamp PD_JSONObject] forKey:@"timestamp"];
    }
    
    [self.debuggingServer sendEventWithName:@"Page.domContentEventFired" parameters:params];
}
- (void)loadEventFiredWithTimestamp:(NSNumber *)timestamp;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (timestamp != nil) {
        [params setObject:[timestamp PD_JSONObject] forKey:@"timestamp"];
    }
    
    [self.debuggingServer sendEventWithName:@"Page.loadEventFired" parameters:params];
}

// Fired when frame has been attached to its parent.
- (void)frameAttachedWithFrameId:(NSString *)frameId parentFrameId:(NSString *)parentFrameId;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (frameId != nil) {
        [params setObject:[frameId PD_JSONObject] forKey:@"frameId"];
    }
    if (parentFrameId != nil) {
        [params setObject:[parentFrameId PD_JSONObject] forKey:@"parentFrameId"];
    }
    
    [self.debuggingServer sendEventWithName:@"Page.frameAttached" parameters:params];
}

// Fired once navigation of the frame has completed. Frame is now associated with the new loader.
- (void)frameNavigatedWithFrame:(PDPageFrame *)frame;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (frame != nil) {
        [params setObject:[frame PD_JSONObject] forKey:@"frame"];
    }
    
    [self.debuggingServer sendEventWithName:@"Page.frameNavigated" parameters:params];
}

// Fired when frame has been detached from its parent.
- (void)frameDetachedWithFrameId:(NSString *)frameId;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (frameId != nil) {
        [params setObject:[frameId PD_JSONObject] forKey:@"frameId"];
    }
    
    [self.debuggingServer sendEventWithName:@"Page.frameDetached" parameters:params];
}

// Fired when frame has started loading.
- (void)frameStartedLoadingWithFrameId:(NSString *)frameId;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (frameId != nil) {
        [params setObject:[frameId PD_JSONObject] forKey:@"frameId"];
    }
    
    [self.debuggingServer sendEventWithName:@"Page.frameStartedLoading" parameters:params];
}

// Fired when frame has stopped loading.
- (void)frameStoppedLoadingWithFrameId:(NSString *)frameId;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (frameId != nil) {
        [params setObject:[frameId PD_JSONObject] forKey:@"frameId"];
    }
    
    [self.debuggingServer sendEventWithName:@"Page.frameStoppedLoading" parameters:params];
}

// Fired when frame schedules a potential navigation.
- (void)frameScheduledNavigationWithFrameId:(NSString *)frameId delay:(NSNumber *)delay;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (frameId != nil) {
        [params setObject:[frameId PD_JSONObject] forKey:@"frameId"];
    }
    if (delay != nil) {
        [params setObject:[delay PD_JSONObject] forKey:@"delay"];
    }
    
    [self.debuggingServer sendEventWithName:@"Page.frameScheduledNavigation" parameters:params];
}

// Fired when frame no longer has a scheduled navigation.
- (void)frameClearedScheduledNavigationWithFrameId:(NSString *)frameId;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (frameId != nil) {
        [params setObject:[frameId PD_JSONObject] forKey:@"frameId"];
    }
    
    [self.debuggingServer sendEventWithName:@"Page.frameClearedScheduledNavigation" parameters:params];
}
- (void)frameResized;
{
    [self.debuggingServer sendEventWithName:@"Page.frameResized" parameters:nil];
}

// Fired when a JavaScript initiated dialog (alert, confirm, prompt, or onbeforeunload) is about to open.
- (void)javascriptDialogOpeningWithMessage:(NSString *)message type:(NSString *)type;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (message != nil) {
        [params setObject:[message PD_JSONObject] forKey:@"message"];
    }
    if (type != nil) {
        [params setObject:[type PD_JSONObject] forKey:@"type"];
    }
    
    [self.debuggingServer sendEventWithName:@"Page.javascriptDialogOpening" parameters:params];
}

// Fired when a JavaScript initiated dialog (alert, confirm, prompt, or onbeforeunload) has been closed.
- (void)javascriptDialogClosedWithResult:(NSNumber *)result;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (result != nil) {
        [params setObject:[result PD_JSONObject] forKey:@"result"];
    }
    
    [self.debuggingServer sendEventWithName:@"Page.javascriptDialogClosed" parameters:params];
}

// Compressed image data requested by the <code>startScreencast</code>.
- (void)screencastFrameWithData:(NSString *)data metadata:(PDPageScreencastFrameMetadata *)metadata frameNumber:(NSNumber *)frameNumber;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];

    if (data != nil) {
        [params setObject:[data PD_JSONObject] forKey:@"data"];
    }
    if (metadata != nil) {
        [params setObject:[metadata PD_JSONObject] forKey:@"metadata"];
    }
    if (frameNumber != nil) {
        [params setObject:[frameNumber PD_JSONObject] forKey:@"frameNumber"];
    }
    
    [self.debuggingServer sendEventWithName:@"Page.screencastFrame" parameters:params];
}

// Fired when the page with currently enabled screencast was shown or hidden </code>.
- (void)screencastVisibilityChangedWithVisible:(NSNumber *)visible;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (visible != nil) {
        [params setObject:[visible PD_JSONObject] forKey:@"visible"];
    }
    
    [self.debuggingServer sendEventWithName:@"Page.screencastVisibilityChanged" parameters:params];
}

// Fired when a color has been picked.
- (void)colorPickedWithColor:(PDDOMRGBA *)color;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (color != nil) {
        [params setObject:[color PD_JSONObject] forKey:@"color"];
    }
    
    [self.debuggingServer sendEventWithName:@"Page.colorPicked" parameters:params];
}

// Fired when interstitial page was shown
- (void)interstitialShown;
{
    [self.debuggingServer sendEventWithName:@"Page.interstitialShown" parameters:nil];
}

// Fired when interstitial page was hidden
- (void)interstitialHidden;
{
    [self.debuggingServer sendEventWithName:@"Page.interstitialHidden" parameters:nil];
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
    } else if ([methodName isEqualToString:@"addScriptToEvaluateOnLoad"] && [self.delegate respondsToSelector:@selector(domain:addScriptToEvaluateOnLoadWithScriptSource:callback:)]) {
        [self.delegate domain:self addScriptToEvaluateOnLoadWithScriptSource:[params objectForKey:@"scriptSource"] callback:^(NSString *identifier, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (identifier != nil) {
                [params setObject:identifier forKey:@"identifier"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"removeScriptToEvaluateOnLoad"] && [self.delegate respondsToSelector:@selector(domain:removeScriptToEvaluateOnLoadWithIdentifier:callback:)]) {
        [self.delegate domain:self removeScriptToEvaluateOnLoadWithIdentifier:[params objectForKey:@"identifier"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"reload"] && [self.delegate respondsToSelector:@selector(domain:reloadWithIgnoreCache:scriptToEvaluateOnLoad:callback:)]) {
        [self.delegate domain:self reloadWithIgnoreCache:[params objectForKey:@"ignoreCache"] scriptToEvaluateOnLoad:[params objectForKey:@"scriptToEvaluateOnLoad"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"navigate"] && [self.delegate respondsToSelector:@selector(domain:navigateWithUrl:callback:)]) {
        [self.delegate domain:self navigateWithUrl:[params objectForKey:@"url"] callback:^(NSString *frameId, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (frameId != nil) {
                [params setObject:frameId forKey:@"frameId"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getNavigationHistory"] && [self.delegate respondsToSelector:@selector(domain:getNavigationHistoryWithCallback:)]) {
        [self.delegate domain:self getNavigationHistoryWithCallback:^(NSNumber *currentIndex, NSArray *entries, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (currentIndex != nil) {
                [params setObject:currentIndex forKey:@"currentIndex"];
            }
            if (entries != nil) {
                [params setObject:entries forKey:@"entries"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"navigateToHistoryEntry"] && [self.delegate respondsToSelector:@selector(domain:navigateToHistoryEntryWithEntryId:callback:)]) {
        [self.delegate domain:self navigateToHistoryEntryWithEntryId:[params objectForKey:@"entryId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getCookies"] && [self.delegate respondsToSelector:@selector(domain:getCookiesWithCallback:)]) {
        [self.delegate domain:self getCookiesWithCallback:^(NSArray *cookies, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (cookies != nil) {
                [params setObject:cookies forKey:@"cookies"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"deleteCookie"] && [self.delegate respondsToSelector:@selector(domain:deleteCookieWithCookieName:url:callback:)]) {
        [self.delegate domain:self deleteCookieWithCookieName:[params objectForKey:@"cookieName"] url:[params objectForKey:@"url"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getResourceTree"] && [self.delegate respondsToSelector:@selector(domain:getResourceTreeWithCallback:)]) {
        [self.delegate domain:self getResourceTreeWithCallback:^(PDPageFrameResourceTree *frameTree, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (frameTree != nil) {
                [params setObject:frameTree forKey:@"frameTree"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getResourceContent"] && [self.delegate respondsToSelector:@selector(domain:getResourceContentWithFrameId:url:callback:)]) {
        [self.delegate domain:self getResourceContentWithFrameId:[params objectForKey:@"frameId"] url:[params objectForKey:@"url"] callback:^(NSString *content, NSNumber *base64Encoded, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (content != nil) {
                [params setObject:content forKey:@"content"];
            }
            if (base64Encoded != nil) {
                [params setObject:base64Encoded forKey:@"base64Encoded"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"searchInResource"] && [self.delegate respondsToSelector:@selector(domain:searchInResourceWithFrameId:url:query:caseSensitive:isRegex:callback:)]) {
        [self.delegate domain:self searchInResourceWithFrameId:[params objectForKey:@"frameId"] url:[params objectForKey:@"url"] query:[params objectForKey:@"query"] caseSensitive:[params objectForKey:@"caseSensitive"] isRegex:[params objectForKey:@"isRegex"] callback:^(NSArray *result, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (result != nil) {
                [params setObject:result forKey:@"result"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setDocumentContent"] && [self.delegate respondsToSelector:@selector(domain:setDocumentContentWithFrameId:html:callback:)]) {
        [self.delegate domain:self setDocumentContentWithFrameId:[params objectForKey:@"frameId"] html:[params objectForKey:@"html"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setDeviceMetricsOverride"] && [self.delegate respondsToSelector:@selector(domain:setDeviceMetricsOverrideWithWidth:height:deviceScaleFactor:mobile:fitWindow:scale:offsetX:offsetY:screenWidth:screenHeight:positionX:positionY:callback:)]) {
        [self.delegate domain:self setDeviceMetricsOverrideWithWidth:[params objectForKey:@"width"] height:[params objectForKey:@"height"] deviceScaleFactor:[params objectForKey:@"deviceScaleFactor"] mobile:[params objectForKey:@"mobile"] fitWindow:[params objectForKey:@"fitWindow"] scale:[params objectForKey:@"scale"] offsetX:[params objectForKey:@"offsetX"] offsetY:[params objectForKey:@"offsetY"] screenWidth:[params objectForKey:@"screenWidth"] screenHeight:[params objectForKey:@"screenHeight"] positionX:[params objectForKey:@"positionX"] positionY:[params objectForKey:@"positionY"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"clearDeviceMetricsOverride"] && [self.delegate respondsToSelector:@selector(domain:clearDeviceMetricsOverrideWithCallback:)]) {
        [self.delegate domain:self clearDeviceMetricsOverrideWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setGeolocationOverride"] && [self.delegate respondsToSelector:@selector(domain:setGeolocationOverrideWithLatitude:longitude:accuracy:callback:)]) {
        [self.delegate domain:self setGeolocationOverrideWithLatitude:[params objectForKey:@"latitude"] longitude:[params objectForKey:@"longitude"] accuracy:[params objectForKey:@"accuracy"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"clearGeolocationOverride"] && [self.delegate respondsToSelector:@selector(domain:clearGeolocationOverrideWithCallback:)]) {
        [self.delegate domain:self clearGeolocationOverrideWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setDeviceOrientationOverride"] && [self.delegate respondsToSelector:@selector(domain:setDeviceOrientationOverrideWithAlpha:beta:gamma:callback:)]) {
        [self.delegate domain:self setDeviceOrientationOverrideWithAlpha:[params objectForKey:@"alpha"] beta:[params objectForKey:@"beta"] gamma:[params objectForKey:@"gamma"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"clearDeviceOrientationOverride"] && [self.delegate respondsToSelector:@selector(domain:clearDeviceOrientationOverrideWithCallback:)]) {
        [self.delegate domain:self clearDeviceOrientationOverrideWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setTouchEmulationEnabled"] && [self.delegate respondsToSelector:@selector(domain:setTouchEmulationEnabledWithEnabled:configuration:callback:)]) {
        [self.delegate domain:self setTouchEmulationEnabledWithEnabled:[params objectForKey:@"enabled"] configuration:[params objectForKey:@"configuration"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"captureScreenshot"] && [self.delegate respondsToSelector:@selector(domain:captureScreenshotWithCallback:)]) {
        [self.delegate domain:self captureScreenshotWithCallback:^(NSString *data, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (data != nil) {
                [params setObject:data forKey:@"data"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"canScreencast"] && [self.delegate respondsToSelector:@selector(domain:canScreencastWithCallback:)]) {
        [self.delegate domain:self canScreencastWithCallback:^(NSNumber *result, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (result != nil) {
                [params setObject:result forKey:@"result"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"startScreencast"] && [self.delegate respondsToSelector:@selector(domain:startScreencastWithFormat:quality:maxWidth:maxHeight:callback:)]) {
        [self.delegate domain:self startScreencastWithFormat:[params objectForKey:@"format"] quality:[params objectForKey:@"quality"] maxWidth:[params objectForKey:@"maxWidth"] maxHeight:[params objectForKey:@"maxHeight"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"stopScreencast"] && [self.delegate respondsToSelector:@selector(domain:stopScreencastWithCallback:)]) {
        [self.delegate domain:self stopScreencastWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"screencastFrameAck"] && [self.delegate respondsToSelector:@selector(domain:screencastFrameAckWithFrameNumber:callback:)]) {
        [self.delegate domain:self screencastFrameAckWithFrameNumber:[params objectForKey:@"frameNumber"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"handleJavaScriptDialog"] && [self.delegate respondsToSelector:@selector(domain:handleJavaScriptDialogWithAccept:promptText:callback:)]) {
        [self.delegate domain:self handleJavaScriptDialogWithAccept:[params objectForKey:@"accept"] promptText:[params objectForKey:@"promptText"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setShowViewportSizeOnResize"] && [self.delegate respondsToSelector:@selector(domain:setShowViewportSizeOnResizeWithShow:showGrid:callback:)]) {
        [self.delegate domain:self setShowViewportSizeOnResizeWithShow:[params objectForKey:@"show"] showGrid:[params objectForKey:@"showGrid"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setColorPickerEnabled"] && [self.delegate respondsToSelector:@selector(domain:setColorPickerEnabledWithEnabled:callback:)]) {
        [self.delegate domain:self setColorPickerEnabledWithEnabled:[params objectForKey:@"enabled"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setOverlayMessage"] && [self.delegate respondsToSelector:@selector(domain:setOverlayMessageWithMessage:callback:)]) {
        [self.delegate domain:self setOverlayMessageWithMessage:[params objectForKey:@"message"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDPageDomain)

- (PDPageDomain *)pageDomain;
{
    return [self domainForName:@"Page"];
}

@end
