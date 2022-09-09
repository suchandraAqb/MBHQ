//
//  FooterViewController.m
//  Ashy Bines Super Circuit
//
//  Created by AQB SOLUTIONS on 05/09/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "FooterViewController.h"
#import "AppDelegate.h"
#import "NavigationViewController.h"
#import "HomePageViewController.h"
#import "TrainHomeViewController.h"
#import "NourishViewController.h"
#import "ConnectViewController.h"
#import "LearnHomeViewController.h"
#import "ExerciseVideoViewController.h"
#import "MenuSettingsViewController.h"
#import "ContentManagementViewController.h"
#import "MyProgramsViewController.h"
#import "HelpViewController.h"
#import "MasterMenuViewController.h"
#import "DietaryPreferenceViewController.h"
#import "MealFrequencyViewController.h"
#import "MealPlanViewController.h"
#import "MealVarietyViewController.h"
#import "WaterTrackerViewController.h"
#import "WaterTrackerDetailsViewController.h"
#import "GratitudeListViewController.h"
#import "AchievementsDateViewController.h"
#import "BucketListNewAddEditViewController.h"
#import "HabitHackerListViewController.h"
#import "HabitHackerDetailsViewController.h"
#import "HabitStatsViewController.h"
#import "HabitHackerDetailNewViewController.h"
#import "PrivacyPolicyAndTermsServiceViewController.h"
#import "AccountabilityBuddyHomeViewController.h"
#import "HabitHackerFirstViewController.h"
#import "CourseDetailsEntryViewController.h"
#import <IntentsUI/IntentsUI.h>
#import <Intents/Intents.h>
#import "NonSubscribedAlertViewController.h"
#import "FBForumViewController.h"

@interface FooterViewController () <INUIAddVoiceShortcutViewControllerDelegate>{
    IBOutlet UIView *mainView;
    IBOutlet UIView *settingsView;
    
    IBOutlet UIButton *trainButton;
    IBOutlet UIButton *nourishButton;
    IBOutlet UIButton *learnButton;
    
    IBOutlet UIButton *homeButton;
    IBOutlet UIButton *todayButton;
    IBOutlet UIButton *featuresButton;
    IBOutlet UIButton *helpButton;
    IBOutlet UIButton *menuButton;
    IBOutlet UIButton *meditationButton;
    __weak IBOutlet UIButton *completeTaskButton;
    AppDelegate *appDelegate;
    IBOutlet UIButton *offlineButton; //AY 06032018
    NSString *currentDate;
    BOOL isFirstTime;
    BOOL isStartTaskComplete;
    BOOL isStartSyncGratitude;
    BOOL isStartSyncGrowth;
    BOOL isSyncApiAlreadyCal;
}

@end

@implementation FooterViewController

#pragma mark - ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didBecomeActive:) name:@"didBecomeActive" object:nil];
   }

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    isSyncApiAlreadyCal = false;
    [self setAlert];
    [self setAppstoreReviewAlert];
    [self siriPopUpaddedOrNot];
  
    [[NSNotificationCenter defaultCenter] addObserverForName:@"didBecomeActive" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
              if(![Utility reachable]){
                  self->offlineButton.hidden = false;
                   if (![self.parentViewController isKindOfClass:[NotesViewController class]] && ![self.parentViewController isKindOfClass:[AchievementsViewController class]] && ![self.parentViewController isKindOfClass:[GratitudeListViewController class]] && ![self.parentViewController isKindOfClass:[WebinarListViewController class]] && ![self.parentViewController isKindOfClass:[WebinarSelectedViewController class]]) {
                      [self todayButtonTapped:0];
                  }
                 }else{
                     [defaults setObject:[NSNumber numberWithInt:0] forKey:@"AppreciatePosition"];
                     self->offlineButton.hidden = true;
                 }
          }];
         [[NSNotificationCenter defaultCenter] addObserverForName:@"GoToGratitude" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
             [defaults setObject:[NSNumber numberWithInt:0] forKey:@"AppreciatePosition"];
               [self featuresButtonTapped:0];
           }];
          if(![Utility reachable]){
                 offlineButton.hidden = false;
              if (![self.parentViewController isKindOfClass:[NotesViewController class]] && ![self.parentViewController isKindOfClass:[AchievementsViewController class]] && ![self.parentViewController isKindOfClass:[GratitudeListViewController class]] && ![self.parentViewController isKindOfClass:[WebinarListViewController class]] && ![self.parentViewController isKindOfClass:[WebinarSelectedViewController class]]){
                     [self todayButtonTapped:0];
                 }
             }else{
                 offlineButton.hidden = true;
             }
    
    //changeOfflineStatus
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOfflineStatus:) name:@"changeOfflineStatus" object:nil];// AY 06032018
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"kReachabilityChangedNotification" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kReachabilityChangedNotification" object:nil];
        dispatch_async(dispatch_get_main_queue(),^ {
//            [self prepareOfflineView];
        });
        
//           if([Utility reachable] ){
//               if(!self->isStartSyncGratitude){
//                    self->isStartSyncGratitude = true;
//                    [self syncOfflineGratitudeData];
//                }
//
//                if(!self->isStartSyncGrowth){
//                    self->isStartSyncGrowth = true;
//                     [self syncOfflineGrowthData];
//               }
//            }
        
    }];// AY 06032018
    
    
     if([Utility reachable]){
         if(!self->isStartSyncGratitude){
               self->isStartSyncGratitude = true;
               [self syncOfflineGratitudeData];
           }
           
           if(!self->isStartSyncGrowth){
               self->isStartSyncGrowth = true;
                [self syncOfflineGrowthData];
          }
    }
    
    
