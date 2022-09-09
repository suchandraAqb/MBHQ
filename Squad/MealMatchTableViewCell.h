//
//  MealMatchTableViewCell.h
//  Squad
//
//  Created by AQB-Mac-Mini 3 on 11/09/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealMatchTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *planMealView;
@property (strong, nonatomic) IBOutlet UIView *myMealView;
@property (strong, nonatomic) IBOutlet UIImageView *planMealImage;
@property (strong, nonatomic) IBOutlet UILabel *planMealName;
@property (strong, nonatomic) IBOutlet UILabel *planMealCal;
@property (strong, nonatomic) IBOutlet UIImageView *myMealImage;
@property (strong, nonatomic) IBOutlet UILabel *myMealName;
@property (strong, nonatomic) IBOutlet UILabel *metricQuantyDetails;
@property (strong, nonatomic) IBOutlet UILabel *intakeDate;
@property (strong, nonatomic) IBOutlet UILabel *myMealCal;
@property (strong, nonatomic) IBOutlet UIButton *upArrow;
@property (strong, nonatomic) IBOutlet UIButton *downArrow;
@property (strong, nonatomic) IBOutlet UIView *myMealTypeView;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *matchButton;
@property (strong, nonatomic) IBOutlet UIButton *myMealDetailsButton;
@property (strong, nonatomic) IBOutlet UIButton *mealDetailsButton;
@property (strong, nonatomic) IBOutlet UIView *otherFoodView;

@property (strong, nonatomic) IBOutlet UIView *myMealAddView;
@property (strong, nonatomic) IBOutlet UILabel *mealTypeLabel;
@property (strong, nonatomic) IBOutlet UIButton *mealAddButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mealTypeLabelHeight;
@property (weak, nonatomic) IBOutlet UIView *swapView;
@property (weak, nonatomic) IBOutlet UIButton *swapButton;
@property (weak, nonatomic) IBOutlet UIButton *swap;

@property (weak, nonatomic) IBOutlet UIView *extraSectionHiddenView;

//myintakeView
@property (strong, nonatomic) IBOutlet UILabel *typeTotalCal;
@property (strong, nonatomic) IBOutlet UILabel *quantity;
@property (strong, nonatomic) IBOutlet UILabel *pcfLabel;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *myIntakeLabel;
@property (strong, nonatomic) IBOutlet UILabel *myPlanLabel;
@property (strong, nonatomic) IBOutlet UILabel *brandLabel;

@end
