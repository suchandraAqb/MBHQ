//
//  WaterIntakeViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 20/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "WaterIntakeViewController.h"

@interface WaterIntakeViewController (){

    IBOutlet UILabel *lastStreak;
    IBOutlet UILabel *topStreak;
    IBOutlet UILabel *currentMonth;
    IBOutlet UILabel *currentDate;
}
@property (strong, nonatomic) NSCalendar *gregorianCalendar;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSArray *datesWithEvent;


@end

@implementation WaterIntakeViewController
#pragma mark -ViewLifeCycle -
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",[UIFont familyNames]);
    _calendar.dataSource = self;
    _calendar.delegate = self;
    _calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    _calendar.currentPage = [NSDate date];
    _calendar.pagingEnabled = NO; // important
    _calendar.allowsMultipleSelection = NO;
    _calendar.firstWeekday = 2;
    _calendar.placeholderType = FSCalendarPlaceholderTypeFillHeadTail;
    _calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase|FSCalendarCaseOptionsHeaderUsesDefaultCase;
    _calendar.appearance.weekdayTextColor = FSCalendarStandardTitleTextColor;
    _calendar.weekdayHeight = 0;//hide week day view
    
    _calendar.appearance.titleFont =[UIFont fontWithName:@"Roboto-Regular" size:15];
    _calendar.appearance.titleDefaultColor = [UIColor whiteColor];
    
    _calendar.appearance.headerTitleColor = [UIColor whiteColor];
    _calendar.appearance.headerTitleFont = [UIFont fontWithName:@"Raleway-Medium" size:3];
    _calendar.appearance.eventDefaultColor = [UIColor clearColor];
    _calendar.appearance.selectionColor = [UIColor clearColor];
    _calendar.appearance.headerDateFormat = @"MMMM yyyy";
    //_calendar.appearance.todayColor = FSCalendarStandardTodayColor;
    _calendar.appearance.borderRadius = 1.0;
    _calendar.appearance.headerMinimumDissolvedAlpha = 0.2;
    
    _datesWithEvent = @[@"2016-10-03",
                        @"2016-10-07",
                        @"2016-10-15",
                        @"2016-10-25"];
    self.images = @{@"2016-11-01":[UIImage imageNamed:@"WaterPercentLow"],
                    @"2016-11-05":[UIImage imageNamed:@"WaterPercentMedium"],
                    @"2016-11-20":[UIImage imageNamed:@"WaterPercentFull"],
                    @"2016-11-07":[UIImage imageNamed:@"WaterPercentMedium"]};
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.locale = [NSLocale currentLocale];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
}
#pragma mark - End -

#pragma mark - IBAction
- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)shareButtonPressed:(id)sender {
}

#pragma mark - End

#pragma mark - FSCalendarDataSource

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    return  nil;
}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    return nil;

}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    return [_datesWithEvent containsObject:[self.dateFormatter stringFromDate:date]];
}



#pragma mark - FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    return YES;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change to page %@",[self.dateFormatter stringFromDate:calendar.currentPage]);
}

- (void)calendarCurrentScopeWillChange:(FSCalendar *)calendar animated:(BOOL)animated
{
    [self.view layoutIfNeeded];
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    [self.view layoutIfNeeded];
}

- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleOffsetForDate:(NSDate *)date
{

    return CGPointZero;
}

- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventOffsetForDate:(NSDate *)date
{
    return CGPointZero;
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventSelectionColorsForDate:(nonnull NSDate *)date
{
    if ([self calendar:calendar subtitleForDate:date]) {
        return @[appearance.eventDefaultColor];
    }
    if ([_datesWithEvent containsObject:[self.dateFormatter stringFromDate:date]]) {
        return @[[UIColor clearColor]];
    }
    return nil;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    if ([_datesWithEvent containsObject:[self.dateFormatter stringFromDate:date]]) {
        return [UIColor clearColor];
    }
    return nil;
}



- (CGFloat)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderRadiusForDate:(nonnull NSDate *)date
{
    
    return 0.0;
}

- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance imageOffsetForDate:(NSDate *)date{
    if ([[self.images allKeys] containsObject:[self.dateFormatter stringFromDate:date]]) {
        return CGPointMake(0, -10);
    }
    return CGPointZero;
    
}

- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    NSLog(@"%@----%@",dateString,self.images[dateString]);
    return self.images[dateString];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
