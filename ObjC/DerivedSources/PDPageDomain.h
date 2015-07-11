//
//  PDPageDomain.h
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

@class PDPageFrame;
@class PDPageScreencastFrameMetadata;
@class PDDOMRGBA;
@class PDPageFrameResourceTree;

@protocol PDPageCommandDelegate;

// Actions and events related to the inspected page belong to the page domain.
@interface PDPageDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDPageCommandDelegate, PDCommandDelegate> delegate;

// Events
- (void)domContentEventFiredWithTimestamp:(NSNumber *)timestamp;
- (void)loadEventFiredWithTimestamp:(NSNumber *)timestamp;

// Fired when frame has been attached to its parent.
// Param frameId: Id of the frame that has been attached.
// Param parentFrameId: Parent frame identifier.
- (void)frameAttachedWithFrameId:(NSString *)frameId parentFrameId:(NSString *)parentFrameId;

// Fired once navigation of the frame has completed. Frame is now associated with the new loader.
// Param frame: Frame object.
- (void)frameNavigatedWithFrame:(PDPageFrame *)frame;

// Fired when frame has been detached from its parent.
// Param frameId: Id of the frame that has been detached.
- (void)frameDetachedWithFrameId:(NSString *)frameId;

// Fired when frame has started loading.
// Param frameId: Id of the frame that has started loading.
- (void)frameStartedLoadingWithFrameId:(NSString *)frameId;

// Fired when frame has stopped loading.
// Param frameId: Id of the frame that has stopped loading.
- (void)frameStoppedLoadingWithFrameId:(NSString *)frameId;

// Fired when frame schedules a potential navigation.
// Param frameId: Id of the frame that has scheduled a navigation.
// Param delay: Delay (in seconds) until the navigation is scheduled to begin. The navigation is not guaranteed to start.
- (void)frameScheduledNavigationWithFrameId:(NSString *)frameId delay:(NSNumber *)delay;

// Fired when frame no longer has a scheduled navigation.
// Param frameId: Id of the frame that has cleared its scheduled navigation.
- (void)frameClearedScheduledNavigationWithFrameId:(NSString *)frameId;
- (void)frameResized;

// Fired when a JavaScript initiated dialog (alert, confirm, prompt, or onbeforeunload) is about to open.
// Param message: Message that will be displayed by the dialog.
// Param type: Dialog type.
- (void)javascriptDialogOpeningWithMessage:(NSString *)message type:(NSString *)type;

// Fired when a JavaScript initiated dialog (alert, confirm, prompt, or onbeforeunload) has been closed.
// Param result: Whether dialog was confirmed.
- (void)javascriptDialogClosedWithResult:(NSNumber *)result;

// Compressed image data requested by the <code>startScreencast</code>.
// Param data: Base64-encoded compressed image.
// Param metadata: Screencast frame metadata.
// Param frameNumber: Frame number.
- (void)screencastFrameWithData:(NSString *)data metadata:(PDPageScreencastFrameMetadata *)metadata frameNumber:(NSNumber *)frameNumber;

// Fired when the page with currently enabled screencast was shown or hidden </code>.
// Param visible: True if the page is visible.
- (void)screencastVisibilityChangedWithVisible:(NSNumber *)visible;

// Fired when a color has been picked.
// Param color: RGBA of the picked color.
- (void)colorPickedWithColor:(PDDOMRGBA *)color;

// Fired when interstitial page was shown
- (void)interstitialShown;

// Fired when interstitial page was hidden
- (void)interstitialHidden;

@end

@protocol PDPageCommandDelegate <PDCommandDelegate>
@optional

/// Enables page domain notifications.
- (void)domain:(PDPageDomain *)domain enableWithCallback:(void (^)(id error))callback;

/// Disables page domain notifications.
- (void)domain:(PDPageDomain *)domain disableWithCallback:(void (^)(id error))callback;
// Callback Param identifier: Identifier of the added script.
- (void)domain:(PDPageDomain *)domain addScriptToEvaluateOnLoadWithScriptSource:(NSString *)scriptSource callback:(void (^)(NSString *identifier, id error))callback;
- (void)domain:(PDPageDomain *)domain removeScriptToEvaluateOnLoadWithIdentifier:(NSString *)identifier callback:(void (^)(id error))callback;

/// Reloads given page optionally ignoring the cache.
// Param ignoreCache: If true, browser cache is ignored (as if the user pressed Shift+refresh).
// Param scriptToEvaluateOnLoad: If set, the script will be injected into all frames of the inspected page after reload.
- (void)domain:(PDPageDomain *)domain reloadWithIgnoreCache:(NSNumber *)ignoreCache scriptToEvaluateOnLoad:(NSString *)scriptToEvaluateOnLoad callback:(void (^)(id error))callback;

