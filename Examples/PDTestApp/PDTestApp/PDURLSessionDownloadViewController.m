//
// Created by Simone Civetta on 01/08/14.
// Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import <PonyDebugger/PDDebugger.h>
#import "PDURLSessionDownloadViewController.h"

@interface PDURLSessionDownloadViewController() <NSURLSessionDownloadDelegate>

@end

@implementation PDURLSessionDownloadViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)_downloadFile
{
    PDLog(@"Starting download");
    NSURL *URL = [NSURL URLWithString:@"http://download.thinkbroadband.com/5MB.zip"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:URL];

    [downloadTask resume];
}

- (IBAction)downloadFile:(id)sender
{
    [self _downloadFile];
}

#pragma mark - Download delegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    PDLog(@"Resuming download task");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setProgress:(totalBytesWritten / (CGFloat)totalBytesExpectedToWrite) animated:YES];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    PDLog(@"Download finished");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.progressView.progress = 0;
    });
}

@end