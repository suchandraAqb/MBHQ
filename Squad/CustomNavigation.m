//
//  CustomNavigation.m
//  Squad
//
//  Created by aqb-mac-mini3 on 31/01/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "CustomNavigation.h"


UIView *contentView;
UIViewController *currController;
BOOL frmMenu;
int stepnumber;
int apiCount;
NSDictionary *currprogram;
NSDictionary *navigationDict;
NSString *programNameForExercise;
NSString *programNameForNutrition;
int ProgramIdForNutrition;
int ProgramIdForExercise;

//UIViewController *topController;

@implementation CustomNavigation
//@synthesize navigationDict;



#pragma mark - Navigation

+(void)startNavigation:(UIViewController *)currentController fromMenu:(BOOL)fromMenu navDict:(NSDictionary *)navDict{
    currController = currentController;
    frmMenu = fromMenu;
    navigationDict = navDict;
    UIViewController *topController;
    if([currController.slidingViewController.topViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)currController.slidingViewController.topViewController;
        NSArray *controllers = [nav viewControllers];
        topController = [controllers lastObject];
        NSLog(@"Top Controller:%@",topController.debugDescription);
    }else{
        topController = currController.slidingViewController.topViewController;
    }
    
    NSString *identifier = [navigationDict objectForKey:@"Identifier"];
    if (![Utility isEmptyCheck:identifier]) {
        
        //no navigation
        if ([identifier caseInsensitiveCompare:@"FbWorldForumUrl"] == NSOrderedSame){
            [self fbForumButtonPressed:identifier];
            return;
        }else if ([identifier caseInsensitiveCompare:@"snapchat"] == NSOrderedSame){
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:currController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:currController];
                return;
            }
            NSURL *url = [NSURL URLWithString:@"snapchat://chat/Ashybines1"];
            if([[UIApplication sharedApplication] canOpenURL:url]){
                     [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                                                 if(success){
                                                     NSLog(@"Opened");
                                                     }
                                             }];
                   }
            
            else {
                url = [NSURL URLWithString:@"https://snapchat.com/add/Ashybines1:"];
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                                          if(success){
                                              NSLog(@"Opened");
                                              }
                                      }];
            }
        }
        
        UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
        if ([topController isKindOfClass:[myController class]]) {
            if (fromMenu) {
                [currController.slidingViewController anchorTopViewToLeftAnimated:YES];
                [currController.slidingViewController resetTopViewAnimated:YES];
            } else {
                
            }
            return;
        }
        
        //to collect some variable and extra data if needed
        if ([identifier caseInsensitiveCompare:@"HomePage"] == NSOrderedSame){
            HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }
        else if ([identifier caseInsensitiveCompare:@"TodayHome"] == NSOrderedSame){
            TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }
        else if ([identifier caseInsensitiveCompare:@"MyPrograms"] == NSOrderedSame){
            MyProgramsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"HabitHackerListView"] == NSOrderedSame){
            HabitHackerListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }
        
        else if ([identifier caseInsensitiveCompare:@"HelpView"] == NSOrderedSame){
            HelpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"GamificationView"] == NSOrderedSame){
            GamificationViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"MeditationReward"] == NSOrderedSame){
            MeditationRewardViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"TrainHome"] == NSOrderedSame){
            TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"Nourish"] == NSOrderedSame){
            NourishViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"LearnHome"] == NSOrderedSame){
            LearnHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"Connect"] == NSOrderedSame){
            ConnectViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"AchieveHome"] == NSOrderedSame){
            AchieveHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"Appreciate"] == NSOrderedSame){
            AppreciateViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"Track"] == NSOrderedSame){
            TrackViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"ViewPersonalSession"] == NSOrderedSame){
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:currController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:currController];
                return;
            }
            
            if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]){
                [Utility showTrailLoginAlert:currController ofType:currController];
                return;
            }
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                int currentStep = [[defaults objectForKey:@"CustomExerciseStepNumber"] intValue];
                
                if([Utility isOfflineMode] && currentStep == 0){
                    
                    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
                    if(![DBQuery isRowExist:@"customExerciseList" condition:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]]){
                        
                        [Utility msg:@"You are in OFFLINE mode and custom sessions hasn't been previously downloaded. Please remove offline mode and download this session while you have access to the internet." title:@"Oops!" controller:currController haveToPop:NO];
                        return;
                        
                    }// AY 20032018
                    
                    ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
                    myController = controller;
                }else{
                    [Utility msg:@"Please go online and complete required steps to access this feature." title:@"Oops!" controller:currController haveToPop:NO];
                }
            }else{
                [self checkStepNumberForSetupWithAPI:@"CheckStepNumberForSetup"];
                return;
            }
            
        }else if ([identifier caseInsensitiveCompare:@"ExerciseDailyList"] == NSOrderedSame){
            if ([Utility isSubscribedUser] && [Utility isOfflineMode]) {
                int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
                if(![DBQuery isRowExist:@"dailyworkout" condition:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]]){
                    
                    [Utility msg:@"You are in OFFLINE mode and daily sessions hasn't been previously downloaded. Please remove offline mode and download this session while you have access to the internet." title:@"Oops!" controller:currController haveToPop:NO];
                    return;
                }
            }
            ExerciseDailyListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"ChalengesHome"] == NSOrderedSame){
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:currController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:currController];
                return;
            }
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            
            if([Utility isSubscribedUser]){
                ChalengesHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
                myController = controller;
            }else{
                [Utility showSubscribedAlert:currController];
                return;
            }
        }else if ([identifier caseInsensitiveCompare:@"FitnessTracker"] == NSOrderedSame){
           
        }else if ([identifier caseInsensitiveCompare:@"TrackMiddle"] == NSOrderedSame){
           
        }else if ([identifier caseInsensitiveCompare:@"AudioBook"] == NSOrderedSame){
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:currController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:currController];
                return;
            }
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            AudioBookViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"RoundList"] == NSOrderedSame){
            RoundListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"SessionList"] == NSOrderedSame){
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:currController];
                return;
            }
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            SessionListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"ExerciseList"] == NSOrderedSame){
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:currController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:currController];
                return;
            }
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            ExerciseListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"CircuitList"] == NSOrderedSame){
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:currController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:currController];
                return;
            }
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            
            CircuitListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"CustomNutritionPlanList"] == NSOrderedSame){
            [self webSerViceCall_GetSquadCurrentProgram];
            return;
        }else if ([identifier caseInsensitiveCompare:@"ShoppingListView"] == NSOrderedSame){
            [self webSerViceCall_GetSquadCurrentProgram];
            return;
        }else if ([identifier caseInsensitiveCompare:@"MealMatchView"] == NSOrderedSame){
            [self webSerViceCall_GetSquadCurrentProgram];
            return;
        }else if ([identifier caseInsensitiveCompare:@"FoodPrep"] == NSOrderedSame){
            if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
                [Utility showTrailLoginAlert:currController ofType:currController];
                return;
            }
            FoodPrepViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"SavedNutritionPlan"] == NSOrderedSame){
            if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
                [Utility showTrailLoginAlert:currController ofType:currController];
                return;
            }
            SavedNutritionPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"RecipeList"] == NSOrderedSame){
            RecipeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"IngredientList"] == NSOrderedSame){
            IngredientListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"DailyGoodness"] == NSOrderedSame){
            DailyGoodnessViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"BlankList"] == NSOrderedSame){
            BlankListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"CoursesList"] == NSOrderedSame){
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:currController];
                return;
            }
            if (![Utility isEmptyCheck:[defaults objectForKey:@"RunningVideoSection"]]) {
                if ([[defaults objectForKey:@"RunningVideoSection"] isEqualToString:@"Course"]) {
                    if (![Utility isEmptyCheck:[defaults objectForKey:@"PlayingCourse"]]) {
                        NSString *courseStr=[defaults objectForKey:@"PlayingCourse"];
                        NSData *data = [courseStr dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        CourseArticleDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseArticleDetails"];
                        controller.courseId = [dict valueForKey:@"CourseId"];
                        controller.articleId = [dict objectForKey:@"ArticleId"];
                        controller.autherStr = [dict objectForKey:@"AuthorName"];
                        controller.taskId = [dict objectForKey:@"TaskId"];
                        myController = controller;
                    }
                }
            }else{
                CoursesListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
                myController = controller;
            }
        }else if ([identifier caseInsensitiveCompare:@"CourseDetails"] == NSOrderedSame){
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:currController];
                return;
            }
            CourseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            controller.isFromMenu=YES;
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"SetProgramView"] == NSOrderedSame){//set program
            if([Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]){
                
                if([defaults boolForKey:@"dontShowSetProgramAlert"]){
                    [self checkStepNumberForSetupWithAPI:@"CheckUserProgramStep"];
                }else{
                    NSString *msgStr = @"\nSet programs do not follow all of your custom meal or workout preferences This is so your preferences won’t effect the results of the program. Your preferences will work again once you finish the program and move back to your custom nutrition or workout plan.";
                    
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@"Please Note:"
                                                          message:msgStr
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction
                                               actionWithTitle:@"Close"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action)
                                               {
                                                   [self checkStepNumberForSetupWithAPI:@"CheckUserProgramStep"];
                                               }];
                    
                    UIAlertAction *cancelAction = [UIAlertAction
                                                   actionWithTitle:@"Dont show me again."
                                                   style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action)
                                                   {
                                                       [defaults setBool:true forKey:@"dontShowSetProgramAlert"];
                                                       [self checkStepNumberForSetupWithAPI:@"CheckUserProgramStep"];
                                                   }];
                    [alertController addAction:okAction];
                    [alertController addAction:cancelAction];
                    
                    [currController presentViewController:alertController animated:YES completion:nil];
                }
                return;
            }else{
                //[Utility showSubscribedAlert:self];
                SetProgramViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
                myController = controller;
            }
        }else if ([identifier caseInsensitiveCompare:@"WebinarListView"] == NSOrderedSame){
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:currController];
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
                        myController = controller;
                    }
                }
            }else{
                WebinarListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];//TagID
                if (![Utility isEmptyCheck:[navigationDict objectForKey:@"TagID"]]) {
                    controller.isNotFromHome = YES;
                    NSString *tagName;
                    if ([[navigationDict objectForKey:@"TagID"] intValue] == 33) {
                        tagName = @"Meditation";
                    } else if ([[navigationDict objectForKey:@"TagID"] intValue] == 59){
                        tagName = @"Mindfulness";
                    }
                    controller.selectedFilterDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:[[navigationDict objectForKey:@"TagID"] intValue]],@"TagID",tagName,@"EventTagName", nil];
                }
                myController = controller;
            }
        }else if ([identifier caseInsensitiveCompare:@"Calendar"] == NSOrderedSame){
            CalendarViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            if (![Utility isEmptyCheck:[navigationDict objectForKey:@"isFromAshyLive"]]) {
                controller.isFromAshyLive = [[navigationDict objectForKey:@"isFromAshyLive"]boolValue];
            }
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"MyWatchList"] == NSOrderedSame){
            MyWatchListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"FindAFriend"] == NSOrderedSame){
           
        }else if ([identifier caseInsensitiveCompare:@"ChannelList"] == NSOrderedSame){
            ChannelListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"ChatSDKMessagesView"] == NSOrderedSame){
           
        }
        //***Ru***Prev
        //chayan 28/11/2019 -- enable this code
         else if ([identifier caseInsensitiveCompare:@"VisionHome"] == NSOrderedSame){
         VisionHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
         myController = controller;
         }
         
         //***Ru***Updated
        else if ([identifier caseInsensitiveCompare:@"AddVisionBoard"] == NSOrderedSame){
            AddVisionBoardViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }
        else if ([identifier caseInsensitiveCompare:@"VisionGoalAction"] == NSOrderedSame){
            VisionGoalActionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"PersonalChallenge"] == NSOrderedSame){
            PersonalChallengeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"AccountabilityBuddyHomeView"] == NSOrderedSame){
            AccountabilityBuddyHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"BucketListNew"] == NSOrderedSame){
            BucketListNewViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"GratitudeView"] == NSOrderedSame){
            GratitudeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"Achievements"] == NSOrderedSame){
            AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"MyDiaryList"] == NSOrderedSame){
            MyDiaryListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"QuoteGalleryView"] == NSOrderedSame){
            QuoteGalleryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"MyPhotosDefault"] == NSOrderedSame){
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:currController];
                return;
            }
            MyPhotosDefaultViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"QuestionnaireHomeView"] == NSOrderedSame){
            if ([Utility isOnlyProgramMember]) {
                return;
            }
            QuestionnaireHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"FBWHome"] == NSOrderedSame){
            FBWHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"AddRecipeView"] == NSOrderedSame){
            AddRecipeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"NutritionSettingHomeView"] == NSOrderedSame){
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:currController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:currController];
                return;
            }
            [self webserviceCall_CheckMiniProgramForNutrition];
            return;
        }else if ([identifier caseInsensitiveCompare:@"DailyGoodnessDetail"] == NSOrderedSame){
            DailyGoodnessDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            if (![Utility isEmptyCheck:[navigationDict objectForKey:@"mealId"]]) {
                controller.mealId = [navigationDict objectForKey:@"mealId"];
            }
            if (![Utility isEmptyCheck:[navigationDict objectForKey:@"dateString"]]) {
                controller.dateString = [navigationDict objectForKey:@"dateString"];
            }
            if (![Utility isEmptyCheck:[navigationDict objectForKey:@"fromController"]]) {
                controller.fromController = [navigationDict objectForKey:@"fromController"];
            }
            if (![Utility isEmptyCheck:[navigationDict objectForKey:@"showTab"]]) {
                controller.showTab = [navigationDict objectForKey:@"showTab"];
            }
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"CustomExerciseSettings"] == NSOrderedSame){
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:currController];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:currController];
                return;
            }
            [self webserviceCall_CheckMiniProgramForExercise];
            return;
        }else if ([identifier caseInsensitiveCompare:@"TrackAll"] == NSOrderedSame){
            TrackAllViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"VitaminView"] == NSOrderedSame){
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:currController];
                return;
            }
            VitaminViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"CommunityView"] == NSOrderedSame){
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:currController];
                return;
            }
            CommunityViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            myController = controller;
        }else if ([identifier caseInsensitiveCompare:@"AfterTrial"] == NSOrderedSame){
            
            AfterTrialViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
            if (![Utility isEmptyCheck:[navigationDict objectForKey:@"isTrail"]]) {
                controller.isTrail = [navigationDict objectForKey:@"isTrail"];
            }
//            if (![Utility isEmptyCheck:[navigationDict objectForKey:@"isNourish"]]) {
//                controller.isNourish = [navigationDict objectForKey:@"isNourish"];
//            }
            if (![Utility isEmptyCheck:[navigationDict objectForKey:@"isAchieve"]]) {
                controller.isAchieve = [navigationDict objectForKey:@"isAchieve"];
            }
            myController = controller;
        }
        
        
        
        BOOL animated = true;
        if ([myController isKindOfClass:[RecipeListViewController class]]) {
            animated = false;
        }
        if (fromMenu) {
            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:myController];
            currController.slidingViewController.topViewController = nav;
            [currController.slidingViewController resetTopViewAnimated:animated];
        }else{
            [currController.navigationController pushViewController:myController animated:false];
        }
    }
    
}
#pragma mark - Private methods
+(void)checkNutritionStep:(int)tag{
    
    UIViewController *myController;
    if ((stepnumber == -1 || stepnumber == 1) && [Utility isEmptyCheck:currprogram] )   {//add1
        ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
        controller.isNutritionSettings=true;
        myController = controller;
    }else if((stepnumber == -1 && ![Utility isEmptyCheck:currprogram])){//add1
        DietaryPreferenceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DietaryPreferenceView"];
        myController = controller;
    }
    else if (stepnumber == 1 || stepnumber == 2) {
        DietaryPreferenceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DietaryPreferenceView"];
        myController = controller;
    }
    else if (stepnumber == 3) {
        MealFrequencyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealFrequencyView"];
        myController = controller;
    }else if (stepnumber == 4){
        MealVarietyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealVarietyView"];
        myController = controller;
    }else if (stepnumber == 5){
        MealPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealPlanView"];
        myController = controller;
    }else{
        if (tag == 1) {//day view
            CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
            controller.isComplete =false;
            controller.stepnumber = stepnumber;
            myController = controller;
        }else if(tag == 2){
            ShoppingListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingListView"];
            myController = controller;
        }else if(tag == 3){//week view
            CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
            controller.isFromShoppingList = YES;
            //    controller.weekDate = weekdate;
            myController = controller;
        }else if(tag == 4){
            MealMatchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealMatchView"];
            myController = controller;
        }else if(tag == 5){
            ShoppingListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingListView"];
            controller.isCustom = true;
            myController = controller;
        }else if(tag == 6){
            SetProgramViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetProgramView"];
            myController = controller;
        }
        
    }
    if (frmMenu) {
        NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:myController];
        currController.slidingViewController.topViewController = nav;
        [currController.slidingViewController resetTopViewAnimated:YES];
    }else{
        [currController.navigationController pushViewController:myController animated:false];
    }
}
+(void)fbForumButtonPressed:(NSString *)url{     //ah ux
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
                                       [self fbForumButtonPressedWithSender:url];
                                   }];
        [alertController addAction:okAction];
        [currController presentViewController:alertController animated:YES completion:nil];
    } else {
        [self fbForumButtonPressedWithSender:url];
    }
}
+(void) fbForumButtonPressedWithSender:(NSString *)url {     //ah ux
    NSString *urlString = @"";
    if ([url compare:@"FbWorldForumUrl"] == NSOrderedSame) {
        urlString = [defaults objectForKey:@"FbWorldForumUrl"];//https://www.facebook.com/groups/250625228700325/
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyyMMdd"];
        NSString *ReferenceEntityId = [df stringFromDate:[NSDate date]];
        NSMutableDictionary *dataDict = [NSMutableDictionary new];
        [dataDict setObject:[NSNumber numberWithInt:2] forKey:@"UserActionId"];
        if(ReferenceEntityId)[dataDict setObject:ReferenceEntityId forKey:@"ReferenceEntityId"];
        [dataDict setObject:@"WorldForum" forKey:@"ReferenceEntityType"];
        
        [Utility addGamificationPointWithData:dataDict];
        
    }else if ([url compare:@"FbCityForumUrl"] == NSOrderedSame) {
        urlString = [defaults objectForKey:@"FbCityForumUrl"];
        
    }else if ([url compare:@"FbSuburbForumUrl"] == NSOrderedSame) {
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
    
}
+(void)checkOfflineAccess{
    [Utility msg:@"You are in OFFLINE mode. Go Online to access this functionality." title:@"Oops!\n" controller:currController haveToPop:NO];
}
#pragma mark - API Calls
+(void) checkStepNumberForSetupWithAPI:(NSString *)apiName {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:currController];
        });
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:currController haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:apiName append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  if (contentView) {
                                                                      [contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          
                                                                          [defaults setInteger:[[responseDict objectForKey:@"StepNumber"] intValue] forKey:@"CustomExerciseStepNumber"];
                                                                          UIViewController *myController;// = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
                                                                          switch ([[responseDict objectForKey:@"StepNumber"] intValue]) {
                                                                                  
                                                                              case -1:
                                                                                  //api call
                                                                                  [self checkStepNumberForSetupWithAPI:@"CheckUserProgramStep"];
                                                                                  break;
                                                                                  
                                                                              case 0:
                                                                              {
                                                                                  //current week
                                                                                  //current week
                                                                                  //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
                                                                                  //                                                                                  if([defaults boolForKey:@"IsNonSubscribedUser"]){
                                                                                  //                                                                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                  //                                                                                  }else{
                                                                                  //
                                                                                  //                                                                                  }
                                                                                  if ([[navigationDict objectForKey:@"Identifier"] caseInsensitiveCompare:@"SetProgramView"] == NSOrderedSame) {
                                                                                      [self webSerViceCall_GetSquadCurrentProgram];
                                                                                      break;
                                                                                  }
                                                                                  ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
                                                                                  //                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  myController = controller;
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 1:
                                                                              {
                                                                                  CustomProgramSetupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomProgramSetup"];
                                                                                  //                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  myController = controller;
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 2:
                                                                              {
                                                                                  ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
                                                                                  //                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  myController = controller;
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 3:
                                                                              {
                                                                                  RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                                  controller.isRateFitness = true;
                                                                                  controller.isWeeklySession = false;
                                                                                  //                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  myController = controller;
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 4:
                                                                              {
                                                                                  RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                                  controller.isRateFitness = false;
                                                                                  controller.isWeeklySession = false;
                                                                                  //                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  myController = controller;
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 5:
                                                                              {
                                                                                  RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                                  controller.isRateFitness = false;
                                                                                  controller.isWeeklySession = true;
                                                                                  //                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  myController = controller;
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 6:
                                                                              {
                                                                                  PersonalSessionsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalSessions"];
                                                                                  //                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  myController = controller;
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 7:
                                                                              {
                                                                                  MovePersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MovePersonalSession"];
                                                                                  //                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  myController = controller;
                                                                                  break;
                                                                              }
                                                                                  
                                                                              default:
                                                                                  break;
                                                                          }
                                                                          if(myController != nil){
                                                                              if (frmMenu) {
                                                                                  NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:myController];
                                                                                  currController.slidingViewController.topViewController = nav;
                                                                                  [currController.slidingViewController resetTopViewAnimated:YES];
                                                                              }else{
                                                                                  [currController.navigationController pushViewController:myController animated:NO];
                                                                              }
                                                                              
                                                                          }
                                                                      }
                                                                      else{
                                                                          [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:currController haveToPop:NO];
                                                                          return;
                                                                      }
                                                                  }else{
                                                                      [Utility msg:error.localizedDescription title:@"Error !" controller:currController haveToPop:NO];
                                                                  }
                                                              });
                                                              
                                                          }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:currController haveToPop:NO];
    }
    
}
+(void)webSerViceCall_GetSquadCurrentProgram{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:currController];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:currController haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadCurrentProgram" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         currprogram = [responseDict objectForKey:@"SquadProgram"];
                                                                     }
                                                                     else{
                                                                         //                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         //return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:currController haveToPop:NO];
                                                                 }
                                                                 
                                                                 [self webSerViceCall_SquadNutritionSettingStep];
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:currController haveToPop:NO];
    }
}


