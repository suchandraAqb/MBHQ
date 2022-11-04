//
//  HabitHackerListViewController.m
//  Squad
//
//  Created by Suchandra Bhattacharya on 03/12/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "HabitHackerListViewController.h"
#import "TableViewCell.h"
#import "HabitHackerDetailsViewController.h"
#import "HabitStatsViewController.h"
#import "PrivacyPolicyAndTermsServiceViewController.h"
#import "HabitHackerFirstViewController.h"
#import "BucketListNewAddEditViewController.h"
#import "HabitHackerDetailNewViewController.h"
#import "WinTheWeekViewController.h"
#import "HabitStateDetailsViewController.h"

@interface HabitHackerListViewController ()
{
    IBOutlet UITableView *habitTable;
    IBOutlet UIButton *habitSwapButton;
    IBOutlet UIView *habitFilterview;
    IBOutletCollection(UIButton) NSArray *filterButton;
    IBOutletCollection(UIButton) NSArray *checkUncheckButton;
    IBOutlet UIButton *manualButton;
    IBOutlet UILabel *noDataFound;
    IBOutlet UIView *infoview;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *percentageShowLabelButton;
    BOOL isChanged;
    UIView *contentView;
    NSMutableArray *habitListArray;
    NSArray *habitMainArray;
    int twiceDailyCount;
    int twiceDailyCountForBreak;
    IBOutlet UIButton *highestToLowestButton;
    IBOutletCollection(UIButton) NSArray *sortButtonCollection;
    IBOutlet UIButton *createHabitNowButton;
    IBOutlet UIButton *showMeExample;
    BOOL tickUntickBool;
    IBOutlet UIButton *settingsButton;
    IBOutlet UIView *addButtonShowView;
    IBOutlet UIView *habitmainView;
    IBOutletCollection(UIButton) NSArray *viewTickButton;
    IBOutlet NSLayoutConstraint *habitListViewHeightConstant;
    IBOutlet UIView *editDelView;
    IBOutletCollection(UIButton) NSArray *editDelButton;
    IBOutlet UIButton *editButton;
    IBOutlet UIButton *delButton;
    IBOutlet UIView *editDelSubView;
    IBOutlet UIButton *walkThroughGotItButton;
    IBOutlet UIButton *weeklyOverviewButton;
    IBOutlet UIButton *autoCompleteHabitButton;
    
    IBOutlet UIButton *todaysHabitsListButton;
    IBOutlet UIButton *showAllHabitListButton;

    UIRefreshControl *refreshControl;
    NSArray *filterTagArr;
    NSArray *filterViewTagArray;
    BOOL isShowAllHabits;
    BOOL isHabitList;
    TableViewCell *cell;
    NSDictionary *habitDetailsDictionary;
    
//    NSArray *ActivehabitArray;
}
@end


@implementation HabitHackerListViewController
@synthesize ActiveHabitArray;
#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    habitTable.estimatedRowHeight = 180;
    habitTable.rowHeight = UITableViewAutomaticDimension;
    habitFilterview.hidden = true;
    habitSwapButton.layer.cornerRadius = 15;
    habitSwapButton.layer.masksToBounds = YES;
    habitSwapButton.layer.borderColor = squadMainColor.CGColor;
    habitSwapButton.layer.borderWidth = 1;
    walkThroughGotItButton.layer.cornerRadius=15;
    walkThroughGotItButton.layer.masksToBounds=true;
       
    todaysHabitsListButton.layer.cornerRadius = 15;
    todaysHabitsListButton.layer.masksToBounds = YES;
    todaysHabitsListButton.layer.borderColor = squadMainColor.CGColor;
    todaysHabitsListButton.layer.borderWidth = 1;
    
    infoview.hidden = true;
    isChanged = true;
    habitListArray = [[NSMutableArray alloc]init];
    saveButton.hidden = true;
    createHabitNowButton.layer.cornerRadius = 15;
    createHabitNowButton.layer.masksToBounds = YES;
    showMeExample.layer.cornerRadius = 15;
    showMeExample.layer.masksToBounds = YES;
    addButtonShowView.hidden = true;
    habitmainView.hidden = true;
    editDelView.hidden = true;
    for (UIButton *button in editDelButton)  {
        button.layer.cornerRadius = 15;
        button.layer.masksToBounds = YES;
    }
    editDelSubView.layer.cornerRadius = 15;
    editDelSubView.layer.masksToBounds = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.0;
    [habitTable addGestureRecognizer:longPress];
    
    for(UIButton *button in filterButton){
      if (button.tag == 1) {
          button.layer.borderColor = squadMainColor.CGColor;
          button.layer.borderWidth = 1;
      }
          button.layer.cornerRadius = 15;
          button.layer.masksToBounds = YES;
        }
    [[NSNotificationCenter defaultCenter] addObserverForName:@"IsfromHabitList" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
          self->_isHabitFirstViewOpen = true;
      }];
      
       if (([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeHabit"]] || ![defaults boolForKey:@"isFirstTimeHabit"]) && [[self.navigationController visibleViewController] isKindOfClass:[HabitHackerListViewController class]]) {
            [self infoButtonPressed:0];
       }
    [[NSNotificationCenter defaultCenter] addObserverForName:@"IsHackerListReload" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
               dispatch_async(dispatch_get_main_queue(), ^{
                   [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];
                    [self webcellCall_GetUserHabitList];
               });
       }];
      [[NSNotificationCenter defaultCenter] addObserverForName:@"IsHackerListDelete" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
          dispatch_async(dispatch_get_main_queue(), ^{
              NSLog(@"%@",notification.object);
              [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];

              NSPredicate *predicate = [NSPredicate predicateWithFormat:@"HabitId = %@",notification.object];
              NSArray *filterArray = [self->habitListArray filteredArrayUsingPredicate:predicate];
              if(filterArray.count>0){
                  [self->habitListArray removeObject:[filterArray objectAtIndex:0]];
                  [self->habitTable reloadData];
              }
             
              });
        }];
    
  

    //pull to refresh
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    if (@available(iOS 10.0, *)) {
        habitTable.refreshControl = refreshControl;
    } else {
        [habitTable addSubview:refreshControl];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"ActivehabitArray%@",ActiveHabitArray);
    NSLog(@"");
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self webcellCall_GetWeeklyOverview];
    [self getAutoCompleteHabitFlag_ApiCall];
    [self prepareFilterViewOnload];

    
    NSLog(@"%@",[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2]);
    
    UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    if (!_isHabitFirstViewOpen) {
        if (![controller isKindOfClass:[BucketListNewViewController class]] && ![controller isKindOfClass:[BucketListNewAddEditViewController class]] && ![controller isKindOfClass:[HabitHackerFirstViewController class]]) {
            [self isMoveToTodayHabit];
        }
    }else{
        _isHabitFirstViewOpen = false;
    }
    if(_isFromhelpSectionshowME){
        _isFromhelpSectionshowME = false;
        [self showMePressed:0];
    }else if(_isFromhelpSectionCreate){
        _isFromhelpSectionCreate = false;
        [self addhabitPressed:0];
    }
    if ([defaults boolForKey:@"isCreate"]) {
        tickUntickBool = true;
    }else{
        tickUntickBool = false;
    }
    
    if(isChanged){
        isChanged = false;
        if ([Utility isEmptyCheck:[defaults objectForKey:@"defaultStatesViewFromList"]]) {
            [defaults setObject:[NSNumber numberWithInt:0] forKey:@"defaultStatesViewFromList"];
            [self webcellCall_UpdateHabitStatsPreference];
        }else{
          [self webcellCall_GetUserHabitList];
    }
    twiceDailyCount = 1;
    twiceDailyCountForBreak = 1;
    }
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(![Utility isEmptyCheck:filterTagArr]){
        [defaults setObject:filterTagArr forKey:@"habitListFilterStatus"];
    }else{
        [defaults removeObjectForKey:@"habitListFilterStatus"];
    }
    if(![Utility isEmptyCheck:filterViewTagArray] && ![Utility isEmptyCheck:[defaults objectForKey:@"habitViewStatus"]]){
           [defaults setObject:filterViewTagArray forKey:@"habitViewStatus"];
       }else{
           [defaults removeObjectForKey:@"habitViewStatus"];
       }
    
}
#pragma nark - End


