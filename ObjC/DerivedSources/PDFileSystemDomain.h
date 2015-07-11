//
//  PDFileSystemDomain.h
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

@class PDFileSystemEntry;
@class PDFileSystemMetadata;

@protocol PDFileSystemCommandDelegate;

@interface PDFileSystemDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDFileSystemCommandDelegate, PDCommandDelegate> delegate;

@end

@protocol PDFileSystemCommandDelegate <PDCommandDelegate>
@optional

/// Enables events from backend.
- (void)domain:(PDFileSystemDomain *)domain enableWithCallback:(void (^)(id error))callback;

/// Disables events from backend.
- (void)domain:(PDFileSystemDomain *)domain disableWithCallback:(void (^)(id error))callback;

/// Returns root directory of the FileSystem, if exists.
// Param origin: Security origin of requesting FileSystem. One of frames in current page needs to have this security origin.
// Param type: FileSystem type of requesting FileSystem.
// Callback Param errorCode: 0, if no error. Otherwise, errorCode is set to FileError::ErrorCode value.
// Callback Param root: Contains root of the requested FileSystem if the command completed successfully.
- (void)domain:(PDFileSystemDomain *)domain requestFileSystemRootWithOrigin:(NSString *)origin type:(NSString *)type callback:(void (^)(NSNumber *errorCode, PDFileSystemEntry *root, id error))callback;

/// Returns content of the directory.
// Param url: URL of the directory that the frontend is requesting to read from.
// Callback Param errorCode: 0, if no error. Otherwise, errorCode is set to FileError::ErrorCode value.
// Callback Param entries: Contains all entries on directory if the command completed successfully.
- (void)domain:(PDFileSystemDomain *)domain requestDirectoryContentWithUrl:(NSString *)url callback:(void (^)(NSNumber *errorCode, NSArray *entries, id error))callback;

/// Returns metadata of the entry.
// Param url: URL of the entry that the frontend is requesting to get metadata from.
// Callback Param errorCode: 0, if no error. Otherwise, errorCode is set to FileError::ErrorCode value.
// Callback Param metadata: Contains metadata of the entry if the command completed successfully.
- (void)domain:(PDFileSystemDomain *)domain requestMetadataWithUrl:(NSString *)url callback:(void (^)(NSNumber *errorCode, PDFileSystemMetadata *metadata, id error))callback;

/// Returns content of the file. Result should be sliced into [start, end).
// Param url: URL of the file that the frontend is requesting to read from.
// Param readAsText: True if the content should be read as text, otherwise the result will be returned as base64 encoded text.
// Param start: Specifies the start of range to read.
// Param end: Specifies the end of range to read exclusively.
// Param charset: Overrides charset of the content when content is served as text.
// Callback Param errorCode: 0, if no error. Otherwise, errorCode is set to FileError::ErrorCode value.
// Callback Param content: Content of the file.
// Callback Param charset: Charset of the content if it is served as text.
- (void)domain:(PDFileSystemDomain *)domain requestFileContentWithUrl:(NSString *)url readAsText:(NSNumber *)readAsText start:(NSNumber *)start end:(NSNumber *)end charset:(NSString *)charset callback:(void (^)(NSNumber *errorCode, NSString *content, NSString *charset, id error))callback;

/// Deletes specified entry. If the entry is a directory, the agent deletes children recursively.
// Param url: URL of the entry to delete.
// Callback Param errorCode: 0, if no error. Otherwise errorCode is set to FileError::ErrorCode value.
- (void)domain:(PDFileSystemDomain *)domain deleteEntryWithUrl:(NSString *)url callback:(void (^)(NSNumber *errorCode, id error))callback;

@end

@interface PDDebugger (PDFileSystemDomain)

@property (nonatomic, readonly, strong) PDFileSystemDomain *fileSystemDomain;

@end
