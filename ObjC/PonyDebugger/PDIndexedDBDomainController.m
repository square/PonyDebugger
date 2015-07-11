//
//  PDDatabaseDomainController.m
//  PonyDebugger
//
//  Created by Mike Lewis on 2/29/12.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "PDIndexedDBDomainController.h"
#import "PDRuntimeDomainController.h"
#import "PDIndexedDBTypes.h"
#import "PDRuntimeTypes.h"

#import <CoreData/CoreData.h>


static NSString *const PDManagedObjectContextNameUserInfoKey = @"PDManagedObjectContextName";


@interface PDIndexedDBDomainController ()

@property (nonatomic, strong) NSMutableArray *managedObjectContexts;

- (NSManagedObjectContext *)_managedObjectContextForName:(NSString *)name;
- (NSString *)_databaseNameForManagedObjectContext:(NSManagedObjectContext *)context;

@end


@implementation PDIndexedDBDomainController

@dynamic domain;

@synthesize managedObjectContexts = _managedObjectContexts;

#pragma mark - Statics

+ (PDIndexedDBDomainController *)defaultInstance;
{
    static PDIndexedDBDomainController *defaultInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultInstance = [[PDIndexedDBDomainController alloc] init];
    });
    
    return defaultInstance;
}

+ (Class)domainClass;
{
    return [PDIndexedDBDomain class];
}

#pragma mark - Initialization

- (id)init;
{
    self = [super init];
    if (self) {
        self.managedObjectContexts = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc;
{
    self.managedObjectContexts = nil;
}

#pragma mark - PDIndexedDBCommandDelegate


- (void)domain:(PDIndexedDBDomain *)domain requestDatabaseNamesWithSecurityOrigin:(NSString *)securityOrigin callback:(void (^)(NSArray *, id))callback;
{
    callback(self._databaseNames, nil);
}

/// Since NSJSONSerialization doesn't allow root objects to be strings, we're going to be lazy and put it in an array then trim it
- (NSString *)_escapeJSONString:(NSString *)unescapedString;
{
    static NSCharacterSet *characterSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        characterSet = [NSCharacterSet characterSetWithCharactersInString:@"[] "];
    });
    NSString *str =  [[NSString alloc]
            initWithData:[NSJSONSerialization dataWithJSONObject:@[unescapedString] options:0 error:NULL]
            encoding:NSUTF8StringEncoding];
    return [str stringByTrimmingCharactersInSet:characterSet];
}

- (void)domain:(PDIndexedDBDomain *)domain requestDataWithSecurityOrigin:(NSString *)securityOrigin databaseName:(NSString *)databaseName objectStoreName:(NSString *)objectStoreName indexName:(NSString *)indexName skipCount:(NSNumber *)skipCount pageSize:(NSNumber *)pageSize keyRange:(PDIndexedDBKeyRange *)keyRange callback:(void (^)(NSArray *objectStoreDataEntries, NSNumber *hasMore, id error))callback;
{
    NSManagedObjectContext *context = [self _managedObjectContextForName:databaseName];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:objectStoreName];
    
    // Don't show subentities if it's not an abstract entity.
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:objectStoreName inManagedObjectContext:context];
    if (![entityDescription isAbstract]) {
        fetchRequest.includesSubentities = NO;
    }
    
    NSInteger totalCount = [context countForFetchRequest:fetchRequest error:NULL];
    
    fetchRequest.fetchOffset = [skipCount integerValue];
    fetchRequest.fetchLimit = [pageSize integerValue];
    
    NSArray *results = [context executeFetchRequest:fetchRequest error:NULL];
    NSMutableArray *dataEntries = [[NSMutableArray alloc] initWithCapacity:results.count];
    
    for (NSManagedObject *object in results) {
        PDIndexedDBDataEntry *dataEntry = [[PDIndexedDBDataEntry alloc] init];
        
        
        dataEntry.primaryKey = [self _escapeJSONString:object.objectID.URIRepresentation.absoluteString];
        
        if (indexName.length > 0) {
            dataEntry.key = [object valueForKey:indexName];
        } else {
            dataEntry.key = dataEntry.primaryKey;
        }
        
        PDRuntimeRemoteObject *remoteObject = [[PDRuntimeRemoteObject alloc] init];
        remoteObject.objectId = [[PDRuntimeDomainController defaultInstance] registerAndGetKeyForObject:object];
        remoteObject.type = @"object";
        remoteObject.classNameString = remoteObject.objectDescription = objectStoreName;
        
        NSMutableDictionary *values = [NSMutableDictionary new];
        
        for (NSPropertyDescription *propertyDescription in object.entity.properties) {

            id val = [object valueForKey:propertyDescription.name];

            if (val) {
                if ([propertyDescription isKindOfClass:[NSAttributeDescription class]]) {
                    values[propertyDescription.name] = [val PD_JSONObject];
                } else if ([propertyDescription isKindOfClass:[NSRelationshipDescription class]]) {
                    NSRelationshipDescription *rel = (id)propertyDescription;

                    if (rel.isToMany) {
                        NSMutableArray *newVals = [NSMutableArray new];
                        for (NSManagedObject *element in (NSSet *)val) {
                            values[propertyDescription.name] = [element objectID].URIRepresentation.absoluteString;
                        }
                    } else {
                        values[propertyDescription.name] = [val objectID].URIRepresentation.absoluteString;
                    }
                }
            } else {
                values[propertyDescription.name] = [NSNull null];
            }

        }
        
        dataEntry.value = [[NSString alloc]
                           initWithData:[NSJSONSerialization dataWithJSONObject:values options:0 error:NULL]
                           encoding:NSUTF8StringEncoding];
        
        [dataEntries addObject:dataEntry];
    }
    
    NSNumber *hasMore = @(fetchRequest.fetchOffset + results.count < totalCount);
    if (fetchRequest.fetchOffset + results.count >= totalCount) {
        hasMore = [NSNumber numberWithBool:NO];
    }
    
    callback(dataEntries, hasMore, nil);
}

