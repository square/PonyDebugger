//
//  PDFontFormatter.m
//  PonyDebugger
//
//  Created by Ryan Olson on 9/8/13.
//
//

#import "PDFontFormatter.h"
#import <UIKit/UIKit.h>

static NSString *const kPDFontFormatterParsingRegex = @"(\\S+)\\s+([0-9\\.]+)\\s*pt";
static NSString *const kPDFontFormatterPrintingFormat = @"%@ %gpt"; // Font name, point size
static const NSUInteger kPDFontFormatterNumberOfComponents = 2;

@implementation PDFontFormatter

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error
{
    BOOL success = NO;
    
    // Try to parse out the font name and point size
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kPDFontFormatterParsingRegex options:0 error:NULL];
    NSTextCheckingResult *firstMatch = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (firstMatch && [firstMatch numberOfRanges] == kPDFontFormatterNumberOfComponents + 1) {
        
        NSString *fontName = [string substringWithRange:[firstMatch rangeAtIndex:1]];
        NSString *pointSizeString = [string substringWithRange:[firstMatch rangeAtIndex:2]];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        CGFloat pointSize = [[numberFormatter numberFromString:pointSizeString] floatValue];
        
        UIFont *font = [UIFont fontWithName:fontName size:pointSize];
        if (font) {
            *obj = font;
            success = YES;
        }
    }
    
    return success;
}

- (NSString *)stringForObjectValue:(id)obj
{
    NSString *string = nil;
    if ([obj isKindOfClass:[UIFont class]]) {
        UIFont *font = obj;
        string = [NSString stringWithFormat:kPDFontFormatterPrintingFormat, font.fontName, font.pointSize];
    }
    return string;
}

@end
