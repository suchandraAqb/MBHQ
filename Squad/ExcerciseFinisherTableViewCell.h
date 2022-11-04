//
//  ExcerciseFinisherTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 20/11/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExcerciseFinisherTableViewCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UILabel *exercisenameLabel;
@property (strong,nonatomic) IBOutlet UILabel *indexlabel;
@property (strong,nonatomic) IBOutlet UILabel *timeLabel;

@property (strong,nonatomic) IBOutlet UILabel *exerciseNameAllLabel;
@property (strong,nonatomic) IBOutlet UILabel *indexAlllabel;
@property (strong,nonatomic) IBOutlet UILabel *timeAllLabel;
@property (strong,nonatomic) IBOutlet UIImageView *userImage;
@property (strong,nonatomic) IBOutlet UIView *cellTopView;
@property (strong,nonatomic) IBOutlet UIView *cellBottomView;
@property (strong,nonatomic) IBOutlet UIImageView *profileImage;

@end
