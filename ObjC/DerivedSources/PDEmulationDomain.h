//
//  PDEmulationDomain.h
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

@class PDEmulationViewport;

@protocol PDEmulationCommandDelegate;

// This domain emulates different environments for the page.
@interface PDEmulationDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDEmulationCommandDelegate, PDCommandDelegate> delegate;

// Events

// Fired when a visible page viewport has changed. Only fired when device metrics are overridden.
// Param viewport: Viewport description.
- (void)viewportChangedWithViewport:(PDEmulationViewport *)viewport;

@end

@protocol PDEmulationCommandDelegate <PDCommandDelegate>
@optional

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
- (void)domain:(PDEmulationDomain *)domain setDeviceMetricsOverrideWithWidth:(NSNumber *)width height:(NSNumber *)height deviceScaleFactor:(NSNumber *)deviceScaleFactor mobile:(NSNumber *)mobile fitWindow:(NSNumber *)fitWindow scale:(NSNumber *)scale offsetX:(NSNumber *)offsetX offsetY:(NSNumber *)offsetY screenWidth:(NSNumber *)screenWidth screenHeight:(NSNumber *)screenHeight positionX:(NSNumber *)positionX positionY:(NSNumber *)positionY callback:(void (^)(id error))callback;

/// Clears the overriden device metrics.
- (void)domain:(PDEmulationDomain *)domain clearDeviceMetricsOverrideWithCallback:(void (^)(id error))callback;

/// Requests that scroll offsets and page scale factor are reset to initial values.
- (void)domain:(PDEmulationDomain *)domain resetScrollAndPageScaleFactorWithCallback:(void (^)(id error))callback;

/// Sets a specified page scale factor.
// Param pageScaleFactor: Page scale factor.
- (void)domain:(PDEmulationDomain *)domain setPageScaleFactorWithPageScaleFactor:(NSNumber *)pageScaleFactor callback:(void (^)(id error))callback;

/// Switches script execution in the page.
// Param value: Whether script execution should be disabled in the page.
- (void)domain:(PDEmulationDomain *)domain setScriptExecutionDisabledWithValue:(NSNumber *)value callback:(void (^)(id error))callback;

/// Overrides the Geolocation Position or Error. Omitting any of the parameters emulates position unavailable.
// Param latitude: Mock latitude
// Param longitude: Mock longitude
// Param accuracy: Mock accuracy
- (void)domain:(PDEmulationDomain *)domain setGeolocationOverrideWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude accuracy:(NSNumber *)accuracy callback:(void (^)(id error))callback;

/// Clears the overriden Geolocation Position and Error.
- (void)domain:(PDEmulationDomain *)domain clearGeolocationOverrideWithCallback:(void (^)(id error))callback;

/// Toggles mouse event-based touch event emulation.
// Param enabled: Whether the touch event emulation should be enabled.
// Param configuration: Touch/gesture events configuration. Default: current platform.
- (void)domain:(PDEmulationDomain *)domain setTouchEmulationEnabledWithEnabled:(NSNumber *)enabled configuration:(NSString *)configuration callback:(void (^)(id error))callback;

/// Emulates the given media for CSS media queries.
// Param media: Media type to emulate. Empty string disables the override.
- (void)domain:(PDEmulationDomain *)domain setEmulatedMediaWithMedia:(NSString *)media callback:(void (^)(id error))callback;

/// Tells whether emulation is supported.
// Callback Param result: True if emulation is supported.
- (void)domain:(PDEmulationDomain *)domain canEmulateWithCallback:(void (^)(NSNumber *result, id error))callback;

@end

@interface PDDebugger (PDEmulationDomain)

@property (nonatomic, readonly, strong) PDEmulationDomain *emulationDomain;

@end
