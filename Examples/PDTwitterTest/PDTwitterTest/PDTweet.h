//
//  PDTweet.h
//  PDTwitterTest 
//
//  Created by Mike Lewis on 11/9/11.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class PDUser;


@interface PDTweet : NSManagedObject

@property (nonatomic, strong) NSNumber *remoteID;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *retrievalDate;

@property (nonatomic, strong) PDUser *user;

@end
