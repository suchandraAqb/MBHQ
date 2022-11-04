//
//  CalendarViewController.m
//  The Life
//
//  Created by AQB SOLUTIONS on 30/03/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarEventTableViewCell.h"
#import "WebinarSelectedViewController.h"
#import "PodcastViewController.h"

@interface CalendarViewController (){
    IBOutlet UIScrollView *scroll;

    IBOutlet UITableView *eventTable;
    IBOutlet NSLayoutConstraint *eventTableHeightConstraint;
    IBOutlet UILabel *monthLabel;
    IBOutlet UILabel *yearLabel;
    NSArray *monthsArray;
    NSArray *prevMonthArray;
    NSArray *nextMonthArray;
    NSMutableArray *eventArray;
    NSDateComponents *comp;
    NSMutableArray *modifiedEventArray;
    UIView *contentView;
    NSCalendar *gregorian;
    JTCalendarManager *calendarManager;
    NSDate *_dateSelected;
    NSMutableDictionary *modifiedEventData;
    
    IBOutlet UILabel *prevLabel;
    IBOutlet UILabel *nextLabel;
    IBOutlet UIImageView *headerBg;
}
@end

@implementation CalendarViewController
@synthesize previousPageButton,nextPageButton,isFromAshyLive;


#pragma mark - Private Function -
-(void)getEventDetailsByID:(NSDictionary *)eventDetails{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
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
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         dispatch_async(dispatch_get_main_queue(),^ {
                                                                             WebinarSelectedViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarSelectedView"];
                                                                             controller.webinar = [responseDictionary mutableCopy];
                                                                             if ([[eventDetails objectForKey:@"IsUpcomingEvent"] boolValue]) {
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
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
            return;
        });
        
    }
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    dispatch_async(dispatch_get_main_queue(), ^{
        eventTableHeightConstraint.constant = eventTable.contentSize.height;
    });

}
-(void)getUpcomingWebinars{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpcomingWebinarsApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSArray *responseArray= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseArray]) {
                                                                         eventArray =[[NSMutableArray alloc]initWithArray:responseArray];
                                                                        

                                                                         [calendarManager reload];
                                                                         if(eventArray.count>0){
                                                                             [self setDateAndYearLabel:[NSDate date]];
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
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


-(void)setDateAndYearLabel:(NSDate *)currentDate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSCalendar* tempCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [tempCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
        
        yearLabel.text=[@"" stringByAppendingFormat:@"%d",(int)[components year]];
        monthLabel.text=[@"" stringByAppendingFormat:@"%@",[monthsArray objectAtIndex:(int)[components month]-1]];
        NSString *key=[@"" stringByAppendingFormat:@"%d-%02d",(int)[components year],(int)[components month]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Date beginswith[c] %@", key];
        NSArray *filteredArray = [eventArray filteredArrayUsingPredicate:predicate];
        modifiedEventArray = [[NSMutableArray alloc]init];
        for (int i = 0; i< filteredArray.count; i++) {
            NSDictionary *dict = [filteredArray objectAtIndex:i];
            if (![Utility isEmptyCheck:dict]) {
                [modifiedEventArray addObjectsFromArray:[dict valueForKey:@"Events"]];
                            }
        }
        if (isFromAshyLive) {
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"EventTypename == %@", @"14"];
           NSArray *tempModifiedEventArray = [modifiedEventArray filteredArrayUsingPredicate:predicate1];
            if (tempModifiedEventArray.count == 0) {
                predicate1 = [NSPredicate predicateWithFormat:@"EventTypename == %@", @"AshyLive"];
                modifiedEventArray = [[modifiedEventArray filteredArrayUsingPredicate:predicate1] mutableCopy];
            }else{
                modifiedEventArray = [tempModifiedEventArray mutableCopy];
            }
        }


        [eventTable reloadData];
    });
}
- (void) goToFbWithWebinarsData: (NSDictionary *)webinarsData {     //ah ux2
    NSString *urlString = [webinarsData objectForKey:@"FbAppUrl"];
    //urlString = @"fb://profile?id=250625228700325&permalink=279802639115917";
    //urlString = @"fb://group/1416808211675824/permalink/1416815778341734/";
    //https://www.facebook.com/groups/1416808211675824/permalink/1416815778341734/
    //urlString = @"fb://group?id=1416808211675824&object_id=1416815778341734&view=permalink";
    //urlString = @"fb://groups?id=1416808211675824&post_id=1416815778341734";
    
    //            https://www.facebook.com/groups/1416808211675824/
    
    // urlString=@"https://www.facebook.com/groups/1416808211675824/permalink/1416815778341734/";
    
    //urlString=@"https://www.facebook.com/groups/250625228700325/permalink/276333556129492/";
    if (![Utility isEmptyCheck:urlString]) {
        //                NSURL *url = [NSURL URLWithString:urlString];
        //                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success){
        //                    if (success) {
        //                        NSLog(@"well done");
        //                    }else{
        //                        NSString *urlString = [webinarsData objectForKey:@"FbUrl"];
        //                        if (![Utility isEmptyCheck:urlString]) {
        //                                NSURL *url = [NSURL URLWithString:urlString];
        //                                [[UIApplication sharedApplication] openURL:url];
        //                            }
        //                    }
        //                }];
        NSURL *url = [NSURL URLWithString:urlString];
        if ([[UIApplication sharedApplication] openURL:url]){
            NSLog(@"well done");
        }else {
            urlString = [webinarsData objectForKey:@"FbUrl"];
            if (![Utility isEmptyCheck:urlString]) {
                url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }else{
        urlString = [webinarsData objectForKey:@"FbUrl"];
        if (![Utility isEmptyCheck:urlString]) {
            NSURL *url = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

-(void)addCalendarPoints{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    NSString *ReferenceEntityId = [df stringFromDate:[NSDate date]];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary new];
    [dataDict setObject:[NSNumber numberWithInt:43] forKey:@"UserActionId"];
    if(ReferenceEntityId)[dataDict setObject:ReferenceEntityId forKey:@"ReferenceEntityId"];
    [dataDict setObject:@"SquadCalendar" forKey:@"ReferenceEntityType"];
    
    [Utility addGamificationPointWithData:dataDict];
}
#pragma mark - End -

#pragma mark - IBAction -

- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - End -
#pragma mark -ViewLifeCycle -
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        headerBg.image = [UIImage imageNamed:@"header-4s.png"];
    }else{
        headerBg.image = [UIImage imageNamed:@"header.png"];
    }
    modifiedEventData=[[NSMutableDictionary alloc]init];
    eventTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    eventArray = [[NSMutableArray alloc]init];
    
    calendarManager = [JTCalendarManager new];
    calendarManager.delegate = self;
    
    [calendarManager setMenuView:_calendarMenuView];
    [calendarManager setContentView:_calendarContentView];
    [calendarManager setDate:[NSDate date]];
    
    monthsArray = [[NSArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    
        [self setDateAndYearLabel:[NSDate date]];
        [self getUpcomingWebinars];
        [self addCalendarPoints];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup

//    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MasterMenuViewController class]]) {
//        MasterMenuViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterMenuView"];
//        controller.delegateMasterMenu=self;
//        self.slidingViewController.underLeftViewController  = controller;
//    }
//    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

#pragma mark -End -


- (IBAction)btnNextMonth:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_calendarContentView loadNextPageWithAnimation];
    });
}

- (IBAction)btnPreviousMonth:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_calendarContentView loadPreviousPageWithAnimation];
    });
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


