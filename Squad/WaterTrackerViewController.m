//
//  WaterTrackerViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 26/02/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "WaterTrackerViewController.h"
#import "DropdownViewController.h"
#import "SongPlayListViewController.h"

#import <AVKit/AVKit.h> //song19
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

//chayan
#import "Utility.h"
#import "AddActionTableViewCell.h"
@interface WaterTrackerViewController ()<SPTAudioStreamingDelegate,SPTAudioStreamingPlaybackDelegate> {
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
    
    NSMutableDictionary *savedReminderDict;     //ah ln1
    
    //chayan
    NSMutableArray *actionHistoryArray;
    IBOutlet UITableView *actionHistorytable;
    IBOutlet NSLayoutConstraint *actionHistorytableHeightConstraint;
    NSInteger previousIndex;
    NSInteger startIndex;
    NSInteger endIndex;
    //add_su_new
    NSMutableArray *reminderIdListArray;
    BOOL isActionCheck;
    IBOutlet UIButton *actionSaveButton;
    
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
    __weak IBOutlet UILabel *topStreakLabel;

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
    NSArray *trackListArray;
    NSMutableArray *trackDayArray;
    NSDate *currentDateOfTheMonth;
    BOOL isDateTapped;
    BOOL isChanged;
}

@end

static float defaultWaterGoal = 2.2;

@implementation WaterTrackerViewController
@synthesize waterTrackerdelegate;
#pragma Mark - Vie@w Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    actionHistoryArray=[[NSMutableArray alloc] init];
    
    calendarManager = [JTCalendarManager new];
    calendarManager.delegate = self;
    [calendarManager setContentView:calendarContentView];
    [calendarManager setDate:[NSDate date]];
    
    monthsArray = [[NSArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    
//    [lastStreakView setNeedsLayout];
//    [lastStreakView layoutIfNeeded];
//    [bestStreakView setNeedsLayout];
//    [bestStreakView layoutIfNeeded];
//    lastStreakView.layer.borderWidth = 1;
//    lastStreakView.layer.borderColor = squadMainColor.CGColor;
//    lastStreakView.layer.masksToBounds = YES;
//    lastStreakView.layer.cornerRadius = lastStreakView.frame.size.height / 2;
//    bestStreakView.layer.borderWidth = 1;
//    bestStreakView.layer.borderColor = squadMainColor.CGColor;
//    bestStreakView.layer.masksToBounds = YES;
//    bestStreakView.layer.cornerRadius = bestStreakView.frame.size.height / 2;
    [self setDateAndYearLabel:[NSDate date]];
    
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [actionHistorytable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
//    [actionHistorytable removeObserver:self forKeyPath:@"contentSize"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - End

#pragma mark - IBAction
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
        [self setUpdaysInaMonth:currentDate];
    });
}
-(void)setUpdaysInaMonth:(NSDate*)currentDate{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->trackDayArray = [[NSMutableArray alloc]init];
        NSCalendar* tempCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components1 = [tempCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        NSDateComponents* components2 = [tempCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
        if ([components1 year] == [components2 year]) {
            if ([components1 month] == [components2 month]) {
                NSLog(@"========%d",(int)[components2 month]);
                
                NSDate *firstMontnDay = [self->calendarManager.dateHelper firstDayOfMonth:currentDate];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];//yyyy-MM-dd'T'HH:mm:ss" 2019-03-12T00:00:00
                NSDate *startDate = firstMontnDay; // your start date
                NSDate *endDate = currentDate; // your end date
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
                    NSLog(@"Same Month===============%@", [df stringFromDate:date]);
                    [self->trackDayArray addObject:[df stringFromDate:date]];
                }
            }else{
                NSDate *firstMontnDay = [self->calendarManager.dateHelper firstDayOfMonth:currentDate];
                NSDate *lastMonthday = [self->calendarManager.dateHelper lastDayOfMonth:currentDate];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                NSDate *startDate = firstMontnDay; // your start date
                NSDate *endDate = lastMonthday; // your end date
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
                    NSLog(@"%@", [df stringFromDate:date]);
                    [self->trackDayArray addObject:[df stringFromDate:date]];
                    
                }
            }
        }else{
            NSDate *firstMontnDay = [self->calendarManager.dateHelper firstDayOfMonth:currentDate];
            NSDate *lastMonthday = [self->calendarManager.dateHelper lastDayOfMonth:currentDate];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *startDate = firstMontnDay; // your start date
            NSDate *endDate = lastMonthday; // your end date
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
                NSLog(@"%@", [df stringFromDate:date]);
                [self->trackDayArray addObject:[df stringFromDate:date]];
                
            }
        }
        if (![Utility isEmptyCheck:self->trackDayArray]&& self->trackDayArray.count>0) {
            NSArray *trackSortArr = [self sortedArray:self->trackDayArray];
            if (![Utility isEmptyCheck:trackSortArr]) {
                [self->trackDayArray removeAllObjects];
                self->trackDayArray = [trackSortArr mutableCopy];
            }
        }
    });
    if (_isFromTodayOrMealMatch) {
        isDateTapped = true;
        [self getWaterLevel_webServiceCall:[NSDate date]];

    }else{
        isDateTapped = false;
        [self getWaterLevel_webServiceCall:currentDate];
    }

}
-(NSArray*)sortedArray:(NSMutableArray *)arr{
        NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self"
                                                                    ascending: NO];
        return [arr sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
}

