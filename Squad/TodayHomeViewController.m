//
//  TodayHomeViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 21/08/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "TodayHomeViewController.h"
#import "NewHomeCollectionViewCell.h"
#import "CourseAndTodoView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ExerciseDailyListViewController.h"
#import "GratitudeViewController.h"
#import "BlankListViewController.h"
#import "DietaryPreferenceViewController.h"
#import "MealFrequencyViewController.h"
#import "MealVarietyViewController.h"
#import "MealPlanViewController.h"
#import "SetProgramViewController.h"
#import "CoursesListViewController.h"
#import "CalendarViewController.h"
#import "MyPhotosDefaultViewController.h"
#import "AchievementsViewController.h"
#import "WebinarSelectedViewController.h"
#import "PodcastViewController.h"
#import "LatestResultViewController.h"
#import "CourseDetailsViewController.h"
#import "GratitudeAddEditViewController.h"
#import "AchievementsAddEditViewController.h"
#import "AddActionViewController.h"
#import "LearnHomeViewController.h"
#import "WaterTrackerViewController.h"
#import "WaterTrackerViewController.h"
#import "VitaminViewController.h"
#import "GratitudeListViewController.h"
#import "SignupWithEmailViewController.h"
#import "AchieveViewController.h"
#import "HabitStatsViewController.h"
#import "CourseDetailsViewController.h"
#import "TableViewCell.h"
//#import <QuartzCore/QuartzCore.h>
//#import <CoreText/CoreText.h>
#import <IntentsUI/IntentsUI.h>
#import <Intents/Intents.h>
#import "GratitudePopUpViewController.h"
@interface TodayHomeViewController (){
    
    __weak IBOutlet UIScrollView *mainScroll;
    __weak IBOutlet UIButton *headerDateButton;
    __weak IBOutlet UIButton *prevButton;
    __weak IBOutlet UIButton *nextButton;
    

    __weak IBOutlet UILabel *monthLabel;
    __weak IBOutlet UILabel *yearLabel;
    
    __weak IBOutlet JTHorizontalCalendarView *calendarContentView;
    JTCalendarManager *calendarManager;
    __weak IBOutlet UIStackView *calendarStackView;
    __weak IBOutlet UIButton *noEventsButton;
    //    NSDate *_dateSelected;

    NSDictionary *todaysDataDict;
    NSDate *currentDate;
    UIView *contentView;
    NSDateFormatter *formatter;
    
    NSArray *monthsArray;
    NSArray *upcomingEvents;
    NSArray *recentEvents;
    NSDate *weekstart;
    
    int apiCount;
    BOOL isLoadController;
    __weak IBOutlet UIView *loadingView;
    __weak IBOutlet UILabel *msgLabel;
    __weak IBOutlet UIImageView *animationImageView;
    IBOutlet UIView *notificationSplashView;
    IBOutlet UILabel *userNameLabel;
    IBOutlet UIButton *notificationSplashOkGotItButton;
    
    IBOutletCollection(UIButton) NSArray *gratitudeListButton;
    IBOutlet UITextView *gratitudetextView;
    IBOutlet UITextView *accomplishtextView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIScrollView *mainSuperScroll;
    IBOutlet NSLayoutConstraint *gratitudeHeightConstant;
    IBOutlet NSLayoutConstraint *accomplishmentHeightConstant;
    IBOutlet UIButton *growthButton;
    IBOutletCollection(UILabel) NSArray *habitNameLabel;
    IBOutletCollection(UIButton) NSArray *habitCheckUncheckButton;
    IBOutletCollection(UILabel) NSArray *habitPercentagelabel;
    IBOutletCollection(UILabel) NSArray *courseNameLabel;
    IBOutletCollection(UILabel) NSArray *coursePercentageLabel;
    IBOutletCollection(UIButton) NSArray *programButton;
    IBOutlet UITableView *habitTable;
    IBOutlet UIView *addButtonShowView;
    IBOutlet UIButton *habitListButton;
    IBOutlet UIView *infoview;
    IBOutlet UIButton *gotItButton;
    IBOutlet UIView *showPicTypeView;
    IBOutlet UIView *seeExampleView;
    IBOutlet UIImageView *seeExampleImage;
    IBOutletCollection(UIButton) NSArray *buttonArr;
    UIToolbar *toolBar;
    UITextView *activeTextView;
    UITextField *activeTextField;
    BOOL pageControlIsChangingPage;
    NSString *savehtmlTextForGratitude;
    NSString *savehtmlTextForAccomplishment;
    UIView *cursorView;
    BOOL isShowSave;
    NSString *selectedState;
    NSDictionary *todayGratitudeDict;
    NSDictionary *todayAchieveDict;
    NSDictionary *todayHabitCourseList;
    int twiceDailyCount;
    BOOL isBackFromNotes;
    NSArray *habitArray;
    NSArray *habitListArray;
    BOOL isTrueShare;
    NSDictionary *shareDict;
}

@end

@implementation TodayHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentDate = [NSDate date];
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    infoview.hidden = true;
    for (UIButton *btn in buttonArr) {
        btn.layer.cornerRadius = 9;
        btn.layer.masksToBounds = YES;
    }
    [self registerForKeyboardNotifications];
    [self nofictiactionPermission];
    [self webcellCall_GetUserHabitList];
    formatter = [NSDateFormatter new];
    headerDateButton.userInteractionEnabled = true;
    [headerDateButton addTarget:self action:@selector(headerDateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    if (![Utility reachable]) {
    if (([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeAeroplaneMode"]] || ![defaults boolForKey:@"isFirstTimeAeroplaneMode"]) && [[self.navigationController visibleViewController] isKindOfClass:[TodayHomeViewController class]]) {
               [self infoButtonPressed:0];
          }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    habitTable.estimatedRowHeight = 60;
    habitTable.rowHeight = UITableViewAutomaticDimension;
    [mainScroll setContentOffset:CGPointZero animated:NO];
    [defaults setObject:currentDate forKey:@"Date"];
    accomplishtextView.text = @"";
    isShowSave = false;
    twiceDailyCount = 1;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backFromNotesPressed:) name:@"backFromNotes" object:nil];

    [[NSNotificationCenter defaultCenter] addObserverForName:@"IsTodayGetGratitudeGrowthReload" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {

        [self getOfflineDataForHabitCourse];
           
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"IsTodaypageReload" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self webServicecallForGetGrowthHomePage:self->currentDate];
                 });
        }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"reloadGratitudeEditView" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        [self webServicecallForGetGrowthHomePage:self->currentDate];

    }];
   
   
    [self getOfflineDataForHabitCourse];
    if(![Utility reachable]){
        if ([Utility isEmptyCheck:gratitudetextView.text] || [gratitudetextView.text isEqualToString:@"Start typing"]) {
            [self setUpgratitude:[todayHabitCourseList objectForKey:@"Gratitude"]];
        }
        
        if ([Utility isEmptyCheck:accomplishtextView.text] ||  [accomplishtextView.text isEqualToString:@"Start typing"])
        {
             [self getOfflineDataForGrowth];
        }
        
        
    }
    [self prepareMbhqView];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
}
- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"left");//next button
        NSTimeInterval twoWeek = 1*24*60*60;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *endDate = [[formatter dateFromString:[formatter stringFromDate:[NSDate date]]] dateByAddingTimeInterval:twoWeek];//weekstart
        
        if ([currentDate isEarlierThan:endDate]) {
            [self nextButtonPressed:0];
        }
        
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"right");//prev button
        
        NSString *date = [todaysDataDict objectForKey:@"DateOfJoining"];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        NSDate *joiningDate = [formatter dateFromString:date];
        if (!joiningDate) {
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            joiningDate = [formatter dateFromString:date];
        }
        [formatter setDateFormat:@"yyyy-MM-dd"];
        joiningDate = [formatter dateFromString:[formatter stringFromDate:joiningDate]];
        NSDate *cDate = [formatter dateFromString:[formatter stringFromDate:currentDate]];
        if ([cDate isSameDay:joiningDate]) {
        
        }else{
            [self prevButtonPressed:0];
        }
        
    }
}
#pragma mark -IBAction

- (IBAction)prevButtonPressed:(UIButton *)sender {
    NSTimeInterval oneDay = -1*24*60*60;
    currentDate = [currentDate dateByAddingTimeInterval:oneDay];
//    [self getAppHomePageValues:currentDate];
}
- (IBAction)nextButtonPressed:(UIButton *)sender {
    NSTimeInterval oneDay = 1*24*60*60;
    currentDate = [currentDate dateByAddingTimeInterval:oneDay];
//    [self getAppHomePageValues:currentDate];
}

