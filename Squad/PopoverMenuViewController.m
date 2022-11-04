//
//  PopoverMenuViewController.m
//  Squad
//
//  Created by Admin on 21/11/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "PopoverMenuViewController.h"
#import "InitialViewController.h"
#import "SignupWithEmailViewController.h"
#import "PrivacyPolicyAndTermsServiceViewController.h"
#import "HeaderDetailsViewController.h"
#import "HomePageViewController.h"
#import "DailyGoodnessDetailViewController.h"
#import "ShowImageViewController.h"
#import "AddEditCustomNutritionViewController.h"
#import "DailyGoodnessViewController.h"
#import "IngredientListViewController.h"
#import "BlankListViewController.h"
#import "AddRecipeViewController.h"
#import "AddEditIngredientViewController.h"
#import "ActivityHistoryViewController.h"
#import "AudioBookViewController.h"
#import "FBWHomeViewController.h"
#import "SquadDataViewController.h"
#import "SettingsViewController.h"
#import "ExerciseTypeViewController.h"
#import "ExerciseDetailsViewController.h"
#import "ExerciseVideoViewController.h"
#import "CalendarViewController.h"
#import "ShopifyListViewController.h"
#import "CoursesListViewController.h"
#import "CourseDetailsViewController.h"
#import "ExerciseListViewController.h"
#import "CircuitListViewController.h"
#import "CircuitDetailsViewController.h"
#import "SessionListViewController.h"
#import "ExerciseDailyListViewController.h"
#import "ForumViewController.h"
#import "ChannelListViewController.h"
#import "PlayListViewController.h"
#import "VideoViewController.h"
#import "PodcastViewController.h"
#import "MyDiaryListViewController.h"
#import "MyDairyAddEditViewController.h"
#import "GratitudeViewController.h"
#import "GratitudeAddEditViewController.h"
#import "AchievementsViewController.h"
#import "AchievementsAddEditNewViewController.h"
#import "MyPhotosViewController.h"
#import "CompareResultViewController.h"
#import "LatestResultViewController.h"
#import "AddDetailsViewController.h"
#import "MyPhotosDefaultViewController.h"
#import "SharePhotoViewController.h"
#import "SharePicDataViewController.h"

