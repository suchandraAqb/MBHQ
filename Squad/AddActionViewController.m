//
//  AddActionViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 14/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AddActionViewController.h"
#import "DropdownViewController.h"
#import "SongPlayListViewController.h"

#import <AVKit/AVKit.h> //song19
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

//chayan
#import "Utility.h"
#import "AddActionTableViewCell.h"
#import "GratitudeListViewController.h"

@interface AddActionViewController ()<SPTAudioStreamingDelegate,SPTAudioStreamingPlaybackDelegate> {
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *doneButton;
    IBOutlet UIButton *categoryButton;
    IBOutlet UIButton *selectGoalButton;
    IBOutlet UISwitch *setReminderSwitch;
    IBOutlet UIButton *deleteButton;
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIStackView *mainStackView;
    IBOutlet UIView *deleteView;
    IBOutlet UIButton *copyButton;
    IBOutlet UIButton *viewReminder;
    IBOutlet UITextView *titleTextView;
    IBOutlet NSLayoutConstraint *titleTextViewHeightConstraint;

    NSMutableArray *categoryArray;
    NSMutableDictionary *resultDict;
    UIView *contentView;
    UITextView *activeTextView;
    UIToolbar *numberToolbar;
    
    IBOutlet UIButton *selectSongButton;
    IBOutlet UIView *songView;

    AVAudioPlayer *player;//song19
    BOOL isFirstTime;//song19
    
    NSMutableDictionary *savedReminderDict;     //ah ln1
    
    //chayan
    NSMutableArray *actionHistoryArray;
     IBOutlet UITableView *actionHistorytable;
    IBOutlet NSLayoutConstraint *actionHistorytableHeightConstraint;
    NSInteger previousIndex;
    NSInteger startIndex;
    NSInteger endIndex;
    NSMutableArray *countIndexArray;
    
    //add_su_new
    NSMutableArray *reminderIdListArray;
    BOOL isChanged;
    BOOL isActionCheck;
    IBOutlet UIButton *actionSaveButton;
    BOOL isFirstTimeReminderSet;//gami_badge_popup

    __weak IBOutlet UIButton *headerButton;
    __weak IBOutlet UIView *editActionTitleView;
    __weak IBOutlet UIButton *editButton;
    __weak IBOutlet UIView *calMenuView;
    __weak IBOutlet UILabel *monthLabel;
    __weak IBOutlet UILabel *yearLabel;
    __weak IBOutlet JTHorizontalCalendarView *calendarContentView;
    JTCalendarManager *calendarManager;
    __weak IBOutlet UIView *streakMainView;
    NSArray *monthsArray;
    __weak IBOutlet UIView *lastStreakView;
    __weak IBOutlet UILabel *lastStreakLabel;
    __weak IBOutlet UIView *bestStreakView;
    __weak IBOutlet UILabel *bestStreakLabel;
    __weak IBOutlet UIView *actionHistoryView;
    __weak IBOutlet UIView *reminderView;
    __weak IBOutlet UIView *goalView;
    __weak IBOutlet UIView *categoryView;
    __weak IBOutlet UIStackView *categoryStackView;
    __weak IBOutlet UIView *saveView;
    BOOL isEdit;
    __weak IBOutlet UIView *showHideView;
    __weak IBOutlet UIView *editView;
    __weak IBOutlet UIImageView *otherImageView;
    __weak IBOutlet UIButton *showButton;
    
}

@end

@implementation AddActionViewController
//ah ac1
- (void)viewDidLoad {
    [super viewDidLoad];
    isEdit = false;
    //chayan
    actionHistoryArray=[[NSMutableArray alloc] init];
    
    isFirstTimeReminderSet = true; //gami_badge_popup

    //Amity
    previousIndex=startIndex=endIndex=-1;
    if(!countIndexArray){
        countIndexArray=[[NSMutableArray alloc]init];
    }
    //End
    //add_su_new
    reminderIdListArray = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
    [self registerForKeyboardNotifications];
    resultDict = [[NSMutableDictionary alloc]init];
    categoryArray = [[NSMutableArray alloc]init];
    isFirstTime = YES; //song19
    isChanged = NO;
    [Utility stopFlashingbutton:saveButton];
    [Utility stopFlashingbutton:doneButton];
    savedReminderDict = [[NSMutableDictionary alloc] init];
    
    if (![Utility isEmptyCheck:_actionSelectedDict] && _actionSelectedDict.count > 0) {
        deleteView.hidden = NO;
        deleteButton.hidden = false;
    } else {
        deleteView.hidden = YES;
        deleteButton.hidden = true;
    }
    
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(doneWithFirstResponder)],nil];
    [numberToolbar sizeToFit];
    titleTextView.inputAccessoryView = numberToolbar;
    
    calendarManager = [JTCalendarManager new];
    calendarManager.delegate = self;
    [calendarManager setContentView:calendarContentView];
    [calendarManager setDate:[NSDate date]];
    
    monthsArray = [[NSArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    [self setDateAndYearLabel:[NSDate date]];
    [lastStreakView setNeedsLayout];
    [lastStreakView layoutIfNeeded];
    [bestStreakView setNeedsLayout];
    [bestStreakView layoutIfNeeded];
    lastStreakView.layer.borderWidth = 1;
    lastStreakView.layer.borderColor = squadMainColor.CGColor;
    lastStreakView.layer.masksToBounds = YES;
    lastStreakView.layer.cornerRadius = lastStreakView.frame.size.height / 2;
    bestStreakView.layer.borderWidth = 1;
    bestStreakView.layer.borderColor = squadMainColor.CGColor;
    bestStreakView.layer.masksToBounds = YES;
    bestStreakView.layer.cornerRadius = bestStreakView.frame.size.height / 2;
//    titleTextView.layer.borderColor = squadSubColor.CGColor;
//    titleTextView.layer.borderWidth = 1;
    [self makeBorder:viewReminder mainColor:false];
    [self makeBorder:selectGoalButton mainColor:false];
    [self makeBorder:selectSongButton mainColor:false];
    [self makeBorder:showButton mainColor:false];
    [self makeBorder:editButton mainColor:true];
    showButton.selected = true;
    isActionCheck = false;
    if (![Utility isEmptyCheck:_buddyDict]) {
        saveView.hidden = true;
        deleteButton.hidden = true;
        editView.hidden = true;
    }
    mainScroll.hidden = true;
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
}

//chayan
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [actionHistorytable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitList:) name:@"backButtonPressed" object:nil];
    if (isFirstTime) {
        isFirstTime = NO;
        [self getCategory];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
//    [reminderIdListArray removeAllObjects]; //add_su_new
    [actionHistorytable removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
    [player pause];
    if (self.sPlayer) {
        [self.sPlayer setIsPlaying:NO callback:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Local Notification Observer and delegate

-(void)quitList:(NSNotification *)notification{
    
    NSString *text = notification.object;
    
    
    if([text isEqualToString:@"homeButtonPressed"]){
        [self logoTapped:0];
    }else{
        [self back:0];
    }
    
}
-(void)makeBorder:(UIButton *)sender mainColor:(BOOL)mainColor{
    if (mainColor) {
        sender.layer.borderColor = squadMainColor.CGColor;
    } else {
        sender.layer.borderColor = squadSubColor.CGColor;
    }
    sender.layer.borderWidth = 1;
}
#pragma mark - IBAction
- (IBAction)back:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            if (self->isEdit) {
                self->isChanged = NO;
                [Utility stopFlashingbutton:self->saveButton];
                [Utility stopFlashingbutton:self->doneButton];
                self->isEdit = NO;
                [self prepareView];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
//                [self dismissViewControllerAnimated:YES completion:nil];
            }
//            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [self->player pause];
    if (self.sPlayer) {
        [self.sPlayer setIsPlaying:NO callback:nil];
    }
}
- (IBAction)selectSongButtonTapped:(id)sender {
    //    SongListViewController *songController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SongListView"];
    //    songController.songListDelegate = self;
    [player pause];
    SongPlayListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayListView"];
    controller.isSelectMusic = YES;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];    //ah song
}

- (IBAction)logoTapped:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            //            [self.navigationController popToRootViewControllerAnimated:YES];
            if(([Utility isSubscribedUser] && [Utility isOfflineMode]) || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
//                TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
                GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                [self.navigationController pushViewController:controller animated:YES];
            }
//            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}
- (IBAction)doneTapped:(id)sender {
    //    NSLog(@"res %@",resultDict);
    if ([Utility isEmptyCheck:_actionSelectedDict] && _actionSelectedDict.count == 0) {
        if ([self validationCheck]) {
            [self saveData];
        }
    } else {
        //chayan
        if (isEdit) {
            //edit
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![Utility isEmptyCheck:self->reminderIdListArray] && self->reminderIdListArray.count>0) {
                    [self changeActionReminder:@"ChangeActionReminderStatusListAPI"];
                }
                if ([self validationCheck]) {
                    [self saveData];
                }
            });
        } else {
            //view
            if (![Utility isEmptyCheck:reminderIdListArray] && reminderIdListArray.count>0) {
                [self changeActionReminder:@"ChangeActionReminderStatusListAPI"];
            }
        }
    }
}
- (IBAction)categoryButtonTapped:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    isChanged = YES;
    for (UIButton *button in categoryStackView.subviews) {
        if (sender == button) {
            [button setBackgroundColor:squadMainColor];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setSelected:true];
        } else {
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:squadMainColor forState:UIControlStateNormal];
            [button setSelected:false];
        }
    }
    
    [resultDict setObject:[NSNumber numberWithInteger:sender.tag] forKey:@"CategoryId"];
