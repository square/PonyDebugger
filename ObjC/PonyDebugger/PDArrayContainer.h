//
//  PDArrayContainer.h
//  PonyDebugger
//
//  Created by Wen-Hao Lue on 8/8/12.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PonyDebugger.h>


@class PDRuntimePropertyDescriptor;


@interface PDArrayContainer : NSObject

- (id)initWithContainer:(id)container;
- (id)initWithArray:(NSArray *)array;
- (id)initWithSet:(NSSet *)set;

- (NSUInteger)count;

@end


@interface PDArrayContainer (PDRuntimePropertyDescriptor)

- (NSArray *)PD_propertiesForPropertyDescriptors;
- (PDRuntimePropertyDescriptor *)PD_propertyDescriptorForPropertyObject:(NSObject *)property;

@end
