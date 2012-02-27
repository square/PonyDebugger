//
//  PDViewController.m
//  PDwitterTest
//
//  Created by Mike Lewis on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PDViewController.h"
#import "PDTweet.h"
#import "AFNetworking.h"

@interface PDViewController () <NSFetchedResultsControllerDelegate, NSURLConnectionDataDelegate> 
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@end

@implementation PDViewController {
    NSFetchedResultsController *_resultsController;
    AFHTTPClient *_client;
}
@synthesize refreshButton = _refreshButton;

@synthesize managedObjectContext = _managedObjectContext;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _client = [[AFHTTPClient alloc] initWithBaseURL:[[NSURL alloc] initWithString:@"https://api.twitter.com/1/"]];
        [_client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    return self;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"remoteID" ascending:NO]];
    
    _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _resultsController.delegate = self;
    [_resultsController performFetch:nil];
}

- (void)viewDidUnload
{
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)_reloadFeed;
{
    [_client getPath:@"statuses/public_timeline.json?count=30" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArray = responseObject;
        
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
                newTweet.userName = [tweetDict valueForKeyPath:@"user.name"];
                newTweet.text = [tweetDict valueForKeyPath:@"text"];
            }
        }
        
        [self.managedObjectContext save:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Request Failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }];
}

#pragma mark - Flipside View Controller


/*
 Assume self has a property 'tableView' -- as is the case for an instance of a UITableViewController
 subclass -- and a method configureCell:atIndexPath: which updates the contents of a given cell
 with information from a managed object at the given index path in the fetched results controller.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
{
    PDTweet *tweet = [_resultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tweet.text;
    cell.detailTextLabel.text = tweet.userName;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"tweet"];
    
    return tweetCell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    assert(section == 0);
    return _resultsController.fetchedObjects.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self configureCell:cell atIndexPath:indexPath];
}

- (IBAction)refresh:(UIBarButtonItem *)sender
{
    [self _reloadFeed];
}


@end
