//
//  PopularHabitLDetailsViewController.m
//  Squad
//
//  Created by Dhiman on 14/10/20.
//  Copyright © 2020 AQB Solutions. All rights reserved.
//

#import "PopularHabitLDetailsViewController.h"

@interface PopularHabitLDetailsViewController ()
{
    IBOutlet UIButton *saveButton;
    IBOutlet UITextView *habitCreateTextView;
    IBOutlet UITextView *habitBreakTextView;
    IBOutlet UIButton *habitTimeButton;
    IBOutlet UIScrollView *mainScroll;
    UITextView *activeTextView;
    UITextField *activeTextField;
    UIToolbar *toolBar;
    UIView *contentView;
    NSMutableDictionary *habitDict;
    NSMutableDictionary *habitDefaultReminderSet;
    NSMutableDictionary *reminderDictionary;
    NSMutableDictionary *breakHabitDict;
    NSMutableDictionary *reminderDictForSettingNotification;
    NSArray *frequencyArray;

}
@end

@implementation PopularHabitLDetailsViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    saveButton.layer.cornerRadius = 8;
    saveButton.layer.masksToBounds = YES;
    habitCreateTextView.layer.cornerRadius = 8;
    habitCreateTextView.layer.masksToBounds = YES;
    habitBreakTextView.layer.cornerRadius = 8;
    habitBreakTextView.layer.masksToBounds = YES;
    habitTimeButton.layer.cornerRadius = 8;
    habitTimeButton.layer.masksToBounds = YES;
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    habitDict = [[NSMutableDictionary alloc]init];
    habitDefaultReminderSet = [[NSMutableDictionary alloc]init];
    reminderDictionary = [[NSMutableDictionary alloc]init];
    breakHabitDict = [[NSMutableDictionary alloc]init];
    reminderDictForSettingNotification = [[NSMutableDictionary alloc]init];
    frequencyArray = [@[@"Daily",@"Twice Daily",@"Weekly",@"Fortnightly",@"Monthly",@"Yearly"] mutableCopy];
    if (![Utility isEmptyCheck:_popularhabitDict]) {
        if (![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"HabitToCreate"]]) {
            habitCreateTextView.text = [_popularhabitDict objectForKey:@"HabitToCreate"];
        }
        if (![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"HabitToBreak"]]) {
            habitBreakTextView.text = [_popularhabitDict objectForKey:@"HabitToBreak"];
        }
        if (![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"HabitFrequencyId"]]) {
            [habitTimeButton setTitle:[frequencyArray objectAtIndex:[[_popularhabitDict objectForKey:@"HabitFrequencyId"]intValue]-1] forState:UIControlStateNormal];
        }else{
            [habitTimeButton setTitle:[frequencyArray objectAtIndex:0] forState:UIControlStateNormal];
        }
    }
   [defaults setBool:false forKey:@"isCreate"];
    [self registerForKeyboardNotifications];

}

#pragma mark - End

#pragma mark - IBActions
-(IBAction)crossButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)saveButtonPressed:(id)sender{
    if ([Utility isEmptyCheck:habitCreateTextView.text] || [Utility isEmptyCheck:habitBreakTextView.text]) {
        [Utility msg:@"Please write your habit details " title:@"Alert" controller:self haveToPop:NO];
        return;
    }
    [self createHabitDetails];
}
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}

-(IBAction)reminder:(UISwitch*)sender{
      SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
        controller.isFromHacker = true;
        if (![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"HabitFrequencyId"]]) {
            [self setDefaultReminder];
            reminderDictionary = [habitDefaultReminderSet mutableCopy];
            controller.defaultSettingsDict = reminderDictionary;
        }
        controller.reminderDelegate = self;
        controller.view.backgroundColor = [UIColor clearColor];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark - End

