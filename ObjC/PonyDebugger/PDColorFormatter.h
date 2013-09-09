//
//  PDColorFormatter.h
//  PonyDebugger
//
//  Created by Ryan Olson on 9/8/13.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PDColorFormatterStyle) {
    PDColorFormatterStyleARGBHex = 0
};

@interface PDColorFormatter : NSFormatter

@property (nonatomic, assign) PDColorFormatterStyle style;

@end
