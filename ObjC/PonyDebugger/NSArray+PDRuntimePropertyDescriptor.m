//
//  NSArray+PDRuntimePropertyDescriptor.m
//  PonyDebugger
//
//  Created by Wen-Hao Lue on 2013-02-02.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "NSArray+PDRuntimePropertyDescriptor.h"
#import "NSObject+PDRuntimePropertyDescriptor.h"

#import "PDRuntimeTypes.h"
#import "PDRuntimeDomainController.h"


#pragma mark - Private Classes

@interface _PDArrayIndex : NSObject

- (id)initWithName:(NSString *)name index:(NSInteger)index;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger index;

@end


#pragma mark - Implementation

@implementation NSArray (PDRuntimePropertyDescriptor)

/**
 * valueForKey behaves differently for NSArray/NSSet, so define our own behaviour to actually grab the 
 * array's value for a key.
 */
- (id)PD_valueForKey:(NSString *)key;
{
    if ([key isEqualToString:@"class"]) {
        return NSStringFromClass([self class]);
    } else if ([key isEqualToString:@"count"]) {
        return @(self.count);
    }

    return nil;
}

- (NSArray *)PD_propertiesForPropertyDescriptors;
{
    NSMutableArray *properties = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    for (NSInteger index = 0; index < self.count; ++index) {
        NSString *name = [NSString stringWithFormat:@"%d", index];
        
        _PDArrayIndex *containerIndex = [[_PDArrayIndex alloc] initWithName:name index:index];
        [properties addObject:containerIndex];
    }

    [properties addObject:@"class"];
    [properties addObject:@"count"];

    return properties;
}

- (PDRuntimePropertyDescriptor *)PD_propertyDescriptorForPropertyObject:(NSObject *)property;
{
    PDRuntimePropertyDescriptor *descriptor = [super PD_propertyDescriptorForPropertyObject:property];
    if (!descriptor) {
        if ([property isKindOfClass:[_PDArrayIndex class]]) {
            descriptor = [self PD_propertyDescriptorForArrayContainerIndex:(_PDArrayIndex *)property];
        }
    }
    
    return descriptor;
}

- (PDRuntimePropertyDescriptor *)PD_propertyDescriptorForArrayContainerIndex:(_PDArrayIndex *)containerIndex;
{
    PDRuntimePropertyDescriptor *descriptor = [[PDRuntimePropertyDescriptor alloc] init];
    
    id propertyValue = [self objectAtIndex:containerIndex.index];
    
    PDRuntimeRemoteObject *remoteValueObject = [[PDRuntimeRemoteObject alloc] init];
    
    NSDictionary *propertyTypeDetails = PDRemoteObjectPropertyTypeDetailsForObject(propertyValue);
    remoteValueObject.type = [propertyTypeDetails objectForKey:@"type"];
    remoteValueObject.subtype = [propertyTypeDetails objectForKey:@"subtype"];
    remoteValueObject.classNameString = NSStringFromClass([propertyValue class]);
    if ([remoteValueObject.type isEqualToString:@"object"] && !remoteValueObject.subtype) {
        remoteValueObject.objectId = [[PDRuntimeDomainController defaultInstance] registerAndGetKeyForObject:propertyValue];
        remoteValueObject.objectDescription = remoteValueObject.classNameString;
    } else {
        remoteValueObject.value = propertyValue;
    }
    
    descriptor.name = containerIndex.name;
    descriptor.value = remoteValueObject;
    descriptor.writable = [NSNumber numberWithBool:NO];
    descriptor.configurable = [NSNumber numberWithBool:NO];
    descriptor.enumerable = [NSNumber numberWithBool:YES];
    descriptor.wasThrown = [NSNumber numberWithBool:NO];
    
    return descriptor;
}

@end


#pragma mark - _PDArrayIndex

@implementation _PDArrayIndex

@synthesize name = _name;
@synthesize index = _index;

- (id)initWithName:(NSString *)name index:(NSInteger)index;
{
    if (!(self = [super self])) {
        return nil;
    }
    
    self.name = name;
    self.index = index;
    
    return self;
}

@end
