//
//  PDOwner.h
//  PDTestApp
//
//  Created by Wen-Hao Lue on 8/21/12.
//  Copyright (c) 2012 Square, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface PDOwner : NSManagedObject

@property (nonatomic, strong) NSNumber *remoteID;
@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *avatarURL;

@property (nonatomic, strong) NSSet *repos;

@end