//    int catID = [[resultDict objectForKey:@"CategoryId"] intValue];
//    int selectedIndex = -1;
//    for (int i = 0; i < categoryArray.count; i++) {
//        int cid = [[[categoryArray objectAtIndex:i] objectForKey:@"id"] intValue];
//        if (cid == catID) {
//            selectedIndex = i;
//        }
//    }
//
//    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
//    controller.modalPresentationStyle = UIModalPresentationCustom;
//    controller.dropdownDataArray = categoryArray;
//    controller.mainKey = @"CategoryName";
//    controller.apiType = @"Category";
//    controller.selectedIndex = selectedIndex;
//    controller.delegate = self;
//    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)setReminderValueChanged:(id)sender {
    if ([sender isOn]) {
        SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
        if ([resultDict objectForKey:@"FrequencyId"] != nil){
            controller.defaultSettingsDict = resultDict;
        }
        controller.reminderDelegate = self;
        //gami_badge_popup
        if (isFirstTimeReminderSet) {
            controller.isFirstTime = isFirstTimeReminderSet;
            isFirstTimeReminderSet = false;
        }//gami_badge_popup
        
        controller.view.backgroundColor = [UIColor clearColor];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
//        [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
//        [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
        
        UISwitch *remSwitch = (UISwitch *)sender;
        [remSwitch setOn:YES];
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Edit Reminder"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self viewReminder:0];
                                   }];
        UIAlertAction *turnOff = [UIAlertAction
                                  actionWithTitle:@"Turn Off Reminder"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      UISwitch *remSwitch = (UISwitch *)sender;
                                      [remSwitch setOn:NO];
                                      
                                      [self->resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"HasReminder"];
                                      [self->resultDict removeObjectForKey:@"FrequencyId"];
                                      [self prepareReminderView];
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
- (IBAction)selectGoalButtonTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    //if([Utility isEmptyCheck:_goalListArray]) return;
    NSDictionary *selectedDict = [self getDictByValue:_goalListArray value:[btn titleForState:UIControlStateNormal] type:@"Name"];
    
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = _goalListArray;
    controller.mainKey = @"Name";
    controller.apiType = @"GoalList";
    controller.selectedIndex = (int)[_goalListArray indexOfObject:selectedDict];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)deleteButtonTapped:(id)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Comfirm Delete"
                                          message:@"Do you want to delete this action?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Delete"
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   [self deleteAction];
                                   
                                   //ah ln1
                                   NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
                                   for (UILocalNotification *req in requests) {
                                       NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
                                       if ([pushTo caseInsensitiveCompare:@"Action"] == NSOrderedSame) {
                                           int bucketRemID = [[req.userInfo objectForKey:@"ID"] intValue];
                                           if (bucketRemID == [[self->_actionSelectedDict objectForKey:@"Id"] intValue]) {
                                               [[UIApplication sharedApplication] cancelLocalNotification:req];
                                           }
                                       }
                                   }
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)copyTapped:(id)sender {
    titleTextView.text = [NSString stringWithFormat:@"COPY OF : %@",titleTextView.text];
    titleTextViewHeightConstraint.constant = titleTextView.contentSize.height;
    [resultDict setObject:titleTextView.text forKey:@"Name"];
    [resultDict setObject:[NSNumber numberWithInt:0] forKey:@"id"];
    [resultDict setObject:[NSNumber numberWithInt:0] forKey:@"Id"];
    copyButton.hidden = true;
}
- (IBAction)viewReminder:(UIButton *)sender {
    SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
    if ([resultDict objectForKey:@"FrequencyId"] != nil)
        controller.defaultSettingsDict = resultDict;
    controller.reminderDelegate = self;
    controller.view.backgroundColor = [UIColor clearColor];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];
    
}