#import "MealTypeViewController.h"
#import "MealAddViewController.h"
#import "TrainHomeViewController.h"
#import "NourishViewController.h"
#import "LearnHomeViewController.h"
#import "ConnectViewController.h"
#import "AchieveHomeViewController.h"
#import "AppreciateViewController.h"
#import "TrackViewController.h"
#import "MenuSettingsViewController.h"
#import "MyProgramsViewController.h"
#import "CourseDetailsViewController.h"
#import "MealMatchViewController.h"
#import "MyProfileSettingsViewController.h"
#import "CustomExerciseSettingsViewController.h"
#import "NutritionSettingHomeViewController.h"
#import "DietaryPreferenceViewController.h"
#import "MealFrequencyViewController.h"
#import "MealVarietyViewController.h"
#import "MealPlanViewController.h"
#import "ChooseGoalViewController.h"
#import "CongratulationViewController.h"
#import "AddCustomSessionViewController.h"
#import "CourseArticleDetailsViewController.h"
#import "ExcerciseDetailsViewController.h"
#import "ChalengesHomeViewController.h"
#import "DashboardViewController.h"
#import "ExcerciseTitleViewController.h"
#import "CustomNutritionMealSettingsViewController.h"
#import "LeaderBoardViewController.h"
#import "ExcerciseTitleAllViewController.h"
#import "ContentManagementViewController.h" //AY 28022018
#import "LeaderBoardDetailsViewController.h"
#import "SpotifyPlaylistViewController.h" //AY 07032018
#import "SettingsPickersViewController.h"
#import "SevenDayTrialViewController.h"
#import "ExerciseEditViewController.h"
#import "FoodPrepViewController.h"
#import "FoodPrepAddEditViewController.h"
#import "FoodPrepShoppingListViewController.h"
#import "FoodPrepSearchViewController.h"
#import "SetProgramViewController.h"
#import "GamificationViewController.h"
#import "MealSwapDropDownViewController.h"
#import "AnalyzeSearchViewController.h"
#import "FatLossViewController.h"
#import "CustomProgramSetupViewController.h"
#import "RateFitnessLevelViewController.h"
#import "AddPersonalSessionViewController.h"
#import "ResourceViewController.h"
#import "RoundListViewController.h"
#import "TimerViewController.h"
#import "HelpViewController.h"
#import "AccountabilityBuddyHomeViewController.h"
#import "AddActionViewController.h"
#import "FindMeABuddyListViewController.h"
#import "MyBuddiesListViewController.h"
#import "AccountabilityGoalActionViewController.h"
#import "AddYourselfBuddyViewController.h"
#import "SearchBuddyListViewController.h"
#import "QuoteViewController.h"
#import "QuoteGalleryViewController.h"
#import "QuestionnaireHomeViewController.h"
#import "CSScaleViewController.h"
#import "RPStressViewController.h"
#import "HQuestionnaireViewController.h"
#import "QuestionAttemptListViewController.h"
#import "WebinarListViewController.h"
#import "WaterTrackerViewController.h"
#import "TrackAllViewController.h"
#import "VitaminViewController.h"
#import "PersonalChallengeViewController.h"
#import "BadgePopUpViewController.h"//BADGE
#import "GratitudeListViewController.h"
#import "AddVisionBoardViewController.h"
#import "AllMessageViewController.h"
#import "AllMessageDetailsViewController.h"
#import "AchievementsDateViewController.h"
#import "FreeModeAlertViewController.h"
#import "WebinarListViewController.h"
#import "BucketListNewAddEditViewController.h"
#import "HelpWalkthroughViewController.h"
#import "FBForumViewController.h"
#import "ChatVideoListViewController.h"
#import "ChatDetailsVideoViewController.h"
#import "MeditationRewardViewController.h"

@interface PopoverMenuViewController (){
    
    UIView *contentView;

    
    IBOutlet UIView *signOutButtonContainer;
    IBOutlet UIView *logInButtonContainer;
    IBOutlet UIView *signUpButtonContainer;
    
    IBOutlet UIButton *helpButton;
    IBOutlet UIButton *profileButton;
    IBOutlet UIButton *homeButton;
    IBOutlet UIButton *signoutButton;
    IBOutlet UIButton *signupButton;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *contactDropdownButton;
    IBOutlet UIButton *gratitudeCountButton;
    IBOutlet UIButton *fbForumButton;
    
    
    
    NSDictionary *streakDict;
    AppDelegate *appDelegate;
    

}

@end

@implementation PopoverMenuViewController

@synthesize parent;

#pragma mark -View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    signoutButton.layer.cornerRadius=10.0;
    signoutButton.clipsToBounds=YES;
    loginButton.layer.cornerRadius=10.0;
    loginButton.clipsToBounds=YES;
    signupButton.layer.cornerRadius=10.0;
    signupButton.clipsToBounds=YES;
    
    gratitudeCountButton.layer.cornerRadius=gratitudeCountButton.frame.size.height/2.0;
    gratitudeCountButton.clipsToBounds=YES;
    
    contactDropdownButton.selected=false;
    emailButton.hidden=true;
    
    self.preferredContentSize = CGSizeMake(200, 350);
    if (!Utility.reachable) {
        profileButton.hidden = true;
        helpButton.hidden = true;
        signOutButtonContainer.hidden = true;
        signUpButtonContainer.hidden = true;
        logInButtonContainer.hidden = true;
    }else{
        profileButton.hidden = true;
        helpButton.hidden = false;
        signOutButtonContainer.hidden = false;
        signUpButtonContainer.hidden = false;
        logInButtonContainer.hidden = false;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (![Utility reachable]) {
        return;
    }
    if ([defaults boolForKey:@"IsNonSubscribedUser"]){
        signOutButtonContainer.hidden = true;
        signUpButtonContainer.hidden = false;
        logInButtonContainer.hidden = false;
    }else if([Utility isSubscribedUser] || [Utility isSquadLiteUser]) {
        signOutButtonContainer.hidden = false;
        signUpButtonContainer.hidden = true;
        logInButtonContainer.hidden = true;
    }else{
        signOutButtonContainer.hidden = true;
        signUpButtonContainer.hidden = false;
        logInButtonContainer.hidden = false;
    }
    
    [self GetStreakData_webServiceCall];
}




