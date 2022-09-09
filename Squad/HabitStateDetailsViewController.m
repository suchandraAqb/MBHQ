//
//  HabitStateDetailsViewController.m
//  Squad
//
//  Created by Suchandra Bhattacharya on 31/12/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "HabitStateDetailsViewController.h"
#import "HabitStatsTableViewCell.h"
#import "WinTheWeekViewController.h"
@interface HabitStateDetailsViewController ()
{
    IBOutlet UITableView *habitStateTable;
    IBOutlet UILabel *habitNameLabel;
    IBOutlet UILabel *breakNameLabel;
    IBOutlet UIView *notesView;
    IBOutlet UITextView *notesTextView;
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIButton *saveButton;
    IBOutlet UIView *notesSubView;
    IBOutlet UILabel *noDataFound;
    IBOutlet UIButton *expandButton;
    IBOutlet UIButton *savetickButton;
    IBOutlet UIView *saveView;
    IBOutlet NSLayoutConstraint *saveHeightConstant;
    IBOutlet UIButton *cancelButton;
        
    
    
    NSMutableArray *habitArr;
    NSArray *habitBreakArr;
    UIView *contentView;
    BOOL isExpand;
    UIToolbar *toolBar;
    UITextView *activeTextView;
    UITextField *activeTextField;
    NSDictionary *edithabitDict;
    int indexValue;
    NSMutableArray *updateTAskArr;
    BOOL isFromback;
    NSDate *weekStartDate;
    NSMutableArray *updateTAskDateArr;
    NSDate *selectedDateForTaskStatus;
}
@end

@implementation HabitStateDetailsViewController
@synthesize habitName,statesDelegate;

