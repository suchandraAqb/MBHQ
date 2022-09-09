//
//  PersonalChallengeDetailsViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 17/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "PersonalChallengeDetailsViewController.h"
#import "PersonalChallengeTableViewCell.h"

@interface PersonalChallengeDetailsViewController (){
    
    __weak IBOutlet UILabel *challengeLabel;
    __weak IBOutlet UILabel *startDateLabel;
    __weak IBOutlet UILabel *EndDateLabel;
    __weak IBOutlet UIButton *partipantsButton;
    
    __weak IBOutlet UILabel *yearLabel;
    __weak IBOutlet UILabel *monthLabel;
    __weak IBOutlet UIView *lastStreakView;
    __weak IBOutlet UILabel *lastStreakLabel;
    __weak IBOutlet UIView *bestStreakView;
    __weak IBOutlet UILabel *bestStreakLabel;
    __weak IBOutlet UITableView *table;
    __weak IBOutlet NSLayoutConstraint *tableHeightConstraint;
    IBOutlet JTHorizontalCalendarView *calendarContentView;
    JTCalendarManager *calendarManager;
    
    NSArray *monthsArray;
    NSDateFormatter *formatter;
    
    __weak IBOutlet UIButton *saveButton;
    __weak IBOutlet UIButton *backButton;
    UIView *contentView;
    NSDictionary *challengeDict;
    NSArray *selectedArray;
    NSMutableArray *toggleSaveArray;
    BOOL isLoad;
}

@end

@implementation PersonalChallengeDetailsViewController
@synthesize habitId,delegate,taskId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    toggleSaveArray = [NSMutableArray new];
    table.estimatedRowHeight = 40;
    table.rowHeight = UITableViewAutomaticDimension;
    isLoad = false;
//    table.hidden = true;
    formatter = [NSDateFormatter new];
    [lastStreakView setNeedsLayout];
    [lastStreakView layoutIfNeeded];
    [bestStreakView setNeedsLayout];
    [bestStreakView layoutIfNeeded];
    lastStreakView.layer.borderWidth = 1;
    lastStreakView.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    lastStreakView.layer.masksToBounds = YES;
    lastStreakView.layer.cornerRadius = lastStreakView.frame.size.height / 2;
    bestStreakView.layer.borderWidth = 1;
    bestStreakView.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    bestStreakView.layer.masksToBounds = YES;
    bestStreakView.layer.cornerRadius = bestStreakView.frame.size.height / 2;
    backButton.layer.borderWidth = 1;
    backButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    calendarManager = [JTCalendarManager new];
    calendarManager.delegate = self;
    
