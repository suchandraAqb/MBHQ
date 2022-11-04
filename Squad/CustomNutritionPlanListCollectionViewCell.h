//
//  CustomNutritionPlanListCollectionViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 13/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNutritionPlanListCollectionViewCell : UICollectionViewCell<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *recipeName;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeType;
@property (weak, nonatomic) IBOutlet UIButton *openQuickEditButton;
@property (weak, nonatomic) IBOutlet UIButton *recipeRepeatButton;
@property (weak, nonatomic) IBOutlet UIButton *recipeDeleteButton;

@property (weak, nonatomic) IBOutlet UIButton *quickEditButton;
@property (weak, nonatomic) IBOutlet UIButton *recipeEditButton;
@property (weak, nonatomic) IBOutlet UIImageView *quickEditArrowImage;

@property (strong, nonatomic) IBOutlet UILabel *mealType;
@property (strong, nonatomic) IBOutlet UIStackView *recipeEditButtonContainerStackView;
@property (strong, nonatomic) IBOutlet UIStackView *quickEditContainerStackView;

@property (strong, nonatomic) IBOutlet UIStackView *legendContainerStackView;
@property (strong, nonatomic) IBOutlet UIButton *cellLegendButton;
@property (strong, nonatomic) IBOutlet UIButton *noMeasureMealButton;
@property (strong, nonatomic) IBOutlet UILabel *legendLabel;
@property (strong, nonatomic) IBOutlet UIView *legendPopupView;
@property (strong, nonatomic) IBOutlet UIButton *legendClose;
@property (strong, nonatomic) IBOutlet UIButton *avoidOrNotButton;

@property (strong, nonatomic) IBOutlet UIView *addCustomShoppingView;
@property (strong, nonatomic) IBOutlet UIButton *shoppingPlusButton;
@property (strong, nonatomic) IBOutlet UIButton *shoppingMinusButton;
@property (strong, nonatomic) IBOutlet UIButton *shoppingCheckUncheckButton;
@property (strong, nonatomic) IBOutlet UILabel *shoppingQuantity;










@end
