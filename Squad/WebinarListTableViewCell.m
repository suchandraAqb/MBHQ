//
//  WebinarListTableViewCell.m
//  The Life
//
//  Created by AQB SOLUTIONS on 04/04/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "WebinarListTableViewCell.h"

@implementation WebinarListTableViewCell
@synthesize listDetailsTextLabel,listHeadingTextLabel,listImageView,listSubheadingTextLabel,listTimeTextLabel;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) updateConstraints
{
    [super updateConstraints];
}

@end