/// Navigates current page to the given URL.
// Param url: URL to navigate the page to.
// Callback Param frameId: Frame id that will be navigated.
- (void)domain:(PDPageDomain *)domain navigateWithUrl:(NSString *)url callback:(void (^)(NSString *frameId, id error))callback;

/// Returns navigation history for the current page.
// Callback Param currentIndex: Index of the current navigation history entry.
// Callback Param entries: Array of navigation history entries.
- (void)domain:(PDPageDomain *)domain getNavigationHistoryWithCallback:(void (^)(NSNumber *currentIndex, NSArray *entries, id error))callback;

/// Navigates current page to the given history entry.
// Param entryId: Unique id of the entry to navigate to.
- (void)domain:(PDPageDomain *)domain navigateToHistoryEntryWithEntryId:(NSNumber *)entryId callback:(void (^)(id error))callback;

/// Returns all browser cookies. Depending on the backend support, will return detailed cookie information in the <code>cookies</code> field.
// Callback Param cookies: Array of cookie objects.
- (void)domain:(PDPageDomain *)domain getCookiesWithCallback:(void (^)(NSArray *cookies, id error))callback;

/// Deletes browser cookie with given name, domain and path.
// Param cookieName: Name of the cookie to remove.
// Param url: URL to match cooke domain and path.
- (void)domain:(PDPageDomain *)domain deleteCookieWithCookieName:(NSString *)cookieName url:(NSString *)url callback:(void (^)(id error))callback;

/// Returns present frame / resource tree structure.
// Callback Param frameTree: Present frame / resource tree structure.
- (void)domain:(PDPageDomain *)domain getResourceTreeWithCallback:(void (^)(PDPageFrameResourceTree *frameTree, id error))callback;

/// Returns content of the given resource.
// Param frameId: Frame id to get resource for.
// Param url: URL of the resource to get content for.
// Callback Param content: Resource content.
// Callback Param base64Encoded: True, if content was served as base64.
- (void)domain:(PDPageDomain *)domain getResourceContentWithFrameId:(NSString *)frameId url:(NSString *)url callback:(void (^)(NSString *content, NSNumber *base64Encoded, id error))callback;

/// Searches for given string in resource content.
// Param frameId: Frame id for resource to search in.
// Param url: URL of the resource to search in.
// Param query: String to search for.
// Param caseSensitive: If true, search is case sensitive.
// Param isRegex: If true, treats string parameter as regex.
// Callback Param result: List of search matches.
- (void)domain:(PDPageDomain *)domain searchInResourceWithFrameId:(NSString *)frameId url:(NSString *)url query:(NSString *)query caseSensitive:(NSNumber *)caseSensitive isRegex:(NSNumber *)isRegex callback:(void (^)(NSArray *result, id error))callback;

/// Sets given markup as the document's HTML.
// Param frameId: Frame id to set HTML for.
// Param html: HTML content to set.
- (void)domain:(PDPageDomain *)domain setDocumentContentWithFrameId:(NSString *)frameId html:(NSString *)html callback:(void (^)(id error))callback;

/// Overrides the values of device screen dimensions (window.screen.width, window.screen.height, window.innerWidth, window.innerHeight, and "device-width"/"device-height"-related CSS media query results).
// Param width: Overriding width value in pixels (minimum 0, maximum 10000000). 0 disables the override.
// Param height: Overriding height value in pixels (minimum 0, maximum 10000000). 0 disables the override.
// Param deviceScaleFactor: Overriding device scale factor value. 0 disables the override.
// Param mobile: Whether to emulate mobile device. This includes viewport meta tag, overlay scrollbars, text autosizing and more.
// Param fitWindow: Whether a view that exceeds the available browser window area should be scaled down to fit.
// Param scale: Scale to apply to resulting view image. Ignored in |fitWindow| mode.
// Param offsetX: X offset to shift resulting view image by. Ignored in |fitWindow| mode.
// Param offsetY: Y offset to shift resulting view image by. Ignored in |fitWindow| mode.
// Param screenWidth: Overriding screen width value in pixels (minimum 0, maximum 10000000). Only used for |mobile==true|.
// Param screenHeight: Overriding screen height value in pixels (minimum 0, maximum 10000000). Only used for |mobile==true|.
// Param positionX: Overriding view X position on screen in pixels (minimum 0, maximum 10000000). Only used for |mobile==true|.
// Param positionY: Overriding view Y position on screen in pixels (minimum 0, maximum 10000000). Only used for |mobile==true|.
- (void)domain:(PDPageDomain *)domain setDeviceMetricsOverrideWithWidth:(NSNumber *)width height:(NSNumber *)height deviceScaleFactor:(NSNumber *)deviceScaleFactor mobile:(NSNumber *)mobile fitWindow:(NSNumber *)fitWindow scale:(NSNumber *)scale offsetX:(NSNumber *)offsetX offsetY:(NSNumber *)offsetY screenWidth:(NSNumber *)screenWidth screenHeight:(NSNumber *)screenHeight positionX:(NSNumber *)positionX positionY:(NSNumber *)positionY callback:(void (^)(id error))callback;

