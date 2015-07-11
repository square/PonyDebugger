//    
//  PDCSSTypes.h
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//
    
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


@class PDCSSCSSStyle;
@class PDCSSCSSRule;
@class PDCSSSourceRange;


/// CSS rule collection for a single pseudo style.
@interface PDCSSPseudoIdMatches : PDObject

/// Pseudo style identifier (see <code>enum PseudoId</code> in <code>ComputedStyleConstants.h</code>).
/// Type: integer
@property (nonatomic, strong) NSNumber *pseudoId;

/// Matches of CSS rules applicable to the pseudo style.
/// Type: array
@property (nonatomic, strong) NSArray *matches;

@end


/// Inherited CSS rule collection from ancestor node.
@interface PDCSSInheritedStyleEntry : PDObject

/// The ancestor node's inline style, if any, in the style inheritance chain.
@property (nonatomic, strong) PDCSSCSSStyle *inlineStyle;

/// Matches of CSS rules matching the ancestor node in the style inheritance chain.
/// Type: array
@property (nonatomic, strong) NSArray *matchedCSSRules;

@end


/// Match data for a CSS rule.
@interface PDCSSRuleMatch : PDObject

/// CSS rule in the match.
@property (nonatomic, strong) PDCSSCSSRule *rule;

/// Matching selector indices in the rule's selectorList selectors (0-based).
/// Type: array
@property (nonatomic, strong) NSArray *matchingSelectors;

@end


/// Data for a simple selector (these are delimited by commas in a selector list).
@interface PDCSSSelector : PDObject

/// Selector text.
/// Type: string
@property (nonatomic, strong) NSString *value;

/// Selector range in the underlying resource (if available).
@property (nonatomic, strong) PDCSSSourceRange *range;

@end


/// Selector list data.
@interface PDCSSSelectorList : PDObject

/// Selectors in the list.
/// Type: array
@property (nonatomic, strong) NSArray *selectors;

/// Rule selector text.
/// Type: string
@property (nonatomic, strong) NSString *text;

@end


/// CSS stylesheet metainformation.
@interface PDCSSCSSStyleSheetHeader : PDObject

/// The stylesheet identifier.
@property (nonatomic, strong) NSString *styleSheetId;

/// Owner frame identifier.
@property (nonatomic, strong) NSString *frameId;

/// Stylesheet resource URL.
/// Type: string
@property (nonatomic, strong) NSString *sourceURL;

/// URL of source map associated with the stylesheet (if any).
/// Type: string
@property (nonatomic, strong) NSString *sourceMapURL;

/// Stylesheet origin.
@property (nonatomic, strong) NSString *origin;

/// Stylesheet title.
/// Type: string
@property (nonatomic, strong) NSString *title;

/// The backend id for the owner node of the stylesheet.
@property (nonatomic, strong) NSNumber *ownerNode;

/// Denotes whether the stylesheet is disabled.
/// Type: boolean
@property (nonatomic, strong) NSNumber *disabled;

/// Whether the sourceURL field value comes from the sourceURL comment.
/// Type: boolean
@property (nonatomic, strong) NSNumber *hasSourceURL;

/// Whether this stylesheet is created for STYLE tag by parser. This flag is not set for document.written STYLE tags.
/// Type: boolean
@property (nonatomic, strong) NSNumber *isInline;

/// Line offset of the stylesheet within the resource (zero based).
/// Type: number
@property (nonatomic, strong) NSNumber *startLine;

/// Column offset of the stylesheet within the resource (zero based).
/// Type: number
@property (nonatomic, strong) NSNumber *startColumn;

@end


/// CSS rule representation.
@interface PDCSSCSSRule : PDObject

/// The css style sheet identifier (absent for user agent stylesheet and user-specified stylesheet rules) this rule came from.
@property (nonatomic, strong) NSString *styleSheetId;

/// Rule selector data.
@property (nonatomic, strong) PDCSSSelectorList *selectorList;

/// Parent stylesheet's origin.
@property (nonatomic, strong) NSString *origin;

/// Associated style declaration.
@property (nonatomic, strong) PDCSSCSSStyle *style;

/// Media list array (for rules involving media queries). The array enumerates media queries starting with the innermost one, going outwards.
/// Type: array
@property (nonatomic, strong) NSArray *media;

@end


/// Text range within a resource. All numbers are zero-based.
@interface PDCSSSourceRange : PDObject

/// Start line of range.
/// Type: integer
@property (nonatomic, strong) NSNumber *startLine;

/// Start column of range (inclusive).
/// Type: integer
@property (nonatomic, strong) NSNumber *startColumn;

/// End line of range
/// Type: integer
@property (nonatomic, strong) NSNumber *endLine;

