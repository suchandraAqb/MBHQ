//
//  GratitudeListViewController.m
//  Squad
//
//  Created by Rupbani Mukherjee on 20/05/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//
#import "GratitudeListViewController.h"
#import "GratitudeListTableViewCell.h"
#import "GratitudeAddEditViewController.h"

@interface GratitudeListViewController ()
{
    NSArray *gratitudeListArray;
    UIView *contentView;
    BOOL shouldSetupRem;
    __weak IBOutlet UITableView *typeTable;
    IBOutlet UIView *viewFilter;
    
    IBOutletCollection(UIButton) NSArray *dateOutletCollection;
    IBOutlet UIButton *havePictureButton;
    
    IBOutlet UIButton *selectDateButton;
    IBOutlet UIButton *showResultButton;
    IBOutlet UIButton *clearAllButton;
    
    IBOutlet UIButton *expandButton;
    IBOutlet UIButton *filterButton;
    
    IBOutletCollection(UIView) NSArray *viewOutletCollection;
    NSDate *selectedDate;
    NSDate *selectedDateFrom;
    NSDate *selectedDateTo;
    
    IBOutlet UILabel *dateLabel;
    NSArray *masterGratitudeListArr;
    UIButton *SelectedFilterbtn;
    IBOutlet UILabel *noDataLabel;
    IBOutlet UITextField *searchTextField;
    IBOutlet UIButton *plusButton;
    IBOutlet UIButton *fromDateButton;
    IBOutlet UIButton *toDateButton;
    IBOutlet UIButton *printButton;
    IBOutlet UIView *dateRangeView;
    IBOutlet UIView *editDelView;
    IBOutlet UIButton *editButton;
    IBOutlet UIButton *delButton;
    IBOutlet UIView *editDelSubView;
    IBOutlet UIView *walkThroughView;
    IBOutlet UIButton *walkThroughGotItButton;
    IBOutlet UIView *notificationSplashView;
    IBOutlet UIButton *notificationSplashOkGotItButton;
    IBOutlet UIView *infoview;
    IBOutlet UIButton *gotItHidden;

    BOOL isAddPressed;
    UIToolbar *toolBar;
    NSMutableDictionary *gratitudeData;
    UIRefreshControl *refreshControl;
    BOOL isFromNotesFirstentry;
    
//    IBOutlet UIButton *crossButton;
//    IBOutlet UILabel *heyUserLabel;
//    IBOutlet UIButton *iAmGratefulButton;
//    IBOutlet UIView *dailyPopUpView;
//    IBOutlet UIView *dailyPopUpInnerView;
//    IBOutlet UIView *gratitudeBtnView;
//    IBOutlet UIImageView *popUpImageManny;
}
@end

