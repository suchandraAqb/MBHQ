//
//  ExerciseDailyListViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 03/01/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "ExerciseDailyListViewController.h"
#import "ExerciseDailyListTableViewCell.h"
#import "ExerciseDailyListHeaderView.h"
#import "HomePageViewController.h"

static NSString *SectionHeaderViewIdentifier = @"ExerciseDailyListHeaderView";

@interface ExerciseDailyListViewController (){
    IBOutlet UITableView *dailyTableView;

    NSMutableDictionary *dateListDict;
    UIView *contentView;
    NSMutableArray *responseArray;
    NSArray *favouriteArray;//add8
    int apiCount;
    
    __weak IBOutlet UIView *loadingSessionView;
    __weak IBOutlet UIImageView *animationImageView;
    BOOL isChanged;
    
}

@end

@implementation ExerciseDailyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    loadingSessionView.hidden = true;
    
   animationImageView.image = [UIImage animatedImageNamed:@"animation-" duration:1.0f];
    
    //arnab 17
    dateListDict = [[NSMutableDictionary alloc]init];
    responseArray = [[NSMutableArray alloc]init];
    

    /*dateListDict = [@{
                           @"January":
                            @[
                                @{
                                   @"date" : @"Thursday 2nd",
                                   @"cat" : @"Booty",
                                   @"subCat" : @"HIIT"
                                },
                                @{
                                    @"date" : @"Wednesday 3rd",
                                    @"cat" : @"Booty",
                                    @"subCat" : @"HIIT"
                                },
                                @{
                                    @"date" : @"Friday 4th",
                                    @"cat" : @"Booty",
                                    @"subCat" : @"HIIT"
                                },
                                @{
                                    @"date" : @"Monday 7th",
                                    @"cat" : @"Booty",
                                    @"subCat" : @"HIIT"
                                }
                            ],
                           @"December":
                               @[
                                   @{
                                       @"date" : @"Thursday 2nd",
                                       @"cat" : @"Booty",
                                       @"subCat" : @"HIIT"
                                       },
                                   @{
                                       @"date" : @"Wednesday 3rd",
                                       @"cat" : @"Booty",
                                       @"subCat" : @"HIIT"
                                       },
                                   @{
                                       @"date" : @"Friday 4th",
                                       @"cat" : @"Booty",
                                       @"subCat" : @"HIIT"
                                       },
                                   @{
                                       @"date" : @"Monday 7th",
                                       @"cat" : @"Booty",
                                       @"subCat" : @"HIIT"
                                       }
                                   ],
                           @"November":
                               @[
                                   @{
                                       @"date" : @"Thursday 2nd",
                                       @"cat" : @"Booty",
                                       @"subCat" : @"HIIT"
                                       },
                                   @{
                                       @"date" : @"Wednesday 3rd",
                                       @"cat" : @"Booty",
                                       @"subCat" : @"HIIT"
                                       },
                                   @{
                                       @"date" : @"Friday 4th",
                                       @"cat" : @"Booty",
                                       @"subCat" : @"HIIT"
                                       },
                                   @{
                                       @"date" : @"Monday 7th",
                                       @"cat" : @"Booty",
                                       @"subCat" : @"HIIT"
                                       }
                                   ]
                        }mutableCopy];*/
    
    dailyTableView.estimatedRowHeight=70;
    dailyTableView.rowHeight = UITableViewAutomaticDimension;
    dailyTableView.estimatedSectionHeaderHeight=80;
    dailyTableView.sectionHeaderHeight=UITableViewAutomaticDimension;
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ExerciseDailyListHeaderView" bundle:nil];
    [dailyTableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    isChanged = true;
    
//    dailyTableView.estimatedRowHeight = 80;
//    dailyTableView.rowHeight = UITableViewAutomaticDimension;
//    
//    dailyTableView.estimatedSectionHeaderHeight = 80;
//    dailyTableView.sectionHeaderHeight = UITableViewAutomaticDimension;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (!isChanged) {
        isChanged = YES;
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if(loadingSessionView.isHidden && ![Utility isOfflineMode]){
            loadingSessionView.hidden = false;
        }
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//add5
        [self getDailyData];
        [self webserviceCall_GetFavoriteSessionList];
    });
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isOnlyToday = false;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - WebserviceCall

