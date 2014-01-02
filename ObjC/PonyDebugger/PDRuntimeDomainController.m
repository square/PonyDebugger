//
//  PDRuntimeDomainController.m
//  PonyDebugger
//
//  Created by Wen-Hao Lue on 8/7/12.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDRuntimeDomainController.h"
#import "PDRuntimeTypes.h"

#import "NSObject+PDRuntimePropertyDescriptor.h"
#import "NSManagedObject+PDRuntimePropertyDescriptor.h"
#import "NSArray+PDRuntimePropertyDescriptor.h"
#import "NSSet+PDRuntimePropertyDescriptor.h"
#import "NSOrderedSet+PDRuntimePropertyDescriptor.h"
#import "NSDictionary+PDRuntimePropertyDescriptor.h"


@interface PDRuntimeDomainController () <PDRuntimeCommandDelegate>

// Dictionary where key is a unique objectId, and value is a reference of the value.
@property (nonatomic, strong) NSMutableDictionary *objectReferences;

// Values are arrays of object references.
@property (nonatomic, strong) NSMutableDictionary *objectGroups;

+ (NSString *)_generateUUID;

- (void)_releaseObjectID:(NSString *)objectID;
- (void)_releaseObjectGroup:(NSString *)objectGroup;

@end


@implementation PDRuntimeDomainController

@dynamic domain;

@synthesize objectReferences = _objectReferences;
@synthesize objectGroups = _objectGroups;

#pragma mark - Statics

+ (PDRuntimeDomainController *)defaultInstance;
{
    static PDRuntimeDomainController *defaultInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultInstance = [[PDRuntimeDomainController alloc] init];
    });
    
    return defaultInstance;
}

+ (Class)domainClass;
{
    return [PDRuntimeDomain class];
}

+ (NSString *)_generateUUID;
{
	CFUUIDRef UUIDRef = CFUUIDCreate(nil);
    NSString *newGuid = (__bridge_transfer NSString *) CFUUIDCreateString(nil, UUIDRef);
    CFRelease(UUIDRef);
    return newGuid;
}

#pragma mark - Initialization

- (id)init;
{
    if (!(self = [super init])) {
        return nil;
    }
    
    self.objectReferences = [[NSMutableDictionary alloc] init];
    self.objectGroups = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void)dealloc;
{
    self.objectReferences = nil;
    self.objectGroups = nil;
}

+ (NSError *)defaultErrorForFailedExpression:(NSString *)expression;
{
    NSString *errorMessage = [NSString stringWithFormat:@"Must specify a keypath that starts with a class name and a singleton selector.  Recieved '%@'", expression];
    NSError *error = [NSError errorWithDomain:PDDebuggerErrorDomain code:100 userInfo:[NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey]];
    return error;
}
#pragma mark - PDRuntimeCommandDelegate

- (void)domain:(PDRuntimeDomain *)domain evaluateWithExpression:(NSString *)expression objectGroup:(NSString *)objectGroup includeCommandLineAPI:(NSNumber *)includeCommandLineAPI doNotPauseOnExceptionsAndMuteConsole:(NSNumber *)doNotPauseOnExceptionsAndMuteConsole contextId:(NSNumber *)contextId returnByValue:(NSNumber *)returnByValue callback:(void (^)(PDRuntimeRemoteObject *result, NSNumber *wasThrown, id error))callback;
{
    PDRuntimeRemoteObject *result = nil;
    NSNumber *wasThrown = @NO;
    NSError *error = nil;

    NSInteger dotPosition = [expression rangeOfString:@"."].location;

    if (dotPosition != NSNotFound) {
        NSString *class = [expression substringToIndex:dotPosition];
        NSString *keypath = [expression substringFromIndex:dotPosition + 1];

        Class klass = NSClassFromString(class);
        @try {
            NSObject *keypathValue = [(NSObject *)klass valueForKeyPath:keypath];
            result = [NSObject PD_remoteObjectRepresentationForObject:keypathValue];
        }
        @catch (...) {
            error = [self.class defaultErrorForFailedExpression:expression];
        }
    } else {
        error = [self.class defaultErrorForFailedExpression:expression];
    }
    callback(result, wasThrown, error);
}

- (void)domain:(PDRuntimeDomain *)domain getPropertiesWithObjectId:(NSString *)objectId ownProperties:(NSNumber *)ownProperties callback:(void (^)(NSArray *result, id error))callback;
{
    NSObject *object = [self.objectReferences objectForKey:objectId];
    if (!object) {
        NSString *errorMessage = [NSString stringWithFormat:@"Object with objectID '%@' does not exist.", objectId];
        NSError *error = [NSError errorWithDomain:PDDebuggerErrorDomain code:100 userInfo:[NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey]];
        
        callback(nil, error);
        return;
    }
    
    NSArray *properties = [object PD_propertyDescriptors];
    callback(properties, nil);
}

- (void)domain:(PDRuntimeDomain *)domain releaseObjectWithObjectId:(NSString *)objectId callback:(void (^)(id error))callback;
{
    callback(nil);
    
    [self _releaseObjectID:objectId];
}

- (void)domain:(PDRuntimeDomain *)domain releaseObjectGroupWithObjectGroup:(NSString *)objectGroup callback:(void (^)(id error))callback;
{
    callback(nil);
    
    [self _releaseObjectGroup:objectGroup];
}

#pragma mark - Public Methods

/**
 * Registers and returns a string associated with the object to retain.
 */
- (NSString *)registerAndGetKeyForObject:(id)object;
{
    NSString *key = [PDRuntimeDomainController _generateUUID];
    
    [self.objectReferences setObject:object forKey:key];
    
    return key;
}

/**
 * Clears object references given the string returned by registerAndGetKeyForObject:
 */
- (void)clearObjectReferencesByKey:(NSArray *)objectKeys;
{
    [self.objectReferences removeObjectsForKeys:objectKeys];
}

/**
 * Clears all object references.
 */
- (void)clearAllObjectReferences;
{
    [self.objectReferences removeAllObjects];
    [self.objectGroups removeAllObjects];
}

#pragma mark - Private Methods

- (void)_releaseObjectID:(NSString *)objectID;
{
    if (![self.objectReferences objectForKey:objectID]) {
        return;
    }
    
    [self.objectReferences removeObjectForKey:objectID];
}

- (void)_releaseObjectGroup:(NSString *)objectGroup;
{
    NSArray *objectIDs = [self.objectGroups objectForKey:objectGroup];
    if (objectIDs) {
        for (NSString *objectID in objectIDs) {
            [self _releaseObjectID:objectID];
        }
        
        [self.objectGroups removeObjectForKey:objectGroup];
    }
}

@end
