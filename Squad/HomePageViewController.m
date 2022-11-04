//
//  HomePageViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 06/12/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "HomePageViewController.h"
#import "ConnectViewController.h"
#import "LearnHomeViewController.h"
#import "TrainHomeViewController.h"
#import "TrackViewController.h"
#import "NourishViewController.h"
#import "AppreciateViewController.h"
#import "AchieveHomeViewController.h"
#import "DailyGoodnessViewController.h"
#import "SelectCountyCityViewController.h"
#import "StartTaskTableViewCell.h"
#import "ExerciseDailyListViewController.h"
#import "TrailHomeViewController.h"
#import "CourseDetailsViewController.h"
#import "DietaryPreferenceViewController.h"
#import "MealFrequencyViewController.h"
#import "MealVarietyViewController.h"
#import "MealPlanViewController.h"
#import "ChooseGoalViewController.h"
#import "PreSignUpViewController.h"
#import "SignupWithEmailViewController.h"
#import "RoundListViewController.h"
#import "HomeTableViewCell.h"
#import "HomeTableSectionHeader.h"
#import "HabitHackerFirstViewController.h"
//#import "ICTutorialOverlay.h"
//#import "PersonalChallengeViewController.h"
#import "CustomNavigation.h"

//chayan : import
#import "Utility.h"

@interface HomePageViewController () {
    IBOutlet UIView *notificationSplashView;
    IBOutlet UIButton *notificationSplashOkGotItButton;
    IBOutlet UITextView *notificationSplashTextView;
    IBOutlet UIButton *connectButton;
    IBOutlet UIButton *trainButton;
    IBOutlet UIButton *nourishButton;
    IBOutlet UIButton *learnButton;
    IBOutlet UIButton *achieveButton;
    IBOutlet UIButton *appreciateButton;
    IBOutlet UIButton *trackButton;
    IBOutlet UIButton *loginButton;
    __weak IBOutlet UILabel *userNameLabel;
    IBOutlet UILabel *myProgramLabel;
    IBOutlet UIView *myProgramOverlay;
    
    __weak IBOutlet UIView *freeUserJoinSqaudView;
    __weak IBOutlet UIView *joinSquadBorderView;
    __weak IBOutlet UILabel *joinSquadInfoLabel;
    //ah ov(storyboard)
    IBOutlet UIButton *logoButton;
    IBOutlet UIView *containerView;
    IBOutlet UIView *headerContainerView;
    //Chayan
    IBOutlet UIButton *helpButton;
    
    int apiCount;
    
    UIView *contentView;
    NSArray *unitPreferenceArray;
    NSDictionary *currprogram;

    //AmitY 21-Sep-2017
    __weak IBOutlet UILabel *trialWelcomeLabel;
    IBOutlet UIView *startTaskView;
    IBOutlet UITableView *startTaskTable;
    IBOutlet UIView *taskCompletedView;
    IBOutlet UIView *messageView;
    IBOutlet UIButton *gameOnButton;
    IBOutlet UIView *blankView;
    NSMutableArray *taskListArray;
    BOOL isOnlyFirst;

    __weak IBOutlet UIView *offlineHomePageView; //AY 06032018
    
    
    //// ADDED FOR VIDEO VIEW ////
    
    __weak IBOutlet UIView *videoView;
    IBOutlet UIView *playerView;
    AVPlayer *videoPlayer;
    AVPlayerViewController *playerController;
    __weak IBOutlet UILabel *userNameLabel1;
    __weak IBOutlet UIButton *playerViewButton;
    __weak IBOutlet UISlider *playerProgressView;
    __weak IBOutlet UIButton *playButton;
    __weak IBOutlet UILabel *currentDurationLabel;
    __weak IBOutlet UILabel *totalDurationLabel;
    __weak IBOutlet UIButton *soundButton;
    
    //// END ////
    
   
    
    //Squad Lite and Free
    
    __weak IBOutlet UIView *freeLiteHomePageView; //AY 05062018
    __weak IBOutlet UIView *unlockMoreFeatureView;
    __weak IBOutlet UIImageView *morefeatureImageView;
    
    
    int currentInfoPage;
    
    NSArray *homeListArray;
    IBOutlet UITableView *homeTable;
    IBOutlet UIView *tablefooterViewDetails;
    BOOL isAllShow;
    BOOL isOFflineShow;
    //
    __weak IBOutlet UIView *shoppingView;
    __weak IBOutlet UIView *customShoppingView;
    __weak IBOutlet UIButton *weeklyShoppingButton;
    __weak IBOutlet NSLayoutConstraint *shoppingTopConstraint;
    
    __weak IBOutlet UIView *recipeListView;
    __weak IBOutlet UIButton *recipeListButton;
    __weak IBOutlet UIButton *addRecipeButton;
    __weak IBOutlet NSLayoutConstraint *recipeButtonTopConstraint;
    BOOL isNotificationObserverAdded;
}

@end

