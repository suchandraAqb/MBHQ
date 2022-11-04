//
//  ViewPersonalSessionViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 14/02/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "ViewPersonalSessionViewController.h"
#import "ViewPersonalSessionTableViewCell.h"
#import "Utility.h"
#import "MasterMenuViewController.h"
#import "ViewPersonalSessionHeaderView.h"
#import "CustomProgramSetupViewController.h"
#import "CustomExerciseSettingsViewController.h"
#import "ResetProgramViewController.h"

@interface ViewPersonalSessionViewController () {   //ah 02
    IBOutlet NSLayoutConstraint *footerConstant;
    IBOutlet UIButton *menuButton;
    IBOutlet UITableView *table;
    IBOutlet UIView *progressingView;
    IBOutlet NSLayoutConstraint *progressingViewWidthConstraint;
    
    IBOutlet UILabel *weekNameTitleLabel;
    IBOutlet UIButton *editWeekButton;
    IBOutlet UIButton *myFavButton;
    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *previousButton;
    IBOutlet UIButton *doneEditButton;
    
    UIView *contentView;
    NSArray *weekdays;
    NSMutableArray *responseArray;
    NSMutableArray *myFavArray;
    NSDate *weekstart;
    NSDate *joiningDate;
    NSDate *thisWeekMonday;
    NSDate *endDate;
    BOOL isEdit;    //ah aec
    int selectedIndex;
    int selectedSection;
    
    //chayan
    NSMutableDictionary *sessionTypeDict;
    NSMutableDictionary *bodyTypeDict;
    IBOutlet NSLayoutConstraint *stackLeading;
    BOOL isMyfav;
    IBOutlet UILabel *noFavLabel;
    NSString *weekDayStr;
    NSString *programName;//SetProgram_In
    NSString *weekNumber;//SetProgram_In
    NSString *UserProgramIdStr;//Today_SetProgram_In
    NSString *ProgramIdStr;//Today_SetProgram_In
    IBOutlet UIView *setprogramRevertView; //Today_SetProgram_In
    IBOutlet NSLayoutConstraint *setprogramRevertHeightConstant; //Today_SetProgram_In
    IBOutlet UITextView *revertTextView; //Today_SetProgram_In
    BOOL isChanged;
    BOOL scrollToToday;
}

@end
static NSString *CellIdentifier = @"ViewPersonalSessionTableViewCell";

@implementation ViewPersonalSessionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    scrollToToday = true;
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
    if(![Utility isSubscribedUser]){
        menuButton.hidden = true;
        footerConstant.constant = 0;
    }else{
        menuButton.hidden = false;
        footerConstant.constant = 75;
    }
    /* //time to defaults saved timezone    //ah aec no change
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone systemTimeZone];
    NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] ;
    //end*/
    
    responseArray = [[NSMutableArray alloc] init];
    myFavArray = [[NSMutableArray alloc]init]; //632018_feedback
    sessionTypeDict = [[NSMutableDictionary alloc] init];
    bodyTypeDict = [[NSMutableDictionary alloc] init];
    
    selectedIndex = -1;
    selectedSection = -1;
    
    progressingViewWidthConstraint.constant = 0;
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setLocale: [NSLocale currentLocale]];
    weekdays = [df shortWeekdaySymbols];
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ViewPersonalSessionHeaderView" bundle:nil];
    [table registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"ViewPersonalSessionHeaderView"];
    
    /*
    //find the start day of week
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setFirstWeekday:2];
////    [calendar setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
//    NSLog(@"wkwkw %ld",(long)[comps weekday]);
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:(0 - ([comps weekday] - 2))];
    weekstart = [calendar dateByAddingComponents:componentsToSubtract toDate:[NSDate date] options:0];
//    weekOffset = 2 monday
    //ah 8.51
    
    */
    
    
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+10"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    
    
//    NSDate *today = [NSDate date];
    NSDate *today = destinationDate;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question. (If today is Sunday, subtract 0 days.)
     */
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:today];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    
    
    
    weekstart = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    thisWeekMonday = weekstart;
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:13];
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    [theCalendar setFirstWeekday:2];
    endDate = [theCalendar dateByAddingComponents:dateComponents toDate:weekstart options:0];
    
    isChanged = true;
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewPersonalUpdateView:) name:@"ViewPersonalUpdateView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadFromExerciseFooter:) name:@"ExerciseUpdateFromFooter" object:nil];

    
    sessionTypeDict = [@{  @"1" : @"Weights",
                           @"2" : @"HIIT",
                           @"3" : @"Pilates",
                           @"4" : @"Yoga",
                           @"5" : @"Cardio",
                           @"6" : @"CardioBasedClass",
                           @"7" : @"ResistanceBasedClass",
                           @"8" : @"Sport",
                           @"9" : @"FBW",
                           @"11" : @"Other"
                           } mutableCopy];
    
    bodyTypeDict = [@{      @"0" : @"Other",
                            @"1" : @"FullBody",
                            @"2" : @"LowerBody",
                            @"3" : @"UpperBody",
                            @"4" : @"Core"} mutableCopy];
    
    //ah se(no change)
    noFavLabel.hidden = true;

    if (!isChanged) {
        return;
    }
    isChanged = false;
    if (_isFromSetProgram && ![Utility isEmptyCheck:_weekStartDate]) {
        [self findFirstDayOfWeekFromDate:_weekStartDate];
        [self getSquadUserWorkoutSessionWothDate:weekstart];
    }else{
        [self getSquadUserMealSessionJoiningDateApiCall];
    }
}

//chayan
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IBAction
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)checkButtonTapped:(UIButton *)sender {
    
    if (![defaults boolForKey:@"IsNonSubscribedUser"] && ![Utility isSubscribedUser] && ![Utility isSquadLiteUser]) {//today__
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    
    if (sender.isSelected) {
        [sender setSelected:NO];
        [self setProgress:NO];
    } else {
        [sender setSelected:YES];
        [self setProgress:YES];
    }
    [self updateStatusApi:@"SetSquadUserWorkoutSessionIsDone" WithId:sender.tag];
}
-(IBAction)repeatButtonTapped:(UIButton *)sender {
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.byValue = @(M_PI*2); // Change to - angle for counter clockwise rotation
    rotate.duration = 1.0;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [sender.layer addAnimation:rotate forKey:@"myRotationAnimation"];
    
    if (sender.isSelected) {
        [sender setSelected:NO];
    } else {
        [sender setSelected:YES];
    }
    
    [self updateStatusApi:@"SetSquadUserWorkoutSessionRepeatNextWeek" WithId:sender.tag];
}
//632018_feedback
-(IBAction)favButtonPressed:(UIButton*)sender{
     NSArray* filterArray = [responseArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Id == %d)", sender.tag] ];
    //NSLog(@"%@",filterArray);
    if (![Utility isEmptyCheck:filterArray]) {
        NSDictionary *dict = [filterArray objectAtIndex:0];
        
//        if(![dict[@"IsDone"] boolValue]){
//            return;
//        }
        
       [self webserviceCall_FavoriteSessionToggle:dict];
    }
    
}
-(IBAction)myFavButtonPressed:(id)sender{
    if (isMyfav) {
        isMyfav = false;
        noFavLabel.hidden = true;
        myFavButton.selected = false;

    }else{
        isMyfav = true;
        myFavButton.selected = true;
        
       NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"IsFavourite == true && (self.ExerciseSessionDetails.SessionCategory == 1 || self.ExerciseSessionDetails.SessionCategory == 4) && self.ExerciseSessionDetails.Id > 0"];//7March //&& IsDone == true
        NSArray* filterArray = [responseArray filteredArrayUsingPredicate:newPredicate];
        myFavArray = [filterArray mutableCopy];
        if ([Utility isEmptyCheck:myFavArray]) {
            noFavLabel.hidden = false;
        }else{
            noFavLabel.hidden = true;
        }
    }
    [table reloadData];
}
//632018_feedback

