//
//  ShopifyCollectionViewCell.m
//  The Life
//
//  Created by AQB Mac 4 on 17/10/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "ShopifyCollectionViewCell.h"

@implementation ShopifyCollectionViewCell
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
