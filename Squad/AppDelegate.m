//
//  AppDelegate.m
//  Squad
//
//  Created by AQB SOLUTIONS on 06/12/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import "SpotifyPlaylistViewController.h"
#import "Utility.h"
#import "MessageViewController.h"
#import "NavigationViewController.h"
#import "MasterMenuViewController.h"
#import "AddGoalsViewController.h"
#import "AddActionViewController.h"
#import "SelectCountyCityViewController.h"
#import "GratitudeAddEditViewController.h"
#import "AchievementsAddEditViewController.h"
#import "PreSignUpViewController.h"

#import "ConnectViewController.h"   //ahn
#import "TrainHomeViewController.h"
#import "NourishViewController.h"
#import "WebinarListViewController.h"
#import "CoursesListViewController.h"
#import "ExerciseDailyListViewController.h" //ahln
#import "AudioBookViewController.h"     //ah 31.8
#import "WebinarSelectedViewController.h"
#import "CourseArticleDetailsViewController.h"
#import "SevenDayTrialViewController.h"
#import "UILabel+ActionSheet.h"
#import "HomePageViewController.h"
#import "CourseDetailsViewController.h"
#import "CalendarViewController.h"
#import "SignupWithEmailViewController.h"
//#import "CourseArticleDetailsViewController.h"
#import "MenuSettingsViewController.h"
#import "MyPhotosDefaultViewController.h"
#import "NutritionSettingHomeViewController.h"
#import "CustomExerciseSettingsViewController.h"
#import "DailyGoodnessViewController.h"
#import "MyBuddiesListViewController.h"

#import "LearnHomeViewController.h"

#import "AchieveHomeViewController.h"
#import "AppreciateViewController.h"
#import "TrackViewController.h"
#import "GamificationViewController.h"
#import "MyProgramsViewController.h"
#import "FoodPrepViewController.h"
#import "InitialViewController.h"
#import "QuoteViewController.h"
#import "HelpViewController.h"
#import "VitaminViewController.h"//ADD_vitamin
#import "BucketListNewAddEditViewController.h"
#import "AddVisionBoardViewController.h"
#import "HabitStatsViewController.h"
#import "StoreObserver.h"
#import "GratitudeListViewController.h"
#import "CoursesListViewController.h"
#import "ChatDetailsVideoViewController.h"
@interface AppDelegate () {
   
    SpotifyPlaylistViewController *spotifyPlaylistController;
    UIView *contentView;
    BOOL isShowInitialPop;
}

@end

@implementation AppDelegate
@synthesize _tokenDelegate,commandCenter,reachability;

#pragma mark- Application Delegates

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.statusBarHidden = NO;
    _isShowingMenu = NO;
    isShowInitialPop = NO;
    
    //TODO:add non-existing push to cancel
    //    if (![defaults boolForKey:@"canceledOldNotification"]) {
    //        [defaults setBool:YES forKey:@"canceledOldNotification"];
    ////        NSArray *cancelPushArray = @[@"Vision",@"goals_vision",@"vision_board",@"bucket_list",@"personal_challenge",@"BucketList",@"Goal",@"gratitude_list",@"addGoal",@"train",@"BucketList",@"Action",@"Vision",@"Gratitude",@"Achievement",@"PersonalChallenge"];
    //        NSArray *cancelPushArray = @[@"Vision",@"goals_vision",@"vision_board",@"bucket_list",@"personal_challenge",@"BucketList",@"Goal",@"gratitude_list",@"addGoal",@"train",@"BucketList",@"Action",@"Vision",@"Gratitude",@"Achievement",@"PersonalChallenge"];
    //
    //        NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
    //        for (UILocalNotification *req in requests) {
    //            NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
    //            if ([cancelPushArray containsObject:pushTo]) {
    //                [[UIApplication sharedApplication] cancelLocalNotification:req];
    //            }
    //            //        if ([pushTo caseInsensitiveCompare:@"Vision"] == NSOrderedSame) {
    //            //            [[UIApplication sharedApplication] cancelLocalNotification:req];
    //            //        }
    //        }
    //    }
    
    
    //Video
    if (![Utility isEmptyCheck:[defaults objectForKey:@"PlayingMeditation"]]) {
        [defaults removeObjectForKey:@"PlayingMeditation"];
    }
    if (![Utility isEmptyCheck:[defaults objectForKey:@"PlayingCourse"]]) {
        [defaults removeObjectForKey:@"PlayingCourse"];
    }
    if (![Utility isEmptyCheck:[defaults objectForKey:@"RunningVideoSection"]]) {
        [defaults removeObjectForKey:@"RunningVideoSection"];
    }
    
    if ([defaults boolForKey:@"IsPlayingLiveChat"]) {
          [defaults setBool:NO forKey:@"IsPlayingLiveChat"];
      }
      if (![Utility isEmptyCheck:[defaults objectForKey:@"PlayingLiveChatDict"]]) {
          [defaults removeObjectForKey:@"PlayingLiveChatDict"];
      }
    //trial chat block
    [[NSNotificationCenter defaultCenter] addObserverForName:@"trialChatCheck" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIViewController *lastController;
            if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
                NSLog(@"NavvisibleViewController:%@",nav.visibleViewController);
                
                UIViewController *last = [nav.viewControllers lastObject];
                
                if([last isKindOfClass:[ECSlidingViewController class]])
                {
                    ECSlidingViewController *sliding = (ECSlidingViewController *)last;
                    NSLog(@"Inner");
                    NSLog(@"%@-----%@",sliding.underRightViewController,sliding.topViewController);
                    NavigationViewController *navInner = (NavigationViewController *)sliding.topViewController;
                    NSLog(@"NavInner:%@",navInner.viewControllers);
                    
                    lastController = [navInner.viewControllers lastObject];
                    
                }
            }else if([self.window.rootViewController isKindOfClass:[ECSlidingViewController class]]) {
                ECSlidingViewController *sliding = (ECSlidingViewController *)self.window.rootViewController;
                NSLog(@"%@-----%@",sliding.underLeftViewController,sliding.topViewController);
                NavigationViewController *navInner = (NavigationViewController *)sliding.topViewController;
                NSLog(@"Outer-%@",navInner.viewControllers.debugDescription);
                
                if (navInner) {
                    NSLog(@"OuterNavInner");
                    
                    lastController = [navInner.viewControllers lastObject];
                    
                }
                
            }
            
            if([defaults boolForKey:@"IsNonSubscribedUser"]){
                [Utility showSubscribedAlert:lastController];
            }
            
        });
    }];
    //Added For ChatSDK
    [[FIRInstanceID instanceID] getIDWithHandler:^(NSString * _Nullable identity, NSError * _Nullable error) {
        NSLog(@"Instance ID:%@",identity);
    }];
    
    //Added End
    [defaults setObject:[NSNumber numberWithBool:true] forKey:@"ApplyRounding"];
    [DAOReader sharedInstance];// AY 20022018 For DB
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    reachability = [Reachability reachabilityForInternetConnection];
    if(reachability){
        if ([reachability startNotifier]){
            NSLog(@"Start Netwrok Monitoring");
        } else{
            NSLog(@"Error Netwrok Monitoring");
        }
    }// AY 22022018 For Internet Monitoring
    
   UILabel * appearanceLabel = [UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]];
    [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Raleway" size:15]];
    UILabel * appearanceLabel1 = [UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]];
    [appearanceLabel1 setAppearanceColor:[UIColor colorWithRed:(0/255.0f) green:(212/255.0f) blue:(187/255.0f) alpha:1.0f]];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[StoreObserver sharedInstance]];

    //    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    _audioListArray = [[NSMutableArray alloc] init];     //ah 14.8
    _activeIndex = 0;
    
    _latLongArray = [[NSMutableArray alloc] init];     //ah tr
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Discoverable"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"Discoverable"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"Discoverable"];
    }
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    //end faf
    
    spotifyPlaylistController = [[SpotifyPlaylistViewController alloc]init];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Shuffle"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"Shuffle"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setObject:@"on" forKey:@"Shuffle"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Inbetween Rounds"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"Inbetween Rounds"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setObject:@"play softer" forKey:@"Inbetween Rounds"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Voice Over"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"Voice Over"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setObject:@"on" forKey:@"Voice Over"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Motivation"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"Motivation"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setObject:@"on" forKey:@"Motivation"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Bell"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"Bell"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setObject:@"off" forKey:@"Bell"]; // AY 12122017 Default Change to off
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isMusicPlaying"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"isMusicPlaying"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setObject:@"paused" forKey:@"isMusicPlaying"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"playlistCheck"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"playlistCheck"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"playlistCheck"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isGoalExpanded"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"isGoalExpanded"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isGoalExpanded"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isActionExpanded"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"isActionExpanded"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isActionExpanded"];
    }
    
    //ah ux
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstTimeForum"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstTimeForum"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstTimeForum"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstTimeHelp"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstTimeHelp"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstTimeHelp"];
    }
    //end ux
    
    //ah ux2
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstTimeLive"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstTimeLive"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstTimeLive"];
    }
    
    //ahd
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isAudioDownloaded"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAudioDownloaded"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isAudioDownloaded"];
    }
    
    //ahn
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isInitialNotiSet"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"isInitialNotiSet"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isInitialNotiSet"];
    }
    //Quote
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isInitialQuoteSet"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"isInitialQuoteSet"] isEqual:[NSNull null]]){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isInitialQuoteSet"];
    }
    
    //chayan
    if ([Utility isEmptyCheck:[defaults objectForKey:@"firstTimeHelpDict"]]){
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"isFirstTimeHome"];
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"isFirstTimeConnect"];
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"isFirstTimeTrain"];
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"isFirstTimeNourish"];
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"isFirstTimeLearn"];
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"isFirstTimeAchieve"];
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"isFirstTimeAppreciate"];
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"isFirstTimeTrack"];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"firstTimeHelpDict"];
        
    }
    
    
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    _mediaPlayingIndex = -1;
    _indexArray = [[NSMutableArray alloc]init];
    
    _autoRotate=NO;     //ah 21.3
    
    
    if ([Utility isEmptyCheck:[defaults objectForKey:@"InstallationDate"]]) {
        [defaults setObject:[NSDate date] forKey:@"InstallationDate"];
    }
    
    //    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    //    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [defaults setObject:[NSDate date] forKey:@"Date"];

    if (![Utility isEmptyCheck:[defaults objectForKey:@"LoginData"]] && ![Utility isEmptyCheck:[defaults objectForKey:@"UserID"]] && ![Utility isEmptyCheck:[defaults objectForKey:@"UserSessionID"]]) { //AY 06032018
        
        if ([defaults boolForKey:@"scheduleFreeUserNotification"]) {
            [Utility cancelscheduleLocalNotificationsForFreeUser];
            [defaults removeObjectForKey:@"scheduleFreeUserNotification"];
        }// AY 19022018
        
        [Utility cancelscheduleLocalNotificationsForQuote];
        //[AppDelegate scheduleLocalNotificationsForQuote:NO];
        NSString *tokenDateStr = [[defaults objectForKey:@"LoginData"]objectForKey:@"TokenExpiry"];
        if (![Utility isEmptyCheck:tokenDateStr]) {
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
             NSDate *tokenDate = [formatter dateFromString:tokenDateStr];
            if ([tokenDate isLaterThan:[NSDate date]]) {
                if ([Utility isOnlyProgramMember]) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

                    CoursesListViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"CoursesList"];
                    NavigationViewController *navController = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                    navController.navigationBarHidden = YES;
                    [self.window setRootViewController:navController];
                    [self.window makeKeyAndVisible];
                    [Utility localImageSync];
        }else{
               self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                       if([DBQuery isRowExist:@"todayGetGrowthDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and AddedDate = '%@'",[NSNumber numberWithInt:[[defaults objectForKey:@"UserID"]intValue]],currentDateStr]]){
                         DAOReader *dbObject = [DAOReader sharedInstance];
                         if([dbObject connectionStart]){
                             NSArray *todayHabitCoursearr = [dbObject selectBy:@"todayGetGrowthDetails" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"AddedDate",@"TodayData",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@' and AddedDate = '%@'",[NSNumber numberWithInt:[[defaults objectForKey:@"UserID"]intValue]],currentDateStr]];
                             NSString *str = todayHabitCoursearr[0][@"TodayData"];
                             NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                             NSDictionary *todayHabitCourseList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                             if(![Utility isEmptyCheck:[todayHabitCourseList objectForKey:@"Gratitude"]] || ![Utility isEmptyCheck:[todayHabitCourseList objectForKey:@"Growth"]]){
                                      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                       GratitudeListViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                                       NavigationViewController *navController = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                                       navController.navigationBarHidden = YES;
                                       [self.window setRootViewController:navController];
                                       [self.window makeKeyAndVisible];
                                       [Utility localImageSync];
                             }else if ([DBQuery isRowExist:@"gratitudeAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and CreatedDateStr = '%@'",[NSNumber numberWithInt:[[defaults objectForKey:@"UserID"]intValue]],currentDateStr]] || ([DBQuery isRowExist:@"growthAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and CreatedDateStr = '%@'",[NSNumber numberWithInt:[[defaults objectForKey:@"UserID"]intValue]],currentDateStr]])){
                                   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                   GratitudeListViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                                   NavigationViewController *navController = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                                   navController.navigationBarHidden = YES;
                                   [self.window setRootViewController:navController];
                                   [self.window makeKeyAndVisible];
                                   [Utility localImageSync];
                             }else{
                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                   TodayHomeViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"TodayHome"];
                                 GratitudeListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                                 controller.isFromGratitudeList = true;
                                   //                controller.isFromAppDelegate = YES;
                                   //                controller.isMovedToToday = true;
                                   NavigationViewController *navController = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                                   navController.navigationBarHidden = YES;
                                   [self.window setRootViewController:navController];
                                   [self.window makeKeyAndVisible];
                                   [Utility localImageSync];
                             }
                         }
                          [dbObject connectionEnd];
                       }else if ([DBQuery isRowExist:@"gratitudeAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and CreatedDateStr = '%@'",[NSNumber numberWithInt:[[defaults objectForKey:@"UserID"]intValue]],currentDateStr]] || ([DBQuery isRowExist:@"growthAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and CreatedDateStr = '%@'",[NSNumber numberWithInt:[[defaults objectForKey:@"UserID"]intValue]],currentDateStr]])){
                             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                             GratitudeListViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                             NavigationViewController *navController = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                             navController.navigationBarHidden = YES;
                             [self.window setRootViewController:navController];
                             [self.window makeKeyAndVisible];
                             [Utility localImageSync];
                       }else{
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                             TodayHomeViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"TodayHome"];
                           GratitudeListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                             //                controller.isFromAppDelegate = YES;
                             //                controller.isMovedToToday = true;
                             controller.isMoveToday = YES;
                             NavigationViewController *navController = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                             navController.navigationBarHidden = YES;
                             [self.window setRootViewController:navController];
                             [self.window makeKeyAndVisible];
                             [Utility localImageSync];
                       }
                 }
            }else{
                self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
               
                LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
                controller.isFromAppDelegate = YES;
                controller.isMovedToToday = true;
                NavigationViewController *navController = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                navController.navigationBarHidden = YES;
                [self.window setRootViewController:navController];
                [self.window makeKeyAndVisible];
            }
        }else{
            self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
            controller.isFromAppDelegate = YES;
            controller.isMovedToToday = true;
            NavigationViewController *navController = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
            navController.navigationBarHidden = YES;
            [self.window setRootViewController:navController];
            [self.window makeKeyAndVisible];
        }
        
        
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //[Utility msg:launchOptions.debugDescription title:@"LocalPushTest" controller:controller haveToPop:NO];
        if (![Utility isEmptyCheck:userInfo]) {
          if (![Utility isEmptyCheck:userInfo[@"pushTo"]] && [deepLinksHosts containsObject:userInfo[@"pushTo"]]){
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict setObject:@"deepLink" forKey:@"redirectType"];
                if(![Utility isEmptyCheck:userInfo]){
                    [dict setObject:userInfo forKey:@"userInfo"];
                    [dict setObject:userInfo[@"pushTo"] forKey:@"redirectTo"];
                }
                [defaults setObject:dict forKey:@"redirection"];
            }
            
        }
        
        
        
    }else{
        
        [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"UserID"];
        [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"UserSessionID"];
        [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"ABBBCOnlineUserId"];
        [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"ABBBCOnlineUserSessionId"];
        
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //SevenDayTrialViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"SevenDayTrial"];
        //controller.isFromAppDelegate = YES;
        InitialViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"InitialView"];
        NavigationViewController *navController = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        navController.navigationBarHidden = YES;
        NSLog(@"%@",navController.viewControllers);
        
        [self.window setRootViewController:navController];
        [self.window makeKeyAndVisible];
        
    }
    
    
    if (launchOptions[UIApplicationLaunchOptionsURLKey] == nil) {
       
    }
    NSError *sessionError = nil;
    @try {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient  error:&sessionError];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
    } @catch (NSException *exception) {
        NSLog(@"Audio Session error %@, %@", exception.reason, exception.userInfo);
        
    } @finally {
        NSLog(@"Audio Session finally");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.FBWAudioPlayer currentItem]];
    //commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [self setUpRemoteControl];
    
    [self becomeFirstResponder];
    
    // Use Firebase library to configure APIs
    [FIRApp configure]; // Added FireApp on 05012018
    
    //[UILocalNotification ]
    
    //    if (SYSTEM_VERSION_LESS_THAN(@"10")) {  //ah ln1
    
    UILocalNotification *localNotification = (UILocalNotification *)[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        //            application.applicationIconBadgeNumber = 0;
        NSLog(@"userinfo 1 --> %@",localNotification.userInfo);
        
        NSString *remType = [localNotification.userInfo objectForKey:@"remType"];
        if ([remType caseInsensitiveCompare:@"initialReminder"] == NSOrderedSame || [remType caseInsensitiveCompare:@"reminder"] == NSOrderedSame) {
            NSMutableDictionary *userInfo = [[localNotification userInfo] mutableCopy];
            [userInfo setObject:localNotification forKey:@"notification"];
            [self sendToViewController:application userInfo:userInfo isfrom:@"Local Notification" isShowAlert:NO];
        }
    }
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (_playerController) {
        [_playerController.player play];
    }
    if (![Utility isEmptyCheck:[defaults objectForKey:@"RunningVideoSection"]]) {
        if ([[defaults objectForKey:@"RunningVideoSection"] isEqualToString:@"Course"]) {
            if (![Utility isEmptyCheck:[defaults objectForKey:@"PlayingCourse"]]) {
                NSString *courseStr=[defaults objectForKey:@"PlayingCourse"];
                NSData *data = [courseStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                CMTime startTime = _playerController.player.currentTime;
                double videoStartTime = CMTimeGetSeconds(startTime);
                [Utility updateCourseVideoTime:dict videoStartTime:videoStartTime];
            }
        }else if ([[defaults objectForKey:@"RunningVideoSection"] isEqualToString:@"Meditation"]){
            if (![Utility isEmptyCheck:[defaults objectForKey:@"PlayingMeditation"]]) {
                NSString *webinarstr=[defaults objectForKey:@"PlayingMeditation"];
                NSData *data = [webinarstr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSMutableDictionary *webinar=[dict mutableCopy];
                CMTime startTime = _playerController.player.currentTime;
                double videoStartTime = CMTimeGetSeconds(startTime);
//                [Utility updateWebinarVideoTime:dict videoStartTime:videoStartTime];
                [Utility saveWebinarVideoStartTimeIntoTable:dict videoStartTime:videoStartTime];
                
                NSMutableArray *videoUrls = [[webinar objectForKey:@"EventItemVideoDetails"] mutableCopy];
                if (![Utility isEmptyCheck:videoUrls] && videoUrls.count > 0) {
                    NSMutableDictionary *appUrlDict =[[videoUrls objectAtIndex:0] mutableCopy];
                    [appUrlDict setObject:[NSNumber numberWithDouble:videoStartTime] forKey:@"Time"];
                    [videoUrls replaceObjectAtIndex:0 withObject:appUrlDict];
                    [webinar setObject:videoUrls forKey:@"EventItemVideoDetails"];
                    [Utility updateWebinarVideoTime_offline:webinar];
                    if(![Utility reachable]){
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadWebinarList" object:self userInfo:nil];
                    }
                }
            }
        }
    }
    
    isShowInitialPop = YES;
    
    //faf
//    if (self.playerController) {
//        self.playerController.player = nil;
//    }
    [self setUpRemoteControl];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Discoverable"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"Discoverable"] isEqual:[NSNull null]] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"Discoverable"] caseInsensitiveCompare:@"yes"] == NSOrderedSame) {
    }
    
    if (_mainAudioPlayer.isPlaying) {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isMusicPaused"];
    }
    
}
-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler{
    
    NSLog(@"Background Session:%@",identifier);
    
    self.backgroundTransferCompletionHandler = completionHandler;
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if ([defaults boolForKey:@"IsNonSubscribedUser"]) {
        [defaults setBool:false forKey:@"IsPopUpShowForFreeMode"];
    }
    if (![Utility isEmptyCheck:[defaults objectForKey:@"RunningVideoSection"]]) {
        if (_playerController) {
            [_playerController.player play];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"didBecomeActive" object:nil];//AY 14112017
     [[NSNotificationCenter defaultCenter]postNotificationName:@"didBecomeActiveForHeader" object:nil];
    [defaults setBool:true forKey:@"IsBecomeOfflineToOnline"];
    
    if(([defaults boolForKey:@"IsNonSubscribedUser"] || [Utility isSquadFreeUser]) && [defaults boolForKey:@"CompletedStartupChecklist"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
            NSLog(@"NavvisibleViewController:%@",nav.visibleViewController);
            
            UIViewController *lastController = [nav.viewControllers lastObject];
            if([lastController isKindOfClass:[InitialViewController class]] || [lastController isKindOfClass:[SignupWithEmailViewController class]] || [lastController isKindOfClass:[LoginController class]] || !isShowInitialPop){
                return;
            }
            
            
            if([lastController isKindOfClass:[ECSlidingViewController class]])
            {
                ECSlidingViewController *sliding = (ECSlidingViewController *)lastController;
                NSLog(@"Inner");
                NSLog(@"%@-----%@",sliding.underRightViewController,sliding.topViewController);
                NavigationViewController *navInner = (NavigationViewController *)sliding.topViewController;
                NSLog(@"NavInner:%@",navInner.viewControllers);
                
                
                UIViewController *prvController = [navInner.viewControllers lastObject];
                
                if([prvController isKindOfClass:[InitialViewController class]] || [prvController isKindOfClass:[SignupWithEmailViewController class]] || [prvController isKindOfClass:[LoginController class]] || !isShowInitialPop){
                    return;
                }
                
                InitialViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"InitialView"];
                controller.isShowTrialInfoView = true;
                controller.isPresented = YES;
                controller.presentingNav = navInner;
                
                if(self->_isShowingMenu){
                    if(sliding.underRightViewController){
                        [sliding.underRightViewController.slidingViewController anchorTopViewToLeftAnimated:YES];
                        [sliding.underRightViewController.slidingViewController resetTopViewAnimated:YES];
                    }
                }
                
                //[navInner presentViewController:controller animated:YES completion:^{}]; //Closed On 29-11-2018
                
                
                
            }
        }else if([self.window.rootViewController isKindOfClass:[ECSlidingViewController class]]) {
            ECSlidingViewController *sliding = (ECSlidingViewController *)self.window.rootViewController;
            NSLog(@"%@-----%@",sliding.underLeftViewController,sliding.topViewController);
            NavigationViewController *navInner = (NavigationViewController *)sliding.topViewController;
            NSLog(@"Outer-%@",navInner.viewControllers.debugDescription);
            
            if (navInner) {
                NSLog(@"OuterNavInner");
                
                UIViewController *prvController = [navInner.viewControllers lastObject];
                
                if([prvController isKindOfClass:[InitialViewController class]] || [prvController isKindOfClass:[SignupWithEmailViewController class]] || [prvController isKindOfClass:[LoginController class]] || !isShowInitialPop){
                    
                    return;
                }
                
                InitialViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"InitialView"];
                controller.isShowTrialInfoView = true;
                controller.isPresented = YES;
                controller.presentingNav = navInner;
                //                [sliding anchorTopViewToLeftAnimated:YES];
                //                [sliding resetTopViewAnimated:YES];
                if(self->_isShowingMenu){
                    if(sliding.underRightViewController){
                        [sliding.underRightViewController.slidingViewController anchorTopViewToLeftAnimated:YES];
                        [sliding.underRightViewController.slidingViewController resetTopViewAnimated:YES];
                    }
                }
                //[navInner presentViewController:controller animated:YES completion:^{}]; //Closed On 29-11-2018
                
                
                
            }
            
        }
    }
    
    
    
    if (self.playerController) {
        self.playerController.player = self.FBWAudioPlayer;
    }
    [self setUpRemoteControl];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //faf
    //int b=(int)application.applicationIconBadgeNumber;
    //    application.applicationIconBadgeNumber = 0;
    application.applicationIconBadgeNumber = (application.applicationIconBadgeNumber > 0) ? application.applicationIconBadgeNumber - 1 : 0;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Discoverable"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"Discoverable"] isEqual:[NSNull null]] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"Discoverable"] caseInsensitiveCompare:@"yes"] == NSOrderedSame) {
        
       
    }
    
    
    
    // Track Installs, updates & sessions(app opens) (You must include this API to enable tracking)
    
   
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Remove the observer
   
    //[[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver: [StoreObserver sharedInstance]];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[self.FBWAudioPlayer currentItem]];
}

