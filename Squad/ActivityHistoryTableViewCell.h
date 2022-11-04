//
//  ActivityHistoryTableViewCell.h
//  Squad
//
//  Created by AQB SOLUTIONS on 27/07/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityHistoryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;  //ah 31.8(storyboard)

@property (strong, nonatomic) IBOutlet UILabel *distanceType;
@end
