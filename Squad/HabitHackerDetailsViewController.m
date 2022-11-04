//
//  HabitHackerDetailsViewController.m
//  Squad
//
//  Created by Suchandra Bhattacharya on 03/12/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "HabitHackerDetailsViewController.h"
@interface HabitHackerDetailsViewController ()
{
    IBOutletCollection(UITextView) NSArray *textView;
    IBOutletCollection(UIScrollView) NSArray *mainScroll;
    IBOutletCollection(UIButton) NSArray*createhabitNowbutton;
    IBOutlet UIScrollView *headerScroll;
    IBOutletCollection(UIButton) NSArray *checkBtn;
    IBOutlet UIView *createhabitView;
    IBOutlet UIButton *habitTimeButton;
    IBOutlet UIButton *newHabitTimeButton;
    IBOutlet UIButton *newHabitTwiceTimeButton;
    IBOutlet UIButton *howLongButton;
    IBOutlet UISwitch *reminderSwitch;
    IBOutlet UIView *firstpageview;
    IBOutlet UIView *secondpageview;
    IBOutlet UIView *mainview;
    IBOutlet UIView *twiceDailyTimeView;
    IBOutlet UITextView *habitName;
    IBOutlet UITextView *habitBreakName;
    IBOutlet UIButton *backButton;
    IBOutlet UIView *popUpAlertView;
    IBOutlet UIView *popUpView;
    IBOutlet UIButton *quickAddButton;
    IBOutlet UIButton *fullsetUpButton;
    IBOutlet UIButton *saveButton;
    UIToolbar *toolBar;
    UITextView *activeTextView;
    UITextField *activeTextField;
    BOOL pageControlIsChangingPage;
    int currentPage;
    BOOL isbreak;
    UIView *contentView;
    NSMutableDictionary *reminderDictionary;
    NSMutableDictionary *habitSet;
    NSMutableDictionary *habitDict;
    NSMutableDictionary *breakHabitDict;
    NSArray *frequencyArray;
    BOOL isnextpage;
    NSMutableDictionary *habitDefaultReminderSet;
    NSMutableDictionary *reminderDictForSettingNotification;
    
    
    IBOutlet NSLayoutConstraint *rewardingTextViewHeightConstraint;
    IBOutlet UIScrollView *rewardScroll;
    IBOutlet UIButton *popularHabitButton;
    NSDictionary *keyboardDetailsDict;
    
    
}
@end

