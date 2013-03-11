//
//  PDPrettyStringPrinter.h
//  PonyDebugger
//
//  Created by Dave Apgar on 2/28/13.
//
//


#import <Foundation/Foundation.h>

@protocol PDPrettyStringPrinting <NSObject>

- (BOOL)canPrettyStringPrintRequest:(NSURLRequest *)request;
- (BOOL)canPrettyStringPrintResponse:(NSURLResponse *)response withRequest:(NSURLRequest *)request;

- (NSString *)prettyStringForData:(NSData *)data forRequest:(NSURLRequest *)request;
- (NSString *)prettyStringForData:(NSData *)data forResponse:(NSURLResponse *)response request:(NSURLRequest *)request;
@end

@interface PDTextPrettyStringPrinter : NSObject <PDPrettyStringPrinting>

@end