+(void)webSerViceCall_SquadNutritionSettingStep{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:currController];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:currController haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadNutritionSettingStep" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         stepnumber=[[responseDict objectForKey:@"StepNumber"]intValue];
                                                                         NSString *identifier = [navigationDict objectForKey:@"Identifier"];
                                                                         if (![Utility isEmptyCheck:identifier]) {
                                                                             if ([identifier caseInsensitiveCompare:@"CustomNutritionPlanList"] == NSOrderedSame) {
                                                                                 if ([[navigationDict objectForKey:@"isFromShoppingList"]boolValue]) {
                                                                                     [self checkNutritionStep:3];
                                                                                 } else {
                                                                                     [self checkNutritionStep:1];
                                                                                 }
                                                                             }else if ([identifier caseInsensitiveCompare:@"ShoppingListView"] == NSOrderedSame){
                                                                                 if ([[navigationDict objectForKey:@"IsCutom"]boolValue]) {
                                                                                     [self checkNutritionStep:5];
                                                                                 } else {
                                                                                     [self checkNutritionStep:2];
                                                                                 }
                                                                             }else if ([identifier caseInsensitiveCompare:@"MealMatchView"] == NSOrderedSame){
                                                                                 [self checkNutritionStep:4];
                                                                             }else if ([identifier caseInsensitiveCompare:@"SetProgramView"] == NSOrderedSame){
                                                                                 [self checkNutritionStep:6];
                                                                             }
                                                                         }
                                                                         
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:currController haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:currController haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:currController haveToPop:NO];
    }
}
///////////////// FOR NUTRITION SETTINGS /////////////////

