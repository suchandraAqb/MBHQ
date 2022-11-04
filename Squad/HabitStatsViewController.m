//
//  HabitStatsViewController.m
//  Squad
//
//  Created by Suchandra Bhattacharya on 16/12/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "HabitStatsViewController.h"
#import "HabitStatsTableViewCell.h"
#import "HabitStateDetailsViewController.h"
#import "HabitHackerDetailNewViewController.h"
#import "HabitSectionViewController.h"
#import "HabitQuater.h"
@interface HabitStatsViewController ()
{
    UIView *contentView;
    int index;
    IBOutletCollection(UIButton) NSArray *footerButton;
    IBOutletCollection(UIButton) NSArray *checkUncheckButton;
    IBOutlet UIView *filterView;
    IBOutlet UITableView *habitTable;
    IBOutlet UITableView *yearlyTable;
    IBOutlet UIView *yearView;
    __weak IBOutlet UILabel *monthYearLabel;
    IBOutlet UILabel *nodataLabel;
    IBOutlet UIView *quaterView;
    IBOutlet UITableView *quaterTable;
    NSMutableArray *monthDateArray;
    NSArray *habitStatsArray;
    NSArray *breakStatsArray;
    NSDictionary *habitMainDict;
    NSArray *habitYearlyStatsArr;
    NSArray *habitQuaterStatsArr;
    NSArray *monthsArray;
    NSDate *currentDate;
    NSDictionary *habitDetailsDictionary;
    int weekCount;
    int habitStatus;
    IBOutlet UIButton *reminderButton;
    
}
@end

@implementation HabitStatsViewController
@synthesize habitListArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    currentDate = [NSDate date];
    filterView.hidden = true;
    yearView.hidden = true;
    quaterView.hidden = true;
    nodataLabel.hidden = true;
     for (UIButton *button in checkUncheckButton) {
         if (button.tag == 0) {
             button.selected = true;
         }else{
             button.selected = false;
         }
     }
    monthDateArray = [[NSMutableArray alloc]init];
    for (UIButton *button in footerButton) {
        button.layer.cornerRadius = 15;
        button.layer.masksToBounds = YES;
        if (button.tag == 12) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.backgroundColor = squadMainColor.CGColor;
            button.layer.masksToBounds = YES;
        }else{
         [button setTitleColor:squadMainColor forState:UIControlStateNormal];
          button.layer.backgroundColor = [UIColor whiteColor].CGColor;
          button.layer.masksToBounds = YES;
          button.layer.borderColor = squadMainColor.CGColor;
          button.layer.borderWidth = 1;
        }
    }
    if (habitTable) {
        habitTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, habitTable.bounds.size.width, 0.01f)];
    }
    monthsArray = [[NSArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"HabitSectionViewController" bundle:nil];
    [yearlyTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"HabitSectionViewController"];
    UINib *sectionHeaderNib1 = [UINib nibWithNibName:@"HabitQuater" bundle:nil];
    [quaterTable registerNib:sectionHeaderNib1 forHeaderFooterViewReuseIdentifier:@"HabitQuater"];
    
    habitDetailsDictionary=[[NSDictionary alloc] init];
    yearlyTable.estimatedSectionHeaderHeight = 80;
    yearlyTable.sectionHeaderHeight = UITableViewAutomaticDimension;
    quaterTable.estimatedSectionHeaderHeight = 80;
    quaterTable.sectionHeaderHeight = UITableViewAutomaticDimension;
    [self getOfflineDataStates];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    int indexValue = 0;
    NSArray *arr = [defaults objectForKey:@"defaultStatesView"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(HabitId==%d)",[[_habitDict objectForKey:@"HabitId"]intValue]];
    NSArray *filterArray = [arr filteredArrayUsingPredicate:predicate];
    if (filterArray.count>0) {
        indexValue = [[[filterArray objectAtIndex:0]objectForKey:@"Index"]intValue];
    }
     for (UIButton *button in checkUncheckButton) {
         if (button.tag == indexValue) {
             button.selected = true;
         }else{
             button.selected = false;
         }
     }
    [self showresultPressed:nil];
    [self setDateAndYearLabel:currentDate];
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"reminderButton"]){
        [reminderButton setImage:[UIImage imageNamed:@"notification_active_grn.png"] forState:UIControlStateNormal];
    }else{
        [reminderButton setImage:[UIImage imageNamed:@"notification_inactive_grn.png"] forState:UIControlStateNormal];
    }
    
}
#pragma mark - End

#pragma mark - IBAction

