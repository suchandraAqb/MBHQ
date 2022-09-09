//
//  WeightRecordSheetViewController.m
//  Squad
//
//  Created by AQB-Mac-Mini 3 on 23/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "WeightRecordSheetViewController.h"
#import "WeightRecordTableViewCell.h"
#import "WeightRecordHeaderView.h"
#import "ExcerciseHistoryViewController.h"


static NSString *SectionHeaderViewIdentifier = @"WeightRecordHeaderView";
@interface WeightRecordSheetViewController (){
    
    IBOutlet UITableView *weightListTable;
    UIView *contentView;
    NSMutableArray *weightRecordList;
    int apiCount;
    NSInteger currentCellSection;
    NSInteger currentCellRow;
    IBOutlet UIButton *saveButton;//AY 09112017
    NSMutableArray *saveCircuitsArray;//AY 09112017
    IBOutlet UIScrollView *mainScroll;
    
}

@end

@implementation WeightRecordSheetViewController
@synthesize exSessionId,sessionDate,workoutTypeId,fromWhere,isPlaySession,isCircuit,exerciseId,exerciseCircuitId,exerciseListArray;
#pragma mark-View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    saveButton.hidden = true;//AY 09112017
    currentCellSection = 0;
    currentCellRow=0;
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"WeightRecordHeaderView" bundle:nil];
    [weightListTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    weightListTable.hidden = true;
    weightRecordList = [[NSMutableArray alloc]init];//AY 09112017
    saveCircuitsArray = [[NSMutableArray alloc]init];//AY 09112017
    
    [self getWeightRecordData:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-End
#pragma mark-WebserviceCall
-(void)getWeightRecordData:(BOOL)isSectionReload{
    if (Utility.reachable) {
        NSError *error;
        NSString *api = @"";
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:exSessionId] forKey:@"ExerciseSessionId"];
        
        if([fromWhere isEqualToString:@"DailyWorkout"]){
            [mainDict setObject:sessionDate forKey:@"DailySessionDate"];
            api = @"GetDailyWeightSheet";
        }else if([fromWhere isEqualToString:@"customSession"]){
            api = @"AddGenerateSquadWeightSheet";
            [mainDict setObject:sessionDate forKey:@"WorkoutDate"];
            [mainDict setObject:[NSNumber numberWithInt:workoutTypeId] forKey:@"UserWorkoutSessionId"];
        }
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
           contentView = [Utility activityIndicatorView:self];
         });
        
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        //AddGenerateSquadWeightSheet GetDailyWeightSheet
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:api append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0){
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     
//                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     
                                                                     /*if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }*/
                                                                     
                                                                     if(![Utility isEmptyCheck:responseDict] && ![Utility isEmptyCheck:responseDict[@"SquadWeightSheetSetsDataModels"]]){
                                                                         weightListTable.hidden = false;
                                                                         
                                                                         if(weightRecordList.count>0){
                                                                             [weightRecordList removeAllObjects];
                                                                         }//AY 09112017
                                                                         
                                                                         if(!isPlaySession){
                                                                             
                                                                             NSArray *listArray = responseDict[@"SquadWeightSheetSetsDataModels"];
                                                                             [weightRecordList addObjectsFromArray:listArray];
                                                                             
                                                                         }else{
                                                                             
                                                                             NSArray *responseArray = responseDict[@"SquadWeightSheetSetsDataModels"];
                                                                            
                                                                             NSMutableArray *customWeightList;
                                                                             
                                                                             if(isCircuit){
                                                                                  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(CircuitId == %d)",exerciseId ];
                                                                                 customWeightList = [[NSMutableArray alloc]initWithArray:[responseArray filteredArrayUsingPredicate:predicate]];
                                                                             }else{
                                                                                  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ExerciseId == %d)",exerciseId ];
                                                                                 customWeightList = [[NSMutableArray alloc]initWithArray:[responseArray filteredArrayUsingPredicate:predicate]];
                                                                             }
                                                                             
                                                                             
                                                                             
                                                                             if(isCircuit){
                                                                                 
                                                                                 if(![Utility isEmptyCheck:customWeightList] && ![Utility isEmptyCheck:customWeightList[0][@"WeightSheetCircuitModels"]]){
                                                                                     
                                                                                     NSArray *weightModel =  customWeightList[0][@"WeightSheetCircuitModels"] ;
                                                                                     
                                                                                     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ExerciseId == %d)",exerciseCircuitId ];
                                                                                     weightModel = [weightModel filteredArrayUsingPredicate:predicate];
                                                                                     
                                                                                     NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:customWeightList[0]];
                                                                                     [dict setObject:weightModel forKey:@"WeightSheetCircuitModels"];
                                                                                     [customWeightList replaceObjectAtIndex:0 withObject:dict];
                                                                                  }
                                                                                 
                                                                             }
                                                                             
                                                                             if(![Utility isEmptyCheck:customWeightList]){
                                                                                 [weightRecordList addObjectsFromArray:customWeightList];
                                                                             }//AY 09112017
                                                                             
                                                                             
                                                                          }
                                                                         
                                                                         if(isSectionReload){
                                                                             
                                                                             NSIndexPath *indexpath = [NSIndexPath indexPathForRow:currentCellRow inSection:currentCellSection];
                                                                             
                                                                             [weightListTable reloadData];
                                                                             [weightListTable scrollToRowAtIndexPath:indexpath
                                                                                                  atScrollPosition:UITableViewScrollPositionTop
                                                                                                          animated:NO];
                                                                             
                                                                         }else{
                                                                            [weightListTable reloadData];
                                                                         }
                                                                         
                                                                         
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