//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                          openURL:url
//                                                sourceApplication:sourceApplication
//                                                       annotation:annotation];
//}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByRemovingPercentEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByRemovingPercentEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

// Handle auth callback
-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation {
    // Ask SPTAuth if the URL given is a Spotify authentication callback
    
    if(_safariBrowser){
        [_safariBrowser dismissViewControllerAnimated:YES completion:nil];
    }
    
    if ([[url scheme] isEqualToString:@"abbbcsquad"]){
        NSLog(@"url recieved: %@", url);
        NSLog(@"query string: %@", [url query]);
        NSLog(@"host: %@", [url host]);
        NSLog(@"url path: %@", [url path]);
        NSDictionary *dict = [self parseQueryString:[url query]];
        NSLog(@"query dict: %@", dict);
        if(![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"openpage"]]){
            [self sendToViewController:application userInfo:dict isfrom:dict[@"openpage"] isShowAlert:NO];
        }else if([deepLinksHosts containsObject:[url host]]){
            [self redirectionForDeeplinkAndChat:[url host] userInfo:nil];
        }else if([[url host] isEqualToString:@"friendRequest"]){
            [self redirectionForDeeplinkAndChat:[url host] userInfo:dict];
        }else if([[url host] isEqualToString:@"cancelreturn"]){
            
            BOOL isCancelled = [[dict objectForKey:@"isCancelled"] boolValue];
            BOOL isUpgraded = [[dict objectForKey:@"isUpgraded"] boolValue];
            BOOL isDowngraded = [[dict objectForKey:@"isDowngraded"] boolValue];
            if(isCancelled || isUpgraded || isDowngraded){
                [self redirectionForDeeplinkAndChat:[url host] userInfo:dict];
            }
            
        }
        else{
            NSNotification *notification =  [NSNotification notificationWithName:@"SampleBitLaunchNotification" object:nil userInfo:@{@"URL":url}];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        return YES;
        
    }else if ([[url scheme] isEqualToString:@"abbbcsquadgarmin"]){
        NSLog(@"url recieved: %@", url);
        NSLog(@"query string: %@", [url query]);
        NSLog(@"host: %@", [url host]);
        NSLog(@"url path: %@", [url path]);
        NSDictionary *dict = [self parseQueryString:[url query]];
        NSLog(@"query dict: %@", dict);
        
        NSNotification *notification =  [NSNotification notificationWithName:@"GarminLoginNotification" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        return YES;
        
    }//AY 16022018
    
    
    BOOL handled= false;
    if ([[SPTAuth defaultInstance] canHandleURL:url]) {
        [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
            
            if (error != nil) {
                NSLog(@"*** Auth error: %@", error);
                return;
            }
            
            
            // Call the -loginUsingSession: method to login SDK
            /*  UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
             UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
             SpotifyPlaylistViewController *controller = (SpotifyPlaylistViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"SpotifyPlaylist"];
             controller.session = session;
             [navigationController pushViewController:controller animated:NO];*/
            
            NSData *spotifySession = [NSKeyedArchiver archivedDataWithRootObject:[SPTAuth defaultInstance].session];
            [[NSUserDefaults standardUserDefaults] setObject:spotifySession forKey:@"spotifySession"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSData *newSessionData = [[NSUserDefaults standardUserDefaults] objectForKey:@"spotifySession"];
            SPTSession *newSession = [NSKeyedUnarchiver unarchiveObjectWithData:newSessionData];
            NSLog(@"First time logged in successfully with session %@", newSession.accessToken);
            
            //            [spotifyPlaylistController viewDidLoad];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"spotifyLoginNotification" object:self];
            
            
            //            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            //            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            //                        SpotifyPlaylistViewController *controller = (SpotifyPlaylistViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"SpotifyPlaylist"];
            //                        controller.session = session;
            //                        [navigationController pushViewController:controller animated:NO];
            //
            //            SpotifyPlaylistViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpotifyPlaylist"];
            //            NavigationViewController *nav = (*)[[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"] initWithRootViewController:controller];
            //            self.slidingViewController.topViewController = nav;
            //            [self.navigationController pushViewController:slider animated:NO];
            
        }];
        
        return YES;
    }
   
              
    
    
    // Add any custom logic here.
    return handled;
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [defaults setBool:true forKey:@"isSpalshShown"];
    self.token = [[[[deviceToken description]
                    stringByReplacingOccurrencesOfString: @"<" withString: @""]
                   stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"My token is: %@", self.token);
    [defaults setObject:self.token forKey:@"deviceToken"];
    //[_tokenDelegate tokenRceived];
    [AppDelegate sendDeviceToken];
    //End
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"%@",error.localizedDescription);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    //[BChatSDK application:application didReceiveRemoteNotification:userInfo]; //Added for ChatSDk
    application.applicationIconBadgeNumber = (application.applicationIconBadgeNumber > 0) ? application.applicationIconBadgeNumber - 1 : 0;
    
    if (![Utility isEmptyCheck:userInfo] && ![Utility isEmptyCheck:[userInfo objectForKey:@"senderid"]]) {
        
        [self sendToViewController:application userInfo:userInfo isfrom:@"Push Notification" isShowAlert:YES];
        
    }else if (![Utility isEmptyCheck:userInfo[@"pushTo"]] && [deepLinksHosts containsObject:userInfo[@"pushTo"]]){
        [self redirectionForDeeplinkAndChat:userInfo[@"pushTo"] userInfo:userInfo];
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //    NSMutableDictionary *userInfo = [[notification userInfo] mutableCopy];
    //    [userInfo setObject:notification forKey:@"notification"];
    //
    //    [self sendToViewController:application userInfo:userInfo isfrom:@"Local Notification" isShowAlert:YES];
    //9/10/18 feedback _S
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        // Application is in the foreground when notification was delivered.
        NavigationViewController *navInner;
        if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
            UIViewController *lastController = [nav.viewControllers lastObject];
            if([lastController isKindOfClass:[ECSlidingViewController class]])
            {
                ECSlidingViewController *sliding = (ECSlidingViewController *)lastController;
                NSLog(@"%@-----%@",sliding.underLeftViewController,sliding.topViewController);
                navInner = (NavigationViewController *)sliding.topViewController;
            }
        }else if([self.window.rootViewController isKindOfClass:[ECSlidingViewController class]]) {
            ECSlidingViewController *sliding = (ECSlidingViewController *)self.window.rootViewController;
            NSLog(@"%@-----%@",sliding.underLeftViewController,sliding.topViewController);
            navInner = (NavigationViewController *)sliding.topViewController;
        }
        
        //      NSString *okText = ![Utility isEmptyCheck:notification.alertAction]?notification.alertAction:@"OK";
        NSString *okText = @"View";
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:notification.alertTitle
                                              message:notification.alertBody
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:okText
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSMutableDictionary *userInfo = [[notification userInfo] mutableCopy];
                                       [userInfo setObject:notification forKey:@"notification"];
                                       
                                       [self sendToViewController:application userInfo:userInfo isfrom:@"Local Notification" isShowAlert:YES];
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Ignore"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [[navInner visibleViewController] presentViewController:alertController animated:YES completion:nil];
        //[[nav visibleViewController] presentViewController:controller animated:YES completion:nil];
    } else {
        NSMutableDictionary *userInfo = [[notification userInfo] mutableCopy];
        [userInfo setObject:notification forKey:@"notification"];
        
        [self sendToViewController:application userInfo:userInfo isfrom:@"Local Notification" isShowAlert:YES];
    }
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{   //ah 21.3
    if(_autoRotate){
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if (orientation == UIInterfaceOrientationPortrait) {
            return UIInterfaceOrientationMaskPortrait;
        }else if (orientation == UIInterfaceOrientationLandscapeRight) {
            return UIInterfaceOrientationMaskLandscapeRight;
        }else if (orientation == UIInterfaceOrientationLandscapeLeft){
            return UIInterfaceOrientationMaskLandscapeLeft;
        }
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    
    // Only allow portrait (standard behaviour)
    return UIInterfaceOrientationMaskPortrait;
}

// Reports app open from a Universal Link for iOS 9 or above
- (BOOL) application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler {
    //NSLog(@"Referer URL:%@",userActivity.referrerURL);
    NSLog(@"webpageURL URL:%@",userActivity.webpageURL);
    NSLog(@"userInfo: %@",userActivity.userInfo);
    NSLog(@"title: %@",userActivity.title);
    NSLog(@"activityType: %@",userActivity.activityType);
     if([userActivity.title isEqualToString:@"mbHQ"]){
           [self redirectionForDeeplinkAndChat:userActivity.title userInfo:nil];
       }
    return YES;
}

// Reports app open from deep link for iOS 10
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
            options:(NSDictionary *) options {
                            
                            if(_safariBrowser){
                                [_safariBrowser dismissViewControllerAnimated:YES completion:nil];
                            }
                if ([[url scheme] isEqualToString:@"abbbcmbhq"]){
                    if ([[url host] isEqualToString:@"purchase_program"]) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadCourseListAfterPurchase" object:self userInfo: nil];
                        return YES;
                    }else if([[url host]isEqualToString:@"app_purchase"]){
                        [self redirectionForDeeplinkAndChat:[url host] userInfo:nil];

                    }
                }
                
                
                            
            //                NSLog(@"url sceme: %@", [url scheme]);
                            if ([[url scheme] isEqualToString:@"abbbcsquad"]){
                                NSLog(@"url recieved: %@", url);
                                NSLog(@"query string: %@", [url query]);
                                NSLog(@"host: %@", [url host]);
                                NSLog(@"url path: %@", [url path]);
                                NSDictionary *dict = [self parseQueryString:[url query]];
                                NSLog(@"query dict: %@", dict);
                                if(![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"openpage"]]){
                                    [self sendToViewController:application userInfo:dict isfrom:dict[@"openpage"] isShowAlert:NO];
                                }else if([deepLinksHosts containsObject:[url host]]){
                                    [self redirectionForDeeplinkAndChat:[url host] userInfo:nil];
                                }else if([[url host] isEqualToString:@"friendRequest"]){
                                    
                                    [self redirectionForDeeplinkAndChat:[url host] userInfo:dict];
                                }else if([[url host] isEqualToString:@"cancelreturn"]){
                                    
                                    BOOL isCancelled = [[dict objectForKey:@"isCancelled"] boolValue];
                                    BOOL isUpgraded = [[dict objectForKey:@"isUpgraded"] boolValue];
                                    BOOL isDowngraded = [[dict objectForKey:@"isDowngraded"] boolValue];
                                    if(isCancelled || isUpgraded || isDowngraded){
                                        [self redirectionForDeeplinkAndChat:[url host] userInfo:dict];
                                    }
                                    
                                }
                                else{
                                    NSNotification *notification =  [NSNotification notificationWithName:@"SampleBitLaunchNotification" object:nil userInfo:@{@"URL":url}];
                                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                                }
                                return YES;
                                
                            }else if ([[url scheme] isEqualToString:@"abbbcsquadgarmin"]){
                                NSLog(@"url recieved: %@", url);
                                NSLog(@"query string: %@", [url query]);
                                NSLog(@"host: %@", [url host]);
                                NSLog(@"url path: %@", [url path]);
                                NSDictionary *dict = [self parseQueryString:[url query]];
                                NSLog(@"query dict: %@", dict);
                                
                                NSNotification *notification =  [NSNotification notificationWithName:@"GarminLoginNotification" object:nil userInfo:dict];
                                [[NSNotificationCenter defaultCenter] postNotification:notification];
                                
                                return YES;
                                
                            }//AY 16022018
                            
                            
                            BOOL handled= false;
                            if ([[SPTAuth defaultInstance] canHandleURL:url]) {
                                [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
                                    
                                    if (error != nil) {
                                        NSLog(@"*** Auth error: %@", error);
                                        return;
                                    }
                                    
                                    // Call the -loginUsingSession: method to login SDK
                                    /*  UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
                                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                     SpotifyPlaylistViewController *controller = (SpotifyPlaylistViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"SpotifyPlaylist"];
                                     controller.session = session;
                                     [navigationController pushViewController:controller animated:NO];*/
                                    
                                    NSData *spotifySession = [NSKeyedArchiver archivedDataWithRootObject:[SPTAuth defaultInstance].session];
                                    [[NSUserDefaults standardUserDefaults] setObject:spotifySession forKey:@"spotifySession"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    
                                    NSData *newSessionData = [[NSUserDefaults standardUserDefaults] objectForKey:@"spotifySession"];
                                    SPTSession *newSession = [NSKeyedUnarchiver unarchiveObjectWithData:newSessionData];
                                    NSLog(@"First time logged in successfully with session %@", newSession.accessToken);
                                    
                                    //            [spotifyPlaylistController viewDidLoad];
                                    
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"spotifyLoginNotification" object:self];
                                    
                                    
                                    //            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
                                    //            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                    //                        SpotifyPlaylistViewController *controller = (SpotifyPlaylistViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"SpotifyPlaylist"];
                                    //                        controller.session = session;
                                    //                        [navigationController pushViewController:controller animated:NO];
                                    //
                                    //            SpotifyPlaylistViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpotifyPlaylist"];
                                    //            NavigationViewController *nav = (*)[[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"] initWithRootViewController:controller];
                                    //            self.slidingViewController.topViewController = nav;
                                    //            [self.navigationController pushViewController:slider animated:NO];
                                    
                                }];
                                
                                return YES;
                            }
                            
                            
                            
                            // Add any custom logic here.
                            return handled;
                        }