-(void) getDailyData {
    if (Utility.reachable && ![Utility isOfflineMode]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;//add8
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            //contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        
        NSDate *currentDate = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitMonth fromDate:currentDate]; // Get necessary date components
        
        NSInteger monthIndex = [components month]; //gives you month
        
        //NSDateFormatter *monthDateformatter = [[NSDateFormatter alloc]init];
        //NSString *monthName = [[monthDateformatter monthSymbols] objectAtIndex:(monthIndex-1)];

        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];   //ah 17
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[NSString stringWithFormat:@"%ld",(long)monthIndex] forKey:@"PageIndex"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetDailySessionList" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 apiCount--;
                                                                 if (apiCount==0) {
                                                                     if(contentView)[contentView removeFromSuperview];
                                                                     if(!loadingSessionView.isHidden){
                                                                         loadingSessionView.hidden = true;
                                                                     }
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         //                                                                         [dateListDict setObject:[[responseDictionary objectForKey:@"DailySessionModels"] objectForKey:@"DailySessionModels"] forKey:monthName];
                                                                         //                                                                         [dailyTableView reloadData];
                                                                         //ah 2.2
                                                                         //ah 6.2
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else {
                                                                             
                                                                             if(responseArray.count>0){
                                                                                 [responseArray removeAllObjects];
                                                                             }// AY 05032018
                                                                             
                                                                             [responseArray addObjectsFromArray:[[responseDictionary objectForKey:@"DailySessionModels"] objectForKey:@"DailySessionModels"]];
                                                                             
                                                                             [self setupView];
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                     
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
           [self getOfflineData];
            [self gotoDetailsPage];
        }else{
           [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
        
        
    }
    
}

-(void)webserviceCall_FavoriteSessionToggle:(NSDictionary*)dict{ //add8
    
    if (Utility.reachable && ![Utility isOfflineMode]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[dict objectForKey:@"ExerciseSessionId"] forKey:@"SessionId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"FavoriteSessionToggle" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self webserviceCall_GetFavoriteSessionList];
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self offlineSessionDoneNFavourite:dict isFav:YES];// AY 02032018
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
}

-(void)webserviceCall_GetFavoriteSessionList{ //add5
    if (Utility.reachable && ![Utility isOfflineMode]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            //contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetFavoriteSessionList" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (apiCount == 0) {
                                                                     if(contentView)[contentView removeFromSuperview];
                                                                     if(!loadingSessionView.isHidden){
                                                                         loadingSessionView.hidden = true;
                                                                     }
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->favouriteArray = [responseDict objectForKey:@"FavoriteSessionList"];
                                                                         [self.view setNeedsUpdateConstraints];
                                                                         [self->dailyTableView reloadData];
                                                                         
                                                                         if (self->apiCount==0) {
                                                                             [self addUpdateDataToDB];
                                                                             [self gotoDetailsPage];
                                                                         }
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
        
    }
    
}

-(void)webserviceCall_CountSessionDone:(NSDictionary*)dict{ //add8
    if (Utility.reachable && ![Utility isOfflineMode]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[dict objectForKey:@"ExerciseSessionId"] forKey:@"SessionId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"CountSessionDone" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup

                                                                         [self webserviceCall_GetFavoriteSessionList];
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
           [self offlineSessionDoneNFavourite:dict isFav:NO];// AY 02032018
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
    
}

#pragma mark - Private Method
-(void) setupView {
    
    if(responseArray.count> 0 && dateListDict.count>0){
        [dateListDict removeAllObjects];
    }// AY 05032018
    
    NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
    [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
    
    for (int i = 0; i < responseArray.count; i++) {
        NSString *dateStr = [[responseArray objectAtIndex:i] objectForKey:@"Date"];
        NSArray *dateArr = [dateStr componentsSeparatedByString:@"T"];
        dateStr = [dateArr objectAtIndex:0];
        NSDate *dailyDate = [dailyDateformatter dateFromString:dateStr];
        
        if([Utility isSquadFreeUser] ){
            if([dailyDate isLaterThan:[NSDate date]]){
                continue;
            }
        }
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitMonth fromDate:dailyDate]; // Get necessary date components
        
        NSDateComponents* yearComponents = [calendar components:NSCalendarUnitYear fromDate:dailyDate]; // Get necessary date components
        
        NSInteger monthIndex = [components month]; //gives you month
        NSInteger yearIndex = [yearComponents year]; //gives you year
        
        NSString *keyName;
        
        if (monthIndex > 9){
            
            keyName= [@"" stringByAppendingFormat:@"%ld-%ld",yearIndex,monthIndex];
            
        }else{
            
            keyName= [@"" stringByAppendingFormat:@"%ld-0%ld",yearIndex,monthIndex];
            
        }
        
       //        NSDateFormatter *monthDateformatter = [[NSDateFormatter alloc]init];
        
        //        NSString *monthName = [[monthDateformatter monthSymbols] objectAtIndex:(monthIndex-1)];
        
        
        
        if (![Utility isEmptyCheck:dateListDict]) {
            
            NSArray *keys = [dateListDict allKeys];
            
            if ([keys containsObject:keyName]) { //[NSNumber numberWithInteger:monthIndex]
                
                NSMutableArray *newArr = [[NSMutableArray alloc]init];
                
                [newArr addObjectsFromArray:[dateListDict objectForKey:keyName]];
                
                [newArr addObject:[responseArray objectAtIndex:i]];
                
                [dateListDict removeObjectForKey:keyName];
                
                [dateListDict setObject:newArr forKey:keyName];
                
            } else {
                
                NSMutableArray *newArr = [[NSMutableArray alloc]init];
                
                [newArr addObject:[responseArray objectAtIndex:i]];
                
                [dateListDict setObject:newArr forKey:keyName];
                
            }
            
        } else {
            
            NSMutableArray *newArr = [[NSMutableArray alloc]init];  //ah ah
            
            [newArr addObject:[responseArray objectAtIndex:i]];
            
            [dateListDict setObject:newArr forKey:keyName];
            
            //            [dateListDict setObject:[responseArray objectAtIndex:i] forKey:monthName];
            
        }
    }
    
    NSArray *keys = [dateListDict allKeys];
//    [[keys mutableCopy] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];

    for (int i = 0; i < keys.count; i++) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        arr = [dateListDict objectForKey:[keys objectAtIndex:i]];
        for (int j = 0; j < arr.count; j++) {
            if ([[arr objectAtIndex:j] isKindOfClass:[NSDictionary class]]) {
                [arr1 addObject:[arr objectAtIndex:j]];
            }
            //NSLog(@"j %d",j);
        }
        [dateListDict removeObjectForKey:[keys objectAtIndex:i]];
        [dateListDict setObject:arr1 forKey:[keys objectAtIndex:i]];
    }
    //NSLog(@"dla %@",dateListDict);
    [dailyTableView reloadData];
    
    if (apiCount==0) {
        [self addUpdateDataToDB];
        [self gotoDetailsPage];
    }
}

-(void)addUpdateDataToDB{
    
    if (![Utility isSubscribedUser]){
        return;
    }
    
    NSString *workoutString = @"";
    NSString *favString = @"";
    
    if(dateListDict.count>0){
        NSError *error;
        NSData *listData = [NSJSONSerialization dataWithJSONObject:dateListDict options:NSJSONWritingPrettyPrinted  error:&error];
        
        if (error) {
            
            NSLog(@"Error DailyWorkout-%@",error.debugDescription);
        }
       workoutString = [[NSString alloc] initWithData:listData encoding:NSUTF8StringEncoding];
    }
    
    if(favouriteArray.count>0){
        NSError *error;
        NSData *favData = [NSJSONSerialization dataWithJSONObject:favouriteArray options:NSJSONWritingPrettyPrinted  error:&error];
        
        if (error) {
            
            NSLog(@"Error Favorite Array-%@",error.debugDescription);
        }
        
        favString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
    }
        
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    if([DBQuery isRowExist:@"dailyworkout" condition:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]]){
        [DBQuery updateDailyWorkOut:workoutString favList:favString isSync:1];
    }else{
        [DBQuery addDailyWorkOut:workoutString favList:favString];
    }
    
}

