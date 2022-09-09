//
//  CustomNutritionPlanListViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 13/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "MasterMenuViewController.h"
#import "SwapMealViewController.h"
#import "SquadUserDailySessionsPopUpViewController.h"
#import "RecipeListViewController.h"
#import "CustomNutritionPlanListCollectionViewController.h"
#import "ShoppingCartPopUpViewController.h"
#import "ResetProgramViewController.h"
#import "MealSwapDropDownViewController.h"
#import "FoodPrepSearchViewController.h"
#import "AddEditCustomNutritionViewController.h" //Nutrition_Local_catch
#import "CustomNutritionMealSettingsViewController.h"
#import "FoodPrepViewController.h"
#import "ShoppingListViewController.h"
#import "MealMatchViewController.h"
#import "DailyGoodnessDetailViewController.h"
#import "SavedNutritionPlanViewController.h"
@protocol CustomNutritionPlanListDelagete<NSObject>
@optional - (void)didCheckAnyChangeForCustomNutrition:(BOOL)ischanged;
@end

@interface CustomNutritionPlanListViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SwapMealViewControllerDelegate,SquadUserDailySessionsPopUpViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,CustomNutritionPlanListCollectionViewControllerDelegate,ShoppingCartPopUpViewControllerDelegate,ResetProgramViewDelegate,MealSwapDropDownDelegate,FoodPrepSearchViewDelegate,AddEditCustomNutritionDelegate,CustomNutritionMealSettingsDelegate,FoodPrepViewDelegate,ShoppingListViewDelegate,MealMatchViewDelegate,DailyGoodnessDetailDelegate,SavedNutritionViewDelegate>{
    id<CustomNutritionPlanListDelagete>delegate;
}
@property(nonatomic,strong) id delegate;
@property BOOL isComplete;
@property(nonatomic)int stepnumber;
@property(assign)BOOL isFromShoppingList;
@property(nonatomic,strong)NSDate *weekDate;
@property BOOL fromSetProgram; 
@property(nonatomic,strong)IBOutlet UIView *multipleSwapHeaderView;
-(IBAction)listButtonPressed:(UIButton *)sender;

@property(nonatomic,strong)NSDate *currentDate;    //today page
@end
