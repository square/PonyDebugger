//
//  PDAFNetworkDomainController.m
//  PonyDebugger
//
//  Created by Mike Lewis on 2/27/12.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDNetworkDomainController.h"
#import "PDPrettyStringPrinter.h"
#import "NSDate+PDDebugger.h"
#import "NSData+PDDebugger.h"

#import <objc/runtime.h>
#import <objc/message.h>
#import <dispatch/queue.h>


@interface _PDRequestState : NSObject

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *dataAccumulator;
@property (nonatomic, copy) NSString *requestID;

@end


@interface PDNetworkDomainController ()

- (void)setResponse:(NSData *)responseBody forRequestID:(NSString *)requestID response:(NSURLResponse *)response request:(NSURLRequest *)request;
- (void)performBlock:(dispatch_block_t)block;

@end


@implementation PDNetworkDomainController {
    NSCache *_responseCache;
    NSMutableDictionary *_connectionStates;
    dispatch_queue_t _queue;
}

@dynamic domain;

#pragma mark - Statics

+ (PDNetworkDomainController *)defaultInstance;
{
    static PDNetworkDomainController *defaultInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultInstance = [[PDNetworkDomainController alloc] init];
    });
    return defaultInstance;
}

+ (NSString *)nextRequestID;
{
    static NSInteger sequenceNumber = 0;
    static NSString *seed = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CFUUIDRef uuid = CFUUIDCreate(CFAllocatorGetDefault());
        seed = (__bridge NSString *)CFUUIDCreateString(CFAllocatorGetDefault(), uuid);
        CFRelease(uuid);
    });
    
    return [[NSString alloc] initWithFormat:@"%@-%ld", seed, (long)(++sequenceNumber)];
}

+ (Class)domainClass;
{
    return [PDNetworkDomain class];
}

#pragma mark Pretty String Printing registration and usage

// This is replaced atomically to avoid having to lock when looking up the printers instead of being mutable.
static NSArray *prettyStringPrinters = nil;

+ (NSArray*)_currentPrettyStringPrinters;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Always register the default to differentiate text vs binary data
        id<PDPrettyStringPrinting> textPrettyStringPrinter = [[PDTextPrettyStringPrinter alloc] init];
        prettyStringPrinters = [[NSArray alloc] initWithObjects:textPrettyStringPrinter, nil];
    });
    return prettyStringPrinters;
}

+ (void)registerPrettyStringPrinter:(id<PDPrettyStringPrinting>)prettyStringPrinter;
{
    @synchronized(prettyStringPrinters) {
        NSMutableArray *newPrinters = [[PDNetworkDomainController _currentPrettyStringPrinters] mutableCopy];
        [newPrinters addObject:prettyStringPrinter];
        prettyStringPrinters = newPrinters;
    }
}

+ (void)unregisterPrettyStringPrinter:(id<PDPrettyStringPrinting>)prettyStringPrinter;
{
    @synchronized(prettyStringPrinters) {
        NSMutableArray *newPrinters = [[PDNetworkDomainController _currentPrettyStringPrinters] mutableCopy];
        [newPrinters removeObjectIdenticalTo:prettyStringPrinter];
        prettyStringPrinters = newPrinters;
    }
}

+ (id<PDPrettyStringPrinting>)prettyStringPrinterForRequest:(NSURLRequest *)request;
{
    for(id<PDPrettyStringPrinting> prettyStringPrinter in [[PDNetworkDomainController _currentPrettyStringPrinters] reverseObjectEnumerator]) {
        if ([prettyStringPrinter canPrettyStringPrintRequest:request]) {
            return prettyStringPrinter;
        }
    }
    return nil;
}

+ (id<PDPrettyStringPrinting>)prettyStringPrinterForResponse:(NSURLResponse *)response withRequest:(NSURLRequest *)request;
{
    for(id<PDPrettyStringPrinting> prettyStringPrinter in [[PDNetworkDomainController _currentPrettyStringPrinters] reverseObjectEnumerator]) {
        if ([prettyStringPrinter canPrettyStringPrintResponse:response withRequest:request]) {
            return prettyStringPrinter;
        }
    }
    return nil;
}

#pragma mark Delegate Injection Convenience Methods

+ (SEL)swizzledSelectorForSelector:(SEL)selector;
{
    return NSSelectorFromString([NSString stringWithFormat:@"_pd_swizzle_%x_%@", arc4random(), NSStringFromSelector(selector)]);
}