-(IBAction)backButtonPressed:(id)sender{
    if (_isFromHabitList) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"IsfromHabitList" object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)settingsButtonPressed:(id)sender{
    filterView.hidden = false;
}
-(IBAction)crossPressed:(id)sender{
    filterView.hidden = true;
}
-(IBAction)prevButtonPressed:(id)sender{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
    NSUInteger numberOfDaysNextInMonth = range.length;
    currentDate = [currentDate dateBySubtractingDays:numberOfDaysNextInMonth];
    [self setDateAndYearLabel:currentDate];
    [self setUpDaysInaMonth];
        if (!self->yearView.hidden) {
            [self->yearlyTable reloadData];
        }else if(!self->quaterView.hidden){
           [self->quaterTable reloadData];
       }else{
           [self->habitTable reloadData];
       }
}
-(IBAction)nextButtonPressed:(id)sender{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
    NSUInteger numberOfDaysNextInMonth = range.length;
    currentDate = [currentDate dateByAddingDays:numberOfDaysNextInMonth];
    [self setDateAndYearLabel:currentDate];
    [self setUpDaysInaMonth];
     if (!self->yearView.hidden) {
         [self->yearlyTable reloadData];
     }else if(!self->quaterView.hidden){
        [self->quaterTable reloadData];
    }else{
        [self->habitTable reloadData];
        
    }
}
-(IBAction)checkUncheckPressed:(UIButton*)sender{
    for (UIButton *button in checkUncheckButton){
        if (button==sender) {
            button.selected=true;
        }else{
            button.selected=false;
        }
    }

}
-(IBAction)showresultPressed:(UIButton*)sender{
    filterView.hidden = true;
    int selectedIndex = 0;
     for (UIButton *button in checkUncheckButton) {
         if (button.selected) {
             if (button.tag == 2) {
                 selectedIndex = (int)button.tag;
                 yearView.hidden = false;
                 quaterView.hidden = true;
                 habitTable.hidden = true;
                 [yearlyTable reloadData];
             }else if (button.tag == 1){
                 selectedIndex = (int)button.tag;
                 quaterView.hidden = false;
                 yearView.hidden = true;
                 habitTable.hidden = true;
                 [quaterTable reloadData];
             }else{
                 selectedIndex = (int)button.tag;
                 habitTable.hidden = false;
                 quaterView.hidden = true;
                 yearView.hidden = true;
                 [habitTable reloadData];
             }
         }
         
     }
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[NSNumber numberWithInt:[[_habitDict objectForKey:@"HabitId"]intValue]] forKey:@"HabitId"];
    [dict setObject:[NSNumber numberWithInt:selectedIndex] forKey:@"Index"];

    if (![Utility isEmptyCheck:[defaults objectForKey:@"defaultStatesView"]]) {
        NSMutableArray *defaultArr = [NSMutableArray new];

        defaultArr = [[defaults objectForKey:@"defaultStatesView"]mutableCopy];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(HabitId==%d)",[[_habitDict objectForKey:@"HabitId"]intValue]];
        NSArray *filterArray = [defaultArr filteredArrayUsingPredicate:predicate];
        if (filterArray.count>0) {
            NSLog(@"%d",(int)[defaultArr indexOfObject:[filterArray objectAtIndex:0]]);
            int index = (int)[defaultArr indexOfObject:[filterArray objectAtIndex:0]];
            [defaultArr replaceObjectAtIndex:index withObject:dict];
        }else{
            [defaultArr addObject:dict];
        }
        [defaults setObject:defaultArr forKey:@"defaultStatesView"];

    }else{
        NSMutableArray *firstArr = [NSMutableArray new];
        [firstArr addObject:dict];
        [defaults setObject:firstArr forKey:@"defaultStatesView"];
    }
   
}
-(IBAction)clearAllbuttonPressed:(id)sender{
    for (UIButton *button in checkUncheckButton) {
        if (button.tag == 0) {
             button.selected = true;
        }else{
             button.selected = false;
        }
       
    }
}
-(IBAction)datePressed:(UIButton*)sender{
   
//           NSDateFormatter *dt2 = [NSDateFormatter new];
//           [dt2 setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
//
//           NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:currentDate];
//
//           NSString *taskdateStr = [[habitStatsArray objectAtIndex:0]objectForKey:@"TaskDate"];
//
//           NSDate *date = [dt2 dateFromString:taskdateStr];
//           NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
       
//           if (components.year == components1.year) {//components.month == components1.month &&
      
               HabitStateDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitStateDetailsView"];
               controller.statesDelegate = self;
               controller.habitArray = habitStatsArray;
               controller.habitBreakArray = breakStatsArray;
               controller.habitName = [_habitDict objectForKey:@"HabitName"];
               controller.breakHabitName = [[_habitDict objectForKey:@"SwapAction"]objectForKey:@"Name"];
                if (![Utility isEmptyCheck:[[habitStatsArray firstObject] objectForKey:@"Name"]]) {
                    controller.habitName = [[[habitStatsArray firstObject] objectForKey:@"Name"]uppercaseString];
                }
                
                if (![Utility isEmptyCheck:[[breakStatsArray firstObject] objectForKey:@"Name"]]) {
                     controller.breakHabitName = [[[[breakStatsArray firstObject] objectForKey:@"Name"]uppercaseString]uppercaseString];
                }
               [self.navigationController pushViewController:controller animated:YES];
//           }else{
//               
//           }
}
-(IBAction)habitNamePressed:(UIButton*)sender{
    NSString *detailsStr = @"";
       if (sender.tag == 1) {
           detailsStr = [[[[_habitDict objectForKey:@"SwapAction"]objectForKey:@"Name"]uppercaseString]uppercaseString];
       }else{
           detailsStr = [[_habitDict objectForKey:@"HabitName"]uppercaseString];
       }
       [Utility msg:detailsStr title:@"" controller:self haveToPop:NO];
}
-(IBAction)habitSectionNamePressed:(UIButton*)sender{
    NSString *detailsStr = @"";
       if (sender.tag == 1) {
           detailsStr = [[[[_habitDict objectForKey:@"SwapAction"]objectForKey:@"Name"]uppercaseString]uppercaseString];
       }else{
           detailsStr = [[_habitDict objectForKey:@"HabitName"]uppercaseString];
       }
       [Utility msg:detailsStr title:@"" controller:self haveToPop:NO];
}
- (IBAction)showDetailsButtonTapped:(UIButton *)sender {
    HabitHackerDetailNewViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitHackerDetailNewView"];
    controller.habitId = [_habitDict valueForKey:@"HabitId"];
    controller.habitDetailDelegate=self;
    controller.habitDictFromStat=habitDetailsDictionary;
    controller.isEditMode = true;
    controller.isFromHabitList = true;
    [self.navigationController pushViewController:controller animated:NO];
}
- (IBAction)deleteButtonTapped:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Alert!"
                                  message:@"What action do you want for  this Habit ?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* delete = [UIAlertAction
                         actionWithTitle:@"DELETE"
                         style:UIAlertActionStyleDestructive
                         handler:^(UIAlertAction * action)
                         {
                            [self deleteHabitSwap_WebServiceCall];
                         }];
//    UIAlertAction* restart = [UIAlertAction
//                              actionWithTitle:@"RESTART FROM TODAY"
//                              style:UIAlertActionStyleDefault
//                              handler:^(UIAlertAction * action)
//                              {
//                                self->habitStatus=4;
//                                [self updateHabitStatus_WebcellCall];
//                              }];
    