@implementation HomePageViewController
@synthesize isMovedToToday;
//ah ov
- (void)viewDidLoad {
    [super viewDidLoad];
    //[defaults setObject:[NSNumber numberWithBool:NO] forKey:@"isSeenWelcomeVid"];
    
    // App split
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"isSeenWelcomeVid"];
    [defaults setBool:YES forKey:@"CompletedStartupChecklist"];
    
    blankView.hidden = false;
    weeklyShoppingButton.layer.borderColor = [Utility colorWithHexString:@"b7b7b7"].CGColor;
    weeklyShoppingButton.layer.borderWidth = 2.0f;
    weeklyShoppingButton.layer.cornerRadius = 10;
    customShoppingView.layer.borderColor = [Utility colorWithHexString:@"b7b7b7"].CGColor;
    customShoppingView.layer.borderWidth = 2.0f;
    customShoppingView.layer.cornerRadius = 10;
    recipeListButton.layer.borderColor = [Utility colorWithHexString:@"b7b7b7"].CGColor;
    recipeListButton.layer.borderWidth = 2.0f;
    recipeListButton.layer.cornerRadius = 10;
    addRecipeButton.layer.borderColor = [Utility colorWithHexString:@"b7b7b7"].CGColor;
    addRecipeButton.layer.borderWidth = 2.0f;
    addRecipeButton.layer.cornerRadius = 10;
    
    [self setmyJoinMyProgramView];
    [self setmyProgramVIew];
    apiCount = 0;
    isOnlyFirst = true;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self getPresenterList];
        
    });
    
    if(![Utility isEmptyCheck:[defaults objectForKey:@"redirection"]]){
        NSDictionary *redirectionDict = [defaults objectForKey:@"redirection"];
        [defaults removeObjectForKey:@"redirection"];
        NSString *type = redirectionDict[@"redirectType"];
        
        if(![Utility isEmptyCheck:type]){
            AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if([type isEqualToString:@"deepLink"]){
                NSDictionary *userInfo = redirectionDict[@"userInfo"];
                if(![Utility isEmptyCheck:userInfo]){
                    [appdelegate redirectionForDeeplinkAndChat:redirectionDict[@"redirectTo"] userInfo:userInfo];
                }else{
                    [appdelegate redirectionForDeeplinkAndChat:redirectionDict[@"redirectTo"] userInfo:nil];
                }
                
            }else if([type isEqualToString:@"chat"]){
                NSDictionary *userInfo = redirectionDict[@"userInfo"];
                if(![Utility isEmptyCheck:userInfo]){
                     [appdelegate redirectionForDeeplinkAndChat:redirectionDict[@"redirectTo"] userInfo:userInfo];
                }
            }else if([type isEqualToString:@"Local Notification"]){
                
                NSDictionary *userInfo = redirectionDict[@"userInfo"];
                
                if(![Utility isEmptyCheck:userInfo]){
                    [appdelegate sendToViewControllerFromLocalNotification:[UIApplication sharedApplication] userInfo:userInfo nav:self.navigationController isShowAlert:NO];
                }else{
                    [appdelegate sendToViewControllerFromLocalNotification:[UIApplication sharedApplication] userInfo:nil nav:self.navigationController isShowAlert:NO];
                }
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[videoPlayer currentItem]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [morefeatureImageView addGestureRecognizer:tapGesture];
    
    //ahd
    if (![defaults boolForKey:@"isAudioDownloaded"]) {
//        Utility *util = [[Utility alloc] init];
        //[util downloadSessionConfiguration];
    }
    
//    [self moveToTodayScreen];
    
}

//chayan
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    // App split
    isMovedToToday = true;
    
    NSLog(@"CurrentProgramName:%@",[defaults objectForKey:@"CurrentProgramName"]);
    if(![Utility isEmptyCheck:[defaults objectForKey:@"CurrentProgramName"]]){
        NSString *programName = [defaults objectForKey:@"CurrentProgramName"];
        myProgramLabel.text = programName;
    }else{
        [self setmyProgramVIew];
    }
    
    
    //if([Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]){
//        [self getProfileDetails];
    //}
    
    
    
    
    shoppingView.hidden = true;
    recipeListView.hidden = true;
    NSString *firstName = [defaults objectForKey:@"FirstName"];
    if(![Utility isEmptyCheck:firstName]){
        userNameLabel.text = [@"" stringByAppendingFormat:@"%@,",firstName];
        userNameLabel1.text = [@"" stringByAppendingFormat:@"%@,",firstName];
        
    }
    
    if(!isNotificationObserverAdded){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offlineModeDetails:) name:@"offlineModeDetails" object:nil];// AY 06032018
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHomePage:) name:@"reloadHomePage" object:nil];// AY 06032018
        
        isNotificationObserverAdded = YES;
    }
    
    
    

    /*if((![Utility isSubscribedUser] && ![Utility isSquadLiteUser]) || [defaults boolForKey:@"IsNonSubscribedUser"]){
        loginButton.hidden = false;
    }else{
        loginButton.hidden = true;
    }*/
    
    if ([Utility isSubscribedUser]) {//today__
        connectButton.alpha = 1.0;
        achieveButton.alpha = 1.0;
        appreciateButton.alpha = 1.0;
        trackButton.alpha = 1.0;
    }else{
        connectButton.alpha = 0.5;
        achieveButton.alpha = 0.5;
        appreciateButton.alpha = 0.5;
        trackButton.alpha = 0.5;

    }
    [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeHome"] boolValue]) {
        [self animateHelp];
    }
    
    
    [self listJsonFileData];
    
    freeLiteHomePageView.hidden = true;
    freeUserJoinSqaudView.hidden = true;
    if(![Utility isSquadLiteUser]){
        if([Utility isSquadFreeUser]){ //|| [defaults boolForKey:@"IsNonSubscribedUser"]
//            blankView.hidden = true;
            //freeLiteHomePageView.hidden = false;
            BOOL isSeenWelcomeVid = [[defaults objectForKey:@"isSeenWelcomeVid"] boolValue];
            if (!isSeenWelcomeVid) {
                [self setupVideoView];
                videoView.hidden = false;
                [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"isSeenWelcomeVid"];
            }else{
                videoView.hidden = true;
            }
            
            BOOL isNotificationEnable = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
            
            if (![defaults boolForKey:@"isSpalshShown"]) { // && [defaults boolForKey:@"HasTrialAvail"]
                if(!isNotificationEnable){
                    notificationSplashView.hidden = false;
                }
            }else{
                notificationSplashView.hidden = true;
                if(!isNotificationEnable )[self promptUserToRegisterPushNotifications]; //&& [defaults boolForKey:@"HasTrialAvail"]
            }
            
        }else{
            
            if([defaults boolForKey:@"IsNonSubscribedUser"]){
                trialWelcomeLabel.hidden = false;
            }else{
                trialWelcomeLabel.hidden = true;
            }
            
            
            
            if(!taskListArray){
                taskListArray = [[NSMutableArray alloc]init];
            }
            taskListArray = [[defaults objectForKey:@"taskListArray"] mutableCopy];
            //BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
            
            //if(![Utility isSubscribedUser]){
            if ([Utility isEmptyCheck:taskListArray]) {
//                [self getStartTaskList];
            }else{
                [self setup_view];
            }
            //}
            
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
//                offlineHomePageView.hidden = false;
                isOFflineShow = true;
            }else{
//                offlineHomePageView.hidden = true;
                isOFflineShow = false;
            }// AY 06032018
            
            
        }
        
    }else{
//        blankView.hidden = true;
        freeLiteHomePageView.hidden = false;
        BOOL isNotificationEnable = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
        
        if (![defaults boolForKey:@"isSpalshShown"]) {
            if(!isNotificationEnable){
                notificationSplashView.hidden = false;
            }
        }else{
            notificationSplashView.hidden = true;
            if(!isNotificationEnable)[self promptUserToRegisterPushNotifications];
        }
    }
    if(isMovedToToday){
        [self moveToTodayScreen];
        
    }
    blankView.hidden = false;
    if ([Utility isOfflineMode]) {
        blankView.hidden = true;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
//    int logoClickCount = [[defaults objectForKey:@"LogoClickCount"] intValue];
//    [defaults setObject:[NSNumber numberWithInt:logoClickCount+1] forKey:@"LogoClickCount"];
//    
//    BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
//    if([defaults boolForKey:@"IsNonSubscribedUser"] && isAllTaskCompleted){
//        int logoClickCount = [[defaults objectForKey:@"LogoClickCount"] intValue];
//        if(logoClickCount>=3){
//            [Utility inAppPromoAlert:self];
//        }
//    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [homeTable setContentInset:UIEdgeInsetsZero];
    [self updateViewConstraints];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"offlineModeDetails" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadHomePage" object:nil];
    isNotificationObserverAdded = NO;
    
    isAllShow = false;
//    isOFflineShow = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - API Call

-(void)getPresenterList{
    
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
           /* apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            if(![Utility isOfflineMode]){
                contentView = [Utility activityIndicatorView:self];
                [self.view bringSubviewToFront:notificationSplashView];
            }*///AY 06032018
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetPresenterListApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 /*apiCount--;
                                                                 if (apiCount == 0 && contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }*/
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         NSArray *presenterArray = [responseDictionary valueForKey:@"Events"];
                                                                         if (![Utility isEmptyCheck:presenterArray] && ![Utility isEmptyCheck:presenterArray]) {
                                                                             NSMutableDictionary *presenterDict1 = [[NSMutableDictionary alloc]init];
                                                                             NSMutableArray *presenterArrayTemp = [[NSMutableArray alloc]init];
                                                                             for (NSDictionary *dict in presenterArray) {
                                                                                 if (![Utility isEmptyCheck:[dict valueForKey:@"ProfilePicture"]] && ![Utility isEmptyCheck:[dict valueForKey:@"EventName"]]) {
                                                                                     [presenterDict1 setObject:[dict valueForKey:@"ProfilePicture"] forKey:[dict valueForKey:@"EventName"]];
                                                                                     
                                                                                 }
                                                                                 NSMutableDictionary *temp = [dict mutableCopy];
                                                                                 if( [[temp valueForKey:@"ProfilePicture"] isKindOfClass:[NSNull class]] )
                                                                                 {
                                                                                     [temp setObject:@"" forKey:@"ProfilePicture"];
                                                                                 }
                                                                                 [presenterArrayTemp addObject:temp];
                                                                             }
                                                                             [defaults setObject:presenterArrayTemp forKey:@"PresenterList"];
                                                                             
                                                                             [defaults setObject:presenterDict1 forKey:@"presenterDict"];
                                                                             
                                                                         }else{
                                                                             [defaults setObject:nil forKey:@"PresenterList"];
                                                                         }

                                                                         
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
        if(![Utility isOfflineMode])[Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];//AY 06032018
    }
}
-(void)getProfileDetails{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            if(![Utility isOfflineMode]){
                //self->contentView = [Utility activityIndicatorView:self];
                //[self.view bringSubviewToFront:notificationSplashView];
            }//AY 06032018

        });
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMbhqUserProfile" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                         NSMutableDictionary *userData =[responseDict mutableCopy];
                                                                         
                                                                         if (![Utility isEmptyCheck:userData]) {
                                                                             for (NSString *key in [userData allKeys]) {
                                                                                 if ([[userData objectForKey:key] class] ==[NSNull class]) {
                                                                                     [userData removeObjectForKey:key];
                                                                                 }
                                                                             }
                                                                         }
                                                                         
                                                                         [defaults setObject:[userData objectForKey:@"UnitPreference"] forKey:@"UnitPreference"];
                                                                         
                                                                         [defaults setObject:[userData objectForKey:@"SelectedTimeZone"] forKey:@"Timezone"];
                                                                         [defaults setObject:[userData objectForKey:@"apply_rounding"] forKey:@"ApplyRounding"];
                                                                         
                                                                         
                                                                         if(![Utility isEmptyCheck:responseDict[@"ProfilePicture"]]){
                                                                             [defaults setObject:responseDict[@"ProfilePicture"]forKey:@"ProfilePicUrl"];
                                                                         }
                                                                         
                                                                         
                                                                         int signupVia = [[responseDict objectForKey:@"SignupVia"] intValue];
                                                                         
                                                                         [defaults setObject:[NSNumber numberWithInt:signupVia] forKey:@"SignupVia"];
                                                                         
                                                                         
                                                                         if(![Utility isEmptyCheck:responseDict[@"ProgramName"]]){
                                                                             
                                                                             NSString *programName = [@"" stringByAppendingFormat:@"%@",responseDict[@"ProgramName"]];
                                                                             self->myProgramLabel.text = programName;
                                                                             
                                                                             [defaults setObject:programName forKey:@"CurrentProgramName"];
                                                                             
                                                                         }else{
                                                                             [defaults setObject:@"" forKey:@"CurrentProgramName"];
                                                                             [self setmyProgramVIew];
                                                                         }
                                                                         
                                                                            

                                                                         
                                                                     }else{
                                                                         NSLog(@"Something is wrong.Please try later.");
                                                                        // [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        if(![Utility isOfflineMode])[Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

-(void)getStartTaskList{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
            [self.view bringSubviewToFront:self->notificationSplashView];
        });
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadWelcomeData" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if(self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         
                                                                         if (![Utility isEmptyCheck:responseDict[@"WelcomeData"]] && ![Utility isEmptyCheck:responseDict[@"WelcomeData"][@"TaskData"]]){
                                                                             
                                                                             self->taskListArray = [responseDict[@"WelcomeData"][@"TaskData"] mutableCopy];
                                                                             [self->startTaskTable reloadData];
                                                                             
                                                                             BOOL isAllTaskCompleted = [responseDict[@"WelcomeData"][@"CompletedStartupChecklist"] boolValue];
                                                                             
                                                                            [defaults setBool:YES forKey:@"CompletedStartupChecklist"]; //AmitY
                                                                             
                                                                              [defaults setObject:self->taskListArray forKey:@"taskListArray"];
                                                                             
                                                                              [self setup_view];
                                                                             
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

-(void)saveStartTaskList:(int)index taskId:(int)taskId{
    
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        
        
        NSMutableDictionary *dict = [[taskListArray objectAtIndex:index] mutableCopy];
        
        [dict setObject:[NSNumber numberWithBool:1] forKey:@"Status"];
        [taskListArray replaceObjectAtIndex:index withObject:dict];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSDictionary *welcomeDict = [[NSDictionary alloc]initWithObjectsAndKeys:taskListArray,@"TaskData", nil];
        [mainDict setObject:welcomeDict forKey:@"WelComeData"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SaveSquadWelcomeData" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         
                                                                         NSMutableDictionary *dict = [[self->taskListArray objectAtIndex:index] mutableCopy];
                                                                         
                                                                         [dict setObject:[NSNumber numberWithBool:1] forKey:@"Status"];
                                                                         [self->taskListArray replaceObjectAtIndex:index withObject:dict];
                                                                         
                                                                         [self->startTaskTable reloadData];
                                                                         
                                                                         BOOL isAllTaskCompleted = [responseDict[@"CompletedStartupChecklist"] boolValue];
                                                                         
                                                                         if(isAllTaskCompleted){
                                                                             
                                                                             [defaults setBool:YES forKey:@"CompletedStartupChecklist"]; //AmitY
                                                                         }
                                                                         [defaults setObject:self->taskListArray forKey:@"taskListArray"];
                                                                         [self startTaskWithIndex:taskId];
                                                                         
                                                                     }
                                                                     else{
                                                                         
                                                                         NSMutableDictionary *dict = [[self->taskListArray objectAtIndex:index] mutableCopy];
                                                                         
                                                                         [dict setObject:[NSNumber numberWithBool:0] forKey:@"Status"];
                                                                         [self->taskListArray replaceObjectAtIndex:index withObject:dict];
                                                                         [defaults setObject:self->taskListArray forKey:@"taskListArray"];
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                     
                                                                 }else{
                                                                     NSMutableDictionary *dict = [[self->taskListArray objectAtIndex:index] mutableCopy];
                                                                     
                                                                     [dict setObject:[NSNumber numberWithBool:0] forKey:@"Status"];
                                                                     [self->taskListArray replaceObjectAtIndex:index withObject:dict];
                                                                     [defaults setObject:self->taskListArray forKey:@"taskListArray"];
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

-(void) checkStepNumberForSetupWithAPI:(NSString *)apiName {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:apiName append:@""forAction:@"POST"];
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
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          
                                                                          [defaults setInteger:[[responseDict objectForKey:@"StepNumber"] intValue] forKey:@"CustomExerciseStepNumber"];
                                                                          
                                                                          switch ([[responseDict objectForKey:@"StepNumber"] intValue]) {
                                                                                  
                                                                              case -1:
                                                                                  //api call
//                                                                                  [self checkStepNumberForSetupWithAPI:@"CheckUserProgramStep"];
                                                                                  break;
                                                                                  
                                                                              case 0:
                                                                              {
                                                                                  //current week
                                                                                  ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
                                                                                  
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 1:
                                                                              {
                                                                                  CustomProgramSetupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomProgramSetup"];
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 2:
                                                                              {
                                                                                  ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 3:
                                                                              {
                                                                                  RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                                  controller.isRateFitness = true;
                                                                                  controller.isWeeklySession = false;
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 4:
                                                                              {
                                                                                  RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                                  controller.isRateFitness = false;
                                                                                  controller.isWeeklySession = false;
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 5:
                                                                              {
                                                                                  RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                                  controller.isRateFitness = false;
                                                                                  controller.isWeeklySession = true;
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 6:
                                                                              {
                                                                                  PersonalSessionsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalSessions"];
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 7:
                                                                              {
                                                                                  MovePersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MovePersonalSession"];
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              default:
                                                                                  break;
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

-(void)webSerViceCall_SquadNutritionSettingStep{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadNutritionSettingStep" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         int stepnumber=[[responseDict objectForKey:@"StepNumber"]intValue];
                                                                         if ((stepnumber != 0 && stepnumber != 6)) {
                                                                             [self goToNutrition:stepnumber];
                                                                         }else{
                                                                             CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
                                                                             controller.isComplete =false;
                                                                             controller.stepnumber = stepnumber;
                                                                             [self.navigationController pushViewController:controller animated:YES];
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
-(void)webSerViceCall_GetSquadCurrentProgram{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadCurrentProgram" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->currprogram=[responseDict objectForKey:@"SquadProgram"];
                                                                     }
                                                                     else{
                                                                         //                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         //return;
                                                                     }
                                                                 }else{
                                                                     //[Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                                 
                                                                 [self webSerViceCall_SquadNutritionSettingStep];
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}


-(void)GetGoalValueListAPI{
    
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self->contentView || ![self->contentView isDescendantOfView:self.view]) {
                //                [contentView removeFromSuperview];
                self->contentView = [Utility activityIndicatorView:self];
            }
            //            contentView = [Utility activityIndicatorView:self];
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetGoalValueListAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   //                                                                 if (contentView) {
                                                                   //                                                                     [contentView removeFromSuperview];
                                                                   //                                                                 }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       
                                                                        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                            
                                                                            NSArray *valuesArray = [responseDictionary objectForKey:@"Details"];
                                                                            AddGoalsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddGoals"];
                                                                            controller.valuesArray = valuesArray;
                                                                            [self.navigationController pushViewController:controller animated:YES];
                                                                            //        [self presentViewController:controller animated:YES completion:nil];
                                                                            
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
-(void)makeUserLogin{
    
    NSString *email = [defaults objectForKey:@"Email"];
    NSString *password = [defaults objectForKey:@"Password"];
    
    if(![Utility isEmptyCheck:email]){
        if (![Utility validateEmail:email]) {
            [Utility msg:@"Please enter a valid email." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        
    }else{
        [Utility msg:@"Please enter your email." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
    if([Utility isEmptyCheck:password]){
        [Utility msg:@"Please enter your password." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
    
    if (Utility.reachable) {
        //[Utility logoutChatSdk];
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
        [mainDict setObject:email forKey:@"EmailAddress"];
        [mainDict setObject:password forKey:@"Password"];
        [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IncludeAbbbcOnline"];
        
        if ([defaults boolForKey:@"IsFbUser"]) {
            if(![Utility isEmptyCheck:[defaults objectForKey:@"facebookTokenString"]]){
                NSString *fbToken =[defaults objectForKey:@"facebookTokenString"];
                [mainDict setObject:fbToken forKey:@"FacebookToken"];
            }
        }
        
        //Added on AY 17042018
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if(![Utility isEmptyCheck:version]){
            [mainDict setObject:version forKey:@"AppVersion"];
        }
        [mainDict setObject:@"ios" forKey:@"AppPlatform"];
        //End
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"LogInApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     
                                                                     
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSMutableDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         for (NSString *key in [responseDictionary allKeys]) {
                                                                             if ([[responseDictionary objectForKey:key] class] ==[NSNull class]) {
                                                                                 [responseDictionary removeObjectForKey:key];
                                                                             }
                                                                         }
                                                                         [defaults setObject:[responseDictionary valueForKey:@"ActiveUntil"] forKey:@"TempTrialEndDate"];
                                                                         [defaults setBool:YES forKey:@"CompletedStartupChecklist"]; //AmitY
                                                                         
                                                                         [defaults setBool:false forKey:@"IsNonSubscribedUser"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"EmailAddress"] forKey:@"Email"];
                                                                         [defaults   setObject:password forKey:@"Password"];
                                                                         [defaults setObject:responseDictionary forKey:@"LoginData"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"UserID"] forKey:@"UserID"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"ABBBCOnlineUserId"] forKey:@"ABBBCOnlineUserId"];
                                                                         
                                                                         if(![Utility isEmptyCheck:responseDictionary[@"ProfilePicUrl"]]){
                                                                             [defaults setObject:responseDictionary[@"ProfilePicUrl"] forKey:@"ProfilePicUrl"];
                                                                         }
                                                                         
                                                                         [defaults setObject:[responseDictionary valueForKey:@"FirstName"] forKey:@"FirstName"];//add24
                                                                         
                                                                         [defaults setObject:[responseDictionary valueForKey:@"LastName"] forKey:@"LastName"];//Added by AY 25042018
                                                                         
                                                                         [defaults setObject:[responseDictionary valueForKey:@"ABBBCOnlineUserSessionId"] forKey:@"ABBBCOnlineUserSessionId"];
                                                                         
                                                                         [defaults setObject:[responseDictionary valueForKey:@"FbWorldForumUrl"] forKey:@"FbWorldForumUrl"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"FbCityForumUrl"] forKey:@"FbCityForumUrl"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"FbSuburbForumUrl"] forKey:@"FbSuburbForumUrl"];
                                                                         
                                                                         NSString *disStat = ([[responseDictionary valueForKey:@"DiscoverableStatus"] boolValue]) ? @"yes" : @"no";
                                                                         [defaults setObject:disStat forKey:@"Discoverable"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"FirebaseToken"] forKey:@"FirebaseToken"];
                                                                         
                                                                         int access_level = [[responseDictionary valueForKey:@"access_level"] intValue];
                                                                         
                                                                         if(access_level == 2){
                                                                             [defaults setBool:true forKey:@"isSquadLite"];
                                                                             [defaults setBool:true forKey:@"CompletedStartupChecklist"];
                                                                         }else{
                                                                             [defaults setBool:false forKey:@"isSquadLite"];
                                                                         }
                                                                         
                                                                         if(![Utility isEmptyCheck:responseDictionary[@"LifeToken"]]){
                                                                             
                                                                             NSMutableDictionary *dict = [NSMutableDictionary new];
                                                                             [dict setObject:responseDictionary[@"LifeToken"] forKey:@"LifeToken"];
                                                                             [dict setObject:[NSDate date] forKey:@"ExpiryDate"];
                                                                             
                                                                             [defaults setObject:dict forKey:@"LifeTokenDetails"];
                                                                             
                                                                         }
                                                                         
                                                                         int signupVia = [[responseDictionary objectForKey:@"SignupMethod"] intValue];
                                                                         
                                                                         [defaults setObject:[NSNumber numberWithInt:signupVia] forKey:@"SignupVia"];
                                                                         
                                                                         [self upgradeButtonPressed:0];
                                                                         
                                                                         
                                                                     }else{
                                                                         
                                                                         
                                                                         if (![Utility isEmptyCheck:responseString]) {
                                                                             [Utility msg:responseString title:@"Error !" controller:self haveToPop:NO];
                                                                         }else{
                                                                             [Utility msg:@"Email or Password is not correct.Please enter correct Email & Password and try again." title:@"Error !" controller:self haveToPop:NO];
                                                                         }
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
#pragma mark - IBAction -
- (IBAction)logInButtonPressed:(id)sender {
    //shabbir fb-10/04/18
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    PreSignUpViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"PreSignUp"];
//    [self.navigationController pushViewController:controller animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)notificationSplashOkGotItButtonPressed:(UIButton  *)sender{
    [defaults setBool:true forKey:@"isSpalshShown"];
    notificationSplashView.hidden = true;
    [self promptUserToRegisterPushNotifications];
    
    int taskId = [sender.accessibilityHint intValue];
    
    if(taskId == 2 || taskId == 4){
         [self saveStartTaskList:(int)sender.tag taskId:taskId];
    }
    
    BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
    if(isAllTaskCompleted && ![Utility isSquadLiteUser] && ![Utility isSquadFreeUser]){
        [gameOnButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    isMovedToToday = true;
    [self moveToTodayScreen];
}
- (IBAction)connectButtonTapped:(id)sender {
    if ([Utility isSubscribedUser] || [Utility isSquadFreeUser] || [Utility isSquadLiteUser]) {
        
        
        

    }else{
        [Utility showSubscribedAlert:self];
    }
    
    
}

- (IBAction)trainButtonTapped:(id)sender {
    TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
    [self.navigationController pushViewController:controller animated:YES];

}

- (IBAction)nourishButtonTapped:(id)sender {
//    if (![Utility isEmptyCheck:unitPreferenceArray]) {
//        DailyGoodnessViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyGoodness"];
//        controller.unitPreferenceArray = unitPreferenceArray;
//        [self.navigationController pushViewController:controller animated:YES];
//    }else{
//        [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
//        return;
//    }
    
    
    NourishViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Nourish"];
    [self.navigationController pushViewController:controller animated:YES];

}

- (IBAction)learnButtonTapped:(id)sender {
    LearnHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LearnHome"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)achieveButtonTapped:(id)sender {
    if ([Utility isSubscribedUser]) {
        AchieveHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AchieveHome"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [Utility showSubscribedAlert:self];
    }
}

- (IBAction)appreciateButtonTapped:(id)sender {
    if ([Utility isSubscribedUser]) {
        AppreciateViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Appreciate"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [Utility showSubscribedAlert:self];
    }
}

- (IBAction)trackButtonTapped:(id)sender {
    if ([Utility isSubscribedUser]) {
        if (![Utility isEmptyCheck:[defaults objectForKey:@"UnitPreference"]]) {
            TrackViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Track"];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
            return;
        }
    }else{
        [Utility showSubscribedAlert:self];
    }
}



//chayan
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)notificationButtonTapped:(id)sender {
    
}


//chayan : questionHelpButtonPressed
- (IBAction)helpButtonPressed:(id)sender {
    
    NSString *urlString=@"https://player.vimeo.com/external/220933773.m3u8?s=04d41e4e04fa8ce700db0f52f247acce968b72e5";
    
    if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeHome"] boolValue]) {
        
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
        NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeHome"];
        [defaults setObject:dict forKey:@"firstTimeHelpDict"];
    }
    else
    {
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
    }
}


- (IBAction)taskButtonPressed:(UIButton *)sender {
    //[self startTaskWithIndex:(int)sender.tag];
    NSMutableDictionary *dict = [[taskListArray objectAtIndex:(int)sender.tag] mutableCopy];
    int taskId =[dict[@"Id"] intValue];
    /*[dict setObject:[NSNumber numberWithBool:1] forKey:@"Status"];
    [taskListArray replaceObjectAtIndex:(int)sender.tag withObject:dict];
    [defaults setObject:taskListArray forKey:@"taskListArray"];
    [startTaskTable reloadData];*/
    
    BOOL currentStatus = [dict[@"Status"] boolValue];
    if(currentStatus){
        if(taskId == 2 || taskId == 4){
            if (![defaults boolForKey:@"isSpalshShown"]) {
                notificationSplashView.hidden = false;
                notificationSplashOkGotItButton.tag = sender.tag;
                notificationSplashOkGotItButton.accessibilityHint = [@"" stringByAppendingFormat:@"%@",[NSNumber numberWithInt:taskId]];
                return;
            }else{
                notificationSplashView.hidden = true;
                BOOL isNotificationEnable = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
                if(!isNotificationEnable)[self promptUserToRegisterPushNotifications];
            }
        }
        [self startTaskWithIndex:taskId];
        return;
    }
    
    NSString *taskName = @"";
    if(taskId == 1){
        taskName = @"Watch Welcome Video";
    }else if(taskId == 2){
        taskName = @"Workout Plan";
    }else if(taskId == 3){
        taskName = @"Try Daily Workout";
    }else if(taskId == 4){
        taskName = @"Nutrition Plan";
    }else if(taskId == 6){
        taskName = @"Browse Recipes";
    }else if(taskId == 7){
        taskName = @"Join World Forum";
    }
    else if(taskId == 9){
        taskName = @"8 Week Challenge";
    }// Added on AY 17042018
    else if(taskId == 11){
        taskName = @"Start a program";
    }
    
    //Added For Firebase Unlock Achievement Tracking AY 21032018
    [FIRAnalytics logEventWithName:@"unlock_achievement" parameters:@{@"achievement_id": taskName }];
    //End
    
    if(![defaults boolForKey:@"IsNonSubscribedUser"] && ![Utility isSubscribedUser] && (taskId == 2 || taskId == 4)){
        if(taskId ==2){
            TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
            [Utility showTrailLoginAlert:self ofType:controller];
            return;
        }else{
            CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
            [Utility showTrailLoginAlert:self ofType:controller];
            return;
        }
        return;
    }else if(taskId == 2 || taskId == 4){
        if (![defaults boolForKey:@"isSpalshShown"]) {
            notificationSplashView.hidden = false;
            notificationSplashOkGotItButton.tag = sender.tag;
            notificationSplashOkGotItButton.accessibilityHint = [@"" stringByAppendingFormat:@"%@",[NSNumber numberWithInt:taskId]];
            return;
        }else{
            notificationSplashView.hidden = true;
            BOOL isNotificationEnable = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
            if(!isNotificationEnable)[self promptUserToRegisterPushNotifications];
        }
        
    }
    //[self startTaskWithIndex:taskId];
    [self saveStartTaskList:(int)sender.tag taskId:[dict[@"Id"] intValue]];
}

- (IBAction)gameOnButtonPressed:(UIButton *)sender {
    taskCompletedView.hidden = true;
    startTaskView.hidden = true;
    
    //            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"InstructionOverlays"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"InstructionOverlays"] isEqual:[NSNull null]]){
    if (![Utility isEmptyCheck:[defaults objectForKey:@"InstructionOverlays"]]) {
        NSMutableArray *insArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"InstructionOverlays"]];
        if (![insArray containsObject:@"Home"]) {
            //[self helpButtonPressed:helpButton];
//            [self showInstructionOverlays];
            [insArray addObject:@"Home"];
            [[NSUserDefaults standardUserDefaults] setObject:insArray forKey:@"InstructionOverlays"];
        }
        
    }else {
        //[self helpButtonPressed:helpButton];
//        [self showInstructionOverlays];
        NSMutableArray *insArray = [[NSMutableArray alloc] init];
        [insArray addObject:@"Home"];
        [[NSUserDefaults standardUserDefaults] setObject:insArray forKey:@"InstructionOverlays"];
    }
}

- (IBAction)customWorkoutButtonPressed:(UIButton *)sender {
    
    int currentStep = [[defaults objectForKey:@"CustomExerciseStepNumber"] intValue];
    
    if([Utility isOfflineMode] && currentStep == 0){
        
        int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
        if(![DBQuery isRowExist:@"customExerciseList" condition:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]]){
            
            [Utility msg:@"You are in OFFLINE mode and custom sessions hasn't been previously downloaded. Please remove offline mode and download this session while you have access to the internet." title:@"Oops!" controller:self haveToPop:NO];
            return;
            
        }// AY 20032018
        
        ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [Utility msg:@"Please go online and complete required steps to access this feature." title:@"Oops!" controller:self haveToPop:NO];
    }
    
    
}//AY 06032018

- (IBAction)dailyWorkoutButtonPressed:(UIButton *)sender {
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    if(![DBQuery isRowExist:@"dailyworkout" condition:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]]){
        
        [Utility msg:@"You are in OFFLINE mode and daily sessions hasn't been previously downloaded. Please remove offline mode and download this session while you have access to the internet." title:@"Oops!" controller:self haveToPop:NO];
        return;
        
    }// AY 20032018
    
    ExerciseDailyListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDailyList"];
    [self.navigationController pushViewController:controller animated:YES];
}//AY 06032018

- (IBAction)playButtonPressed:(UIButton *)sender {
    playerViewButton.hidden = true;
    if(videoPlayer){
        [playButton setSelected:!playButton.isSelected];
        
        if(playButton.isSelected){
            [videoPlayer play];
            if (videoPlayer.rate != 0 && videoPlayer.error == nil) {
                
                
                double interval = .1f;
                
                CMTime playerDuration = videoPlayer.currentItem.duration; // return player duration.
                if (CMTIME_IS_INVALID(playerDuration))
                {
                    return;
                }
                double duration = CMTimeGetSeconds(playerDuration);
                if (isfinite(duration))
                {
                    CGFloat width = CGRectGetWidth([playerProgressView bounds]);
                    interval = 0.5f * duration / width;
                }
                __weak typeof(self) weakSelf = self;
                /* Update the scrubber during normal playback. */
                if (interval > 0) {
                    [videoPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                              queue:NULL
                                                         usingBlock:
                     ^(CMTime time)
                     {
                         //NSLog(@"int %f",interval);
                         [weakSelf syncScrubber];
                     }];
                }
            }
        }else{
            [videoPlayer pause];
        }
    }
}
- (IBAction)soundButtonPressed:(UIButton *)sender {
    soundButton.selected = !soundButton.isSelected;
    videoPlayer.muted = !videoPlayer.isMuted;
}

- (IBAction)watchLaterButtonPressed:(UIButton *)sender {
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"isSeenWelcomeVid"];
    videoView.hidden = true;
    [videoPlayer pause];
    videoPlayer = nil;
    playerController = nil;
    
    if ([defaults boolForKey:@"isFirstTimeForum"] && [Utility isSquadFreeUser]) {
        freeUserJoinSqaudView.hidden = false;
    }
}

- (IBAction)unlockFeatureButtonPressed:(UIButton *)sender {
    unlockMoreFeatureView.hidden = false;
}

- (IBAction)upgradeButtonPressed:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if([Utility isSquadFreeUser]){
        
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
        [self.navigationController pushViewController:signupController animated:YES];
        
    }else if([Utility isSquadLiteUser]){
        int signupVia = [[defaults objectForKey:@"SignupVia"] intValue];
        
        if(signupVia == Web){
            NSDictionary *lifeTokenDetails = [defaults objectForKey:@"LifeTokenDetails"];
            if(![Utility isEmptyCheck:lifeTokenDetails]){
                
                NSString *lifeToken = [lifeTokenDetails objectForKey:@"LifeToken"];
                NSDate *expiryDate = [lifeTokenDetails objectForKey:@"ExpiryDate"];;
                NSLog(@"Hours From: %f",[[NSDate date] hoursFrom:expiryDate]);
                
                if([[NSDate date] hoursFrom:expiryDate] > 22){
                    [self makeUserLogin];
                    return;
                }
                
                NSString *urlStr = [@"" stringByAppendingFormat:@"%@/Members/Member/ExternalUserLogin?token=%@&returnUrl=/event/squadworldupgrade?isSquadLiteToWorld=true&callbackUrl=abbbcsquad://cancelreturn",BASEURL,lifeToken];
                urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                
                //urlStr = @"http://aqbstaging.com/greyquiz/Deeplink.html";
                
                NSURL *url = [NSURL URLWithString:urlStr];
//                if ([[UIApplication sharedApplication] openURL:url]){
//                    NSLog(@"well done");
//                }
                
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                if(appDelegate.safariBrowser){
                    appDelegate.safariBrowser = nil;
                }
                
                appDelegate.safariBrowser = [[SFSafariViewController alloc] initWithURL:url];
                appDelegate.safariBrowser.delegate = appDelegate;
                [self.navigationController presentViewController:appDelegate.safariBrowser animated:YES completion:nil];
            }
            
            return;
            
        }
        
        
        NSMutableDictionary *userDataDict = [[NSMutableDictionary alloc]init];
        [userDataDict setObject:[defaults objectForKey:@"FirstName"] forKey:@"FirstName"];
        [userDataDict setObject:[defaults objectForKey:@"LastName"] forKey:@"LastName"];
        // [userDataDict setObject:mobileTextField.text forKey:@"Mobile"];
        [userDataDict setObject:[defaults objectForKey:@"Email"] forKey:@"Email"];
        [userDataDict setObject:[defaults objectForKey:@"Password"] forKey:@"Password"];
        [userDataDict setObject:[NSNumber numberWithBool:[defaults boolForKey:@"IsFbUser"]] forKey:@"IsFbUser"];
        
       
        
    }
}

- (IBAction)unlockFeatureBackButtonPressed:(UIButton *)sender {
    currentInfoPage = 1;
    NSString *pageImageName = [@"" stringByAppendingFormat:@"squad_page_%d.png",currentInfoPage+1];
    [morefeatureImageView setImage:[UIImage imageNamed:pageImageName]];
    unlockMoreFeatureView.hidden = true;
}
- (IBAction)circuitTimerButtonPressed:(UIButton *)sender {
    RoundListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RoundList"];
    [self.navigationController pushViewController:controller animated:YES];
}//06/08/18

-(IBAction)tableFooterArrowPressed:(id)sender{
    isAllShow  = true;
    [homeTable reloadData];
    [homeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    homeTable.tableFooterView = nil;
    tablefooterViewDetails.hidden = true;
}
-(IBAction)sectionTapped:(UIButton*)sender{
    if(sender.tag != 0 && sender.tag != 3 && [Utility isSquadFreeUser]){
        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }
    
    
    if (sender.tag == 0) { //TRAIN
//        [self trainButtonTapped:nil];
    }else if (sender.tag == 1){ // NOURISH
        [self nourishButtonTapped:nil];
    }else if (sender.tag == 2){ //LEARN
        [self learnButtonTapped:nil];
    }else if (sender.tag == 3){ //CONNECT
        [self connectButtonTapped:nil];
    }else if (sender.tag == 4){ //ACHIVE
        [self achieveButtonTapped:nil];
    }else if (sender.tag == 5){ //APPRECIATE
        [self appreciateButtonTapped:nil];
    }else if (sender.tag == 6){ //TRACK
        [self trackButtonTapped:nil];
    }
}
- (IBAction)shoppingViewPressed:(UIButton *)sender {
    if (sender.tag == 0) {
        shoppingView.hidden = true;
        recipeListView.hidden = true;
        [homeTable setContentInset:UIEdgeInsetsZero];
        [self updateViewConstraints];
    } else if (sender.tag == 1) {//custom shopping
        NourishViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Nourish"];
        controller.fromTodayPage = true;
        controller.redirectBackToTodayPage = true;
        controller.isFromShoppingListNotification = true;
        [self.navigationController pushViewController:controller animated:NO];
    } else if (sender.tag == 2) {//custom nutrition
        NourishViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Nourish"];
        controller.fromTodayPage = true;
        controller.redirectBackToTodayPage = true;
        controller.isFromNotification = true;
        [self.navigationController pushViewController:controller animated:NO];
    } else if (sender.tag == 3) {//weekly
        NourishViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Nourish"];
        controller.fromTodayPage = true;
        controller.redirectBackToTodayPage = true;
        controller.isWeeklyShopping = true;
        [self.navigationController pushViewController:controller animated:NO];
    }
}
-(void) updateViewConstraints{
    [super updateViewConstraints];
    
}
- (IBAction)recipeButtonPressed:(UIButton *)sender {
    if (sender.tag == 0) {
        RecipeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RecipeList"];
        [self.navigationController pushViewController:controller animated:NO];
    } else if (sender.tag == 1) {
        AddRecipeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddRecipeView"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (IBAction)myProgramButtonPressed:(UIButton *)sender {
   /* if([Utility isSquadFreeUser]){
        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }else if(![Utility isSubscribedUser] || [defaults boolForKey:@"IsNonSubscribedUser"]){
        [Utility showSubscribedAlert:self];
        return;
    }*/
    [CustomNavigation startNavigation:self fromMenu:NO navDict:@{@"Identifier":@"SetProgramView"}];
//    LearnHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LearnHome"];
//    controller.fromTodayPage = true;
//    controller.redirectBackToTodayPage = true;
//
//    UIButton *button = [UIButton new];
//    button.tag = 6;
//    [controller itemButtonPressed:button];
//
//    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)joinAshybinesSquadButtonPressed:(UIButton *)sender {
    
    if ([defaults boolForKey:@"isFirstTimeForum"]) {
        [defaults setBool:NO forKey:@"isFirstTimeForum"];
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Please Note"
                                              message:@"If you haven’t already joined your forum, please know it can take up to 48 hours to be approved to your Squad Forum, make sure your request to join the fb group and then wait to be accepted"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self fbForumButtonPressedWithIndex:0];
                                       self->freeUserJoinSqaudView.hidden = true;
                                   }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self fbForumButtonPressedWithIndex:0];
        self->freeUserJoinSqaudView.hidden = true;
    }
    
}


#pragma mark - End

#pragma mark - Private Method

-(void)setupVideoView{
    
        NSString *urlString=@"https://player.vimeo.com/external/220933773.m3u8?s=04d41e4e04fa8ce700db0f52f247acce968b72e5";
        //NSString *urlString=@"https://player.vimeo.com/external/220932517.m3u8?s=dd3882bb52f88673c33ff600b24bfc55684011de";
        NSURL *videoURL = [NSURL URLWithString:urlString];
        videoPlayer = [AVPlayer playerWithURL:videoURL];
        playerController = [[AVPlayerViewController alloc]init];
        playerController.player = videoPlayer;
        playerController.showsPlaybackControls = false;
        [self addChildViewController:playerController];
        [playerView addSubview:playerController.view];
        playerController.view.frame = playerView.bounds;
    
}

- (void)syncScrubber
{
    CMTime playerDuration = videoPlayer.currentItem.asset.duration;
    if (CMTIME_IS_INVALID(playerDuration))
    {
        playerProgressView.minimumValue = 0.0;
        playerProgressView.hidden = true;
        return;
    }
    
    if(playerProgressView.isHidden){
      playerProgressView.hidden = false;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration) && (duration > 0))
    {
        float minValue = [playerProgressView minimumValue];
        float maxValue = [playerProgressView maximumValue];
        double time = CMTimeGetSeconds([videoPlayer currentTime]);
        [playerProgressView setValue:(maxValue - minValue) * time / duration + minValue];
        
        NSUInteger dMinutes = floor((NSUInteger)duration / 60);
        NSUInteger dSeconds = floor((NSUInteger)duration % 3600 % 60);
        NSString *videoDurationText = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
        totalDurationLabel.text = videoDurationText;
        
        
    }
    
    //time label
    NSUInteger playerTime = CMTimeGetSeconds(videoPlayer.currentTime);
    NSUInteger dMinutes = floor(playerTime / 60);
    NSUInteger dSeconds = floor(playerTime % 3600 % 60);
    
    NSString *videoDurationText = [NSString stringWithFormat:@"%02lu:%02lu /", (unsigned long)dMinutes, (unsigned long)dSeconds];
    currentDurationLabel.text = videoDurationText;
}

-(void)goToNutrition:(int)stepnumber{
    if ((stepnumber == -1 || stepnumber == 1) && [Utility isEmptyCheck:currprogram] )   {//add1
        ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
        controller.isNutritionSettings=true;
        [self.navigationController pushViewController:controller animated:YES];
    }else if((stepnumber == -1 && ![Utility isEmptyCheck:currprogram])){//add1
        DietaryPreferenceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DietaryPreferenceView"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (stepnumber == 1 || stepnumber == 2) {
        DietaryPreferenceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DietaryPreferenceView"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (stepnumber == 3) {
        MealFrequencyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealFrequencyView"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (stepnumber == 4){
        MealVarietyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealVarietyView"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (stepnumber == 5){
        MealPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealPlanView"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
        controller.isComplete =false;
        controller.stepnumber = stepnumber;
        [self.navigationController pushViewController:controller animated:YES];
    }//add1
    
}
//chayan
-(void) animateHelp {   //ah ux
    [UIView animateWithDuration:1.5 animations:^{
        self->helpButton.alpha = 0.2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            self->helpButton.alpha = 1;
        } completion:^(BOOL finished) {
            UIViewController *vc = [self.navigationController visibleViewController];
            if (vc == self)
                [self animateHelp];
        }];
    }];
}
- (void) showInstructionOverlays {
    NSMutableArray *overlayViews = [[NSMutableArray alloc] init];
    overlayViews = [@[@{
                          @"view" : headerContainerView,
                          @"onTop" : @NO,
                          @"insText" :  @"Click the Squad logo to access the home screen",
                          @"isCustomFrame" : @true,
                          @"isFromHeader" :@true,
                          @"frame" : headerContainerView
                          },
                      @{
                          @"view" : headerContainerView,
                          @"onTop" : @NO,
                          @"insText" : @"Click here for tools and tips to get the most from your squad app",
                          @"isCustomFrame" : @true,
                          @"isFromHeader" :@true,
                          @"frame" : headerContainerView
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [trainButton convertRect:trainButton.bounds toView:self.view]],
                          @"onTop" :@NO,
                          @"insText" : @"Create a custom workout plan",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [nourishButton convertRect:nourishButton.bounds toView:self.view]],
                          @"onTop" : @NO,
                          @"insText" : @"Create your personalised nutrition plan",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [learnButton convertRect:learnButton.bounds toView:self.view]],
                          @"onTop" : @NO,
                          @"insText" : @"Watch webinars or enrol in mini health courses",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [connectButton convertRect:connectButton.bounds toView:self.view]],
                          @"onTop" : @NO,
                          @"insText" : @"Set up your forum access and find squad members near you",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [achieveButton convertRect:achieveButton.bounds toView:self.view]],
                          @"onTop" : @NO,
                          @"insText" : @"Set goals and reminders to stay accountable",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [appreciateButton convertRect:appreciateButton.bounds toView:self.view]],
                          @"onTop" : @NO,
                          @"insText" : @"Create your gratitude list and do guided meditations",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [trackButton convertRect:trackButton.bounds toView:self.view]],
                          @"onTop" : @NO,
                          @"insText" : @"Track your progress with pictures, data and more",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [containerView convertRect:containerView.bounds toView:self.view]],
                          @"onTop" : @YES,
                          @"insText" : @"Click the Squad Home to access the home screen",
                          @"isCustomFrame" : @true,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : containerView,
                          @"onTop" : @YES,
                          @"insText" : @"Click the Squad Train to access the train screen",
                          @"isCustomFrame" : @true,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : containerView,
                          @"onTop" : @YES,
                          @"insText" : @"Click the Squad Nourish to access the nourish screen",
                          @"isCustomFrame" : @true,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : containerView,
                          @"onTop" : @YES,
                          @"insText" : @"Click the Squad Learn to access the learn screen",
                          @"isCustomFrame" : @true,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : containerView,
                          @"onTop" : @YES,
                          @"insText" : @"Menu",
                          @"isCustomFrame" : @true,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          }] mutableCopy];
    
    int multiplierX = 0;
    int multiplierY = 0;
    
    for (int i = 0; i < overlayViews.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:overlayViews[i]];
        if ([[dict objectForKey:@"isCustomFrame"] boolValue] && ![[dict objectForKey:@"isFromHeader"]boolValue]) {
            CGRect newFrame = containerView.frame;
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            newFrame.origin.x = (screenWidth/5.0)*multiplierX;//(screenWidth/5.0) +
            newFrame.size.width = (screenWidth/5.0);
            [dict setObject:[NSValue valueWithCGRect:newFrame] forKey:@"frame"];
            [overlayViews replaceObjectAtIndex:i withObject:dict];
            multiplierX++;
        }else if ([[dict objectForKey:@"isCustomFrame"] boolValue] && [[dict objectForKey:@"isFromHeader"]boolValue]){
            CGRect newFrame = headerContainerView.frame;
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            if (isOnlyFirst) {
                newFrame.origin.x = (screenWidth/2.0)-100;
                isOnlyFirst =false;
            }else{
                newFrame.origin.x = (screenWidth/2.0)*multiplierY;//(screenWidth/5.0) +
            }
            newFrame.size.width = (screenWidth/2.0);
            [dict setObject:[NSValue valueWithCGRect:newFrame] forKey:@"frame"];
            [overlayViews replaceObjectAtIndex:i withObject:dict];
            multiplierY++;
        }
    }
    [Utility initializeInstructionAt:self OnViews:overlayViews];
}

