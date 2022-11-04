//
//  VitaminViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 07/03/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "VitaminViewController.h"
#import "VitaminTodayTableViewCell.h"
#import "VitaminWeeklyTableViewCell.h"
#import "VitaminMonthlyTableViewCell.h"
@interface VitaminViewController ()
{
    IBOutlet UIButton *todayButton;
    IBOutlet UIButton *thisWeekButton;
    IBOutlet UIButton *monthButton;
    IBOutlet UIButton *addVitamin;
    IBOutlet UITableView *todayTable;
    UIView *contentView;
    NSArray *vitaminListArray;
    NSDate *weekDate;
    NSMutableArray *monthDateArray;
    NSMutableArray *todayArrayDetails;
    BOOL isPerfromEmpty;
    NSMutableDictionary *resultDict;
}
@end

@implementation VitaminViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    addVitamin.layer.cornerRadius = 8;
    addVitamin.layer.masksToBounds = YES;
    [self itemButtonPressed:todayButton];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark  - End

#pragma mark - IBAction
-(IBAction)itemButtonPressed:(UIButton*)sender{
    if (sender == todayButton) {
        todayButton.selected = true;
        thisWeekButton.selected = false;
        monthButton.selected = false;
        [defaults setObject:@"today" forKey:@"SelectedState"];

    }else if (sender == thisWeekButton){
        todayButton.selected = false;
        thisWeekButton.selected = true;
        monthButton.selected = false;
        [defaults setObject:@"Week" forKey:@"SelectedState"];
        [self getWeekFirstDate];

    }else{
        todayButton.selected = false;
        thisWeekButton.selected = false;
        monthButton.selected = true;
        [defaults setObject:@"Month" forKey:@"SelectedState"];
    }
    [self webSerViceCall_GetVitaminTasks];
}
-(IBAction)addVitaminButtonPressed:(id)sender{
    AddVitaminViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddVitaminView"];
    controller.isFromEdit=NO;
    controller.addVitaminDelegate=self;
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)weeklyVitaminButtonPressed:(UIButton*)sender{
    NSDictionary *editDict;
    
    NSDictionary *vitaminDict = [vitaminListArray objectAtIndex:[sender.accessibilityHint intValue]];
    if (![Utility isEmptyCheck:vitaminDict]) {
        NSMutableArray *weeklyVitaminArray = [[NSMutableArray alloc]init];
        if (![Utility isEmptyCheck:[vitaminDict objectForKey:@"VitaminTaskList"]]) {
            NSArray *vitaminTask = [vitaminDict objectForKey:@"VitaminTaskList"];
            NSArray *weekDayArray = [self daysInWeek:2 fromDate:weekDate];
            for (NSString *dateStr in weekDayArray) {
                NSArray *filteredArr = [vitaminTask filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(TaskDate == %@)", [@"" stringByAppendingFormat:@"%@T00:00:00",dateStr]]];
                if (![Utility isEmptyCheck:filteredArr]) {
                    [weeklyVitaminArray addObject:[filteredArr objectAtIndex:0]];
                }else{
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setObject:@"inactiveDay" forKey:@"DayNotActive"];
                    [weeklyVitaminArray addObject:dict];
                }
            }
            if (![Utility isEmptyCheck:weeklyVitaminArray] && weeklyVitaminArray.count>0) {
                editDict = [weeklyVitaminArray objectAtIndex:sender.tag];
                if (![Utility isEmptyCheck:editDict] && [Utility isEmptyCheck:[editDict objectForKey:@"DayNotActive"]]) {
                    NSArray *individualTaskArr= [editDict objectForKey:@"IndividualTasks"];

                    if (!([[editDict objectForKey:@"PendingCount"]intValue] == 0)) {
                        isPerfromEmpty = false;
                        [self webSerViceCall_UpdateTaskStatus:individualTaskArr[[[editDict objectForKey:@"DoneCount"]intValue]]];
                    }
                    else{
                        for (int i = 0; i<individualTaskArr.count; i++) {
                            isPerfromEmpty = true;
                            [self webSerViceCall_UpdateTaskStatus:individualTaskArr[i]];
                        }
                    }
                    
//                    VitaminEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VitaminEditView"];
//                    controller.editDict = editDict;
//                    controller.vitaminEditDelegate = self;
//                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }
    }
}
-(IBAction)monthlyButtonPressed:(UIButton*)sender{
    NSDictionary *vitaminDict = [vitaminListArray objectAtIndex:[sender.accessibilityHint intValue]];
    if (![Utility isEmptyCheck:vitaminDict]) {
        NSArray *vitaminTask = [vitaminDict objectForKey:@"VitaminTaskList"];
        NSArray *filteredTodayArr = [vitaminTask filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(TaskDate >= %@ and TaskDate <= %@)", [self strFromDate:[self getFirstDateOfMonth:[NSDate date]]],[self strFromDate:[self lastDayOfMonth:[NSDate date]]]]];
        if (![Utility isEmptyCheck:filteredTodayArr] && filteredTodayArr.count>0) {
            NSDateFormatter *df = [NSDateFormatter new];
            [df setDateFormat:@"yyyy-MM-dd EEE"];

            NSDate *dt =[df dateFromString:monthDateArray[sender.tag-1]];
            NSDateFormatter *df1 = [NSDateFormatter new];
            [df1 setTimeZone:[NSTimeZone localTimeZone]];

            [df1 setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [df1 stringFromDate:dt];
            NSArray *todayClickedArr = [vitaminTask filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(TaskDate = %@)", [@"" stringByAppendingFormat:@"%@T00:00:00",dateStr]]];
            
            if (![Utility isEmptyCheck:todayClickedArr] && todayClickedArr.count>0) {
                VitaminEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VitaminEditView"];
                controller.editDict = [todayClickedArr objectAtIndex:0];
                controller.vitaminEditDelegate = self;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }
}
-(IBAction)editButtonTapped:(UIButton*)sender{
    if (![Utility isEmptyCheck:[vitaminListArray objectAtIndex:sender.tag]]) {
        AddVitaminViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddVitaminView"];
        controller.isFromEdit=YES;
        controller.addVitaminDelegate=self;
        controller.userVitaminId = [[[vitaminListArray objectAtIndex:sender.tag]objectForKey:@"UserVitaminId"] intValue];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(IBAction)notificationOnOffButtonPressed:(UIButton*)sender{
    if (sender.isSelected) {
        if (![Utility isEmptyCheck:[vitaminListArray objectAtIndex:sender.tag]]) {
            int userVitaminId = [[[vitaminListArray objectAtIndex:sender.tag]objectForKey:@"UserVitaminId"] intValue];
            NSDictionary *userVitaminDict = [[vitaminListArray objectAtIndex:sender.tag] objectForKey:@"UserVitaminDetails"];
            if (![Utility isEmptyCheck:userVitaminDict]) {
                
                if((![Utility isEmptyCheck:[userVitaminDict objectForKey:@"ReminderFrequencyId"]] && [[userVitaminDict objectForKey:@"ReminderFrequencyId"]intValue]>0) || (![Utility isEmptyCheck:[userVitaminDict objectForKey:@"ReminderVitaminId"]] && [[userVitaminDict objectForKey:@"ReminderVitaminId"]intValue]>0)){
                    
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:nil
                                                              message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction
                                                   actionWithTitle:@"Edit Reminder"
                                                   style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action)
                                                   {
                                                       [self reminderDetails:true vitaminId:userVitaminId];
                                                   }];
                        UIAlertAction *turnOff = [UIAlertAction
                                                  actionWithTitle:@"Turn Off Reminder"
                                                  style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action)
                                                  {
                                                      [self webSerViceCall_TurnUserVitaminReminderOff:userVitaminDict];
                                                      
                                                  }];
                        UIAlertAction *cancelAction = [UIAlertAction
                                                       actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action)
                                                       {
                                                           
                                                       }];
                        [alertController addAction:okAction];
                        [alertController addAction:turnOff];
                        [alertController addAction:cancelAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                }
            }
        }
    }else{
        if (![Utility isEmptyCheck:[vitaminListArray objectAtIndex:sender.tag]]) {
            resultDict= [NSMutableDictionary new];
            resultDict =  [[vitaminListArray objectAtIndex:sender.tag]objectForKey:@"UserVitaminDetails"];
        
            SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
            controller.reminderDelegate = self;
            controller.fromController=@"Vitamin";
            controller.view.backgroundColor = [UIColor clearColor];
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}
-(void)reminderDetails:(BOOL)isEdit vitaminId:(int)userVitaminId{
    AddVitaminViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddVitaminView"];
    controller.isFromEdit=YES;
    controller.addVitaminDelegate=self;
    controller.isFromNotification= isEdit;
    controller.userVitaminId = userVitaminId;
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)todayButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:todayArrayDetails]) {
        NSDictionary *todayDict = [todayArrayDetails objectAtIndex:sender.tag];
        NSArray *individualTaskArray = [todayDict objectForKey:@"IndividualTasks"];
       
        if (!([[todayDict objectForKey:@"PendingCount"]intValue] == 0)) {
            isPerfromEmpty = false;
            [self webSerViceCall_UpdateTaskStatus:individualTaskArray[[[todayDict objectForKey:@"DoneCount"]intValue]]];
        }
        else{
            for (int i = 0; i<individualTaskArray.count; i++) {
                isPerfromEmpty = true;
                [self webSerViceCall_UpdateTaskStatus:individualTaskArray[i]];
            }
        }
    }
}
#pragma mark - End
#pragma mark - Private Function

-(NSString *)strFromDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd'T'HH:mm:ss
    NSString *str =[formatter stringFromDate:date];
    NSString *dateStr = [@"" stringByAppendingFormat:@"%@T00:00:00",str];
    return dateStr;
}
-(void)getWeekFirstDate{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:[NSDate date] options:0];
    if (beginningOfWeek) {
        weekDate = beginningOfWeek;
    }
 }
-(NSDate*)dateOfFirstAndLast:(int)month day:(int)day{
    NSDate *now = [NSDate date];
    NSDateComponents *components= [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:now];
    components.month = month;
    components.day = day;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}
-(NSArray*)daysInWeek:(int)weekOffset fromDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";//yyyy-MM-dd HH:mm:ss.SSS
    // [formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    //create date on week start
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:(0 - ([comps weekday] - weekOffset))];
    NSDate *weekstart = [calendar dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    //add 7 days
    NSMutableArray* week=[NSMutableArray arrayWithCapacity:7];
    for (int i=0; i<7; i++) {
        formatter.dateFormat = @"yyyy-MM-dd";//yyyy-MM-dd HH:mm:ss.SSS
        NSDateComponents *compsToAdd = [[NSDateComponents alloc] init];
        compsToAdd.day=i;
        NSDate *nextDate = [calendar dateByAddingComponents:compsToAdd toDate:weekstart options:0];
        [week addObject:[formatter stringFromDate:nextDate ]];
    }
    return [NSArray arrayWithArray:week];
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
-(void)setUpDaysInaMonth{
    monthDateArray = [[NSMutableArray alloc]init];
    NSDate *monthFirstDate=[self getFirstDateOfMonth:[NSDate date]];
    NSDate *lastDateOfmonth = [self lastDayOfMonth:[NSDate date]];
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
-(int)getPercerntageOfDone:(int)doneCount total:(int)totalCount{
    if (doneCount == 0 && totalCount == 0) {
        return 0;
    }else{
        return (100 * doneCount)/totalCount;
    }
}

-(void)webSerViceCall_GetVitaminTasks{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[self strFromDate:[self dateOfFirstAndLast:1 day:1]] forKey:@"FromDateString"];
        [mainDict setObject:[self strFromDate:[self dateOfFirstAndLast:12 day:31]] forKey:@"ToDateString"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetVitaminTasks" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"%@",responseString);
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         self->vitaminListArray = [responseDict objectForKey:@"VitaminLists"];
                                                                         if (![Utility isEmptyCheck:self->vitaminListArray] && self->vitaminListArray.count>0) {
                                                                             if (self->todayButton.selected) {
                                                                                 self->todayArrayDetails = [[NSMutableArray alloc]init];
                                                                                 for (int i =0; i<self->vitaminListArray.count; i++) {
                                                                                     NSDictionary *dict = [self->vitaminListArray objectAtIndex:i];
                                                                                     if (![Utility isEmptyCheck:dict]) {
                                                                                         if (![Utility isEmptyCheck:[dict objectForKey:@"VitaminTaskList"]]) {
                                                                                             NSArray *vitaminTask = [dict objectForKey:@"VitaminTaskList"];
                                                                                             NSArray *filteredTodayArr = [vitaminTask filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(TaskDate == %@)", [self strFromDate:[NSDate date]]]];
                                                                                             if (filteredTodayArr.count>0) {
                                                                                                 [self->todayArrayDetails addObject:[filteredTodayArr objectAtIndex:0]];
                                                                                             }
                                                                                         }
                                                                                     }
                                                                                 }
//                                                                                 NSLog(@"%@",self->todayArrayDetails);
                                                                             }
                                                                             self->todayTable.hidden = false;
                                                                             [self->todayTable reloadData];
                                                                         }else{
                                                                             self->todayTable.hidden=true;
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
-(void)webSerViceCall_UpdateTaskStatus:(NSDictionary*)dict{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[dict objectForKey:@"VitaminTaskId"] forKey:@"TaskId"];
        if (!isPerfromEmpty) {
            [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
        }else{
            [mainDict setObject:[NSNumber numberWithBool:false] forKey:@"IsDone"];
        }

//        if ([[dict objectForKey:@"IsTaskDone"]boolValue]) {
//            [mainDict setObject:[NSNumber numberWithBool:false] forKey:@"IsDone"];
//        }else{
//            [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
//        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateTaskStatus" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         [self dataReload];
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
-(void)webSerViceCall_TurnUserVitaminReminderOff:(NSDictionary*)reminderDict{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        if (![Utility isEmptyCheck:[reminderDict objectForKey:@"ReminderVitaminId"]] && [[reminderDict objectForKey:@"ReminderVitaminId"]intValue]>0) {
            [mainDict setObject:[reminderDict objectForKey:@"ReminderVitaminId"] forKey:@"UserVitaminId"];
        }else{
            [mainDict setObject:[reminderDict objectForKey:@"UserVitaminId"] forKey:@"UserVitaminId"];
        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"TurnUserVitaminReminderOff" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         [self dataReload];
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
-(void)webSerViceCall_AddUpdateUserVitamin:(NSDictionary*)reminderDict{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        NSMutableDictionary *subDict =[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDateFormatter *df1 = [NSDateFormatter new];
        [df1 setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [df1 stringFromDate:[NSDate date]];
        
        if (![Utility isEmptyCheck:resultDict]) {
            [subDict setObject:dateStr forKey:@"CreatedAtString"];
            [subDict setObject:dateStr forKey:@"UpdatedAtString"];
            [subDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
            
            [subDict setObject:[resultDict objectForKey:@"VitaminName"] forKey:@"VitaminName"];
            if (![Utility isEmptyCheck:[resultDict objectForKey:@"TabletPerTime"]]) {
                [subDict setObject:[resultDict objectForKey:@"TabletPerTime"] forKey:@"TabletPerTime"];
            }
            [subDict setObject:[resultDict objectForKey:@"DailyAmount"] forKey:@"DailyAmount"];
            [subDict setObject:[resultDict objectForKey:@"VitaminAmountTypeId"] forKey:@"VitaminAmountTypeId"];
            [subDict setObject:[resultDict objectForKey:@"TaskFrequencyTypeId"] forKey:@"TaskFrequencyTypeId"];
            [subDict setObject:[reminderDict objectForKey:@"FrequencyId"] forKey:@"ReminderFrequencyId"];
            [subDict setObject:[NSNumber numberWithBool:YES] forKey:@"ReminderPushNotify"];
            [subDict setObject:[reminderDict objectForKey:@"Email"] forKey:@"ReminderEmail"];
            [subDict setObject:[reminderDict objectForKey:@"ReminderAt1"] forKey:@"ReminderAt1"];
            [subDict setObject:[reminderDict objectForKey:@"ReminderAt2"] forKey:@"ReminderAt2"];
            [subDict setObject:[reminderDict objectForKey:@"ReminderOption"] forKey:@"ReminderOption"];
            [subDict setObject:[reminderDict objectForKey:@"Email"] forKey:@"Email"];
            [subDict setObject:[reminderDict objectForKey:@"PushNotification"] forKey:@"PushNotification"];

            [subDict setObject:[reminderDict objectForKey:@"Sunday"] forKey:@"IsSundayTask"];
            [subDict setObject:[reminderDict objectForKey:@"Monday"] forKey:@"IsMondayTask"];
            [subDict setObject:[reminderDict objectForKey:@"Tuesday"] forKey:@"IsTuesdayTask"];
            [subDict setObject:[reminderDict objectForKey:@"Wednesday"] forKey:@"IsWednesdayTask"];
            [subDict setObject:[reminderDict objectForKey:@"Thursday"] forKey:@"IsThursdayTask"];
            [subDict setObject:[reminderDict objectForKey:@"Friday"] forKey:@"IsFridayTask"];
            [subDict setObject:[reminderDict objectForKey:@"Saturday"] forKey:@"IsSaturdayTask"];
            
            [subDict setObject:[reminderDict objectForKey:@"Sunday"] forKey:@"Sunday"];
            [subDict setObject:[reminderDict objectForKey:@"Monday"] forKey:@"Monday"];
            [subDict setObject:[reminderDict objectForKey:@"Tuesday"] forKey:@"Tuesday"];
            [subDict setObject:[reminderDict objectForKey:@"Wednesday"] forKey:@"Wednesday"];
            [subDict setObject:[reminderDict objectForKey:@"Thursday"] forKey:@"Thursday"];
            [subDict setObject:[reminderDict objectForKey:@"Friday"] forKey:@"Friday"];
            [subDict setObject:[reminderDict objectForKey:@"Saturday"] forKey:@"Saturday"];
            
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"IsJanuaryTask"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"IsFebruaryTask"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"IsMarchTask"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"IsAprilTask"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"IsMayTask"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"IsJuneTask"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"IsJulyTask"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"IsAugustTask"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"IsSeptemberTask"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"IsOctoberTask"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"IsNovemberTask"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"IsDecemberTask"];
            
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"January"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"February"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"March"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"April"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"May"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"June"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"July"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"August"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"September"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"October"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"November"];
            [subDict setObject:[NSNumber numberWithBool:false] forKey:@"December"];
            
            [subDict setObject:[resultDict objectForKey:@"UserVitaminId"] forKey:@"UserVitaminId"];
            [subDict setObject:[resultDict objectForKey:@"VitaminAmountTypeId"] forKey:@"VitaminAmountTypeId"];//[resultDict objectForKey:@"VitaminAmountType"]
            [mainDict setObject:subDict forKey:@"Model"];
        }
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateUserVitamin" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         
                                                                         if ([[reminderDict objectForKey:@"PushNotification"]boolValue]) {
                                                                             if(![Utility isEmptyCheck:[responseDict objectForKey:@"UserVitaminId"]]){
                                                                                 [subDict setObject:[responseDict objectForKey:@"UserVitaminId"] forKey:@"UserVitaminId"];
                                                                                 [self generateNotification:subDict];
                                                                             }
                                                                             
                                                                             //                                                                             [SetReminderViewController setOldLocalNotificationFromDictionary:self->resultDict ExtraData:[NSMutableDictionary new] FromController:@"Vitamin" Title:[self->resultDict objectForKey:@"VitaminName"] Type:@"Vitamin" Id:[[resultDict objectForKey:@"UserVitaminId"]intValue]];
                                                                         }
                                                                         [self addDataReload];
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
-(void)generateNotification:(NSMutableDictionary*)modelDict{
    NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *req in requests) {
        NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
        int idValue = [[req.userInfo objectForKey:@"ID"]intValue];
        if ([pushTo caseInsensitiveCompare:@"Vitamin"] == NSOrderedSame && (idValue == [[modelDict objectForKey:@"UserVitaminId"]intValue])) {
            [[UIApplication sharedApplication] cancelLocalNotification:req];
        }
    }
    NSMutableDictionary *extraData = [[NSMutableDictionary alloc] init];
    [extraData setObject:[modelDict objectForKey:@"UserVitaminId"] forKey:@"Id"];
//    [SetReminderViewController setOldLocalNotificationFromDictionary:modelDict ExtraData:extraData FromController:@"Vitamin" Title:[modelDict objectForKey:@"VitaminName"] Type:@"Vitamin" Id:[[modelDict objectForKey:@"UserVitaminId"]intValue]];
}
#pragma mark - End
#pragma mark - TableView datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIndentifier = @"VitaminMonthlyTableViewCell";
    VitaminMonthlyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    CGFloat height = 0;
    if (todayButton.selected) {
        height = 55;//44
    }else if(thisWeekButton.selected) {
        height = 120;//75
    }
    else{
        height = cell.collectionHeightConstant.constant+40;
    }
    return height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (todayButton.selected) {
        return todayArrayDetails.count;
    }else{
        return vitaminListArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *maincell;NSDictionary *vitaminDict;
    if (!todayButton.selected) {
        vitaminDict = [vitaminListArray objectAtIndex:indexPath.row];
    }

    if (![Utility isEmptyCheck:vitaminDict] || (![Utility isEmptyCheck:todayArrayDetails] && todayArrayDetails.count>0)) {
        if (todayButton.selected) {
            NSString *cellIndentifier = @"VitaminTodayTableViewCell";
            VitaminTodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[VitaminTodayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
                    NSDictionary *individualVitaminDetailsDict = [todayArrayDetails objectAtIndex:indexPath.row];
                    NSArray *individualTaskArr = [individualVitaminDetailsDict objectForKey:@"IndividualTasks"];
                    if (![Utility isEmptyCheck:individualTaskArr] && individualTaskArr.count>0) {
                        if (![Utility isEmptyCheck:[individualTaskArr objectAtIndex:0]]) {
                            cell.todayVitaminName.text = [[individualTaskArr objectAtIndex:0]objectForKey:@"VitaminName"];
                        }else{
                            cell.todayVitaminName.text=@"";
                        }
                    }
                    if ([[individualVitaminDetailsDict objectForKey:@"DoneCount"]intValue]==0) {
                        cell.completePortionLabel.hidden = true;
                        cell.completePortionLabel.text=@"";
                        [cell.todayPortionImgButton setImage:[UIImage imageNamed:@"vitamin_pink_circle.png"] forState:UIControlStateNormal];
                    }else if ([[individualVitaminDetailsDict objectForKey:@"PendingCount"]intValue]==0){
                        cell.completePortionLabel.hidden = true;
                        cell.completePortionLabel.text=@"";
                        [cell.todayPortionImgButton setImage:[UIImage imageNamed:@"vitamin_tick_big.png"] forState:UIControlStateNormal];
                    }else{
                        cell.completePortionLabel.hidden = false;
                        cell.completePortionLabel.text = [@"" stringByAppendingFormat:@"%@ of %@ complete",[individualVitaminDetailsDict objectForKey:@"DoneCount"],[individualVitaminDetailsDict objectForKey:@"TotalCount"]];
                        [cell.todayPortionImgButton setImage:[UIImage imageNamed:@"Vitamin_darkcircle.png"] forState:UIControlStateNormal];
                        
                        if ([[individualVitaminDetailsDict objectForKey:@"TotalCount"]intValue]==2) {
                            int totalComplete = [self getPercerntageOfDone:[[individualVitaminDetailsDict objectForKey:@"DoneCount"]intValue] total:[[individualVitaminDetailsDict objectForKey:@"TotalCount"]intValue]];
                            
                            if (totalComplete>=10 && totalComplete<100) {
                                [cell.todayPortionImgButton setImage:[UIImage imageNamed:@"half_circle.png"] forState:UIControlStateNormal];
                            }
                        }else{
                            int totalComplete = [self getPercerntageOfDone:[[individualVitaminDetailsDict objectForKey:@"DoneCount"]intValue] total:[[individualVitaminDetailsDict objectForKey:@"TotalCount"]intValue]];
                            
                            if (totalComplete>=10 && totalComplete<=50) {
                                [cell.todayPortionImgButton setImage:[UIImage imageNamed:@"1of3rd.png"] forState:UIControlStateNormal];
                            }else if ((totalComplete>=50 && totalComplete<100)){
                                [cell.todayPortionImgButton setImage:[UIImage imageNamed:@"2of3rd.png"] forState:UIControlStateNormal];
                            }
                        }
                    }
            
            NSArray *filteredArr = [vitaminListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(UserVitaminId == %@)", [[individualTaskArr objectAtIndex:0]objectForKey:@"UserVitaminId"]]];
            
                NSDictionary *dict = [filteredArr objectAtIndex:0];
                NSDictionary *userVitaminDict = [dict objectForKey:@"UserVitaminDetails"];
            
            if ((![Utility isEmptyCheck:[userVitaminDict objectForKey:@"ReminderFrequencyId"]] && [[userVitaminDict objectForKey:@"ReminderFrequencyId"]intValue]>0) || (![Utility isEmptyCheck:[userVitaminDict objectForKey:@"ReminderVitaminId"]] && [[userVitaminDict objectForKey:@"ReminderVitaminId"]intValue]>0)) {
                    cell.notificationOfOnButton.selected = true;
                }else{
                    cell.notificationOfOnButton.selected = false;
                }
            
            cell.vitamimEditButton.tag=indexPath.row;
            cell.todayPortionImgButton.tag = indexPath.row;
            cell.notificationOfOnButton.tag = indexPath.row;
            maincell = cell;
        }else if (thisWeekButton.selected){
            NSString *cellIndentifier = @"VitaminWeeklyTableViewCell";
            VitaminWeeklyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[VitaminWeeklyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            if (![Utility isEmptyCheck:[vitaminDict objectForKey:@"VitaminName"]]) {
                cell.vitaminLabel.text = [vitaminDict objectForKey:@"VitaminName"];
            }else{
                cell.vitaminLabel.text=@"";
            }
            NSMutableArray *weeklyVitaminArray = [[NSMutableArray alloc]init];
            if (![Utility isEmptyCheck:[vitaminDict objectForKey:@"VitaminTaskList"]]) {
                NSArray *vitaminTask = [vitaminDict objectForKey:@"VitaminTaskList"];
                NSArray *weekDayArray = [self daysInWeek:2 fromDate:weekDate];
                for (NSString *dateStr in weekDayArray) {
                    NSArray *filteredArr = [vitaminTask filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(TaskDate == %@)", [@"" stringByAppendingFormat:@"%@T00:00:00",dateStr]]];
                    if (![Utility isEmptyCheck:filteredArr]) {
                        [weeklyVitaminArray addObject:[filteredArr objectAtIndex:0]];
                    }else{
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setObject:@"inactiveDay" forKey:@"DayNotActive"];
                        [weeklyVitaminArray addObject:dict];
                    }
                }
                NSNumber *sumOfDoneCount = [weeklyVitaminArray valueForKeyPath:@"@sum.DoneCount"];
                NSNumber *sumOfTotalCount = [weeklyVitaminArray valueForKeyPath:@"@sum.TotalCount"];
                int weelyDone = [self getPercerntageOfDone:[sumOfDoneCount intValue] total:[sumOfTotalCount intValue]];
                if (weelyDone>=0 && weelyDone<50) {
                    [cell.smileyTypeButton setImage:[UIImage imageNamed:@"Vitamin_Smily_sad.png"] forState:UIControlStateNormal];
                }else{
                    [cell.smileyTypeButton setImage:[UIImage imageNamed:@"Vitamin_Smily.png"] forState:UIControlStateNormal];

                }
                if (![Utility isEmptyCheck:weeklyVitaminArray]) {
                    for (UIButton *weekDay in cell.weekdays) {
                        weekDay.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.row];
                        if (![Utility isEmptyCheck:[weeklyVitaminArray objectAtIndex:weekDay.tag]]) {
                            NSDictionary *individualVitaminDetails = [weeklyVitaminArray objectAtIndex:weekDay.tag];
                            if (![Utility isEmptyCheck:individualVitaminDetails]) {
                                if ([Utility isEmptyCheck:[individualVitaminDetails objectForKey:@"DayNotActive"]]) {
                                    weekDay.userInteractionEnabled = true;
                                    if ([[individualVitaminDetails objectForKey:@"DoneCount"]intValue]==0) {
                                        [weekDay setImage:[UIImage imageNamed:@"Vitamin_darkcircle.png"] forState:UIControlStateNormal];
                                    }else if ([[individualVitaminDetails objectForKey:@"PendingCount"]intValue]==0){
                                        [weekDay setImage:[UIImage imageNamed:@"vitamin_tick_big.png"] forState:UIControlStateNormal];
                                    }else{
                                        if ([[individualVitaminDetails objectForKey:@"TotalCount"]intValue]==2) {
                                            int totalComplete = [self getPercerntageOfDone:[[individualVitaminDetails objectForKey:@"DoneCount"]intValue] total:[[individualVitaminDetails objectForKey:@"TotalCount"]intValue]];
                                            
                                            if (totalComplete>=10 && totalComplete<100) {
                                                [weekDay setImage:[UIImage imageNamed:@"half_circle.png"] forState:UIControlStateNormal];
                                            }
                                        }else{
                                                int totalComplete = [self getPercerntageOfDone:[[individualVitaminDetails objectForKey:@"DoneCount"]intValue] total:[[individualVitaminDetails objectForKey:@"TotalCount"]intValue]];
                                                if (totalComplete>=10 && totalComplete<=50) {
                                                    [weekDay setImage:[UIImage imageNamed:@"1of3rd.png"] forState:UIControlStateNormal];
                                                }else if ((totalComplete>=50 && totalComplete<100)){
                                                    [weekDay setImage:[UIImage imageNamed:@"2of3rd.png"] forState:UIControlStateNormal];
                                                }
                                            }
                                    }
                                }else{
                                    weekDay.userInteractionEnabled = false;
                                    [weekDay setImage:[UIImage imageNamed:@"Vitamin_lightcircle.png"] forState:UIControlStateNormal];
                                }
                              
                            }
                        }
                    }
                }
            }
            cell.vitamimEditWeeklyButton.tag= indexPath.row;
            maincell = cell;
        }else{
            NSString *cellIndentifier = @"VitaminMonthlyTableViewCell";
            VitaminMonthlyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[VitaminMonthlyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            cell.vitamimEditMonthlyButton.tag = indexPath.row;
            NSArray *vitaminTask = [vitaminDict objectForKey:@"VitaminTaskList"];
            if (![Utility isEmptyCheck:[vitaminDict objectForKey:@"VitaminName"]]) {
                cell.monthlyVitaminLabel.text = [vitaminDict objectForKey:@"VitaminName"];
            }
            NSArray *filteredTodayArr = [vitaminTask filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(TaskDate >= %@ and TaskDate <= %@)", [self strFromDate:[self getFirstDateOfMonth:[NSDate date]]],[self strFromDate:[self lastDayOfMonth:[NSDate date]]]]];
            
//            NSLog(@"==========%@",filteredTodayArr);
            
            NSNumber *sumOfDoneCount = [filteredTodayArr valueForKeyPath:@"@sum.DoneCount"];
            NSNumber *totalCount = [filteredTodayArr valueForKeyPath:@"@sum.TotalCount"];
            int monthlyDone = [self getPercerntageOfDone:[sumOfDoneCount intValue] total:[totalCount intValue]];
            if (monthlyDone>=0 && monthlyDone <50) {
                [cell.monthlySmileyButton setImage:[UIImage imageNamed:@"Vitamin_Smily_sad.png"] forState:UIControlStateNormal];
            }else{
                [cell.monthlySmileyButton setImage:[UIImage imageNamed:@"Vitamin_Smily.png"] forState:UIControlStateNormal];
            }
            [self setUpDaysInaMonth];
            [(VitaminMonthlyTableViewCell *)cell setUpView:monthDateArray vitaminArr:filteredTodayArr indexValue:(int)indexPath.row];
            maincell = cell;
        }
    }
    return maincell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddVitaminViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddVitaminView"];
    controller.isFromEdit=YES;
    controller.addVitaminDelegate=self;
    controller.userVitaminId = [[[vitaminListArray objectAtIndex:indexPath.row]objectForKey:@"UserVitaminId"] intValue];
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark  - End

#pragma mark - VitaminEditDelegateMethod
-(void)dataReload{
    if (![Utility isEmptyCheck:[defaults objectForKey:@"SelectedState"]]) {
        if ([[defaults objectForKey:@"SelectedState"]isEqualToString:@"today"]) {
            [self itemButtonPressed:todayButton];
        }else if ([[defaults objectForKey:@"SelectedState"]isEqualToString:@"Week"]){
            [self itemButtonPressed:thisWeekButton];
        }else{
            [self itemButtonPressed:monthButton];
        }
    }
}
#pragma mark - End
#pragma mark - AddVitaminDelegate

-(void)addDataReload{
    if (![Utility isEmptyCheck:[defaults objectForKey:@"SelectedState"]]) {
        if ([[defaults objectForKey:@"SelectedState"]isEqualToString:@"today"]) {
            [self itemButtonPressed:todayButton];
        }else if ([[defaults objectForKey:@"SelectedState"]isEqualToString:@"Week"]){
            [self itemButtonPressed:thisWeekButton];
        }else{
            [self itemButtonPressed:monthButton];
        }
    }
}
#pragma mark  - End

#pragma mark - ReminderDelegate
-(void) reminderSettingsValue:(NSMutableDictionary *)reminderDict {
    NSLog(@"rem %@",reminderDict);
    if (![Utility isEmptyCheck:reminderDict]) {
        [self webSerViceCall_AddUpdateUserVitamin:reminderDict];
    }
}
-(void) cancelReminder {
//    if ([resultDict objectForKey:@"FrequencyId"] != nil) {
//
//    } else {
////        [reminderSwitch setOn:NO];
//        [resultDict removeObjectForKey:@"FrequencyId"];
//    }
}
@end