//    UIAlertAction* pause = [UIAlertAction
//                            actionWithTitle:@"PAUSE/HIDE"
//                            style:UIAlertActionStyleDefault
//                            handler:^(UIAlertAction * action)
//                            {
//                                self->habitStatus=3;
//                                [self updateHabitStatus_WebcellCall];
//                            }];
    
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"No"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 
                             }];
    
    [alert addAction:delete];
//    [alert addAction:restart];
//    [alert addAction:pause];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)notificationButtontapped:(UIButton*)sender {
    NSLog(@"habitListArray===>%@",habitListArray);
    NSLog(@"");
    NSDictionary *habitDict = habitListArray[sender.tag];
    if ([Utility isEmptyCheck:habitDict]) {
        return;
    }
     HabitHackerDetailNewViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitHackerDetailNewView"];
     controller.habitId = [habitDict valueForKey:@"HabitId"];
     controller.habitDetailDelegate=self;
     controller.isEditMode = true;
     controller.habitDictFromStat= habitDict;
     controller.isFromHabitList = true;
     controller.isFromNotification = true;
//     controller.reminderSwitchStatus;
     [self.navigationController pushViewController:controller animated:NO];

}


#pragma mark - Webservce call
-(void)GetHabitStats_WebServiceCall{
        if (Utility.reachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
                self->contentView = [Utility activityIndicatorView:self];
            });
            NSURLSession *dailySession = [NSURLSession sharedSession];
            NSError *error;
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            [mainDict setObject:AccessKey forKey:@"Key"];
            [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
            [mainDict setObject:[_habitDict objectForKey:@"HabitId"] forKey:@"HabitId"];//[_habitDict objectForKey:@"HabitId"]
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetHabitStats" append:@"" forAction:@"POST"];
            NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 dispatch_async(dispatch_get_main_queue(),^ {
                                                                     if (self->contentView) {
                                                                         [self->contentView removeFromSuperview];
                                                                     }
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         
                                                                         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                             
                                                                             if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"]boolValue]) {
                                                                                 [self habitStatesPrepareView:responseDictionary];
                                                                                 [self addUpdateDBStates:responseDictionary];
                                                                             } else {
                                                                                 [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
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

#pragma mark - private Function

-(void)addUpdateDBStates:(NSDictionary*)dict{
    if (![Utility isSubscribedUser]){
        return;
    }
    NSString *detailsString = @"";
    
    if(![Utility isEmptyCheck:dict]){
        NSError *error;
        NSData *offlineData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            NSLog(@"Error Favorite Array-%@",error.debugDescription);
        }
        detailsString = [[NSString alloc] initWithData:offlineData encoding:NSUTF8StringEncoding];
    }
     
    int habitId = [[_habitDict objectForKey:@"HabitId"]intValue];
    int userId = [[defaults valueForKey:@"UserID"] intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *updateDateStr = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@",[@"" stringByAppendingFormat:@"UserId ='%@' and HabitId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:habitId]]);
    if([DBQuery isRowExist:@"habitStatesDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and HabitId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:habitId]]]){
        [DBQuery updateHabitDetails:detailsString with:habitId with:0 With:updateDateStr];
    }else{
        BOOL isAdd =  [DBQuery addHabitStatesDetails:detailsString with:habitId with:0 with:updateDateStr];
              if (!isAdd) {
                  [Utility msg:@"Data not inseted" title:@"" controller:self haveToPop:0];
          }
    }
      

}
-(void)habitStatesPrepareView:(NSDictionary*)responseDictionary{
     self->habitMainDict = [responseDictionary mutableCopy];
     if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"HabitStats"]]) {
         NSSortDescriptor *ageDescriptor = [[NSSortDescriptor alloc] initWithKey:@"TaskDateString" ascending:YES];
         NSArray *sortDescriptors = @[ageDescriptor];
         self->habitStatsArray = [[responseDictionary objectForKey:@"HabitStats"] sortedArrayUsingDescriptors:sortDescriptors];
//                                                                                     self->habitStatsArray = [responseDictionary objectForKey:@"HabitStats"];
     }
     if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"BreakHabitStats"]]) {
         NSSortDescriptor *ageDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"TaskDateString" ascending:YES];
         NSArray *sortDescriptors1 = @[ageDescriptor1];
         self->breakStatsArray = [[responseDictionary objectForKey:@"BreakHabitStats"] sortedArrayUsingDescriptors:sortDescriptors1];