-(void)getOfflineData{
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    if([DBQuery isRowExist:@"dailyworkout" condition:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            NSArray *arr = [dbObject selectBy:@"dailyworkout" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"dailyWorkoutList",@"favSessionList",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]];
            
            if(arr.count>0){
                
                if(![Utility isEmptyCheck:arr[0][@"dailyWorkoutList"]]){
                    NSString *str = arr[0][@"dailyWorkoutList"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dailyList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    if(dailyList){
                        if(dateListDict) [dateListDict removeAllObjects];
                        [dateListDict addEntriesFromDictionary:dailyList];
                    }
                    
                }
                
                if(![Utility isEmptyCheck:arr[0][@"favSessionList"]]){
                    NSString *str = arr[0][@"favSessionList"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    NSMutableArray *favArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    if(favArray){
                        favouriteArray = favArray;
                    }
               }
                 dispatch_async(dispatch_get_main_queue(),^ {
                     [dailyTableView reloadData];
                 });
            }
            
            [dbObject connectionEnd];
        }
    }else{
        [Utility msg:@"You are in OFFLINE mode and daily sessions hasn't been previously downloaded. Please remove offline mode and download this session while you have access to the internet." title:@"Oops!\n" controller:self haveToPop:YES];
    }
    
}

-(void)offlineSessionDoneNFavourite:(NSDictionary *)dataDict isFav:(BOOL)isFav{
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    int sessionId = [[dataDict objectForKey:@"ExerciseSessionId"]intValue];
    if([DBQuery isRowExist:@"dailyworkout" condition:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            NSMutableDictionary *dict;
            NSArray *arr = [dbObject selectBy:@"dailyworkout" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"dailyWorkoutList",@"favSessionList",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]];
            
            if(arr.count>0){
                NSMutableArray *favArray = [[NSMutableArray alloc]init];
                if(![Utility isEmptyCheck:arr[0][@"favSessionList"]]){
                    NSString *str = arr[0][@"favSessionList"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    favArray = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
                    
                    NSArray *filterarray = [favArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SessionId == %d)", sessionId]];
                    if(filterarray.count>0){
                        NSInteger objectIndex= [favArray indexOfObject:filterarray[0]];
                        dict = [[NSMutableDictionary alloc]initWithDictionary:filterarray[0]];
                        int sessionCount = [dict[@"SessionCount"]intValue];
                        
//                        if(sessionCount>0 && isFav){
                        if(isFav){
                            BOOL IsFavorite = [dict[@"IsFavorite"] boolValue];
                            [dict setObject:[NSNumber numberWithBool:!IsFavorite] forKey:@"IsFavorite"];
                            [dict setObject:[NSNumber numberWithBool:true] forKey:@"IsFavDone"];
                            [favArray replaceObjectAtIndex:objectIndex withObject:dict];
                        }else if(!isFav){
                            sessionCount++;
                            [dict setObject:[NSNumber numberWithInt:sessionCount] forKey:@"SessionCount"];
                            [dict setObject:[NSNumber numberWithBool:true] forKey:@"IsCountDone"];
                            [favArray replaceObjectAtIndex:objectIndex withObject:dict];
                        }
                        
                    }else{
                        if(!isFav){
                            dict = [[NSMutableDictionary alloc]init];
                            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsFavorite"];
                            [dict setObject:[NSNumber numberWithInt:1] forKey:@"SessionCount"];
                            [dict setObject:[NSNumber numberWithBool:true] forKey:@"IsCountDone"];
                            [dict setObject:[NSNumber numberWithInt:userId] forKey:@"UserId"];
                            [dict setObject:[NSNumber numberWithInt:sessionId] forKey:@"SessionId"];
                            [favArray addObject:dict];
                        }else{
                            dict = [[NSMutableDictionary alloc]init];
                            [dict setObject:[NSNumber numberWithBool:isFav] forKey:@"IsFavorite"];
                            [dict setObject:[NSNumber numberWithInt:0] forKey:@"SessionCount"];
                            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsCountDone"];
                            [dict setObject:[NSNumber numberWithInt:userId] forKey:@"UserId"];
                            [dict setObject:[NSNumber numberWithInt:sessionId] forKey:@"SessionId"];
                            [dict setObject:[NSNumber numberWithBool:isFav] forKey:@"IsFavDone"];
                            [favArray addObject:dict];
                        }
                    }
                    
                    
                }else{
                    if(!isFav){
                        dict = [[NSMutableDictionary alloc]init];
                        [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsFavorite"];
                        [dict setObject:[NSNumber numberWithInt:1] forKey:@"SessionCount"];
                        [dict setObject:[NSNumber numberWithBool:true] forKey:@"isDone"];
                        [dict setObject:[NSNumber numberWithInt:userId] forKey:@"UserId"];
                        [dict setObject:[NSNumber numberWithInt:sessionId] forKey:@"SessionId"];
                        [favArray addObject:dict];
                    }else{
                        dict = [[NSMutableDictionary alloc]init];
                        [dict setObject:[NSNumber numberWithBool:isFav] forKey:@"IsFavorite"];
                        [dict setObject:[NSNumber numberWithInt:0] forKey:@"SessionCount"];
                        [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsCountDone"];
                        [dict setObject:[NSNumber numberWithInt:userId] forKey:@"UserId"];
                        [dict setObject:[NSNumber numberWithInt:sessionId] forKey:@"SessionId"];
                        [dict setObject:[NSNumber numberWithBool:isFav] forKey:@"IsFavDone"];
                        [favArray addObject:dict];
                    }
                    
                }
                
                if(favArray.count<=0){
                    return;
                }
                NSString *favString = @"";
                if(favArray.count>0){
                    NSError *error;
                    NSData *favData = [NSJSONSerialization dataWithJSONObject:favArray options:NSJSONWritingPrettyPrinted  error:&error];
                    
                    if (error) {
                        
                        NSLog(@"Error Favorite Array-%@",error.debugDescription);
                    }
                    
                    favString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
                }
                
                NSMutableString *modifiedExList = [NSMutableString stringWithString:favString];
                [modifiedExList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExList length])]; //AY 07032018
                
                if([dbObject connectionStart]){
                    
                    NSString *date = [NSDate date].description;
                    NSArray *columnArray = [[NSArray alloc]initWithObjects:@"favSessionList",@"isSync",@"lastUpdate",nil];
                    NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedExList,[NSNumber numberWithInt:0],date, nil];
                    
                    if([dbObject updateWithCondition:@"dailyworkout" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]]){
                        [self getOfflineData];
                    }
                }
                [dbObject connectionEnd];
            }
            if (![Utility isEmptyCheck:dict]) {
                [self offlineExerciseDetailsDone:dict];
            }
        }
    }
    
}// AY 02032018