//chayan
-(IBAction)checkButtonTapped:(UIButton *)sender {
    if (![Utility isEmptyCheck:_buddyDict]) {
        return;
    }
    isActionCheck = true;
//    [Utility startFlashingbutton:actionSaveButton];
    sender.selected = !sender.isSelected;
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:[[[actionHistoryArray objectAtIndex:sender.tag] objectForKey:@"goal_mindset_reminder_master_id"] integerValue]],@"ReminderID", nil];
    [reminderIdListArray addObject:dict];
}

-(IBAction)saveButtonTapped:(UIButton *)sender{
    if (![Utility isEmptyCheck:reminderIdListArray] && reminderIdListArray.count>0) {
        [self changeActionReminder:@"ChangeActionReminderStatusListAPI"];
    }
}
- (IBAction)editButtonPressed:(UIButton *)sender {
    isEdit = true;
    [self prepareView];
}
- (IBAction)previousButtonPressed:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->calendarContentView loadPreviousPageWithAnimation];
    });
}
- (IBAction)nextButtonPressed:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->calendarContentView loadNextPageWithAnimation];
    });
}
-(void)setDateAndYearLabel:(NSDate *)currentDate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSCalendar* tempCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [tempCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
        
        self->yearLabel.text=[@"" stringByAppendingFormat:@"%d",(int)[components year]];
        self->monthLabel.text=[@"" stringByAppendingFormat:@"%@",[self->monthsArray objectAtIndex:(int)[components month]-1]];
        
    });
}
- (IBAction)showButtonPressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    BOOL show = sender.selected;
    if(sender.isSelected){
        [otherImageView setImage:[UIImage imageNamed:@"down_arr.png"]];
    }else{
        [otherImageView setImage:[UIImage imageNamed:@"fp_up_arr.png"]];
    }
    if ([Utility isEmptyCheck:_actionSelectedDict] && _actionSelectedDict.count == 0) {
        goalView.hidden = show;
        songView.hidden = show;
    }else{
        [self prepareView];
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    //[_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
    return YES;
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDate *currentDate = calendar.date;
        [self setDateAndYearLabel:currentDate];
    });
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDate *currentDate = calendar.date;
        [self setDateAndYearLabel:currentDate];
    });
}

#pragma mark -End
#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView


- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *createdDate = [Utility getDateOnly:_actionSelectedDict[@"CreatedAt"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *strtDate = [formatter dateFromString:createdDate];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    dayView.hidden = false;
    // Other month
    if(![calendarManager.dateHelper date:calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
        //        dayView.layer.borderWidth = 0.0f;
        dayView.hidden = true;
    }
    // date range
    else if([calendarManager.dateHelper date:dayView.date isEqualOrAfter:strtDate andEqualOrBefore:[NSDate date]]){
        BOOL selected = false;
        for (NSDictionary *dict in actionHistoryArray) {
            if([dict[@"is_action"]boolValue] && [dayView.date isSameDay:[formatter dateFromString:dict[@"reminder_datetime"]]]){//selected
                dayView.circleView.hidden = NO;
                dayView.circleView.backgroundColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f];
                dayView.dotView.backgroundColor = [UIColor whiteColor];
                dayView.textLabel.textColor = [UIColor whiteColor];
                selected = true;
                break;
            }
        }
        if(!selected){
            dayView.circleView.hidden = NO;
            dayView.circleView.backgroundColor = [UIColor whiteColor];
            dayView.circleView.layer.borderWidth = 1;
            dayView.circleView.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
            dayView.dotView.backgroundColor = [UIColor whiteColor];
            dayView.textLabel.textColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f];
        }
        
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.textLabel.textColor = [UIColor blackColor];
        //        dayView.layer.borderWidth = 0.0f;
    }
    // Today
    //    if([calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
    //        dayView.circleView.hidden = NO;
    //        dayView.circleView.backgroundColor = [UIColor whiteColor];
    //        dayView.dotView.backgroundColor = [UIColor whiteColor];
    //        dayView.textLabel.textColor = [UIColor blackColor];
    //        dayView.layer.borderColor = [UIColor blackColor].CGColor;
    //        dayView.layer.borderWidth = 1.0f;
    //    }
    // Selected date
    //    else if(_dateSelected && [calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
    //
    //        UIColor *temp=dayView.circleView.backgroundColor;
    //
    //        if([temp isEqual:[UIColor whiteColor]]){
    //            dayView.circleView.hidden = NO;
    //            //        dayView.circleView.backgroundColor = dayView.circleView.backgroundColor;
    //            dayView.circleView.backgroundColor = [UIColor whiteColor];
    //            dayView.dotView.backgroundColor = [UIColor lightGrayColor];
    //            dayView.textLabel.textColor = [UIColor blackColor];
    //            dayView.layer.borderWidth = 0.0f;
    //        }
    //    }
    
    
    
    
    //    UIImageView *i = [[UIImageView alloc]initWithFrame:dayView.circleView.bounds];
    //    i.image = [UIImage imageNamed:@"tick_circle.png"];
    //    [dayView.circleView addSubview:i];
    //    i.center = dayView.circleView.center;
    
    
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    //    _dateSelected = dayView.date;
    //
    //    // Animation for the circleView
    //    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    //    [UIView transitionWithView:dayView
    //                      duration:.3
    //                       options:0
    //                    animations:^{
    //                        dayView.circleView.transform = CGAffineTransformIdentity;
    //                        //[calendarManager reload];
    //                        NSCalendar* tempCalendar = [NSCalendar currentCalendar];
    //                        NSDateComponents* components = [tempCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dayView.date]; // Get necessary date components
    //                        NSString *key=[@"" stringByAppendingFormat:@"%d-%02d-%02d",(int)[components year],(int)[components month],(int)[components day]];
    //                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"StartDate beginswith[c] %@", key];
    //                        NSArray *filteredArray = [modifiedEventArray filteredArrayUsingPredicate:predicate];
    //                        if (filteredArray.count > 0) {
    //                            int s =(int)[modifiedEventArray indexOfObject:[filteredArray objectAtIndex:0]];
    //                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:s inSection:0];
    //                            CalendarEventTableViewCell *cell = (CalendarEventTableViewCell *)[eventTable cellForRowAtIndexPath:indexPath];
    //                            CGRect animatedViewFrame = [eventTable convertRect:cell.frame toView:scroll];
    //                            [scroll scrollRectToVisible:animatedViewFrame animated:YES];                        }
    //
    //                    } completion:nil];
    
    //
    //    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    //    if(calendarManager.settings.weekModeEnabled){
    //        return;
    //    }
    //    // Load the previous or next page if touch a day from another month
    //
    //    if(![calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
    //        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
    //            [_calendarContentView loadNextPageWithAnimation];
    //        }
    //        else{
    //            [_calendarContentView loadPreviousPageWithAnimation];
    //        }
    //    }
}