#pragma mark - Private Fuction
-(void)createHabitDetails{
    [habitDict setObject:habitCreateTextView.text forKey:@"HabitName"];
    if (![Utility isEmptyCheck:reminderDictionary]) {
           [self setupHabit];
       }else{
           [self setDefaultReminder];
           reminderDictionary = [habitDefaultReminderSet mutableCopy];
           [self setupHabit];
       }
    [breakHabitDict setObject:habitBreakTextView.text forKey:@"Name"];
    [habitDefaultReminderSet setObject:[NSNumber numberWithInt:0] forKey:@"TaskReminderAt1"];
    [breakHabitDict setObject:[NSNumber numberWithInt:0] forKey:@"TaskReminderAt1"];
    [habitDefaultReminderSet setObject:[NSNumber numberWithInt:0] forKey:@"TaskReminderAt2"];
    [breakHabitDict setObject:[NSNumber numberWithInt:0] forKey:@"TaskReminderAt2"];
    [habitDict setObject:@"" forKey:@"ActionWhere"];
    [habitDict setObject:@"" forKey:@"Cue"];
    [habitDict setObject:@"" forKey:@"Routine"];
    [habitDict setObject:@"" forKey:@"MoreSeen"];
    [habitDict setObject:@"" forKey:@"Reward"];
    [habitDict setObject:@"" forKey:@"AccountabilityNotes"];
    [habitDict setObject:@"" forKey:@"OldActionBreak"];
    [habitDict setObject:@"" forKey:@"NoteHidden"];
    [habitDict setObject:@"" forKey:@"NoteHarder"];
    [habitDict setObject:@"" forKey:@"NoteHorrible"];
    [habitDefaultReminderSet setObject:[NSNumber numberWithInt:0] forKey:@"Duration"];
    [self addUpdateHabitSwap_WebServiceCall];

        
//        if (![Utility isEmptyCheck:newHabitTimeButton.accessibilityHint]) {
////            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
////             [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
////             NSDate *date = [dateFormatter dateFromString:[newHabitTimeButton.accessibilityHint mutableCopy]];
////             NSTimeInterval interval  = [date timeIntervalSince1970] ;
//             [habitDefaultReminderSet setObject:[newHabitTimeButton.accessibilityHint mutableCopy] forKey:@"TaskReminderAt1"];
//             [breakHabitDict setObject:[newHabitTimeButton.accessibilityHint mutableCopy] forKey:@"TaskReminderAt1"];
//
//        }else{
//             [habitDefaultReminderSet setObject:[NSNumber numberWithInt:0] forKey:@"TaskReminderAt1"];
//             [breakHabitDict setObject:[NSNumber numberWithInt:0] forKey:@"TaskReminderAt1"];
//        }
//        if (![Utility isEmptyCheck:newHabitTwiceTimeButton.accessibilityHint]) {
////            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
////            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
////            NSDate *date = [dateFormatter dateFromString:[newHabitTwiceTimeButton.accessibilityHint mutableCopy]];
////            NSTimeInterval interval  = [date timeIntervalSince1970] ;
//            [habitDefaultReminderSet setObject:[newHabitTwiceTimeButton.accessibilityHint mutableCopy] forKey:@"TaskReminderAt2"];
//            [breakHabitDict setObject:[newHabitTwiceTimeButton.accessibilityHint mutableCopy] forKey:@"TaskReminderAt2"];
//
////              [habitDefaultReminderSet setObject:newHabitTwiceTimeButton.accessibilityHint forKey:@"ReminderAt2"];
//        }else{
//              [habitDefaultReminderSet setObject:[NSNumber numberWithInt:0] forKey:@"TaskReminderAt2"];
//              [breakHabitDict setObject:[NSNumber numberWithInt:0] forKey:@"TaskReminderAt2"];
//
//         }
//        if (![Utility isEmptyCheck:howLongButton.accessibilityHint]) {
//            [habitDefaultReminderSet setObject:[NSNumber numberWithInt:[howLongButton.accessibilityHint intValue]] forKey:@"Duration"];
//        }else{
//             [habitDefaultReminderSet setObject:[NSNumber numberWithInt:0] forKey:@"Duration"];
//        }
//        if (![Utility isEmptyCheck:reminderDictForSettingNotification] && reminderSwitch.on) {
//            [self setUpReminder];
//            [self setupHabit];
//        }
//
    
}
-(void)setUpReminder{
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"April"] forKey:@"April"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"August"] forKey:@"August"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"December"] forKey:@"December"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"Email"] forKey:@"Email"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"February"] forKey:@"February"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"FrequencyId"] forKey:@"FrequencyId"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"Friday"] forKey:@"Friday"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"January"] forKey:@"January"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"July"] forKey:@"July"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"June"] forKey:@"June"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"March"] forKey:@"March"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"May"] forKey:@"May"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"Monday"] forKey:@"Monday"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"MonthReminder"] forKey:@"MonthReminder"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"November"] forKey:@"November"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"October"] forKey:@"October"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"PushNotification"] forKey:@"PushNotification"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"ReminderAt1"] forKey:@"ReminderAt1"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"ReminderAt2"] forKey:@"ReminderAt2"];
    
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"ReminderOption"] forKey:@"ReminderOption"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"Saturday"] forKey:@"Saturday"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"September"] forKey:@"September"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"Sunday"] forKey:@"Sunday"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"Thursday"] forKey:@"Thursday"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"Tuesday"] forKey:@"Tuesday"];
    [habitDefaultReminderSet setObject:[reminderDictForSettingNotification objectForKey:@"Wednesday"] forKey:@"Wednesday"];


}
-(void)setupHabit{
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"FrequencyId"] forKey:@"TaskFrequencyTypeId"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"Sunday"] forKey:@"IsSundayTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"Monday"] forKey:@"IsMondayTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"Tuesday"] forKey:@"IsTuesdayTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"Wednesday"] forKey:@"IsWednesdayTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"Thursday"] forKey:@"IsThursdayTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"Friday"] forKey:@"IsFridayTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"Saturday"] forKey:@"IsSaturdayTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"January"] forKey:@"IsJanuaryTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"February"] forKey:@"IsFebruaryTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"March"] forKey:@"IsMarchTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"April"] forKey:@"IsAprilTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"May"] forKey:@"IsMayTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"June"] forKey:@"IsJuneTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"July"] forKey:@"IsJulyTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"August"] forKey:@"IsAugustTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"September"] forKey:@"IsSeptemberTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"October"] forKey:@"IsOctoberTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"November"] forKey:@"IsNovemberTask"];
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"December"] forKey:@"IsDecemberTask"];
     [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[reminderDictionary objectForKey:@"TaskMonthReminder"]]?[reminderDictionary objectForKey:@"TaskMonthReminder"]:[NSNull null] forKey:@"TaskMonthReminder"];