- (void)domain:(PDIndexedDBDomain *)domain requestDatabaseWithSecurityOrigin:(NSString *)securityOrigin databaseName:(NSString *)databaseName callback:(void (^)(PDIndexedDBDatabaseWithObjectStores *, id))callback;
{
    callback([self _databaseInContext:[self _managedObjectContextForName:databaseName]], nil);
}

#pragma mark - Public Methods

- (void)addManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSString *name = [self _databaseNameForManagedObjectContext:context];
    [self addManagedObjectContext:context withName:name];
}

- (void)addManagedObjectContext:(NSManagedObjectContext *)context withName:(NSString *)name;
{
    [context.userInfo setObject:name forKey:PDManagedObjectContextNameUserInfoKey];
    [_managedObjectContexts addObject:context];
}

- (void)removeManagedObjectContext:(NSManagedObjectContext *)context;
{
    [self.managedObjectContexts removeObject:context];
}

#pragma mark - Private Methods

- (NSManagedObjectContext *)_managedObjectContextForName:(NSString *)name;
{
    for (NSManagedObjectContext *context in self.managedObjectContexts) {
        if ([[context.userInfo objectForKey:PDManagedObjectContextNameUserInfoKey] isEqualToString:name]) {
            return context;
        }
    }
    
    return nil;
}

- (NSString *)_databaseNameForManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    for (NSPersistentStore *store in context.persistentStoreCoordinator.persistentStores) {
        NSURL *url = [context.persistentStoreCoordinator URLForPersistentStore:store];
        NSString *pathString = [url.lastPathComponent stringByDeletingPathExtension];
        if (pathString) {
            [paths addObject:pathString];
        }
    }
    
    return [paths componentsJoinedByString:@":"];
}

- (NSArray *)_databaseNames;
{
    NSMutableArray *dbNames = [[NSMutableArray alloc] initWithCapacity:_managedObjectContexts.count];

    [self.managedObjectContexts enumerateObjectsUsingBlock:^(NSManagedObjectContext *context, NSUInteger idx, BOOL *stop) {
        [dbNames addObject:context.userInfo[PDManagedObjectContextNameUserInfoKey]];
    }];
    
    return dbNames;
}

- (PDIndexedDBDatabaseWithObjectStores *)_databaseInContext:(NSManagedObjectContext *)context;
{
    NSMutableArray *objectStores = [[NSMutableArray alloc] init];
    
    for (NSEntityDescription *entity in context.persistentStoreCoordinator.managedObjectModel.entities) {
        PDIndexedDBObjectStore *objectStore = [[PDIndexedDBObjectStore alloc] init];
        
        PDIndexedDBKeyPath *keyPath = [[PDIndexedDBKeyPath alloc] init];
        keyPath.type = @"string";
        keyPath.string = @"objectID";
        
        objectStore.keyPath = keyPath;
        
        NSMutableArray *indexes = [[NSMutableArray alloc] init];
        for (NSAttributeDescription *property in [[entity attributesByName] allValues]) {
            if ([property isIndexed]) {
                PDIndexedDBObjectStoreIndex *index = [[PDIndexedDBObjectStoreIndex alloc] init];
                index.name = property.name;
                
                PDIndexedDBKeyPath *guidKeyPath = [[PDIndexedDBKeyPath alloc] init];
                guidKeyPath.type = @"string";
                guidKeyPath.string = property.name;
                
                index.keyPath = guidKeyPath;
                index.unique = [NSNumber numberWithBool:NO];
                index.multiEntry = [NSNumber numberWithBool:NO];
                
                [indexes addObject:index];
            }
        }
        objectStore.indexes = indexes;
        
        objectStore.autoIncrement = [NSNumber numberWithBool:NO];
        objectStore.name = entity.name;
        
        [objectStores addObject:objectStore];
    }
       
    PDIndexedDBDatabaseWithObjectStores *db = [[PDIndexedDBDatabaseWithObjectStores alloc] init];
    
    db.name = [self _databaseNameForManagedObjectContext:context];
    db.version = @"N/A";
    db.objectStores = objectStores;
    
    return db;
}

@end
