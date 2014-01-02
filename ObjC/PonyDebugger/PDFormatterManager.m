//
//  PDFormatterManager.m
//  PonyDebugger
//
//  Created by Ryan Olson on 9/8/13.
//
//

#import "PDFormatterManager.h"
#import <UIKit/UIKit.h>
#import "PDGenericObjectFormatter.h"
#import "PDStringFormatter.h"
#import "PDColorFormatter.h"
#import "PDFontFormatter.h"

@interface PDFormatterManager ()

@property (nonatomic, strong) NSDictionary *ponyFormatters;

@end

@implementation PDFormatterManager

+ (instancetype)defaultInstance;
{
    static PDFormatterManager *formatterManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatterManager = [[PDFormatterManager alloc] init];
        
        // Register the default formatters
        PDGenericObjectFormatter *genericFormatter = [[PDGenericObjectFormatter alloc] init];
        [formatterManager registerPonyFormatter:genericFormatter forObjectsOfKind:[NSObject class]];
        
        PDStringFormatter *stringFormatter = [[PDStringFormatter alloc] init];
        [formatterManager registerPonyFormatter:stringFormatter forObjectsOfKind:[NSString class]];
        
        PDColorFormatter *colorFormatter = [[PDColorFormatter alloc] init];
        colorFormatter.style = PDColorFormatterStyleARGBHex;
        [formatterManager registerPonyFormatter:colorFormatter forObjectsOfKind:[UIColor class]];
        
        PDFontFormatter *fontFormatter = [[PDFontFormatter alloc] init];
        [formatterManager registerPonyFormatter:fontFormatter forObjectsOfKind:[UIFont class]];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [formatterManager registerPonyFormatter:numberFormatter forObjectsOfKind:[NSNumber class]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [formatterManager registerPonyFormatter:dateFormatter forObjectsOfKind:[NSDate class]];
    });
    return formatterManager;
}

- (void)registerPonyFormatter:(NSFormatter *)formatter forObjectsOfKind:(Class)aClass;
{
    NSMutableDictionary *newFormatters = nil;
    if (self.ponyFormatters) {
       newFormatters = [self.ponyFormatters mutableCopy];
    } else {
        newFormatters = [NSMutableDictionary dictionary];
    }
    [newFormatters setObject:formatter forKey:(id <NSCopying>)aClass];
    self.ponyFormatters = [NSDictionary dictionaryWithDictionary:newFormatters];
}

- (NSFormatter *)formatterForClass:(Class)aClass;
{
    Class currentClass = aClass;
    NSFormatter *foundFormatter = nil;
    
    // Move up the class tree until we find a suitable formatter or hit the top of the tree
    while (!foundFormatter && currentClass) {
        foundFormatter = [self.ponyFormatters objectForKey:currentClass];
        currentClass = [currentClass superclass];
    }
    
    return foundFormatter;
}

@end
