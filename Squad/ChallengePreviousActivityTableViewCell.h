//
//  ChallengePreviousActivityTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 16/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengePreviousActivityTableViewCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UILabel *dateLabel;
@property (strong,nonatomic) IBOutlet UIStackView *activityStack;
@property (strong,nonatomic) IBOutlet UILabel *countLabel;
@property (strong,nonatomic) IBOutlet UILabel *repsLabel;
@property (strong,nonatomic) IBOutlet UILabel *timeLabel;
@property (strong,nonatomic) IBOutlet UITextView *videoLinkTextView;
@property (strong,nonatomic) IBOutlet UILabel *videoLabel;
@property (strong,nonatomic) IBOutlet UIButton *playButton;
@property (strong,nonatomic) IBOutlet UIView *cellView;
@end