#pragma mark - Transition examples

#pragma mark - TableView Datasource & Delegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self.view setNeedsUpdateConstraints];
    return modifiedEventArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier =@"CalendarEventTableViewCell";
    CalendarEventTableViewCell *cell = (CalendarEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[CalendarEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict =[modifiedEventArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        NSString *eventDate = [dict objectForKey:@"StartDate"];
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        NSDate *date = [dateFormatter dateFromString:eventDate];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
        NSInteger weekday = [components weekday];
        NSString *weekdayName = [dateFormatter weekdaySymbols][weekday - 1];
        dateFormatter.dateFormat = @"dd";
        NSString *day = [dateFormatter stringFromDate:date];
        dateFormatter.dateFormat = @"hh:mm a";
        NSString *time = [dateFormatter stringFromDate:date];
        cell.eventDay.text = [NSString stringWithFormat:@"%@ %@", weekdayName, day];
        cell.eventTime.text = time;
        NSString *event =@"";
        NSString *eventName = [dict valueForKey:@"Name"];
        cell.eventColor.layer.cornerRadius = cell.eventColor.frame.size.width/2;
        cell.eventColor.clipsToBounds = YES;
        if (![Utility isEmptyCheck:eventName]) {
            event = [eventName stringByAppendingString:@"-"];
        }
        NSString *eventPresenterName = [dict valueForKey:@"PresenterName"];

        if (![Utility isEmptyCheck:eventPresenterName]) {
            event = [event stringByAppendingFormat:@"-%@",eventPresenterName];;
        }
        NSString *eventTypeName = [dict objectForKey:@"EventTypename"];
        float alpha = 1.0;
        if (![[dict objectForKey:@"IsUpcomingEvent"] boolValue]) {
            alpha = 0.2;
            cell.eventName.textColor = [UIColor blackColor];
            cell.eventDay.textColor = [UIColor blackColor];
            cell.eventTime.textColor = [UIColor blackColor];

        }
        if ([eventTypeName isEqualToString:@"Podcast"]){
            cell.eventColor.backgroundColor = [UIColor colorWithRed:131.0f/255.0f green:217.0f/255.0f blue:239.0f/255.0f alpha:alpha];
        }else if ([eventTypeName isEqualToString:@"Seminar"]){
            cell.eventColor.backgroundColor =[UIColor colorWithRed:131.0f/255.0f green:217.0f/255.0f blue:239.0f/255.0f alpha:alpha];
        }else if ([eventTypeName isEqualToString:@"Webinar"]){
            cell.eventColor.backgroundColor = [UIColor colorWithRed:131.0f/255.0f green:217.0f/255.0f blue:239.0f/255.0f alpha:alpha];
        }else if ([eventTypeName isEqualToString:@"14"] || [eventTypeName isEqualToString:@"AshyLive"]){
            cell.eventColor.backgroundColor = [UIColor colorWithRed:249.0f/255.0f green:147.0f/255.0f blue:234.0f/255.0f alpha:alpha];
        }else if ([eventTypeName isEqualToString:@"Raw"]){
            cell.eventColor.backgroundColor = [UIColor colorWithRed:145.0f/255.0f green:145.0f/255.0f blue:242.0f/255.0f alpha:alpha];
        }else if ([eventTypeName isEqualToString:@"WeeklyWellness"]){
            cell.eventColor.backgroundColor = [UIColor colorWithRed:114.0f/255.0f green:205.0f/255.0f blue:148.0f/255.0f alpha:alpha];
        }else if ([eventTypeName isEqualToString:@"FridayFoodAndNutrition"]){
            cell.eventColor.backgroundColor = [UIColor colorWithRed:250.0f/255.0f green:164.0f/255.0f blue:76.0f/255.0f alpha:alpha];
        }else if ([eventTypeName isEqualToString:@"MovementMonday"]){
            cell.eventColor.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:130.0f/255.0f blue:136.0f/255.0f alpha:alpha];
        }else{
            cell.eventColor.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:252.0f/255.0f blue:119.0f/255.0f alpha:alpha];
        }
        cell.eventName.text = event;
        components = nil;
    }
    [self.view setNeedsUpdateConstraints];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(),^ {
        NSDictionary *webinarsData = [modifiedEventArray objectAtIndex:indexPath.row];
        NSString *eventTypeName = [webinarsData objectForKey:@"EventTypename"];
        //if (isFromAshyLive) {
        if (![Utility isEmptyCheck:eventTypeName] && ([eventTypeName isEqualToString:@"14"] || [eventTypeName isEqualToString:@"AshyLive"] || [eventTypeName isEqualToString:@"17"] || [eventTypeName isEqualToString:@"FridayFoodAndNutrition"] || [eventTypeName isEqualToString:@"16"] || [eventTypeName isEqualToString:@"WeeklyWellness"])) {
            //ah ux2
            if ([defaults boolForKey:@"isFirstTimeLive"]) {
                [defaults setBool:NO forKey:@"isFirstTimeLive"];
                
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Please Note"
                                                      message:@"If you haven’t already joined your forum, please know this chat is in the World Forum, your access will be granted soon. Please request to join from Connect section."
                                                      preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               [self goToFbWithWebinarsData:webinarsData];
                                           }];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                [self goToFbWithWebinarsData:webinarsData];
            }
        }else if(![Utility isEmptyCheck:eventTypeName] && [eventTypeName isEqualToString:@"Podcast"]){
            NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinarsData valueForKey:@"EventItemVideoDetails"]];
            if (eventItemVideoDetailsArray.count > 0) {
                NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
                if (![Utility isEmptyCheck:eventItemVideoDetails]) {
                    NSString *urlString = [eventItemVideoDetails objectForKey:@"PodcastURL" ];
                    if (![Utility isEmptyCheck:urlString]) {
                        PodcastViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Podcast"];
                        controller.urlString = urlString;
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                }
            }
        }else{
            [self getEventDetailsByID:webinarsData];
        }
        
    });
}