@implementation GratitudeListViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    isAddPressed = false;
    if (_isFromToday) {
        _isFromToday = false;
        isAddPressed = true;
        [self addButtonPressed:0];
        return;
    }
     
    shouldSetupRem = true;
    typeTable.estimatedRowHeight = 80;
    typeTable.rowHeight = UITableViewAutomaticDimension;
    
    viewFilter.hidden = YES;
    selectDateButton.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
    selectDateButton.clipsToBounds = YES;
    selectDateButton.layer.borderWidth = 1.2;
    selectDateButton.layer.cornerRadius = 10;
    
    fromDateButton.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
    fromDateButton.clipsToBounds = YES;
    fromDateButton.layer.borderWidth = 1.2;
    fromDateButton.layer.cornerRadius = 10;
    [fromDateButton setTitle:@"From Date" forState:UIControlStateNormal];
    
    toDateButton.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
    toDateButton.clipsToBounds = YES;
    toDateButton.layer.borderWidth = 1.2;
    toDateButton.layer.cornerRadius = 10;
    [toDateButton setTitle:@"To Date" forState:UIControlStateNormal];
    
    dateRangeView.hidden=true;
    infoview.hidden = true;
    if (![Utility reachable]) {
       if (([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeAeroplaneMode"]] || ![defaults boolForKey:@"isFirstTimeAeroplaneMode"]) && [[self.navigationController visibleViewController] isKindOfClass:[GratitudeListViewController class]]) {
                  [self infoButtonPressed:0];
             }
       }
    [self nofictiactionPermission];

    
#pragma mark - ShowAll on within Filter view
    
    for (UIButton *button in dateOutletCollection)
    {
        if(button.tag == 1){
            button.selected = true;
            SelectedFilterbtn = button;
        }else{
            button.selected = false;
        }
    }
    havePictureButton.selected=false;
   
    [self webServicecallForGetGratitudeListListAPI];
    
    expandButton.selected = true;
    for(UIView *view in viewOutletCollection){
        view.hidden = NO;
    }
    
    searchTextField.text = @"";
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    searchTextField.inputAccessoryView = toolBar;
    searchTextField.layer.borderWidth = 1;
    searchTextField.layer.borderColor = squadSubColor.CGColor;
    searchTextField.layer.cornerRadius = 10.0;
    searchTextField.layer.masksToBounds = YES;
    [searchTextField addTarget:self action:@selector(textValueChange:) forControlEvents:UIControlEventEditingChanged];
    
    //pull to refresh
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    if (@available(iOS 10.0, *)) {
        typeTable.refreshControl = refreshControl;
    } else {
        [typeTable addSubview:refreshControl];
    }
    if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeGratitude"]] || ![defaults boolForKey:@"isFirstTimeGratitude"]) {
        walkThroughView.hidden=false;
    }else{
        walkThroughView.hidden=true;
    }
    walkThroughGotItButton.layer.cornerRadius=15;
    walkThroughGotItButton.layer.masksToBounds=true;
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"IsGratitudeListShow" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        self->isFromNotesFirstentry = true;
        [self webServicecallForGetGratitudeListListAPI];

    }];
      [[NSNotificationCenter defaultCenter] addObserverForName:@"reloadGratitudeEditView" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
          [self webServicecallForGetGratitudeListListAPI];

      }];
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         [formatter setDateFormat:@"yyyy-MM-dd"];
           if (!_isFromGratitudeList && !isAddPressed) {
               NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                      [formatter setDateFormat:@"yyyy-MM-dd"];
                      NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
                      if([DBQuery isRowExist:@"todayGetGrowthDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and AddedDate = '%@'",[NSNumber numberWithInt:[[defaults objectForKey:@"UserID"]intValue]],currentDateStr]]){
                        DAOReader *dbObject = [DAOReader sharedInstance];
                        if([dbObject connectionStart]){
                            NSArray *todayHabitCoursearr = [dbObject selectBy:@"todayGetGrowthDetails" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"AddedDate",@"TodayData",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@' and AddedDate = '%@'",[NSNumber numberWithInt:[[defaults objectForKey:@"UserID"]intValue]],currentDateStr]];
                            NSString *str = todayHabitCoursearr[0][@"TodayData"];
                            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                            NSDictionary *todayHabitCourseList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                            if(![Utility isEmptyCheck:[todayHabitCourseList objectForKey:@"Gratitude"]] || ![Utility isEmptyCheck:[todayHabitCourseList objectForKey:@"Growth"]]){
                                
                            }else{
                                if (([DBQuery isRowExist:@"gratitudeAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and CreatedDateStr = '%@'",[NSNumber numberWithInt:[[defaults objectForKey:@"UserID"]intValue]],currentDateStr]])) {
                                    AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Achievements"];
                                    [self.navigationController pushViewController:controller animated:NO];
//                                }else if (!isFromNotesFirstentry) {
                                }
//                                else if (isFromNotesFirstentry) {
//                                    AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Achievements"];
//                                    [self.navigationController pushViewController:controller animated:NO];
//                                }
                                
                            }
                        }
                         [dbObject connectionEnd];
                      }else{
//                          if (self->_isMoveToday) {
//                              self->_isMoveToday = false;
//                              //i can try adding popup view here
//                              if ([Utility isEmptyCheck:[defaults objectForKey:@"DailyPopUp"]]) {
//                                      [defaults setObject:[NSDate date] forKey:@"DailyPopUp"];
//                                      dailyPopUpView.hidden = false;
//                                  dailyPopUpInnerView.layer.cornerRadius=15;
//                                  dailyPopUpInnerView.layer.masksToBounds=true;
//                                  iAmGratefulButton.layer.cornerRadius=15;
//                                  iAmGratefulButton.layer.masksToBounds=true;
//                                  gratitudeBtnView.layer.cornerRadius = 15;
//                                  gratitudeBtnView.layer.masksToBounds =true;
//                                  NSString *username = [defaults objectForKey:@"FirstName"];
//                                  username = username.uppercaseString;
//                                  NSLog(@"FirstName======>%@",username);
//                                  NSLog(@"");
//
//                                  NSString *welcomeUser = @"HEY ";
//                                  UIFont *welcomeUserFont = [UIFont fontWithName:@"Raleway" size:18];
//                                  NSMutableAttributedString *attributedString1 =
//                                  [[NSMutableAttributedString alloc] initWithString:welcomeUser attributes:@{
//                                      NSFontAttributeName : welcomeUserFont}];
//
//                                  UIFont *usernameFont = [UIFont fontWithName:@"Raleway-Bold" size:22];
//                                  NSMutableAttributedString *attributedString2 =
//                                  [[NSMutableAttributedString alloc] initWithString:username attributes:@{
//                                      NSFontAttributeName : usernameFont}];
////                                  NSString *welcomeUser = [@"" stringByAppendingFormat:@"HEY %@",attributedString1];
//                                  [attributedString1 appendAttributedString:attributedString2];
//                                  NSLog(@"attributedString1======>%@",attributedString1);
//                                  NSLog(@"");
//                                  heyUserLabel.attributedText = attributedString1;
//                                  }
//                                  else if (![Utility isEmptyCheck:[defaults objectForKey:@"DailyPopUp"]]){
//                                      NSDate *lastShownDate=[defaults objectForKey:@"DailyPopUp"];
//                                      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                                      [formatter setDateFormat:@"yyyy-MM-dd"];
//                                      NSString *lastShownDateString = [formatter stringFromDate:lastShownDate];
//                                      NSString *todayDateStr=[formatter stringFromDate:[NSDate date]];
//
//                                      lastShownDate=[formatter dateFromString:lastShownDateString];
//                                      NSDate *todayDate=[formatter dateFromString:todayDateStr];
//                                      if ([todayDate compare:lastShownDate] == NSOrderedDescending) {
//                                          [Utility isEmptyCheck:[defaults objectForKey:@"DontShowDailyPopUp"]];
//                                          if (![defaults boolForKey:@"DontShowDailyPopUp"]) {
//                                              [defaults setObject:[NSNumber numberWithBool:true] forKey:@"DontShowDailyPopUp"];
//                                              [defaults setObject:[NSDate date] forKey:@"DailyPopUp"];
//                                              dailyPopUpView.hidden = false;
//                                              dailyPopUpInnerView.layer.cornerRadius=15;
//                                              dailyPopUpInnerView.layer.masksToBounds=true;
//                                              iAmGratefulButton.layer.cornerRadius=15;
//                                              iAmGratefulButton.layer.masksToBounds=true;
//                                              gratitudeBtnView.layer.cornerRadius = 15;
//                                              gratitudeBtnView.layer.masksToBounds =true;
//                                              NSString *username = [defaults objectForKey:@"FirstName"];
//                                              username = username.uppercaseString;
//                                              NSLog(@"FirstName======>%@",username);
//                                              NSLog(@"");
//
//                                              NSString *welcomeUser = @"HEY ";
//                                              UIFont *welcomeUserFont = [UIFont fontWithName:@"Raleway" size:18];
//                                              NSMutableAttributedString *attributedString1 =
//                                              [[NSMutableAttributedString alloc] initWithString:welcomeUser attributes:@{
//                                                  NSFontAttributeName : welcomeUserFont}];
//
//                                              UIFont *usernameFont = [UIFont fontWithName:@"Raleway-Bold" size:22];
//                                              NSMutableAttributedString *attributedString2 =
//                                              [[NSMutableAttributedString alloc] initWithString:username attributes:@{
//                                                  NSFontAttributeName : usernameFont}];
//            //                                  NSString *welcomeUser = [@"" stringByAppendingFormat:@"HEY %@",attributedString1];
//                                              [attributedString1 appendAttributedString:attributedString2];
//                                              NSLog(@"attributedString1======>%@",attributedString1);
//                                              NSLog(@"");
//                                              heyUserLabel.attributedText = attributedString1;
//                                          }else{
//                                          }
//                                      }else{
//                                      }
//                                  }
//                          }
//                          else if(isFromNotesFirstentry){//} (!isFromNotesFirstentry) {
//                               AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Achievements"];
//                              controller.isMoveToday = false;
////                               TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//                               [self.navigationController pushViewController:controller animated:NO];
//                              
//                           }
                      }
             
           }else{
               _isFromGratitudeList = false;
           }
      showResultButton.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
      showResultButton.clipsToBounds = YES;
      showResultButton.layer.borderWidth = 1;
      showResultButton.layer.cornerRadius = 15;
      
      clearAllButton.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
      clearAllButton.clipsToBounds = YES;
      clearAllButton.layer.borderWidth = 1;
      clearAllButton.layer.cornerRadius = 15;
    
      printButton.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
      printButton.clipsToBounds = YES;
      printButton.layer.borderWidth = 1;
      printButton.layer.cornerRadius = 15;
      
    editDelSubView.layer.cornerRadius = 15;
    editDelSubView.layer.masksToBounds = YES;
    editButton.layer.cornerRadius = 15;
    editButton.layer.masksToBounds = YES;
    delButton.layer.cornerRadius = 15;
    delButton.layer.masksToBounds = YES;
    
    gotItHidden.layer.cornerRadius = 15;
    gotItHidden.layer.masksToBounds = YES;