-(IBAction)mbhqListButtonPressed:(UIButton*)sender{
    if (![Utility reachable]) {
        [Utility msg:@"Currenly You are offline.Go to online to get the list" title:@"Oops! " controller:self haveToPop:NO];
        return;
    }
    if ([Utility isOnlyProgramMember]) {
//       [Utility showAlertAfterSevenDayTrail:self];
       return;
   }
    if (sender.tag == 1) { //GratitudeList
        
        NSArray *arr=self.navigationController.viewControllers;
        for (UIViewController *controller in arr) {
            if ([controller isKindOfClass:[GratitudeListViewController class]]) {
                GratitudeListViewController *c=(GratitudeListViewController *)controller;
                c.isFromGratitudeList=true;
                [self.navigationController popToViewController:c animated:YES];
                return;
            }
        }
        
        GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GratitudeListView"];
        controller.isFromGratitudeList = true;
        [self.navigationController pushViewController:controller animated:YES];
    }else{ //Accomplishment List
        NSArray *arr=self.navigationController.viewControllers;
        for (UIViewController *controller in arr) {
            if ([controller isKindOfClass:[AchievementsViewController class]]) {
                AchievementsViewController *c=(AchievementsViewController *)controller;
                c.isFromGrowthList=true;
                [self.navigationController popToViewController:c animated:YES];
                return;
            }
        }
        
        AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Achievements"];
        controller.isFromGrowthList = true;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(IBAction)mbhqSaveButtonPressed:(UIButton*)sender{
    [self.view endEditing:true];
    if ([Utility isOnlyProgramMember]) {
//        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }
    if (sender.tag == 11) {
        if (![Utility isEmptyCheck:gratitudetextView.text] && gratitudetextView.text.length>0 && ![gratitudetextView.text isEqualToString:@"Start typing"]) {
            [self saveDataMultiPart];
        }else{
             [Utility msg:@"Please enter some text" title:@"Alert!" controller:self haveToPop:NO];
        }
       
    }else{
        if (![Utility isEmptyCheck:accomplishtextView.text] && accomplishtextView.text.length>0 && ![accomplishtextView.text isEqualToString:@"Start typing"]) {
             [self saveDataMultiPartForAccomplishment];
        }else{
            [Utility msg:@"Please enter some text" title:@"Alert!" controller:self haveToPop:NO];
        }
    }
}
- (IBAction)btnPreviousMonth:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->calendarContentView loadPreviousPageWithAnimation];
    });
}
- (IBAction)btnNextMonth:(id)sender
{
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
        [defaults setObject:currentDate forKey:@"Date"];
    });
}

