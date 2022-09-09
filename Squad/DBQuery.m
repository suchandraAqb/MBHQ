//
//  DBQuery.m
//  Squad
//
//  Created by aqb-mac-mini3 on 20/02/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "DBQuery.h"

@implementation DBQuery

+(BOOL)addDailyWorkOut:(NSString *)dailyList favList:(NSString *)favList{
    
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
        NSMutableString *modifiedDailyList = [NSMutableString stringWithString:dailyList];
        [modifiedDailyList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDailyList length])];
        
        NSMutableString *modifiedFavList = [NSMutableString stringWithString:favList];
        [modifiedFavList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedFavList length])];
        
        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"dailyWorkoutList",@"favSessionList",@"lastUpdate",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],modifiedDailyList,modifiedFavList,date, nil];
        
        rowId = [dbObject insert:@"dailyworkout" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
    
}
+(BOOL)isTableExist:(NSString *)tableName{
    BOOL isExist = false;
   
    DAOReader *dbObject = [DAOReader sharedInstance];
    if([dbObject connectionStart]){
        
//        NSArray *arr = [dbObject selectByTable:tableName];
        
        if([dbObject selectByTable:tableName]){
//            NSLog(@"No of Entry------:%ld",arr.count);
            isExist = true;
        }
        
        [dbObject connectionEnd];
    }
    
    return isExist;
}
+(BOOL)isRowExist:(NSString *)tableName condition:(NSString *)condition{
    BOOL isExist = false;
   
    DAOReader *dbObject = [DAOReader sharedInstance];
    if([dbObject connectionStart]){
        
        NSArray *arr = [dbObject selectBy:tableName withColumn:[[NSArray alloc]initWithObjects:@"UserId",nil] whereCondition:condition];
        
        if(arr.count>0){
            NSLog(@"No of Entry:%ld",arr.count);
            isExist = true;
        }
        
        [dbObject connectionEnd];
    }
    
    return isExist;
}

+(BOOL)updateDailyWorkOut:(NSString *)dailyList favList:(NSString *)favList isSync:(int)isSync{
    DAOReader *dbObject = [DAOReader sharedInstance];
    BOOL isUpdate = false;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
        NSMutableString *modifiedDailyList = [NSMutableString stringWithString:dailyList];
        [modifiedDailyList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDailyList length])];
        
        NSMutableString *modifiedFavList = [NSMutableString stringWithString:favList];
        [modifiedFavList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedFavList length])];
        
        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"dailyWorkoutList",@"favSessionList",@"lastUpdate",@"isSync",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],modifiedDailyList,modifiedFavList,date,[NSNumber numberWithInt:isSync], nil];
        
        isUpdate = [dbObject updateWithCondition:@"dailyworkout" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]];
    }
    
    return isUpdate;
}

+(BOOL)addExerciseTypes:(NSString *)equipmentTypes details:(NSString *)equipmentTypeDetails sessionId:(int)sessionId{
    
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
        NSMutableString *modifiedEquipmentTypes = [NSMutableString stringWithString:equipmentTypes];
        [modifiedEquipmentTypes replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedEquipmentTypes length])];
        
        NSMutableString *modifiedEquipmentDetails = [NSMutableString stringWithString:equipmentTypeDetails];
        [modifiedEquipmentDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedEquipmentDetails length])];
        
        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"equipmentList",@"equipmentDetails",@"lastUpdate",@"exSessionId",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],modifiedEquipmentTypes,modifiedEquipmentDetails,date,[NSNumber numberWithInt:sessionId], nil];
        
        rowId = [dbObject insert:@"exerciseTypeDetails" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
    
}

+(BOOL)updateExerciseTypes:(NSString *)equipmentTypes details:(NSString *)equipmentTypeDetails sessionId:(int)sessionId{
    
    DAOReader *dbObject = [DAOReader sharedInstance];
    BOOL isUpdate = false;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
        NSMutableString *modifiedEquipmentTypes = [NSMutableString stringWithString:equipmentTypes];
        [modifiedEquipmentTypes replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedEquipmentTypes length])];
        
        NSMutableString *modifiedEquipmentDetails = [NSMutableString stringWithString:equipmentTypeDetails];
        [modifiedEquipmentDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedEquipmentDetails length])];
        
        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"equipmentList",@"equipmentDetails",@"lastUpdate",@"exSessionId",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],modifiedEquipmentTypes,modifiedEquipmentDetails,date,[NSNumber numberWithInt:sessionId], nil];
        
        isUpdate = [dbObject updateWithCondition:@"exerciseTypeDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,sessionId]];
        
        [dbObject connectionEnd];
    }
    
    return isUpdate;
    
}

