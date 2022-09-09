//
//  MealFrequencyTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 31/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealFrequencyTableViewCell : UITableViewCell
@property(strong,nonatomic) IBOutlet UIButton *frequencyCheckUncheButton;
@property(strong,nonatomic) IBOutlet UILabel *frequencyMealLabel;
@property (strong,nonatomic) IBOutlet UIView *mealDetailsView;
@end
