//
//  PDCSSDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDCSSDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDCSSTypes.h>


@interface PDCSSDomain ()
//Commands

@end

@implementation PDCSSDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"CSS";
}

// Events

// Fires whenever a MediaQuery result changes (for example, after a browser window has been resized.) The current implementation considers only viewport-dependent media features.
- (void)mediaQueryResultChanged;
{
    [self.debuggingServer sendEventWithName:@"CSS.mediaQueryResultChanged" parameters:nil];
}

// Fired whenever a stylesheet is changed as a result of the client operation.
- (void)styleSheetChangedWithStyleSheetId:(NSString *)styleSheetId;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (styleSheetId != nil) {
        [params setObject:[styleSheetId PD_JSONObject] forKey:@"styleSheetId"];
    }
    
    [self.debuggingServer sendEventWithName:@"CSS.styleSheetChanged" parameters:params];
}

// Fired whenever an active document stylesheet is added.
- (void)styleSheetAddedWithHeader:(PDCSSCSSStyleSheetHeader *)header;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (header != nil) {
        [params setObject:[header PD_JSONObject] forKey:@"header"];
    }
    
    [self.debuggingServer sendEventWithName:@"CSS.styleSheetAdded" parameters:params];
}

// Fired whenever an active document stylesheet is removed.
- (void)styleSheetRemovedWithStyleSheetId:(NSString *)styleSheetId;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (styleSheetId != nil) {
        [params setObject:[styleSheetId PD_JSONObject] forKey:@"styleSheetId"];
    }
    
    [self.debuggingServer sendEventWithName:@"CSS.styleSheetRemoved" parameters:params];
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
    } else if ([methodName isEqualToString:@"getMatchedStylesForNode"] && [self.delegate respondsToSelector:@selector(domain:getMatchedStylesForNodeWithNodeId:excludePseudo:excludeInherited:callback:)]) {
        [self.delegate domain:self getMatchedStylesForNodeWithNodeId:[params objectForKey:@"nodeId"] excludePseudo:[params objectForKey:@"excludePseudo"] excludeInherited:[params objectForKey:@"excludeInherited"] callback:^(NSArray *matchedCSSRules, NSArray *pseudoElements, NSArray *inherited, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];

            if (matchedCSSRules != nil) {
                [params setObject:matchedCSSRules forKey:@"matchedCSSRules"];
            }
            if (pseudoElements != nil) {
                [params setObject:pseudoElements forKey:@"pseudoElements"];
            }
            if (inherited != nil) {
                [params setObject:inherited forKey:@"inherited"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getInlineStylesForNode"] && [self.delegate respondsToSelector:@selector(domain:getInlineStylesForNodeWithNodeId:callback:)]) {
        [self.delegate domain:self getInlineStylesForNodeWithNodeId:[params objectForKey:@"nodeId"] callback:^(PDCSSCSSStyle *inlineStyle, PDCSSCSSStyle *attributesStyle, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (inlineStyle != nil) {
                [params setObject:inlineStyle forKey:@"inlineStyle"];
            }
            if (attributesStyle != nil) {
                [params setObject:attributesStyle forKey:@"attributesStyle"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getComputedStyleForNode"] && [self.delegate respondsToSelector:@selector(domain:getComputedStyleForNodeWithNodeId:callback:)]) {
        [self.delegate domain:self getComputedStyleForNodeWithNodeId:[params objectForKey:@"nodeId"] callback:^(NSArray *computedStyle, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (computedStyle != nil) {
                [params setObject:computedStyle forKey:@"computedStyle"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getPlatformFontsForNode"] && [self.delegate respondsToSelector:@selector(domain:getPlatformFontsForNodeWithNodeId:callback:)]) {
        [self.delegate domain:self getPlatformFontsForNodeWithNodeId:[params objectForKey:@"nodeId"] callback:^(NSArray *fonts, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (fonts != nil) {
                [params setObject:fonts forKey:@"fonts"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getStyleSheetText"] && [self.delegate respondsToSelector:@selector(domain:getStyleSheetTextWithStyleSheetId:callback:)]) {
        [self.delegate domain:self getStyleSheetTextWithStyleSheetId:[params objectForKey:@"styleSheetId"] callback:^(NSString *text, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (text != nil) {
                [params setObject:text forKey:@"text"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setStyleSheetText"] && [self.delegate respondsToSelector:@selector(domain:setStyleSheetTextWithStyleSheetId:text:callback:)]) {
        [self.delegate domain:self setStyleSheetTextWithStyleSheetId:[params objectForKey:@"styleSheetId"] text:[params objectForKey:@"text"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"setRuleSelector"] && [self.delegate respondsToSelector:@selector(domain:setRuleSelectorWithStyleSheetId:range:selector:callback:)]) {
        [self.delegate domain:self setRuleSelectorWithStyleSheetId:[params objectForKey:@"styleSheetId"] range:[params objectForKey:@"range"] selector:[params objectForKey:@"selector"] callback:^(PDCSSCSSRule *rule, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (rule != nil) {
                [params setObject:rule forKey:@"rule"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setStyleText"] && [self.delegate respondsToSelector:@selector(domain:setStyleTextWithStyleSheetId:range:text:callback:)]) {
        [self.delegate domain:self setStyleTextWithStyleSheetId:[params objectForKey:@"styleSheetId"] range:[params objectForKey:@"range"] text:[params objectForKey:@"text"] callback:^(PDCSSCSSStyle *style, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (style != nil) {
                [params setObject:style forKey:@"style"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setMediaText"] && [self.delegate respondsToSelector:@selector(domain:setMediaTextWithStyleSheetId:range:text:callback:)]) {
        [self.delegate domain:self setMediaTextWithStyleSheetId:[params objectForKey:@"styleSheetId"] range:[params objectForKey:@"range"] text:[params objectForKey:@"text"] callback:^(PDCSSCSSMedia *media, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (media != nil) {
                [params setObject:media forKey:@"media"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"createStyleSheet"] && [self.delegate respondsToSelector:@selector(domain:createStyleSheetWithFrameId:callback:)]) {
        [self.delegate domain:self createStyleSheetWithFrameId:[params objectForKey:@"frameId"] callback:^(NSString *styleSheetId, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (styleSheetId != nil) {
                [params setObject:styleSheetId forKey:@"styleSheetId"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"addRule"] && [self.delegate respondsToSelector:@selector(domain:addRuleWithStyleSheetId:ruleText:location:callback:)]) {
        [self.delegate domain:self addRuleWithStyleSheetId:[params objectForKey:@"styleSheetId"] ruleText:[params objectForKey:@"ruleText"] location:[params objectForKey:@"location"] callback:^(PDCSSCSSRule *rule, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (rule != nil) {
                [params setObject:rule forKey:@"rule"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"forcePseudoState"] && [self.delegate respondsToSelector:@selector(domain:forcePseudoStateWithNodeId:forcedPseudoClasses:callback:)]) {
        [self.delegate domain:self forcePseudoStateWithNodeId:[params objectForKey:@"nodeId"] forcedPseudoClasses:[params objectForKey:@"forcedPseudoClasses"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getMediaQueries"] && [self.delegate respondsToSelector:@selector(domain:getMediaQueriesWithCallback:)]) {
        [self.delegate domain:self getMediaQueriesWithCallback:^(NSArray *medias, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (medias != nil) {
                [params setObject:medias forKey:@"medias"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"setEffectivePropertyValueForNode"] && [self.delegate respondsToSelector:@selector(domain:setEffectivePropertyValueForNodeWithNodeId:propertyName:value:callback:)]) {
        [self.delegate domain:self setEffectivePropertyValueForNodeWithNodeId:[params objectForKey:@"nodeId"] propertyName:[params objectForKey:@"propertyName"] value:[params objectForKey:@"value"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDCSSDomain)

- (PDCSSDomain *)CSSDomain;
{
    return [self domainForName:@"CSS"];
}

@end
