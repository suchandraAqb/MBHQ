//
//  HabitHackerDetailNewViewController.m
//  Squad
//
//  Created by Admin on 30/12/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "HabitHackerDetailNewViewController.h"
#import "NotesViewController.h"
#import "HabitHackerFirstViewController.h"

@interface HabitHackerDetailNewViewController (){
    
    UIToolbar *toolBar;
    UITextView *activeTextView;
    UITextField *activeTextField;
    UIView *contentView;
//    BOOL isEditMode;
    
    
    
    
    
    IBOutlet UIScrollView *mainScroll;
    IBOutletCollection(UITextView) NSArray *textView;
    
    IBOutletCollection(UIButton) NSArray *buttons;
    
    IBOutletCollection(UIButton) NSArray *statusButtons;
    
    
    IBOutlet UITextView *habitNameTextView;
    
    IBOutlet UIButton *reOccuringButton;
    
    IBOutlet UIView *whenView;
    IBOutlet UILabel *andLabel;
    IBOutlet UIButton *whenButton;
    IBOutlet UIButton *whenButton2;
    
    IBOutlet UIButton *durationButton;
    
    IBOutlet UIView *atView1;
    IBOutlet UIButton *atButton1;
    IBOutlet UIView *atView2;
    IBOutlet UIButton *atButton2;
    
    IBOutlet UITextView *whereTextView;
    IBOutlet UISwitch *reminderSwitch;
    IBOutlet UITextView *cueTextView;
    IBOutlet UITextView *routineTextView;
    IBOutlet UITextView *seenTextView;
    IBOutlet UITextView *rewardingTextView;
    IBOutlet UITextView *accountabilityTextView;
    
    IBOutlet UITextView *breakNameTextView;
    IBOutlet UITextView *cueBreakTextView;
    IBOutlet UITextView *routineBreakTextView;
    IBOutlet UITextView *rewardBreakTextView;
    IBOutlet UITextView *watchBreakTextView;
    IBOutlet UITextView *horrbBreakTextView;
    
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *editButton;
    IBOutlet UIButton *detailsButton;
    IBOutlet UIButton *statsButton;
    
    
    IBOutlet UILabel *habitNameLabel;
    IBOutlet UILabel *whereLabel;
    IBOutlet UILabel *cueLabel;
    IBOutlet UILabel *routineLabel;
    IBOutlet UILabel *seenLabel;
    IBOutlet UILabel *rewardingLabel;
    IBOutlet UILabel *accountabilityLabel;
    IBOutlet UILabel *breakNameLabel;
    IBOutlet UILabel *rewardBreakLabel;
    IBOutlet UILabel *watchBreakLabel;
    IBOutlet UILabel *horrbBreakLabel;
    
    IBOutlet UILabel *whereQuestionLabel;
    IBOutlet UILabel *cueQuestionLabel;
    IBOutlet UILabel *routineQuestionLabel;
    IBOutlet UILabel *seenQuestionLabel;
    IBOutlet UILabel *rewardingQuestionLabel;
    IBOutlet UILabel *accountabilityQuestionLabel;
    IBOutlet UILabel *rewardBreakQuestionLabel;
    IBOutlet UILabel *watchBreakQuestionLabel;
    IBOutlet UILabel *horrbBreakQuestionLabel;
    
    
    
    NSMutableDictionary *reminderDictionary;
    NSMutableDictionary *taskFrequencyDictionary;
    NSArray *frequencyArray;
    NSMutableArray *reminderTimeArray;
    NSMutableDictionary *habitDetailsDict;
    NSMutableDictionary *habitDict;
    NSMutableDictionary *breakHabitDict;
    NSMutableDictionary *habitDefaultReminderSet;
    BOOL isReminderDict;
    BOOL isTaskDict;
    int habitStatus;
    NSString *reminderIdentifier;
    IBOutlet UIView *saveButtonView;
    IBOutlet UIView *detailsButtonView;
    BOOL isEdited;
    
    BOOL reminderSwitchStatus;
    BOOL isHiddenStatus;
    
}

@end

@implementation HabitHackerDetailNewViewController

