//
//  AchieveTableViewCell.h
//  Squad
//
//  Created by AQB Mac 4 on 27/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AchieveTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *goalImage;
@property (strong, nonatomic) IBOutlet UIStackView *outerStackView;
@property (strong, nonatomic) IBOutlet UILabel *goalName;
@property (strong, nonatomic) IBOutlet UILabel *goalSubName;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UIStackView *innerStackView;

@end