+(BOOL)addExerciseDetails:(NSString *)exerciseDetails saveIdsDict:(NSDictionary *)saveIdsDict{
    
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
        NSMutableString *modifiedExerciseDetails = [NSMutableString stringWithString:exerciseDetails];
        [modifiedExerciseDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExerciseDetails length])];
        
        int sessionId = [saveIdsDict[@"exSessionId"] intValue];
        int isCustom = [saveIdsDict[@"isCustom"] intValue];
        int completeId = [saveIdsDict[@"completeId"] intValue];
        NSString *weekStartDate= saveIdsDict[@"weekStartDate"];
        NSString *sessionDate= saveIdsDict[@"sessionDate"];
        
        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"exerciseDetails",@"lastUpdate",@"exSessionId",@"isCustom",@"sessionCompleteId",@"weekStartDate",@"sessionDate",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],modifiedExerciseDetails,date,[NSNumber numberWithInt:sessionId],[NSNumber numberWithInt:isCustom],[NSNumber numberWithInt:completeId],weekStartDate,sessionDate,nil];
        
        rowId = [dbObject insert:@"exerciseDetails" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
    
}

+(BOOL)updateExerciseDetails:(NSString *)exerciseDetails sessionId:(int)sessionId{
    
    DAOReader *dbObject = [DAOReader sharedInstance];
    BOOL isUpdate = false;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
        NSMutableString *modifiedExerciseDetails = [NSMutableString stringWithString:exerciseDetails];
        [modifiedExerciseDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExerciseDetails length])];
        
        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"exerciseDetails",@"lastUpdate",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedExerciseDetails,date,nil];
        
        isUpdate = [dbObject updateWithCondition:@"exerciseDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,sessionId]];
        [dbObject connectionEnd];
    }
    
    return isUpdate;
    
}

+(BOOL)updateExerciseDetailsNames:(NSString *)exerciseNames sessionId:(int)sessionId{
    
    DAOReader *dbObject = [DAOReader sharedInstance];
    BOOL isUpdate = false;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
        NSMutableString *modifiedExerciseDetails = [NSMutableString stringWithString:exerciseNames];
        [modifiedExerciseDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExerciseDetails length])];
        
        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"exerciseNames",@"lastUpdate",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedExerciseDetails,date,nil];
        
        isUpdate = [dbObject updateWithCondition:@"exerciseDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,sessionId]];
        [dbObject connectionEnd];
    }
    
    return isUpdate;
    
}

+(BOOL)addCustomExerciseDetails:(NSString *)exerciseDetails joiningDate:(NSString *)joiningDate weekStartDate:(NSString *)weekStartDate{
    
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
        NSMutableString *modifiedExerciseDetails = [NSMutableString stringWithString:exerciseDetails];
        [modifiedExerciseDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExerciseDetails length])];
        
        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"joiningDate",@"weekStartDate",@"exerciseList",@"lastUpdate",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],joiningDate,weekStartDate,modifiedExerciseDetails,date, nil];
        
        rowId = [dbObject insert:@"customExerciseList" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
    
}

+(BOOL)updateCustomExerciseDetails:(NSString *)exerciseDetails joiningDate:(NSString *)joiningDate weekStartDate:(NSString *)weekStartDate{
    
    DAOReader *dbObject = [DAOReader sharedInstance];
    BOOL isUpdate = false;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
        NSMutableString *modifiedExerciseDetails = [NSMutableString stringWithString:exerciseDetails];
        [modifiedExerciseDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExerciseDetails length])];
        
        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"exerciseList",@"lastUpdate",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],modifiedExerciseDetails,date, nil];
        
        isUpdate = [dbObject updateWithCondition:@"customExerciseList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStartDate]];
    }
    
    return isUpdate;
    
}

