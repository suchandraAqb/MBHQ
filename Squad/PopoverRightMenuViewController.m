//
//  PopoverRightMenuViewController.m
//  Squad
//
//  Created by Amit Yadav on 01/09/22.
//  Copyright © 2022 AQB Solutions. All rights reserved.
//

#import "PopoverRightMenuViewController.h"
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

@interface PopoverRightMenuViewController (){
    IBOutlet UIButton *communityForumButton;
    IBOutlet UIButton *liveChatsButton;
    AppDelegate *appDelegate;
}
@end

@implementation PopoverRightMenuViewController

@synthesize parent;

#pragma mark -View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    communityForumButton.layer.cornerRadius=10.0;
    communityForumButton.clipsToBounds=YES;
    liveChatsButton.layer.cornerRadius=10.0;
    liveChatsButton.clipsToBounds=YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)liveChatButtonPressed:(UIButton *)sender{
    
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

-(IBAction)communityForumButtonPressed:(UIButton *)sender{
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
//{
//    [self dismissViewControllerAnimated:NO completion:nil];
//    dispatch_async(dispatch_get_main_queue(),^ {
//        NSString *urlString=@"https://www.facebook.com/groups/250625228700325";
//        FBForumViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FBForum"];
//        controller.urlString = urlString;
//        [self.parent.navigationController pushViewController:controller animated:YES];
//    });
//}

-(IBAction)closeButtonPressed:(UIButton *)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
