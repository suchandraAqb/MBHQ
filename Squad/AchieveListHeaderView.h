//
//  AchieveListHeaderView.h
//  Squad
//
//  Created by AQB Mac 4 on 27/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AchieveListHeaderView : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet UIImageView *headerBgImage;
@property (strong, nonatomic) IBOutlet UILabel *achieveTypeName;
@property (strong, nonatomic) IBOutlet UIButton *collapseButton;

@end
