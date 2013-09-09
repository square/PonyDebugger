//
//  PDFormatterManager.h
//  PonyDebugger
//
//  Created by Ryan Olson on 9/8/13.
//
//

#import <Foundation/Foundation.h>

@interface PDFormatterManager : NSObject

+ (instancetype)defaultInstance;

- (void)registerPonyFormatter:(NSFormatter *)formatter forObjectsOfKind:(Class)aClass;

// Walks up the class tree (starting with aClass) until it finds a registered formatter
- (NSFormatter *)formatterForClass:(Class)aClass;

@end
