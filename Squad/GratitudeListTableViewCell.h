//
//  GratitudeListTableViewCell.h
//  Squad
//
//  Created by Rupbani Mukherjee on 20/05/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GratitudeListTableViewCell : UITableViewCell
@property(strong,nonatomic) IBOutlet UILabel *gratitudeListLabel;
@property(strong,nonatomic) IBOutlet UILabel *gratitudeListDayLabel;

@property (strong, nonatomic) IBOutlet UIButton *notificationButton;


@end

NS_ASSUME_NONNULL_END
