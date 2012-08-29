//
//  PDUser.h
//  PDTwitterTest
//
//  Created by Wen-Hao Lue on 8/21/12.
//  Copyright (c) 2012 Square, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface PDUser : NSManagedObject

@property (nonatomic, strong) NSNumber *remoteID;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profilePictureURL;

@property (nonatomic, strong) NSSet *tweets;

@end