#pragma mark- End

#pragma mark - UNUserNotificationCenter Delegates
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler { //ah ln
    NSLog(@"willPresentNotification -> %@",notification);
    
    if([Utility isOfflineMode]) return;
    //    AudioServicesPlaySystemSound (1104);
    
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        UIViewController *lastController = [nav.viewControllers lastObject];
        if([lastController isKindOfClass:[ECSlidingViewController class]])
        {
            ECSlidingViewController *sliding = (ECSlidingViewController *)lastController;
            NSLog(@"Inner");
            NSLog(@"%@-----%@",sliding.underLeftViewController,sliding.topViewController);
            NavigationViewController *navInner = (NavigationViewController *)sliding.topViewController;
            if (navInner) {
                    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound); //add_new_update
                
            }else{
                completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound); //add_new_update
            }
        }else{
            completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound); //add_new_update
        }
    }else if([self.window.rootViewController isKindOfClass:[ECSlidingViewController class]]) {
        ECSlidingViewController *sliding = (ECSlidingViewController *)self.window.rootViewController;
        NavigationViewController *navInner = (NavigationViewController *)sliding.topViewController;
        NSLog(@"Outer:%@",navInner.visibleViewController);
        if (navInner) {
                completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound); //add_new_update
        }else{
            completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound); //add_new_update
        }
    }else{
        completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound); //add_new_update
    }
    
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    NSLog(@"didReceiveNotificationResponse -> %@", response);
    
    UIViewController *lastController = self.window.rootViewController;
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        lastController = [nav.viewControllers lastObject];
    }
    if (response.notification.request.content.userInfo) {
        NSDictionary *dict = response.notification.request.content.userInfo;
        
        if (![response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            // User did tap at Local notification
            [self sendToViewController:[UIApplication sharedApplication] userInfo:dict isfrom:@"Local Notification" isShowAlert:NO];
            return;
        }
        
        if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:[dict objectForKey:@"senderid"]]) {
            
            [self sendToViewController:[UIApplication sharedApplication] userInfo:dict isfrom:@"Push Notification" isShowAlert:NO];
            
        }else if (![Utility isEmptyCheck:dict[@"pushTo"]] && [deepLinksHosts containsObject:dict[@"pushTo"]]){
            [self redirectionForDeeplinkAndChat:dict[@"pushTo"] userInfo:dict];
        }
    }
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken{
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSLog(@"Fired From Appdelegate token: %@", fcmToken);
    [AppDelegate sendDeviceToken];
    [Utility UpdatePushTokenToFireBaseDBForChat];
}

#pragma mark- AppsFlyer Delegate for Capture Campaign Data

-(void)onConversionDataReceived:(NSDictionary*) installData {
    
    id status = [installData objectForKey:@"af_status"];
    if([status isEqualToString:@"Non-organic"]) {
        id sourceID = [installData objectForKey:@"media_source"];
        id campaign = [installData objectForKey:@"campaign"];
        NSLog(@"This is a none organic install. Media source: %@  Campaign: %@",sourceID,campaign);
    } else if([status isEqualToString:@"Organic"]) {
        NSLog(@"This is an organic install.");
    }
}
-(void)onConversionDataRequestFailure:(NSError *) error {
    NSLog(@"%@",error);
}
- (void)onAppOpenAttribution:(NSDictionary*)attributionData{
    NSLog(@"onAppOpenAttribution:%@",attributionData);
    
    if(![Utility isEmptyCheck:attributionData[@"af_dp"]]){
        
        NSURL *url = [NSURL URLWithString:attributionData[@"af_dp"]];
        NSArray *deepLinksHost = [[NSArray alloc]initWithObjects:@"squaddaily",@"dailygoodness",@"fatloss",@"mealplan",nil];
        if(url && [deepLinksHost containsObject:[url host]]){
            [self redirectionForDeeplinkAndChat:[url host] userInfo:nil];
        }
    }
}
#pragma mark- End

#pragma mark- Controller Navigation for Notifications
-(void)redirectionForDeeplinkAndChat:(NSString *)redirectTo userInfo:(NSDictionary *)userInfo{
    
    if([Utility isOfflineMode]) return;
    
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        UIViewController *lastController = [nav.viewControllers lastObject];
        if([lastController isKindOfClass:[ECSlidingViewController class]])
        {
            ECSlidingViewController *sliding = (ECSlidingViewController *)lastController;
            NSLog(@"Inner");
            NSLog(@"%@-----%@",sliding.underLeftViewController,sliding.topViewController);
            NavigationViewController *navInner = (NavigationViewController *)sliding.topViewController;
            [self redirectToControllerByNavigation:navInner redirectTo:redirectTo userInfo:userInfo];
            
        }else{
            //[Utility msg:@"InnerNavElse" title:@"PushTest" controller:lastController haveToPop:NO];
            NSLog(@"InnerNavElse");
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            if([redirectTo isEqualToString:@"chat"]){
                [dict setObject:@"chat" forKey:@"redirectType"];
            }else{
                [dict setObject:@"deepLink" forKey:@"redirectType"];
            }
            
            if(![Utility isEmptyCheck:userInfo]){
                [dict setObject:userInfo forKey:@"userInfo"];
            }
            
            [dict setObject:redirectTo forKey:@"redirectTo"];
            [defaults setObject:dict forKey:@"redirection"];

            
        }
    }else if([self.window.rootViewController isKindOfClass:[ECSlidingViewController class]]) {
        ECSlidingViewController *sliding = (ECSlidingViewController *)self.window.rootViewController;
        NSLog(@"%@-----%@",sliding.underLeftViewController,sliding.topViewController);
        NavigationViewController *navInner = (NavigationViewController *)sliding.topViewController;
        NSLog(@"Outer-%@",navInner.viewControllers.debugDescription);
        if (navInner) {
            NSLog(@"OuterNavInner");
            [self redirectToControllerByNavigation:navInner redirectTo:redirectTo userInfo:userInfo];
            
        }else{
            //[Utility msg:@"OuterNavElse" title:@"DeepLinkTest" controller:navInner haveToPop:NO];
        }
        
    }
    
}