+(BOOL)addQuoteDetails:(NSString *)quoteDetails addedDate:(NSString *)addedDate addedMonth:(NSString*)addedMonth personalAddDate:(NSString *)personalAddDate personalQuote:(NSString*)personalQuote favStatues:(NSString*)favStatus{//Quote
    
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
        NSMutableString *modifiedQuoteDetails = [NSMutableString stringWithString:quoteDetails];
        [modifiedQuoteDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedQuoteDetails length])];
        
        NSMutableString *modifiedPersonalQuoteDetails = [NSMutableString stringWithString:personalQuote];
        [modifiedQuoteDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedQuoteDetails length])];
        //        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"addedDate",@"addedMonth",@"quoteList",@"favStatus",@"personalAddDate",@"personalQuote",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],addedDate,addedMonth,modifiedQuoteDetails,favStatus,personalAddDate,modifiedPersonalQuoteDetails ,nil];
        
        rowId = [dbObject insert:@"quoteList" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    return (rowId > 0) ?true:false;
}
+(BOOL)updateQuoteDetails:(NSString *)quoteDetails addedDate:(NSString *)addedDate addedMonth:(NSString*)addedMonth personalAddDate:(NSString *)personalAddDate personalQuote:(NSString*)personalQuote favStatues:(NSString*)favStatus{//Quote
    
    DAOReader *dbObject = [DAOReader sharedInstance];
    BOOL isUpdate = false;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
        NSMutableString *modifiedQuoteDetails = [NSMutableString stringWithString:quoteDetails];
        [modifiedQuoteDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedQuoteDetails length])];
        //        NSString *date = [NSDate date].description;
        
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"favStatus",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],favStatus,nil];
        
        isUpdate = [dbObject updateWithCondition:@"quoteList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and quoteList = '%@'",userId,modifiedQuoteDetails]];
    }
    
    return isUpdate;
    
}
+(BOOL)addGratitudeDetails:(int)gratitudeID with:(NSString*)detailsStr addedDate:(NSString*)addedDateStr isSync:(int)isSync{
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        NSMutableString *modifiedGratitudeDetails = [NSMutableString stringWithString:detailsStr];
        [modifiedGratitudeDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedGratitudeDetails length])];
        
//        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"GratitudeId",@"CreatedDateStr",@"LastUpdateStr",@"GratitudeList",@"isSync",@"IsReloadRequre",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],[NSNumber numberWithInt:gratitudeID],addedDateStr,addedDateStr,modifiedGratitudeDetails,[NSNumber numberWithInt:isSync],[NSNumber numberWithInt:0], nil];
        
        rowId = [dbObject insert:@"gratitudeAddList" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
}
+(BOOL)addHabitStatesDetails:(NSString*)detailsStr with:(int)HabitID with:(int)isReloadRequre with:(NSString*)addedDate{
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        NSMutableString *modifiedHabitDetails = [NSMutableString stringWithString:detailsStr];
        [modifiedHabitDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedHabitDetails length])];
//        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"HabitId",@"CreateDate",@"LastUpdate",@"HabitStates",@"isReloadRequre",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],[NSNumber numberWithInt:HabitID],addedDate,addedDate,modifiedHabitDetails,[NSNumber numberWithInt:isReloadRequre], nil];
        
        rowId = [dbObject insert:@"habitStatesDetails" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
}
+(BOOL)updateHabitDetails:(NSString*)detailsStr with:(int)HabitID with:(int)isReloadRequre With:(NSString*)updatedate{
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
          NSMutableString *modifiedDetails = [NSMutableString stringWithString:detailsStr];
          [modifiedDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDetails length])];
          
