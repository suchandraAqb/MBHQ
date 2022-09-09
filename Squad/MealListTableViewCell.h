//
//  MealListTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 12/11/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealListTableViewCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UIImageView *mealpic;
@property (strong,nonatomic) IBOutlet UILabel *mealDetails;
@property (strong,nonatomic) IBOutlet UILabel *calorie;
@end