-(void)redirectToControllerByNavigation:(NavigationViewController *)navInner redirectTo:(NSString *)redirectTo userInfo:(NSDictionary *)userInfo{
    
    if (navInner) {
        if([redirectTo isEqualToString:@"squaddaily"]){
            
            if([[navInner visibleViewController] isKindOfClass:[ExerciseDailyListViewController class]]){
                return;
            }
            
            ExerciseDailyListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDailyList"];
            [navInner pushViewController:controller animated:YES];
            
        }else if([redirectTo isEqualToString:@"dailygoodness"]){
            
            if([[navInner visibleViewController] isKindOfClass:[DailyGoodnessViewController class]]){
                return;
            }
            
            DailyGoodnessViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyGoodness"];
            [navInner pushViewController:controller animated:YES];
            
        }else if([redirectTo isEqualToString:@"fatloss"]){
            
            if([[navInner visibleViewController] isKindOfClass:[CourseArticleDetailsViewController class]]){
                return;
            }
            
            CourseArticleDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseArticleDetails"];
            controller.courseId = [NSNumber numberWithInt:1];
            controller.articleId = [NSNumber numberWithInt:1];
            [navInner pushViewController:controller animated:YES];
            
        }else if([redirectTo isEqualToString:@"friendRequest"]){
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:navInner];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:navInner];
                return;
            }
            
            if(![Utility isEmptyCheck:userInfo[@"friendShipId"]]){
                [self friendRequestAccept:userInfo[@"friendShipId"] controller:navInner.visibleViewController];
            }
        }
        ///// TRAIN SECTION /////
        else if ([redirectTo isEqualToString:@"customexercise"]) {
            
            if([[navInner visibleViewController] isKindOfClass:[TrainHomeViewController class]]){
                
                TrainHomeViewController *controller = (TrainHomeViewController *)[navInner visibleViewController];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:1];
                [controller itemButtonPressed:btn];
                return;
            }
            
            TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:1];
            [navInner pushViewController:controller animated:YES];
            [controller itemButtonPressed:btn];
        }else if ([redirectTo isEqualToString:@"challenge"]) {
            
            if([[navInner visibleViewController] isKindOfClass:[TrainHomeViewController class]]){
                
                TrainHomeViewController *controller = (TrainHomeViewController *)[navInner visibleViewController];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:2];
                [controller itemButtonPressed:btn];
                return;
            }
            
            TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:2];
            [navInner pushViewController:controller animated:YES];
            [controller itemButtonPressed:btn];
        }else if ([redirectTo isEqualToString:@"fitbit_iwatch"]) {
            
            if([[navInner visibleViewController] isKindOfClass:[TrainHomeViewController class]]){
                
                TrainHomeViewController *controller = (TrainHomeViewController *)[navInner visibleViewController];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:11];
                [controller itemButtonPressed:btn];
                return;
            }
            
            TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:11];
            [navInner pushViewController:controller animated:YES];
            [controller itemButtonPressed:btn];
        }else if ([redirectTo isEqualToString:@"fbw_tracker"]) {
            
            if([[navInner visibleViewController] isKindOfClass:[TrainHomeViewController class]]){
                
                TrainHomeViewController *controller = (TrainHomeViewController *)[navInner visibleViewController];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:7];
                [controller itemButtonPressed:btn];
                return;
            }
            
            TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:7];
            [navInner pushViewController:controller animated:YES];
            [controller itemButtonPressed:btn];
        }else if ([redirectTo isEqualToString:@"session_list"]) {
            
            if([[navInner visibleViewController] isKindOfClass:[TrainHomeViewController class]]){
                
                TrainHomeViewController *controller = (TrainHomeViewController *)[navInner visibleViewController];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:5];
                [controller itemButtonPressed:btn];
                return;
            }
            
            TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:5];
            [navInner pushViewController:controller animated:YES];
            [controller itemButtonPressed:btn];
        }
        ///// TRAIN SECTION END /////
        
        ///// NOURISH SECTION /////
        else if([redirectTo isEqualToString:@"mealplan"]){
            
            if([[navInner visibleViewController] isKindOfClass:[NourishViewController class]]){
                return;
            }
            NourishViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Nourish"];
            controller.isFromNotification = YES;
            [navInner pushViewController:controller animated:YES];
        }else if([redirectTo isEqualToString:@"calorie_counter"]){
            if([[navInner visibleViewController] isKindOfClass:[NourishViewController class]]){
                return;
            }
            NourishViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Nourish"];
            controller.isFromMealMatchNotification = YES;
            [navInner pushViewController:controller animated:YES];
        }else if([redirectTo isEqualToString:@"food_prep_helper"]){
            
            if([[navInner visibleViewController] isKindOfClass:[FoodPrepViewController class]]){
                return;
            }
            
            FoodPrepViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrep"];
            [navInner pushViewController:controller animated:YES];;
        }else if([redirectTo isEqualToString:@"recipes_list"]){
            if([[navInner visibleViewController] isKindOfClass:[RecipeListViewController class]]){
                return;
            }
            
            RecipeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RecipeList"];
            [navInner pushViewController:controller animated:YES];
        }
        
        ///// NOURISH SECTION END /////
        
        ///// LEARN SECTION /////
        else if([redirectTo isEqualToString:@"courses"]){
            if([[navInner visibleViewController] isKindOfClass:[LearnHomeViewController class]]){
                
                LearnHomeViewController *controller = (LearnHomeViewController *)[navInner visibleViewController];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:1];
                [controller itemButtonPressed:btn];
                return;
            }
            
            LearnHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LearnHome"];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:1];
            [navInner pushViewController:controller animated:YES];
            [controller itemButtonPressed:btn];
        }else if([redirectTo isEqualToString:@"eight_week_challenge"]){
            if([[navInner visibleViewController] isKindOfClass:[LearnHomeViewController class]]){
                
                LearnHomeViewController *controller = (LearnHomeViewController *)[navInner visibleViewController];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:5];
                [controller itemButtonPressed:btn];
                return;
            }
            
            LearnHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LearnHome"];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:5];
            [navInner pushViewController:controller animated:YES];
            [controller itemButtonPressed:btn];
        }else if([redirectTo isEqualToString:@"set_programs"]){
            if([[navInner visibleViewController] isKindOfClass:[LearnHomeViewController class]]){
                
                LearnHomeViewController *controller = (LearnHomeViewController *)[navInner visibleViewController];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:6];
                [controller itemButtonPressed:btn];
                return;
            }
            
            LearnHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LearnHome"];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:6];
            [navInner pushViewController:controller animated:YES];
            [controller itemButtonPressed:btn];
        }else if([redirectTo isEqualToString:@"webinar_all"]){
            if([[navInner visibleViewController] isKindOfClass:[LearnHomeViewController class]]){
                
                LearnHomeViewController *controller = (LearnHomeViewController *)[navInner visibleViewController];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:0];
                [controller itemButtonPressed:btn];
                return;
            }
            
            LearnHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LearnHome"];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:0];
            [navInner pushViewController:controller animated:YES];
            [controller itemButtonPressed:btn];
        }
        
        ///// LEARN SECTION END /////
        ///// CONNECT SECTION /////
        else if([redirectTo isEqualToString:@"find_a_friend"]){
            
            if([Utility isSubscribedUser] || [Utility isSquadLiteUser]){
                if([[navInner visibleViewController] isKindOfClass:[ConnectViewController class]]){
                    
                    ConnectViewController *controller = (ConnectViewController *)[navInner visibleViewController];
                    [controller findASquadMemberButtonPressed:nil];
                    return;
                }
                
                ConnectViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Connect"];
                [navInner pushViewController:controller animated:YES];
                [controller findASquadMemberButtonPressed:nil];
            }else{
                [Utility showSubscribedAlert:[navInner visibleViewController]];
            }
            
            
        }else if([redirectTo isEqualToString:@"message_center"]){
            
            if([Utility isSubscribedUser] || [Utility isSquadLiteUser]){
               
            }else{
                [Utility showSubscribedAlert:[navInner visibleViewController]];
            }
        }
        ///// CONNECT SECTION END /////
        
        ///// ACHIEVE SECTION /////
        else if([redirectTo isEqualToString:@"accountability_buddies"]){
            if([Utility isSubscribedUser]){
                if([[navInner visibleViewController] isKindOfClass:[AchieveHomeViewController class]]){
                    
                    AchieveHomeViewController *controller = (AchieveHomeViewController *)[navInner visibleViewController];
                    [controller accountabilityBuddiesTapped:nil];
                    return;
                }
                
                AchieveHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AchieveHome"];
                [navInner pushViewController:controller animated:YES];
                [controller accountabilityBuddiesTapped:nil];
            }else{
                [Utility showSubscribedAlert:[navInner visibleViewController]];
            }
        }else if([redirectTo isEqualToString:@"goals_vision"]){
            return;
            if([Utility isSubscribedUser]){
                if([[navInner visibleViewController] isKindOfClass:[AchieveHomeViewController class]]){
                    
                    AchieveHomeViewController *controller = (AchieveHomeViewController *)[navInner visibleViewController];
                    [controller visionGoalsActionsButtonTapped:nil];
                    return;
                }
                
                AchieveHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AchieveHome"];
                [navInner pushViewController:controller animated:YES];
                
                [controller visionGoalsActionsButtonTapped:nil];
            }else{
                [Utility showSubscribedAlert:[navInner visibleViewController]];
            }
        }else if([redirectTo isEqualToString:@"vision_board"]){
            return;
            if([Utility isSubscribedUser]){
                if([[navInner visibleViewController] isKindOfClass:[AchieveHomeViewController class]]){
                    
                    AchieveHomeViewController *controller = (AchieveHomeViewController *)[navInner visibleViewController];
                    [controller visionBoardButtonTapped:nil];
                    return;
                }
                
                AchieveHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AchieveHome"];
                [navInner pushViewController:controller animated:YES];
                
                [controller visionBoardButtonTapped:nil];
            }else{
                [Utility showSubscribedAlert:[navInner visibleViewController]];
            }
        }
        else if([redirectTo isEqualToString:@"bucket_list"]){
            return;
            if([Utility isSubscribedUser]){
                if([[navInner visibleViewController] isKindOfClass:[AchieveHomeViewController class]]){
                    
                    AchieveHomeViewController *controller = (AchieveHomeViewController *)[navInner visibleViewController];
                    [controller bucketListTapped:nil];
                    return;
                }
                
                AchieveHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AchieveHome"];
                [navInner pushViewController:controller animated:YES];
                [controller bucketListTapped:nil];
            }else{
                [Utility showSubscribedAlert:[navInner visibleViewController]];
            }
        }else if([redirectTo isEqualToString:@"personal_challenge"]){
            return;
            if([Utility isSubscribedUser]){
                if([[navInner visibleViewController] isKindOfClass:[AchieveHomeViewController class]]){
                    
                    AchieveHomeViewController *controller = (AchieveHomeViewController *)[navInner visibleViewController];
                    [controller personalChallengesButtonTapped:nil];
                    return;
                }
                
                AchieveHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AchieveHome"];
                [navInner pushViewController:controller animated:YES];
                [controller personalChallengesButtonTapped:nil];
            }else{
                [Utility showSubscribedAlert:[navInner visibleViewController]];
            }
        }
        else if (![Utility isEmptyCheck:redirectTo] && [redirectTo caseInsensitiveCompare:@"BucketList"] == NSOrderedSame) {
            BucketListNewAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BucketListNewAddEdit"];
            if(![Utility isEmptyCheck:userInfo[@"extraData"]]){
                controller.bucketData = userInfo[@"extraData"];
            }
            [navInner pushViewController:controller animated:self];
//            [navInner presentViewController:controller animated:YES completion:nil];
            
        } else if (![Utility isEmptyCheck:redirectTo] && [redirectTo caseInsensitiveCompare:@"Goal"] == NSOrderedSame) {
            return;
            NSArray *valuesArray = userInfo[@"extraData"][@"valuesArray"];
            AddGoalsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddGoals"];
            
            if(![Utility isEmptyCheck:valuesArray]){
                controller.valuesArray = valuesArray;
            }
            
            if(![Utility isEmptyCheck:userInfo[@"extraData"][@"selectedGoalDict"]]){
                NSMutableDictionary *selectedGoalDict = [[NSMutableDictionary alloc] initWithDictionary:userInfo[@"extraData"][@"selectedGoalDict"]];
                controller.selectedGoalDict = selectedGoalDict;
            }
            [navInner pushViewController:controller animated:YES];
            [navInner presentViewController:controller animated:YES completion:nil];
            
        }
        ///// ACHIEVE SECTION END /////
        ///// APPRECIATE SECTION  /////
        else if([redirectTo isEqualToString:@"meditation"]){
            if([Utility isSubscribedUser]){
                if([[navInner visibleViewController] isKindOfClass:[AppreciateViewController class]]){
                    
                    AppreciateViewController *controller = (AppreciateViewController *)[navInner visibleViewController];
                    UIButton *btn = [[UIButton alloc] init];
                    [btn setTag:4];
                    [controller itemButtonPressed:btn];
                    return;
                }
                
                AppreciateViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Appreciate"];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:4];
                [navInner pushViewController:controller animated:YES];
                [controller itemButtonPressed:btn];
            }else{
                [Utility showSubscribedAlert:[navInner visibleViewController]];
            }
            
        }else if([redirectTo isEqualToString:@"gratitude_list"]){
            return;
            if([Utility isSubscribedUser]){
                if([[navInner visibleViewController] isKindOfClass:[AppreciateViewController class]]){
                    
                    AppreciateViewController *controller = (AppreciateViewController *)[navInner visibleViewController];
                    UIButton *btn = [[UIButton alloc] init];
                    [btn setTag:0];
                    [controller itemButtonPressed:btn];
                    return;
                }
                
                AppreciateViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Appreciate"];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:0];
                [navInner pushViewController:controller animated:YES];
                [controller itemButtonPressed:btn];
            }else{
                [Utility showSubscribedAlert:[navInner visibleViewController]];
            }
        }
        ///// APPRECIATE SECTION END /////
        ///// TRACK SECTION  /////
        else if([redirectTo isEqualToString:@"photos"]){
            if([Utility isSubscribedUser]){
                if([[navInner visibleViewController] isKindOfClass:[TrackViewController class]]){
                    
                    TrackViewController *controller = (TrackViewController *)[navInner visibleViewController];
                    UIButton *btn = [[UIButton alloc] init];
                    [btn setTag:0];
                    [controller itemButtonPressed:btn];
                    return;
                }
                
                TrackViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Track"];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:0];
                [navInner pushViewController:controller animated:YES];
                [controller itemButtonPressed:btn];
            }else{
                [Utility showSubscribedAlert:[navInner visibleViewController]];
            }
        }else if([redirectTo isEqualToString:@"weigh_ins"]){
            if([Utility isSubscribedUser]){
                if([[navInner visibleViewController] isKindOfClass:[TrackViewController class]]){
                    
                    TrackViewController *controller = (TrackViewController *)[navInner visibleViewController];
                    UIButton *btn = [[UIButton alloc] init];
                    [btn setTag:1];
                    [controller itemButtonPressed:btn];
                    return;
                }
                
                TrackViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Track"];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:1];
                [navInner pushViewController:controller animated:YES];
                [controller itemButtonPressed:btn];
            }else{
                [Utility showSubscribedAlert:[navInner visibleViewController]];
            }
        }else if([redirectTo isEqualToString:@"questionnaire"]){
            if([Utility isSubscribedUser]){
                if([[navInner visibleViewController] isKindOfClass:[TrackViewController class]]){
                    
                    TrackViewController *controller = (TrackViewController *)[navInner visibleViewController];
                    UIButton *btn = [[UIButton alloc] init];
                    [btn setTag:7];
                    [controller itemButtonPressed:btn];
                    return;
                }
                
                TrackViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Track"];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:7];
                [navInner pushViewController:controller animated:YES];
                [controller itemButtonPressed:btn];
            }else{
                [Utility showSubscribedAlert:[navInner visibleViewController]];
            }
        }
        ///// TRACK SECTION END /////
        ///// OTHER SECTION  /////
        else if([redirectTo isEqualToString:@"gamification_centre"]){
            if ([Utility isSubscribedUser]) {
                if ([[navInner visibleViewController] isKindOfClass:[GamificationViewController class]]) {
                    return;
                }
                
                GamificationViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GamificationView"];
                [navInner pushViewController:controller animated:YES];
            }else{
                
                [Utility showSubscribedAlert:[navInner visibleViewController]];
            }
            
        }else if([redirectTo isEqualToString:@"booty_abs"]){
            if ([Utility isSubscribedUser]) {
                if ([[navInner visibleViewController] isKindOfClass:[MyProgramsViewController class]]) {
                    return;
                }
                MyProgramsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPrograms"];
                [navInner pushViewController:controller animated:YES];
            }
            else{
                
                [Utility showSubscribedAlert:[navInner visibleViewController]];
            }
            
        }else if([redirectTo isEqualToString:@"calendar"]){
            if ([[navInner visibleViewController] isKindOfClass:[CalendarViewController class]]) {
                return;
            }
            CalendarViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Calendar"];
            [navInner pushViewController:controller animated:YES];
        }else if([redirectTo isEqualToString:@"settings"]){
            if ([[navInner visibleViewController] isKindOfClass:[MenuSettingsViewController class]]) {
                return;
            }
            MenuSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuSettingsView"];
            [navInner pushViewController:controller animated:YES];
        }else if([redirectTo isEqualToString:@"web"]){
            if(![Utility isEmptyCheck:userInfo[@"weburl"]]){
                NSString *weburl = userInfo[@"weburl"];
                
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:weburl]]){
                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weburl] options:@{} completionHandler:^(BOOL success) {
                    if(success){
                        NSLog(@"Opened");
                        }
                    }];
                }
                
            }
        }else if([redirectTo isEqualToString:@"today_page"]){
            if([[navInner visibleViewController] isKindOfClass:[TodayHomeViewController class]]){
                return;
            }
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:navInner.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                //                [Utility showAlertAfterSevenDayTrail:navInner.visibleViewController];
                //                return;
            }
            
            
            
//            TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
            GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
            [navInner pushViewController:controller animated:YES];
            
        }else if([redirectTo isEqualToString:@"help"]){
            if([[navInner visibleViewController] isKindOfClass:[HelpViewController class]]){
                return;
            }
            
            HelpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpView"];
            [navInner pushViewController:controller animated:YES];
            
        }
        else if([redirectTo isEqualToString:@"cancelreturn"]){
            
            BOOL isCancelled = [[userInfo objectForKey:@"isCancelled"] boolValue];
            BOOL isUpgraded = [[userInfo objectForKey:@"isUpgraded"] boolValue];
            BOOL isDowngraded = [[userInfo objectForKey:@"isDowngraded"] boolValue];
            
            if(isCancelled){
                /*if ([[navInner visibleViewController] isKindOfClass:[InitialViewController class]]) {
                 return;
                 }*/
                
                NSMutableDictionary *userDataDict = [[NSMutableDictionary alloc]init];
                [userDataDict setObject:[defaults objectForKey:@"FirstName"] forKey:@"FirstName"];
                [userDataDict setObject:[defaults objectForKey:@"LastName"] forKey:@"LastName"];
                [userDataDict setObject:@"" forKey:@"Mobile"];
                [userDataDict setObject:[defaults objectForKey:@"Email"] forKey:@"Email"];
                [userDataDict setObject:[NSNumber numberWithBool:[defaults boolForKey:@"IsFbUser"]] forKey:@"IsFbUser"];
                
                if([defaults boolForKey:@"IsFbUser"]){
                    [userDataDict setObject:[defaults objectForKey:@"Password"] forKey:@"Password"];
                }else{
                    //                    [userDataDict setObject:@"1234" forKey:@"Password"];
                    [userDataDict setObject:[defaults objectForKey:@"Password"] forKey:@"Password"];//13/12
                }
                //                [self logoutApi];     //13/12
                if(![Utility isEmptyCheck:[userInfo objectForKey:@"activeUntil"]]){
                    [defaults setObject:[userInfo objectForKey:@"activeUntil"] forKey:@"TempTrialEndDate"];//13/12
                    NSDateFormatter *df = [NSDateFormatter new];
                    [df setDateFormat:@"yyyy-MM-dd"];
                    NSDate *date = [df dateFromString:[userInfo objectForKey:@"activeUntil"]];
                    [df setDateFormat:@"dd MMM yyyy"];
                    NSString *text = [@"" stringByAppendingFormat:@"Hi, Your cancellation was successful. You have full access until %@ at which time you will be limited to the 'free workouts'.\nPlease stay part of our amazing community and please stay in touch.",[df stringFromDate:date]];
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:nil
                                                          message:text
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action)
                                               {
                                                   //                                                   UIViewController *con = navInner.topViewController;
                                                   //                                                   NSLog(@"%@",con);
                                                   //                                                   [navInner.navigationController popViewControllerAnimated:YES];
                                                   [navInner popViewControllerAnimated:YES];
                                                   //                                                   [self registerNonsubscribedUser:userDataDict withNavigation:navInner];
                                               }];
                    [alertController addAction:okAction];
                    [navInner presentViewController:alertController animated:YES completion:nil];
                }
                //                else{
                //                    [self registerNonsubscribedUser:userDataDict withNavigation:navInner];
                //                }
                //                [self registerNonsubscribedUser:userDataDict withNavigation:navInner];
                /*UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 InitialViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"InitialView"];
                 [navInner pushViewController:controller animated:YES];*/
                
                
            }else if(isUpgraded || isDowngraded){
                if ([[navInner visibleViewController] isKindOfClass:[LoginController class]]) {
                    return;
                }
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
                controller.isFromAppDelegate = true;
                [navInner pushViewController:controller animated:YES];
            }
            
        }else if ([redirectTo isEqualToString:@"mbHQ"]){
            NotesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
            controller.fromStr = @"Gratitude";
            [navInner pushViewController:controller animated:YES];
        }else if([redirectTo isEqualToString:@"app_purchase"]){
            if ([[navInner visibleViewController] isKindOfClass:[LoginController class]]) {
                return;
            }
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
            controller.isFromSignUp = true;
            [navInner pushViewController:controller animated:YES];
        }
        ///// OTHER SECTION END /////
        
    }
}

