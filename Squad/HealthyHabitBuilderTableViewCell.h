//
//  HealthyHabitBuilderTableViewCell.h
//  Squad
//
//  Created by AQB SOLUTIONS on 06/09/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthyHabitBuilderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *actionTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *actionFrequencyLabel;
@property (strong, nonatomic) IBOutlet UIButton *watchButton;
@property (strong, nonatomic) IBOutlet UIView *countView;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIStackView *mainStackView;
@property (strong, nonatomic) IBOutlet UIView *dayView;
@property (strong, nonatomic) IBOutlet UIView *firstCheckView;
@property (strong, nonatomic) IBOutlet UIView *secondCheckView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *firstCheckButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *secondCheckButtons;


@end