//                                                                                     self->breakStatsArray = [responseDictionary objectForKey:@"BreakHabitStats"];
     }
     if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"HabitYearlyStats"]]) {
         NSSortDescriptor *ageDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"Year" ascending:NO];
         NSArray *sortDescriptors1 = @[ageDescriptor1];
         self->habitYearlyStatsArr = [[responseDictionary objectForKey:@"HabitYearlyStats"] sortedArrayUsingDescriptors:sortDescriptors1];
     }
     if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"HabitQuarterlyStats"]]) {
         habitQuaterStatsArr = [[[responseDictionary objectForKey:@"HabitQuarterlyStats"] reverseObjectEnumerator] allObjects];
     }
    [self setUpDaysInaMonth];
    if (!self->yearView.hidden) {
        [self->yearlyTable reloadData];
    }else if(!self->quaterView.hidden){
        [self->quaterTable reloadData];
    }else{
        [self->habitTable reloadData];
    }
    
    //--------- redirect from local notification
    if (_isfromLocalNotification) {
        _isfromLocalNotification=NO;
        HabitStateDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitStateDetailsView"];
         controller.statesDelegate = self;
         controller.habitArray = habitStatsArray;
         controller.habitBreakArray = breakStatsArray;
         controller.habitName = [_habitDict objectForKey:@"HabitName"];
         controller.breakHabitName = [[_habitDict objectForKey:@"SwapAction"]objectForKey:@"Name"];
         controller.frequencyId = [[[_habitDict objectForKey:@"NewAction"]objectForKey:@"TaskFrequencyTypeId"]intValue];
        if (![Utility isEmptyCheck:[[habitStatsArray firstObject] objectForKey:@"Name"]]) {
            controller.habitName = [[[habitStatsArray firstObject] objectForKey:@"Name"]uppercaseString];
        }
        
        if (![Utility isEmptyCheck:[[breakStatsArray firstObject] objectForKey:@"Name"]]) {
             controller.breakHabitName = [[[[breakStatsArray firstObject] objectForKey:@"Name"]uppercaseString]uppercaseString];
        }
         [self.navigationController pushViewController:controller animated:YES];
    }
    //-----------
}
-(void)getOfflineDataStates{
    if ([Utility reachable]) {
         int userId = [[defaults objectForKey:@"UserID"] intValue];
         int habitId = [[_habitDict objectForKey:@"HabitId"]intValue];
//         NSString *date = [NSDate date].description;
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         [formatter setDateFormat:@"yyyy-MM-dd"];
         NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
        
        NSLog(@"%@",[@"" stringByAppendingFormat:@"UserId ='%@' and HabitId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:habitId]]);
        
                if([DBQuery isRowExist:@"habitStatesDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and HabitId = '%@' and IsReloadRequre = 1",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:habitId]]]){
                        [self GetHabitStats_WebServiceCall];
                  
                    }else if([DBQuery isRowExist:@"habitStatesDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and HabitId = '%@' and LastUpdate = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:habitId],currentDateStr]]){
                        DAOReader *dbObject = [DAOReader sharedInstance];
                         if([dbObject connectionStart]){
                                          
                                     NSArray *habitStatesarr = [dbObject selectBy:@"habitStatesDetails" withColumn:[[NSArray alloc]initWithObjects:@"id",@"UserId",@"HabitStates",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@' and HabitId = '%@' and LastUpdate = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:habitId],currentDateStr]];
                                          
                                          if(habitStatesarr.count>0) {
                                               NSString *str = habitStatesarr[0][@"HabitStates"];
                                               NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                                               NSDictionary *habitDetails = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                               [self habitStatesPrepareView:habitDetails];
                                          }
                                      }
                    }else{
                        [self GetHabitStats_WebServiceCall];
                    }
        }
}
-(void)setDateAndYearLabel:(NSDate *)currentDate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSCalendar* tempCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [tempCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
        
        self->monthYearLabel.text = [@"" stringByAppendingFormat:@"%@ %d",[self->monthsArray objectAtIndex:(int)[components month]-1],(int)[components year]];
    });
}
  
-(void)setUpDaysInaMonth{
    monthDateArray = [[NSMutableArray alloc]init];
    NSDateFormatter *dateFormatter1 = [NSDateFormatter new];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
//    NSString *taskStr =[[habitStatsArray objectAtIndex:0] objectForKey:@"TaskDate"];
//    NSDate *date1=[dateFormatter1 dateFromString:currentDate];
    
//    NSString *taskStr1 =[[habitStatsArray objectAtIndex:(habitStatsArray.count-1)] objectForKey:@"TaskDate"];
//    NSDate *date2=[dateFormatter1 dateFromString:currentDate];
    
    NSDate *monthFirstDate=[self getFirstDateOfMonth:currentDate];
    if ([monthFirstDate weekday] > 2){
        monthFirstDate = [monthFirstDate dateBySubtractingDays:([monthFirstDate weekday] - 2)];
    }else if([monthFirstDate weekday] == 1){
        monthFirstDate = [monthFirstDate dateBySubtractingDays:6];
    }
    NSDate *lastDateOfmonth = [self lastDayOfMonth:currentDate];
    
    NSLog(@"%ld",(long)[lastDateOfmonth weekday]);
    if ([lastDateOfmonth weekday] > 2){
        lastDateOfmonth = [lastDateOfmonth dateByAddingDays:((7-[lastDateOfmonth weekday]) + 2)];
    }else if([lastDateOfmonth weekday] == 1){
        lastDateOfmonth = [lastDateOfmonth dateByAddingDays:((7-[lastDateOfmonth weekday]) + 1)];
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd EEE"];//yyyy-MM-dd'T'HH:mm:ss
    NSDate *startDate = monthFirstDate; // your start date
    NSDate *endDate = lastDateOfmonth; // your end date
    NSDateComponents *dayDifference = [[NSDateComponents alloc] init];
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    NSUInteger dayOffset = 1;
    NSDate *nextDate = startDate;
    do {
        [dates addObject:nextDate];
        
        [dayDifference setDay:dayOffset++];
        NSDate *d = [[NSCalendar currentCalendar] dateByAddingComponents:dayDifference toDate:startDate options:0];
        nextDate = d;
    } while([nextDate compare:endDate] == NSOrderedAscending);
    
    //                [df setDateStyle:NSDateFormatterFullStyle];
    for (NSDate *date in dates) {
//        NSLog(@"%@", [df stringFromDate:date]);
        [monthDateArray addObject:[df stringFromDate:date]];
    }
}
-(NSDate*)getFirstDateOfMonth:(NSDate*)currentDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componentsCurrentDate = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:currentDate];
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = 1;
    componentsNewDate.day = 1;
    return [calendar dateFromComponents:componentsNewDate];
}
- (NSDate *)lastDayOfMonth:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componentsCurrentDate = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month + 1;
    componentsNewDate.day = 1;//0
    
    return [calendar dateFromComponents:componentsNewDate];
}
//-(void)updateHabitStatus_WebcellCall{
//    if (Utility.reachable) {
//        dispatch_async(dispatch_get_main_queue(),^ {
//            if (self->contentView) {
//                [self->contentView removeFromSuperview];
//            }
//            self->contentView = [Utility activityIndicatorView:self];
//        });
//        NSURLSession *dailySession = [NSURLSession sharedSession];
//        NSError *error;
//
//        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
//        [mainDict setObject:AccessKey forKey:@"Key"];
//        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
//
//        [mainDict setObject:[_habitDict valueForKey:@"HabitId"] forKey:@"HabitId"];
//        [mainDict setObject:[NSString stringWithFormat:@"%d",habitStatus] forKey:@"HabitStatus"];
//
//        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
//        if (error) {
//            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
//            return;
//        }
//        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
//
//        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateHabitStatus" append:@"" forAction:@"POST"];
//        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
//                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                             dispatch_async(dispatch_get_main_queue(),^ {
//                                                                 if (self->contentView) {
//                                                                     [self->contentView removeFromSuperview];
//                                                                 }
//                                                                 if(error == nil)
//                                                                 {
//                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                                     NSLog(@"Response Data:%@",responseString);
//                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
//
//                                                                         if (self->habitStatus==4) {
//                                                                             self->habitStatus=1;
//                                                                         }
//
//                                                                         for (UIButton *btn in self->statusButtons) {
//                                                                             if (btn.tag==self->habitStatus)
//                                                                             {
//                                                                                 btn.selected=true;
//                                                                                 self->habitStatus=(int)btn.tag;
//
//                                                                             } else{
//                                                                                 btn.selected = false;
//                                                                             }
//                                                                         }
//                                                                         if (self->habitStatus == 3) {
//                                                                             [self->reminderSwitch setOn:NO animated:NO];
//                                                                               self->isReminderDict=NO;
//                                                                               [self->habitDefaultReminderSet setObject:[NSNumber numberWithBool:NO] forKey:@"Email"];
//                                                                               [self->habitDefaultReminderSet setObject:[NSNumber numberWithBool:NO] forKey:@"PushNotification"];
//                                                                               [self->breakHabitDict setObject:[NSNumber numberWithBool:NO] forKey:@"Email"];
//                                                                               [self->breakHabitDict setObject:[NSNumber numberWithBool:NO] forKey:@"PushNotification"];
//                                                                             self->isHiddenStatus = true;
//                                                                             [self saveButtonPressed:nil];
//
//                                                                         }
//                                                                         [self->habitDetailsDict setObject:[NSNumber numberWithInt:self->habitStatus] forKey:@"Status"];
//                                                                         [self->habitDetailDelegate reloadUpdatedData:self->habitDetailsDict];
//                                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"IsHackerListReload" object:self userInfo:nil];
//                                                                         }else{
//                                                                             [Utility msg:responseDictionary[@"ErrorMessage"] title:@"Oops! " controller:self haveToPop:NO];
//                                                                             return;
//                                                                         }
//                                                                     }else{
//                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
//                                                                         return;
//                                                                     }
//                                                             });
//                                                         }];
//        [dataTask resume];
//
//    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
//    }
//}
-(void)deleteHabitSwap_WebServiceCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[_habitDict objectForKey:@"HabitId"] forKey:@"HabitId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"AbbbcUserSessionId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteHabitSwap" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"]boolValue]) {
                                                                             [[NSNotificationCenter defaultCenter]postNotificationName:@"IsHackerListDelete" object:[self->_habitDict objectForKey:@"HabitId"] userInfo:nil];
                                                                             NSLog(@"%@",self.navigationController.viewControllers);
                                                                             BOOL isFound = false;
                                                                             for (UIViewController *controller in self.navigationController.viewControllers) {
                                                                                 if ([controller isKindOfClass:[HabitHackerFirstViewController class]]) {
                                                                                     [self.navigationController popToViewController:controller animated:YES];
                                                                                     isFound = true;
                                                                                     break;
                                                                                     
                                                                                 }
                                                                             }
                                                                             
                                                                             if(!isFound){
                                                                                 [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];

                                                                                 [self.navigationController popToRootViewControllerAnimated:NO];
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
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

#pragma mark - TableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     if (tableView == yearlyTable || tableView == quaterTable) {
         return 2;
     }else{
         return 1;
     }
    
}