-(void)sendToViewController:(UIApplication *)application userInfo:(NSDictionary *)userInfo isfrom:(NSString *)isfrom isShowAlert:(BOOL)isShowAlert{
    if (![Utility isEmptyCheck:userInfo]) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
            UIViewController *lastController = [nav.viewControllers lastObject];
            if([lastController isKindOfClass:[ECSlidingViewController class]])
            {
                ECSlidingViewController *sliding = (ECSlidingViewController *)lastController;
                NSLog(@"%@-----%@",sliding.underLeftViewController,sliding.topViewController);
                NavigationViewController *navInner = (NavigationViewController *)sliding.topViewController;
                if (navInner) {
                    if ([isfrom isEqualToString:@"Local Notification"]) {
                        [self sendToViewControllerFromLocalNotification:application userInfo:userInfo nav:navInner isShowAlert:isShowAlert];
                    }else if ([isfrom isEqualToString:@"courses"]) {
                        CoursesListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CoursesList"];
                        [navInner pushViewController:controller animated:YES];
                    }else if ([isfrom isEqualToString:@"customnutrition"]) {
                        NourishViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Nourish"];
                        controller.isFromNotification = YES;
                        [navInner pushViewController:controller animated:YES];
                    }else if ([isfrom isEqualToString:@"squaddaily"]) {
                        ExerciseDailyListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDailyList"];
                        [navInner pushViewController:controller animated:YES];
                    }else if ([isfrom isEqualToString:@"customexercise"]) {
                        TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
                        UIButton *btn = [[UIButton alloc] init];
                        [btn setTag:1];
                        [controller itemButtonPressed:btn];
                        [navInner pushViewController:controller animated:YES];
                    }else if ([isfrom isEqualToString:@"Push Notification"]) {
                        NSDictionary *aps = [userInfo objectForKey:@"aps"];
                        if (![Utility isEmptyCheck:aps]) {
                            NSDictionary *alert = [aps objectForKey:@"alert"];
                            if (![Utility isEmptyCheck:alert]) {
                                UIViewController *lastControllerInner = [navInner.viewControllers lastObject];
                                if([lastControllerInner isKindOfClass:[MessageViewController class]])
                                {
                                    /*NSMutableArray *array = [nav.viewControllers mutableCopy];
                                     [array removeLastObject];
                                     nav.viewControllers = array;*/
                                    MessageViewController *messageViewController = (MessageViewController *)lastControllerInner;
                                    NSLog(@"%d-------%d",messageViewController.receiverId,[[userInfo objectForKey:@"senderid"] intValue]);
                                    if (messageViewController.receiverId == [[userInfo objectForKey:@"senderid"] intValue]) {
                                        messageViewController.receiverId = [[userInfo objectForKey:@"senderid"] intValue];
                                        messageViewController.receiverName =[alert objectForKey:@"title"];
                                        [messageViewController viewDidAppear:YES];
                                        return;
                                    }else{
                                        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:[alert objectForKey:@"title"] message:@"" preferredStyle:UIAlertControllerStyleAlert];
                                        if (![Utility isEmptyCheck:[alert objectForKey:@"body"]]) {
                                            [alertvc setValue:[Utility getattributedMessage:[alert objectForKey:@"body"]] forKey:@"attributedMessage"];
                                            
                                        }
                                        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                            [navInner popViewControllerAnimated:NO];
                                            MessageViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"Message"];
                                            controller.receiverId = [[userInfo objectForKey:@"senderid"] intValue];
                                            controller.receiverName =[alert objectForKey:@"title"];
                                            [navInner pushViewController:controller animated:NO];
                                        }];
                                        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                            
                                        }];
                                        
                                        [alertvc addAction:actionOk];
                                        [alertvc addAction:actionCancel];
                                        
                                        //UIViewController *vc = self.window.rootViewController;
                                        [messageViewController presentViewController:alertvc animated:YES completion:nil];
                                        return;
                                    }
                                }else{
                                    if (application.applicationState == UIApplicationStateActive && [[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
                                        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:[alert objectForKey:@"title"] message:@"" preferredStyle:UIAlertControllerStyleAlert];
                                        if (![Utility isEmptyCheck:[alert objectForKey:@"body"]]) {
                                            [alertvc setValue:[Utility getattributedMessage:[alert objectForKey:@"body"]] forKey:@"attributedMessage"];
                                        }
                                        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                            MessageViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"Message"];
                                            controller.receiverId = [[userInfo objectForKey:@"senderid"] intValue];
                                            controller.receiverName =[alert objectForKey:@"title"];
                                            [navInner pushViewController:controller animated:YES];
                                        }];
                                        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                            
                                        }];
                                        
                                        [alertvc addAction:actionOk];
                                        [alertvc addAction:actionCancel];
                                        
                                        //UINavigationController *vc =(UINavigationController *) self.window.rootViewController;
                                        [lastControllerInner presentViewController:alertvc animated:YES completion:nil];
                                    }else{
                                        MessageViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"Message"];
                                        controller.receiverId = [[userInfo objectForKey:@"senderid"] intValue];
                                        controller.receiverName =[alert objectForKey:@"title"];
                                        [navInner pushViewController:controller animated:YES];
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                if (![Utility isEmptyCheck:[defaults objectForKey:@"LoginData"]] && ![Utility isEmptyCheck:[defaults objectForKey:@"UserID"]] && ![Utility isEmptyCheck:[defaults objectForKey:@"UserSessionID"]]) {
                    
                    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
                    NavigationViewController *navController = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                    navController.navigationBarHidden = YES;
                    [self.window setRootViewController:navController];
                    [self.window makeKeyAndVisible];
                    
                    if ([isfrom isEqualToString:@"Local Notification"]) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                        
                        UILocalNotification *notification = userInfo[@"notification"];
                        
                        if(notification){
                            userInfo = notification.userInfo;
                        }
                        
                        [dict setObject:isfrom forKey:@"redirectType"];
                        //[Utility msg:userInfo.debugDescription title:@"LocalPushTest" controller:controller haveToPop:NO];
                        if(![Utility isEmptyCheck:userInfo]){
                            [dict setObject:userInfo forKey:@"userInfo"];
                        }
                        
                        [dict setObject:@"" forKey:@"redirectTo"];
                        [defaults setObject:dict forKey:@"redirection"];
                        
                    }
                    
                }else{
                    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
                    //PreSignUpViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"PreSignUp"];
                    NavigationViewController *navController = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                    navController.navigationBarHidden = YES;
                    [self.window setRootViewController:navController];
                    [self.window makeKeyAndVisible];
                }
            }
            
        }else if([self.window.rootViewController isKindOfClass:[ECSlidingViewController class]]) {
            ECSlidingViewController *sliding = (ECSlidingViewController *)self.window.rootViewController;
            NSLog(@"%@-----%@",sliding.underLeftViewController,sliding.topViewController);
            NavigationViewController *navInner = (NavigationViewController *)sliding.topViewController;
            if (navInner) {
                if ([isfrom isEqualToString:@"Local Notification"]) {
                    [self sendToViewControllerFromLocalNotification:application userInfo:userInfo nav:navInner isShowAlert:isShowAlert];
                }
            }
        }
    }
}


-(void)sendToViewControllerFromLocalNotification:(UIApplication *)application userInfo:(NSDictionary *)userInfo nav:(UINavigationController *)nav isShowAlert:(BOOL)isShowAlert{
    
    UIViewController *lastController = [nav.viewControllers lastObject];
    
    UILocalNotification *notification = userInfo[@"notification"];
    
    if(notification){
        userInfo = notification.userInfo;
    }
    
    if ([[userInfo objectForKey:@"remType"] caseInsensitiveCompare:@"initialReminder"] == NSOrderedSame){    //ahn
        if (application.applicationState == UIApplicationStateActive && [[UIDevice currentDevice].systemVersion floatValue] < 10.0 && isShowAlert) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:notification.alertTitle message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (userInfo) {
                    [self redirectToControllerFromLocalNotification:userInfo nav:nav];
                    
                }
                
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:ok];
            [alertController addAction:cancel];
            
            [lastController presentViewController:alertController animated:YES completion:nil];
        }else {
            
            if([[UIDevice currentDevice].systemVersion floatValue] < 10.0){
                if (userInfo) {
                    [self redirectToControllerFromLocalNotification:userInfo nav:nav];
                }
            }else{
                [self redirectToControllerFromLocalNotification:userInfo nav:nav];
            }
            
            
        }
    }else if ([[userInfo objectForKey:@"remType"] caseInsensitiveCompare:@"reminder"] == NSOrderedSame) {    //ah ln1
        if (application.applicationState == UIApplicationStateActive && [[UIDevice currentDevice].systemVersion floatValue] < 10.0 && isShowAlert) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:notification.alertTitle message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (userInfo) {
                    [self redirectToControllerFromLocalNotification:userInfo nav:nav];
                    
                }
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:ok];
            [alertController addAction:cancel];
            
            [lastController presentViewController:alertController animated:YES completion:nil];
        }else{
            if([[UIDevice currentDevice].systemVersion floatValue] < 10.0){
                if (userInfo) {
                    [self redirectToControllerFromLocalNotification:userInfo nav:nav];
                }
            }else{
                [self redirectToControllerFromLocalNotification:userInfo nav:nav];
            }
        }
    } else {
        if (application.applicationState == UIApplicationStateActive && [[UIDevice currentDevice].systemVersion floatValue] < 10.0 && isShowAlert) {
            //        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],notification.soundName]];
            //        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_pewPewSound);
            //        AudioServicesPlaySystemSound(self.pewPewSound);
            
            //        AVAudioPlayer *newAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
            //        self.player = newAudioPlayer;
            //        self.player.numberOfLoops = -1;
            //        [self.player prepareToPlay];
            //        [self.player play];
            UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [defaults setBool:YES forKey:@"isNotificationClicked"];
                NSData *data= [defaults objectForKey:@"NotificationData"];
                UILocalNotification *localNotif = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                NSLog(@"Remove localnotification  are %@", localNotif);
                [[UIApplication sharedApplication] cancelLocalNotification:localNotif];
                [defaults removeObjectForKey:@"NotificationData"];
                NSURL *url = [NSURL URLWithString:@"fb://profile/816487051740290/"];
               if([[UIApplication sharedApplication] canOpenURL:url]){
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                  if(success){
                      NSLog(@"Opened");
                      }
                  }];
               }else {
                    url = [NSURL URLWithString:@"https://www.facebook.com/groups/816487051740290/"];
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    if(success){
                        NSLog(@"Opened");
                        }
                    }];
                }
                
            }];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertvc addAction:actionOk];
            [alertvc addAction:actionCancel];
            [lastController presentViewController:alertvc animated:YES completion:nil];
        }else{
            [defaults setBool:YES forKey:@"isNotificationClicked"];
            NSData *data= [defaults objectForKey:@"NotificationData"];
            UILocalNotification *localNotif = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSLog(@"Remove localnotification  are %@", localNotif);
            [[UIApplication sharedApplication] cancelLocalNotification:localNotif];
            [defaults removeObjectForKey:@"NotificationData"];
            NSURL *url = [NSURL URLWithString:@"fb://profile/816487051740290/"];
           if([[UIApplication sharedApplication] canOpenURL:url]){
              [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"Opened");
                }
            }];
           }
            else {
                url = [NSURL URLWithString:@"https://www.facebook.com/groups/816487051740290/"];
                 [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                           if(success){
                               NSLog(@"Opened");
                               }
                           }];
            }
            
        }
    }
}

