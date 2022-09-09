//
//  MyExercisePlanCollectionViewCell.h
//  ABBBCOnline
//
//  Created by AQB Mac 4 on 21/11/16.
//  Copyright © 2016 Aqb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyExercisePlanCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UITableView *dayTable;
@property (strong, nonatomic) IBOutlet UILabel *dayTitle;
@property (strong, nonatomic) IBOutlet UILabel *date;

@property (strong, nonatomic) IBOutlet UIButton *addButton;

@end