#pragma mark - view Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    habitStateTable.estimatedRowHeight = 70;
    habitStateTable.rowHeight = UITableViewAutomaticDimension;
    habitArr = [[NSMutableArray alloc]init];
    notesView.hidden = true;
    isExpand = false;
    saveButton.layer.cornerRadius = 15;
    saveButton.layer.masksToBounds = YES;
    notesSubView.layer.cornerRadius = 8;
    notesSubView.layer.masksToBounds = YES;
    notesSubView.layer.borderColor = squadMainColor.CGColor;
    notesSubView.layer.borderWidth = 1;
    updateTAskArr = [[NSMutableArray alloc]init];
    updateTAskDateArr = [[NSMutableArray alloc]init];
    savetickButton.layer.cornerRadius = 15;
    savetickButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = 15;
    cancelButton.layer.masksToBounds = YES;
    saveView.hidden = true;
    saveHeightConstant.constant =0;
        
    
    
    if (![Utility isEmptyCheck:habitName]) {
        habitNameLabel.text = [@"" stringByAppendingFormat:@"%@",[habitName uppercaseString]];
    }
    if (![Utility isEmptyCheck:habitName]) {
        breakNameLabel.text = [@"" stringByAppendingFormat:@"%@",[_breakHabitName uppercaseString]];
    }
    if (![Utility isEmptyCheck:_habitArray]) {
        NSSortDescriptor *ageDescriptor = [[NSSortDescriptor alloc] initWithKey:@"TaskDate" ascending:NO];
        NSArray *sortDescriptors = @[ageDescriptor];
        NSArray *habitArray = [_habitArray sortedArrayUsingDescriptors:sortDescriptors];
        NSMutableArray *dateArr = [[NSMutableArray alloc]init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd'T'hh:mm:ss"];
        
        for (int i =0; i<habitArray.count; i++) {
            if (![Utility isEmptyCheck:[[habitArray objectAtIndex:i]objectForKey:@"TaskDate"]]) {
                NSDate *date = [formatter dateFromString:[[habitArray objectAtIndex:i]objectForKey:@"TaskDate"]];
                if([date compare:[NSDate date]]==NSOrderedAscending){
                    [dateArr addObject:[habitArray objectAtIndex:i]];
                }
            }
        }
        if (![Utility isEmptyCheck:dateArr]) {
            habitArr = [dateArr mutableCopy];
        }
        if (!(habitArr.count>0)) {
            habitArr = [_habitArray mutableCopy];
            NSSortDescriptor *ageDescriptor = [[NSSortDescriptor alloc] initWithKey:@"TaskDate" ascending:NO];
            NSArray *sortDescriptors = @[ageDescriptor];
            NSArray *habitArray = [_habitArray sortedArrayUsingDescriptors:sortDescriptors];
            if (habitArr.count>0) {
                [habitArr removeAllObjects];
            }
            [habitArr addObject:[habitArray objectAtIndex:(habitArray.count-1)]];
        }
        
    }
    if (![Utility isEmptyCheck:_habitBreakArray] && _habitBreakArray.count>0)  {
           NSSortDescriptor *ageDescriptor = [[NSSortDescriptor alloc] initWithKey:@"TaskDate" ascending:NO];
           NSArray *sortDescriptors = @[ageDescriptor];
           NSArray *habitBreakArray = [_habitBreakArray sortedArrayUsingDescriptors:sortDescriptors];
           NSMutableArray *dateArr = [[NSMutableArray alloc]init];
           NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
           [formatter setDateFormat:@"YYYY-MM-dd'T'hh:mm:ss"];
           
           for (int i =0; i<habitBreakArray.count; i++) {
               if (![Utility isEmptyCheck:[[habitBreakArray objectAtIndex:i]objectForKey:@"TaskDate"]]) {
                   NSDate *date = [formatter dateFromString:[[habitBreakArray objectAtIndex:i]objectForKey:@"TaskDate"]];
                   if([date compare:[NSDate date]]==NSOrderedAscending){
                       [dateArr addObject:[habitBreakArray objectAtIndex:i]];
                   }
               }
           }
           if (![Utility isEmptyCheck:dateArr]) {
                habitBreakArr = [dateArr mutableCopy];
            }
            NSMutableArray *breakArr = [[NSMutableArray alloc]init];
           if (!(habitBreakArr.count>0)) {
               NSSortDescriptor *ageDescriptor = [[NSSortDescriptor alloc] initWithKey:@"TaskDate" ascending:NO];
               NSArray *sortDescriptors = @[ageDescriptor];
               NSArray *habitArray = [_habitBreakArray sortedArrayUsingDescriptors:sortDescriptors];
               [breakArr addObject:[habitArray objectAtIndex:(habitArray.count-1)]];
               habitBreakArr = [breakArr mutableCopy];
           }
       }
//    if (_frequencyId>1 && !(habitArr.count>0)) {
//        habitArr = [_habitArray mutableCopy];
//        NSSortDescriptor *ageDescriptor = [[NSSortDescriptor alloc] initWithKey:@"TaskDate" ascending:NO];
//        NSArray *sortDescriptors = @[ageDescriptor];
//        NSArray *habitArray = [_habitArray sortedArrayUsingDescriptors:sortDescriptors];
//        if (habitArr.count>0) {
//            [habitArr removeAllObjects];
//        }
//        [habitArr addObject:[habitArray objectAtIndex:(habitArray.count-1)]];
//    }
    if ([Utility isEmptyCheck:_habitArray] && [Utility isEmptyCheck:_habitBreakArray]) {
       noDataFound.hidden = false;
       habitStateTable.hidden = true;
    }else{
       noDataFound.hidden = true;
       habitStateTable.hidden = false;
    }
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [self registerForKeyboardNotifications];
    
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    int daynumber=(int)[cal component:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSDate *todayDate=[NSDate date];
    if (daynumber==1) {
        weekStartDate=[todayDate dateBySubtractingDays:6];
    }else{
        weekStartDate=[todayDate dateBySubtractingDays:(daynumber-2)];
    }
}



#pragma mark - End

#pragma mark - IBAction


-(IBAction)backButtonPressed:(id)sender{
    if (!saveView.hidden) {
        [self alertPopUp];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(IBAction)habitCreatePressed:(UIButton*)sender{
   
    sender.selected = !sender.selected;
    NSDictionary *dict = habitArr[sender.tag];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd'T'hh:mm:ss"];
    
    
    if (![Utility isEmptyCheck:[dict objectForKey:@"TaskDate"]]) {
        NSDate *date = [formatter dateFromString:[dict objectForKey:@"TaskDate"]];
        if (![updateTAskDateArr containsObject:date]) {
            [updateTAskDateArr addObject:date];
        }
    
        if([date compare:[NSDate date]]==NSOrderedDescending &&_frequencyId>1){
            return;
        }
    }
 
    NSMutableDictionary *subdict = [[NSMutableDictionary alloc]init];
    [subdict setObject:[dict objectForKey:@"TaskMasterId"] forKey:@"TaskId"];
    
   if ([[dict objectForKey:@"IsTaskDone"]boolValue]) {
        [subdict setObject:[NSNumber numberWithBool:false] forKey:@"IsDone"];
    }else{
        [subdict setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
    }
    if ([updateTAskArr containsObject:subdict]) {
        [updateTAskArr removeObject:subdict];
    }
    [updateTAskArr addObject:subdict];
    [self updatetickUntick];

    [self flashSaveButton];
}
-(IBAction)saveTickButton:(id)sender{
    [self webSerViceCall_UpdateTaskStatus];
}
-(IBAction)breakHabitPressed:(UIButton*)sender{
   
   sender.selected = !sender.selected;
   NSDictionary *dict = habitBreakArr[sender.tag];
   NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
      [formatter setDateFormat:@"YYYY-MM-dd'T'hh:mm:ss"];
      if (![Utility isEmptyCheck:[dict objectForKey:@"TaskDate"]]) {
          NSDate *date = [formatter dateFromString:[dict objectForKey:@"TaskDate"]];
          if([date compare:[NSDate date]]==NSOrderedDescending &&_frequencyId>1){
              return;
          }
      }
   NSMutableDictionary *subdict = [[NSMutableDictionary alloc]init];
   [subdict setObject:[dict objectForKey:@"TaskMasterId"] forKey:@"TaskId"];
   
  if ([[dict objectForKey:@"IsTaskDone"]boolValue]) {
       [subdict setObject:[NSNumber numberWithBool:false] forKey:@"IsDone"];
   }else{
       [subdict setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
   }
    if ([updateTAskArr containsObject:subdict]) {
        [updateTAskArr removeObject:subdict];
    }
   [updateTAskArr addObject:subdict];
   [self updatetickUntick];
   [self flashSaveButton];
}
-(IBAction)notesCrossPressed:(id)sender{
    notesView.hidden = true;
}
-(IBAction)editButtonPressed:(UIButton*)sender{
    edithabitDict =[habitArr objectAtIndex:sender.tag];
    indexValue = (int)sender.tag;
    notesView.hidden = false;

    if (![Utility isEmptyCheck:edithabitDict] && ![Utility isEmptyCheck:[edithabitDict objectForKey:@"Note"]]) {
        notesTextView.text = [edithabitDict objectForKey:@"Note"];
    }else{
        notesTextView.text = @"";
    }
}
-(IBAction)saveButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:notesTextView.text]) {
        if (![Utility isEmptyCheck:edithabitDict]) {
            [self webSerViceCall_UpdateTaskNote:edithabitDict with:indexValue];
        }
    }else{
        [Utility msg:@"Please Enter Some Text" title:@"" controller:self haveToPop:NO];
    }
    
}
-(IBAction)expandButtonPressed:(UIButton*)sender{
      if (isExpand) {
          isExpand = false;
          expandButton.selected = false;
      }else{
          isExpand = true;
          expandButton.selected = true;
      }
      [habitStateTable reloadData];
}
-(IBAction)habitnameButtonPressd:(UIButton*)sender{
    NSString *detailsStr = @"";
    if (sender.tag == 1) {
        detailsStr = [habitName uppercaseString];
    }else{
        detailsStr = [_breakHabitName uppercaseString];
    }
    [Utility msg:detailsStr title:@"" controller:self haveToPop:NO];
}
-(IBAction)cancelButtonPressed:(id)sender{
    saveView.hidden = true;
    saveHeightConstant.constant = 0;
}
#pragma mark - Private Function

-(void)checkWinTheWeek:(NSDictionary*)responseDict{
    int totalTaskForTheDay=[[responseDict objectForKey:@"TotalTaskForTheDay"] intValue];
    int totalTaskDoneForTheDay=[[responseDict objectForKey:@"TotalTaskDoneForTheDay"] intValue];
    BOOL dailyPopupShown = [[responseDict objectForKey:@"DailyBadgeShown"] boolValue];
    
    int daysDoneForTheWeek=[[responseDict objectForKey:@"DaysDoneForTheWeek"] intValue];
    BOOL WeeklyPopupShown = [[responseDict objectForKey:@"WeeklyBadgeShown"] boolValue];
    
    NSString *weekStartDateStr=[responseDict objectForKey:@"WeekStartDate"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDateString=[formatter stringFromDate:selectedDateForTaskStatus];
    
    
    if (daysDoneForTheWeek>=4 && !WeeklyPopupShown) {
        WinTheWeekViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WinTheWeekView"];
        controller.winType=@"WEEK";
        controller.dayDoneCount=daysDoneForTheWeek;
        controller.WeekStartDateStr=weekStartDateStr;
        controller.todayDateStr=todayDateString;
        controller.parent=self;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else if (totalTaskForTheDay>0 && totalTaskDoneForTheDay>0 && totalTaskForTheDay==totalTaskDoneForTheDay && !dailyPopupShown){
        WinTheWeekViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WinTheWeekView"];
        controller.winType=@"DAY";
        controller.dayDoneCount=daysDoneForTheWeek;
        controller.WeekStartDateStr=weekStartDateStr;
        controller.todayDateStr=todayDateString;
        controller.parent=self;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }
}



-(void)flashSaveButton{
    if (updateTAskArr.count>0) {
        saveView.hidden = false;
        saveHeightConstant.constant = 65;
//        [Utility startFlashingbuttonForManualSort:savetickButton];
    }
}
-(void)alertPopUp{
     NSString *str = @"Your changes will be lost if you don’t save them.";
        UIAlertController *alertController = [UIAlertController
                                                 alertControllerWithTitle:@"Save Changes"
                                                 message:str
                                                 preferredStyle:UIAlertControllerStyleAlert];
        [alertController setValue:[Utility getattributedMessage:str] forKey:@"attributedMessage"];
        
           UIAlertAction *okAction = [UIAlertAction
                                      actionWithTitle:@"Save"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction *action)
                                      {
                                         self->isFromback = true;
                                         [self saveTickButton:0];
                                      }];
           UIAlertAction *cancelAction = [UIAlertAction
                                          actionWithTitle:@"Don't Save"
                                          style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction *action)
                                          {
                                            self->saveView.hidden = true;
                                            self->saveHeightConstant.constant = 0;
                                            [self.navigationController popViewControllerAnimated:YES];
                                          }];
           [alertController addAction:cancelAction];
           [alertController addAction:okAction];
           [self presentViewController:alertController animated:YES completion:nil];
}
-(void)updatetickUntick{
    for (int i = 0; i<updateTAskArr.count; i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(TaskMasterId = %d)",[[[updateTAskArr objectAtIndex:i]objectForKey:@"TaskId"]intValue]];
        NSArray *filterArr = [habitArr filteredArrayUsingPredicate:predicate];
        if (filterArr.count>0) {
            int index = (int)[habitArr indexOfObject:[filterArr objectAtIndex:0]];
            NSDictionary *dic = [habitArr objectAtIndex:index];
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
            tempDict = [dic mutableCopy];
            BOOL isDone = [[[updateTAskArr objectAtIndex:i]objectForKey:@"IsDone"]boolValue];
            [tempDict setObject:[NSNumber numberWithBool:isDone] forKey:@"IsDone"];
            [habitArr replaceObjectAtIndex:index withObject:tempDict];
        }
        NSArray *filterArr1 = [habitBreakArr filteredArrayUsingPredicate:predicate];

        if (filterArr1.count>0) {
            int index = (int)[habitBreakArr indexOfObject:[filterArr1 objectAtIndex:0]];
            NSDictionary *dic = [habitBreakArr objectAtIndex:index];
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
            tempDict = [dic mutableCopy];
            BOOL isDone = [[[updateTAskArr objectAtIndex:i]objectForKey:@"IsDone"]boolValue];
            [tempDict setObject:[NSNumber numberWithBool:isDone] forKey:@"IsDone"];
            NSMutableArray *habitBreak = [[NSMutableArray alloc]init];
            habitBreak = [habitBreakArr mutableCopy];
            [habitBreak replaceObjectAtIndex:index withObject:tempDict];
            habitBreakArr = [habitBreak mutableCopy];
        }
    }
}
#pragma mark - End
-(void)webSerViceCall_UpdateTaskNote:(NSDictionary*)dict with:(int)indexValue{
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
        [mainDict setObject:[dict objectForKey:@"TaskMasterId"] forKey:@"TaskMasterId"];
        [mainDict setObject:notesTextView.text forKey:@"Note"];
       
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateTaskNote" append:@""forAction:@"POST"];
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
                                                                         self->notesView.hidden = true;
                                                                         
                                                                         [Utility msg:@"Notes Saved Succesfully" title:@"" controller:self haveToPop:NO];
                                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"IsHackerListReload" object:self userInfo:nil];
                                                                         
                                                                         NSMutableDictionary *newDict=[[NSMutableDictionary alloc]init];
                                                                         newDict = [self->edithabitDict mutableCopy];
                                                                         [newDict setObject:self->notesTextView.text forKey:@"Note"];
                                                                         if (indexValue>=0) {
                                                                             [self->habitArr replaceObjectAtIndex:indexValue withObject:newDict];
                                                                             self->notesTextView.text = @"";
                                                                             [self->habitStateTable reloadData];
                                                                         }
                                                                         if ([self->statesDelegate respondsToSelector:@selector(reloadData)]) {
                                                                             [self->statesDelegate reloadData];
                                                                             
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

-(void)webSerViceCall_UpdateTaskStatus{
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
        [mainDict setObject:updateTAskArr forKey:@"TaskDoneStatuses"];
       
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateTaskStatusForMultiple" append:@""forAction:@"POST"];
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
                                                                         
                                                                         if (self->updateTAskDateArr.count>0) {
                                                                             NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
                                                                             NSArray *descriptors=[NSArray arrayWithObject: descriptor];
                                                                             NSArray *reverseOrder=[self->updateTAskDateArr sortedArrayUsingDescriptors:descriptors];
                                                                             
                                                                             NSDate *selectedDate=[reverseOrder objectAtIndex:0];
                                                                             NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                                                                             [formatter setDateFormat:@"yyyy-MM-dd"];
                                                                             NSString *selectedDateString=[formatter stringFromDate:selectedDate];
                                                                             selectedDate=[formatter dateFromString:selectedDateString];
                                                                             NSString *weekStartDateString=[formatter stringFromDate:self->weekStartDate];
                                                                             NSDate *weekStartDt=[formatter dateFromString:weekStartDateString];
                                                                             
                                                                             NSComparisonResult r= [selectedDate compare:weekStartDt];
                                                                             [self->updateTAskDateArr removeAllObjects];
                                                                             if ([selectedDate compare:weekStartDt]!=NSOrderedAscending){
                                                                                 self->selectedDateForTaskStatus=selectedDate;
                                                                                 [self webSerViceCall_GetTaskStatusForDate];
                                                                             }
                                                                         }
                                                                         
                                                                         if (self->updateTAskArr.count>0) {
                                                                             self->saveView.hidden = true;
                                                                             self->saveHeightConstant.constant = 0;
                                                                             [self updatetickUntick];
//                                                                             [self->updateTAskArr removeAllObjects];
                                                                         }
                                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"IsHackerListReload" object:self userInfo:nil];

                                                                         if ([self->statesDelegate respondsToSelector:@selector(reloadData)]) {
                                                                             [self->statesDelegate reloadData];
                                                                         }
                                                                         if (self->isFromback) {
                                                                             self->isFromback = false;
                                                                             [self.navigationController popViewControllerAnimated:NO];
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

-(void)webSerViceCall_GetTaskStatusForDate{
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
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [mainDict setObject:[formatter stringFromDate:selectedDateForTaskStatus] forKey:@"ForDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetTaskStatusForDate" append:@""forAction:@"POST"];
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
                                                                         [self checkWinTheWeek:responseDict];
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

#pragma mark - End
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSInteger orientation=[UIDevice currentDevice].orientation;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        //ios7
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            kbSize=CGSizeMake(kbSize.height, kbSize.width);
        }else if (UIDeviceOrientationIsPortrait(orientation)){
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }
    }
    else {
        //iOS 8 specific code here
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }else if (UIDeviceOrientationIsPortrait(orientation)){
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }
    }
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
     mainScroll.contentInset = contentInsets;
     mainScroll.scrollIndicatorInsets = contentInsets;
    
   
    if (activeTextField !=nil) {
        mainScroll.contentInset = contentInsets;
        mainScroll.scrollIndicatorInsets = contentInsets;
        CGRect aRect = mainScroll.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
               [mainScroll scrollRectToVisible:activeTextField.frame animated:YES];
        }
   
       
    }else if (activeTextView !=nil) {
     CGRect aRect = mainScroll.frame;
           CGRect frame = [mainScroll convertRect:activeTextView.frame fromView:activeTextView.superview];
           aRect.size.height -= kbSize.height;
           if (!CGRectContainsPoint(aRect,frame.origin) ) {
               [mainScroll scrollRectToVisible:frame animated:YES];
           }
      }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
      
}
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
#pragma mark - textView Delegate

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [self.view layoutIfNeeded];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    activeTextView = textView;
    [textView setInputAccessoryView:toolBar];
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    activeTextView = textView;
    activeTextField = nil;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeTextView = nil;
    NSLog(@"%@",textView.text);
}

