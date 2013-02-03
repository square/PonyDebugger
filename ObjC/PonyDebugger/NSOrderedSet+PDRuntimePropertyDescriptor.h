//
//  NSOrderedSet+PDRuntimePropertyDescriptor.h
//  PonyDebugger
//
//  Created by Wen-Hao Lue on 2013-02-03.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <Foundation/Foundation.h>

@interface NSOrderedSet (PDRuntimePropertyDescriptor)

- (id)PD_objectAtIndex:(NSUInteger)index;

@end
