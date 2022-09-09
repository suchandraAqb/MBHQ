//
//  LeaderBoardDetailsTableViewCell.h
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 17/10/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderBoardDetailsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *commonString;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UIImageView *statusImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commonStringHeightConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImage;
@property (strong, nonatomic) IBOutlet UILabel *indexLabel;
@property (strong, nonatomic) IBOutlet UILabel *citySubLabel;

//citySubLabel
@property(strong,nonatomic) IBOutlet UIButton *leaderShareButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *citySubLabelHeightConstant; //add_Today
@property (strong,nonatomic) IBOutlet UIView *cellTopView;
@property (strong,nonatomic) IBOutlet UIView *cellBottomView;
@end
