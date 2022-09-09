//
//  SetProgramTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 24/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetProgramTableViewCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UIStackView *programStack;
@property (strong,nonatomic) IBOutlet UIView *mainView;
@property (strong,nonatomic) IBOutlet UIView *detailsView;
@property (strong,nonatomic) IBOutlet UIButton *expandCollapse;
@property (strong,nonatomic) IBOutlet UILabel *programName;
@property (strong,nonatomic) IBOutlet UILabel *startDate;
@property (strong,nonatomic) IBOutlet UILabel *endDate;
@property (strong,nonatomic) IBOutlet UILabel *durationLabel;
@property (strong,nonatomic) IBOutlet UIButton *exerciseButton;
@property (strong,nonatomic) IBOutlet UIButton *nutritionButton;
@property (strong,nonatomic) IBOutlet UIImageView *plusMinusImage;
@property (strong,nonatomic) IBOutlet UIView *execiseCurrentDateView;
@property (strong,nonatomic) IBOutlet UIView *nutritionCurrenDateView;
@property (strong,nonatomic) IBOutlet UIView *startView;
@property (strong,nonatomic) IBOutlet UIView *cancelView;
@property (strong,nonatomic) IBOutlet UIView *editView;
@property (strong,nonatomic) IBOutlet UIView *deleteView;
@property (strong,nonatomic) IBOutlet UIStackView *actionStack;
@property (strong,nonatomic) IBOutlet UILabel *courseLabel;
@property (strong,nonatomic) IBOutlet UIImageView *courseArrow;
@property (strong,nonatomic) IBOutlet UIButton *courseButton;
@property (strong,nonatomic) IBOutlet UILabel *execiseCancelLabel;
@property (strong,nonatomic) IBOutlet UILabel *nutritionCancelLabel;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *exerciseCancelLabelHeight;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *nutritionCancelLabelHeight;
@property (strong,nonatomic) IBOutlet UIButton *startButton;
@property (strong,nonatomic) IBOutlet UIButton *deleteButton;
@property (strong,nonatomic) IBOutlet UIButton *deleteYesButton;
@property (strong,nonatomic) IBOutlet UIButton *editButton;
@property (strong,nonatomic) IBOutlet UIButton *cancelButton;
@property (strong,nonatomic) IBOutlet UIView *actionView;
@property (strong,nonatomic) IBOutlet UIStackView *detailsStackView;
@property (strong,nonatomic) IBOutlet UIView *descriptionView;//change_setprogram_feedback
@property (strong,nonatomic) IBOutlet UIButton *clickHereButton;//change_setprogram_feedback
@property (strong,nonatomic) IBOutlet UIView *courseUnderlineView;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *courseArrowWidthConstant;
@property (strong,nonatomic) IBOutlet UIView *durationView;
@property (strong,nonatomic) IBOutlet UIView *exerciseView;
@property (strong,nonatomic) IBOutlet UIView *nutritionView;
@property (strong,nonatomic) IBOutlet UIView *courseView;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *startButtonHeightConstant;
@property (strong,nonatomic) IBOutlet UIView *startDescriptionView;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *viewDescriptionHeightConstant;
@property (strong,nonatomic) IBOutlet UILabel *shoppingcancelLabel;
@property (strong,nonatomic) IBOutlet UIButton *shoppingButton;
@property (strong,nonatomic) IBOutlet UIView *shoppingView;
@property (strong,nonatomic) IBOutlet UIView *shoppingCurrentDateView;
@property (strong,nonatomic) IBOutlet UILabel *mealPlanCurrentDateViewLabel;
@property (strong,nonatomic) IBOutlet UIImageView *mealPlanCurrentDateViewArrowImage;
@property (strong,nonatomic) IBOutlet UIView *mealPlanCurrentDateViewUndelineView;

@property (strong,nonatomic) IBOutlet UILabel *shoppingListCurrentDateViewLabel;
@property (strong,nonatomic) IBOutlet UIImageView *shoppingListCurrentDateViewArrowImage;
@property (strong,nonatomic) IBOutlet UIView *shoppingListCurrentDateViewUndelineView;

@property (strong,nonatomic) IBOutlet UILabel *exerciseCurrentDateViewLabel;
@property (strong,nonatomic) IBOutlet UIImageView *exerciseCurrentDateViewArrowImage;
@property (strong,nonatomic) IBOutlet UIView *exerciseCurrentDateViewUndelineView;

@property (strong,nonatomic) IBOutlet NSLayoutConstraint *shoppingCancelLabelHeight;
@end