//        [self prepareOfflineView];
    
     // AY 06032018

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    mainView.hidden = NO;
    settingsView.hidden = YES;
    [self setFooterImages];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    UIViewController *controller = self.parentViewController;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [controller.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [controller.view addGestureRecognizer:swipeRight];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeOfflineStatus" object:nil];
}// AY 06032018
-(void)setFooterImages{
    NSLog(@"footer Parent%@",self.parentViewController.debugDescription);
    homeButton.selected = false;
    featuresButton.selected = false;
    todayButton.selected = false;
    helpButton .selected = false;
    menuButton.selected = false;
    meditationButton.selected=false;
    [[homeButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[featuresButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[todayButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[helpButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[menuButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    if ([self isAchieveScreen]){//Achieve
        homeButton.selected = true;
    }else if ([self isAppreciateScreen]){ //Appreciate
        featuresButton.selected = true;
    }else if ([self.parentViewController isKindOfClass:[TodayHomeViewController class]]){ //Today
        todayButton.selected = true;
    }else if ([self isCourseScreen]){//Learn
        helpButton .selected = true;
    }else if ([self isCommnumityScreen]){
        menuButton.selected = true;
    }else if ([self isMeditationScreen]){
        meditationButton.selected = true;
    }
    [self setBgColor:homeButton];
    [self setBgColor:featuresButton];
    [self setBgColor:todayButton];
    [self setBgColor:helpButton];
    [self setBgColor:menuButton];
    [self setBgColor:meditationButton];
    
}
-(void)setBgColor:(UIButton *)button{
    UIColor *clr;
    BOOL selected = button.isSelected;
    if(selected){
        clr = [UIColor whiteColor];
    } else {
        clr = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    }
    [button setBackgroundColor:clr];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End

#pragma mark - Webservice Call


-(void)syncOfflineGratitudeData{
    
    int userId = [[defaults objectForKey:@"UserID"] intValue];
    
         if([DBQuery isRowExist:@"gratitudeAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and isSync = 0",[NSNumber numberWithInt:userId]]]){
             DAOReader *dbObject = [DAOReader sharedInstance];
             if([dbObject connectionStart]){
                    
                 NSArray *arr = [dbObject selectBy:@"gratitudeAddList" withColumn:[[NSArray alloc]initWithObjects:@"id",@"UserId",@"GratitudeList",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@' and isSync = 0",[NSNumber numberWithInt:userId]]];
                 
                 if(arr.count>0){
                     NSMutableArray *gratitudeArr = [NSMutableArray new];
                     for(int i = 0; i <arr.count ;i++){
                         NSString *str = arr[i][@"GratitudeList"];
                         NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                         NSDictionary *gratitudeData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                         [gratitudeArr addObject:gratitudeData];
                     }
                     
                     if(gratitudeArr.count>0){
                         [self webserviceCall_syncGratitudeData:arr gratitudeList:gratitudeArr];
                     }else {
                         self->isStartSyncGratitude = false;
                     }
                 }else {
                     self->isStartSyncGratitude = false;
                 }
                 
                 
                [dbObject connectionEnd];
            }else {
                self->isStartSyncGratitude = false;
            }
        }else {
            self->isStartSyncGratitude = false;
        }
   
    
}// AY 02032018

-(void)syncOfflineGrowthData{
    
    int userId = [[defaults objectForKey:@"UserID"] intValue];
    
    if([DBQuery isRowExist:@"growthAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and isSync = 0",[NSNumber numberWithInt:userId]]]){
         DAOReader *dbObject = [DAOReader sharedInstance];
            if([dbObject connectionStart]){
               
                NSArray *arr = [dbObject selectBy:@"growthAddList" withColumn:[[NSArray alloc]initWithObjects:@"id",@"UserId",@"GrowthList",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@' and isSync = 0",[NSNumber numberWithInt:userId]]];
                
                if(arr.count>0){
                    NSMutableArray *growthArr = [NSMutableArray new];
                    for(int i = 0; i <arr.count ;i++){
                        NSString *str = arr[i][@"GrowthList"];
                        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *gratitudeData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        [growthArr addObject:gratitudeData];
                    }
                    
                    if(growthArr.count>0){
                        if (![defaults boolForKey:@"isSyncApiAlreadyCal"]) {
                            [self webserviceCall_syncGrowthData:arr growthList:growthArr];
                        }
                    }else{
                        self->isStartSyncGrowth = false;
                    }
                }else{
                    self->isStartSyncGrowth = false;
                }
                
                [dbObject connectionEnd];
                
                
              
           }else{
               self->isStartSyncGrowth = false;
           }
       }else{
           self->isStartSyncGrowth = false;
       }
    
    
}// AY 07032018

-(void)webserviceCall_syncGratitudeData:(NSArray *)dbArr gratitudeList:(NSArray *)gratitudeList{
    
    if (Utility.reachable) {
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:gratitudeList forKey:@"Gratitudes"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateGratitudeList" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     NSLog(@"Update Offline data Response: %@",responseString);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         
                                                                         if(![Utility isEmptyCheck:responseDict[@"Gratitudes"]]){
                                                                             [self updateOfflineGratitudeData:dbArr responseArr:responseDict[@"Gratitudes"]];
                                                                         }else{
                                                                             self->isStartSyncGratitude = false;
                                                                         }
                                                                         
                                                                     }else{
                                                                         self->isStartSyncGratitude = false;
                                                                     }
                                                                     
                                                                 }else{
                                                                     self->isStartSyncGratitude = false;
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        self->isStartSyncGratitude = false;
    }
}// AY 02032018

-(void)webserviceCall_syncGrowthData:(NSArray *)dbArr growthList:(NSArray *)growthList{
    
    if (Utility.reachable) {
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:growthList forKey:@"ReverseBuckets"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        [defaults setBool:true forKey:@"isSyncApiAlreadyCal"];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateMultiReverseBucketList" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     NSLog(@"Update Offline data Response: %@",responseString);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         [defaults setBool:false forKey:@"isSyncApiAlreadyCal"];

                                                                         if(![Utility isEmptyCheck:responseDict[@"ReverseBuckets"]]){
                                                                             [self updateOfflineGrowthData:dbArr responseArr:responseDict[@"ReverseBuckets"]];
                                                                         }else{
                                                                             self->isStartSyncGrowth = false;
                                                                         }
                                                                     }else{
                                                                         self->isStartSyncGrowth = false;
                                                                     }
                                                                     
                                                                 }else{
                                                                     self->isStartSyncGrowth = false;
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        self->isStartSyncGrowth = false;
    }
}// AY 07032018


#pragma mark - End

#pragma mark - IBAction
-(IBAction)siriButtonPressed:(id)sender{
   NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:@"com.mindbodyhq.admin.mbHQ"];
       activity.title = @"mbHQ";
       activity.userInfo = @{
           @"text": @"ada"
           
       };
    [activity setEligibleForSearch:YES];
    if (@available(iOS 12.0, *)) {
        [activity setEligibleForPrediction:YES];
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 12.0, *)) {
        activity.persistentIdentifier = @"com.mindbodyhq.admin.mbHQ";
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 12.0, *)) {
        activity.suggestedInvocationPhrase = @"hey siri, today im grateful for";
    } else {
        // Fallback on earlier versions
    }
    self.view.userActivity = activity;
    [activity becomeCurrent];
      
      if (@available(iOS 12.0, *)) {
          INShortcut *shortCut = [[INShortcut alloc] initWithUserActivity:activity];
          INUIAddVoiceShortcutViewController *addSiri = [[INUIAddVoiceShortcutViewController alloc] initWithShortcut:shortCut];
          addSiri.delegate = self;
          addSiri.modalPresentationStyle = UIModalPresentationFormSheet;
          [self presentViewController:addSiri animated:YES completion: nil];

      }else {
      // Fallback on earlier versions
      }
}

- (IBAction)offlineButtonPressed:(UIButton *)sender {//Appreciate
    dispatch_async(dispatch_get_main_queue(),^ {
        if ([self.parentViewController isKindOfClass:[WebinarListViewController class]] || [self.parentViewController isKindOfClass:[WebinarSelectedViewController class]]) {
            return;
        }
        [defaults setObject:[NSNumber numberWithInt:2] forKey:@"AppreciatePosition"];
        if (![Utility isEmptyCheck:[defaults objectForKey:@"AppreciatePosition"]]) {
            SectionTabViewController *controller = [[SectionTabViewController alloc]init];
            if(!self.navigationController){
                [controller tabFooterNavigation:self.parentViewController section:@"Appreciate" frmMenu:YES];
            }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
                [controller tabFooterNavigation:self.parentViewController section:@"Appreciate" frmMenu:YES];
            }else{
                [controller tabFooterNavigation:self.parentViewController section:@"Appreciate" frmMenu:NO];
            }
            return;
        }
//        NSString *identifier = @"";
//        if([Utility isSquadFreeUser]){
//            [Utility showAlertAfterSevenDayTrail:self.parentViewController];
//            return;
//
//        }else{
//            if ([self.parentViewController isKindOfClass:[GratitudeViewController class]]){
//                return;
//            }
//            if (![defaults boolForKey:@"isFirstAppreciate"]) {
//                [defaults setBool:YES forKey:@"isFirstAppreciate"];
//                identifier = @"AfterTrial";
//            } else {
//                identifier = @"GratitudeListView";
//            }
//        }
//        NSLog(@"Self Controllers%@", self.navigationController.viewControllers.debugDescription);
//
//            if(!self.navigationController){
//                [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":identifier}];
//
//            }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
//
//                [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":identifier}];
//
//            }else{
//                [CustomNavigation startNavigation:self.parentViewController fromMenu:NO navDict:@{@"Identifier":identifier}];
//            }
//
//
    });
}

-(IBAction)homeButtonTapped:(id)sender{//nourish custom page
    dispatch_async(dispatch_get_main_queue(),^ {
        UIButton *btn = (UIButton *)sender;
        if (btn.isSelected) {
            return;
        }
//        if ([Utility checkForFirstDailyWorkout:self.parentViewController]) {
//            return;
//        }
//        if ([self isSettingsPageCheck]) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"NutritionUpdateFromFooter" object:self];
//        }
        
        
        
        if ([Utility isEmptyCheck:[defaults objectForKey:@"AchievePosition"]]) {
            [defaults setObject:[NSNumber numberWithInt:0] forKey:@"AchievePosition"];
        }
       if ([Utility isOnlyProgramMember]) {
            [Utility showNonSubscribedAlert:self.parentViewController sectionName:@"Habit"];
            return;
        }
        if (![Utility isEmptyCheck:[defaults objectForKey:@"AchievePosition"]]) {
            SectionTabViewController *controller = [[SectionTabViewController alloc]init];
            if(!self.navigationController){
                [controller tabFooterNavigation:self.parentViewController section:@"Achieve" frmMenu:YES];
            }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
                [controller tabFooterNavigation:self.parentViewController section:@"Achieve" frmMenu:YES];
            }else{
                [controller tabFooterNavigation:self.parentViewController section:@"Achieve" frmMenu:NO];
            }
            return;
        }
        NSDictionary *navDictionary;
        NSString *identifier;
        if([Utility isSquadFreeUser]){
            [Utility showAlertAfterSevenDayTrail:self.parentViewController];
            return;
//            [defaults setObject:[NSNumber numberWithInteger:2] forKey:@"AchievePosition"];
//            if ([self.parentViewController isKindOfClass:[RecipeListViewController class]]){
//                return;
//            }
//            identifier = @"RecipeList";
//            navDictionary = @{@"Identifier":identifier};
        }else{
            [defaults setObject:[NSNumber numberWithInteger:0] forKey:@"AchievePosition"];
            if ([self.parentViewController isKindOfClass:[VisionGoalActionViewController class]]){
                return;
            }
            if (![defaults boolForKey:@"isFirstAchieve"]) {
                [defaults setBool:YES forKey:@"isFirstAchieve"];
                identifier = @"AfterTrial";
                navDictionary = @{@"Identifier":identifier,@"isAchieve":@true};
            } else {
                identifier = @"BucketListNew";
                navDictionary = @{@"Identifier":identifier};
            }

        }
        //        identifier = @"HomePage";
        
//        if ([self isSettingsPage]) {
//            [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
//                if (shouldPop) {
//                    if(!self.navigationController){
//                        [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:navDictionary];
//
//                    }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
//
//                        [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:navDictionary];
//
//                    }else{
//                        [CustomNavigation startNavigation:self.parentViewController fromMenu:NO navDict:navDictionary];
//                    }
//                }
//            }];
//            return;
//        }else{
            if(!self.navigationController){
                [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:navDictionary];
                
            }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
                
                [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:navDictionary];
                
            }else{
                [CustomNavigation startNavigation:self.parentViewController fromMenu:NO navDict:navDictionary];
            }
//        }
    });
}

-(IBAction)featuresButtonTapped:(id)sender{//Appreciate
    dispatch_async(dispatch_get_main_queue(),^ {
        UIButton *btn = (UIButton *)sender;
        if (btn.isSelected) {
            return;
        }
//        if ([self isSettingsPageCheck]) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"ExerciseUpdateFromFooter" object:self];
//        }
        
        
        
        if ([Utility isOnlyProgramMember]) {
            [Utility showNonSubscribedAlert:self.parentViewController sectionName:@"Gratitude"];
            return;
        }
        if (![Utility isEmptyCheck:[defaults objectForKey:@"AppreciatePosition"]]) {
            SectionTabViewController *controller = [[SectionTabViewController alloc]init];
            if(!self.navigationController){
                [controller tabFooterNavigation:self.parentViewController section:@"Appreciate" frmMenu:YES];
            }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
                [controller tabFooterNavigation:self.parentViewController section:@"Appreciate" frmMenu:YES];
            }else{
                [controller tabFooterNavigation:self.parentViewController section:@"Appreciate" frmMenu:NO];
            }
            return;
        }
        NSString *identifier = @"";
        if([Utility isSquadFreeUser]){
            [Utility showAlertAfterSevenDayTrail:self.parentViewController];
            return;
//            identifier = @"ExerciseDailyList";
//            if ([self.parentViewController isKindOfClass:[ExerciseDailyListViewController class]]){
//                return;
//            }
        }else{
            if ([self.parentViewController isKindOfClass:[GratitudeViewController class]]){
                return;
            }
            if (![defaults boolForKey:@"isFirstAppreciate"]) {
                [defaults setBool:YES forKey:@"isFirstAppreciate"];
                identifier = @"AfterTrial";
            } else {
                identifier = @"GratitudeListView";
            }
        }
        NSLog(@"Self Controllers%@", self.navigationController.viewControllers.debugDescription);
        
//        if ([self isSettingsPage]) {
//            [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
//                if (shouldPop) {
//                    if(!self.navigationController){
//                        [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":identifier}];
//
//                    }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
//
//                        [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":identifier}];
//
//                    }else{
//                        [CustomNavigation startNavigation:self.parentViewController fromMenu:NO navDict:@{@"Identifier":identifier}];
//                    }
//                }
//            }];
//            return;
//        }else{
            if(!self.navigationController){
                [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":identifier}];
                
            }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
                
                [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":identifier}];
                
            }else{
                [CustomNavigation startNavigation:self.parentViewController fromMenu:NO navDict:@{@"Identifier":identifier}];
            }
//        }
        
    });
}

-(IBAction)todayButtonTapped:(id)sender{
    
    dispatch_async(dispatch_get_main_queue(),^ {
        UIButton *btn = (UIButton *)sender;
        if (btn.isSelected) {
            return;
        }
        if ([Utility checkForFirstDailyWorkout:self.parentViewController]) {
            return;
        }
        if ([self.parentViewController isKindOfClass:[TodayHomeViewController class]]){
            return;
        }
        
        NSLog(@"viewControllers%@",  self.navigationController.debugDescription);
        
        if ([self isSettingsPage]) {
            [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
                if (shouldPop) {
                    if(!self.navigationController){
                        [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":@"TodayHome"}];
                        
                    }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
                        
                        [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":@"TodayHome"}];
                        
                    }else{
                        [CustomNavigation startNavigation:self.parentViewController fromMenu:NO navDict:@{@"Identifier":@"TodayHome"}];
                    }
                }
            }];
            return;
        }else{
            if(!self.navigationController){
                [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":@"TodayHome"}];
                
            }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
                
                [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":@"TodayHome"}];
                
            }else{
                [CustomNavigation startNavigation:self.parentViewController fromMenu:NO navDict:@{@"Identifier":@"TodayHome"}];
            }
        }
    });
}

-(IBAction)helpButtonPressed:(id)sender{//Learn
    dispatch_async(dispatch_get_main_queue(),^ {
        UIButton *btn = (UIButton *)sender;
        if (btn.isSelected) {
            return;
        }
//        if ([Utility checkForFirstDailyWorkout:self.parentViewController]) {
//            return;
//        }
        
        
        
        
        if (![Utility isEmptyCheck:[defaults objectForKey:@"LearnPosition"]]) {
            SectionTabViewController *controller = [[SectionTabViewController alloc]init];
            if(!self.navigationController){
                [controller tabFooterNavigation:self.parentViewController section:@"Learn" frmMenu:YES];
            }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
                [controller tabFooterNavigation:self.parentViewController section:@"Learn" frmMenu:YES];
            }else{
                [controller tabFooterNavigation:self.parentViewController section:@"Learn" frmMenu:NO];
            }
            return;
        }
        NSString *identifier = @"CoursesList";
        if ([self.parentViewController isKindOfClass:[CoursesListViewController class]]){
            return;
        }
//
//        if ([self isSettingsPage]) {
//            [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
//                if (shouldPop) {
//                    if(!self.navigationController){
//                        [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":identifier}];
//
//                    }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
//
//                        [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":identifier}];
//
//                    }else{
//                        [CustomNavigation startNavigation:self.parentViewController fromMenu:NO navDict:@{@"Identifier":identifier}];
//                    }
//                }
//            }];
//            return;
//        }else{
            if(!self.navigationController){
                [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":identifier}];
                
            }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
                
                [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":identifier}];
                
            }else{
                [CustomNavigation startNavigation:self.parentViewController fromMenu:NO navDict:@{@"Identifier":identifier}];
            }
//        }
        
    });
}


- (IBAction)meditationButtonPressed:(id)sender {
    
    if ([Utility isOnlyProgramMember]) {
        [Utility showNonSubscribedAlert:self.parentViewController sectionName:@"Meditation"];
        return;
    }
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"RunningVideoSection"]]) {
        if ([[defaults objectForKey:@"RunningVideoSection"] isEqualToString:@"Meditation"]) {
            if (![Utility isEmptyCheck:[defaults objectForKey:@"PlayingMeditation"]]) {
                NSString *webinarstr=[defaults objectForKey:@"PlayingMeditation"];
                NSData *data = [webinarstr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                WebinarSelectedViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarSelectedView"];
                controller.webinar = [dict mutableCopy];
                [self.parentViewController.navigationController pushViewController:controller animated:NO];
            }
        }
    }else{
//        NSArray *controllers = self.parentViewController.navigationController.viewControllers;
//        for(UIViewController *controller in controllers){
//            if([controller isKindOfClass:[WebinarListViewController class]]){
//                WebinarListViewController *webinar = (WebinarListViewController *)controller;
//                webinar.isFromCourse=true;
//                [self.parentViewController.navigationController popToViewController:controller animated:NO];
//                return;
//            }
//        }
        
        if (![self haveToPushViewController:(UIViewController *)[WebinarListViewController class] parent:self.parentViewController]) {
            return;
        }
        
        WebinarListViewController *webinar = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarListView"];
        webinar.isFromCourse=true;
        [self.parentViewController.navigationController pushViewController:webinar animated:NO];
    }
    
}

