//
//  PDURLSessionViewController.m
//  PDTestApp
//
//  Created by Simone Civetta on 31/07/14.
//  Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import <PonyDebugger/PonyDebugger.h>

#import "PDURLSessionViewController.h"
#import "PDRepo.h"
#import "PDOwner.h"

@interface PDURLSessionViewController () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (IBAction)_refresh:(UIBarButtonItem *)sender;

@end

@implementation PDURLSessionViewController {
    NSMutableData *_responseData;
    NSURLSession *_urlSession;
}

@dynamic refreshControl;

#pragma mark - UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(_refresh:) forControlEvents:UIControlEventValueChanged];
    [self _reloadImage];
}

#pragma mark - Private Methods

- (void)_reloadImage
{
    NSString *resource = [NSString stringWithFormat:@"https://corner.squareup.com/images/ponydebugger/icon.png"];

    if (!_urlSession) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    
    NSURLSessionDataTask *dataTask = [_urlSession dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:resource]]];

    [dataTask resume];
}

- (IBAction)_refresh:(UIBarButtonItem *)sender;
{
    [self _reloadImage];
    PDLogD(@"Reloading repos");
}

- (void)displayImage:(UIImage *)image
{
    self.imageView.image = image;
    [self.tableView reloadData];
}

- (void)displayError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Request Failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark - NSURLSession Delegate Methods

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    _responseData = [[NSMutableData alloc] init];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            [self displayError:error];
            [self.refreshControl endRefreshing];
            return;
        }

        UIImage *image = [[UIImage alloc] initWithData:_responseData];
        
        [self displayImage:image];
        [self.refreshControl endRefreshing];
    });
}

@end