+(void)nutritionButtonDetails{
    
    BOOL isSetProgramActive = NO;
    if (![Utility isEmptyCheck:programNameForNutrition] && ProgramIdForNutrition>0) {
        isSetProgramActive = YES;
    }
    
    if (![defaults boolForKey:@"IsNonSubscribedUser"] && ![Utility isSubscribedUser] && ![Utility isSquadLiteUser]) {//today__
        NutritionSettingHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionSettingHomeView"];
        [Utility showTrailLoginAlert:currController ofType:controller];
        return;
    }
    
    if([Utility isSubscribedUser] && [Utility isOfflineMode]){
        [self checkOfflineAccess];
        return;
    }
    dispatch_async(dispatch_get_main_queue(),^ {
        NSString *msgStr=@"";
        NSString *okStr;
        if (isSetProgramActive) {
            msgStr = [@"" stringByAppendingFormat:@"\nYou are currently doing the %@.\nCustom Settings cannot be changed once a program begins.\nTo cancel the %@ and revert to your customised plan today click REVERT and then on the program screen click CANCEL.\nTo continue on the %@ , click CLOSE.",[programNameForNutrition uppercaseString],[programNameForNutrition uppercaseString],[programNameForNutrition uppercaseString]];
            okStr = @"REVERT";
        }else{
            msgStr = @"Are you certain you want to change your nutrition settings?  This will change your nutrition plan from today onward.";
            okStr = @"OK";
        }
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"ALERT!"
                                              message:msgStr
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"CLOSE"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:okStr
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       UIViewController *myController;
                                       if (isSetProgramActive) {
                                           [CustomNavigation startNavigation:currController fromMenu:frmMenu navDict:@{@"Identifier":@"SetProgramView"}];
                                           return;
                                           //                                           myController = controller;
                                       }else{
                                           
                                           NutritionSettingHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionSettingHomeView"];
                                           myController = controller;
                                       }
                                       if (frmMenu) {
                                           NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:myController];
                                           currController.slidingViewController.topViewController = nav;
                                           [currController.slidingViewController resetTopViewAnimated:YES];
                                       }else{
                                           [currController.navigationController pushViewController:myController animated:NO];
                                       }
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [currController presentViewController:alertController animated:YES completion:nil];
        
    });
    
}

