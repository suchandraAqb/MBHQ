//
//  HeaderDetailsViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 27/12/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//
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

#import "PopoverMenuViewController.h"
#import "PopoverRightMenuViewController.h"

@interface HeaderDetailsViewController ()
{
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *infoButton;
    IBOutlet UIButton *chatButton;
    IBOutlet UIButton *starButton;
    IBOutlet UILabel *allTimePointLabel;
    __weak IBOutlet UIButton *logoButton;
    IBOutlet UIButton *menuButton;
    IBOutlet UIButton *notificationButton;
    
    IBOutlet UIView *articleNotificationView;
    IBOutlet UIView *chatButtonView;
    IBOutlet UIView *forumView;
    IBOutlet UIButton *forumbadgeCount;
    NSDictionary *streakDict;
    NSTimer *forumTimer;
}
@end

@implementation HeaderDetailsViewController

#pragma mark - IBAction

- (IBAction)notificationButtonPressed:(UIButton *)sender {
    
    if (![Utility reachable]) {
          [Utility msg:@"Currenly You are offline.Go to online to get the message details" title:@"Oops! " controller:self haveToPop:NO];
          return;
      }
    
    if ([Utility isOnlyProgramMember]) {
        return;
    }
    if([Utility isSquadFreeUser]){
        //        [Utility showAlertAfterSevenDayTrail:self.parentViewController];
        //        return;
    }
    
    
    UIViewController *visibleController = self.parentViewController;
    if ([visibleController isKindOfClass:[CoursesListViewController class]]) {
        return;
    }
    if ([self isSettingsPage]) {
        [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
            if (shouldPop) {
                CoursesListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CoursesList"];
                
                if([self.parentViewController isKindOfClass:[MasterMenuViewController class]]){
                    NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                    self.parentViewController.slidingViewController.topViewController = nav;
                    [self.parentViewController.slidingViewController resetTopViewAnimated:YES];
                }else{
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }];
        return;
    }else{
        CoursesListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CoursesList"];
        
        if([self.parentViewController isKindOfClass:[MasterMenuViewController class]]){
            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
            self.parentViewController.slidingViewController.topViewController = nav;
            [self.parentViewController.slidingViewController resetTopViewAnimated:YES];
        }else{
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    
    
}



- (IBAction)logoButtonPressed:(UIButton *)sender {

   if ([Utility isOnlyProgramMember]) {
       return;
   }
    if ([self isSettingsPage]) {
        [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
            if (shouldPop) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        return;
    }
    
    if(([Utility isSubscribedUser] && [Utility isOfflineMode]) || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
        
        if([self.navigationController.visibleViewController  isKindOfClass:[HomePageViewController class]] || [self.navigationController.visibleViewController  isKindOfClass:[TodayHomeViewController class]]){
            return;
        }else if ([self.parentViewController isKindOfClass:[ExerciseVideoViewController class]] || [self.parentViewController isKindOfClass:[ShoppingListViewController class]] || [self.parentViewController isKindOfClass:[CustomNutritionMealSettingsViewController class]] || [self.parentViewController isKindOfClass:[FoodPrepAddEditViewController class]] || [self.parentViewController isKindOfClass:[MasterMenuViewController class]] || [self.parentViewController isKindOfClass:[TimerViewController class]] || [self.parentViewController isKindOfClass:[RoundListViewController class]] || [self.parentViewController isKindOfClass:[SessionListViewController class]] || [self.parentViewController isKindOfClass:[AddGoalsViewController class]] || [self.parentViewController isKindOfClass:[AddActionViewController class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backButtonPressed" object:@"homeButtonPressed"];
            return;
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
        if (!isAllTaskCompleted ){
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }else  if([self.navigationController.visibleViewController  isKindOfClass:[TodayHomeViewController class]] || [self.navigationController.visibleViewController  isKindOfClass:[HomePageViewController class]]){
            return;
        }else  if ([self.parentViewController isKindOfClass:[ExerciseVideoViewController class]] || [self.parentViewController isKindOfClass:[ShoppingListViewController class]] || [self.parentViewController isKindOfClass:[CustomNutritionMealSettingsViewController class]] || [self.parentViewController isKindOfClass:[FoodPrepAddEditViewController class]] || [self.parentViewController isKindOfClass:[MasterMenuViewController class]] || [self.parentViewController isKindOfClass:[TimerViewController class]] || [self.parentViewController isKindOfClass:[RoundListViewController class]] || [self.parentViewController isKindOfClass:[SessionListViewController class]] || [self.parentViewController isKindOfClass:[AddGoalsViewController class]] || [self.parentViewController isKindOfClass:[AddActionViewController class]]){
            NSLog(@"------%@",self.parentViewController);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backButtonPressed" object:@"homeButtonPressed"];
            return;
        }// AY 05032018
//        TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//        GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
        AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Achievements"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    
}
-(IBAction)infoButtonPressed:(id)sender{
    
    
    UIViewController *controller = self.navigationController.visibleViewController;
    
        if ([controller isKindOfClass:[HomePageViewController class]]) {
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
        }else if ([controller isKindOfClass:[TrainHomeViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/220932728.m3u8?s=5df94fedbc4655abb941380001975b0f4665586c";
            if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeTrain"] boolValue]) {
                [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
                NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
                [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeTrain"];
                [defaults setObject:dict forKey:@"firstTimeHelpDict"];
            }
            else{
                [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
            }
        }else if ([controller isKindOfClass:[NourishViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/220933018.m3u8?s=ec878c58bd2e8675af4994335feb49789319b5b6";
            if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeNourish"] boolValue]) {
                [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
                NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
                [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeNourish"];
                [defaults setObject:dict forKey:@"firstTimeHelpDict"];
            }
            else{
                [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
            }
        }else if ([controller isKindOfClass:[LearnHomeViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/220933065.m3u8?s=387a479d1133aee78893c610a7ef9654b82ac4b4";
            
            if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeLearn"] boolValue]) {
                [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
                NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
                [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeLearn"];
                [defaults setObject:dict forKey:@"firstTimeHelpDict"];
                
            }
            else{
                [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
            }
        }else if ([controller isKindOfClass:[ConnectViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/220932517.m3u8?s=dd3882bb52f88673c33ff600b24bfc55684011de";
            
            if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeConnect"] boolValue]) {
                [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
                NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
                [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeConnect"];
                [defaults setObject:dict forKey:@"firstTimeHelpDict"];
            }
            else{
                [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
            }
        }else if ([controller isKindOfClass:[AchieveHomeViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/220937662.m3u8?s=38a17694e14093b93c516efe24d9c6592677ba25";
            
            if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeAchieve"] boolValue]) {
                [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
                NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
                [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeAchieve"];
                [defaults setObject:dict forKey:@"firstTimeHelpDict"];
            }
            else{
                [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
            }
        }else if ([controller isKindOfClass:[AppreciateViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/220933321.m3u8?s=dbe73990b8d048743040db27d4e8e29e78144aa3";
            
            if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeAppreciate"] boolValue]) {
                [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
                NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
                [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeAppreciate"];
                [defaults setObject:dict forKey:@"firstTimeHelpDict"];
            }
            else{
                [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
            }
        }else if ([controller isKindOfClass:[TrackViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/220933540.m3u8?s=ea345fe4a29d1c3409a4b3b8f381ced8f99f2870";
            
            if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeTrack"] boolValue]) {
                [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
                NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
                [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeTrack"];
                [defaults setObject:dict forKey:@"firstTimeHelpDict"];
            }
            else{
                [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
            }
        }
    //new info videos
        else if ([controller isKindOfClass:[TodayHomeViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408368.m3u8?s=b6c812928713281f6cab2e4528d5890e97814c62";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[MasterMenuViewController class]] || [controller isKindOfClass:[ECSlidingViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408257.m3u8?s=eb4b9b3ed9aff17c0a6b8297ad209d7c8d6ed8d6";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[MyProgramsViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408179.m3u8?s=3832f0ae5a00782c688dcc68188d6d9adce10f1c";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[ViewPersonalSessionViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408441.m3u8?s=8748f953c0dcd9ef067b02e6764676a9260746fc";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[AdvanceSearchForSessionViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408419.m3u8?s=949c6e4121bb6d39a695aeb9a70c86f51fd060f6";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[ExerciseDailyListViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408459.m3u8?s=73d0620bca853d123c45e2424a8449c819b15ce1";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }
//        else if ([controller isKindOfClass:[SessionListViewController class]]){
//            NSString *urlString=@"https://player.vimeo.com/external/290408419.m3u8?s=949c6e4121bb6d39a695aeb9a70c86f51fd060f6";
//            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
//        }
        else if ([controller isKindOfClass:[FBWHomeViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408166.m3u8?s=c1e7bdaf5f33fddb961082171a1f3980ca4efd99";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[RoundListViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408070.m3u8?s=2a602bd8653c2c7ca45f1858818eb1363894e069";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[CustomNutritionPlanListViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408090.m3u8?s=c5a2636fb44f431346c4573e6ed76c9d1edfbec4";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[ShoppingListViewController class]]){
            ShoppingListViewController *new = (ShoppingListViewController *)controller;
            NSString *urlString;
            if(new.isCustom){
                urlString=@"https://player.vimeo.com/external/290408106.m3u8?s=13672bb1dcb8878e60d773c7be9e40d6ddd5a7a4";
            }else{
                urlString=@"https://player.vimeo.com/external/290408344.m3u8?s=1d6dff9551d0dd7625b4e7ae6c73b4ae42ebcc97";
            }
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[AddEditCustomNutritionViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408126.m3u8?s=416a3f25d4d0b7de9e17fc8d31df48a9bbedbb2c";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[MealMatchViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408289.m3u8?s=8ec9609a73a534c510ae0299e8b673ff8ab4a3f8";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[FoodPrepViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408497.m3u8?s=84cd85961e4d4257830901bf2c49d41156db3597";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[SavedNutritionPlanViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408333.m3u8?s=a89ba7ac51edd8120f914340e471ef2f3419a9b3";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[RecipeListViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408320.m3u8?s=0f1713347464cb64eb27cc82a00060fd4d433fd3";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[FoodPrepSearchViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408320.m3u8?s=0f1713347464cb64eb27cc82a00060fd4d433fd3";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[CoursesListViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408217.m3u8?s=f0b76fab6bfec350339727655d99961f15132eca";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[SetProgramViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408239.m3u8?s=5ad9b28aaf9e7796f1d22e8213bedfddaccf03e2";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }else if ([controller isKindOfClass:[MyPhotosDefaultViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408389.m3u8?s=43eab43c14d390852b49f5d2131a3fc8ed8756fb";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }
        /*else if ([controller isKindOfClass:[MyPhotosCompareViewController class]]){
            NSString *urlString=@"https://player.vimeo.com/external/290408389.m3u8?s=43eab43c14d390852b49f5d2131a3fc8ed8756fb";
            [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
        }*/
       
}
-(IBAction)starButtonPressed:(id)sender{
    
    if(![defaults boolForKey:@"CompletedStartupChecklist"]){
        [self incompleStartTaskAlert];
        return;
    }
   /* if([Utility isSquadLiteUser]){
        [Utility showSubscribedAlert:self.parentViewController];
        return;
    }else if([Utility isSquadFreeUser]){
        [Utility showAlertAfterSevenDayTrail:self.parentViewController];
        return;
    }*/
   if ([Utility isOnlyProgramMember]) {
        return;
    }
    UIViewController *visibleController = self.parentViewController;
    if ([visibleController isKindOfClass:[GamificationViewController class]]) {
        return;
    }
    if ([Utility isEmptyCheck:streakDict]) {
        return;
    }
    
    if ([self isSettingsPage]) {
        [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
            if (shouldPop) {
                GamificationViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GamificationView"];
                controller.streakDict = self->streakDict;
                if([self.parentViewController isKindOfClass:[MasterMenuViewController class]]){
                    NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                    self.parentViewController.slidingViewController.topViewController = nav;
                    [self.parentViewController.slidingViewController resetTopViewAnimated:YES];
                }else{
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }];
        return;
    }else{
        GamificationViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GamificationView"];
        controller.streakDict = self->streakDict;
        if([self.parentViewController isKindOfClass:[MasterMenuViewController class]]){
            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
            self.parentViewController.slidingViewController.topViewController = nav;
            [self.parentViewController.slidingViewController resetTopViewAnimated:YES];
        }else{
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    
} //landScape_Change
-(IBAction)backButtonPressed:(id)sender{
    if ([self isSettingsPage]) {
        [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
            if (shouldPop) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        return;
    }
    if ([self.parentViewController isKindOfClass:[ExerciseVideoViewController class]] || [self.parentViewController isKindOfClass:[ContentManagementViewController class]] || [self.parentViewController isKindOfClass:[ShoppingListViewController class]] || [self.parentViewController isKindOfClass:[CustomNutritionMealSettingsViewController class]] || [self.parentViewController isKindOfClass:[FoodPrepAddEditViewController class]]||[self.parentViewController isKindOfClass:[ExerciseDetailsViewController class]] || [self.parentViewController isKindOfClass:[ExerciseTypeViewController class]] ||[self.parentViewController isKindOfClass:[AddEditCustomNutritionViewController class]] || [self.parentViewController isKindOfClass:[FoodPrepViewController class]] || [self.parentViewController isKindOfClass:[MealMatchViewController class]]||[self.parentViewController isKindOfClass:[DailyGoodnessDetailViewController class]] || [self.parentViewController isKindOfClass:[FoodPrepShoppingListViewController class]] || [self.parentViewController isKindOfClass:[MealAddViewController class]] || [self.parentViewController isKindOfClass:[MealTypeViewController class]] || [self.parentViewController isKindOfClass:[FoodPrepSearchViewController class]] || [self.parentViewController isKindOfClass:[SavedNutritionPlanViewController class]] || [self.parentViewController isKindOfClass:[AdvanceSearchForSessionViewController class]] || [self.parentViewController isKindOfClass:[TimerViewController class]] || [self.parentViewController isKindOfClass:[RoundListViewController class]] || [self.parentViewController isKindOfClass:[SessionListViewController class]] || [self.parentViewController isKindOfClass:[AddGoalsViewController class]] || [self.parentViewController isKindOfClass:[AddActionViewController class]] || [self.parentViewController isKindOfClass:[WaterTrackerViewController class]]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backButtonPressed" object:nil];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }// AY 22022018
    
}

-(IBAction)chatButtonPressed:(id)sender{
//    BadgePopUpViewController *custom = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BadgePopUpView"];
//    custom.modalPresentationStyle = UIModalPresentationCustom;
//    custom.streakDict = self->streakDict;
//    custom.parentcontroller = self.parentViewController;
//    [self presentViewController:custom animated:YES completion:nil];
    if(/* DISABLES CODE */ (true)){
        dispatch_async(dispatch_get_main_queue(), ^{

                UIButton *btn=(UIButton *) sender;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            PopoverRightMenuViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PopoverRightMenu"];
                controller.parent=self.parentViewController;
                UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:controller];
                destNav.modalPresentationStyle = UIModalPresentationPopover;
                UIPopoverPresentationController *popoverPresentationController = destNav.popoverPresentationController;
                popoverPresentationController.delegate = self;
                popoverPresentationController.sourceView = btn.superview;
                popoverPresentationController.sourceRect = btn.frame;
                popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;

                destNav.navigationBarHidden = YES;
                [self presentViewController:destNav animated:YES completion:nil];
            });
}else{
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

    if([Utility isSquadFreeUser]){
        //        [Utility showAlertAfterSevenDayTrail:self.parentViewController];
        //        return;
    }

    if ([Utility checkForFirstDailyWorkout:self.parentViewController]) {
        return;
    }

    UIViewController *visibleController = self.parentViewController;
    if ([visibleController isKindOfClass:[CommunityViewController class]]) {
        return;
    }
    if ([self isSettingsPage]) {
        [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
            if (shouldPop) {
                //ChatSDKMessagesViewController *qcontroller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatSDKMessagesView"];

                CommunityViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CommunityView"];

                if([self.parentViewController isKindOfClass:[MasterMenuViewController class]]){
                    NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                    self.parentViewController.slidingViewController.topViewController = nav;
                    [self.parentViewController.slidingViewController resetTopViewAnimated:YES];
                }else{
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }];
        return;
    }else{
        //ChatSDKMessagesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatSDKMessagesView"];

        CommunityViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CommunityView"];

        if([self.parentViewController isKindOfClass:[MasterMenuViewController class]]){
            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
            self.parentViewController.slidingViewController.topViewController = nav;
            [self.parentViewController.slidingViewController resetTopViewAnimated:YES];
        }else{
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}
   /*
    */
    
}//landScape_Change

-(IBAction)menuButtonPressed:(id)sender{
//    if (![Utility reachable]) {
//        [Utility msg:@"Currenly You are offline.Go to online to get the menu" title:@"Oops! " controller:self haveToPop:NO];
//        return;
//    }
   
    dispatch_async(dispatch_get_main_queue(), ^{

            UIButton *btn=(UIButton *) sender;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            PopoverMenuViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PopoverMenu"];
            controller.parent=self.parentViewController;
            UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:controller];
            destNav.modalPresentationStyle = UIModalPresentationPopover;
            UIPopoverPresentationController *popoverPresentationController = destNav.popoverPresentationController;
            popoverPresentationController.delegate = self;
            popoverPresentationController.sourceView = btn.superview;
            popoverPresentationController.sourceRect = btn.frame;
            popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;

            destNav.navigationBarHidden = YES;
            [self presentViewController:destNav animated:YES completion:nil];
        });
        
        
        
        
        
        
        
    //     dispatch_async(dispatch_get_main_queue(),^ {
    //
    //         if(![defaults boolForKey:@"CompletedStartupChecklist"]){
    //             [self incompleStartTaskAlert];
    //             return;
    //         }
    //         if ([Utility checkForFirstDailyWorkout:self.parentViewController]) {
    //             return;
    //         }
    //         if ([self isSettingsPage]) {
    //             [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
    //                 if (shouldPop) {
    //                     [[NSNotificationCenter defaultCenter]postNotificationName:@"offlineModeDetails" object:nil];// AY 06032018
    //
    //                     [self.slidingViewController anchorTopViewToLeftAnimated:YES];
    //                     [self.slidingViewController resetTopViewAnimated:YES];
    //                 }
    //             }];
    //             return;
    //         }else{
    //             [[NSNotificationCenter defaultCenter]postNotificationName:@"offlineModeDetails" object:nil];// AY 06032018
    //
    //             [self.slidingViewController anchorTopViewToLeftAnimated:YES];
    //             [self.slidingViewController resetTopViewAnimated:YES];
    //         }
    //     });
         
         
     
    
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}

#pragma mark - End

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
//    chatButton.badgeBGColor = [Utility colorWithHexString:@"DD2390"];
    chatButton.badgeBGColor = [Utility colorWithHexString:@"000000"];
    chatButton.badgeFont = [UIFont fontWithName:@"Oswald-Regular" size:12];
    chatButton.shouldHideBadgeAtZero = YES;
    forumbadgeCount.layer.cornerRadius = forumbadgeCount.frame.size.height/2;
    forumbadgeCount.layer.masksToBounds = YES;
    [forumbadgeCount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forumbadgeCount setBackgroundColor:[UIColor redColor]];
    forumbadgeCount.titleLabel.font = [UIFont fontWithName:@"Raleway-Semibold" size:12];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //changeOfflineStatus
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOfflineStatus:) name:@"changeOfflineStatus" object:nil];// AY 26042018
    [self updateBadge]; // AY
    // NSLog(@"%@",self.navigationController.viewControllers);
    
    //gami_badge_popup
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBadgePoint:)
                                                 name:@"UpdateBadgePoint"
                                               object:nil]; //gami_badge_popup
   
    self->forumbadgeCount.hidden = true;
    
    [self updateTabButtons];
    [self updateLogo];
    [self updateBadge];
    [self squadAppLog];
    [self squadNotificationLog];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"didBecomeActiveForHeader" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        if ([defaults boolForKey:@"IsBecomeOfflineToOnline"]) {
            [defaults setBool:false forKey:@"IsBecomeOfflineToOnline"];
            [self updateTabButtons];
            
        }
      }];
    
    
     if ([defaults boolForKey:@"IsNonSubscribedUser"]) {
         if (![defaults boolForKey:@"IsPopUpShowForFreeMode"]) {
//             [self freeModePopUpDetails];
         }
     }
    [self getNotification_CommunityWebserviceCall];
      forumTimer = [NSTimer scheduledTimerWithTimeInterval:30 repeats:YES block:^(NSTimer * _Nonnull timer) {
          [self getNotification_CommunityWebserviceCall];
      }];
    
    UIViewController *controller = self.parentViewController;
    backButton.hidden = false;
    infoButton.hidden = true;
    menuButton.hidden = true;
    if (!Utility.reachable) {
         self->chatButtonView.hidden = true;
    }else{
        if ([controller isKindOfClass:[AllMessageViewController class]] || [controller isKindOfClass:[AllMessageDetailsViewController class]]) {
                self->chatButtonView.hidden = true;
        }else{
            self->chatButtonView.hidden = true;//false
        }
    }
    if ([controller isKindOfClass:[MasterMenuViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
        [menuButton setImage:[UIImage imageNamed:@"menu_cross.png"] forState:UIControlStateNormal];
    } else if ([controller isKindOfClass:[HomePageViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    }
    
    ///**Ru**
    else if ([controller isKindOfClass:[GratitudeAddEditViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    }
    else if ([controller isKindOfClass:[GratitudeListViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    }
    else if ([controller isKindOfClass:[AddVisionBoardViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    }
    //**Ru**
    else if ([controller isKindOfClass:[TodayHomeViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    } else if ([controller isKindOfClass:[CustomNutritionPlanListViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    } else if ([controller isKindOfClass:[MealMatchViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    } else if ([controller isKindOfClass:[RecipeListViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    } else if ([controller isKindOfClass:[DailyGoodnessViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    } else if ([controller isKindOfClass:[DailyGoodnessDetailViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
        NSArray *nArray = self.parentViewController.navigationController.viewControllers;
        for (UIViewController *mView in nArray) {
            if ([mView isKindOfClass:[DailyGoodnessDetailViewController class]]) {
                DailyGoodnessDetailViewController *controller = (DailyGoodnessDetailViewController *)mView;
                BOOL sh = controller.showTab;
                if (!sh) {
                    menuButton.hidden = true;
                    backButton.hidden = false;
                }
                break;
            }
        }
    } else if ([controller isKindOfClass:[FoodPrepViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    } else if ([controller isKindOfClass:[SavedNutritionPlanViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    } else if ([controller isKindOfClass:[ViewPersonalSessionViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    } else if ([controller isKindOfClass:[ExerciseDailyListViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    } else if ([controller isKindOfClass:[SessionListViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    } else if ([controller isKindOfClass:[RoundListViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    } else if ([controller isKindOfClass:[ChalengesHomeViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    } else if ([controller isKindOfClass:[MyPhotosDefaultViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    }  else if ([controller isKindOfClass:[QuestionnaireHomeViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    } else if ([controller isKindOfClass:[SetProgramViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    } else if ([controller isKindOfClass:[CoursesListViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    } else if ([controller isKindOfClass:[WebinarListViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    }else  if ([controller isKindOfClass:[WaterTrackerViewController class]]) {
        backButton.hidden = false;
        menuButton.hidden = true;
    }else  if ([controller isKindOfClass:[TrackAllViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[ExerciseTypeViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[VitaminViewController class]]) {//SB_TEST
        backButton.hidden = true;
        menuButton.hidden = false;
        NSArray *arr = self.parentViewController.navigationController.viewControllers;
        UIViewController *controller = [self.parentViewController.navigationController.viewControllers objectAtIndex:arr.count-2];
        if ([controller isKindOfClass:[TrackAllViewController class]] ||[controller isKindOfClass:[TodayHomeViewController class]] ) {
            menuButton.hidden = true;
            backButton.hidden = false;
        }
        
    }else  if ([controller isKindOfClass:[AddVitaminViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[AdvanceSearchForSessionViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[FoodPrepSearchViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[AddRecipeViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[AchieveHomeViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[AppreciateViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[PersonalChallengeViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[NewMealAddViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[FoodScanViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[AddToPlanViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }
    else  if ([controller isKindOfClass:[VisionGoalActionViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    } else  if ([controller isKindOfClass:[AccountabilityBuddyHomeViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }
    /*Prev
    else  if ([controller isKindOfClass:[VisionHomeViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }*/
    //Updated
    else  if ([controller isKindOfClass:[AddVisionBoardViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }
    else  if ([controller isKindOfClass:[BucketListNewViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[BucketListNewAddEditViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[GratitudeViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }
    
    //RU*** add AchievementsViewController
    
    else  if ([controller isKindOfClass:[AchievementsViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }
    else if ([controller isKindOfClass:[AchievementsDateViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    }
    else if ([controller isKindOfClass:[AchievementsAddEditNewViewController class]]) {
        menuButton.hidden = false;
        backButton.hidden = true;
    }
    
    else  if ([controller isKindOfClass:[AllMessageViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[AllMessageDetailsViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[AddGoalsViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[WebinarListViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }else  if ([controller isKindOfClass:[NotesViewController class]]) {
        backButton.hidden = true;
        menuButton.hidden = false;
    }
    
    menuButton.hidden=true;
    backButton.hidden=true;
    
    chatButtonView.hidden=true;
    articleNotificationView.hidden=true;
    [self isCacheExpired_webServiceCall];
    
//    [self webServiceCall_GetUnreadMessageCountForUser:controller];
//    [self getUserRewardPoints_webServiceCall:nil]; //Gamification
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [forumTimer invalidate];
    forumTimer = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeOfflineStatus" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UpdateBadgePoint" object:nil]; //gami_badge_popup
}// AY 06032018
#pragma mark - End

#pragma mark- LocalNotification
-(void)changeOfflineStatus:(NSNotification *)notification{
    [self updateTabButtons];
    [self updateBadge];
}// AY 06032018

-(void)updateTabButtons{
    
    if([Utility isSubscribedUser]){
        if(!Utility.reachable){
            menuButton.hidden = true;
            chatButtonView.hidden = true;
            starButton.hidden = true;
            allTimePointLabel.hidden = true;
            articleNotificationView.hidden = true;
        }else{
            menuButton.hidden = true;
            chatButtonView.hidden = true;//false
            starButton.hidden = false;
            allTimePointLabel.hidden = false;
            articleNotificationView.hidden = true;//false
        }
        
    }else if([Utility isSquadLiteUser] || [Utility isSquadFreeUser]){
        chatButtonView.hidden = true;//false
        starButton.hidden = false;
        allTimePointLabel.hidden = false;
    }else{
        chatButtonView.hidden = true;
        starButton.hidden = true;
        allTimePointLabel.hidden = true;
    }
}

-(void)updateLogo{
    if([Utility isSquadFreeUser]){
        [logoButton setImage:[UIImage imageNamed:@"mbhq_logo_Free.png"] forState:UIControlStateNormal];
    }else if([Utility isSquadLiteUser]){
        [logoButton setImage:[UIImage imageNamed:@"mbhq_logo_Lite.png"] forState:UIControlStateNormal];
    }else{
        [logoButton setImage:[UIImage imageNamed:@"mbhq_logo.png"] forState:UIControlStateNormal];
    }
}
#pragma mark- End

#pragma mark - Webservicecall


-(void)GetStreakData_webServiceCall{//BADGE
    if (Utility.reachable) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            if (self->contentView) {
        //                [self->contentView removeFromSuperview];
        //            }
        //            self->contentView = [Utility activityIndicatorView:self];
        //        });
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
                                                                 //                                                                 if (self->contentView) {
                                                                 //                                                                     [self->contentView removeFromSuperview];
                                                                 //                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         self->streakDict = [responseDict objectForKey:@"StreakData"];
                                                                         BOOL isCheck = [self lockUnlockDetails:[[self->streakDict objectForKey:@"Total"]intValue]];
                                                                         
                                                                         if (isCheck && ([[defaults objectForKey:@"Total"]intValue]!= [[self->streakDict objectForKey:@"Total"]intValue])) {
                                                                             [defaults setBool:YES forKey:@"MilesStoneValue"];
                                                                         }else{
                                                                             [defaults setBool:NO forKey:@"MilesStoneValue"];
                                                                         }
                                                                         [defaults setObject:[NSNumber numberWithInt:[[self->streakDict objectForKey:@"Total"]intValue]] forKey:@"Total"];

                                                                         if ([defaults boolForKey:@"MilesStoneValue"]) {
                                                                             BadgePopUpViewController *custom = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BadgePopUpView"];
                                                                             custom.modalPresentationStyle = UIModalPresentationCustom;
                                                                             custom.streakDict = self->streakDict;
                                                                             custom.parentcontroller = self.parentViewController;
                                                                             [self presentViewController:custom animated:YES completion:nil];
                                                                         }
//                                                                         self->starButton.backgroundColor = [Utility colorWithHexString:@"000000"];
                                                                         
//                                                                         if(![Utility isEmptyCheck:[self->streakDict objectForKey:@"Total"]]){
//                                                                             double points = [[self->streakDict objectForKey:@"Total"]doubleValue];
//                                                                             if (points>999) {
//                                                                                 NSString *pointsStr = [self gratitudePointsCalculation:[@"" stringByAppendingFormat:@"%@",[self->streakDict objectForKey:@"Total"]]];
//                                                                                 [self->starButton setTitle:[@"" stringByAppendingFormat:@"%@+",pointsStr] forState:UIControlStateNormal];
//                                                                             }else{
//                                                                                 [self->starButton setTitle:[@"" stringByAppendingFormat:@"%@",[self->streakDict objectForKey:@"Total"]] forState:UIControlStateNormal];
//                                                                             }
////                                                                             if ([[self->streakDict objectForKey:@"CurrentStreak"]intValue]>=1 && [[self->streakDict objectForKey:@"CurrentStreak"]intValue]<=91 && [[self->streakDict objectForKey:@"CurrentStreak"]intValue]!=19 && [[self->streakDict objectForKey:@"CurrentStreak"]intValue]!=20) {
////                                                                                                                                                              NSDateFormatter *df = [[NSDateFormatter alloc] init];
////                                                                                                                                                              [df setDateFormat:@"yyyy-MM-dd"];
////
////                                                                             //                                                                                if([defaults boolForKey:@"isSpalshShown"]){
////                                                                                                                                                                 if ([Utility isEmptyCheck:[defaults objectForKey:@"todaySet"]]) {
////                                                                                                                                                                     if ([defaults boolForKey:@"isTodayFirst"]) {
////                                                                                                                                                                         [defaults setBool:NO forKey:@"isTodayFirst"];
////                                                                                                                                                                         NSString *curentDateStr = [df stringFromDate:[NSDate date]];
////                                                                                                                                                                         [defaults setObject:curentDateStr forKey:@"StreakCurrentDate"];
////                                                                                                                                                                         [defaults setObject:@"YES" forKey:@"todaySet"];
////                                                                                                                                                                     }
////                                                                                                                                                                 }else{
////                                                                                                                                                                     NSString *prevdateStr =[defaults objectForKey:@"StreakCurrentDate"];
////                                                                                                                                                                     NSString *currentDateStr = [df stringFromDate:[NSDate date]];
////                                                                                                                                                                     if ([prevdateStr isEqualToString:currentDateStr]) {
////                                                                                                                                                                         [defaults setObject:@"NO" forKey:@"todaySet"];
////                                                                                                                                                                     }else{
////                                                                                                                                                                         [defaults setObject:@"YES" forKey:@"todaySet"];
////                                                                                                                                                                     }
////                                                                                                                                                                     NSString *curentDateStr = [df stringFromDate:[NSDate date]];
////                                                                                                                                                                     [defaults setObject:curentDateStr forKey:@"StreakCurrentDate"];
////                                                                                                                                                                 }
////                                                                                                                                                                 NSString *str = [defaults objectForKey:@"todaySet"];
////
////                                                                                                                                                                 if ([str isEqualToString:@"YES"]) {
////                                                                    //
////                                                                    //                                                                                                                                                                     if(![Utility isFullUser]){
////                                                                    //                                                                                                                                                                         return;
////                                                                    //                                                                                                                                                                     }
////                                                                    //
////                                                                    //                                                                                                                                                                     BadgePopUpViewController *custom = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BadgePopUpView"];
////                                                                    //                                                                                                                                                                     custom.modalPresentationStyle = UIModalPresentationCustom;
////                                                                    //                                                                                                                                                                     custom.streakDict = self->streakDict;
////                                                                    //                                                                                                                                                                     custom.parentController = self;
////                                                                    //                                                                                                                                                                     [self presentViewController:custom animated:YES completion:nil];
////                                                                                                                                                                 }else{
////                                                                                                                                                                     //[self GetLearnNotification_webServiceCall];
////                                                                                                                                                                 }
////                                                                             //                                                                                }
////
////                                                                             }
//
//                                                                         }else{
//                                                                             [self->starButton setTitle:@"" forState:UIControlStateNormal];
//                                                                         }
                                                                         
                                                                         
//                                                                         if (![Utility isEmptyCheck:[self->streakDict objectForKey:@"CurrentStreak"]]) {
//
//                                                                             double points = [[self->streakDict objectForKey:@"CurrentStreak"]doubleValue];
//                                                                             if (points>999) {
//                                                                                 NSString *pointsStr = [self gratitudePointsCalculation:[@"" stringByAppendingFormat:@"%@",[self->streakDict objectForKey:@"CurrentStreak"]]];
//                                                                                 [self->starButton setTitle:[@"" stringByAppendingFormat:@"%@+",pointsStr] forState:UIControlStateNormal];
//                                                                             }else{
//                                                                                 [self->starButton setTitle:[@"" stringByAppendingFormat:@"%@",[self->streakDict objectForKey:@"CurrentStreak"]] forState:UIControlStateNormal];
//                                                                             }
//
//                                                                             if ([[self->streakDict objectForKey:@"CurrentStreak"]intValue]>=1 && [[self->streakDict objectForKey:@"CurrentStreak"]intValue]<=21 && [[self->streakDict objectForKey:@"CurrentStreak"]intValue]!=19 && [[self->streakDict objectForKey:@"CurrentStreak"]intValue]!=20) {
//                                                                                 NSDateFormatter *df = [[NSDateFormatter alloc] init];
//                                                                                 [df setDateFormat:@"yyyy-MM-dd"];
//
////                                                                                if([defaults boolForKey:@"isSpalshShown"]){
//                                                                                    if ([Utility isEmptyCheck:[defaults objectForKey:@"todaySet"]]) {
//                                                                                        if ([defaults boolForKey:@"isTodayFirst"]) {
//                                                                                            [defaults setBool:NO forKey:@"isTodayFirst"];
//                                                                                            NSString *curentDateStr = [df stringFromDate:[NSDate date]];
//                                                                                            [defaults setObject:curentDateStr forKey:@"StreakCurrentDate"];
//                                                                                            [defaults setObject:@"YES" forKey:@"todaySet"];
//                                                                                        }
//                                                                                    }else{
//                                                                                        NSString *prevdateStr =[defaults objectForKey:@"StreakCurrentDate"];
//                                                                                        NSString *currentDateStr = [df stringFromDate:[NSDate date]];
//                                                                                        if ([prevdateStr isEqualToString:currentDateStr]) {
//                                                                                            [defaults setObject:@"NO" forKey:@"todaySet"];
//                                                                                        }else{
//                                                                                            [defaults setObject:@"YES" forKey:@"todaySet"];
//                                                                                        }
//                                                                                        NSString *curentDateStr = [df stringFromDate:[NSDate date]];
//                                                                                        [defaults setObject:curentDateStr forKey:@"StreakCurrentDate"];
//                                                                                    }
//                                                                                    NSString *str = [defaults objectForKey:@"todaySet"];
//                                                                                    if ([str isEqualToString:@"YES"]) {
//                                                                                        BadgePopUpViewController *custom = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BadgePopUpView"];
//                                                                                        custom.modalPresentationStyle = UIModalPresentationCustom;
//                                                                                        custom.streakDict = self->streakDict;
//                                                                                        [self presentViewController:custom animated:YES completion:nil];
//                                                                                    }
////                                                                                }
//                                                                             }
//                                                                         }else{
//                                                                             [self->starButton setTitle:@"" forState:UIControlStateNormal];
//                                                                         }
                                                                     }
                                                                     else{
//                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
//                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

-(void)getUserRewardPoints_webServiceCall:(UIViewController*)controller{ //gami_badge_popup_train //14may2018
    if (Utility.reachable) {
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserRewardPoints" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"RewardPoints"]]) {
                                                                             
                                                                             NSNumber * allTime = [responseDict objectForKey:@"RewardPoints"];
                                                                             
                                                                             if (![Utility isEmptyCheck:[Utility getPointsImage:[allTime doubleValue]]]) {
                                                                                 
                                                                                 NSDictionary *badgeDict = [Utility getPointsImage:[allTime doubleValue]];
                                                                                 
                                                                                 if ([[badgeDict objectForKey:@"pointRange"] isEqualToString:@"25000"]) {
                                                                                     [self->starButton setBackgroundColor:[UIColor blackColor]];
                                                                                 }else{
                                                                                     [self->starButton setBackgroundColor:[Utility colorWithHexString:[badgeDict objectForKey:@"colorCode"]]];
                                                                                 }
                                                                                 
                                                                                 NSLog(@"check-%@",[defaults objectForKey:@"BadgeImageText"]);
                                                                                 
                                                                                 
                                                                                 if (![[badgeDict objectForKey:@"imageText"] isEqualToString:[defaults objectForKey:@"BadgeImageText"]] && ![Utility isEmptyCheck:[defaults objectForKey:@"BadgeImageText"]]) {
                                                                                     if ([allTime doubleValue]>[[defaults objectForKey:@"Points"]doubleValue]) {
                                                                                         [Utility showBadgePopUp:self ofType:[badgeDict objectForKey:@"imageText"] withcolourCode:[badgeDict objectForKey:@"colorCode"] ofRange:[badgeDict objectForKey:@"pointRange"]];
                                                                                     }
                                                                                 }
                                                                                 
                                                                                 [defaults setObject:[badgeDict objectForKey:@"imageText"] forKey:@"BadgeImageText"];
                                                                                 [defaults setDouble:[allTime doubleValue] forKey:@"Points"];
                                                                                 
                                                                                 [self->starButton setTitle:[@"" stringByAppendingFormat:@"%@",allTime] forState:UIControlStateNormal];
                                                                             }
                                                                             
                                                                         }else{
                                                                             NSDictionary *badgeDict = [Utility getPointsImage:0];
                                                                             
                                                                             [self->starButton setBackgroundColor:[Utility colorWithHexString:[badgeDict objectForKey:@"colorCode"]]];
                                                                             [self->starButton setTitle:@"0" forState:UIControlStateNormal];
                                                                         }
                                                                     }
                                                                     else{
                                                                         //[Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
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
-(void)isCacheExpired_webServiceCall{
    if (Utility.reachable) {
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
//        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"IsCacheExpired" append:@""forAction:@"POST"];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMeditationCacheExpiryTime" append:@""forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         NSDateFormatter *df = [NSDateFormatter new];
                                                                         [df setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
                                                                         [df setTimeZone:[NSTimeZone systemTimeZone]];//timeZoneWithName:@"UTC"
                                                                         NSString *dateStr=[responseDict objectForKey:@"ExpiryDateTime"];
                                                                         NSDate *expDate=[df dateFromString:dateStr];
                                                                         
                                                                         NSDate *meditationSyncDate=[defaults objectForKey:@"MeditationListSyncDate"];
                                                                         NSString *syncDateStr=[df stringFromDate:meditationSyncDate];
                                                                         meditationSyncDate=[df dateFromString:syncDateStr];
                                                                         
                                                                         NSComparisonResult result;
                                                                         result=[expDate compare:meditationSyncDate];
                                                                         
                                                                         if (![Utility isEmptyCheck:expDate] && ![Utility isEmptyCheck:meditationSyncDate]) {
                                                                             if ([expDate compare:meditationSyncDate]==NSOrderedDescending) {
                                                                                 [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadWebinarList" object:self userInfo:nil];
                                                                             }
                                                                         }
                                                                         NSLog(@"sf");

//                                                                         if ([[responseDict objectForKey:@"IsExpired"]boolValue]) {
//////                                                                             [defaults setBool:true forKey:@"IsExpired"];
//                                                                         }else{
////                                                                             [defaults setBool:false forKey:@"IsExpired"];
//                                                                         }
                                                                     }
                                                                     else{
                                                                         //[Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
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
-(void)logAppUsage_webServiceCall{
    if (Utility.reachable) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            if (self->contentView) {
        //                [self->contentView removeFromSuperview];
        //            }
        //            self->contentView = [Utility activityIndicatorView:self];
        //        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *todayStr = [df stringFromDate:[NSDate date]];
        [mainDict setObject:todayStr forKey:@"CurrentDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"LogAppUsage" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 //                                                                 if (self->contentView) {
                                                                 //                                                                     [self->contentView removeFromSuperview];
                                                                 //                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         NSLog(@"%@",responseDict);
                                                                         [self GetStreakData_webServiceCall];
                                                                     }
                                                                     else{
                                                                         NSLog(@"%@",error.localizedDescription);
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     NSLog(@"%@",error.localizedDescription);
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

-(void)webServiceCall_GetUnreadMessageCountForUser:(UIViewController*)controller{
    if (Utility.reachable) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            if (self->contentView) {
        //                [self->contentView removeFromSuperview];
        //            }
        //            self->contentView = [Utility activityIndicatorView:self];
        //        });
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        //        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUnreadMessageCountForMbhqUser" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  //                                                                  if (self->contentView) {
                                                                  //                                                                      [self->contentView removeFromSuperview];
                                                                  //                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          
                                                                          int unreadMessageCount = [[responseDict objectForKey:@"UnreadMessageCount"]intValue];
                                                                          int unreadArticleCount = [[responseDict objectForKey:@"UnreadArticleCount"]intValue];
                                                                          
                                                                          if (unreadMessageCount==0) {
                                                                              self->chatButtonView.hidden=true;
                                                                          }else if (unreadMessageCount==1){
                                                                              self->chatButtonView.hidden=true;//false
                                                                              self->chatButton.badgeValue = @"1";
//                                                                              self->chatButton.badgeValue = [NSString stringWithFormat:@"%i", (int) unreadMessageCount];
                                                                          }else if (unreadMessageCount>1){
                                                                              self->chatButtonView.hidden=true;//false
                                                                              self->chatButton.badgeValue = @"1+";
                                                                          }
                                                                          
                                                                          if (unreadArticleCount==0) {
                                                                              self->articleNotificationView.hidden=true;
                                                                          }else if (unreadArticleCount==1){
                                                                              self->articleNotificationView.hidden=true;//false
                                                                              [self->notificationButton setTitle:@"1" forState:UIControlStateNormal];
                                                                          }else if (unreadArticleCount>1){
                                                                              self->articleNotificationView.hidden=true;//false
                                                                              [self->notificationButton setTitle:@"1+" forState:UIControlStateNormal];
                                                                          }
                                                                      }
                                                                      else{
//                                                                          [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                          return;
                                                                      }
                                                                  }else{
//                                                                      [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                  }
                                                              });
                                                              
                                                          }];
        [dataTask resume];
        
    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}



//chayan 27/11/2019
-(void)GetLearnNotification_webServiceCall{//Message Notifcation
    
//    if(![Utility isFullUser]){
//        return;
//    }
    
    if (Utility.reachable) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            if (self->contentView) {
        //                [self->contentView removeFromSuperview];
        //            }
        //            self->contentView = [Utility activityIndicatorView:self];
        //        });
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"AbbbcUserSessionId"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"HasNewNotifications" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 //                                                                 if (self->contentView) {
                                                                 //                                                                     [self->contentView removeFromSuperview];
                                                                 //                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         
                                                                         BOOL isMessage = [[responseDict objectForKey:@"HasNewMessages"]boolValue];
                                                                         
                                                                         BOOL isSeminar = [[responseDict objectForKey:@"HasNewSeminars"] boolValue];
                                                                         
                                                                         NSString *courseName = @"";
                                                                         if(![Utility isEmptyCheck:[responseDict objectForKey:@"CourseName"]]){
                                                                             courseName = [@"" stringByAppendingFormat:@"%@",[responseDict objectForKey:@"CourseName"]];
                                                                         }
                                                                         
                                                                         [self showLearnNotification:isMessage isSeminar:isSeminar courseName:courseName];
                                                                         
                                                                     }
                                                                     else{
                                                                         //[Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     //[Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
       // [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

-(void)getNotification_CommunityWebserviceCall{
    if (Utility.reachable) {
        NSString *post =[NSString stringWithFormat:@"fetch=notifications,friend_requests,count_new_messages&server_key=%@",CommunityServerKey];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *utlStr = @"https://forum.mindbodyhq.com/api/get-general-data";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"forumAccessToken"]]) {
            utlStr = [@"" stringByAppendingFormat:@"%@?access_token=%@",utlStr,[defaults objectForKey:@"forumAccessToken"]];
        }
        [request setURL:[NSURL URLWithString:utlStr]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         if ([Utility isEmptyCheck:responseString]) {
             return ;
         }
         NSLog(@"%@",responseString);
         NSMutableDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"api_status"]intValue] == 200) {
               dispatch_async(dispatch_get_main_queue(), ^{

                        int newNotificationsCount = 0;
                        int newfriendNotificationsCount = 0;
                        int newMsgNotificationsCount = 0;
                        if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"new_notifications_count"]]) {
                            newNotificationsCount = [[responseDictionary objectForKey:@"new_notifications_count"]intValue];

                        }
                        if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"new_friend_requests_count"]]) {
                            newfriendNotificationsCount = [[responseDictionary objectForKey:@"new_friend_requests_count"]intValue];
                        }
                        if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"count_new_messages"]]) {
                             newMsgNotificationsCount = [[responseDictionary objectForKey:@"count_new_messages"]intValue];

                        }

                       int totalNotificationCount = newNotificationsCount+newfriendNotificationsCount+newMsgNotificationsCount;
                       if (totalNotificationCount>0) {
                             self->forumbadgeCount.hidden = false;
                               [self->forumbadgeCount setTitle:[@"" stringByAppendingFormat:@"%d",totalNotificationCount] forState:UIControlStateNormal];
                            }else{
                                self->forumbadgeCount.hidden = true;
                         }
                        [UIApplication sharedApplication].applicationIconBadgeNumber = totalNotificationCount;

                     });
                 }
             }];
         [dataTask resume];
     }
 }





#pragma mark  -End

#pragma mark - Private Method

-(void) updateBadge {
    
    // The message view open with this thread?
    // Get the number of unread messages
//    int count = NM.currentUser.unreadMessageCount;
//
//    chatButton.badgeValue = [NSString stringWithFormat:@"%i", (int) count];
//    if(count>0){
//        chatButton.hidden = false;
//    }else{
//        chatButton.hidden = true;
//    }
    // This way does not set the tab bar number
    //[BInterfaceManager sharedManager].a.privateThreadsViewController.tabBarItem.badgeValue = badge;
    
}
-(void)updateBadgePoint:(NSNotification*)notfication{ //gami_badge_popup
    if ([notfication.name isEqualToString:@"UpdateBadgePoint"]) {
//        [self getUserRewardPoints_webServiceCall:notfication.object];
    }
}

-(void)updateOnlineOfflineStatus{
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
                                   [self logoButtonPressed:0];
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
-(void)squadAppLog{
   
    starButton.layer.cornerRadius = starButton.frame.size.height/2.0;
    starButton.clipsToBounds = YES;
    self->starButton.backgroundColor = [Utility colorWithHexString:@"000000"];
    starButton.titleLabel.textColor = [UIColor whiteColor];
    
    [self logAppUsage_webServiceCall];
}

-(void) squadNotificationLog{
    notificationButton.clipsToBounds = YES;
}

-(void)freeModePopUpDetails{
        if (![Utility isEmptyCheck:[defaults objectForKey:@"TrialStartDate"]]) {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            [calendar setTimeZone:[NSTimeZone systemTimeZone]];
            NSDate *installationDate = [defaults objectForKey:@"TrialStartDate"];
            NSDate *day1;
            if([installationDate isToday]){
                day1 =  [calendar dateByAddingUnit:NSCalendarUnitMinute
                                             value:10
                                            toDate:installationDate
                                           options:0];
                NSDate *currentDate = [NSDate date];
                
                if(day1 && [currentDate isLaterThan:day1]){
                    [defaults setBool:true forKey:@"IsPopUpShowForFreeMode"];
                    FreeModeAlertViewController *controller =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FreeModeAlertView"];
                    [self.navigationController pushViewController:controller animated:NO];
//                    controller.modalPresentationStyle = UIModalPresentationCustom;
//                    [self presentViewController:controller animated:YES completion:nil];
                }
            }
        }
}

-(NSString*)gratitudePointsCalculation:(NSString*)points{
    NSString *firstStr = @"";
    NSRange myRange = NSMakeRange(0, 1);
    firstStr = [points substringWithRange:myRange];
    return firstStr;
}


//chayan 27/11/2019
-(void)showLearnNotification:(BOOL)isMessage isSeminar:(BOOL)isSeminar courseName:(NSString *)courseName{
    
    if(!isSeminar && !isMessage) return;
    
    if(isMessage && ([self.parentViewController isKindOfClass:[AllMessageViewController class]] || [self.parentViewController isKindOfClass:[AllMessageDetailsViewController class]])){
        return;
    }
    
    if(isSeminar && ([self.parentViewController isKindOfClass:[CoursesListViewController class]] || [self.parentViewController isKindOfClass:[CourseDetailsViewController class]] || [self.parentViewController isKindOfClass:[CourseArticleDetailsViewController class]])){
        return;
    }
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LearnNotificationViewController *learn=[storyboard instantiateViewControllerWithIdentifier:@"LearnNotificationView"];
    learn.modalPresentationStyle = UIModalPresentationCustom;
    learn.isMessage = isMessage;
    learn.isSeminar = isSeminar;
    learn.courseName = courseName;
    learn.fromContoller = self.parentViewController;
    [self presentViewController:learn animated:YES completion:nil];
    
}

-(BOOL)lockUnlockDetails:(int)totalStreak{
 
    BOOL isPopUp = false;
    if (totalStreak==3 || totalStreak==7 || totalStreak==14 || totalStreak==21 || totalStreak==28 ||totalStreak==35 ||totalStreak==42 || totalStreak==50 || totalStreak==75 || totalStreak==100 || totalStreak==125 || totalStreak==150 || totalStreak==175 || totalStreak==200 || totalStreak==225||totalStreak==250 ||totalStreak==275||totalStreak==300 ||totalStreak==325||totalStreak==350 ||totalStreak==375||totalStreak==400||totalStreak==425||totalStreak==450||totalStreak==475||totalStreak==500||totalStreak==550||totalStreak==600||totalStreak==650||totalStreak==700||totalStreak==750||totalStreak==800||totalStreak==850||totalStreak==900||totalStreak==950||totalStreak==1000||totalStreak==1100||totalStreak==1200||totalStreak==1300||totalStreak==1400||totalStreak==1500||totalStreak==1600||totalStreak==1700||totalStreak==1800||totalStreak==1900||totalStreak==2000||totalStreak==2250||totalStreak==2500||totalStreak==2750||totalStreak==3000||totalStreak==5000||totalStreak==10000){
        isPopUp = true;
    }
    return isPopUp;
}



#pragma mark - End

#pragma maek - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - End




@end