/// All swizzled delegate methods should make use of this guard.
/// This will prevent duplicated sniffing when the original implementation calls up to a superclass implementation which we've also swizzled.
/// The superclass implementation (and implementations in classes above that) will be executed without inteference if called from the original implementation.
+ (void)sniffWithoutDuplicationForObject:(NSObject *)object selector:(SEL)selector sniffingBlock:(void (^)(void))sniffingBlock originalImplementationBlock:(void (^)(void))originalImplementationBlock
{
    const void *key = selector;

    // Don't run the sniffing block if we're inside a nested call
    if (!objc_getAssociatedObject(object, key)) {
        sniffingBlock();
    }

    // Mark that we're calling through to the original so we can detect nested calls
    objc_setAssociatedObject(object, key, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    originalImplementationBlock();
    objc_setAssociatedObject(object, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)instanceRespondsButDoesNotImplementSelector:(SEL)selector class:(Class)cls;
{
    if ([cls instancesRespondToSelector:selector]) {
        unsigned int numMethods = 0;
        Method *methods = class_copyMethodList(cls, &numMethods);
        
        BOOL implementsSelector = NO;
        for (int index = 0; index < numMethods; index++) {
            SEL methodSelector = method_getName(methods[index]);
            if (selector == methodSelector) {
                implementsSelector = YES;
                break;
            }
        }
        
        free(methods);
        
        if (!implementsSelector) {
            return YES;
        }
    }
    
    return NO;
}

+ (void)replaceImplementationOfSelector:(SEL)selector withSelector:(SEL)swizzledSelector forClass:(Class)cls withMethodDescription:(struct objc_method_description)methodDescription implementationBlock:(id)implementationBlock undefinedBlock:(id)undefinedBlock;
{
    if ([self instanceRespondsButDoesNotImplementSelector:selector class:cls]) {
        return;
    }

#ifdef __IPHONE_6_0
    IMP implementation = imp_implementationWithBlock((id)([cls instancesRespondToSelector:selector] ? implementationBlock : undefinedBlock));
#else
    IMP implementation = imp_implementationWithBlock((__bridge void *)([cls instancesRespondToSelector:selector] ? implementationBlock : undefinedBlock));
#endif
    
    Method oldMethod = class_getInstanceMethod(cls, selector);
    if (oldMethod) {
        class_addMethod(cls, swizzledSelector, implementation, methodDescription.types);
         
        Method newMethod = class_getInstanceMethod(cls, swizzledSelector);
        
        method_exchangeImplementations(oldMethod, newMethod);
    } else {
        class_addMethod(cls, selector, implementation, methodDescription.types);
    }
}

#pragma mark - Delegate Injection

+ (void)injectIntoAllNSURLConnectionDelegateClasses;
{
    // Only allow swizzling once.
    static BOOL swizzled = NO;
    if (swizzled) {
        return;
    }
    
    swizzled = YES;

    // Swizzle any classes that implement one of these selectors.
    const SEL selectors[] = {
        @selector(connectionDidFinishLoading:),
        @selector(connection:didReceiveResponse:),
        @selector(URLSession:dataTask:didReceiveResponse:completionHandler:),
        @selector(URLSession:task:didCompleteWithError:),
        @selector(URLSession:downloadTask:didFinishDownloadingToURL:)
    };
    
    const int numSelectors = sizeof(selectors) / sizeof(SEL);

    Class *classes = NULL;
    int numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0) {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (NSInteger classIndex = 0; classIndex < numClasses; ++classIndex) {
            Class class = classes[classIndex];
            
            if (class_getClassMethod(class, @selector(isSubclassOfClass:)) == NULL) {
                continue;
            }
            
            if (![class isSubclassOfClass:[NSObject class]]) {
                continue;
            }
            
            if ([class isSubclassOfClass:[PDNetworkDomainController class]]) {
                continue;
            }
            
            for (int selectorIndex = 0; selectorIndex < numSelectors; ++selectorIndex) {
                if ([class instancesRespondToSelector:selectors[selectorIndex]]) {
                    [self injectIntoDelegateClass:class];
                    break;
                }
            }
        }
        
        free(classes);
    }
}

+ (void)injectIntoDelegateClass:(Class)cls;
{
    // Connections
    [self injectWillSendRequestIntoDelegateClass:cls];
    [self injectDidReceiveDataIntoDelegateClass:cls];
    [self injectDidReceiveResponseIntoDelegateClass:cls];
    [self injectDidFinishLoadingIntoDelegateClass:cls];
    [self injectDidFailWithErrorIntoDelegateClass:cls];
    
    // Sessions
    [self injectTaskWillPerformHTTPRedirectionIntoDelegateClass:cls];
    [self injectTaskDidReceiveDataIntoDelegateClass:cls];
    [self injectTaskDidReceiveResponseIntoDelegateClass:cls];
    [self injectTaskDidCompleteWithErrorIntoDelegateClass:cls];
    [self injectRespondsToSelectorIntoDelegateClass:cls];

    // Download tasks
    [self injectDownloadTaskDidWriteDataIntoDelegateClass:cls];
    [self injectDownloadTaskDidFinishDownloadingIntoDelegateClass:cls];
}

+ (void)injectWillSendRequestIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(connection:willSendRequest:redirectResponse:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDataDelegate);
    if (!protocol) {
        protocol = @protocol(NSURLConnectionDelegate);
    }
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef NSURLRequest *(^NSURLConnectionWillSendRequestBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLRequest *request, NSURLResponse *response);
    
    NSURLConnectionWillSendRequestBlock undefinedBlock = ^NSURLRequest *(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLRequest *request, NSURLResponse *response) {
        [[PDNetworkDomainController defaultInstance] connection:connection willSendRequest:request redirectResponse:response];
        return request;
    };
    
    NSURLConnectionWillSendRequestBlock implementationBlock = ^NSURLRequest *(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLRequest *request, NSURLResponse *response) {
        __block NSURLRequest *returnValue = nil;
        [self sniffWithoutDuplicationForObject:connection selector:selector sniffingBlock:^{
            undefinedBlock(slf, connection, request, response);
        } originalImplementationBlock:^{
            returnValue = ((id(*)(id, SEL, id, id, id))objc_msgSend)(slf, swizzledSelector, connection, request, response);
        }];
        return returnValue;
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectDidReceiveResponseIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(connection:didReceiveResponse:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDataDelegate);
    if (!protocol) {
        protocol = @protocol(NSURLConnectionDelegate);
    }
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLConnectionDidReceiveResponseBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLResponse *response);
    
    NSURLConnectionDidReceiveResponseBlock undefinedBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLResponse *response) {
        [[PDNetworkDomainController defaultInstance] connection:connection didReceiveResponse:response];
    };
    
    NSURLConnectionDidReceiveResponseBlock implementationBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLResponse *response) {
        [self sniffWithoutDuplicationForObject:connection selector:selector sniffingBlock:^{
            undefinedBlock(slf, connection, response);
        } originalImplementationBlock:^{
            ((void(*)(id, SEL, id, id))objc_msgSend)(slf, swizzledSelector, connection, response);
        }];
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectDidReceiveDataIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(connection:didReceiveData:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDataDelegate);
    if (!protocol) {
        protocol = @protocol(NSURLConnectionDelegate);
    }
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLConnectionDidReceiveDataBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSData *data);
    
    NSURLConnectionDidReceiveDataBlock undefinedBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSData *data) {
        [[PDNetworkDomainController defaultInstance] connection:connection didReceiveData:data];
    };
    
    NSURLConnectionDidReceiveDataBlock implementationBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSData *data) {
        [self sniffWithoutDuplicationForObject:connection selector:selector sniffingBlock:^{
            undefinedBlock(slf, connection, data);
        } originalImplementationBlock:^{
            ((void(*)(id, SEL, id, id))objc_msgSend)(slf, swizzledSelector, connection, data);
        }];
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectDidFinishLoadingIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(connectionDidFinishLoading:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDataDelegate);
    if (!protocol) {
        protocol = @protocol(NSURLConnectionDelegate);
    }
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLConnectionDidFinishLoadingBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection);
    
    NSURLConnectionDidFinishLoadingBlock undefinedBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection) {
        [[PDNetworkDomainController defaultInstance] connectionDidFinishLoading:connection];
    };
    
    NSURLConnectionDidFinishLoadingBlock implementationBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection) {
        [self sniffWithoutDuplicationForObject:connection selector:selector sniffingBlock:^{
            undefinedBlock(slf, connection);
        } originalImplementationBlock:^{
            ((void(*)(id, SEL, id))objc_msgSend)(slf, swizzledSelector, connection);
        }];
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectDidFailWithErrorIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(connection:didFailWithError:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDelegate);
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLConnectionDidFailWithErrorBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSError *error);
    
    NSURLConnectionDidFailWithErrorBlock undefinedBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSError *error) {
        [[PDNetworkDomainController defaultInstance] connection:connection didFailWithError:error];
    };
    
    NSURLConnectionDidFailWithErrorBlock implementationBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSError *error) {
        [self sniffWithoutDuplicationForObject:connection selector:selector sniffingBlock:^{
            undefinedBlock(slf, connection, error);
        } originalImplementationBlock:^{
            ((void(*)(id, SEL, id, id))objc_msgSend)(slf, swizzledSelector, connection, error);
        }];
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectTaskWillPerformHTTPRedirectionIntoDelegateClass:(Class)cls
{
    SEL selector = @selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];

    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);

    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLSessionWillPerformHTTPRedirectionBlock)(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionTask *task, NSHTTPURLResponse *response, NSURLRequest *newRequest, void(^completionHandler)(NSURLRequest *));
    
    NSURLSessionWillPerformHTTPRedirectionBlock undefinedBlock = ^(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionTask *task, NSHTTPURLResponse *response, NSURLRequest *newRequest, void(^completionHandler)(NSURLRequest *)) {
        [[PDNetworkDomainController defaultInstance] URLSession:session task:task willPerformHTTPRedirection:response newRequest:newRequest completionHandler:completionHandler];
    };

    NSURLSessionWillPerformHTTPRedirectionBlock implementationBlock = ^(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionTask *task, NSHTTPURLResponse *response, NSURLRequest *newRequest, void(^completionHandler)(NSURLRequest *)) {
        [self sniffWithoutDuplicationForObject:session selector:selector sniffingBlock:^{
            undefinedBlock(slf, session, task, response, newRequest, completionHandler);
        } originalImplementationBlock:^{
            ((id(*)(id, SEL, id, id, id, id, void(^)()))objc_msgSend)(slf, swizzledSelector, session, task, response, newRequest, completionHandler);
        }];
    };

    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];

}

