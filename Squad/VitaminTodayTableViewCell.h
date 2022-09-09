//
//  VitaminTodayTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 07/03/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VitaminTodayTableViewCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UIButton *todayPortionImgButton;
@property (strong,nonatomic) IBOutlet UILabel *todayVitaminName;
@property (strong,nonatomic) IBOutlet UIButton *notificationOfOnButton;
@property (strong,nonatomic) IBOutlet UILabel *completePortionLabel;
@property (strong,nonatomic) IBOutlet UIButton *vitamimEditButton;
@end

NS_ASSUME_NONNULL_END
