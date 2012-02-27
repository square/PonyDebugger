#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>

@class PDDatabaseDatabase;

@protocol PDDatabaseCommandDelegate;

@interface PDDatabaseDomain : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <PDDatabaseCommandDelegate, PDCommandDelegate> delegate;

// Events
- (void)addDatabaseWithDatabase:(PDDatabaseDatabase *)database;
- (void)sqlTransactionSucceededWithTransactionId:(NSNumber *)transactionId columnNames:(NSArray *)columnNames values:(NSArray *)values;
- (void)sqlTransactionFailedWithTransactionId:(NSNumber *)transactionId sqlError:(NSDictionary *)sqlError;

@end

@protocol PDDatabaseCommandDelegate <PDCommandDelegate>
@optional

// Enables database tracking, database events will now be delivered to the client.
- (void)domain:(PDDatabaseDomain *)domain enableWithCallback:(void (^)(id error))callback;

// Disables database tracking, prevents database events from being sent to the client.
- (void)domain:(PDDatabaseDomain *)domain disableWithCallback:(void (^)(id error))callback;
- (void)domain:(PDDatabaseDomain *)domain getDatabaseTableNamesWithDatabaseId:(NSNumber *)databaseId callback:(void (^)(NSArray *tableNames, id error))callback;
- (void)domain:(PDDatabaseDomain *)domain executeSQLWithDatabaseId:(NSNumber *)databaseId query:(NSString *)query callback:(void (^)(NSNumber *success, NSNumber *transactionId, id error))callback;

@end

@interface PDDebugger (PDDatabaseDomain)

@property (nonatomic, readonly, retain) PDDatabaseDomain *databaseDomain;

@end
