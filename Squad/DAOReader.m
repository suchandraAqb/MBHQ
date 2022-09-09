//
//  DAOReader.m
//  datacrunch
//
//  Created by aqb Solutions on 26/10/12.
//  Copyright (c) 2012 DataCrunch.me. All rights reserved.
//

#import "DAOReader.h"


@implementation DAOReader

+ (instancetype)sharedInstance
{
    static DAOReader *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DAOReader alloc] init];
        // Do any other initialisation stuff here
        [sharedInstance makeDBCopy];
    });
    return sharedInstance;
}


/**********************************************
 *
 *Common DAO methods (connectionStart/connectionEnd/insert/update
                      /select/selectBy/delete/deleteAll)
 *
 ************************************************/


//for copying database to documents directory
//this database contains the table with no values

- (void) makeDBCopy
{
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DBNAME];
    
    NSLog(@"DBPATH-%@",writableDBPath);
    
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success)
	{
		return;
	}
    
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBNAME];
    
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success)
	{
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}


-(BOOL)connectionStart
{
    BOOL isStart = false;
      int sqlite3_open(const char *filename, sqlite3 **database);
      //NSLog(@"DBPath-%@",[utilityObject getDBPath:DBNAME ]);
      const char *dbpath = [[Utility getDBPath:DBNAME] UTF8String]; // Convert NSString to UTF-8
      if(sqlite3_open(dbpath, &connectDb) == SQLITE_OK){
          NSLog(@"Database Opened Successfully");
          isStart = true;
      }else{
          NSLog(@"Database failed to open ");
      }
      
      return isStart;
      
}

//Transaction

-(void)startTransaction{
    
    sqlite3_exec(connectDb,"BEGIN", 0, 0, 0);
    
}
-(void)commitTransaction{
    
    sqlite3_exec(connectDb,"COMMIT", 0, 0, 0);
    
}
-(void)rollBackTransaction{ 
    
    sqlite3_exec(connectDb,"ROLLBACK", 0, 0, 0);
}

//Transaction

-(void)connectionEnd
{
    if(statement!=NULL){
        //sqlite3_finalize(statement);
        
    }
    if(connectDb!=NULL){
        sqlite3_close(connectDb);
        
    }
}
-(Boolean)delete:(NSString *)tableName forId:(NSString *)rowIds
{
    Boolean status=NO;
    
    NSString *querySQL = [@"" stringByAppendingFormat:@"delete from %@ where id  in (%@) ",tableName,rowIds];
    
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
    
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        status =YES;
        
    }
    if(statement!=NULL)
     sqlite3_reset(statement);
    
    return status;
    
}

