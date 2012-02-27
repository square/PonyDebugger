#import "PDConsoleTypes.h"

@implementation PDConsoleConsoleMessage

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"source",@"source",
                    @"level",@"level",
                    @"text",@"text",
                    @"type",@"type",
                    @"url",@"url",
                    @"line",@"line",
                    @"repeatCount",@"repeatCount",
                    @"parameters",@"parameters",
                    @"stackTrace",@"stackTrace",
                    @"networkRequestId",@"networkRequestId",
                    nil];
    });

    return mappings;
}

@dynamic source;
@dynamic level;
@dynamic text;
@dynamic type;
@dynamic url;
@dynamic line;
@dynamic repeatCount;
@dynamic parameters;
@dynamic stackTrace;
@dynamic networkRequestId;
 
@end

@implementation PDConsoleCallFrame

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"functionName",@"functionName",
                    @"url",@"url",
                    @"lineNumber",@"lineNumber",
                    @"columnNumber",@"columnNumber",
                    nil];
    });

    return mappings;
}

@dynamic functionName;
@dynamic url;
@dynamic lineNumber;
@dynamic columnNumber;
 
@end

