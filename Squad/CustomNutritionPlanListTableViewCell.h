//
//  CustomNutritionPlanListTableViewCell.h
//  Squad
//
//  Created by aqbsol iPhone on 16/01/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNutritionPlanListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeType;
@property (weak, nonatomic) IBOutlet UILabel *recipeName;

@property (weak, nonatomic) IBOutlet UIButton *recipeSwapButton;
@property (weak, nonatomic) IBOutlet UIButton *recipeRepeatButton;
@property (weak, nonatomic) IBOutlet UIButton *showRecipeButton;

@property (weak, nonatomic) IBOutlet UIButton *addCustomShoppingButton;
@property (weak, nonatomic) IBOutlet UIButton *shoppingButton;
@property (weak, nonatomic) IBOutlet UIImageView *circleImage;
@property (weak, nonatomic) IBOutlet UILabel *circleLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak, nonatomic) IBOutlet UIView *addCustomShoppingView;
@property (weak, nonatomic) IBOutlet UIButton *shoppingCheckUncheckButton;
@property (weak, nonatomic) IBOutlet UILabel *shoppingQuantity;

@property (weak, nonatomic) IBOutlet UIButton *saveCustomShoppingButton;
@property (weak, nonatomic) IBOutlet UIButton *shoppingMinusButton;
@property (weak, nonatomic) IBOutlet UIButton *shoppingPlusButton;

@property (weak, nonatomic) IBOutlet UIButton *editMealButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editMealButtonHeight;
@property (weak, nonatomic) IBOutlet UIView *editCustomMealView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editCustomMealViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *updateMealSettingButton;
@property (weak, nonatomic) IBOutlet UIButton *editRecipeButton;

@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;  //preparationTimeLabel
@property (weak, nonatomic) IBOutlet UIImageView *measureImage;
@property (weak, nonatomic) IBOutlet UILabel *totalCalorieLabel;


@end
