//
//  PDViewController.m
//  PDTwitterTest
//
//  Created by Mike Lewis on 11/9/11.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDViewController.h"
#import "PDTweet.h"
#import "PDUser.h"

#import <objc/runtime.h>

typedef void (^PDSuccessBlock)(NSURL *from, NSData *results);
typedef void (^PDFailureBlock)(NSError *error);

static void *const PDSuccessBlockKey = @"PDSuccessBlockKey";
static void *const PDFailureBlockKey = @"PDFailureBlockKey";
static void *const PDResponseDataKey = @"PDResponseDataKey";

#pragma mark - Private Interface

@interface PDViewController () <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *refreshButton;

- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)_reloadFeed;

- (IBAction)_refresh:(UIBarButtonItem *)sender;

@end


#pragma mark - Implementation

@implementation PDViewController {
    NSFetchedResultsController *_resultsController;
    NSMutableDictionary *_imageCache;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize refreshButton = _refreshButton;
@synthesize searchBar = _searchBar;

#pragma mark - Initialization

- (id) initWithCoder:(NSCoder *)aDecoder;
{
    if (!(self = [super initWithCoder:aDecoder])) {
        return nil;
    }

    _imageCache = [[NSMutableDictionary alloc] init];

    return self;
}

- (void)dealloc;
{
    self.managedObjectContext = nil;
}

#pragma mark - UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObjects:
        [NSSortDescriptor sortDescriptorWithKey:@"retrievalDate" ascending:NO],
        [NSSortDescriptor sortDescriptorWithKey:@"remoteID" ascending:NO],
        nil];
    
    _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _resultsController.delegate = self;
    [_resultsController performFetch:nil];
}