//          NSString *date = [NSDate date].description;
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"LastUpdate",@"IsReloadRequre",@"HabitStates",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],updatedate,[NSNumber numberWithInt:isReloadRequre],modifiedDetails,nil];
          
          isUpdate = [dbObject updateWithCondition:@"habitStatesDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and HabitId = '%d'",userId,HabitID]];
          [dbObject connectionEnd];
      }
      
      return isUpdate;
}
+(BOOL)updateHabitColumn:(int)HabitID with:(int)isReloadRequre{
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
          if([DBQuery isRowExist:@"habitStatesDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and HabitId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:HabitID]]]){
              NSArray *columnArray = [[NSArray alloc]initWithObjects:@"IsReloadRequre",nil];
                     NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:isReloadRequre],nil];
                     
                     isUpdate = [dbObject updateWithCondition:@"habitStatesDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and HabitId = '%d'",userId,HabitID]];
               [dbObject connectionEnd];
          }
      }
      
      return isUpdate;
}
+(BOOL)deleteData:(NSString*)tablename with:(int)insertID{
     DAOReader *dbObject = [DAOReader sharedInstance];
     BOOL isDelete = false;
        
        if([dbObject connectionStart]){

            isDelete = [dbObject delete:tablename forId:[@"" stringByAppendingFormat:@"%d",insertID]];
            [dbObject connectionEnd];
        }
        
        return isDelete;
}
+(BOOL)updateGratitudeDetailsUsingRowID:(int)row with:(int)gratitudeID with:(NSString*)detailsStr UpdateDate:(NSString*)updateDateStr with:(int)sync{
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
          NSMutableString *modifiedGratitudeDetails = [NSMutableString stringWithString:detailsStr];
          [modifiedGratitudeDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedGratitudeDetails length])];
          //        NSString *date = [NSDate date].description;
          
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"GratitudeId",@"LastUpdateStr",@"gratitudeList",@"isSync",@"IsReloadRequre",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],[NSNumber numberWithInt:gratitudeID],updateDateStr,modifiedGratitudeDetails,[NSNumber numberWithInt:sync],[NSNumber numberWithInt:0],nil];
          
          isUpdate = [dbObject updateWithCondition:@"gratitudeAddList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and isSync = 0 and id = '%d'",userId,row]];
           [dbObject connectionEnd];
      }
      
      return isUpdate;
}
+(BOOL)updateGratitudeDetailsUsingGratitudeID:(int)gratitudeID with:(NSString*)detailsStr UpdateDate:(NSString*)updateDateStr with:(int)sync{
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
          NSMutableString *modifiedGratitudeDetails = [NSMutableString stringWithString:detailsStr];
          [modifiedGratitudeDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedGratitudeDetails length])];
          //        NSString *date = [NSDate date].description;
          
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"GratitudeId",@"LastUpdateStr",@"gratitudeList",@"isSync",@"IsReloadRequre",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],[NSNumber numberWithInt:gratitudeID],updateDateStr,modifiedGratitudeDetails,[NSNumber numberWithInt:sync],[NSNumber numberWithInt:0],nil];
          
          isUpdate = [dbObject updateWithCondition:@"gratitudeAddList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and  GratitudeId = '%d'",userId,gratitudeID]];
           [dbObject connectionEnd];
      }
      
      return isUpdate;
}
+(BOOL)updateGrowthDetailsUsingRowID:(int)row with:(int)growthID with:(NSString*)detailsStr UpdateDate:(NSString*)updateDateStr with:(int)sync{
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
          NSMutableString *modifiedDetails = [NSMutableString stringWithString:detailsStr];
          [modifiedDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDetails length])];
          //        NSString *date = [NSDate date].description;
          
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"AchivementId",@"LastUpdateStr",@"GrowthList",@"isSync",@"IsReloadRequre",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],[NSNumber numberWithInt:growthID],updateDateStr,modifiedDetails,[NSNumber numberWithInt:sync],[NSNumber numberWithInt:0],nil];
          
          isUpdate = [dbObject updateWithCondition:@"growthAddList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and isSync = 0 and id = '%d'",userId,row]];
           [dbObject connectionEnd];
      }
      
      return isUpdate;
}
+(BOOL)updateGrowthDetails:(int)growthID with:(NSString*)detailsStr UpdateDate:(NSString*)updateDateStr with:(int)sync{
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
          NSMutableString *modifiedDetails = [NSMutableString stringWithString:detailsStr];
          [modifiedDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDetails length])];
          //        NSString *date = [NSDate date].description;
          
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"AchivementId",@"LastUpdateStr",@"GrowthList",@"isSync",@"IsReloadRequire",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],[NSNumber numberWithInt:growthID],updateDateStr,modifiedDetails,[NSNumber numberWithInt:sync],[NSNumber numberWithInt:0],nil];
          
          isUpdate = [dbObject updateWithCondition:@"growthAddList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and isSync = 0",userId]];
           [dbObject connectionEnd];
      }
      
      return isUpdate;
}
+(BOOL)addGrowthDetails:(int)achieveId with:(NSString*)detailsStr addedDate:(NSString*)addedDateStr isSync:(int)isSync{
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        NSMutableString *modifiedDetails = [NSMutableString stringWithString:detailsStr];
        [modifiedDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDetails length])];
        
