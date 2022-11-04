//
//  MyExercisePlanCollectionViewCell.m
//  ABBBCOnline
//
//  Created by AQB Mac 4 on 21/11/16.
//  Copyright © 2016 Aqb. All rights reserved.
//

#import "MyExercisePlanCollectionViewCell.h"

@implementation MyExercisePlanCollectionViewCell
-(void)layoutSubviews{
    self.contentView.frame = self.bounds;
    [super layoutSubviews];
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
