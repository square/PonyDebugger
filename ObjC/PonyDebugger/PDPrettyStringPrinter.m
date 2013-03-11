//
//  PDPrettyStringPrinter.m
//  PonyDebugger
//
//  Created by Dave Apgar on 2/28/13.
//
//

#import "PDPrettyStringPrinter.h"
#import "NSData+PDB64Additions.h"

@implementation PDTextPrettyStringPrinter

// Handle any non-binary, but don't make it pretty
- (BOOL)canPrettyStringPrintContentType:(NSString *)contentType
{
    return
    ([contentType rangeOfString:@"json"].location != NSNotFound)
    || ([contentType rangeOfString:@"text"].location != NSNotFound)
    || ([contentType rangeOfString:@"xml"].location != NSNotFound);
}

- (BOOL)canPrettyStringPrintRequest:(NSURLRequest *)request
{
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    return [self canPrettyStringPrintContentType:contentType];
}

- (BOOL)canPrettyStringPrintResponse:(NSURLResponse *)response withRequest:(NSURLRequest *)request
{
    return [self canPrettyStringPrintContentType:response.MIMEType];
}

- (NSString*)prettyStringForData:(NSData *)data
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)prettyStringForData:(NSData *)data forRequest:(NSURLRequest *)request
{
    return [self prettyStringForData:data];
}

- (NSString *)prettyStringForData:(NSData *)data forResponse:(NSURLResponse *)response request:(NSURLRequest *)request
{
    return [self prettyStringForData:data];
}

@end