//
//  ProfileTableViewCell.h
//  The Life
//
//  Created by AQB Solutions-Mac Mini 2 on 02/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *notificationDays;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UIImageView *checkUncheckImage;

@end
