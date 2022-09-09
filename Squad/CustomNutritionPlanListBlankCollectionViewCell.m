//
//  CustomNutritionPlanListBlankCollectionViewCell.m
//  Squad
//
//  Created by AQB Mac 4 on 03/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CustomNutritionPlanListBlankCollectionViewCell.h"

@implementation CustomNutritionPlanListBlankCollectionViewCell
-(void)layoutSubviews{
    self.contentView.frame = self.bounds;
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    UIView *cellContentView = self.contentView;
    cellContentView.translatesAutoresizingMaskIntoConstraints = false;
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[cellContentView]|"
                          options:0
                          metrics:0
                          views:NSDictionaryOfVariableBindings(cellContentView)]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|[cellContentView]|"
                          options:0
                          metrics:0
                          views:NSDictionaryOfVariableBindings(cellContentView)]];
    
    
}
@end