@implementation HabitHackerDetailsViewController
@synthesize hackerdelegate;
#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    keyboardDetailsDict=[[NSDictionary alloc] init];
    mainview.hidden = false;
    firstpageview.hidden = false;
    secondpageview.hidden = true;
    createhabitView.hidden = true;
    isnextpage = false;
    popUpView.layer.cornerRadius = 15;
    popUpView.layer.masksToBounds = YES;
    habitDict = [[NSMutableDictionary alloc]init];
    reminderDictionary = [[NSMutableDictionary alloc]init];
    reminderDictForSettingNotification = [[NSMutableDictionary alloc]init];
    breakHabitDict = [[NSMutableDictionary alloc]init];
    habitSet = [[NSMutableDictionary alloc]init];
    habitDefaultReminderSet = [[NSMutableDictionary alloc]init];
    [self habitChange:0];
    habitTimeButton.layer.cornerRadius = 8;
    habitTimeButton.layer.masksToBounds = YES;
    reminderSwitch.on = false;
    frequencyArray = [@[@"Daily",@"Twice Daily",@"Weekly",@"Fortnightly",@"Monthly",@"Yearly"] mutableCopy];
    [habitTimeButton setTitle:[frequencyArray objectAtIndex:0] forState:UIControlStateNormal];
    [defaults setBool:false forKey:@"isCreate"];
    
    for (UITextView *text in textView) {
        text.layer.borderColor = [UIColor whiteColor].CGColor;
        text.layer.borderWidth = 1;
        text.layer.cornerRadius = 8;
        text.layer.masksToBounds = YES;
    }
   
    for (UIButton *button in createhabitNowbutton) {
        button.layer.borderColor = squadMainColor.CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 8;
        button.layer.masksToBounds = YES;
    }
    newHabitTimeButton.layer.cornerRadius = 8;
    newHabitTimeButton.layer.masksToBounds = YES;
    newHabitTwiceTimeButton.layer.cornerRadius = 8;
    newHabitTwiceTimeButton.layer.masksToBounds = YES;
    howLongButton.layer.cornerRadius = 8;
    howLongButton.layer.masksToBounds = YES;
    habitName.layer.cornerRadius = 8;
    habitName.layer.masksToBounds = YES;
    habitBreakName.layer.cornerRadius = 8;
    habitBreakName.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 8;
    habitBreakName.layer.masksToBounds = YES;
    popularHabitButton.layer.cornerRadius = 8;
    popularHabitButton.layer.masksToBounds = YES;
    currentPage = 0;
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    _createpageControl.hidden = true;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [self registerForKeyboardNotifications];
    [self tickUntickForPopUp:0];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"Quick Add"];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-SemiBold" size:18] range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString length])];
    
    NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:@"  (3/3)"];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway" size:17] range:NSMakeRange(0, [attributedString2 length])];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString2 length])];
    
    [attributedString appendAttributedString:attributedString2];
    [quickAddButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc]initWithString:@"Full Set-Up"];
    [attributedString3 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-SemiBold" size:18] range:NSMakeRange(0, [attributedString3 length])];
    [attributedString3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString3 length])];
    
    NSMutableAttributedString *attributedString4 =[[NSMutableAttributedString alloc]initWithString:@"  (3/14)"];
    [attributedString4 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway" size:17] range:NSMakeRange(0, [attributedString4 length])];
    [attributedString4 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString4 length])];
    
    [attributedString3 appendAttributedString:attributedString4];
    [fullsetUpButton setAttributedTitle:attributedString3 forState:UIControlStateNormal];
    [saveButton setTitle:@"Create Now" forState:UIControlStateNormal];
}

#pragma mark - End

#pragma mark - IBAction
-(IBAction)page2notifcationPressed:(id)sender{
      SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
        controller.isFromHacker = true;
        if ([reminderDictionary objectForKey:@"FrequencyId"] != nil)
            controller.defaultSettingsDict = reminderDictionary;
        controller.reminderDelegate = self;
        controller.view.backgroundColor = [UIColor clearColor];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)changePage:(id)sender
{
    //move the scroll view
     UIPageControl * pageControl;
     UIScrollView *scrollView;
     scrollView = headerScroll;
     pageControl = _createpageControl;
     CGRect frame = scrollView.frame;
     frame.origin.x = frame.size.width * pageControl.currentPage;
     frame.origin.y = 0;
    //    frame.origin.x = frame.size.width * 1;
     [scrollView scrollRectToVisible:frame animated:YES];
    //scrollViewDidEndDecelerating will turn this off
//    pageControlIsChangingPage = YES;
}
-(IBAction)habitChange:(UIButton*)sender{
    if (sender.tag == 0) {
        //[habitDict setObject:[NSNumber numberWithBool:false] forKey:@"IsBreak"];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapAction:)];
                tapGesture.numberOfTapsRequired = 1;
        [headerScroll addGestureRecognizer:tapGesture];
    }
}
-(IBAction)createHabitNowPressed:(UIButton*)sender{
    for (int i = 0; i<12; i++) {
         [self createHabitDetails:i];
    }
    if ([Utility isEmptyCheck:[habitDict objectForKey:@"HabitName"]] || [Utility isEmptyCheck:[habitDefaultReminderSet objectForKey:@"TaskFrequencyTypeId"]] || [Utility isEmptyCheck:[breakHabitDict objectForKey:@"Name"]]) {
        [Utility msg:@"Please write the habit do you want to break" title:@"Alert" controller:self haveToPop:NO];
        return;
    }
        if (secondpageview.hidden == false) {
            if (![Utility isEmptyCheck:habitDefaultReminderSet]) {
                       if (![Utility isEmptyCheck:[habitDefaultReminderSet objectForKey:@"TaskFrequencyTypeId"]]) {
                           int taskFrequencyId = [[habitDefaultReminderSet objectForKey:@"TaskFrequencyTypeId"]intValue];
                           if (taskFrequencyId == 2) {
                               twiceDailyTimeView.hidden = false;
                           }else{
                               twiceDailyTimeView.hidden = true;
                           }
                       }
                   }
            int seconds = 300;
            howLongButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",seconds];
            [howLongButton setTitle:@"5 Minutes" forState:UIControlStateNormal];
            [self setUpAlertForPage2:@"FULL SET UP" with:@"QUICK ADD"];
        }else if(_createpageControl.currentPage<9){
            [self createHabitDetails:(int)_createpageControl.currentPage];
            [self tapAction:0];
          //  [self setUpAlertForPage2:@"COMPLETE FULL SET UP" with:@"SAVE NOW"];
        }else{
             self->isnextpage = false;
            [self addUpdateHabitSwap_WebServiceCall:@""];
        }
}

