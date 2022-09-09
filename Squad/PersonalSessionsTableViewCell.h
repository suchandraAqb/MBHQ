//
//  PersonalSessionsTableViewCell.h
//  Squad
//
//  Created by AQB SOLUTIONS on 09/02/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalSessionsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dayNameLabel;   //ah cpn
@property (strong, nonatomic) IBOutlet UIButton *personalSessionNameButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *moveSwapButton;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;

@end