//     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"ReminderAt1"] forKey:@"TaskReminderAt1"];
//     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"ReminderAt2"] forKey:@"TaskReminderAt2"];
    
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"FrequencyId"] forKey:@"TaskFrequencyTypeId"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"Sunday"] forKey:@"IsSundayTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"Monday"] forKey:@"IsMondayTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"Tuesday"] forKey:@"IsTuesdayTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"Wednesday"] forKey:@"IsWednesdayTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"Thursday"] forKey:@"IsThursdayTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"Friday"] forKey:@"IsFridayTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"Saturday"] forKey:@"IsSaturdayTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"January"] forKey:@"IsJanuaryTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"February"] forKey:@"IsFebruaryTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"March"] forKey:@"IsMarchTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"April"] forKey:@"IsAprilTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"May"] forKey:@"IsMayTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"June"] forKey:@"IsJuneTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"July"] forKey:@"IsJulyTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"August"] forKey:@"IsAugustTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"September"] forKey:@"IsSeptemberTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"October"] forKey:@"IsOctoberTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"November"] forKey:@"IsNovemberTask"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"December"] forKey:@"IsDecemberTask"];
        [breakHabitDict setObject:![Utility isEmptyCheck:[reminderDictionary objectForKey:@"TaskMonthReminder"]]?[reminderDictionary objectForKey:@"TaskMonthReminder"]:[NSNull null] forKey:@"TaskMonthReminder"];