-(void)deleteWeightRecordSheet:(int)sheetId circuitId:(int)circuitId exerciseId:(int)exerciseId setNo:(int)setNo isExercise:(BOOL)isExercise completion:(void (^)(BOOL status))completion{
    if (Utility.reachable) {
        NSError *error;
        
        NSString *api = @"";
        if([fromWhere isEqualToString:@"DailyWorkout"]){
            api = @"DeleteDailySquadSet";
        }else if([fromWhere isEqualToString:@"customSession"]){
            api = @"DeleteSquadSet";
        }
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:setNo] forKey:@"SetNo"];
        
        if(isExercise){
            [mainDict setObject:[NSNumber numberWithInt:sheetId] forKey:@"SquadWeightSheetId"];
            [mainDict setObject:[NSNumber numberWithInt:circuitId] forKey:@"SquadWeightSheetCircuitId"];
        }else{
            [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"SquadWeightSheetId"];
            [mainDict setObject:[NSNumber numberWithInt:circuitId] forKey:@"SquadWeightSheetCircuitId"];
        }
        
        [mainDict setObject:[NSNumber numberWithInt:exerciseId] forKey:@"ExerciseId"];
        [mainDict setObject:[NSNumber numberWithBool:0] forKey:@"IsdeleteMultipleSets"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:api append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0){
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     
                                                                     //                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     
                                                                     /*if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                      
                                                                      }
                                                                      else{
                                                                      [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                      return;
                                                                      }*/
                                                                     
                                                                     //[self getWeightRecordData:YES];
                                                                     completion(true);
                                                                     
                                                                     
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                     completion(false);
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        completion(false);
    }
}

