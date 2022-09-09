//
//  MealSwapDropDownTableViewCell.h
//  Squad
//
//  Created by AQB Solutions Private Limited on 15/05/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealSwapDropDownTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mealNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *myfavButton;
@property (weak, nonatomic) IBOutlet UIButton *unmeasuredButton;
@property (weak, nonatomic) IBOutlet UIButton *myMealButton;
@end
