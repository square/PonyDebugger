//
//  PDRepo.h
//  PDTestApp 
//
//  Created by Mike Lewis on 11/9/11.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class PDOwner;


@interface PDRepo : NSManagedObject

@property (nonatomic, strong) NSNumber *remoteID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *lastUpdated;

@property (nonatomic, strong) PDOwner *owner;

@end
