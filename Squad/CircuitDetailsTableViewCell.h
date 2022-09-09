//
//  CircuitDetailsTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 14/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface CircuitDetailsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIStackView *stackView;
@property (strong, nonatomic) IBOutlet UILabel *exerciseName;
@property (strong, nonatomic) IBOutlet UILabel *exerciseNumber;
@property (strong, nonatomic) IBOutlet UILabel *reps;
@property (strong, nonatomic) IBOutlet UILabel *sets;
@property (strong, nonatomic) IBOutlet UIStackView *topInnerStackView;

@property (strong, nonatomic) IBOutlet UIStackView *repsSetstackView;
@property (strong, nonatomic) IBOutlet UIButton *expandCollapse;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIStackView *detailStackView;
@property (strong, nonatomic) IBOutlet UIStackView *instructionStackView;
@property (strong, nonatomic) IBOutlet UIStackView *tipsStackView;
@property (strong, nonatomic) IBOutlet UILabel *instruction;
@property (strong, nonatomic) IBOutlet UILabel *tips;
@property (strong, nonatomic) IBOutlet UIStackView *equipmentRequiredStackView;
@property (strong, nonatomic) IBOutlet UILabel *equipmentRequired;
@property (strong, nonatomic) IBOutlet UIStackView *equipmentBasedAlternativesStackView;
@property (strong, nonatomic) IBOutlet UIStackView *equipmentBasedAlternativesButtonStackView;
@property (strong, nonatomic) IBOutlet UIStackView *bodyWeightAlertnativesStackView;
@property (strong, nonatomic) IBOutlet UIStackView *bodyWeightAlertnativesButtonStackView;

@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *previousButton;
@property (strong, nonatomic) IBOutlet UIView *playerContainer;
@property (strong, nonatomic) IBOutlet UIImageView *exImage;
@property (strong, nonatomic) IBOutlet UIView *playerView;
@property (strong, nonatomic) AVPlayerViewController *playerController;


@end