+ (void)injectTaskDidReceiveDataIntoDelegateClass:(Class)cls
{
    SEL selector = @selector(URLSession:dataTask:didReceiveData:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLSessionDataDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLSessionDidReceiveDataBlock)(id <NSURLSessionDataDelegate> slf, NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data);
    
    NSURLSessionDidReceiveDataBlock undefinedBlock = ^(id <NSURLSessionDataDelegate> slf, NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data) {
        [[PDNetworkDomainController defaultInstance] URLSession:session dataTask:dataTask didReceiveData:data];
    };
    
    NSURLSessionDidReceiveDataBlock implementationBlock = ^(id <NSURLSessionDataDelegate> slf, NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data) {
        [self sniffWithoutDuplicationForObject:session selector:selector sniffingBlock:^{
            undefinedBlock(slf, session, dataTask, data);
        } originalImplementationBlock:^{
            ((void(*)(id, SEL, id, id, id))objc_msgSend)(slf, swizzledSelector, session, dataTask, data);
        }];
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];

}

+ (void)injectTaskDidReceiveResponseIntoDelegateClass:(Class)cls
{
    SEL selector = @selector(URLSession:dataTask:didReceiveResponse:completionHandler:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLSessionDataDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLSessionDidReceiveResponseBlock)(id <NSURLConnectionDataDelegate> slf, NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response, void(^completionHandler)(NSURLSessionResponseDisposition disposition));
    
    NSURLSessionDidReceiveResponseBlock undefinedBlock = ^(id <NSURLConnectionDataDelegate> slf, NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response, void(^completionHandler)(NSURLSessionResponseDisposition disposition)) {
        [[PDNetworkDomainController defaultInstance] URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
    };
    
    NSURLSessionDidReceiveResponseBlock implementationBlock = ^(id <NSURLConnectionDataDelegate> slf, NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response, void(^completionHandler)(NSURLSessionResponseDisposition disposition)) {
        [self sniffWithoutDuplicationForObject:session selector:selector sniffingBlock:^{
            undefinedBlock(slf, session, dataTask, response, completionHandler);
        } originalImplementationBlock:^{
            ((void(*)(id, SEL, id, id, id, void(^)()))objc_msgSend)(slf, swizzledSelector, session, dataTask, response, completionHandler);
        }];
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];

}

+ (void)injectTaskDidCompleteWithErrorIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(URLSession:task:didCompleteWithError:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLSessionTaskDidCompleteWithErrorBlock)(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionTask *task, NSError *error);

    NSURLSessionTaskDidCompleteWithErrorBlock undefinedBlock = ^(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionTask *task, NSError *error) {
        [[PDNetworkDomainController defaultInstance] URLSession:session task:task didCompleteWithError:error];
    };

    NSURLSessionTaskDidCompleteWithErrorBlock implementationBlock = ^(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionTask *task, NSError *error) {
        [self sniffWithoutDuplicationForObject:session selector:selector sniffingBlock:^{
            undefinedBlock(slf, session, task, error);
        } originalImplementationBlock:^{
            ((void(*)(id, SEL, id, id, id))objc_msgSend)(slf, swizzledSelector, session, task, error);
        }];
    };

    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

// Used for overriding AFNetworking behavior
+ (void)injectRespondsToSelectorIntoDelegateClass:(Class)cls
{
    SEL selector = @selector(respondsToSelector:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];

    //Protocol *protocol = @protocol(NSURLSessionTaskDelegate);
    Method method = class_getInstanceMethod(cls, selector);
    struct objc_method_description methodDescription = *method_getDescription(method);

    typedef void (^NSURLSessionTaskDidCompleteWithErrorBlock)(id slf, SEL sel);

    BOOL (^undefinedBlock)(id <NSURLSessionTaskDelegate>, SEL) = ^(id slf, SEL sel) {
        return YES;
    };

    BOOL (^implementationBlock)(id <NSURLSessionTaskDelegate>, SEL) = ^(id <NSURLSessionTaskDelegate> slf, SEL sel) {
        if (sel == @selector(URLSession:dataTask:didReceiveResponse:completionHandler:)) {
            return undefinedBlock(slf, sel);
        }
        return ((BOOL(*)(id, SEL, SEL))objc_msgSend)(slf, swizzledSelector, sel);
    };

    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}


+ (void)injectDownloadTaskDidFinishDownloadingIntoDelegateClass:(Class)cls
{
    SEL selector = @selector(URLSession:downloadTask:didFinishDownloadingToURL:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];

    Protocol *protocol = @protocol(NSURLSessionDownloadDelegate);
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);

    typedef void (^NSURLSessionDownloadTaskDidFinishDownloadingBlock)(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionDownloadTask *task, NSURL *location);

    NSURLSessionDownloadTaskDidFinishDownloadingBlock undefinedBlock = ^(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionDownloadTask *task, NSURL *location) {
        NSData *data = [NSData dataWithContentsOfFile:location.relativePath];
        [[PDNetworkDomainController defaultInstance] URLSession:session task:task didFinishDownloadingToURL:location data:data];
    };

    NSURLSessionDownloadTaskDidFinishDownloadingBlock implementationBlock = ^(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionDownloadTask *task, NSURL *location) {
        [self sniffWithoutDuplicationForObject:session selector:selector sniffingBlock:^{
            undefinedBlock(slf, session, task, location);
        } originalImplementationBlock:^{
            ((void(*)(id, SEL, id, id, id))objc_msgSend)(slf, swizzledSelector, session, task, location);
        }];
    };

    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectDownloadTaskDidWriteDataIntoDelegateClass:(Class)cls
{
    SEL selector = @selector(URLSession:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];

    Protocol *protocol = @protocol(NSURLSessionDownloadDelegate);
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);

    typedef void (^NSURLSessionDownloadTaskDidWriteDataBlock)(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionDownloadTask *task, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);

    NSURLSessionDownloadTaskDidWriteDataBlock undefinedBlock = ^(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionDownloadTask *task, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        [[PDNetworkDomainController defaultInstance] URLSession:session downloadTask:task didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    };

    NSURLSessionDownloadTaskDidWriteDataBlock implementationBlock = ^(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionDownloadTask *task, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        [self sniffWithoutDuplicationForObject:session selector:selector sniffingBlock:^{
            undefinedBlock(slf, session, task, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        } originalImplementationBlock:^{
            ((void(*)(id, SEL, id, id, int64_t, int64_t, int64_t))objc_msgSend)(slf, swizzledSelector, session, task, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        }];
    };

    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];

}

#pragma mark - Initialization

- (id)init;
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _connectionStates = [[NSMutableDictionary alloc] init];
    _responseCache = [[NSCache alloc] init];
    _queue = dispatch_queue_create("com.squareup.ponydebugger.PDNetworkDomainController", DISPATCH_QUEUE_SERIAL);
    
    return self;
}

- (void)dealloc;
{
    if (_queue) {
        dispatch_release(_queue);
    }
}

#pragma mark - PDNetworkCommandDelegate

- (void)domain:(PDNetworkDomain *)domain canClearBrowserCacheWithCallback:(void (^)(NSNumber *, id))callback;
{
    callback([NSNumber numberWithBool:NO], nil);
}

- (void)domain:(PDNetworkDomain *)domain canClearBrowserCookiesWithCallback:(void (^)(NSNumber *, id))callback
{
    callback([NSNumber numberWithBool:NO], nil);
}

- (void)domain:(PDNetworkDomain *)domain clearBrowserCacheWithCallback:(void (^)(id))callback;
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    callback(nil);
}