-(IBAction)menuButtonTapped:(id)sender{//Learn
    dispatch_async(dispatch_get_main_queue(),^ {
        UIButton *btn = (UIButton *)sender;
        if (btn.isSelected) {
            return;
        }
        
        [defaults setObject:[NSNumber numberWithInt:0] forKey:@"CommunityPosition"];
        if (![Utility isEmptyCheck:[defaults objectForKey:@"CommunityPosition"]]) {
            SectionTabViewController *controller = [[SectionTabViewController alloc]init];
            if(!self.navigationController){
                [controller tabFooterNavigation:self.parentViewController section:@"Community" frmMenu:YES];
            }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
                [controller tabFooterNavigation:self.parentViewController section:@"Community" frmMenu:YES];
            }else{
                [controller tabFooterNavigation:self.parentViewController section:@"Community" frmMenu:NO];
            }
            return;
        }
        NSString *identifier = @"CommunityView";
        if ([self.parentViewController isKindOfClass:[CommunityViewController class]]){
            return;
        }

            if(!self.navigationController){
                [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":identifier}];
                
            }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
                
                [CustomNavigation startNavigation:self.parentViewController fromMenu:YES navDict:@{@"Identifier":identifier}];
                
            }else{
                [CustomNavigation startNavigation:self.parentViewController fromMenu:NO navDict:@{@"Identifier":identifier}];
            }
        
    });
}