/// Clears the overriden device metrics.
- (void)domain:(PDPageDomain *)domain clearDeviceMetricsOverrideWithCallback:(void (^)(id error))callback;

/// Overrides the Geolocation Position or Error. Omitting any of the parameters emulates position unavailable.
// Param latitude: Mock latitude
// Param longitude: Mock longitude
// Param accuracy: Mock accuracy
- (void)domain:(PDPageDomain *)domain setGeolocationOverrideWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude accuracy:(NSNumber *)accuracy callback:(void (^)(id error))callback;

/// Clears the overriden Geolocation Position and Error.
- (void)domain:(PDPageDomain *)domain clearGeolocationOverrideWithCallback:(void (^)(id error))callback;

/// Overrides the Device Orientation.
// Param alpha: Mock alpha
// Param beta: Mock beta
// Param gamma: Mock gamma
- (void)domain:(PDPageDomain *)domain setDeviceOrientationOverrideWithAlpha:(NSNumber *)alpha beta:(NSNumber *)beta gamma:(NSNumber *)gamma callback:(void (^)(id error))callback;

/// Clears the overridden Device Orientation.
- (void)domain:(PDPageDomain *)domain clearDeviceOrientationOverrideWithCallback:(void (^)(id error))callback;

/// Toggles mouse event-based touch event emulation.
// Param enabled: Whether the touch event emulation should be enabled.
// Param configuration: Touch/gesture events configuration. Default: current platform.
- (void)domain:(PDPageDomain *)domain setTouchEmulationEnabledWithEnabled:(NSNumber *)enabled configuration:(NSString *)configuration callback:(void (^)(id error))callback;

/// Capture page screenshot.
// Callback Param data: Base64-encoded image data (PNG).
- (void)domain:(PDPageDomain *)domain captureScreenshotWithCallback:(void (^)(NSString *data, id error))callback;

/// Tells whether screencast is supported.
// Callback Param result: True if screencast is supported.
- (void)domain:(PDPageDomain *)domain canScreencastWithCallback:(void (^)(NSNumber *result, id error))callback;

/// Starts sending each frame using the <code>screencastFrame</code> event.
// Param format: Image compression format.
// Param quality: Compression quality from range [0..100].
// Param maxWidth: Maximum screenshot width.
// Param maxHeight: Maximum screenshot height.
- (void)domain:(PDPageDomain *)domain startScreencastWithFormat:(NSString *)format quality:(NSNumber *)quality maxWidth:(NSNumber *)maxWidth maxHeight:(NSNumber *)maxHeight callback:(void (^)(id error))callback;

/// Stops sending each frame in the <code>screencastFrame</code>.
- (void)domain:(PDPageDomain *)domain stopScreencastWithCallback:(void (^)(id error))callback;

/// Acknowledges that a screencast frame has been received by the frontend.
// Param frameNumber: Frame number.
- (void)domain:(PDPageDomain *)domain screencastFrameAckWithFrameNumber:(NSNumber *)frameNumber callback:(void (^)(id error))callback;

/// Accepts or dismisses a JavaScript initiated dialog (alert, confirm, prompt, or onbeforeunload).
// Param accept: Whether to accept or dismiss the dialog.
// Param promptText: The text to enter into the dialog prompt before accepting. Used only if this is a prompt dialog.
- (void)domain:(PDPageDomain *)domain handleJavaScriptDialogWithAccept:(NSNumber *)accept promptText:(NSString *)promptText callback:(void (^)(id error))callback;

/// Paints viewport size upon main frame resize.
// Param show: Whether to paint size or not.
// Param showGrid: Whether to paint grid as well.
- (void)domain:(PDPageDomain *)domain setShowViewportSizeOnResizeWithShow:(NSNumber *)show showGrid:(NSNumber *)showGrid callback:(void (^)(id error))callback;

/// Shows / hides color picker
// Param enabled: Shows / hides color picker
- (void)domain:(PDPageDomain *)domain setColorPickerEnabledWithEnabled:(NSNumber *)enabled callback:(void (^)(id error))callback;

/// Sets overlay message.
// Param message: Overlay message to display when paused in debugger.
- (void)domain:(PDPageDomain *)domain setOverlayMessageWithMessage:(NSString *)message callback:(void (^)(id error))callback;

@end

@interface PDDebugger (PDPageDomain)

@property (nonatomic, readonly, strong) PDPageDomain *pageDomain;

@end