-(IBAction)addButtonTapped:(UIButton*)sender {
    
    if([Utility isSubscribedUser] && [Utility isOfflineMode]){
        [Utility msg:@"You are in OFFLINE mode. Go online to add Custom Workout." title:@"Oops!\n" controller:self haveToPop:NO];
        return;
    }//AY 07032018
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    
    dayComponent.day = [sender tag];
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    [theCalendar setFirstWeekday:2];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:weekstart options:0];
    
    AddCustomSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddCustomSession"];
    controller.sessionDate = nextDate;
    controller.AddCustomSessionViewDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)editWeekButtonTapped:(id)sender {    //ah 10.51
    
    if([Utility isSubscribedUser] && [Utility isOfflineMode]){
        [Utility msg:@"You are in OFFLINE mode. Go online to edit Custom Workout." title:@"Oops!\n" controller:self haveToPop:NO];
        return;
    }//AY 07032018
    
    
    if (editWeekButton.isSelected) {
        [editWeekButton setSelected:NO];
        isEdit = NO;
//        nextButton.hidden = NO;
//        previousButton.hidden = NO;
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:-7];
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        [theCalendar setFirstWeekday:2];
        NSDate *sevenDaysAgo = [theCalendar dateByAddingComponents:dateComponents toDate:weekstart options:0];
        if ([joiningDate compare:sevenDaysAgo] == NSOrderedDescending || isEdit) {     //ah se
            previousButton.hidden = true;
        } else {
            previousButton.hidden = false;
        }
        
        [dateComponents setDay:+7];
        NSDate *sevenDaysAfter = [theCalendar dateByAddingComponents:dateComponents toDate:weekstart options:0];
        
        if ([endDate compare:sevenDaysAfter] == NSOrderedAscending || isEdit) {
            nextButton.hidden = true;
        } else {
            nextButton.hidden = false;
        }
        
        selectedIndex = -1;
        selectedSection = -1;

        [table reloadData];
        //save edit
    } else {
        [editWeekButton setSelected:YES];
        isEdit = YES;
        nextButton.hidden = YES;
        previousButton.hidden = YES;
        
        [table reloadData];
        //open edit
    }
}

-(IBAction)nextButtonTapped:(id)sender {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:7];
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    [theCalendar setFirstWeekday:2];
    NSDate *afterSevenDays = [theCalendar dateByAddingComponents:dateComponents toDate:weekstart options:0];
    
    progressingViewWidthConstraint.constant = 0;
    isMyfav = false;//632018_feedback
    noFavLabel.hidden=true;
    [self findFirstDayOfWeekFromDate:afterSevenDays];
    
    [self getSquadUserWorkoutSessionWothDate:afterSevenDays];
}
-(IBAction)previousButtonTapped:(id)sender {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-7];
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    [theCalendar setFirstWeekday:2];
    NSDate *sevenDaysAgo = [theCalendar dateByAddingComponents:dateComponents toDate:weekstart options:0];
    
    progressingViewWidthConstraint.constant = 0;
    isMyfav = false;//632018_feedback
    noFavLabel.hidden=true;
    [self findFirstDayOfWeekFromDate:sevenDaysAgo];
    [self getSquadUserWorkoutSessionWothDate:sevenDaysAgo];
}
- (IBAction)editButtonTapped:(UIButton *)sender {
    if([Utility isSubscribedUser] && [Utility isOfflineMode]){
        [Utility msg:@"You are in OFFLINE mode. Go online to edit Custom Workout." title:@"Oops!\n" controller:self haveToPop:NO];
        return;
    }//AY 07032018
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];                                                                         [formatter setDateFormat:@"yyyy-MM-dd"];
    AddCustomSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddCustomSession"];
    controller.sessionID = sender.tag;
    controller.weekDate =  [NSString stringWithFormat:@"%@T00:00:00",[formatter stringFromDate:weekstart]];
    NSLog(@"Date-%@",sender.accessibilityHint);
    controller.sessionDate1 = [@"" stringByAppendingFormat:@"%@",sender.accessibilityHint];
    controller.AddCustomSessionViewDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)deleteButtonTapped:(UIButton*)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Comfirm Delete"
                                          message:@"Do you want to delete this session?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Delete"
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   [self deleteSessionWithId:[sender tag]];
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

-(IBAction)swapEqualButtonTapped:(UIButton *)sender {
    //outer id
    if (selectedIndex >= 0 && selectedSection >= 0) {
        selectedIndex = -1;
        selectedSection = -1;
        [table reloadData];
    } else {
        selectedIndex = (int)sender.tag;
        selectedSection = [sender.accessibilityHint intValue];
        [table reloadData];
    }
}
-(IBAction)swapButtonTapped:(id)sender {
//    [self swapApiCallWithToId:[sender tag]];
}
-(IBAction)moveSwapButtonTapped:(UIButton *)sender {
    
    if ([sender.accessibilityHint caseInsensitiveCompare:@"swap"] == NSOrderedSame) {
        [self swapApiCallWithToId:[sender tag]];
    } else if ([sender.accessibilityHint caseInsensitiveCompare:@"move"] == NSOrderedSame) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        [theCalendar setFirstWeekday:2];
//        [theCalendar setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
        
        NSDateComponents *components = [theCalendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
        [dateComponents setDay:(sender.tag - ([components weekday]-2))];
        
        NSDate *dt = [theCalendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString *dtStr = [formatter stringFromDate:dt];
        
        [self moveApiCallWithDate:dtStr];
    }
}
-(IBAction)backToSettingsTapped:(id)sender {    //ah 23.6
    
    if([Utility isSubscribedUser] && [Utility isOfflineMode]){
        [Utility msg:@"You are in OFFLINE mode. Go online to edit Custom Workout settings." title:@"Oops!\n" controller:self haveToPop:NO];
        return;
    }//AY 07032018
    
    BOOL isexist=false;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[CustomExerciseSettingsViewController class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            isexist=true;
            break;
            
        }
    }
    if (!isexist) {
        CustomExerciseSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomExerciseSettings"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
#pragma mark - API Call
-(void)webserviceCall_FavoriteSessionToggle:(NSDictionary *)dict{ //632018_feedback
    
    NSInteger sessionID = [dict[@"ExerciseSessionId"] integerValue];
    if (Utility.reachable && ![Utility isOfflineMode]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInteger:sessionID] forKey:@"SessionId"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"FavoriteSessionToggle" append:@""forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self getSquadUserWorkoutSessionWothDate:self->weekstart];
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
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self offlineSessionDoneNFavourite:dict isFav:YES];// AY 07032018
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
}//632018_feedback

-(void) getSquadUserWorkoutSessionWothDate:(NSDate *)newDate {
    if (Utility.reachable && ![Utility isOfflineMode]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];   //yyyy-MM-dd  //2017-03-06T10:38:18.7877+00:00 //yyyy-MM-dd'T'HH:mm:ss
        NSString *currentDateStr = [formatter stringFromDate:newDate];

        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:currentDateStr forKey:@"dt"];
        [mainDict setObject:[NSNumber numberWithInteger:0] forKey:@"UserStep"];

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadUserWorkoutSession" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     [self previousSetUp:newDate];
                                                                     
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         //SetProgram_In
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"ProgramName"]]) {
                                                                             self->programName = [responseDict objectForKey:@"ProgramName"];
                                                                         }else{
                                                                             self->programName = @"";
                                                                         }
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"WeekNumber"]]) {
                                                                             self->weekNumber = [@"" stringByAppendingFormat:@"%@",[responseDict objectForKey:@"WeekNumber"]];
                                                                         }else{
                                                                             self->weekNumber = @"";
                                                                         }
                                                                         //Today_SetProgram_In
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"UserProgramId"]]) {
                                                                             self->UserProgramIdStr = [@"" stringByAppendingFormat:@"%@",[responseDict objectForKey:@"UserProgramId"]];
                                                                         }
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"ProgramId"]]) {
                                                                             self->ProgramIdStr = [@"" stringByAppendingFormat:@"%@",[responseDict objectForKey:@"ProgramId"]];
                                                                         }//
                                                                         
                                                                         
                                                                         //SetProgram_In
                                                                         self->responseArray = [responseDict objectForKey:@"SquadUserWorkoutSessionList"];
                                                                         if (self->isMyfav) {//7march
                                                                             NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"IsFavourite == true && (self.ExerciseSessionDetails.SessionCategory == 1 || self.ExerciseSessionDetails.SessionCategory == 4) && self.ExerciseSessionDetails.Id > 0"]; //7March && IsDone == true
                                                                             NSArray* filterArray = [self->responseArray filteredArrayUsingPredicate:newPredicate];
                                                                             self->myFavArray = [filterArray mutableCopy];
                                                                             if ([Utility isEmptyCheck:self->myFavArray]) {
                                                                                 self->noFavLabel.hidden = false;
                                                                             }else{
                                                                                 self->noFavLabel.hidden = true;
                                                                             }
                                                                         }
                                                                         [self->table reloadData];
                                                                         [self populateSessionList:true];
                                                                         [self addUpdateDB];
                                                                        //632018_feedback
                                                                     }
                                                                     else{
//                                                                         [table reloadData];
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
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self getOfflineData];
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
}