#pragma mark -End

#pragma mark -IBAction

- (IBAction)coachButtonPressed:(UIButton *)sender {
    
    [self getCoachToken_ApiCall];
}


- (IBAction)liveChatButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        if (![self.parent isKindOfClass:[ChatVideoListViewController class]]) {
            if (![Utility isEmptyCheck:[defaults objectForKey:@"IsPlayingLiveChat"]] && [[defaults objectForKey:@"IsPlayingLiveChat"] boolValue]) {
                NSString *webinarstr=[defaults objectForKey:@"PlayingLiveChatDict"];
                NSData *data = [webinarstr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                  CMTime startTime = CMTimeMake(0, 0);
                    if ([defaults boolForKey:@"IsPlayingLiveChat"]) {
                        [self->appDelegate.FBWAudioPlayer pause];
                        startTime = self->appDelegate.playerController.player.currentTime;
                        
                    }
                BOOL isCheck = false;
                NSArray *controllers = [self.parent.navigationController viewControllers];
                for(UIViewController *controller in controllers){
                    if ([controller isKindOfClass:[ChatDetailsVideoViewController class]]) {
                        isCheck = true;
                        [self.parent.navigationController popToViewController:controller animated:NO];
                    }
                }
                if (!isCheck) {
                    ChatDetailsVideoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ChatDetailsVideo"];
                    controller.videoDict = dict;
                    if (CMTimeGetSeconds(startTime)>0) {
                           controller.videoTime = startTime;
                       }
                     [self.parent.navigationController pushViewController:controller animated:NO];
                }
                
            }else{
                ChatVideoListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ChatVideoList"];
                [self.parent.navigationController pushViewController:controller animated:NO];
            }
        }
    }];
}

- (IBAction)fbForumButtonPressed:(UIButton *)sender {
//    [self dismissViewControllerAnimated:NO completion:nil];
//    dispatch_async(dispatch_get_main_queue(),^ {
//        NSString *urlString=@"https://www.facebook.com/groups/250625228700325";
//        FBForumViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FBForum"];
//        controller.urlString = urlString;
//        [self.parent.navigationController pushViewController:controller animated:YES];
//    });
    [self dismissViewControllerAnimated:NO completion:^{
   //        FacebookGroupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"FacebookGroupView"];
   //        controller.url = [NSURL URLWithString:FaceBookGroup];
           NSString *urlString=@"https://www.facebook.com/groups/250625228700325";
           NSURL *facebookURL = [NSURL URLWithString:urlString];
           if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
               [[UIApplication sharedApplication] openURL:facebookURL options:@{} completionHandler:^(BOOL success) {
                   if (success) {
                        NSLog(@"Opened url");
                   }
                   
               }];
               
           } else {
               [[UIApplication sharedApplication] openURL:facebookURL options:@{} completionHandler:^(BOOL success) {
                   if (success) {
                        NSLog(@"Opened url");
                   }
                   
               }];
           }
   //        [self.parent.navigationController pushViewController:controller animated:NO];
           

       }];

}


