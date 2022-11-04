//
//  AudioBookTableViewCell.h
//  Squad
//
//  Created by AQB SOLUTIONS on 14/08/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioBookTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) IBOutlet UILabel *eventListName;
@property (strong, nonatomic) IBOutlet UILabel *presenterNameLabel;

@end
