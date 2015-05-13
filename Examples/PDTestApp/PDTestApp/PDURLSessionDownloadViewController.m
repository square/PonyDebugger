//
// Created by Simone Civetta on 01/08/14.
// Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import <PonyDebugger/PDDebugger.h>
#import "PDURLSessionDownloadViewController.h"

@interface PDURLSessionDownloadViewController() <NSURLSessionDownloadDelegate>

@end



@implementation PDURLSessionDownloadViewController {
    NSURLSession *_urlSession;
    NSURLSession *_urlSession2;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)_downloadFile
{
    PDLog(@"Starting download");
    NSURL *URL = [NSURL URLWithString:@"http://www.allcreaturesgreatandsmall.org.uk/media/25575/Shetland_Pony_on_Belstone_Common,_Dartmoor.jpg"];

    if (!_urlSession) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    
    NSURLSessionDownloadTask *downloadTask = [_urlSession downloadTaskWithURL:URL];
    
    [downloadTask resume];
}

- (void)_downloadFile2
{
    PDLog(@"Starting download");
    NSURL *URL = [NSURL URLWithString:@"http://www.allcreaturesgreatandsmall.org.uk/media/25575/Shetland_Pony_on_Belstone_Common,_Dartmoor.jpg"];
    
    if (!_urlSession2) {
        _urlSession2 = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:nil];
    }
    
    NSURLSessionDownloadTask *downloadTask = [_urlSession2 downloadTaskWithURL:URL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSLog(@"Download complete");
    }];
    
    [downloadTask resume];
}

- (IBAction)downloadFile:(id)sender
{
    [self _downloadFile];
}

- (IBAction)downloadFile2:(id)sender
{
    [self _downloadFile2];
}

#pragma mark - NSURLSession Delegate Methods

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    PDLog(@"Download resumed");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    PDLog(@"Download finished");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.progressView.progress = 0.0;
    });
}

@end