-(IBAction)datePressed:(UIButton*)sender{
    if (sender == newHabitTimeButton) {
        newHabitTimeButton.selected = true;
        howLongButton.selected = false;
        newHabitTwiceTimeButton.selected = false;

    }else if(sender == newHabitTwiceTimeButton){
        newHabitTimeButton.selected = false;
        howLongButton.selected = false;
        newHabitTwiceTimeButton.selected = true;
    }else{
        newHabitTimeButton.selected = false;
        newHabitTwiceTimeButton.selected = false;
        howLongButton.selected = true;
    }
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
                controller.isfromhabit = YES;
                controller.modalPresentationStyle = UIModalPresentationCustom;
//               controller.maxDate = [NSDate date];
//                NSTimeInterval sixmonth = 5*60*60;
//                controller.minDate = [[NSDate date]
//                                         dateByAddingTimeInterval:sixmonth];
               controller.selectedDate = [NSDate date];
                
                if (sender == newHabitTimeButton) {
                    controller.datePickerMode = UIDatePickerModeTime;
                }else if(sender == newHabitTwiceTimeButton){
                    controller.datePickerMode = UIDatePickerModeTime;
                }else{
                    controller.datePickerMode = UIDatePickerModeCountDownTimer;
                }
               controller.delegate = self;
               [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)backButtonpressed:(id)sender{
    [self setUpAlertForExit];
}
-(IBAction)reminderPressed:(UISwitch*)sender{
    if (sender.on) {
        SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
//        controller.isfromHabitHideYearly = true;
//        controller.isFromHacker = true;
//        if ([reminderDictionary objectForKey:@"FrequencyId"] != nil)
//            controller.defaultSettingsDict = reminderDictionary;
        controller.reminderDelegate = self;
        controller.view.backgroundColor = [UIColor clearColor];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        
    }
}
-(IBAction)nextbuttonPressed:(id)sender{
   
//    [self createHabitDetails:0];
//    if ([Utility isEmptyCheck:[habitDict objectForKey:@"HabitName"]] || [Utility isEmptyCheck:[habitDefaultReminderSet objectForKey:@"TaskFrequencyTypeId"]]) {
//        [Utility msg:@"Please write the habit do you want to create" title:@"Alert" controller:self haveToPop:NO];
//        return;
//    }
//    mainview.hidden = false;
////    firstpageview.hidden = true;
////    secondpageview.hidden = false;
//    createhabitView.hidden = true;
//    [self setUpAlertForSave];
    for (int i = 0; i<12; i++) {
         [self createHabitDetails:i];
    }
    if ([Utility isEmptyCheck:[habitDict objectForKey:@"HabitName"]] || [Utility isEmptyCheck:[habitDefaultReminderSet objectForKey:@"TaskFrequencyTypeId"]] || [Utility isEmptyCheck:[breakHabitDict objectForKey:@"Name"]]) {
        [Utility msg:@"Please write the habit do you want to break" title:@"Alert" controller:self haveToPop:NO];
        return;
    }
        if (secondpageview.hidden == false) {
            if (![Utility isEmptyCheck:habitDefaultReminderSet]) {
                       if (![Utility isEmptyCheck:[habitDefaultReminderSet objectForKey:@"TaskFrequencyTypeId"]]) {
                           int taskFrequencyId = [[habitDefaultReminderSet objectForKey:@"TaskFrequencyTypeId"]intValue];
                           if (taskFrequencyId == 2) {
                               twiceDailyTimeView.hidden = false;
                           }else{
                               twiceDailyTimeView.hidden = true;
                           }
                       }
                   }
            int seconds = 300;
            howLongButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",seconds];
            [howLongButton setTitle:@"5 Minutes" forState:UIControlStateNormal];
            [self setUpAlertForPage2:@"FULL SET UP" with:@"QUICK ADD"];
        }else if(_createpageControl.currentPage<9){
            [self createHabitDetails:(int)_createpageControl.currentPage];
            [self tapAction:0];
          //  [self setUpAlertForPage2:@"COMPLETE FULL SET UP" with:@"SAVE NOW"];
        }else{
             self->isnextpage = false;
            [self addUpdateHabitSwap_WebServiceCall:@""];
        }
    
}
-(IBAction)seconpageBackPressed:(id)sender{
//      mainview.hidden = false;
//      firstpageview.hidden = false;
//      secondpageview.hidden = true;
//      createhabitView.hidden = true;
      [self setUpAlertForExit];
}
-(IBAction)quickAddPressed:(id)sender{
     self->isnextpage= false;
     popUpAlertView.hidden = true;
     [self addUpdateHabitSwap_WebServiceCall:@""];
}
-(IBAction)FullSetUpPressed:(id)sender{
   self->mainview.hidden = true;
    self->firstpageview.hidden = true;
    self->secondpageview.hidden = true;
    self->createhabitView.hidden = false;
    self->isnextpage = true;
    popUpAlertView.hidden = true;
   [self addUpdateHabitSwap_WebServiceCall:@""];
}
-(IBAction)closePopUppressed:(id)sender{
    popUpAlertView.hidden = true;
}
-(IBAction)tickUntickForPopUp:(UIButton*)sender{
        if (sender.tag == 0) {
            quickAddButton.selected = true;
            fullsetUpButton.selected = false;
            [saveButton setTitle:@"Create Now" forState:UIControlStateNormal];

        }else{
            quickAddButton.selected = false;
            fullsetUpButton.selected = true;
            [saveButton setTitle:@"Continue" forState:UIControlStateNormal];

        }
}
-(IBAction)savePressed:(id)sender{
    if (quickAddButton.selected) {
        [self quickAddPressed:0];
    }else{
        [self FullSetUpPressed:0];
    }
}
-(IBAction)popularHabitButtonPressed:(id)sender{
    PopularHabitListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PopularHabitList"];
    [self.navigationController pushViewController:controller animated:NO];
}
#pragma mark - End
- (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60; int minutes = (totalSeconds / 60) % 60; int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

-(void)setDefaultReminder{
       [habitDefaultReminderSet setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
       [habitDefaultReminderSet setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
       [habitDefaultReminderSet setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt1"];
       [habitDefaultReminderSet setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt2"];
       [habitDefaultReminderSet setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
       [habitDefaultReminderSet setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
       [habitDefaultReminderSet setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
       
       NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
       NSArray* monthArray = [newDateformatter monthSymbols];
       NSArray* dayArray = [newDateformatter weekdaySymbols];
       for (int i = 0; i < monthArray.count; i++) {
           [habitDefaultReminderSet setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:i]];
       }
       for (int i = 0; i < dayArray.count; i++) {
           [habitDefaultReminderSet setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
       }
}
-(void)setUpAlertForPage2:(NSString*)saveStr with:(NSString*)nextPageStr{
    popUpAlertView.hidden = false;
    /*
    NSString *str = @"Please choose your option";
    UIAlertController *alertController = [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:str
                                             preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:[Utility getattributedMessage:str] forKey:@"attributedMessage"];
    
       UIAlertAction *okAction = [UIAlertAction
                                  actionWithTitle:saveStr
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                    self->mainview.hidden = true;
                                    self->firstpageview.hidden = true;
                                    self->secondpageview.hidden = true;
                                    self->createhabitView.hidden = false;
                                    self->isnextpage = true;
                                    if ([saveStr isEqualToString:@"COMPLETE FULL SET UP"]) {
                                       [self tapAction:0];
                                    }else{
                                       [self changePage:0];
                                    }
//                                    [self addUpdateHabitSwap_WebServiceCall:saveStr];
                                  }];
       UIAlertAction *cancelAction = [UIAlertAction
                                      actionWithTitle:nextPageStr
                                      style:UIAlertActionStyleCancel
                                      handler:^(UIAlertAction *action)
                                      {
                                        self->isnextpage= false;
                                        [self addUpdateHabitSwap_WebServiceCall:nextPageStr];
                                      }];
       [alertController addAction:okAction];
       [alertController addAction:cancelAction];
       [self presentViewController:alertController animated:YES completion:nil];
     */
}
-(void)setUpAlertForExit{
    NSString *str = @"Are you sure you want to exit?";
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:str
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:[Utility getattributedMessage:str] forKey:@"attributedMessage"];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"SAVE MY HABIT NOW"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   self->isnextpage = false;
                                   [self addUpdateHabitSwap_WebServiceCall:@""];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"NO"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
//                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)setUpAlertForSave{
    NSString *str = @"Are you sure you want to Save?";
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:str
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:[Utility getattributedMessage:str] forKey:@"attributedMessage"];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"SAVE MY HABIT NOW"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   self->isnextpage = false;
                                   [self addUpdateHabitSwap_WebServiceCall:@""];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"NO"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
//                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
     [habitDefaultReminderSet setObject:[reminderDictionary objectForKey:@"MonthReminder"] forKey:@"TaskMonthReminder"];
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
        [breakHabitDict setObject:[reminderDictionary objectForKey:@"MonthReminder"] forKey:@"TaskMonthReminder"];
//        [breakHabitDict setObject:[reminderDictionary objectForKey:@"ReminderAt1"] forKey:@"TaskReminderAt1"];
    //        [breakHabitDict setObject:[reminderDictionary objectForKey:@"ReminderAt2"] forKey:@"TaskReminderAt2"];

}
-(void)createHabitDetails:(int)value{
    if (value == 0) {
        [habitDict setObject:habitName.text forKey:@"HabitName"];
            if (![Utility isEmptyCheck:reminderDictionary]) {
                [self setupHabit];
            }else{
                [self setDefaultReminder];
                reminderDictionary = [habitDefaultReminderSet mutableCopy];
                [self setupHabit];
            }
        
    }else if (value == 1){
         [breakHabitDict setObject:habitBreakName.text forKey:@"Name"];
        
    }else if (value == 2){
        
        if (![Utility isEmptyCheck:newHabitTimeButton.accessibilityHint]) {
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//             [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//             NSDate *date = [dateFormatter dateFromString:[newHabitTimeButton.accessibilityHint mutableCopy]];
//             NSTimeInterval interval  = [date timeIntervalSince1970] ;
             [habitDefaultReminderSet setObject:[newHabitTimeButton.accessibilityHint mutableCopy] forKey:@"TaskReminderAt1"];
             [breakHabitDict setObject:[newHabitTimeButton.accessibilityHint mutableCopy] forKey:@"TaskReminderAt1"];
 
        }else{
             [habitDefaultReminderSet setObject:[NSNumber numberWithInt:0] forKey:@"TaskReminderAt1"];
             [breakHabitDict setObject:[NSNumber numberWithInt:0] forKey:@"TaskReminderAt1"];
        }
        if (![Utility isEmptyCheck:newHabitTwiceTimeButton.accessibilityHint]) {
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//            NSDate *date = [dateFormatter dateFromString:[newHabitTwiceTimeButton.accessibilityHint mutableCopy]];
//            NSTimeInterval interval  = [date timeIntervalSince1970] ;
            [habitDefaultReminderSet setObject:[newHabitTwiceTimeButton.accessibilityHint mutableCopy] forKey:@"TaskReminderAt2"];
            [breakHabitDict setObject:[newHabitTwiceTimeButton.accessibilityHint mutableCopy] forKey:@"TaskReminderAt2"];

//              [habitDefaultReminderSet setObject:newHabitTwiceTimeButton.accessibilityHint forKey:@"ReminderAt2"];
        }else{
              [habitDefaultReminderSet setObject:[NSNumber numberWithInt:0] forKey:@"TaskReminderAt2"];
              [breakHabitDict setObject:[NSNumber numberWithInt:0] forKey:@"TaskReminderAt2"];

         }
        if (![Utility isEmptyCheck:howLongButton.accessibilityHint]) {
            [habitDefaultReminderSet setObject:[NSNumber numberWithInt:[howLongButton.accessibilityHint intValue]] forKey:@"Duration"];
        }else{
             [habitDefaultReminderSet setObject:[NSNumber numberWithInt:0] forKey:@"Duration"];
        }
        if (![Utility isEmptyCheck:reminderDictForSettingNotification] && reminderSwitch.on) {
            [self setUpReminder];
            [self setupHabit];
        }
        
    }else if (value == 3){
        for (UITextView *text in textView) {
            NSLog(@"%@",text.text);
        }
        UITextView *textview = textView[0];
        [habitDict setObject:textview.text forKey:@"ActionWhere"];
        
    }else if (value == 4){
        UITextView *textview = textView[1];
        [habitDict setObject:textview.text forKey:@"Cue"];
    }else if (value == 5){
         UITextView *textview = textView[2];
         [habitDict setObject:textview.text forKey:@"Routine"];
    }else if (value == 6){
         UITextView *textview = textView[3];
         [habitDict setObject:textview.text forKey:@"MoreSeen"];
    }else if (value == 7){
         UITextView *textview = textView[4];
         [habitDict setObject:textview.text forKey:@"Reward"];
    }else if (value == 8){
         UITextView *textview = textView[5];
         [habitDict setObject:textview.text forKey:@"AccountabilityNotes"];
    }else if (value == 9){
         UITextView *textview = textView[6];
         [habitDict setObject:textview.text forKey:@"OldActionBreak"];
    }else if (value == 10){
         UITextView *textview = textView[7];
         NSArray *brokenByLines=[[textview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsSeparatedByString:@"\n"];
         if (![Utility isEmptyCheck:brokenByLines]) {
            
             if (brokenByLines.count>1) {
                 [habitDict setObject:brokenByLines[0] forKey:@"NoteHidden"];
                 [habitDict setObject:brokenByLines[1] forKey:@"NoteHarder"];
             }else{
                 [habitDict setObject:brokenByLines[0] forKey:@"NoteHidden"];
             }
         }else{
              [habitDict setObject:@"" forKey:@"NoteHidden"];
         }

    }else if (value == 11){
         UITextView *textview = textView[8];
         [habitDict setObject:textview.text forKey:@"NoteHorrible"];
    }
}

-(void)addUpdateHabitSwap_WebServiceCall:(NSString*)saveStr{
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
//                                                                                 if ([saveStr isEqualToString:@"COMPLETE FULL SET UP"]) {
//                                                                                        [self tapAction:0];
//                                                                                    }else{
//                                                                                        [self changePage:0];
//                                                                                    }
                                                                                 if (self->reminderSwitch.isOn && ![Utility isEmptyCheck:self->habitDict] && [[self->habitDefaultReminderSet objectForKey:@"PushNotification"] boolValue]) {
                                                                                     NSMutableDictionary *extraDict = [NSMutableDictionary new];
                                                                                     [extraDict setObject:[self->habitDict objectForKey:@"HabitId"] forKey:@"HabitId"];
                                                                                     [SetReminderViewController setOldLocalNotificationFromDictionary:self->habitDefaultReminderSet ExtraData:extraDict FromController:(NSString *)@"HabitList" Title:self->habitName.text Type:@"HabitList" Id:[[self->habitDict objectForKey:@"HabitId"] intValue]];
                                                                                 }
                                                                                 if (!self->isnextpage) {
                                                                                     self->isnextpage = false;
                                                                                     if ([self->hackerdelegate respondsToSelector:@selector(reloadData)]) {
                                                                                         [self->hackerdelegate reloadData];
                                                                                     }
                                                                                     [[NSNotificationCenter defaultCenter]postNotificationName:@"HabitFirstViewReload" object:nil];
                                                                                     [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark - End

#pragma mark - UITapGesture Action
- (void)tapAction:(UITapGestureRecognizer *)tap
{
//    if(self.pageControl.currentPage == self.pageControl.numberOfPages-1){
//        headerScroll.hidden = true;
//        self.pageControl.hidden = true;
//        return;
//    }
    
        [self createHabitDetails:(int)_createpageControl.currentPage];
        _createpageControl.currentPage = _createpageControl.currentPage+1;
        [self changePage:0];
}
#pragma mark - End

#pragma mark - UIScrollViewDelegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if ((scrollView.contentOffset.x + scrollView.frame.size.width) > scrollView.contentSize.width) {
//        headerScroll.hidden = true;
//        self.pageControl.hidden = true;
//        return;
//    }
//    if (pageControlIsChangingPage) {
//        return;
//    }
    UIPageControl * pageControl;
    scrollView = headerScroll;
    pageControl = _createpageControl;
     
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (!(page==pageControl.currentPage)) {
        [self createHabitDetails:(int)page-1];
    }
    pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    pageControlIsChangingPage = NO;

//    uint page = mainScroll.contentOffset.x / SCROLLWIDTH;
//    [self.pageControl setCurrentPage:page];
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
    keyboardDetailsDict=info;
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
    for (UIScrollView *scroll in mainScroll) {
         scroll.contentInset = contentInsets;
         scroll.scrollIndicatorInsets = contentInsets;
    }
    
    rewardScroll.contentInset = contentInsets;
    rewardScroll.scrollIndicatorInsets = contentInsets;
    
   
    if (activeTextField !=nil) {
        for (UIScrollView *scroll in mainScroll) {
                scroll.contentInset = contentInsets;
                scroll.scrollIndicatorInsets = contentInsets;
                CGRect aRect = scroll.frame;
                aRect.size.height -= kbSize.height;
                if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
                       [scroll scrollRectToVisible:activeTextField.frame animated:YES];
                }
           }
        
       
    }else if (activeTextView !=nil) {
         for (UIScrollView *scroll in mainScroll) {
             CGRect aRect = scroll.frame;
                   CGRect frame = [scroll convertRect:activeTextView.frame fromView:activeTextView.superview];
                   aRect.size.height -= kbSize.height;
                   if (!CGRectContainsPoint(aRect,frame.origin) ) {
                       [scroll scrollRectToVisible:frame animated:YES];
                   }
         }
        
        if (![Utility isEmptyCheck:activeTextView.text]) {
        CGRect aRect = CGRectMake(activeTextView.frame.origin.x, activeTextView.frame.origin.y, activeTextView.contentSize.width, activeTextView.contentSize.height);
        [rewardScroll scrollRectToVisible:aRect animated:YES];
        }
        
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
      for (UIScrollView *scroll in mainScroll) {
          scroll.contentInset = contentInsets;
          scroll.scrollIndicatorInsets = contentInsets;
      }
    rewardScroll.contentInset = contentInsets;
    rewardScroll.scrollIndicatorInsets = contentInsets;
}
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}


#pragma mark - textView Delegate

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"%d",(int)_createpageControl.currentPage);
    if ((int)_createpageControl.currentPage==5) {
        CGFloat maxHeight = 250;
        if (rewardingTextViewHeightConstraint.constant < maxHeight) {
            rewardingTextViewHeightConstraint.constant +=15;
            [self.view setNeedsUpdateConstraints];
        }
        
        CGSize kbSize = [[keyboardDetailsDict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
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
         rewardScroll.contentInset = contentInsets;
         rewardScroll.scrollIndicatorInsets = contentInsets;
        if (![Utility isEmptyCheck:activeTextView.text]) {
             CGRect aRect = CGRectMake(activeTextView.frame.origin.x, activeTextView.frame.origin.y, activeTextView.contentSize.width, activeTextView.contentSize.height);
             [rewardScroll scrollRectToVisible:aRect animated:YES];
             }
    }
    
//    [self.view layoutIfNeeded];
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
#pragma mark - Reminder Delegate

-(void)reminderSettingsValue:(NSMutableDictionary *)reminderDict {
    NSLog(@"rem %@",reminderDict);
    if (!firstpageview.hidden) {
        reminderDictionary = [reminderDict mutableCopy];
        int frequencyId = [[reminderDict objectForKey:@"FrequencyId"]intValue];
        if (frequencyId>1) {
            int frequencyId = [[reminderDict objectForKey:@"FrequencyId"]intValue];
            [reminderDictionary setObject:[NSNumber numberWithInt:frequencyId] forKey:@"FrequencyId"];
        }
        
    }else{
        reminderDictForSettingNotification = [reminderDict mutableCopy];
    }
    if (![Utility isEmptyCheck:reminderDict]) {
        [habitTimeButton setTitle:[frequencyArray objectAtIndex:[[reminderDictionary objectForKey:@"FrequencyId"]intValue]-1] forState:UIControlStateNormal];
    }
    [self createHabitDetails:1];
}
-(void) cancelReminder {
}
#pragma  mark - DatePickerViewControllerDelegate
-(void) didSelectSeconds:(int)seconds with:(NSDate *)date{
    if (date) {
        NSDateFormatter *df = [NSDateFormatter new];
        if (newHabitTimeButton.selected) {
            int totalSeconds=[Utility secondsFromDate:date includeSeconds:NO];
            newHabitTimeButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",totalSeconds];
            [df setDateFormat:@"hh:mm a"];//hh:mm a
            [newHabitTimeButton setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
        }else if(newHabitTwiceTimeButton.selected) {
             int totalSeconds1=[Utility secondsFromDate:date includeSeconds:NO];
             newHabitTwiceTimeButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",totalSeconds1];
             [df setDateFormat:@"hh:mm a"];//hh:mm a
             [newHabitTwiceTimeButton setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
        }else{
//            NSString *timeStr = [Utility timeFormatted:seconds];
            NSString *durationStr=[Utility durationStringFromSeconds:seconds includeSeconds:NO];
            howLongButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",seconds];
            [howLongButton setTitle:durationStr forState:UIControlStateNormal];
        }
    }else{
      if (newHabitTimeButton.selected) {
            newHabitTimeButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",seconds];
            [newHabitTimeButton setTitle:@"NO SET TIME" forState:UIControlStateNormal];
        }else if(newHabitTwiceTimeButton.selected) {
            newHabitTwiceTimeButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",seconds];
            [newHabitTwiceTimeButton setTitle:@"NO SET TIME" forState:UIControlStateNormal];
        }else{
            howLongButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",seconds];
            [howLongButton setTitle:@"NO SET TIME" forState:UIControlStateNormal];
        }
    }
}

@end
