//
//  ExerciseDetailHeaderView.h
//  ABBBCOnline
//
//  Created by AQB Mac 4 on 30/11/16.
//  Copyright © 2016 Aqb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ExerciseDetailHeaderView : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet UIStackView *outerStackView;
@property (strong, nonatomic) IBOutlet UILabel *superCircuitName;

@property (strong, nonatomic) IBOutlet UIView *orContainterView;
@property (strong, nonatomic) IBOutlet UIStackView *mainStackView;

@property (strong, nonatomic) IBOutlet UILabel *orLabel;
@property (strong, nonatomic) IBOutlet UIView *orTopSideBar;
@property (strong, nonatomic) IBOutlet UIView *orMiddleSideBar;
@property (strong, nonatomic) IBOutlet UIView *orBottomSideBar;

@property (strong, nonatomic) IBOutlet UIView *mainSideBarContainer;

@property (strong, nonatomic) IBOutlet UIView *detailSideBarContainer;

@property (strong, nonatomic) IBOutlet UILabel *circuitName;
@property (strong, nonatomic) IBOutlet UILabel *circuitReps;
@property (strong, nonatomic) IBOutlet UILabel *circuitSets;

@property (strong, nonatomic) IBOutlet UILabel *circuitNumber;
@property (strong, nonatomic) IBOutlet UIButton *expandCollapseButton;

@property (strong, nonatomic) IBOutlet UIStackView *circuitDetailsStackView;
@property (strong, nonatomic) IBOutlet UIView *circuitDetailsView;




@property (strong, nonatomic) IBOutlet UILabel *repsCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *setCountLabel;
@property (strong, nonatomic) IBOutlet UIView *setMainView;
@property (strong, nonatomic) IBOutlet UIView *setMiddleView;
@property (strong, nonatomic) IBOutlet UIView *setUpperView;
@property (strong, nonatomic) IBOutlet UIView *setLowerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftViewWidthConstraint; //arnab 17
@property (nonatomic, assign) CGFloat lastContentOffset;    //arnab 17
@property (strong, nonatomic) IBOutlet UIScrollView *detailScroll;  //arnab 17
@property (strong, nonatomic) IBOutlet UIButton *headerEditButton;  //arnab 17
@property (strong, nonatomic) UIView *previousContentView;
@property (strong, nonatomic) UIScrollView *previousScrollView;

@property (strong, nonatomic) IBOutlet UIImageView *dropdownArrowImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dropdownWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dropdownHeightConstraint;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIStackView *circuitInstructionsStackView;
@property (strong, nonatomic) IBOutlet UILabel *circuitInstructionsLabel;
@property (strong, nonatomic) IBOutlet UILabel *circuitTipsLabel;
@property (strong, nonatomic) IBOutlet UIStackView *circuitTipsStackView;
@property (strong, nonatomic) IBOutlet UIStackView *circuitInstructionTipsContainerStackView;





@property (strong, nonatomic) IBOutlet UIImageView *exerciseImageView;
@property (strong, nonatomic) IBOutlet UIStackView *equipmentRequiredStackView;
@property (strong, nonatomic) IBOutlet UILabel *equipmentRequired;
@property (strong, nonatomic) IBOutlet UIStackView *equipmentBasedAlternativesStackView;
@property (strong, nonatomic) IBOutlet UIStackView *equipmentBasedAlternativesButtonStackView;

@property (strong, nonatomic) IBOutlet UIStackView *bodyWeightAlternativesStackView;
@property (strong, nonatomic) IBOutlet UIStackView *bodyWeightAlternativesButtonStackView;

@property (strong, nonatomic) IBOutlet UIView *exercisePlayerView;

@property (strong, nonatomic) IBOutlet UIButton *scrollNextButton;  //ah 17
@property (strong, nonatomic) IBOutlet UIButton *scrollPreviousButton;

@property (strong, nonatomic)  AVPlayerViewController *playerController;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong, nonatomic)  IBOutlet UIView *playerContainer;
@property (strong, nonatomic) IBOutlet UILabel *instructionLabel;
@property (strong, nonatomic) IBOutlet UIStackView *instructionLabelStackView;
@property (strong, nonatomic) IBOutlet UIStackView *tipsLabelStackView;

@end