-(void) updateRepeateSessionApiCall:(BOOL)isRepeat Button:(UIButton *)currentRepeatButton {
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        //[mainDict setObject:[NSNumber numberWithInt:3259] forKey:@"UserExerciseSessionId"];
        [mainDict setObject:[NSNumber numberWithBool:isRepeat] forKey:@"IsRepeat"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateRepeateSession" append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                                                                         rotate.byValue = @(M_PI*2); // Change to - angle for counter clockwise rotation
                                                                         rotate.duration = 1.0;
                                                                         rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                                                         
                                                                         [currentRepeatButton.layer addAnimation:rotate forKey:@"myRotationAnimation"];
                                                                         
                                                                         if ([[responseDict objectForKey:@"IsRepeat"] boolValue]) {
                                                                             [currentRepeatButton setImage:[UIImage imageNamed:@"repeat_active.png"] forState:UIControlStateNormal];
                                                                         } else {
                                                                             [currentRepeatButton setImage:[UIImage imageNamed:@"repeat.png"] forState:UIControlStateNormal];
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

- (void) updateStatusApi:(NSString *)api WithId:(NSInteger)sessionID {
    if (Utility.reachable && ![Utility isOfflineMode]) {
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInteger:sessionID] forKey:@"Id"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
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
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup

                                                                         [self getSquadUserWorkoutSessionWothDate:self->weekstart];
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
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            if([api isEqualToString:@"SetSquadUserWorkoutSessionIsDone"]){
                
                NSArray* filterArray = [responseArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Id == %d)", sessionID] ];
                //NSLog(@"%@",filterArray);
                if (![Utility isEmptyCheck:filterArray]) {
                    NSDictionary *dict = [filterArray objectAtIndex:0];
                    [self offlineSessionDoneNFavourite:dict isFav:NO];// AY 07032018
                }
                
            }
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
    
}
-(void)getSquadUserMealSessionJoiningDateApiCall{
    if (Utility.reachable && ![Utility isOfflineMode]) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadUserMealSessionJoiningDateApiCall" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         [self setupWeekStartView:responseDict];
                                                                     }
                                                                     else{
                                                                         //[Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self getSquadUserWorkoutSessionWothDate:weekstart];
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
        
        
       
    }
    
}
-(void) deleteSessionWithId:(NSInteger) sID {
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInteger:sID] forKey:@"Id"];
        [mainDict setObject:[NSNumber numberWithInteger:1] forKey:@"StepNo"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteSquadUserWorkoutSession" append:@""forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self getSquadUserWorkoutSessionWothDate:self->weekstart];
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
-(void) swapApiCallWithToId:(NSInteger) toID {
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInteger:selectedIndex] forKey:@"fromid"];
        [mainDict setObject:[NSNumber numberWithInteger:toID] forKey:@"toid"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SwapSquadUserWorkoutSession" append:@""forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->selectedIndex = -1;
                                                                         self->selectedSection = -1;
                                                                         [self getSquadUserWorkoutSessionWothDate:self->weekstart];
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
-(void) moveApiCallWithDate:(NSString *) dt {
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInteger:selectedIndex] forKey:@"Moveid"];
        [mainDict setObject:dt forKey:@"dt"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];

        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"MoveSquadUserWorkoutSession" append:@""forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->selectedIndex = -1;
                                                                         self->selectedSection = -1;
                                                                         [self getSquadUserWorkoutSessionWothDate:self->weekstart];
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Move Error!" controller:self haveToPop:NO];
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
-(void) checkStepNumberForSetupWithAPI{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"CheckStepNumberForSetup" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
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
                                                                          if (![Utility isEmptyCheck:[responseDict objectForKey:@"StepNumber"]]  && [[responseDict objectForKey:@"StepNumber"] isEqual:@0]) {
                                                                              [self generateSquadUserMealPlans:[responseDict objectForKey:@"StepNumber"]];
                                                                          }else{
                                                                              [Utility msg:@"Please setup your Exercise Plan" title:@"Warning!" controller:self haveToPop:NO];
                                                                              return;
                                                                          }
                                                                      }
                                                                      else{
                                                                          [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                          return;
                                                                      }
                                                                  }else{
                                                                      [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                      return;
                                                                  }
                                                              });
                                                              
                                                          }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        return;
    }
    
}
-(void)generateSquadUserMealPlans:(NSNumber *)stepNumberForGenerateMeal{  //ah 10.52
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (weekstart) {
            NSDateFormatter* dailyDateformatter = [[NSDateFormatter alloc]init];
            [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];

            [mainDict setObject:[dailyDateformatter stringFromDate:weekstart] forKey:@"RunDate"];
        }
        [mainDict setObject:stepNumberForGenerateMeal forKey:@"exerciseStep"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GenerateSquadUserMealPlansApiCall" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
//                                                                         haveToCallGenerateMeal = NO;
//                                                                         [self getMealPlanApiCall];
                                                                         [self getSquadUserWorkoutSessionWothDate:self->weekstart];
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
-(void)showFBWAlert {
    
    NSString *msgStr = @"FBW stands for 'Fat Burning Walk'\n\nIt works best as a fasted cardio walk for 30 to 60mins first thing in the morning.\n\nBut whenever you can do it is great for your body and mindset (even if not fasted)";
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"FBW\n\n"
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
#pragma mark - Private Method
-(void) setProgress:(BOOL)isPositive {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (isPositive) {
        progressingViewWidthConstraint.constant = progressingViewWidthConstraint.constant + screenWidth/(float)responseArray.count;
    } else {
        progressingViewWidthConstraint.constant = progressingViewWidthConstraint.constant - screenWidth/(float)responseArray.count;
    }
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

-(NSArray *) getCurrentDayDataFromDayComp:(NSInteger) section {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    NSArray* weekFilterArray;
//    if (section == 6) {
//        dayComponent.day = 0;
//    } else {
//        dayComponent.day = section+1;
//    }
    
    dayComponent.day = section;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    [theCalendar setFirstWeekday:2];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:weekstart options:0];
    
//    NSLog(@"nextDate: %@ ... sec %ld", nextDate, (long)section);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    weekDayStr = [formatter stringFromDate:nextDate]; //Chang
    
    NSString *attributeName  = @"StartDateTimeStr";
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(%K MATCHES %@)",attributeName,weekDayStr];
    if (isMyfav) {//632018_feedback
        weekFilterArray = [myFavArray filteredArrayUsingPredicate:predicate1];
    }else{
        weekFilterArray = [responseArray filteredArrayUsingPredicate:predicate1];
    }//632018_feedback
    return weekFilterArray;
}
-(void) findFirstDayOfWeekFromDate:(NSDate *) newDate {
    //find the start day of week
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setFirstWeekday:2];
//    [calendar setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:(0 - ([comps weekday] - 2))];
    weekstart = [calendar dateByAddingComponents:componentsToSubtract toDate:newDate options:0];
    //    weekOffset = 2 monday

}

-(void)setupWeekStartView:(NSDictionary *)responseDict{
    
    if (![Utility isEmptyCheck:responseDict[@"WeekStartDate"] ]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        //                                                                             [formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
        NSDate *date = [formatter dateFromString:responseDict[@"WeekStartDate"]];
        if (date) {
            joiningDate = date;
            
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            [dateComponents setDay:-7];
            NSCalendar *theCalendar = [NSCalendar currentCalendar];
            [theCalendar setFirstWeekday:2];
            NSDate *sevenDaysAgo = [theCalendar dateByAddingComponents:dateComponents toDate:weekstart options:0];
            
            if ([joiningDate compare:sevenDaysAgo] == NSOrderedDescending || isEdit) {     //ah se
                previousButton.hidden = true;
            } else {
                previousButton.hidden = false;
            }
        }
        [self getSquadUserWorkoutSessionWothDate:weekstart];//add_su_3/8/17
    }
    
}

-(void)previousSetUp:(NSDate *)newDate{
    
    //add_su_3/8/17
    NSTimeInterval secondWeekStart = 14*24*60*60;
    NSDate *secondJoiningStart = [joiningDate
                                  dateByAddingTimeInterval:secondWeekStart];
    
    NSDate *secondJoiningEnd = [joiningDate
                                dateByAddingTimeInterval:secondWeekStart+6*24*60*60];
    
    
    NSTimeInterval fifthWeek = 35*24*60*60;
    NSDate *fifthJoiningStart = [joiningDate
                                 dateByAddingTimeInterval:fifthWeek];
    
    NSDate *fifthJoiningEnd = [joiningDate
                               dateByAddingTimeInterval:fifthWeek+6*24*60*60];
    
    if ([newDate compare:secondJoiningStart] == NSOrderedDescending && [newDate compare:secondJoiningEnd] == NSOrderedAscending) {
       
    }else if ([newDate compare:fifthJoiningStart] == NSOrderedDescending && [newDate compare:fifthJoiningEnd] == NSOrderedAscending){
        
    }
    //
    
}

-(void)populateSessionList:(BOOL)isOnline{
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-7];
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    [theCalendar setFirstWeekday:2];
    NSDate *sevenDaysAgo = [theCalendar dateByAddingComponents:dateComponents toDate:weekstart options:0];
    
    if ([joiningDate compare:sevenDaysAgo] == NSOrderedDescending || isEdit) {
        previousButton.hidden = true;
    } else {
        previousButton.hidden = false;
    }
    
    
    [dateComponents setDay:+7];
    NSDate *sevenDaysAfter = [theCalendar dateByAddingComponents:dateComponents toDate:weekstart options:0];
    
    if ([endDate compare:sevenDaysAfter] == NSOrderedAscending || isEdit) {
        nextButton.hidden = true;
    } else {
        nextButton.hidden = false;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    // [formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
    
   //Today_SetProgram_In
    if (![Utility isEmptyCheck:programName] && ![Utility isEmptyCheck:weekNumber]) {
        weekNameTitleLabel.text = [@"" stringByAppendingFormat:@"%@ - Week %@",programName,weekNumber];
        setprogramRevertView.hidden = false;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[@"" stringByAppendingFormat:@"Following plan is based on %@ Revert to Custom Plan",programName]];
        NSRange range = [[@"" stringByAppendingFormat:@"Following plan is based on %@ Revert to Custom Plan",programName] rangeOfString: @"Revert to Custom Plan"];
        NSRange range1 =[[@"" stringByAppendingFormat:@"Following plan is based on %@ Revert to Custom Plan",programName] rangeOfString: programName];
        [text addAttribute:NSLinkAttributeName value:@"Revert://" range:NSMakeRange(range.location, range.length)];
        
        [text addAttribute:NSUnderlineStyleAttributeName
                     value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                     range:NSMakeRange(range.location, range.length)];
     
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.alignment                = NSTextAlignmentCenter;
        
        NSDictionary *attrDict = @{
                                   NSFontAttributeName : [UIFont fontWithName:@"Oswald-Regular" size:13.0],
                                   NSForegroundColorAttributeName : [UIColor grayColor],
                                   NSParagraphStyleAttributeName:paragraphStyle
                                   };
        [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
        [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Bold" size:13] range:NSMakeRange(range1.location,range1.length)];
        
        revertTextView.attributedText = text;
        CGSize sizeThatFitsTextView = [revertTextView sizeThatFits:CGSizeMake(revertTextView.frame.size.width, MAXFLOAT)];
        setprogramRevertHeightConstant.constant = sizeThatFitsTextView.height+10;

        revertTextView.editable = NO;
        revertTextView.delaysContentTouches = NO;
        
    }else{
        setprogramRevertView.hidden = true;
        setprogramRevertHeightConstant.constant = 0;
          if ([[formatter stringFromDate:thisWeekMonday] isEqualToString:[formatter stringFromDate:weekstart]]) {
//        if ([weekstart compare:thisWeekMonday] == NSOrderedSame) {
            weekNameTitleLabel.text = @"CURRENT WEEK";
        } else {
            weekNameTitleLabel.text = [NSString stringWithFormat:@"WEEK - %@",[formatter stringFromDate:weekstart]];
        }
        revertTextView.text= @"";
    }//Today_SetProgram_In
    
    int count = 0;
    for (NSDictionary *dict in responseArray) {
        if (![Utility isEmptyCheck:[dict objectForKey:@"IsDone"]] && [[dict objectForKey:@"IsDone"] boolValue]) {
            count++;
        }
    }
    if (progressingViewWidthConstraint.constant == 0 && ![Utility isEmptyCheck:responseArray]) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        progressingViewWidthConstraint.constant = progressingViewWidthConstraint.constant + count*screenWidth/(float)responseArray.count;
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: weekstart toDate: [NSDate date] options: 0];
    NSInteger days = [components day];
    BOOL isScroll = false;
    if (isMyfav) {//632018_feedback
        if (![Utility isEmptyCheck:myFavArray]) {
            isScroll = true;
        }
    }else{
        if (![Utility isEmptyCheck:responseArray]) {
            isScroll = true;
        }
    }
    if (self->scrollToToday && isScroll && days<7) {
        self->scrollToToday = false;
        [self->table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:days] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

-(void)addUpdateDB{
    if (![Utility isSubscribedUser]){
        return;
    }
    
    
    NSString *detailsString = @"";
    
    if(responseArray.count>0){
        NSError *error;
        NSData *favData = [NSJSONSerialization dataWithJSONObject:responseArray options:NSJSONWritingPrettyPrinted  error:&error];
        
        if (error) {
            
            NSLog(@"Error Favorite Array-%@",error.debugDescription);
        }
        
        detailsString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
    }
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *weekStartDateStr = [formatter stringFromDate:weekstart];
    NSString *joiningDateStr = [formatter stringFromDate:joiningDate];
    
    
    if([DBQuery isRowExist:@"customExerciseList" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStartDateStr]]){
        
        [DBQuery updateCustomExerciseDetails:detailsString joiningDate:joiningDateStr weekStartDate:weekStartDateStr];
    }else{
        [DBQuery addCustomExerciseDetails:detailsString joiningDate:joiningDateStr weekStartDate:weekStartDateStr];
        
    }
}

-(void)getOfflineData{
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *weekStartDateStr = [formatter stringFromDate:weekstart];
    
    if([DBQuery isRowExist:@"customExerciseList" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStartDateStr]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            NSArray *arr = [dbObject selectBy:@"customExerciseList" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"exerciseList",@"joiningDate",@"weekStartDate",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStartDateStr]];
            
            if(arr.count>0){
                
                if(![Utility isEmptyCheck:arr[0][@"exerciseList"]]){
                    NSString *str = arr[0][@"exerciseList"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    NSArray *exerciseList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    if(exerciseList){
                        responseArray = [exerciseList mutableCopy];
                        
                    }else{
                        
                    }
                    
                }
                
                if(![Utility isEmptyCheck:arr[0][@"joiningDate"]]){
                    joiningDate = [formatter dateFromString:arr[0][@"joiningDate"]];
                    
                    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                    [dateComponents setDay:-7];
                    NSCalendar *theCalendar = [NSCalendar currentCalendar];
                    [theCalendar setFirstWeekday:2];
                    NSDate *sevenDaysAgo = [theCalendar dateByAddingComponents:dateComponents toDate:weekstart options:0];
                    
                    if ([joiningDate compare:sevenDaysAgo] == NSOrderedDescending || isEdit) {     //ah se
                        previousButton.hidden = true;
                    } else {
                        previousButton.hidden = false;
                    }
                }
                
                
                dispatch_async(dispatch_get_main_queue(),^ {
                    [self previousSetUp:self->weekstart];
                    if (self->isMyfav) {
                       NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"IsFavourite == true && (self.ExerciseSessionDetails.SessionCategory == 1 || self.ExerciseSessionDetails.SessionCategory == 4) && self.ExerciseSessionDetails.Id > 0"]; //&& IsDone == true
                        NSArray* filterArray = [self->responseArray filteredArrayUsingPredicate:newPredicate];
                        self->myFavArray = [filterArray mutableCopy];
                        if ([Utility isEmptyCheck:self->myFavArray]) {
                            self->noFavLabel.hidden = false;
                        }else{
                            self->noFavLabel.hidden = true;
                        }
                    }
                    [self->table reloadData];
                    [self populateSessionList:false];
                });
            }
            
            [dbObject connectionEnd];
        }
    }else{
        responseArray = nil;
        dispatch_async(dispatch_get_main_queue(),^ {
            [self previousSetUp:self->weekstart];
            [self->table reloadData];
            [self populateSessionList:false];
        });
        [Utility msg:@"You are in OFFLINE mode and custom sessions hasn't been previously downloaded. Please remove offline mode and download this session while you have access to the internet." title:@"Oops!\n" controller:self haveToPop:YES];
    }
    
}

-(BOOL)isOfflineAvailable:(int)sessionId{
    BOOL isAvailable = false;
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    DAOReader *dbObject = [DAOReader sharedInstance];
    if([dbObject connectionStart]){
        
        NSString *query = [@"" stringByAppendingFormat:@"select ce.exerciseList from customExerciseList ce,exerciseDetails ed where  ce.UserId = ed.UserId AND ed.exSessionId = '%d' AND ed.exerciseNames != '' AND ce.UserId = '%d'",sessionId,userId];
        
        NSArray *arr =[dbObject selectByQuery:[[NSArray alloc]initWithObjects:@"exerciseList",nil] query:query];
        
        if(arr.count>0){
            isAvailable = true;
        }
    }
    
    return isAvailable;
    
}// AY 14032018

-(void)offlineSessionDoneNFavourite:(NSDictionary *)dataDict isFav:(BOOL)isFav{
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    int sessionId = [[dataDict objectForKey:@"Id"]intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *weekStartDateStr = [formatter stringFromDate:weekstart];
    
    if([DBQuery isRowExist:@"customExerciseList" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStartDateStr]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            
            NSArray *arr = [dbObject selectBy:@"customExerciseList" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"exerciseList",@"joiningDate",@"weekStartDate",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStartDateStr]];
            
            
            if(arr.count>0){
                NSMutableArray *favArray = [[NSMutableArray alloc]init];
                if(![Utility isEmptyCheck:arr[0][@"exerciseList"]]){
                    NSString *str = arr[0][@"exerciseList"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    favArray = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
                    
                    NSArray *filterarray = [favArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Id == %d)", sessionId]];
                    if(filterarray.count>0){
                        NSInteger objectIndex= [favArray indexOfObject:filterarray[0]];
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:filterarray[0]];
                        BOOL isDone = [dict[@"IsDone"]boolValue];
                        
//                        if(isDone && isFav){//18may2018
                        if(isFav){
                            BOOL IsFavorite = [dict[@"IsFavourite"] boolValue];
                            [dict setObject:[NSNumber numberWithBool:!IsFavorite] forKey:@"IsFavourite"];
                            [dict setObject:[NSNumber numberWithBool:true] forKey:@"IsFavDone"];
                            [favArray replaceObjectAtIndex:objectIndex withObject:dict];
                        }else if(!isFav){
                            [dict setObject:[NSNumber numberWithBool:!isDone] forKey:@"IsDone"];
                            [dict setObject:[NSNumber numberWithBool:true] forKey:@"IsCountDone"];
                            [favArray replaceObjectAtIndex:objectIndex withObject:dict];
                        }
                        
                    }
                    
                }
                
                
                if(favArray.count<=0){
                    return;
                }
                
                NSString *favString = @"";
                if(favArray.count>0){
                    NSError *error;
                    NSData *favData = [NSJSONSerialization dataWithJSONObject:favArray options:NSJSONWritingPrettyPrinted  error:&error];
                    
                    if (error) {
                        
                        NSLog(@"Error Favorite Array-%@",error.debugDescription);
                    }
                    
                    favString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
                }
                
                NSMutableString *modifiedExList = [NSMutableString stringWithString:favString];
                [modifiedExList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExList length])];
                
                if([dbObject connectionStart]){
                    
                    NSString *date = [NSDate date].description;
                    NSArray *columnArray = [[NSArray alloc]initWithObjects:@"exerciseList",@"isSync",@"lastUpdate",nil];
                    NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedExList,[NSNumber numberWithInt:0],date, nil];
                    
                    if([dbObject updateWithCondition:@"customExerciseList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStartDateStr]]){
                        
                        [self getOfflineData];
                    }
                }
                [dbObject connectionEnd];
            }
            
            [self offlineExerciseDetailsDone:dataDict];
        }
    }
    
}// AY 07032018