- (void)viewDidUnload;
{
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [self.searchBar resignFirstResponder];
    [self _reloadFeedWithSearchTerm:searchBar.text];
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

#pragma mark - NSURLConnection

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
    PDFailureBlock failureBlock = objc_getAssociatedObject(connection, PDFailureBlockKey);
    if (failureBlock) {
        failureBlock(error);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    if ((HTTPResponse.statusCode / 100) == 2) {
        objc_setAssociatedObject(connection, PDResponseDataKey, [NSMutableData data], OBJC_ASSOCIATION_RETAIN);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)receivedData;
{
    NSMutableData *responseData = objc_getAssociatedObject(connection, PDResponseDataKey);
    [responseData appendData:receivedData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    PDSuccessBlock successBlock = objc_getAssociatedObject(connection, PDSuccessBlockKey);
    if (successBlock) {
        successBlock(connection.originalRequest.URL, objc_getAssociatedObject(connection, PDResponseDataKey));
    }
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
    PDTweet *tweet = [_resultsController objectAtIndexPath:indexPath];
    NSURL *imageURL = [NSURL URLWithString:tweet.user.profilePictureURL];
    cell.imageView.image = [_imageCache objectForKey:imageURL];

    if (!cell.imageView.image) {
        cell.imageView.image = [UIImage imageNamed:@"twitter_egg.png"];

        __weak NSMutableDictionary *weakImageCache = _imageCache;
        __weak UITableView *weakTableView = self.tableView;
        [self _fetchFromURL:imageURL withSuccessBlock:^(NSURL *from, NSData *response) {
            [weakImageCache setObject:[UIImage imageWithData:response] forKey:from];

            [weakTableView reloadData];
        } failureBlock:NULL];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"@%@ %@", tweet.user.screenName, tweet.text];
}

- (void)_reloadFeed;
{
    NSString *path = @"https://api.twitter.com/1/statuses/public_timeline.json?count=30";
    [self _fetchFromURL:[NSURL URLWithString:path] withSuccessBlock:^(NSURL *from, NSData *results) {
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingAllowFragments error:NULL];
        
        NSMutableSet *tweetIDs = [[NSMutableSet alloc] initWithCapacity:[responseArray count]];
        for (NSDictionary *tweetDict in responseArray) {
            [tweetIDs addObject:[tweetDict objectForKey:@"id"]];
        }
        
        NSFetchRequest *existingRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
        existingRequest.predicate = [NSPredicate predicateWithFormat:@"remoteID in %@", tweetIDs];
        
        NSArray *existingTweets = [self.managedObjectContext executeFetchRequest:existingRequest error:nil];
        
        for (PDTweet *tweet in existingTweets) {
            [tweetIDs removeObject:tweet.remoteID];
        }
        
        NSEntityDescription *ent = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:self.managedObjectContext];
        for (NSDictionary *tweetDict in responseArray) {
            NSNumber *remoteID = [tweetDict objectForKey:@"id"];
            if ([tweetIDs containsObject:remoteID]) {
                PDTweet *newTweet = [[PDTweet alloc] initWithEntity:ent insertIntoManagedObjectContext:self.managedObjectContext];
                newTweet.remoteID = remoteID;
                newTweet.text = [tweetDict valueForKeyPath:@"text"];
                newTweet.retrievalDate = [NSDate date];
                
                NSNumber *userRemoteID = [tweetDict valueForKeyPath:@"user.id"];
                NSFetchRequest *existingUserRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
                existingUserRequest.predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", userRemoteID];
                
                PDUser *user = [[self.managedObjectContext executeFetchRequest:existingUserRequest error:NULL] lastObject];
                if (!user) {
                    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
                    user = [[PDUser alloc] initWithEntity:userEntity insertIntoManagedObjectContext:self.managedObjectContext];
                    user.remoteID = userRemoteID;
                    user.name = [tweetDict valueForKeyPath:@"user.name"];
                    user.screenName = [tweetDict valueForKeyPath:@"user.screen_name"];
                    user.profilePictureURL = [tweetDict valueForKeyPath:@"user.profile_image_url"];
                }
                
                newTweet.user = user;
            }
        }
        
        [self.managedObjectContext save:NULL];
    } failureBlock:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Request Failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)_reloadFeedWithSearchTerm:(NSString *)searchTerm;
{
    NSString *path = [NSString stringWithFormat:@"https://api.twitter.com/1/search.json?q=%@", [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self _fetchFromURL:[NSURL URLWithString:path] withSuccessBlock:^(NSURL *from, NSData *results) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingAllowFragments error:NULL];
        NSArray *responseArray = [responseDictionary objectForKey:@"results"];
        
        NSMutableSet *tweetIDs = [[NSMutableSet alloc] initWithCapacity:[responseArray count]];
        for (NSDictionary *tweetDict in responseArray) {
            [tweetIDs addObject:[tweetDict objectForKey:@"id"]];
        }
        
        NSFetchRequest *existingRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
        existingRequest.predicate = [NSPredicate predicateWithFormat:@"remoteID in %@", tweetIDs];
        
        NSArray *existingTweets = [self.managedObjectContext executeFetchRequest:existingRequest error:nil];
        
        for (PDTweet *tweet in existingTweets) {
            [tweetIDs removeObject:tweet.remoteID];
        }
        
        NSEntityDescription *ent = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:self.managedObjectContext];
        for (NSDictionary *tweetDict in responseArray) {
            NSNumber *remoteID = [tweetDict objectForKey:@"id"];
            if ([tweetIDs containsObject:remoteID]) {
                PDTweet *newTweet = [[PDTweet alloc] initWithEntity:ent insertIntoManagedObjectContext:self.managedObjectContext];
                newTweet.remoteID = remoteID;
                newTweet.text = [tweetDict valueForKeyPath:@"text"];
                newTweet.retrievalDate = [NSDate date];
                
                NSNumber *userRemoteID = [tweetDict valueForKeyPath:@"from_user_id"];
                NSFetchRequest *existingUserRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
                existingUserRequest.predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", userRemoteID];
                
                PDUser *user = [[self.managedObjectContext executeFetchRequest:existingUserRequest error:NULL] lastObject];
                if (!user) {
                    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
                    user = [[PDUser alloc] initWithEntity:userEntity insertIntoManagedObjectContext:self.managedObjectContext];
                    user.remoteID = userRemoteID;
                    user.name = [tweetDict valueForKeyPath:@"from_user_name"];
                    user.screenName = [tweetDict valueForKeyPath:@"from_user"];
                    user.profilePictureURL = [tweetDict valueForKeyPath:@"profile_image_url"];
                }
                
                newTweet.user = user;
            }
        }
        
        [self.managedObjectContext save:NULL];
    } failureBlock:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Request Failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (IBAction)_refresh:(UIBarButtonItem *)sender;
{
    [self _reloadFeed];
}

- (void)_fetchFromURL:(NSURL *) url withSuccessBlock:(PDSuccessBlock) successBlock failureBlock:(PDFailureBlock) failureBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];

    objc_setAssociatedObject(connection, PDSuccessBlockKey, successBlock, OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(connection, PDFailureBlockKey, failureBlock, OBJC_ASSOCIATION_COPY);

    [connection start];
}

@end