//    [calendarManager setMenuView:_calendarMenuView];
    [calendarManager setContentView:calendarContentView];
    [calendarManager setDate:[NSDate date]];
    
    monthsArray = [[NSArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    
    saveButton.hidden = true;
    
//    [self getPersonalChallengeCalendarView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getPersonalChallengeCalendarView];
    [table addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [table removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
}
-(void)checkForChange:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"backButtonPressed"]) {
        if([delegate respondsToSelector:@selector(didChangePersonalChallengeDetails:)]){
            [delegate didChangePersonalChallengeDetails:isLoad];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -IBAction
- (IBAction)refreshPressed:(UIButton *)sender {
    [calendarManager setDate:[NSDate date]];
    [self setDateAndYearLabel:[NSDate date]];
    //    [mainScroll setHidden:false];
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
- (IBAction)checkUncheckPressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    NSDictionary *dict = [selectedArray objectAtIndex:sender.tag];
    if ([toggleSaveArray containsObject:dict[@"goal_mindset_reminder_master_id"]]) {
        [toggleSaveArray removeObject:dict[@"goal_mindset_reminder_master_id"]];
    }else{
        [toggleSaveArray addObject:dict[@"goal_mindset_reminder_master_id"]];
    }
    if (toggleSaveArray.count>0) {
        saveButton.hidden = false;
    } else {
        saveButton.hidden = true;
    }
}
- (IBAction)challengeHistoryPressed:(UIButton *)sender {
    table.hidden = !table.isHidden;
}
- (IBAction)saveHistoryPressed:(UIButton *)sender {
    if (toggleSaveArray.count>0) {
        [self togglePersonalChallengeTask:toggleSaveArray];
    }
    
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    if([delegate respondsToSelector:@selector(didChangePersonalChallengeDetails:)]){
        [delegate didChangePersonalChallengeDetails:isLoad];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -End
#pragma mark -Private Method
-(void)updateView{
    if (![Utility isEmptyCheck:challengeDict]) {
        selectedArray = challengeDict[@"goal_mindset_reminder_master_Details"];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(reminder_datetime <= %@)",[formatter stringFromDate:[NSDate date]]];
        NSArray *filteredArray = [selectedArray filteredArrayUsingPredicate:predicate];
        if (filteredArray.count>0) {
            selectedArray = filteredArray;
            table.hidden = false;
        }else{
            selectedArray = [NSArray new];
            table.hidden = true;
        }
        //
        int lastCount = 0;
        int bestCount = 0;
        int tempBestCount = 0;
        BOOL breaked = true;
        int isFirst = 0;
        for (NSDictionary *temp in selectedArray) {
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
        
        //
        challengeLabel.text = ![Utility isEmptyCheck:challengeDict[@"Name"]]?[challengeDict[@"Name"]uppercaseString]:@"";
        
        if ([[formatter dateFromString:challengeDict[@"CreatedAt"]] isEarlierThanOrEqualTo:[NSDate date]] && [[NSDate date] isEarlierThanOrEqualTo:[formatter dateFromString:challengeDict[@"EndDate"]]]) {
            [challengeLabel setTextColor:[UIColor colorWithRed:(76/255.0f) green:(217/255.0f) blue:(100/255.0f) alpha:1.0f]];
        }else{
            [challengeLabel setTextColor:[UIColor colorWithRed:(228/255.0f) green:(39/255.0f) blue:(160/255.0f) alpha:1.0f]];
        }
        
        [partipantsButton setTitle:[NSString stringWithFormat:@"%@ PARTICIPANTS",challengeDict[@"JoinMember"]] forState:UIControlStateNormal];
        partipantsButton.layer.borderWidth = 1;
        partipantsButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *date = [formatter dateFromString:challengeDict[@"CreatedAt"]];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        startDateLabel.text = [NSString stringWithFormat:@"START DATE: %@",[formatter stringFromDate:date]];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        date = [formatter dateFromString:challengeDict[@"EndDate"]];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        EndDateLabel.text = [NSString stringWithFormat:@"END DATE: %@",[formatter stringFromDate:date]];
    }
    [calendarManager setDate:[NSDate date]];
    [self setDateAndYearLabel:[NSDate date]];
    [table reloadData];
}
-(void)setDateAndYearLabel:(NSDate *)currentDate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSCalendar* tempCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [tempCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
        
        self->yearLabel.text=[@"" stringByAppendingFormat:@"%d",(int)[components year]];
        self->monthLabel.text=[@"" stringByAppendingFormat:@"%@",[self->monthsArray objectAtIndex:(int)[components month]-1]];
        
    });
}
-(void)getPersonalChallengeCalendarView{
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"userId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:habitId forKey:@"ChallengeId"];
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"PersonalChallengeCalendarView" append:@""forAction:@"POST"];
        
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         self->challengeDict = [responseDict objectForKey:@"Details"];
                                                                         [self updateView];
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
                                                                         self->saveButton.hidden = true;
                                                                         [self->toggleSaveArray removeAllObjects];
                                                                         self->isLoad = true;
                                                                         [self getPersonalChallengeCalendarView];
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
#pragma mark -TableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return selectedArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalChallengeTableViewCell *cell = (PersonalChallengeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PersonalChallengeTableViewCell"];
//    NSArray *history = challengeDict[@"goal_mindset_reminder_master_Details"];
    NSDictionary *dict = [selectedArray objectAtIndex:indexPath.row];
    NSString *sdate = dict[@"reminder_datetime"];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [df dateFromString:sdate];
    [df setDateFormat:@"EEEE MMMM dd"];
    cell.dateLabel.text = [df stringFromDate:date];
    cell.checkButton.selected = ![Utility isEmptyCheck:dict[@"is_action"]]?[dict[@"is_action"] boolValue]:false;
    
    cell.checkButton.tag = (int)indexPath.row;
    return cell;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == table) {
        tableHeightConstraint.constant = table.contentSize.height;
    }
}
#pragma mark -End
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
    else if([calendarManager.dateHelper date:dayView.date isEqualOrAfter:[formatter dateFromString:challengeDict[@"CreatedAt"]] andEqualOrBefore:[formatter dateFromString:challengeDict[@"EndDate"]]]){
        BOOL selected = false;
        for (NSDictionary *dict in selectedArray) {
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
//        if (!challengeDict){//selected
//            dayView.circleView.hidden = NO;
//            dayView.circleView.backgroundColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f];
//            dayView.dotView.backgroundColor = [UIColor whiteColor];
//            dayView.textLabel.textColor = [UIColor whiteColor];
//        } else {selectedArray
//            dayView.circleView.hidden = NO;
//            dayView.circleView.backgroundColor = [UIColor whiteColor];
//            dayView.circleView.layer.borderWidth = 1;
//            dayView.circleView.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
//            dayView.dotView.backgroundColor = [UIColor whiteColor];
//            dayView.textLabel.textColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f];
//        }
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
#pragma mark-End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