//    searchTextField.hidden=true;
    plusButton.hidden=false;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
        longPress.minimumPressDuration = 1.0;
        [typeTable addGestureRecognizer:longPress];
    
    
      [[NSNotificationCenter defaultCenter] addObserverForName:@"IsGratitudeListReload" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
               [self webServicecallForGetGratitudeListListAPI];
        }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"IsTodayGetGratitudeGrowthReload" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
         [self webServicecallForGetGratitudeListListAPI];
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark -IBAction

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)printButtonPressed:(id)sender{
    viewFilter.hidden = true;
    [self webServicecallForSearchAndEmailGratitudeListAPI];
}
- (IBAction)filterButtonPressed:(UIButton *)sender
{
    viewFilter.hidden = NO;
}
- (IBAction)walkThroughCrossButtonPressed:(UIButton *)sender {
    walkThroughView.hidden=true;
    [defaults setObject:[NSNumber numberWithBool:true] forKey:@"isFirstTimeGratitude"];
}
-(IBAction)addButtonPressed:(id)sender{
    
    NotesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
    controller.currentDate = _todaySelectDate;
    controller.notesDelegate = self;
    controller.fromStr = @"Gratitude";
    [self.navigationController pushViewController:controller animated:YES];
}


- (IBAction)searchButtonPressed:(id)sender {
//    searchTextField.hidden=!searchTextField.hidden;
    plusButton.hidden=!plusButton.hidden;
}

