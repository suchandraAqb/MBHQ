//
//  CustomNutritionPlanListNewCollectionViewCell.h
//  Squad
//
//  Created by aqbsol iPhone on 22/01/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNutritionPlanListNewCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *mealNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mealTypeLabel;
@property (strong, nonatomic) IBOutlet UIButton *mealNameButton;

@property (weak, nonatomic) IBOutlet UIButton *cartButton;
@property (weak, nonatomic) IBOutlet UIImageView *circleImage;
@property (weak, nonatomic) IBOutlet UILabel *circleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cartBigSelectedImage;
@property (weak, nonatomic) IBOutlet UIImageView *selectedCircleImage;
@property (weak, nonatomic) IBOutlet UILabel *selectedCircleLabel;

@property (weak, nonatomic) IBOutlet UIButton *cartBigSelectedImageButton;
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UIView *swapSelectionView;
@property (weak, nonatomic) IBOutlet UIButton *swapSelectedButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *singleSwapButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cartHeightConstraint;

@end