//-(IBAction)homeButtonTapped:(id)sender{
//    dispatch_async(dispatch_get_main_queue(),^ {
//
//        if ([self.parentViewController isKindOfClass:[HomePageViewController class]]){
//            return;
//        }
//
//        //        int logoClickCount = [[defaults objectForKey:@"LogoClickCount"] intValue];
//        //        [defaults setObject:[NSNumber numberWithInt:logoClickCount+1] forKey:@"LogoClickCount"];
//
//        if ([self isSettingsPage]) {
//            [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
//                if (shouldPop) {
//                    if(!self.navigationController){
//                        HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
//                        NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                        self.slidingViewController.topViewController = nav;
//                        [self.slidingViewController resetTopViewAnimated:YES];
//
//                    }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
//
//                        ECSlidingViewController *con = (ECSlidingViewController *)[self.navigationController.viewControllers lastObject];
//                        NSLog(@"EC Controllers%@",  con.topViewController.debugDescription.debugDescription);
//
//                        if([con.topViewController isKindOfClass:[NavigationViewController class]]){
//                            NavigationViewController *nav = (NavigationViewController *)con.topViewController;
//
//                            HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
//                            [nav pushViewController:controller animated:YES];
//                            [self.slidingViewController resetTopViewAnimated:YES];
//
//
//                        }else{
//                            HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
//                            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                            self.slidingViewController.topViewController = nav;
//                            [self.slidingViewController resetTopViewAnimated:YES];
//                        }
//
//                    }else{
//                        HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
//                        [self.navigationController pushViewController:controller animated:YES];
//                    }
//                }
//            }];
//            return;
//        }else{
//            if(!self.navigationController){
//                HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
//                NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                self.slidingViewController.topViewController = nav;
//                [self.slidingViewController resetTopViewAnimated:YES];
//
//            }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
//
//                ECSlidingViewController *con = (ECSlidingViewController *)[self.navigationController.viewControllers lastObject];
//                NSLog(@"EC Controllers%@",  con.topViewController.debugDescription.debugDescription);
//
//                if([con.topViewController isKindOfClass:[NavigationViewController class]]){
//                    NavigationViewController *nav = (NavigationViewController *)con.topViewController;
//
//                    HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
//                    [nav pushViewController:controller animated:YES];
//                    [self.slidingViewController resetTopViewAnimated:YES];
//
//
//                }else{
//                    HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
//                    NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                    self.slidingViewController.topViewController = nav;
//                    [self.slidingViewController resetTopViewAnimated:YES];
//                }
//
//            }else{
//                HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
//                [self.navigationController pushViewController:controller animated:YES];
//            }
//        }
//
//    });
//}
//
//-(IBAction)todayButtonTapped:(id)sender{
//
//    dispatch_async(dispatch_get_main_queue(),^ {
//
//        if([Utility isSquadLiteUser]){ //Lite_chnage
//            [Utility showSubscribedAlert:self.parentViewController];
//            return;
//        }else if([Utility isSquadFreeUser]){
//            [Utility showAlertAfterSevenDayTrail:self.parentViewController];
//            return;
//        }//Lite_chnage
//
//        if ([self.parentViewController isKindOfClass:[TodayHomeViewController class]]){
//            return;
//        }
//
//
//        if(![defaults boolForKey:@"CompletedStartupChecklist"]){
//            [self incompleStartTaskAlert];
//            return;
//        }
//
//        NSLog(@"viewControllers%@",  self.navigationController.debugDescription);
//
//        if ([self isSettingsPage]) {
//            [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
//                if (shouldPop) {
//                    if(!self.navigationController){
//                        TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//                        NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                        self.slidingViewController.topViewController = nav;
//                        [self.slidingViewController resetTopViewAnimated:YES];
//
//                    }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
//
//                        ECSlidingViewController *con = (ECSlidingViewController *)[self.navigationController.viewControllers lastObject];
//                        NSLog(@"EC Controllers%@",  con.topViewController.debugDescription.debugDescription);
//
//                        if([con.topViewController isKindOfClass:[NavigationViewController class]]){
//                            NavigationViewController *nav = (NavigationViewController *)con.topViewController;
//
//                            TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//                            [nav pushViewController:controller animated:YES];
//                            [self.slidingViewController resetTopViewAnimated:YES];
//
//
//                        }else{
//                            TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//                            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                            self.slidingViewController.topViewController = nav;
//                            [self.slidingViewController resetTopViewAnimated:YES];
//                        }
//
//                    }else{
//                        TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//                        [self.navigationController pushViewController:controller animated:YES];
//                    }
//                }
//            }];
//            return;
//        }else{
//            if(!self.navigationController){
//                TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//                NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                self.slidingViewController.topViewController = nav;
//                [self.slidingViewController resetTopViewAnimated:YES];
//
//            }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
//
//                ECSlidingViewController *con = (ECSlidingViewController *)[self.navigationController.viewControllers lastObject];
//                NSLog(@"EC Controllers%@",  con.topViewController.debugDescription.debugDescription);
//
//                if([con.topViewController isKindOfClass:[NavigationViewController class]]){
//                    NavigationViewController *nav = (NavigationViewController *)con.topViewController;
//
//                    TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//                    [nav pushViewController:controller animated:YES];
//                    [self.slidingViewController resetTopViewAnimated:YES];
//
//
//                }else{
//                    TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//                    NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                    self.slidingViewController.topViewController = nav;
//                    [self.slidingViewController resetTopViewAnimated:YES];
//                }
//
//            }else{
//                TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//                [self.navigationController pushViewController:controller animated:YES];
//            }
//        }
//
//    });
//
//}
//
//-(IBAction)featuresButtonTapped:(id)sender{
//    dispatch_async(dispatch_get_main_queue(),^ {
//
//        if([Utility isSquadLiteUser]){
//            [Utility showSubscribedAlert:self.parentViewController];
//            return;
//        }else if([Utility isSquadFreeUser]){
//            [Utility showAlertAfterSevenDayTrail:self.parentViewController];
//            return;
//        }
//
//        if ([self.parentViewController isKindOfClass:[MyProgramsViewController class]]){
//            return;
//        }
//
//        if(![defaults boolForKey:@"CompletedStartupChecklist"]){
//            [self incompleStartTaskAlert];
//            return;
//        }
//
//        NSLog(@"Self Controllers%@", self.navigationController.viewControllers.debugDescription);
//
//        if ([self isSettingsPage]) {
//            [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
//                if (shouldPop) {
//                    if(!self.navigationController){
//                        MyProgramsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPrograms"];
//                        NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                        self.slidingViewController.topViewController = nav;
//                        [self.slidingViewController resetTopViewAnimated:YES];
//
//                    }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
//
//                        ECSlidingViewController *con = (ECSlidingViewController *)[self.navigationController.viewControllers lastObject];
//                        NSLog(@"EC Controllers%@",  con.topViewController.debugDescription.debugDescription);
//
//                        if([con.topViewController isKindOfClass:[NavigationViewController class]]){
//                            NavigationViewController *nav = (NavigationViewController *)con.topViewController;
//
//                            MyProgramsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPrograms"];
//                            [nav pushViewController:controller animated:YES];
//                            [self.slidingViewController resetTopViewAnimated:YES];
//                            //[self menuButtonTapped:nil];
//
//                        }else{
//                            MyProgramsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPrograms"];
//                            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                            self.slidingViewController.topViewController = nav;
//                            [self.slidingViewController resetTopViewAnimated:YES];
//                        }
//
//                    }else{
//                        MyProgramsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPrograms"];
//                        [self.navigationController pushViewController:controller animated:YES];
//                    }
//                }
//            }];
//            return;
//        }else{
//            if(!self.navigationController){
//                MyProgramsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPrograms"];
//                NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                self.slidingViewController.topViewController = nav;
//                [self.slidingViewController resetTopViewAnimated:YES];
//
//            }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
//
//                ECSlidingViewController *con = (ECSlidingViewController *)[self.navigationController.viewControllers lastObject];
//                NSLog(@"EC Controllers%@",  con.topViewController.debugDescription.debugDescription);
//
//                if([con.topViewController isKindOfClass:[NavigationViewController class]]){
//                    NavigationViewController *nav = (NavigationViewController *)con.topViewController;
//
//                    MyProgramsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPrograms"];
//                    [nav pushViewController:controller animated:YES];
//                    [self.slidingViewController resetTopViewAnimated:YES];
//                    //[self menuButtonTapped:nil];
//
//                }else{
//                    MyProgramsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPrograms"];
//                    NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                    self.slidingViewController.topViewController = nav;
//                    [self.slidingViewController resetTopViewAnimated:YES];
//                }
//
//            }else{
//                MyProgramsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPrograms"];
//                [self.navigationController pushViewController:controller animated:YES];
//            }
//        }
//
//    });
//}
//
//
//-(IBAction)helpButtonPressed:(id)sender{
//    dispatch_async(dispatch_get_main_queue(),^ {
//
//        //        if([Utility isSquadLiteUser]){
//        //            [Utility showSubscribedAlert:self.parentViewController];
//        //            return;
//        //        }else if([Utility isSquadFreeUser]){
//        //            [Utility showAlertAfterSevenDayTrail:self.parentViewController];
//        //            return;
//        //        }
//
//
//        if ([self.parentViewController isKindOfClass:[HelpViewController class]]){
//            return;
//        }
//
//        if(![defaults boolForKey:@"CompletedStartupChecklist"]){
//            [self incompleStartTaskAlert];
//            return;
//        }
//
//        if ([self isSettingsPage]) {
//            [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
//                if (shouldPop) {
//                    if(!self.navigationController){
//                        HelpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpView"];
//                        NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                        self.slidingViewController.topViewController = nav;
//                        [self.slidingViewController resetTopViewAnimated:YES];
//
//                    }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
//
//                        ECSlidingViewController *con = (ECSlidingViewController *)[self.navigationController.viewControllers lastObject];
//                        NSLog(@"EC Controllers%@",  con.topViewController.debugDescription.debugDescription);
//
//                        if([con.topViewController isKindOfClass:[NavigationViewController class]]){
//                            NavigationViewController *nav = (NavigationViewController *)con.topViewController;
//
//                            HelpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpView"];
//                            [nav pushViewController:controller animated:YES];
//                            [self.slidingViewController resetTopViewAnimated:YES];
//
//                        }else{
//                            HelpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpView"];
//                            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                            self.slidingViewController.topViewController = nav;
//                            [self.slidingViewController resetTopViewAnimated:YES];
//                        }
//
//                    }else{
//                        HelpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpView"];
//                        [self.navigationController pushViewController:controller animated:YES];
//                    }
//                }
//            }];
//            return;
//        }else{
//            if(!self.navigationController){
//                HelpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpView"];
//                NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                self.slidingViewController.topViewController = nav;
//                [self.slidingViewController resetTopViewAnimated:YES];
//
//            }else if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
//
//                ECSlidingViewController *con = (ECSlidingViewController *)[self.navigationController.viewControllers lastObject];
//                NSLog(@"EC Controllers%@",  con.topViewController.debugDescription.debugDescription);
//
//                if([con.topViewController isKindOfClass:[NavigationViewController class]]){
//                    NavigationViewController *nav = (NavigationViewController *)con.topViewController;
//
//                    HelpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpView"];
//                    [nav pushViewController:controller animated:YES];
//                    [self.slidingViewController resetTopViewAnimated:YES];
//
//                }else{
//                    HelpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpView"];
//                    NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//                    self.slidingViewController.topViewController = nav;
//                    [self.slidingViewController resetTopViewAnimated:YES];
//                }
//
//            }else{
//                HelpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpView"];
//                [self.navigationController pushViewController:controller animated:YES];
//            }
//        }
//
//    });
//}
//
//-(IBAction)menuButtonTapped:(id)sender{
//    dispatch_async(dispatch_get_main_queue(),^ {
//
//        if(![defaults boolForKey:@"CompletedStartupChecklist"]){
//            [self incompleStartTaskAlert];
//            return;
//        }
//        if ([self isSettingsPage]) {
//            [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
//                if (shouldPop) {
//                    [[NSNotificationCenter defaultCenter]postNotificationName:@"offlineModeDetails" object:nil];// AY 06032018
//
//                    [self.slidingViewController anchorTopViewToLeftAnimated:YES];
//                    [self.slidingViewController resetTopViewAnimated:YES];
//                }
//            }];
//            return;
//        }else{
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"offlineModeDetails" object:nil];// AY 06032018
//
//            [self.slidingViewController anchorTopViewToLeftAnimated:YES];
//            [self.slidingViewController resetTopViewAnimated:YES];
//        }
//    });
//}