@synthesize habitDictFromStat,habitId,habitDetailDelegate,isEditMode;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
        [Utility stopFlashingbutton:saveButton];
        isEdited=false;
        reminderTimeArray = [[NSMutableArray alloc]init];
        reminderDictionary = [[NSMutableDictionary alloc]init];
        taskFrequencyDictionary = [[NSMutableDictionary alloc]init];
        
        habitDetailsDict=[[NSMutableDictionary alloc]init];
        habitDict = [[NSMutableDictionary alloc]init];
        breakHabitDict = [[NSMutableDictionary alloc]init];
        habitDefaultReminderSet = [[NSMutableDictionary alloc]init];
        
        frequencyArray = [@[@"Daily",@"Twice Daily",@"Weekly",@"Fortnightly",@"Monthly",@"Yearly"] mutableCopy];
        
        saveButton.layer.cornerRadius=15;
        saveButton.layer.borderColor=[UIColor whiteColor].CGColor;
        detailsButton.layer.cornerRadius=15;
        detailsButton.layer.borderColor=[UIColor whiteColor].CGColor;
        statsButton.layer.cornerRadius=15;
        statsButton.layer.borderColor=[UIColor whiteColor].CGColor;
        
        [detailsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        detailsButton.layer.backgroundColor = squadMainColor.CGColor;
        detailsButton.layer.masksToBounds = YES;
        
        [statsButton setTitleColor:squadMainColor forState:UIControlStateNormal];
        statsButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
        statsButton.layer.masksToBounds = YES;
        statsButton.layer.borderColor = squadMainColor.CGColor;
        statsButton.layer.borderWidth = 1;
        
        
        toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        toolBar.barStyle = UIBarStyleBlackOpaque;
        toolBar.translucent = YES;
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
        [toolBar setItems:[NSArray arrayWithObject:btnDone]];
        [self registerForKeyboardNotifications];
    
    
    //edit mode off
    isEditMode = NO;
  
    saveButton.hidden=true;
    detailsButton.hidden=false;
    statsButton.hidden=false;
    editButton.selected=false;
    isReminderDict=false;
    isTaskDict=false;
    
    for (UITextView *text in textView) {
        text.editable=NO;
    }
    for (UIButton *btn in buttons) {
        btn.userInteractionEnabled=false;
    }
    for (UIButton *btn in statusButtons) {
        btn.userInteractionEnabled=NO;
    }
    reminderSwitch.userInteractionEnabled=NO;
    reOccuringButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if (_isFromHabitList) {
          isEditMode = YES;
          [self editButtonPressed:nil];
      }

    if ([Utility isEmptyCheck:habitDictFromStat]) {
        [self webcellCall_GetUserHabitList];
    }else{
        habitDetailsDict=[habitDictFromStat mutableCopy];
        habitDefaultReminderSet=[[habitDetailsDict objectForKey:@"NewAction"]mutableCopy];
        breakHabitDict=[[habitDetailsDict objectForKey:@"SwapAction"]mutableCopy];
        [self setData];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [reminderTimeArray addObject:@"12 am"];
    for (int i = 1; i < 12; i++) {
        [reminderTimeArray addObject:[NSString stringWithFormat:@"%d am",i]];
    }
    [reminderTimeArray addObject:@"12 pm"];
    for (int i = 1; i < 12; i++) {
        [reminderTimeArray addObject:[NSString stringWithFormat:@"%d pm",i]];
    }
    if (_isFromNotification) {
        reminderSwitch.on = true;
        [self reminderPressed:reminderSwitch];
    }
    
    
}
#pragma mark -End



#pragma mark - Private Method

-(void)setFrequencyButtonTitle:(NSDictionary *)reminderDict{
    if ([[reminderDict objectForKey:@"FrequencyId"]intValue]==1) {
        [reOccuringButton setTitle:[frequencyArray objectAtIndex:[[reminderDict objectForKey:@"FrequencyId"]intValue]-1] forState:UIControlStateNormal];
        andLabel.hidden=true;
        whenButton2.hidden=true;
    }
//    else if ([[reminderDict objectForKey:@"FrequencyId"]intValue]==2){
//        [reOccuringButton setTitle:[frequencyArray objectAtIndex:[[reminderDict objectForKey:@"FrequencyId"]intValue]-1] forState:UIControlStateNormal];
//        andLabel.hidden=false;
//        whenButton2.hidden=false;
//    }
    else if ([[reminderDict objectForKey:@"FrequencyId"]intValue]==3 || [[reminderDict objectForKey:@"FrequencyId"]intValue]==4){
        NSString *frequencyStr=[frequencyArray objectAtIndex:[[reminderDict objectForKey:@"FrequencyId"]intValue] -1 ];
        NSString *selectedDayStr=[Utility selectedDayStringForReminder:reminderDict];
        NSString *titleStr=[frequencyStr stringByAppendingFormat:@" - ( %@ )",selectedDayStr];
        [reOccuringButton setTitle:titleStr forState:UIControlStateNormal];
        andLabel.hidden=true;
        whenButton2.hidden=true;
    }else if ([[reminderDict objectForKey:@"FrequencyId"]intValue]==5){
        NSString *frequencyStr=[frequencyArray objectAtIndex:[[reminderDict objectForKey:@"FrequencyId"]intValue] -1];
        NSString *monthStr=[@"" stringByAppendingFormat:@"%d Day of month",[[reminderDict objectForKey:@"MonthReminder"]intValue]];
        NSString *titleStr=[frequencyStr stringByAppendingFormat:@" - ( %@ )",monthStr];
        [reOccuringButton setTitle:titleStr forState:UIControlStateNormal];
        andLabel.hidden=true;
        whenButton2.hidden=true;
    }
}


-(void)setData{
    NSDictionary *newActionDict=[habitDetailsDict objectForKey:@"NewAction"];
    
    [reminderDictionary setObject:[newActionDict objectForKey:@"FrequencyId"] forKey:@"FrequencyId"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"Sunday"] forKey:@"Sunday"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"Monday"] forKey:@"Monday"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"Tuesday"] forKey:@"Tuesday"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"Wednesday"] forKey:@"Wednesday"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"Thursday"] forKey:@"Thursday"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"Friday"] forKey:@"Friday"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"Saturday"] forKey:@"Saturday"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"January"] forKey:@"January"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"February"] forKey:@"February"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"March"] forKey:@"March"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"April"] forKey:@"April"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"May"] forKey:@"May"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"June"] forKey:@"June"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"July"] forKey:@"July"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"August"] forKey:@"August"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"September"] forKey:@"September"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"October"] forKey:@"October"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"November"] forKey:@"November"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"December"] forKey:@"December"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"MonthReminder"] forKey:@"MonthReminder"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"ReminderAt1"] forKey:@"ReminderAt1"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"ReminderAt2"] forKey:@"ReminderAt2"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"Email"] forKey:@"Email"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"PushNotification"] forKey:@"PushNotification"];
    [reminderDictionary setObject:[newActionDict objectForKey:@"ReminderOption"] forKey:@"ReminderOption"];
    
    isReminderDict=false;
    
    
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"TaskFrequencyTypeId"] forKey:@"FrequencyId"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsSundayTask"] forKey:@"Sunday"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsMondayTask"] forKey:@"Monday"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsTuesdayTask"] forKey:@"Tuesday"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsWednesdayTask"] forKey:@"Wednesday"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsThursdayTask"] forKey:@"Thursday"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsFridayTask"] forKey:@"Friday"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsSaturdayTask"] forKey:@"Saturday"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsJanuaryTask"] forKey:@"January"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsFebruaryTask"] forKey:@"February"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsMarchTask"] forKey:@"March"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsAprilTask"] forKey:@"April"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsMayTask"] forKey:@"May"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsJuneTask"] forKey:@"June"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsJulyTask"] forKey:@"July"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsAugustTask"] forKey:@"August"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsSeptemberTask"] forKey:@"September"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsOctoberTask"] forKey:@"October"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsNovemberTask"] forKey:@"November"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"IsDecemberTask"] forKey:@"December"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"TaskMonthReminder"] forKey:@"MonthReminder"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"TaskReminderAt1"] forKey:@"ReminderAt1"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"TaskReminderAt2"] forKey:@"ReminderAt2"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"Email"] forKey:@"Email"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"PushNotification"] forKey:@"PushNotification"];
    [taskFrequencyDictionary setObject:[newActionDict objectForKey:@"ReminderOption"] forKey:@"ReminderOption"];
    
    isTaskDict=false;
    
    
    

    
    //###################
    
    
    if (![Utility isEmptyCheck:[habitDetailsDict objectForKey:@"HabitName"]]) {
//        habitNameTextView.text=[[habitDetailsDict objectForKey:@"HabitName"] uppercaseString];
        habitNameLabel.text=[habitDetailsDict objectForKey:@"HabitName"];
    }
    
    
    
    if (![Utility isEmptyCheck:taskFrequencyDictionary]) {
        [self setFrequencyButtonTitle:taskFrequencyDictionary];
    }
    
