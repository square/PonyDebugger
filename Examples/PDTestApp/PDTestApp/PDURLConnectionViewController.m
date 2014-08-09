//
//  PDURLConnectionViewController.m
//  PDTestApp
//
//  Created by Mike Lewis on 11/9/11.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PonyDebugger.h>

#import "PDURLConnectionViewController.h"
#import "PDRepo.h"
#import "PDOwner.h"

#pragma mark - Private Interface

@interface PDURLConnectionViewController () <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, NSURLConnectionDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end


#pragma mark - Implementation

@implementation PDURLConnectionViewController {
    NSFetchedResultsController *_resultsController;
    NSMutableData *_responseData;
}

#pragma mark - UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Repo"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObjects:
                                    [NSSortDescriptor sortDescriptorWithKey:@"lastUpdated" ascending:NO],
                                    [NSSortDescriptor sortDescriptorWithKey:@"remoteID" ascending:NO],
                                    nil];
    
    _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _resultsController.delegate = self;
    [_resultsController performFetch:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(_refresh:) forControlEvents:UIControlEventValueChanged];
    
    self.searchBar.text = @"square";
    [self _reloadReposWithSearchTerm:self.searchBar.text];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [self.searchBar resignFirstResponder];
    [self _reloadReposWithSearchTerm:searchBar.text];
    
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
    static NSString *CellIdentifier = @"PDRepoCell";
    UITableViewCell *repoCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    return repoCell;
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
    cell.textLabel.text = repo.name;
    cell.detailTextLabel.text = repo.owner.login;
}

- (void)_reloadReposWithSearchTerm:(NSString *)searchTerm;
{
    NSString *URLString = [NSString stringWithFormat:@"https://api.github.com/users/%@/repos", [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]] delegate:self];
}

- (IBAction)_refresh:(UIBarButtonItem *)sender;
{
    [self _reloadReposWithSearchTerm:self.searchBar.text];
    
    // PDLog() takes the same string/argument formatting as NSLog().
    // PDLogD() formats it with debug formatting.
    PDLogD(@"Reloading repos with search term: %@.", self.searchBar.text);
}

- (void)displayRepos:(NSArray *)repoArray
{
    NSMutableSet *repoIDs = [[NSMutableSet alloc] initWithCapacity:[repoArray count]];
    for (NSDictionary *repoDict in repoArray) {
        [repoIDs addObject:[repoDict objectForKey:@"id"]];
    }
    
    NSFetchRequest *existingRequest = [NSFetchRequest fetchRequestWithEntityName:@"Repo"];
    existingRequest.predicate = [NSPredicate predicateWithFormat:@"remoteID in %@", repoIDs];
    
    NSArray *existingRepos = [self.managedObjectContext executeFetchRequest:existingRequest error:nil];
    
    for (PDRepo *repo in existingRepos) {
        [repoIDs removeObject:repo.remoteID];
    }
    
    PDLogObjects(@"Response array:", repoArray);
    
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.managedObjectContext];
    for (NSDictionary *repoDict in repoArray) {
        NSNumber *remoteID = [repoDict objectForKey:@"id"];
        if ([repoIDs containsObject:remoteID]) {
            PDRepo *repo = [[PDRepo alloc] initWithEntity:ent insertIntoManagedObjectContext:self.managedObjectContext];
            repo.remoteID = remoteID;
            repo.name = [repoDict valueForKeyPath:@"name"];
            repo.lastUpdated = [NSDate date];
            
            NSNumber *ownerRemoteID = [repoDict valueForKeyPath:@"owner.id"];
            NSFetchRequest *existingUserRequest = [NSFetchRequest fetchRequestWithEntityName:@"Owner"];
            existingUserRequest.predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", ownerRemoteID];
            
            PDOwner *owner = [[self.managedObjectContext executeFetchRequest:existingUserRequest error:NULL] lastObject];
            if (!owner) {
                NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"Owner" inManagedObjectContext:self.managedObjectContext];
                owner = [[PDOwner alloc] initWithEntity:userEntity insertIntoManagedObjectContext:self.managedObjectContext];
                owner.remoteID = ownerRemoteID;
                owner.login = [repoDict valueForKeyPath:@"owner.login"];
                owner.avatarURL = [repoDict valueForKeyPath:@"owner.avatar_url"];
            }
            
            repo.owner = owner;
        }
    }
    
    [self.managedObjectContext save:NULL];
}

- (void)displayError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Request Failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        [self displayError:error];
        [self.refreshControl endRefreshing];
        return;
    }
    
    [self displayRepos:responseArray];
    [self.refreshControl endRefreshing];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self displayError:error];
    [self.refreshControl endRefreshing];
}

@end