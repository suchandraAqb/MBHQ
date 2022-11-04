//
//  NotificationSettingTableViewCell.h
//  The Life
//
//  Created by AQB Mac 4 on 05/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationSettingTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *settingTitle;
@property (strong, nonatomic) IBOutlet UILabel *settingSubtitle;
@property (strong, nonatomic) IBOutlet UISwitch *settingSwitch;

@end
