//
//  HomePageViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 06/12/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "MasterMenuViewController.h"
#import "RateFitnessLevelViewController.h"
#import "PersonalSessionsViewController.h"
#import "MovePersonalSessionViewController.h"
#import "ChooseGoalViewController.h"
#import "ViewPersonalSessionViewController.h"
#import "FBWHomeViewController.h"
#import "CustomProgramSetupViewController.h"
#import "CustomNutritionPlanListViewController.h"
#import "ShoppingListViewController.h"
#import "AddGoalsViewController.h"
#import "CourseArticleDetailsViewController.h"
#import "HelpVideoPlayerViewController.h"



@interface HomePageViewController : UIViewController<HelpVideoPlayerViewDelegate>{
   
}

@property (nonatomic) BOOL isMovedToToday;
@property (nonatomic) BOOL sendToDailyWorkout;
@end
