//
//  CalendarViewController.h
//  The Life
//
//  Created by AQB SOLUTIONS on 30/03/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
#import "MasterMenuViewController.h"
#import "Utility.h"

@interface CalendarViewController : UIViewController<JTCalendarDelegate,UITableViewDelegate,UITableViewDataSource>


//@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
//@property (strong, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
//@property (strong, nonatomic) JTCalendar *calendar;
@property (strong, nonatomic) IBOutlet UIButton *previousPageButton;
@property (strong, nonatomic) IBOutlet UIButton *nextPageButton;
@property (nonatomic)BOOL isFromAshyLive;


- (IBAction)btnNextMonth:(id)sender;
- (IBAction)btnPreviousMonth:(id)sender;
@end
