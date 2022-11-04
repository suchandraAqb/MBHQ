//
//  FoodPrepAddEditTableViewCell.h
//  Squad
//
//  Created by aqbsol iPhone on 06/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodPrepAddEditTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *mealName;
@property (weak, nonatomic) IBOutlet UILabel *mealNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *mealViewButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *mealQuantity;
@property (weak, nonatomic) IBOutlet UITextField *mealCalorie;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *unmeasuredButton;
@end