- (void)domain:(PDNetworkDomain *)domain getResponseBodyWithRequestId:(NSString *)requestId callback:(void (^)(NSString *, NSNumber *, id))callback;
{
    NSDictionary *response = [_responseCache objectForKey:requestId];
    callback([response objectForKey:@"body"], [response objectForKey:@"base64Encoded"], nil);
}


#pragma mark - Private Methods

- (void)setResponse:(NSData *)responseBody forRequestID:(NSString *)requestID response:(NSURLResponse *)response request:(NSURLRequest *)request;
{
    id<PDPrettyStringPrinting> prettyStringPrinter = [PDNetworkDomainController prettyStringPrinterForResponse:response withRequest:request];

    NSString *encodedBody;
    BOOL isBinary;
    if (!prettyStringPrinter) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        encodedBody = [responseBody base64EncodedStringWithOptions:0];
#else
        encodedBody = responseBody.base64Encoding;
#endif
        isBinary = YES;
    } else {
        encodedBody = [prettyStringPrinter prettyStringForData:responseBody forResponse:response request:request];
        isBinary = NO;
    }

    NSDictionary *responseDict = [NSDictionary dictionaryWithObjectsAndKeys:
        encodedBody, @"body",
        [NSNumber numberWithBool:isBinary], @"base64Encoded",
        nil];

    [_responseCache setObject:responseDict forKey:requestID cost:[responseBody length]];
}

