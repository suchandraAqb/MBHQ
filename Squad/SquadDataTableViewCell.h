//
//  SquadDataTableViewCell.h
//  Squad
//
//  Created by AQB SOLUTIONS on 31/07/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquadDataTableViewCell : UITableViewCell
////ah fbw2

@property (strong, nonatomic) IBOutlet UILabel *slNoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@end
