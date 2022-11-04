//
//  MenuSettingsViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 04/01/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "MenuSettingsViewController.h"
#import "MyProfileSettingsViewController.h"
#import "SettingsViewController.h"
#import "NutritionSettingHomeViewController.h"
#import "CustomExerciseSettingsViewController.h"
#import "ContentManagementViewController.h"
#import "LearnHomeViewController.h"

@interface MenuSettingsViewController (){
    IBOutlet UIView *headerContainerView;
   
    __weak IBOutlet UIView *profileButtonContainer;
    __weak IBOutlet UIView *contentMgmtView;
    __weak IBOutlet UIButton *contentMgmtButton;
    
    __weak IBOutlet UIView *audioContainerView;
    __weak IBOutlet UIView *nutritionContainerView;
    __weak IBOutlet UIView *exerciseContainerView;
    
    IBOutletCollection(UIView) NSArray *needInsViews;
     __weak IBOutlet UISwitch *offlineSwitch;
     UIView *contentView;
    NSString *programNameForNutrition;
    int ProgramIdForNutrition;
    NSString *programNameForExercise;
    int ProgramIdForExercise;
    int apiCount;
}

@end

@implementation MenuSettingsViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    offlineSwitch.on = [defaults boolForKey:@"isOffline"];
}
-(void)viewWillAppear:(BOOL)animated{
    // Do any additional setup after loading the view.
    if ([Utility isSubscribedUser]) {
        profileButtonContainer.alpha = 1.0f;
        contentMgmtView.alpha = 1.0f;
        offlineSwitch.superview.alpha = 1.0f;
        audioContainerView.alpha = 1.0;
        nutritionContainerView.alpha = 1.0;
        exerciseContainerView.alpha = 1.0;
    }else if([Utility isSquadLiteUser]){
        profileButtonContainer.alpha = 1.0f;
        contentMgmtView.alpha = 0.5f;
        offlineSwitch.superview.alpha = 0.5f;
        audioContainerView.alpha = 0.5;
        nutritionContainerView.alpha = 0.5;
        exerciseContainerView.alpha = 0.5;
    }
    else{
        profileButtonContainer.alpha = 0.5f;
        contentMgmtView.alpha = 0.5f;
        offlineSwitch.superview.alpha = 0.5f;
        audioContainerView.alpha = 0.5;
        nutritionContainerView.alpha = 0.5;
        exerciseContainerView.alpha = 0.5;
    }
    apiCount=0;
    if([Utility isSubscribedUser] && ![Utility isOfflineMode]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self webserviceCall_CheckMiniProgramForExercise];
            [self webserviceCall_CheckMiniProgramForNutrition];
        });
    }
    
 
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self showInstructionOverlays];
   //if([Utility isSubscribedUser]){
        if (![Utility isEmptyCheck:[defaults objectForKey:@"InstructionOverlays"]]){
            NSMutableArray *insArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"InstructionOverlays"]];
            if (![insArray containsObject:@"MENUSETTING"]) {
                //[self helpButtonPressed:helpButton];
                [self showInstructionOverlays];
                [insArray addObject:@"MENUSETTING"];
                [defaults setObject:insArray forKey:@"InstructionOverlays"];
            }
        }else {
            //[self helpButtonPressed:helpButton];
            [self showInstructionOverlays];
            NSMutableArray *insArray = [[NSMutableArray alloc] init];
            [insArray addObject:@"MENUSETTING"];
            [defaults setObject:insArray forKey:@"InstructionOverlays"];
        }
   //}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - End
#pragma mark - Private Method
-(void)syncOfflineDailyWorkOutData{
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    if([DBQuery isRowExist:@"dailyworkout" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and isSync = 0",userId]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            NSArray *arr = [dbObject selectBy:@"dailyworkout" withColumn:[[NSArray alloc]initWithObjects:@"favSessionList",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and isSync = 0",userId]];
            
            if(arr.count>0){
                
                if(![Utility isEmptyCheck:arr[0][@"favSessionList"]]){
                    NSString *str = arr[0][@"favSessionList"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    NSMutableArray *favArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    if(favArray){
                        NSArray *filterarray = [favArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsFavDone == true OR IsCountDone == true)"]];
                        
                        if(filterarray.count>0)[self webserviceCall_FavoriteSessionandCountUpdate:filterarray];
                    }
                }
                dispatch_async(dispatch_get_main_queue(),^ {
                    
                });
            }
            
            [dbObject connectionEnd];
        }
    }
    
}// AY 02032018

