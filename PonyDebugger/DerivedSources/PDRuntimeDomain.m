#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDRuntimeDomain.h>
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDRuntimeTypes.h>


@interface PDRuntimeDomain ()
//Commands

@end

@implementation PDRuntimeDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Runtime";
}




- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"evaluate"] && [self.delegate respondsToSelector:@selector(domain:evaluateWithExpression:objectGroup:includeCommandLineAPI:doNotPauseOnExceptions:frameId:returnByValue:callback:)]) {
        [self.delegate domain:self evaluateWithExpression:[params objectForKey:@"expression"] objectGroup:[params objectForKey:@"objectGroup"] includeCommandLineAPI:[params objectForKey:@"includeCommandLineAPI"] doNotPauseOnExceptions:[params objectForKey:@"doNotPauseOnExceptions"] frameId:[params objectForKey:@"frameId"] returnByValue:[params objectForKey:@"returnByValue"] callback:^(PDRuntimeRemoteObject *result, NSNumber *wasThrown, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (result != nil) {
                [params setObject:result forKey:@"result"];
            }
            if (wasThrown != nil) {
                [params setObject:wasThrown forKey:@"wasThrown"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"callFunctionOn"] && [self.delegate respondsToSelector:@selector(domain:callFunctionOnWithObjectId:functionDeclaration:arguments:returnByValue:callback:)]) {
        [self.delegate domain:self callFunctionOnWithObjectId:[params objectForKey:@"objectId"] functionDeclaration:[params objectForKey:@"functionDeclaration"] arguments:[params objectForKey:@"arguments"] returnByValue:[params objectForKey:@"returnByValue"] callback:^(PDRuntimeRemoteObject *result, NSNumber *wasThrown, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (result != nil) {
                [params setObject:result forKey:@"result"];
            }
            if (wasThrown != nil) {
                [params setObject:wasThrown forKey:@"wasThrown"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"getProperties"] && [self.delegate respondsToSelector:@selector(domain:getPropertiesWithObjectId:ownProperties:callback:)]) {
        [self.delegate domain:self getPropertiesWithObjectId:[params objectForKey:@"objectId"] ownProperties:[params objectForKey:@"ownProperties"] callback:^(NSArray *result, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (result != nil) {
                [params setObject:result forKey:@"result"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"releaseObject"] && [self.delegate respondsToSelector:@selector(domain:releaseObjectWithObjectId:callback:)]) {
        [self.delegate domain:self releaseObjectWithObjectId:[params objectForKey:@"objectId"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"releaseObjectGroup"] && [self.delegate respondsToSelector:@selector(domain:releaseObjectGroupWithObjectGroup:callback:)]) {
        [self.delegate domain:self releaseObjectGroupWithObjectGroup:[params objectForKey:@"objectGroup"] callback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"run"] && [self.delegate respondsToSelector:@selector(domain:runWithCallback:)]) {
        [self.delegate domain:self runWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation PDDebugger (PDRuntimeDomain)

- (PDRuntimeDomain *)runtimeDomain;
{
    return [self domainForName:@"Runtime"];
}

@end