#pragma mark - Webservice Call

-(void)getAutoCompleteHabitFlag_ApiCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            
//             if (self->contentView) {
//                 [self->contentView removeFromSuperview];
//                }
//             self->contentView = [Utility activityIndicatorView:self];
             
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetAutoCompleteHabitFlag" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                     

                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         
                                                                         
                                                                         [self->autoCompleteHabitButton setSelected:[[responseDictionary objectForKey:@"AutoCompleteHabit"] boolValue]];
                                                                         
                                                                             

                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                         
                                                                         return;
                                                                     }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        [self->autoCompleteHabitButton setSelected:!self->autoCompleteHabitButton.isSelected];
    }
}

-(void)updateAutoCompleteHabitFlag_ApiCall:(BOOL)value{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            
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
        [mainDict setObject:[NSNumber numberWithBool:value] forKey:@"AutCompleteHabit"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateAutoCompleteHabitFlag" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                     

                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                             

                                                                         }else{
                                                                             [Utility msg:responseDictionary[@"ErrorMessage"] title:@"Oops! " controller:self haveToPop:NO];
                                                                             [self->autoCompleteHabitButton setSelected:!self->autoCompleteHabitButton.isSelected];
                                                                             return;
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                         [self->autoCompleteHabitButton setSelected:!self->autoCompleteHabitButton.isSelected];
                                                                         return;
                                                                     }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        [self->autoCompleteHabitButton setSelected:!self->autoCompleteHabitButton.isSelected];
    }
}



-(void)webcellCall_GetWeeklyOverview{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            
//             if (self->contentView) {
//                 [self->contentView removeFromSuperview];
//                }
//             self->contentView = [Utility activityIndicatorView:self];
             
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetHabitWeeklyOverview" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                     

                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         
                                                                         
                                                                         [self->weeklyOverviewButton setSelected:[[responseDictionary objectForKey:@"WeeklyOverview"] boolValue]];
                                                                         
                                                                             

                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                         
                                                                         return;
                                                                     }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        [self->weeklyOverviewButton setSelected:!self->weeklyOverviewButton.isSelected];
    }
}

-(void)webcellCall_UpdateWeeklyOverview:(BOOL)value{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            
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
        [mainDict setObject:[NSNumber numberWithBool:value] forKey:@"WeeklyOverview"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateHabitWeeklyOverview" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                     

                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                             

                                                                         }else{
                                                                             [Utility msg:responseDictionary[@"ErrorMessage"] title:@"Oops! " controller:self haveToPop:NO];
                                                                             [self->weeklyOverviewButton setSelected:!self->weeklyOverviewButton.isSelected];
                                                                             return;
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                         [self->weeklyOverviewButton setSelected:!self->weeklyOverviewButton.isSelected];
                                                                         return;
                                                                     }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        [self->weeklyOverviewButton setSelected:!self->weeklyOverviewButton.isSelected];
    }
}

