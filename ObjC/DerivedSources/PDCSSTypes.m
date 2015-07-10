//
//  PDCSSTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDCSSTypes.h"

@implementation PDCSSPseudoIdMatches

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"pseudoId",@"pseudoId",
                    @"matches",@"matches",
                    nil];
    });

    return mappings;
}

@dynamic pseudoId;
@dynamic matches;
 
@end

@implementation PDCSSInheritedStyleEntry

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"inlineStyle",@"inlineStyle",
                    @"matchedCSSRules",@"matchedCSSRules",
                    nil];
    });

    return mappings;
}

@dynamic inlineStyle;
@dynamic matchedCSSRules;
 
@end

@implementation PDCSSRuleMatch

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"rule",@"rule",
                    @"matchingSelectors",@"matchingSelectors",
                    nil];
    });

    return mappings;
}

@dynamic rule;
@dynamic matchingSelectors;
 
@end

@implementation PDCSSSelector

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"value",@"value",
                    @"range",@"range",
                    nil];
    });

    return mappings;
}

@dynamic value;
@dynamic range;
 
@end

@implementation PDCSSSelectorList

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"selectors",@"selectors",
                    @"text",@"text",
                    nil];
    });

    return mappings;
}

@dynamic selectors;
@dynamic text;
 
@end

@implementation PDCSSCSSStyleSheetHeader

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"styleSheetId",@"styleSheetId",
                    @"frameId",@"frameId",
                    @"sourceURL",@"sourceURL",
                    @"sourceMapURL",@"sourceMapURL",
                    @"origin",@"origin",
                    @"title",@"title",
                    @"ownerNode",@"ownerNode",
                    @"disabled",@"disabled",
                    @"hasSourceURL",@"hasSourceURL",
                    @"isInline",@"isInline",
                    @"startLine",@"startLine",
                    @"startColumn",@"startColumn",
                    nil];
    });

    return mappings;
}

@dynamic styleSheetId;
@dynamic frameId;
@dynamic sourceURL;
@dynamic sourceMapURL;
@dynamic origin;
@dynamic title;
@dynamic ownerNode;
@dynamic disabled;
@dynamic hasSourceURL;
@dynamic isInline;
@dynamic startLine;
@dynamic startColumn;
 
@end

@implementation PDCSSCSSRule

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"styleSheetId",@"styleSheetId",
                    @"selectorList",@"selectorList",
                    @"origin",@"origin",
                    @"style",@"style",
                    @"media",@"media",
                    nil];
    });

    return mappings;
}

@dynamic styleSheetId;
@dynamic selectorList;
@dynamic origin;
@dynamic style;
@dynamic media;
 
@end

@implementation PDCSSSourceRange

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"startLine",@"startLine",
                    @"startColumn",@"startColumn",
                    @"endLine",@"endLine",
                    @"endColumn",@"endColumn",
                    nil];
    });

    return mappings;
}

@dynamic startLine;
@dynamic startColumn;
@dynamic endLine;
@dynamic endColumn;
 
@end

@implementation PDCSSShorthandEntry

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"name",@"name",
                    @"value",@"value",
                    @"important",@"important",
                    nil];
    });

    return mappings;
}

@dynamic name;
@dynamic value;
@dynamic important;
 
@end

@implementation PDCSSCSSComputedStyleProperty

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"name",@"name",
                    @"value",@"value",
                    nil];
    });

    return mappings;
}

@dynamic name;
@dynamic value;
 
@end

@implementation PDCSSCSSStyle

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"styleSheetId",@"styleSheetId",
                    @"cssProperties",@"cssProperties",
                    @"shorthandEntries",@"shorthandEntries",
                    @"cssText",@"cssText",
                    @"range",@"range",
                    nil];
    });

    return mappings;
}

@dynamic styleSheetId;
@dynamic cssProperties;
@dynamic shorthandEntries;
@dynamic cssText;
@dynamic range;
 
@end

@implementation PDCSSCSSProperty

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"name",@"name",
                    @"value",@"value",
                    @"important",@"important",
                    @"implicit",@"implicit",
                    @"text",@"text",
                    @"parsedOk",@"parsedOk",
                    @"disabled",@"disabled",
                    @"range",@"range",
                    nil];
    });

    return mappings;
}

@dynamic name;
@dynamic value;
@dynamic important;
@dynamic implicit;
@dynamic text;
@dynamic parsedOk;
@dynamic disabled;
@dynamic range;
 
@end

@implementation PDCSSCSSMedia

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"text",@"text",
                    @"source",@"source",
                    @"sourceURL",@"sourceURL",
                    @"range",@"range",
                    @"parentStyleSheetId",@"parentStyleSheetId",
                    @"mediaList",@"mediaList",
                    nil];
    });

    return mappings;
}

@dynamic text;
@dynamic source;
@dynamic sourceURL;
@dynamic range;
@dynamic parentStyleSheetId;
@dynamic mediaList;
 
@end

@implementation PDCSSMediaQuery

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"expressions",@"expressions",
                    @"active",@"active",
                    nil];
    });

    return mappings;
}

@dynamic expressions;
@dynamic active;
 
@end

@implementation PDCSSMediaQueryExpression

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"value",@"value",
                    @"unit",@"unit",
                    @"feature",@"feature",
                    @"valueRange",@"valueRange",
                    @"computedLength",@"computedLength",
                    nil];
    });

    return mappings;
}

@dynamic value;
@dynamic unit;
@dynamic feature;
@dynamic valueRange;
@dynamic computedLength;
 
@end

@implementation PDCSSPlatformFontUsage

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"familyName",@"familyName",
                    @"glyphCount",@"glyphCount",
                    nil];
    });

    return mappings;
}

@dynamic familyName;
@dynamic glyphCount;
 
@end