+(void)webserviceCall_CheckMiniProgramForNutrition{
    if (Utility.reachable) {
        apiCount++;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:currController];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"SquadUserId"];
        //        [mainDict setObject:[dict objectForKey:@"ProgramId"] forKey:@"ProgramId"];
        //        [mainDict setObject:[dict objectForKey:@"UserMiniProgramId"] forKey:@"UserProgramId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:currController haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"CheckMiniProgramForNutrition" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"SquadMiniProgramModel"]]) {
                                                                             NSDictionary *squadMiniProgramModel = [responseDict objectForKey:@"SquadMiniProgramModel"];
                                                                             if (![Utility isEmptyCheck:[squadMiniProgramModel objectForKey:@"ProgramName"]]) {
                                                                                 programNameForNutrition = [squadMiniProgramModel objectForKey:@"ProgramName"];
                                                                             }
                                                                             if (![Utility isEmptyCheck:[squadMiniProgramModel objectForKey:@"ProgramId"]]) {
                                                                                 ProgramIdForNutrition = [[squadMiniProgramModel objectForKey:@"ProgramId"] intValue];
                                                                             }
                                                                         }
                                                                         [self nutritionButtonDetails];
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:currController haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:currController haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:currController haveToPop:NO];
    }
}

///////////////// END /////////////////

