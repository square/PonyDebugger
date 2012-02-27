#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDPageDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDPageTypes.h>


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
        [self.delegate domain:self navigateWithUrl:[params objectForKey:@"url"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getCookies"] && [self.delegate respondsToSelector:@selector(domain:getCookiesWithCallback:)]) {
        [self.delegate domain:self getCookiesWithCallback:^(NSArray *cookies, NSString *cookiesString, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (cookies != nil) {
                [params setObject:cookies forKey:@"cookies"];
            }
            if (cookiesString != nil) {
                [params setObject:cookiesString forKey:@"cookiesString"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"deleteCookie"] && [self.delegate respondsToSelector:@selector(domain:deleteCookieWithCookieName:domain:callback:)]) {
        [self.delegate domain:self deleteCookieWithCookieName:[params objectForKey:@"cookieName"] domain:[params objectForKey:@"domain"] callback:^(id error) {
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
    } else if ([methodName isEqualToString:@"searchInResources"] && [self.delegate respondsToSelector:@selector(domain:searchInResourcesWithText:caseSensitive:isRegex:callback:)]) {
        [self.delegate domain:self searchInResourcesWithText:[params objectForKey:@"text"] caseSensitive:[params objectForKey:@"caseSensitive"] isRegex:[params objectForKey:@"isRegex"] callback:^(NSArray *result, id error) {
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
    } else if ([methodName isEqualToString:@"setScreenSizeOverride"] && [self.delegate respondsToSelector:@selector(domain:setScreenSizeOverrideWithWidth:height:callback:)]) {
        [self.delegate domain:self setScreenSizeOverrideWithWidth:[params objectForKey:@"width"] height:[params objectForKey:@"height"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setShowPaintRects"] && [self.delegate respondsToSelector:@selector(domain:setShowPaintRectsWithResult:callback:)]) {
        [self.delegate domain:self setShowPaintRectsWithResult:[params objectForKey:@"result"] callback:^(id error) {
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
