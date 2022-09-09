//
//  CustomNavigation.h
//  Squad
//
//  Created by aqb-mac-mini3 on 31/01/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeaderDetailsViewController.h"
#import "MyProgramsViewController.h"
#import "HelpViewController.h"
#import "GamificationViewController.h"
#import "TrainHomeViewController.h"
#import "NourishViewController.h"
#import "LearnHomeViewController.h"
#import "ConnectViewController.h"
#import "AchieveHomeViewController.h"
#import "AppreciateViewController.h"
#import "TrackViewController.h"
#import "ExerciseDailyListViewController.h"
#import "ChalengesHomeViewController.h"
#import "AudioBookViewController.h"
#import "RoundListViewController.h"
#import "SessionListViewController.h"
#import "ExerciseListViewController.h"
#import "CircuitListViewController.h"
#import "DietaryPreferenceViewController.h"
#import "MealFrequencyViewController.h"
#import "MealVarietyViewController.h"
#import "MealPlanViewController.h"
#import "IngredientListViewController.h"
#import "DailyGoodnessViewController.h"
#import "BlankListViewController.h"
#import "CoursesListViewController.h"
#import "CourseDetailsViewController.h"
#import "CourseArticleDetailsViewController.h"
#import "SetProgramViewController.h"
#import "WebinarListViewController.h"
#import "WebinarSelectedViewController.h"
#import "CalendarViewController.h"
#import "MyWatchListViewController.h"
#import "ChannelListViewController.h"
//#import "VisionHomeViewController.h"
//#import "VisionGoalActionViewController.h"
//#import "PersonalChallengeViewController.h"
//#import "BucketListNewViewController.h"
#import "GratitudeViewController.h"
#import "AchievementsViewController.h"
#import "MyDiaryListViewController.h"
#import "QuoteGalleryViewController.h"
#import "MyPhotosDefaultViewController.h"
#import "QuestionnaireHomeViewController.h"
#import "NutritionSettingHomeViewController.h"
#import "CustomExerciseSettingsViewController.h"
#import "TrackAllViewController.h"
#import "VitaminViewController.h"
#import "AfterTrialViewController.h"
#import "AddVisionBoardViewController.h"
#import "HabitHackerListViewController.h"
#import "CommunityViewController.h"
#import "AccountabilityBuddyHomeViewController.h"
#import "MeditationRewardViewController.h"
#import "FBForumViewController.h"
@interface CustomNavigation : NSObject

//@property (nonatomic, strong) NSDictionary *navigationDict;//mandatory

//send extra data in key value pair with identifier in navDict
+(void)startNavigation:(UIViewController *)controller fromMenu:(BOOL)fromMenu navDict:(NSDictionary *)navDict;

@end