//    if (![Utility isEmptyCheck:[newActionDict objectForKey:@"TaskFrequencyTypeId"]]) {
//        [reOccuringButton setTitle:[frequencyArray objectAtIndex:[[newActionDict objectForKey:@"TaskFrequencyTypeId"]intValue]-1] forState:UIControlStateNormal];
//    }
//
//    if ([[frequencyArray objectAtIndex:[[newActionDict objectForKey:@"TaskFrequencyTypeId"]intValue]-1] isEqualToString:@"Twice Daily"]) {
//        andLabel.hidden=false;
//        whenButton2.hidden=false;
//    }else{
//        andLabel.hidden=true;
//        whenButton2.hidden=true;
//    }
    
    if (![Utility isEmptyCheck:[newActionDict objectForKey:@"TaskReminderAt1"]]) {
        int interval=[[newActionDict objectForKey:@"TaskReminderAt1"] intValue];
//        NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
        whenButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",interval];
        if (interval==0) {
            [whenButton setTitle:@"NA" forState:UIControlStateNormal];
        }else{
            NSDate * date = [NSDate date];
            int totalSeconds=[Utility secondsFromDate:date includeSeconds:YES];
            date=[date dateBySubtractingSeconds:totalSeconds];
            date=[date dateByAddingSeconds:interval];
            NSDateFormatter *df = [NSDateFormatter new];
    //        [df setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
    //        whenButton.accessibilityHint = [df stringFromDate:date];
            [df setDateFormat:@"hh:mm a"];//hh:mm a
            [whenButton setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
        }
    }
    
    
    if (![Utility isEmptyCheck:[newActionDict objectForKey:@"TaskReminderAt2"]]) {
        int interval=[[newActionDict objectForKey:@"TaskReminderAt2"] intValue];
//        NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
        whenButton2.accessibilityHint = [@"" stringByAppendingFormat:@"%d",interval];
        if (interval==0) {
            [whenButton2 setTitle:@"NA" forState:UIControlStateNormal];
        }else{
            NSDate * date = [NSDate date];
            int totalSeconds=[Utility secondsFromDate:date includeSeconds:YES];
            date=[date dateBySubtractingSeconds:totalSeconds];
            date=[date dateByAddingSeconds:interval];
            NSDateFormatter *df = [NSDateFormatter new];
    //        [df setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
    //        whenButton2.accessibilityHint = [df stringFromDate:date];
            [df setDateFormat:@"hh:mm a"];//hh:mm a
            [whenButton2 setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
        }
    }

    if (![Utility isEmptyCheck:[newActionDict objectForKey:@"Duration"]]) {
        int seconds=[[newActionDict objectForKey:@"Duration"] intValue];
        durationButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",seconds];
        if (seconds==0) {
            [durationButton setTitle:@"NA" forState:UIControlStateNormal];
        }else{
            NSString *durationStr=[Utility durationStringFromSeconds:seconds includeSeconds:NO];
            [durationButton setTitle:durationStr forState:UIControlStateNormal];
        }
    }
    
    if ((![Utility isEmptyCheck:[newActionDict objectForKey:@"PushNotification"]]) || (![Utility isEmptyCheck:[newActionDict objectForKey:@"Email"]])) {
        int pn=[[newActionDict objectForKey:@"PushNotification"]intValue];
        int em=[[newActionDict objectForKey:@"Email"]intValue];
        if (pn==1 || em==1) {
            [reminderSwitch setOn:YES];
        }else{
            [reminderSwitch setOn:NO];
        }
    }else{
        [reminderSwitch setOn:NO];
    }
    //============
//    if (![Utility isEmptyCheck:[newActionDict objectForKey:@"ReminderAt1"]]) {
//        [atButton1 setTitle:[reminderTimeArray objectAtIndex:[[newActionDict objectForKey:@"ReminderAt1"] integerValue]] forState:UIControlStateNormal];
//    }
//    if (![Utility isEmptyCheck:[newActionDict objectForKey:@"ReminderAt2"]]) {
//        [atButton2 setTitle:[reminderTimeArray objectAtIndex:[[newActionDict objectForKey:@"ReminderAt2"] integerValue]] forState:UIControlStateNormal];
//    }
    
    
    if (![Utility isEmptyCheck:[habitDetailsDict objectForKey:@"ActionWhere"]]) {
//        whereTextView.text=[habitDetailsDict objectForKey:@"ActionWhere"];
        whereLabel.text=[habitDetailsDict objectForKey:@"ActionWhere"];
    }

    
    if (![Utility isEmptyCheck:[habitDetailsDict objectForKey:@"Cue"]]) {
//        cueTextView.text=[habitDetailsDict objectForKey:@"Cue"];
            cueLabel.text=[habitDetailsDict objectForKey:@"Cue"];
    }
    
    if (![Utility isEmptyCheck:[habitDetailsDict objectForKey:@"Routine"]]) {
//        routineTextView.text=[newActionDict objectForKey:@"Name"];
        routineLabel.text=[habitDetailsDict objectForKey:@"Routine"];

    }
    
    if (![Utility isEmptyCheck:[habitDetailsDict objectForKey:@"MoreSeen"]]) {
//        seenTextView.text=[habitDetailsDict objectForKey:@"MoreSeen"];
        seenLabel.text=[habitDetailsDict objectForKey:@"MoreSeen"];

    }
    if (![Utility isEmptyCheck:[habitDetailsDict objectForKey:@"Reward"]]) {
//        rewardingTextView.text=[habitDetailsDict objectForKey:@"Reward"];
        rewardingLabel.text=[habitDetailsDict objectForKey:@"Reward"];

    }
    if (![Utility isEmptyCheck:[habitDetailsDict objectForKey:@"AccountabilityNotes"]]) {
//        accountabilityTextView.text=[habitDetailsDict objectForKey:@"AccountabilityNotes"];
        accountabilityLabel.text=[habitDetailsDict objectForKey:@"AccountabilityNotes"];

    }
    
    
    if (![Utility isEmptyCheck:[habitDetailsDict objectForKey:@"SwapAction"]]) {
        NSDictionary *swapDict = [habitDetailsDict objectForKey:@"SwapAction"];
        if (![Utility isEmptyCheck:[swapDict objectForKey:@"Name"]]) {
//            breakNameTextView.text =[[swapDict objectForKey:@"Name"] uppercaseString];
            breakNameLabel.text =[swapDict objectForKey:@"Name"];

        }
    }
    
    if (![Utility isEmptyCheck:[habitDetailsDict objectForKey:@"OldActionBreak"]]) {
//        rewardBreakTextView.text=[habitDetailsDict objectForKey:@"OldActionBreak"];
        rewardBreakLabel.text=[habitDetailsDict objectForKey:@"OldActionBreak"];
    }
    
    
    if (![Utility isEmptyCheck:[habitDetailsDict objectForKey:@"NoteHidden"]]) {
//        watchBreakTextView.text=[habitDetailsDict objectForKey:@"NoteHidden"];
        watchBreakLabel.text=[habitDetailsDict objectForKey:@"NoteHidden"];
    }
    
    if (![Utility isEmptyCheck:[habitDetailsDict objectForKey:@"NoteHorrible"]]) {
//        horrbBreakTextView.text=[habitDetailsDict objectForKey:@"NoteHorrible"];
        horrbBreakLabel.text=[habitDetailsDict objectForKey:@"NoteHorrible"];
    }
    
    
    int status=[[habitDetailsDict objectForKey:@"Status"]intValue];
    for (UIButton *btn in statusButtons) {
        if (btn.tag==status)
        {
            btn.selected=true;
            habitStatus=(int)btn.tag;
        } else{
            btn.selected = false;
        }
    }
}



-(void) createHabitDetails{
    
    [habitDict setObject:[habitDetailsDict objectForKey:@"HabitId"] forKey:@"HabitId"];
    
//    [habitDict setObject:habitNameTextView.text forKey:@"HabitName"];
    [habitDict setObject:habitNameLabel.text forKey:@"HabitName"];
    
    [habitDict setObject:[habitDetailsDict objectForKey:@"ActionId"] forKey:@"ActionId"];
    
//    [habitDict setObject:whereTextView.text forKey:@"ActionWhere"];
    [habitDict setObject:whereLabel.text forKey:@"ActionWhere"];
    
//    [habitDict setObject:cueTextView.text forKey:@"Cue"];
    [habitDict setObject:cueLabel.text forKey:@"Cue"];
    
    [habitDict setObject:[habitDetailsDict objectForKey:@"Craving"] forKey:@"Craving"];
    
//    [habitDict setObject:rewardBreakTextView.text forKey:@"OldActionBreak"];
    [habitDict setObject:rewardBreakLabel.text forKey:@"OldActionBreak"];
    
//    [habitDict setObject:seenTextView.text forKey:@"MoreSeen"];
    [habitDict setObject:seenLabel.text forKey:@"MoreSeen"];

    [habitDict setObject:routineLabel.text forKey:@"Routine"];
    [habitDict setObject:[habitDetailsDict objectForKey:@"Status"] forKey:@"Status"];
    
//    [habitDict setObject:rewardingTextView.text forKey:@"Reward"];
    [habitDict setObject:rewardingLabel.text forKey:@"Reward"];

    
    [habitDict setObject:[habitDetailsDict objectForKey:@"MakeMoreRewarding"] forKey:@"MakeMoreRewarding"];
    

//    [habitDict setObject:watchBreakTextView.text forKey:@"NoteHidden"];
    [habitDict setObject:watchBreakLabel.text forKey:@"NoteHidden"];

    [habitDict setObject:[habitDetailsDict objectForKey:@"NoteHarder"] forKey:@"NoteHarder"];
    
//    [habitDict setObject:horrbBreakTextView.text forKey:@"NoteHorrible"];
    [habitDict setObject:horrbBreakLabel.text forKey:@"NoteHorrible"];

    
    [habitDict setObject:[habitDetailsDict objectForKey:@"DateCreated"] forKey:@"DateCreated"];
    [habitDict setObject:[habitDetailsDict objectForKey:@"DateUpdated"] forKey:@"DateUpdated"];
    
//    [habitDict setObject:accountabilityTextView.text forKey:@"AccountabilityNotes"];
    [habitDict setObject:accountabilityLabel.text forKey:@"AccountabilityNotes"];

    
    [habitDict setObject:[habitDetailsDict objectForKey:@"ManualOrder"] forKey:@"ManualOrder"];
    [habitDict setObject:[habitDetailsDict objectForKey:@"UserId"] forKey:@"UserId"];

    
//    if (![Utility isEmptyCheck:whenButton.titleLabel.text]) {
//                [habitDefaultReminderSet setObject:whenButton.titleLabel.text forKey:@"DueDate"];
//                [breakHabitDict setObject:whenButton.titleLabel.text forKey:@"DueDate"];
//           }else{
//                [habitDefaultReminderSet setObject:@"" forKey:@"DueDate"];
//                [breakHabitDict setObject:@"" forKey:@"DueDate"];
//           }
//           if (![Utility isEmptyCheck:durationButton.titleLabel.text]) {
//                [habitDefaultReminderSet setObject:durationButton.titleLabel.text forKey:@"reminder_till_date"];
//                [breakHabitDict setObject:durationButton.titleLabel.text forKey:@"reminder_till_date"];
//
//           }else{
//                [habitDefaultReminderSet setObject:@"" forKey:@"reminder_till_date"];
//                [breakHabitDict setObject:@"" forKey:@"reminder_till_date"];
//
//           }
    
    
    if (![Utility isEmptyCheck:whenButton.accessibilityHint]) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//         [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//         NSDate *date = [dateFormatter dateFromString:whenButton.accessibilityHint];
//         NSTimeInterval interval  = [date timeIntervalSince1970] ;
//        [habitDefaultReminderSet setObject:[NSNumber numberWithDouble:interval] forKey:@"TaskReminderAt1"];
         [habitDefaultReminderSet setObject:whenButton.accessibilityHint forKey:@"TaskReminderAt1"];
    }else{
         [habitDefaultReminderSet setObject:@"" forKey:@"TaskReminderAt1"];
    }
    
    
    if (![Utility isEmptyCheck:whenButton2.accessibilityHint]) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//        NSDate *date = [dateFormatter dateFromString:whenButton2.accessibilityHint];
//        NSTimeInterval interval  = [date timeIntervalSince1970] ;
//        [habitDefaultReminderSet setObject:[NSNumber numberWithDouble:interval] forKey:@"TaskReminderAt2"];
        [habitDefaultReminderSet setObject:whenButton2.accessibilityHint forKey:@"TaskReminderAt2"];
        
    }else{
        [habitDefaultReminderSet setObject:@"" forKey:@"TaskReminderAt2"];
     }
    
    if (![Utility isEmptyCheck:durationButton.accessibilityHint]) {
         [habitDefaultReminderSet setObject:durationButton.accessibilityHint forKey:@"Duration"];
    }else{
         [habitDefaultReminderSet setObject:@"" forKey:@"Duration"];
    }
    
    
    
    
    