-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   if (tableView == yearlyTable) {
       HabitSectionViewController *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HabitSectionViewController"];
       if(section == 0){
           sectionHeaderView.topConstraint.constant = 0;
           sectionHeaderView.seperatorView.hidden = true;
           sectionHeaderView.habitname.textColor =[UIColor blackColor];//squadMainColor;
//            if (![Utility isEmptyCheck:[_habitDict objectForKey:@"HabitName"]]) {
//                sectionHeaderView.habitname.text = [[_habitDict objectForKey:@"HabitName"]uppercaseString];
//            }
           
           if (![Utility isEmptyCheck:[[habitStatsArray firstObject] objectForKey:@"Name"]]) {
               sectionHeaderView.habitname.text = [[[habitStatsArray firstObject] objectForKey:@"Name"]uppercaseString];
           }
           
       }else{
           sectionHeaderView.topConstraint.constant = 30;
           sectionHeaderView.seperatorView.hidden = false;
           sectionHeaderView.habitname.textColor = [UIColor blackColor];
//           if (![Utility isEmptyCheck:[_habitDict objectForKey:@"SwapAction"]]) {
//               sectionHeaderView.habitname.text = [[[_habitDict objectForKey:@"SwapAction"]objectForKey:@"Name"]uppercaseString];
//           }
           if (![Utility isEmptyCheck:[[breakStatsArray firstObject] objectForKey:@"Name"]]) {
                sectionHeaderView.habitname.text = [[[[breakStatsArray firstObject] objectForKey:@"Name"]uppercaseString]uppercaseString];
           }
       }
       sectionHeaderView.habitSectionName.tag = section;
       [sectionHeaderView.habitSectionName addTarget:self action:@selector(habitSectionNamePressed:) forControlEvents:UIControlEventTouchUpInside];

       return sectionHeaderView;
   }else if(tableView == quaterTable){
       HabitQuater *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HabitQuater"];
             if(section == 0){
                 sectionHeaderView.topConstraint.constant = 0;
                 sectionHeaderView.seperatorView.hidden = true;
                 sectionHeaderView.habitQauterName.textColor = [UIColor blackColor];
//                  if (![Utility isEmptyCheck:[_habitDict objectForKey:@"HabitName"]]) {
//                      sectionHeaderView.habitQauterName.text = [[_habitDict objectForKey:@"HabitName"]uppercaseString];
//                  }
                 if (![Utility isEmptyCheck:[[habitStatsArray firstObject] objectForKey:@"Name"]]) {
                     sectionHeaderView.habitQauterName.text = [[[habitStatsArray firstObject] objectForKey:@"Name"]uppercaseString];
                 }
             }else{
                 sectionHeaderView.topConstraint.constant = 30;
                 sectionHeaderView.seperatorView.hidden = false;
                 sectionHeaderView.habitQauterName.textColor = [UIColor blackColor];
//                 if (![Utility isEmptyCheck:[_habitDict objectForKey:@"SwapAction"]]) {
//                     sectionHeaderView.habitQauterName.text = [[[_habitDict objectForKey:@"SwapAction"]objectForKey:@"Name"]uppercaseString];
//                 }
                 if (![Utility isEmptyCheck:[[breakStatsArray firstObject] objectForKey:@"Name"]]) {
                      sectionHeaderView.habitQauterName.text = [[[[breakStatsArray firstObject] objectForKey:@"Name"]uppercaseString]uppercaseString];
                 }
             }
       sectionHeaderView.habitSectionName.tag = section;
       [sectionHeaderView.habitSectionName addTarget:self action:@selector(habitSectionNamePressed:) forControlEvents:UIControlEventTouchUpInside];

             return sectionHeaderView;
   }else{
       return nil;
   }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == yearlyTable || tableView == quaterTable) {
        return UITableViewAutomaticDimension;
    }else{
        NSString *cellIndentifier = @"HabitStatsTableViewCell";
        HabitStatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        NSLog(@"%d",[Utility weeksOfMonth:(int)[currentDate month] inYear:(int)[currentDate year]]);
        weekCount = [Utility weeksOfMonth:(int)[currentDate month] inYear:(int)[currentDate year]];
        if (weekCount <0) {
            weekCount = 1;
        }
        NSLog(@"%f",cell.habitName.intrinsicContentSize.height);
        int labelheight = 0;
        if (cell.habitName.intrinsicContentSize.height>60) {
            labelheight = 60;
        }else{
            labelheight = cell.habitName.intrinsicContentSize.height;
        }
        cell.percentageHeightConstant.constant = ((weekCount+1)*50)+40+labelheight+5;
        return ((weekCount+1)*50)+40+labelheight+5;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == yearlyTable) {
        return habitYearlyStatsArr.count;
    }else if(tableView == quaterTable){
        return habitQuaterStatsArr.count;
    }else{
        return 2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIndentifier = @"HabitStatsTableViewCell";
    HabitStatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
       cell = [[HabitStatsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
   }
    if (tableView == habitTable) {
        nodataLabel.hidden = true;
        habitTable.hidden = false;
       
        if (indexPath.row == 0) {
                if (![Utility isEmptyCheck:[[habitStatsArray objectAtIndex:0] objectForKey:@"Name"]]) {
                    cell.habitName.textColor =[UIColor blackColor] ;//squadMainColor;
                    cell.habitName.text = [[[habitStatsArray objectAtIndex:0] objectForKey:@"Name"]uppercaseString];
                }
               if (![Utility isEmptyCheck:[habitMainDict objectForKey:@"HabitMonthlyStats"]]) {
                   NSArray *HabitMonthlyStatsArr = [habitMainDict objectForKey:@"HabitMonthlyStats"];
//                   double percentage = [[[HabitMonthlyStatsArr objectAtIndex:0]objectForKey:@"StatsMonthlyPercentage"]floatValue]*100;
                   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Month == %d and Year == %d)",[currentDate month],[currentDate year]];
                   NSArray *filterArr = [HabitMonthlyStatsArr filteredArrayUsingPredicate:predicate];
                   if (filterArr.count>0) {
                       cell.habitPercentageLabel.text = [@"" stringByAppendingFormat:@"%@ %%",[[filterArr objectAtIndex:0]objectForKey:@"StatsMonthlyPercentage"]];

                   }else {
                       cell.habitPercentageLabel.text = [@"" stringByAppendingFormat:@"%@ %%",@"0"];

                   }
               }else{
                   cell.habitPercentageLabel.text = [@"" stringByAppendingFormat:@"%@ %%",@"0"];
               }
               if (![Utility isEmptyCheck:monthDateArray]) {
                   [(HabitStatsTableViewCell *)cell setUpView:monthDateArray indexValue:(int)indexPath.row with:habitStatsArray with:(int)[currentDate month]];
               }
            if (![Utility isEmptyCheck:[habitMainDict objectForKey:@"HabitMonthlyStats"]]) {
                
                NSArray *habitmonthlyArr = [habitMainDict objectForKey:@"HabitMonthlyStats"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Month == %d and Year == %d)",[currentDate month],[currentDate year]];
                habitmonthlyArr = [habitmonthlyArr filteredArrayUsingPredicate:predicate];
                
                if (habitmonthlyArr.count>0 && ![Utility isEmptyCheck:[habitmonthlyArr objectAtIndex:0]]) {
                    if (![Utility isEmptyCheck:[[habitmonthlyArr objectAtIndex:0] objectForKey:@"WeeklyStats"]]) {
                    NSArray *weeklyStatsArr = [[habitmonthlyArr objectAtIndex:0] objectForKey:@"WeeklyStats"];
                        if (weeklyStatsArr.count>0) {
    
                            
                            for (int i = 0; i<weeklyStatsArr.count;i++) {
                                UILabel *label = cell.percentageLabelMonthly[i];
                                label.text = [@"" stringByAppendingFormat:@"%@ %%",[[weeklyStatsArr objectAtIndex:i]objectForKey:@"StatsWeeklyPercentage"]];
                                }
                            
                        }
                    }else{
                        for (int i = 0; i<weekCount;i++) {
                            UILabel *label = cell.percentageLabelMonthly[i];
                            label.text = [@"" stringByAppendingFormat:@"%@ %%",@"0"];
                        }
                    }
                }else{
                    for (int i = 0; i<weekCount;i++) {
                        UILabel *label = cell.percentageLabelMonthly[i];
                        label.text = [@"" stringByAppendingFormat:@"%@ %%",@"0"];
                     }
                }
            }else{
                for (int i = 0; i<weekCount;i++) {
                    UILabel *label = cell.percentageLabelMonthly[i];
                    label.text = [@"" stringByAppendingFormat:@"%@ %%",@"0"];
                 }
            }
           }else{
                if (![Utility isEmptyCheck:[[breakStatsArray objectAtIndex:0] objectForKey:@"Name"]]) {
                      cell.habitName.textColor = [UIColor blackColor];
                       cell.habitName.text = [[[[breakStatsArray objectAtIndex:0] objectForKey:@"Name"]uppercaseString]uppercaseString];
                   }
                if (![Utility isEmptyCheck:[habitMainDict objectForKey:@"BreakMonthlyStats"]]) {
                   NSArray *HabitMonthlyStatsArr = [habitMainDict objectForKey:@"BreakMonthlyStats"];
                   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Month == %d and Year == %d)",[currentDate month],[currentDate year]];
                   NSArray *filterArr = [HabitMonthlyStatsArr filteredArrayUsingPredicate:predicate];
                   if (filterArr.count>0) {
                       cell.habitPercentageLabel.text = [@"" stringByAppendingFormat:@"%@ %%",[[filterArr objectAtIndex:0]objectForKey:@"StatsMonthlyPercentage"]];

                   }else{
                       cell.habitPercentageLabel.text = [@"" stringByAppendingFormat:@"%@ %%",@"0"];

                   }
                }else{
                    cell.habitPercentageLabel.text = [@"" stringByAppendingFormat:@"%@ %%",@"0"];

                }
               
                if (![Utility isEmptyCheck:monthDateArray]) {
                   [(HabitStatsTableViewCell *)cell setUpView:monthDateArray indexValue:(int)indexPath.row with:breakStatsArray with:(int)[currentDate month]];
                }
               
                if (![Utility isEmptyCheck:[habitMainDict objectForKey:@"BreakMonthlyStats"]]) {
                    NSArray *habitmonthlyArr = [habitMainDict objectForKey:@"BreakMonthlyStats"];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Month == %d and Year == %d)",[currentDate month],[currentDate year]];
                    habitmonthlyArr = [habitmonthlyArr filteredArrayUsingPredicate:predicate];
                    if (habitmonthlyArr.count >0 && ![Utility isEmptyCheck:[habitmonthlyArr objectAtIndex:0]]) {
                        if (![Utility isEmptyCheck:[[habitmonthlyArr objectAtIndex:0] objectForKey:@"WeeklyStats"]]) {
                            NSArray *weeklyStatsArr = [[habitmonthlyArr objectAtIndex:0] objectForKey:@"WeeklyStats"];
                            if (weeklyStatsArr.count>0) {
                                
                                
                             for (int i = 0; i<weeklyStatsArr.count;i++) {
                                   NSLog(@"===%@",weeklyStatsArr[i]);
                                   UILabel *label = cell.percentageLabelMonthly[i];
                                   label.text = [@"" stringByAppendingFormat:@"%@ %%",[[weeklyStatsArr objectAtIndex:i]objectForKey:@"StatsWeeklyPercentage"]];
                                   }
                                
                            }
                               
                        }else{
                                for (int i = 0; i<weekCount;i++) {
                                    UILabel *label = cell.percentageLabelMonthly[i];
                                    label.text = [@"" stringByAppendingFormat:@"%@ %%",@"0"];
                                 }
                            }
                        }else{
                            for (int i = 0; i<weekCount;i++) {
                                UILabel *label = cell.percentageLabelMonthly[i];
                                label.text = [@"" stringByAppendingFormat:@"%@ %%",@"0"];
                             }
                        }
                    }else{
                        for (int i = 0; i<weekCount;i++) {
                            UILabel *label = cell.percentageLabelMonthly[i];
                            label.text = [@"" stringByAppendingFormat:@"%@ %%",@"0"];
                         }
                    }
        }
        
    }else if(tableView == yearlyTable){
            NSDateFormatter *dt2 = [NSDateFormatter new];
            [dt2 setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
            
//                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:currentDate];
//                int dateYear = [[[habitYearlyStatsArr objectAtIndex:indexPath.row]objectForKey:@"Year"] intValue];;
            
                //if (dateYear == components.year) {
                    nodataLabel.hidden = true;
                    yearlyTable.hidden = false;
                      if (indexPath.section == 0) {
                                NSDictionary *yearlyDict = [habitYearlyStatsArr objectAtIndex:indexPath.row];
                                if (![Utility isEmptyCheck:yearlyDict]) {
                                    if (![Utility isEmptyCheck:[yearlyDict objectForKey:@"Year"]]) {
                                        cell.habitYearNameForYearly.text = [@"" stringByAppendingFormat:@"%@",[yearlyDict objectForKey:@"Year"]];
                                    }else{
                                        cell.habitYearNameForYearly.text = @"";
                                    }
                                    if (![Utility isEmptyCheck:[yearlyDict objectForKey:@"StatsYearlyPercentage"]]) {
                    //                    double percentage = [[yearlyDict objectForKey:@"StatsYearlyPercentage"]floatValue]*100;
                                        cell.habitPercentageForYearly.text = [@"" stringByAppendingFormat:@"%@ %%",[yearlyDict objectForKey:@"StatsYearlyPercentage"]];
                                    }else{
                                        cell.habitPercentageForYearly.text = @"N/A";
                                    }
                                }
                            }else{
                                if (![Utility isEmptyCheck:[habitMainDict objectForKey:@"BreakYearlyStats"]]) {
                                        NSSortDescriptor *ageDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"Year" ascending:NO];
                                        NSArray *sortDescriptors1 = @[ageDescriptor1];
                                        NSArray *breakYearlyStatsArr = [[habitMainDict objectForKey:@"BreakYearlyStats"] sortedArrayUsingDescriptors:sortDescriptors1];
                                    
                                    if (![Utility isEmptyCheck:[breakYearlyStatsArr objectAtIndex:indexPath.row]]) {
                                           NSDictionary *yearlyDict = [breakYearlyStatsArr objectAtIndex:indexPath.row];

                                           if (![Utility isEmptyCheck:[yearlyDict objectForKey:@"Year"]]) {
                                               cell.habitYearNameForYearly.text = [@"" stringByAppendingFormat:@"%@",[yearlyDict objectForKey:@"Year"]];
                                           }else{
                                               cell.habitYearNameForYearly.text = @"";
                                           }
                                           if (![Utility isEmptyCheck:[yearlyDict objectForKey:@"StatsYearlyPercentage"]]) {
                    //                           double percentage = [[yearlyDict objectForKey:@"StatsYearlyPercentage"]floatValue];
                                               cell.habitPercentageForYearly.text = [@"" stringByAppendingFormat:@"%@ %%",[yearlyDict objectForKey:@"StatsYearlyPercentage"]];
                                           }else{
                                               cell.habitPercentageForYearly.text = @"N/A";
                                           }
                                       }
                                   }
                               }
               /* }else{
                    nodataLabel.hidden = false;
                    yearlyTable.hidden = true;
                }*/
      
    }else{
        NSArray *quaterArr = @[@"JANUARY - MARCH",@"APRIL - JUNE",@"JULY - SEPTEMBER",@"OCTOBER - DECEMBER"];

        NSDateFormatter *dt2 = [NSDateFormatter new];
                 [dt2 setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
                 
        
                         nodataLabel.hidden = true;
                         quaterTable.hidden = false;
                         if (indexPath.section == 0) {
                                   if (![Utility isEmptyCheck:habitQuaterStatsArr]) {
                                       NSDictionary *quaterDict = [habitQuaterStatsArr objectAtIndex:indexPath.row];
                                       if (![Utility isEmptyCheck:[quaterDict objectForKey:@"Quarter"]]) {
                                           int quater = [[quaterDict objectForKey:@"Quarter"]intValue]-1;
                                           cell.habitNameForQuater.text = [@"" stringByAppendingFormat:@"%@ %@",[quaterArr objectAtIndex:quater],[quaterDict objectForKey:@"Year"]];
                                           }else{
                                               cell.habitNameForQuater.text = @"";
                                           }
                                       if (![Utility isEmptyCheck:[quaterDict objectForKey:@"StatsQuarterlyPercentage"]]) {
                                                   cell.habitPercentageForQuater.text = [@"" stringByAppendingFormat:@"%@ %%",[quaterDict objectForKey:@"StatsQuarterlyPercentage"]];
                                               }else{
                                                   cell.habitPercentageForQuater.text = @"N/A";
                                              }
                                       }
                                   
                               }else{
                                   if (![Utility isEmptyCheck:[habitMainDict objectForKey:@"BreakQuarterlyStats"]]) {
//                                       NSArray *breakQuarterlyStatsArr = [habitMainDict objectForKey:@"BreakQuarterlyStats"];
                                       NSArray *breakQuarterlyStatsArr = [[[habitMainDict objectForKey:@"BreakQuarterlyStats"] reverseObjectEnumerator] allObjects];
                                       
                                       if (![Utility isEmptyCheck:breakQuarterlyStatsArr]) {
                                           NSDictionary *quaterDict = [breakQuarterlyStatsArr objectAtIndex:indexPath.row];
                                           if (![Utility isEmptyCheck:[quaterDict objectForKey:@"Quarter"]]) {
                                               int quater = [[quaterDict objectForKey:@"Quarter"]intValue]-1;
                                                   cell.habitNameForQuater.text = [@"" stringByAppendingFormat:@"%@ %@",[quaterArr objectAtIndex:quater],[quaterDict objectForKey:@"Year"]];
                                               }else{
                                                   cell.habitNameForQuater.text = @"";
                                               }
                                           if (![Utility isEmptyCheck:[quaterDict objectForKey:@"StatsQuarterlyPercentage"]]) {
                                                       cell.habitPercentageForQuater.text = [@"" stringByAppendingFormat:@"%@ %%",[quaterDict objectForKey:@"StatsQuarterlyPercentage"]];
                                                   }else{
                                                       cell.habitPercentageForQuater.text = @"N/A";
                                                  }
                                           }
                                   }
                               }
      
    }
    cell.habitNameButton.tag = indexPath.row;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HabitStateDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitStateDetailsView"];
     controller.statesDelegate = self;
     controller.habitArray = habitStatsArray;
     controller.habitBreakArray = breakStatsArray;
     controller.habitName = [_habitDict objectForKey:@"HabitName"];
     controller.breakHabitName = [[_habitDict objectForKey:@"SwapAction"]objectForKey:@"Name"];
     controller.frequencyId = [[[_habitDict objectForKey:@"NewAction"]objectForKey:@"TaskFrequencyTypeId"]intValue];
    if (![Utility isEmptyCheck:[[habitStatsArray firstObject] objectForKey:@"Name"]]) {
        controller.habitName = [[[habitStatsArray firstObject] objectForKey:@"Name"]uppercaseString];
    }
    
    if (![Utility isEmptyCheck:[[breakStatsArray firstObject] objectForKey:@"Name"]]) {
         controller.breakHabitName = [[[[breakStatsArray firstObject] objectForKey:@"Name"]uppercaseString]uppercaseString];
    }
    
    
     [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - DetailsViewDeledate
-(void)reloadUpdatedData:(NSDictionary *)habitDictionary
{
    _habitDict=habitDictionary;
    [self GetHabitStats_WebServiceCall];
}

-(void)setHAbitDetailsDictionary:(NSDictionary *)habitDictionary
{
    
    habitDetailsDictionary=habitDictionary;
    
}


#pragma mark - StateDetailsDelegate
-(void)reloadData{
    [self GetHabitStats_WebServiceCall];
}

@end
