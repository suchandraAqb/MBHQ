//
//  CalendarEventTableViewCell.m
//  The Life
//
//  Created by AQB SOLUTIONS on 04/04/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "CalendarEventTableViewCell.h"

@implementation CalendarEventTableViewCell

@synthesize eventColor,eventDay,eventName,eventTime;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