-(void)offlineExerciseDetailsDone:(NSDictionary*)dataDict{
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    int exerciseId = [[dataDict objectForKey:@"SessionId"]intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    if([DBQuery isRowExist:@"exerciseDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,exerciseId]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            NSArray *arr = [dbObject selectBy:@"exerciseDetails" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"exerciseDetails",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,exerciseId]];
            
            if(arr.count>0){
                NSMutableDictionary *exerciseDetailsMutableDict = [[NSMutableDictionary alloc]init];
                
                if(![Utility isEmptyCheck:arr[0][@"exerciseDetails"]]){
                    NSString *str = arr[0][@"exerciseDetails"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    exerciseDetailsMutableDict = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]mutableCopy];
                    
                    if (![Utility isEmptyCheck:exerciseDetailsMutableDict]) {
                        BOOL IsFavorite = [dataDict[@"IsFavorite"] boolValue];
                        [exerciseDetailsMutableDict removeObjectForKey:@"IsFavourite"];
                        [exerciseDetailsMutableDict setObject:[NSNumber numberWithBool:IsFavorite] forKey:@"IsFavourite"];
                    }else{
                        return;
                    }
                    
                    NSString *exDetailsStr = @"";
                    
                    if(![Utility isEmptyCheck:exerciseDetailsMutableDict]){
                        NSError *error;
                        NSData *favData = [NSJSONSerialization dataWithJSONObject:exerciseDetailsMutableDict options:NSJSONWritingPrettyPrinted  error:&error];
                        if (error) {
                            NSLog(@"Error Favorite Array-%@",error.debugDescription);
                        }
                        exDetailsStr = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
                    }
                    
                    NSMutableString *modifiedExList = [NSMutableString stringWithString:exDetailsStr];
                    [modifiedExList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExList length])];
                    
                    if([dbObject connectionStart]){
                        
                        NSString *date = [NSDate date].description;
                        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"exerciseDetails",@"lastUpdate",nil];
                        NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedExList,date, nil];
                        
                        if([dbObject updateWithCondition:@"exerciseDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,exerciseId]]){
                            //                            [self getOfflineData];
                        }
                    }
                    [dbObject connectionEnd];
                }
            }
        }
    }
}