- (IBAction)gratitudeCountButtonPressed:(UIButton *)sender{
        
    [self dismissViewControllerAnimated:NO completion:nil];
    dispatch_async(dispatch_get_main_queue(),^ {
        
        if(![defaults boolForKey:@"CompletedStartupChecklist"]){
             [self incompleStartTaskAlert];
             return;
         }
        if ([Utility isOnlyProgramMember]) {
            [Utility showNonSubscribedAlert:self.parentViewController sectionName:@"Gratitude"];
            return;
         }
         UIViewController *visibleController = self.parentViewController;
         if ([visibleController isKindOfClass:[GamificationViewController class]]) {
             return;
         }
        if ([Utility isEmptyCheck:self->streakDict]) {
             return;
         }
         
         if ([self isSettingsPage]) {
             [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
                 if (shouldPop) {
                     GamificationViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GamificationView"];
                     controller.streakDict = self->streakDict;
                     if([self.parent isKindOfClass:[MasterMenuViewController class]]){
                         NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                         self.parent.slidingViewController.topViewController = nav;
                         [self.parent.slidingViewController resetTopViewAnimated:YES];
                     }else{
                         [self.parent.navigationController pushViewController:controller animated:YES];
                     }
                 }
             }];
             return;
         }else{
             GamificationViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GamificationView"];
             controller.streakDict = self->streakDict;
             if([self.parent isKindOfClass:[MasterMenuViewController class]]){
                 NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                 self.parent.slidingViewController.topViewController = nav;
                 [self.parent.slidingViewController resetTopViewAnimated:YES];
             }else{
                 [self.parent.navigationController pushViewController:controller animated:YES];
             }
         }
        
        
        //---------------------------------
        
    
    
    });
    
}


- (IBAction)contactDropdownPressed:(UIButton *)sender {
    if (contactDropdownButton.isSelected) {
        contactDropdownButton.selected=false;
        emailButton.hidden=true;
    }else{
        contactDropdownButton.selected=true;
        emailButton.hidden=false;
    }
}

- (IBAction)emailButtonPressed:(UIButton *)sender {
    NSString *mailStr=@"mailto:customercare@mindbodyhq.com";

    NSString *url = [mailStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:mailStr] ];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
    if(success){
        NSLog(@"Opened");
        }
    }];
}