-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
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
-(IBAction)editDelCrossPressed:(id)sender{
    editDelView.hidden = true;
}
-(IBAction)editPressed:(UIButton*)sender{
       editDelView.hidden = true;
       if ([Utility isEmptyCheck:gratitudeListArray[sender.tag]]) {
              return;
        }
       NSDictionary *dict = [gratitudeListArray objectAtIndex:sender.tag];
        GratitudeAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GratitudeAddEdit"];
        controller.gratitudeData = [dict mutableCopy];
        controller.gratitudeDelegate = self;
        //[self presentViewController:controller animated:YES completion:nil];
        [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)deleteButtonPressed:(UIButton*)sender{
        editDelView.hidden = true;
        if ([Utility isEmptyCheck:gratitudeListArray[sender.tag]]) {
          return;
        }
        NSDictionary *dict = gratitudeListArray[sender.tag];

        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Alert!"
                                      message:@"Do you want to delete ?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* delete = [UIAlertAction
                             actionWithTitle:@"DELETE"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
                                [self delete:dict];
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
    infoview.hidden = true;
    [defaults setBool:true forKey:@"isFirstTimeAeroplaneMode"];
}
-(IBAction)infoButtonPressed:(id)sender{
    infoview.hidden = false;
//    if(gratitudeListArray.count>0){
//           typeTable.hidden = false;
//           noDataLabel.hidden = true;
//       }else{
//           typeTable.hidden = true;
//           noDataLabel.hidden = false;
//       }
}
//- (IBAction)crossButtonPressed:(id)sender {
//    dailyPopUpView.hidden = true;
//}
//
//- (IBAction)iAmGratefulButtonPressed:(id)sender {
//    dailyPopUpView.hidden = true;
//    NotesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
//    controller.currentDate = _todaySelectDate;
//    controller.notesDelegate = self;
//    controller.fromStr = @"Gratitude";
//    [self.navigationController pushViewController:controller animated:YES];
//}
#pragma mark - UIView Filter Section


- (IBAction)dateButtonPressed:(UIButton *)sender{
    
   for (UIButton *btn in dateOutletCollection) {
            if (btn.tag == 6) {
                 btn.selected = true;
                SelectedFilterbtn = btn;
            } else{
                btn.selected = false;
            }
    }
    havePictureButton.selected=false;
    
//    [self clearSelectedDate];
    [self selectDateButtonPressed:sender];
}



- (IBAction)dateOutletcollectionPressed:(UIButton *)sender
{
    
    if (sender.isSelected) {
        [self clearButtonPressed:sender];
    }else{
        //MArk: ShowAll Button selected
        for (UIButton *btn in dateOutletCollection) {
            if (sender==btn)
            {
                [self clearSelectedDate];
                btn.selected = true;
                SelectedFilterbtn = btn;
                if (btn.tag == 6) {
                    //[self selectDateButtonPressed:btn];
                    [fromDateButton setTitle:@"From Date" forState:UIControlStateNormal];
                    [toDateButton setTitle:@"To Date" forState:UIControlStateNormal];
                    dateRangeView.hidden=NO;
                }
                havePictureButton.selected=false;
            } else{
                btn.selected = false;
                dateRangeView.hidden=YES;
            }
        }
        if (sender==havePictureButton) {
            havePictureButton.selected = true;
            SelectedFilterbtn = havePictureButton;
        }
    }
}

- (IBAction)closeView:(UIButton *)sender
{
    viewFilter.hidden = YES;
}
- (IBAction)expandButtonPressed:(UIButton *)sender {
    
    expandButton.selected = !expandButton.isSelected;
    
    [expandButton setImage:[UIImage imageNamed:@"up_arrow_mbHQ.png"] forState:UIControlStateNormal];
    
    if(expandButton.isSelected){
        [expandButton setImage:[UIImage imageNamed:@"up_arrow_mbHQ.png"] forState:UIControlStateNormal];
        for (UIButton *btn in viewOutletCollection) {
            btn.hidden = false;
        }
    }else{
        [expandButton setImage:[UIImage imageNamed:@"down_arrow_mbHQ.png"] forState:UIControlStateNormal];
        for (UIButton *btn in viewOutletCollection) {
            btn.hidden = true;
        }
    }
}

- (IBAction)selectDateButtonPressed:(UIButton *)sender {
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    if (sender.tag==0) {
        if (![Utility isEmptyCheck:selectedDateFrom]) {
            controller.selectedDate = selectedDateFrom;
        }
        controller.dateType=@"From";
    }
    if (sender.tag==1) {
        if (![Utility isEmptyCheck:selectedDateTo]) {
            controller.selectedDate = selectedDateTo;
        }
        controller.dateType=@"To";
    }
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}



-(IBAction)notificationOnOffButtonPressed:(UIButton*)sender{
//     gratitudeData = [[NSMutableDictionary alloc]init];
//     gratitudeData = [[gratitudeListArray objectAtIndex:sender.tag]mutableCopy];
//     [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
//     [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
//     [self saveDataMultiPart];

    NSDictionary *dict = [gratitudeListArray objectAtIndex:sender.tag];
    if ([Utility isEmptyCheck:dict]) {
        return;
    }
    GratitudeAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GratitudeAddEdit"];
    controller.isFromListReminder = true;
    controller.gratitudeData = [dict mutableCopy];
    controller.gratitudeDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
    /*
    if (sender.isSelected) {
        if (![Utility isEmptyCheck:[gratitudeListArray objectAtIndex:sender.tag]]) {
            NSDictionary *userDict = [gratitudeListArray objectAtIndex:sender.tag];
            if (![Utility isEmptyCheck:userDict]) {
                
                if((![Utility isEmptyCheck:[userDict objectForKey:@"PushNotification"]] && [[userDict objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[userDict objectForKey:@"Email"]] && [[userDict objectForKey:@"Email"] boolValue])){
                    
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:nil
                                                              message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction
                                                   actionWithTitle:@"Edit Reminder"
                                                   style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action)
                                                   {
//                                                       [self reminderDetails:true vitaminId:userVitaminId];
                                                   }];
                        UIAlertAction *turnOff = [UIAlertAction
                                                  actionWithTitle:@"Turn Off Reminder"
                                                  style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action)
                                                  {
//                                                      [self webSerViceCall_TurnUserVitaminReminderOff:userVitaminDict];
                                                      
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
        }
    }else{
        if (![Utility isEmptyCheck:[gratitudeListArray objectAtIndex:sender.tag]]) {
//            resultDict= [NSMutableDictionary new];
//            resultDict =  [[gratitudeListArray objectAtIndex:sender.tag]objectForKey:@"UserVitaminDetails"];
        
            SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
            controller.reminderDelegate = self;
            controller.fromController=@"";
            controller.view.backgroundColor = [UIColor clearColor];
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
     */
}
- (IBAction)showResultButtonPressed:(UIButton *)sender
{
    //MARK: ButtonColor Change
    /*  if (showResultButton.isSelected) {
     [showResultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     showResultButton.backgroundColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0];
     [clearAllButton setTitleColor:[UIColor colorWithRed:20.0/255.0 green:227.0/255.0 blue:209.0/255.0 alpha:1.0] forState:UIControlStateNormal];
     clearAllButton.backgroundColor = [UIColor whiteColor];
     }
     else{
     showResultButton.backgroundColor = [UIColor whiteColor];
     [showResultButton setTitleColor:[UIColor colorWithRed:20.0/255.0 green:227.0/255.0 blue:209.0/255.0 alpha:1.0] forState:UIControlStateNormal];
     [clearAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     clearAllButton.backgroundColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0];
     }
     */
    //    if (![Utility isEmptyCheck:gratitudeListArray]) {
    //        noDataLabel.hidden = true;
    //    }else{
    //        [self filterDataFromDate];
    //        noDataLabel.hidden = false;
    //    }
    
    [self filterDataFromDate];
    viewFilter.hidden = YES;
    if (!(SelectedFilterbtn.tag == 1)) {
        filterButton.selected = true;
    }else{
        filterButton.selected = false;
    }
}

- (IBAction)clearButtonPressed:(UIButton *)sender
{
    //MARK: Button selected color change
    /*
     if (clearAllButton.isSelected) {
     [clearAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     clearAllButton.backgroundColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0];
     [showResultButton setTitleColor:[UIColor colorWithRed:20.0/255.0 green:227.0/255.0 blue:209.0/255.0 alpha:1.0] forState:UIControlStateNormal];
     showResultButton.backgroundColor = [UIColor whiteColor];
     }
     else{
     clearAllButton.backgroundColor = [UIColor whiteColor];
     [clearAllButton setTitleColor:[UIColor colorWithRed:20.0/255.0 green:227.0/255.0 blue:209.0/255.0 alpha:1.0] forState:UIControlStateNormal];
     [showResultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     showResultButton.backgroundColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0];
     }
     */
    
#pragma mark - Clear data
    viewFilter.hidden = true;
    [self clearSelectedDate];
    filterButton.selected = false;
    for (UIButton *btn in dateOutletCollection) {
        if(btn.tag == 1){
            btn.selected = true;
            SelectedFilterbtn = btn;
        }else{
            btn.selected = false;
        }
    }
    havePictureButton.selected=false;
    dateRangeView.hidden=true;
    [self filterDataFromDate];
}

#pragma  mark -DatePickerViewControllerDelegate
-(void)didSelectDate:(NSDate *)date dateType:(NSString *)dateType{
    NSLog(@"%@",date);
    if (date) {
        if ([dateType isEqualToString:@"From"]) {
                    SelectedFilterbtn = nil;
            static NSDateFormatter *dateFormatter;
            dateFormatter = [NSDateFormatter new];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            selectedDateFrom = date;
            [dateFormatter setDateFormat:@"dd/MM/yyyy"];// MMM d yyyy
            NSString *dateString = [dateFormatter stringFromDate:date];
            // [dateLabel setText:[NSString stringWithFormat:@"Date: %@",dateString]];
            //[selectDateButton setText:[NSString stringWithFormat:@"Date: %@",dateString]];
            [fromDateButton setTitle:dateString forState:UIControlStateNormal];
            //        UIButton *btn = [[UIButton alloc]init];
            //        btn.tag = 6;
            //        [self dateOutletcollectionPressed:btn];
        }
        if ([dateType isEqualToString:@"To"]) {
                    SelectedFilterbtn = nil;
            static NSDateFormatter *dateFormatter;
            dateFormatter = [NSDateFormatter new];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            selectedDateTo = date;
            [dateFormatter setDateFormat:@"dd/MM/yyyy"];// MMM d yyyy
            NSString *dateString = [dateFormatter stringFromDate:date];
            [toDateButton setTitle:dateString forState:UIControlStateNormal];
        }
    }
}


#pragma mark - Private Method

//pull to refresh
- (void)refreshTable {
    [refreshControl endRefreshing];
     [self webServicecallForGetGratitudeListListAPI];
}

//-(void)dailyPopUp{
//
//}

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
-(void)filterDataFromDate
{
    if([Utility isEmptyCheck:masterGratitudeListArr] || masterGratitudeListArr.count<=0){
        return;
    }
    searchTextField.text=@"";
//    searchTextField.hidden=true;
    plusButton.hidden=false;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *today = [NSDate date];
    
    if(SelectedFilterbtn){
#pragma mark: Filter Show All
        if(SelectedFilterbtn.tag == 1){
            gratitudeListArray = masterGratitudeListArr;
        }
#pragma mark: Filter Today
        else if(SelectedFilterbtn.tag == 2){
            NSString *dateString = [formatter stringFromDate:today];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"CreatedAtString =  %@",dateString];
            gratitudeListArray = [masterGratitudeListArr filteredArrayUsingPredicate:predicate];
        }
#pragma mark: Filter This Month
        else if(SelectedFilterbtn.tag == 3){
            NSDate *firstDay = [NSDate dateWithYear:[today year] month:[today month] day:1];
            
            NSDate *lastDay = [NSDate dateWithYear:[today year] month:[today month] day:[today daysInMonth]];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(CreatedAtString >= %@) AND (CreatedAtString <= %@)",[formatter stringFromDate:firstDay],[formatter stringFromDate:lastDay]];
            
            gratitudeListArray = [masterGratitudeListArr filteredArrayUsingPredicate:predicate];
        }
#pragma mark: Filter 3 Months ago
        else if(SelectedFilterbtn.tag == 4){
            NSDate *sixMonths = [today dateBySubtractingDays:90];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(CreatedAtString >= %@) AND (CreatedAtString <= %@)",[formatter stringFromDate:sixMonths],[formatter stringFromDate:today]];
            gratitudeListArray = [masterGratitudeListArr filteredArrayUsingPredicate:predicate];
        }
#pragma mark: Filter 1 year ago
        else if(SelectedFilterbtn.tag == 5){
            NSDate *oneYear = [today dateBySubtractingDays:365];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(CreatedAtString >= %@) AND (CreatedAtString <= %@)",[formatter stringFromDate:oneYear],[formatter stringFromDate:today]];
            gratitudeListArray = [masterGratitudeListArr filteredArrayUsingPredicate:predicate];
        }
#pragma mark: Filter Select Date
        else if (SelectedFilterbtn.tag==6){
            if(selectedDateFrom && selectedDateTo){
                NSString *dateString1 = [formatter stringFromDate:selectedDateFrom];
                NSString *dateString2 = [formatter stringFromDate:selectedDateTo];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(CreatedAtString >= %@) AND (CreatedAtString <=  %@)",dateString1,dateString2];
                gratitudeListArray = [masterGratitudeListArr filteredArrayUsingPredicate:predicate];
            }
            else{
                [Utility msg:@"Please select date range" title:@"Oops!" controller:self haveToPop:NO];
            }
        }
#pragma mark: Filter having picture
        else if(SelectedFilterbtn.tag == 7){
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Picture != %@ and Picture != %@)",@"",@"<null>"];
            gratitudeListArray = [masterGratitudeListArr filteredArrayUsingPredicate:predicate];
        }
    }
    else{
#pragma mark: Filter Select Date
        if(selectedDateFrom && selectedDateTo){
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *dateString1 = [formatter stringFromDate:selectedDateFrom];
            NSString *dateString2 = [formatter stringFromDate:selectedDateTo];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(CreatedAtString >= %@) AND (CreatedAtString <=  %@)",dateString1,dateString2];
            gratitudeListArray = [masterGratitudeListArr filteredArrayUsingPredicate:predicate];
        }
    }
    [typeTable reloadData];
}