#pragma mark - API Call

//chayan
- (void)changeActionReminder:(NSString *)api {
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        //[mainDict setObject:[NSNumber numberWithInteger:[[[actionHistoryArray objectAtIndex:sender.tag] objectForKey:@"goal_mindset_reminder_master_id"] integerValue]] forKey:@"ReminderID"];
        
        [mainDict setObject:reminderIdListArray forKey:@"ChangeList"]; //add_su_new
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"\n\n %@",jsonString);
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:api append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSLog(@"\n\n %@",responseString);
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         self->isActionCheck = false;
                                                                         self->isEdit = false;
//                                                                         [Utility stopFlashingbutton:self->actionSaveButton];
                                                                         
                                                                         //gami_badge_popup
                                                                         if (self->_isNewAction) {
                                                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];
                                                                         }//gami_badge_popup

                                                                         for (int i =0; i<self->reminderIdListArray.count; i++) {
                                                                             
                                                                             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(goal_mindset_reminder_master_id == %@)",[self->reminderIdListArray[i]objectForKey:@"ReminderID"]];
                                                                             NSArray *filterArray = [self->actionHistoryArray filteredArrayUsingPredicate:predicate];
                                                                             
                                                                             if (![Utility isEmptyCheck:filterArray]) {
                                                                                 NSMutableDictionary *dict =[[filterArray objectAtIndex:0]mutableCopy];
                                                                                 NSInteger index= [self->actionHistoryArray indexOfObject:dict];
                                                                                 if ([[dict objectForKey:@"is_action"]boolValue]) {
                                                                                     [dict setValue:[NSNumber numberWithBool:NO] forKey:@"is_action"];
                                                                                 }else{
                                                                                     [dict setValue:[NSNumber numberWithBool:YES] forKey:@"is_action"];
                                                                                 }
                                                                                 [self->actionHistoryArray replaceObjectAtIndex:index withObject:dict];
                                                                             }
                                                                         }
                                                                         NSMutableArray *mutblArray = [[NSMutableArray alloc]initWithArray:self->actionHistoryArray];
                                                                         [self->_actionSelectedDict setObject:mutblArray forKey:@"goal_mindset_reminder_master_Details"];
                                                                         [self->reminderIdListArray removeAllObjects];
                                                                         [self.view setNeedsUpdateConstraints];

                                                                         [self->calendarManager setDate:[NSDate date]];
                                                                         [self setDateAndYearLabel:[NSDate date]];
                                                                         [self->actionHistorytable reloadData];
//                                                                         dispatch_async(dispatch_get_main_queue(), ^{
//                                                                             [self populateGroupCount];
//                                                                         });
                                                                         [self updateBestAndLast];
                                                                         [Utility msg:@"Saved successfully" title:nil controller:self haveToPop:NO];
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