//    [habitDefaultReminderSet setObject:routineTextView.text forKey:@"Name"];
    [habitDefaultReminderSet setObject:habitNameLabel.text forKey:@"Name"];

//    [breakHabitDict setObject:breakNameTextView.text forKey:@"Name"];
    [breakHabitDict setObject:breakNameLabel.text forKey:@"Name"];

    BOOL switchison=reminderSwitch.isOn;
    [habitDefaultReminderSet setObject:[NSNumber numberWithBool:switchison] forKey:@"HasReminder"];
    [breakHabitDict setObject:[NSNumber numberWithBool:switchison] forKey:@"HasReminder"];

    
    if (isReminderDict) {
        //New Action
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"April"] forKey:@"April"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"August"] forKey:@"August"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"December"] forKey:@"December"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"Email"] forKey:@"Email"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"February"] forKey:@"February"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"FrequencyId"] forKey:@"FrequencyId"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"Friday"] forKey:@"Friday"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"January"] forKey:@"January"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"July"] forKey:@"July"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"June"] forKey:@"June"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"March"] forKey:@"March"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"May"] forKey:@"May"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"Monday"] forKey:@"Monday"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"MonthReminder"] forKey:@"MonthReminder"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"November"] forKey:@"November"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"October"] forKey:@"October"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"PushNotification"] forKey:@"PushNotification"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"ReminderAt1"] forKey:@"ReminderAt1"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"ReminderAt2"] forKey:@"ReminderAt2"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"ReminderOption"] forKey:@"ReminderOption"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"Saturday"] forKey:@"Saturday"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"September"] forKey:@"September"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"Sunday"] forKey:@"Sunday"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"Thursday"] forKey:@"Thursday"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"Tuesday"] forKey:@"Tuesday"];
        [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"Wednesday"] forKey:@"Wednesday"];
        
        
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"April"] forKey:@"April"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"August"] forKey:@"August"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"December"] forKey:@"December"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"Email"] forKey:@"Email"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"February"] forKey:@"February"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"FrequencyId"] forKey:@"FrequencyId"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"Friday"] forKey:@"Friday"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"January"] forKey:@"January"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"July"] forKey:@"July"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"June"] forKey:@"June"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"March"] forKey:@"March"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"May"] forKey:@"May"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"Monday"] forKey:@"Monday"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"MonthReminder"] forKey:@"MonthReminder"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"November"] forKey:@"November"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"October"] forKey:@"October"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"PushNotification"] forKey:@"PushNotification"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"ReminderAt1"] forKey:@"ReminderAt1"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"ReminderAt2"] forKey:@"ReminderAt2"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"ReminderOption"] forKey:@"ReminderOption"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"Saturday"] forKey:@"Saturday"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"September"] forKey:@"September"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"Sunday"] forKey:@"Sunday"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"Thursday"] forKey:@"Thursday"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"Tuesday"] forKey:@"Tuesday"];
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"Wednesday"] forKey:@"Wednesday"];
    }
    
    if (isTaskDict) {
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"FrequencyId"] forKey:@"TaskFrequencyTypeId"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"Sunday"] forKey:@"IsSundayTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"Monday"] forKey:@"IsMondayTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"Tuesday"] forKey:@"IsTuesdayTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"Wednesday"] forKey:@"IsWednesdayTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"Thursday"] forKey:@"IsThursdayTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"Friday"] forKey:@"IsFridayTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"Saturday"] forKey:@"IsSaturdayTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"January"] forKey:@"IsJanuaryTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"February"] forKey:@"IsFebruaryTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"March"] forKey:@"IsMarchTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"April"] forKey:@"IsAprilTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"May"] forKey:@"IsMayTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"June"] forKey:@"IsJuneTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"July"] forKey:@"IsJulyTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"August"] forKey:@"IsAugustTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"September"] forKey:@"IsSeptemberTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"October"] forKey:@"IsOctoberTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"November"] forKey:@"IsNovemberTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"December"] forKey:@"IsDecemberTask"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"MonthReminder"] forKey:@"TaskMonthReminder"];
        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"FrequencyId"] forKey:@"FrequencyId"];
