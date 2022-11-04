//
//  CustomNutritionPlanListDateCollectionViewCell.h
//  Squad
//
//  Created by aqbsol iPhone on 22/01/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNutritionPlanListDateCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIButton *dayButton;
@property (strong, nonatomic) IBOutlet UIImageView *dumbleImage;
@property (strong, nonatomic) IBOutlet UILabel *dumbleText;
@property (strong, nonatomic) IBOutlet UIButton *dumbleButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewMiddleConstraint;

@property (strong, nonatomic) IBOutlet UILabel *emptyLabel;

@end