-(void)offlineExerciseDetailsDone:(NSDictionary*)dataDict{
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    int exerciseId = [[dataDict objectForKey:@"ExerciseSessionId"]intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //    NSString *weekStartDateStr = [formatter stringFromDate:weekstart];
    
    if([DBQuery isRowExist:@"exerciseDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,exerciseId]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            NSArray *arr = [dbObject selectBy:@"exerciseDetails" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"exerciseDetails",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,exerciseId]];
            
            if(arr.count>0){
                NSMutableDictionary *exerciseDetailsMutableDict = [[NSMutableDictionary alloc]init];
                
                if(![Utility isEmptyCheck:arr[0][@"exerciseDetails"]]){
                    NSString *str = arr[0][@"exerciseDetails"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    exerciseDetailsMutableDict = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]mutableCopy];
                    
                    if (![Utility isEmptyCheck:exerciseDetailsMutableDict]) {
                        BOOL IsFavorite = [dataDict[@"IsFavourite"] boolValue];
                        [exerciseDetailsMutableDict removeObjectForKey:@"IsFavourite"];
                        [exerciseDetailsMutableDict setObject:[NSNumber numberWithBool:!IsFavorite] forKey:@"IsFavourite"];
                    }else{
                        return;
                    }
                    
                    NSString *exDetailsStr = @"";
                    
                    if(![Utility isEmptyCheck:exerciseDetailsMutableDict]){
                        NSError *error;
                        NSData *favData = [NSJSONSerialization dataWithJSONObject:exerciseDetailsMutableDict options:NSJSONWritingPrettyPrinted  error:&error];
                        if (error) {
                            NSLog(@"Error Favorite Array-%@",error.debugDescription);
                        }
                        exDetailsStr = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
                    }
                    
                    NSMutableString *modifiedExList = [NSMutableString stringWithString:exDetailsStr];
                    [modifiedExList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExList length])];
                    
                    if([dbObject connectionStart]){
                        
                        NSString *date = [NSDate date].description;
                        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"exerciseDetails",@"lastUpdate",nil];
                        NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedExList,date, nil];
                        
                        if([dbObject updateWithCondition:@"exerciseDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,exerciseId]]){
                            
//                            [self getOfflineData];
                        }
                    }
                    [dbObject connectionEnd];
                }
            }
        }
    }
}