//        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"ReminderAt1"] forKey:@"TaskReminderAt1"];
//        [habitDefaultReminderSet setObject:[taskFrequencyDictionary objectForKey:@"ReminderAt2"] forKey:@"TaskReminderAt2"];
        
        
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"FrequencyId"] forKey:@"TaskFrequencyTypeId"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"Sunday"] forKey:@"IsSundayTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"Monday"] forKey:@"IsMondayTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"Tuesday"] forKey:@"IsTuesdayTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"Wednesday"] forKey:@"IsWednesdayTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"Thursday"] forKey:@"IsThursdayTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"Friday"] forKey:@"IsFridayTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"Saturday"] forKey:@"IsSaturdayTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"January"] forKey:@"IsJanuaryTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"February"] forKey:@"IsFebruaryTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"March"] forKey:@"IsMarchTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"April"] forKey:@"IsAprilTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"May"] forKey:@"IsMayTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"June"] forKey:@"IsJuneTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"July"] forKey:@"IsJulyTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"August"] forKey:@"IsAugustTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"September"] forKey:@"IsSeptemberTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"October"] forKey:@"IsOctoberTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"November"] forKey:@"IsNovemberTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"December"] forKey:@"IsDecemberTask"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"MonthReminder"] forKey:@"TaskMonthReminder"];
        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"FrequencyId"] forKey:@"FrequencyId"];

//        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"ReminderAt1"] forKey:@"TaskReminderAt1"];
//        [breakHabitDict setObject:[taskFrequencyDictionary objectForKey:@"ReminderAt2"] forKey:@"TaskReminderAt2"];
    }
        
    
}



#pragma mark End




#pragma mark - Api call

-(void)webcellCall_GetUserHabitList{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
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
        [mainDict setObject:habitId forKey:@"HabitId"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];

        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserHabitSwap" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                             if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"HabitSwap"]]) {
                                                                                 self->habitDetailsDict=[[responseDictionary objectForKey:@"HabitSwap"] mutableCopy];
                                                                                 self->habitDefaultReminderSet=[[self->habitDetailsDict objectForKey:@"NewAction"]mutableCopy];
                                                                                 self->breakHabitDict=[[self->habitDetailsDict objectForKey:@"SwapAction"]mutableCopy];
                                                                                 
                                                                                 [self setData];
                                                                             }else{
                                                                             }
//                                                                             NSArray *arr = @[@"TETS",@"TETSq"];
//                                                                             self->habitListArray = [arr mutableCopy];
//                                                                             [self->habitTable reloadData];
                                                                         }else{
                                                                             [Utility msg:responseDictionary[@"ErrorMessage"] title:@"Oops! " controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                             });
                                                         }];
        [dataTask resume];

    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}



-(void)addUpdateHabitSwap_WebServiceCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
          
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            if (!self->isHiddenStatus) {
                self->contentView = [Utility activityIndicatorView:self];
            }
           
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
        
//        if (![Utility isEmptyCheck:[habitDict objectForKey:@"HabitName"]] && ![Utility isEmptyCheck:[[habitDict objectForKey:@"NewAction"]objectForKey:@"TaskFrequencyTypeId"]] && ![Utility isEmptyCheck:[breakHabitDict objectForKey:@"Name"]]) {
//            [mainDict setObject:AccessKey forKey:@"Key"];
//            [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
//            [mainDict setObject:habitDict forKey:@"Habit"];
//        }else{
//            [Utility msg:@"Please write the habit do you want to create and break" title:@"Alert" controller:self haveToPop:NO];
//            return;
//        }
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
                                                                             self->isEdited=false;
                                                                             self->habitDetailsDict=[responseDictionary objectForKey:@"HabitReturn"];
                                                                            self->habitDefaultReminderSet=[[self->habitDetailsDict objectForKey:@"NewAction"]mutableCopy];
                                                                             self->breakHabitDict=[[self->habitDetailsDict objectForKey:@"SwapAction"]mutableCopy];
                                                                             [self setData];
                                                                             UIButton *btn;
                                                                             [self editButtonPressed:btn];
                                                                             
                                                                             [self->habitDetailDelegate reloadUpdatedData:self->habitDetailsDict];
                                                                             [[NSNotificationCenter defaultCenter]postNotificationName:@"IsHackerListReload" object:self userInfo:nil];
                                                                             [self->habitDetailDelegate setHAbitDetailsDictionary:self->habitDetailsDict];
                                                                             [self.navigationController popViewControllerAnimated:NO];
                                                                             
