//
//  ExerciseListTableViewCell.h
//  Squad
//
//  Created by AQB Mac 4 on 19/01/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@protocol IndividualExerciseProtocol <NSObject>
-(void)loadNewScreen:(int)Id;
@end

@interface ExerciseListTableViewCell : UITableViewCell{
     id<IndividualExerciseProtocol>delegate;
}
@property (nonatomic,strong)id delegate;

@property (strong, nonatomic) IBOutlet UIStackView *stackView;
@property (strong, nonatomic) IBOutlet UILabel *exerciseName;
@property (strong, nonatomic) IBOutlet UIButton *expandCollapse;
@property (strong, nonatomic) IBOutlet UIImageView *exerciseImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *exerciseImageWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *exerciseTableViewHeightConstraint;
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

@property (strong, nonatomic)IBOutlet UIButton *historyButton; //add_new_1
@property (strong, nonatomic)IBOutlet UIButton *sessionHistoryButton; //add_new_1

@property (strong,nonatomic) IBOutlet UIView *detailsview;
@property (strong,nonatomic) IBOutlet UIView *equipmentRequiredView;
@property (strong,nonatomic) IBOutlet UIView *equipmentBasedView;
@property (strong,nonatomic) IBOutlet UIView *bodyWeightView;
@property (strong,nonatomic) IBOutlet UIStackView *stack;
@property (strong,nonatomic) IBOutlet UITableView *eqRequirdTable;
@property (strong,nonatomic) IBOutlet UITableView *eqBasedtable;
@property (strong,nonatomic) IBOutlet UITableView *bodyWeightTable;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *detailsViewHeight;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *totalDetailsHeightConstant;
-(void)setUpView:(NSDictionary*)circuitDict;

@end
