//
//  PDDatabaseDomainController.m
//  PonyDebugger
//
//  Created by Mike Lewis on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDDatabaseDomainController.h"
#import "PDDatabaseTypes.h"
#import <CoreData/CoreData.h>

@implementation PDDatabaseDomainController {
    NSMutableDictionary *_managedObjectContexts;
}

@dynamic domain;

+ (PDDatabaseDomainController *)defaultInstance;
{
    static PDDatabaseDomainController *defaultInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultInstance = [[PDDatabaseDomainController alloc] init];
    });
    
    return defaultInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _managedObjectContexts = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)_broadcastDatabase:(NSManagedObjectContext *)context withKey:(NSNumber *)key;
{
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    for (NSPersistentStore *store in context.persistentStoreCoordinator.persistentStores) {
        [paths addObject:[context.persistentStoreCoordinator URLForPersistentStore:store].lastPathComponent];
    }
    NSString *name = [paths componentsJoinedByString:@":"];
        
    PDDatabaseDatabase *database = [[PDDatabaseDatabase alloc] init];
    database.domain = @"";
    database.version = @"1.0";
    database.name = name;
    database.identifier = (id)key;
    
    [self.domain addDatabaseWithDatabase:database];
}

- (void)addManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSNumber *key = [NSNumber numberWithInteger:context.persistentStoreCoordinator.hash];
    [_managedObjectContexts setObject:context forKey:key];
    if (self.enabled) {
        [self _broadcastDatabase:context withKey:key];
    }
}

- (void)removeManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSNumber *key = [NSNumber numberWithInteger:context.persistentStoreCoordinator.hash];
    [_managedObjectContexts removeObjectForKey:key];
}

#pragma mard Delegate Methods


- (void)domain:(PDDynamicDebuggerDomain *)domain enableWithCallback:(void (^)(id))callback;
{
    [super domain:domain enableWithCallback:callback];
    [_managedObjectContexts enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self _broadcastDatabase:obj withKey:key];
    }];
}

- (void)domain:(PDDatabaseDomain *)domain getDatabaseTableNamesWithDatabaseId:(NSNumber *)databaseId callback:(void (^)(NSArray *tableNames, id error))callback
{
    NSMutableArray *tableNames = [NSMutableArray array];
    
    NSManagedObjectContext *context = [_managedObjectContexts objectForKey:databaseId];
    
    for (NSEntityDescription *entity in [context.persistentStoreCoordinator.managedObjectModel entities]) {
        [tableNames addObject:entity.name];
    }
    
    callback(tableNames, nil);
}

- (void)domain:(PDDatabaseDomain *)domain executeSQLWithDatabaseId:(NSNumber *)databaseId query:(NSString *)query callback:(void (^)(NSNumber *success, NSNumber *transactionId, id error))callback
{
    // this should be save because it's all being called on the main thread, however, TODO and fix this
    static int xid = 0;
    
    // TODO: Add a better grammar
    NSRegularExpression *queryExpression = [[NSRegularExpression alloc]
                                            initWithPattern:@"select (.*) from \"?([^\";]*)\"?(?: where (.*)?)?(?: order by (.*)( desc)?)?;?" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [queryExpression firstMatchInString:query options:0 range:NSMakeRange(0, query.length)];
    
    //    NSString selectList = [match rangeAtIndex:0];
    NSString *fromList = [query substringWithRange:[match rangeAtIndex:2]];
    
    NSString *entityName = [fromList stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSManagedObjectContext *context = [_managedObjectContexts objectForKey:databaseId];
    
    NSError *error = nil;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    BOOL success = !error;
    
    NSNumber *_xid = [NSNumber numberWithInt:xid];
    xid++;
    
    callback([NSNumber numberWithBool:success], _xid, nil);
    
    NSMutableArray *columnNames = [[NSMutableArray alloc] initWithObjects:@"objectID", nil];
    
    [columnNames addObjectsFromArray:[[entity propertiesByName] allKeys]];
    
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:results.count];
    
    for (NSManagedObject *result in results) {
        for (NSString *columnName in columnNames) {
            id val = [result valueForKey:columnName];
            [values addObject:val == nil ? [NSNull null] : [val description]];
        }
    }
    
    
    [domain sqlTransactionSucceededWithTransactionId:_xid columnNames:columnNames values:values];
}

+ (Class)domainClass;
{
    return [PDDatabaseDomain class];
}

@end
