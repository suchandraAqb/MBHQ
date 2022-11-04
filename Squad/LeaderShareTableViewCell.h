//
//  LeaderShareTableViewCell.h
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 10/11/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderShareTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *selectedImage;
@property (strong, nonatomic) IBOutlet UILabel *indexLabel;

@property (strong, nonatomic) IBOutlet UIImageView *detailsImageView;

@property (strong, nonatomic) IBOutlet UIImageView *detailsStatusImageView;

@property (strong, nonatomic) IBOutlet UILabel *detailsUserNameString;
@property (strong, nonatomic) IBOutlet UILabel *commonString;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailsHeightConstraint;

@end
