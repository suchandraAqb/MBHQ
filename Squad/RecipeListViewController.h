//
//  RecipeListViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 19/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "Utility.h"
#import "NutritionAdvanceSearchViewController.h"
#import "FoodPrepSearchViewController.h"
#import "DailyGoodnessDetailViewController.h"
#import "AddEditCustomNutritionViewController.h"
#import "CustomNutritionMealSettingsViewController.h"
#import "AddRecipeViewController.h"


@interface RecipeListViewController : UIViewController<UITextFieldDelegate,AdvanceSearchViewDelegate,DailyGoodnessDetailDelegate,AddEditCustomNutritionDelegate,CustomNutritionMealSettingsDelegate,FoodPrepSearchViewDelegate,AddRecipeViewDelegate>
@property (strong, nonatomic)  NSNumber *mealId;
@property (strong, nonatomic)  NSNumber *mealSessionId;
@property (strong, nonatomic)  NSDate *mealDate;

@end