- (IBAction)calenderMoreInfoPressed:(UIButton *)sender {
    if([Utility isSquadLiteUser]){
        [Utility showSubscribedAlert:self];
        return;
    }else if([Utility isSquadFreeUser]){
        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }
    
    CalendarViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Calendar"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)headerDateButtonPressed:(UIButton *)sender{
    if (![Utility reachable]) {
        return;
    }
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    
    NSTimeInterval twoWeek = 1*24*60*60;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *endDate = [[formatter dateFromString:[formatter stringFromDate:[NSDate date]]] dateByAddingTimeInterval:twoWeek];
    controller.maxDate = endDate;
    
    NSString *date = [todaysDataDict objectForKey:@"DateOfJoining"];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *joiningDate = [formatter dateFromString:date];
    if (!joiningDate) {
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        joiningDate = [formatter dateFromString:date];
    }
    [formatter setDateFormat:@"yyyy-MM-dd"];
    joiningDate = [formatter dateFromString:[formatter stringFromDate:joiningDate]];
    controller.minDate = joiningDate;
    
    controller.selectedDate = currentDate;
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)notificationSplashOkGotItButtonPressed:(UIButton  *)sender{
    [defaults setBool:true forKey:@"isSpalshShown"];
    notificationSplashView.hidden = true;
    [self promptUserToRegisterPushNotifications];
}
-(IBAction)noDontNeedHelpButtonPressed:(id)sender{
    [defaults setBool:true forKey:@"isSpalshShown"];
    notificationSplashView.hidden = true;
}
-(IBAction)growthPlusButtonPressed:(id)sender{
     dispatch_async(dispatch_get_main_queue(), ^{
         if ([Utility isOnlyProgramMember]) {
//             [Utility showAlertAfterSevenDayTrail:self];
             return;
         }
         AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Achievements"];
         controller.isFromToday = YES;
         controller.todaySelectDate = self->currentDate;
         [self.navigationController pushViewController:controller animated:YES];
     });
}
-(IBAction)gratitudePlusButtonPressed:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
    if ([Utility isOnlyProgramMember]) {
//        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }
     GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GratitudeListView"];
     controller.isFromToday = YES;
     controller.todaySelectDate = self->currentDate;
     [self.navigationController pushViewController:controller animated:YES];
    });
}
-(IBAction)tickuntickPressed:(UIButton*)sender{
    if (![Utility reachable]) {
           return;
       }
    if (![Utility isEmptyCheck:habitArray] && habitArray.count>0) {
        if (![Utility isEmptyCheck:[habitArray objectAtIndex:sender.tag]]) {
            NSDictionary *habitDict = [habitArray objectAtIndex:sender.tag];
            if (![Utility isEmptyCheck:[[habitArray objectAtIndex:sender.tag]objectForKey:@"NewAction"]]) {
                NSDictionary *newActionDict = [[habitArray objectAtIndex:sender.tag]objectForKey:@"NewAction"];
                if (![Utility isEmptyCheck:[newActionDict objectForKey:@"CurrentDayTask"]] && ![Utility isEmptyCheck:[newActionDict objectForKey:@"CurrentDayTask2"]]) {
                    if (twiceDailyCount == 1) {
                        twiceDailyCount = +1;
                        [self webSerViceCall_UpdateTaskStatus:habitDict newAction:[newActionDict objectForKey:@"CurrentDayTask"] with:sender];
                    }else{
                        [self webSerViceCall_UpdateTaskStatus:habitDict newAction:[newActionDict objectForKey:@"CurrentDayTask2"] with:sender];
                    }
                    
                }else if(![Utility isEmptyCheck:[newActionDict objectForKey:@"CurrentDayTask"]] && [Utility isEmptyCheck:[newActionDict objectForKey:@"CurrentDayTask2"]]){
                    [self webSerViceCall_UpdateTaskStatus:habitDict newAction:[newActionDict objectForKey:@"CurrentDayTask"] with:sender];

                }
            }
        }
    }
}
-(IBAction)habitButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:habitArray] && habitArray.count>0) {
        HabitStatsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitStatsView"];
        controller.habitDict = [habitArray objectAtIndex:sender.tag];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(IBAction)addhabitPressed:(id)sender{
    if (![Utility reachable]) {
        return;
    }
       if ([Utility isOnlyProgramMember]) {
//           [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
    HabitHackerListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitHackerListView"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)programsButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:todayHabitCourseList] && ![Utility isEmptyCheck:[todayHabitCourseList objectForKey:@"Courses"]]) {
        NSArray *courseArr =[todayHabitCourseList objectForKey:@"Courses"];
        CourseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetails"];
         controller.courseData = [courseArr objectAtIndex:sender.tag];
         [self.navigationController pushViewController:controller animated:YES];
    }
}
-(IBAction)changePage:(id)sender
{
    //move the scroll view
   
    CGRect frame = mainScroll.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    //    frame.origin.x = frame.size.width * 1;
    [mainScroll scrollRectToVisible:frame animated:YES];
    //scrollViewDidEndDecelerating will turn this off
    pageControlIsChangingPage = YES;
}
-(IBAction)infoCrossPressed:(id)sender{
    infoview.hidden = true;
    [defaults setBool:true forKey:@"isFirstTimeAeroplaneMode"];
}
-(IBAction)infoButtonPressed:(id)sender{
    infoview.hidden = false;
}
-(IBAction)saveShareButtonPressed:(id)sender{
     if (![Utility isEmptyCheck:gratitudetextView.text] && gratitudetextView.text.length>0 && ![gratitudetextView.text isEqualToString:@"Start typing"]) {
         if ([gratitudetextView.text isEqualToString:[todayGratitudeDict objectForKey:@"Name"]]) {
             [self.view endEditing:YES];
             self->shareDict = todayGratitudeDict;
             self->showPicTypeView.hidden = false;
         }else{
             isTrueShare = true;
             [self saveDataMultiPart];
         }
     }else{
         [Utility msg:@"Please enter some text" title:@"Alert!" controller:self haveToPop:NO];
     }
}
-(IBAction)shareDetailsPressed:(UIButton*)sender{
    self->showPicTypeView.hidden = true;
    GratitudePopUpViewController *controller =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudePopUpView"];
                                                controller.modalPresentationStyle = UIModalPresentationCustom;
                                                controller.controller = self;
                                                controller.dict = shareDict;
                                                if (sender.tag == 0) {
                                                    controller.type = @"TextWithPic";
                                                }else if(sender.tag == 1){
                                                    controller.type = @"TextOverPic";
                                                }else{
                                                    controller.type = @"";
                                                }
                                              [self presentViewController:controller animated:YES completion:nil];
    }
-(IBAction)crossShareButtonPresssed:(id)sender{
    showPicTypeView.hidden = true;
}
-(IBAction)seeExamplePressed:(UIButton*)sender{
    seeExampleView.hidden = false;
    if (sender.tag == 0) {
        seeExampleImage.image = [UIImage imageNamed:@"textandpic.png"];
    }else if(sender.tag == 1){
        seeExampleImage.image = [UIImage imageNamed:@"textoverpic.png"];
    }else{
        seeExampleImage.image = [UIImage imageNamed:@"textonly.png"];
    }
}
-(IBAction)exampleCrossButtonPressed:(id)sender{
    seeExampleView.hidden = true;
}
#pragma mark -End

#pragma mark -Private Method

-(void)backFromNotesPressed:(NSNotification*)notification{
    isBackFromNotes = true;
}
-(void)getOfflineData{
    int userId = [[defaults objectForKey:@"UserID"] intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
        if([DBQuery isRowExist:@"gratitudeAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and CreatedDateStr = '%@'",[NSNumber numberWithInt:userId],currentDateStr]]){
           DAOReader *dbObject = [DAOReader sharedInstance];
            if([dbObject connectionStart]){
                NSArray *gratitudearr = [dbObject selectBy:@"gratitudeAddList" withColumn:[[NSArray alloc]initWithObjects:@"id",@"UserId",@"GratitudeList",@"CreatedDateStr",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@' and CreatedDateStr = '%@'",[NSNumber numberWithInt:userId],currentDateStr]];
                    
                    NSDictionary *fisrtObject = [gratitudearr firstObject];
                    NSString *str = fisrtObject[@"GratitudeList"];  //[@"GratitudeList"]
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:dataDict];
                    [dict setObject:fisrtObject[@"id"] forKey:@"rowId"];
                
                    if(![Utility isEmptyCheck:dict]){
                       [self setUpgratitude:dict];
                    }
//                    if ([Utility isEmptyCheck:[dict objectForKey:@"Details"]]) {
//                        [self setUpgratitude:dict];
//                    }else{
//                         [self setUpgratitude:[dict objectForKey:@"Details"]];
//                    }
                     [dbObject connectionEnd];
            }
        }else{
            self->gratitudetextView.text = @"Start typing";
        }

    
}
-(void)getOfflineDataForGrowth{
     int userId = [[defaults objectForKey:@"UserID"] intValue];
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setDateFormat:@"yyyy-MM-dd"];
     NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    if([DBQuery isRowExist:@"growthAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and CreatedDateStr = '%@'",[NSNumber numberWithInt:userId],currentDateStr]]){
        DAOReader *dbObject = [DAOReader sharedInstance];
         if([dbObject connectionStart]){
             
             NSArray *growtharr = [dbObject selectBy:@"growthAddList" withColumn:[[NSArray alloc]initWithObjects:@"id",@"UserId",@"GrowthList",@"CreatedDateStr",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@' and CreatedDateStr = '%@'",[NSNumber numberWithInt:userId],currentDateStr]];
               //GrowthList
             NSDictionary *fisrtObject = [growtharr firstObject];
             NSString *str = fisrtObject[@"GrowthList"];  //[@"GratitudeList"]
             NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:dataDict];
             [dict setObject:fisrtObject[@"id"] forKey:@"rowId"];
             if(![Utility isEmptyCheck:dict]){
                [self setUpGrowth:dict];
             }
             
             
//             if ([Utility isEmptyCheck:[dict objectForKey:@"Details"]]) {
//                 [self setUpGrowth:dict];
//             }else{
//                 [self setUpGrowth:[dict objectForKey:@"Details"]];
//             }
              [dbObject connectionEnd];
             }
    }else{
        self->accomplishtextView.text= @"Start typing";
        [self->growthButton setTitle:@"My journal entry is:" forState:UIControlStateNormal];//Today I accomplished:
    }

        
}
-(void)getOfflineDataForHabitCourse{
    
    int userId = [[defaults objectForKey:@"UserID"] intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
        if([DBQuery isRowExist:@"todayGetGrowthDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and AddedDate = '%@'",[NSNumber numberWithInt:userId],currentDateStr]]){
           DAOReader *dbObject = [DAOReader sharedInstance];
            if([dbObject connectionStart]){
                NSArray *todayHabitCoursearr = [dbObject selectBy:@"todayGetGrowthDetails" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"AddedDate",@"TodayData",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@' and AddedDate = '%@'",[NSNumber numberWithInt:userId],currentDateStr]];
                    NSString *str = todayHabitCoursearr[0][@"TodayData"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    todayHabitCourseList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    [self setUpHabitDetails:todayHabitCourseList];
                    [self setUpCourse:todayHabitCourseList];
                    if ([Utility isEmptyCheck:gratitudetextView.text] || [gratitudetextView.text isEqualToString:@"Start typing"]) {
                        [self setUpgratitude:[todayHabitCourseList objectForKey:@"Gratitude"]];
                    }
                    if ([Utility isEmptyCheck:accomplishtextView.text] || [accomplishtextView.text isEqualToString:@"Start typing"]) {
                        [self setUpGrowth:[todayHabitCourseList objectForKey:@"Growth"]];
                    }
                    
                    [dbObject connectionEnd];
            }
        }else{
            if([Utility reachable]){
                [self webServicecallForGetGrowthHomePage:currentDate];
            }else{
                [self getOfflineData];
                [self getOfflineDataForGrowth];
            }
            
        }
    
}

-(void)setUpHabitDetails:(NSDictionary*)todayDict{
    if (![Utility isEmptyCheck:todayDict] && ![Utility isEmptyCheck:[todayDict objectForKey:@"Habits"]]) {
        habitArray = [todayDict objectForKey:@"Habits"];
        if (!(habitArray.count>0)) {
            addButtonShowView.hidden = false;
            habitTable.hidden = true;
        }else{
            addButtonShowView.hidden = true;
            habitTable.hidden = false;
        }
        [habitTable reloadData];
        /*
        int habitCount ;
        if (habitArray.count>3) {
            habitCount = 3;
        }else{
            habitCount = (int)habitArray.count;
        }
        for (int i = 0;i<habitCount;i++) {
            UIButton *button = habitCheckUncheckButton[i];
            button.hidden = false;
            UILabel *percentageLabel = habitPercentagelabel[i];
            percentageLabel.hidden = false;
        }
        
        for (int i =0;i <habitCount;i++){
            UILabel *habitNamelabel = habitNameLabel[i];
            habitNamelabel.text = [[habitArray objectAtIndex:habitNamelabel.tag]objectForKey:@"HabitName"];
        }
    for (int i =0;i<habitCount;i++){
        UIButton *checkUncheckButton = habitCheckUncheckButton[i];
        if (![Utility isEmptyCheck:[[habitArray objectAtIndex:checkUncheckButton.tag]objectForKey:@"NewAction"]]) {
                NSDictionary *newDict = [[habitArray objectAtIndex:checkUncheckButton.tag]objectForKey:@"NewAction"];
                if ((![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask"]]) && ![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask2"]]) {
                    checkUncheckButton.userInteractionEnabled = true;
                    checkUncheckButton.alpha = 1;
                    NSDictionary *currentTaskDict = [newDict objectForKey:@"CurrentDayTask"];
                    NSDictionary *currentTaskDict1 = [newDict objectForKey:@"CurrentDayTask2"];
            
                   if ([[currentTaskDict objectForKey:@"IsDone"]boolValue] && [[currentTaskDict1 objectForKey:@"IsDone"]boolValue]) {
                       [checkUncheckButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
                   }else if([[currentTaskDict objectForKey:@"IsDone"]boolValue] || [[currentTaskDict1 objectForKey:@"IsDone"]boolValue]){
                       [checkUncheckButton setImage:[UIImage imageNamed:@"half_circle.png"] forState:UIControlStateNormal];
                   }else{
                       [checkUncheckButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
                   }
               } else if ((![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask"]])) {
                    checkUncheckButton.userInteractionEnabled = true;
                    checkUncheckButton.alpha = 1;
                    NSDictionary *currentDayTask = [newDict objectForKey:@"CurrentDayTask"];
                   
                   if ([[currentDayTask objectForKey:@"IsDone"]boolValue]) {
                       [checkUncheckButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
                   }else{
                       [checkUncheckButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
                   }
               }else if(![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask2"]]){
                   checkUncheckButton.userInteractionEnabled = true;
                   checkUncheckButton.alpha = 1;
                   NSDictionary *currentDayTask = [newDict objectForKey:@"CurrentDayTask2"];
                  
                   if ([[currentDayTask objectForKey:@"IsDone"]boolValue]) {
                       [checkUncheckButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
                   }else{
                       [checkUncheckButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
                   }
               }else{
                     [checkUncheckButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
                      checkUncheckButton.userInteractionEnabled = false;
                      checkUncheckButton.alpha = 0.5;
                    }
                }
            }
        for (int i = 0;i<habitCount;i++) {
            UILabel *percentagelabel = habitPercentagelabel[i];
                if (![Utility isEmptyCheck:[[habitArray objectAtIndex:percentagelabel.tag]objectForKey:@"NewAction"]]) {
                    NSDictionary *newDict = [[habitArray objectAtIndex:percentagelabel.tag]objectForKey:@"NewAction"];
                    percentagelabel.text = [NSString stringWithFormat:@"%.0f%%", [[newDict objectForKey:@"OverallPerformance"]floatValue]];
                }else{
                    percentagelabel.text = @"";
                }
            }
        }else{
             for (int i = 0;i<3;i++) {
                 UIButton *button = habitCheckUncheckButton[i];
                 button.hidden = true;
                 UILabel *percentageLabel = habitPercentagelabel[i];
                 percentageLabel.hidden = true;
             }
        
         */
    }else{
        addButtonShowView.hidden = false;
        habitTable.hidden = true;
    }
}
-(void)setUpCourse:(NSDictionary*)todayDict{
    if (![Utility isEmptyCheck:todayDict] && ![Utility isEmptyCheck:[todayDict objectForKey:@"Courses"]]) {
        NSArray *coursesArr = [todayDict objectForKey:@"Courses"];
        int totalCount;
        if (coursesArr.count>3) {
            totalCount = 3;
        }else{
            totalCount = (int)coursesArr.count;
        }
        for (int i = 0; i<totalCount; i++) {
            UIButton *button = programButton[i];
            button.hidden = false;
            UILabel *percentagelable = coursePercentageLabel[i];
            percentagelable.hidden = false;
        }
        for (int i = 0; i<totalCount; i++) {
            UILabel *label = courseNameLabel[i];
            label.text = [[coursesArr objectAtIndex:label.tag]objectForKey:@"CourseName"];
            UIButton *button = programButton[i];
            button.hidden = false;
        }
        for (int i = 0; i<totalCount; i++) {
            UILabel *label = coursePercentageLabel[i];
            int totalarticleCount = [[[coursesArr objectAtIndex:label.tag]objectForKey:@"TotalArticlesReleased"] intValue];
            int articleRead = [[[coursesArr objectAtIndex:label.tag]objectForKey:@"UserCourseArticleRead"] intValue];
            float articlevalue = (articleRead*100);
            label.text = [@"" stringByAppendingFormat:@"%d%%",(int)floor(articlevalue/totalarticleCount)];
        }
    }else{
          for (int i = 0; i<3; i++) {
              UIButton *button = programButton[i];
              button.hidden = true;
              UILabel *percentagelable = coursePercentageLabel[i];
              percentagelable.hidden = true;
          }
    }
}

-(void)setUpGrowth:(NSDictionary*)achievementsDict{
          if (![Utility isEmptyCheck:achievementsDict]) {
              todayAchieveDict = [achievementsDict mutableCopy];
              NSArray *splitArr = [[achievementsDict objectForKey:@"Achievement"] componentsSeparatedByString:@":"];
              if (splitArr.count>=2) {
                  if (![Utility isEmptyCheck:[splitArr objectAtIndex:1]]) {
                      self->accomplishtextView.text =[@"" stringByAppendingFormat:@"%@",[splitArr objectAtIndex:1]];
                  }
                  if (![Utility isEmptyCheck:[splitArr objectAtIndex:0]]) {
                      [self->growthButton setTitle:[@"" stringByAppendingFormat:@"%@:",[splitArr objectAtIndex:0]] forState:UIControlStateNormal];
                  }
              }else{
                  [self->growthButton setTitle:@"My journal entry is:" forState:UIControlStateNormal];//Today I accomplished:
                  self->accomplishtextView.text= @"Start typing";

              }
              
          }else{
              [self getOfflineDataForGrowth];
              
          }
            [self prepareMbhqView];
      }


-(void)setUpgratitude:(NSDictionary*)todayDict{
          if (![Utility isEmptyCheck:todayDict]) {
              todayGratitudeDict = [todayDict mutableCopy];
              
              NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:[todayDict objectForKey:@"Name"]];
              NSArray *splitArr = [[todayDict objectForKey:@"Name"] componentsSeparatedByString:@":"];
              if (splitArr.count>1) {
                  NSRange foundRange1 = [text1.mutableString rangeOfString:[splitArr objectAtIndex:0]];
                  
                  NSDictionary *attrDict1 = @{
                                              NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:19.0],
                                              NSForegroundColorAttributeName : [Utility colorWithHexString:@"41515C"]
                                              
                                              };
                  [text1 addAttributes:attrDict1 range:NSMakeRange(0, text1.length)];
                  [text1 addAttributes:@{
                                         NSFontAttributeName : [UIFont fontWithName:@"Raleway-Bold" size:19.0]
                                         
                                         }
                                 range:foundRange1];
                  self->gratitudetextView.attributedText = text1;
              }else{
                 
                  self->gratitudetextView.text = [todayDict objectForKey:@"Name"];
              }
              
          }
          else{
              [self getOfflineData];
              
          }
            [self prepareMbhqView];
}
-(void)prepareMbhqView{
    [[NSNotificationCenter defaultCenter] addObserverForName:@"didBecomeActive" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        [self gratitudeSaveShowHide:false];
        [self accomplishSaveShowHide:false];

    }];
    [self gratitudeSaveShowHide:false];
    [self accomplishSaveShowHide:false];

    for (UIButton *btn in gratitudeListButton) {
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        if (btn.tag == 1 || btn.tag == 2) {
            btn.layer.borderColor = [Utility colorWithHexString:mbhqBaseColor].CGColor;
            btn.layer.borderWidth = 1;
        }
    }
   
    habitListButton.layer.cornerRadius = 15;
    habitListButton.layer.masksToBounds = YES;
    habitListButton.layer.borderColor = squadMainColor.CGColor;
    habitListButton.layer.borderWidth = 1;
    
    gotItButton.layer.cornerRadius = 15;
    gotItButton.layer.masksToBounds = YES;
    
    if ([Utility isEmptyCheck:gratitudetextView.text] || [gratitudetextView.text isEqualToString:@"Start typing"]) {
        gratitudetextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:0.5];
        gratitudetextView.text = @"Start typing";
        [Utility setTheCursorPosition:gratitudetextView];
    }else{
        gratitudetextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
        [Utility removeCursor:gratitudetextView];

    }
    if ([Utility isEmptyCheck:accomplishtextView.text] || [accomplishtextView.text isEqualToString:@"Start typing"]) {
        accomplishtextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:0.5];
        accomplishtextView.text = @"Start typing";
        [Utility setTheCursorPosition:accomplishtextView];
    }else{
        accomplishtextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
        [Utility removeCursor:accomplishtextView];
    }
        pageControl.currentPage = 0;
        pageControl.numberOfPages = 2;
    
    if (!isShowSave) {
//        for (UIButton *btn in gratitudeListButton) {
//            if (btn.tag == 11 || btn.tag == 12 || btn.tag == 13) {
//                 btn.hidden = true;
//                if ([Utility reachable]) {
//                    gratitudeHeightConstant.constant = 40;
//                    accomplishmentHeightConstant.constant = 40;
//                }else{
//                    gratitudeHeightConstant.constant = 0;
//                    accomplishmentHeightConstant.constant = 0;
//
//                }
//            }
//        }
    }
    if (_isFromHabit) {
           pageControl.currentPage = 1;
           [self changePage:0];
       }
}
-(NSDictionary*)setUpGratitudeDetails{
    NSMutableDictionary *gratitudeData;
     if ([Utility isEmptyCheck:todayGratitudeDict]) {
         gratitudeData = [[NSMutableDictionary alloc]init];
     }else{
         gratitudeData = [todayGratitudeDict mutableCopy];
     }
    
     [gratitudeData setObject:gratitudetextView.text forKey:@"Name"];//Today I am grateful for:
     [gratitudeData setObject:@"" forKey:@"Description"];//savehtmlTextForGratitude
     
     if ([gratitudeData objectForKey:@"FrequencyId"] == nil) {
         [gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
         [gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
         [gratitudeData setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt1"];
         [gratitudeData setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt2"];
         [gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
         [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
         [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
         
         NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
         NSArray* monthArray = [newDateformatter monthSymbols];
         NSArray* dayArray = [newDateformatter weekdaySymbols];
         for (int i = 0; i < monthArray.count; i++) {
             [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:i]];
         }
         for (int i = 0; i < dayArray.count; i++) {
             [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
         }
     }
     if (gratitudeData[@"Id"] == nil) {
         [gratitudeData setObject:[NSNumber numberWithInteger:0] forKey:@"Id"];
     }
     if (gratitudeData[@"CreatedBy"] == nil) {
         [gratitudeData setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
     }
     
     [gratitudeData setObject:@"" forKey:@"UploadPictureImgBase64"];
     NSDateFormatter *format = [[NSDateFormatter alloc]init];
     [format setDateFormat:@"YYYY-MM-dd"];
     [gratitudeData setObject:[format stringFromDate:currentDate] forKey:@"CreatedAtString"];
    return [gratitudeData mutableCopy];
}

-(NSDictionary*)setUpGrowthDetails{
    NSMutableDictionary *achievementsData;
       if ([Utility isEmptyCheck:todayAchieveDict]) {
           achievementsData = [[NSMutableDictionary alloc]init];
       }else{
           achievementsData = [todayAchieveDict mutableCopy];
       }
           NSString *str = growthButton.titleLabel.text;
           if (![str isEqualToString:@"My journal entry is:"]) {//Today I accomplished:
               [achievementsData setObject:[@"" stringByAppendingFormat:@"%@%@",growthButton.titleLabel.text, accomplishtextView.text] forKey:@"Achievement"];
           }else{
               [achievementsData setObject:[@"" stringByAppendingFormat:@"%@", accomplishtextView.text] forKey:@"Achievement"];
           }
               [achievementsData setObject:@"" forKey:@"Notes"];//savehtmlTextForAccomplishment
           if ([achievementsData objectForKey:@"FrequencyId"] == nil) {
               [achievementsData setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
               [achievementsData setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
               [achievementsData setObject:[NSNumber numberWithInt:12] forKey:@"ReminderAt1"];
               [achievementsData setObject:[NSNumber numberWithInt:12] forKey:@"ReminderAt2"];
               [achievementsData setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
               [achievementsData setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
               [achievementsData setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
               
               NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
               NSArray* monthArray = [newDateformatter monthSymbols];
               NSArray* dayArray = [newDateformatter weekdaySymbols];
               for (int i = 0; i < monthArray.count; i++) {
                   [achievementsData setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:i]];
               }
               for (int i = 0; i < dayArray.count; i++) {
                   [achievementsData setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
               }
           }
           if (achievementsData[@"Id"] == nil) {
               [achievementsData setObject:[NSNumber numberWithInteger:0] forKey:@"Id"];
           }
           if (achievementsData[@"CreatedBy"] == nil) {
               [achievementsData setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
           }
           [achievementsData setObject:@"" forKey:@"UploadPictureImgBase64"];
           NSDateFormatter *format = [[NSDateFormatter alloc]init];
           [format setDateFormat:@"YYYY-MM-dd"];
           [achievementsData setObject:[format stringFromDate:currentDate] forKey:@"CreatedAtString"];
    return [achievementsData mutableCopy];
}

-(void)isTextChanged:(BOOL)value{
    
}
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
//    [Utility setTheCursorPosition:gratitudetextView];
//    [Utility setTheCursorPosition:accomplishtextView];
}


-(void)getAppHomePageValues:(NSDate *)currentDate{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
            
            self->loadingView.hidden = false;
            [self.view bringSubviewToFront:self->loadingView];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"SquadUserId"];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [mainDict setObject:[formatter stringFromDate:currentDate] forKey:@"DateFor"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetAppHomePageValues" append:@""forAction:@"POST"];
        NSURLSessionDataTask *dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount==0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if (self->apiCount == 0) {
                                                                     self->loadingView.hidden = true;
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self updateView:responseDict];
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
-(void)updateView:(NSDictionary *)responseDict{
    
}
-(int)getPercerntageOfDone:(int)doneCount total:(int)totalCount{
    if (doneCount == 0 && totalCount == 0) {
        return 0;
    }else{
        return (100 * doneCount)/totalCount;
    }
}

-(NSString *)getMass:(NSString *)myDistance{//kg to lb
    NSString *calcDistance = @"";
    if (![Utility isEmptyCheck:[defaults objectForKey:@"UnitPreference"]] && [[defaults objectForKey:@"UnitPreference"]intValue] == 2) {//imperial
        float convDistance = [myDistance floatValue];
        convDistance *= 2.20462;
        calcDistance = [NSString stringWithFormat:@"%.02f",convDistance];
    } else {//metric
        calcDistance = myDistance;
    }
    return calcDistance;
}

-(NSString *)getLength:(NSString *)myDistance{//cm to inches
    NSString *calcDistance = @"";
    if (![Utility isEmptyCheck:[defaults objectForKey:@"UnitPreference"]] && [[defaults objectForKey:@"UnitPreference"]intValue] == 2) {//imperial
        float convDistance = [myDistance floatValue];
        convDistance *= 0.393701;
        calcDistance = [NSString stringWithFormat:@"%.02f",convDistance];
        
    } else {//metric
        calcDistance = myDistance;
    }
    return calcDistance;
}

-(void)togglePersonalChallengeTask:(NSMutableArray *)tId{
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        //        [mainDict setObject:tId forKey:@"Id"];
        [mainDict setObject:tId forKey:@"TaskId"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"TogglePersonalChallengeTask" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 //                                                                 self->apiCount--;
                                                                 if (self->contentView){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
//                                                                         [self getAppHomePageValues:self->currentDate];
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
-(void)getEventDetailsByID:(NSDictionary *)eventDetails{
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
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[eventDetails objectForKey:@"EventItemID"] forKey:@"EventID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetEventDetailsByIDApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         dispatch_async(dispatch_get_main_queue(),^ {
                                                                             WebinarSelectedViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarSelectedView"];
                                                                             controller.webinar = [responseDictionary mutableCopy];
                                                                             if ([[eventDetails objectForKey:@"IsUpcoming"] boolValue]) {
                                                                                 controller.upcomingWebinarsData = eventDetails;
                                                                             }
                                                                             [self.navigationController pushViewController:controller animated:YES];
                                                                         });
                                                                         
                                                                     }else{
                                                                         [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                                                                         return;
                                                                         
                                                                     }
                                                                     
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                             
                                                         }];
        [dataTask resume];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
            return;
        });
        
    }
}

-(void)promptUserToRegisterPushNotifications{
    UIApplication *application = [UIApplication sharedApplication];
    /* if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
     UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert
     | UIUserNotificationTypeBadge
     | UIUserNotificationTypeSound) categories:nil];
     [application registerUserNotificationSettings:settings];
     }*/
    
    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = appDelegate;
            
            
#endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // [END register_for_notifications]
    }
}
-(void)nofictiactionPermission{
    BOOL isNotificationEnable = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    
    if (![defaults boolForKey:@"isSpalshShown"]) { // && [defaults boolForKey:@"HasTrialAvail"]
        if(!isNotificationEnable){
            notificationSplashView.hidden = false;
        }
    }else{
        notificationSplashView.hidden = true;
        if(!isNotificationEnable )[self promptUserToRegisterPushNotifications]; //&& [defaults boolForKey:@"HasTrialAvail"]
    }
}
-(void)gratitudeSaveShowHide:(BOOL)isshow{
    if (isshow) {
        for (UIButton *btn in gratitudeListButton) {
            if (btn.tag == 11)
                btn.hidden = false;
                if (btn.tag == 13) {
                    if ([Utility reachable]) {
                        btn.hidden = false;
                        gratitudeHeightConstant.constant = 130;

                    }else{
                      
                        btn.hidden = true;
                        gratitudeHeightConstant.constant = 37;

                    }
                }
                    if (btn.tag == 1 || btn.tag == 2) {
                        if ([Utility reachable]) {
                            btn.hidden = false;
                        }else{
                            btn.hidden = true;
                        }
                    }
        }
    }else{
        for (UIButton *btn in gratitudeListButton) {
            if ([Utility reachable]) {
                if (btn.tag == 11 || btn.tag == 13 || btn.tag == 12){
                    btn.hidden = true;
                }else{
                    btn.hidden = false;
                }
            }else{
                btn.hidden = true;
            }
          
            if ([Utility reachable]) {
                gratitudeHeightConstant.constant = 40;
            }else{
                gratitudeHeightConstant.constant = 0;

            }
        }
    }
    
}
-(void)accomplishSaveShowHide:(BOOL)isshow{
    if (isshow) {
        for (UIButton *btn in gratitudeListButton) {
            if (btn.tag == 12)
                btn.hidden = false;
            accomplishmentHeightConstant.constant = 80;
        }
    }else{
        for (UIButton *btn in gratitudeListButton) {
            if (btn.tag == 12)
                btn.hidden = true;
            accomplishmentHeightConstant.constant = 40;
        }
    }
    
}

-(void)saveDataMultiPartForAccomplishment{
    if (Utility.reachable) {
        NSDictionary * achievementsData = [self setUpGrowthDetails];
        NSError *error;
        [self accomplishSaveShowHide:false];
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:achievementsData forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateReverseBucketApiCallWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.chosenImage=nil;
        controller.isFromtodayGetApiName = true;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        NSDictionary *growthdata = [self setUpGrowthDetails];
        [self addUpdateDBForGrowth:growthdata];
    }
    
}
-(void)addUpdateDBForGrowth:(NSDictionary*)dict{
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
    
    int userId = [[defaults valueForKey:@"UserID"] intValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *addedDateStr = [formatter stringFromDate:[NSDate date]];
    int rowId = 0;
    if(![Utility isEmptyCheck:dict[@"rowId"]]){
        rowId = [dict[@"rowId"] intValue];
    }
    
    
    BOOL isAdd = false;
    
    if(rowId>0){
        DAOReader *dbObject = [DAOReader sharedInstance];
        
        if([dbObject connectionStart]){
            NSMutableString *modifiedGratitudeDetails = [NSMutableString stringWithString:detailsString];
            [modifiedGratitudeDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedGratitudeDetails length])];
            //        NSString *date = [NSDate date].description;
            
            NSArray *columnArray = [[NSArray alloc]initWithObjects:@"GrowthList",@"isSync",nil];
            NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedGratitudeDetails,[NSNumber numberWithInt:0],nil];
            
            isAdd = [dbObject updateWithCondition:@"growthAddList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"Id ='%d'",rowId]];
             [dbObject connectionEnd];
        }
        
    }else if([DBQuery isRowExist:@"growthAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and AchivementId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:[[dict objectForKey:@"Id"]intValue]]]]){
        isAdd = [DBQuery updateGrowthDetails:[[dict objectForKey:@"Id"]intValue] with:detailsString UpdateDate:addedDateStr with:0];
    }else{
        isAdd = [DBQuery addGrowthDetails:[[dict objectForKey:@"Id"]intValue] with:detailsString addedDate:addedDateStr isSync:0];
    }
    if (isAdd) {
        [self showSuccessAlertForGrowth];
    }
         [self accomplishSaveShowHide:false];
    
    [self getOfflineDataForHabitCourse];
}

-(void)saveDataMultiPart{
    if (Utility.reachable) {
        NSDictionary *gratitudeData = [self setUpGratitudeDetails];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:gratitudeData forKey:@"model"];
        
      
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        [self gratitudeSaveShowHide:false];
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateGratitudeApiCallWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.chosenImage=nil;
        controller.isFromtodayGetApiName = true;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        NSDictionary *gratitudedata = [self setUpGratitudeDetails];
        [self addUpdateDB:gratitudedata];
    }
    
}
-(void)addUpdateDB:(NSDictionary*)dict{
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
    
    int userId = [[defaults valueForKey:@"UserID"] intValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *addedDateStr = [formatter stringFromDate:[NSDate date]];
    
    int rowId = 0;
    if(![Utility isEmptyCheck:dict[@"rowId"]]){
        rowId = [dict[@"rowId"] intValue];
    }
    
    
    BOOL isAdd = false;
    
    if(rowId>0){
        DAOReader *dbObject = [DAOReader sharedInstance];
        
        if([dbObject connectionStart]){
            NSMutableString *modifiedGratitudeDetails = [NSMutableString stringWithString:detailsString];
            [modifiedGratitudeDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedGratitudeDetails length])];
            //        NSString *date = [NSDate date].description;
            
            NSArray *columnArray = [[NSArray alloc]initWithObjects:@"gratitudeList",@"isSync",nil];
            NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedGratitudeDetails,[NSNumber numberWithInt:0],nil];
            
            isAdd = [dbObject updateWithCondition:@"gratitudeAddList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"Id ='%d'",rowId]];
             [dbObject connectionEnd];
        }
        
    }else if([DBQuery isRowExist:@"gratitudeAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and GratitudeId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:[[dict objectForKey:@"Id"]intValue]]]]){
        isAdd = [DBQuery updateGratitudeDetailsUsingGratitudeID:[[dict objectForKey:@"Id"]intValue] with:detailsString UpdateDate:addedDateStr with:0];
    }else{
        isAdd = [DBQuery addGratitudeDetails:[[dict objectForKey:@"Id"]intValue] with:detailsString addedDate:addedDateStr isSync:0];
    }
    if (isAdd) {
        [self showSuccessAlert];
    }
        [self gratitudeSaveShowHide:false];
    [self getOfflineDataForHabitCourse];

}

-(void)showSuccessAlert{
    NSString *msgStr = @"Your gratitude was saved.\nPlease note: Your 1st gratitude for the day will be visible on the today page in aeroplane mode. Extra gratitudes will be only visible once 'aeroplane' mode is turned off.";
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"SUCCESS\n"
                                          message:msgStr
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                               }];
    
    
    [alertController addAction:okAction];
   
    
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)showSuccessAlertForGrowth{
    NSString *msgStr = @"Your growth was saved.\nPlease note:Your 1st growth for the day will be visible on the today page in aeroplane mode. Extra growth will be only visible once 'aeroplane' mode is turned off";
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"SUCCESS\n"
                                          message:msgStr
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                               }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)webcellCall_GetUserHabitList{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"status"];
        [mainDict setObject:[NSNumber numberWithInt:1] forKey:@"OrderBy"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SearchUserHabitSwaps" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                             if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"HabitSwaps"]]) {
                                                                                 self->habitListArray = [responseDictionary objectForKey:@"HabitSwaps"];
                                                                                 [self setUpReminder];
                                                                             }else{
                                                                             }
//
                                                                         }else{
//                                                                             [Utility msg:responseDictionary[@"ErrorMessage"] title:@"Oops! " controller:self haveToPop:NO];
//                                                                             return;
                                                                         }
                                                                     }else{
//                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
//                                                                         return;
                                                                     }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
-(void)setUpReminder{
   NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *req in requests) {
        NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
        if ([pushTo caseInsensitiveCompare:@"HabitList"] == NSOrderedSame) {
            [[UIApplication sharedApplication] cancelLocalNotification:req];
            
        }
    }
    
    for (int i = 0; i < habitListArray.count; i++) {
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[habitListArray objectAtIndex:i]];
        if ([[[dict objectForKey:@"NewAction"]objectForKey:@"PushNotification"] boolValue]) {
            NSMutableDictionary *extraDict = [NSMutableDictionary new];
            [extraDict setObject:[dict objectForKey:@"HabitId"] forKey:@"HabitId"];
            [SetReminderViewController setOldLocalNotificationFromDictionary:[[dict objectForKey:@"NewAction"] mutableCopy] ExtraData:extraDict FromController:(NSString *)@"HabitList" Title:[dict objectForKey:@"HabitName"] Type:@"HabitList" Id:[[dict objectForKey:@"HabitId"] intValue]];
        }
    }
}
-(void)webServicecallForGetGrowthHomePage:(NSDate*)currentdate{
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
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [mainDict setObject:[formatter stringFromDate:currentdate] forKey:@"ForDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetGrowthHomePage" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
//                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                                                       NSMutableDictionary *responseDict = [responseDictionary mutableCopy];
//                                                                       [responseDict removeObjectForKey:@"Courses"];
                                                                       if(![Utility isEmptyCheck:responseDictionary]){
                                                                           NSError *error;
                                                                           NSData *todayData = [NSJSONSerialization dataWithJSONObject:responseDictionary options:NSJSONWritingPrettyPrinted  error:&error];
                                                                           if (error) {
                                                                               NSLog(@"Error Favorite Array-%@",error.debugDescription);
                                                                           }
                                                                           
                                                                           NSString *detailsString = [[NSString alloc] initWithData:todayData encoding:NSUTF8StringEncoding];
                                                                       
                                                                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                        [formatter setDateFormat:@"yyyy-MM-dd"];
                                                                           NSString *currentDateStr = [formatter stringFromDate:self->currentDate];
                                                                           int userId = [[defaults objectForKey:@"UserID"] intValue];
                                                                           if([DBQuery isRowExist:@"todayGetGrowthDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and AddedDate = '%@'",[NSNumber numberWithInt:userId],currentDateStr]]){
                                                                                [DBQuery updateTodayGrwothDetails:detailsString With:currentDateStr];
                                                                            }else{
                                                                                [DBQuery addTodayGrwothDetails:detailsString with:currentDateStr];
                                                                             }
                                                                          
                                                                                [self setUpHabitDetails:responseDictionary];
                                                                                [self setUpCourse:responseDictionary];
                                                                                [self setUpgratitude:[responseDictionary objectForKey:@"Gratitude"]];
                                                                                [self setUpGrowth:[responseDictionary objectForKey:@"Growth"]];
                                                                           
                                                                            if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"Gratitude"]] || ![Utility isEmptyCheck:[responseDictionary objectForKey:@"Growth"]]) {
                                                                                if (self->_isMoveToday) {
                                                                                    self->_isMoveToday = false;
                                                                                    GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                                                                                    [self.navigationController pushViewController:controller animated:NO];
                                                                                    
                                                                                }
                                                                            }
                                                                       }
                                                                       
                                                                   }else{
                                                                       [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                   }
                                                               });
                                                           }];
        [dataTask resume];
        
    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        [self getOfflineData];
        [self getOfflineDataForGrowth];
    }
    
}

