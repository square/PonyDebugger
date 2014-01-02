//
//  PDGenericObjectFormatter.m
//  PonyDebugger
//
//  Created by Ryan Olson on 9/8/13.
//
//

#import "PDGenericObjectFormatter.h"

@implementation PDGenericObjectFormatter

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error
{
    // Editing not supported
    return NO;
}

- (NSString *)stringForObjectValue:(id)obj
{
    return [obj description];
}

@end