-(void)setup_view{
    int completeCount = 0;
    for (NSDictionary *dict in taskListArray) {
        if([dict[@"Status"] boolValue]){
            completeCount ++;
        }
    }
    if(completeCount == taskListArray.count){
        [defaults setBool:true forKey:@"CompletedStartupChecklist"]; //AmitY
    }else{
        [defaults setBool:YES forKey:@"CompletedStartupChecklist"]; //AmitY
    }
    playerProgressView.hidden = true;
    //if(![Utility isSubscribedUser]){
        BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
        //     [self showInstructionOverlays];
        
        if (!isAllTaskCompleted ){
            startTaskView.hidden = false;
            
            BOOL isSeenWelcomeVid = [[defaults objectForKey:@"isSeenWelcomeVid"] boolValue];
            if (!isSeenWelcomeVid) {
                [self setupVideoView];
                videoView.hidden = false;
                [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"isSeenWelcomeVid"];
            }else{
                videoView.hidden = true;
            }
            
        }else{
            startTaskView.hidden = true;
//            blankView.hidden = true;
            /*BOOL isTaskCompletedMessagaeView = [defaults boolForKey:@"isTaskCompletedMessagaeView"];
            
            if (!isTaskCompletedMessagaeView){
                taskCompletedView.hidden = true;
                [self.view sendSubviewToBack:taskCompletedView];
                [defaults setBool:1 forKey:@"isTaskCompletedMessagaeView"];
            }*/
            
            BOOL isNotificationEnable = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
            
            if (![defaults boolForKey:@"isSpalshShown"]) {
                if(!isNotificationEnable){
                   notificationSplashView.hidden = false;
                }
            }else{
                [gameOnButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                notificationSplashView.hidden = true;
                if(!isNotificationEnable)[self promptUserToRegisterPushNotifications];
            }
        }
    
    
   /* }else{
        startTaskView.hidden = true;
        blankView.hidden = true;
        [gameOnButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }*/
    
    [homeTable reloadData];
    
    messageView.layer.cornerRadius = 5.0;
    messageView.clipsToBounds = YES;
    gameOnButton.layer.cornerRadius = 5.0;
    gameOnButton.clipsToBounds = YES;
}

-(void)startTaskWithIndex:(int)index{
    if (index == 1){
        [self helpButtonPressed:0];
    }else if (index == 2){
//        [self checkStepNumberForSetupWithAPI:@"CheckStepNumberForSetup"];
    }else if (index == 3){
        ExerciseDailyListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDailyList"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (index == 4){
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self webSerViceCall_GetSquadCurrentProgram];
            
        });
    }else if (index == 5){
        ShoppingListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingListView"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (index == 6){
        RecipeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RecipeList"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (index == 7){
        if ([defaults boolForKey:@"isFirstTimeForum"]) {
            [defaults setBool:NO forKey:@"isFirstTimeForum"];
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Please Note"
                                                  message:@"If you haven’t already joined your forum, please know it can take up to 48 hours to be approved to your Squad Forum, make sure your request to join the fb group and then wait to be accepted"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self fbForumButtonPressedWithIndex:0];
                                       }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [self fbForumButtonPressedWithIndex:0];
        }
    }else if (index == 8){
        [self GetGoalValueListAPI];
    }else if (index == 9){
//        CourseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetails"];
//        controller.isFromMenu=YES;
//        controller.isfromHome = YES;//change_new_240318
//        [self.navigationController pushViewController:controller animated:YES];
        
        //change_new_240318
       /* CourseArticleDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseArticleDetails"];
        controller.courseId = [NSNumber numberWithInt:19];
        controller.articleId = [NSNumber numberWithInt:278]; //279
        controller.taskId = [NSNumber numberWithInt:158];
        [self.navigationController pushViewController:controller animated:YES];*/
        
        
        CourseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetails"];
        controller.isFromMenu=YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if (index == 10){
        CourseArticleDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseArticleDetails"];
        controller.courseId = [NSNumber numberWithInt:1];
        controller.articleId = [NSNumber numberWithInt:1];
        controller.taskId = [NSNumber numberWithInt:1];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (index == 11){
        LearnHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LearnHome"];
        controller.fromTodayPage = true;
        controller.redirectBackToTodayPage = true;
        
        UIButton *button = [UIButton new];
        button.tag = 6;
        [controller itemButtonPressed:button];
        [self.navigationController pushViewController:controller animated:NO];
    }
    
    [self setup_view];
    
}


-(void) fbForumButtonPressedWithIndex:(int)index {     //ah ux
    NSString *urlString = @"";
    if (index == 0) {
        urlString = [defaults objectForKey:@"FbWorldForumUrl"];
        if(!urlString){
          urlString = @"https://www.facebook.com/groups/250625228700325/";
        }
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyyMMdd"];
        NSString *ReferenceEntityId = [df stringFromDate:[NSDate date]];
        
        NSMutableDictionary *dataDict = [NSMutableDictionary new];
        [dataDict setObject:[NSNumber numberWithInt:2] forKey:@"UserActionId"];
        if(ReferenceEntityId)[dataDict setObject:ReferenceEntityId forKey:@"ReferenceEntityId"];
        [dataDict setObject:@"WorldForum" forKey:@"ReferenceEntityType"];
        
        [Utility addGamificationPointWithData:dataDict];
    }else if (index == 1) {
        urlString = [defaults objectForKey:@"FbCityForumUrl"];
        
    }else if (index == 3) {
        urlString = [defaults objectForKey:@"FbSuburbForumUrl"];
    }
    
    
    if (![Utility isEmptyCheck:urlString]) {
        NSString *substractString =[urlString stringByReplacingOccurrencesOfString:@"https://www.facebook.com/groups" withString:@"fb://profile"];
        NSLog(@"%@\n %@",urlString,substractString);
        NSURL *url = [NSURL URLWithString:substractString];
        
        
       if([[UIApplication sharedApplication] canOpenURL:url]){
             [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
           if(success){
               NSLog(@"Opened");
               }
           }];
       }
        else {
            url = [NSURL URLWithString:urlString];
              [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                     if(success){
                         NSLog(@"Opened");
                         }
                     }];
        }
    }
    
    
    /*if (![Utility isEmptyCheck:urlString]) {
     FBForumViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FBForum"];
     controller.urlString = urlString;
     [self.navigationController pushViewController:controller animated:YES];
     }*/
}

