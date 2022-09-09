//
//  AddActionTableViewCell.h
//  Squad
//
//  Created by MAC 6- AQB SOLUTIONS on 15/06/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

//created by chayan

#import <UIKit/UIKit.h>

@interface AddActionTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIView *topLineView;
@property (strong, nonatomic) IBOutlet UIView *middleLineView;
@property (strong, nonatomic) IBOutlet UIView *bottomLineView;
@property (strong, nonatomic) IBOutlet UIButton *groupCountMiddleButton;
@property (strong, nonatomic) IBOutlet UILabel *waterAmount;

@end
