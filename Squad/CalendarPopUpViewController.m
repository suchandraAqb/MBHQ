//
//  CalendarPopUpViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 18/08/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "CalendarPopUpViewController.h"

@interface CalendarPopUpViewController (){
    
    IBOutlet JTHorizontalCalendarView *calendarContentView;
    JTCalendarManager *calendarManager;
    IBOutlet UILabel *yearLabel;
    IBOutlet UILabel *monthLabel;
    NSArray *monthsArray;
    __weak IBOutlet UILabel *headerLabel;
    
}
@end

@implementation CalendarPopUpViewController
@synthesize delegate,selectedDate,fromController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    calendarManager = [JTCalendarManager new];
    calendarManager.delegate = self;
    
    //    [calendarManager setMenuView:_calendarMenuView];
    [calendarManager setContentView:calendarContentView];
    [calendarManager setDate:selectedDate];
    [self setDateAndYearLabel:selectedDate];
    monthsArray = [[NSArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    if([fromController isEqualToString:@"fitness"]){
        headerLabel.text = @"";
    }
}

#pragma mark -IBAction
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
- (IBAction)backButtonPressed:(UIButton *)sender {
    if([delegate respondsToSelector:@selector(cancelInPopUp)]){
        [delegate cancelInPopUp];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -End
-(void)setDateAndYearLabel:(NSDate *)currentDate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSCalendar* tempCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [tempCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
        
        self->yearLabel.text=[@"" stringByAppendingFormat:@"%d",(int)[components year]];
        self->monthLabel.text=[@"" stringByAppendingFormat:@"%@",[self->monthsArray objectAtIndex:(int)[components month]-1]];
        
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
#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView


- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
//    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    dayView.hidden = false;
    // Other month
    if(![calendarManager.dateHelper date:calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
        dayView.hidden = true;
    }
    // selected date
    else if([calendarManager.dateHelper date:selectedDate isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor whiteColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f];
        dayView.circleView.layer.borderWidth = 1;
        dayView.circleView.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    }
    
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd"];
    today = [df dateFromString:[df stringFromDate:today]];
    NSLog(@"%@  %@  %@",dayView.date,[NSDate date],today);
    if([fromController isEqualToString:@"fitness"]){
        selectedDate = dayView.date;
        if([delegate respondsToSelector:@selector(didSelectDateInPopUp:)]){
            [delegate didSelectDateInPopUp:selectedDate];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        if ([dayView.date isEarlierThan:today]) {
            [calendarManager setDate:selectedDate];
            [self setDateAndYearLabel:selectedDate];
            [Utility msg:@"Please select the date later than or equal to today" title:@"" controller:self haveToPop:NO];
        } else {
            selectedDate = dayView.date;
            if([delegate respondsToSelector:@selector(didSelectDateInPopUp:)]){
                [delegate didSelectDateInPopUp:selectedDate];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}
#pragma mark-End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