-(Boolean)delete:(NSString *)tableName
{
    Boolean status=NO;
    
    NSString *querySQL = [@"" stringByAppendingFormat:@"DELETE FROM %@ ",tableName];
    
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
    
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        status =YES;
        
    }
    if(statement!=NULL)
        sqlite3_reset(statement);
    
    //NSLog(@"%s Delete failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(connectDb), sqlite3_errcode(connectDb));
    
    return status;
    
}
-(Boolean)createTableDBForWebniarList{
    BOOL isStart = false;
         int sqlite3_open(const char *filename, sqlite3 **database);
         const char *dbpath = [[Utility getDBPath:DBNAME] UTF8String]; // Convert NSString to UTF-8
         if(sqlite3_open(dbpath, &connectDb) == SQLITE_OK){
             const char *sql_stmt = "CREATE TABLE IF NOT EXISTS webniarListDetails (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, UserId    INTEGER NOT NULL, Details TEXT)";
                sqlite3_prepare_v2(connectDb, sql_stmt, -1, &statement, NULL);
                
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    isStart =YES;
                    
                }
                if(statement!=NULL)
                    sqlite3_reset(statement);
                
                //NSLog(@"%s Delete failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(connectDb), sqlite3_errcode(connectDb));
                
                return isStart;
         }else{
             NSLog(@"Database failed to open ");
         }
         return isStart;
}
-(Boolean)createTableDBForNonQued{
    BOOL isStart = false;
         int sqlite3_open(const char *filename, sqlite3 **database);
         const char *dbpath = [[Utility getDBPath:DBNAME] UTF8String]; // Convert NSString to UTF-8
         if(sqlite3_open(dbpath, &connectDb) == SQLITE_OK){
             const char *sql_stmt = "CREATE TABLE IF NOT EXISTS nonQuedDetails (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, UserId INTEGER NOT NULL, EventItemId INTEGER NOT NULL,NonQuedValue INTEGER,IsNonQuedPlaying INTEGER)";
                sqlite3_prepare_v2(connectDb, sql_stmt, -1, &statement, NULL);
                
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    isStart =YES;
                    
                }
                if(statement!=NULL)
                    sqlite3_reset(statement);
                
                //NSLog(@"%s Delete failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(connectDb), sqlite3_errcode(connectDb));
                
                return isStart;
         }else{
             NSLog(@"Database failed to open ");
         }
         return isStart;
}
-(Boolean)createTableDBForGuided{
    BOOL isStart = false;
         int sqlite3_open(const char *filename, sqlite3 **database);
         const char *dbpath = [[Utility getDBPath:DBNAME] UTF8String]; // Convert NSString to UTF-8
         if(sqlite3_open(dbpath, &connectDb) == SQLITE_OK){
             const char *sql_stmt = "CREATE TABLE IF NOT EXISTS guidedDetails (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, UserId INTEGER NOT NULL, EventItemId INTEGER NOT NULL,GuidedIndex INTEGER,IsGuidedPlaying INTEGER)";
                sqlite3_prepare_v2(connectDb, sql_stmt, -1, &statement, NULL);
                
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    isStart =YES;
                    
                }
                if(statement!=NULL)
                    sqlite3_reset(statement);
                
                //NSLog(@"%s Delete failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(connectDb), sqlite3_errcode(connectDb));
                
                return isStart;
         }else{
             NSLog(@"Database failed to open ");
         }
         return isStart;
}
-(Boolean)createTableDBForDropdown{
    BOOL isStart = false;
         int sqlite3_open(const char *filename, sqlite3 **database);
         const char *dbpath = [[Utility getDBPath:DBNAME] UTF8String]; // Convert NSString to UTF-8
         if(sqlite3_open(dbpath, &connectDb) == SQLITE_OK){
             const char *sql_stmt = "CREATE TABLE IF NOT EXISTS dropDownDetails (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, UserId INTEGER NOT NULL, EventItemId INTEGER NOT NULL,DropdownIndex INTEGER,DataDict TEXT,IsDropdownPlay INTEGER)";
                sqlite3_prepare_v2(connectDb, sql_stmt, -1, &statement, NULL);
                
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    isStart =YES;
                    
                }
                if(statement!=NULL)
                    sqlite3_reset(statement);
                
                //NSLog(@"%s Delete failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(connectDb), sqlite3_errcode(connectDb));
                
                return isStart;
         }else{
             NSLog(@"Database failed to open ");
         }
         return isStart;
}
-(Boolean)createTableDBForWebniarSelected{
    BOOL isStart = false;
         int sqlite3_open(const char *filename, sqlite3 **database);
         const char *dbpath = [[Utility getDBPath:DBNAME] UTF8String]; // Convert NSString to UTF-8
         if(sqlite3_open(dbpath, &connectDb) == SQLITE_OK){
             const char *sql_stmt = "CREATE TABLE IF NOT EXISTS webniarTimeTable (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, UserId INTEGER NOT NULL, EventItemId INTEGER NOT NULL,VideoTime TEXT)";
                sqlite3_prepare_v2(connectDb, sql_stmt, -1, &statement, NULL);
                
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    isStart =YES;
                    
                }
                if(statement!=NULL)
                    sqlite3_reset(statement);
                
                //NSLog(@"%s Delete failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(connectDb), sqlite3_errcode(connectDb));
                
                return isStart;
         }else{
             NSLog(@"Database failed to open ");
         }
         return isStart;
}