-(void)listJsonFileData{
    NSString *filePath;
    NSError *error;
    
    filePath = [[NSBundle mainBundle] pathForResource:@"HomeListDetails" ofType:@"json"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    homeListArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if(error){
        NSLog(@"Signup Notification JSON Read Error:%@",error.debugDescription);
        return;
    }
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"HomeTableSectionHeader" bundle:nil];
    [homeTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"HomeTableSectionHeader"];
    homeTable.estimatedRowHeight = 65;
    homeTable.rowHeight = UITableViewAutomaticDimension;
    isAllShow = true;//feedback
    
    if (tablefooterViewDetails.hidden && !isOFflineShow) {
        tablefooterViewDetails.hidden = true;
    }
    if (isOFflineShow) {
        tablefooterViewDetails.hidden = true;
    }
    tablefooterViewDetails.hidden = true;//feedback
    
    if (![Utility isEmptyCheck:homeListArray]) {
        [homeTable reloadData];
        [homeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)setmyProgramVIew{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"my "];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"EyeCatchingPro" size:54] range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])]; //[Utility colorWithHexString:@"58595B"]
    
    NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:@"PROGRAMS"];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:26] range:NSMakeRange(0, [attributedString2 length])];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString2 length])]; //[Utility colorWithHexString:@"58595B"]
    
    [attributedString appendAttributedString:attributedString2];
    myProgramLabel.attributedText = attributedString;
    
