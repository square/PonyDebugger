//
//  PDCSSDomain.h
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

@class PDCSSCSSMedia;
@class PDCSSCSSStyleSheetHeader;
@class PDCSSCSSStyle;
@class PDCSSSourceRange;
@class PDCSSCSSRule;

@protocol PDCSSCommandDelegate;

// This domain exposes CSS read/write operations. All CSS objects (stylesheets, rules, and styles) have an associated <code>id</code> used in subsequent operations on the related object. Each object type has a specific <code>id</code> structure, and those are not interchangeable between objects of different kinds. CSS objects can be loaded using the <code>get*ForNode()</code> calls (which accept a DOM node id). A client can also discover all the existing stylesheets with the <code>getAllStyleSheets()</code> method (or keeping track of the <code>styleSheetAdded</code>/<code>styleSheetRemoved</code> events) and subsequently load the required stylesheet contents using the <code>getStyleSheet[Text]()</code> methods.
@interface PDCSSDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDCSSCommandDelegate, PDCommandDelegate> delegate;

// Events

// Fires whenever a MediaQuery result changes (for example, after a browser window has been resized.) The current implementation considers only viewport-dependent media features.
- (void)mediaQueryResultChanged;

// Fired whenever a stylesheet is changed as a result of the client operation.
- (void)styleSheetChangedWithStyleSheetId:(NSString *)styleSheetId;

// Fired whenever an active document stylesheet is added.
// Param header: Added stylesheet metainfo.
- (void)styleSheetAddedWithHeader:(PDCSSCSSStyleSheetHeader *)header;

// Fired whenever an active document stylesheet is removed.
// Param styleSheetId: Identifier of the removed stylesheet.
- (void)styleSheetRemovedWithStyleSheetId:(NSString *)styleSheetId;

@end

@protocol PDCSSCommandDelegate <PDCommandDelegate>
@optional

/// Enables the CSS agent for the given page. Clients should not assume that the CSS agent has been enabled until the result of this command is received.
- (void)domain:(PDCSSDomain *)domain enableWithCallback:(void (^)(id error))callback;

/// Disables the CSS agent for the given page.
- (void)domain:(PDCSSDomain *)domain disableWithCallback:(void (^)(id error))callback;

/// Returns requested styles for a DOM node identified by <code>nodeId</code>.
// Param excludePseudo: Whether to exclude pseudo styles (default: false).
// Param excludeInherited: Whether to exclude inherited styles (default: false).
// Callback Param matchedCSSRules: CSS rules matching this node, from all applicable stylesheets.
// Callback Param pseudoElements: Pseudo style matches for this node.
// Callback Param inherited: A chain of inherited styles (from the immediate node parent up to the DOM tree root).
- (void)domain:(PDCSSDomain *)domain getMatchedStylesForNodeWithNodeId:(NSNumber *)nodeId excludePseudo:(NSNumber *)excludePseudo excludeInherited:(NSNumber *)excludeInherited callback:(void (^)(NSArray *matchedCSSRules, NSArray *pseudoElements, NSArray *inherited, id error))callback;

/// Returns the styles defined inline (explicitly in the "style" attribute and implicitly, using DOM attributes) for a DOM node identified by <code>nodeId</code>.
// Callback Param inlineStyle: Inline style for the specified DOM node.
// Callback Param attributesStyle: Attribute-defined element style (e.g. resulting from "width=20 height=100%").
- (void)domain:(PDCSSDomain *)domain getInlineStylesForNodeWithNodeId:(NSNumber *)nodeId callback:(void (^)(PDCSSCSSStyle *inlineStyle, PDCSSCSSStyle *attributesStyle, id error))callback;

/// Returns the computed style for a DOM node identified by <code>nodeId</code>.
// Callback Param computedStyle: Computed style for the specified DOM node.
- (void)domain:(PDCSSDomain *)domain getComputedStyleForNodeWithNodeId:(NSNumber *)nodeId callback:(void (^)(NSArray *computedStyle, id error))callback;

