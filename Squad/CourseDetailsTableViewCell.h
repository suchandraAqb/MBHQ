//
//  CourseDetailsTableViewCell.h
//  ProgressBar
//
//  Created by AQB SOLUTIONS on 23/02/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *courseName;
@property(strong,  nonatomic) IBOutlet UILabel *videoTimingLbl;
@property(strong,  nonatomic) IBOutlet UIImageView *videoTimingImg;
@property (strong, nonatomic) IBOutlet UIButton *courseNameButton;
@property (strong, nonatomic) IBOutlet UIButton *courseActionButton;
@property (strong, nonatomic) IBOutlet UILabel *courseActionName;
@property(strong,  nonatomic) IBOutlet UILabel *releaseDateLabel;
@property(strong,  nonatomic) IBOutlet UIView *blurView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong,nonatomic) IBOutlet UILabel *indexLabel;
@end
