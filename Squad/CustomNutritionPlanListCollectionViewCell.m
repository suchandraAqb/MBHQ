//
//  CustomNutritionPlanListCollectionViewCell.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 13/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CustomNutritionPlanListCollectionViewCell.h"

@implementation CustomNutritionPlanListCollectionViewCell
-(void)layoutSubviews{
    self.contentView.frame = self.bounds;
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.recipeEditButtonContainerStackView.spacing = (float)(self.frame.size.width/40);
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
