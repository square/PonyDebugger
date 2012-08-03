//
//  PDArrayContainer.m
//  PonyDebugger
//
//  Created by Wen-Hao Lue on 8/8/12.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDArrayContainer.h"
#import "NSObject+PDRuntimePropertyDescriptor.h"

#import "PDRuntimeTypes.h"
#import "PDRuntimeDomainController.h"


#pragma mark - Private Classes

@interface _PDArrayContainerIndex : NSObject

- (id)initWithName:(NSString *)name index:(NSInteger)index;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger index;

@end


#pragma mark - Private Interface

@interface PDArrayContainer ()

@property (nonatomic, copy) NSArray *array;

@end


#pragma mark - Implementation

@implementation PDArrayContainer

@synthesize array = _array;

- (id)initWithContainer:(id)container;
{
    if ([container isKindOfClass:[NSArray class]]) {
        return [self initWithArray:container];
    } else if ([container isKindOfClass:[NSSet class]]) {
        return [self initWithSet:container];
    }
    
    return nil;
}

- (id)initWithArray:(NSArray *)array;
{
    if (!(self = [super init])) {
        return nil;
    }
    
    self.array = array;
    
    return self;
}

- (id)initWithSet:(NSSet *)set;
{
    if (!(self = [super init])) {
        return nil;
    }
    
    self.array = [set allObjects];
    
    return self;
}

- (void)dealloc;
{
    self.array = nil;
}

- (NSUInteger)count;
{
    return self.array.count;
}

- PD_JSONObject;
{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithCapacity:self.array.count];
    
    for (NSInteger index = 0; index < self.array.count; ++index) {
        NSString *key = [NSString stringWithFormat:@"%d", index];
        id value = [[self.array objectAtIndex:index] PD_JSONObject];
        [ret setObject:value forKey:key];
    }
    
    return ret;
}

@end


@implementation PDArrayContainer (PDRuntimePropertyDescriptor)

- (NSArray *)PD_propertiesForPropertyDescriptors;
{
    NSMutableArray *properties = [[NSMutableArray alloc] initWithCapacity:self.array.count + 1];
    
    for (NSInteger index = 0; index < self.array.count; ++index) {
        NSString *name = [NSString stringWithFormat:@"%d", index];
        
        _PDArrayContainerIndex *containerIndex = [[_PDArrayContainerIndex alloc] initWithName:name index:index];
        [properties addObject:containerIndex];
    }
    
    [properties addObject:@"count"];
    
    return properties;
}

- (PDRuntimePropertyDescriptor *)PD_propertyDescriptorForPropertyObject:(NSObject *)property;
{
    PDRuntimePropertyDescriptor *descriptor = [super PD_propertyDescriptorForPropertyObject:property];
    if (!descriptor) {
        if ([property isKindOfClass:[_PDArrayContainerIndex class]]) {
            descriptor = [self PD_propertyDescriptorForArrayContainerIndex:(_PDArrayContainerIndex *)property];
        }
    }
    
    return descriptor;
}

- (PDRuntimePropertyDescriptor *)PD_propertyDescriptorForArrayContainerIndex:(_PDArrayContainerIndex *)containerIndex;
{
    PDRuntimePropertyDescriptor *descriptor = [[PDRuntimePropertyDescriptor alloc] init];
    
    id propertyValue = [self.array objectAtIndex:containerIndex.index];
    
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


#pragma mark - _PDArrayContainerIndex

@implementation _PDArrayContainerIndex

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

- (void)dealloc;
{
    self.name = nil;
}

@end