/// End column of range (exclusive).
/// Type: integer
@property (nonatomic, strong) NSNumber *endColumn;

@end


@interface PDCSSShorthandEntry : PDObject

/// Shorthand name.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// Shorthand value.
/// Type: string
@property (nonatomic, strong) NSString *value;

/// Whether the property has "!important" annotation (implies <code>false</code> if absent).
/// Type: boolean
@property (nonatomic, strong) NSNumber *important;

@end


@interface PDCSSCSSComputedStyleProperty : PDObject

/// Computed style property name.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// Computed style property value.
/// Type: string
@property (nonatomic, strong) NSString *value;

@end


/// CSS style representation.
@interface PDCSSCSSStyle : PDObject

/// The css style sheet identifier (absent for user agent stylesheet and user-specified stylesheet rules) this rule came from.
@property (nonatomic, strong) NSString *styleSheetId;

/// CSS properties in the style.
/// Type: array
@property (nonatomic, strong) NSArray *cssProperties;

/// Computed values for all shorthands found in the style.
/// Type: array
@property (nonatomic, strong) NSArray *shorthandEntries;

/// Style declaration text (if available).
/// Type: string
@property (nonatomic, strong) NSString *cssText;

/// Style declaration range in the enclosing stylesheet (if available).
@property (nonatomic, strong) PDCSSSourceRange *range;

@end


/// CSS property declaration data.
@interface PDCSSCSSProperty : PDObject

/// The property name.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// The property value.
/// Type: string
@property (nonatomic, strong) NSString *value;

/// Whether the property has "!important" annotation (implies <code>false</code> if absent).
/// Type: boolean
@property (nonatomic, strong) NSNumber *important;

/// Whether the property is implicit (implies <code>false</code> if absent).
/// Type: boolean
@property (nonatomic, strong) NSNumber *implicit;

/// The full property text as specified in the style.
/// Type: string
@property (nonatomic, strong) NSString *text;

/// Whether the property is understood by the browser (implies <code>true</code> if absent).
/// Type: boolean
@property (nonatomic, strong) NSNumber *parsedOk;

/// Whether the property is disabled by the user (present for source-based properties only).
/// Type: boolean
@property (nonatomic, strong) NSNumber *disabled;

/// The entire property range in the enclosing style declaration (if available).
@property (nonatomic, strong) PDCSSSourceRange *range;

@end


/// CSS media rule descriptor.
@interface PDCSSCSSMedia : PDObject

/// Media query text.
/// Type: string
@property (nonatomic, strong) NSString *text;

/// Source of the media query: "mediaRule" if specified by a @media rule, "importRule" if specified by an @import rule, "linkedSheet" if specified by a "media" attribute in a linked stylesheet's LINK tag, "inlineSheet" if specified by a "media" attribute in an inline stylesheet's STYLE tag.
/// Type: string
@property (nonatomic, strong) NSString *source;

/// URL of the document containing the media query description.
/// Type: string
@property (nonatomic, strong) NSString *sourceURL;

/// The associated rule (@media or @import) header range in the enclosing stylesheet (if available).
@property (nonatomic, strong) PDCSSSourceRange *range;

/// Identifier of the stylesheet containing this object (if exists).
@property (nonatomic, strong) NSString *parentStyleSheetId;

/// Array of media queries.
/// Type: array
@property (nonatomic, strong) NSArray *mediaList;

@end


/// Media query descriptor.
@interface PDCSSMediaQuery : PDObject

/// Array of media query expressions.
/// Type: array
@property (nonatomic, strong) NSArray *expressions;

/// Whether the media query condition is satisfied.
/// Type: boolean
@property (nonatomic, strong) NSNumber *active;

@end


/// Media query expression descriptor.
@interface PDCSSMediaQueryExpression : PDObject

/// Media query expression value.
/// Type: number
@property (nonatomic, strong) NSNumber *value;

/// Media query expression units.
/// Type: string
@property (nonatomic, strong) NSString *unit;

/// Media query expression feature.
/// Type: string
@property (nonatomic, strong) NSString *feature;

/// The associated range of the value text in the enclosing stylesheet (if available).
@property (nonatomic, strong) PDCSSSourceRange *valueRange;

/// Computed length of media query expression (if applicable).
/// Type: number
@property (nonatomic, strong) NSNumber *computedLength;

@end


/// Information about amount of glyphs that were rendered with given font.
@interface PDCSSPlatformFontUsage : PDObject

/// Font's family name reported by platform.
/// Type: string
@property (nonatomic, strong) NSString *familyName;

/// Amount of glyphs that were rendered with this font.
/// Type: number
@property (nonatomic, strong) NSNumber *glyphCount;

@end


