//
//  SavedNutritionTableViewCell.h
//  Squad
//
//  Created by aqb-mac-mini3 on 25/06/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedNutritionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *applyShowButton;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *weekView;
@property (weak, nonatomic) IBOutlet UIButton *currentWeek;
@property (weak, nonatomic) IBOutlet UIButton *nextWeek;

@end
