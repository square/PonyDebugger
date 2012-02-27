//
//  PDObject.m
//  PonyExpress
//
//  Created by Mike Lewis on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PDObject.h"
#import <objc/runtime.h>

NSString *const PDDebuggerErrorDomain = @"org.lolrus.PDDebuggerDomain";
const NSInteger PDDebuggerRequiredAttributeMissingCode = 1001;

@implementation NSObject (PD_JSONObject)

- (id)PD_JSONObject;
{
    return self;
}

- (id)PD_JSONObjectCopy;
{
    return [[self PD_JSONObject] copy];
}

@end

@implementation PDObject {
    NSMutableDictionary *_store;
}

@synthesize store = _store;

+ (NSDictionary *)keysToEncode;
{
    return [[NSDictionary alloc] init];
}

- (id)init;
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _store = [[NSMutableDictionary alloc] init];

    return self;
}

- (id)initWithStore:(NSDictionary *)store;
{
    self = [super init];
    if (!self) {
        return nil;
    }

    assert(store);
    _store = [store mutableCopy];

    return self;
}

- (BOOL)validate:(NSError **)error;
{
    return YES;
}

- (id)copyWithZone:(NSZone *)zone;
{
    return [[[self class] alloc] initWithStore:_store];
}

- (id)valueForKey:(NSString *)key;
{
	return [_store valueForKey:[[[self class] keysToEncode] objectForKey:key]];
}

- (void)setValue:(id)value forKey:(NSString *)key;
{
    [_store setValue:value forKey:[[[self class] keysToEncode] objectForKey:key]];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel;
{
    NSString *selName = NSStringFromSelector(sel);
    if ([selName hasPrefix:@"set"] && selName.length > 4) {
        NSString *propertyName = [NSString stringWithFormat:@"%@%@", [[selName substringWithRange:NSMakeRange(3, 1)] lowercaseString],
                                  [selName substringWithRange:NSMakeRange(4, selName.length - 5)]];
                                 
#ifdef __IPHONE_6_0 
        class_addMethod([self class], sel, imp_implementationWithBlock((id)(^(id slf, id value) {
#else
        class_addMethod([self class], sel, imp_implementationWithBlock((__bridge void *)(^(id slf, id value) {
#endif
            [slf setValue:value forKey:propertyName];
        })), "v@:@");
        
        return YES;
    } else if (![selName hasPrefix:@"_"] && [selName rangeOfString:@":"].length == 0) {
#ifdef __IPHONE_6_0
        class_addMethod([self class], sel, imp_implementationWithBlock((id)^id(id slf) {
#else
        class_addMethod([self class], sel, imp_implementationWithBlock((__bridge void *)^id(id slf) {
#endif
            id val = [slf valueForKey:selName];
            return val;
        }), "@@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

- PD_JSONObject;
{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithCapacity:_store.count];
    [_store enumerateKeysAndObjectsWithOptions:0 usingBlock:^(id key, id obj, BOOL *stop) {
        [ret setObject:[obj PD_JSONObject] forKey:key];
    }];
    return ret;
}

@end