//        [breakHabitDict setObject:[reminderDictionary objectForKey:@"ReminderAt1"] forKey:@"TaskReminderAt1"];
    //        [breakHabitDict setObject:[reminderDictionary objectForKey:@"ReminderAt2"] forKey:@"TaskReminderAt2"];

}
-(void)setDefaultReminder{
        [habitDefaultReminderSet setObject:[_popularhabitDict objectForKey:@"HabitFrequencyId"] forKey:@"FrequencyId"];
        [habitDefaultReminderSet setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
        [habitDefaultReminderSet setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt1"];
        [habitDefaultReminderSet setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt2"];
        [habitDefaultReminderSet setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
        [habitDefaultReminderSet setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
        [habitDefaultReminderSet setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
    
        [habitDefaultReminderSet setObject:[_popularhabitDict objectForKey:@"HabitFrequencyId"] forKey:@"TaskFrequencyTypeId"];
        [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"IsSundayTask"]]?[_popularhabitDict objectForKey:@"IsSundayTask"]:[NSNumber numberWithBool:false] forKey:@"IsSundayTask"];
        [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"IsMondayTask"]]?[_popularhabitDict objectForKey:@"IsMondayTask"]:[NSNumber numberWithBool:false] forKey:@"IsMondayTask"];
        [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"IsTuesdayTask"]]?[_popularhabitDict objectForKey:@"IsTuesdayTask"]:[NSNumber numberWithBool:false] forKey:@"IsTuesdayTask"];
        [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"IsWednesdayTask"]]?[_popularhabitDict objectForKey:@"IsWednesdayTask"]:[NSNumber numberWithBool:false] forKey:@"IsWednesdayTask"];
        [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"IsThursdayTask"]]?[_popularhabitDict objectForKey:@"IsThursdayTask"]:[NSNumber numberWithBool:false] forKey:@"IsThursdayTask"];
        [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"IsFridayTask"]]?[_popularhabitDict objectForKey:@"IsFridayTask"]:[NSNumber numberWithBool:false] forKey:@"IsFridayTask"];
        [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"IsSaturdayTask"]]?[_popularhabitDict objectForKey:@"IsSaturdayTask"]:[NSNumber numberWithBool:false] forKey:@"IsSaturdayTask"];
    
          [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"IsSundayTask"]]?[_popularhabitDict objectForKey:@"IsSundayTask"]:[NSNumber numberWithBool:false] forKey:@"Sunday"];
          [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"IsMondayTask"]]?[_popularhabitDict objectForKey:@"IsMondayTask"]:[NSNumber numberWithBool:false] forKey:@"Monday"];
          [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"IsTuesdayTask"]]?[_popularhabitDict objectForKey:@"IsTuesdayTask"]:[NSNumber numberWithBool:false] forKey:@"Tuesday"];
          [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"IsWednesdayTask"]]?[_popularhabitDict objectForKey:@"IsWednesdayTask"]:[NSNumber numberWithBool:false] forKey:@"Wednesday"];
          [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"IsThursdayTask"]]?[_popularhabitDict objectForKey:@"IsThursdayTask"]:[NSNumber numberWithBool:false] forKey:@"Thursday"];
          [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"IsFridayTask"]]?[_popularhabitDict objectForKey:@"IsFridayTask"]:[NSNumber numberWithBool:false] forKey:@"Friday"];
          [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"IsSaturdayTask"]]?[_popularhabitDict objectForKey:@"IsSaturdayTask"]:[NSNumber numberWithBool:false] forKey:@"Saturday"];
          [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"TaskMonthly"]]?[_popularhabitDict objectForKey:@"TaskMonthly"]:[NSNull null] forKey:@"TaskMonthReminder"];
        [habitDefaultReminderSet setObject:![Utility isEmptyCheck:[_popularhabitDict objectForKey:@"TaskMonthly"]]?[_popularhabitDict objectForKey:@"TaskMonthly"]:[NSNull null] forKey:@"MonthReminder"];

    
       NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
       NSArray* monthArray = [newDateformatter monthSymbols];
//       NSArray* dayArray = [newDateformatter weekdaySymbols];
       for (int i = 0; i < monthArray.count; i++) {
           [habitDefaultReminderSet setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:i]];
       }