-(void)redirectToControllerFromLocalNotification:(NSDictionary *)userInfo nav:(UINavigationController *)nav{
    if (![Utility isEmptyCheck:userInfo] && ![Utility isOfflineMode]) { //AY 06032018
        NSDictionary *dict = userInfo;
        if ([dict[@"pushTo"] caseInsensitiveCompare:@"WorldForum"] == NSOrderedSame) {
            if([[nav visibleViewController] isKindOfClass:[ConnectViewController class]]){
                return;
            }
            
            if(![Utility isSubscribedUser] && ![Utility isSquadLiteUser] && ![Utility isSquadFreeUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }// AY 19032018
            ConnectViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Connect"];
            [nav pushViewController:controller animated:YES];
            
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"TodayPage"] == NSOrderedSame) {
            
            if([[nav visibleViewController] isKindOfClass:[TodayHomeViewController class]]){
                return;
            }
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                //                 [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                //                 return;
            }
            
            
            
//            TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
            GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
            [nav pushViewController:controller animated:YES];
            
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"setProgram"] == NSOrderedSame) {
            
            if([[nav visibleViewController] isKindOfClass:[LearnHomeViewController class]]){
                
                LearnHomeViewController *controller = (LearnHomeViewController *)[nav visibleViewController];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:6];
                [controller itemButtonPressed:btn];
                return;
            }
            
            LearnHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LearnHome"];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:6];
            [nav pushViewController:controller animated:YES];
            [controller itemButtonPressed:btn];
            
        }
        else if ([dict[@"pushTo"] caseInsensitiveCompare:@"circuitTimer"] == NSOrderedSame) {
            
            if([[nav visibleViewController] isKindOfClass:[TrainHomeViewController class]]){
                TrainHomeViewController *controller = (TrainHomeViewController *)[nav visibleViewController];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:12];
                [controller itemButtonPressed:btn];
                return;
            }
            
            TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:12];
            [controller itemButtonPressed:btn];
            [nav pushViewController:controller animated:YES];
            
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"features"] == NSOrderedSame) {
            
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            if([[nav visibleViewController] isKindOfClass:[MyProgramsViewController class]]){
                return;
            }
            
            MyProgramsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPrograms"];
            [nav pushViewController:controller animated:YES];
            
        }
        else if ([dict[@"pushTo"] caseInsensitiveCompare:@"customExercise"] == NSOrderedSame) {
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            if([[nav visibleViewController] isKindOfClass:[TrainHomeViewController class]]){
                TrainHomeViewController *controller = (TrainHomeViewController *)[nav visibleViewController];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:1];
                [controller itemButtonPressed:btn];
                return;
            }
            
            TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:1];
            [controller itemButtonPressed:btn];
            [nav pushViewController:controller animated:YES];
            
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"session_list"] == NSOrderedSame) {
            if([[nav visibleViewController] isKindOfClass:[TrainHomeViewController class]]){
                
                TrainHomeViewController *controller = (TrainHomeViewController *)[nav visibleViewController];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:5];
                [controller itemButtonPressed:btn];
                return;
            }
            
            TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:5];
            [nav pushViewController:controller animated:YES];
            [controller itemButtonPressed:btn];
            
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"customNutrition"] == NSOrderedSame) {
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            if([[nav visibleViewController] isKindOfClass:[NourishViewController class]]){
                return;
            }
            NourishViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Nourish"];
            controller.isFromNotification = YES;
            [nav pushViewController:controller animated:YES];
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"WebinarListView"] == NSOrderedSame) {
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            if([[nav visibleViewController] isKindOfClass:[WebinarListViewController class]]){
                return;
            }
            WebinarListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarListView"];
            controller.isNotFromHome = YES;
            controller.selectedFilterDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:59],@"TagID",@"Mindfulness",@"EventTagName", nil];
            [nav pushViewController:controller animated:YES];
            
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"CoursesList"] == NSOrderedSame) {
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            if([[nav visibleViewController] isKindOfClass:[CoursesListViewController class]]){
                return;
            }
            CoursesListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CoursesList"];
            [nav pushViewController:controller animated:YES];
            
        }
        //ahln
        else if ([dict[@"pushTo"] caseInsensitiveCompare:@"squadDaily"] == NSOrderedSame) {
            if([[nav visibleViewController] isKindOfClass:[ExerciseDailyListViewController class]]){
                return;
            }
            ExerciseDailyListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDailyList"];
            [nav pushViewController:controller animated:YES];
        } else if ([dict[@"pushTo"] caseInsensitiveCompare:@"addGoal"] == NSOrderedSame) {
            return;
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            if([[nav visibleViewController] isKindOfClass:[AddGoalsViewController class]]){
                return;
            }
            AddGoalsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddGoals"];
            [nav pushViewController:controller animated:YES];
            [[nav visibleViewController] presentViewController:controller animated:YES completion:nil];
        } else if ([dict[@"pushTo"] caseInsensitiveCompare:@"findAFriend"] == NSOrderedSame) {
           
        }
        // AY 16032018
        else if ([dict[@"pushTo"] caseInsensitiveCompare:@"SignUp"] == NSOrderedSame){
            if([[nav visibleViewController] isKindOfClass:[SignupWithEmailViewController class]]){
                return;
            }
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SignupWithEmailViewController *signupController=[storyboard instantiateViewControllerWithIdentifier:@"SignupWithEmail"];
            NSDictionary *userData = [defaults objectForKey:@"NonSubscribedUserData"];
            if (![Utility isEmptyCheck:userData] && ![Utility isEmptyCheck:userData[@"Email"]]) {
                signupController.isFromFb = ![Utility isEmptyCheck:userData[@"IsFbUser"]]?[userData[@"IsFbUser"] boolValue] : NO;
                signupController.fName = ![Utility isEmptyCheck:userData[@"FirstName"]]?userData[@"FirstName"] : @"";
                signupController.lName = ![Utility isEmptyCheck:userData[@"LastName"]]?userData[@"LastName"] : @"";
                signupController.email = userData[@"Email"];
                if (![Utility isEmptyCheck:userData[@"IsFbUser"]] && [userData[@"IsFbUser"] boolValue]) {
                    signupController.password = ![Utility isEmptyCheck:userData[@"Password"]]?userData[@"Password"] : @"";
                }else{
                    signupController.password =  @"";
                }
                signupController.isFromNonSubscribedUser = YES;
            }
            [nav pushViewController:signupController animated:YES];
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"train"] == NSOrderedSame) {
            return;
            //            if([[nav visibleViewController] isKindOfClass:[TrainHomeViewController class]]){
            //                return;
            //            }
            //            TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
            //            [nav pushViewController:controller animated:YES];
            
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"8WeekChallenge"] == NSOrderedSame) {
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            if([[nav visibleViewController] isKindOfClass:[CourseDetailsViewController class]]){
                return;
            }
            CourseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetails"];
            controller.isFromMenu = YES;
            [nav pushViewController:controller animated:YES];
            
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"calendar"] == NSOrderedSame) {
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            if([[nav visibleViewController] isKindOfClass:[CalendarViewController class]]){
                return;
            }
            CalendarViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Calendar"];
            [nav pushViewController:controller animated:YES];
            
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"customShopping"] == NSOrderedSame) {
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            if([[nav visibleViewController] isKindOfClass:[ShoppingListViewController class]]){
                return;
            }
            ShoppingListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingListView"];
            controller.isCustom = YES;
            //controller.weekdate = weekDate;
            [nav pushViewController:controller animated:YES];
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"activityTracker"] == NSOrderedSame) {
            if(![defaults boolForKey:@"IsNonSubscribedUser"] && ![Utility isSubscribedUser]){
                if([[nav visibleViewController] isKindOfClass:[TrainHomeViewController class]]){
                    return;
                }
                TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:11];
                [controller itemButtonPressed:btn];
                [nav pushViewController:controller animated:YES];
            }else {
                
               
            }
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"CoursesArticle"] == NSOrderedSame) {
            
            if([[nav visibleViewController] isKindOfClass:[CourseArticleDetailsViewController class]]){
                return;
            }
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            CourseArticleDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseArticleDetails"];
            controller.courseId = [NSNumber numberWithInt:7];
            controller.articleId = [NSNumber numberWithInt:46];
            /*if (![Utility isEmptyCheck:[articleData objectForKey:@"RelatedTask"]]) {
             controller.taskId = [articleData objectForKey:@"RelatedTask"][@"TaskId"];
             }*/
            [nav pushViewController:controller animated:YES];
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"MenuSetting"] == NSOrderedSame) {
            if([[nav visibleViewController] isKindOfClass:[MenuSettingsViewController class]]){
                return;
            }
            MenuSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuSettingsView"];
            [nav pushViewController:controller animated:YES];
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"FBWTracker"] == NSOrderedSame) {
            
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"TrackPicture"] == NSOrderedSame) {
            if([[nav visibleViewController] isKindOfClass:[TrackViewController class]]){
                
                TrackViewController *controller = (TrackViewController *)[nav visibleViewController];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:0];
                [controller itemButtonPressed:btn];
                return;
            }
            
            TrackViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Track"];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:0];
            [nav pushViewController:controller animated:YES];
            [controller itemButtonPressed:btn];
            
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"questionnaire"] == NSOrderedSame) {
            if([[nav visibleViewController] isKindOfClass:[TrackViewController class]]){
                
                TrackViewController *controller = (TrackViewController *)[nav visibleViewController];
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:7];
                [controller itemButtonPressed:btn];
                return;
            }
            
            TrackViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Track"];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:7];
            [nav pushViewController:controller animated:YES];
            [controller itemButtonPressed:btn];
            
        }
        else if ([dict[@"pushTo"] caseInsensitiveCompare:@"MealMatch"] == NSOrderedSame) {
            if([[nav visibleViewController] isKindOfClass:[NourishViewController class]]){
                return;
            }
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            NourishViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Nourish"];
            controller.isFromMealMatchNotification = YES;
            [nav pushViewController:controller animated:YES];
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"NutritionSetting"] == NSOrderedSame) {
            if([[nav visibleViewController] isKindOfClass:[NutritionSettingHomeViewController class]]){
                return;
            }
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            NutritionSettingHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionSettingHomeView"];
            [nav pushViewController:controller animated:YES];
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"ExerciseSetting"] == NSOrderedSame) {
            if([[nav visibleViewController] isKindOfClass:[CustomExerciseSettingsViewController class]]){
                return;
            }
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            CustomExerciseSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomExerciseSettings"];
            [nav pushViewController:controller animated:YES];
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"Survey"] == NSOrderedSame) {
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *URL = [NSURL URLWithString:@"https://www.surveymonkey.com/r/VKHHVMV"];
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"Opened url");
                }
            }];
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"SignUpViaWeb"] == NSOrderedSame) {
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *URL = [NSURL URLWithString:@"https://www.ashybines.com/squad50off/index"];
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"Opened url");
                }
            }];
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"KETO"] == NSOrderedSame) {
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *URL = [NSURL URLWithString:@"https://www.ashybines.com/home/keto"];
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"Opened url");
                }
            }];
        }
        else if ([dict[@"pushTo"] caseInsensitiveCompare:@"SquadLiteUpgrade"] == NSOrderedSame) {
            
           
            
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"BucketList"] == NSOrderedSame) {
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            BucketListNewAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BucketListNewAddEdit"];
            controller.bucketData = dict[@"extraData"];
            [nav pushViewController:controller animated:YES];
//           [[nav visibleViewController] presentViewController:controller animated:YES completion:nil];
        } else if ([dict[@"pushTo"] caseInsensitiveCompare:@"Goal"] == NSOrderedSame) {
            return;
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            NSArray *valuesArray = dict[@"extraData"][@"valuesArray"];
            NSMutableDictionary *selectedGoalDict = [[NSMutableDictionary alloc] initWithDictionary:dict[@"extraData"][@"selectedGoalDict"]];
            AddGoalsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddGoals"];
            controller.valuesArray = valuesArray;
            controller.selectedGoalDict = selectedGoalDict;
            [nav pushViewController:controller animated:YES];
            [[nav visibleViewController] presentViewController:controller animated:YES completion:nil];
        } else if ([dict[@"pushTo"] caseInsensitiveCompare:@"Action"] == NSOrderedSame) {
            return;
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            NSArray *goalListArray = dict[@"extraData"][@"goalListArray"];
            NSMutableDictionary *selectedActionDict = [[NSMutableDictionary alloc] initWithDictionary:dict[@"extraData"][@"selectedActionDict"]];
            
            AddActionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddAction"];
            controller.goalListArray = [goalListArray mutableCopy];
            controller.actionSelectedDict = selectedActionDict;
            [nav pushViewController:controller animated:YES];
            [[nav visibleViewController] presentViewController:controller animated:YES completion:nil];
        } else if ([dict[@"pushTo"] caseInsensitiveCompare:@"Vision"] == NSOrderedSame) {
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            AddVisionBoardViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddVisionBoard"];
            controller.visionBoardDict = dict[@"extraData"];
            controller.isFromReminder = YES;
            [nav pushViewController:controller animated:YES];
        } else if ([dict[@"pushTo"] caseInsensitiveCompare:@"Gratitude"] == NSOrderedSame) {
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            GratitudeAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GratitudeAddEdit"];
            controller.gratitudeData = dict[@"extraData"];
            [nav pushViewController:controller animated:YES];
//            [[nav visibleViewController] presentViewController:controller animated:YES completion:nil];
        } else if ([dict[@"pushTo"] caseInsensitiveCompare:@"Achievement"] == NSOrderedSame) {
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            AchievementsAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AchievementsAddEdit"];
            controller.achievementsData = dict[@"extraData"];
            [nav pushViewController:controller animated:YES];
//            [[nav visibleViewController] presentViewController:controller animated:YES completion:nil];
        } else if ([dict[@"pushTo"] caseInsensitiveCompare:@"PersonalChallenge"] == NSOrderedSame) {
            return;
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            
            PersonalChallengeDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalChallengeDetails"];
            controller.habitId = dict[@"ID"];
            [nav pushViewController:controller animated:YES];
        }
        else if ([dict[@"pushTo"] caseInsensitiveCompare:@"QuoteController"] == NSOrderedSame) {//Quote
            
            [Utility cancelscheduleLocalNotificationsForQuote];
            [AppDelegate scheduleLocalNotificationsForQuote:NO];
            
            /* if([Utility isSquadLiteUser]){
             [Utility showSubscribedAlert:nav.visibleViewController];
             return;
             }else if([Utility isSquadFreeUser]){
             [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
             return;
             }*/
            
            if([[nav visibleViewController] isKindOfClass:[QuoteViewController class]]){
                return;
            }
            
            if (![Utility isEmptyCheck:dict]) {
                QuoteViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuoteView"];
                controller.quoteDict = (![Utility isEmptyCheck:dict[@"quoteDict"]])?dict[@"quoteDict"]:nil ;
                controller.fromAppDelegate = true;
                [nav pushViewController:controller animated:YES];
            }
        }else if ([dict[@"pushTo"] caseInsensitiveCompare:@"Vitamin"] == NSOrderedSame) {  //ADD_vitamin
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            if([[nav visibleViewController] isKindOfClass:[VitaminViewController class]]){
                return;
            }
            VitaminViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VitaminView"];
            [nav pushViewController:controller animated:YES];
        }//ADD_vitamin
        else if ([dict[@"pushTo"] caseInsensitiveCompare:@"HabitList"] == NSOrderedSame) {  //ADD_vitamin
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:nav.visibleViewController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:nav.visibleViewController];
                return;
            }
            if([[nav visibleViewController] isKindOfClass:[HabitStatsViewController class]]){
                return;
            }
            HabitStatsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitStatsView"];
            controller.habitDict = [dict objectForKey:@"extraData"];
            controller.isfromLocalNotification=YES;
            [nav pushViewController:controller animated:YES];
        }
        //End
        
    }
}
#pragma mark-End
#pragma mark - RemoteControlEvents
//ah 31.8
- (void) playTrackCommandSelector {
    //    NSIndexPath *ip = [NSIndexPath indexPathForRow:appDelegate.activeIndex inSection:0];
    //    AudioBookTableViewCell *cell = (AudioBookTableViewCell *)[_audioListTable cellForRowAtIndexPath:ip];
    //    [cell.playPauseButton setSelected:YES];
    [self.FBWAudioPlayer play];
}
- (void) pauseTrackCommandSelector {
    //    NSIndexPath *ip = [NSIndexPath indexPathForRow:appDelegate.activeIndex inSection:0];
    //    AudioBookTableViewCell *cell = (AudioBookTableViewCell *)[_audioListTable cellForRowAtIndexPath:ip];
    //    [cell.playPauseButton setSelected:NO];
    [self.FBWAudioPlayer pause];
}
- (void)nextTrackCommandSelector {
    [self.FBWAudioPlayer pause];
    self.activeIndex++;
    //    AudioBookViewController *audioBook = [[AudioBookViewController alloc] init];
    if (self.activeIndex < self.audioListArray.count) {
        //        [audioBook playAudioWithUrl:[[self.audioListArray objectAtIndex:self.activeIndex] objectForKey:@"audioUrl"]];
        NSURL *trackURL = [NSURL URLWithString:[[self.audioListArray objectAtIndex:self.activeIndex] objectForKey:@"audioUrl"]];
        
        self.FBWAudioPlayer = nil;
        self.FBWAudioPlayer =  [[AVPlayer alloc] initWithURL:trackURL];
        [self.FBWAudioPlayer play];
        
        
    } else {
        self.activeIndex = 0;
        //        [audioBook playAudioWithUrl:[[self.audioListArray objectAtIndex:self.activeIndex] objectForKey:@"audioUrl"]];
        NSURL *trackURL = [NSURL URLWithString:[[self.audioListArray objectAtIndex:self.activeIndex] objectForKey:@"audioUrl"]];
        
        self.FBWAudioPlayer = nil;
        self.FBWAudioPlayer =  [[AVPlayer alloc] initWithURL:trackURL];
        [self.FBWAudioPlayer play];
        
    }
}
- (void)prevTrackCommandSelector {
    [self.FBWAudioPlayer pause];
    self.activeIndex--;
    //    AudioBookViewController *audioBook = [[AudioBookViewController alloc] init];
    if (self.activeIndex < 0) {
        self.activeIndex = 0;
        //        [audioBook playAudioWithUrl:[[self.audioListArray objectAtIndex:self.activeIndex] objectForKey:@"audioUrl"]];
        NSURL *trackURL = [NSURL URLWithString:[[self.audioListArray objectAtIndex:self.activeIndex] objectForKey:@"audioUrl"]];
        
        self.FBWAudioPlayer = nil;
        self.FBWAudioPlayer =  [[AVPlayer alloc] initWithURL:trackURL];
        [self.FBWAudioPlayer play];
        
    } else {
        //        [audioBook playAudioWithUrl:[[self.audioListArray objectAtIndex:self.activeIndex] objectForKey:@"audioUrl"]];
        NSURL *trackURL = [NSURL URLWithString:[[self.audioListArray objectAtIndex:self.activeIndex] objectForKey:@"audioUrl"]];
        
        self.FBWAudioPlayer = nil;
        self.FBWAudioPlayer =  [[AVPlayer alloc] initWithURL:trackURL];
        [self.FBWAudioPlayer play];
        
    }
}

