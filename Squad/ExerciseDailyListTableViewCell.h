//
//  ExerciseDailyListTableViewCell.h
//  Squad
//
//  Created by AQB SOLUTIONS on 03/01/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseDailyListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *catLabel;
@property (strong, nonatomic) IBOutlet UILabel *subCatLabel;

@property(strong,nonatomic) IBOutlet UIButton *favButton;
@property(strong,nonatomic) IBOutlet UIButton  *checkUncheckButton;



@end
