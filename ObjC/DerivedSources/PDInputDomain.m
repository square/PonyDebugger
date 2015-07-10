//
//  PDInputDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDInputDomain.h>
#import <PonyDebugger/PDObject.h>


@interface PDInputDomain ()
//Commands

@end

@implementation PDInputDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Input";
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"dispatchKeyEvent"] && [self.delegate respondsToSelector:@selector(domain:dispatchKeyEventWithType:modifiers:timestamp:text:unmodifiedText:keyIdentifier:code:key:windowsVirtualKeyCode:nativeVirtualKeyCode:autoRepeat:isKeypad:isSystemKey:callback:)]) {
        [self.delegate domain:self dispatchKeyEventWithType:[params objectForKey:@"type"] modifiers:[params objectForKey:@"modifiers"] timestamp:[params objectForKey:@"timestamp"] text:[params objectForKey:@"text"] unmodifiedText:[params objectForKey:@"unmodifiedText"] keyIdentifier:[params objectForKey:@"keyIdentifier"] code:[params objectForKey:@"code"] key:[params objectForKey:@"key"] windowsVirtualKeyCode:[params objectForKey:@"windowsVirtualKeyCode"] nativeVirtualKeyCode:[params objectForKey:@"nativeVirtualKeyCode"] autoRepeat:[params objectForKey:@"autoRepeat"] isKeypad:[params objectForKey:@"isKeypad"] isSystemKey:[params objectForKey:@"isSystemKey"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"dispatchMouseEvent"] && [self.delegate respondsToSelector:@selector(domain:dispatchMouseEventWithType:x:y:modifiers:timestamp:button:clickCount:callback:)]) {
        [self.delegate domain:self dispatchMouseEventWithType:[params objectForKey:@"type"] x:[params objectForKey:@"x"] y:[params objectForKey:@"y"] modifiers:[params objectForKey:@"modifiers"] timestamp:[params objectForKey:@"timestamp"] button:[params objectForKey:@"button"] clickCount:[params objectForKey:@"clickCount"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"dispatchTouchEvent"] && [self.delegate respondsToSelector:@selector(domain:dispatchTouchEventWithType:touchPoints:modifiers:timestamp:callback:)]) {
        [self.delegate domain:self dispatchTouchEventWithType:[params objectForKey:@"type"] touchPoints:[params objectForKey:@"touchPoints"] modifiers:[params objectForKey:@"modifiers"] timestamp:[params objectForKey:@"timestamp"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"emulateTouchFromMouseEvent"] && [self.delegate respondsToSelector:@selector(domain:emulateTouchFromMouseEventWithType:x:y:timestamp:button:deltaX:deltaY:modifiers:clickCount:callback:)]) {
        [self.delegate domain:self emulateTouchFromMouseEventWithType:[params objectForKey:@"type"] x:[params objectForKey:@"x"] y:[params objectForKey:@"y"] timestamp:[params objectForKey:@"timestamp"] button:[params objectForKey:@"button"] deltaX:[params objectForKey:@"deltaX"] deltaY:[params objectForKey:@"deltaY"] modifiers:[params objectForKey:@"modifiers"] clickCount:[params objectForKey:@"clickCount"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"synthesizePinchGesture"] && [self.delegate respondsToSelector:@selector(domain:synthesizePinchGestureWithX:y:scaleFactor:relativeSpeed:gestureSourceType:callback:)]) {
        [self.delegate domain:self synthesizePinchGestureWithX:[params objectForKey:@"x"] y:[params objectForKey:@"y"] scaleFactor:[params objectForKey:@"scaleFactor"] relativeSpeed:[params objectForKey:@"relativeSpeed"] gestureSourceType:[params objectForKey:@"gestureSourceType"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"synthesizeScrollGesture"] && [self.delegate respondsToSelector:@selector(domain:synthesizeScrollGestureWithX:y:xDistance:yDistance:xOverscroll:yOverscroll:preventFling:speed:gestureSourceType:callback:)]) {
        [self.delegate domain:self synthesizeScrollGestureWithX:[params objectForKey:@"x"] y:[params objectForKey:@"y"] xDistance:[params objectForKey:@"xDistance"] yDistance:[params objectForKey:@"yDistance"] xOverscroll:[params objectForKey:@"xOverscroll"] yOverscroll:[params objectForKey:@"yOverscroll"] preventFling:[params objectForKey:@"preventFling"] speed:[params objectForKey:@"speed"] gestureSourceType:[params objectForKey:@"gestureSourceType"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"synthesizeTapGesture"] && [self.delegate respondsToSelector:@selector(domain:synthesizeTapGestureWithX:y:duration:tapCount:gestureSourceType:callback:)]) {
        [self.delegate domain:self synthesizeTapGestureWithX:[params objectForKey:@"x"] y:[params objectForKey:@"y"] duration:[params objectForKey:@"duration"] tapCount:[params objectForKey:@"tapCount"] gestureSourceType:[params objectForKey:@"gestureSourceType"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDInputDomain)

- (PDInputDomain *)inputDomain;
{
    return [self domainForName:@"Input"];
}

@end
