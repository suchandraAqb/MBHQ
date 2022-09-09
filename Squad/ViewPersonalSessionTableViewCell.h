//
//  ViewPersonalSessionTableViewCell.h
//  Squad
//
//  Created by AQB SOLUTIONS on 14/02/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewPersonalSessionTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UIButton *repeateButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

//chayan
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;

@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIView *middleSeparatorView;
@property (strong, nonatomic) IBOutlet UIButton *swapEqualButton;
@property (strong, nonatomic) IBOutlet UIButton *moveSwapButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIView *editDeleteButtonView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *durationHeightConstraint;    //ah ux2
@property (strong,nonatomic) IBOutlet UILabel *dayNameLabel;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *middleSeparatorViewTrallingConstant;
@property (strong,nonatomic) IBOutlet UIView *dividerView;
@property (strong,nonatomic) IBOutlet UIStackView *stack;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *stackViewLeadingConstant;
@property (strong, nonatomic) IBOutlet UIView *repeatSeparatorView;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *editBackImage;
@property (strong,nonatomic) IBOutlet UILabel *addMyWorkoutLabel;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *dividerViewBottomConstant;
@property (strong,nonatomic) IBOutlet UIButton *favButton; //632018_feedback
@end
