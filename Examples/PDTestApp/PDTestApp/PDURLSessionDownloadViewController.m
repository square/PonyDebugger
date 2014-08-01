//
// Created by Simone Civetta on 01/08/14.
// Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import <PonyDebugger/PDDebugger.h>
#import "PDURLSessionDownloadViewController.h"
#import "AFURLSessionManager.h"

@implementation PDURLSessionDownloadViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)_downloadFile
{
    PDLog(@"Starting download");
    NSURL *URL = [NSURL URLWithString:@"http://download.thinkbroadband.com/5MB.zip"];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSProgress *progress = nil;

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:URL] progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [progress removeObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted))];
        PDLog(@"File downloaded to: %@", filePath);
    }];

    [progress addObserver:self
               forKeyPath:NSStringFromSelector(@selector(fractionCompleted))
                  options:NSKeyValueObservingOptionInitial
                  context:NULL];
    
    [downloadTask resume];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(fractionCompleted))]) {
        NSProgress *progress = (NSProgress *)object;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressView setProgress:(CGFloat) progress.fractionCompleted animated:YES];
        });        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (IBAction)downloadFile:(id)sender
{
    [self _downloadFile];
}

@end