-(void)webServicecallForGetGratitudeListListAPI{
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
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetGratitudeListListAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       
                                                                       self->masterGratitudeListArr = [responseDictionary objectForKey:@"Details"];
                                                                       if (![Utility isEmptyCheck:self->masterGratitudeListArr] && self->masterGratitudeListArr.count>0) {
                                                                           
                                                                           self->gratitudeListArray = [self->masterGratitudeListArr mutableCopy];
                                                                           
                                                                           if (self->shouldSetupRem) {
                                                                               self->shouldSetupRem = NO;
                                                                               [self setUpReminder];    
                                                                           }
                                                                       }else{
                                                                           self->gratitudeListArray = [[NSArray alloc]init];
                                                                           [self->typeTable reloadData];
                                                                       }
                                                                       [self filterDataFromDate];
                                                                       
                                                                   }else{
                                                                       [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                   }
                                                               });
                                                           }];
        [dataTask resume];
        
    }else{
        if ([Utility reachable]) {
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
    
}
-(void)webServicecallForSearchAndEmailGratitudeListAPI{
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
        [mainDict setObject:[NSNumber numberWithInt:(int)SelectedFilterbtn.tag-1] forKey:@"SearchPeriod"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SearchAndEmailGratitudeList" append:@"" forAction:@"POST"];
        
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
                                                                           [Utility msg:@"Search details sent to mail" title:@"" controller:self haveToPop:NO];
                                                                       }
                                                                      
                                                                   }else{
                                                                       [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                   }
                                                               });
                                                           }];
        [dataTask resume];
        
    }else{
        if ([Utility reachable]) {
           [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
    
}
-(void)saveDataMultiPart {
    if (Utility.reachable) {
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
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateGratitudeApiCallWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        //controller.chosenImage=selectedImage;
        controller.chosenImage=nil;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        if ([Utility reachable]) {
          [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
    
}
-(void)delete:(NSDictionary*)gratitudeData{
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
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[gratitudeData valueForKey:@"Id"] forKey:@"GratitudeID"];
        
    
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
        [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
        return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteGratitudeApiCall" append:@"" forAction:@"POST"];
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
            if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                        UIAlertController *alertController = [UIAlertController
                                        alertControllerWithTitle:@"Success"
                                        message:@"Gratitude Deleted Successfully. "
                                        preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *okAction = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action) {
                                            self->shouldSetupRem = true;
                                            [self webServicecallForGetGratitudeListListAPI];
                                           
                                        }];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
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

- (void) setUpReminder
{
    NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *req in requests) {
        NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
        if ([pushTo caseInsensitiveCompare:@"Gratitude"] == NSOrderedSame) {
            
            [[UIApplication sharedApplication] cancelLocalNotification:req];
            
        }
    }
    
    for (int i = 0; i < gratitudeListArray.count; i++) {
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[gratitudeListArray objectAtIndex:i]];
        if ([[dict objectForKey:@"PushNotification"] boolValue]) {
            if (![Utility isEmptyCheck:[dict objectForKey:@"Id"]] && ![Utility isEmptyCheck:[dict objectForKey:@"FrequencyId"]]) {
                NSDictionary *dict1 = @{@"Id" : [dict objectForKey:@"Id"]};
                [SetReminderViewController setOldLocalNotificationFromDictionary:[dict mutableCopy] ExtraData:[dict1 mutableCopy] FromController:@"Gratitude" Title:[dict objectForKey:@"Name"] Type:@"Gratitude" Id:[[dict objectForKey:@"Id"] intValue]];
            }
           
        }
    }
    
}

-(void)clearSelectedDate{
    selectedDate = nil;
    selectedDateFrom=nil;
    selectedDateTo=nil;
//    [toDateButton setTitle:@"From Date" forState:UIControlStateNormal];
//    [toDateButton setTitle:@"To Date" forState:UIControlStateNormal];
    [selectDateButton setTitle:@"SELECT DATE" forState:UIControlStateNormal];
    
}

#pragma mark - TableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table{
    return 1;
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    if(gratitudeListArray.count>0){
        noDataLabel.hidden = true;
    }else{
        noDataLabel.hidden = false;
    }
    return gratitudeListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"GratitudeList";
    GratitudeListTableViewCell *cell;
    cell=[table dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[GratitudeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
    NSDictionary *dict = [gratitudeListArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        if (![Utility isEmptyCheck:[dict objectForKey:@"Name"]]) {
            
//            if (indexPath.row%2 == 0) {
//                cell.gratitudeListLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:19];
//            }else{
//                cell.gratitudeListLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:19];
//            }
            cell.gratitudeListLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:19];
            cell.gratitudeListLabel.text = ![Utility isEmptyCheck:[dict objectForKey:@"Name"]]? [dict objectForKey:@"Name"] : @"";
        }
    
    NSString *detailString= @"";
    
    if (![Utility isEmptyCheck:[dict objectForKey:@"CreatedAtString"]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd'T'HH:mm:ss
        NSDate *date = [formatter dateFromString:[dict objectForKey:@"CreatedAtString"]];
        NSLog(@"%@",[dict objectForKey:@"CreatedAtString"]);
        
        if(date){
            
            if([date isToday]){
                detailString = @"Today";
            }else if ([date isYesterday]){
                detailString = @"Yesterday";
            }else{
                [formatter setDateFormat:@"EEEE d MMMM"];
                NSString *dateStr = [@"" stringByAppendingFormat:@"%@",[formatter stringFromDate:date]];
                
                NSInteger currentDay = [date day];
                NSString *daySuffix = [@"" stringByAppendingFormat:@"%ld%@",(long)currentDay,[Utility daySuffixForDate:date]];
                
                dateStr = [dateStr stringByReplacingOccurrencesOfString:[@"" stringByAppendingFormat:@"%ld",(long)currentDay] withString:daySuffix options:NSCaseInsensitiveSearch range:[dateStr rangeOfString:[@"" stringByAppendingFormat:@"%ld",(long)currentDay]]];
                
                detailString = dateStr;
            }
        }
    }
    cell.gratitudeListDayLabel.text = detailString;
    if (![Utility isEmptyCheck:[dict objectForKey:@"Picture"]]){
        cell.gratitudeListDayLabel.textColor=[Utility colorWithHexString:mbhqBaseColor];
    }else{
        cell.gratitudeListDayLabel.textColor=[Utility colorWithHexString:@"474747"];
    }
        
        
        
        
//    if(![Utility isEmptyCheck:[dict objectForKey:@"PictureDevicePath"]]){
//        NSString *localImageName = [dict objectForKey:@"PictureDevicePath"];
//        UIImage *selectedImage = [Utility getImageFromDocumentDirectoryWithImageName:localImageName];
//        if(selectedImage){
//            cell.gratitudeListDayLabel.textColor=[Utility colorWithHexString:mbhqBaseColor];
//        }else if (![Utility isEmptyCheck:[dict objectForKey:@"Picture"]]){
//            cell.gratitudeListDayLabel.textColor=[Utility colorWithHexString:mbhqBaseColor];
//        }else{
//            cell.gratitudeListDayLabel.textColor=[Utility colorWithHexString:@"474747"];
//        }
//    }else if (![Utility isEmptyCheck:[dict objectForKey:@"Picture"]]){
//        cell.gratitudeListDayLabel.textColor=[Utility colorWithHexString:mbhqBaseColor];
//    }else{
//        cell.gratitudeListDayLabel.textColor=[Utility colorWithHexString:@"474747"];
//    }
        
        
        
    
    if ((![Utility isEmptyCheck:[dict objectForKey:@"PushNotification"]] && [[dict objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[dict objectForKey:@"Email"]] && [[dict objectForKey:@"Email"] boolValue])) {
        cell.notificationButton.selected = true;
        cell.notificationButton.hidden = false;
    }else{
        cell.notificationButton.selected = false;
        cell.notificationButton.hidden = true;
        }
    }
    cell.notificationButton.tag = indexPath.row;
    return cell;
}
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Ru
    NSDictionary *dict = [gratitudeListArray objectAtIndex:indexPath.row];
    GratitudeAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GratitudeAddEdit"];
    controller.gratitudeData = [dict mutableCopy];
    controller.gratitudeDelegate = self;
    //[self presentViewController:controller animated:YES completion:nil];
    [self.navigationController pushViewController:controller animated:YES];
}




#pragma mark - textField Delegate
-(void)textValueChange:(UITextField *)textField{
    NSLog(@"search for %@", textField.text);
    if(textField.text.length>0){
        gratitudeListArray=[masterGratitudeListArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Name CONTAINS[c] %@)", textField.text]];
    }else{
        gratitudeListArray=masterGratitudeListArr;
    }
//    if (![Utility isEmptyCheck:gratitudeListArray]) {
//        noDataLabel.hidden = true;
//    }else{
//        noDataLabel.hidden = false;
//    }
    [typeTable reloadData];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    viewFilter.hidden = true;
    if(textField.text.length>0){
        gratitudeListArray=[masterGratitudeListArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Name CONTAINS[c] %@)", textField.text]];
    }else{
        gratitudeListArray=masterGratitudeListArr;
    }
    if (![Utility isEmptyCheck:gratitudeListArray]) {
        noDataLabel.hidden = true;
    }else{
        noDataLabel.hidden = false;
    }
    [typeTable reloadData];
    [textField resignFirstResponder];
}
#pragma mark - End


#pragma mark - GratitudeAddEditDelegate
- (void)didGratitudeBackAction:(BOOL)ischanged{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];
    self->shouldSetupRem = true;
    [self webServicecallForGetGratitudeListListAPI];
}
-(void)reloadData:(BOOL)isreload{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];
    [self webServicecallForGetGratitudeListListAPI];
}
#pragma mark - End


#pragma mark - Gesture recognizer delegate
//-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
//{
//    CGPoint p = [gestureRecognizer locationInView:typeTable];
//    NSIndexPath *indexPath = [typeTable indexPathForRowAtPoint:p];
//    if (indexPath != nil) {
//        if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
//            NSDictionary *dict = [gratitudeListArray objectAtIndex:indexPath.row];
//            [UIPasteboard generalPasteboard].string = ![Utility isEmptyCheck:[dict objectForKey:@"Name"]]? [dict objectForKey:@"Name"] : @"";
//            [Utility showToastInsideView:self.view WithMessage:@"Copied.."];
//        }
//    }
//}
#pragma mark - LongPressGestureRecognizer Delegate

-  (void)handleLongPress:(UILongPressGestureRecognizer*)sender {
        if (sender.state == UIGestureRecognizerStateEnded) {
            NSLog(@"UIGestureRecognizerStateEnded");
   }
  else if (sender.state == UIGestureRecognizerStateBegan){
            NSLog(@"UIGestureRecognizerStateBegan");
            editDelView.hidden = false;
            CGPoint location = [sender locationInView:typeTable];
            NSIndexPath *indexpath= [typeTable indexPathForRowAtPoint:location];
            editButton.tag = indexpath.row;
            delButton.tag = indexpath.row;

   }
}
#pragma mark - End
#pragma mark - End

#pragma mark progressbar delegate

- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    dispatch_async(dispatch_get_main_queue(), ^{
    if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
        self->shouldSetupRem = true;
        [self webServicecallForGetGratitudeListListAPI];
        }
    });
}
@end