- (void)performBlock:(dispatch_block_t)block;
{
    dispatch_async(_queue, block);
}

#pragma mark - Private Methods (Connections)

- (_PDRequestState *)requestStateForConnection:(NSURLConnection *)connection;
{
    NSValue *key = [NSValue valueWithNonretainedObject:connection];
    _PDRequestState *state = [_connectionStates objectForKey:key];
    if (!state) {
        state = [[_PDRequestState alloc] init];
        state.requestID = [[self class] nextRequestID];
        [_connectionStates setObject:state forKey:key];
    }

    return state;
}

- (NSString *)requestIDForConnection:(NSURLConnection *)connection;
{
    return [self requestStateForConnection:connection].requestID;
}

- (void)setResponse:(NSURLResponse *)response forConnection:(NSURLConnection *)connection;
{
    [self requestStateForConnection:connection].response = response;
}

- (NSURLResponse *)responseForConnection:(NSURLConnection *)connection;
{
    return [self requestStateForConnection:connection].response;
}

- (void)setRequest:(NSURLRequest *)request forConnection:(NSURLConnection *)connection;
{
    [self requestStateForConnection:connection].request = request;
}

- (NSURLRequest *)requestForConnection:(NSURLConnection *)connection;
{
    return [self requestStateForConnection:connection].request;
}

- (void)setAccumulatedData:(NSMutableData *)data forConnection:(NSURLConnection *)connection;
{
    _PDRequestState *requestState = [self requestStateForConnection:connection];
    requestState.dataAccumulator = data;
}

- (void)addAccumulatedData:(NSData *)data forConnection:(NSURLConnection *)connection;
{
    NSMutableData *dataAccumulator = [self requestStateForConnection:connection].dataAccumulator;
    
    [dataAccumulator appendData:data];
}

