//
//  VideoTableViewCell.h
//  Squad
//
//  Created by AQB SOLUTIONS on 28/12/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *exerciseNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *exerciseTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *exerciseUnitLabel;
@property (strong, nonatomic) IBOutlet UILabel *exerciseSetCountLabel;
@property (strong, nonatomic) IBOutlet UIView *exerciseBgView;
@property (strong, nonatomic) IBOutlet UILabel *exerciseSupersetLabel;
@property (strong, nonatomic) IBOutlet UIView *exerciseSupersetTopView;
@property (strong, nonatomic) IBOutlet UIView *exerciseSupersetMiddleView;
@property (strong, nonatomic) IBOutlet UIView *exerciseSupersetBottomView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *exerciseSupersetMVTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *exerciseSupersetMVBottomConstraint;
@property (strong, nonatomic) IBOutlet UILabel *exerciseRepsCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *exerciseCircuitNo;
@property (strong, nonatomic) IBOutlet UILabel *exerciseExNo;
@property (strong, nonatomic) IBOutlet UILabel *exerciseExName;
@property (strong, nonatomic) IBOutlet UILabel *repsSecsLabel;

@end