-(void) addUpdateWeightRecord:(NSArray *)circuitsArray isExercise:(BOOL)isExercise completion:(void (^)(BOOL status))completion{
    if (Utility.reachable) {
        NSError *error;
        
        NSString *api = @"";
        if([fromWhere isEqualToString:@"DailyWorkout"]){
            api = @"AddDailyWeightsheetSets";
        }else if([fromWhere isEqualToString:@"customSession"]){
            api = @"AddSquadSets";
        }
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if(isExercise){
            [mainDict setObject:[[NSArray alloc]init] forKey:@"CircuitSetModels"];
            [mainDict setObject:circuitsArray forKey:@"ExerciseSetModels"];
        }else{
            [mainDict setObject:circuitsArray forKey:@"CircuitSetModels"];
            [mainDict setObject:[[NSArray alloc]init] forKey:@"ExerciseSetModels"];
        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:api append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0){
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     
//                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     
                                                                     /*if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                      
                                                                      }
                                                                      else{
                                                                      [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                      return;
                                                                      }*/
                                                                     
                                                                     //[self getWeightRecordData:YES];
                                                                     completion(true);
                                                                     
                                                                     
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                     completion(false);
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        completion(false);
    }
}

#pragma mark-End

#pragma mark-IBAction
- (IBAction)backButtonPressed:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.navigationController  popViewControllerAnimated:YES];
        }
    }];//AY 09112017
}
- (IBAction)logoButtonPressed:(UIButton *)sender {
    
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];//AY 09112017
}
- (IBAction)addSetButtonPressed:(UIButton *)sender {
    
    currentCellSection = sender.tag;
    currentCellRow=[sender.accessibilityHint integerValue];
   
    NSMutableDictionary *sectionDict = [[NSMutableDictionary alloc]initWithDictionary:[weightRecordList objectAtIndex:currentCellSection]];
    
    if(![Utility isEmptyCheck:sectionDict[@"CircuitId"]]){
        if(![Utility isEmptyCheck:sectionDict[@"WeightSheetCircuitModels"]]){
            NSMutableArray *weightDataArray = [[NSMutableArray alloc]initWithArray:sectionDict[@"WeightSheetCircuitModels"]];
            
            if(![Utility isEmptyCheck:weightDataArray]){
                NSMutableDictionary *weightData = [[NSMutableDictionary alloc]initWithDictionary:weightDataArray[currentCellRow]];
                if(![Utility isEmptyCheck:weightData[@"CircuitSetsModels"]]){
                    NSMutableArray *circuits = [[NSMutableArray alloc]initWithArray:weightData[@"CircuitSetsModels"]];
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[circuits lastObject]];
                    [dict setObject:[NSNumber numberWithInt:(int)circuits.count+1] forKey:@"SetNo"];
                    [dict setObject:@"0.0" forKey:@"Weight"];
                    [dict setObject:[NSNumber numberWithInt:0] forKey:@"RepGoal"];
                    [dict removeObjectForKey:@"Id"];
                    [dict setObject:[NSNumber numberWithBool:false] forKey:@"DefaultSet"];
                    [circuits addObject:dict];
                    
                    NSMutableArray *circuitsArray = [[NSMutableArray alloc]init];
                    for(int i=0;i<circuits.count;i++){
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[circuits objectAtIndex:i]];
                        [dict setObject:[NSNumber numberWithInt:[dict[@"SquadWeightSheetCircuitId"] intValue]] forKey:@"WeightSheetCircuitId"];
                        [circuitsArray addObject:dict];
                    }
                    __unsafe_unretained typeof(self) weakSelf = self;
                    [weakSelf addUpdateWeightRecord:circuitsArray isExercise:false completion:^(BOOL status) {
                        
                        if(status){
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                    [weightData setObject:circuits forKey:@"CircuitSetsModels"];
                                    [weightDataArray replaceObjectAtIndex:currentCellRow withObject:weightData];
                                    [sectionDict setObject:weightDataArray forKey:@"WeightSheetCircuitModels"];
                                    [weightRecordList replaceObjectAtIndex:currentCellSection withObject:sectionDict];
                                
                                    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:currentCellRow inSection:currentCellSection];
                                    [weightListTable reloadData];
                                    [weightListTable scrollToRowAtIndexPath:indexpath
                                                           atScrollPosition:UITableViewScrollPositionNone
                                                                   animated:NO];
                                
                            });
                         }
                       
                    }];
                }else{
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setObject:[NSNumber numberWithInt:1] forKey:@"SetNo"];
                    [dict setObject:@"0.0" forKey:@"Weight"];
                    [dict setObject:[NSNumber numberWithInt:0] forKey:@"RepGoal"];
                    [dict setObject:[@"" stringByAppendingFormat:@"%@ %@",weightData[@"RepGoal"],weightData[@"RestComment"]] forKey:@"Rep"];
                    [dict setObject:[NSNumber numberWithInt:[weightData[@"Id"] intValue]] forKey:@"WeightSheetCircuitId"];
                    [dict setObject:[NSNumber numberWithInt:[weightData[@"Id"] intValue]] forKey:@"SquadWeightSheetCircuitId"];
                    [dict setObject:[NSNumber numberWithBool:false] forKey:@"DefaultSet"];
                    NSMutableArray *circuitsArray = [[NSMutableArray alloc]init];
                    [circuitsArray addObject:dict];
                    __unsafe_unretained typeof(self) weakSelf = self;
                    [weakSelf addUpdateWeightRecord:circuitsArray isExercise:false completion:^(BOOL status) {
                        if(status){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [weightData setObject:circuitsArray forKey:@"CircuitSetsModels"];
                                [weightDataArray replaceObjectAtIndex:currentCellRow withObject:weightData];
                                [sectionDict setObject:weightDataArray forKey:@"WeightSheetCircuitModels"];
                                [weightRecordList replaceObjectAtIndex:currentCellSection withObject:sectionDict];
                                
                                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:currentCellRow inSection:currentCellSection];
                                [weightListTable reloadData];
                                [weightListTable scrollToRowAtIndexPath:indexpath
                                                       atScrollPosition:UITableViewScrollPositionNone
                                                               animated:NO];
                            });
                            
                        }
                    }];
                }
                
            }
        }
    }else{
        
            if(![Utility isEmptyCheck:sectionDict[@"ExerciseSetsModels"]]){
                NSMutableArray *circuits = [[NSMutableArray alloc]initWithArray:sectionDict[@"ExerciseSetsModels"]];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[circuits lastObject]];
                [dict setObject:[NSNumber numberWithInt:(int)circuits.count+1] forKey:@"SetNo"];
                [dict setObject:@"0.0" forKey:@"Weight"];
                [dict setObject:[NSNumber numberWithInt:0] forKey:@"RepGoal"];
                [dict removeObjectForKey:@"Id"];
                [dict setObject:[NSNumber numberWithBool:false] forKey:@"DefaultSet"];
                [circuits addObject:dict];
                
                NSMutableArray *circuitsArray = [[NSMutableArray alloc]init];
                for(int i=0;i<circuits.count;i++){
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[circuits objectAtIndex:i]];
                    [dict setObject:[NSNumber numberWithInt:[dict[@"SquadWeightSheetId"] intValue]] forKey:@"WeightSheetId"];
                    [circuitsArray addObject:dict];
                }
                __unsafe_unretained typeof(self) weakSelf = self;
                [weakSelf addUpdateWeightRecord:circuitsArray isExercise:true completion:^(BOOL status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [sectionDict setObject:circuits forKey:@"ExerciseSetsModels"];
                        [weightRecordList replaceObjectAtIndex:sender.tag withObject:sectionDict];
                        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:currentCellRow inSection:currentCellSection];
                        [weightListTable reloadData];
                        [weightListTable scrollToRowAtIndexPath:indexpath
                                               atScrollPosition:UITableViewScrollPositionNone
                                                       animated:NO];
                    });
                }];
            }else{
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict setObject:[NSNumber numberWithInt:1] forKey:@"SetNo"];
                [dict setObject:@"0.0" forKey:@"Weight"];
                [dict setObject:[NSNumber numberWithInt:0] forKey:@"RepGoal"];
                [dict setObject:[@"" stringByAppendingFormat:@"%@ %@",sectionDict[@"RepGoal"],sectionDict[@"RestComment"]] forKey:@"Rep"];
                [dict setObject:[NSNumber numberWithInt:[sectionDict[@"Id"] intValue]] forKey:@"WeightSheetId"];
                [dict setObject:[NSNumber numberWithInt:[sectionDict[@"Id"] intValue]] forKey:@"SquadWeightSheetId"];
                [dict setObject:[NSNumber numberWithBool:false] forKey:@"DefaultSet"];
                NSMutableArray *circuitsArray = [[NSMutableArray alloc]init];
                [circuitsArray addObject:dict];
                __unsafe_unretained typeof(self) weakSelf = self;
                [weakSelf addUpdateWeightRecord:circuitsArray isExercise:true completion:^(BOOL status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [sectionDict setObject:circuitsArray forKey:@"ExerciseSetsModels"];
                        [weightRecordList replaceObjectAtIndex:sender.tag withObject:sectionDict];
                        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:currentCellRow inSection:currentCellSection];
                        [weightListTable reloadData];
                        [weightListTable scrollToRowAtIndexPath:indexpath
                                               atScrollPosition:UITableViewScrollPositionNone
                                                       animated:NO];
                    });
                }];
            }
    }
    
    
    
}