///////////////// FOR EXERCISE SETTINGS /////////////////

+(void)exerciseButtonDetails{
    
    BOOL isSetProgramActive = NO;
    if (![Utility isEmptyCheck:programNameForExercise] && ProgramIdForExercise>0) {
        isSetProgramActive = YES;
    }
    
    
    
    if (![defaults boolForKey:@"IsNonSubscribedUser"] && ![Utility isSubscribedUser] && ![Utility isSquadLiteUser]) {//today__
        CustomProgramSetupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomProgramSetup"];
        [Utility showTrailLoginAlert:currController ofType:controller];
        return;
    }
    
    if([Utility isSubscribedUser] && [Utility isOfflineMode]){
        [self checkOfflineAccess];
        return;
    }
    dispatch_async(dispatch_get_main_queue(),^ {
        NSString *msgStr=@"";
        NSString *okStr;
        if (isSetProgramActive) {
            msgStr = [@"" stringByAppendingFormat:@"\nYou are currently doing the %@.\nCustom Settings cannot be changed once a program begins.\nTo cancel the %@ and revert to your customised plan today click REVERT and then on the program screen click CANCEL.\nTo continue on the %@ , click CLOSE.",[programNameForExercise uppercaseString],[programNameForExercise uppercaseString],[programNameForExercise uppercaseString]];
            okStr = @"REVERT";
        }else{
            msgStr = @"Are you certain you want to change your workout settings?  This will change your custom workout plan from next week onward.";
            okStr = @"OK";
        }
        UIAlertController *alertController = [UIAlertController //15may2018
                                              alertControllerWithTitle:@"ALERT!"
                                              message:msgStr
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"CLOSE"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:okStr
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       UIViewController *myController;
                                       if (isSetProgramActive) {
                                           [CustomNavigation startNavigation:currController fromMenu:frmMenu navDict:@{@"Identifier":@"SetProgramView"}];
                                           return;
                                           //                                           myController = controller;
                                       }else{
                                           
                                           CustomExerciseSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomExerciseSettings"];
                                           myController = controller;
                                       }
                                       if (frmMenu) {
                                           NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:myController];
                                           currController.slidingViewController.topViewController = nav;
                                           [currController.slidingViewController resetTopViewAnimated:YES];
                                       }else{
                                           [currController.navigationController pushViewController:myController animated:NO];
                                       }
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [currController presentViewController:alertController animated:YES completion:nil];
    });
    
    
}
+(void)webserviceCall_CheckMiniProgramForExercise{
    if (Utility.reachable) {
        apiCount++;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:currController];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"SquadUserId"];
        //        [mainDict setObject:[dict objectForKey:@"ProgramId"] forKey:@"ProgramId"];
        //        [mainDict setObject:[dict objectForKey:@"UserMiniProgramId"] forKey:@"UserProgramId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:currController haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"CheckMiniProgramForExercise" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"SquadMiniProgramModel"]]) {
                                                                             NSDictionary *squadMiniProgramModel = [responseDict objectForKey:@"SquadMiniProgramModel"];
                                                                             if (![Utility isEmptyCheck:[squadMiniProgramModel objectForKey:@"ProgramName"]]) {
                                                                                 programNameForExercise = [squadMiniProgramModel objectForKey:@"ProgramName"];
                                                                             }
                                                                             if (![Utility isEmptyCheck:[squadMiniProgramModel objectForKey:@"ProgramId"]]) {
                                                                                 ProgramIdForExercise = [[squadMiniProgramModel objectForKey:@"ProgramId"] intValue];
                                                                             }
                                                                         }
                                                                         [self exerciseButtonDetails];
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:currController haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:currController haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:currController haveToPop:NO];
    }
}
/// END ///

#pragma mark - End

 
@end
