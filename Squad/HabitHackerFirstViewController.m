//
//  HabitHackerFirstViewController.m
//  Squad
//
//  Created by Dhiman on 26/08/20.
//  Copyright © 2020 AQB Solutions. All rights reserved.
//

#import "HabitHackerFirstViewController.h"
#import "TableViewCell.h"
#import "HabitStatsViewController.h"
#import "HabitHackerDetailsViewController.h"
#import "HabitHackerDetailNewViewController.h"
#import "WinTheWeekViewController.h"
#import "WinTheWeekResultViewController.h"
#import "HabitHackerListViewController.h"
@interface HabitHackerFirstViewController ()
{
    IBOutlet UITableView *habitTable;
    IBOutlet UIView *addButtonShowView;
    IBOutlet UIButton *habitListButton;
    IBOutlet UILabel *percentageShowLabel;
    IBOutlet UIView *editDelView;
    IBOutlet UIButton *editButton;
    IBOutlet UIButton *delButton;
    IBOutlet UIView *editDelSubView;
    IBOutlet UIView *infoview;
    IBOutlet UIButton *createHabitNowButton;
    IBOutlet UIButton *showMeExample;
    IBOutlet UIButton *walkThroughGotItButton;
    
    
    IBOutlet UILabel *dateHeadingLabel;
    IBOutlet UIView *dateListView;
    IBOutlet UIView *dateListSubView;
    
    IBOutletCollection(UIButton) NSArray *dateListButtonArray;
    
    IBOutlet UIButton *savetickButton;
    IBOutlet UIView *saveView;
    IBOutlet UIButton *cancelButton;

    
    bool checkAllButton;
    bool crossAllButton;
    bool uncheckAllButton;
    NSMutableArray *allButtons;
    

    NSArray *habitArray;
    UIView *contentView;
    int twiceDailyCount;
    int twiceDailyCountForBreak;
    NSMutableArray *habitListArray;
    BOOL isShowAllHabits;
    NSDictionary *habitDetailsDictionary;
    
    NSMutableArray *DateListArray;
    NSDictionary *selectedDateDict;
    NSMutableArray *updateTAskArr;
    NSMutableArray *updateHabitArr;
    NSDate *weekStartDate;
     UIRefreshControl *refreshControl;
    NSDate *currentVisibleDate;
    
    IBOutlet UIButton *crossButton;
    IBOutlet UILabel *heyUserLabel;
    IBOutlet UIButton *iAmGratefulButton;
    IBOutlet UIView *dailyPopUpView;
    IBOutlet UIView *dailyPopUpInnerView;
    IBOutlet UIView *gratitudeBtnView;
    
    IBOutlet UIButton *tickAllButton;

}
@end