//        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"AchivementId",@"CreatedDateStr",@"LastUpdateStr",@"GrowthList",@"isSync",@"IsReloadRequire",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],[NSNumber numberWithInt:achieveId],addedDateStr,addedDateStr,modifiedDetails, [NSNumber numberWithInt:isSync],[NSNumber numberWithInt:0],nil];
        
        rowId = [dbObject insert:@"growthAddList" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
}
+(BOOL)addTodayGrwothDetails:(NSString*)detailsStr with:(NSString*)addedDateStr{
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        NSMutableString *modifiedDetails = [NSMutableString stringWithString:detailsStr];
        [modifiedDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDetails length])];
        
//        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"AddedDate",@"TodayData",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],addedDateStr,modifiedDetails,nil];
        
        rowId = [dbObject insert:@"todayGetGrowthDetails" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
}

+(BOOL)updateTodayGrwothDetails:(NSString*)detailsStr With:(NSString*)dateStr{
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
          NSMutableString *modifiedDetails = [NSMutableString stringWithString:detailsStr];
          [modifiedDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDetails length])];
          
//          NSString *date = [NSDate date].description;
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"AddedDate",@"TodayData",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],dateStr,modifiedDetails,nil];
          
          isUpdate = [dbObject updateWithCondition:@"todayGetGrowthDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and AddedDate = '%@'",userId,dateStr]];
           [dbObject connectionEnd];
      }
      
      return isUpdate;
}
+(BOOL)addMeditationData:(NSString*)detailsStr with:(int)eventId{
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
       NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        NSMutableString *modifiedDetails = [NSMutableString stringWithString:detailsStr];
        [modifiedDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDetails length])];
        
//        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"EventId",@"Details",@"CreatedDate",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],[NSNumber numberWithInt:eventId],modifiedDetails,currentDateStr,nil];
        
        rowId = [dbObject insert:@"meditationList" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
}

+(BOOL)updateMeditationDetails:(NSString*)detailsStr with:(int)eventId{
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
          NSMutableString *modifiedDetails = [NSMutableString stringWithString:detailsStr];
          [modifiedDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDetails length])];
          
//          NSString *date = [NSDate date].description;
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"Details",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedDetails,nil];
          
          isUpdate = [dbObject updateWithCondition:@"meditationList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and EventId = '%d'",userId,eventId]];
          [dbObject connectionEnd];
      }
      
      return isUpdate;
}
+(BOOL)addImageLocally:(int)imageType itemId:(int)item_id imagename:(NSString*)image_name issync:(BOOL)isSync{
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        
//        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"Image_type",@"Item_Id",@"Image_name",@"isSync",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],[NSNumber numberWithInt:imageType],[NSNumber numberWithInt:item_id],image_name,[NSNumber numberWithInt:isSync], nil];
        
        rowId = [dbObject insert:@"LocalImageSync" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
}
+(BOOL)updateImageLocally:(int)imageType itemId:(int)item_id imagename:(NSString*)image_name issync:(BOOL)isSync{
    DAOReader *dbObject = [DAOReader sharedInstance];
    BOOL isUpdate = false;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        
//        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"Image_type",@"Item_Id",@"Image_name",@"isSync",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],[NSNumber numberWithInt:imageType],[NSNumber numberWithInt:item_id],image_name,[NSNumber numberWithInt:isSync], nil];
        
         isUpdate = [dbObject updateWithCondition:@"LocalImageSync" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and Image_type = '%d' and Item_Id = '%d'",userId,imageType,item_id]];
        [dbObject connectionEnd];
    }
    
    return isUpdate;

}
+(BOOL)addMeditationTagList:(NSString*)detailsStr{
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        NSMutableString *modifiedDetails = [NSMutableString stringWithString:detailsStr];
        [modifiedDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDetails length])];
        
//        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"ListData",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],modifiedDetails,nil];
        
        rowId = [dbObject insert:@"meditationTagList" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
}
+(BOOL)addWebniarList:(NSString*)detailsStr{
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        NSMutableString *modifiedDetails = [NSMutableString stringWithString:detailsStr];
        [modifiedDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDetails length])];
        