-(IBAction)settingsButtonTapped:(id)sender {
    dispatch_async(dispatch_get_main_queue(),^ {
        if (self->mainView.isHidden) {
            self->mainView.hidden = NO;
            self->settingsView.hidden = YES;
        } else {
            self->mainView.hidden = YES;
            self->settingsView.hidden = NO;
        }
        
    });
}


#pragma mark- End
#pragma mark- LocalNotification
-(void)changeOfflineStatus:(NSNotification *)notification{
//    [self prepareOfflineView];
}// AY 06032018
#pragma mark- End

#pragma mark- Private Method
-(void)goToCommunityView{
    if (![Utility reachable]) {
        [Utility msg:@"The MindbodyHQ forum is not available in aeroplane mode. Please turn your internet back on to access the forum" title:@"Oops! " controller:self haveToPop:NO];
        return;
      }
    
    if ([Utility isOnlyProgramMember]) {
        [Utility showNonSubscribedAlert:self.parentViewController sectionName:@"Forum"];
        return;
    }
    
    if(![defaults boolForKey:@"CompletedStartupChecklist"]){
        [self incompleStartTaskAlert];
        return;
    }
    if ([Utility checkForFirstDailyWorkout:self.parentViewController]) {
        return;
    }
    UIViewController *visibleController = self.parentViewController;
    if ([visibleController isKindOfClass:[CommunityViewController class]]) {
        return;
    }
//    CommunityViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CommunityView"];
//    [self.navigationController pushViewController:controller animated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
    dispatch_async(dispatch_get_main_queue(),^ {
        NSString *urlString=@"https://www.facebook.com/groups/250625228700325";
        FBForumViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FBForum"];
        controller.urlString = urlString;
        [self.navigationController pushViewController:controller animated:YES];
    });
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

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    if ([Utility isOnlyProgramMember]) {
        return;
    }
    
    if ([Utility checkForFirstDailyWorkout:self.parentViewController]) {
        return;
    }
    if (![Utility reachable]) {
        return;
    }
    if (featuresButton.isSelected) {
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            if ([self.parentViewController isKindOfClass:[GratitudeListViewController class]]) {
                SectionTabViewController *controller = [[SectionTabViewController alloc]init];
                [controller tabSwipeNavigation:self.parentViewController section:@"Appreciate" position:1 frmMenu:NO];
            }else{
                [self meditationButtonPressed:meditationButton];
            }
        } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            if ([self.parentViewController isKindOfClass:[AchievementsViewController class]]) {
                SectionTabViewController *controller = [[SectionTabViewController alloc]init];
                [controller tabSwipeNavigation:self.parentViewController section:@"Appreciate" position:0 frmMenu:NO];
            }else{
//                [self goToCommunityView];
                [self dismissViewControllerAnimated:NO completion:nil];
                dispatch_async(dispatch_get_main_queue(),^ {
                    NSString *urlString=@"https://www.facebook.com/groups/250625228700325";
                    FBForumViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FBForum"];
                    controller.urlString = urlString;
                    [self.navigationController pushViewController:controller animated:YES];
                });
            }
        }
    }else if (meditationButton.isSelected){
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            SectionTabViewController *controller = [[SectionTabViewController alloc]init];
            [controller tabSwipeNavigation:self.parentViewController section:@"Achieve" position:0 frmMenu:NO];
//            [self homeButtonTapped:homeButton];
        } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            SectionTabViewController *controller = [[SectionTabViewController alloc]init];
            [controller tabSwipeNavigation:self.parentViewController section:@"Appreciate" position:1 frmMenu:NO];
