//
//  FoodPrepSearchViewController.h
//  Squad
//
//  Created by aqbsol iPhone on 13/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEditCustomNutritionViewController.h"

@protocol FoodPrepSearchViewDelegate <NSObject>
@optional - (void) didSelectSearchOption:(NSMutableDictionary*)searchDict sender:(UIButton *)sender;
@optional - (void)didSwapCompleteWithSearchedMeal:(BOOL)isComplete;
@optional - (void)didMultipleSwap:(NSDictionary *)swapDict;
@optional - (void)didCheckAnyChangeForFoodPrepSearch:(BOOL)ischanged;
@optional -(void)mealSerachWithFilterData:(NSDictionary *)dict ingredientsAllList:(NSArray *)ingredientsAllList dietaryPreferenceArray:(NSArray *)dietaryPreferenceArray;
@optional -(void)isBackToNourish:(BOOL)isBack;
@optional -(void)getAllMealArray:(NSArray *)mealList;
@end

@interface FoodPrepSearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AddEditCustomNutritionDelegate>{
    id<FoodPrepSearchViewDelegate>delegate;
}

@property (nonatomic,strong)id delegate;
@property (nonatomic,strong)UIButton *sender;
@property()BOOL isFromFoodPrep;
@property()BOOL isFromRecipe;
@property() int mealSessionIdToReplace;
@property()BOOL isFromMealMatch;
@property()BOOL isMyRecipe;

@property (nonatomic,strong)NSMutableDictionary *defaultSearchDict;
@property (nonatomic,strong)NSArray *ingredientsAllList;
@property (nonatomic,strong)NSArray *dietaryPreferenceArray;
@property (nonatomic,strong)NSArray *allMealArray;
@end
