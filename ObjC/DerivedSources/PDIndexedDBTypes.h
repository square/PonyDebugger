//    
//  PDIndexedDBTypes.h
//  PonyDebuggerDerivedSources
//
//  Generated on 7/10/15
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//
    
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


@class PDIndexedDBKeyPath;


/// Database with an array of object stores.
@interface PDIndexedDBDatabaseWithObjectStores : PDObject

/// Database name.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// Deprecated string database version.
/// Type: string
@property (nonatomic, strong) NSString *version;

/// Integer database version.
/// Type: integer
@property (nonatomic, strong) NSNumber *intVersion;

/// Object stores in this database.
/// Type: array
@property (nonatomic, strong) NSArray *objectStores;

@end


/// Object store.
@interface PDIndexedDBObjectStore : PDObject

/// Object store name.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// Object store key path.
@property (nonatomic, strong) PDIndexedDBKeyPath *keyPath;

/// If true, object store has auto increment flag set.
/// Type: boolean
@property (nonatomic, strong) NSNumber *autoIncrement;

/// Indexes in this object store.
/// Type: array
@property (nonatomic, strong) NSArray *indexes;

@end


/// Object store index.
@interface PDIndexedDBObjectStoreIndex : PDObject

/// Index name.
/// Type: string
@property (nonatomic, strong) NSString *name;

/// Index key path.
@property (nonatomic, strong) PDIndexedDBKeyPath *keyPath;

/// If true, index is unique.
/// Type: boolean
@property (nonatomic, strong) NSNumber *unique;

/// If true, index allows multiple entries for a key.
/// Type: boolean
@property (nonatomic, strong) NSNumber *multiEntry;

@end


/// Key.
@interface PDIndexedDBKey : PDObject

/// Key type.
/// Type: string
@property (nonatomic, strong) NSString *type;

/// Number value.
/// Type: number
@property (nonatomic, strong) NSNumber *number;

/// String value.
/// Type: string
@property (nonatomic, strong) NSString *string;

/// Date value.
/// Type: number
@property (nonatomic, strong) NSNumber *date;

/// Array value.
/// Type: array
@property (nonatomic, strong) NSArray *array;

@end


/// Key range.
@interface PDIndexedDBKeyRange : PDObject

/// Lower bound.
@property (nonatomic, strong) PDIndexedDBKey *lower;

/// Upper bound.
@property (nonatomic, strong) PDIndexedDBKey *upper;

/// If true lower bound is open.
/// Type: boolean
@property (nonatomic, strong) NSNumber *lowerOpen;

/// If true upper bound is open.
/// Type: boolean
@property (nonatomic, strong) NSNumber *upperOpen;

@end


/// Data entry.
@interface PDIndexedDBDataEntry : PDObject

/// JSON-stringified key object.
/// Type: string
@property (nonatomic, strong) NSString *key;

/// JSON-stringified primary key object.
/// Type: string
@property (nonatomic, strong) NSString *primaryKey;

/// JSON-stringified value object.
/// Type: string
@property (nonatomic, strong) NSString *value;

@end


/// Key path.
@interface PDIndexedDBKeyPath : PDObject

/// Key path type.
/// Type: string
@property (nonatomic, strong) NSString *type;

/// String value.
/// Type: string
@property (nonatomic, strong) NSString *string;

/// Array value.
/// Type: array
@property (nonatomic, strong) NSArray *array;

@end


