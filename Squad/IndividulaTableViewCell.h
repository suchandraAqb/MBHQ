//
//  IndividulaTableViewCell.h
//  App Booty
//
//  Created by AQB Solutions-Mac Mini 2 on 12/02/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>



@interface IndividulaTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *exerciseIndex;

@property (strong, nonatomic) IBOutlet UILabel *exerciseName;
@property (strong, nonatomic) IBOutlet UILabel *repsLabel;//,,,change new1
@property (strong, nonatomic) IBOutlet UIButton *expandButton;
@property (strong, nonatomic) IBOutlet UIView *detailsView;
@property(nonatomic, strong) IBOutlet UIView *playerView;
@property (nonatomic,strong) IBOutlet UIImageView *exerciseImage;
@property(nonatomic, strong)  AVPlayerViewController *playerController;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailsViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;
@property (strong,nonatomic)  IBOutlet UILabel *exerciseTipsLabel;

@end