-(IBAction)addWaterToSpecificDay:(id)sender{
//    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
//    controller.modalPresentationStyle = UIModalPresentationCustom;
//    controller.maxDate = [NSDate date];
//    controller.selectedDate = [NSDate date];
//    controller.datePickerMode = UIDatePickerModeDate;
//    controller.delegate = self;
//    [self presentViewController:controller animated:YES completion:nil];
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Add water goal"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Enter water in ml";
         textField.keyboardType = UIKeyboardTypeNumberPad;
         
     }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *water = alertController.textFields.firstObject;
                                   [self saveWater:[water.text intValue]];
                                   
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
        self->_isFromTodayOrMealMatch = false;
        [self setDateAndYearLabel:currentDate];
    });
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDate *currentDate = calendar.date;
        self->_isFromTodayOrMealMatch = false;
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
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    dayView.hidden = false;
    
//    // Other month
    if(![calendarManager.dateHelper date:calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];//lightGrayColor
        dayView.hidden = true;
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.textLabel.textColor = [UIColor blackColor];
        dayView.textLabel.hidden = NO;
        
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor clearColor];
        dayView.circleView.layer.borderWidth = 0.0;
        dayView.dayImage.hidden = YES;
        dayView.dayImage.image = nil;
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat: @"yyyy-MM-dd"];
        NSString *date = [@"" stringByAppendingFormat:@"%@",[df stringFromDate:dayView.date]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(intake_date == %@)",[@"" stringByAppendingFormat:@"%@",[formatter stringFromDate:[df dateFromString:date]]]];
        NSArray *filteredArray = [trackListArray filteredArrayUsingPredicate:predicate];
        if (![Utility isEmptyCheck:filteredArray] && filteredArray.count>0) {
            if (![Utility isEmptyCheck:[filteredArray objectAtIndex:0]]) {
                float waterAmount = [[[filteredArray objectAtIndex:0] objectForKey:@"amount"]floatValue];
                float waterMiliAmount = [self convertMiliToLitre:waterAmount];
                if (waterMiliAmount<=0.0) {
                    waterMiliAmount = 0.0;
                }
                float waterGoal = ![Utility isEmptyCheck:[[filteredArray objectAtIndex:0] objectForKey:@"goalAmount"]]?[[[filteredArray objectAtIndex:0] objectForKey:@"goalAmount"]floatValue]:0.0;
                waterGoal = [self convertMiliToLitre:waterGoal];
                if (waterGoal <= 0.0) {
                    waterGoal = defaultWaterGoal;
                }
                if (waterMiliAmount >= waterGoal) {
                    //tick
                    dayView.circleView.hidden = YES;
                    dayView.dayImage.hidden = NO;
                    dayView.dayImage.image = [UIImage imageNamed:@"vitamin_tick_big.png"];
                    dayView.textLabel.hidden = YES;
                }else if (waterMiliAmount<waterGoal && waterMiliAmount>0) {
                    //green
                    dayView.circleView.backgroundColor = [Utility colorWithHexString:@"93E2DD"];
                    dayView.circleView.layer.borderWidth = 1.0;
                    dayView.circleView.layer.borderColor = [UIColor colorWithRed:147/255.0 green:226/255.0 blue:221/255.0 alpha:1.0].CGColor;
                }else{
                    //gray
                    dayView.circleView.layer.borderWidth = 1.0;
                    dayView.circleView.layer.borderColor = [squadSubColor colorWithAlphaComponent:0.5].CGColor;
                }
            }else{
                //gray
                dayView.circleView.layer.borderWidth = 1.0;
                dayView.circleView.layer.borderColor = [squadSubColor colorWithAlphaComponent:0.5].CGColor;
            }
        }else{
            //gray
            dayView.circleView.layer.borderWidth = 1.0;
            dayView.circleView.layer.borderColor = [squadSubColor colorWithAlphaComponent:0.5].CGColor;
        }
        
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    NSLog(@"Calender");
    if ([dayView.date isLaterThan:[NSDate date]]) {
        return;
    }
    isDateTapped = true;
    [self getWaterLevel_webServiceCall:dayView.date];
}