/// Requests information about platform fonts which we used to render child TextNodes in the given node.
// Callback Param fonts: Usage statistics for every employed platform font.
- (void)domain:(PDCSSDomain *)domain getPlatformFontsForNodeWithNodeId:(NSNumber *)nodeId callback:(void (^)(NSArray *fonts, id error))callback;

/// Returns the current textual content and the URL for a stylesheet.
// Callback Param text: The stylesheet text.
- (void)domain:(PDCSSDomain *)domain getStyleSheetTextWithStyleSheetId:(NSString *)styleSheetId callback:(void (^)(NSString *text, id error))callback;

/// Sets the new stylesheet text.
- (void)domain:(PDCSSDomain *)domain setStyleSheetTextWithStyleSheetId:(NSString *)styleSheetId text:(NSString *)text callback:(void (^)(id error))callback;

/// Modifies the rule selector.
// Callback Param rule: The resulting rule after the selector modification.
- (void)domain:(PDCSSDomain *)domain setRuleSelectorWithStyleSheetId:(NSString *)styleSheetId range:(PDCSSSourceRange *)range selector:(NSString *)selector callback:(void (^)(PDCSSCSSRule *rule, id error))callback;

/// Modifies the style text.
// Callback Param style: The resulting style after the selector modification.
- (void)domain:(PDCSSDomain *)domain setStyleTextWithStyleSheetId:(NSString *)styleSheetId range:(PDCSSSourceRange *)range text:(NSString *)text callback:(void (^)(PDCSSCSSStyle *style, id error))callback;

/// Modifies the rule selector.
// Callback Param media: The resulting CSS media rule after modification.
- (void)domain:(PDCSSDomain *)domain setMediaTextWithStyleSheetId:(NSString *)styleSheetId range:(PDCSSSourceRange *)range text:(NSString *)text callback:(void (^)(PDCSSCSSMedia *media, id error))callback;

/// Creates a new special "via-inspector" stylesheet in the frame with given <code>frameId</code>.
// Param frameId: Identifier of the frame where "via-inspector" stylesheet should be created.
// Callback Param styleSheetId: Identifier of the created "via-inspector" stylesheet.
- (void)domain:(PDCSSDomain *)domain createStyleSheetWithFrameId:(NSString *)frameId callback:(void (^)(NSString *styleSheetId, id error))callback;

/// Inserts a new rule with the given <code>ruleText</code> in a stylesheet with given <code>styleSheetId</code>, at the position specified by <code>location</code>.
// Param styleSheetId: The css style sheet identifier where a new rule should be inserted.
// Param ruleText: The text of a new rule.
// Param location: Text position of a new rule in the target style sheet.
// Callback Param rule: The newly created rule.
- (void)domain:(PDCSSDomain *)domain addRuleWithStyleSheetId:(NSString *)styleSheetId ruleText:(NSString *)ruleText location:(PDCSSSourceRange *)location callback:(void (^)(PDCSSCSSRule *rule, id error))callback;

/// Ensures that the given node will have specified pseudo-classes whenever its style is computed by the browser.
// Param nodeId: The element id for which to force the pseudo state.
// Param forcedPseudoClasses: Element pseudo classes to force when computing the element's style.
- (void)domain:(PDCSSDomain *)domain forcePseudoStateWithNodeId:(NSNumber *)nodeId forcedPseudoClasses:(NSArray *)forcedPseudoClasses callback:(void (^)(id error))callback;

/// Returns all media queries parsed by the rendering engine.
- (void)domain:(PDCSSDomain *)domain getMediaQueriesWithCallback:(void (^)(NSArray *medias, id error))callback;

/// Find a rule with the given active property for the given node and set the new value for this property
// Param nodeId: The element id for which to set property.
- (void)domain:(PDCSSDomain *)domain setEffectivePropertyValueForNodeWithNodeId:(NSNumber *)nodeId propertyName:(NSString *)propertyName value:(NSString *)value callback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDCSSDomain)

@property (nonatomic, readonly, strong) PDCSSDomain *CSSDomain;

@end
