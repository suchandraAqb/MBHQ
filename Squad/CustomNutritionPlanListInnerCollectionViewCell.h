//
//  CustomNutritionPlanListInnerCollectionViewCell.h
//  Squad
//
//  Created by aqbsol iPhone on 19/01/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNutritionPlanListInnerCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UIImageView *dayImage;
@property (strong, nonatomic) IBOutlet UIButton *dayButton;
@property (strong, nonatomic) IBOutlet UIButton *dumbleButton;

@property (strong, nonatomic) IBOutlet UILabel *dumbleLabel;
@property (strong,nonatomic) IBOutlet UIImageView *dumbleImage;
@end
