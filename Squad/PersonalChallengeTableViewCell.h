//
//  PersonalChallengeTableViewCell.h
//  Squad
//
//  Created by aqb-mac-mini3 on 12/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalChallengeTableViewCell : UITableViewCell
//List Table
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIStackView *mainStackView;

@property (weak, nonatomic) IBOutlet UILabel *challengeName;
@property (weak, nonatomic) IBOutlet UIButton *publicButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *remainderButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UILabel *startedOnLabel;
@property (weak, nonatomic) IBOutlet UILabel *endsOnLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *challengeCompletedLabel;
@property (weak, nonatomic) IBOutlet UIButton *participantButton;
@property (weak, nonatomic) IBOutlet UIView *participantView;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UILabel *start;
@property (weak, nonatomic) IBOutlet UILabel *end;
@property (weak, nonatomic) IBOutlet UILabel *completedDates;
@property (weak, nonatomic) IBOutlet UIView *vertDivider;
@property (weak, nonatomic) IBOutlet UIStackView *fStackView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adminImage;


//USER TABLE
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;

//DETAILS TABLE
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end