- (IBAction)homeButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    dispatch_async(dispatch_get_main_queue(),^ {
        if ([Utility isOnlyProgramMember]) {
            [Utility showNonSubscribedAlert:self.parentViewController sectionName:@"Gratitude"];
            return ;
        }
    if ([Utility checkForFirstDailyWorkout:self.parent.parentViewController]) {
        return;
    }
    if ([self isSettingsPage]) {
        [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
            if (shouldPop) {
                [self.parent.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        return;
    }
    if(([Utility isSubscribedUser] && [Utility isOfflineMode]) || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
        
        if([self.parent.navigationController.visibleViewController  isKindOfClass:[HomePageViewController class]] || [self.parent.navigationController.visibleViewController  isKindOfClass:[TodayHomeViewController class]]){
            return;
        }else if ([self.parent.parentViewController isKindOfClass:[ExerciseVideoViewController class]] || [self.parent.parentViewController isKindOfClass:[ShoppingListViewController class]] || [self.parent.parentViewController isKindOfClass:[CustomNutritionMealSettingsViewController class]] || [self.parent.parentViewController isKindOfClass:[FoodPrepAddEditViewController class]] || [self.parent.parentViewController isKindOfClass:[MasterMenuViewController class]] || [self.parent.parentViewController isKindOfClass:[TimerViewController class]] || [self.parent.parentViewController isKindOfClass:[RoundListViewController class]] || [self.parent.parentViewController isKindOfClass:[SessionListViewController class]] || [self.parent.parentViewController isKindOfClass:[AddGoalsViewController class]] || [self.parent.parentViewController isKindOfClass:[AddActionViewController class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backButtonPressed" object:@"homeButtonPressed"];
            return;
        }
        [self.parent.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
        
        if (!isAllTaskCompleted ){
            [self.parent.navigationController popToRootViewControllerAnimated:YES];
            return;
        }else  if([self.parent.parentViewController  isKindOfClass:[TodayHomeViewController class]] || [self.parent.parentViewController  isKindOfClass:[HomePageViewController class]]){
            return;
        }else  if ([self.parent.parentViewController isKindOfClass:[ExerciseVideoViewController class]] || [self.parent.parentViewController isKindOfClass:[ShoppingListViewController class]] || [self.parent.parentViewController isKindOfClass:[CustomNutritionMealSettingsViewController class]] || [self.parent.parentViewController isKindOfClass:[FoodPrepAddEditViewController class]] || [self.parent.parentViewController isKindOfClass:[MasterMenuViewController class]] || [self.parent.parentViewController isKindOfClass:[TimerViewController class]] || [self.parent.parentViewController isKindOfClass:[RoundListViewController class]] || [self.parent.parentViewController isKindOfClass:[SessionListViewController class]] || [self.parent.parentViewController isKindOfClass:[AddGoalsViewController class]] || [self.parent.parentViewController isKindOfClass:[AddActionViewController class]]){
            NSLog(@"------%@",self.parent.parentViewController);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backButtonPressed" object:@"homeButtonPressed"];
            return;
        }// AY 05032018
//        TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//        GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
        AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Achievements"];
        [self.parent.navigationController pushViewController:controller animated:YES];
    }
    
    });
}

- (IBAction)profileButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    dispatch_async(dispatch_get_main_queue(),^ {
        
        if ([self.parent isKindOfClass:[MyProfileSettingsViewController class]]) {
            return;
        }
    
        [self profileButtonDetails];
    });
    
}



- (IBAction)helpButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    dispatch_async(dispatch_get_main_queue(),^ {
    
    
    [self helpButtonDetails];
    });
}








- (IBAction)logInButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    dispatch_async(dispatch_get_main_queue(),^ {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BOOL isControllerFound = NO;
    for (UIViewController *controller in self.parent.navigationController.viewControllers) {
        if ([controller isKindOfClass:[InitialViewController class]]) {
            InitialViewController *controller1 =(InitialViewController *)controller;
            controller1.openLoginView = true;
            [self.parent.navigationController popToViewController:controller animated:YES];
            isControllerFound = YES;
            break;
        }
    }
    
    if(!isControllerFound){
        InitialViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InitialView"];
        controller.openLoginView = true;
        //[self.navigationController pushViewController:controller animated:YES];
        NavigationViewController *nav = [[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        
        self.parent.slidingViewController.topViewController = nav;
        [self.parent.slidingViewController resetTopViewAnimated:YES];
    }
    });
}





- (IBAction)logOutButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
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
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"LogOutApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 
                                                                 if(error == nil)
                                                                 {
                                                                     [self removeAllDefaultsAfterLogout];
                                                                     [Utility removeDefaultObjects];
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     if([responseString boolValue]) {
                                                                         BOOL isControllerFound = NO;
                                                                         for (UIViewController *controller in self.parent.navigationController.viewControllers) {
                                                                             if ([controller isKindOfClass:[InitialViewController class]]) {
                                                                                 [self.parent.navigationController popToViewController:controller
                                                                                       animated:YES];
                                                                                 isControllerFound = YES;
                                                                                 break;
                                                                             }
                                                                         }
                                                                         
                                                                         if(!isControllerFound){
                                                                            InitialViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InitialView"];
                                                                            [self.parent.navigationController pushViewController:controller animated:YES];
                                                                         }
                                                                         
                                                                         return ;
                                                                     }else{
//                                                                         [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                                                                         BOOL isControllerFound = NO;
                                                                         for (UIViewController *controller in self.parent.navigationController.viewControllers) {
                                                                             if ([controller isKindOfClass:[InitialViewController class]]) {
                                                                                [self.parent.navigationController popToViewController:controller
                                                                                                                       animated:YES];
                                                                                 isControllerFound = YES;
                                                                                 break;
                                                                             }
                                                                         }
                                                                         
                                                                         if(!isControllerFound){
                                                                             InitialViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InitialView"];
                                                                             [self.parent.navigationController pushViewController:controller animated:YES];
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

- (IBAction)signUpButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
    dispatch_async(dispatch_get_main_queue(),^ {
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
    NavigationViewController *nav = [[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:signupController];
    self.parent.slidingViewController.topViewController = nav;
    [self.parent.slidingViewController resetTopViewAnimated:YES];
    });
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)quotesButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
        dispatch_async(dispatch_get_main_queue(),^ {
        UIViewController *topController;
        
        if([self.parent.slidingViewController.topViewController isKindOfClass:[UINavigationController class]]){
            UINavigationController *nav = (UINavigationController *)self.parent.slidingViewController.topViewController;
            NSArray *controllers = [nav viewControllers];
            topController = [controllers lastObject];
            NSLog(@"Top Controller:%@",topController.debugDescription);
        }else{
            topController = self.parent.slidingViewController.topViewController;
        }
        
        if(topController && [topController isKindOfClass:[QuoteGalleryViewController class]]){
                  return;
              }
        
              [self quotesButtonDetails];
        });
}

-(IBAction)webVersionButtonPressed:(id)sender{
    
    NSURL *url = [NSURL URLWithString:@"https://mindbodyhq.com/"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
    if(success){
        NSLog(@"Opened");
        }
    }];
}

#pragma mark -End



#pragma mark -Private Method

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
                                    [self homeButtonPressed:self->homeButton];
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

-(void)gratitudeNav{
    
    if ([self.parent isKindOfClass:[GratitudeListViewController class]]) {
        return;
    }
        
    if ([Utility isSubscribedUser] || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
        if([Utility isOfflineMode]){
            [self checkOfflineAccess];
            return;
        }
        
        NSArray *arr = [self.parent.navigationController viewControllers];
        for (UIViewController *controller in arr) {
            if ([controller isKindOfClass:[GratitudeListViewController class]]) {
                [self.parent.navigationController popToViewController:controller animated:YES];
                return;
            }
        }
        
//        GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GratitudeListView"];
        AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Achievements"];
        [self.parent.navigationController pushViewController:controller animated:YES];
        
    }else{
        [Utility showSubscribedAlert:self.parent];
    }
    
}

-(BOOL)isSettingsPage{
    BOOL isSettings = false;
//    return false;
    
    if ([self.parent.parentViewController isKindOfClass:[ChooseGoalViewController class]] ||[self.parent.parentViewController isKindOfClass:[DietaryPreferenceViewController class]] ||[self.parent.parentViewController isKindOfClass:[MealFrequencyViewController class]] ||[self.parent.parentViewController isKindOfClass:[MealVarietyViewController class]] ||[self.parent.parentViewController isKindOfClass:[MealPlanViewController class]] ||[self.parent.parentViewController isKindOfClass:[CustomProgramSetupViewController class]] ||[self.parent.parentViewController isKindOfClass:[RateFitnessLevelViewController class]] ||[self.parent.parentViewController isKindOfClass:[PersonalSessionsViewController class]] ||[self.parent.parentViewController isKindOfClass:[MovePersonalSessionViewController class]]) {
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
    [self.parent presentViewController:alertController animated:YES completion:nil];
}


-(void)profileButtonDetails{
        if ([Utility isSubscribedUser] || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
            
            if([Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            dispatch_async(dispatch_get_main_queue(),^ {
                MyProfileSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyProfileSettingsView"];
                if([self.parentViewController isKindOfClass:[MasterMenuViewController class]]){
                    NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                    self.parentViewController.slidingViewController.topViewController = nav;
                    [self.parentViewController.slidingViewController resetTopViewAnimated:YES];
                }else{
                    [self.parent.navigationController pushViewController:controller animated:YES];
                }
                
            });
        }else if([Utility isSquadFreeUser]){
            [self.parent.slidingViewController anchorTopViewToLeftAnimated:YES];
            [self.parent.slidingViewController resetTopViewAnimated:YES];
            [Utility showAlertAfterSevenDayTrail:self.parent];
            return;
        }
        else{
            [self.parent.slidingViewController anchorTopViewToLeftAnimated:YES];
            [self.parent.slidingViewController resetTopViewAnimated:YES];
            [Utility showSubscribedAlert:self.parent];
        }
}

-(void)checkOfflineAccess{
    [Utility msg:@"You are in OFFLINE mode. Go Online to access this functionality." title:@"Oops!\n" controller:self.parent haveToPop:NO];
}

-(void)helpButtonDetails{
    
    dispatch_async(dispatch_get_main_queue(),^ {
       /* HelpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpView"];
        if([self.parentViewController isKindOfClass:[MasterMenuViewController class]]){
            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
            self.parentViewController.slidingViewController.topViewController = nav;
            [self.parentViewController.slidingViewController resetTopViewAnimated:YES];
        }else{
            [self.parent.navigationController pushViewController:controller animated:YES];
        }*/
        
       /* if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:HELP_MENU]]){
                NSURL *url = [NSURL URLWithString:HELP_MENU];
               [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success){
                   if (success) {
                       NSLog(@"Opened");
                   }
               }];
        }*/
        
                HelpWalkthroughViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpWalkthroughView"];
               controller.modalPresentationStyle = UIModalPresentationCustom;
               controller.url=[NSURL URLWithString:HELP_MENU];
               controller.parent=self->parent;
               [self->parent presentViewController:controller animated:YES completion:nil];
        
    });
}

-(void)quotesButtonDetails{
        if ([Utility isSubscribedUser] || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
            
            if([Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            dispatch_async(dispatch_get_main_queue(),^ {
                QuoteGalleryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuoteGalleryView"];
               if([self.parentViewController isKindOfClass:[MasterMenuViewController class]]){
                    NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                    self.parentViewController.slidingViewController.topViewController = nav;
                    [self.parentViewController.slidingViewController resetTopViewAnimated:YES];
                }else{
                    [self.parent.navigationController pushViewController:controller animated:YES];
                }
                
            });
        }else if([Utility isSquadFreeUser]){
            [self.parent.slidingViewController anchorTopViewToLeftAnimated:YES];
            [self.parent.slidingViewController resetTopViewAnimated:YES];
            [Utility showAlertAfterSevenDayTrail:self.parent];
            return;
        }
        else{
            [self.parent.slidingViewController anchorTopViewToLeftAnimated:YES];
            [self.parent.slidingViewController resetTopViewAnimated:YES];
            [Utility showSubscribedAlert:self.parent];
        }
}

-(void)removeAllDefaultsAfterLogout{
    [Utility logoutChatSdk];
    [defaults setObject:@"" forKey:@"CurrentProgramName"];
    
    [defaults removeObjectForKey:@"TempTrialEndDate"];
    [defaults setBool:NO forKey:@"isOffline"]; // AY 27022018 (For Offline)
    [defaults setBool:NO forKey:@"isSquadLite"];
    [defaults setBool:NO forKey:@"IsNonSubscribedUser"];
    [defaults setBool:NO forKey:@"isInitialNotiSet"];
    [defaults setBool:NO forKey:@"isInitialQuoteSet"];//Quote
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
    [defaults setBool:false forKey:@"isFirstTimeCourse"];
    [defaults setBool:false forKey:@"isFirstTimeTest"];
    [defaults setBool:false forKey:@"isFirstTimeGratitude"];
    [defaults setBool:false forKey:@"isFirstTimeGrowth"];
    [defaults removeObjectForKey:@"CourseNameArray"];
    
    [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"UserID"];
    [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"UserSessionID"];
    [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"ABBBCOnlineUserId"];
    [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"ABBBCOnlineUserSessionId"];
    [defaults setBool:false forKey:@"isFirstTimeGratitude"];
    [defaults setBool:false forKey:@"isFirstTimeBucket"];
    [defaults setBool:false forKey:@"isFirstTimeHabit"];
    [defaults setBool:false forKey:@"isFirstTimeMeditation"]; //24/7/2020
    [defaults removeObjectForKey:@"defaultStatesView"];
    [defaults removeObjectForKey:@"habitListFilterStatus"];
    [defaults removeObjectForKey:@"habitViewStatus"];
    [defaults removeObjectForKey:@"bucketListFilterStatus"];
    
    
    [defaults setBool:NO forKey:@"IsBecomeOfflineToOnline"];
    [defaults setBool:NO forKey:@"isSiriAdded"];
    [defaults removeObjectForKey:@"siriAlert"];
    [defaults setBool:NO forKey:@"isFirstTimeSiri"];
    [defaults removeObjectForKey:@"Email"];
    [Utility logoutAccount_CommunityWebserviceCall];
}

-(NSString*)gratitudePointsCalculation:(NSString*)points{
    NSString *firstStr = @"";
    NSRange myRange = NSMakeRange(0, 1);
    firstStr = [points substringWithRange:myRange];
    return firstStr;
}

#pragma mark -End

#pragma mark - Webservice call
-(void)getCoachToken_ApiCall{
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
//        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults valueForKey:@"Email"] forKey:@"Email"];
        [mainDict setObject:[defaults valueForKey:@"Password"] forKey:@"Password"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"getCoachToken" append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                         NSString *coachToken=[responseDictionary objectForKey:@"OnceOffToken"];
                                                                         if (![Utility isEmptyCheck:coachToken]) {
                                                                             [self dismissViewControllerAnimated:NO completion:^{
                                                                                 NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://coach.mindbodyhq.com/members/member/LogonViaToken?token=%@",coachToken]];
                                                                                 if([[UIApplication sharedApplication] canOpenURL:url]){
                                                                                 [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                                                                                     if(success){
                                                                                         NSLog(@"Opened");
                                                                                         }
                                                                                     }];
                                                                                 }
                                                                             }];
                                                                         }else{
                                                                             [self dismissViewControllerAnimated:NO completion:^{
                                                                                 NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://coach.mindbodyhq.com/members/member/logon"]];
                                                                                 if([[UIApplication sharedApplication] canOpenURL:url]){
                                                                                 [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                                                                                     if(success){
                                                                                         NSLog(@"Opened");
                                                                                         }
                                                                                     }];
                                                                                 }
                                                                             }];
                                                                         }
                                                                     }else{
                                                                         [self dismissViewControllerAnimated:NO completion:^{
                                                                             NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://coach.mindbodyhq.com/members/member/logon"]];
                                                                             if([[UIApplication sharedApplication] canOpenURL:url]){
                                                                             [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                                                                                 if(success){
                                                                                     NSLog(@"Opened");
                                                                                     }
                                                                                 }];
                                                                             }
                                                                         }];
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


-(void)GetStreakData_webServiceCall{//BADGE
    if (Utility.reachable) {
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *todayStr = [df stringFromDate:[NSDate date]];
        [mainDict setObject:todayStr forKey:@"UserCurrentDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetGratitudeStreakData" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                        self->streakDict = [responseDict objectForKey:@"StreakData"];
                                                                         
                                                                         if(![Utility isEmptyCheck:[self->streakDict objectForKey:@"Total"]]){
                                                                             double points = [[self->streakDict objectForKey:@"Total"]doubleValue];
                                                                             if (points>999) {
                                                                                 NSString *pointsStr = [self gratitudePointsCalculation:[@"" stringByAppendingFormat:@"%@",[self->streakDict objectForKey:@"Total"]]];
                                                                                 [self->gratitudeCountButton setTitle:[@"" stringByAppendingFormat:@"%@+",pointsStr] forState:UIControlStateNormal];
                                                                             }else{
                                                                                 [self->gratitudeCountButton setTitle:[@"" stringByAppendingFormat:@"%@",[self->streakDict objectForKey:@"Total"]] forState:UIControlStateNormal];
                                                                             }
                                                                         }else{
                                                                             [self->gratitudeCountButton setTitle:@"" forState:UIControlStateNormal];
                                                                         }
                                                                     }
                                                                     else{
//                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
//                                                                         return;
                                                                     }
                                                                 }else{
//                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }
}

#pragma mark -End


@end