#pragma mark - TableView Datasource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (![Utility isEmptyCheck:responseArray]) { //632018_feedback
        return 7;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *weekFilterArray = [self getCurrentDayDataFromDayComp:section];
    if (isMyfav) {
        return weekFilterArray.count;
    }else{
        return (weekFilterArray.count > 1) ? weekFilterArray.count : weekFilterArray.count+1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // Removes extra padding in Grouped style
    return CGFLOAT_MIN;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;
//}
//-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    ViewPersonalSessionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ViewPersonalSessionHeaderView"];
//
//    if (section == 6) {
//        sectionHeaderView.dayNameLabel.text = [weekdays objectAtIndex:0];
//    } else {
//        sectionHeaderView.dayNameLabel.text = [weekdays objectAtIndex:section+1];
//    }
////    sectionHeaderView.dayNameLabel.text = [weekdays objectAtIndex:section];
//
//    return  sectionHeaderView;
//}

//chayan
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ViewPersonalSessionTableViewCell *cell = (ViewPersonalSessionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[ViewPersonalSessionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.contentView.alpha = 1.0;
    
    NSArray *weekFilterArray = [self getCurrentDayDataFromDayComp:indexPath.section];
    int sessionFlowId = 0;
    
    if (![Utility isEmptyCheck:weekFilterArray] && weekFilterArray.count > indexPath.row) {
        if (![Utility isEmptyCheck:[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"ExerciseSessionDetails"]]) {
            
            NSDictionary *dict = [[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"ExerciseSessionDetails"];
            
            sessionFlowId = [dict[@"SessionFlowId"] intValue];
            
            NSDictionary *darkAttrsDictionary = @{
                                                  NSFontAttributeName : cell.nameLabel.font,
                                                  NSForegroundColorAttributeName : cell.nameLabel.textColor
                                                  };
            NSDictionary *grayAttrsDictionary = @{
                                                  NSFontAttributeName : cell.nameLabel.font,
                                                  NSForegroundColorAttributeName : [UIColor lightGrayColor]
                                                  };
            
            if (![Utility isEmptyCheck:[dict objectForKey:@"SessionCategory"]] && ([[dict objectForKey:@"SessionCategory"] intValue] == 1 || [[dict objectForKey:@"SessionCategory"] intValue] == 4)) { //ah ux2(storyboard)
                cell.durationLabel.hidden = false;
                //                cell.durationHeightConstraint.constant = cell.durationLabel.bounds.size.height+2;
                //ah 28.6
                
                NSString *sessionType = [sessionTypeDict objectForKey:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"SessionType"] intValue]]];
                NSString *bodyArea = [bodyTypeDict objectForKey:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"BodyArea"] intValue]]];
                NSString *sessionTitle = [dict objectForKey:@"SessionTitle"];
                NSString *duration = [NSString stringWithFormat:@"%d",[[dict objectForKey:@"Duration"] intValue]];
                
                //                NSLog(@"only_sessionType %@ || sessionType %@ || sessionTypeDict %@",[dict objectForKey:@"SessionType"],[sessionTypeDict objectForKey:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"SessionType"] intValue]]], sessionTypeDict);
                
                //                NSLog(@"sessionType %@ || bodyArea %@ \n dict -> %@",sessionType,bodyArea,dict);
                
                NSAttributedString *grayAttributedString;
                NSAttributedString *darkAttributedString;
                
                if (![Utility isEmptyCheck:bodyArea]) {
                    grayAttributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" (%@)",bodyArea] attributes:grayAttrsDictionary];
                } else {
                    grayAttributedString = [[NSAttributedString alloc] init];
                }
                
                if (![Utility isEmptyCheck:sessionType]) {
                    darkAttributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[sessionType uppercaseString]] attributes:darkAttrsDictionary];
                } else {
                    darkAttributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"--"] attributes:darkAttrsDictionary];
                }
                
                //ah ux3
                NSMutableAttributedString *newString =[[NSMutableAttributedString alloc] init];
                
                [newString appendAttributedString:darkAttributedString];
                [newString appendAttributedString:grayAttributedString];
                
                cell.nameLabel.attributedText = newString;
                //end
                
                
                /* if (sessionType==nil && bodyArea!=nil)
                 {
                 NSAttributedString *grayAttributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" (%@)",bodyArea] attributes:grayAttrsDictionary];
                 
                 cell.nameLabel.text = [NSString stringWithFormat:@"-- (%@)",bodyArea];
                 }
                 else if (sessionType!=nil && bodyArea==nil)
                 {
                 cell.nameLabel.text = [NSString stringWithFormat:@"%@",sessionType];
                 }
                 else if (sessionType!=nil && bodyArea!=nil)
                 {
                 cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",sessionType,bodyArea];
                 }
                 else
                 {
                 cell.nameLabel.text = @"";
                 }*/
                
                
                if (sessionTitle==nil && duration!=nil && [duration intValue]!=0)
                {
                    cell.durationLabel.text = [NSString stringWithFormat:@"-- (%@ mins)",duration];
                }
                else if (sessionTitle!=nil && duration==nil)
                {
                    cell.durationLabel.text = [NSString stringWithFormat:@"%@",sessionTitle];
                }
                else if (sessionTitle!=nil && duration!=nil && [duration intValue]!=0)
                {
                    cell.durationLabel.text = [NSString stringWithFormat:@"%@ (%@ mins)",sessionTitle,duration];
                }
                else if (sessionTitle!=nil && duration!=nil && [duration intValue]==0)
                {
                    cell.durationLabel.text = [NSString stringWithFormat:@"%@",sessionTitle];
                }
                else
                {
                    cell.durationLabel.text = @"";
                }
                //7March
                if (![Utility isEmptyCheck:[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"IsFavourite"]] && [[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"IsFavourite"] boolValue]) {
                    [cell.favButton setSelected:YES];
                } else {
                    [cell.favButton setSelected:NO];
                }//7March
            } else {
                cell.nameLabel.text = [[dict objectForKey:@"SessionTitle"] uppercaseString];
                cell.durationLabel.text = @"";
                cell.durationLabel.hidden = true;
                cell.favButton.hidden = true; //7March
            }
            
            //            cell.nameLabel.text = [[dict objectForKey:@"SessionTitle"] uppercaseString];
        } else {
            cell.nameLabel.text = @"";
            //chayan
            cell.durationLabel.text = @"";
        }
        
        if (![Utility isEmptyCheck:[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"IsDone"]] && [[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"IsDone"] boolValue]) {
            [cell.checkButton setSelected:YES];

        } else {
            [cell.checkButton setSelected:NO];
        }
        
        if (![Utility isEmptyCheck:[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"RepeatNextWeek"]] && [[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"RepeatNextWeek"] boolValue]) {
            [cell.repeateButton setSelected:YES];
        } else {
            [cell.repeateButton setSelected:NO];
        }
        
        [cell.checkButton addTarget:self action:@selector(checkButtonTapped:)
                   forControlEvents:UIControlEventTouchUpInside];
        [cell.checkButton setTag:[[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"Id"] integerValue]];
        
        [cell.repeateButton addTarget:self action:@selector(repeatButtonTapped:)
                     forControlEvents:UIControlEventTouchUpInside];
        [cell.repeateButton setTag:[[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"Id"] integerValue]];
        [cell.favButton setTag:[[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"Id"] integerValue]];//632018_feedback
        
        [cell setTag:[[[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"ExerciseSessionDetails"] objectForKey:@"Id"] integerValue]];    //ah aec
        [cell setAccessibilityHint:[[[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"ExerciseSessionDetails"] objectForKey:@"SessionCategory"] stringValue]]; //ah se
        
        //chayan
        //        cell.durationLabel.hidden = false;
        
        cell.nameLabel.hidden = false;
        cell.addButton.hidden = true;
        cell.addMyWorkoutLabel.hidden = true; //new_feedback_today
        cell.middleSeparatorView.hidden = false;
        
        
        //====
        NSString *dateString = [[weekFilterArray objectAtIndex:0]objectForKey:@"StartDateTimeStr"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:dateString];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        
        if([today day] == [components day] && [today month] == [components month] && [today year] == [components year]) { //feedback_work
            cell.dayNameLabel.textColor = [Utility colorWithHexString:@"E425A0"];
            cell.nameLabel.textColor = [Utility colorWithHexString:@"58595b"]; //new_feedback_today
            cell.durationLabel.textColor = [Utility colorWithHexString:@"a6a8ab"]; //new_feedback_today
            cell.editBackImage.image = [UIImage imageNamed:@"black_arrow.png"];
            cell.backImage.image = [UIImage imageNamed:@"black_arrow.png"];
            [cell.checkButton setImage:[UIImage imageNamed:@"uncheck_black_circle_personal.png"] forState:UIControlStateNormal];
            [cell.checkButton setImage:[UIImage imageNamed:@"check_black_circle_personal.png"] forState:UIControlStateSelected];
            
        }else{
            cell.dayNameLabel.textColor = [Utility colorWithHexString:@"bbbdbf"];
            cell.nameLabel.textColor = [Utility colorWithHexString:@"bbbdbf"];
            cell.durationLabel.textColor = [Utility colorWithHexString:@"bbbdbf"]; //new_feedback_today
            cell.editBackImage.image = [UIImage imageNamed:@"gray_arrow.png"];
            cell.backImage.image = [UIImage imageNamed:@"gray_arrow.png"];
            [cell.checkButton setImage:[UIImage imageNamed:@"uncheck_circle_personal.png"] forState:UIControlStateNormal];
            [cell.checkButton setImage:[UIImage imageNamed:@"check_circle_personal.png"] forState:UIControlStateSelected];
        } //feedback_work
        //7March
        NSInteger day = [components day];
        // NSLog(@"%ld",(long)day);
        NSUInteger index;
        NSUInteger value;
        if (isMyfav) {
            value =   weekFilterArray.count;
        }else{
            value =  (weekFilterArray.count > 1) ? weekFilterArray.count : weekFilterArray.count+1;
        }
        NSLog(@"%@",weekdays[indexPath.section]);
        NSLog(@"====%ld",(long)indexPath.row);
        
        if (value == (indexPath.row+1)) {
            cell.dividerView.hidden= false;
        }else{
            cell.dividerView.hidden = true;
        }
        
        index = value/2;
        if (isMyfav) {
            if (index == 0) {
                index = index +1;
            }
        }  //7March
        
        if (indexPath.row+1 == index) {
            cell.dayNameLabel.hidden = false;
            
            if (indexPath.section == 6) {
                //                    cell.dayNameLabel.text = [[@"" stringByAppendingFormat:@"%@\n%ld",[weekdays objectAtIndex:0],(long)day]uppercaseString];//feedback_work
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[[@"" stringByAppendingFormat:@"%@",[weekdays objectAtIndex:0]]uppercaseString]];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:16] range:NSMakeRange(0, [attributedString length])];
                
                NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:[[@"" stringByAppendingFormat:@"\n%ld",(long)day]uppercaseString]];
                [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:23] range:NSMakeRange(0, [attributedString2 length])];
                
                [attributedString appendAttributedString:attributedString2];
                cell.dayNameLabel.attributedText = attributedString;
                
            } else {
                //                    cell.dayNameLabel.text = [[@"" stringByAppendingFormat:@"%@\n%ld",[weekdays objectAtIndex:indexPath.section+1],(long)day]uppercaseString]; //feedback_work
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[[@"" stringByAppendingFormat:@"%@",[weekdays objectAtIndex:indexPath.section+1]]uppercaseString]];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:16] range:NSMakeRange(0, [attributedString length])];
                NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:[[@"" stringByAppendingFormat:@"\n%ld",(long)day]uppercaseString]];
                [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:23] range:NSMakeRange(0, [attributedString2 length])];
                
                [attributedString appendAttributedString:attributedString2];
                cell.dayNameLabel.attributedText = attributedString;
            }
            NSLog(@"DayLabel-%@",cell.dayNameLabel.text);
        }
        else{
            cell.dayNameLabel.hidden = true;
            cell.dayNameLabel.text = @"";
        }
        //            }
        //=
        
        if (isEdit) {
            cell.stackViewLeadingConstant.constant = 45; //add_n
            cell.checkButton.hidden = true;
            
            [cell.stack insertArrangedSubview:cell.swapEqualButton atIndex:0];//==
            [cell.stack insertArrangedSubview:cell.editBackImage atIndex:2];
            
            cell.swapEqualButton.hidden = false;
            
            cell.editDeleteButtonView.hidden = false;
            
            cell.middleSeparatorViewTrallingConstant.constant = 183;//add
            //add_su_today
            cell.middleSeparatorView.hidden = false;
            cell.repeatSeparatorView.hidden = true;
            cell.backImage.hidden = true;
            cell.editBackImage.hidden= false;
            //add_su_today--end
            
            NSLog(@"ISEDIT--%f",cell.middleSeparatorViewTrallingConstant.constant);
            cell.repeateButton.hidden = true;
            cell.favButton.hidden = true; //632018_feedback
            [cell.editButton addTarget:self action:@selector(editButtonTapped:)
                      forControlEvents:UIControlEventTouchUpInside];
            [cell.editButton setTag:[[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"Id"] integerValue]];
            [cell.editButton setAccessibilityHint:[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"StartDateTime"]];   //
            
            
            /*if(sessionFlowId == TIMER || sessionFlowId == CIRCUITTIMER || sessionFlowId == FOLLOWALONG){
                cell.editButton.hidden = true;
            }else{*/
                cell.editButton.hidden = false;
            //}
            
            [cell.deleteButton addTarget:self action:@selector(deleteButtonTapped:)
                        forControlEvents:UIControlEventTouchUpInside];
            [cell.deleteButton setTag:[[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"Id"] integerValue]];
            
            [cell.swapEqualButton addTarget:self action:@selector(swapEqualButtonTapped:)
                           forControlEvents:UIControlEventTouchUpInside];
            [cell.swapEqualButton setTag:[[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"Id"] integerValue]];
            [cell.swapEqualButton setAccessibilityHint:[NSString stringWithFormat:@"%d",(int)indexPath.section]];
        } else {
            cell.swapEqualButton.hidden = true;
            cell.editDeleteButtonView.hidden = true;
            cell.checkButton.hidden = false;
            NSLog(@"==========%f",cell.middleSeparatorViewTrallingConstant.constant);
            cell.middleSeparatorViewTrallingConstant.constant = 183+50;//add
            //add_su_today
            cell.middleSeparatorView.hidden = true;
            cell.repeatSeparatorView.hidden = false;
            cell.backImage.hidden = false;
            cell.editBackImage.hidden= true;
            //add_su_today--End
            cell.repeateButton.hidden = false; //add
            //7March
            if (cell.tag > 0 && !isEdit && ([cell.accessibilityHint intValue] == 1 || [cell.accessibilityHint intValue] == 4)) {
                cell.favButton.hidden = false;//632018_feedback
            }else{
                cell.favButton.hidden = true;
            }//7March
            [cell.stack removeArrangedSubview:cell.swapEqualButton];//==
            [cell.swapEqualButton removeFromSuperview];
            
            [cell.stack removeArrangedSubview:cell.editBackImage];
            [cell.editBackImage removeFromSuperview];
            
            cell.stackViewLeadingConstant.constant= 45+50;
        }
        
        [cell.moveSwapButton setTitle:@"Swap Here" forState:UIControlStateNormal];
        [cell.moveSwapButton addTarget:self action:@selector(moveSwapButtonTapped:)
                      forControlEvents:UIControlEventTouchUpInside];
        [cell.moveSwapButton setTag:[[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"Id"] integerValue]];
        [cell.moveSwapButton setAccessibilityHint:@"swap"];
        
        if (selectedIndex == [[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"Id"] integerValue] && selectedSection == indexPath.section) {
            cell.moveSwapButton.hidden = true;
        } else if (selectedIndex >= 0 && selectedSection >= 0) {
            cell.moveSwapButton.hidden = false;
        } else {
            cell.moveSwapButton.hidden = true;
        }
        
        
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            
            if([self isOfflineAvailable:(int)cell.tag]){
                cell.contentView.alpha = 1.0;
               
            }else{
                cell.contentView.alpha = 0.2;
                
            }
            
        }else{
            cell.contentView.alpha = 1.0;
            
        }// AY 14032018
        
    } else {
        cell.dayNameLabel.textColor = [Utility colorWithHexString:@"bbbdbf"];
        //chayan
        
        if (isEdit) {
            cell.middleSeparatorViewTrallingConstant.constant = 183;
            cell.middleSeparatorView.hidden = false;
            cell.repeatSeparatorView.hidden = true;
            
            cell.backImage.hidden = true;
            cell.editBackImage.hidden= false;
        }else{
            cell.middleSeparatorViewTrallingConstant.constant = 183+50;
            cell.middleSeparatorView.hidden = true;
            cell.repeatSeparatorView.hidden = false;
            
            cell.backImage.hidden = false;
            cell.editBackImage.hidden= true;
        }
        cell.durationLabel.hidden = true;
        cell.nameLabel.hidden = true;
        
        if (isMyfav) {//632018_feedback
            cell.addButton.hidden = true;
            cell.addMyWorkoutLabel.hidden = true;
            cell.addMyWorkoutLabel.text = @"";

        }else{
            cell.addMyWorkoutLabel.hidden = false;
            cell.addButton.hidden = false;
            cell.addMyWorkoutLabel.text = @"ADD WORKOUT";
        }//632018_feedback
        cell.backImage.hidden = true;///aaaa
        cell.checkButton.hidden = true;
        cell.repeateButton.hidden = true;
        cell.favButton.hidden = true;//632018_feedback
        cell.middleSeparatorView.hidden = true;
        cell.swapEqualButton.hidden = true;
        [cell.stack removeArrangedSubview:cell.swapEqualButton];//==
        [cell.swapEqualButton removeFromSuperview];
        
        [cell.stack removeArrangedSubview:cell.editBackImage];//==
        [cell.editBackImage removeFromSuperview];
        
        cell.editDeleteButtonView.hidden = true;
        
        [cell.moveSwapButton setTitle:@"Move Here" forState:UIControlStateNormal];
        [cell.moveSwapButton addTarget:self action:@selector(moveSwapButtonTapped:)
                      forControlEvents:UIControlEventTouchUpInside];
        //        [cell.moveSwapButton setTag:[[[weekFilterArray objectAtIndex:indexPath.row] objectForKey:@"Id"] integerValue]];
        [cell.moveSwapButton setTag:indexPath.section];
        [cell.moveSwapButton setAccessibilityHint:@"move"];
        
        if (selectedIndex >= 0 && selectedSection >= 0) {
            cell.moveSwapButton.hidden = false;
        } else {
            cell.moveSwapButton.hidden = true;
        }
        //==
        cell.dayNameLabel.hidden = true;
        cell.dayNameLabel.text = @"";
        
        if([Utility isEmptyCheck:weekFilterArray]){
            NSString *dateString = weekDayStr;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [dateFormatter dateFromString:dateString];
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
            NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
            
            if([today day] == [components day] && [today month] == [components month] && [today year] == [components year]) { //feedback_work
                cell.dayNameLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                cell.nameLabel.textColor = [Utility colorWithHexString:@"58595b"]; //new_feedback_today
                cell.durationLabel.textColor = [Utility colorWithHexString:@"a6a8ab"]; //new_feedback_today
                cell.editBackImage.image = [UIImage imageNamed:@"black_arrow.png"];
                cell.backImage.image = [UIImage imageNamed:@"black_arrow.png"];
                [cell.checkButton setImage:[UIImage imageNamed:@"uncheck_black_circle_personal.png"] forState:UIControlStateNormal];
                [cell.checkButton setImage:[UIImage imageNamed:@"check_black_circle_personal.png"] forState:UIControlStateSelected];
            }else{
                cell.dayNameLabel.textColor = [Utility colorWithHexString:@"bbbdbf"];
                cell.nameLabel.textColor = [Utility colorWithHexString:@"bbbdbf"];
                cell.durationLabel.textColor = [Utility colorWithHexString:@"bbbdbf"]; //new_feedback_today
                cell.editBackImage.image = [UIImage imageNamed:@"gray_arrow.png"];
                cell.backImage.image = [UIImage imageNamed:@"gray_arrow.png"];
                [cell.checkButton setImage:[UIImage imageNamed:@"uncheck_circle_personal.png"] forState:UIControlStateNormal];
                [cell.checkButton setImage:[UIImage imageNamed:@"check_circle_personal.png"] forState:UIControlStateSelected];
            }
            
            
            if (indexPath.section == 6) { //new_feedback_today
                cell.dayNameLabel.hidden = false;
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[[@"" stringByAppendingFormat:@"%@",[weekdays objectAtIndex:0]]uppercaseString]];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:16] range:NSMakeRange(0, [attributedString length])];
    
                NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:[[@"" stringByAppendingFormat:@"\n%ld",(long)components.day]uppercaseString]];
                [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:23] range:NSMakeRange(0, [attributedString2 length])];
    
                [attributedString appendAttributedString:attributedString2];
                cell.dayNameLabel.attributedText = attributedString; //feedback_work
            } else  {
                cell.dayNameLabel.hidden = false;
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[[@"" stringByAppendingFormat:@"%@",[weekdays objectAtIndex:indexPath.section+1]]uppercaseString]];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:16] range:NSMakeRange(0, [attributedString length])];
                
                NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:[[@"" stringByAppendingFormat:@"\n%ld",(long)components.day]uppercaseString]];
                [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:23] range:NSMakeRange(0, [attributedString2 length])];
                
                  [attributedString appendAttributedString:attributedString2];
                cell.dayNameLabel.attributedText = attributedString; //feedback_work
                
            }//new_feedback_today

        }
        
        cell.dividerView.hidden = false;
        
        
        
        //
        [cell.addButton addTarget:self action:@selector(addButtonTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
        [cell.addButton setTag:indexPath.section];
        [cell setTag:0];
        [cell setAccessibilityHint:@"0"];
    }
    cell.repeateButton.hidden = true;
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];    //ah aec
    NSArray *weekFilterArray = [self getCurrentDayDataFromDayComp:indexPath.section];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];                                                                         [formatter setDateFormat:@"yyyy-MM-dd"];

  
    if (cell.tag > 0 && !isEdit && ([cell.accessibilityHint intValue] == 1 || [cell.accessibilityHint intValue] == 4)) {
        
        if([Utility isSubscribedUser] && [Utility isOfflineMode] && ![self isOfflineAvailable:(int)cell.tag]){
            [Utility msg:@"You are in OFFLINE mode and this session hasn't been previously downloaded. Please remove offline mode and download this session while you have access to the internet." title:@"Oops!\n" controller:self haveToPop:NO];
            return;
        }
        
        //ah se
        ExerciseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDetails"];
        NSDictionary *exerciseDetails = [weekFilterArray objectAtIndex:indexPath.row];//AY 01112017
        controller.exSessionId = (int)cell.tag;
        controller.delegate = self;
        controller.weekDate =  [NSString stringWithFormat:@"%@T00:00:00",[formatter stringFromDate:weekstart]];//AY 01112017
        controller.sessionDate =  ![Utility isEmptyCheck:exerciseDetails[@"StartDateTime"]] ? exerciseDetails[@"StartDateTime"] : @"";
        controller.fromWhere =@"customSession";
        controller.workoutTypeId = [[exerciseDetails objectForKey:@"Id"] intValue]; //AY 02112017
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        if([cell.accessibilityHint intValue]==5){
            [self showFBWAlert];
        }
    }
}
#pragma mark - End
//Today_SetProgram_In
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([[URL scheme] isEqualToString:@"Revert"])
    {
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [Utility msg:@"You are in OFFLINE mode. Go online to Revert." title:@"Oops!\n" controller:self haveToPop:NO];
            YES;
        }//AY 07032018
        
        if (![Utility isEmptyCheck:ProgramIdStr] && ![Utility isEmptyCheck:UserProgramIdStr] && ![Utility isEmptyCheck:weekstart]) {
            ResetProgramViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ResetProgramView"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];//@"yyyy-MM-dd'T'HH:mm:ss"
            NSString *weekStartStr = [dateFormat stringFromDate:weekstart];
            controller.weekStartDayStr = weekStartStr;
            
            controller.programIdStr = ProgramIdStr;
            controller.userprogramIdStr = UserProgramIdStr;
            controller.option = @"CancelExercise";
            controller.modalPresentationStyle = UIModalPresentationCustom;
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        }else{
            [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
        }
        return NO;
    }
    return YES;
}

-(void)didPerformRevertOption{
//    [self getSquadUserMealSessionJoiningDateApiCall];
     [self getSquadUserWorkoutSessionWothDate:weekstart];
}
//Today_SetProgram_In
#pragma mark  -ExerciseDetailsDelegate

-(void)didCheckAnyChange:(BOOL)ischanged{
    isChanged = ischanged;
}

#pragma mark - End
-(void)viewPersonalUpdateView:(NSNotification*)notification{
    isChanged = true;
}
-(void)reloadFromExerciseFooter:(NSNotification*)notification{
    isChanged = true;
}
@end
