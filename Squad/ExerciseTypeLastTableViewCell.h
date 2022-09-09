//
//  ExerciseTypeLastTableViewCell.h
//  Squad
//
//  Created by AQB Mac 4 on 9/3/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseTypeLastTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UIImageView *durationIcon;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UIButton *rightArrow;
@property (weak, nonatomic) IBOutlet UIButton *leftArrow;
@end