- (NSData *)accumulatedDataForConnection:(NSURLConnection *)connection;
{
    return [self requestStateForConnection:connection].dataAccumulator;
}

// This removes storing the accumulated request/response from the dictionary so we can release connection
- (void)connectionFinished:(NSURLConnection *)connection;
{
    NSValue *key = [NSValue valueWithNonretainedObject:connection];
    [_connectionStates removeObjectForKey:key];
}

#pragma mark - Private Methods (Tasks)

- (_PDRequestState *)requestStateForTask:(NSURLSessionTask *)task;
{
    NSValue *key = [NSValue valueWithNonretainedObject:task];
    _PDRequestState *state = [_connectionStates objectForKey:key];
    if (!state) {
        state = [[_PDRequestState alloc] init];
        state.requestID = [[self class] nextRequestID];
        [_connectionStates setObject:state forKey:key];
    }

    return state;
}

- (NSString *)requestIDForTask:(NSURLSessionTask *)task;
{
    return [self requestStateForTask:task].requestID;
}

- (void)setResponse:(NSURLResponse *)response forTask:(NSURLSessionTask *)task;
{
    [self requestStateForTask:task].response = response;
}

- (NSURLResponse *)responseForTask:(NSURLSessionTask *)task
{
    return [self requestStateForTask:task].response;
}

- (void)setRequest:(NSURLRequest *)request forTask:(NSURLSessionTask *)task;
{
    [self requestStateForTask:task].request = request;
}

- (NSURLRequest *)requestForTask:(NSURLSessionTask *)task;
{
    return [self requestStateForTask:task].request;
}

- (void)setAccumulatedData:(NSMutableData *)data forTask:(NSURLSessionTask *)task;
{
    _PDRequestState *requestState = [self requestStateForTask:task];
    requestState.dataAccumulator = data;
}

- (void)addAccumulatedData:(NSData *)data forTask:(NSURLSessionTask *)task;
{
    NSMutableData *dataAccumulator = [self requestStateForTask:task].dataAccumulator;

    [dataAccumulator appendData:data];
}

- (NSData *)accumulatedDataForTask:(NSURLSessionTask *)task;
{
    return [self requestStateForTask:task].dataAccumulator;
}

// This removes storing the accumulated request/response from the dictionary so we can release task
- (void)taskFinished:(NSURLSessionTask *)task;
{
    NSValue *key = [NSValue valueWithNonretainedObject:task];
    [_connectionStates removeObjectForKey:key];
}

@end


@implementation PDNetworkDomainController (NSURLConnectionHelpers)

- (void)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response;
{
    [self performBlock:^{
        [self setRequest:request forConnection:connection];
        PDNetworkRequest *networkRequest = [PDNetworkRequest networkRequestWithURLRequest:request];
        PDNetworkResponse *networkRedirectResponse = response ? [[PDNetworkResponse alloc] initWithURLResponse:response request:request] : nil;
        
        [self.domain requestWillBeSentWithRequestId:[self requestIDForConnection:connection]
                                            frameId:@""
                                           loaderId:@""
                                        documentURL:[request.URL absoluteString]
                                            request:networkRequest
                                          timestamp:[NSDate PD_timestamp]
                                          initiator:nil
                                   redirectResponse:networkRedirectResponse];
    }];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    [self performBlock:^{
        
        if ([response respondsToSelector:@selector(copyWithZone:)]) {
            
            // If the request wasn't generated yet, then willSendRequest was not called. This appears to be an inconsistency in documentation
            // and behavior.
            NSURLRequest *request = [self requestForConnection:connection];
            if (!request && [connection respondsToSelector:@selector(currentRequest)]) {
            
                NSLog(@"PonyDebugger Warning: -[PDNetworkDomainController connection:willSendRequest:redirectResponse:] not called, request timestamp may be inaccurate. See Known Issues in the README for more information.");

                request = connection.currentRequest;
                [self setRequest:request forConnection:connection];

                PDNetworkRequest *networkRequest = [PDNetworkRequest networkRequestWithURLRequest:request];
                [self.domain requestWillBeSentWithRequestId:[self requestIDForConnection:connection]
                                                    frameId:@""
                                                   loaderId:@""
                                                documentURL:[request.URL absoluteString]
                                                    request:networkRequest
                                                  timestamp:[NSDate PD_timestamp]
                                                  initiator:nil
                                           redirectResponse:nil];
            }
        
            [self setResponse:response forConnection:connection];
            
            NSMutableData *dataAccumulator = nil;
            if (response.expectedContentLength < 0) {
                dataAccumulator = [[NSMutableData alloc] init];
            } else {
                dataAccumulator = [[NSMutableData alloc] initWithCapacity:(NSUInteger)response.expectedContentLength];
            }
            
            [self setAccumulatedData:dataAccumulator forConnection:connection];
            
            NSString *requestID = [self requestIDForConnection:connection];
            PDNetworkResponse *networkResponse = [PDNetworkResponse networkResponseWithURLResponse:response request:[self requestForConnection:connection]];
            
            [self.domain responseReceivedWithRequestId:requestID
                                               frameId:@""
                                              loaderId:@""
                                             timestamp:[NSDate PD_timestamp]
                                                  type:response.PD_responseType
                                              response:networkResponse];
        }
        
    }];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    // Just to be safe since we're doing this async
    data = [data copy];
    [self performBlock:^{
        [self addAccumulatedData:data forConnection:connection];

        if ([self accumulatedDataForConnection:connection] == nil) return;
        
        NSNumber *length = [NSNumber numberWithInteger:data.length];
        NSString *requestID = [self requestIDForConnection:connection];
        
        [self.domain dataReceivedWithRequestId:requestID
                                     timestamp:[NSDate PD_timestamp]
                                    dataLength:length
                             encodedDataLength:length];
    }];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    [self performBlock:^{
        NSURLResponse *response = [self responseForConnection:connection];
        NSString *requestID = [self requestIDForConnection:connection];

        NSData *accumulatedData = [self accumulatedDataForConnection:connection];

        [self setResponse:accumulatedData
             forRequestID:requestID
                 response:response
                  request:[self requestForConnection:connection]];
        
        [self.domain loadingFinishedWithRequestId:requestID
                                        timestamp:[NSDate PD_timestamp]];
        
        [self connectionFinished:connection];
    }];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
    [self performBlock:^{
        [self.domain loadingFailedWithRequestId:[self requestIDForConnection:connection]
                                      timestamp:[NSDate PD_timestamp]
                                      errorText:[error localizedDescription]
                                       canceled:[NSNumber numberWithBool:NO]];
        
        [self connectionFinished:connection];
    }];
}

