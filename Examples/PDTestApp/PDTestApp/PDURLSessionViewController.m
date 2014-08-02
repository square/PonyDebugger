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
@property (nonatomic, strong) NSArray *allRepos;

- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (IBAction)_refresh:(UIBarButtonItem *)sender;

@end

@implementation PDURLSessionViewController {
    NSMutableData *_responseData;
    NSURLSession *_urlSession;
}

#pragma mark - UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(_refresh:) forControlEvents:UIControlEventValueChanged];
    [self _reloadRepos];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *repoCell = [tableView dequeueReusableCellWithIdentifier:@"PDRepoCell"];
    if (!repoCell) {
        repoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PDRepoCell"];
        repoCell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        repoCell.textLabel.numberOfLines = 0;
        repoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return repoCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.allRepos count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self _configureCell:cell atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods

- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary *repo = self.allRepos[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ by %@", [repo valueForKeyPath:@"name"], [repo valueForKeyPath:@"owner.login"]];
}

- (void)_reloadRepos
{
    NSString *resource = [NSString stringWithFormat:@"https://api.github.com/users/square/repos"];

    if (!_urlSession) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    
    NSURLSessionDataTask *dataTask = [_urlSession dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:resource]]];

    [dataTask resume];
}

- (IBAction)_refresh:(UIBarButtonItem *)sender;
{
    [self _reloadRepos];
    PDLogD(@"Reloading repos");
}

- (void)displayRepos:(NSArray *)repoArray
{
    self.allRepos = repoArray;
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
        
        NSError *deserializationError;
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:&deserializationError];
        
        if (deserializationError) {
            [self displayError:error];
            [self.refreshControl endRefreshing];
            return;
        }
        
        [self displayRepos:responseArray];
        [self.refreshControl endRefreshing];
    });
}

@end