//        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"Details",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],modifiedDetails,nil];
        
        rowId = [dbObject insert:@"webniarListDetails" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
}
+(BOOL)checkColumnExists:(NSString*)columeName with:(NSString*)tableName
{
    DAOReader *dbObject = [DAOReader sharedInstance];
    BOOL isCheck = [dbObject checkColumnExists:columeName with:tableName];
    return isCheck;
}
+(BOOL)alterTableColumn:(NSString*)tableName with:(NSString*)columnName With:(BOOL)type{
    DAOReader *dbObject = [DAOReader sharedInstance];
    BOOL isalter = [dbObject alterTable:tableName withColumn:columnName withColumTYPE:1];
    return isalter;
}
+(BOOL)addNonQuedDetails:(BOOL)tick with:(int)eventItemID withNonQuePlay:(BOOL)nonqued{
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        
//        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"EventItemId",@"NonQuedValue",@"IsNonQuedPlaying",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],[NSNumber numberWithInt:eventItemID],[NSNumber numberWithInt:tick],[NSNumber numberWithInt:nonqued], nil];
        
        rowId = [dbObject insert:@"nonQuedDetails" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
}
+(BOOL)updateNonQuedDetails:(BOOL)tick with:(int)eventItemID{
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
//          NSString *date = [NSDate date].description;
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"NonQuedValue",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:tick],nil];
          
          isUpdate = [dbObject updateWithCondition:@"nonQuedDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' AND EventItemID = '%d'",userId,eventItemID]];
          [dbObject connectionEnd];
      }
      
      return isUpdate;
}
+(BOOL)addGuidedDetails:(int)tick with:(int)eventItemID{
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        
//        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"EventItemId",@"GuidedIndex",@"IsGuidedPlaying",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],[NSNumber numberWithInt:eventItemID],[NSNumber numberWithInt:tick],[NSNumber numberWithInt:0], nil];
        
        rowId = [dbObject insert:@"guidedDetails" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
}

+(BOOL)updateGuidedDetails:(int)tick with:(int)eventItemID{
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
//          NSString *date = [NSDate date].description;
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"GuidedIndex",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:tick], nil];
          
          isUpdate = [dbObject updateWithCondition:@"guidedDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' AND EventItemID = '%d'",userId,eventItemID]];
          [dbObject connectionEnd];
      }
      
      return isUpdate;
}
+(BOOL)addDropdownDetails:(int)tick with:(int)eventItemID with:(NSString*)dataDictStr{
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        
//        NSString *date = [NSDate date].description;
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"EventItemId",@"DropdownIndex",@"DataDict",@"IsDropdownPlay",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],[NSNumber numberWithInt:eventItemID],[NSNumber numberWithInt:tick],dataDictStr,[NSNumber numberWithInt:0], nil];
        
        rowId = [dbObject insert:@"dropDownDetails" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
}
+(BOOL)updateDropdownDetails:(int)tick with:(int)eventItemID with:(NSString*)dataDictStr{
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
//          NSString *date = [NSDate date].description;
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"DropDownIndex",@"DataDict",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:tick],dataDictStr,nil];
          
          isUpdate = [dbObject updateWithCondition:@"dropDownDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' AND EventItemID = '%d'",userId,eventItemID]];
          [dbObject connectionEnd];
      }
      
      return isUpdate;
}

+(BOOL)updateNonQuedDetailsForPlayNonQued:(BOOL)isNonQuedPlaying with:(int)eventItemID{
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
//          NSString *date = [NSDate date].description;
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"IsNonQuedPlaying",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:isNonQuedPlaying],nil];
          
          isUpdate = [dbObject updateWithCondition:@"nonQuedDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and EventItemID = '%d'",userId,eventItemID]];
          [dbObject connectionEnd];
      }
      
      return isUpdate;
}
+(BOOL)updateDropDownDetailsForPlay:(BOOL)isDropDownPlaying with:(int)eventItemID{
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
//          NSString *date = [NSDate date].description;
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"IsDropdownPlay",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:isDropDownPlaying],nil];
          
          isUpdate = [dbObject updateWithCondition:@"dropDownDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and EventItemID = '%d'",userId,eventItemID]];
          [dbObject connectionEnd];
      }
      
      return isUpdate;
}
+(BOOL)updateGuidedDetailsForPlay:(BOOL)isGuidedPlaying with:(int)eventItemID{
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
//          NSString *date = [NSDate date].description;
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"IsGuidedPlaying",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:isGuidedPlaying],nil];
          
          isUpdate = [dbObject updateWithCondition:@"guidedDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and EventItemID = '%d'",userId,eventItemID]];
          [dbObject connectionEnd];
      }
      
      return isUpdate;
}
+(BOOL)updateMeditationTagList:(NSString*)detailsStr {
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
          NSMutableString *modifiedDetails = [NSMutableString stringWithString:detailsStr];
          [modifiedDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDetails length])];
          