@implementation HabitHackerFirstViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([Utility isEmptyCheck:[defaults objectForKey:@"DailyPopUp"]]) {
            [defaults setObject:[NSDate date] forKey:@"DailyPopUp"];
            dailyPopUpView.hidden = false;
        dailyPopUpInnerView.layer.cornerRadius=15;
        dailyPopUpInnerView.layer.masksToBounds=true;
        iAmGratefulButton.layer.cornerRadius=15;
        iAmGratefulButton.layer.masksToBounds=true;
        gratitudeBtnView.layer.cornerRadius = 15;
        gratitudeBtnView.layer.masksToBounds =true;
        NSString *username = [defaults objectForKey:@"FirstName"];
        username = username.uppercaseString;
        NSLog(@"FirstName======>%@",username);
        NSLog(@"");
        
        NSString *welcomeUser = @"HEY ";
        UIFont *welcomeUserFont = [UIFont fontWithName:@"Raleway" size:18];
        NSMutableAttributedString *attributedString1 =
        [[NSMutableAttributedString alloc] initWithString:welcomeUser attributes:@{
            NSFontAttributeName : welcomeUserFont}];
        
        UIFont *usernameFont = [UIFont fontWithName:@"Raleway-Bold" size:22];
        NSMutableAttributedString *attributedString2 =
        [[NSMutableAttributedString alloc] initWithString:username attributes:@{
            NSFontAttributeName : usernameFont}];
//                                  NSString *welcomeUser = [@"" stringByAppendingFormat:@"HEY %@",attributedString1];
        [attributedString1 appendAttributedString:attributedString2];
        NSLog(@"attributedString1======>%@",attributedString1);
        NSLog(@"");
        heyUserLabel.attributedText = attributedString1;
        }
        else if (![Utility isEmptyCheck:[defaults objectForKey:@"DailyPopUp"]]){
            NSDate *lastShownDate=[defaults objectForKey:@"DailyPopUp"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *lastShownDateString = [formatter stringFromDate:lastShownDate];
            NSString *todayDateStr=[formatter stringFromDate:[NSDate date]];
            
            lastShownDate=[formatter dateFromString:lastShownDateString];
            NSDate *todayDate=[formatter dateFromString:todayDateStr];
            if ([todayDate compare:lastShownDate] == NSOrderedDescending) {
//                [Utility isEmptyCheck:[defaults objectForKey:@"DontShowDailyPopUp"]];
                if (![Utility isEmptyCheck:[defaults objectForKey:@"DontShowDailyPopUp"]]/*[defaults boolForKey:@"DontShowDailyPopUp"]*/) {
                    [defaults setObject:[NSNumber numberWithBool:true] forKey:@"DontShowDailyPopUp"];
                    [defaults setObject:[NSDate date] forKey:@"DailyPopUp"];
                    dailyPopUpView.hidden = false;
                    dailyPopUpInnerView.layer.cornerRadius=15;
                    dailyPopUpInnerView.layer.masksToBounds=true;
                    iAmGratefulButton.layer.cornerRadius=15;
                    iAmGratefulButton.layer.masksToBounds=true;
                    gratitudeBtnView.layer.cornerRadius = 15;
                    gratitudeBtnView.layer.masksToBounds =true;
                    NSString *username = [defaults objectForKey:@"FirstName"];
                    username = username.uppercaseString;
                    NSLog(@"FirstName======>%@",username);
                    NSLog(@"");
                    
                    NSString *welcomeUser = @"HEY ";
                    UIFont *welcomeUserFont = [UIFont fontWithName:@"Raleway" size:18];
                    NSMutableAttributedString *attributedString1 =
                    [[NSMutableAttributedString alloc] initWithString:welcomeUser attributes:@{
                        NSFontAttributeName : welcomeUserFont}];
                    
                    UIFont *usernameFont = [UIFont fontWithName:@"Raleway-Bold" size:22];
                    NSMutableAttributedString *attributedString2 =
                    [[NSMutableAttributedString alloc] initWithString:username attributes:@{
                        NSFontAttributeName : usernameFont}];
//                                  NSString *welcomeUser = [@"" stringByAppendingFormat:@"HEY %@",attributedString1];
                    [attributedString1 appendAttributedString:attributedString2];
                    NSLog(@"attributedString1======>%@",attributedString1);
                    NSLog(@"");
                    heyUserLabel.attributedText = attributedString1;
                }else{
                }
            }else{
            }
        }

    if ([tickAllButton.currentImage isEqual:[UIImage imageNamed:@"untick_mbhq.png"]]) {
        [tickAllButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
    }else{
        [tickAllButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
    }

    DateListArray=[[NSMutableArray alloc] init];
    dateListSubView.layer.cornerRadius=10;
    dateListSubView.clipsToBounds=YES;
    
    savetickButton.layer.cornerRadius = 15;
    savetickButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = 15;
    cancelButton.layer.masksToBounds = YES;
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    if (@available(iOS 10.0, *)) {
        habitTable.refreshControl = refreshControl;
    } else {
        [habitTable addSubview:refreshControl];
    }
    

    [[NSNotificationCenter defaultCenter] addObserverForName:@"IsHackerListReload" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
                    dispatch_async(dispatch_get_main_queue(), ^{
    //                    [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];
                         [self webServicecallForGetGrowthHomePage_fromNotification:[defaults objectForKey:@"Date"]];
                       
                    });
            }];
    
    for (UIButton *btn in dateListButtonArray) {
        btn.layer.cornerRadius=10;
        btn.clipsToBounds=YES;
        btn.titleLabel.font=[UIFont fontWithName:@"Raleway-Bold" size:18];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:120 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self checkIfTodayDateChanged];
        NSInteger numberOfRows = [self->habitTable numberOfRowsInSection:0];
        NSMutableArray *untickAllButtons = [[NSMutableArray alloc] init];
        NSMutableArray *tickAllButtons = [[NSMutableArray alloc] init];
        NSMutableArray *CrossAllButtons = [[NSMutableArray alloc] init];
        NSMutableArray *allButtons = [[NSMutableArray alloc] init];
          for (NSInteger i = 0; i< numberOfRows; i++) {
               NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
              TableViewCell *cell = [self->habitTable cellForRowAtIndexPath:indexPath];
              if (cell.tickuntickButton != nil) {
                  [allButtons addObject:cell.tickuntickButton];
                  if ([cell.tickuntickButton.currentImage isEqual: [UIImage imageNamed:@"untick_mbhq.png"]]) {
                      [untickAllButtons addObject:cell.tickuntickButton];
                  }else if ([cell.tickuntickButton.currentImage isEqual: [UIImage imageNamed:@"tick_mbhq.png"]]) {
                      [tickAllButtons addObject:cell.tickuntickButton];
                  }else if ([cell.tickuntickButton.currentImage isEqual: [UIImage imageNamed:@"greycross.png"]]) {
                      [CrossAllButtons addObject:cell.tickuntickButton];
                  }
              }
          }
        if(allButtons.count > 0){
            if (allButtons.count == tickAllButtons.count) {
                [self->tickAllButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
            }else if (allButtons.count == CrossAllButtons.count) {
                [self->tickAllButton setImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];
            }else if (allButtons.count == untickAllButtons.count) {
                [self->tickAllButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
            }else{
                [self->tickAllButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
            }
        }
    }];
//    NSLog(@"HabitArray=======>%@",habitArray);
//    NSLog(@"");
}
-(void)viewDidAppear:(BOOL)animated{
    NSInteger numberOfRows = [habitTable numberOfRowsInSection:0];
    NSMutableArray *untickAllButtons = [[NSMutableArray alloc] init];
    NSMutableArray *tickAllButtons = [[NSMutableArray alloc] init];
    NSMutableArray *CrossAllButtons = [[NSMutableArray alloc] init];
    NSMutableArray *allButtons = [[NSMutableArray alloc] init];
      for (NSInteger i = 0; i< numberOfRows; i++) {
           NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
           TableViewCell *cell = [habitTable cellForRowAtIndexPath:indexPath];
          if (cell.tickuntickButton != nil) {
              [allButtons addObject:cell.tickuntickButton];
              if ([cell.tickuntickButton.currentImage isEqual: [UIImage imageNamed:@"untick_mbhq.png"]]) {
                  [untickAllButtons addObject:cell.tickuntickButton];
              }else if ([cell.tickuntickButton.currentImage isEqual: [UIImage imageNamed:@"tick_mbhq.png"]]) {
                  [tickAllButtons addObject:cell.tickuntickButton];
              }else if ([cell.tickuntickButton.currentImage isEqual: [UIImage imageNamed:@"greycross.png"]]) {
                  [CrossAllButtons addObject:cell.tickuntickButton];
              }
          }
      }
    if(allButtons.count > 0){
        if (allButtons.count == tickAllButtons.count) {
            [tickAllButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
        }else if (allButtons.count == CrossAllButtons.count) {
            [tickAllButton setImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];
        }else if (allButtons.count == untickAllButtons.count) {
            [tickAllButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
        }else{
            [tickAllButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    if (self->_isMoveToday) {
        self->_isMoveToday = false;
        //i can try adding popup view here
   
    }
    

//    else if ([tickAllButton.currentImage isEqual:[UIImage imageNamed:@"tick_mbhq.png"]]) {
//        [tickAllButton setImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];
//    }else if([tickAllButton.currentImage isEqual:[UIImage imageNamed:@"greycross.png"]]){
//        [tickAllButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
//    }
    
    selectedDateDict=[[NSDictionary alloc] init];
    updateTAskArr = [[NSMutableArray alloc]init];
    updateHabitArr = [[NSMutableArray alloc]init];
    saveView.hidden = true;
    dateHeadingLabel.text=@"TODAY'S HABITS";
    habitTable.estimatedRowHeight = 60;
    habitTable.rowHeight = UITableViewAutomaticDimension;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"IsHackerListDelete" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSLog(@"%@",notification.object);
//                 [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];
//                 [self webServicecallForGetGrowthHomePage:[defaults objectForKey:@"Date"]];
                 [self webServicecallForGetGrowthHomePage_fromNotification:[defaults objectForKey:@"Date"]];
                });
           }];
    
     [[NSNotificationCenter defaultCenter] addObserverForName:@"HabitFirstViewReload" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
      dispatch_async(dispatch_get_main_queue(), ^{
          NSLog(@"%@",notification.object);
//          [self webServicecallForGetGrowthHomePage:[defaults objectForKey:@"Date"]];
          [self webServicecallForGetGrowthHomePage_fromNotification:[defaults objectForKey:@"Date"]];
          });
    }];
    
    [self prepareView];

       if (!(habitArray.count>0)) {
              addButtonShowView.hidden = false;
              habitTable.hidden = true;
          }else{
              addButtonShowView.hidden = true;
              habitTable.hidden = false;
          }
          [habitTable reloadData];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    int daynumber=(int)[cal component:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSDate *todayDate=[NSDate date];
    if (daynumber==1) {
        weekStartDate=[todayDate dateBySubtractingDays:6];
    }else{
        weekStartDate=[todayDate dateBySubtractingDays:(daynumber-2)];
    }
    if(![Utility isEmptyCheck:[[NSUserDefaults standardUserDefaults]objectForKey:@"ActiveHabitList"]]){
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ActiveHabitList"];
    }
}
- (void)viewWillDisappear:(BOOL)animated{

    
}
#pragma mark - End

#pragma mark - IBAction

-(IBAction)cancelButtonPressed:(id)sender{
    [habitTable reloadData];
    saveView.hidden = true;
    [updateTAskArr removeAllObjects];
    [updateHabitArr removeAllObjects];
    NSInteger numberOfRows = [habitTable numberOfRowsInSection:0];
    NSMutableArray *untickAllButtons = [[NSMutableArray alloc] init];
    NSMutableArray *tickAllButtons = [[NSMutableArray alloc] init];
    NSMutableArray *CrossAllButtons = [[NSMutableArray alloc] init];
    NSMutableArray *allButtons = [[NSMutableArray alloc] init];
      for (NSInteger i = 0; i< numberOfRows; i++) {
           NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
           TableViewCell *cell = [habitTable cellForRowAtIndexPath:indexPath];
          if (cell.tickuntickButton != nil) {
              [allButtons addObject:cell.tickuntickButton];
              if ([cell.tickuntickButton.currentImage isEqual: [UIImage imageNamed:@"untick_mbhq.png"]]) {
                  [untickAllButtons addObject:cell.tickuntickButton];
              }else if ([cell.tickuntickButton.currentImage isEqual: [UIImage imageNamed:@"tick_mbhq.png"]]) {
                  [tickAllButtons addObject:cell.tickuntickButton];
              }else if ([cell.tickuntickButton.currentImage isEqual: [UIImage imageNamed:@"greycross.png"]]) {
                  [CrossAllButtons addObject:cell.tickuntickButton];
              }
          }
      }
    if (allButtons.count == tickAllButtons.count) {
        [tickAllButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
    }else if (allButtons.count == CrossAllButtons.count) {
        [tickAllButton setImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];
    }else if (allButtons.count == untickAllButtons.count) {
        [tickAllButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
    }else{
        [tickAllButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)saveButtonPressed:(id)sender{
    [self webSerViceCall_UpdateTaskStatus_Multiple];
}


- (IBAction)dateHeadingPressed:(UIButton *)sender {
    [self makeDateList];
    dateListView.hidden=false;
}

- (IBAction)closeDateListViewPressed:(UIButton *)sender {
    dateListView.hidden=true;
}

- (IBAction)dateListButtonPressed:(UIButton *)sender {
    saveView.hidden=true;
    if (updateTAskArr.count>0) {
        [updateTAskArr removeAllObjects];
    }
    if (updateHabitArr.count>0) {
        [updateHabitArr removeAllObjects];
    }
    dateListView.hidden=true;
    dateHeadingLabel.text=[[DateListArray objectAtIndex:sender.tag] objectForKey:@"Heading"];
    if (sender.tag==0) {
        selectedDateDict=[[NSMutableDictionary alloc] init];
        [self getOfflineDataForHabitCourse];
    }else{
        selectedDateDict=[DateListArray objectAtIndex:sender.tag];
        [self webServicecallForGetGrowthHomePageHabitOnly:[self->selectedDateDict objectForKey:@"Date"]];
    }
}



- (IBAction)trophyButtonPressed:(id)sender {
    WinTheWeekResultViewController  *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WinTheWeekResultView"];
    [self.navigationController pushViewController:controller animated:NO];
}


-(IBAction)addhabitPressed:(id)sender{
    infoview.hidden = true;

    if (![Utility reachable]) {
        return;
    }
   if ([Utility isOnlyProgramMember]) {
        return;
    }
    HabitHackerListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitHackerListView"];
    controller.ActiveHabitArray = habitArray;
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)addHabitButtonPressed:(id)sender{
    infoview.hidden = true;
    [defaults setObject:[NSNumber numberWithBool:true] forKey:@"isFirstTimeHabit"];

    if (![Utility reachable]) {
          return;
      }
     if ([Utility isOnlyProgramMember]) {
          return;
      }
    HabitHackerDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitHackerDetailsView"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)tickuntickPressed:(UIButton*)sender{
    if (![Utility reachable]) {
           return;
       }
    NSLog(@"sender====>%@",sender);
    NSLog(@"");
    [self tickUntick:sender];
    
    
    NSInteger numberOfRows = [habitTable numberOfRowsInSection:0];
    NSMutableArray *untickAllButtons = [[NSMutableArray alloc] init];
    NSMutableArray *tickAllButtons = [[NSMutableArray alloc] init];
    NSMutableArray *CrossAllButtons = [[NSMutableArray alloc] init];
    NSMutableArray *allButtons = [[NSMutableArray alloc] init];
      for (NSInteger i = 0; i< numberOfRows; i++) {
           NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
           TableViewCell *cell = [habitTable cellForRowAtIndexPath:indexPath];
          if (cell.tickuntickButton != nil) {
              [allButtons addObject:cell.tickuntickButton];
              if ([cell.tickuntickButton.currentImage isEqual: [UIImage imageNamed:@"untick_mbhq.png"]]) {
                  [untickAllButtons addObject:cell.tickuntickButton];
              }else if ([cell.tickuntickButton.currentImage isEqual: [UIImage imageNamed:@"tick_mbhq.png"]]) {
                  [tickAllButtons addObject:cell.tickuntickButton];
              }else if ([cell.tickuntickButton.currentImage isEqual: [UIImage imageNamed:@"greycross.png"]]) {
                  [CrossAllButtons addObject:cell.tickuntickButton];
              }
          }
      }
    if (allButtons.count == tickAllButtons.count) {
        [tickAllButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
    }else if (allButtons.count == CrossAllButtons.count) {
        [tickAllButton setImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];
    }else if (allButtons.count == untickAllButtons.count) {
        [tickAllButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
    }else{
        [tickAllButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
    }
}
-(IBAction)tickAllButtonPressed:(UIButton*)sender{
    if (![Utility reachable]) {
           return;
       }
     checkAllButton = false;
     crossAllButton = false;
     uncheckAllButton = false;
     allButtons = [NSMutableArray new];
    int count = 0;
    if ([tickAllButton.currentImage isEqual:[UIImage imageNamed:@"untick_mbhq.png"]]) {
        [tickAllButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
        checkAllButton = true;
        NSInteger numberOfRows = [habitTable numberOfRowsInSection:0];
        NSLog(@"numberOfRows = %ld",(long)numberOfRows);
        NSLog(@"");
          for (NSInteger i = 0; i< numberOfRows; i++) {
               NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
               TableViewCell *cell = [habitTable cellForRowAtIndexPath:indexPath];
              if (cell.tickuntickButton != nil) {
                      [allButtons addObject:cell.tickuntickButton];
                  count++;
                  NSLog(@"count = %ld",(long)count);
                  NSLog(@"");
              }
          }
    }else if ([tickAllButton.currentImage isEqual:[UIImage imageNamed:@"tick_mbhq.png"]]) {
        [tickAllButton setImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];
        crossAllButton = true;
        NSInteger numberOfRows = [habitTable numberOfRowsInSection:0];
        NSLog(@"numberOfRows = %ld",(long)numberOfRows);
        NSLog(@"");
        
          for (NSInteger i = 0; i< numberOfRows; i++) {
               NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
               TableViewCell *cell = [habitTable cellForRowAtIndexPath:indexPath];
              if (cell.tickuntickButton != nil) {
                      [allButtons addObject:cell.tickuntickButton];
                      count++;
                      NSLog(@"count = %ld",(long)count);
                      NSLog(@"");
              }
          }
    }else if([tickAllButton.currentImage isEqual:[UIImage imageNamed:@"greycross.png"]]){
        [tickAllButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
        uncheckAllButton = true;
        NSInteger numberOfRows = [habitTable numberOfRowsInSection:0];
        NSLog(@"numberOfRows = %ld",(long)numberOfRows);
        NSLog(@"");
          for (NSInteger i = 0; i< numberOfRows; i++) {
               NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
               TableViewCell *cell = [habitTable cellForRowAtIndexPath:indexPath];
              if (cell.tickuntickButton != nil) {
                      [allButtons addObject:cell.tickuntickButton];
                  count++;
                  NSLog(@"count = %ld",(long)count);
                  NSLog(@"");
              }
          }
    }

    if(allButtons != nil){
    for(long i=0;i<allButtons.count;i++){
        NSLog(@"allbuttons.count = %ld",(long)allButtons.count);
        NSLog(@"");
        if (checkAllButton) {
            [self tickUntickAll:allButtons[i]];
        }else if(crossAllButton){
            [self tickUntickAll:allButtons[i]];
        }else if(uncheckAllButton){
            [self tickUntickAll:allButtons[i]];
        }
        }
    }
}
-(IBAction)editDelCrossPressed:(id)sender{
    editDelView.hidden = true;
    infoview.hidden = true;

}
-(IBAction)breakTickuntickPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:[habitListArray objectAtIndex:sender.tag]]) {
        if (![Utility isEmptyCheck:[[habitListArray objectAtIndex:sender.tag]objectForKey:@"SwapAction"]]) {
            NSDictionary *newSwapDict = [[habitListArray objectAtIndex:sender.tag]objectForKey:@"SwapAction"];
            if (![Utility isEmptyCheck:[newSwapDict objectForKey:@"CurrentDayTask"]] && ![Utility isEmptyCheck:[newSwapDict objectForKey:@"CurrentDayTask2"]]) {
                if (twiceDailyCountForBreak == 1) {
                    twiceDailyCountForBreak = +1;
                    [self webSerViceCall_UpdateTaskStatus:newSwapDict newAction:[newSwapDict objectForKey:@"CurrentDayTask"] with:sender];
                }else{
                    [self webSerViceCall_UpdateTaskStatus:newSwapDict newAction:[newSwapDict objectForKey:@"CurrentDayTask2"] with:sender];
                }
            }else if(![Utility isEmptyCheck:[newSwapDict objectForKey:@"CurrentDayTask"]] && [Utility isEmptyCheck:[newSwapDict objectForKey:@"CurrentDayTask2"]]){
                [self webSerViceCall_UpdateTaskStatus:newSwapDict newAction:[newSwapDict objectForKey:@"CurrentDayTask"] with:sender];
            }
        }
    }
}
-(IBAction)editPressed:(UIButton*)sender{
        editDelView.hidden = true;
        infoview.hidden = true;

        if ([Utility isEmptyCheck:habitArray[sender.tag]]) {
               return;
           }
       NSDictionary *habitDict = habitArray[sender.tag];
       HabitHackerDetailNewViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitHackerDetailNewView"];
       controller.habitId = [habitDict valueForKey:@"HabitId"];
       controller.habitDetailDelegate=self;
       controller.isEditMode = true;
       controller.habitDictFromStat= habitDict;
       controller.isFromHabitList = true;
       [self.navigationController pushViewController:controller animated:NO];
}
-(IBAction)deleteButtonPressed:(UIButton*)sender{
        editDelView.hidden = true;
        infoview.hidden = true;

        if ([Utility isEmptyCheck:habitArray[sender.tag]]) {
            return;
        }
        NSDictionary *habitDict = habitArray[sender.tag];

        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Alert!"
                                      message:@"Do you want to delete ?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* delete = [UIAlertAction
                             actionWithTitle:@"DELETE"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
                                [self deleteHabitSwap_WebServiceCall:[habitDict valueForKey:@"HabitId"]];
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                 }];
        
        [alert addAction:delete];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];

}
-(IBAction)infoCrossPressed:(id)sender{
    [defaults setObject:[NSNumber numberWithBool:true] forKey:@"isFirstTimeHabit"];

    if (!(habitArray.count>0)) {
        addButtonShowView.hidden = false;
        habitTable.hidden = true;
    }else{
        addButtonShowView.hidden = true;
        habitTable.hidden = false;
    }
    infoview.hidden = true;
//    habitmainView.hidden = false;

}
-(IBAction)showMePressed:(id)sender{
    /*if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:SHOWME_HABIT_URL]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SHOWME_HABIT_URL] options:@{} completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"Opened");
                }
            }];
        }*/
    [defaults setObject:[NSNumber numberWithBool:true] forKey:@"isFirstTimeHabit"];
    infoview.hidden = true;
//    habitmainView.hidden = false;
    if ((habitArray.count>0)) {
        addButtonShowView.hidden = true;
        habitTable.hidden = false;
    }else{
        addButtonShowView.hidden = false;
        habitTable.hidden = true;
    }
    PrivacyPolicyAndTermsServiceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PrivacyPolicyAndTermsService"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.url=[NSURL URLWithString:SHOWME_HABIT_URL];
    controller.isFromCourse = NO;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)infoButtonPressed:(id)sender{
    infoview.hidden = false;
    addButtonShowView.hidden =true;
//    habitmainView.hidden = true;
}
- (IBAction)crossButtonPressed:(id)sender {
    dailyPopUpView.hidden = true;
}

- (IBAction)iAmGratefulButtonPressed:(id)sender {
    dailyPopUpView.hidden = true;
    AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Achievements"];
//    NotesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
//    controller.currentDate = _todaySelectDate;
//    controller.notesDelegate = self;
//    controller.fromStr = @"Growth";
    controller.gratitudePopUpPressed = true;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - End

#pragma mark - Private method


-(void)tickUntick:(UIButton*)sender{
//    NSInteger i = [sender tag];
    if (![Utility isEmptyCheck:habitArray] && habitArray.count>0) {
        if (![Utility isEmptyCheck:[habitArray objectAtIndex:sender.tag]]) {
            NSDictionary *habitDict = [habitArray objectAtIndex:sender.tag];
            NSLog(@"sender.tag%ld",(long)sender.tag);
            NSLog(@"");
            if (![Utility isEmptyCheck:[[habitArray objectAtIndex:sender.tag]objectForKey:@"NewAction"]]) {
                NSDictionary *newActionDict = [[habitArray objectAtIndex:sender.tag]objectForKey:@"NewAction"];
                
                saveView.hidden=false;
                if ([sender.currentImage isEqual: [UIImage imageNamed:@"untick_mbhq.png"]]) {
                    [sender setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
                     
                    //-------------
                    NSDictionary *currentDayTaskDict=[newActionDict objectForKey:@"CurrentDayTask"];
                    if (![updateHabitArr containsObject:habitDict]) {
                        [updateHabitArr addObject:habitDict];
                    }
                                        
                    NSMutableDictionary *mainDict=[[NSMutableDictionary alloc] init];
                                        
                                        
                    [mainDict setObject:[currentDayTaskDict objectForKey:@"TaskMasterId"] forKey:@"TaskId"];
                    [mainDict setObject:[NSNumber numberWithBool:false] forKey:@"IsDone"];
                    [mainDict setObject:[NSNumber numberWithInt:2] forKey:@"TickingMode"];
                    if ([updateTAskArr containsObject:mainDict]) {
                        [updateTAskArr removeObject:mainDict];
                    }
                    [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
                    [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"TickingMode"];
                    
                    [updateTAskArr addObject:mainDict];
                    

                }else if ([sender.currentImage isEqual: [UIImage imageNamed:@"tick_mbhq.png"]]){
                    [sender setImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];
                    //-------------
                    NSDictionary *swapActionDict = [[habitArray objectAtIndex:sender.tag]objectForKey:@"SwapAction"];
                    NSLog(@"habitArray======>%@",habitArray);
                    NSLog(@"");
                    //CurrentDayTask is going null
                    NSDictionary *swapCurrentDayTaskDict=[swapActionDict objectForKey:@"CurrentDayTask"];
                    NSDictionary *currentDayTaskDict=[newActionDict objectForKey:@"CurrentDayTask"];
                    if (![updateHabitArr containsObject:habitDict]) {
                        [updateHabitArr addObject:habitDict];
                    }
                                        
                    NSMutableDictionary *mainDict=[[NSMutableDictionary alloc] init];
                    NSMutableDictionary *mainDict2=[[NSMutableDictionary alloc] init];
                                        
                    [mainDict setObject:[currentDayTaskDict objectForKey:@"TaskMasterId"] forKey:@"TaskId"];
                    [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
                    [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"TickingMode"];
                    if ([updateTAskArr containsObject:mainDict]) {
                        [updateTAskArr removeObject:mainDict];
                    }
                    NSLog(@"swapCurrentDayTaskDict======>%@",swapCurrentDayTaskDict);
                    NSLog(@"");
                    [mainDict2 setObject:[swapCurrentDayTaskDict objectForKey:@"TaskMasterId"] forKey:@"TaskId"];//crash because of it
                //                      [mainDict2 setObject:[NSNumber numberWithBool:false] forKey:@"IsDone"];
                //                        if ([updateTAskArr containsObject:mainDict2]) {
                //                            [updateTAskArr removeObject:mainDict2];
                //                        }
                    [mainDict2 setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
                    [mainDict2 setObject:[NSNumber numberWithInt:1] forKey:@"TickingMode"];
                    [updateTAskArr addObject:mainDict2];
                    //--------
                                        
                }else if ([sender.currentImage isEqual: [UIImage imageNamed:@"greycross.png"]]){
                    [sender setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
                                    
                    //-------------
                    NSDictionary *swapActionDict = [[habitArray objectAtIndex:sender.tag]objectForKey:@"SwapAction"];
                    NSLog(@"swapActionDict======>%@",swapActionDict);
                    NSLog(@"");
                    NSDictionary *swapCurrentDayTaskDict=[swapActionDict objectForKey:@"CurrentDayTask"];
                    NSDictionary *currentDayTaskDict=[newActionDict objectForKey:@"CurrentDayTask"];
                    if (![updateHabitArr containsObject:habitDict]) {
                        [updateHabitArr addObject:habitDict];
                    }
                                
                    NSMutableDictionary *mainDict=[[NSMutableDictionary alloc] init];
                    NSMutableDictionary *mainDict2=[[NSMutableDictionary alloc] init];
                    
                    [mainDict setObject:[currentDayTaskDict objectForKey:@"TaskMasterId"] forKey:@"TaskId"];
                    [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
                    [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"TickingMode"];
                    if ([updateTAskArr containsObject:mainDict]) {
                        [updateTAskArr removeObject:mainDict];
                    }
                    [mainDict setObject:[NSNumber numberWithBool:false] forKey:@"IsDone"];
                    [mainDict setObject:[NSNumber numberWithInt:2] forKey:@"TickingMode"];
                    [updateTAskArr addObject:mainDict];
                                    
                    [mainDict2 setObject:[swapCurrentDayTaskDict objectForKey:@"TaskMasterId"] forKey:@"TaskId"];
                    [mainDict2 setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
                    [mainDict2 setObject:[NSNumber numberWithInt:1] forKey:@"TickingMode"];
                    if ([updateTAskArr containsObject:mainDict2]) {
                        [updateTAskArr removeObject:mainDict2];
                    }
                    [mainDict2 setObject:[NSNumber numberWithBool:false] forKey:@"IsDone"];
                    [mainDict2 setObject:[NSNumber numberWithInt:2] forKey:@"TickingMode"];
                    //--------
                }
            }
        }
    }
}
-(void)tickUntickAll:(UIButton*)sender{
//    NSInteger i = [sender tag];
    if (![Utility isEmptyCheck:habitArray] && habitArray.count>0) {
        if (![Utility isEmptyCheck:[habitArray objectAtIndex:sender.tag]]) {
            NSDictionary *habitDict = [habitArray objectAtIndex:sender.tag];
            NSLog(@"sender.tag%ld",(long)sender.tag);
            NSLog(@"");
            if (![Utility isEmptyCheck:[[habitArray objectAtIndex:sender.tag]objectForKey:@"NewAction"]]) {
                NSDictionary *newActionDict = [[habitArray objectAtIndex:sender.tag]objectForKey:@"NewAction"];
                
                saveView.hidden=false;
                if (checkAllButton) {
                    [sender setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
                                        
                    //-------------
                    NSDictionary *currentDayTaskDict=[newActionDict objectForKey:@"CurrentDayTask"];
                    if (![updateHabitArr containsObject:habitDict]) {
                        [updateHabitArr addObject:habitDict];
                    }
                                        
                    NSMutableDictionary *mainDict=[[NSMutableDictionary alloc] init];
                                        
                                        
                    [mainDict setObject:[currentDayTaskDict objectForKey:@"TaskMasterId"] forKey:@"TaskId"];
                    [mainDict setObject:[NSNumber numberWithBool:false] forKey:@"IsDone"];
                    [mainDict setObject:[NSNumber numberWithInt:2] forKey:@"TickingMode"];
                    if ([updateTAskArr containsObject:mainDict]) {
                        [updateTAskArr removeObject:mainDict];
                    }
                    [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
                    [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"TickingMode"];
                    
                    [updateTAskArr addObject:mainDict];
                    
                    //------------
                }else if (crossAllButton){
                    [sender setImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];
                    //-------------
                    NSDictionary *swapActionDict = [[habitArray objectAtIndex:sender.tag]objectForKey:@"SwapAction"];
                    NSLog(@"habitArray======>%@",habitArray);
                    NSLog(@"");
                    //CurrentDayTask is going null
                    NSDictionary *swapCurrentDayTaskDict=[swapActionDict objectForKey:@"CurrentDayTask"];
                    NSDictionary *currentDayTaskDict=[newActionDict objectForKey:@"CurrentDayTask"];
                    if (![updateHabitArr containsObject:habitDict]) {
                        [updateHabitArr addObject:habitDict];
                    }
                                        
                    NSMutableDictionary *mainDict=[[NSMutableDictionary alloc] init];
                    NSMutableDictionary *mainDict2=[[NSMutableDictionary alloc] init];
                                        
                    [mainDict setObject:[currentDayTaskDict objectForKey:@"TaskMasterId"] forKey:@"TaskId"];
                    [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
                    [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"TickingMode"];
                    if ([updateTAskArr containsObject:mainDict]) {
                        [updateTAskArr removeObject:mainDict];
                    }
                    NSLog(@"swapCurrentDayTaskDict======>%@",swapCurrentDayTaskDict);
                    NSLog(@"");
                    [mainDict2 setObject:[swapCurrentDayTaskDict objectForKey:@"TaskMasterId"] forKey:@"TaskId"];//crash because of it
                //                      [mainDict2 setObject:[NSNumber numberWithBool:false] forKey:@"IsDone"];
                //                        if ([updateTAskArr containsObject:mainDict2]) {
                //                            [updateTAskArr removeObject:mainDict2];
                //                        }
                    [mainDict2 setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
                    [mainDict2 setObject:[NSNumber numberWithInt:1] forKey:@"TickingMode"];
                    [updateTAskArr addObject:mainDict2];
                    //--------
                                        
                }else if (uncheckAllButton){
                    [sender setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
                                    
                    //-------------
                    NSDictionary *swapActionDict = [[habitArray objectAtIndex:sender.tag]objectForKey:@"SwapAction"];
                    NSLog(@"swapActionDict======>%@",swapActionDict);
                    NSLog(@"");
                    NSDictionary *swapCurrentDayTaskDict=[swapActionDict objectForKey:@"CurrentDayTask"];
                    NSDictionary *currentDayTaskDict=[newActionDict objectForKey:@"CurrentDayTask"];
                    if (![updateHabitArr containsObject:habitDict]) {
                        [updateHabitArr addObject:habitDict];
                    }
                                
                    NSMutableDictionary *mainDict=[[NSMutableDictionary alloc] init];
                    NSMutableDictionary *mainDict2=[[NSMutableDictionary alloc] init];
                    
                    [mainDict setObject:[currentDayTaskDict objectForKey:@"TaskMasterId"] forKey:@"TaskId"];
                    [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
                    [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"TickingMode"];
                    if ([updateTAskArr containsObject:mainDict]) {
                        [updateTAskArr removeObject:mainDict];
                    }
                    [mainDict setObject:[NSNumber numberWithBool:false] forKey:@"IsDone"];
                    [mainDict setObject:[NSNumber numberWithInt:2] forKey:@"TickingMode"];
                    [updateTAskArr addObject:mainDict];
                                    
                    [mainDict2 setObject:[swapCurrentDayTaskDict objectForKey:@"TaskMasterId"] forKey:@"TaskId"];
                    [mainDict2 setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
                    [mainDict2 setObject:[NSNumber numberWithInt:1] forKey:@"TickingMode"];
                    if ([updateTAskArr containsObject:mainDict2]) {
                        [updateTAskArr removeObject:mainDict2];
                    }
                    [mainDict2 setObject:[NSNumber numberWithBool:false] forKey:@"IsDone"];
                    [mainDict2 setObject:[NSNumber numberWithInt:2] forKey:@"TickingMode"];
                    //--------
                }
            }
        }
    }
}
-(void)checkIfTodayDateChanged{
    
    NSLog(@"Timer Working");
    //dateHeadingLabel.text=@"TODAY'S HABITS";
    NSString *headingStr = dateHeadingLabel.text;
    
    if ([headingStr isEqualToString:@"TODAY'S HABITS"] && ![currentVisibleDate isToday]){
        currentVisibleDate = [NSDate date];
        [self webServicecallForGetGrowthHomePageHabitOnly:currentVisibleDate];
    }
    
}

- (void)refreshTable {
    [refreshControl endRefreshing];
    saveView.hidden=true;
    if (![Utility isEmptyCheck:self->selectedDateDict]) {
        [self webServicecallForGetGrowthHomePageHabitOnly:[self->selectedDateDict objectForKey:@"Date"]];
    }else{
        [self webServicecallForGetGrowthHomePage:[defaults objectForKey:@"Date"]];
    }
    NSInteger numberOfRows = [self->habitTable numberOfRowsInSection:0];
    NSMutableArray *untickAllButtons = [[NSMutableArray alloc] init];
    NSMutableArray *tickAllButtons = [[NSMutableArray alloc] init];
    NSMutableArray *CrossAllButtons = [[NSMutableArray alloc] init];
    NSMutableArray *allButtons = [[NSMutableArray alloc] init];
      for (NSInteger i = 0; i< numberOfRows; i++) {
           NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
          TableViewCell *cell = [self->habitTable cellForRowAtIndexPath:indexPath];
          if (cell.tickuntickButton != nil) {
              [allButtons addObject:cell.tickuntickButton];
              if ([cell.tickuntickButton.currentImage isEqual: [UIImage imageNamed:@"untick_mbhq.png"]]) {
                  [untickAllButtons addObject:cell.tickuntickButton];
              }else if ([cell.tickuntickButton.currentImage isEqual: [UIImage imageNamed:@"tick_mbhq.png"]]) {
                  [tickAllButtons addObject:cell.tickuntickButton];
              }else if ([cell.tickuntickButton.currentImage isEqual: [UIImage imageNamed:@"greycross.png"]]) {
                  [CrossAllButtons addObject:cell.tickuntickButton];
              }
          }
      }
    if(allButtons.count > 0){
        if (allButtons.count == tickAllButtons.count) {
            [self->tickAllButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
        }else if (allButtons.count == CrossAllButtons.count) {
            [self->tickAllButton setImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];
        }else if (allButtons.count == untickAllButtons.count) {
            [self->tickAllButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
        }else{
            [self->tickAllButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
        }
    }
}


-(void)makeDateList{
    NSDictionary *dict;
    [DateListArray removeAllObjects];
    NSDate *currentDate=[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDateStr=[formatter stringFromDate:currentDate];
    dict=[[NSDictionary alloc] initWithObjectsAndKeys:currentDate,@"Date",todayDateStr,@"DateString",@"TODAY'S HABITS",@"Heading",@"Today",@"ButtonTitle", nil];
    [DateListArray addObject:dict];
    
    NSDate *yesterday=[currentDate dateBySubtractingDays:1];
    NSString *yesterdayDateStr=[formatter stringFromDate:yesterday];
    dict=[[NSDictionary alloc] initWithObjectsAndKeys:yesterday,@"Date",yesterdayDateStr,@"DateString",@"YESTERDAY'S HABITS",@"Heading",@"Yesterday",@"ButtonTitle", nil];
    [DateListArray addObject:dict];
    
    NSDate *forDate;
    NSString *dateStr;
    for (int i=2; i<=9; i++) {
        forDate=[currentDate dateBySubtractingDays:i];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        dateStr=[formatter stringFromDate:forDate];
        
        [formatter setDateFormat:@"MMM dd"];
        NSString *heading=[[NSString stringWithFormat:@"%@'S HABITS",[formatter stringFromDate:forDate]] uppercaseString];
        
        [formatter setDateFormat:@"EEE, MMM dd"];
        NSString *buttonTitle=[formatter stringFromDate:forDate];
        
        dict=[[NSDictionary alloc] initWithObjectsAndKeys:forDate,@"Date",dateStr,@"DateString",heading,@"Heading",buttonTitle,@"ButtonTitle", nil];
        [DateListArray addObject:dict];
    }
    
    if (![Utility isEmptyCheck:DateListArray] && DateListArray.count==10) {
        for (UIButton *btn in dateListButtonArray) {
            NSDictionary *dict=[DateListArray objectAtIndex:btn.tag];
            [btn setTitle:[NSString stringWithFormat:@"%@",dict[@"ButtonTitle"]] forState:UIControlStateNormal];
        }
    }
}


-(void)checkWinTheWeek:(NSDictionary*)responseDict{
    int totalTaskForTheDay=[[responseDict objectForKey:@"TotalTaskForTheDay"] intValue];
    int totalTaskDoneForTheDay=[[responseDict objectForKey:@"TotalTaskDoneForTheDay"] intValue];
    BOOL dailyPopupShown = [[responseDict objectForKey:@"DailyBadgeShown"] boolValue];
    
    int daysDoneForTheWeek=[[responseDict objectForKey:@"DaysDoneForTheWeek"] intValue];
    BOOL WeeklyPopupShown = [[responseDict objectForKey:@"WeeklyBadgeShown"] boolValue];
    
    NSString *weekStartDateStr=[responseDict objectForKey:@"WeekStartDate"];
    NSString *todayDateString;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if (![Utility isEmptyCheck:selectedDateDict]) {
        todayDateString=[formatter stringFromDate:[selectedDateDict objectForKey:@"Date"]];
    }else{
        todayDateString=[formatter stringFromDate:[NSDate date]];
    }
    
    
    
    if (daysDoneForTheWeek>=4 && !WeeklyPopupShown) {
        WinTheWeekViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WinTheWeekView"];
        controller.winType=@"WEEK";
        controller.dayDoneCount=daysDoneForTheWeek;
        controller.WeekStartDateStr=weekStartDateStr;
        controller.todayDateStr=todayDateString;
        controller.parent=self;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else if (totalTaskForTheDay>0 && totalTaskDoneForTheDay>0 && totalTaskForTheDay==totalTaskDoneForTheDay && !dailyPopupShown){
        WinTheWeekViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WinTheWeekView"];
        controller.winType=@"DAY";
        controller.dayDoneCount=daysDoneForTheWeek;
        controller.WeekStartDateStr=weekStartDateStr;
        controller.todayDateStr=todayDateString;
        controller.parent=self;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }
}


#pragma mark - End

#pragma mark - Webservice call

-(void)webSerViceCall_UpdateTaskStatus_Multiple{
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
        [mainDict setObject:updateTAskArr forKey:@"TaskDoneStatuses"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateTaskStatusForMultiple" append:@""forAction:@"POST"];
        NSLog(@"Request data ======>%@",request);
        NSLog(@"");
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 NSLog(@"response data ======>%@",response);
                                                                 NSLog(@"");
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         
                                                                         self->saveView.hidden=true;
                                                                         
                                                                         
                                                                         if (self->updateHabitArr.count>0) {
                                                                             for (NSDictionary *dict in self->updateHabitArr) {
                                                                                 [DBQuery updateHabitColumn:[[dict objectForKey:@"HabitId"]intValue] with:1];
                                                                             }
                                                                         }
                                                                         
                                                                         if (self->updateTAskArr.count>0) {
                                                                             [self->updateTAskArr removeAllObjects];
                                                                         }
                                                                         [self->updateHabitArr removeAllObjects];
                                                                         
                                                                         if (![Utility isEmptyCheck:self->selectedDateDict]) {
                                                                             [self webServicecallForGetGrowthHomePageHabitOnly:[self->selectedDateDict objectForKey:@"Date"]];
                                                                         }else{
                                                                             [self webServicecallForGetGrowthHomePage:[defaults objectForKey:@"Date"]];
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

-(void)webSerViceCall_GetTaskStatusForDate{
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
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        if (![Utility isEmptyCheck:self->selectedDateDict]) {
            [mainDict setObject:[formatter stringFromDate:[self->selectedDateDict objectForKey:@"Date"]] forKey:@"ForDate"];
        }else{
            [mainDict setObject:[formatter stringFromDate:[NSDate date]] forKey:@"ForDate"];
        }
        
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetTaskStatusForDate" append:@""forAction:@"POST"];
        NSLog(@"Request data ======>%@",jsonString);
        NSLog(@"");
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 NSLog(@"response data ======>%@",response);
                                                                 NSLog(@"");
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     NSLog(@"responseString data ======>%@",responseString);
                                                                     NSLog(@"");
                                                                     NSLog(@"responseDict data ======>%@",responseDict);
                                                                     NSLog(@"");
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         [self checkWinTheWeek:responseDict];
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
//                                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"IsHackerListReload" object:self userInfo:nil];
                                                                         [DBQuery updateHabitColumn:[[dict objectForKey:@"HabitId"]intValue] with:1];
                                                                         
                                                                         if (![Utility isEmptyCheck:self->selectedDateDict]) {
                                                                             [self webServicecallForGetGrowthHomePageHabitOnly:[self->selectedDateDict objectForKey:@"Date"]];
                                                                         }else{
                                                                             [self webServicecallForGetGrowthHomePage:[defaults objectForKey:@"Date"]];
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

-(void)webServicecallForGetGrowthHomePage:(NSDate*)currentdate{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
         if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeHabit"]] || ![defaults boolForKey:@"isFirstTimeHabit"]) {
                        [self->contentView removeFromSuperview];
                    }else{
                        if (self->contentView) {
                            [self->contentView removeFromSuperview];
                           }
                        self->contentView = [Utility activityIndicatorView:self];
                    }
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
        NSLog(@"Request data ======>%@",request);
        NSLog(@"");
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   NSLog(@"response data ======>%@",response);
                                                                   NSLog(@"");
                                                                   if(error == nil)
                                                                   {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                                                       NSMutableDictionary *responseDict = [responseDictionary mutableCopy];
//                                                                       [responseDict removeObjectForKey:@"Courses"];
                                                                       
                                                                       if(![Utility isEmptyCheck:responseDictionary]){
                                                                           NSError *error;
                                                                           NSData *todayData = [NSJSONSerialization dataWithJSONObject:responseDictionary options:NSJSONWritingPrettyPrinted  error:&error];
                                                                           if (error) {
                                                                               NSLog(@"Error Favorite Array-%@",error.debugDescription);
                                                                           }
                                                                           self->currentVisibleDate = currentdate;
                                                                           NSString *detailsString = [[NSString alloc] initWithData:todayData encoding:NSUTF8StringEncoding];
                                                                       
                                                                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                        [formatter setDateFormat:@"yyyy-MM-dd"];
                                                                        NSString *currentDateStr = [formatter stringFromDate:[defaults objectForKey:@"Date"]];
                                                                           NSString *callDateStr = [formatter stringFromDate:currentdate];
                                                                           int userId = [[defaults objectForKey:@"UserID"] intValue];
                                                                           
                                                                           if ([currentDateStr isEqualToString:callDateStr]) {
                                                                               if([DBQuery isRowExist:@"todayGetGrowthDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and AddedDate = '%@'",[NSNumber numberWithInt:userId],currentDateStr]]){
                                                                                   [DBQuery updateTodayGrwothDetails:detailsString With:currentDateStr];
                                                                               }else{
                                                                                   [DBQuery addTodayGrwothDetails:detailsString with:currentDateStr];
                                                                                }
                                                                           }
                                                                           
                                                                           
                                                                                [self setUpHabitDetails:responseDictionary];
                                                                           [self webSerViceCall_GetTaskStatusForDate];
                                                                              
                                                                            
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


-(void)webServicecallForGetGrowthHomePageHabitOnly:(NSDate*)currentdate{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
             if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeHabit"]] || ![defaults boolForKey:@"isFirstTimeHabit"]) {
                            [self->contentView removeFromSuperview];
                        }else{
                            if (self->contentView) {
                                [self->contentView removeFromSuperview];
                               }
                            self->contentView = [Utility activityIndicatorView:self];
                        }
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetGrowthHomePageHabitOnly" append:@"" forAction:@"POST"];
        NSLog(@"Request data ======>%@",request);
        NSLog(@"");
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   NSLog(@"response data ======>%@",response);
                                                                   NSLog(@"");
                                                                   if(error == nil)
                                                                   {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                                                       NSMutableDictionary *responseDict = [responseDictionary mutableCopy];
//                                                                       ;
                                                                       if(![Utility isEmptyCheck:responseDictionary]){
                                                                           [self setUpHabitDetails:responseDictionary];
                                                                           
                                                                           if (![Utility isEmptyCheck:self->selectedDateDict]) {
                                                                               NSDate *selectedDate=[self->selectedDateDict objectForKey:@"Date"];
                                                                               NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                                                                               [formatter setDateFormat:@"yyyy-MM-dd"];
                                                                               
                                                                               NSString *selectedDateString=[formatter stringFromDate:selectedDate];
                                                                               selectedDate =[formatter dateFromString:selectedDateString];
                                                                               
                                                                               NSString *weekStartDateString=[formatter stringFromDate:self->weekStartDate];
                                                                               NSDate *weekStartDt=[formatter dateFromString:weekStartDateString];
                                                                               
                                                                               NSComparisonResult r= [selectedDate compare:weekStartDt];
                                                                               
                                                                               if ([selectedDate compare:weekStartDt]!=NSOrderedAscending){
                                                                                   [self webSerViceCall_GetTaskStatusForDate];
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
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}


//--------------------

-(void)webServicecallForGetGrowthHomePage_fromNotification:(NSDate*)currentdate{
    if (Utility.reachable) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//             if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeHabit"]] || ![defaults boolForKey:@"isFirstTimeHabit"]) {
//                            [self->contentView removeFromSuperview];
//                        }else{
//                            if (self->contentView) {
//                                [self->contentView removeFromSuperview];
//                               }
//                            self->contentView = [Utility activityIndicatorView:self];
//                        }
//                   });
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
        NSLog(@"Request data ======>%@",request);
        NSLog(@"");
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   NSLog(@"response data ======>%@",response);
                                                                   NSLog(@"");
                                                                   if(error == nil)
                                                                   {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
                                                                        NSString *currentDateStr = [formatter stringFromDate:[defaults objectForKey:@"Date"]];
                                                                           NSString *callDateStr = [formatter stringFromDate:currentdate];
                                                                           int userId = [[defaults objectForKey:@"UserID"] intValue];
                                                                           
                                                                           if ([currentDateStr isEqualToString:callDateStr]) {
                                                                               if([DBQuery isRowExist:@"todayGetGrowthDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and AddedDate = '%@'",[NSNumber numberWithInt:userId],currentDateStr]]){
                                                                                   [DBQuery updateTodayGrwothDetails:detailsString With:currentDateStr];
                                                                               }else{
                                                                                   [DBQuery addTodayGrwothDetails:detailsString with:currentDateStr];
                                                                                }
                                                                           }
                                                                           
                                                                           
                                                                                [self setUpHabitDetails:responseDictionary];
                                                                              
                                                                            
                                                                       }
                                                                       
                                                                   }else{
//                                                                       [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                   }
                                                               });
                                                           }];
        [dataTask resume];
        
    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}

//--------------------


-(void)deleteHabitSwap_WebServiceCall:(NSString*)habitId{
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
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:habitId forKey:@"HabitId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"AbbbcUserSessionId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteHabitSwap" append:@"" forAction:@"POST"];
        NSLog(@"Request data ======>%@",request);
        NSLog(@"");
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 NSLog(@"response data ======>%@",response);
                                                                 NSLog(@"");
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"]boolValue]) {
                                                                             [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];
                                                                             
                                                                                if (![Utility isEmptyCheck:self->selectedDateDict]) {
                                                                                    [self webServicecallForGetGrowthHomePageHabitOnly:[self->selectedDateDict objectForKey:@"Date"]];
                                                                                }else{
                                                                                    [self webServicecallForGetGrowthHomePage:[defaults objectForKey:@"Date"]];
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

-(void)getOfflineDataForHabitCourse{
    int userId = [[defaults objectForKey:@"UserID"] intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr;
    currentDateStr = [formatter stringFromDate:[NSDate date]];
    
        if([DBQuery isRowExist:@"todayGetGrowthDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and AddedDate = '%@'",[NSNumber numberWithInt:userId],currentDateStr]]){
           DAOReader *dbObject = [DAOReader sharedInstance];
            if([dbObject connectionStart]){
                NSArray *todayHabitCoursearr = [dbObject selectBy:@"todayGetGrowthDetails" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"AddedDate",@"TodayData",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@' and AddedDate = '%@'",[NSNumber numberWithInt:userId],currentDateStr]];
                    NSString *str = todayHabitCoursearr[0][@"TodayData"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *todayHabitCourseList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    [self setUpHabitDetails:todayHabitCourseList];
                    
                    [dbObject connectionEnd];
                    [self webSerViceCall_GetTaskStatusForDate];
            }
        }else{
            if([Utility reachable]){
               // [self webServicecallForGetGrowthHomePage:[defaults objectForKey:@"Date"]];
                [self webServicecallForGetGrowthHomePage:[NSDate date]];
            }
            
        }
}

-(void)setUpHabitDetails:(NSDictionary*)todayDict{
    if (![Utility isEmptyCheck:todayDict] && ![Utility isEmptyCheck:[todayDict objectForKey:@"Habits"]]) {
        habitArray = [todayDict objectForKey:@"Habits"];
        NSLog(@"todayDict====%@",todayDict);
        NSLog(@"");
        [self setUpReminder];
        if (!(habitArray.count>0)) {
            addButtonShowView.hidden = false;
            habitTable.hidden = true;
        }else{
            addButtonShowView.hidden = true;
            habitTable.hidden = false;
        }
        [habitTable reloadData];
        NSLog(@"habitArray====%@",habitArray);
        NSLog(@"");
      
    }else{
        if (![defaults boolForKey:@"isFirstTimeHabit"]) {
               self->addButtonShowView.hidden = true;
        }else{
               self->addButtonShowView.hidden = false;
        }
          
//        addButtonShowView.hidden = false;
        habitTable.hidden = true;
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
    
    for (int i = 0; i < habitArray.count; i++) {
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[habitArray objectAtIndex:i]];
        if ([[[dict objectForKey:@"NewAction"]objectForKey:@"PushNotification"] boolValue]) {
            NSMutableDictionary *extraDict = [NSMutableDictionary new];
            [extraDict setObject:[dict objectForKey:@"HabitId"] forKey:@"HabitId"];
            [SetReminderViewController setOldLocalNotificationFromDictionary:[[dict objectForKey:@"NewAction"] mutableCopy] ExtraData:extraDict FromController:(NSString *)@"HabitList" Title:[dict objectForKey:@"HabitName"] Type:@"HabitList" Id:[[dict objectForKey:@"HabitId"] intValue]];
        }
    }
}
-(void)prepareView{
      habitListButton.layer.cornerRadius = 15;
      habitListButton.layer.masksToBounds = YES;
      habitListButton.layer.borderColor = squadMainColor.CGColor;
      habitListButton.layer.borderWidth = 1;
      editButton.layer.cornerRadius = 15;
      editButton.layer.masksToBounds = YES;
      delButton.layer.cornerRadius = 15;
      delButton.layer.masksToBounds = YES;
      editDelSubView.layer.cornerRadius = 15;
      editDelSubView.layer.masksToBounds = YES;
      walkThroughGotItButton.layer.cornerRadius=15;
      walkThroughGotItButton.layer.masksToBounds=true;
      twiceDailyCount = 1;
      twiceDailyCountForBreak = 1;
      isShowAllHabits = false;
      infoview.hidden = true;
      createHabitNowButton.layer.cornerRadius = 15;
      createHabitNowButton.layer.masksToBounds = YES;
      showMeExample.layer.cornerRadius = 15;
      showMeExample.layer.masksToBounds = YES;
      habitListArray = [[NSMutableArray alloc]init];
      UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
      longPress.minimumPressDuration = 1.0;
      [habitTable addGestureRecognizer:longPress];
    
    if (([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeHabit"]] || ![defaults boolForKey:@"isFirstTimeHabit"]) && [[self.navigationController visibleViewController] isKindOfClass:[HabitHackerFirstViewController class]]) {
             [self infoButtonPressed:0];
        }
      [self getOfflineDataForHabitCourse];

}

#pragma mark - Table View Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"Habitarray.count========>%lu",(unsigned long)habitArray.count);
    return habitArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = (TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
//    cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
    if (cell==nil) {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
    }else{
        
    }
    NSDictionary *dict = [habitArray objectAtIndex:indexPath.row];
    if (isShowAllHabits) {
           cell.habitBreakview.hidden = false;
       }else{
           cell.habitBreakview.hidden = true;
       }
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
    cell.reminderButton.hidden = true;
    cell.tickuntickButton.tag = indexPath.row;
    

    if (![Utility isEmptyCheck:[dict objectForKey:@"NewAction"]]) {
           NSDictionary *newDict = [dict objectForKey:@"NewAction"];
           if (percentageShowLabel.hidden) {
               cell.percentagelabel.hidden= true;
               cell.reminderButton.hidden = true;
           }else{
               cell.percentagelabel.hidden= false;
               if ((![Utility isEmptyCheck:[newDict objectForKey:@"PushNotification"]] && [[newDict objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[newDict objectForKey:@"Email"]] && [[newDict objectForKey:@"Email"] boolValue])) {
                         cell.reminderButton.hidden = false;
                     }else{
                         cell.reminderButton.hidden = true;
                     }
           }
        /*
           if(![Utility isEmptyCheck:[newDict objectForKey:@"OverallPerformance"]]){
               
               //[NSString stringWithFormat:@"%.1f%%", [[newDict objectForKey:@"OverallPerformance"]floatValue] *100]
               cell.percentagelabel.text = [NSString stringWithFormat:@"%.0f%%", [[newDict objectForKey:@"OverallPerformance"]floatValue]];//*100
           }else{
               cell.percentagelabel.text = @"";
           }
        */
        
//        //------------------- check/uncheck for today-------------
//        if ([Utility isEmptyCheck:selectedDateDict]) {
//            if ((![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask"]]) && ![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask2"]]) {
//                       cell.tickuntickButton.userInteractionEnabled = true;
//                       cell.tickuntickButton.alpha = 1;
//                       NSDictionary *currentTaskDict = [newDict objectForKey:@"CurrentDayTask"];
//                       NSDictionary *currentTaskDict1 = [newDict objectForKey:@"CurrentDayTask2"];
//                       if (percentageShowLabel.hidden) {
//                           cell.percentagelabel.hidden= true;
//                           cell.tickuntickButton.userInteractionEnabled = false;
//                       }else{
//                           cell.percentagelabel.hidden= false;
//                           cell.tickuntickButton.userInteractionEnabled = true;
//                       }
//
//                       if ([[currentTaskDict objectForKey:@"IsDone"]boolValue] && [[currentTaskDict1 objectForKey:@"IsDone"]boolValue]) {
//            //               cell.tickuntickButton.selected=true;
//                           [cell.tickuntickButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
//                       }else if([[currentTaskDict objectForKey:@"IsDone"]boolValue] || [[currentTaskDict1 objectForKey:@"IsDone"]boolValue]){
//                           [cell.tickuntickButton setImage:[UIImage imageNamed:@"half_circle.png"] forState:UIControlStateNormal];
//                       }else{
//            //               cell.tickuntickButton.selected=false;
//                           [cell.tickuntickButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
//                       }
//                   } else if ((![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask"]])) {
//                        cell.tickuntickButton.userInteractionEnabled = true;
//                        cell.tickuntickButton.alpha = 1;
//                       NSDictionary *currentDayTask = [newDict objectForKey:@"CurrentDayTask"];
//
//                       if (percentageShowLabel.hidden) {
//                           cell.percentagelabel.hidden= true;
//                           cell.tickuntickButton.userInteractionEnabled = false;
//                       }else{
//                           cell.percentagelabel.hidden= false;
//                           cell.tickuntickButton.userInteractionEnabled = true;
//                       }
//                       if ([[currentDayTask objectForKey:@"IsDone"]boolValue]) {
//            //               cell.tickuntickButton.selected=true;
//                           [cell.tickuntickButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
//                       }else{
//            //               cell.tickuntickButton.selected=false;
//                           [cell.tickuntickButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
//                       }
//                   }else if(![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask2"]]){
//                       cell.tickuntickButton.userInteractionEnabled = true;
//                       cell.tickuntickButton.alpha = 1;
//                       NSDictionary *currentDayTask = [newDict objectForKey:@"CurrentDayTask2"];
//
//                       if (percentageShowLabel.hidden) {
//                           cell.percentagelabel.hidden = true;
//                           cell.tickuntickButton.userInteractionEnabled = false;
//                       }else{
//                           cell.percentagelabel.hidden = false;
//                           cell.tickuntickButton.userInteractionEnabled = true;
//                       }
//
//                       if ([[currentDayTask objectForKey:@"IsDone"]boolValue]) {
//            //               cell.tickuntickButton.selected=true;
//                           [cell.tickuntickButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
//                       }else{
//            //               cell.tickuntickButton.selected=false;
//                           [cell.tickuntickButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
//                       }
//                   }else{
//            //            cell.tickuntickButton.selected=false;
//                         [cell.tickuntickButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
//                          cell.tickuntickButton.userInteractionEnabled = false;
//                          cell.tickuntickButton.alpha = 0.5;
//                       }
//        }else{//------------------- check/uncheck for history date-------------
//            if (![Utility isEmptyCheck:[dict objectForKey:@"SwapAction"]]) {
//                NSDictionary *swapnDict = [dict objectForKey:@"SwapAction"];
//                if ((![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask"]]) && ![Utility isEmptyCheck:[swapnDict objectForKey:@"CurrentDayTask"]]) {
//                    NSDictionary *newActionCurrentDayTaskDict = [newDict objectForKey:@"CurrentDayTask"];
//                    NSDictionary *swapActionCurrentDayTaskDict = [swapnDict objectForKey:@"CurrentDayTask"];
//
//                    BOOL newActionCurrentDayTaskIsDone=[[newActionCurrentDayTaskDict objectForKey:@"IsDone"]boolValue];
//                    BOOL swapActionCurrentDayTaskIsDone=[[swapActionCurrentDayTaskDict objectForKey:@"IsDone"]boolValue];
//
//                    if (newActionCurrentDayTaskIsDone) {
//                        [cell.tickuntickButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
//                    }else if (swapActionCurrentDayTaskIsDone){
//                        [cell.tickuntickButton setImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];
//                    }else{
//                        [cell.tickuntickButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
//                    }
//
//
//
//                    cell.tickuntickButton.userInteractionEnabled = true;
//                    cell.tickuntickButton.alpha = 1;
//                    if (percentageShowLabel.hidden) {
//                        cell.percentagelabel.hidden = true;
//                        cell.tickuntickButton.userInteractionEnabled = false;
//                    }else{
//                        cell.percentagelabel.hidden = false;
//                        cell.tickuntickButton.userInteractionEnabled = true;
//                    }
//                }
//            }
//        }
       
        
        //----------------------
        
        if (![Utility isEmptyCheck:[dict objectForKey:@"SwapAction"]]) {
            NSDictionary *swapnDict = [dict objectForKey:@"SwapAction"];
            if ((![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask"]]) && ![Utility isEmptyCheck:[swapnDict objectForKey:@"CurrentDayTask"]]) {
                NSDictionary *newActionCurrentDayTaskDict = [newDict objectForKey:@"CurrentDayTask"];
                NSDictionary *swapActionCurrentDayTaskDict = [swapnDict objectForKey:@"CurrentDayTask"];
                
                BOOL newActionCurrentDayTaskIsDone=[[newActionCurrentDayTaskDict objectForKey:@"IsDone"]boolValue];
                BOOL swapActionCurrentDayTaskIsDone=[[swapActionCurrentDayTaskDict objectForKey:@"IsDone"]boolValue];
                
//                [cell.tickuntickButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
                
//                if(saveView.isHidden){
                    if (newActionCurrentDayTaskIsDone) {
                        [cell.tickuntickButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
                    }else if (swapActionCurrentDayTaskIsDone){
                        [cell.tickuntickButton setImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];
                    }else{
                        [cell.tickuntickButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
                    }
//                }else{
                    /*if (![Utility isEmptyCheck:alltickUntickButtonSenderTags]) {
                        if(){
                    [cell.tickuntickButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
                     }else if(){
                    [cell.tickuntickButton setImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];
                      }else{
                    [cell.tickuntickButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
                        }
                    }else{
                        NSLog(@"");
                    }*/
//                }
             
                
                
                
                cell.tickuntickButton.userInteractionEnabled = true;
                cell.tickuntickButton.alpha = 1;
                if (percentageShowLabel.hidden) {
                    cell.percentagelabel.hidden = true;
                    cell.tickuntickButton.userInteractionEnabled = false;
                }else{
                    cell.percentagelabel.hidden = false;
                    cell.tickuntickButton.userInteractionEnabled = true;
                }
            }
        }
        //------------------------
        
       }
    
    
    
    
    
//     if (![Utility isEmptyCheck:[dict objectForKey:@"SwapAction"]]) {
//            NSDictionary *swapDict = [dict objectForKey:@"SwapAction"];
//            if (![Utility isEmptyCheck:[swapDict objectForKey:@"Name"]]) {
//    //            if (indexPath.row%2 == 0) {
//    //                cell.breakNameLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:19];
//    //            }else{
//    //                cell.breakNameLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:19];
//    //            }
//                cell.breakNameLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:17];
//                cell.breakNameLabel.text =[swapDict objectForKey:@"Name"];
//            }
//            cell.breakreminderButton.hidden = true;
//             if (percentageShowLabel.hidden) {
//                 cell.breakpercentagelabel.hidden= true;
//                 cell.breakreminderButton.hidden = true;
//             }else{
//                 cell.breakpercentagelabel.hidden= false;
//                 if ((![Utility isEmptyCheck:[swapDict objectForKey:@"PushNotification"]] && [[swapDict objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[swapDict objectForKey:@"Email"]] && [[swapDict objectForKey:@"Email"] boolValue])) {
////                        cell.breakreminderButton.hidden = false;
//                    }else{
////                        cell.breakreminderButton.hidden = true;
//                 }
//             }
//            /*
//            if(![Utility isEmptyCheck:[swapDict objectForKey:@"OverallPerformance"]]){
//                //[NSString stringWithFormat:@"%.01f%%", [[swapDict objectForKey:@"OverallPerformance"]floatValue]*100]
//                cell.breakpercentagelabel.text = [NSString stringWithFormat:@"%.0f%%", [[swapDict objectForKey:@"OverallPerformance"]floatValue]];//*100
//            }else{
//                cell.breakpercentagelabel.text = @"";
//            }
//             */
//            if ((![Utility isEmptyCheck:[swapDict objectForKey:@"CurrentDayTask"]]) && ![Utility isEmptyCheck:[swapDict objectForKey:@"CurrentDayTask2"]]) {
//                   cell.breaktickuntickButton.userInteractionEnabled = true;
//                   cell.breaktickuntickButton.alpha = 1;
//                   NSDictionary *currentTaskDict = [swapDict objectForKey:@"CurrentDayTask"];
//                   NSDictionary *currentTaskDict1 = [swapDict objectForKey:@"CurrentDayTask2"];
//
//                if (percentageShowLabel.hidden) {
//                    cell.breakpercentagelabel.hidden= true;
//                    cell.breaktickuntickButton.userInteractionEnabled = false;
//                }else{
//                    cell.breakpercentagelabel.hidden= false;
//                    cell.breaktickuntickButton.userInteractionEnabled = true;
//                }
//                   if ([[currentTaskDict objectForKey:@"IsDone"]boolValue] && [[currentTaskDict1 objectForKey:@"IsDone"]boolValue]) {
//                       [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"check_red.png"] forState:UIControlStateNormal];
//
//                   }else if([[currentTaskDict objectForKey:@"IsDone"]boolValue] || [[currentTaskDict1 objectForKey:@"IsDone"]boolValue]){
//                       [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"half_circle_red.png"] forState:UIControlStateNormal];
//                   }else{
//                       [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"unchecked_red.png"] forState:UIControlStateNormal];
//                   }
//               } else if ((![Utility isEmptyCheck:[swapDict objectForKey:@"CurrentDayTask"]])) {
//
//                   cell.breaktickuntickButton.userInteractionEnabled = true;
//                   cell.breaktickuntickButton.alpha = 1;
//                   NSDictionary *currentDayTask = [swapDict objectForKey:@"CurrentDayTask"];
//                   if (percentageShowLabel.hidden) {
//                      cell.breakpercentagelabel.hidden= true;
//                      cell.breaktickuntickButton.userInteractionEnabled = false;
//                   }else{
//                      cell.breakpercentagelabel.hidden= false;
//                      cell.breaktickuntickButton.userInteractionEnabled = true;
//                   }
//                   if ([[currentDayTask objectForKey:@"IsDone"]boolValue]) {
//                       [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"check_red.png"] forState:UIControlStateNormal];
//                   }else{
//                       [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"unchecked_red.png"] forState:UIControlStateNormal];
//                   }
//               }else if(![Utility isEmptyCheck:[swapDict objectForKey:@"CurrentDayTask2"]]){
//                   cell.breaktickuntickButton.userInteractionEnabled = true;
//                   cell.breaktickuntickButton.alpha = 1;
//                   NSDictionary *currentDayTask = [swapDict objectForKey:@"CurrentDayTask2"];
//                   if (percentageShowLabel.hidden) {
//                       cell.breakpercentagelabel.hidden= true;
//                       cell.breaktickuntickButton.userInteractionEnabled = false;
//                   }else{
//                       cell.breakpercentagelabel.hidden= false;
//                       cell.breaktickuntickButton.userInteractionEnabled = true;
//                   }
//                   if ([[currentDayTask objectForKey:@"IsDone"]boolValue]) {
//                       [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"check_red.png"] forState:UIControlStateNormal];
//                   }else{
//                       [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"unchecked_red.png"] forState:UIControlStateNormal];
//                   }
//               }else{
//                   [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"unchecked_red.png"] forState:UIControlStateNormal];
//                    cell.breaktickuntickButton.userInteractionEnabled = false;
//                    cell.breaktickuntickButton.alpha = 0.5;
//               }
//
//        }
  
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![Utility reachable]) {
        return;
    }
    
    
    if (![Utility isEmptyCheck:habitArray] && habitArray.count>0) {
        TableViewCell *cell = [self->habitTable cellForRowAtIndexPath:indexPath];
        if(!cell.reminderButton.isHidden){
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"reminderButton"];
        }else if(cell.reminderButton.isHidden){
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"reminderButton"];
        }
           HabitStatsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitStatsView"];
           controller.habitDict = [habitArray objectAtIndex:indexPath.row];
           controller.isFromHabitList = false;
        controller.habitListArray = habitArray;
           [self.navigationController pushViewController:controller animated:YES];
       }
}
#pragma mark - LongPressGestureRecognizer Delegate

-  (void)handleLongPress:(UILongPressGestureRecognizer*)sender {
        if (sender.state == UIGestureRecognizerStateEnded) {
            NSLog(@"UIGestureRecognizerStateEnded");
   }
  else if (sender.state == UIGestureRecognizerStateBegan){
            NSLog(@"UIGestureRecognizerStateBegan");
            editDelView.hidden = false;
            CGPoint location = [sender locationInView:habitTable];
            NSIndexPath *indexpath= [habitTable indexPathForRowAtPoint:location];
            editButton.tag = indexpath.row;
            delButton.tag = indexpath.row;
   }
}
#pragma mark - End
#pragma mark - DetailsViewDeledate
-(void)reloadUpdatedData:(NSDictionary *)habitDictionary
{
    [self webServicecallForGetGrowthHomePage:[defaults objectForKey:@"Date"]];
}
-(void)setHAbitDetailsDictionary:(NSDictionary *)habitDictionary
{
    habitDetailsDictionary = habitDictionary;
}
@end
