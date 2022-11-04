//
//  FoodPrepTableViewCell.h
//  Squad
//
//  Created by aqbsol iPhone on 05/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodPrepTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *foodPrepNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *viewFoodPrepButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end