#pragma mark - AVPlayer Notification
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    if([notification.object isKindOfClass:[AudioBookViewController class]] || [notification.object isKindOfClass:[CourseArticleDetailsViewController class]] || [notification.object isKindOfClass:[WebinarSelectedViewController class]]){
        if(self.playerController){
            AVPlayerItem *p = [notification object];
            [p seekToTime:kCMTimeZero];
        }else{
            self.activeIndex++;
            if (self.activeIndex < self.audioListArray.count) {
                
            } else {
                self.activeIndex = 0;
            }
            
            NSURL *trackURL = [NSURL URLWithString:[[self.audioListArray objectAtIndex:self.activeIndex] objectForKey:@"audioUrl"]];
            
            self.FBWAudioPlayer = nil;
            self.FBWAudioPlayer =  [[AVPlayer alloc] initWithURL:trackURL];
            [self.FBWAudioPlayer play];
            
        }
    }else if ([notification.object isKindOfClass:[ChatDetailsVideoViewController class]]){
        if(self.playerController){
        //            AVPlayerItem *p = [notification object];
        //            [p seekToTime:kCMTimeZero];
                }else{
        //            self.activeIndex++;
        //            if (self.activeIndex < self.audioListArray.count) {
        //
        //            } else {
        //                self.activeIndex = 0;
        //            }
        //
                    if ([defaults boolForKey:@"IsPlayingLiveChat"]) {
                        NSData *data = [defaults objectForKey:@"PlayingLiveChatDict"];
                        NSDictionary *videoDet = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        NSDictionary *videoDict=[[videoDet objectForKey:@"EventItemVideoDetails"] objectAtIndex:0];

                        if (![Utility isEmptyCheck:videoDict]) {
                            NSString * videoString = [[videoDict objectForKey:@"DownloadURL"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                            NSURL *videoURL = [NSURL URLWithString:videoString];
                            self.FBWAudioPlayer = nil;
                            self.FBWAudioPlayer =  [[AVPlayer alloc] initWithURL:videoURL];
                            [self.FBWAudioPlayer play];
                        }
                    }
                }
    }
    
}
-(void)setUpRemoteControl{
    //    [commandCenter.playCommand removeTarget:self action:@selector(playTrackCommandSelector)];
    //    [commandCenter.pauseCommand removeTarget:self action:@selector(pauseTrackCommandSelector)];
    //    [commandCenter.nextTrackCommand removeTarget:self action:@selector(nextTrackCommandSelector)];
    //    [commandCenter.previousTrackCommand removeTarget:self action:@selector(prevTrackCommandSelector)];
    //    if (self.playerController) {
    //        commandCenter.playCommand.enabled = true;
    //        commandCenter.pauseCommand.enabled = true;
    //        commandCenter.nextTrackCommand.enabled = false;
    //        commandCenter.previousTrackCommand.enabled = false;
    //        [commandCenter.playCommand addTarget:self action:@selector(playTrackCommandSelector)];
    //        [commandCenter.pauseCommand addTarget:self action:@selector(pauseTrackCommandSelector)];
    //    }else{
    //        commandCenter.playCommand.enabled = true;
    //        commandCenter.pauseCommand.enabled = true;
    //        commandCenter.nextTrackCommand.enabled = true;
    //        commandCenter.previousTrackCommand.enabled = true;
    //        [commandCenter.playCommand addTarget:self action:@selector(playTrackCommandSelector)];
    //        [commandCenter.pauseCommand addTarget:self action:@selector(pauseTrackCommandSelector)];
    //        [commandCenter.nextTrackCommand addTarget:self action:@selector(nextTrackCommandSelector)];
    //        [commandCenter.previousTrackCommand addTarget:self action:@selector(prevTrackCommandSelector)];
    //    }
}
#pragma mark - End
#pragma mark - Local Notification For Free Users
+(void)scheduleLocalNotificationsForFreeUser{
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"TrialStartDate"]]) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        NSDate *installationDate = [defaults objectForKey:@"TrialStartDate"];
        
        //NSLog(@"Trial Date:%@",[format stringFromDate:installationDate]);
        
        //Day 1 Notification
        NSDate *day1;
        if([installationDate isToday]){
            day1 =  [calendar dateByAddingUnit:NSCalendarUnitMinute
                                         value:60
                                        toDate:[NSDate date]
                                       options:0];
        }else{
            day1 =  [calendar dateByAddingUnit:NSCalendarUnitMinute
                                         value:60
                                        toDate:installationDate
                                       options:0];
        }
        
        NSDate *currentDate = [NSDate date];
        
        if(day1 && ![day1 isEarlierThan:currentDate]){
            
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"squadDaily",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day1;
            localNotification.alertTitle = @"DAY 1";
            localNotification.alertBody = @"Squad Daily Workouts are THE BEST. Give one a try, you will LOVE IT!";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        
        
        day1 =  [calendar dateByAddingUnit:NSCalendarUnitMinute
                                     value:180
                                    toDate:day1
                                   options:0];
        
        
        if(day1 && ![day1 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys: @"initialReminder", @"remType", @"freeUser", @"notificationType",@"customExercise",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day1;
            localNotification.alertTitle = @"CUSTOM WORKOUTS";
            localNotification.alertBody = @"Take your DAILY workouts to next level and create a CUSTOM WORKOUT plan designed around your goals";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        
        
        //Day 2 Notification
        NSDate *day2 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                             value:1
                                            toDate:installationDate
                                           options:0];
        
        day2 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day2 options:NSCalendarMatchStrictly];
        
        
        if(day2 && ![day2 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"customNutrition",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day2;
            localNotification.alertTitle = @"DAY 2";
            localNotification.alertBody = @"Its day 2 of your 7 day TRIAL. Let’s check out what mouth watering meals your Custom Nutrition Plan has planned for you today.";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        
        
        day2 =  [calendar dateBySettingHour:16 minute:45 second:00 ofDate:day2 options:NSCalendarMatchStrictly];
        
        
        if(day2 && ![day2 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys: @"initialReminder", @"remType", @"freeUser", @"notificationType",@"train",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day2;
            localNotification.alertTitle = @"THESE WILL BLOW YOUR MIND";
            localNotification.alertBody = @"Hey Gorgeous, get secret tips on how to get the most from your CUSTOM PLANS. Click the [i] in the top right hand corner of your app. These features will blow your mind!";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        
        day2 =  [calendar dateBySettingHour:19 minute:00 second:00 ofDate:day2 options:NSCalendarMatchStrictly];
        
        
        if(day2 && ![day2 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys: @"initialReminder", @"remType", @"freeUser", @"notificationType",@"WorldForum",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day2;
            localNotification.alertTitle = @"Meet Your Squad";
            localNotification.alertBody = @"Meet the supportive, positive women that will help you achieve your goals.";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        
        //Day 3 Notification
        NSDate *day3 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                             value:2
                                            toDate:installationDate
                                           options:0];
        
        day3 = [calendar dateBySettingHour:6 minute:00 second:00 ofDate:day3 options:NSCalendarMatchStrictly];
        
        
        if(day3 && ![day3 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"TodayPage",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day3;
            localNotification.alertTitle = @"TODAY is the DAY";
            localNotification.alertBody = @"Everything you need to transform your body in one simple page";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        
        
        day3 =  [calendar dateBySettingHour:12 minute:00 second:00 ofDate:day3 options:NSCalendarMatchStrictly];
        
        
        if(day3 && ![day3 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys: @"initialReminder", @"remType", @"freeUser", @"notificationType",@"8WeekChallenge",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day3;
            localNotification.alertTitle = @"Achieve more results!";
            localNotification.alertBody = @"In 8 weeks you won’t recognise yourself";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        
        day3 =  [calendar dateBySettingHour:19 minute:00 second:00 ofDate:day3 options:NSCalendarMatchStrictly];
        
        
        if(day3 && ![day3 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys: @"initialReminder", @"remType", @"freeUser", @"notificationType",@"calendar",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day3;
            localNotification.alertTitle = @"GET EDUCATED";
            localNotification.alertBody = @"Over 25 life changing courses right at your fingers.  Learn how fat is really burned and never be fooled again!";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        
        //Day 4 Notification
        NSDate *day4 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                             value:3
                                            toDate:installationDate
                                           options:0];
        
        day4 = [calendar dateBySettingHour:10 minute:00 second:00 ofDate:day4 options:NSCalendarMatchStrictly];
        
        
        if(day4 && ![day4 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"customShopping",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day4;
            localNotification.alertTitle = @"YOUR NEW BFF";
            localNotification.alertBody = @"Haven’t got on top of your diet yet? The Custom Shopping list feature is a MUST.  Trust me, this one is a life-saver, game changer and BFF rolled into one.";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        day4 = [calendar dateBySettingHour:19 minute:00 second:00 ofDate:day4 options:NSCalendarMatchStrictly];
        
        
        if(day4 && ![day4 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"SignUpViaWeb",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day4;
            localNotification.alertTitle = @"SAVE 50%% off SQUAD TODAY";
            localNotification.alertBody = @"Don’t miss this crazy offer, this week only";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        // End
        
        //Day 5 Notification
        NSDate *day5 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                             value:4
                                            toDate:installationDate
                                           options:0];
        
        day5 = [calendar dateBySettingHour:8 minute:40 second:00 ofDate:day5 options:NSCalendarMatchStrictly];
        
        
        if(day5 && ![day5 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"activityTracker",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day5;
            localNotification.alertTitle = @"FITBIT or I-WATCH CONNECT";
            localNotification.alertBody = @"Do you have a Fitbit, I-watch or garmin watch. Link your watch and stay motivated and accountable with squad girls from around the world";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        
        day5 = [calendar dateBySettingHour:15 minute:10 second:00 ofDate:day5 options:NSCalendarMatchStrictly];
        
        
        if(day5 && ![day5 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"SignUpViaWeb",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day5;
            localNotification.alertTitle = @"Just 2 Days left of your FREE TRIAL";
            localNotification.alertBody = @"Get 50%% off Squad TODAY";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        //Day 6 Notification
        NSDate *day6 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                             value:5
                                            toDate:installationDate
                                           options:0];
        
        day6 = [calendar dateBySettingHour:8 minute:00 second:00 ofDate:day6 options:NSCalendarMatchStrictly];
        
        
        if(day6 && ![day6 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"WorldForum",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day6;
            localNotification.alertTitle = @"24/7 SQUAD COMMUNITY";
            localNotification.alertBody = @"Hey Hey Hey. Did you know Squad has a 24/7 members only community to keep you accountable and motivated?";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        
        day6 = [calendar dateBySettingHour:13 minute:00 second:00 ofDate:day6 options:NSCalendarMatchStrictly];
        
        
        if(day6 && ![day6 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"SignUpViaWeb",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day6;
            localNotification.alertTitle = @"48 HOURS LEFT";
            localNotification.alertBody = @"We told you squad was like no other fitness program on Earth!   There’s only 48 hours to lock in your special membership discount. Join us and transform your health today";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        
        //End
        
        
        //Day 7 Notification
        NSDate *day7 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                             value:6
                                            toDate:installationDate
                                           options:0];
        
        day7 = [calendar dateBySettingHour:10 minute:00 second:00 ofDate:day7 options:NSCalendarMatchStrictly];
        
        
        if(day7 && ![day7 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"squadDaily",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day7;
            localNotification.alertTitle = @"20 Minute Sessions?";
            localNotification.alertBody = @"Don’t have a free hour to train? No worries… Squad TURBO 20 sessions are designed to get max results in just 20mins. Try one today";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        
        day7 = [calendar dateBySettingHour:18 minute:00 second:00 ofDate:day7 options:NSCalendarMatchStrictly];
        
        
        if(day7 && ![day7 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"SignUp",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day7;
            localNotification.alertTitle = @"LAST CHANCE TO JOIN";
            localNotification.alertBody = @"Thank you so much for trialling SQUAD. We hope you’ve been motivated, educated and inspired a little (or hopefully a LOT) this week. We hope to see you on the forum tomorrow.";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        //Day 8 Notification
        NSDate *day8 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                             value:7
                                            toDate:installationDate
                                           options:0];
        
        day8 = [calendar dateBySettingHour:9 minute:00 second:00 ofDate:day8 options:NSCalendarMatchStrictly];
        
        
        if(day8 && ![day8 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"SignUpViaWeb",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day8;
            localNotification.alertTitle = @"DON’T LEAVE US…";
            localNotification.alertBody = @"We miss you already… Don’t leave us! This is officially your last chance to Save big, when you join the world's most holistic fitness and weight loss community. Join us today";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        
        //Day 9 Notification
        NSDate *day9 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                             value:8
                                            toDate:installationDate
                                           options:0];
        
        day9 = [calendar dateBySettingHour:12 minute:00 second:00 ofDate:day9 options:NSCalendarMatchStrictly];
        
        
        if(day9 && ![day9 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"Survey",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day9;
            localNotification.alertTitle = @"FEEDBACK WANTED";
            localNotification.alertBody = @"Please spare 2 minutes of your time to tell us about your Squad experience. You could win an entire year of membership.";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        
        //Day 11 Notification
        NSDate *day11 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                              value:10
                                             toDate:installationDate
                                            options:0];
        
        day11 = [calendar dateBySettingHour:07 minute:30 second:00 ofDate:day11 options:NSCalendarMatchStrictly];
        
        
        if(day11 && ![day11 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"squadDaily",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day11;
            localNotification.alertTitle = @"Should you workout today?";
            localNotification.alertBody = @"YES, YES, YES!";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        //Day 15 Notification
        NSDate *day15 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                              value:14
                                             toDate:installationDate
                                            options:0];
        
        day15 = [calendar dateBySettingHour:9 minute:00 second:00 ofDate:day15 options:NSCalendarMatchStrictly];
        
        
        if(day15 && ![day15 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"squadDaily",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day15;
            localNotification.alertTitle = @"Spare 20mins?";
            localNotification.alertBody = @"Why not do a session?";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        //Day 22 Notification
        NSDate *day22 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                              value:21
                                             toDate:installationDate
                                            options:0];
        
        day22 = [calendar dateBySettingHour:7 minute:00 second:00 ofDate:day22 options:NSCalendarMatchStrictly];
        
        
        if(day22 && ![day22 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"SignUpViaWeb",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day22;
            localNotification.alertTitle = @"Sick of not getting results?";
            localNotification.alertBody = @"Look and feel your best with the number 1 weight loss program on the planet.";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        //Day 29 Notification
        NSDate *day29 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                              value:28
                                             toDate:installationDate
                                            options:0];
        
        day29 = [calendar dateBySettingHour:8 minute:00 second:00 ofDate:day29 options:NSCalendarMatchStrictly];
        
        
        if(day29 && ![day29 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"session_list",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day29;
            localNotification.alertTitle = @"Feeling tired and sore?";
            localNotification.alertBody = @"How bout a quick yoga session to relieve that pain.";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        //Day 36 Notification
        NSDate *day36 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                              value:35
                                             toDate:installationDate
                                            options:0];
        
        day36 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day36 options:NSCalendarMatchStrictly];
        
        
        if(day36 && ![day36 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"setProgram",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day36;
            localNotification.alertTitle = @"Results are made in the kitchen";
            localNotification.alertBody = @"Does your diet need a shake up? Try a program today.";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        //Day 43 Notification
        NSDate *day43 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                              value:42
                                             toDate:installationDate
                                            options:0];
        
        day43 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day43 options:NSCalendarMatchStrictly];
        
        
        if(day43 && ![day43 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"circuitTimer",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day43;
            localNotification.alertTitle = @"Workout NOW";
            localNotification.alertBody = @"Pick 4 exercises and timer them with our cool circuit timer now.";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        //Day 50 Notification
        NSDate *day50 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                              value:49
                                             toDate:installationDate
                                            options:0];
        
        day50 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day50 options:NSCalendarMatchStrictly];
        
        
        if(day50 && ![day50 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"KETO",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day50;
            localNotification.alertTitle = @"Drop fat fast with Keto!";
            localNotification.alertBody = @"Can a bacon and egg cheeseburger really help you lose weight?";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        //Day 57 Notification
        NSDate *day57 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                              value:56
                                             toDate:installationDate
                                            options:0];
        
        day57 = [calendar dateBySettingHour:8 minute:00 second:00 ofDate:day57 options:NSCalendarMatchStrictly];
        
        
        if(day57 && ![day57 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"squadDaily",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day57;
            localNotification.alertTitle = @"Sweat is fat Crying..";
            localNotification.alertBody = @"Don’t skip today’s daily workout";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        //Day 64 Notification
        NSDate *day64 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                              value:63
                                             toDate:installationDate
                                            options:0];
        
        day64 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day64 options:NSCalendarMatchStrictly];
        
        
        if(day64 && ![day64 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"SignUpViaWeb",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day64;
            localNotification.alertTitle = @"Sick of not getting results?";
            localNotification.alertBody = @"Look and feel your best with the number 1 weight loss program on the planet";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        //Day 71 Notification
        NSDate *day71 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                              value:70
                                             toDate:installationDate
                                            options:0];
        
        day71 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day71 options:NSCalendarMatchStrictly];
        
        
        if(day71 && ![day71 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"activityTracker",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day71;
            localNotification.alertTitle = @"Do you have a fitbit or iwatch?";
            localNotification.alertBody = @"Link it and compete with your squad.";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        
        //Day 78 Notification
        NSDate *day78 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                              value:77
                                             toDate:installationDate
                                            options:0];
        
        day78 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day78 options:NSCalendarMatchStrictly];
        
        
        if(day78 && ![day78 isEarlierThan:currentDate]){
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"SignUpViaWeb",@"pushTo",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = day78;
            localNotification.alertTitle = @"Results are made in the kitchen";
            localNotification.alertBody = @"Does your diet need a shake up?";
            //localNotification.alertAction = @"Check Now";
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            //    [localNotification setRepeatInterval:];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Free User Notification --> \n%@",localNotification);
        }
        
        //End
        [defaults setBool:YES forKey:@"scheduleFreeUserNotification"];
        
    }
    
    
}// AY 19022018
+(void)scheduleLocalNotificationsForFreeWorkoutUser{
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *installationDate = [NSDate date];
    
    //NSLog(@"Trial Date:%@",[format stringFromDate:installationDate]);
    
    //Day 1 Notification
    NSDate *day1;
    if([installationDate isToday]){
        day1 =  [calendar dateByAddingUnit:NSCalendarUnitMinute
                                     value:60
                                    toDate:[NSDate date]
                                   options:0];
    }else{
        day1 =  [calendar dateByAddingUnit:NSCalendarUnitMinute
                                     value:60
                                    toDate:installationDate
                                   options:0];
    }
    
    NSDate *currentDate = [NSDate date];
    
    if(day1 && ![day1 isEarlierThan:currentDate]){
        
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"squadDaily",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day1;
        localNotification.alertTitle = @"DAY 1";
        localNotification.alertBody = @"Squad Daily Workouts are THE BEST. Give one a try, you will LOVE IT!";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //    [localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    
    //End
    
    
    
    //Day 2 Notification
    NSDate *day2 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                         value:1
                                        toDate:installationDate
                                       options:0];
    
    day2 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day2 options:NSCalendarMatchStrictly];
    
    
    if(day2 && ![day2 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"squadDaily",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day2;
        localNotification.alertTitle = @"20 Minute sessions?";
        localNotification.alertBody = @"Don’t have a free hour to train? No worries… Squad TURBO 20 sessions are designed to get max results in just 20mins. Try one today";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //    [localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    
    
    //End
    //Day 3 Notification
    NSDate *day3 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                         value:2
                                        toDate:installationDate
                                       options:0];
    
    day3 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day3 options:NSCalendarMatchStrictly];
    
    
    if(day3 && ![day3 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"session_list",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day3;
        localNotification.alertTitle = @"Pilates, Yoga, HIIT and More!!";
        localNotification.alertBody = @"Did you know there are over 1500 different sessions in Squad? Find the session for you.";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //    [localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 4 Notification
    NSDate *day4 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                         value:3
                                        toDate:installationDate
                                       options:0];
    
    day4 = [calendar dateBySettingHour:16 minute:45 second:00 ofDate:day4 options:NSCalendarMatchStrictly];
    
    
    if(day4 && ![day4 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"circuitTimer",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day4;
        localNotification.alertTitle = @"QUICK CIRCUITS, QUICK RESULTs";
        localNotification.alertBody = @"Create a circuit in seconds. Use our amazing circuit timer.";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //    [localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 5 Notification
    NSDate *day5 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                         value:4
                                        toDate:installationDate
                                       options:0];
    
    day5 = [calendar dateBySettingHour:8 minute:40 second:00 ofDate:day5 options:NSCalendarMatchStrictly];
    
    
    if(day5 && ![day5 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"WorldForum",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day5;
        localNotification.alertTitle = @"Come say Hi!";
        localNotification.alertBody = @"Did you know Squad has a 24/7 members only community to keep you accountable and motivated?";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //    [localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 6 Notification
    NSDate *day6 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                         value:5
                                        toDate:installationDate
                                       options:0];
    
    day6 = [calendar dateBySettingHour:8 minute:00 second:00 ofDate:day6 options:NSCalendarMatchStrictly];
    
    
    if(day6 && ![day6 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"features",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day6;
        localNotification.alertTitle = @"More Features, More Results";
        localNotification.alertBody = @"Learn how to get the most from your Workouts. Watch our Help vids";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //    [localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 7 Notification
    NSDate *day7 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                         value:6
                                        toDate:installationDate
                                       options:0];
    
    day7 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day7 options:NSCalendarMatchStrictly];
    
    
    if(day7 && ![day7 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"activityTracker",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day7;
        localNotification.alertTitle = @"Do you have a fitbit or iwatch?";
        localNotification.alertBody = @"Link it and compete with your squad";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //    [localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 8 Notification
    NSDate *day8 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                         value:7
                                        toDate:installationDate
                                       options:0];
    
    day8 = [calendar dateBySettingHour:10 minute:00 second:00 ofDate:day8 options:NSCalendarMatchStrictly];
    
    
    if(day8 && ![day8 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"SignUpViaWeb",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day8;
        localNotification.alertTitle = @"Ready to TRANSFORM your body?";
        localNotification.alertBody = @"Up to 50%% off our already low membership rates. Get full access TODAY";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //    [localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 9 Notification
    NSDate *day9 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                         value:8
                                        toDate:installationDate
                                       options:0];
    
    day9 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day9 options:NSCalendarMatchStrictly];
    
    
    if(day9 && ![day9 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"squadDaily",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day9;
        localNotification.alertTitle = @"Should you workout today?";
        localNotification.alertBody = @"YES, YES, YES!";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //    [localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 15 Notification
    NSDate *day15 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                          value:14
                                         toDate:installationDate
                                        options:0];
    
    day15 = [calendar dateBySettingHour:9 minute:00 second:00 ofDate:day15 options:NSCalendarMatchStrictly];
    
    
    if(day15 && ![day15 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"squadDaily",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day15;
        localNotification.alertTitle = @"Spare 20mins?";
        localNotification.alertBody = @"Why not do a session?";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //    [localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 22 Notification
    NSDate *day22 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                          value:21
                                         toDate:installationDate
                                        options:0];
    
    day22 = [calendar dateBySettingHour:7 minute:00 second:00 ofDate:day22 options:NSCalendarMatchStrictly];
    
    
    if(day22 && ![day22 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"SignUpViaWeb",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day22;
        localNotification.alertTitle = @"Sick of not getting results?";
        localNotification.alertBody = @"Look and feel your best with the number 1 weight loss program on the planet";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //[localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 29 Notification
    NSDate *day29 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                          value:28
                                         toDate:installationDate
                                        options:0];
    
    day29 = [calendar dateBySettingHour:8 minute:00 second:00 ofDate:day29 options:NSCalendarMatchStrictly];
    
    
    if(day29 && ![day29 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"session_list",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day29;
        localNotification.alertTitle = @"Feeling tired and sore?";
        localNotification.alertBody = @"How about a quick yoga session to relieve that pain";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //[localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 36 Notification
    NSDate *day36 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                          value:35
                                         toDate:installationDate
                                        options:0];
    
    day36 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day36 options:NSCalendarMatchStrictly];
    
    
    if(day36 && ![day36 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"setProgram",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day36;
        localNotification.alertTitle = @"Results are made in the kitchen";
        localNotification.alertBody = @"Does your diet need a shake up? Try a program today";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //[localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 43 Notification
    NSDate *day43 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                          value:42
                                         toDate:installationDate
                                        options:0];
    
    day43 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day43 options:NSCalendarMatchStrictly];
    
    
    if(day43 && ![day43 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"circuitTimer",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day43;
        localNotification.alertTitle = @"Workout NOW";
        localNotification.alertBody = @"Pick 4 exercises and timer them with our cool circuit timer now";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //[localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 50 Notification
    NSDate *day50 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                          value:49
                                         toDate:installationDate
                                        options:0];
    
    day50 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day50 options:NSCalendarMatchStrictly];
    
    
    if(day50 && ![day50 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"KETO",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day50;
        localNotification.alertTitle = @"Drop fat fast with Keto!";
        localNotification.alertBody = @"Can a bacon and egg cheeseburger really help you lose weight?";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //[localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 57 Notification
    NSDate *day57 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                          value:56
                                         toDate:installationDate
                                        options:0];
    
    day57 = [calendar dateBySettingHour:8 minute:00 second:00 ofDate:day57 options:NSCalendarMatchStrictly];
    
    
    if(day57 && ![day57 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"squadDaily",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day57;
        localNotification.alertTitle = @"Sweat is fat Crying..";
        localNotification.alertBody = @"Don’t skip today’s daily workout";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //[localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 64 Notification
    NSDate *day64 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                          value:63
                                         toDate:installationDate
                                        options:0];
    
    day64 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day64 options:NSCalendarMatchStrictly];
    
    
    if(day64 && ![day64 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"SignUpViaWeb",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day64;
        localNotification.alertTitle = @"Sick of not getting results?";
        localNotification.alertBody = @"Look and feel your best with the number 1 weight loss program on the planet";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //[localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 71 Notification
    NSDate *day71 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                          value:70
                                         toDate:installationDate
                                        options:0];
    
    day71 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day71 options:NSCalendarMatchStrictly];
    
    
    if(day71 && ![day71 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"activityTracker",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day71;
        localNotification.alertTitle = @"Do you have a fitbit or iwatch?";
        localNotification.alertBody = @"Link it and compete with your squad";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //[localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    //Day 78 Notification
    NSDate *day78 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                          value:77
                                         toDate:installationDate
                                        options:0];
    
    day78 = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:day78 options:NSCalendarMatchStrictly];
    
    
    if(day78 && ![day78 isEarlierThan:currentDate]){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"freeUser", @"notificationType",@"SignUpViaWeb",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day78;
        localNotification.alertTitle = @"Results are made in the kitchen";
        localNotification.alertBody = @"Does your diet need a shake up?";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //[localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Free User Notification --> \n%@",localNotification);
    }
    //End
    
    [defaults setBool:YES forKey:@"scheduleFreeUserNotification"];
    
}

+(void)scheduleLocalNotificationsForQuote:(BOOL)isInitial{
    
    if(![defaults boolForKey:@"QuoteNotification"]) return;
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"DDD"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    
    
    
    NSDate *quoteStartDate = [NSDate date];
    
    if(![Utility isEmptyCheck:[defaults objectForKey:@"QuoteStartDate"]]){
        quoteStartDate = [defaults objectForKey:@"QuoteStartDate"];
    }else{
        [defaults setObject:quoteStartDate forKey:@"QuoteStartDate"];
    }
    
    NSDate *triggerDate;
    int currentDayInYear;
    
    if([quoteStartDate isToday] && isInitial){
        triggerDate =  [calendar dateByAddingUnit:NSCalendarUnitMinute
                                            value:60
                                           toDate:[NSDate date]
                                          options:0];
        
        currentDayInYear = [[dateFormatter stringFromDate:quoteStartDate] intValue];
        [self setQuoteNotiWithDate:triggerDate dayInCalendar:currentDayInYear];
        
        for(int i=1;i<=21;i++){
            triggerDate =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                                value:i
                                               toDate:currentDate
                                              options:0];
            
            triggerDate = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:triggerDate options:NSCalendarMatchStrictly];
            
            NSLog(@"Trigger Date:%@",triggerDate);
            
            currentDayInYear = [[dateFormatter stringFromDate:currentDate] intValue]+i;
            [self setQuoteNotiWithDate:triggerDate dayInCalendar:currentDayInYear];
        }
        
        
    }else{
        currentDayInYear = [[dateFormatter stringFromDate:currentDate] intValue]+1;
        triggerDate =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                            value:1
                                           toDate:currentDate
                                          options:0];
        
        triggerDate = [calendar dateBySettingHour:7 minute:30 second:00 ofDate:triggerDate options:NSCalendarMatchStrictly];
        
        if(![self isQuoteExistForDate:triggerDate]){
            [self setQuoteNotiWithDate:triggerDate dayInCalendar:currentDayInYear];
        }
    }
    
    
    if(isInitial){
        [defaults setBool:YES forKey:@"isInitialQuoteSet"];
    }
    
}

+(void)setQuoteNotiWithDate:(NSDate *)triggerDate dayInCalendar:(int)currentDayInYear{
    NSArray *quoteArray = [Utility getQuoteListFromJSON];
    NSDate *currentDate = [NSDate date];
    
    if(currentDayInYear>365){
        currentDayInYear = 1;
    }
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"number == %d",currentDayInYear];
    
    NSArray *filteredQuoteArray = [[quoteArray filteredArrayUsingPredicate:predicate] mutableCopy];
    
    if(![Utility isEmptyCheck:filteredQuoteArray] && filteredQuoteArray.count>0){
        
        NSDictionary *dict = filteredQuoteArray[0];
        NSString *quote = !([Utility isEmptyCheck:dict[@"QUOTE"]])?[dict[@"QUOTE"] uppercaseString]:@"";
        
        if(quote.length>20){
            quote = [@"" stringByAppendingFormat:@"%@.....Read More",[quote substringToIndex:20]];
        }
        
        //NSString *credit = !([Utility isEmptyCheck:dict[@"Credit"]])?[dict[@"Credit"] uppercaseString]:@"-UNKNOWN-";
        
        if(triggerDate && ![triggerDate isEarlierThan:currentDate]){
            
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"quote", @"notificationType",@"QuoteController",@"pushTo",dict,@"quoteDict",nil];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = triggerDate;
            localNotification.alertTitle = @"Quote";
            localNotification.alertBody = [@"" stringByAppendingFormat:@"%@",quote]; //[@"" stringByAppendingFormat:@"\"%@\" - %@",quote,credit]
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            localNotification.soundName = @"Notification.caf";
            [localNotification setUserInfo:userInfo];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Quote Notification --> \n%@",localNotification);
        }
        
    }
}

+(BOOL)isQuoteExistForDate:(NSDate *)date{
    
    BOOL isExist = NO;
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    if(notifications && notifications.count>0){
        for(UILocalNotification *notification in notifications){
            NSDictionary *dict = notification.userInfo;
            
            if(![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"notificationType"]] && [[dict objectForKey:@"notificationType"] isEqualToString:@"quote"]){
                
                if([notification.fireDate isSameDay:date]){
                    isExist = YES;
                    break;
                }
            }
            
        }
    }
    
    return isExist;
    
}// AY 19022018
#pragma mark - End
#pragma mark -ApiCall
-(void)friendRequestAccept:(NSNumber *)habitId controller:(UIViewController *)controller{
    
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:controller];
        });
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:habitId forKey:@"Id"];
        
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:controller haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"FriendRequestAccept" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  if (self->contentView) {
                                                                      [self->contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      NSLog(@"responseDict: \n %@",responseDict);
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          
                                                                          //[Utility msg:@"Friend Request Accepted" title:@"\n" controller:controller haveToPop:NO];
                                                                          
                                                                          MyBuddiesListViewController *con = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyBuddiesListView"];
                                                                          
                                                                          [controller.navigationController pushViewController:con animated:YES];
                                                                          
                                                                      }
                                                                      else{
                                                                          //[Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:(UIViewController *)controller haveToPop:NO];
                                                                          return;
                                                                      }
                                                                  }else{
                                                                      [Utility msg:error.localizedDescription title:@"Error !" controller:controller haveToPop:NO];
                                                                  }
                                                              });
                                                              
                                                          }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:controller haveToPop:NO];
    }
    
}
+(void)sendDeviceToken{
    //AppDelegate *appDelegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
    NSString *deviceToken = [defaults objectForKey:@"deviceToken"];
    if (Utility.reachable) {
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"User_id"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        if (![Utility isEmptyCheck:deviceToken])[mainDict setObject:deviceToken forKey:@"Ios_device_id"];
        if(![Utility isEmptyCheck:[FIRMessaging messaging].FCMToken]){
            [mainDict setObject:[FIRMessaging messaging].FCMToken forKey:@"FirebaseIOStoken"];
        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"InitializeUserNotificationApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             if(error == nil)
                                                             {
                                                                 NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                 
                                                                 NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                 if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                     //                                                                         NSString *iosDeviceID = [responseDict valueForKey:@"IosDeviceID"];
                                                                     NSLog(@"%@",responseDict);
                                                                     //                                                                         if (![Utility isEmptyCheck:iosDeviceID] && [iosDeviceID isEqualToString:appDelegate.token]) {
                                                                     //                                                                             [defaults setBool:YES forKey:@"IsTokenSaved"];
                                                                     //                                                                         }
                                                                     
                                                                 }
                                                             }else{
                                                                 NSLog(@"%@",error.localizedDescription);
                                                             }
                                                         }];
        [dataTask resume];
        
    }
    
}

- (void)logoutApi {
    if (Utility.reachable) {
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            //[Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"LogOutApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 
                                                                 [Utility logoutChatSdk];
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     [defaults removeObjectForKey:@"TempTrialEndDate"];
                                                                     [defaults setBool:NO forKey:@"isOffline"]; // AY 27022018 (For Offline)
                                                                     [defaults setBool:NO forKey:@"isSquadLite"];
                                                                     [defaults setBool:NO forKey:@"IsNonSubscribedUser"];
                                                                     [defaults setBool:NO forKey:@"isInitialNotiSet"];
                                                                     [defaults setBool:NO forKey:@"isInitialQuoteSet"];//Quote
                                                                     
                                                                     
                                                                     if([responseString boolValue]) {
                                                                         
                                                                         [defaults setObject:nil forKey:@"taskListArray"];
                                                                         
                                                                         
                                                                         //[defaults setObject:nil forKey:@"healthDataSyncDate"];
                                                                         [defaults setObject:nil forKey:@"NonSubscribedUserData"];
                                                                         [defaults setObject:nil forKey:@"LoginData"];
                                                                         [defaults setObject:nil forKey:@"UserID"];
                                                                         [defaults setObject:nil forKey:@"UserSessionID"];
                                                                         [defaults setObject:nil forKey:@"PresenterList"];
                                                                         //[defaults setObject:nil forKey:@"Email"];
                                                                         //[defaults setObject:nil forKey:@"Password"];
                                                                         [defaults setObject:nil forKey:@"ABBBCOnlineUserId"];
                                                                         [defaults setObject:nil forKey:@"ABBBCOnlineUserSessionId"];
                                                                         
                                                                         [defaults setObject:nil forKey:@"FbWorldForumUrl"];
                                                                         [defaults setObject:nil forKey:@"FbCityForumUrl"];
                                                                         [defaults setObject:nil forKey:@"FbSuburbForumUrl"];
                                                                         
                                                                         [defaults setBool:NO forKey:@"isVisionGoalExpanded"];
                                                                         
                                                                         //su
                                                                         
                                                                         [defaults setObject:nil forKey:@"rightSelectedPic"];
                                                                         [defaults setObject:nil forKey:@"leftSelectedPic"];
                                                                         [defaults setObject:nil forKey:@"BadgeImageText"];
                                                                         
                                                                         
                                                                         [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"UserID"];
                                                                         [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"UserSessionID"];
                                                                         [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"ABBBCOnlineUserId"];
                                                                         [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"ABBBCOnlineUserSessionId"];
                                                                         
                                                                         
                                                                     }else{
                                                                         //                                                                         [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                                                                         
                                                                     }
                                                                     
                                                                 }else{
                                                                     //[Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        //[Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
+(void)updateTrialStartDate{
    //AppDelegate *appDelegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
    
    if (Utility.reachable) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *trialDate = [formatter stringFromDate:[NSDate date]];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:trialDate forKey:@"TrialDate"];
        [mainDict setObject:[NSNumber numberWithInt:2] forKey:@"AppTypeCode"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateTrialDate" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             if(error == nil)
                                                             {
                                                                 NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                 
                                                                 NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                 if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                     //                                                                         NSString *iosDeviceID = [responseDict valueForKey:@"IosDeviceID"];
                                                                     NSLog(@"%@",responseDict);
                                                                     
                                                                 }
                                                             }else{
                                                                 NSLog(@"%@",error.localizedDescription);
                                                             }
                                                         }];
        [dataTask resume];
        
    }
    
}
-(void)registerNonsubscribedUser:(NSDictionary *)userDataDict withNavigation:(NavigationViewController *)nav{
    if (Utility.reachable) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:nav];
        });
        
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:userDataDict forKey:@"RegistrationDetails"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithBool:1] forKey:@"skipPaidUserCheck"];
        
        NSTimeZone *myTimeZone = [NSTimeZone systemTimeZone];
        NSString *timezoneName = myTimeZone.name;
        NSString *offset = myTimeZone.abbreviation;
        [mainDict setObject:timezoneName forKey:@"TimezoneName"];
        [mainDict setObject:offset forKey:@"GMTOffset"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            //[Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"RegisterFreeMbhqUser" append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if ([[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                             
                                                                             [self updateUserData:userDataDict responseData:responseDictionary withNavigation:nav];
                                                                             
                                                                         }else{
                                                                             BOOL HasTrialExpired = [responseDictionary[@"HasTrialExpired"] boolValue];
                                                                             
                                                                             if(HasTrialExpired){
                                                                                 [defaults setBool:HasTrialExpired forKey:@"HasTrialAvail"];
                                                                                 [self updateUserData:userDataDict responseData:responseDictionary withNavigation:nav];
                                                                             }else{
                                                                                 [self goToInitialPageWithNavigation:nav];
                                                                                 return;
                                                                             }
                                                                         }
                                                                     }else{
                                                                         [self goToInitialPageWithNavigation:nav];
                                                                         //[Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                         return;
                                                                         
                                                                     }
                                                                 }
                                                                 
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        [self goToInitialPageWithNavigation:nav];
        //[Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
-(void)updateUserData:(NSDictionary *)userDataDict responseData:(NSDictionary *)responseDictionary withNavigation:(NavigationViewController *)nav{
    
    [defaults setBool:true forKey:@"IsNonSubscribedUser"];
    
    NSMutableDictionary *updatedUserDict = [[NSMutableDictionary alloc]initWithDictionary:userDataDict];
    //    [updatedUserDict setObject:@"" forKey:@"Password"];
    [updatedUserDict setObject:userDataDict[@"Password"] forKey:@"Password"];//13/12
    
    if (![Utility isEmptyCheck:userDataDict[@"TempTrialEndDate"]]) {
        [defaults setObject:userDataDict[@"TempTrialEndDate"] forKey:@"TempTrialEndDate"];
    }
    
    [defaults setObject:updatedUserDict forKey:@"NonSubscribedUserData"];
    [defaults setObject:[userDataDict valueForKey:@"Email"] forKey:@"Email"];
    //    [defaults setObject:@"" forKey:@"Password"];
    [defaults setObject:userDataDict[@"Password"] forKey:@"Password"];//13/12
    [defaults setObject:[responseDictionary valueForKey:@"SquadUserId"] forKey:@"UserID"];
    [defaults setObject:[responseDictionary valueForKey:@"NonSubscribedUserSessionId"] forKey:@"UserSessionID"];
    [defaults setObject:[responseDictionary valueForKey:@"AbbbcUserId"] forKey:@"ABBBCOnlineUserId"];
    [defaults setObject:[responseDictionary valueForKey:@"AbbbcUserSessionId"] forKey:@"ABBBCOnlineUserSessionId"];
    [defaults setObject:[userDataDict valueForKey:@"FirstName"] forKey:@"FirstName"];
    [defaults setObject:[userDataDict valueForKey:@"LastName"] forKey:@"LastName"];//add24
    NSString *trialStartDate;
    
    BOOL HasTrialStarted = false;
    if(![Utility isEmptyCheck:responseDictionary[@"TrialStartDate"]]){
        
        HasTrialStarted = true;
        trialStartDate = responseDictionary[@"TrialStartDate"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSDate *trialDate = [formatter dateFromString:trialStartDate];
        
        if(trialDate && HasTrialStarted){
            [defaults setObject:trialDate forKey:@"TrialStartDate"];
        }else{
            NSDate *prv7Day = [[NSDate date] dateByAddingDays:-8];
            [defaults setObject:prv7Day forKey:@"TrialStartDate"];
        }
        
    }else{
        NSDate *prv7Day = [[NSDate date] dateByAddingDays:-8];
        [defaults setObject:prv7Day forKey:@"TrialStartDate"];
    }
    
    [Utility cancelscheduleLocalNotificationsForFreeUser];
    
    if(HasTrialStarted){
        [defaults setBool:YES forKey:@"CompletedStartupChecklist"]; //AmitY
        [defaults setBool:YES forKey:@"HasTrialAvail"];
    }
    
    [defaults synchronize];
    [self goToInitialPageWithNavigation:nav];
    
}
-(void)goToInitialPageWithNavigation:(NavigationViewController *)nav{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InitialViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"InitialView"];
    controller.isShowTrialInfoView = true;
    [nav pushViewController:controller animated:NO];
}

#pragma mark - End

#pragma mark - SFSafariDelegate
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    NSLog(@"Done Pressed");
}

- (void)safariViewController:(SFSafariViewController *)controller initialLoadDidRedirectToURL:(NSURL *)URL{
    NSLog(@"Redirect TO URL:");
    
}

#pragma mark - End

#pragma mark - private method
- (void)reachabilityChanged:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"didBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadWebinarList" object:nil];
    Reachability* reachability = notification.object;
    if(reachability.currentReachabilityStatus == NotReachable){
        NSLog(@"Internet off");
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"IsGratitudeListReload" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"IsAchievementRealod" object:nil];
        
    }
}

#pragma mark- End
@end