-(void) getCategory {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        //        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetCategoryAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           
                                                                           self->categoryArray = [responseDictionary objectForKey:@"Details"];
                                                                           
                                                                           for (UIButton *button in self->categoryStackView.subviews) {
                                                                               [self->categoryStackView removeArrangedSubview:button];
                                                                               [button removeFromSuperview];
                                                                           }
                                                                           for (NSDictionary *temp in self->categoryArray) {
                                                                               UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                                                               
                                                                               [button addTarget:self action:@selector(categoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                                                                               [button setTitle:[temp objectForKey:@"CategoryName"] forState:UIControlStateNormal];
                                                                               button.tag =[[temp objectForKey:@"id"] integerValue];
                                                                               button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                                                                               button.titleLabel.font =[UIFont fontWithName:@"Oswald-Light" size:17];
                                                                               if ([[temp objectForKey:@"id"] integerValue] == 10) {
                                                                                   [button setBackgroundColor:squadMainColor];
                                                                                   [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                                                                   [button setSelected:true];
                                                                               } else {
                                                                                   [button setBackgroundColor:[UIColor whiteColor]];
                                                                                   [button setTitleColor:squadMainColor forState:UIControlStateNormal];
                                                                                   [button setSelected:false];
                                                                               }
                                                                               [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                                                                               [self makeBorder:button mainColor:YES];
                                                                               
                                                                               [self->categoryStackView addArrangedSubview:button];
                                                                           }
                                                                           [self.view layoutIfNeeded];
                                                                           
                                                                           if ([Utility isEmptyCheck:self->_actionSelectedDict] && self->_actionSelectedDict.count == 0) {
                                                                               //ah ac2
                                                                               if ([Utility isEmptyCheck:self->_goalListArray]) {
                                                                                   [self getGoalList];
                                                                               }else{                                                                         [self prepareView];
                                                                               }
                                                                           } else {
                                                                               if (![Utility isEmptyCheck:self->_goalListArray]) {
                                                                                   [self getSelectDetails];
                                                                               } else {
                                                                                   [self getGoalList];
                                                                               }
                                                                           }
                                                                           
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
- (void) getGoalList {      //ah ln1
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self->contentView || ![self->contentView isDescendantOfView:self.view]) {
                //                [contentView removeFromSuperview];
                self->contentView = [Utility activityIndicatorView:self];     //ah cv
            }
            //            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetGoalListAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];   //ah cv
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           self->_goalListArray = [responseDictionary objectForKey:@"Details"];
                                                                           if (![Utility isEmptyCheck:self->_actionSelectedDict]) {
                                                                               if (![Utility isEmptyCheck:[self->_actionSelectedDict objectForKey:@"Id"]]) {
                                                                                   [self getSelectDetails];
                                                                               }else{
                                                                                   [self prepareView];
                                                                               }
                                                                           }else{
                                                                               [self prepareView];
                                                                           }
                                                                       }
                                                                   }else{
                                                                       //                                                                       [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                   }
                                                               });
                                                           }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
-(void) getSelectDetails {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[_actionSelectedDict objectForKey:@"Id"] forKey:@"ActionId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetActionSelectAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       
                                                                       NSLog(@"\n\n ssss string : %@",responseString);
                                                                       
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           
                                                                           self->_actionSelectedDict = [[responseDictionary objectForKey:@"Details"]mutableCopy];
                                                                           
                                                                           [self prepareView];
                                                                           
                                                                       } else {
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
-(void) saveData {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        if ([resultDict objectForKey:@"FrequencyId"] == nil) {
            [resultDict setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
            [resultDict setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
            [resultDict setObject:[NSNumber numberWithInt:12] forKey:@"ReminderAt1"];
            [resultDict setObject:[NSNumber numberWithInt:12] forKey:@"ReminderAt2"];
            [resultDict setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
            
            NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
            NSArray* monthArray = [newDateformatter monthSymbols];
            NSArray* dayArray = [newDateformatter weekdaySymbols];
            for (int i = 0; i < monthArray.count; i++) {
                [resultDict setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:i]];
            }
            for (int i = 0; i < dayArray.count; i++) {
                [resultDict setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
            }
        }
        
        [resultDict removeObjectForKey:@"GoalIdTemp"];
        
        [resultDict setObject:titleTextView.text forKey:@"Name"];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:resultDict forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateActionAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {

//                                                                           if (![Utility isEmptyCheck:self->reminderIdListArray] && self->reminderIdListArray.count>0) {
//                                                                               [self changeActionReminder:@"ChangeActionReminderStatusListAPI"];
//                                                                           }
                                                                           
                                                                           //ah ln1
                                                                           if (self->setReminderSwitch.isOn && ![Utility isEmptyCheck:self->savedReminderDict] && [[self->savedReminderDict objectForKey:@"PushNotification"] boolValue]) {
                                                                               
                                                                               [self->resultDict setObject:[[responseDictionary objectForKey:@"Details"] objectForKey:@"Id"] forKey:@"Id"];
                                                                               
                                                                               NSMutableDictionary *extraData = [[NSMutableDictionary alloc] init];
                                                                               [extraData setObject:self->resultDict forKey:@"selectedActionDict"];
                                                                               [extraData setObject:[NSArray new] forKey:@"GoalListArray"];
                                                                               
                                                                               //                                                                               if (SYSTEM_VERSION_LESS_THAN(@"10")) {
                                                                               [SetReminderViewController setOldLocalNotificationFromDictionary:self->savedReminderDict ExtraData:extraData FromController:@"Action" Title:self->titleTextView.text Type:@"Action" Id:[[self->_actionSelectedDict objectForKey:@"Id"] intValue]];
                                                                               //                                                                               } else {
                                                                               //                                                                                   [SetReminderViewController setLocalNotificationFromDictionary:savedReminderDict ExtraData:_actionSelectedDict FromController:@"Action" Title:titleTextView.text Type:@"Action" Id:[[_actionSelectedDict objectForKey:@"Id"] intValue]];
                                                                               //                                                                               }
                                                                           }
                                                                           [self.navigationController popViewControllerAnimated:YES];
//                                                                           [self dismissViewControllerAnimated:YES completion:nil];
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
-(void) deleteAction {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[_actionSelectedDict objectForKey:@"Id"] forKey:@"ActionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteActionAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           [self.navigationController popViewControllerAnimated:YES];
//                                                                           [self dismissViewControllerAnimated:YES completion:nil];
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






#pragma mark - SongListDelegate
- (void) getSelectedSongName:(NSString *)name Url:(NSString *)songUrlStr {
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
    [selectSongButton setAccessibilityHint:songUrlStr];
    [selectSongButton setTitle:name forState:UIControlStateNormal];
    NSString *saveSongDataStr = [NSString stringWithFormat:@"%@*##*%@",songUrlStr,name];
    [resultDict setObject:saveSongDataStr forKey:@"Song"];      //ah song
    [_actionSelectedDict setObject:saveSongDataStr forKey:@"Song"];
}
#pragma mark - SportifyDelegate
-(void) sportifySelSongName:(NSString *)name Url:(NSString *)songUrlStr{
    //song name from spotify
    NSLog(@"song song song %@",songUrlStr);
    
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
    
    [selectSongButton setAccessibilityHint:songUrlStr];
    [selectSongButton setTitle:name forState:UIControlStateNormal];
    NSString *saveSongDataStr = [NSString stringWithFormat:@"%@*##*%@",songUrlStr,name];
    [resultDict setObject:saveSongDataStr forKey:@"Song"];      //ah 4.5
    [_actionSelectedDict setObject:saveSongDataStr forKey:@"Song"];
    [self playSongInSpotify:songUrlStr];
}
-(void)playSongInSpotify:(NSString *)songUrlStr{
    @try {
        SPTAuth *auth = [SPTAuth defaultInstance];
        NSLog(@"%@",auth.session);
        if (![Utility isEmptyCheck:auth.session]) {
            if (auth.session.isValid) {
                if (self.sPlayer == nil) {
                    NSError *error = nil;
                    NSLog(@"%@\n%@",auth.clientID,auth.session.accessToken);
                    if(![Utility isEmptyCheck:auth.clientID] && ![Utility isEmptyCheck:auth.session.accessToken]){
                        self.sPlayer = [SPTAudioStreamingController sharedInstance];
                        if (!self.sPlayer.initialized) {
                            if ([self.sPlayer startWithClientId:auth.clientID audioController:nil allowCaching:YES error:&error]) {
                                self.sPlayer.delegate = self;
                                self.sPlayer.playbackDelegate = self;
                                self.sPlayer.diskCache = [[SPTDiskCache alloc] initWithCapacity:1024 * 1024 * 64];
                                [self.sPlayer loginWithAccessToken:auth.session.accessToken];
                            }
                            
                        }
                        
                    }
                    
                }
            }
        }
        
        
        
        //        if (!self.sPlayer) {
        //            self.sPlayer = [SPTAudioStreamingController sharedInstance];
        //            self.sPlayer.delegate = self;
        //            self.sPlayer.playbackDelegate = self;
        //        }
        if (self.sPlayer.playbackState.isPlaying) {
            [self.sPlayer setIsPlaying:NO callback:nil];
        }
        [self.sPlayer playSpotifyURI:songUrlStr startingWithIndex:0 startingWithPosition:10 callback:^(NSError *error) {
            if (error != nil) {
                NSLog(@"*** failed to play: %@", error);
                return;
            }else{
                
            }
        }];
    } @catch (NSException *exception) {
        
    }
}
#pragma mark  - End
#pragma mark - ReminderDelegate
-(void) reminderSettingsValue:(NSMutableDictionary *)reminderDict {
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
    savedReminderDict = reminderDict;   //ah ln1
    [resultDict setObject:[NSNumber numberWithBool:YES] forKey:@"HasReminder"];
    [_actionSelectedDict addEntriesFromDictionary:reminderDict];
    [resultDict addEntriesFromDictionary:reminderDict];
    [self prepareReminderView];
}
-(void) cancelReminder {
    if ([resultDict objectForKey:@"FrequencyId"] != nil) {
        
    } else {
        [setReminderSwitch setOn:NO];
        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"HasReminder"];
        [resultDict removeObjectForKey:@"FrequencyId"];
    }
    [self prepareReminderView];
}
#pragma mark - Dropdown Delegate
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData{
    NSLog(@"ty %@ \ndata %@",type,selectedData);
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
    if ([type caseInsensitiveCompare:@"Category"] == NSOrderedSame) {
        [categoryButton setTitle:[selectedData objectForKey:@"CategoryName"] forState:UIControlStateNormal];
        [resultDict setObject:[selectedData objectForKey:@"id"] forKey:@"CategoryId"];
    } else if ([type caseInsensitiveCompare:@"GoalList"] == NSOrderedSame) {
        [selectGoalButton setTitle:[selectedData objectForKey:@"Name"] forState:UIControlStateNormal];
        [resultDict setObject:[selectedData objectForKey:@"id"] forKey:@"GoalId"];
        [resultDict setObject:[selectedData objectForKey:@"id"] forKey:@"GoalId"];
    }
}
#pragma mark - Private Methods
-(BOOL) validationCheck {
    BOOL isValid = NO;
    NSString *titleStr = titleTextView.text;
    
    if (titleStr.length < 1 || [titleStr isEqualToString:@"ADD ACTION"]) {
        [Utility msg:@"Please enter Action Name." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    } else if ([[resultDict objectForKey:@"CategoryId"] intValue] < 0) {        //ah ux3
        [Utility msg:@"Please select Category." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    } else if (!setReminderSwitch.isOn) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:@"Would you like to set a reminder to help you stay accountable and achieve your goal?"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
                                       [self->setReminderSwitch setOn:YES];
                                       [self setReminderValueChanged:self->setReminderSwitch];
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self saveData];
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return isValid;
    }
    
    return YES;
}
-(NSDictionary *)getDictByValue:(NSArray *)filterArray value:(id)value type:(NSString *)type{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",type, value];
    NSArray *filteredSessionCategoryArray = [filterArray filteredArrayUsingPredicate:predicate];
    if (filteredSessionCategoryArray.count > 0) {
        NSDictionary *dict = [filteredSessionCategoryArray objectAtIndex:0];
        return dict;
    }
    return  nil;
}
-(void) prepareView {
    [self.view endEditing:YES];
    if ([Utility isEmptyCheck:_actionSelectedDict] && _actionSelectedDict.count == 0) {
        //add
//        titleTextView.textColor = [UIColor darkGrayColor];
        titleTextView.userInteractionEnabled = true;
        if (![Utility isEmptyCheck:_actionName]) {
            titleTextView.text = _actionName;
        }
        titleTextViewHeightConstraint.constant = titleTextView.contentSize.height;
        if (![Utility isEmptyCheck:_selectedGoal]) {
            [headerButton setTitle:[_selectedGoal objectForKey:@"Name"] forState:UIControlStateNormal];
        }
        
        editActionTitleView.hidden = true;
        deleteButton.hidden = true;
        editButton.hidden = true;
        editView.hidden = true;
        calMenuView.hidden = true;
        calendarContentView.hidden = true;
        streakMainView.hidden = true;
        actionHistoryView.hidden = true;
        actionHistorytable.hidden = true;
        reminderView.hidden = false;
        goalView.hidden = showButton.isSelected;
        songView.hidden = showButton.isSelected;
//        categoryView.hidden = false;
//        saveView.hidden = false;
        
        [selectGoalButton setTitle:[_selectedGoal objectForKey:@"Name"] forState:UIControlStateNormal];
        [resultDict setObject:[_selectedGoal objectForKey:@"id"] forKey:@"GoalId"];
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDate *newDate = [cal dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:[NSDate date] options:0];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZZ"];     //2017-03-06T10:38:18.7877+00:00
        NSString *currentDateStr = [formatter stringFromDate:newDate];
        NSString *newCurrentDateStr = [formatter stringFromDate:[NSDate date]];
        
//        [categoryButton setTitle:[[categoryArray objectAtIndex:9] objectForKey:@"CategoryName"] forState:UIControlStateNormal];
        
        [resultDict setObject:[NSNumber numberWithInt:0] forKey:@"id"];
        [resultDict setObject:@"" forKey:@"Name"];
        [resultDict setObject:@"" forKey:@"Song"];
        [resultDict setObject:[[categoryArray objectAtIndex:9] objectForKey:@"id"] forKey:@"CategoryId"];
        [resultDict setObject:currentDateStr forKey:@"DueDate"];
        [resultDict setObject:[defaults objectForKey:@"UserID"] forKey:@"CreatedBy"];
        [resultDict setObject:[NSArray new] forKey:@"goal_mindset_reminder_master_Details"];
        [resultDict setObject:[NSArray new] forKey:@"GoalDetails"];
        [resultDict setObject:currentDateStr forKey:@"reminder_till_date"];
        [resultDict setObject:newCurrentDateStr forKey:@"last_reminder_inserted_date"];
        [resultDict setObject:newCurrentDateStr forKey:@"CreatedAt"];
        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsDeleted"];
        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"Status"];
        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsCreatedUpdated"];
//        [resultDict setObject:[NSNumber numberWithInt:0] forKey:@"GoalId"];
        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"HasReminder"];
    }
    else {
        //chayan
        if (isEdit) {
            //edit
            [headerButton setTitle:@"EDIT ACTION" forState:UIControlStateNormal];
            titleTextView.userInteractionEnabled = true;
            editActionTitleView.hidden = false;
            deleteButton.hidden = false;
            editButton.hidden = true;
            editView.hidden = true;
            calMenuView.hidden = true;
            calendarContentView.hidden = true;
            streakMainView.hidden = true;
            actionHistoryView.hidden = true;
            actionHistorytable.hidden = true;
            reminderView.hidden = false;
//            categoryView.hidden = false;
            saveView.hidden = false;
            showHideView.hidden = false;
            goalView.hidden = showButton.isSelected;
            songView.hidden = showButton.isSelected;
            
        } else {
            //view
            [headerButton setTitle:@"ACTIONS" forState:UIControlStateNormal];
            if (![Utility isEmptyCheck:[_actionSelectedDict objectForKey:@"GoalId"]] && [[_actionSelectedDict objectForKey:@"GoalId"] integerValue] > 0) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id == %d)", [[_actionSelectedDict objectForKey:@"GoalId"] intValue]];
                NSArray *filteredSessionCategoryArray = [_goalListArray filteredArrayUsingPredicate:predicate];
                NSDictionary *selectedDict = [[NSDictionary alloc]init];
                if (filteredSessionCategoryArray.count > 0) {
                    selectedDict = [filteredSessionCategoryArray objectAtIndex:0];
//                    [selectGoalButton setTitle:[selectedDict objectForKey:@"Name"] forState:UIControlStateNormal];
                    [headerButton setTitle:[selectedDict objectForKey:@"Name"] forState:UIControlStateNormal];
                }
                
            }
            titleTextView.userInteractionEnabled = false;
            editActionTitleView.hidden = true;
            deleteButton.hidden = false;
            editButton.hidden = false;
            editView.hidden = false;
            calMenuView.hidden = false;
            calendarContentView.hidden = false;
            streakMainView.hidden = false;
            actionHistoryView.hidden = false;
            actionHistorytable.hidden = false;
            reminderView.hidden = true;
//            categoryView.hidden = false;
            saveView.hidden = false;
            showHideView.hidden = true;
            goalView.hidden = true;
            songView.hidden = true;
        }
        if (![Utility isEmptyCheck:_buddyDict]) {
            deleteButton.hidden = true;
            editView.hidden = true;
            saveView.hidden = true;
        }
        
        actionHistoryArray=[[_actionSelectedDict objectForKey:@"goal_mindset_reminder_master_Details"] mutableCopy];
        if ([Utility isEmptyCheck:actionHistoryArray]) {
            actionHistoryView.hidden = true;
        }
        [self updateBestAndLast];
        
        [calendarManager setDate:[NSDate date]];
        [self setDateAndYearLabel:[NSDate date]];
        [actionHistorytable reloadData];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self populateGroupCount];
//        });
        
        
        titleTextView.text = [[_actionSelectedDict objectForKey:@"Name"]capitalizedString];
        titleTextViewHeightConstraint.constant = titleTextView.contentSize.height;
//        titleTextView.textColor = [UIColor darkGrayColor];
        
        if (![Utility isEmptyCheck:[_actionSelectedDict objectForKey:@"GoalId"]] && [[_actionSelectedDict objectForKey:@"GoalId"] integerValue] > 0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id == %d)", [[_actionSelectedDict objectForKey:@"GoalId"] intValue]];
            NSArray *filteredSessionCategoryArray = [_goalListArray filteredArrayUsingPredicate:predicate];
            NSDictionary *selectedDict = [[NSDictionary alloc]init];
            if (filteredSessionCategoryArray.count > 0) {
                selectedDict = [filteredSessionCategoryArray objectAtIndex:0];
                [selectGoalButton setTitle:[selectedDict objectForKey:@"Name"] forState:UIControlStateNormal];
                NSString *dueDate = [Utility getDateOnly:[selectedDict objectForKey:@"DueDate"]];
                NSDateFormatter *df = [NSDateFormatter new];
                [df setDateFormat:@"yyyy-MM-dd"];
                if ([[df dateFromString:[df stringFromDate:[NSDate date]]] isEarlierThanOrEqualTo:[df dateFromString:dueDate]]) {
                    [setReminderSwitch setOnTintColor:[UIColor colorWithRed:(76/255.0f) green:(217/255.0f) blue:(100/255.0f) alpha:1.0f]];
                }
            }
            
        }
        
//        [categoryButton setTitle:[[categoryArray objectAtIndex:[[_actionSelectedDict objectForKey:@"CategoryId"] integerValue]-1] objectForKey:@"CategoryName"] forState:UIControlStateNormal];
        
        if (![Utility isEmptyCheck:[_actionSelectedDict objectForKey:@"PushNotification"]] && ![Utility isEmptyCheck:[_actionSelectedDict objectForKey:@"Email"]] && ([[_actionSelectedDict objectForKey:@"PushNotification"] boolValue] || [[_actionSelectedDict objectForKey:@"Email"] boolValue])) {
            savedReminderDict = _actionSelectedDict;   //ah ln1
            [setReminderSwitch setOn:YES];
        } else {
            [setReminderSwitch setOn:NO];
        }
        
        [resultDict addEntriesFromDictionary:_actionSelectedDict];
        
        //song19
        
        if (![Utility isEmptyCheck:[_actionSelectedDict objectForKey:@"Song"]]) {
            //play song
            NSError *error;
            //            if ([[NSFileManager defaultManager] fileExistsAtPath:[_selectedGoalDict objectForKey:@"Song"]]) { @"%@*#*%@"
            NSArray *songArr = [[_actionSelectedDict objectForKey:@"Song"] componentsSeparatedByString:@"*##*"];
            
            if (![Utility isEmptyCheck:songArr]) {
                if (songArr.count > 1) {
                    [selectSongButton setTitle:[songArr objectAtIndex:1] forState:UIControlStateNormal];
                }
                NSString *uri = [songArr objectAtIndex:0];
                if ([uri hasPrefix:@"spotify"]) {
                    [self playSongInSpotify:uri];
                } else {
                    player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:[songArr objectAtIndex:0]] error:&error];
                    
                    if (!error) {
                        [player prepareToPlay];
                        [player play];
                    }
                }
            }
            //}
            
        }//song19End

    }
    categoryView.hidden = true;
    [self prepareReminderView];
    mainScroll.hidden = false;
}
-(void)prepareReminderView{
    if (setReminderSwitch.on) {
        viewReminder.enabled = true;
        [viewReminder setTitle:@"View Reminder Settings" forState:UIControlStateNormal];
        viewReminder.alpha = 1.0;
//        [viewReminder setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    }else{
        viewReminder.enabled = false;
        [viewReminder setTitle:@"Set a Reminder" forState:UIControlStateNormal];
        viewReminder.alpha = 0.5;
//        [viewReminder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
}
-(void)updateBestAndLast{
    int lastCount = 0;
    int bestCount = 0;
    int tempBestCount = 0;
    BOOL breaked = true;
    int isFirst = 0;
    for (NSDictionary *temp in actionHistoryArray) {
        if([temp[@"is_action"]intValue] == 1){
            if (isFirst == 0) {
                isFirst = 1;
                lastCount++;
                tempBestCount++;
                bestCount++;
            }else if (isFirst == 1){
                lastCount++;
                tempBestCount++;
                bestCount++;
            }else if (isFirst == 2){
                tempBestCount++;
                if (tempBestCount>bestCount) {
                    bestCount = tempBestCount;
                }
            }
            
            breaked = false;
        }else{
            if (isFirst == 1) {
                isFirst = 2;
            }
            breaked = true;
            tempBestCount = 0;
        }
    }
    lastStreakLabel.text = [NSString stringWithFormat:@"%d",lastCount];
    bestStreakLabel.text = [NSString stringWithFormat:@"%d",bestCount];
}
-(void)doneWithFirstResponder{
    [self.view endEditing:YES];
}

//chayan
-(void)populateGroupCount{
    
    for(NSDictionary *dict in countIndexArray){
        
        NSInteger index = [dict[@"index"] integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        AddActionTableViewCell *cell=(AddActionTableViewCell *)[actionHistorytable cellForRowAtIndexPath:indexPath];
        cell.groupCountMiddleButton.hidden=NO;
        int groupTotal=[dict[@"groupTotal"] intValue];
        [cell.groupCountMiddleButton setTitle:[@"" stringByAppendingFormat:@"%d",groupTotal] forState:UIControlStateNormal];
        
    }
    
    if(countIndexArray.count>0)[countIndexArray removeAllObjects];
    
}


- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {    //ah ux3
    if (isChanged || isActionCheck) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Save Changes"
                                              message:@"Your changes will be lost if you don’t save them."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Save"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       if (self->isActionCheck) {
                                           [self changeActionReminder:@"ChangeActionReminderStatusListAPI"];
                                       }else if(self->isChanged){
                                           [self doneTapped:nil];
                                       }
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

#pragma mark - KeyboardNotifications -
// Call this method somewhere in your view controller setup code.
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
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextView.frame.origin) ) {
            [mainScroll scrollRectToVisible:activeTextView.frame animated:YES];
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
#pragma mark - textView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
    activeTextView=textView;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeTextView=nil;
    if(titleTextView.text.length == 0){
//        titleTextView.textColor = [UIColor lightGrayColor];
        titleTextView.text = @"ADD ACTION";
        [titleTextView resignFirstResponder];
    }
}
- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([txtView isEqual:titleTextView]) {
        //        if (txtView.contentSize.height > titleTextViewHeightConstraint.constant) {
        titleTextViewHeightConstraint.constant = txtView.contentSize.height;
        //        }
    }
    [self.view layoutIfNeeded];
    return YES;
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if([titleTextView.text caseInsensitiveCompare:@"ADD ACTION"] == NSOrderedSame){
        titleTextView.text = @"";
//        titleTextView.textColor = [UIColor darkGrayColor];
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(titleTextView.text.length == 0){
//        titleTextView.textColor = [UIColor lightGrayColor];
        titleTextView.text = @"ADD ACTION";
        [titleTextView resignFirstResponder];
    }
}




