//
//  SectionHeaderView.h
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 14/10/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeaderView : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet UILabel *stageLabel;
@property (strong, nonatomic) IBOutlet UIButton *upgradeButton;
@property (strong, nonatomic) IBOutlet UIImageView *sectionHeaderViewBackgroundImage;

@end
