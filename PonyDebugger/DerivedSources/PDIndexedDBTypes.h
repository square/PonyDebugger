#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


@class PDRuntimeRemoteObject;


// Security origin with database names.
@interface PDIndexedDBSecurityOriginWithDatabaseNames : PDObject

// Security origin.
// Type: string
@property (nonatomic, retain) NSString *securityOrigin;

// Database names for this origin.
// Type: array
@property (nonatomic, retain) NSArray *databaseNames;

@end


// Database with an array of object stores.
@interface PDIndexedDBDatabaseWithObjectStores : PDObject

// Database name.
// Type: string
@property (nonatomic, retain) NSString *name;

// Database version.
// Type: string
@property (nonatomic, retain) NSString *version;

// Object stores in this database.
// Type: array
@property (nonatomic, retain) NSArray *objectStores;

@end


// Object store.
@interface PDIndexedDBObjectStore : PDObject

// Object store name.
// Type: string
@property (nonatomic, retain) NSString *name;

// Object store key path.
// Type: string
@property (nonatomic, retain) NSString *keyPath;

// Indexes in this object store.
// Type: array
@property (nonatomic, retain) NSArray *indexes;

@end


// Object store index.
@interface PDIndexedDBObjectStoreIndex : PDObject

// Index name.
// Type: string
@property (nonatomic, retain) NSString *name;

// Index key path.
// Type: string
@property (nonatomic, retain) NSString *keyPath;

// If true, index is unique.
// Type: boolean
@property (nonatomic, retain) NSNumber *unique;

// If true, index allows multiple entries for a key.
// Type: boolean
@property (nonatomic, retain) NSNumber *multiEntry;

@end


// Key.
@interface PDIndexedDBKey : PDObject

// Key type.
// Type: string
@property (nonatomic, retain) NSString *type;

// Number value.
// Type: number
@property (nonatomic, retain) NSNumber *number;

// String value.
// Type: string
@property (nonatomic, retain) NSString *string;

// Date value.
// Type: number
@property (nonatomic, retain) NSNumber *date;

// Array value.
// Type: array
@property (nonatomic, retain) NSArray *array;

@end


// Key range.
@interface PDIndexedDBKeyRange : PDObject

// Lower bound.
@property (nonatomic, retain) PDIndexedDBKey *lower;

// Upper bound.
@property (nonatomic, retain) PDIndexedDBKey *upper;

// If true lower bound is open.
// Type: boolean
@property (nonatomic, retain) NSNumber *lowerOpen;

// If true upper bound is open.
// Type: boolean
@property (nonatomic, retain) NSNumber *upperOpen;

@end


// Key.
@interface PDIndexedDBDataEntry : PDObject

// Key.
@property (nonatomic, retain) PDIndexedDBKey *key;

// Primary key.
@property (nonatomic, retain) PDIndexedDBKey *primaryKey;

// Value.
@property (nonatomic, retain) PDRuntimeRemoteObject *value;

@end