-(void)webSerViceCall_UpdateTaskStatus:(NSDictionary*)dict newAction:(NSDictionary*)newActionDict with:(UIButton *)sender{
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
        [mainDict setObject:[newActionDict objectForKey:@"TaskMasterId"] forKey:@"TaskId"];
        if ([[newActionDict objectForKey:@"IsTaskDone"]boolValue]) {
            [mainDict setObject:[NSNumber numberWithBool:false] forKey:@"IsDone"];
        }else{
            [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateTaskStatusForHabit" append:@""forAction:@"POST"];
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
                                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"IsHackerListReload" object:self userInfo:nil];
                                                                         [DBQuery updateHabitColumn:[[dict objectForKey:@"HabitId"]intValue] with:1];
                                                                         [self webServicecallForGetGrowthHomePage:self->currentDate];
                                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"IsHackerListReload" object:self userInfo:nil];

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

#pragma mark -End

#pragma mark -CollectionView Delegate & Datasource


#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    //restriction for current month only
//    if([calendarManager.dateHelper date:date isEqualOrAfter:[NSDate date]]){
//        return NO;
//    } else if([calendarManager.dateHelper date:date isEqualOrBefore:[NSDate date]]){
//        return NO;
//    }
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
    // Today
    if([calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor whiteColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor blackColor];
        dayView.layer.borderColor = [UIColor blackColor].CGColor;
        dayView.layer.borderWidth = 1.0f;
    }
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
    // Other month
    else if(![calendarManager.dateHelper date:calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
        dayView.layer.borderWidth = 0.0f;
    }
    
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.textLabel.textColor = [UIColor blackColor];
        dayView.layer.borderWidth = 0.0f;
    }
    //    UIImageView *i = [[UIImageView alloc]initWithFrame:dayView.circleView.bounds];
    //    i.image = [UIImage imageNamed:@"tick_circle.png"];
    //    [dayView.circleView addSubview:i];
    //    i.center = dayView.circleView.center;
    
    if (upcomingEvents.count>0){
        NSCalendar* tempCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [tempCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dayView.date];
        NSString *key=[@"" stringByAppendingFormat:@"%d-%02d",(int)[components year],(int)[components month]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Date beginswith[c] %@", key];
        NSArray *filteredArray = [upcomingEvents filteredArrayUsingPredicate:predicate];
        if (![Utility isEmptyCheck:filteredArray]) {
            for (int i = 0; i< filteredArray.count; i++) {
                NSArray *eventSubArray = [[filteredArray objectAtIndex:i] valueForKey:@"Events"];
                NSString *key=[@"" stringByAppendingFormat:@"%d-%02d-%02d",(int)[components year],(int)[components month],(int)[components day]];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"StartDate beginswith[c] %@", key];
                NSArray *filteredArray1 = [eventSubArray filteredArrayUsingPredicate:predicate];
                if (![Utility isEmptyCheck:filteredArray1]) {
                    dayView.circleView.hidden = NO;
                    dayView.textLabel.textColor = [UIColor whiteColor];
                    float alpha = 1.0;
                    if (![[[filteredArray1 objectAtIndex:0] objectForKey:@"IsUpcoming"] boolValue]) {
                        alpha = 0.2;
                    }
                    NSString *eventTypeName = [[filteredArray1 objectAtIndex:0] objectForKey:@"EventType"];//EventTypename
                    if ([eventTypeName isEqualToString:@"Podcast"]) {
                        dayView.circleView.backgroundColor = [UIColor colorWithRed:131.0f/255.0f green:217.0f/255.0f blue:239.0f/255.0f alpha:alpha];
                        dayView.dotView.backgroundColor = [UIColor colorWithRed:131.0f/255.0f green:217.0f/255.0f blue:239.0f/255.0f alpha:alpha];
                    }else if ([eventTypeName isEqualToString:@"Seminar"]){
                        dayView.circleView.backgroundColor =[UIColor colorWithRed:131.0f/255.0f green:217.0f/255.0f blue:239.0f/255.0f alpha:alpha];
                        dayView.dotView.backgroundColor=[UIColor colorWithRed:131.0f/255.0f green:217.0f/255.0f blue:239.0f/255.0f alpha:alpha];
                    }else if ([eventTypeName isEqualToString:@"Webinar"]){
                        dayView.circleView.backgroundColor = [UIColor colorWithRed:131.0f/255.0f green:217.0f/255.0f blue:239.0f/255.0f alpha:alpha];
                        dayView.dotView.backgroundColor=[UIColor colorWithRed:131.0f/255.0f green:217.0f/255.0f blue:239.0f/255.0f alpha:alpha];
                    }else if ([eventTypeName isEqualToString:@"14"] || [eventTypeName isEqualToString:@"AshyLive"]){
                        dayView.circleView.backgroundColor = [UIColor colorWithRed:249.0f/255.0f green:147.0f/255.0f blue:234.0f/255.0f alpha:alpha];
                        dayView.dotView.backgroundColor=[UIColor colorWithRed:249.0f/255.0f green:147.0f/255.0f blue:234.0f/255.0f alpha:alpha];
                    }else if ([eventTypeName isEqualToString:@"Raw"]){
                        dayView.circleView.backgroundColor = [UIColor colorWithRed:145.0f/255.0f green:145.0f/255.0f blue:242.0f/255.0f alpha:alpha];
                        dayView.dotView.backgroundColor=[UIColor colorWithRed:253.0f/255.0f green:220.0f/255.0f blue:248.0f/255.0f alpha:alpha];
                    }else if ([eventTypeName isEqualToString:@"WeeklyWellness"]){
                        dayView.circleView.backgroundColor = [UIColor colorWithRed:114.0f/255.0f green:205.0f/255.0f blue:148.0f/255.0f alpha:alpha];
                        dayView.dotView.backgroundColor = [UIColor colorWithRed:114.0f/255.0f green:205.0f/255.0f blue:148.0f/255.0f alpha:alpha];
                    }else if ([eventTypeName isEqualToString:@"FridayFoodAndNutrition"]){
                        dayView.circleView.backgroundColor = [UIColor colorWithRed:250.0f/255.0f green:164.0f/255.0f blue:76.0f/255.0f alpha:alpha];
                        dayView.dotView.backgroundColor=[UIColor colorWithRed:250.0f/255.0f green:164.0f/255.0f blue:76.0f/255.0f alpha:alpha];
                    }else if ([eventTypeName isEqualToString:@"MovementMonday"]){
                        dayView.circleView.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:130.0f/255.0f blue:136.0f/255.0f alpha:alpha];
                        dayView.dotView.backgroundColor=[UIColor colorWithRed:239.0f/255.0f green:130.0f/255.0f blue:136.0f/255.0f alpha:alpha];
                    }else{
                        dayView.circleView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:252.0f/255.0f blue:119.0f/255.0f alpha:alpha];
                        dayView.dotView.backgroundColor=[UIColor colorWithRed:255.0f/255.0f green:252.0f/255.0f blue:119.0f/255.0f alpha:alpha];
                        
                    }
                    break;
                    
                }
            }
        }
    }
    
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
//    _dateSelected = dayView.date;
    
}
#pragma mark-End