//          NSString *date = [NSDate date].description;
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"ListData",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedDetails,nil];
          
          isUpdate = [dbObject updateWithCondition:@"meditationTagList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]];
          [dbObject connectionEnd];
      }
      
      return isUpdate;
}
+(void)isTableExistOrNot:(BOOL)isExist{
    [defaults setBool:isExist forKey:@"TableUpdateCheck"];
}
+(BOOL)createTableDB{
    DAOReader *dbObject = [DAOReader sharedInstance];
    BOOL isSuccess = false;

     if([dbObject connectionStart]){
         isSuccess = [dbObject createTableDBForWebniarList];
         [dbObject connectionEnd];

     }
    return isSuccess;
}
+(BOOL)createTableDBForNonQued{
    DAOReader *dbObject = [DAOReader sharedInstance];
    BOOL isSuccess = false;

     if([dbObject connectionStart]){
         isSuccess = [dbObject createTableDBForNonQued];
         [dbObject connectionEnd];

     }
    return isSuccess;
}
+(BOOL)createTableDBForGuided{
    DAOReader *dbObject = [DAOReader sharedInstance];
    BOOL isSuccess = false;

     if([dbObject connectionStart]){
         isSuccess = [dbObject createTableDBForGuided];
         [dbObject connectionEnd];

     }
    return isSuccess;
}
+(BOOL)createTableDBForDropdown{
    DAOReader *dbObject = [DAOReader sharedInstance];
    BOOL isSuccess = false;

     if([dbObject connectionStart]){
         isSuccess = [dbObject createTableDBForDropdown];
         [dbObject connectionEnd];

     }
    return isSuccess;
}
+(BOOL)createTableDBForWebniarSelcted{
    DAOReader *dbObject = [DAOReader sharedInstance];
    BOOL isSuccess = false;

     if([dbObject connectionStart]){
         isSuccess = [dbObject createTableDBForWebniarSelected];
         [dbObject connectionEnd];

     }
    return isSuccess;
}

+(BOOL)updateWebniarList:(NSString*)detailsStr {
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
          NSMutableString *modifiedDetails = [NSMutableString stringWithString:detailsStr];
          [modifiedDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDetails length])];
          
//          NSString *date = [NSDate date].description;
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"Details",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedDetails,nil];
          
          isUpdate = [dbObject updateWithCondition:@"webniarListDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]];
          [dbObject connectionEnd];
      }
      
      return isUpdate;
}
+(BOOL)updateMeditationTime:(NSString*)detailsStr with:(int)eventId{
    DAOReader *dbObject = [DAOReader sharedInstance];
      BOOL isUpdate = false;
      
      if([dbObject connectionStart]){
          int userId = [[defaults objectForKey:@"UserID"] intValue];
          NSMutableString *modifiedDetails = [NSMutableString stringWithString:detailsStr];
          [modifiedDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDetails length])];
          
//          NSString *date = [NSDate date].description;
          NSArray *columnArray = [[NSArray alloc]initWithObjects:@"VideoTime",nil];
          NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedDetails,nil];
          
          isUpdate = [dbObject updateWithCondition:@"webniarTimeTable" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and EventItemId = '%d'",userId,eventId]];
          [dbObject connectionEnd];
      }
      
      return isUpdate;
}

+(BOOL)addMeditationTime:(NSString*)detailsStr with:(int)eventId{
    DAOReader *dbObject = [DAOReader sharedInstance];
    int rowId = -1;
    
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        NSMutableString *modifiedDetails = [NSMutableString stringWithString:detailsStr];
        [modifiedDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedDetails length])];
        
        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"UserId",@"EventItemId",@"VideoTime",nil];
        NSArray *valuesArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:userId],[NSNumber numberWithInt:eventId],modifiedDetails,nil];
        
        rowId = [dbObject insert:@"webniarTimeTable" withColumn:columnArray forValue:valuesArray];
        [dbObject connectionEnd];
    }
    
    return (rowId > 0) ?true:false;
}

@end