@end


@implementation PDNetworkDomainController (NSURLSessionTaskHelpers)

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    [self performBlock:^{
        [self setRequest:request forTask:task];
        PDNetworkRequest *networkRequest = [PDNetworkRequest networkRequestWithURLRequest:request];
        PDNetworkResponse *networkRedirectResponse = response ? [[PDNetworkResponse alloc] initWithURLResponse:response request:request] : nil;

        [self.domain requestWillBeSentWithRequestId:[self requestIDForTask:task]
                                            frameId:@""
                                           loaderId:@""
                                        documentURL:[request.URL absoluteString]
                                            request:networkRequest
                                          timestamp:[NSDate PD_timestamp]
                                          initiator:nil
                                   redirectResponse:networkRedirectResponse];
    }];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler;
{
    if ([response respondsToSelector:@selector(copyWithZone:)]) {

        // willSendRequest does not exist in NSURLSession. Here's a workaround.
        NSURLRequest *request = [self requestForTask:dataTask];
        if (!request && [dataTask respondsToSelector:@selector(currentRequest)]) {

            static BOOL hasLoggedTimestampWarning = NO;
            if (!hasLoggedTimestampWarning) {
                hasLoggedTimestampWarning = YES;
                NSLog(@"PonyDebugger Warning: Some requests' timestamps may be inaccurate. See Known Issues in the README for more information.");
            }

            request = dataTask.currentRequest;
            [self setRequest:request forTask:dataTask];

            PDNetworkRequest *networkRequest = [PDNetworkRequest networkRequestWithURLRequest:request];
            [self.domain requestWillBeSentWithRequestId:[self requestIDForTask:dataTask]
                                                frameId:@""
                                               loaderId:@""
                                            documentURL:[request.URL absoluteString]
                                                request:networkRequest
                                              timestamp:[NSDate PD_timestamp]
                                              initiator:nil
                                       redirectResponse:nil];
        }

        [self setResponse:response forTask:dataTask];

        NSMutableData *dataAccumulator = nil;
        if (response.expectedContentLength < 0) {
            dataAccumulator = [[NSMutableData alloc] init];
        } else {
            dataAccumulator = [[NSMutableData alloc] initWithCapacity:(NSUInteger)response.expectedContentLength];
        }

        [self setAccumulatedData:dataAccumulator forTask:dataTask];

        NSString *requestID = [self requestIDForTask:dataTask];
        PDNetworkResponse *networkResponse = [PDNetworkResponse networkResponseWithURLResponse:response request:[self requestForTask:dataTask]];

        [self.domain responseReceivedWithRequestId:requestID
                                           frameId:@""
                                          loaderId:@""
                                         timestamp:[NSDate PD_timestamp]
                                              type:response.PD_responseType
                                          response:networkResponse];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // Just to be safe since we're doing this async
    data = [data copy];
    [self performBlock:^{
        [self addAccumulatedData:data forTask:dataTask];

        if ([self accumulatedDataForTask:dataTask] == nil) return;

        NSNumber *length = [NSNumber numberWithInteger:data.length];
        NSString *requestID = [self requestIDForTask:dataTask];

        [self.domain dataReceivedWithRequestId:requestID
                                     timestamp:[NSDate PD_timestamp]
                                    dataLength:length
                             encodedDataLength:length];
    }];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;
{
    [self performBlock:^{
        NSURLResponse *response = [self responseForTask:task];
        NSString *requestID = [self requestIDForTask:task];

        NSData *accumulatedData = [self accumulatedDataForTask:task];

        if (error) {
            [self.domain loadingFailedWithRequestId:[self requestIDForTask:task]
                                          timestamp:[NSDate PD_timestamp]
                                          errorText:[error localizedDescription]
                                           canceled:[NSNumber numberWithBool:NO]];
        } else {
            [self setResponse:accumulatedData
                 forRequestID:requestID
                     response:response
                      request:[self requestForTask:task]];
        }

        [self.domain loadingFinishedWithRequestId:requestID
                                        timestamp:[NSDate PD_timestamp]];

        [self taskFinished:task];
    }];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    [self performBlock:^{
        // If the request wasn't generated yet, then willSendRequest was not called. This appears to be an inconsistency in documentation
        // and behavior.
        NSURLRequest *request = [self requestForTask:downloadTask];
        if (!request && [downloadTask respondsToSelector:@selector(currentRequest)]) {

            request = downloadTask.currentRequest;
            [self setRequest:request forTask:downloadTask];
            NSString *requestID = [self requestIDForTask:downloadTask];

            PDNetworkRequest *networkRequest = [PDNetworkRequest networkRequestWithURLRequest:request];
            [self.domain requestWillBeSentWithRequestId:requestID
                                                frameId:@""
                                               loaderId:@""
                                            documentURL:[request.URL absoluteString]
                                                request:networkRequest
                                              timestamp:[NSDate PD_timestamp]
                                              initiator:nil
                                       redirectResponse:nil];

            [self setResponse:downloadTask.response forTask:downloadTask];

            NSMutableData *dataAccumulator = nil;
            dataAccumulator = [[NSMutableData alloc] initWithCapacity:(NSUInteger) totalBytesExpectedToWrite];
            [self setAccumulatedData:dataAccumulator forTask:downloadTask];
            
            PDNetworkResponse *networkResponse = [PDNetworkResponse networkResponseWithURLResponse:downloadTask.response request:request];
            
            [self.domain responseReceivedWithRequestId:requestID
                                               frameId:@""
                                              loaderId:@""
                                             timestamp:[NSDate PD_timestamp]
                                                  type:downloadTask.response.PD_responseType
                                              response:networkResponse];
        }

        [self addAccumulatedData:[NSData emptyDataOfLength:(NSUInteger) bytesWritten] forTask:downloadTask];

        NSNumber *length = [NSNumber numberWithInteger:(NSInteger) bytesWritten];
        NSString *requestID = [self requestIDForTask:downloadTask];

        [self.domain dataReceivedWithRequestId:requestID
                                     timestamp:[NSDate PD_timestamp]
                                    dataLength:length
                             encodedDataLength:length];
    }];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location data:(NSData *)data
{
    [self performBlock:^{
        NSURLResponse *response = [self responseForTask:downloadTask];
        NSString *requestID = [self requestIDForTask:downloadTask];
        
        [self setResponse:data
             forRequestID:requestID
                 response:response
                  request:[self requestForTask:downloadTask]];

        [self.domain loadingFinishedWithRequestId:requestID
                                        timestamp:[NSDate PD_timestamp]];

        [self taskFinished:downloadTask];
    }];
}

@end


@implementation PDNetworkRequest (PDNetworkHelpers)

- (id)initWithURLRequest:(NSURLRequest *)request
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.url = [request.URL absoluteString];
    self.method = request.HTTPMethod;
    self.headers = request.allHTTPHeaderFields;
    
    
    NSData *body = request.HTTPBody;
    
    // pretty print and redact sensitive fields
    id<PDPrettyStringPrinting> prettyStringPrinter = [PDNetworkDomainController prettyStringPrinterForRequest:request];
    if (prettyStringPrinter) {
        self.postData = [prettyStringPrinter prettyStringForData:body forRequest:request];
    } else {
        // If the data isn't UTF-8 it will just be nil;
        self.postData = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    }

    return self;
}

+ (PDNetworkRequest *)networkRequestWithURLRequest:(NSURLRequest *)request;
{
    return [[[self class] alloc] initWithURLRequest:request];
}

@end


@implementation PDNetworkResponse (PDNetworkHelpers)

- (id)initWithURLResponse:(NSURLResponse *)response request:(NSURLRequest *)request
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.url = [response.URL absoluteString];

    // Set statusText if this was a HTTP Response
    self.statusText = @"";

    self.mimeType = response.MIMEType;
    self.requestHeaders = request.allHTTPHeaderFields;
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        self.status = [NSNumber numberWithInteger:httpResponse.statusCode];
        self.statusText = [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode];
        self.headers = httpResponse.allHeaderFields;
    }

    return self;
}

+ (PDNetworkResponse *)networkResponseWithURLResponse:(NSURLResponse *)response request:(NSURLRequest *)request;
{
    return [[[self class] alloc] initWithURLResponse:response request:request];
}

@end


@implementation NSURLResponse (PDNetworkHelpers)

- (NSString *)PD_responseType;
{
    NSString *MIMEType = self.MIMEType;
    NSString *contentType = [MIMEType lowercaseString];
    NSString *type = @"Other";
    
    if ([contentType rangeOfString:@"image"].length != 0) {
        type = @"Image";
    } else if ([contentType rangeOfString:@"json"].length != 0) {
        type = @"XHR";
    }

    return type;
}

@end


@implementation _PDRequestState

@synthesize request = _request;
@synthesize response = _response;
@synthesize requestID = _requestID;
@synthesize dataAccumulator = _dataAccumulator;

@end