//       for (int i = 0; i < dayArray.count; i++) {
//           [habitDefaultReminderSet setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
//       }
}
-(void)setUpDefaultReminderForPopularHabit{
       [reminderDictionary setObject:[_popularhabitDict objectForKey:@"HabitFrequencyId"] forKey:@"FrequencyId"];
       [reminderDictionary setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
       [reminderDictionary setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt1"];
       [reminderDictionary setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt2"];
       [reminderDictionary setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
       [reminderDictionary setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
       [reminderDictionary setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
       
       NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
       NSArray* monthArray = [newDateformatter monthSymbols];
       NSArray* dayArray = [newDateformatter weekdaySymbols];
       for (int i = 0; i < monthArray.count; i++) {
           [reminderDictionary setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:i]];
       }
       for (int i = 0; i < dayArray.count; i++) {
           [reminderDictionary setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
       }
}
-(void)addUpdateHabitSwap_WebServiceCall{
//    if ([Utility isEmptyCheck:[habitDict objectForKey:@"HabitName"]] || [Utility isEmptyCheck:[habitDefaultReminderSet objectForKey:@"TaskFrequencyTypeId"]] || [Utility isEmptyCheck:[breakHabitDict objectForKey:@"Name"]]) {
//        [Utility msg:@"Please write the habit do you want to create and break" title:@"Alert" controller:self haveToPop:NO];
//        return;
//    }
    
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
          
            [habitDict setObject:breakHabitDict forKey:@"SwapAction"];
            [habitDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
            [habitDict setObject:habitDefaultReminderSet forKey:@"NewAction"];
            
            [mainDict setObject:AccessKey forKey:@"Key"];
            [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
            [mainDict setObject:habitDict forKey:@"Habit"];
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateHabitSwap" append:@"" forAction:@"POST"];
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
                                                                                 NSDictionary *habitReturnDict = [responseDictionary objectForKey:@"HabitReturn"];
                                                                                 [self->habitDict setObject:[habitReturnDict objectForKey:@"HabitId"] forKey:@"HabitId"];
                                                                                 [defaults setBool:true forKey:@"isCreate"];
                                                                                 [self crossButtonPressed:0];
                                                                                 [[NSNotificationCenter defaultCenter]postNotificationName:@"HabitFirstViewReload" object:nil];
                                                                                  [[NSNotificationCenter defaultCenter]postNotificationName:@"IsHackerListReload" object:nil];
                                                                                 
                                                                                 NSArray *arr = [self->_parent.navigationController viewControllers];
                                                                                 UIViewController *controller = arr[[arr count]-3];
                                                                                 [self->_parent.navigationController popToViewController:controller animated:NO];
                                                                                 
//
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
#pragma mark - End
#pragma mark - End

#pragma mark - TextView Delegate

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
    
   
        if (activeTextView !=nil) {
             CGRect aRect = mainScroll.frame;
             CGRect frame = [mainScroll convertRect:activeTextView.frame fromView:activeTextView.superview];
                   aRect.size.height -= kbSize.height;
                   if (!CGRectContainsPoint(aRect,frame.origin) ) {
                       [mainScroll scrollRectToVisible:frame animated:YES];
                   }
        
    }
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    activeTextView = textView;
    [textView setInputAccessoryView:toolBar];
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    activeTextView = textView;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeTextView = nil;
    NSLog(@"%@",textView.text);
}

#pragma mark - Reminder Delegate

-(void)reminderSettingsValue:(NSMutableDictionary *)reminderDict {
    NSLog(@"rem %@",reminderDict);
    reminderDictionary = [reminderDict mutableCopy];
       int frequencyId = [[reminderDict objectForKey:@"FrequencyId"]intValue];
   
       if (frequencyId == 5) {
           int monthId = [[reminderDict objectForKey:@"MonthReminder"]intValue];
           [reminderDictionary setObject:[NSNumber numberWithInt:monthId] forKey:@"TaskMonthReminder"];
       }
    
    if (![Utility isEmptyCheck:reminderDict]) {
        [habitTimeButton setTitle:[frequencyArray objectAtIndex:[[reminderDictionary objectForKey:@"FrequencyId"]intValue]-1] forState:UIControlStateNormal];
    }
}
@end
