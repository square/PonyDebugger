//
//  PDColorFormatter.m
//  PonyDebugger
//
//  Created by Ryan Olson on 9/8/13.
//
//

#import "PDColorFormatter.h"
#import <UIKit/UIKit.h>

@implementation PDColorFormatter

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error
{
    BOOL success = NO;
    switch (self.style) {
        case PDColorFormatterStyleARGBHex:
            *obj = [self colorWithArgbHexString:string];
            success = YES;
            break;
            
        default:
            break;
    }
    return success;
}

- (NSString *)stringForObjectValue:(id)obj
{
    NSString *string = nil;
    if ([obj isKindOfClass:[UIColor class]]) {
        switch (self.style) {
            case PDColorFormatterStyleARGBHex:
                string = [self argbHexStringForColor:obj];
                break;
                
            default:
                break;
        }
    }
    return string;
}

- (UIColor *)colorWithArgbHexString:(NSString *)argbHexString;
{
    NSString *numberString = [argbHexString stringByTrimmingCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"] invertedSet]];
    NSString *const hexPrefix = @"0x";
    numberString = [hexPrefix stringByAppendingString:numberString];
    NSScanner *scanner = [NSScanner scannerWithString:numberString];
    
    unsigned int intNumber = 0;
    [scanner scanHexInt:&intNumber];
    CGFloat alpha = ((intNumber >> 24) & 0xFF) / (float)0xFF;
    CGFloat red = ((intNumber >> 16) & 0xFF) / (float)0xFF;
    CGFloat green = ((intNumber >> 8) & 0xFF) / (float)0xFF;
    CGFloat blue = (intNumber & 0xFF) / (float)0xFF;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString *)argbHexStringForColor:(UIColor *)color;
{
    CGFloat red, green, blue, alpha, white;
    NSString *colorString = nil;
    if ([color getRed:&red green:&green blue:&blue alpha:&alpha]) {
        unsigned int colorInt = (((int)roundf(alpha * 0xFF)) << 24) | (((int)roundf(red * 0xFF)) << 16) | (((int)roundf(green * 0xFF)) << 8) | (((int)roundf(blue * 0xFF)));
        colorString = [NSString stringWithFormat:@"#%08X", colorInt];
    } else if ([color getWhite:&white alpha:&alpha]) {
        unsigned int colorInt = (((int)roundf(alpha * 0xFF)) << 24) | (((int)roundf(white * 0xFF)) << 16) | (((int)roundf(white * 0xFF)) << 8) | (((int)roundf(white * 0xFF)));
        colorString = [NSString stringWithFormat:@"#%08X", colorInt];
    }
    
    return colorString;
}

@end
