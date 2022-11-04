//
//  DBQuery.h
//  Squad
//
//  Created by aqb-mac-mini3 on 20/02/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBQuery : NSObject
+(BOOL)isRowExist:(NSString *)tableName condition:(NSString *)condition;
+(BOOL)addDailyWorkOut:(NSString *)dailyList favList:(NSString *)favList;
+(BOOL)updateDailyWorkOut:(NSString *)dailyList favList:(NSString *)favList isSync:(int)isSync;
+(BOOL)addExerciseTypes:(NSString *)equipmentTypes details:(NSString *)equipmentTypeDetails sessionId:(int)sessionId;
+(BOOL)updateExerciseTypes:(NSString *)equipmentTypes details:(NSString *)equipmentTypeDetails sessionId:(int)sessionId;
+(BOOL)addExerciseDetails:(NSString *)exerciseDetails saveIdsDict:(NSDictionary *)saveIdsDict;
+(BOOL)updateExerciseDetails:(NSString *)exerciseDetails sessionId:(int)sessionId;
+(BOOL)updateExerciseDetailsNames:(NSString *)exerciseNames sessionId:(int)sessionId;
+(BOOL)addCustomExerciseDetails:(NSString *)exerciseDetails joiningDate:(NSString *)joiningDate weekStartDate:(NSString *)weekStartDate;
+(BOOL)updateCustomExerciseDetails:(NSString *)exerciseDetails joiningDate:(NSString *)joiningDate weekStartDate:(NSString *)weekStartDate;
+(BOOL)addQuoteDetails:(NSString *)quoteDetails addedDate:(NSString *)addedDate addedMonth:(NSString*)addedMonth personalAddDate:(NSString *)personalAddDate personalQuote:(NSString*)personalQuote favStatues:(NSString*)favStatus;//Quote

+(BOOL)updateQuoteDetails:(NSString *)quoteDetails addedDate:(NSString *)addedDate addedMonth:(NSString*)addedMonth personalAddDate:(NSString *)personalAddDate personalQuote:(NSString*)personalQuote favStatues:(NSString*)favStatus;//Quote
+(BOOL)addGratitudeDetails:(int)gratitudeID with:(NSString*)detailsStr addedDate:(NSString*)addedDateStr isSync:(int)isSync;
+(BOOL)updateGratitudeDetailsUsingRowID:(int)row with:(int)gratitudeID with:(NSString*)detailsStr UpdateDate:(NSString*)updateDateStr with:(int)sync;
+(BOOL)deleteData:(NSString*)tableName with:(int)insertID;
+(BOOL)addGrowthDetails:(int)achieveId with:(NSString*)detailsStr addedDate:(NSString*)addedDateStr isSync:(int)isSync;
+(BOOL)addHabitStatesDetails:(NSString*)detailsStr with:(int)HabitID with:(int)isReloadRequre with:(NSString*)addedDate;
+(BOOL)updateHabitDetails:(NSString*)detailsStr with:(int)HabitID with:(int)isReloadRequre With:(NSString*)updatedate;
+(BOOL)updateHabitColumn:(int)HabitID with:(int)isReloadRequre;
+(BOOL)updateGrowthDetails:(int)growthID with:(NSString*)detailsStr UpdateDate:(NSString*)updateDateStr with:(int)sync;
+(BOOL)updateGratitudeDetailsUsingGratitudeID:(int)gratitudeID with:(NSString*)detailsStr UpdateDate:(NSString*)updateDateStr with:(int)sync;
+(BOOL)addTodayGrwothDetails:(NSString*)detailsStr with:(NSString*)addedDateStr;
+(BOOL)updateTodayGrwothDetails:(NSString*)detailsStr With:(NSString*)dateStr;
+(BOOL)addMeditationData:(NSString*)detailsStr with:(int)eventId;
+(BOOL)updateMeditationDetails:(NSString*)detailsStr with:(int)eventId;
+(BOOL)addMeditationTagList:(NSString*)detailsStr;
+(BOOL)updateMeditationTagList:(NSString*)detailsStr;
+(BOOL)updateGrowthDetailsUsingRowID:(int)row with:(int)growthID with:(NSString*)detailsStr UpdateDate:(NSString*)updateDateStr with:(int)sync;
+(BOOL)addImageLocally:(int)imageType itemId:(int)item_id imagename:(NSString*)image_name issync:(BOOL)isSync;
+(BOOL)updateImageLocally:(int)imageType itemId:(int)item_id imagename:(NSString*)image_name issync:(BOOL)isSync;
+(BOOL)updateWebniarList:(NSString*)detailsStr;
+(BOOL)addWebniarList:(NSString*)detailsStr;
+(BOOL)updateMeditationTime:(NSString*)detailsStr with:(int)eventId;
+(BOOL)addMeditationTime:(NSString*)detailsStr with:(int)eventId;
+(BOOL)isTableExist:(NSString *)tableName;
+(void)isTableExistOrNot:(BOOL)isExist;
+(BOOL)createTableDB;
+(BOOL)createTableDBForWebniarSelcted;
+(BOOL)addNonQuedDetails:(BOOL)tick with:(int)eventItemID withNonQuePlay:(BOOL)nonqued;
+(BOOL)updateNonQuedDetails:(BOOL)tick with:(int)eventItemID;
+(BOOL)createTableDBForNonQued;
+(BOOL)updateNonQuedDetailsForPlayNonQued:(BOOL)isNonQuedPlaying with:(int)eventItemID;
+(BOOL)createTableDBForGuided;
+(BOOL)addGuidedDetails:(int)tick with:(int)eventItemID;
+(BOOL)updateGuidedDetails:(int)tick with:(int)eventItemID;
+(BOOL)updateDropdownDetails:(int)tick with:(int)eventItemID with:(NSString*)dataDictStr;
+(BOOL)addDropdownDetails:(int)tick with:(int)eventItemID with:(NSString*)dataDictStr;
+(BOOL)createTableDBForDropdown;
+(BOOL)updateDropDownDetailsForPlay:(BOOL)isDropDownPlaying with:(int)eventItemID;
+(BOOL)updateGuidedDetailsForPlay:(BOOL)isGuidedPlaying with:(int)eventItemID;
+(BOOL)checkColumnExists:(NSString*)columeName with:(NSString*)tableName;
+(BOOL)alterTableColumn:(NSString*)tableName with:(NSString*)columnName With:(BOOL)type;
@end