-(void)webcellCall_GetUserHabitList{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
             if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeHabit"]] || ![defaults boolForKey:@"isFirstTimeHabit"]) {
                 [self->contentView removeFromSuperview];
             }else{
                 if (self->contentView) {
                     [self->contentView removeFromSuperview];
                    }
                 self->contentView = [Utility activityIndicatorView:self];
             }
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
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                     self->habitmainView.hidden = false;

                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                             if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"HabitSwaps"]]) {
                                                                                 self->addButtonShowView.hidden = true;
                                                                                 self->habitTable.hidden = false;
                                                                                 self->habitMainArray = [responseDictionary objectForKey:@"HabitSwaps"];
                                                                                 self->habitListArray = [self->habitMainArray mutableCopy];
                                                                               
                                                                                 [self setUpReminder];
                                                                                 [self->habitTable reloadData];
                                                                                 [self showResult:0];
                                                                             }else{
                                                                                 self->habitTable.hidden = true;
                                                                                 if (self->_isFromhelpSectionshowME) {
                                                                                     self->addButtonShowView.hidden = true;
                                                                                 }else{
                                                                                     if (![defaults boolForKey:@"isFirstTimeHabit"]) {
                                                                                         self->addButtonShowView.hidden = true;
                                                                                     }else{
                                                                                         self->addButtonShowView.hidden = false;
                                                                                     }
                                                                                 }
                                                                             }

                                                                         }else{
                                                                             [Utility msg:responseDictionary[@"ErrorMessage"] title:@"Oops! " controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
-(void)webcellCall_UpdateHabitStatsPreference{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
             if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeHabit"]] || ![defaults boolForKey:@"isFirstTimeHabit"]) {
                 [self->contentView removeFromSuperview];
             }else{
                 if (self->contentView) {
                     [self->contentView removeFromSuperview];
                    }
                 self->contentView = [Utility activityIndicatorView:self];
             }
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"defaultStatesViewFromList"] forKey:@"PreferenceType"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateHabitStatsPreference" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                     self->habitmainView.hidden = false;

                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         [self webcellCall_GetUserHabitList];
                                                                     }else{
                                                                             [Utility msg:responseDictionary[@"ErrorMessage"] title:@"Oops! " controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
-(void)webSerViceCall_UpdateTaskStatus:(NSDictionary*)dict with:(UIButton *)sender{
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
        [mainDict setObject:[dict objectForKey:@"TaskMasterId"] forKey:@"TaskId"];
        if ([[dict objectForKey:@"IsTaskDone"]boolValue]) {
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
                                                                         NSDictionary *dict = [self->habitListArray objectAtIndex:sender.tag];
                                                                         [DBQuery updateHabitColumn:[[dict objectForKey:@"HabitId"]intValue] with:1];
                                                                         self->tickUntickBool = true;
                                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];
                                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"IsHackerListReload" object:self userInfo:nil];
                                                                         [self webcellCall_GetUserHabitList];
                                                                         [self webSerViceCall_GetTaskStatusForDate];
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
-(void)webSerViceCall_UpdateHabitSwapManualOrder:(NSArray*)habitIds{
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
        [mainDict setObject:habitIds forKey:@"HabitIds"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateHabitSwapManualOrder" append:@""forAction:@"POST"];
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
                                                                         [self clearAll:nil];
                                                                           [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];
                                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"IsHackerListReload" object:self userInfo:nil];

                                                                         [self webcellCall_GetUserHabitList];
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
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"]boolValue]) {
                                                                             [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];
                                                                             [[NSNotificationCenter defaultCenter]postNotificationName:@"IsHackerListReload" object:self userInfo:nil];

                                                                             [self webcellCall_GetUserHabitList];
                                                                            
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

-(void)webServicecallForSearchAndEmailHabitListAPI{
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
        [mainDict setObject:@"" forKey:@"searchText"];
        NSMutableArray *arr = [NSMutableArray new];
        if (filterTagArr.count>0) {
            

        if (filterTagArr.count == 3) {
            [arr addObject:[NSNumber numberWithInt:Active]];
            [arr addObject:[NSNumber numberWithInt:Snooze]];
            [arr addObject:[NSNumber numberWithInt:Completed]];
        }else if(filterTagArr.count == 2){
            NSString *str = filterTagArr [0];
            if ([str isEqualToString:@"1"]) {
                [arr addObject:[NSNumber numberWithInt:Active]];
            }else if ([str isEqualToString:@"2"]){
                [arr addObject:[NSNumber numberWithInt:Snooze]];
            }else{
                [arr addObject:[NSNumber numberWithInt:Completed]];
            }
            NSString *str1 = filterTagArr [1];
             if ([str1 isEqualToString:@"1"]) {
                  [arr addObject:[NSNumber numberWithInt:Active]];
               }else if ([str1 isEqualToString:@"2"]){
                   [arr addObject:[NSNumber numberWithInt:Snooze]];
               }else{
                   [arr addObject:[NSNumber numberWithInt:Completed]];
               }

        }else{
            NSString *str = filterTagArr [0];
               if ([str isEqualToString:@"1"]) {
                   [arr addObject:[NSNumber numberWithInt:Active]];
               }else if ([str isEqualToString:@"2"]){
                   [arr addObject:[NSNumber numberWithInt:Snooze]];
               }else{
                   [arr addObject:[NSNumber numberWithInt:Completed]];
               }
        }
        }
        [mainDict setObject:arr forKey:@"Status"];

        if (highestToLowestButton.selected) {
            [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"OrderBy"];
        }else{
            [mainDict setObject:[NSNumber numberWithInt:1] forKey:@"OrderBy"];
        }
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"EmailUserHabitSwaps" append:@"" forAction:@"POST"];
        
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
                                                                           self->habitFilterview.hidden = true;
                                                                           [Utility msg:@"Habit details sent to mail" title:@"" controller:self haveToPop:NO];
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
-(void)addUpdateHabitSwap_WebServiceCall:(NSDictionary*)habitDict{
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
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:habitDict forKey:@"Habit"];
        

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateHabitSwap" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"]boolValue]) {
                                                                             [[NSNotificationCenter defaultCenter]postNotificationName:@"IsHackerListReload" object:self userInfo:nil];

                                                                             [self webcellCall_GetUserHabitList];
                                                                            
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
        [mainDict setObject:[formatter stringFromDate:[NSDate date]] forKey:@"ForDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetTaskStatusForDate" append:@""forAction:@"POST"];
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

#pragma nark - End


#pragma mark - Private Function


-(void)checkWinTheWeek:(NSDictionary*)responseDict{
    int totalTaskForTheDay=[[responseDict objectForKey:@"TotalTaskForTheDay"] intValue];
    int totalTaskDoneForTheDay=[[responseDict objectForKey:@"TotalTaskDoneForTheDay"] intValue];
    BOOL dailyPopupShown = [[responseDict objectForKey:@"DailyBadgeShown"] boolValue];
    
    int daysDoneForTheWeek=[[responseDict objectForKey:@"DaysDoneForTheWeek"] intValue];
    BOOL WeeklyPopupShown = [[responseDict objectForKey:@"WeeklyBadgeShown"] boolValue];
    
    NSString *weekStartDateStr=[responseDict objectForKey:@"WeekStartDate"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDateString=[formatter stringFromDate:[NSDate date]];
    
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

//pull to refresh
- (void)refreshTable {
    [refreshControl endRefreshing];
    [self webcellCall_GetUserHabitList];
}

-(void)prepareFilterViewOnload{
    
    if(![Utility isEmptyCheck:[defaults objectForKey:@"habitListFilterStatus"]]){
        filterTagArr = [defaults objectForKey:@"habitListFilterStatus"];
        
        for(UIButton *button in checkUncheckButton){
            NSString *tagStr = [@"" stringByAppendingFormat:@"%ld",button.tag];
            if([filterTagArr containsObject:tagStr]){
                button.selected = true;
            }
        }
        /*
        for(UIButton *button in checkUncheckButton){
            NSString *tagStr = [@"" stringByAppendingFormat:@"%ld",button.tag];
            if([filterTagArr containsObject:tagStr]){
                button.selected = true;
            }
        }*/
        
        
    }
    if (![Utility isEmptyCheck:[defaults objectForKey:@"habitViewStatus"]]) {
        filterViewTagArray = [defaults objectForKey:@"habitViewStatus"];
    
        for (UIButton *btn in viewTickButton) {
                    NSString *tagStr = [@"" stringByAppendingFormat:@"%ld",btn.tag];
                    if([filterViewTagArray containsObject:tagStr]){
                        if ([tagStr isEqualToString:@"0"]) {
                            isShowAllHabits = false;
                        }else{
                            isShowAllHabits = true;
                        }
                       btn.selected = true;
                   }
                }
    }else{
        for (UIButton *btn in viewTickButton) {
            if (btn.tag == 0) {
                btn.selected = true;
            }else{
                btn.selected = false;
            }
        }
        isShowAllHabits = false;
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
-(void)clearShowAllHabitsView{
//    isShowAllHabits = false;
//    for (UIButton *btn in viewTickButton) {
//            btn.selected = false;
//    }
}
-(void)clearAllTickofStatusSortSection{
     for(UIButton *button in checkUncheckButton){
         button.selected = false;
     }
    showAllHabitListButton.selected=false;
    manualButton.selected =false;
    highestToLowestButton.selected =false;
}
//- (void) setUpReminder {
//
//    NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
//    for (UILocalNotification *req in requests) {
//        NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
//    if ([pushTo caseInsensitiveCompare:@"HabitList"] == NSOrderedSame) {
//            [[UIApplication sharedApplication] cancelLocalNotification:req];
//        }
//    }
//
//    for (int i = 0; i < habitListArray.count; i++) {
//        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[habitListArray objectAtIndex:i]];
//        if ([[[dict objectForKey:@"NewAction"]objectForKey:@"PushNotification"] boolValue]) {
//            NSMutableDictionary *extraDict = [NSMutableDictionary new];
//            extraDict se
//            [SetReminderViewController setOldLocalNotificationFromDictionary:[dict mutableCopy] ExtraData:[dict mutableCopy] FromController:(NSString *)@"HabitList" Title:[dict objectForKey:@"Name"] Type:@"HabitList" Id:[[dict objectForKey:@"HabitId"] intValue]];
//        }
//    }
//}
-(void)isMoveToTodayHabit{
    if (![self haveToPushViewController:(UIViewController *)[HabitHackerFirstViewController class] parent:self]) {
        return;
    }
    
//    BOOL isControllerHave = false;
//    NSArray *arr =[self.navigationController viewControllers];
    HabitHackerFirstViewController *controller  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HabitHackerFirstView"];
    controller.isFromHabit = true;
    [self.navigationController pushViewController:controller animated:NO];

//    for (int i = 0 ; i<arr.count; i++) {
//        if ([arr[i] isKindOfClass:[HabitHackerFirstViewController class]]) {
//            isControllerHave =  true;
//            [self.navigationController popToViewController:arr[i] animated:NO];
//        }
//    }
//    if (!isControllerHave) {
//        [self.navigationController pushViewController:controller animated:NO];
//    }
    
}

-(BOOL)haveToPushViewController:(UIViewController *)myController parent:(UIViewController *)parent{
    BOOL push = true;
    NSArray *controllers = parent.navigationController.viewControllers;
    NSMutableArray *tempControllers = [NSMutableArray new];
    NSMutableArray *uniqueController = [NSMutableArray new];
    for (UIViewController *controller in [controllers reverseObjectEnumerator]) {
        NSString *stringVC = NSStringFromClass([controller class]);
        if (![tempControllers containsObject:stringVC]) {
            [tempControllers addObject:stringVC];
            [uniqueController addObject:controller];
        }
    }
    controllers = [[uniqueController reverseObjectEnumerator] allObjects];
    parent.navigationController.viewControllers = controllers;
    for (UIViewController *controller in controllers) {
        if ([controller isKindOfClass:[myController class]]) {
            push = false;
            NSArray *poppedViewController = [parent.navigationController popToViewController:controller animated:YES];
            NSMutableArray *customNav = [controller.navigationController.viewControllers mutableCopy];
//            [customNav addObjectsFromArray:poppedViewController];
            for (UIViewController *view in poppedViewController) {
                [customNav insertObject:view atIndex:(customNav.count - 1)];
            }
            controller.navigationController.viewControllers = customNav;
            break;
        }
    }
    return push;
}
#pragma mark - End
    
#pragma mark - IBAction
-(IBAction)todaysHabitsListButtonPressed:(id)sender{
    HabitHackerFirstViewController *controller  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HabitHackerFirstView"];
//    controller.isFromHabit = true;
    [self.navigationController pushViewController:controller animated:NO];
}
-(IBAction)checkuncheckButtonPressed:(UIButton*)sender{
    [self clearShowAllHabitsView];
    if (sender.selected) {
        sender.selected = false;
    }else{
        sender.selected = true;
    }
    NSMutableArray *arr = [NSMutableArray new];
    for(UIButton *button in checkUncheckButton){
        if (button.selected == true) {
            [arr addObject:[@""  stringByAppendingFormat:@"%ld", (long)button.tag]];
            filterTagArr = [arr mutableCopy];
        }else{
            [arr removeObject:[@""  stringByAppendingFormat:@"%ld", (long)button.tag]];
            filterTagArr = [arr mutableCopy];
        }
    }
}
-(IBAction)reorderSaveButtonPressed:(id)sender{
    NSArray *array = [habitListArray valueForKey:@"HabitId"];
    [Utility stopFlashingbuttonForManual:saveButton];
     habitTable.editing = false;
        self->saveButton.hidden = true;
        if (![Utility isEmptyCheck:array]) {
        [self webSerViceCall_UpdateHabitSwapManualOrder:array];
    }
}
-(IBAction)addhabitPressed:(id)sender{
    infoview.hidden = true;
    [defaults setObject:[NSNumber numberWithBool:true] forKey:@"isFirstTimeHabit"];

    HabitHackerDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitHackerDetailsView"];
    controller.hackerdelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)filterButtonPressed:(id)sender{
    addButtonShowView.hidden = true;
    habitFilterview.hidden = false;
}
-(IBAction)cancelFilterPressed:(id)sender{
    if (!(habitListArray.count>0)) {
           addButtonShowView.hidden = false;
           habitTable.hidden = true;
       }else{
           addButtonShowView.hidden = true;
           habitTable.hidden = false;
       }
     habitFilterview.hidden = true;
}
-(IBAction)infoCrossPressed:(id)sender{
    [defaults setObject:[NSNumber numberWithBool:true] forKey:@"isFirstTimeHabit"];

    if (!(habitListArray.count>0)) {
        addButtonShowView.hidden = false;
        habitTable.hidden = true;
    }else{
        addButtonShowView.hidden = true;
        habitTable.hidden = false;
    }
    infoview.hidden = true;
    habitmainView.hidden = false;

}
-(IBAction)infoButtonPressed:(id)sender{
    infoview.hidden = false;
    addButtonShowView.hidden =true;
    habitmainView.hidden = true;
}
-(IBAction)showResult:(id)sender{
    NSMutableArray *arr = [NSMutableArray new] ;
    
    if (![Utility isEmptyCheck:habitListArray] && habitListArray.count>0) {
        [habitListArray removeAllObjects];
    }
   
    if (![Utility isEmptyCheck:habitMainArray]) {
        arr = [filterTagArr mutableCopy];
        if (arr.count==3) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Status == %d)",Active];
            NSArray *filterArr = [habitMainArray filteredArrayUsingPredicate:predicate];
            
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(Status == %d)",Snooze];
            NSArray *filterArr1 = [habitMainArray filteredArrayUsingPredicate:predicate1];
            
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(Status == %d)",Completed];
            NSArray *filterArr2= [habitMainArray filteredArrayUsingPredicate:predicate2];
                      
            if (![Utility isEmptyCheck:habitListArray] && habitListArray.count>0) {
                [habitListArray removeAllObjects];
            }
            [habitListArray addObjectsFromArray:filterArr];
            [habitListArray addObjectsFromArray:filterArr1];
            [habitListArray addObjectsFromArray:filterArr2];
            settingsButton.selected=true;
        }else if (arr.count == 2){
            NSPredicate *predicate;
            NSArray *filterArr;
            NSArray *filterArr1;
                NSString *str  = arr[0];
                if ([str isEqualToString:@"1"]) {
                    predicate = [NSPredicate predicateWithFormat:@"(Status == %d)",Active];
                }else if ([str isEqualToString:@"2"]){
                    predicate = [NSPredicate predicateWithFormat:@"(Status == %d)",Snooze];
                }else{
                    predicate = [NSPredicate predicateWithFormat:@"(Status == %d)",Completed];
                }
                filterArr= [habitMainArray filteredArrayUsingPredicate:predicate];
       
                NSPredicate *predicate1;
                NSString *str1  = arr[1];
                if ([str1 isEqualToString:@"1"]) {
                   predicate1 = [NSPredicate predicateWithFormat:@"(Status == %d)",Active];
                }else if ([str1 isEqualToString:@"2"]){
                   predicate1 = [NSPredicate predicateWithFormat:@"(Status == %d)",Snooze];
                }else{
                   predicate1 = [NSPredicate predicateWithFormat:@"(Status == %d)",Completed];
                }
                filterArr1= [habitMainArray filteredArrayUsingPredicate:predicate1];
            
                if (![Utility isEmptyCheck:habitListArray] && habitListArray.count>0) {
                    [habitListArray removeAllObjects];
                }
                [habitListArray addObjectsFromArray:filterArr];
                [habitListArray addObjectsFromArray:filterArr1];
            settingsButton.selected=true;
        }else if(arr.count == 1){
            NSPredicate *predicate;
            NSArray *filterArr;
            NSString *str  = arr[0];
             if ([str isEqualToString:@"1"]) {
                  predicate = [NSPredicate predicateWithFormat:@"(Status == %d)",Active];
              }else if ([str isEqualToString:@"2"]){
                  predicate = [NSPredicate predicateWithFormat:@"(Status == %d)",Snooze];
              }else{
                  predicate = [NSPredicate predicateWithFormat:@"(Status == %d)",Completed];
             }
            if (![Utility isEmptyCheck:habitListArray] && habitListArray.count>0) {
                [habitListArray removeAllObjects];
            }
            filterArr = [habitMainArray filteredArrayUsingPredicate:predicate];
            [habitListArray addObjectsFromArray:filterArr];
            settingsButton.selected=true;

        }else{
            if (![Utility isEmptyCheck:habitListArray] && habitListArray.count>0) {
                   [habitListArray removeAllObjects];
               }
                habitListArray = [habitMainArray mutableCopy];
                
            UIButton *btn = viewTickButton[0];
            if ((![Utility isEmptyCheck:[defaults objectForKey:@"habitViewStatus"]] && !(btn.selected == true)) ||(highestToLowestButton.selected || manualButton.selected)) {
                settingsButton.selected = true;
            }else{
                settingsButton.selected = false;
            }
           
        }
        habitFilterview.hidden = true;
        [habitTable reloadData];
        if(![Utility isEmptyCheck:filterTagArr]){
            [defaults setObject:filterTagArr forKey:@"habitListFilterStatus"];
        }else{
            [defaults removeObjectForKey:@"habitListFilterStatus"];
        }
    }
}
-(IBAction)tickuntickPressed:(UIButton*)sender{
    [self clearShowAllHabitsView];
    if (![Utility isEmptyCheck:[habitListArray objectAtIndex:sender.tag]]) {
        if (![Utility isEmptyCheck:[[habitListArray objectAtIndex:sender.tag]objectForKey:@"NewAction"]]) {
            NSDictionary *newActionDict = [[habitListArray objectAtIndex:sender.tag]objectForKey:@"NewAction"];
            if (![Utility isEmptyCheck:[newActionDict objectForKey:@"CurrentDayTask"]] && ![Utility isEmptyCheck:[newActionDict objectForKey:@"CurrentDayTask2"]]) {
                if (twiceDailyCount == 1) {
                    twiceDailyCount = +1;
                    [self webSerViceCall_UpdateTaskStatus:[newActionDict objectForKey:@"CurrentDayTask"] with:sender];
                }else{
                    [self webSerViceCall_UpdateTaskStatus:[newActionDict objectForKey:@"CurrentDayTask2"] with:sender];

                }
                
            }else if(![Utility isEmptyCheck:[newActionDict objectForKey:@"CurrentDayTask"]] && [Utility isEmptyCheck:[newActionDict objectForKey:@"CurrentDayTask2"]]){
                [self webSerViceCall_UpdateTaskStatus:[newActionDict objectForKey:@"CurrentDayTask"] with:sender];
            }
        }
    }
}
-(IBAction)viewTickUntickPressed:(UIButton*)sender{
    for (UIButton *btn in viewTickButton) {
        if (btn.tag == sender.tag) {
            btn.selected = true;
        }else{
            btn.selected = false;
        }
    }
    NSMutableArray *arr = [NSMutableArray new];

    if (sender.selected) {
        UIButton *btn = viewTickButton[sender.tag];
        if (btn.tag == 1) { //Show all
            habitListArray = [habitMainArray mutableCopy];
            isShowAllHabits = true;
            [arr addObject:[@""  stringByAppendingFormat:@"%ld", (long)btn.tag]];
            [habitTable reloadData];
        }else{
            [arr addObject:[@""  stringByAppendingFormat:@"%ld", (long)btn.tag]];
            isShowAllHabits = false;
            [habitTable reloadData];
        }
        filterViewTagArray = [arr mutableCopy];
        [defaults setObject:filterViewTagArray forKey:@"habitViewStatus"];
    }
    settingsButton.selected=true;
    habitFilterview.hidden = true;
}
-(IBAction)sortTickUntickButtonsPressed:(UIButton*)sender{
    [self clearShowAllHabitsView];
    if (sender==manualButton) {
        highestToLowestButton.selected=false;
        sender.selected = true;
        habitFilterview.hidden = true;
        saveButton.hidden = false;
        percentageShowLabelButton.hidden = true;
        [Utility startFlashingbuttonForManualSort:saveButton];
        [habitTable setEditing:true];
        [habitTable reloadData];
    }else if (sender==highestToLowestButton){
        manualButton.selected=false;
        sender.selected = true;
        percentageShowLabelButton.hidden = false;
        habitFilterview.hidden = true;
        saveButton.hidden = true;
        [habitTable setEditing:false];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"NewAction.OverallPerformance" ascending:NO];
        NSArray *sorted = [habitListArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
        habitListArray = [sorted mutableCopy];
        [habitTable reloadData];
    }
    settingsButton.selected=true;
    [habitTable setContentOffset:CGPointZero animated:YES];
}

-(IBAction)clearAll:(UIButton*)sender{
    
    if(![Utility isEmptyCheck:filterTagArr]){
       [defaults removeObjectForKey:@"habitListFilterStatus"];
    }
    if(![Utility isEmptyCheck:filterViewTagArray]){
        [defaults removeObjectForKey:@"habitViewStatus"];

    }
    for(UIButton *button in checkUncheckButton){
        button.selected=false;
    }
    
    showAllHabitListButton.selected=false;
    
    for(UIButton *button in sortButtonCollection){
        button.selected=false;
    }
    
    if (![Utility isEmptyCheck:habitListArray] && habitListArray.count>0) {
        [habitListArray removeAllObjects];
    }
    for (UIButton *btn in viewTickButton) {
         if (btn.tag == 0) {
                   btn.selected = true;
         }else{
                   btn.selected = false;
               }
           }
    isShowAllHabits = false;
    settingsButton.selected=false;
    manualButton.selected=false;
    highestToLowestButton.selected = false;
    [habitTable setEditing:false];
    saveButton.hidden = true;
    percentageShowLabelButton.hidden = false;
    habitListArray=[habitMainArray mutableCopy];
    habitFilterview.hidden = true;
    [habitTable reloadData];
}

-(IBAction)breakTickuntickPressed:(UIButton*)sender{
    [self clearShowAllHabitsView];
    if (![Utility isEmptyCheck:[habitListArray objectAtIndex:sender.tag]]) {
        if (![Utility isEmptyCheck:[[habitListArray objectAtIndex:sender.tag]objectForKey:@"SwapAction"]]) {
            NSDictionary *newSwapDict = [[habitListArray objectAtIndex:sender.tag]objectForKey:@"SwapAction"];
            if (![Utility isEmptyCheck:[newSwapDict objectForKey:@"CurrentDayTask"]] && ![Utility isEmptyCheck:[newSwapDict objectForKey:@"CurrentDayTask2"]]) {
                if (twiceDailyCountForBreak == 1) {
                    twiceDailyCountForBreak = +1;
                    [self webSerViceCall_UpdateTaskStatus:[newSwapDict objectForKey:@"CurrentDayTask"] with:sender];
                }else{
                    [self webSerViceCall_UpdateTaskStatus:[newSwapDict objectForKey:@"CurrentDayTask2"] with:sender];

                }
                
            }else if(![Utility isEmptyCheck:[newSwapDict objectForKey:@"CurrentDayTask"]] && [Utility isEmptyCheck:[newSwapDict objectForKey:@"CurrentDayTask2"]]){
                [self webSerViceCall_UpdateTaskStatus:[newSwapDict objectForKey:@"CurrentDayTask"] with:sender];
            }
        }
    }
}

-(IBAction)habitListButtonPressed:(id)sender{
    [self webcellCall_GetUserHabitList];
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
    habitmainView.hidden = false;
    if ((habitListArray.count>0)) {
        addButtonShowView.hidden = true;
    }else{
        addButtonShowView.hidden = false;
    }
    PrivacyPolicyAndTermsServiceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PrivacyPolicyAndTermsService"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.url=[NSURL URLWithString:SHOWME_HABIT_URL];
    controller.isFromCourse = NO;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)reminderButtonPressed:(UIButton*)sender{
    //   NSMutableDictionary *habitDefaultReminderSet = [[NSMutableDictionary alloc]init];
    //    habitDefaultReminderSet = [habitListArray[sender.tag]mutableCopy];
    //
    //    NSMutableDictionary *habitDict = [[NSMutableDictionary alloc]init];
    //    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    //    habitDict = [[habitDefaultReminderSet objectForKey:@"NewAction"]mutableCopy];
    //    [habitDict setObject:[NSNumber numberWithBool:NO] forKey:@"Email"];
    //    [habitDict setObject:[NSNumber numberWithBool:NO] forKey:@"PushNotification"];
    //    [dict setObject:habitDict forKey:@"NewAction"];
    //
    //    [habitDefaultReminderSet removeObjectForKey:@"NewAction"];
    //    [habitDefaultReminderSet addEntriesFromDictionary:dict];
    //    [self addUpdateHabitSwap_WebServiceCall:habitDefaultReminderSet];
        
        
        NSDictionary *habitDict = habitListArray[sender.tag];
        if ([Utility isEmptyCheck:habitDict]) {
            return;
        }
         HabitHackerDetailNewViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitHackerDetailNewView"];
         controller.habitId = [habitDict valueForKey:@"HabitId"];
         controller.habitDetailDelegate=self;
         controller.isEditMode = true;
         controller.habitDictFromStat= habitDict;
         controller.isFromHabitList = true;
         controller.isFromNotification = true;
         [self.navigationController pushViewController:controller animated:NO];
        
        
        
        
        

    //    SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SetReminder"];
    //    if (![Utility isEmptyCheck:habitListArray[sender.tag]] && ![Utility isEmptyCheck:[[habitListArray[sender.tag]objectForKey:@"NewAction"]objectForKey:@"FrequencyId"]]) {
    //        controller.defaultSettingsDict = [habitListArray[sender.tag]objectForKey:@"NewAction"];
    //    }
    //    NSLog(@"%@",habitListArray[sender.tag]);
    //    controller.view.backgroundColor = [UIColor clearColor];
    //    controller.reminderDelegate = self;
    //    controller.modalPresentationStyle = UIModalPresentationCustom;
    //    [self presentViewController:controller animated:NO completion:nil];
    }
-(IBAction)printButtonPressed:(id)sender{
    [self webServicecallForSearchAndEmailHabitListAPI];
}
-(IBAction)editDelCrossPressed:(id)sender{
    editDelView.hidden = true;
}
-(IBAction)editPressed:(UIButton*)sender{
       editDelView.hidden = true;
       if ([Utility isEmptyCheck:habitListArray[sender.tag]]) {
              return;
        }
       NSDictionary *habitDict = habitListArray[sender.tag];
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
        if ([Utility isEmptyCheck:habitListArray[sender.tag]]) {
          return;
        }
        NSDictionary *habitDict = habitListArray[sender.tag];

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
-(IBAction)percentageButtonPressed:(id)sender{
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = @[@"All Time",@"This year",@"This Quarter",@"This Month"];
        if ([Utility isEmptyCheck:[defaults objectForKey:@"defaultStatesViewFromList"]]) {
            controller.selectedIndex = 0;
        }else{
            controller.selectedIndex = [[defaults objectForKey:@"defaultStatesViewFromList"]intValue];

        }
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
}

-(IBAction)weeklyOverviewValueChanged:(UIButton *)sender{
   [self->weeklyOverviewButton setSelected:!self->weeklyOverviewButton.isSelected];
   [self webcellCall_UpdateWeeklyOverview:sender.isSelected];
}
- (IBAction)autoCompleteValueChanged:(UIButton *)sender {
    [self->autoCompleteHabitButton setSelected:!self->autoCompleteHabitButton.isSelected];
    [self updateAutoCompleteHabitFlag_ApiCall:sender.isSelected];
}
-(IBAction)showALLHabitButtonPressed:(UIButton*)sender {
    [self clearShowAllHabitsView];
    if (sender.selected) {
        sender.selected = false;
//        filterTagArr = [habitListArray mutableCopy];
    }else{
        sender.selected = true;
//        filterTagArr = [ActivehabitArray mutableCopy];
    }
//    NSMutableArray *arr = [NSMutableArray new];
//    
//        if (sender.selected == true) {
//            [arr addObject:[@""  stringByAppendingFormat:@"%ld", (long)sender.tag]];
//            filterTagArr = [arr mutableCopy];
//        }else{
//            [arr removeObject:[@""  stringByAppendingFormat:@"%ld", (long)sender.tag]];
//            filterTagArr = [arr mutableCopy];
//        
//    }
}


#pragma mark - Table View Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(showAllHabitListButton.isSelected == true){
    if (habitListArray.count>0) {
        habitTable.hidden = false;
        addButtonShowView.hidden = true;
            return habitListArray.count;
    }else{
        habitTable.hidden = true;
        addButtonShowView.hidden = false;
    }
    }else{
        if(ActiveHabitArray.count>0){
            habitTable.hidden = false;
            addButtonShowView.hidden = true;
            return ActiveHabitArray.count;
        }else{
            habitTable.hidden = true;
            addButtonShowView.hidden = false;
        }
        
    }
    return 0;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
       saveButton.hidden = false;
    //    [habitListArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        
        NSMutableOrderedSet *orderedSet=[NSMutableOrderedSet orderedSetWithArray:habitListArray];
        NSInteger fromIndex = sourceIndexPath.row;
        NSInteger toIndex = destinationIndexPath.row;
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndex:fromIndex];
        [orderedSet moveObjectsAtIndexes:indexes toIndex:toIndex];
        habitListArray=[[NSMutableArray arrayWithArray:[orderedSet array]] mutableCopy];
        
        [Utility startFlashingbuttonForManualSort:saveButton];
        [habitTable reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell = (TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    if (cell==nil) {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
    }
    NSDictionary *dict;
    if(showAllHabitListButton.isSelected == true){
    dict = [habitListArray objectAtIndex:indexPath.row];
    }else{
    dict = [ActiveHabitArray objectAtIndex:indexPath.row];
    }
    if (isShowAllHabits) {
        cell.habitBreakview.hidden = false;
    }else{
        cell.habitBreakview.hidden = true;
    }

    if (![Utility isEmptyCheck:[dict objectForKey:@"HabitName"]]) {
//        if (indexPath.row%2 == 0) {
//            cell.habitNameLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:19];
//        }else{
//            cell.habitNameLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:19];
//        }
        cell.habitNameLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:19];
        cell.habitNameLabel.text = [dict objectForKey:@"HabitName"];
    }
    cell.tickuntickButton.tag = indexPath.row;
    cell.breaktickuntickButton.tag = indexPath.row;
    cell.reminderButton.tag = indexPath.row;
    
    if (![Utility isEmptyCheck:[dict objectForKey:@"NewAction"]]) {
        NSDictionary *newDict = [dict objectForKey:@"NewAction"];
        if (percentageShowLabelButton.hidden) {
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
        if(![Utility isEmptyCheck:[newDict objectForKey:@"OverallPerformance"]]){
            
            //[NSString stringWithFormat:@"%.1f%%", [[newDict objectForKey:@"OverallPerformance"]floatValue] *100]
            cell.percentagelabel.text = [NSString stringWithFormat:@"%.0f%%", [[newDict objectForKey:@"OverallPerformance"]floatValue]];//*100
        }else{
            cell.percentagelabel.text = @"";
        }

    if ((![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask"]]) && ![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask2"]]) {
        cell.tickuntickButton.userInteractionEnabled = true;
        cell.tickuntickButton.alpha = 1;
        NSDictionary *currentTaskDict = [newDict objectForKey:@"CurrentDayTask"];
        NSDictionary *currentTaskDict1 = [newDict objectForKey:@"CurrentDayTask2"];
        if (percentageShowLabelButton.hidden) {
            cell.percentagelabel.hidden= true;
            cell.tickuntickButton.userInteractionEnabled = false;
        }else{
            cell.percentagelabel.hidden= false;
            cell.tickuntickButton.userInteractionEnabled = true;
        }
 
        if ([[currentTaskDict objectForKey:@"IsDone"]boolValue] && [[currentTaskDict1 objectForKey:@"IsDone"]boolValue]) {
            [cell.tickuntickButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
        }else if([[currentTaskDict objectForKey:@"IsDone"]boolValue] || [[currentTaskDict1 objectForKey:@"IsDone"]boolValue]){
            [cell.tickuntickButton setImage:[UIImage imageNamed:@"half_circle.png"] forState:UIControlStateNormal];
        }else{
            [cell.tickuntickButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
        }
    } else if ((![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask"]])) {
         cell.tickuntickButton.userInteractionEnabled = true;
         cell.tickuntickButton.alpha = 1;
        NSDictionary *currentDayTask = [newDict objectForKey:@"CurrentDayTask"];
        
        if (percentageShowLabelButton.hidden) {
            cell.percentagelabel.hidden= true;
            cell.tickuntickButton.userInteractionEnabled = false;
        }else{
            cell.percentagelabel.hidden= false;
            cell.tickuntickButton.userInteractionEnabled = true;
        }
        if ([[currentDayTask objectForKey:@"IsDone"]boolValue]) {
            [cell.tickuntickButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
        }else{
            [cell.tickuntickButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
        }
    }else if(![Utility isEmptyCheck:[newDict objectForKey:@"CurrentDayTask2"]]){
        cell.tickuntickButton.userInteractionEnabled = true;
        cell.tickuntickButton.alpha = 1;
        NSDictionary *currentDayTask = [newDict objectForKey:@"CurrentDayTask2"];
        
        if (percentageShowLabelButton.hidden) {
            cell.percentagelabel.hidden = true;
            cell.tickuntickButton.userInteractionEnabled = false;
        }else{
            cell.percentagelabel.hidden = false;
            cell.tickuntickButton.userInteractionEnabled = true;
        }
        
        if ([[currentDayTask objectForKey:@"IsDone"]boolValue]) {
            [cell.tickuntickButton setImage:[UIImage imageNamed:@"tick_mbhq.png"] forState:UIControlStateNormal];
        }else{
            [cell.tickuntickButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
        }
    }else{
          [cell.tickuntickButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
           cell.tickuntickButton.userInteractionEnabled = false;
           cell.tickuntickButton.alpha = 0.5;
        }
    }
    if (![Utility isEmptyCheck:[dict objectForKey:@"SwapAction"]]) {
        NSDictionary *swapDict = [dict objectForKey:@"SwapAction"];
        if (![Utility isEmptyCheck:[swapDict objectForKey:@"Name"]]) {
//            if (indexPath.row%2 == 0) {
//                cell.breakNameLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:19];
//            }else{
//                cell.breakNameLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:19];
//            }
            cell.breakNameLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:17];
            cell.breakNameLabel.text =[swapDict objectForKey:@"Name"];
        }
        if (percentageShowLabelButton.hidden) {
             cell.breakpercentagelabel.hidden= true;
             cell.breakreminderButton.hidden = true;
         }else{
             cell.breakpercentagelabel.hidden= false;
             if ((![Utility isEmptyCheck:[swapDict objectForKey:@"PushNotification"]] && [[swapDict objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[swapDict objectForKey:@"Email"]] && [[swapDict objectForKey:@"Email"] boolValue])) {
                    cell.breakreminderButton.hidden = false;
                }else{
                    cell.breakreminderButton.hidden = true;
             }
         }
        
        if(![Utility isEmptyCheck:[swapDict objectForKey:@"OverallPerformance"]]){
            //[NSString stringWithFormat:@"%.01f%%", [[swapDict objectForKey:@"OverallPerformance"]floatValue]*100]
            cell.breakpercentagelabel.text = [NSString stringWithFormat:@"%.0f%%", [[swapDict objectForKey:@"OverallPerformance"]floatValue]];//*100
        }else{
            cell.breakpercentagelabel.text = @"";
        }
        if ((![Utility isEmptyCheck:[swapDict objectForKey:@"CurrentDayTask"]]) && ![Utility isEmptyCheck:[swapDict objectForKey:@"CurrentDayTask2"]]) {
               cell.breaktickuntickButton.userInteractionEnabled = true;
               cell.breaktickuntickButton.alpha = 1;
               NSDictionary *currentTaskDict = [swapDict objectForKey:@"CurrentDayTask"];
               NSDictionary *currentTaskDict1 = [swapDict objectForKey:@"CurrentDayTask2"];

            if (percentageShowLabelButton.hidden) {
                cell.breakpercentagelabel.hidden= true;
                cell.breaktickuntickButton.userInteractionEnabled = false;
            }else{
                cell.breakpercentagelabel.hidden= false;
                cell.breaktickuntickButton.userInteractionEnabled = true;
            }
               if ([[currentTaskDict objectForKey:@"IsDone"]boolValue] && [[currentTaskDict1 objectForKey:@"IsDone"]boolValue]) {
                   [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];

               }else if([[currentTaskDict objectForKey:@"IsDone"]boolValue] || [[currentTaskDict1 objectForKey:@"IsDone"]boolValue]){
                   [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"half_circle_grey.png"] forState:UIControlStateNormal];
               }else{
                   [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"unchecked_grey.png"] forState:UIControlStateNormal];
               }
           } else if ((![Utility isEmptyCheck:[swapDict objectForKey:@"CurrentDayTask"]])) {
               
               cell.breaktickuntickButton.userInteractionEnabled = true;
               cell.breaktickuntickButton.alpha = 1;
               NSDictionary *currentDayTask = [swapDict objectForKey:@"CurrentDayTask"];
               if (percentageShowLabelButton.hidden) {
                  cell.breakpercentagelabel.hidden= true;
                  cell.breaktickuntickButton.userInteractionEnabled = false;
               }else{
                  cell.breakpercentagelabel.hidden= false;
                  cell.breaktickuntickButton.userInteractionEnabled = true;
               }
               if ([[currentDayTask objectForKey:@"IsDone"]boolValue]) {
                   [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];
               }else{
                   [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"unchecked_grey.png"] forState:UIControlStateNormal];
               }
           }else if(![Utility isEmptyCheck:[swapDict objectForKey:@"CurrentDayTask2"]]){
               cell.breaktickuntickButton.userInteractionEnabled = true;
               cell.breaktickuntickButton.alpha = 1;
               NSDictionary *currentDayTask = [swapDict objectForKey:@"CurrentDayTask2"];
               if (percentageShowLabelButton.hidden) {
                   cell.breakpercentagelabel.hidden= true;
                   cell.breaktickuntickButton.userInteractionEnabled = false;
               }else{
                   cell.breakpercentagelabel.hidden= false;
                   cell.breaktickuntickButton.userInteractionEnabled = true;
               }
               if ([[currentDayTask objectForKey:@"IsDone"]boolValue]) {
                   [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];
               }else{
                   [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"unchecked_grey.png"] forState:UIControlStateNormal];
               }
           }else{
               [cell.breaktickuntickButton setImage:[UIImage imageNamed:@"unchecked_grey.png"] forState:UIControlStateNormal];
                cell.breaktickuntickButton.userInteractionEnabled = false;
                cell.breaktickuntickButton.alpha = 0.5;
           }
        
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HabitStatsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitStatsView"];
    controller.habitDict = [habitListArray objectAtIndex:indexPath.row];
    controller.isCreateOrTick = tickUntickBool;
    controller.isFromHabitList = true;
    controller.habitListArray = habitListArray;
    NSLog(@"habitListArray===>%@",habitListArray);
    NSLog(@"");
    [self.navigationController pushViewController:controller animated:YES];
    
}
#pragma mark - Hacker Delegate
-(void)reloadData{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];
    isChanged = true;
}
#pragma mark - End

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
    [self webcellCall_GetUserHabitList];
}
-(void)setHAbitDetailsDictionary:(NSDictionary *)habitDictionary
{
    habitDetailsDictionary = habitDictionary;
}


#pragma mark - PopoverViewDelegate
- (void) tagSelected:(int)index{
    [defaults setObject:[NSNumber numberWithInt:index] forKey:@"defaultStatesViewFromList"];
    [self webcellCall_UpdateHabitStatsPreference];
}
@end
