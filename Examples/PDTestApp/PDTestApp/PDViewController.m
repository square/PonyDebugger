//
//  PDViewController.m
//  PDTestApp
//
//  Created by Mike Lewis on 11/9/11.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PonyDebugger.h>

#import "PDViewController.h"
#import "PDRepo.h"
#import "PDOwner.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"


#pragma mark - Private Interface

@interface PDViewController () <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *refreshButton;

- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (IBAction)_refresh:(UIBarButtonItem *)sender;

@end


#pragma mark - Implementation

@implementation PDViewController {
    NSFetchedResultsController *_resultsController;
    AFHTTPRequestOperationManager *_requestOperationManager;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize refreshButton = _refreshButton;
@synthesize searchBar = _searchBar;

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super initWithCoder:coder];
    if (self) {
        _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.github.com/"]];
    }
    
    return self;
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
    
    self.searchBar.text = @"square";
    [self _reloadReposWithSearchTerm:self.searchBar.text];
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
    __weak UITableViewCell *weakCell = cell;
    [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:repo.owner.avatarURL]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakCell.imageView.image = image;
        [weakCell setNeedsLayout];
    } failure:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ by %@", repo.name, repo.owner.login];
}

- (void)_reloadReposWithSearchTerm:(NSString *)searchTerm;
{
    NSString *path = [NSString stringWithFormat:@"users/%@/repos", [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [_requestOperationManager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseArray) {

        NSMutableSet *repoIDs = [[NSMutableSet alloc] initWithCapacity:[responseArray count]];
        for (NSDictionary *repoDict in responseArray) {
            [repoIDs addObject:[repoDict objectForKey:@"id"]];
        }

        NSFetchRequest *existingRequest = [NSFetchRequest fetchRequestWithEntityName:@"Repo"];
        existingRequest.predicate = [NSPredicate predicateWithFormat:@"remoteID in %@", repoIDs];

        NSArray *existingRepos = [self.managedObjectContext executeFetchRequest:existingRequest error:nil];

        for (PDRepo *repo in existingRepos) {
            [repoIDs removeObject:repo.remoteID];
        }

        PDLogObjects(@"Response array:", responseArray);

        NSEntityDescription *ent = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.managedObjectContext];
        for (NSDictionary *repoDict in responseArray) {
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Request Failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (IBAction)_refresh:(UIBarButtonItem *)sender;
{
    [self _reloadReposWithSearchTerm:self.searchBar.text];
    
    // PDLog() takes the same string/argument formatting as NSLog().
    // PDLogD() formats it with debug formatting.
    PDLogD(@"Reloading repos with search term: %@.", self.searchBar.text);
}

@end