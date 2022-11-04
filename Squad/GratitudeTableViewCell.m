//
//  GratitudeTableViewCell.m
//  Squad
//
//  Created by AQB Mac 4 on 10/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "GratitudeTableViewCell.h"

@implementation GratitudeTableViewCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
