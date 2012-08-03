//
//  PDViewController.h
//  PDTwitterTest
//
//  Created by Mike Lewis on 2/27/12.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <UIKit/UIKit.h>

@interface PDViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