- (IBAction)viewHistoryButtonPressed:(UIButton *)sender {
    
   int excerciseId=0;
    int row = [sender.accessibilityHint intValue];
    NSDictionary *sectionDict = [weightRecordList objectAtIndex:sender.tag];
    NSString *exerciseName=@"";
    if(![Utility isEmptyCheck:sectionDict[@"WeightSheetCircuitModels"]] && ![Utility isEmptyCheck:sectionDict[@"CircuitId"]]){
        NSArray *weightDataArray = sectionDict[@"WeightSheetCircuitModels"];
        
        if(![Utility isEmptyCheck:weightDataArray]){
            NSDictionary *weightData = weightDataArray[row];
            exerciseName = [weightData objectForKey:@"ExerciseName"];
            excerciseId = [weightData[@"ExerciseId"] intValue];
        }
    }else if([Utility isEmptyCheck:sectionDict[@"CircuitId"]]){
        
        if(![Utility isEmptyCheck:sectionDict] && ![Utility isEmptyCheck:sectionDict[@"ExerciseName"]]){
            exerciseName = sectionDict[@"ExerciseName"];
            
        }
        
        if(![Utility isEmptyCheck:sectionDict] && ![Utility isEmptyCheck:sectionDict[@"ExerciseId"]]){
             excerciseId = [sectionDict[@"ExerciseId"] intValue];
            
        }
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        ExcerciseHistoryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseHistoryView"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        
        controller.excerciseId =excerciseId;
        controller.exerciseName = exerciseName;
        [self presentViewController:controller animated:YES completion:nil];
    });
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    NSDictionary *sectionDict = [weightRecordList objectAtIndex:currentCellSection];
    BOOL isExercise = false;
    if([Utility isEmptyCheck:sectionDict[@"CircuitId"]]){
        isExercise = true;
    }
    
    NSLog(@"%@",saveCircuitsArray);
    __unsafe_unretained typeof(self) weakSelf = self;
    [weakSelf addUpdateWeightRecord:saveCircuitsArray isExercise:isExercise completion:^(BOOL status) {
        saveButton.hidden = true;
        [Utility msg:@"Weight data saved successfully" title:@"Success!" controller:self haveToPop:NO];
    }];
    
}

#pragma mark-End

- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {
    if (!saveButton.isHidden) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Save Changes"
                                              message:@"Your changes will be lost if you don’t save them."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Save"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self saveButtonPressed:nil];
                                       response(NO);
                                       
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Don't Save"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           response(YES);
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        response(YES);
    }
}
- (IBAction)exerciseNameButtonPressed:(UIButton *)sender {
    int excerciseId=0;
    int row = [sender.accessibilityHint intValue];
    NSDictionary *sectionDict = [weightRecordList objectAtIndex:sender.tag];
    NSString *exerciseName=@"";
    NSString *exerciseImageURL=@"";
    if(![Utility isEmptyCheck:sectionDict[@"WeightSheetCircuitModels"]] && ![Utility isEmptyCheck:sectionDict[@"CircuitId"]]){
        NSArray *weightDataArray = sectionDict[@"WeightSheetCircuitModels"];
        
        if(![Utility isEmptyCheck:weightDataArray]){
            NSDictionary *weightData = weightDataArray[row];
            exerciseName = [weightData objectForKey:@"ExerciseName"];
            excerciseId = [weightData[@"ExerciseId"] intValue];
        }
        
        if(![Utility isEmptyCheck:exerciseListArray]){
            NSDictionary *exerciseDict = [exerciseListArray objectAtIndex:sender.tag];
            if(![Utility isEmptyCheck:exerciseDict[@"CircuitExercises"]]){
                
                NSArray *exerciseArray = exerciseDict[@"CircuitExercises"];
                if(![Utility isEmptyCheck:exerciseArray[row]]){
                    NSDictionary *dict = exerciseArray[row];
                    
                    if(![Utility isEmptyCheck:dict[@"PhotoList"]]){
                        exerciseImageURL = dict[@"PhotoList"][0];
                    }
                }
                
            }
            
        }
        
        
    }else if([Utility isEmptyCheck:sectionDict[@"CircuitId"]]){
        
        if(![Utility isEmptyCheck:sectionDict] && ![Utility isEmptyCheck:sectionDict[@"ExerciseName"]]){
            exerciseName = sectionDict[@"ExerciseName"];
        }
        
        if(![Utility isEmptyCheck:exerciseListArray]){
            NSDictionary *exerciseDict = [exerciseListArray objectAtIndex:sender.tag];
            if(![Utility isEmptyCheck:exerciseDict[@"PhotoList"]]){
                exerciseImageURL = exerciseDict[@"PhotoList"][0];
            }
            
        }
        
        
        
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        ExcerciseHistoryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseHistoryView"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.isShowImage = true;
        controller.exerciseImageURL = exerciseImageURL;
        controller.excerciseId =excerciseId;
        controller.exerciseName = exerciseName;
        [self presentViewController:controller animated:YES completion:nil];
    });
}//AY 21112017

#pragma mark -Tableview Delefate and Datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return weightRecordList.count; //mealTypeArray.count
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary *sectionDict = [weightRecordList objectAtIndex:section];
    
    //NSLog(@"%ld",section);
    if((section ==0 || section+1 == weightRecordList.count) && !isPlaySession){
        return 0;
    }
    
    if([Utility isEmptyCheck:sectionDict[@"CircuitId"]]){
        return 1;
    }
    
    if(![Utility isEmptyCheck:sectionDict[@"WeightSheetCircuitModels"]]){
        NSArray *weightArray = sectionDict[@"WeightSheetCircuitModels"];
        return weightArray.count;
    }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // Removes extra padding in Grouped style
    NSDictionary *sectionDict = [weightRecordList objectAtIndex:section];
    if([Utility isEmptyCheck:sectionDict[@"CircuitId"]]){
        return 0;
    }
    return UITableViewAutomaticDimension;
    
 }
    
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    NSDictionary *sectionDict = [weightRecordList objectAtIndex:section];
    if([Utility isEmptyCheck:sectionDict[@"CircuitId"]]){
        return 0;
    }
    return 60;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    // Removes extra padding in Grouped style
    NSDictionary *sectionDict = [weightRecordList objectAtIndex:section];
    if([Utility isEmptyCheck:sectionDict[@"CircuitId"]]){
        return 0;
    }
    return 10;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
   WeightRecordHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
