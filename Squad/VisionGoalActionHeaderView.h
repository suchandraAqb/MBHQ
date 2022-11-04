//
//  VisionGoalActionHeaderView.h
//  Squad
//
//  Created by AQB SOLUTIONS on 03/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLProgressBar.h"

@interface VisionGoalActionHeaderView : UITableViewHeaderFooterView
//ah ac
@property (strong, nonatomic) IBOutlet UIImageView *goalHeaderImageView;
@property (strong, nonatomic) IBOutlet UILabel *goalHeaderLabel;
@property (strong, nonatomic) IBOutlet UIButton *goalDateButton;
@property (strong, nonatomic) IBOutlet UIButton *goalHeaderSelectionButton;

@property (strong, nonatomic) IBOutlet YLProgressBar *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *expandCollapseButton;
@property (weak, nonatomic) IBOutlet UIButton *editGoalButton;
@property (weak, nonatomic) IBOutlet UIButton *expiredGoalButton;
@property (weak, nonatomic) IBOutlet UIView *goalView;

@property (weak, nonatomic) IBOutlet UIView *swapView;
@property (weak, nonatomic) IBOutlet UIButton *moveFromButton;
@property (weak, nonatomic) IBOutlet UIButton *moveToButton;
@property (strong,nonatomic) IBOutlet UIView *editView;
@end
