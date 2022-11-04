//
//  ExerciseDetailsTableViewCell.h
//  ABBBCOnline
//
//  Created by AQB Mac 4 on 30/11/16.
//  Copyright © 2016 Aqb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface ExerciseDetailsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *expandCollapseButton;
@property (strong, nonatomic) IBOutlet UILabel *exerciseName;
@property (strong, nonatomic) IBOutlet UILabel *reps;
@property (strong, nonatomic) IBOutlet UILabel *sets;

@property (strong, nonatomic) IBOutlet UIStackView *stackView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *detailsView;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UIStackView *detailContainerStackView;
@property (strong, nonatomic) IBOutlet UIStackView *restPeriodStackView;
@property (strong, nonatomic) IBOutlet UILabel *restPeriod;
@property (strong, nonatomic) IBOutlet UIStackView *tipsStackView;
@property (strong, nonatomic) IBOutlet UILabel *tips;

@property (strong, nonatomic) IBOutlet UILabel *exerciseTips;
@property (strong, nonatomic) IBOutlet UIStackView *exerciseTipsStackView;
@property (strong, nonatomic) IBOutlet UIImageView *exerciseImageView;
@property (strong, nonatomic) IBOutlet UIStackView *equipmentRequiredStackView;
@property (strong, nonatomic) IBOutlet UILabel *equipmentRequired;
@property (strong, nonatomic) IBOutlet UIStackView *equipmentBasedAlternativesStackView;
@property (strong, nonatomic) IBOutlet UILabel *equipmentBasedAlternatives;
@property (strong, nonatomic) IBOutlet UIStackView *bodyWeightAlternativesStackView;
@property (strong, nonatomic) IBOutlet UILabel *bodyWeightAlternatives;
@property (strong, nonatomic) IBOutlet UIView *exercisePlayerView;

@property (strong, nonatomic) IBOutlet UIView *circuitSuperSetView;
@property (strong, nonatomic) IBOutlet UIView *circuitSuperSetUpperView;
@property (strong, nonatomic) IBOutlet UIView *circuitSuperSetLowerView;
@property (strong, nonatomic) IBOutlet UIView *circuitSuperSetMiddleView;
@property (strong, nonatomic) IBOutlet UILabel *setLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainViewWidthConstraint;
@property (strong, nonatomic) IBOutlet UIButton *cellEditExerciseButton;
@property (strong, nonatomic) IBOutlet UIScrollView *cellScrollView;
@property (nonatomic, assign) CGFloat lastContentOffset;    //arnab 17
@property (strong, nonatomic) IBOutlet UIButton *scrollNextButton;  //ah 17
@property (strong, nonatomic) IBOutlet UIButton *scrollPreviousButton;
@property (strong, nonatomic) IBOutlet UIStackView *equipmentBasedAlternativesButtonStackView;
@property (strong, nonatomic)  IBOutlet UIView *playerContainer;
@property (strong, nonatomic) IBOutlet UIStackView *bodyWeightAlternativesButtonStackView;
@property (strong, nonatomic)  AVPlayerViewController *playerController;

@property (strong, nonatomic) IBOutlet UIView *cellSeparatorRightView;//ah 27.2
@property (strong,nonatomic)  IBOutlet UIButton *videoButton;
@property (strong,nonatomic)  IBOutlet UIView *editSessionView;
@property (strong,nonatomic)  IBOutlet NSLayoutConstraint *editSessionHeightConstant;

//ah 2.3
@property (strong, nonatomic) AVPlayerItem *videoItem;
@property (strong, nonatomic) AVPlayer *videoPlayer;
@property (strong, nonatomic) AVPlayerLayer *avLayer;
@end
