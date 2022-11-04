//
//  ExerciseTypeTableViewCell.h
//  Squad
//
//  Created by AQB Mac 4 on 8/3/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UIImageView *durationIcon;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UIImageView *equipmentIcon;
@property (weak, nonatomic) IBOutlet UIView *equipmentContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *equipmentContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *equipments;

@property (weak, nonatomic) IBOutlet UIButton *favButton;
@property (weak, nonatomic) IBOutlet UIImageView *bodyTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *bodyTypeLabel;

@end
