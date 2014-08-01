//
// Created by Simone Civetta on 01/08/14.
// Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PDURLSessionDownloadViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIProgressView *progressView;

- (IBAction)downloadFile:(id)sender;

@end