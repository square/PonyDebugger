//
//  PDStringFormatter.m
//  PonyDebugger
//
//  Created by Ryan Olson on 9/8/13.
//
//

#import "PDStringFormatter.h"

@implementation PDStringFormatter

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error
{
    *obj = [string copy];
    return YES;
}

- (NSString *)stringForObjectValue:(id)obj
{
    NSString *string = nil;
    if ([obj isKindOfClass:[NSString class]]) {
        string = [obj copy];
    }
    return string;
}

@end