//    if([Utility isSquadFreeUser]){
//        myProgramOverlay.hidden = false;
//    }else{
//        myProgramOverlay.hidden = true;
//    }
}

-(void)setmyJoinMyProgramView{
    joinSquadBorderView.layer.borderColor = [UIColor whiteColor].CGColor;
    joinSquadBorderView.layer.borderWidth = 2.0f;
    joinSquadBorderView.layer.cornerRadius = 35;
    joinSquadBorderView.clipsToBounds = YES;
    
    NSString *textStr = @"Before you start working out, join our facebook community and stay in touch!";
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:textStr];
    
    
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:18.0],
                               NSForegroundColorAttributeName : [UIColor whiteColor],
                               NSParagraphStyleAttributeName:paragraphStyle
                               };
    [text addAttributes:attrDict range:NSMakeRange(0,text.length)];
    
    NSDictionary *attrDict1 = @{
                                NSFontAttributeName : [UIFont fontWithName:@"Raleway-Bold" size:18.0],
                                NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSParagraphStyleAttributeName:paragraphStyle
                                };
    [text addAttributes:attrDict1 range:[textStr rangeOfString:@"facebook community"]];
    
    joinSquadInfoLabel.attributedText = text;
    
    
}

-(void)moveToTodayScreen{
    if(isMovedToToday){
        /*
        if (_sendToDailyWorkout) {
            _sendToDailyWorkout = false;
            ExerciseDailyListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDailyList"];
            controller.isOnlyToday = true;
            [self.navigationController pushViewController:controller animated:NO];
            return;
        }
        isMovedToToday = false;
         */
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
                     HabitHackerFirstViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitHackerFirstView"];
                     [self.navigationController pushViewController:controller animated:NO];
              }else if ([DBQuery isRowExist:@"gratitudeAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and CreatedDateStr = '%@'",[NSNumber numberWithInt:[[defaults objectForKey:@"UserID"]intValue]],currentDateStr]] || ([DBQuery isRowExist:@"growthAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and CreatedDateStr = '%@'",[NSNumber numberWithInt:[[defaults objectForKey:@"UserID"]intValue]],currentDateStr]])){
                  HabitHackerFirstViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitHackerFirstView"];
                  [self.navigationController pushViewController:controller animated:NO];
              }else{
//                    TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
                  HabitHackerFirstViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HabitHackerFirstView"];
                    [self.navigationController pushViewController:controller animated:NO];
              }
          }
           [dbObject connectionEnd];
        }else if ([DBQuery isRowExist:@"gratitudeAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and CreatedDateStr = '%@'",[NSNumber numberWithInt:[[defaults objectForKey:@"UserID"]intValue]],currentDateStr]] || ([DBQuery isRowExist:@"growthAddList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and CreatedDateStr = '%@'",[NSNumber numberWithInt:[[defaults objectForKey:@"UserID"]intValue]],currentDateStr]])){
            HabitHackerFirstViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitHackerFirstView"];
            [self.navigationController pushViewController:controller animated:NO];
        }else{
//            TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
            HabitHackerFirstViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HabitHackerFirstView"];
            AchievementsViewController *c = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Achievements"];
            c.isMoveToday = YES;
            controller.isMoveToday = YES;
            [self.navigationController pushViewController:controller animated:NO];
        }
    }
}
#pragma mark - End

