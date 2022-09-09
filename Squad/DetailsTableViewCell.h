//
//  DetailsTableViewCell.h
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 24/10/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *detailsImageView;
@property (strong, nonatomic) IBOutlet UILabel *detailsUserNameString;
@property (strong, nonatomic) IBOutlet UILabel *detailsCommonString;
@property (strong, nonatomic) IBOutlet UIImageView *detailsStatusImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailsHeightConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImage;
@property (strong, nonatomic) IBOutlet UILabel *indexLabel;
@property (strong, nonatomic) IBOutlet UIImageView *indexImage;
@property(strong,nonatomic) IBOutlet UIButton *leaderShareButton;
@property (strong, nonatomic) IBOutlet UILabel *citySubLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *citySubLabelHeightConstant;
@property (strong,nonatomic) IBOutlet UIView *borderView;
@property (strong,nonatomic) IBOutlet UIView *cellTopView;
@property (strong,nonatomic) IBOutlet UIView *cellBottomView;
@property (strong,nonatomic) IBOutlet UIImageView *profileImage;
@end
