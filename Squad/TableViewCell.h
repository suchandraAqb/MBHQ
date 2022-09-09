//
//  TableViewCell.h
//  Squad
//
//  Created by AQB SOLUTIONS on 06/12/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *menuImage;
@property (strong, nonatomic) IBOutlet UILabel *menuName;
@property (strong, nonatomic) IBOutlet UISwitch *offlineSwitch;


#pragma mark - Find A Friend
@property (strong, nonatomic) IBOutlet UIImageView *FaFImageView;
@property (strong, nonatomic) IBOutlet UILabel *FaFSenderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *FaFMessageLabel;
@property (strong, nonatomic) IBOutlet UILabel *FaFTimeLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *senderHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myHeightConstraint;

#pragma mark - Message
@property (strong, nonatomic) IBOutlet UITextView *myMessageLabel;
@property (strong, nonatomic) IBOutlet UITextView *senderMessageLabel;
@property (strong, nonatomic) IBOutlet UILabel *myTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *senderTimeLabel;

#pragma mark - SpotifyList
@property (strong, nonatomic) IBOutlet UIImageView *spotifyListImageView;
@property (strong, nonatomic) IBOutlet UILabel *spotifyListLabel;
@property (strong, nonatomic) IBOutlet UILabel *spotifyTracksNo;
#pragma mark - End

#pragma mark - Settings
@property (strong, nonatomic) IBOutlet UIImageView *settingsMusicImageView;
@property (strong, nonatomic) IBOutlet UILabel *settingsMusicTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *settingsMusicSubTitleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *settingsSoundsImageView;
@property (strong, nonatomic) IBOutlet UILabel *settingsSoundsTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *settingsSoundsSubTitle;

@property (strong, nonatomic) IBOutlet UIImageView *settingsFriendImageView;
@property (strong, nonatomic) IBOutlet UILabel *settingsFriendTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *settingsFriendSubTitleLabel;
#pragma mark - End

#pragma mark - PlayList
@property (strong, nonatomic) IBOutlet UILabel *playListLabel;
@property(strong,nonatomic) IBOutlet UIView *selectedView;


#pragma mark - SongList
@property (strong, nonatomic) IBOutlet UILabel *songListLabel;
#pragma mark - Content Mgmt
@property (strong, nonatomic) IBOutlet UILabel *itemNameLabel;

#pragma mark - RoundList
@property (strong, nonatomic) IBOutlet UILabel *roundEditTableCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *roundEditTableOnTime;
@property (strong, nonatomic) IBOutlet UILabel *roundEditTableOffTime;
@property (strong, nonatomic) IBOutlet UIButton *roundEditTableOnButton;
@property (strong, nonatomic) IBOutlet UIButton *roundEditTableOffButton;

@property (strong, nonatomic) IBOutlet UILabel *stationEditTableRoundCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *stationEditTableStationCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *stationEditTableOnTime;
@property (strong, nonatomic) IBOutlet UILabel *stationEditTableOffTime;
@property (strong, nonatomic) IBOutlet UIButton *stationEditTableOnButton;
@property (strong, nonatomic) IBOutlet UIButton *stationEditTableOffButton;
@property (strong, nonatomic) IBOutlet UILabel *stationEditTableRepsLabel;
@property (strong, nonatomic) IBOutlet UILabel *stationEditTableRepsCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *stationEditTableToggleButton;
@property (strong, nonatomic) IBOutlet UIButton *stationEditTableEditButton;
@property (strong, nonatomic) IBOutlet UILabel *offTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *onTimeLabel;
@property (strong, nonatomic) IBOutlet UIView *stationEditTableBottomView;
@property (strong, nonatomic) IBOutlet UILabel *stationEditTableRoundName;

@property (strong, nonatomic) IBOutlet UILabel *stationBottomViewExerciseNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *stationBottomViewExerciseEdit;
@property (strong, nonatomic) IBOutlet UIImageView *stationBottomViewExerciseImage;
@property (strong, nonatomic) IBOutlet UILabel *stationBottomViewExerciseDetails;
@property (strong, nonatomic) IBOutlet UIView *stationBottomViewExerciseVideoView;

@property (strong, nonatomic) IBOutlet UILabel *sessionViewExerciseNameLabel;

@property (strong,nonatomic) IBOutlet UILabel *habitNameLabel;
@property (strong,nonatomic) IBOutlet UILabel *percentagelabel;
@property (strong,nonatomic) IBOutlet UIButton *tickuntickButton;
@property (strong,nonatomic) IBOutlet UIButton *reminderButton;

@property (strong,nonatomic) IBOutlet UILabel *breakNameLabel;
@property (strong,nonatomic) IBOutlet UILabel *breakpercentagelabel;
@property (strong,nonatomic) IBOutlet UIButton *breaktickuntickButton;
@property (strong,nonatomic) IBOutlet UIButton *breakreminderButton;
@property (strong, nonatomic) IBOutlet UIView *habitBreakview;


@property (strong,nonatomic) IBOutlet UILabel *habitNameLabelForToday;
@property (strong,nonatomic) IBOutlet UIButton *checkUncheckButtonForToday;
@property (strong,nonatomic) IBOutlet UIButton *habitButtonPressed;

@property (strong,nonatomic) IBOutlet UIStackView *editView;

@property (strong,nonatomic) IBOutlet UILabel *popularHabitLabel;
@property (strong,nonatomic) IBOutlet UIButton *checkUncheckPopularButton;

@property (strong,nonatomic) IBOutlet UILabel *guidedMeditationTitle;
@property (strong,nonatomic) IBOutlet UIButton *checkUncheckButton;
@property (strong,nonatomic) IBOutlet UIButton *minusButton;
#pragma mark - End
@end
