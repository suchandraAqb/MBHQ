//
//  CalendarEventTableViewCell.h
//  The Life
//
//  Created by AQB SOLUTIONS on 04/04/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarEventTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *eventColor;
@property (strong, nonatomic) IBOutlet UILabel *eventName;
@property (strong, nonatomic) IBOutlet UILabel *eventDay;
@property (strong, nonatomic) IBOutlet UILabel *eventTime;
@end