//                                                                             [self statsButtonPressed:btn];
                                                                            
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
        [mainDict setObject:habitId forKey:@"HabitId"];
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
                                                                             [[NSNotificationCenter defaultCenter]postNotificationName:@"IsHackerListDelete" object:self->habitId userInfo:nil];
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


-(void)updateHabitStatus_WebcellCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
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
        [mainDict setObject:habitId forKey:@"HabitId"];
        [mainDict setObject:[NSString stringWithFormat:@"%d",habitStatus] forKey:@"HabitStatus"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];

        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateHabitStatus" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         
                                                                         if (self->habitStatus==4) {
                                                                             self->habitStatus=1;
                                                                         }
                                                                         
                                                                         for (UIButton *btn in self->statusButtons) {
                                                                             if (btn.tag==self->habitStatus)
                                                                             {
                                                                                 btn.selected=true;
                                                                                 self->habitStatus=(int)btn.tag;
                                                                                 
                                                                             } else{
                                                                                 btn.selected = false;
                                                                             }
                                                                         }
                                                                         if (self->habitStatus == 3) {
                                                                             [self->reminderSwitch setOn:NO animated:NO];
                                                                               self->isReminderDict=NO;
                                                                               [self->habitDefaultReminderSet setObject:[NSNumber numberWithBool:NO] forKey:@"Email"];
                                                                               [self->habitDefaultReminderSet setObject:[NSNumber numberWithBool:NO] forKey:@"PushNotification"];
                                                                               [self->breakHabitDict setObject:[NSNumber numberWithBool:NO] forKey:@"Email"];
                                                                               [self->breakHabitDict setObject:[NSNumber numberWithBool:NO] forKey:@"PushNotification"];
                                                                             self->isHiddenStatus = true;
                                                                             [self saveButtonPressed:nil];
                                                                            
                                                                         }
                                                                         [self->habitDetailsDict setObject:[NSNumber numberWithInt:self->habitStatus] forKey:@"Status"];
                                                                         [self->habitDetailDelegate reloadUpdatedData:self->habitDetailsDict];
                                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"IsHackerListReload" object:self userInfo:nil];
                                                                         }else{
                                                                             [Utility msg:responseDictionary[@"ErrorMessage"] title:@"Oops! " controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                             });
                                                         }];
        [dataTask resume];

    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}



#pragma mark -End




#pragma mark - IBAction

-(IBAction)backButtonPressed:(id)sender{
    if (isEdited) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Save changes"
                                      message:@"Your changes will be lost if you don’t save them."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* save = [UIAlertAction
                                  actionWithTitle:@"Save"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                    UIButton *btn;
                                    [self saveButtonPressed:btn];
                                  }];
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Don't Save"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                    [self->habitDetailDelegate setHAbitDetailsDictionary:self->habitDetailsDict];
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                     
                                 }];
        [alert addAction:save];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self->habitDetailDelegate setHAbitDetailsDictionary:self->habitDetailsDict];
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}

-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)editButtonPressed:(id)sender {
    isEditMode=!isEditMode;
    
    saveButton.hidden=!saveButton.hidden;
    detailsButton.hidden=!detailsButton.hidden;
    statsButton.hidden=!statsButton.hidden;
    
    editButton.selected=!editButton.selected;
    for (UITextView *text in textView) {
        text.editable=!text.editable;
    }
    for (UIButton *btn in buttons) {
        btn.userInteractionEnabled=!btn.userInteractionEnabled;
    }
    for (UIButton *btn in statusButtons) {
        btn.userInteractionEnabled=!btn.userInteractionEnabled;
    }
    reminderSwitch.userInteractionEnabled=!reminderSwitch.userInteractionEnabled;
}

-(IBAction)frequencyButtonPrssed:(id)sender{
    [Utility startFlashingbutton:saveButton];
      reminderIdentifier=@"Task";
      SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
        controller.isFromHacker = true;
        NSMutableDictionary *newDict = [NSMutableDictionary new];
        newDict = [taskFrequencyDictionary mutableCopy];
        if([newDict objectForKey:@"FrequencyId"] != nil){
            int frequencyId = [[newDict objectForKey:@"FrequencyId"]intValue];
                if (frequencyId>1) {
                    int frequencyId = [[newDict objectForKey:@"FrequencyId"]intValue];
                    [newDict setObject:[NSNumber numberWithInt:frequencyId] forKey:@"FrequencyId"];
                   }
            controller.defaultSettingsDict = newDict;
        }
        controller.reminderDelegate = self;
        controller.view.backgroundColor = [UIColor clearColor];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
}

-(IBAction)datePressed:(UIButton*)sender{
    [Utility startFlashingbutton:saveButton];
    if (sender == whenButton) {
            whenButton.selected = true;
            durationButton.selected = false;
            whenButton2.selected = false;

        }else if(sender == whenButton2){
            whenButton.selected = false;
            durationButton.selected = false;
            whenButton2.selected = true;
        }else{
            whenButton.selected = false;
            whenButton2.selected = false;
            durationButton.selected = true;
        }
        DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
                    controller.isfromhabit = YES;
                    controller.modalPresentationStyle = UIModalPresentationCustom;
    //               controller.maxDate = [NSDate date];
//                    NSTimeInterval sixmonth = 5*60*60;
//                    controller.minDate = [[NSDate date]
//                                             dateByAddingTimeInterval:sixmonth];
                   controller.selectedDate = [NSDate date];
                    
                    if (sender == whenButton) {
                        controller.datePickerMode = UIDatePickerModeTime;
                    }else if(sender == whenButton2){
                        controller.datePickerMode = UIDatePickerModeTime;
                    }else{
                        controller.datePickerMode = UIDatePickerModeCountDownTimer;
                    }
                   controller.delegate = self;
                   [self presentViewController:controller animated:YES completion:nil];
}