-(void)syncOfflineCustomWorkOutData{
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    if([DBQuery isRowExist:@"customExerciseList" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and isSync = 0",userId]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            //NSArray *arr = [dbObject selectBy:@"customExerciseList" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"exerciseList",@"joiningDate",@"weekStartDate",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStartDateStr]];
            
            NSArray *arr = [dbObject selectBy:@"customExerciseList" withColumn:[[NSArray alloc]initWithObjects:@"exerciseList",@"weekStartDate",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and isSync = 0",userId]];
            
            if(arr.count>0){
                
                for(int i=0;i<arr.count;i++){
                    
                    if(![Utility isEmptyCheck:arr[i][@"exerciseList"]]){
                        NSString *str = arr[i][@"exerciseList"];
                        NSString *weekStart = arr[i][@"weekStartDate"];
                        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                        NSMutableArray *favArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        
                        if(favArray){
                            NSArray *filterarray = [favArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsFavDone == true OR IsCountDone == true)"]];
                            
                            if(filterarray.count>0){
                                [self webserviceCall_CustomWorkOutFavoriteSessionandCountUpdate:filterarray weekStart:weekStart];
                            }
                        }
                    }
                    
                }
                
            }
            
            [dbObject connectionEnd];
        }
    }
    
}// AY 07032018

-(void)webserviceCall_FavoriteSessionandCountUpdate:(NSArray *)favArray{
    
    if (Utility.reachable) {
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:favArray forKey:@"FavoriteSessionList"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"FavoriteSessionandCountUpdate" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     NSLog(@"Update Offline data Response: %@",responseString);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
                                                                         
                                                                         NSArray *favouriteArray = [responseDict objectForKey:@"FavoriteSessionList"];
                                                                         NSString *favString =@"";
                                                                         if(favouriteArray.count>0){
                                                                             NSError *error;
                                                                             NSData *favData = [NSJSONSerialization dataWithJSONObject:favouriteArray options:NSJSONWritingPrettyPrinted  error:&error];
                                                                             
                                                                             if (error) {
                                                                                 
                                                                                 NSLog(@"Error Favorite Array-%@",error.debugDescription);
                                                                             }
                                                                             
                                                                             favString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
                                                                         }
                                                                         
                                                                         if(favString.length <= 0){
                                                                             return ;
                                                                         }
                                                                         
                                                                         NSMutableString *modifiedExList = [NSMutableString stringWithString:favString];
                                                                         [modifiedExList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExList length])]; //AY 07032018
                                                                         
                                                                         DAOReader *dbObject = [DAOReader sharedInstance];
                                                                         if([dbObject connectionStart]){
                                                                             
                                                                             NSString *date = [NSDate date].description;
                                                                             NSArray *columnArray = [[NSArray alloc]initWithObjects:@"favSessionList",@"isSync",@"lastUpdate",nil];
                                                                             NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedExList,[NSNumber numberWithInt:1],date, nil];
                                                                             
                                                                             [dbObject updateWithCondition:@"dailyworkout" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]];
                                                                         }
                                                                         
                                                                         
                                                                         [dbObject connectionEnd];
                                                                     }
                                                                     
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }
}// AY 02032018

-(void)webserviceCall_CustomWorkOutFavoriteSessionandCountUpdate:(NSArray *)favArray weekStart:(NSString *)weekStart{
    
    if (Utility.reachable) {
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:favArray forKey:@"FavoriteSessionList"];
        [mainDict setObject:weekStart forKey:@"dt"];
        [mainDict setObject:weekStart forKey:@"UserStep"];
        [mainDict setObject:[NSNumber numberWithInteger:0] forKey:@"UserStep"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SyncSquadUserWorkoutSessionData" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     NSLog(@"Update Offline data Response: %@",responseString);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
                                                                         
                                                                         NSArray *favouriteArray = [responseDict objectForKey:@"SquadUserWorkoutSessionList"];
                                                                         NSString *favString =@"";
                                                                         if(favouriteArray.count>0){
                                                                             NSError *error;
                                                                             NSData *favData = [NSJSONSerialization dataWithJSONObject:favouriteArray options:NSJSONWritingPrettyPrinted  error:&error];
                                                                             
                                                                             if (error) {
                                                                                 
                                                                                 NSLog(@"Error Favorite Array-%@",error.debugDescription);
                                                                             }
                                                                             
                                                                             favString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
                                                                         }
                                                                         
                                                                         if(favString.length <= 0){
                                                                             return ;
                                                                         }
                                                                         
                                                                         NSMutableString *modifiedExList = [NSMutableString stringWithString:favString];
                                                                         [modifiedExList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExList length])]; //AY 07032018
                                                                         
                                                                         DAOReader *dbObject = [DAOReader sharedInstance];
                                                                         if([dbObject connectionStart]){
                                                                             
                                                                             NSString *date = [NSDate date].description;
                                                                             NSArray *columnArray = [[NSArray alloc]initWithObjects:@"exerciseList",@"isSync",@"lastUpdate",nil];
                                                                             NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedExList,[NSNumber numberWithInt:0],date, nil];
                                                                             
                                                                             [dbObject updateWithCondition:@"customExerciseList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStart]];
                                                                         }
                                                                         
                                                                         
                                                                         [dbObject connectionEnd];
                                                                     }
                                                                     
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }
}// AY 07032018

