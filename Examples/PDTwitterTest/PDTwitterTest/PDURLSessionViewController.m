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

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *refreshButton;

- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)_reloadFeedWithSearchTerm:(NSString *)searchTerm;

- (IBAction)_refresh:(UIBarButtonItem *)sender;

@end

@implementation PDURLSessionViewController {
    NSFetchedResultsController *_resultsController;
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
    
    self.searchBar.text = @"ponydebugger";
    [self _reloadFeedWithSearchTerm:self.searchBar.text];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
    // Return YES for supported orientations.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    
    return YES;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [self.searchBar resignFirstResponder];
    [self _reloadFeedWithSearchTerm:searchBar.text];
    
    // PDLogObjects() is used to output objects that are inspectable. To output different data types,
    // separate them out in different arguments.
    PDLogObjects(@"Searched with bar:", searchBar, @"and search term:", searchBar.text);
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
{
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if (!searchText.length) {
        [self.searchBar resignFirstResponder];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        break;
        
        case NSFetchedResultsChangeDelete:
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        break;
        
        case NSFetchedResultsChangeUpdate:
        [self _configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
        break;
        
        case NSFetchedResultsChangeMove:
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;
{
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"PDTweetCell"];
    if (!tweetCell) {
        tweetCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PDTweetCell"];
        tweetCell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        tweetCell.textLabel.numberOfLines = 0;
        tweetCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return tweetCell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [cell.imageView cancelImageRequestOperation];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _resultsController.fetchedObjects.count;
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Private Methods

- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
{
    PDRepo *repo = [_resultsController objectAtIndexPath:indexPath];
    [cell.imageView setImageWithURL:[NSURL URLWithString:repo.owner.avatarURL] placeholderImage:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"@%@ %@", repo.owner.login, repo.name];
}

- (void)_reloadFeedWithSearchTerm:(NSString *)searchTerm;
{
    NSString *resource = [NSString stringWithFormat:@"https://api.github.com/users/square/repos"];
    NSURL *URL = [NSURL URLWithString:resource];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [_sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [[[UIAlertView alloc] initWithTitle:@"Request Failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            NSArray *responseArray = [responseObject objectForKey:@"results"];
            
            NSMutableSet *tweetIDs = [[NSMutableSet alloc] initWithCapacity:[responseArray count]];
            for (NSDictionary *tweetDict in responseArray) {
                [tweetIDs addObject:[tweetDict objectForKey:@"id"]];
            }
            
            NSFetchRequest *existingRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
            existingRequest.predicate = [NSPredicate predicateWithFormat:@"remoteID in %@", tweetIDs];

        }
    }];
    
    [dataTask resume];
}

- (IBAction)_refresh:(UIBarButtonItem *)sender;
{
    [self _reloadFeedWithSearchTerm:self.searchBar.text];
    
    // PDLog() takes the same string/argument formatting as NSLog().
    // PDLogD() formats it with debug formatting.
    PDLogD(@"Reloading feed with search term: %@.", self.searchBar.text);
}

@end