-(Boolean)deleteWhen:(NSString *)tableName whereCondition:(NSString *)condition
{
    Boolean status=NO;
    
    NSString *querySQL = [@"" stringByAppendingFormat:@"delete from %@ where  %@",tableName,condition];
    
    //NSLog(@"querySQL-%@",querySQL);
    
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
    
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        status =YES;
        
    }
    if(statement!=NULL)
        sqlite3_reset(statement);
    
    //NSLog(@"%s Delete failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(connectDb), sqlite3_errcode(connectDb));
    
    return status;
    
}
-(BOOL)checkColumnExists:(NSString*)columeName with:(NSString*)tableName
{
    BOOL columnExists = NO;

    NSString *querySql = [@"" stringByAppendingFormat:@"SELECT %@ FROM %@",columeName,tableName];
    const char *query_stmt = [querySql UTF8String];
    sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
       if (sqlite3_step(statement) == SQLITE_ROW)
       {
           columnExists =YES;
       }
       if(statement!=NULL)
        sqlite3_reset(statement);
     
    return columnExists;
}
-(int)insert:(NSString *)tableName withColumn:(NSArray *)column forValue:(NSArray *)value
{
    int rowId=-1;
    
//  NSLog(@"column Array-%@",column);
//  NSLog(@"Value Array-%@",value);
    
    @try{
        
        NSString *querySQL =[@"" stringByAppendingFormat:@"insert into %@ (",tableName];
        NSString *columnName = @""; 
        NSString *columnValues = @"Values(";
        
        for (int i=0; i<[column count]; i++) {
            
            columnName = [columnName stringByAppendingFormat:@"%@,",[column objectAtIndex:i]];
            NSString *valueString=[value objectAtIndex:i];
           
//            NSLog(@"ValueString-%@",valueString);
//            if(![valueString isEqualToString:@""] && ![valueString isEqual:[NSNull null]] && [valueString rangeOfString:@"'"].location !=NSNotFound){
//            valueString=[valueString stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
//            }
            columnValues = [columnValues stringByAppendingFormat:@"'%@',",valueString];
        }
        columnName = [columnName substringToIndex:columnName.length-1];
        columnValues = [columnValues substringToIndex:columnValues.length-1];
        querySQL = [querySQL stringByAppendingFormat:@" %@ ) %@ )",columnName,columnValues];
        const char *query_stmt = [querySQL UTF8String];
        
       // NSLog(@"Insert Query-%s",query_stmt);
        
        sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
      
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //rowId = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] integerValue];
            rowId = (int)sqlite3_last_insert_rowid(connectDb);
       }
        
        
        NSLog(@"%s Insert failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(connectDb), sqlite3_errcode(connectDb));
        NSString *str  = [@"" stringByAppendingFormat:@"%s Insert failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(connectDb), sqlite3_errcode(connectDb)];
        if ([str isEqualToString:@"-[DAOReader insert:withColumn:forValue:] Insert failure 'no such table: webniarListDetails' (1)"] || [str isEqualToString:@"-[DAOReader insert:withColumn:forValue:] Insert failure 'no such table: webniarTimeTable' (1)"]) {
            [DBQuery isTableExistOrNot:NO];
        }else{
            [DBQuery isTableExistOrNot:YES];
        }
        NSLog(@"Statement-%d",sqlite3_step(statement));
        
    }
    @catch(NSException *ex) {
        
        NSLog(@"%@",[NSString stringWithFormat:@"%@",ex]);
    }

    if(statement!=NULL)
        sqlite3_reset(statement);

    return rowId;
    
}



-(int)updateAnnotate:(NSString *)tableName withColumn:(NSArray *)column forValue:(NSArray *)value forId:(NSString *)rowId
{
    int success=-1;
    
    @try{
        
        NSString *querySQL =[@"" stringByAppendingFormat:@"update %@ set ",tableName];
        NSString *columnName = @"";
        
        for (int i=0; i<[column count]; i++) {
            
            columnName = [columnName stringByAppendingFormat:@"%@='%@',",[column objectAtIndex:i],[value objectAtIndex:i]];
            
        }
        
        columnName = [columnName substringToIndex:columnName.length-1];
        
            querySQL = [querySQL stringByAppendingFormat:@" %@  where id = '%@'",columnName,rowId];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
        
        
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = [rowId intValue];
            
            
        }
        
        //        NSLog(@"%s Update failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(connectDb), sqlite3_errcode(connectDb));
        //
        //        NSLog(@"Statement-%d",sqlite3_step(statement));
        
    }
    @catch(NSException *ex) {
        
        NSLog(@"Error While updating:%@",[NSString stringWithFormat:@"%@",ex]);
    }
    if(statement!=NULL)
        sqlite3_reset(statement);
    
    return success;
    
}


