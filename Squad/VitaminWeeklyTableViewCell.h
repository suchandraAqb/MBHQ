//
//  VitaminWeeklyTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 15/03/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VitaminWeeklyTableViewCell : UITableViewCell
@property (strong,nonatomic) IBOutletCollection(UIButton) NSArray *weekdays;
@property (strong,nonatomic) IBOutlet UILabel *vitaminLabel;
@property (strong,nonatomic) IBOutlet UIButton *smileyTypeButton;
@property (strong,nonatomic) IBOutlet UIButton *vitamimEditWeeklyButton;

@end

NS_ASSUME_NONNULL_END
