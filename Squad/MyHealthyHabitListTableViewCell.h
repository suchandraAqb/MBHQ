//
//  MyHealthyHabitListTableViewCell.h
//  Squad
//
//  Created by MAC 6- AQB SOLUTIONS on 24/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHealthyHabitListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *downArrowButton;
@property (strong, nonatomic) IBOutlet UIButton *upArrowButton;
@property (strong, nonatomic) IBOutlet UIButton *activeButton;
@property (strong, nonatomic) IBOutlet UILabel *activeInactiveLabel;
@property (strong, nonatomic) IBOutlet UIButton *visibleButton;
@property (strong, nonatomic) IBOutlet UILabel *visibleInvisiableLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;



@end