#pragma mark - TableView dataSource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return habitArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIndentifier = @"HabitStatsTableViewCell";
    HabitStatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
       cell = [[HabitStatsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
   }
    
    NSDateFormatter *dateFormatter1 = [NSDateFormatter new];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd'T'hh:mm:ss
    NSDateFormatter *dt1 = [NSDateFormatter new];
    [dt1 setDateFormat:@"EEE dd MMM"];
    NSDateFormatter *dt2 = [NSDateFormatter new];
    [dt2 setDateFormat:@"EEE"];
    
    NSDictionary *habitDict =[habitArr objectAtIndex:indexPath.row];
    NSString *taskStr =[habitDict objectForKey:@"TaskDateString"];
    NSDate *date1=[dateFormatter1 dateFromString:taskStr];
    cell.monthLabel.text = [dt1 stringFromDate:date1];
    if ([[dt2 stringFromDate:date1]isEqualToString:@"Mon"]) {
        cell.monthLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:17];
    }else{
        cell.monthLabel.font = [UIFont fontWithName:@"Raleway" size:17];
    }
    if ([[habitDict objectForKey:@"IsDone"]boolValue]) {
        cell.habitCreateButton.selected = true;
    }else{
        cell.habitCreateButton.selected = false;
    }
    if ((indexPath.row+1) < (habitArr.count)) {
        if (![Utility isEmptyCheck:[habitArr objectAtIndex:indexPath.row+1]]) {
        NSDictionary *habitDict =[habitArr objectAtIndex:indexPath.row+1];
        NSString *taskStr =[habitDict objectForKey:@"TaskDateString"];
        NSDate *date2=[dateFormatter1 dateFromString:taskStr];
        if (!([date1 month] == [date2 month])) {
            cell.monthSeperatorview.hidden = false;
        }else{
            cell.monthSeperatorview.hidden = true;
          }
        }
    }else{
           cell.monthSeperatorview.hidden = true;
        }
    

