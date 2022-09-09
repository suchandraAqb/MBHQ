//
//  AchievementsTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 16/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AchievementsTableViewCell : UITableViewCell

@property(strong,nonatomic) IBOutlet UILabel *achievementLabel;
@property(strong,nonatomic) IBOutlet UIImageView *achievementImage;


@property(strong,nonatomic) IBOutlet UILabel *achievementListDayLabel;

@property (strong, nonatomic) IBOutlet UIButton *notificationButton;
@end