//    sectionHeaderView.layer.borderColor = [Utility colorWithHexString:@"66C8DB"].CGColor;
//    sectionHeaderView.layer.borderWidth = 2.0;
    sectionHeaderView.layer.cornerRadius = 5.0;
    sectionHeaderView.clipsToBounds = YES;
    
    NSDictionary *sectionDict = [weightRecordList objectAtIndex:section];
    NSString *exerciseName = @"";
    if(![Utility isEmptyCheck:sectionDict[@"CircuitName"]]){
        exerciseName = sectionDict[@"CircuitName"];
    }
    //sectionHeaderView.exerciseNameLabel.textColor = [Utility colorWithHexString:@"F427AB"];//AY 09112017
    sectionHeaderView.bgView.backgroundColor = [Utility colorWithHexString:@"F427AB"];//AY 09112017
    sectionHeaderView.exerciseNameLabel.text = exerciseName;
    
    if([Utility isEmptyCheck:sectionDict[@"CircuitId"]]){
        return nil;
    }
    
    return sectionHeaderView;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *CellIdentifier =@"WeightRecordTableViewCell";
    WeightRecordTableViewCell *cell;
    
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[WeightRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    if (weightRecordList.count == indexPath.section || indexPath.section == 1){
//        return  nil;
//    }
    
    if(isPlaySession){
        cell.exerciseNameButton.hidden = true;
    }else{
        cell.exerciseNameButton.hidden = false;
    }//AY 21112017
    
    NSDictionary *sectionDict = [weightRecordList objectAtIndex:indexPath.section];
    
    if(![Utility isEmptyCheck:sectionDict[@"CircuitId"]]){
        
        if(![Utility isEmptyCheck:sectionDict[@"WeightSheetCircuitModels"]]){
            
                NSArray *weightDataArray = sectionDict[@"WeightSheetCircuitModels"];
            
                if(![Utility isEmptyCheck:weightDataArray]){
                    NSDictionary *weightData = weightDataArray[indexPath.row];
                    NSString *circuitName = @"";
                    if(![Utility isEmptyCheck:weightData] && ![Utility isEmptyCheck:weightData[@"ExerciseName"]]){
                        circuitName = weightData[@"ExerciseName"];
                    }
                    
                    cell.circuitNameLabel.text = circuitName;
                    cell.recommendedSetLabel.text = [@"" stringByAppendingFormat:@"Recommended Sets: %d",[weightData[@"SetCount"] intValue]];
                    
                    int isSuperSet = [weightData[@"IsSuperset"] intValue];
                    int superSetPossition = [weightData[@"SuperSetPosition"] intValue];
                    if(superSetPossition > -1 && isSuperSet > 0){ //isSuperSet>=1 &&
                        cell.superSetLabel.text = @"[SUPERSET]";
                    }else{
                        cell.superSetLabel.text = @"";
                    }
                    
                    NSArray *views = cell.weightSheetStackView.arrangedSubviews;
                    if(views.count>0){
                        for(AddWeightDataView *view in views){
                            [view removeFromSuperview];
                        }
                    }
                    if(![Utility isEmptyCheck:weightData] && ![Utility isEmptyCheck:weightData[@"CircuitSetsModels"]]){
                        NSArray *circuitSets = weightData[@"CircuitSetsModels"];
                        for(int i = 0;i < circuitSets.count ; i++){
                            AddWeightDataView *dataView = [AddWeightDataView instantiateView];
                            dataView.delegate = self;
                            dataView.layer.borderColor = [Utility colorWithHexString:@"F427AB"].CGColor;
                            dataView.layer.borderWidth = 1.0;
                            dataView.layer.cornerRadius = 3.0;
                            dataView.clipsToBounds = YES;
                            dataView.weightTable = tableView;
                            dataView.cell = cell;
                            dataView.cellSection=indexPath.section;
                            dataView.cellRow=indexPath.row;
                            [dataView updateView:circuitSets withIndex:i];
                            [cell.weightSheetStackView addArrangedSubview:dataView];
                        }
                    }
                    
                }
            
            }
    }else{
        NSDictionary *weightData = sectionDict;
        NSString *circuitName = @"";
        if(![Utility isEmptyCheck:weightData] && ![Utility isEmptyCheck:weightData[@"ExerciseName"]]){
            circuitName = weightData[@"ExerciseName"];
        }
        cell.circuitNameLabel.text = circuitName;
        cell.recommendedSetLabel.text = [@"" stringByAppendingFormat:@"Recommended Sets: %d",[weightData[@"SetCount"] intValue]];
        
        int isSuperSet = [weightData[@"IsSuperset"] intValue];
        int superSetPossition = [weightData[@"SuperSetPosition"] intValue];
        if(superSetPossition > -1 && isSuperSet > 0){
            cell.superSetLabel.text = @"[SUPERSET]";
        }else{
            cell.superSetLabel.text = @"";
        }
        
        NSArray *views = cell.weightSheetStackView.arrangedSubviews;
        if(views.count>0){
            for(AddWeightDataView *view in views){
                [view removeFromSuperview];
            }
        }
        if(![Utility isEmptyCheck:weightData] && ![Utility isEmptyCheck:weightData[@"ExerciseSetsModels"]]){
            NSArray *circuitSets = weightData[@"ExerciseSetsModels"];
            for(int i = 0;i < circuitSets.count ; i++){
                AddWeightDataView *dataView = [AddWeightDataView instantiateView];
                dataView.delegate = self;
                dataView.layer.borderColor = [Utility colorWithHexString:@"F427AB"].CGColor;
                dataView.layer.borderWidth = 1.0;
                dataView.layer.cornerRadius = 3.0;
                dataView.clipsToBounds = YES;
                dataView.weightTable = tableView;
                dataView.cell = cell;
                dataView.cellSection=indexPath.section;
                dataView.cellRow=indexPath.row;
                [dataView updateView:circuitSets withIndex:i];
                [cell.weightSheetStackView addArrangedSubview:dataView];
            }
        }
    }
    
    cell.addSetButton.tag = indexPath.section;
    cell.addSetButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",indexPath.row];
    cell.viewHistoryButton.tag = indexPath.section;
    cell.viewHistoryButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",indexPath.row];
    cell.exerciseNameButton.tag = indexPath.section;//AY 21112017
    cell.exerciseNameButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",indexPath.row];//AY 21112017
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
 }
#pragma mark - End


#pragma mark - End

#pragma mark - AddWeightDataView Delegate Methods
-(void)textFieldBeginEditing:(WeightRecordTableViewCell *)cell keyboardSize:(CGSize)size {

    weightListTable.contentInset =  UIEdgeInsetsMake(0, 0, 280, 0);
    weightListTable.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 280, 0);
//    [weightListTable scrollToRowAtIndexPath:[weightListTable indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}
-(void)deleteSet:(NSDictionary *)dict cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow ofIndex:(NSInteger)index{
    NSMutableDictionary *sectionDict = [[NSMutableDictionary alloc]initWithDictionary:[weightRecordList objectAtIndex:cellSection]];
    currentCellSection = cellSection;
    currentCellRow=cellRow;
    
   
    
     if(![Utility isEmptyCheck:sectionDict[@"CircuitId"]]){
        if(![Utility isEmptyCheck:sectionDict[@"WeightSheetCircuitModels"]]){
            NSMutableArray *weightDataArray = [[NSMutableArray alloc]initWithArray:sectionDict[@"WeightSheetCircuitModels"]];
            
            if(![Utility isEmptyCheck:weightDataArray]){
                 NSMutableDictionary *weightData = [[NSMutableDictionary alloc]initWithDictionary:weightDataArray[cellRow]];
                [self deleteWeightRecordSheet:[weightData[@"SquadWeightSheetId"] intValue] circuitId:[dict[@"SquadWeightSheetCircuitId"] intValue] exerciseId:[weightData[@"ExerciseId"] intValue] setNo:[dict[@"SetNo"] intValue] isExercise:false completion:^(BOOL status) {
                    if(status){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                             UITableViewScrollPosition pos = UITableViewScrollPositionMiddle;
                            if(![Utility isEmptyCheck:weightData[@"CircuitSetsModels"]]){
                                NSMutableArray *circuits = [[NSMutableArray alloc]initWithArray:weightData[@"CircuitSetsModels"]];
                               
                                if(index > circuits.count/2.0){
                                    pos = UITableViewScrollPositionBottom;
                                }else if(cellRow < circuits.count/2.0){
                                    pos = UITableViewScrollPositionTop;
                                }
                                [circuits removeObject:dict];
                                [weightData setObject:circuits forKey:@"CircuitSetsModels"];
                            }
                            [weightDataArray replaceObjectAtIndex:cellRow withObject:weightData];
                            [sectionDict setObject:weightDataArray forKey:@"WeightSheetCircuitModels"];
                            [weightRecordList replaceObjectAtIndex:currentCellSection withObject:sectionDict];
                            
                            if([saveCircuitsArray containsObject:dict]){
                                [saveCircuitsArray removeObject:dict];
                            }
                            
                            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:currentCellRow inSection:currentCellSection];
                            [weightListTable reloadData];
                            [weightListTable scrollToRowAtIndexPath:indexpath
                                                   atScrollPosition:pos
                                                           animated:NO];
                        });
                        
                    }
                   
                    
                }];
            }
        }
     }else{
         
         [self deleteWeightRecordSheet:[dict[@"SquadWeightSheetId"] intValue] circuitId:0 exerciseId:[sectionDict[@"ExerciseId"] intValue] setNo:[dict[@"SetNo"] intValue] isExercise:true completion:^(BOOL status) {
             
             if(status){
                 
                 if(![Utility isEmptyCheck:sectionDict[@"ExerciseSetsModels"]]){
                     NSMutableArray *circuits = [[NSMutableArray alloc]initWithArray:sectionDict[@"ExerciseSetsModels"]];
                     UITableViewScrollPosition pos = UITableViewScrollPositionMiddle;
                     if(index > circuits.count/2.0){
                         pos = UITableViewScrollPositionBottom;
                     }else if(index < circuits.count/2.0){
                         pos = UITableViewScrollPositionTop;
                     }
                     [circuits removeObject:dict];
                     [sectionDict setObject:circuits forKey:@"ExerciseSetsModels"];
                     [weightRecordList replaceObjectAtIndex:cellSection withObject:sectionDict];
                     
                     if([saveCircuitsArray containsObject:dict]){
                         [saveCircuitsArray removeObject:dict];
                     }
                     
                     NSIndexPath *indexpath = [NSIndexPath indexPathForRow:currentCellRow inSection:currentCellSection];
                     [weightListTable reloadData];
                     [weightListTable scrollToRowAtIndexPath:indexpath
                                            atScrollPosition:pos
                                                    animated:NO];
                 }
             }
             
         }];
     }
}