-(void)webserviceCall_CheckMiniProgramForNutrition{
    if (Utility.reachable) {
        apiCount++;
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            if (contentView) {
        //                [contentView removeFromSuperview];
        //            }
        //            contentView = [Utility activityIndicatorView:self];
        //        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"SquadUserId"];
        //        [mainDict setObject:[dict objectForKey:@"ProgramId"] forKey:@"ProgramId"];
        //        [mainDict setObject:[dict objectForKey:@"UserMiniProgramId"] forKey:@"UserProgramId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"CheckMiniProgramForNutrition" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 //                                                                 if (contentView) {
                                                                 //                                                                     [contentView removeFromSuperview];
                                                                 //                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"SquadMiniProgramModel"]]) {
                                                                             NSDictionary *squadMiniProgramModel = [responseDict objectForKey:@"SquadMiniProgramModel"];
                                                                             if (![Utility isEmptyCheck:[squadMiniProgramModel objectForKey:@"ProgramName"]]) {
                                                                                 self->programNameForNutrition = [squadMiniProgramModel objectForKey:@"ProgramName"];
                                                                             }
                                                                             if (![Utility isEmptyCheck:[squadMiniProgramModel objectForKey:@"ProgramId"]]) {
                                                                                 self->ProgramIdForNutrition = [[squadMiniProgramModel objectForKey:@"ProgramId"] intValue];
                                                                             }
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
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
-(void)webserviceCall_CheckMiniProgramForExercise{
    if (Utility.reachable) {
        apiCount++;
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            if (contentView) {
        //                [contentView removeFromSuperview];
        //            }
        //            contentView = [Utility activityIndicatorView:self];
        //        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"SquadUserId"];
        //        [mainDict setObject:[dict objectForKey:@"ProgramId"] forKey:@"ProgramId"];
        //        [mainDict setObject:[dict objectForKey:@"UserMiniProgramId"] forKey:@"UserProgramId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"CheckMiniProgramForExercise" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 //                                                                 if (contentView) {
                                                                 //                                                                     [contentView removeFromSuperview];
                                                                 //                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"SquadMiniProgramModel"]]) {
                                                                             NSDictionary *squadMiniProgramModel = [responseDict objectForKey:@"SquadMiniProgramModel"];
                                                                             if (![Utility isEmptyCheck:[squadMiniProgramModel objectForKey:@"ProgramName"]]) {
                                                                                 self->programNameForExercise = [squadMiniProgramModel objectForKey:@"ProgramName"];
                                                                             }
                                                                             if (![Utility isEmptyCheck:[squadMiniProgramModel objectForKey:@"ProgramId"]]) {
                                                                                 self->ProgramIdForExercise = [[squadMiniProgramModel objectForKey:@"ProgramId"] intValue];
                                                                             }
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
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
-(void)checkOfflineAccess{
    [Utility msg:@"You are in OFFLINE mode. Go Online to access this functionality." title:@"Oops!\n" controller:self haveToPop:NO];
}


-(void)makeUserLogin{
   
    NSString *email = [defaults objectForKey:@"Email"];
    NSString *password = [defaults objectForKey:@"Password"];
    
    if(![Utility isEmptyCheck:email]){
        if (![Utility validateEmail:email]) {
            [Utility msg:@"Please enter a valid email." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        
    }else{
        [Utility msg:@"Please enter your email." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
    if([Utility isEmptyCheck:password]){
        [Utility msg:@"Please enter your password." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
    
    if (Utility.reachable) {
         //[Utility logoutChatSdk];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:email forKey:@"EmailAddress"];
        [mainDict setObject:password forKey:@"Password"];
        [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IncludeAbbbcOnline"];
        
        if ([defaults boolForKey:@"IsFbUser"]) {
            if(![Utility isEmptyCheck:[defaults objectForKey:@"facebookTokenString"]]){
                NSString *fbToken =[defaults objectForKey:@"facebookTokenString"];
                [mainDict setObject:fbToken forKey:@"FacebookToken"];
            }
        }
        
        //Added on AY 17042018
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if(![Utility isEmptyCheck:version]){
            [mainDict setObject:version forKey:@"AppVersion"];
        }
        [mainDict setObject:@"ios" forKey:@"AppPlatform"];
        //End
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"LogInApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     
                                                                     
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSMutableDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         for (NSString *key in [responseDictionary allKeys]) {
                                                                             if ([[responseDictionary objectForKey:key] class] ==[NSNull class]) {
                                                                                 [responseDictionary removeObjectForKey:key];
                                                                             }
                                                                         }
                                                                         [defaults setObject:[responseDictionary valueForKey:@"ActiveUntil"] forKey:@"TempTrialEndDate"];
                                                                         [defaults setBool:YES forKey:@"CompletedStartupChecklist"]; //AmitY
                                                                         
                                                                         [defaults setBool:false forKey:@"IsNonSubscribedUser"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"EmailAddress"] forKey:@"Email"];
                                                                         [defaults   setObject:password forKey:@"Password"];
                                                                         [defaults setObject:responseDictionary forKey:@"LoginData"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"UserID"] forKey:@"UserID"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"ABBBCOnlineUserId"] forKey:@"ABBBCOnlineUserId"];
                                                                         
                                                                         if(![Utility isEmptyCheck:responseDictionary[@"ProfilePicUrl"]]){
                                                                             [defaults setObject:responseDictionary[@"ProfilePicUrl"] forKey:@"ProfilePicUrl"];
                                                                         }
                                                                         
                                                                         [defaults setObject:[responseDictionary valueForKey:@"FirstName"] forKey:@"FirstName"];//add24
                                                                         
                                                                         [defaults setObject:[responseDictionary valueForKey:@"LastName"] forKey:@"LastName"];//Added by AY 25042018
                                                                         
                                                                         [defaults setObject:[responseDictionary valueForKey:@"ABBBCOnlineUserSessionId"] forKey:@"ABBBCOnlineUserSessionId"];
                                                                         
                                                                         [defaults setObject:[responseDictionary valueForKey:@"FbWorldForumUrl"] forKey:@"FbWorldForumUrl"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"FbCityForumUrl"] forKey:@"FbCityForumUrl"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"FbSuburbForumUrl"] forKey:@"FbSuburbForumUrl"];
                                                                         
                                                                         NSString *disStat = ([[responseDictionary valueForKey:@"DiscoverableStatus"] boolValue]) ? @"yes" : @"no";
                                                                         [defaults setObject:disStat forKey:@"Discoverable"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"FirebaseToken"] forKey:@"FirebaseToken"];
                                                                         
                                                                         int access_level = [[responseDictionary valueForKey:@"access_level"] intValue];
                                                                         
                                                                         if(access_level == 2){
                                                                             [defaults setBool:true forKey:@"isSquadLite"];
                                                                             [defaults setBool:true forKey:@"CompletedStartupChecklist"];
                                                                         }else{
                                                                             [defaults setBool:false forKey:@"isSquadLite"];
                                                                         }
                                                                         
                                                                         if(![Utility isEmptyCheck:responseDictionary[@"LifeToken"]]){
                                                                             
                                                                             NSMutableDictionary *dict = [NSMutableDictionary new];
                                                                             [dict setObject:responseDictionary[@"LifeToken"] forKey:@"LifeToken"];
                                                                             [dict setObject:[NSDate date] forKey:@"ExpiryDate"];
                                                                             
                                                                             [defaults setObject:dict forKey:@"LifeTokenDetails"];
                                                                             
                                                                         }
                                                                         
                                                                         int signupVia = [[responseDictionary objectForKey:@"SignupMethod"] intValue];
                                                                         
                                                                         [defaults setObject:[NSNumber numberWithInt:signupVia] forKey:@"SignupVia"];
                                                                         
                                                                         
//                                                                         [self syncOfflineDailyWorkOutData];
//                                                                         [self syncOfflineCustomWorkOutData];
                                                                        
                                                                         
                                                                     }else{
                                                                         
                                                                         offlineSwitch.on = !offlineSwitch.isOn;
                                                                         [defaults setBool:offlineSwitch.isOn forKey:@"isOffline"];
                                                                         
                                                                         if (![Utility isEmptyCheck:responseString]) {
                                                                             [Utility msg:responseString title:@"Error !" controller:self haveToPop:NO];
                                                                         }else{
                                                                             [Utility msg:@"Email or Password is not correct.Please enter correct Email & Password and try again." title:@"Error !" controller:self haveToPop:NO];
                                                                         }
                                                                         return;
                                                                     }
                                                                     
                                                                 }else{
                                                                     offlineSwitch.on = !offlineSwitch.isOn;
                                                                     [defaults setBool:offlineSwitch.isOn forKey:@"isOffline"];
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        offlineSwitch.on = !offlineSwitch.isOn;
        [defaults setBool:offlineSwitch.isOn forKey:@"isOffline"];
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}





#pragma mark - End
#pragma mark - IBAction

- (IBAction)offlineModeChange:(UISwitch *)sender {
    
    if([Utility isSquadLiteUser]){
        offlineSwitch.on = false;
        [Utility showSubscribedAlert:self];
        return;
    }else if([Utility isSquadFreeUser]){
        offlineSwitch.on = false;
        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }
    
    if([Utility isSubscribedUser]){
        [defaults setBool:sender.isOn forKey:@"isOffline"];
        if(!sender.isOn){
            if([defaults boolForKey:@"IsNonSubscribedUser"]){
//                [self syncOfflineDailyWorkOutData];
//                [self syncOfflineCustomWorkOutData];
            }else{
               [self makeUserLogin];
            }
            
        }// AY 02032018
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeOfflineStatus" object:nil];// AY 06032018
    }else{
        
        offlineSwitch.on = false;
        [Utility showSubscribedAlert:self];
    }
}


- (IBAction)settingButtonPressed:(UIButton *)sender {//15may2018
    if (sender.tag == 1){
        if ([Utility isSubscribedUser] || [Utility isSquadLiteUser]) {
            
            if([Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(),^ {
                MyProfileSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyProfileSettingsView"];
                [self.navigationController pushViewController:controller animated:YES];
            });
        }else if([Utility isSquadFreeUser]){
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
        else{
            [Utility showSubscribedAlert:self];
        }
    }else if (sender.tag == 2){
        
        if([Utility isSquadLiteUser]){
            [Utility showSubscribedAlert:self];
            return;
        }else if([Utility isSquadFreeUser]){
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
        dispatch_async(dispatch_get_main_queue(),^ {
            SettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Settings"];
            [self.navigationController pushViewController:controller animated:YES];
        });
        
    }else if (sender.tag == 3){
        
        BOOL isSetProgramActive = NO;
        if (![Utility isEmptyCheck:programNameForNutrition] && ProgramIdForNutrition>0) {
            isSetProgramActive = YES;
        }
        
        if([Utility isSquadLiteUser]){
            [Utility showSubscribedAlert:self];
            return;
        }else if([Utility isSquadFreeUser]){
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
        
        if (![defaults boolForKey:@"IsNonSubscribedUser"] && ![Utility isSubscribedUser] && ![Utility isSquadLiteUser]) {//today__
            NutritionSettingHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionSettingHomeView"];
            [Utility showTrailLoginAlert:self ofType:controller];
            return;
        }
        
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self checkOfflineAccess];
            return;
        }
        dispatch_async(dispatch_get_main_queue(),^ {
            NSString *msgStr=@"";
            NSString *okStr;
             if (isSetProgramActive) {
                 msgStr = [@"" stringByAppendingFormat:@"\nYou are currently doing the %@.\nChanges to your customised settings will only come into affect after the %@ ends or is cancelled.\nTo cancel the %@ and revert to your customised plan today click REVERT.\nTo continue on the %@ , click CLOSE.",[self->programNameForNutrition uppercaseString],[self->programNameForNutrition uppercaseString],[self->programNameForNutrition uppercaseString],[self->programNameForNutrition uppercaseString]];
                 okStr = @"REVERT";
             }else{
                 msgStr = @"Are you certain you want to change your nutrition settings?  This will change your nutrition plan from today onward.";
                 okStr = @"OK";
             }
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"ALERT!"
                                                  message:msgStr
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"CLOSE"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               
                                           }];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:okStr
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                            if (isSetProgramActive) {
                                                LearnHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LearnHome"];
                                                [self.navigationController pushViewController:controller animated:YES];
                                                UIButton *button = [UIButton new];
                                                button.tag = 6;
                                                [controller itemButtonPressed:button];
                                            }else{
                                                NutritionSettingHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionSettingHomeView"];
                                                [self.navigationController pushViewController:controller animated:YES];
                                            }
                                          
                                       }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
        
    }else if (sender.tag == 4){
        BOOL isSetProgramActive = NO;
        if (![Utility isEmptyCheck:self->programNameForExercise] && ProgramIdForExercise>0) {
            isSetProgramActive = YES;
        }
        
        if([Utility isSquadLiteUser]){
            [Utility showSubscribedAlert:self];
            return;
        }else if([Utility isSquadFreeUser]){
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
        
        if (![defaults boolForKey:@"IsNonSubscribedUser"] && ![Utility isSubscribedUser] && ![Utility isSquadLiteUser]) {//today__
            CustomProgramSetupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomProgramSetup"];
            [Utility showTrailLoginAlert:self ofType:controller];
            return;
        }
        
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self checkOfflineAccess];
            return;
        }
        dispatch_async(dispatch_get_main_queue(),^ {
            NSString *msgStr=@"";
            NSString *okStr;
            if (isSetProgramActive) {
                msgStr = [@"" stringByAppendingFormat:@"\nYou are currently doing the %@.\nChanges to your customised settings will only come into affect after the %@ ends or is cancelled.\nTo cancel the %@ and revert to your customised plan today click REVERT.\nTo continue on the %@ , click CLOSE.",[self->programNameForExercise uppercaseString],[self->programNameForExercise uppercaseString],[self->programNameForExercise uppercaseString],[self->programNameForExercise uppercaseString]];
                okStr = @"REVERT";
            }else{
                msgStr = @"Are you certain you want to change your workout settings?  This will change your custom workout plan from next week onward.";
                okStr = @"OK";
            }
            UIAlertController *alertController = [UIAlertController //15may2018
                                                  alertControllerWithTitle:@"ALERT!"
                                                  message:msgStr
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"CLOSE"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               
                                           }];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:okStr
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           if (isSetProgramActive) {
                                               LearnHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LearnHome"];
                                               [self.navigationController pushViewController:controller animated:YES];
                                               UIButton *button = [UIButton new];
                                               button.tag = 6;
                                               [controller itemButtonPressed:button];
                                           }else{
                                               CustomExerciseSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomExerciseSettings"];
                                               [self.navigationController pushViewController:controller animated:YES];
                                           }
                                          
                                       }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        });
        
    }else if (sender.tag == 6){
        
        if([Utility isSquadLiteUser]){
            [Utility showSubscribedAlert:self];
            return;
        }else if([Utility isSquadFreeUser]){
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
        
        if([Utility isSubscribedUser]){
            dispatch_async(dispatch_get_main_queue(),^ {
                ContentManagementViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContentManagementView"];
                [self.navigationController pushViewController:controller animated:YES];
            });
        }else{
            [Utility showSubscribedAlert:self];
        }
        
    }
}


#pragma  mark -Show Instructions
- (void) showInstructionOverlays {
    
        NSMutableArray *overlayViews = [[NSMutableArray alloc] init];
        NSArray *messageArray = @[@"Content Management allows you to remove seminars/courses or videos you have downloaded to your app to free up space."
                                  ];
   
        for(int i=0;i<needInsViews.count;i++){
            
                UIView *insView = needInsViews[i];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict setObject:insView forKey:@"view"];
                [dict setObject:@NO forKey:@"onTop"];
                [dict setObject:messageArray[i] forKey:@"insText"];
                [dict setObject:@YES forKey:@"isCustomFrame"];
                NSLog(@"%@",NSStringFromCGRect([self.view convertRect:insView.bounds fromView:insView]));
                CGRect tempRect=[self.view convertRect:insView.bounds fromView:insView];
            
                CGRect rect = CGRectMake(tempRect.origin.x, tempRect.origin.y-(tempRect.size.height/2), tempRect.size.width, tempRect.size.height);
                [dict setObject:[NSValue valueWithCGRect:rect] forKey:@"frame"];
                [overlayViews addObject:dict];
           
         }
    
    
    [Utility initializeInstructionAt:self OnViews:overlayViews];
}
#pragma  mark -End


@end
