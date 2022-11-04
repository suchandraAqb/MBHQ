//
//  MealPlanTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 04/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealPlanTableViewCell : UITableViewCell
@property(strong,nonatomic) IBOutlet UILabel *topLabel;
@property(strong,nonatomic) IBOutlet UILabel *detailsLabel;
@property(strong,nonatomic) IBOutlet UILabel *recommendedLabel;
@property(strong,nonatomic) IBOutlet UIButton *recommendedButton;
@property(strong,nonatomic) IBOutlet UIView *shadowView;
@property (strong,nonatomic) IBOutlet UIView *topView;
@property (strong,nonatomic) IBOutlet UIButton *topViewCheckUncheckButton;
@property (strong,nonatomic) IBOutlet UIButton *expandButton;
@property (strong,nonatomic) IBOutlet UIView *bottonView;
@property (strong,nonatomic) IBOutlet UIStackView *stack;
@end
