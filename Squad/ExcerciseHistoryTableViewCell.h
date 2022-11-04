//
//  ExcerciseHistoryTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 26/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExcerciseHistoryTableViewCell : UITableViewCell
@property (strong , nonatomic) IBOutlet UILabel *setLabel;
@property (strong , nonatomic) IBOutlet UILabel *weightLabel;
@property (strong , nonatomic) IBOutlet UILabel *repGoalLabel;
@property (strong , nonatomic) IBOutlet UILabel *repsLabel;
@end
