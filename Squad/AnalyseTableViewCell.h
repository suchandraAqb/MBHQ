//
//  AnalyseTableViewCell.h
//  Squad
//
//  Created by aqbsol iPhone on 30/05/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalyseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *searchName;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *association;
@property (weak, nonatomic) IBOutlet UIButton *action;

@property (weak, nonatomic) IBOutlet UILabel *mealName;
@property (weak, nonatomic) IBOutlet UILabel *avgRating;
@property (weak, nonatomic) IBOutlet UILabel *frequency;
@property (weak, nonatomic) IBOutlet UIButton *expAvgButton;
@property (weak, nonatomic) IBOutlet UIButton *expMealButton;

@property (weak, nonatomic) IBOutlet UILabel *expandedMealLabel;
@property (weak, nonatomic) IBOutlet UILabel *expandedRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *expandedIngredientsLabel;

@end