#pragma mark -endx

#pragma mark - Fake data

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}
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
    else if(_dateSelected && [calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        
        UIColor *temp=dayView.circleView.backgroundColor;
        
        if([temp isEqual:[UIColor whiteColor]]){
            dayView.circleView.hidden = NO;
            //        dayView.circleView.backgroundColor = dayView.circleView.backgroundColor;
            dayView.circleView.backgroundColor = [UIColor whiteColor];
            dayView.dotView.backgroundColor = [UIColor lightGrayColor];
            dayView.textLabel.textColor = [UIColor blackColor];
        }
    }
    // Other month
    else if(![calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
  
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
//    UIImageView *i = [[UIImageView alloc]initWithFrame:dayView.circleView.bounds];
//    i.image = [UIImage imageNamed:@"tick_circle.png"];
//    [dayView.circleView addSubview:i];
//    i.center = dayView.circleView.center;
    
    if (eventArray.count>0){
        NSCalendar* tempCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [tempCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dayView.date];
        NSString *key=[@"" stringByAppendingFormat:@"%d-%02d",(int)[components year],(int)[components month]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Date beginswith[c] %@", key];
        NSArray *filteredArray = [eventArray filteredArrayUsingPredicate:predicate];
        for (int i = 0; i< filteredArray.count; i++) {
            NSArray *eventSubArray = [[filteredArray objectAtIndex:i] valueForKey:@"Events"];
            NSString *key=[@"" stringByAppendingFormat:@"%d-%02d-%02d",(int)[components year],(int)[components month],(int)[components day]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"StartDate beginswith[c] %@", key];
            NSArray *filteredArray = [eventSubArray filteredArrayUsingPredicate:predicate];
            if (isFromAshyLive) {
                NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"EventTypename == %@", @"14"];
               NSArray *filteredArray1 = [filteredArray filteredArrayUsingPredicate:predicate1];
                if (filteredArray1.count == 0) {
                    predicate1 = [NSPredicate predicateWithFormat:@"EventTypename == %@", @"AshyLive"];
                    filteredArray = [filteredArray filteredArrayUsingPredicate:predicate1];
                }else{
                    filteredArray = filteredArray1;
                }
            }
            if (filteredArray.count > 0) {
                dayView.circleView.hidden = NO;
                dayView.textLabel.textColor = [UIColor whiteColor];
                float alpha = 1.0;
                if (![[[filteredArray objectAtIndex:0] objectForKey:@"IsUpcomingEvent"] boolValue]) {
                    alpha = 0.2;
                }
                NSString *eventTypeName = [[filteredArray objectAtIndex:0] objectForKey:@"EventTypename"];
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

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        //[calendarManager reload];
                        NSCalendar* tempCalendar = [NSCalendar currentCalendar];
                        NSDateComponents* components = [tempCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dayView.date]; // Get necessary date components
                        NSString *key=[@"" stringByAppendingFormat:@"%d-%02d-%02d",(int)[components year],(int)[components month],(int)[components day]];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"StartDate beginswith[c] %@", key];
                        NSArray *filteredArray = [modifiedEventArray filteredArrayUsingPredicate:predicate];
                        if (filteredArray.count > 0) {
                            int s =(int)[modifiedEventArray indexOfObject:[filteredArray objectAtIndex:0]];
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:s inSection:0];
                            CalendarEventTableViewCell *cell = (CalendarEventTableViewCell *)[eventTable cellForRowAtIndexPath:indexPath];
                            CGRect animatedViewFrame = [eventTable convertRect:cell.frame toView:scroll];
                            [scroll scrollRectToVisible:animatedViewFrame animated:YES];                        }

                    } completion:nil];
    
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


@end
