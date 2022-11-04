//
//  ChooseGoalTableViewCell.h
//  Squad
//
//  Created by AQB Mac 4 on 16/01/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface ChooseGoalTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *arrowButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arrowButtonWidhConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *selectedFatLossAmountLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *selectedFatLossAmountWidthConstraint;
@property (strong, nonatomic) IBOutlet UILabel *selectedFatLossAmount;
@property (strong, nonatomic) IBOutlet UILabel *goalName;
@property (strong,nonatomic) IBOutlet UIView *borderView;
@property (strong,nonatomic) IBOutlet UIView *ratefitnessmainView;
@end
