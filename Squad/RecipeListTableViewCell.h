//
//  RecipeListTableViewCell.h
//  Squad
//
//  Created by AQB Mac 4 on 19/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIImageView *noMeasureMeal;
@property (strong, nonatomic) IBOutlet UILabel *recipeName;
@property (strong, nonatomic) IBOutlet UIButton *recipeEditButton;
@property (strong, nonatomic) IBOutlet UIButton *breakfastButton;
@property (strong, nonatomic) IBOutlet UIButton *lunchButton;
@property (strong, nonatomic) IBOutlet UIButton *dinnerButton;
@property (strong, nonatomic) IBOutlet UIButton *snackButton;
@property (strong, nonatomic) IBOutlet UIImageView *recipeImage;

@property (strong, nonatomic) IBOutlet UIButton *swapWithMealButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *submittedButton;
@property (strong, nonatomic) IBOutlet UIStackView *swapWithMealStackView;

@property (strong, nonatomic) IBOutlet UIButton *prepTimeButton;
@property (strong, nonatomic) IBOutlet UIButton *caloriesButton;
@property (strong, nonatomic) IBOutlet UIButton *avoidOrNotButton;

//shabbir
@property (weak, nonatomic) IBOutlet UIView *editMealView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editMealViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *favrtButton;
@property (weak, nonatomic) IBOutlet UIButton *updateMealSetting;
@property (weak, nonatomic) IBOutlet UIButton *editRecipe;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editRecipeButtonHeight;



@end