#pragma mark - UIScrollViewDelegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((scrollView.contentOffset.x + scrollView.frame.size.width) < scrollView.contentSize.width) {
//        mainSuperScroll.hidden = true;
    if (pageControlIsChangingPage) {
        return;
    }
    CGFloat pageWidth = mainSuperScroll.frame.size.width;
    float fractionalPage = mainSuperScroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlIsChangingPage = NO;
    
    //Change+
    CGFloat pageWidth = mainSuperScroll.frame.size.width;
    float fractionalPage = mainSuperScroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
    
    //    uint page = mainScroll.contentOffset.x / SCROLLWIDTH;
    //    [self.pageControl setCurrentPage:page];
}

#pragma  mark - DatePickerViewControllerDelegate
-(void)didSelectDate:(NSDate *)date{
    NSLog(@"%@",date);
    if ([date isSameDay:currentDate]) {
        return;
    }
    if (date) {
        currentDate = date;
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSLog(@"%@",[formatter stringFromDate:currentDate]);
        [headerDateButton setTitle:[formatter stringFromDate:currentDate] forState:UIControlStateNormal];
        [defaults setObject:currentDate forKey:@"Date"];
        [self webServicecallForGetGrowthHomePage:currentDate];
    }
}
#pragma mark - End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
#pragma mark - End

