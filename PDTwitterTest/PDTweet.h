//
//  PDTTweet.h
//  PonyExpress
//
//  Created by Mike Lewis on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PDTweet : NSManagedObject

@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * userName;

@end