-(IBAction)reminderPressed:(UISwitch*)sender{
    [Utility startFlashingbutton:saveButton];
    if (sender.isOn) {
        //sender.on=false;
//        [sender setOn:NO animated:NO];
        
        NSDictionary *habitReminderDict =[habitDetailsDict objectForKey:@"NewAction"];
        if ((![Utility isEmptyCheck:[habitReminderDict objectForKey:@"PushNotification"]] && [[habitReminderDict objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[habitReminderDict objectForKey:@"Email"]] && [[habitReminderDict objectForKey:@"Email"] boolValue])) {
               reminderSwitchStatus = true;
            }else{
               reminderSwitchStatus = false;
          }
        reminderIdentifier=@"Reminder";
        SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
         [reminderDictionary setObject:[NSNumber numberWithBool:true] forKey:@"PushNotification"];
        
        if ([reminderDictionary objectForKey:@"FrequencyId"] != nil)
            controller.defaultSettingsDict = reminderDictionary;
        controller.reminderDelegate = self;
        controller.view.backgroundColor = [UIColor clearColor];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
//        [sender setOn:YES animated:NO];
        reminderSwitchStatus=YES;
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Edit Reminder"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                     self->reminderIdentifier=@"Reminder";
                                       SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
                                        if ([self->reminderDictionary objectForKey:@"FrequencyId"] != nil)
                                            controller.defaultSettingsDict = self->reminderDictionary;
                                        controller.reminderDelegate = self;
                                        controller.view.backgroundColor = [UIColor clearColor];
                                        controller.modalPresentationStyle = UIModalPresentationCustom;
                                        [self presentViewController:controller animated:YES completion:nil];
                                   }];
        UIAlertAction *turnOff = [UIAlertAction
                                  actionWithTitle:@"Turn Off Reminder"
                                  style:UIAlertActionStyleCancel
                                  handler:^(UIAlertAction *action)
                                  {
                                        [sender setOn:NO animated:NO];
                                        self->isReminderDict=NO;
                                        [self->habitDefaultReminderSet setObject:[NSNumber numberWithBool:NO] forKey:@"Email"];
                                        [self->habitDefaultReminderSet setObject:[NSNumber numberWithBool:NO] forKey:@"PushNotification"];
                                        [self->breakHabitDict setObject:[NSNumber numberWithBool:NO] forKey:@"Email"];
                                        [self->breakHabitDict setObject:[NSNumber numberWithBool:NO] forKey:@"PushNotification"];
            
                                  }];
        
//        UIAlertAction *cancelAction = [UIAlertAction
//                                       actionWithTitle:@"Cancel"
//                                       style:UIAlertActionStyleCancel
//                                       handler:^(UIAlertAction *action)
//                                       {
//
//                                       }];
        [alertController addAction:okAction];
        [alertController addAction:turnOff];
//        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    [self.view endEditing:true];
    [self createHabitDetails];
    [self addUpdateHabitSwap_WebServiceCall];
    
}

- (IBAction)deleteButtonPressed:(UIButton *)sender {
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
    UIAlertAction* restart = [UIAlertAction
                              actionWithTitle:@"RESTART FROM TODAY"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                self->habitStatus=4;
                                [self updateHabitStatus_WebcellCall];
                              }];
    
    UIAlertAction* pause = [UIAlertAction
                            actionWithTitle:@"PAUSE/HIDE"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                self->habitStatus=3;
                                [self updateHabitStatus_WebcellCall];
                            }];
    
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"No"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 
                             }];
    
    [alert addAction:delete];
    [alert addAction:restart];
    [alert addAction:pause];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)statusButtonsPressed:(UIButton *)sender
{
    if (!sender.isSelected) {
        for (UIButton *btn in statusButtons) {
            if (sender==btn)
            {
//                btn.selected=true;
                habitStatus=(int)sender.tag;
            } else{
//                btn.selected = false;
            }
        }
        [self updateHabitStatus_WebcellCall];
    }
}

- (IBAction)statsButtonPressed:(UIButton *)sender {
    if (isEdited) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Save changes"
                                      message:@"Your changes will be lost if you don’t save them"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* save = [UIAlertAction
                                  actionWithTitle:@"Save"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                    UIButton *btn;
                                    [self saveButtonPressed:btn];
                                  }];
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Don't Save"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                    [self->habitDetailDelegate setHAbitDetailsDictionary:self->habitDetailsDict];
                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                     
                                 }];
        [alert addAction:save];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self->habitDetailDelegate setHAbitDetailsDictionary:self->habitDetailsDict];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)answerLabelPressed:(UIButton *)sender {
    
    NSString *text=@"";
    NSString *Q_text=@"";
    NSString *textViewName;
    if (sender.tag==1) {
        textViewName=@"habitNameLabel";
        text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:habitNameLabel.text]?habitNameLabel.text:@""];
        Q_text=@"Habit Name : ";
    }
    if (sender.tag==2) {
        textViewName=@"whereLabel";
        text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:whereLabel.text]?whereLabel.text:@""];
        Q_text=[@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:whereQuestionLabel.text]?whereQuestionLabel.text:@""];
    }
    if (sender.tag==3) {
        textViewName=@"cueLabel";
        text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:cueLabel.text]?cueLabel.text:@""];
        Q_text=[@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:cueQuestionLabel.text]?cueQuestionLabel.text:@""];
    }
    if (sender.tag==4) {
        textViewName=@"routineLabel";
        text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:routineLabel.text]?routineLabel.text:@""];
        Q_text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:routineQuestionLabel.text]?routineQuestionLabel.text:@""];
    }
    if (sender.tag==5) {
        textViewName=@"seenLabel";
        text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:seenLabel.text]?seenLabel.text:@""];
        Q_text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:seenQuestionLabel.text]?seenQuestionLabel.text:@""];
    }
    if (sender.tag==6) {
        textViewName=@"rewardingLabel";
        text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:rewardingLabel.text]?rewardingLabel.text:@""];
        Q_text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:rewardingQuestionLabel.text]?rewardingQuestionLabel.text:@""];
    }
    if (sender.tag==7) {
        textViewName=@"accountabilityLabel";
        text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:accountabilityLabel.text]?accountabilityLabel.text:@""];
        Q_text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:accountabilityQuestionLabel.text]?accountabilityQuestionLabel.text:@""];
    }
    if (sender.tag==8) {
        textViewName=@"breakNameLabel";
        text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:breakNameLabel.text]?breakNameLabel.text:@""];
        Q_text=@"Break Name : ";
    }
    if (sender.tag==9) {
        textViewName=@"rewardBreakLabel";
        text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:rewardBreakLabel.text]?rewardBreakLabel.text:@""];
        Q_text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:rewardBreakQuestionLabel.text]?rewardBreakQuestionLabel.text:@""];
    }
    if (sender.tag==10) {
        textViewName=@"watchBreakLabel";
        text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:watchBreakLabel.text]?watchBreakLabel.text:@""];
        Q_text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:watchBreakQuestionLabel.text]?watchBreakQuestionLabel.text:@""];
    }
    if (sender.tag==11) {
        textViewName=@"horrbBreakLabel";
        text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:horrbBreakLabel.text]?horrbBreakLabel.text:@""];
        Q_text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:horrbBreakQuestionLabel.text]?horrbBreakQuestionLabel.text:@""];
    }
    
    NotesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
    controller.notesDelegate=self;
    controller.fromStr=@"HabitDetails";
    controller.habitText=text;
    controller.habitQuestionText=Q_text;
    controller.textViewName=textViewName;
    [self.navigationController pushViewController:controller animated:NO];
    
}





