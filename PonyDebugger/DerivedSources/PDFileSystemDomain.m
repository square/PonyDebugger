#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDFileSystemDomain.h>
#import <PonyDebugger/PDObject.h>


@interface PDFileSystemDomain ()
//Commands

@end

@implementation PDFileSystemDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"FileSystem";
}




- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"enable"] && [self.delegate respondsToSelector:@selector(domain:enableWithCallback:)]) {
        [self.delegate domain:self enableWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"disable"] && [self.delegate respondsToSelector:@selector(domain:disableWithCallback:)]) {
        [self.delegate domain:self disableWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDFileSystemDomain)

- (PDFileSystemDomain *)fileSystemDomain;
{
    return [self domainForName:@"FileSystem"];
}

@end