#pragma mark - API Call

-(void)getWaterLevel_webServiceCall:(NSDate*)currentDate{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSCalendar* tempCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [tempCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[NSNumber numberWithInt:(int)[components month]] forKey:@"Month"];
        [mainDict setObject:[NSNumber numberWithInt:(int)[components year]] forKey:@"Year"];
        if (isDateTapped) {
            [mainDict setObject:[NSNumber numberWithInt:(int)[components day]] forKey:@"Day"];
        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetWaterLevel" append:@"" forAction:@"POST"];

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
                                                                         self->trackListArray = [responseDict objectForKey:@"TrackList"];
                                                                         
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"LastStreakCount"]]) {
                                                                             self->lastStreakLabel.text = [NSString stringWithFormat:@"%@",[responseDict objectForKey:@"LastStreakCount"]];
                                                                         }
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"TopStreakCount"]]) {
                                                                             self->topStreakLabel.text = [NSString stringWithFormat:@"%@",[responseDict objectForKey:@"TopStreakCount"]];
                                                                         }
//                                                                         [self->actionHistorytable reloadData];
                                                                         [self->calendarManager reload];
                                                                         if (self->isDateTapped) {
                                                                             if (![Utility isEmptyCheck:self->trackListArray] && self->trackListArray.count>0) {
                                                                                 
                                                                                 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                                 [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                                                                                 NSDateFormatter *df = [NSDateFormatter new];
                                                                                 [df setDateFormat: @"yyyy-MM-dd"];
                                                                                 NSString *date = [@"" stringByAppendingFormat:@"%@",[df stringFromDate:currentDate]];
                                                                                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(intake_date == %@)",[@"" stringByAppendingFormat:@"%@",[formatter stringFromDate:[df dateFromString:date]]]];
                                                                                 NSArray *filteredArray = [self->trackListArray filteredArrayUsingPredicate:predicate];
                                                                                 if (![Utility isEmptyCheck:filteredArray] && filteredArray.count>0) {
                                                                                     if (![Utility isEmptyCheck:[filteredArray objectAtIndex:0]]) {
                                                                                         [self goToWaterTrackerDetails:[filteredArray objectAtIndex:0]];
                                                                                     }
                                                                                     
                                                                                 }
                                                                                 
//                                                                                 [self goToWaterTrackerDetails:[self->trackListArray objectAtIndex:0]];
                                                                             }else{
                                                                                 NSMutableDictionary *trackDict =[[NSMutableDictionary alloc]init];
                                                                                 
                                                                                if (![Utility isEmptyCheck:[responseDict objectForKey:@"TopStreakCount"]]) {
                                                                                       [trackDict setObject:[responseDict objectForKey:@"TopStreakCount"] forKey:@"topStreakCount"];
                                                                                   }
                                                                                 
                                                                                 if (![Utility isEmptyCheck:[responseDict objectForKey:@"LastStreakCount"]]) {
                                                                                     [trackDict setObject:[responseDict objectForKey:@"LastStreakCount"] forKey:@"lastStreakCount"];
                                                                                 }
                                                                                  [trackDict setObject:[defaults objectForKey:@"UserID"] forKey:@"user_id"];
                                                                                  [trackDict setObject:[NSNumber numberWithInt:0] forKey:@"amount"];
                                                                                 
                                                                                 if (![Utility isEmptyCheck:currentDate]) {
                                                                                     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                                                                     [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                                                                     [trackDict setObject:[dateFormatter stringFromDate:currentDate] forKey:@"IntakeDateAsString"];
                                                                                 }
                                                                                 [self goToWaterTrackerDetails:trackDict];
                                                                             }
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
-(void)saveWater:(int)water{
    if (Utility.reachable) {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[NSNumber numberWithInt:water] forKey:@"GoalAmountInMl"];
        [mainDict setObject:[df stringFromDate:[NSDate date]] forKey:@"GoalDate"];
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateWaterGoal" append:@""forAction:@"POST"];
        
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         
                                                                         [Utility msg:@"Water goal saved successfully" title:@"Success" controller:self haveToPop:NO];
                                                                         [self getWaterLevel_webServiceCall:[NSDate date]];
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

#pragma mark - Private Method

-(void)goToWaterTrackerDetails:(NSDictionary*)trackDict {
    if (![Utility isEmptyCheck:trackDict]) {
        WaterTrackerDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WaterTrackerDetailsView"];
        controller.trackDict = trackDict;
        controller.delegate = self;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }
}
-(float)convertMiliToLitre:(float)miliLitre{
    return miliLitre/1000;
}

-(void)checkForChange:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"backButtonPressed"]) {
        if ([waterTrackerdelegate respondsToSelector:@selector(didCheckAnyChangeInWaterTracker:)]) {
            [waterTrackerdelegate didCheckAnyChangeInWaterTracker:isChanged];
        }
        [self backButtonPressed:nil];
    }
}
#pragma mark - Table View Datasource Delegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return trackDayArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddActionTableViewCell *cell= (AddActionTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"AddActionTableViewCell"];
    if (cell==nil) {
        cell = [[AddActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddActionTableViewCell"];
    }
    
    if (![Utility isEmptyCheck:trackDayArray]&& trackDayArray.count>0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString: [trackDayArray objectAtIndex:indexPath.row]];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd"];
        cell.nameLabel.text = [dateFormatter stringFromDate:date];
        
        if (![Utility isEmptyCheck:trackListArray] && trackListArray.count>0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(intake_date == %@)",[@"" stringByAppendingFormat:@"%@",[trackDayArray objectAtIndex:indexPath.row]]];
            NSArray *filteredArray = [trackListArray filteredArrayUsingPredicate:predicate];
            if (![Utility isEmptyCheck:filteredArray] && filteredArray.count>0) {
//                NSNumber *max = [filteredArray valueForKeyPath:@"@max.amount.floatValue"];
//                NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(amount == %@)",max];
//                NSArray *maxAmountArray = [filteredArray filteredArrayUsingPredicate:predicate1];
                
                if (![Utility isEmptyCheck:[filteredArray objectAtIndex:0]]) {
                    float waterAmount = [[[filteredArray objectAtIndex:0] objectForKey:@"amount"]floatValue];
                    float waterMiliAmount = [self convertMiliToLitre:waterAmount];
                    if (waterMiliAmount<=0.0) {
                        waterMiliAmount = 0.0;
                    }
                    cell.waterAmount.text = [@"" stringByAppendingFormat:@"%@ L",[Utility customRoundNumber:waterMiliAmount]];
                    float waterGoal = ![Utility isEmptyCheck:[[filteredArray objectAtIndex:0] objectForKey:@"goalAmount"]]?[[[filteredArray objectAtIndex:0] objectForKey:@"goalAmount"]floatValue]:0.0;
                    waterGoal = [self convertMiliToLitre:waterGoal];
                    if (waterGoal <= 0.0) {
                        waterGoal = defaultWaterGoal;
                    }
                    if (waterMiliAmount >= waterGoal) {
                        cell.checkButton.hidden = false;
                        cell.checkButton.selected = true;
                    }else{
                        cell.checkButton.hidden = true;
                    }
                }
            }else{
                cell.waterAmount.text = @"";
                cell.checkButton.hidden = true;
            }
           
        }else{
            cell.waterAmount.text = @"";
            cell.checkButton.hidden = true;
        }
    }
    return cell;
}

#pragma mark - End

#pragma mark - Observers Method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    if (object == actionHistorytable) {
//        actionHistorytableHeightConstraint.constant=actionHistorytable.contentSize.height;
//    }
}

#pragma mark - End

#pragma  mark - DatePickerViewControllerDelegate

-(void)didSelectDate:(NSDate *)date{
    isDateTapped = YES;
    [self getWaterLevel_webServiceCall:date];
}

#pragma mark - End

#pragma mark - Water tracker Delegate
-(void)dataReload:(NSDate *)currentDate{
    isDateTapped =false;
    isChanged = true;
    [self getWaterLevel_webServiceCall:currentDate];
}
#pragma mark - End
@end