#pragma mark end

#pragma mark - Keyboard notification
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
#pragma mark end

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
    
    
    NSString *textViewName;
    if (textView==habitNameTextView) {
        textViewName=@"habitNameTextView";
    }
    if (textView==whereTextView) {
        textViewName=@"whereTextView";
    }
    if (textView==cueTextView) {
        textViewName=@"cueTextView";
    }
    if (textView==routineTextView) {
        textViewName=@"routineTextView";
    }
    if (textView==seenTextView) {
        textViewName=@"seenTextView";
    }
    if (textView==rewardingTextView) {
        textViewName=@"rewardingTextView";
    }
    if (textView==accountabilityTextView) {
        textViewName=@"accountabilityTextView";
    }
    if (textView==breakNameTextView) {
        textViewName=@"breakNameTextView";
    }
    if (textView==rewardBreakTextView) {
        textViewName=@"rewardBreakTextView";
    }
    if (textView==watchBreakTextView) {
        textViewName=@"watchBreakTextView";
    }
    if (textView==horrbBreakTextView) {
        textViewName=@"horrbBreakTextView";
    }
    
    activeTextView = textView;
    activeTextField = nil;
    
    NSString *text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:textView.text]?textView.text:@""];
    
    NotesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
    controller.notesDelegate=self;
    controller.fromStr=@"HabitDetails";
    controller.habitText=text;
    controller.textViewName=textViewName;
    [textView resignFirstResponder];
    [self.navigationController pushViewController:controller animated:NO];
    
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    activeTextView = nil;
    NSLog(@"%@",textView.text);
}
#pragma mark end


#pragma mark -Notes Delegate

- (void) setHabitText:(NSString *) habitText textViewName:(NSString *) textViewName{
    isEdited=true;
    [Utility startFlashingbutton:saveButton];
    
    if ([textViewName isEqualToString:@"habitNameLabel"]) {
        habitNameLabel.text=habitText;
    }
    if ([textViewName isEqualToString:@"whereLabel"]) {
        whereLabel.text=habitText;
    }
    if ([textViewName isEqualToString:@"cueLabel"]) {
        cueLabel.text=habitText;
    }
    if ([textViewName isEqualToString:@"routineLabel"]) {
        routineLabel.text=habitText;
    }
    if ([textViewName isEqualToString:@"seenLabel"]) {
        seenLabel.text=habitText;
    }
    if ([textViewName isEqualToString:@"rewardingLabel"]) {
        rewardingLabel.text=habitText;
    }
    if ([textViewName isEqualToString:@"accountabilityLabel"]) {
        accountabilityLabel.text=habitText;
    }
    if ([textViewName isEqualToString:@"breakNameLabel"]) {
        breakNameLabel.text=habitText;
    }
    if ([textViewName isEqualToString:@"rewardBreakLabel"]) {
        rewardBreakLabel.text=habitText;
    }
    if ([textViewName isEqualToString:@"watchBreakLabel"]) {
        watchBreakLabel.text=habitText;
    }
    if ([textViewName isEqualToString:@"horrbBreakLabel"]) {
        horrbBreakLabel.text=habitText;
    }
    
//    UIButton *btn;
//    [self editButtonPressed:btn];
    
}

#pragma mark- End




#pragma mark - Reminder Delegate

-(void)reminderSettingsValue:(NSMutableDictionary *)reminderDict {
    isEdited=true;
    NSLog(@"rem %@",reminderDict);
    
    if ([reminderIdentifier isEqualToString:@"Task"]) {
        isTaskDict=true;
        
        if (![Utility isEmptyCheck:reminderDict]) {
            int frequencyId = [[reminderDict objectForKey:@"FrequencyId"]intValue];
            if (frequencyId>1) {
                NSMutableDictionary *tempDict = [NSMutableDictionary new];
                tempDict = [reminderDict mutableCopy];
                int frequencyId = [[reminderDict objectForKey:@"FrequencyId"]intValue];
                [tempDict setObject:[NSNumber numberWithInt:frequencyId] forKey:@"FrequencyId"];
                reminderDict = [tempDict mutableCopy];
            }
            if (![Utility isEmptyCheck:taskFrequencyDictionary]) {
                [taskFrequencyDictionary removeAllObjects];
            }
            taskFrequencyDictionary = [reminderDict mutableCopy];
            [self setFrequencyButtonTitle:reminderDict];
        }
        
    } else if ([reminderIdentifier isEqualToString:@"Reminder"]){
        isReminderDict=true;
        reminderSwitch.on=true;
        reminderDictionary = [reminderDict mutableCopy];
        
    }
}

-(void) cancelReminder {
    if ([reminderIdentifier isEqualToString:@"Reminder"]){
        reminderSwitch.on=reminderSwitchStatus;
    }
}


#pragma mark End

#pragma  mark - DatePickerViewControllerDelegate
-(void)didSelectSeconds:(int)seconds with:(NSDate *)date{
    isEdited=true;
    if (date) {
        NSDateFormatter *df = [NSDateFormatter new];
        if (whenButton.selected) {
            int totalSeconds=[Utility secondsFromDate:date includeSeconds:NO];
            whenButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",totalSeconds];
            [df setDateFormat:@"hh:mm a"];
            [whenButton setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
        }
        else if(whenButton2.selected) {
            int totalSeconds=[Utility secondsFromDate:date includeSeconds:NO];
            whenButton2.accessibilityHint = [@"" stringByAppendingFormat:@"%d",totalSeconds];
            [df setDateFormat:@"hh:mm a"];
            [whenButton2 setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
        }else{
//            NSString *timeStr = [Utility timeFormatted:seconds];
            NSString *durationStr=[Utility durationStringFromSeconds:seconds includeSeconds:NO];
            durationButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",seconds];
            [durationButton setTitle:durationStr forState:UIControlStateNormal];
        }
    }else{
        if (whenButton.selected) {
            whenButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",seconds];
            [whenButton setTitle:@"NA" forState:UIControlStateNormal];
            }
        else if(whenButton2.selected) {
            whenButton2.accessibilityHint = [@"" stringByAppendingFormat:@"%d",seconds];
            [whenButton2 setTitle:@"NA" forState:UIControlStateNormal];
        }else{
            durationButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",seconds];
            [durationButton setTitle:@"NA" forState:UIControlStateNormal];
        }
    }
}
#pragma mark End



@end