//chayan : tableview
#pragma mark - Table View Datasource Delegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return actionHistoryArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddActionTableViewCell *cell= (AddActionTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"AddActionTableViewCell"];
    if (cell==nil) {
        cell = [[AddActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddActionTableViewCell"];
    }
    
    if (![Utility isEmptyCheck:actionHistoryArray]) {
       NSDictionary *dict = [actionHistoryArray objectAtIndex:indexPath.row];
        
        //AmitY
        cell.groupCountMiddleButton.layer.cornerRadius=cell.groupCountMiddleButton.frame.size.height/2.0;
        cell.groupCountMiddleButton.clipsToBounds=YES;
        cell.groupCountMiddleButton.layer.borderColor=[Utility colorWithHexString:@"F427AB"].CGColor;
        cell.groupCountMiddleButton.layer.borderWidth=1.0;
        cell.groupCountMiddleButton.hidden=YES;
        //End
        
       
        NSString *dateStr=[dict objectForKey:@"reminder_datetime"];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        NSDate *date = [dateFormatter dateFromString:dateStr];
        dateFormatter.dateFormat = @"MMM dd";
        NSString *dateString=[dateFormatter stringFromDate:date];
        
        
        cell.nameLabel.text=dateString;
        
        bool isAction=[[dict objectForKey:@"is_action"] boolValue];
        
        if (isAction) {
            [cell.checkButton setSelected:YES];
            
            if(previousIndex == -1){
                previousIndex=indexPath.row;
                startIndex=indexPath.row;
                cell.middleLineView.hidden=NO;
                cell.bottomLineView.hidden=NO;
                cell.topLineView.hidden=YES;
                
                int nextIndex=(int)indexPath.row+1;
                if(nextIndex<=actionHistoryArray.count-1){
                    NSDictionary *nextDict = [actionHistoryArray objectAtIndex:nextIndex];
                    bool nextIsAction=[[nextDict objectForKey:@"is_action"] boolValue];
                    if(!nextIsAction){
                        previousIndex=-1;
                        startIndex=-1;
                        cell.middleLineView.hidden=YES;
                        cell.bottomLineView.hidden=YES;
                        cell.topLineView.hidden=YES;
                    }
                }else{
                    previousIndex=-1;
                    startIndex=-1;
                    cell.middleLineView.hidden=YES;
                    cell.bottomLineView.hidden=YES;
                    cell.topLineView.hidden=YES;
                }
                
            }else if(previousIndex+1 == indexPath.row){
                previousIndex=indexPath.row;
                endIndex=indexPath.row;
                cell.middleLineView.hidden=YES;
                cell.bottomLineView.hidden=NO;
                cell.topLineView.hidden=NO;
                
                int nextIndex=(int)indexPath.row+1;
                if(nextIndex<=actionHistoryArray.count-1){
                    NSDictionary *nextDict = [actionHistoryArray objectAtIndex:nextIndex];
                    bool nextIsAction=[[nextDict objectForKey:@"is_action"] boolValue];
                    if(!nextIsAction){
                        previousIndex=-1;
                        cell.middleLineView.hidden=NO;
                        cell.bottomLineView.hidden=YES;
                        cell.topLineView.hidden=NO;
                        
                        //Amity
                        NSInteger midIndex=floor((startIndex+endIndex)/2.0);
                        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:(int)(endIndex-startIndex)+1],@"groupTotal",[NSNumber numberWithInteger:midIndex],@"index", nil];
                        
                        [countIndexArray addObject:dict];
                        startIndex=-1;
                        endIndex=-1;
                        //End
                        
                    }
                }else{
                    previousIndex=-1;
                    cell.middleLineView.hidden=NO;
                    cell.bottomLineView.hidden=YES;
                    cell.topLineView.hidden=NO;
                    
                    //Amity
                    NSInteger midIndex=floor((startIndex+endIndex)/2.0);
                    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:(int)(endIndex-startIndex)+1],@"groupTotal",[NSNumber numberWithInteger:midIndex],@"index", nil];
                    
                    [countIndexArray addObject:dict];
                    startIndex=-1;
                    endIndex=-1;
                    //End
                }
                
                
            }

        }
        else{
            [cell.checkButton setSelected:NO];
            cell.middleLineView.hidden=YES;
            cell.bottomLineView.hidden=YES;
            cell.topLineView.hidden=YES;
        }
        cell.middleLineView.hidden=YES;
        cell.bottomLineView.hidden=YES;
        cell.topLineView.hidden=YES;
        cell.groupCountMiddleButton.hidden = YES;
        
        [cell.checkButton addTarget:self action:@selector(checkButtonTapped:)
                   forControlEvents:UIControlEventTouchUpInside];
        [cell.checkButton setTag:indexPath.row];
        
    }
    
    return cell;
}

#pragma mark - End

//chayan
#pragma mark - Observers Method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == actionHistorytable) {
        actionHistorytableHeightConstraint.constant=actionHistorytable.contentSize.height;
    }
}

#pragma mark - End


@end












