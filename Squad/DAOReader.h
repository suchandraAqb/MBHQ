//
//  DAOReader.h
//  datacrunch
//
//  Created by aqb Solutions on 26/10/12.
//  Copyright (c) 2012 DataCrunch.me. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DAOReader : NSObject{

    NSManagedObjectContext *managedObjectContext;
    sqlite3 *connectDb;
    sqlite3_stmt  *statement;
}

+ (instancetype)sharedInstance;
- (BOOL)connectionStart;
- (void)startTransaction;
- (void)commitTransaction;
- (void)rollBackTransaction;
- (void)connectionEnd;
- (Boolean)delete:(NSString *)tableName forId:(NSString *)rowIds;
- (Boolean)deleteWhen:(NSString *)tableName whereCondition:(NSString *)condition; 
- (int)insert:(NSString *)tableName withColumn:(NSArray *)column forValue:(NSArray *)value;
- (NSMutableArray*)selectBy:(NSString *)tableName withColumn:(NSArray*)column whereCondition:(NSString *)condition;
- (NSMutableArray*)selectByQuery:(NSArray*)column query:(NSString *)querySQL;
-(NSMutableDictionary*)selectByQueryInKeyValue:(NSArray*)column query:(NSString *)querySQL;
- (Boolean)deleteUsingQuery:(NSString *)querySQL;
- (void) makeDBCopy;
-(Boolean)truncate:(NSString *)tableName;
-(BOOL)updateWithCondition:(NSString *)tableName withColumn:(NSArray *)column forValue:(NSArray *)value conditionString:(NSString *)conditionString;
-(Boolean)delete:(NSString *)tableName;
-(int)updateAnnotate:(NSString *)tableName withColumn:(NSArray *)column forValue:(NSArray *)value forId:(NSString *)rowId;
-(NSMutableArray*)selectByQueryInKey:(NSArray*)column query:(NSString *)querySQL key:(NSString *)key;
-(BOOL)selectByTable:(NSString *)tableName;
-(Boolean)createTableDBForWebniarList;
-(Boolean)createTableDBForWebniarSelected;
-(Boolean)createTableDBForNonQued;
-(Boolean)createTableDBForGuided;
-(Boolean)createTableDBForDropdown;
-(BOOL)checkColumnExists:(NSString*)columeName with:(NSString*)tableName;
-(BOOL)alterTable:(NSString *)tableName withColumn:(NSString *)column withColumTYPE:(BOOL)type;
@end
