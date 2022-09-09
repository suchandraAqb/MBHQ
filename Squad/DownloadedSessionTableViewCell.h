//
//  DownloadedSessionTableViewCell.h
//  Squad
//
//  Created by aqb-mac-mini3 on 19/03/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadedSessionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@end