-(BOOL)updateWithCondition:(NSString *)tableName withColumn:(NSArray *)column forValue:(NSArray *)value conditionString:(NSString *)conditionString
{
    BOOL success=FALSE;
    
    @try{
        
        NSString *querySQL =[@"" stringByAppendingFormat:@"update %@ set ",tableName];
        NSString *columnName = @"";
        
        for (int i=0; i<[column count]; i++) {
            
            columnName = [columnName stringByAppendingFormat:@"%@='%@',",[column objectAtIndex:i],[value objectAtIndex:i]];
            
        }
        columnName = [columnName substringToIndex:columnName.length-1];
        querySQL = [querySQL stringByAppendingFormat:@" %@  where %@",columnName,conditionString];
        // NSLog(@"updateForNs querySQL :: %@",querySQL);
        const char *query_stmt = [querySQL UTF8String];
        
        sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
        
         //NSLog(@"%s Update failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(connectDb), sqlite3_errcode(connectDb));
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = TRUE;
            
            
        }
        
    }
    @catch(NSException *ex) {
        
        NSLog(@"Error While updating:%@",[NSString stringWithFormat:@"%@",ex]);
    }
    if(statement!=NULL)
        sqlite3_reset(statement);
    
    return success;
    
}
-(BOOL)alterTable:(NSString *)tableName withColumn:(NSString *)column withColumTYPE:(BOOL)type
{
    BOOL success=FALSE;
    
    @try{
        
        NSString *querySQL =[@"" stringByAppendingFormat:@"ALTER TABLE %@ ADD %@ INTEGER",tableName,column];
        
        // NSLog(@"updateForNs querySQL :: %@",querySQL);
        const char *query_stmt = [querySQL UTF8String];
        
        sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
        
         //NSLog(@"%s Update failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(connectDb), sqlite3_errcode(connectDb));
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = TRUE;
            
            
        }
        
    }
    @catch(NSException *ex) {
        
        NSLog(@"Error While updating:%@",[NSString stringWithFormat:@"%@",ex]);
    }
    if(statement!=NULL)
        sqlite3_reset(statement);
    
    return success;
    
}
-(NSMutableArray*)selectBy:(NSString *)tableName withColumn:(NSArray*)column whereCondition:(NSString *)condition
{
     NSMutableArray *data=[[NSMutableArray alloc] init];
     NSString *columnName = @"";
    for (int i=0; i<[column count]; i++) {
        
        columnName = [columnName stringByAppendingFormat:@"%@,",[column objectAtIndex:i]];
    }
    columnName = [columnName substringToIndex:columnName.length-1];
    
    NSString *querySQL = [@"" stringByAppendingFormat:@"SELECT %@ FROM %@ where %@",columnName,tableName,condition]; //where %@ condition
    
   // NSLog(@"querySQL-%@",querySQL);
    
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
    
     
    //NSLog(@"Statement-%d",sqlite3_step(statement));
    
    int result;
    
    if ((result = sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL)) != SQLITE_OK)
    {
        NSLog(@"%s: prepare failure '%s' (%d)", __FUNCTION__, sqlite3_errmsg(connectDb), result);
        
    }
    