-(BOOL)isOfflineAvailable:(int)sessionId{
    BOOL isAvailable = false;
     int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    DAOReader *dbObject = [DAOReader sharedInstance];
    if([dbObject connectionStart]){
        
        NSString *query = [@"" stringByAppendingFormat:@"select et.equipmentList from exerciseTypeDetails et,dailyworkout dw,exerciseDetails ed where dw.UserId = et.UserId AND ed.UserId = et.UserId AND et.exSessionId = ed.sessionCompleteId AND ed.exerciseNames != '' AND et.exSessionId = '%d' AND dw.UserId = '%d'",sessionId,userId];
        
        NSArray *arr =[dbObject selectByQuery:[[NSArray alloc]initWithObjects:@"equipmentList",nil] query:query];
        
        if(arr.count>0){
            isAvailable = true;
        }
    }
    
    return isAvailable;
    
}// AY 14032018
-(void)gotoDetailsPage{
    NSArray *keys = [dateListDict allKeys];
    //    [[keys mutableCopy] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    NSArray *arr = [dateListDict objectForKey:[keys objectAtIndex:0]];
    if(![Utility isEmptyCheck:arr]){
        NSDictionary *dict;// = [arr objectAtIndex:0];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat: @"yyyy-MM-dd"];
        NSDate *trgtDate;
        if (_isOnlyToday) {
            trgtDate = [df dateFromString:@"2019-04-05"];//05 april for 1st time user
        } else {
            trgtDate = [NSDate date];
        }
        NSString *date = [@"" stringByAppendingFormat:@"%@",[df stringFromDate:trgtDate]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Date == %@)",[@"" stringByAppendingFormat:@"%@",[formatter stringFromDate:[formatter dateFromString:[formatter stringFromDate:[df dateFromString:date]]]]]];
        NSArray *filteredArray = [responseArray filteredArrayUsingPredicate:predicate];
        if (![Utility isEmptyCheck:filteredArray] && filteredArray.count>0) {
            if (![Utility isEmptyCheck:[filteredArray objectAtIndex:0]]) {
                dict = [filteredArray objectAtIndex:0];
                NSLog(@"%@",dict);
            }
            
        }
        if([Utility isOfflineMode]){
            NSMutableArray *myArray = [NSMutableArray new];
            NSArray *keys = [dateListDict allKeys];
            
            NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
            keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
            for (int i=0; i<keys.count; i++) {
                NSArray *arr = [dateListDict objectForKey:[keys objectAtIndex:i]];
                [myArray addObjectsFromArray:arr];
            }
            responseArray = myArray;
        }
        ExerciseTypeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseType"];
        
        if (![Utility isEmptyCheck:dict]) {
            
            int exSessionID = [[dict objectForKey:@"ExerciseSessionId"] intValue];
//            if([Utility isSubscribedUser] && [Utility isOfflineMode] && ![self isOfflineAvailable:exSessionID]){
//                [Utility msg:@"You are in OFFLINE mode and this session hasn't been previously downloaded. Please remove offline mode and download this session while you have access to the internet." title:@"Oops!\n" controller:self haveToPop:NO];
//                return;
//            }
            controller.exSessionID = exSessionID;
            controller.dateStr = [dict objectForKey:@"Date"];
            controller.sessionTitle = [dict objectForKey:@"ExerciseSessionTitle"];
            controller.isPersonalisedSession = [[dict objectForKey:@"IsPersonalised"] boolValue];  //ah ux2
            controller.exerciseSessionType = [dict objectForKey:@"ExerciseSessionType"];//AY 23102017
        }
        controller.delegate = self;
        controller.dailyWorkoutLists = ![Utility isEmptyCheck:responseArray]?[[responseArray reverseObjectEnumerator]allObjects]:[NSMutableArray new];
        controller.isOnlyToday = _isOnlyToday;
        [self.navigationController pushViewController:controller animated:NO];
    }
}
#pragma -mark IBAction
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
-(IBAction)logoTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)home:(id)sender {
    HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)checkUncheckButtonPressed:(UIButton*)sender{//add8
    if (![defaults boolForKey:@"IsNonSubscribedUser"] && ![Utility isSubscribedUser] && ![Utility isSquadLiteUser]) {//today__
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    
    
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:dailyTableView];
    NSIndexPath *indexPath = [dailyTableView indexPathForRowAtPoint:buttonPosition];
    ExerciseDailyListTableViewCell *cell = (ExerciseDailyListTableViewCell *)[dailyTableView cellForRowAtIndexPath:indexPath];
    
    if (!cell.checkUncheckButton.selected) {
        NSArray *keys = [dateListDict allKeys];
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
        keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
        
        int selectedsection = [sender.accessibilityHint intValue];
        NSArray *arr = [dateListDict objectForKey:[keys objectAtIndex:selectedsection]];
        NSDictionary *dict = [arr objectAtIndex:sender.tag];
        
        
        NSString *dateStr = [dict objectForKey:@"Date"];
        NSArray *dateArr = [dateStr componentsSeparatedByString:@"T"];
        dateStr = [dateArr objectAtIndex:0];
        
        NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
        [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dailyDate = [dailyDateformatter dateFromString:dateStr];
        
        if([Utility isSquadFreeUser] ){
            if(![dailyDate isYesterday] && ![dailyDate isDayBeforeYesterday]){
                [Utility showAlertAfterSevenDayTrail:self];
                return;
            }
        }
        
        [self webserviceCall_CountSessionDone:dict];
    }
}

-(IBAction)favButtonPressed:(UIButton*)sender{
    if (![defaults boolForKey:@"IsNonSubscribedUser"] && ![Utility isSubscribedUser] && ![Utility isSquadLiteUser]) {//today__
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    NSArray *keys = [dateListDict allKeys];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    int selectedsection = [sender.accessibilityHint intValue];
    NSArray *arr = [dateListDict objectForKey:[keys objectAtIndex:selectedsection]];
    NSDictionary *dict = [arr objectAtIndex:sender.tag];
    
    NSString *dateStr = [dict objectForKey:@"Date"];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"T"];
    dateStr = [dateArr objectAtIndex:0];
    
    NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
    [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dailyDate = [dailyDateformatter dateFromString:dateStr];
    
    if([Utility isSquadFreeUser]){
        if(![dailyDate isYesterday] && ![dailyDate isDayBeforeYesterday]){
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
    }
    
    [self webserviceCall_FavoriteSessionToggle:dict];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dateListDict.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *keys = [dateListDict allKeys];
    //    [[keys mutableCopy] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    NSArray *arr = [dateListDict objectForKey:[keys objectAtIndex:section]];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // Removes extra padding in Grouped style
    return CGFLOAT_MIN;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ExerciseDailyListHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    NSArray *keys = [dateListDict allKeys];
    //    [[keys mutableCopy] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    NSString *keyName = [keys objectAtIndex:section];
    
    NSArray *temp = [keyName componentsSeparatedByString:@"-"];
    
    NSInteger monthIndex = [temp[1] integerValue];
    
//    sectionHeaderView.exerciseHeaderTextLabel.text = [[keys objectAtIndex:section] uppercaseString];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
    NSString *monthName = [[df monthSymbols] objectAtIndex:monthIndex-1];
    sectionHeaderView.exerciseHeaderTextLabel.text = [monthName uppercaseString];
    
    return  sectionHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"ir %ld | is %ld",(long)indexPath.row,(long)indexPath.section);
    NSString *CellIdentifier = @"ExerciseDailyListTableViewCell";
    ExerciseDailyListTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ExerciseDailyListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *keys = [dateListDict allKeys];
    //    [[keys mutableCopy] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    NSArray *arr = [dateListDict objectForKey:[keys objectAtIndex:indexPath.section]];
    
    NSString *dateStr = [[arr objectAtIndex:indexPath.row] objectForKey:@"Date"];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"T"];
    dateStr = [dateArr objectAtIndex:0];
    
    NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
    [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dailyDate = [dailyDateformatter dateFromString:dateStr];
    [dailyDateformatter setDateFormat:@"EEEE d"];
//    endDateLabel.text = [dailyDateformatter stringFromDate:endDate];      2017-01-18T08:28:50.7138494+00:00
    
    NSString *suffix = @"";
    if (![dailyDate isEqual:[NSNull null]]) {
        suffix = [Utility daySuffixForDate:dailyDate];
    }
    cell.dateLabel.text = [NSString stringWithFormat:@"%@%@",[dailyDateformatter stringFromDate:dailyDate],suffix];
    if (![Utility isEmptyCheck:[[arr objectAtIndex:indexPath.row] objectForKey:@"BodyType"]]) {
        cell.catLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"BodyType"];
    } else {
        cell.catLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"ExerciseBodyType"];
    }   //ah 3.5
    
    cell.subCatLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"ExerciseSessionType"];
    
    //add8
    cell.favButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
    cell.favButton.tag =indexPath.row;
    cell.checkUncheckButton.tag=indexPath.row;
    cell.checkUncheckButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];

    int sessionId = [[[arr objectAtIndex:indexPath.row] objectForKey:@"ExerciseSessionId"]intValue];
    NSArray *filterarray = [favouriteArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SessionId == %d)", sessionId]];
    NSLog(@"%@",filterarray);
    if (![Utility isEmptyCheck:filterarray]) {
        NSDictionary *filterDict = [filterarray objectAtIndex:0];
        if ([[filterDict objectForKey:@"IsFavorite"]boolValue]) {
            cell.favButton.selected=true;
        }else{
            cell.favButton.selected=false;
        }
        if ([[filterDict objectForKey:@"SessionCount"] intValue]>0) {
            cell.checkUncheckButton.selected=true;
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup

        }else{
            cell.checkUncheckButton.selected=false;
        }
    }else{
        cell.favButton.selected=false;
        cell.checkUncheckButton.selected=false;
    }
    
    
    
    
    
    
    if([Utility isSubscribedUser] && [Utility isOfflineMode]){
        
        if([self isOfflineAvailable:sessionId]){
            //cell.contentView.alpha = 1.0;
            cell.checkUncheckButton.superview.alpha = 1.0;
            cell.catLabel.superview.alpha = 1.0;
            cell.subCatLabel.superview.alpha = 1.0;
        }else{
            //cell.contentView.alpha = 0.2;
            cell.checkUncheckButton.superview.alpha = 0.2;
            cell.catLabel.superview.alpha = 0.2;
            cell.subCatLabel.superview.alpha = 0.2;
        }
        
    }else{
        //cell.contentView.alpha = 1.0;
        cell.checkUncheckButton.superview.alpha = 1.0;
        cell.catLabel.superview.alpha = 1.0;
        cell.subCatLabel.superview.alpha = 1.0;
    }// AY 14032018
    
    
    /*if([Utility isSquadFreeUser]){
        
        if([dailyDate isYesterday] || [dailyDate isDayBeforeYesterday]){
            cell.checkUncheckButton.superview.alpha = 1.0;
            cell.catLabel.superview.alpha = 1.0;
            cell.subCatLabel.superview.alpha = 1.0;
        }else{
            cell.checkUncheckButton.superview.alpha = 0.2;
            cell.catLabel.superview.alpha = 0.2;
            cell.subCatLabel.superview.alpha = 0.2;
        }
        
    }*/

 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *keys = [dateListDict allKeys];
    //    [[keys mutableCopy] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    NSArray *arr = [dateListDict objectForKey:[keys objectAtIndex:indexPath.section]];
    if(![Utility isEmptyCheck:arr]){
        NSDictionary *dict = [arr objectAtIndex:indexPath.row];
        if (![Utility isEmptyCheck:dict]) {
            
            int exSessionID = [[dict objectForKey:@"ExerciseSessionId"] intValue];
            
            
           /* if([Utility isSquadFreeUser]){
                
                NSString *dateStr = [dict objectForKey:@"Date"];
                NSArray *dateArr = [dateStr componentsSeparatedByString:@"T"];
                dateStr = [dateArr objectAtIndex:0];
                
                NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
                [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *dailyDate = [dailyDateformatter dateFromString:dateStr];
                
                if(![dailyDate isYesterday] && ![dailyDate isDayBeforeYesterday]){
                    [Utility showAlertAfterSevenDayTrail:self];
                    return;
                }
                
            }*/
            
            if([Utility isSubscribedUser] && [Utility isOfflineMode] && ![self isOfflineAvailable:exSessionID]){
                [Utility msg:@"You are in OFFLINE mode and this session hasn't been previously downloaded. Please remove offline mode and download this session while you have access to the internet." title:@"Oops!\n" controller:self haveToPop:NO];
                return;
            }
            
            ExerciseTypeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseType"];
            controller.delegate = self;
            controller.exSessionID = exSessionID;
            controller.dateStr = [dict objectForKey:@"Date"];
            controller.sessionTitle = [dict objectForKey:@"ExerciseSessionTitle"];
            controller.isPersonalisedSession = [[dict objectForKey:@"IsPersonalised"] boolValue];  //ah ux2
            controller.exerciseSessionType = [dict objectForKey:@"ExerciseSessionType"];//AY 23102017
            [self.navigationController pushViewController:controller animated:NO];
        }
    }
}


#pragma mark - ExerciseTypeDelegate

-(void)didCheckAnyChange:(BOOL)ischanged{
    isChanged = ischanged;
}
@end
