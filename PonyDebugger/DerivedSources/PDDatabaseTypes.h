#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


// Database object.
@interface PDDatabaseDatabase : PDObject

// Database ID.
// Type: string
@property (nonatomic, retain) NSString *identifier;

// Database domain.
// Type: string
@property (nonatomic, retain) NSString *domain;

// Database name.
// Type: string
@property (nonatomic, retain) NSString *name;

// Database version.
// Type: string
@property (nonatomic, retain) NSString *version;

@end


