//
//  GamificationTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 19/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamificationTableViewCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UILabel *actionName;
@property (strong,nonatomic) IBOutlet UILabel *pointName;
@property (strong,nonatomic) IBOutlet UILabel *earnActionName;

@property (strong,nonatomic) IBOutlet UIImageView *badgeImage;
@property (strong,nonatomic) IBOutlet UILabel *dateLabel;
@property (strong,nonatomic) IBOutlet UIButton *infoButton;
@end