//            [self featuresButtonTapped:featuresButton];
        }
    }else if (homeButton.isSelected){
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            if ([self.parentViewController isKindOfClass:[HabitHackerListViewController class]]) {
                SectionTabViewController *controller = [[SectionTabViewController alloc]init];
                [controller tabSwipeNavigation:self.parentViewController section:@"Achieve" position:1 frmMenu:NO];
            }else{
                SectionTabViewController *controller = [[SectionTabViewController alloc]init];
                [controller tabSwipeNavigation:self.parentViewController section:@"Learn" position:0 frmMenu:NO];
            }
//            [self helpButtonPressed:helpButton];
        } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            if ([self.parentViewController isKindOfClass:[BucketListNewViewController class]]) {
                SectionTabViewController *controller = [[SectionTabViewController alloc]init];
                [controller tabSwipeNavigation:self.parentViewController section:@"Achieve" position:0 frmMenu:NO];
            }else{
                [self meditationButtonPressed:meditationButton];
            }
//            [self meditationButtonPressed:meditationButton];
        }
    }else if (helpButton.isSelected){
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            if ([self.parentViewController isKindOfClass:[CoursesListViewController class]]) {
                SectionTabViewController *controller = [[SectionTabViewController alloc]init];
                [controller tabSwipeNavigation:self.parentViewController section:@"Learn" position:1 frmMenu:NO];
            }else{
//                [self goToCommunityView];
                [self dismissViewControllerAnimated:NO completion:nil];
                dispatch_async(dispatch_get_main_queue(),^ {
                    NSString *urlString=@"https://www.facebook.com/groups/250625228700325";
                    FBForumViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FBForum"];
                    controller.urlString = urlString;
                    [self.navigationController pushViewController:controller animated:YES];
                });
            }
        } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            if ([self.parentViewController isKindOfClass:[QuestionnaireHomeViewController class]]) {
                SectionTabViewController *controller = [[SectionTabViewController alloc]init];
                [controller tabSwipeNavigation:self.parentViewController section:@"Learn" position:0 frmMenu:NO];
            }else{
                SectionTabViewController *controller = [[SectionTabViewController alloc]init];
                [controller tabSwipeNavigation:self.parentViewController section:@"Achieve" position:1 frmMenu:NO];
            }
//            [self homeButtonTapped:homeButton];
        }
    }
}

