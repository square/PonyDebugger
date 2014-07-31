//
//  PDURLSessionViewController.m
//  PDTwitterTest
//
//  Created by Simone Civetta on 31/07/14.
//  Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import <PonyDebugger/PonyDebugger.h>

#import "PDURLSessionViewController.h"
#import "PDRepo.h"
#import "PDOwner.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface PDURLSessionViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *allRepos;

- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (IBAction)_refresh:(UIBarButtonItem *)sender;

@end

@implementation PDURLSessionViewController {
    AFURLSessionManager *_sessionManager;
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super initWithCoder:coder];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    
    return self;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
    // Return YES for supported orientations.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    
    return YES;
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

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [cell.imageView cancelImageRequestOperation];
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
    __weak UITableViewCell *weakCell = cell;
    [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[repo valueForKeyPath:@"owner.avatar_url"]]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakCell.imageView.image = image;
        [weakCell setNeedsLayout];
    } failure:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ by %@", [repo valueForKeyPath:@"name"], [repo valueForKeyPath:@"owner.login"]];
}

- (void)_reloadRepos
{
    NSString *resource = [NSString stringWithFormat:@"https://api.github.com/users/square/repos"];
    NSURL *URL = [NSURL URLWithString:resource];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [_sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseArray, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [[[UIAlertView alloc] initWithTitle:@"Request Failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            self.allRepos = responseArray;
        }
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
    
    [dataTask resume];
}

- (IBAction)_refresh:(UIBarButtonItem *)sender;
{
    [self _reloadRepos];
    
    // PDLog() takes the same string/argument formatting as NSLog().
    // PDLogD() formats it with debug formatting.
    PDLogD(@"Reloading repos");
}

@end