-(void)updateWeightData:(NSDictionary *)dict ofIndex:(NSInteger)index cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    weightListTable.contentInset = contentInsets;
    weightListTable.scrollIndicatorInsets = contentInsets;
    UITableViewScrollPosition pos = UITableViewScrollPositionMiddle;
    saveButton.hidden = false;//AY 09112017
    NSMutableDictionary *sectionDict = [[NSMutableDictionary alloc]initWithDictionary:[weightRecordList objectAtIndex:cellSection]]; //[weightRecordList objectAtIndex:cellSection];
    currentCellSection = cellSection;
    currentCellRow=cellRow;
    if(![Utility isEmptyCheck:sectionDict[@"CircuitId"]]){
        if(![Utility isEmptyCheck:sectionDict[@"WeightSheetCircuitModels"]]){
            NSMutableArray *weightDataArray = [[NSMutableArray alloc]initWithArray:sectionDict[@"WeightSheetCircuitModels"]]; //sectionDict[@"WeightSheetCircuitModels"]
            
            if(![Utility isEmptyCheck:weightDataArray]){
                NSMutableDictionary *weightData = [[NSMutableDictionary alloc]initWithDictionary:weightDataArray[cellRow]];
                
                if(![Utility isEmptyCheck:weightData[@"CircuitSetsModels"]]){
                    NSMutableArray *circuits = [[NSMutableArray alloc]initWithArray:weightData[@"CircuitSetsModels"]];
                    if(index > circuits.count/2.0){
                        pos = UITableViewScrollPositionBottom;
                    }else if(index < circuits.count/2.0){
                        pos = UITableViewScrollPositionTop;
                    }
                    NSMutableDictionary *temp = [[NSMutableDictionary alloc]initWithDictionary:dict];
                    [temp setObject:[NSNumber numberWithInt:[dict[@"SquadWeightSheetCircuitId"] intValue]] forKey:@"WeightSheetCircuitId"];
                    [circuits replaceObjectAtIndex:index withObject:temp];
//                    NSMutableArray *circuitsArray = [[NSMutableArray alloc]init];
//                    for(int i=0;i<circuits.count;i++){
//                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[circuits objectAtIndex:i]];
//                        [dict setObject:[NSNumber numberWithInt:[dict[@"SquadWeightSheetCircuitId"] intValue]] forKey:@"WeightSheetCircuitId"];
//                        [circuitsArray addObject:dict];
//                    }
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SetNo == %d && SquadWeightSheetCircuitId == %d)",[dict[@"SetNo"] intValue],[dict[@"SquadWeightSheetCircuitId"] intValue]];
                    if(saveCircuitsArray.count>0){
                        NSArray *arr = [saveCircuitsArray filteredArrayUsingPredicate:predicate];
                        for(NSDictionary *dict in arr){
                            [saveCircuitsArray removeObject:dict];
                        }
                    }
                    
                    [saveCircuitsArray addObject:circuits[index]];
                    
                    [weightData setObject:circuits forKey:@"CircuitSetsModels"];
                    //[self addUpdateWeightRecord:saveCircuitsArray isExercise:false completion:^(BOOL status) {}];
                }
                [weightDataArray replaceObjectAtIndex:cellRow withObject:weightData];
                [sectionDict setObject:weightDataArray forKey:@"WeightSheetCircuitModels"];
                [weightRecordList replaceObjectAtIndex:cellSection withObject:sectionDict];
            }
        }
    }else{
        if(![Utility isEmptyCheck:sectionDict[@"ExerciseSetsModels"]]){
            NSMutableArray *circuits = [[NSMutableArray alloc]initWithArray:sectionDict[@"ExerciseSetsModels"]];
            if(index > circuits.count/2.0){
                pos = UITableViewScrollPositionBottom;
            }else if(index < circuits.count/2.0){
                pos = UITableViewScrollPositionTop;
            }
            NSMutableDictionary *temp = [[NSMutableDictionary alloc]initWithDictionary:dict];
            [temp setObject:[NSNumber numberWithInt:[dict[@"SquadWeightSheetId"] intValue]] forKey:@"WeightSheetId"];
            [circuits replaceObjectAtIndex:index withObject:temp];
            
//            NSMutableArray *circuitsArray = [[NSMutableArray alloc]init];
//            for(int i=0;i<circuits.count;i++){
//                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[circuits objectAtIndex:i]];
//                [dict setObject:[NSNumber numberWithInt:[dict[@"SquadWeightSheetId"] intValue]] forKey:@"WeightSheetId"];
//                [circuitsArray addObject:dict];
//            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SetNo == %d && SquadWeightSheetId == %d)",[dict[@"SetNo"] intValue],[dict[@"SquadWeightSheetId"] intValue]];
            
            if(saveCircuitsArray.count>0){
                NSArray *arr = [saveCircuitsArray filteredArrayUsingPredicate:predicate];
                for(NSDictionary *dict in arr){
                    [saveCircuitsArray removeObject:dict];
                }
            }
             [saveCircuitsArray addObject:circuits[index]];
            [sectionDict setObject:circuits forKey:@"ExerciseSetsModels"];
            [weightRecordList replaceObjectAtIndex:cellSection withObject:sectionDict];
            //[self addUpdateWeightRecord:saveCircuitsArray isExercise:true completion:^(BOOL status) {}];
        }
    }
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:currentCellRow inSection:currentCellSection];
    [weightListTable reloadData];
    [weightListTable scrollToRowAtIndexPath:indexpath
                           atScrollPosition:pos
                                   animated:NO];
    
}
#pragma mark - End

@end