#pragma mark - Table View Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == homeTable) {
        if ([Utility isOfflineMode]){//isOFflineShow) {
            return 1;
        }else if (!isAllShow){
            return 2;
        }
        return homeListArray.count;
    }else
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      if (tableView == homeTable) {
          NSArray *detailsArr = [[homeListArray objectAtIndex:section]objectForKey:@"details"];
          
          if(section == 0 || section == 5){
              if([defaults boolForKey:@"IsNonSubscribedUser"] && [Utility isSquadFreeUser]){
                  return detailsArr.count;
              }else{
                  return detailsArr.count-1;
              }
          }
          return detailsArr.count;
      }else
    return taskListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == homeTable) {
        return 50;
    }
    return 0;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomeTableSectionHeader *sectionHeaderView = [homeTable dequeueReusableHeaderFooterViewWithIdentifier:@"HomeTableSectionHeader"];
    if (![Utility isEmptyCheck:[[homeListArray objectAtIndex:section]objectForKey:@"image"]]) {
          sectionHeaderView.titleImage.image = [UIImage imageNamed:[[homeListArray objectAtIndex:section]objectForKey:@"image"]];
    }
    if (![Utility isEmptyCheck:[[homeListArray objectAtIndex:section]objectForKey:@"title"]]) {
        sectionHeaderView.titlelabel.text = [[homeListArray objectAtIndex:section]objectForKey:@"title"];
    }
    sectionHeaderView.titleButton.tag = section;
    [sectionHeaderView.titleButton addTarget:self action:@selector(sectionTapped:)
                                          forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *dict = [homeListArray objectAtIndex:section];
    
    sectionHeaderView.overlayView.hidden = true;
    if([Utility isSquadFreeUser]){
        BOOL isAccessibleForFree = [dict[@"isAccessibleForFree"] boolValue];
        if(isAccessibleForFree){
            sectionHeaderView.overlayView.hidden = true;
        }else{
            sectionHeaderView.overlayView.hidden = false;
        }
    }
    
    return  sectionHeaderView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tablecell;
    if (tableView == homeTable) {
        NSString *CellIdentifier =@"HomeTableViewCell";
        HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.programBorderView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
        cell.programBorderView.layer.borderWidth = 1;
        
        if (![Utility isEmptyCheck:[homeListArray objectAtIndex:indexPath.section]]) {
            NSDictionary *dict = [homeListArray objectAtIndex:indexPath.section];
            NSArray *detailsArr = [dict objectForKey:@"details"];
            BOOL isAccessibleForFree = [dict[@"isAccessibleForFree"] boolValue];
            if (![Utility isEmptyCheck:detailsArr]) {
                if (indexPath.section == 0 && indexPath.row == 2) {
                    NSString *str = [detailsArr objectAtIndex:indexPath.row];
                    NSArray *items = [str componentsSeparatedByString:@"/"];
                     if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                         cell.programsLabel.text = [items objectAtIndex:1];
                     }else{
                          cell.programsLabel.text = [items objectAtIndex:0];
                     }

                }else{
                    if ((indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 1 && indexPath.row == 0) || (indexPath.section == 1 && indexPath.row == 1)) {
                        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"my "];
                        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"EyeCatchingPro" size:45] range:NSMakeRange(0, [attributedString length])];
                        [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"58595B"] range:NSMakeRange(0, [attributedString length])];
                        
                        NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:[detailsArr objectAtIndex:indexPath.row]];
                        [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:17] range:NSMakeRange(0, [attributedString2 length])];
                        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"58595B"] range:NSMakeRange(0, [attributedString2 length])];
                        
                        [attributedString appendAttributedString:attributedString2];
                        cell.programsLabel.attributedText = attributedString;
                    }else{
                        cell.programsLabel.text = [detailsArr objectAtIndex:indexPath.row];
                    }
                }
            }
            cell.overlayView.hidden = true;
            if([Utility isSquadFreeUser]){
                if(isAccessibleForFree){
                    cell.overlayView.hidden = true;
                    if(indexPath.section== 0 && indexPath.row == 0){
                        cell.overlayView.hidden = false;
                    }
                }else if(indexPath.section == homeListArray.count-1 && indexPath.row >= 2){
                    cell.overlayView.hidden = true;
                }else if(indexPath.section == homeListArray.count-2 && indexPath.row == 2){
                    cell.overlayView.hidden = true;
                }
                else{
                    cell.overlayView.hidden = false;
                }
                
            }
            
        }
        tablecell = cell;
        
    }else{
        NSString *CellIdentifier =@"StartTaskTableViewCell";
        StartTaskTableViewCell *cell = (StartTaskTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[StartTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [cell.taskCountButton setTitle:[@"" stringByAppendingFormat:@"%d",(int)indexPath.row+1] forState:UIControlStateNormal];
        
        NSDictionary *dict = [taskListArray objectAtIndex:indexPath.row];
        
        int taskId = [dict[@"Id"] intValue];
        
        if (taskId == 1){
            cell.videoButton.hidden = false;
        }else{
            cell.videoButton.hidden = true;
        }
        
        if(![Utility isEmptyCheck:dict[@"Name"]]){
            cell.taskNameLabel.text = dict[@"Name"];
        }else{
            cell.taskNameLabel.text = @"";
        }
        
        BOOL isTaskCompleted = [dict[@"Status"] boolValue];
        
        if (isTaskCompleted){
            cell.taskCheckButton.selected = true;
            //cell.detailsButton.enabled= false;
        }else{
            cell.taskCheckButton.selected = false;
            cell.detailsButton.enabled= true;
        }
        
        if(indexPath.row>0){
            int prvIndex = (int)indexPath.row -1;
            NSDictionary *prvDict = [taskListArray objectAtIndex:prvIndex];
            BOOL prvIsTaskCompleted = [prvDict[@"Status"] boolValue];
            
            if (prvIsTaskCompleted){
                cell.detailsButton.enabled= true;
                cell.taskCheckButton.alpha = 1.0;
            }else{
                cell.detailsButton.enabled= false;
                cell.taskCheckButton.alpha = 0.5;
            }
        }else{
            cell.detailsButton.enabled= true;
            cell.taskCheckButton.alpha = 1.0;
        }
     
        cell.detailsButton.tag = indexPath.row;
        tablecell = cell;
    }
    return tablecell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeTableViewCell *cell = (HomeTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    /*if([Utility isSquadFreeUser]){
        NSDictionary *dict = [homeListArray objectAtIndex:indexPath.section];
        BOOL isAccessibleForFree = [dict[@"isAccessibleForFree"] boolValue];
        if(isAccessibleForFree){
            if(indexPath.section== 0 && indexPath.row == 0){
                [Utility showAlertAfterSevenDayTrail:self];
                return;
            }
            
        }else{
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
        
    }*/
    
    if(!cell.overlayView.isHidden){
        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }
    
    
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        [homeTable setContentInset:UIEdgeInsetsMake(0.0, 0.0, 350, 0.0)];
        [homeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        NSInteger heightT = cell.frame.size.height;
        heightT = 2*heightT;
        shoppingTopConstraint.constant = heightT;
        [self updateViewConstraints];
        
        shoppingView.hidden = false;
        
        return;
    }else if (indexPath.section == 1 && indexPath.row == 3) {
        
        [homeTable setContentInset:UIEdgeInsetsMake(0.0, 0.0, 350, 0.0)];
        [homeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        //HomeTableViewCell *cell = (HomeTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        NSInteger heightT = cell.frame.size.height;
        heightT = 2*heightT;
        recipeButtonTopConstraint.constant = heightT;
        [self updateViewConstraints];
        
        recipeListView.hidden = false;
        
        return;
    }
    
    if (indexPath.section == 0) {
//        TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
//        controller.fromTodayPage = true;
//        controller.redirectBackToTodayPage = true;
//        UIButton *button = [UIButton new];

        if (indexPath.row == 0) {
//            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
//                [self customWorkoutButtonPressed:nil];
//                return;
//            }else{
//                button.tag = 1;
//                [controller itemButtonPressed:button];
//            }
            [CustomNavigation startNavigation:self fromMenu:NO navDict:@{@"Identifier":@"ViewPersonalSession"}];
        }else if(indexPath.row == 1){
//            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
//                [self dailyWorkoutButtonPressed:nil];
//                return;
//            }else{
//                button.tag = 0;
//                [controller itemButtonPressed:button];
//            }
            [CustomNavigation startNavigation:self fromMenu:NO navDict:@{@"Identifier":@"ExerciseDailyList"}];
        }else if(indexPath.row == 2){
//            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
//                button.tag = 12;
//                [controller itemButtonPressed:button];
//            }else{
//                button.tag = 5;
//                [controller itemButtonPressed:button];
//            }
            [CustomNavigation startNavigation:self fromMenu:NO navDict:@{@"Identifier":@"RoundList"}];
        }else if(indexPath.row == 3){
//            button.tag = 12;
//            [controller itemButtonPressed:button];
        }
//        [self.navigationController pushViewController:controller animated:NO];

    }else if (indexPath.section == 1){
        NourishViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Nourish"];
        controller.fromTodayPage = true;
        controller.redirectBackToTodayPage = true;
        //UIButton *button = [UIButton new];
        
        if (indexPath.row == 0) {
            //button.tag = 1;
            //[controller itemButtonPressed:button];
            controller.isFromNotification = true;
        }else if (indexPath.row == 1){
            //[controller customShoppingListViewButtonTapped:nil];
            controller.isFromShoppingListNotification = true;
        }else{
//            button.tag = 6;
//            [controller itemButtonPressed:button];
            controller.isFromMealMatchNotification = true;
        }
        
        [self.navigationController pushViewController:controller animated:NO];
        
    }else if (indexPath.section == 2){
        LearnHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LearnHome"];
        controller.fromTodayPage = true;
        controller.redirectBackToTodayPage = true;

        UIButton *button = [UIButton new];

       /* if (indexPath.row == 0) {
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:self];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:self];
                return;
            }else if(![Utility isSubscribedUser] || [defaults boolForKey:@"IsNonSubscribedUser"]){
                [Utility showSubscribedAlert:self];
                return;
            }
            
            button.tag = 6;
            [controller itemButtonPressed:button];
        }else*/ if (indexPath.row == 0){
            button.tag = 1;
            [controller itemButtonPressed:button];
        }else  if (indexPath.row == 1){
            button.tag = 0;
            [controller itemButtonPressed:button];
        }else{
            button.tag = 5;
            [controller itemButtonPressed:button];
        }

        [self.navigationController pushViewController:controller animated:NO];
        
    }else if (indexPath.section == 3){
        ConnectViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Connect"];
        controller.redirectBackToTodayPage = true;

        UIButton *button = [UIButton new];

        if (indexPath.row == 0) {
            button.tag = 0;
            [controller fbForumButtonPressedWithSender:button];
            return;
        }else{
            controller.fromTodayPage = true;
            [self.navigationController pushViewController:controller animated:NO];
            
            [controller findASquadMemberButtonPressed:nil];
        }

    }else if (indexPath.section == 4){
        
        if([Utility isSquadLiteUser]){
            [Utility showSubscribedAlert:self];
            return;
        }else if([Utility isSquadFreeUser]){
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
        
        AchieveHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AchieveHome"];
        controller.fromTodayPage = true;
        controller.redirectBackToTodayPage = true;
        [self.navigationController pushViewController:controller animated:YES];

        if (indexPath.row == 0) {
            [controller visionBoardButtonTapped:nil];
        }else if (indexPath.row == 1) {
            [controller visionGoalsActionsButtonTapped:nil];
        }else if (indexPath.row == 2){
            [controller personalChallengesButtonTapped:nil];
        }else{
            [controller accountabilityBuddiesTapped:nil];
        }

        
    }else if (indexPath.section == 5){
        
        if([Utility isSquadLiteUser] && indexPath.row != 2){
            [Utility showSubscribedAlert:self];
            return;
        }else if([Utility isSquadFreeUser] && indexPath.row != 2){
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
        
        AppreciateViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Appreciate"];
        
        controller.fromTodayPage = true;
        controller.redirectBackToTodayPage = true;
        [self.navigationController pushViewController:controller animated:NO];
        UIButton *button = [UIButton new];
        if (indexPath.row == 0) {
            button.tag = 0;
            [controller itemButtonPressed:button];

        }else if (indexPath.row == 2) {
            button.tag = 5;
            [controller itemButtonPressed:button];
        }
        else{
            [controller viewAllMeditationButtonPressed:nil];
        }

    }else{
        
        if([Utility isSquadLiteUser]){
            [Utility showSubscribedAlert:self];
            return;
        }else if([Utility isSquadFreeUser] && indexPath.row < 2){
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
        
        TrackViewController *controller;
        if (![Utility isEmptyCheck:[defaults objectForKey:@"UnitPreference"]] || indexPath.row == 2) {
            controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Track"];
        }else{
            [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
            return;
        }
        
        controller.fromTodayPage = true;
        controller.redirectBackToTodayPage = true;
        [self.navigationController pushViewController:controller animated:NO];

        UIButton *button = [UIButton new];

        if (indexPath.row == 0) {
            button.tag = 0;
            [controller itemButtonPressed:button];
        }else if (indexPath.row == 1){
            button.tag = 1;
            [controller itemButtonPressed:button];
        }else if (indexPath.row == 2){
            button.tag = 2;
            [controller itemButtonPressed:button];
        }else if (indexPath.row == 3){
            button.tag = 7;
            [controller itemButtonPressed:button];
        }
    }

}

#pragma mark - End

#pragma mark - Help Video Player Delegate
-(void)controllerDismissed{
    taskListArray = [[defaults objectForKey:@"taskListArray"] mutableCopy];
    if(![Utility isSubscribedUser]){
        bool isAllTaskCompleted = true;
        for (NSDictionary *dict in taskListArray) {
            if(![dict[@"Status"] boolValue]){
                isAllTaskCompleted = false;
                break;
            }
        }
        [defaults setBool:YES forKey:@"CompletedStartupChecklist"]; //AmitY
    }
    [self setup_view];
}
#pragma mark - End

#pragma mark - AVPlayer Notification
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self watchLaterButtonPressed:0];
}
#pragma mark - End

#pragma mark - Location Manager Delegate Methods -

#pragma mark - End
#pragma mark - UITapGesture Action
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    // do stuff
    currentInfoPage ++;
    if(currentInfoPage >2){
        currentInfoPage = 1;
        NSString *pageImageName = [@"" stringByAppendingFormat:@"squad_page_%d.png",currentInfoPage+1];
        [morefeatureImageView setImage:[UIImage imageNamed:pageImageName]];
        unlockMoreFeatureView.hidden = true;
    }else{
        NSString *pageImageName = [@"" stringByAppendingFormat:@"squad_page_%d.png",currentInfoPage+1];
        [morefeatureImageView setImage:[UIImage imageNamed:pageImageName]];
    }
    
}
#pragma mark - End

#pragma mark  - Local Notification

-(void)offlineModeDetails:(NSNotification*)notification{
    if([Utility isSubscribedUser] && [Utility isOfflineMode]){
//        offlineHomePageView.hidden = false;
        isOFflineShow = true;
        tablefooterViewDetails.hidden = true;
    }else{
//        offlineHomePageView.hidden = true;
        isOFflineShow = false;
        tablefooterViewDetails.hidden= true;
    }// AY 06032018
    [homeTable reloadData];
    isMovedToToday = true;
    [self moveToTodayScreen];
}

-(void)reloadHomePage:(NSNotification*)notification{
     [self setmyProgramVIew];
    [self viewWillAppear:YES];
    [homeTable reloadData];
}



@end