-(void)siriPopUpaddedOrNot{
    if (@available(iOS 12.0, *)) {
        [INVoiceShortcutCenter.sharedCenter getAllVoiceShortcutsWithCompletion:^(NSArray<INVoiceShortcut *> * _Nullable voiceShortcuts, NSError * _Nullable error) {
            if (![Utility isEmptyCheck:voiceShortcuts]) {
                for (int i=0;i<voiceShortcuts.count;i++) {
                    INVoiceShortcut *shortcut = [voiceShortcuts objectAtIndex:i];
                    if (![Utility isEmptyCheck:shortcut.invocationPhrase] && [shortcut.invocationPhrase isEqualToString:@"hey siri, today im grateful for"]) {
                        [defaults setBool:true forKey:@"isSiriAdded"];
                    }
                }
            }
        } ];
    }else {
        // Fallback on earlier versions
    };
    
    if (![defaults boolForKey:@"isSiriAdded"]) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        currentDate = [dateFormat stringFromDate:[NSDate date]];
        
        if(([Utility isEmptyCheck:[defaults objectForKey:@"siriAlert"]] || ![currentDate isEqualToString:[defaults objectForKey:@"siriAlert"]])){
                 [defaults setObject:currentDate forKey:@"siriAlert"];
                 BOOL isNotificationEnable = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
                 if (isNotificationEnable) {
                    [self dismissViewControllerAnimated:NO completion:^{
                    [self siriButtonPressed:nil];
                    }];
                }
                
        }else
        {
            if (![Utility isEmptyCheck:[defaults objectForKey:@"firstLoginDate"]] && ![defaults boolForKey:@"isFirstTimeSiri"]) {
                [defaults setBool:true forKey:@"isFirstTimeSiri"];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd/MM/yyyy"];
                NSDate *firstLoginDate = [defaults objectForKey:@"firstLoginDate"];
                if ([firstLoginDate isToday]) {
                     [self siriButtonPressed:nil];
                }
            }
        }
    }
}
-(void)updateOfflineGratitudeData:(NSArray *)indexArray responseArr:(NSArray *)responseArr{
    
    for(int i=0; i<responseArr.count ; i++){
        
        NSDictionary *responseDict = responseArr[i];
        int idx = [responseDict[@"Index"] intValue];
        
        if(![Utility isEmptyCheck:responseDict[@"Gratitude"]]){
            NSDictionary *Gratitude = responseDict[@"Gratitude"];
            
            if(idx < indexArray.count){
                NSDictionary *idxObj = [indexArray objectAtIndex:idx];
                int rowId = [idxObj[@"id"] intValue];
                int gratitudeId = [Gratitude[@"Id"] intValue];
                
                NSString *detailsString = @"";
                if(![Utility isEmptyCheck:Gratitude]){
                    NSError *error;
                    NSData *offlineData = [NSJSONSerialization dataWithJSONObject:Gratitude options:NSJSONWritingPrettyPrinted  error:&error];
                    if (error) {
                        NSLog(@"Error %@",error.debugDescription);
                    }
                    detailsString = [[NSString alloc] initWithData:offlineData encoding:NSUTF8StringEncoding];
                }
                
                if(rowId>0){
                    DAOReader *dbObject = [DAOReader sharedInstance];
                    
                    if([dbObject connectionStart]){
                        NSMutableString *modifiedGratitudeDetails = [NSMutableString stringWithString:detailsString];
                        [modifiedGratitudeDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedGratitudeDetails length])];
                        //        NSString *date = [NSDate date].description;
                        
                        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"gratitudeList",@"GratitudeId",@"isSync",nil];
                        NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedGratitudeDetails,[NSNumber numberWithInt:gratitudeId],[NSNumber numberWithInt:1],nil];
                        
                        BOOL isAdd = [dbObject updateWithCondition:@"gratitudeAddList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"Id ='%d'",rowId]];
                         [dbObject connectionEnd];
                        
                        if(isAdd){
                            NSLog(@"Gratitude Data Updated with Rowid: %d and Gratitude Id:%d",rowId,gratitudeId);
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"IsGratitudeListReload" object:self userInfo:nil];
    
    isStartSyncGratitude = false;
    
}

-(void)updateOfflineGrowthData:(NSArray *)indexArray responseArr:(NSArray *)responseArr{
    
    for(int i=0; i<responseArr.count ; i++){
        
        NSDictionary *responseDict = responseArr[i];
        int idx = [responseDict[@"Index"] intValue];
        
        if(![Utility isEmptyCheck:responseDict[@"ReverseBucket"]]){
            NSDictionary *ReverseBucket = responseDict[@"ReverseBucket"];
            
            if(idx < indexArray.count){
                NSDictionary *idxObj = [indexArray objectAtIndex:idx];
                int rowId = [idxObj[@"id"] intValue];
                int growthId = [ReverseBucket[@"Id"] intValue];
                
                NSString *detailsString = @"";
                if(![Utility isEmptyCheck:ReverseBucket]){
                    NSError *error;
                    NSData *offlineData = [NSJSONSerialization dataWithJSONObject:ReverseBucket options:NSJSONWritingPrettyPrinted  error:&error];
                    if (error) {
                        NSLog(@"Error %@",error.debugDescription);
                    }
                    detailsString = [[NSString alloc] initWithData:offlineData encoding:NSUTF8StringEncoding];
                }
                
                if(rowId>0){
                    DAOReader *dbObject = [DAOReader sharedInstance];
                    
                    if([dbObject connectionStart]){
                        NSMutableString *modifiedGratitudeDetails = [NSMutableString stringWithString:detailsString];
                        [modifiedGratitudeDetails replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedGratitudeDetails length])];
                        //        NSString *date = [NSDate date].description;
                        
                        NSArray *columnArray = [[NSArray alloc]initWithObjects:@"GrowthList",@"AchivementId",@"isSync",nil];
                        NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedGratitudeDetails,[NSNumber numberWithInt:growthId],[NSNumber numberWithInt:1],nil];
                        
                        BOOL isAdd = [dbObject updateWithCondition:@"growthAddList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"Id ='%d'",rowId]];
                         [dbObject connectionEnd];
                        
                        if(isAdd){
                            NSLog(@"Growth Data Updated with Rowid: %d and Gratitude Id:%d",rowId,growthId);
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"IsAchievementRealod" object:self userInfo:nil];
    isStartSyncGrowth = false;

}

-(void)setAlert{
    
    if (![defaults boolForKey:@"isSpalshShown"]) { 
        return;
    }
    
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"InstallationDate"]]) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        NSDate *installationDate = [defaults objectForKey:@"InstallationDate"];
        NSString *installDateStr = [dateFormat stringFromDate:installationDate];
        currentDate = [dateFormat stringFromDate:[NSDate date]];
        
        if(![installDateStr isEqualToString:currentDate]){
          
            BOOL isNotificationEnable = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
            
            if(([Utility isEmptyCheck:[defaults objectForKey:@"notificationAlert"]] || ![currentDate isEqualToString:[defaults objectForKey:@"notificationAlert"]])&& !isNotificationEnable){
                 [defaults setObject:currentDate forKey:@"notificationAlert"];
                [self showAlert];
            }
        }
    }
}

-(void)setAppstoreReviewAlert{
    if (![Utility isEmptyCheck:[defaults objectForKey:@"firstLoginDate"]]) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        NSDate *firstLoginDate = [defaults objectForKey:@"firstLoginDate"];
        NSDate *firstlogin1hr = [calendar dateByAddingUnit:NSCalendarUnitMinute
                                                     value:60
                                                    toDate:firstLoginDate
                                                   options:0];
        
        NSString *firstLoginDateStr = [dateFormat stringFromDate:firstLoginDate];
        NSDate *day3 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                             value:2
                                            toDate:firstLoginDate
                                           options:0];
        
        NSString *dayThreeDateStr = [dateFormat stringFromDate:day3];
        
        NSDate *day5 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                             value:4
                                            toDate:firstLoginDate
                                           options:0];
        
        NSString *dayFiveDateStr = [dateFormat stringFromDate:day5];
        
        
        
        currentDate = [dateFormat stringFromDate:[NSDate date]];
        
        if([firstLoginDateStr isEqualToString:currentDate] && [[NSDate date] compare:firstlogin1hr] == NSOrderedDescending){
            
            if(([Utility isEmptyCheck:[defaults objectForKey:@"reviewAlert"]] || ![currentDate isEqualToString:[defaults objectForKey:@"reviewAlert"]])){
                [defaults setObject:currentDate forKey:@"reviewAlert"];
                dispatch_async(dispatch_get_main_queue(),^ {
                    [SKStoreReviewController requestReview];
                });
                
            }
        }else if([dayThreeDateStr isEqualToString:currentDate]){
            if(([Utility isEmptyCheck:[defaults objectForKey:@"reviewAlert"]] || ![currentDate isEqualToString:[defaults objectForKey:@"reviewAlert"]])){
                [defaults setObject:currentDate forKey:@"reviewAlert"];
                dispatch_async(dispatch_get_main_queue(),^ {
                    [SKStoreReviewController requestReview];
                });
            }
        }else  if([dayFiveDateStr isEqualToString:currentDate]){
            NSLog(@"CurrentDate-%@",[defaults objectForKey:@"reviewAlert"]);
            if(([Utility isEmptyCheck:[defaults objectForKey:@"reviewAlert"]] || ![currentDate isEqualToString:[defaults objectForKey:@"reviewAlert"]])){
                [defaults setObject:currentDate forKey:@"reviewAlert"];
                dispatch_async(dispatch_get_main_queue(),^ {
                    [SKStoreReviewController requestReview];
                });
            }
        }
    }
}

