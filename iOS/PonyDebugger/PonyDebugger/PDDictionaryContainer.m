//
//  PDDictionaryContainer.m
//  PonyDebugger
//
//  Created by Wen-Hao Lue on 8/9/12.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDDictionaryContainer.h"
#import "NSObject+PDRuntimePropertyDescriptor.h"

#import <PonyDebugger/PDRuntimeTypes.h>


#pragma mark - Private Classes

@interface _PDDictionaryContainerKey : NSObject

- (id)initWithKey:(id <NSCopying>)key stringRepresentation:(NSString *)stringKey;

@property (nonatomic, copy) id <NSCopying> key;
@property (nonatomic, copy) NSString *stringKey;

@end


#pragma mark - Private Interface

@interface PDDictionaryContainer ()

@property (nonatomic, copy) NSDictionary *dictionary;

@end


#pragma mark - Implementation

@implementation PDDictionaryContainer

@synthesize dictionary = _dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
{
    if (!(self = [super init])) {
        return nil;
    }
    
    self.dictionary = dictionary;
    
    return self;
}

- (void)dealloc;
{
    self.dictionary = nil;
}


- PD_JSONObject;
{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithCapacity:self.dictionary.count];
    
    [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *stringKey = [NSString stringWithFormat:@"%@", key];
        [ret setObject:obj forKey:stringKey];
    }];
    
    return ret;
}

@end


@implementation PDDictionaryContainer (PDRuntimePropertyDescriptor)

- (NSArray *)PD_propertiesForPropertyDescriptors;
{
    NSMutableArray *properties = [[NSMutableArray alloc] initWithCapacity:self.dictionary.count + 1];
    
    [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *stringKey = [NSString stringWithFormat:@"%@", key];
        
        _PDDictionaryContainerKey *containerIndex = [[_PDDictionaryContainerKey alloc] initWithKey:key stringRepresentation:stringKey];
        [properties addObject:containerIndex];
    }];
    
    return properties;
}

- (PDRuntimePropertyDescriptor *)PD_propertyDescriptorForPropertyObject:(NSObject *)property;
{
    PDRuntimePropertyDescriptor *descriptor = [super PD_propertyDescriptorForPropertyObject:property];
    if (!descriptor) {
        if ([property isKindOfClass:[_PDDictionaryContainerKey class]]) {
            descriptor = [self PD_propertyDescriptorForDictionaryContainerKey:(_PDDictionaryContainerKey *)property];
        }
    }
    
    return descriptor;
}

- (PDRuntimePropertyDescriptor *)PD_propertyDescriptorForDictionaryContainerKey:(_PDDictionaryContainerKey *)containerKey;
{
    PDRuntimePropertyDescriptor *descriptor = [[PDRuntimePropertyDescriptor alloc] init];
    
    id propertyValue = [self.dictionary objectForKey:containerKey.key];
    
    descriptor.name = containerKey.stringKey;
    descriptor.value = [self PD_propertyDescriptorValueForObject:propertyValue];
    descriptor.writable = [NSNumber numberWithBool:NO];
    descriptor.configurable = [NSNumber numberWithBool:NO];
    descriptor.enumerable = [NSNumber numberWithBool:YES];
    descriptor.wasThrown = [NSNumber numberWithBool:NO];
    
    return descriptor;
}

@end


#pragma mark - _PDDictionaryContainerKey

@implementation _PDDictionaryContainerKey

@synthesize stringKey = _stringKey;
@synthesize key = _key;

- (id)initWithKey:(id<NSCopying>)key stringRepresentation:(NSString *)stringKey;
{
    if (!(self = [super self])) {
        return nil;
    }
    
    self.key = key;
    self.stringKey = stringKey;
    
    return self;
}

- (void)dealloc;
{
    self.key = nil;
    self.stringKey = nil;
}

@end