//    NSDictionary *breakHabitDict;
//    if (indexPath.row<habitBreakArr.count) {
//
//        cell.habitBreakButton.hidden=false;
//    }else{
//        cell.habitBreakButton.hidden=true;
//    }
    
    NSDictionary *breakHabitDict =[habitBreakArr objectAtIndex:indexPath.row];
    
    if ([[breakHabitDict objectForKey:@"IsDone"]boolValue]) {
           cell.habitBreakButton.selected = true;
       }else{
           cell.habitBreakButton.selected = false;
       }
     if (isExpand){
         [cell.stack insertArrangedSubview:cell.notesView atIndex:1];
     }else{
         [cell.stack removeArrangedSubview:cell.notesView];
         [cell.notesView removeFromSuperview];
     }
    
    
    if (![Utility isEmptyCheck:[habitDict objectForKey:@"Note"]]) {
        cell.editButton.selected = true;
        cell.notesTextlabel.text = [@"" stringByAppendingFormat:@"%@",[habitDict objectForKey:@"Note"]];
    }else{
        cell.editButton.selected = false;
        cell.notesTextlabel.text = @"";
    }
    cell.notesView.layer.cornerRadius = 8;
    cell.notesView.layer.masksToBounds = YES;
//    cell.notesView.layer.borderColor = squadMainColor.CGColor;
//    cell.notesView.layer.borderWidth = 1;
    cell.habitCreateButton.tag = indexPath.row;
    cell.habitBreakButton.tag = indexPath.row;
    cell.editButton.tag = indexPath.row;
    NSLog(@"========%ld",(long)cell.editButton.tag);
    
    if ([date1 isLaterThan:[NSDate date]]) {
        cell.habitCreateButton.userInteractionEnabled = false;
        cell.habitCreateButton.layer.opacity = 0.5;
        cell.habitBreakButton.userInteractionEnabled = false;
        cell.habitBreakButton.layer.opacity = 0.5;
        cell.editButton.userInteractionEnabled = false;
        cell.editButton.layer.opacity = 0.5;
    }else{
        cell.habitCreateButton.userInteractionEnabled = true;
        cell.habitCreateButton.layer.opacity = 1;
        cell.habitBreakButton.userInteractionEnabled = true;
        cell.habitBreakButton.layer.opacity = 1;
        cell.editButton.userInteractionEnabled = true;
        cell.editButton.layer.opacity = 1;
    }
    
    return cell;
}

@end