#pragma mark - textView Delegate
- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [self.view layoutIfNeeded];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    NotesViewController *controller =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
//        controller.notesDelegate = self;
//        controller.modalPresentationStyle = UIModalPresentationCustom;
//        if (textView == self->gratitudetextView) {
//             controller.textView = self->gratitudetextView;
//            if ([Utility isEmptyCheck:savehtmlTextForGratitude]) {
//                if (![gratitudetextView.text isEqualToString:@"Start typing"]) {
//                    controller.htmlEditText = [gratitudetextView.attributedText string];
//                }
//            }else{
//                controller.htmlEditText = savehtmlTextForGratitude;
//            }
//    }else{
//        if (textView == self->accomplishtextView) {
//            controller.textView = self->accomplishtextView;
//            if ([Utility isEmptyCheck:savehtmlTextForAccomplishment]) {
//                if (![accomplishtextView.text isEqualToString:@"Start typing"]) {
//                     controller.htmlEditText = [accomplishtextView.attributedText string];
//                }
//            }else{
//                controller.htmlEditText = savehtmlTextForAccomplishment;
//            }
//
//        }
//    }
//      [self presentViewController:controller animated:NO completion:nil];
    if ([textView isEqual:gratitudetextView]) {
        [self gratitudeSaveShowHide:true];
    }else if([textView isEqual:accomplishtextView]){
        [self accomplishSaveShowHide:false];
        if ([textView.text isEqualToString:@"Start typing"]) {
            if (!isBackFromNotes) {
                isBackFromNotes = true;
                [self growthPlusButtonPressed:0];
            }
        }
    }
    [Utility removeCursor:textView];
    activeTextView = textView;
    [textView setInputAccessoryView:toolBar];
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
//    [self.view endEditing:YES];
    activeTextView = textView;
    activeTextField = nil;
    if (textView.tag == 1) {
        if([gratitudetextView.text caseInsensitiveCompare:@"Start typing"] == NSOrderedSame){
            gratitudetextView.text = @"";
            gratitudetextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
        }
    }
    if (textView.tag == 2) {
        if([accomplishtextView.text caseInsensitiveCompare:@"Start typing"] == NSOrderedSame){
            accomplishtextView.text = @"";
            accomplishtextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
        }
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
//    [self.view endEditing:YES];
    activeTextView = nil;
    NSString *trimmedGratitudeStr = [gratitudetextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([Utility isEmptyCheck:trimmedGratitudeStr] ||  [gratitudetextView.text isEqualToString:@"Start typing"]){
        gratitudetextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:0.5];
        gratitudetextView.text = @"Start typing";
        [self gratitudeSaveShowHide:false];
    }else{
        gratitudetextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
        [self gratitudeSaveShowHide:true];
    }
        [gratitudetextView resignFirstResponder];
    
    NSString *trimmedAccomplishStr = [accomplishtextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if([Utility isEmptyCheck:trimmedAccomplishStr] || [accomplishtextView.text isEqualToString:@"Start typing"]){
        accomplishtextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:0.5];
        accomplishtextView.text = @"Start typing";
        [self accomplishSaveShowHide:false];
    }else{
        accomplishtextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
        [self accomplishSaveShowHide:true];
    }
        [accomplishtextView resignFirstResponder];
 
}
#pragma mark - progressbar delegate
- (void)completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict from:(NSString *)fromApi{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             [formatter setDateFormat:@"yyyy-MM-dd"];
             NSString *dateStr = [formatter stringFromDate:[NSDate date]];
             int userId = [[defaults objectForKey:@"UserID"] intValue];
            
            if ([fromApi isEqualToString:@"AddUpdateGratitudeApiCallWithPhoto"]) {
               
                [[NSNotificationCenter defaultCenter]postNotificationName:@"IsGratitudeListReload" object:self userInfo:nil];
                
                if(![Utility isEmptyCheck:responseDict[@"Details"]]){
                    NSDictionary *gratitudeDict = responseDict[@"Details"];
                    
                    NSString *detailsString = @"";
                   
                    NSError *error;
                    NSData *offlineData = [NSJSONSerialization dataWithJSONObject:gratitudeDict options:NSJSONWritingPrettyPrinted  error:&error];
                    if (error) {
                        NSLog(@"Error Favorite Array-%@",error.debugDescription);
                        return;
                    }
                    detailsString = [[NSString alloc] initWithData:offlineData encoding:NSUTF8StringEncoding];
                    
                    
                    if([DBQuery isRowExist:@"gratitudeAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and GratitudeId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:[[gratitudeDict objectForKey:@"Id"]intValue]]]]){
                        [DBQuery updateGratitudeDetailsUsingGratitudeID:[[responseDict objectForKey:@"Id"]intValue] with:detailsString UpdateDate:dateStr with:1];
                    }else{
                        [DBQuery addGratitudeDetails:[[gratitudeDict objectForKey:@"Id"]intValue] with:detailsString addedDate:dateStr isSync:1];
                    }
                    
                }
                if (self->isTrueShare) {
                    [self.view endEditing:YES];
                    self->isTrueShare = false;
                    self->shareDict = responseDict[@"Details"];
                    self->showPicTypeView.hidden = false;
//                    [Utility saveShareAlert:responseDict[@"Details"]with:self];
                }
                
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"IsAchievementRealod" object:self userInfo:nil];
                
                if(![Utility isEmptyCheck:responseDict[@"Details"]]){
                    NSDictionary *achievementDict = responseDict[@"Details"];
                    
                    NSString *detailsString = @"";
                   
                    NSError *error;
                    NSData *offlineData = [NSJSONSerialization dataWithJSONObject:achievementDict options:NSJSONWritingPrettyPrinted  error:&error];
                    if (error) {
                        NSLog(@"Error Favorite Array-%@",error.debugDescription);
                        return;
                    }
                    detailsString = [[NSString alloc] initWithData:offlineData encoding:NSUTF8StringEncoding];
                    
                    if([DBQuery isRowExist:@"growthAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and AchivementId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:[[achievementDict objectForKey:@"Id"]intValue]]]]){
                        [DBQuery updateGrowthDetails:[[responseDict objectForKey:@"Id"]intValue] with:detailsString UpdateDate:dateStr with:1];

                    }else{
                        [DBQuery addGrowthDetails:[[achievementDict objectForKey:@"Id"]intValue] with:detailsString addedDate:dateStr isSync:1];
                    }
                }
            }
            if (!self->showPicTypeView.hidden) {
                return;
            }
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Success"
                                                  message:@"Saved Successfully."
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                            [self webServicecallForGetGrowthHomePage:self->currentDate];
                                            UIButton *btn = [[UIButton alloc]init];
                                            btn.tag = 1;
                                            [self mbhqListButtonPressed:btn];
                                       }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
            return;
          }
        
    });
    
}
- (void) completedWithError:(NSError *)error{
    [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
}

#pragma mark - End

-(void)saveButtonDetails:(NSString *)saveText with:(UITextView *)textview{
    [mainScroll setContentOffset:CGPointZero animated:NO];
    [textview setContentOffset:CGPointZero animated:NO];
    
    if (textview == gratitudetextView) {
        savehtmlTextForGratitude = saveText;
        gratitudetextView.attributedText = [Utility converHtmltotext:saveText];
        gratitudetextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
//        [Utility setTheCursorPosition:self->gratitudetextView];
    }else{
        savehtmlTextForAccomplishment = saveText;
        accomplishtextView.attributedText = [Utility converHtmltotext:saveText];
        accomplishtextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
//        [Utility setTheCursorPosition:self->accomplishtextView];
    }
    
    [self prepareMbhqView];
}
-(void)cancelNotes{
    [mainScroll setContentOffset:CGPointZero animated:NO];
    [self prepareMbhqView];
}
#pragma mark - DropDown Delegate

-(void)dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{
    if ([type caseInsensitiveCompare:@"Growth"] == NSOrderedSame) {
        selectedState = selectedValue;
        NotesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
        controller.selectGrowth = selectedState;
        controller.currentDate = currentDate;
        controller.notesDelegate = self;
        controller.fromStr = @"Growth";
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - Notes Delegate
-(void)reloadData:(BOOL)isreload{
    [self webServicecallForGetGrowthHomePage:currentDate];
}

#pragma mark - Table View Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return habitArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = (TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    if (cell==nil) {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
    }
    NSDictionary *dict = [habitArray objectAtIndex:indexPath.row];

    if (![Utility isEmptyCheck:[dict objectForKey:@"HabitName"]]) {
//        if (indexPath.row%2 == 0) {
//            cell.habitNameLabelForToday.font = [UIFont fontWithName:@"Raleway-Medium" size:19];
//        }else{
//            cell.habitNameLabelForToday.font = [UIFont fontWithName:@"Raleway-Bold" size:19];
//        }
        cell.habitNameLabelForToday.font = [UIFont fontWithName:@"Raleway-Medium" size:19];
        cell.habitNameLabelForToday.text = [dict objectForKey:@"HabitName"];
    }
    cell.checkUncheckButtonForToday.tag = indexPath.row;
    
    if (![Utility isEmptyCheck:[dict objectForKey:@"NewAction"]]) {
        NSDictionary *newDict = [dict objectForKey:@"NewAction"];

    if ((![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask"]]) && ![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask2"]]) {
        cell.checkUncheckButtonForToday.userInteractionEnabled = true;
        cell.checkUncheckButtonForToday.alpha = 1;
        NSDictionary *currentTaskDict = [newDict objectForKey:@"CurrentDayTask"];
        NSDictionary *currentTaskDict1 = [newDict objectForKey:@"CurrentDayTask2"];
 
        if ([[currentTaskDict objectForKey:@"IsDone"]boolValue] && [[currentTaskDict1 objectForKey:@"IsDone"]boolValue]) {
            [cell.checkUncheckButtonForToday setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
        }else if([[currentTaskDict objectForKey:@"IsDone"]boolValue] || [[currentTaskDict1 objectForKey:@"IsDone"]boolValue]){
            [cell.checkUncheckButtonForToday setImage:[UIImage imageNamed:@"half_circle.png"] forState:UIControlStateNormal];
        }else{
            [cell.checkUncheckButtonForToday setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
        }
    } else if ((![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask"]])) {
         cell.checkUncheckButtonForToday.userInteractionEnabled = true;
         cell.checkUncheckButtonForToday.alpha = 1;
        NSDictionary *currentDayTask = [newDict objectForKey:@"CurrentDayTask"];
   
        if ([[currentDayTask objectForKey:@"IsDone"]boolValue]) {
            [cell.checkUncheckButtonForToday setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
        }else{
            [cell.checkUncheckButtonForToday setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
        }
    }else if(![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask2"]]){
        cell.checkUncheckButtonForToday.userInteractionEnabled = true;
        cell.checkUncheckButtonForToday.alpha = 1;
        NSDictionary *currentDayTask = [newDict objectForKey:@"CurrentDayTask2"];
     
        if ([[currentDayTask objectForKey:@"IsDone"]boolValue]) {
            [cell.checkUncheckButtonForToday setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
        }else{
            [cell.checkUncheckButtonForToday setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
        }
    }else{
          [cell.checkUncheckButtonForToday setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
           cell.checkUncheckButtonForToday.userInteractionEnabled = false;
           cell.checkUncheckButtonForToday.alpha = 0.5;
        }
    }
  
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![Utility reachable]) {
        return;
    }
    if (![Utility isEmptyCheck:habitArray] && habitArray.count>0) {
           HabitStatsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitStatsView"];
           controller.habitDict = [habitArray objectAtIndex:indexPath.row];
           [self.navigationController pushViewController:controller animated:YES];
       }
    
}
@end