//    if ((result = sqlite3_step(statement)) != SQLITE_DONE)
//    {
//        NSLog(@"%s: step failure: '%s' (%d)", __FUNCTION__, sqlite3_errmsg(connectDb), result);
//    }
    
    while (sqlite3_step(statement) == SQLITE_ROW)
    {  
        NSMutableDictionary *dataRow =[[NSMutableDictionary alloc] init] ;
        
        for (int i=0;i<[column count]; i++) {        
            
            if(sqlite3_column_text(statement, i)!=NULL){
               
                [dataRow setValue:[[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, i)] forKey:[column objectAtIndex:i]];
            }else
                [dataRow setValue:@"" forKey:[column objectAtIndex:i]];
            
        }
        
        
        [data addObject:dataRow];
        
    }

    if(statement!=NULL)
        sqlite3_reset(statement);
    
    
    return data;
    
}
-(BOOL)selectByTable:(NSString *)tableName
{
     BOOL status = NO;

     NSString *querySQL = [@"" stringByAppendingFormat:@"SELECT count(*) FROM sqlite_master WHERE type='table' AND name='%@'",tableName];
     //SELECT name FROM sqlite_temp_master WHERE type='table' AND name= %@",tableName]; //where %@ condition
     //SELECT name FROM sqlite_temp_master WHERE type='table'
    // NSLog(@"querySQL-%@",querySQL);
    
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
    NSLog(@"Statement-%d",sqlite3_step(statement));
        sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
     if (sqlite3_step(statement) == SQLITE_ROW)
     {
        status =YES;
        
     }
    if(statement!=NULL)
        sqlite3_reset(statement);
    
//    if ((result = sqlite3_step(statement)) != SQLITE_DONE)
//    {
//        NSLog(@"%s: step failure: '%s' (%d)", __FUNCTION__, sqlite3_errmsg(connectDb), result);
//    }

    if(statement!=NULL)
        sqlite3_reset(statement);
    return status;
    
}
-(NSMutableDictionary*)selectByQueryInKeyValue:(NSArray*)column query:(NSString *)querySQL
{
    NSMutableDictionary *dataDict=[[NSMutableDictionary alloc] init];
    //NSLog(@"querySQL-%@",querySQL);
    const char *query_stmt = [querySQL UTF8String];
    //NSLog(@"query_stmt-%s",query_stmt);
    sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
    
    for (int k=0; k<column.count; k++) {
        [dataDict setObject:[[NSMutableArray alloc]init] forKey:[column objectAtIndex:k]];
    }
    
    //NSLog(@"Statement-%d",sqlite3_step(statement));
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
       for (int k=0; k<dataDict.count; k++) {
           NSMutableArray *columnDataArray = [dataDict valueForKey:[column objectAtIndex:k]];
            if(sqlite3_column_text(statement, k)!=NULL){
                [columnDataArray addObject:[[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, k)]];
            }else
                [columnDataArray addObject:@""];
       }
    }
    
    
    
    if(statement!=NULL)
        sqlite3_reset(statement);
    
    return dataDict;
    
}

-(NSMutableArray*)selectByQuery:(NSArray*)column query:(NSString *)querySQL
{
    NSMutableArray *data=[[NSMutableArray alloc] init];
       
    
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
    
  // NSLog(@"%s Select failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(connectDb), sqlite3_errcode(connectDb));
    
    while (sqlite3_step(statement) == SQLITE_ROW)
    {  
        NSMutableDictionary *dataRow =[[NSMutableDictionary alloc] init] ;
        
        for (int i=0;i<[column count]; i++) {        
            if(sqlite3_column_text(statement, i)!=NULL){
                [dataRow setValue:[[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, i)] forKey:[column objectAtIndex:i]];
            }else
                [dataRow setValue:@"" forKey:[column objectAtIndex:i]];
            
        }
        
        [data addObject:dataRow];
        
    }
    
    if(statement!=NULL)
        sqlite3_reset(statement);
    
    return data;
    
}

-(NSMutableArray*)selectByQueryInKey:(NSArray*)column query:(NSString *)querySQL key:(NSString *)key
{
    NSMutableArray *data=[[NSMutableArray alloc] init];
    
    
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
    
    //NSLog(@"%s Select failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(connectDb), sqlite3_errcode(connectDb));
    
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        NSMutableDictionary *dataRow =[[NSMutableDictionary alloc] init] ;
        
        for (int i=0;i<[column count]; i++) {
            if(sqlite3_column_text(statement, i)!=NULL){
                [dataRow setValue:[[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, i)] forKey:[column objectAtIndex:i]];
            }else
                [dataRow setValue:@"" forKey:[column objectAtIndex:i]];
            
        }
        
        NSDictionary *tempDict=[[NSDictionary alloc]initWithObjectsAndKeys:dataRow,key, nil];
        [data addObject:tempDict];
        tempDict=nil;
        dataRow=nil;
        
    }
    
    if(statement!=NULL)
        sqlite3_reset(statement);
    
    return data;
    
}


-(Boolean)truncate:(NSString *)tableName
{
    Boolean status=NO;
    
    NSString *querySQL = [@"" stringByAppendingFormat:@"DELETE FROM %@ ",tableName];
    
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
    
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        status =YES;
        
    }
    if(statement!=NULL)
        sqlite3_reset(statement);
    
    return status;
    
}

-(Boolean)deleteUsingQuery:(NSString *)querySQL
{
    Boolean status=NO;
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_prepare_v2(connectDb, query_stmt, -1, &statement, NULL);
    
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        status =YES;
        
    }
    if(statement!=NULL)
        sqlite3_reset(statement);
    
    return status;
    
}



@end