-(void) showAlert {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"\"The Mbhq\" Would Like to Send You Notifications"
                                          message:@"Notifications may include alerts,sounds and icon badges.These can be configured in Settings."
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Allow"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]){
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                           if(success){
                               NSLog(@"Opened");
                               }
                           }];
                       }
                                    
                    }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Don't Allow"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                    if (![defaults boolForKey:@"isSiriAdded"]) {
                                          [self dismissViewControllerAnimated:NO completion:^{
                                              [self siriButtonPressed:nil];
                                       }];
                                    }
                                   }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)incompleStartTaskAlert{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Alert!"
                                          message:@"Please complete top 4 getting started task to access this functionality."
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self homeButtonTapped:0];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(BOOL)isSettingsPage{
    BOOL isSettings = false;
    return false;
    
    if ([self.parentViewController isKindOfClass:[ChooseGoalViewController class]] ||[self.parentViewController isKindOfClass:[DietaryPreferenceViewController class]] ||[self.parentViewController isKindOfClass:[MealFrequencyViewController class]] ||[self.parentViewController isKindOfClass:[MealVarietyViewController class]] ||[self.parentViewController isKindOfClass:[MealPlanViewController class]] ||[self.parentViewController isKindOfClass:[CustomProgramSetupViewController class]] ||[self.parentViewController isKindOfClass:[RateFitnessLevelViewController class]] ||[self.parentViewController isKindOfClass:[PersonalSessionsViewController class]] ||[self.parentViewController isKindOfClass:[MovePersonalSessionViewController class]]) {
        isSettings = true;
    }
    return isSettings;
}
-(BOOL)isSettingsPageCheck{
    BOOL isSettings = false;
    
    if ([self.parentViewController isKindOfClass:[ChooseGoalViewController class]] ||[self.parentViewController isKindOfClass:[DietaryPreferenceViewController class]] ||[self.parentViewController isKindOfClass:[MealFrequencyViewController class]] ||[self.parentViewController isKindOfClass:[MealVarietyViewController class]] ||[self.parentViewController isKindOfClass:[MealPlanViewController class]] ||[self.parentViewController isKindOfClass:[CustomProgramSetupViewController class]] ||[self.parentViewController isKindOfClass:[RateFitnessLevelViewController class]] ||[self.parentViewController isKindOfClass:[PersonalSessionsViewController class]] ||[self.parentViewController isKindOfClass:[MovePersonalSessionViewController class]]) {
        isSettings = true;
    }
    return isSettings;
}
- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Alert!"
                                          message:@"Are you sure you want to exit?\n\nWe need your goals and preferences to create your custom nutrition and workout program and set up your challenges.\nPlease continue!"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Continue"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   response(NO);
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Exit"
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction *action)
                                   {
                                       response(YES);
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(BOOL)isAchieveScreen{
    BOOL isContain = false;
    //Prev**RU**
//    if([self.parentViewController isKindOfClass:[VisionGoalActionViewController class]] || [self.parentViewController isKindOfClass:[AccountabilityBuddyHomeViewController class]] || [self.parentViewController isKindOfClass:[VisionHomeViewController class]] || [self.parentViewController isKindOfClass:[PersonalChallengeViewController class]] || [self.parentViewController isKindOfClass:[BucketListNewViewController class]]){
//        isContain = true;
//    }
//
    if([self.parentViewController isKindOfClass:[HabitHackerListViewController class]]|| [self.parentViewController isKindOfClass:[HabitHackerDetailsViewController class]]|| [self.parentViewController isKindOfClass:[HabitHackerDetailNewViewController class]]||[self.parentViewController isKindOfClass:[VisionGoalActionViewController class]] || [self.parentViewController isKindOfClass:[AccountabilityBuddyHomeViewController class]] || [self.parentViewController isKindOfClass:[AddVisionBoardViewController class]] || [self.parentViewController isKindOfClass:[PersonalChallengeViewController class]] || [self.parentViewController isKindOfClass:[BucketListNewViewController class]] ||[self.parentViewController isKindOfClass:[BucketListNewAddEditViewController class]]|| [self.parentViewController isKindOfClass:[MyBuddiesListViewController class]]||[self.parentViewController isKindOfClass:[AccountabilityGoalActionViewController class]]|| [self.parentViewController isKindOfClass:[AddGoalsViewController class]] || [self.parentViewController isKindOfClass:[HabitStatsViewController class]] || [self.parentViewController isKindOfClass:[HabitHackerFirstViewController class]] ||[self.parentViewController isKindOfClass:[PopularHabitListViewController class]] ||[self.parentViewController isKindOfClass:[PopularHabitLDetailsViewController class]]){
        isContain = true;
    }
    return isContain;
}
-(BOOL)isAppreciateScreen{
    BOOL isContain = false;
    if([self.parentViewController isKindOfClass:[GratitudeViewController class]] || [self.parentViewController isKindOfClass:[AchievementsViewController class]] || [self.parentViewController isKindOfClass:[AchievementsDateViewController class]] ||
       [self.parentViewController isKindOfClass:[AchievementsAddEditViewController class]] ||[self.parentViewController isKindOfClass:[GratitudeAddEditViewController class]] || [self.parentViewController isKindOfClass:[GratitudeListViewController class]] ||[self.parentViewController isKindOfClass:[TodayHomeViewController class]]//[self.parentViewController isKindOfClass:[WebinarListViewController class]] || [self.parentViewController isKindOfClass:[WebinarSelectedViewController class]]
       ){//[self.parentViewController isKindOfClass:[QuoteViewController class]] || [self.parentViewController isKindOfClass:[QuoteGalleryViewController class]]
        isContain = true;
    }
    return isContain;
}
-(BOOL)isLearnScreen{//[self.parentViewController isKindOfClass:[WebinarListViewController class]]
    BOOL isContain = false;
    if([self.parentViewController isKindOfClass:[CoursesListViewController class]]  || [self.parentViewController isKindOfClass:[QuestionnaireHomeViewController class]]|| [self.parentViewController isKindOfClass:[CSScaleViewController class]]|| [self.parentViewController isKindOfClass:[QuestionAttemptListViewController class]] || [self.parentViewController isKindOfClass:[RPStressViewController class]] || [self.parentViewController isKindOfClass:[HQuestionnaireViewController class]]){
        isContain = true;
    }
    return isContain;
}

-(BOOL)isCommnumityScreen{
    BOOL isContain = false;
    if([self.parentViewController isKindOfClass:[CommunityViewController class]]){
        isContain = true;
    }
    return isContain;
}
-(BOOL)isCourseScreen{
    BOOL isContain = false;
    if([self.parentViewController isKindOfClass:[CoursesListViewController class]] || [self.parentViewController isKindOfClass:[CourseDetailsViewController class]] || [self.parentViewController isKindOfClass:[CourseArticleDetailsViewController class]] || [self.parentViewController isKindOfClass:[PersonalChallengeViewController class]] || [self.parentViewController isKindOfClass:[PersonalChallengeAddEditViewController class]] || [self.parentViewController isKindOfClass:[PersonalChallengeDetailsViewController class]] || [self.parentViewController isKindOfClass:[QuestionnaireHomeViewController class]] || [self.parentViewController isKindOfClass:[QuestionAttemptListViewController class]] || [self.parentViewController isKindOfClass:[HQuestionnaireViewController class]] || [self.parentViewController isKindOfClass:[RPStressViewController class]] || [self.parentViewController isKindOfClass:[CSScaleViewController class]]||[self.parentViewController isKindOfClass:[CourseDetailsEntryViewController class]]){
        isContain = true;
    }
    return isContain;
}
-(BOOL)isMeditationScreen{
    BOOL isContain = false;
    if([self.parentViewController isKindOfClass:[WebinarListViewController class]] || [self.parentViewController isKindOfClass:[WebinarSelectedViewController class]]){
        isContain = true;
    }
    return isContain;
}

#pragma mark- End
#pragma mark - Siri Delegate
- (void)addVoiceShortcutViewController:(nonnull INUIAddVoiceShortcutViewController *)controller didFinishWithVoiceShortcut:(nullable INVoiceShortcut *)voiceShortcut error:(nullable NSError *)error  API_AVAILABLE(ios(12.0)){
    if (error == nil) {
        [defaults setBool:true forKey:@"isSiriAdded"];
        [controller dismissViewControllerAnimated:YES completion:^{
        }];
    }
   
}

- (void)addVoiceShortcutViewControllerDidCancel:(nonnull INUIAddVoiceShortcutViewController *)controller  API_AVAILABLE(ios(12.0)){
    [controller dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - Local Notification Observer
-(void)didBecomeActive:(NSNotification *)notofication{
    isStartTaskComplete = [defaults boolForKey:@"CompletedStartupChecklist"];
}
#pragma mark- End

@end
