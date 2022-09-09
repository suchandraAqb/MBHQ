//
//  MyExercisePlanViewController.m
//  ABBBCOnline
//
//  Created by AQB Mac 4 on 20/11/16.
//  Copyright © 2016 Aqb. All rights reserved.
//

#import "MyExercisePlanViewController.h"
#import "MyExercisePlanCollectionViewCell.h"
#import "WeekCollectionViewCell.h"
#import "ExerciseTableViewCell.h"
#import "EditSessionViewController.h"
#import "ExerciseDetailsViewController.h"

@interface MyExercisePlanViewController (){
    IBOutlet UICollectionView *collection;
    NSMutableArray *myExercisePlanArray;
    UIView *contentView;
    IBOutlet UICollectionView *weekCollectionView;
    int tempCurrentWeek;
    NSDictionary *courseData;
    IBOutlet UILabel *blankMsgLabel;
}

@end

@implementation MyExercisePlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myExercisePlanArray = [[NSMutableArray alloc]init];
    tempCurrentWeek = [[defaults objectForKey:@"CurrentWeekNumber"]intValue];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self serviceCall];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [weekCollectionView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tempCurrentWeek-1 inSection:0];
    [weekCollectionView scrollToItemAtIndexPath:indexPath
                               atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                       animated:YES];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)serviceCall{
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getCourseDetails];
        [self getMyExerciseData];
    });
}
-(void)getCourseDetails{
    if (contentView) {
        [contentView removeFromSuperview];
    }
    NSString* filepath = [[NSBundle mainBundle]pathForResource:@"GetCourseWeek" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
        NSDictionary *dict =[responseDictionary objectForKey:@"obj"];
        if (![Utility isEmptyCheck:dict]) {
            courseData = dict;
        }else{
            [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
            return;
        }
        
    }else{
        [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
        return;
    }

    
    
//    if (Utility.reachable) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (contentView) {
//                [contentView removeFromSuperview];
//            }
//            contentView = [Utility activityIndicatorView:self];
//
//        });
//        NSURLSession *loginSession = [NSURLSession sharedSession];
//        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetCourseWeekApiCall" append:[@"?" stringByAppendingFormat:@"courseId=%@&weekNumber=%@",[defaults objectForKey:@"CourseID"],[NSNumber numberWithInt:tempCurrentWeek]] forAction:@"GET"];
//        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
//                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                             dispatch_async(dispatch_get_main_queue(),^ {
//                                                                 if (contentView) {
//                                                                     //[contentView removeFromSuperview];
//                                                                 }
//                                                                 if(error == nil)
//                                                                 {
//                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
//                                                                         NSDictionary *dict =[responseDictionary objectForKey:@"obj"];
//                                                                         if (![Utility isEmptyCheck:dict]) {
//                                                                             courseData = dict;
//                                                                         }else{
//                                                                             [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
//                                                                             return;
//                                                                         }
//                                                                         
//                                                                     }else{
//                                                                         [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
//                                                                         return;
//                                                                     }
//                                                                     
//                                                                 }else{
//                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
//                                                                 }
//                                                             });
//                                                         }];
//        [dataTask resume];
//        
//    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
//    }
    
}
-(NSArray*)daysInWeek:(int)weekOffset fromDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    //create date on week start
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:(0 - ([comps weekday] - weekOffset))];
    NSDate *weekstart = [calendar dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    //add 7 days
    NSMutableArray* week=[NSMutableArray arrayWithCapacity:7];
    for (int i=0; i<7; i++) {
        NSDateComponents *compsToAdd = [[NSDateComponents alloc] init];
        compsToAdd.day=i;
        NSDate *nextDate = [calendar dateByAddingComponents:compsToAdd toDate:weekstart options:0];
        [week addObject:[formatter stringFromDate:nextDate ]];
        
    }
    return [NSArray arrayWithArray:week];
}
-(void)getMyExerciseData{
    if (contentView) {
        [contentView removeFromSuperview];
    }
    NSString* filepath = [[NSBundle mainBundle]pathForResource:@"MyExerciseData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
        NSArray *exerciseArray =[responseDictionary objectForKey:@"obj"];
        if (![Utility isEmptyCheck:exerciseArray] && exerciseArray.count > 0) {
            NSArray *uniqueDates = [exerciseArray valueForKeyPath:@"@distinctUnionOfObjects.SessionDate"];
            NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"self"
                                                                         ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
            NSArray *sortedArray = [uniqueDates sortedArrayUsingDescriptors:sortDescriptors];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
            
            //                                                                             [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];  //arnab new
            if (sortedArray.count > 0) {
                NSString *sessionDate =[sortedArray objectAtIndex:0];
                if (![Utility isEmptyCheck:sessionDate]) {
                    //                                                                                     formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS"; //arnab
                    NSDate *fstDate = [formatter dateFromString:sessionDate ];
                    if (fstDate == nil) {      //arnab new
                        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
                        fstDate = [formatter dateFromString:sessionDate ];
                    }
                    NSArray *weekDayArray = [self daysInWeek:2 fromDate:fstDate];
                    for (NSString *date in weekDayArray) {
                        NSArray *filteredarray = [exerciseArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SessionDate == %@)", date]];
                        if (filteredarray.count > 0) {
                            [myExercisePlanArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredarray,@"exerciseData",date,@"day", nil]];
                            
                        }else{
                            [myExercisePlanArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray array],@"exerciseData",date,@"day", nil]];
                        }
                    }
                    [collection reloadData];
                    collection.hidden = false;
                    blankMsgLabel.hidden = true;
                    
                }else{
                    [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                    return;
                }
            }else{
                [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                return;
            }
            
            
            
        }else{
            NSLog(@"-------%@",courseData);
            NSString *courseStartDateString = [courseData objectForKey:@"StartDate"];
            if (![Utility isEmptyCheck:courseStartDateString]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                [formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
                NSDate *date = [formatter dateFromString:courseStartDateString];
                NSDate *nextWeekPlanGenerationDate = [date dateByAddingTimeInterval:-60*60*60];
                
                formatter.dateFormat = @"EEEE, dd-MMM-yyyy";
                NSString *releasedDate = [formatter stringFromDate:nextWeekPlanGenerationDate];
                formatter.dateFormat = @"HH a";
                NSString *releasedTime = [formatter stringFromDate:nextWeekPlanGenerationDate];
                blankMsgLabel.text = [@"" stringByAppendingFormat:@"Your Week %d Exercise Plan will be released on %@ at %@.",tempCurrentWeek,releasedDate,releasedTime];
                [collection reloadData];
                collection.hidden = true;
                blankMsgLabel.hidden = false;
            }
        }
        
    }else{
        [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
        return;
    }
//    if (Utility.reachable) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (contentView) {
//                [contentView removeFromSuperview];
//            }
//            myExercisePlanArray = [[NSMutableArray alloc]init];
//            collection.hidden = true;
//            blankMsgLabel.hidden = true;
//            contentView = [Utility activityIndicatorView:self];
//        });
//        NSURLSession *loginSession = [NSURLSession sharedSession];
//        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"MyExerciseDataApiCall" append:[@"?" stringByAppendingFormat:@"userId=%@&courseId=%@&weekNumber=%@", [defaults objectForKey:@"UserID"],[defaults objectForKey:@"CourseID"],[NSNumber numberWithInt: tempCurrentWeek ]] forAction:@"GET"];
//        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
//                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                             dispatch_async(dispatch_get_main_queue(),^ {
//                                                                 if (contentView) {
//                                                                     [contentView removeFromSuperview];
//                                                                 }
//                                                                 if(error == nil)
//                                                                 {
//                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
//                                                                         NSArray *exerciseArray =[responseDictionary objectForKey:@"obj"];
//                                                                         if (![Utility isEmptyCheck:exerciseArray] && exerciseArray.count > 0) {
//                                                                             NSArray *uniqueDates = [exerciseArray valueForKeyPath:@"@distinctUnionOfObjects.SessionDate"];
//                                                                             NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"self"
//                                                                                                                                          ascending:YES];
//                                                                             NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
//                                                                             NSArray *sortedArray = [uniqueDates sortedArrayUsingDescriptors:sortDescriptors];
//                                                                             NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//                                                                             formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//                                                                             [formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
//                                                                             
////                                                                             [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];  //arnab new
//                                                                             if (sortedArray.count > 0) {
//                                                                                 NSString *sessionDate =[sortedArray objectAtIndex:0];
//                                                                                 if (![Utility isEmptyCheck:sessionDate]) {
////                                                                                     formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS"; //arnab
//                                                                                     NSDate *fstDate = [formatter dateFromString:sessionDate ];
//                                                                                     if (fstDate == nil) {      //arnab new
//                                                                                         formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
//                                                                                         fstDate = [formatter dateFromString:sessionDate ];
//                                                                                     }
//                                                                                     NSArray *weekDayArray = [self daysInWeek:0 fromDate:fstDate];
//                                                                                     for (NSString *date in weekDayArray) {
//                                                                                         NSArray *filteredarray = [exerciseArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SessionDate == %@)", date]];
//                                                                                         if (filteredarray.count > 0) {
//                                                                                             [myExercisePlanArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredarray,@"exerciseData",date,@"day", nil]];
//
//                                                                                         }else{
//                                                                                             [myExercisePlanArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray array],@"exerciseData",date,@"day", nil]];
//                                                                                         }
//                                                                                     }
//                                                                                     [collection reloadData];
//                                                                                     collection.hidden = false;
//                                                                                     blankMsgLabel.hidden = true;
//                                                                                     
//                                                                                 }else{
//                                                                                     [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
//                                                                                     return;
//                                                                                 }
//                                                                             }else{
//                                                                                 [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
//                                                                                 return;
//                                                                             }
//                                                                             
//
//
//                                                                         }else{
//                                                                             NSLog(@"-------%@",courseData);
//                                                                             NSString *courseStartDateString = [courseData objectForKey:@"StartDate"];
//                                                                             if (![Utility isEmptyCheck:courseStartDateString]) {
//                                                                                 NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//                                                                                 formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//                                                                                 [formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
//                                                                                 NSDate *date = [formatter dateFromString:courseStartDateString];
//                                                                                 NSDate *nextWeekPlanGenerationDate = [date dateByAddingTimeInterval:-60*60*60];
//                                                                                 
//                                                                                 formatter.dateFormat = @"EEEE, dd-MMM-yyyy";
//                                                                                 NSString *releasedDate = [formatter stringFromDate:nextWeekPlanGenerationDate];
//                                                                                 formatter.dateFormat = @"HH a";
//                                                                                 NSString *releasedTime = [formatter stringFromDate:nextWeekPlanGenerationDate];
//                                                                                 blankMsgLabel.text = [@"" stringByAppendingFormat:@"Your Week %d Exercise Plan will be released on %@ at %@.",tempCurrentWeek,releasedDate,releasedTime];
//                                                                                 [collection reloadData];
//                                                                                 collection.hidden = true;
//                                                                                 blankMsgLabel.hidden = false;
//                                                                             }
//                                                                         }
//                                                                         
//                                                                     }else{
//                                                                         [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
//                                                                         return;
//                                                                     }
//                                                                     
//                                                                 }else{
//                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
//                                                                 }
//                                                             });
//                                                         }];
//        [dataTask resume];
//        
//    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
//    }
//    
}
#pragma mark - IBAction -

- (IBAction)weekButtonTapped:(UIButton *)sender {
    tempCurrentWeek = (int)sender.tag + 1;
    [weekCollectionView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [weekCollectionView scrollToItemAtIndexPath:indexPath
                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                   animated:YES];
    [self serviceCall];
}

- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editButtonPressed:(UIButton *)sender {
    NSDictionary *dict = [myExercisePlanArray objectAtIndex:sender.accessibilityHint.intValue];
    NSArray *array = [dict objectForKey:@"exerciseData"];
    NSDictionary *exerciseData = [array objectAtIndex:sender.tag];
    EditSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditSession"];
    controller.sessionData = [exerciseData mutableCopy];
    controller.weekNumber  = tempCurrentWeek;
    controller.day = sender.accessibilityHint.intValue;
    controller.isEdit = true;
    controller.startDate = [dict objectForKey:@"day"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)addButton:(UIButton *)sender {
    NSDictionary *dict = [myExercisePlanArray objectAtIndex:sender.tag];
    EditSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditSession"];
    controller.weekNumber  = tempCurrentWeek;
    controller.day = (int)sender.tag;
    controller.isEdit = false;
    controller.startDate = [dict objectForKey:@"day"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)checkUncheckButton:(UIButton *)sender {
    NSMutableDictionary *dict = [[myExercisePlanArray objectAtIndex:[sender.accessibilityHint integerValue]] mutableCopy];
    NSMutableArray *array = [[dict objectForKey:@"exerciseData"] mutableCopy];
    NSMutableDictionary *exerciseValue = [[array objectAtIndex:sender.tag] mutableCopy];
    if (Utility.reachable) {
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSError *error;
        BOOL isDone = false;
        if ([[exerciseValue objectForKey:@"IsDone"] boolValue]) {
            isDone = false;
        }else{
            isDone = true;
        }
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[exerciseValue objectForKey:@"Id"] forKey:@"UserExerciseSessionId"];
        [mainDict setObject:[NSNumber numberWithBool:isDone] forKey:@"IsDone"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateUserExerciseSessionStatusApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                         BOOL isDone = false;
                                                                         if ([[exerciseValue objectForKey:@"IsDone"] boolValue]) {
                                                                             isDone = false;
                                                                         }else{
                                                                             isDone = true;
                                                                         }
                                                                         [exerciseValue setObject:[NSNumber numberWithBool:isDone ] forKey:@"IsDone"];
                                                                         [array replaceObjectAtIndex:sender.tag withObject:exerciseValue];
                                                                         [dict setObject:array forKey:@"exerciseData"];
                                                                         [myExercisePlanArray replaceObjectAtIndex:sender.accessibilityHint.integerValue withObject:dict];
                                                                         [collection reloadData];
                                                                         
                                                                     }else{
                                                                         [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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


#pragma mark - End

#pragma mark - TableView Datasource & Delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dict = [myExercisePlanArray objectAtIndex:tableView.tag];
    NSArray *array = [dict objectForKey:@"exerciseData"];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"ExerciseTableViewCell";
    ExerciseTableViewCell *cell = (ExerciseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[ExerciseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = [myExercisePlanArray objectAtIndex:tableView.tag];
    NSArray *array = [dict objectForKey:@"exerciseData"];
    NSDictionary *exerciseData = [array objectAtIndex:indexPath.row];
    if ([[exerciseData objectForKey:@"IsDone"]boolValue]) {
        [cell.checkUncheckButton setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    }else{
        [cell.checkUncheckButton setImage:[UIImage imageNamed:@"we_blk_tick.png"] forState:UIControlStateNormal];
    }
    cell.checkUncheckButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)tableView.tag];
    cell.checkUncheckButton.tag = indexPath.row;
    
    cell.editButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)tableView.tag];
    cell.editButton.tag = indexPath.row;
    
    cell.exerciseTitle.text =[exerciseData objectForKey:@"SessionTitle"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [myExercisePlanArray objectAtIndex:tableView.tag];
    NSArray *array = [dict objectForKey:@"exerciseData"];
    NSDictionary *exerciseData = [array objectAtIndex:indexPath.row];
    ExerciseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDetails"];
    controller.exerciseData = exerciseData;
    [self.navigationController pushViewController:controller animated:YES];
    NSLog(@"%@",exerciseData);
}

#pragma -mark CollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:collection]) {
        return myExercisePlanArray.count;
    }else{
        int weekNumber = [[defaults objectForKey:@"CurrentWeekNumber"]intValue];
        return weekNumber+2;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:collection]) {
        NSString *CellIdentifier =@"MyExercisePlanCollectionViewCell";
        MyExercisePlanCollectionViewCell *cell = (MyExercisePlanCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        NSDictionary *dict = [myExercisePlanArray objectAtIndex:indexPath.row];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [dict objectForKey:@"day"];
        NSDate *date = [formatter dateFromString:dateString];
        formatter.dateFormat = @"EEEE";
        NSString *formattedString = [[formatter stringFromDate:date] uppercaseString];
        cell.dayTitle.text = formattedString;
        
        formatter.dateFormat = @"dd/MM/yy";
        NSString *formattedDateString = [formatter stringFromDate:date];
        cell.date.text = formattedDateString;
        NSArray *sessionArray = [dict objectForKey:@"exerciseData"];
        if (sessionArray.count >=2) {
            cell.addButton.hidden = true;
        }else{
            cell.addButton.hidden = false;
        }
        cell.addButton.tag = indexPath.row;
        
        cell.dayTable.tag = indexPath.row;
        [cell.dayTable reloadData];
        return cell;
    }else{
        NSString *CellIdentifier =@"WeekCollectionViewCell";
        WeekCollectionViewCell *cell = (WeekCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.leftWing.hidden = true;
        }else{
            cell.leftWing.hidden = false;
        }
        NSInteger numberOfRows = [collectionView numberOfItemsInSection:0];

        if (indexPath.row == numberOfRows-1) {
            cell.rightWing.hidden = true;
        }else{
            cell.rightWing.hidden = false;
        }
        int currentWeek =(int)numberOfRows-3;
        if (indexPath.row == currentWeek+1) {
            cell.leftWing.backgroundColor = [UIColor colorWithRed:50.0f/255.0f green:205.0f/255.0f blue:184.0f/255.0f alpha:1.0f];
            cell.rightWing.backgroundColor = [UIColor colorWithRed:195.0f/255.0f green:193.0f/255.0f blue:193.0f/255.0f alpha:1.0f];
            cell.weekButton.enabled = true;
        }else if(indexPath.row > currentWeek+1){
            cell.weekButton.enabled = false;
            cell.leftWing.backgroundColor = [UIColor colorWithRed:195.0f/255.0f green:193.0f/255.0f blue:193.0f/255.0f alpha:1.0f];
            cell.rightWing.backgroundColor = [UIColor colorWithRed:195.0f/255.0f green:193.0f/255.0f blue:193.0f/255.0f alpha:1.0f];
        }else{
            cell.weekButton.enabled = true;
            cell.rightWing.backgroundColor = [UIColor colorWithRed:50.0f/255.0f green:205.0f/255.0f blue:184.0f/255.0f alpha:1.0f];
            cell.leftWing.backgroundColor = [UIColor colorWithRed:50.0f/255.0f green:205.0f/255.0f blue:184.0f/255.0f alpha:1.0f];
        }
        if (indexPath.row == tempCurrentWeek-1) {
            [cell.weekButton setBackgroundImage:[UIImage imageNamed:@"week_outline.png"] forState:UIControlStateNormal];
            [cell.weekButton setTitleColor:[Utility colorWithHexString:@"#31cdb8"] forState:UIControlStateNormal];

        }else if(indexPath.row > currentWeek+1){
            [cell.weekButton setBackgroundImage:[UIImage imageNamed:@"inact_week_filled.png"] forState:UIControlStateNormal];
            [cell.weekButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        }else{
            [cell.weekButton setBackgroundImage:[UIImage imageNamed:@"week_filled.png"] forState:UIControlStateNormal];
            [cell.weekButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        cell.weekButton.tag = indexPath.row;
        [cell.weekButton setTitle:[@""stringByAppendingFormat:@"WEEK %ld",indexPath.row + 1]  forState:UIControlStateNormal];
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:collection]) {
        CGFloat w1 = (CGRectGetWidth(collection.frame)-5)/2;
        return CGSizeMake(w1, 265);
    }else{
        CGFloat w1 = CGRectGetWidth(weekCollectionView.frame)/3;
        return CGSizeMake(w1, 38);
    }
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if ([collectionView isEqual:collection]) {
        return 5;
    }else{
        return 0;
    }
}

#pragma -mark End
@end
