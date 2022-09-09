//
//  ViewScoreTableCell.h
//  ABS Finisher
//
//  Created by aqb-mac-5 on 14/10/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewScoreTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *backgroundCellView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dateContainerHeightConstraints;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dateLabelHeightConstraints;
@property (strong, nonatomic) IBOutlet UIButton *calenderButton;

@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *countContainerHeightConstraints;
@property (strong, nonatomic) IBOutlet UITextField *countTextfield;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *countLabelHeightConstraints;


@property (strong, nonatomic) IBOutlet UILabel *repsLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *repsContainerHeightConstraints;
@property (strong, nonatomic) IBOutlet UITextField *repstextField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *repsLabelHeightConstraints;


@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *timeContainerHeightConstraints;
@property (strong, nonatomic) IBOutlet UIButton *timeButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *timeLabelHeightConstraints;

@property (strong, nonatomic) IBOutlet UILabel *videoLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *videoContainerHeightConstraints; //Change AmitY 03-Nov-2016
@property (strong, nonatomic) IBOutlet UITextField *videoTextfield;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *videoLinkLabelHeightConstraints;
@property (strong, nonatomic) IBOutlet UIButton *videoUploadButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

//AmitY 3-Nov-2016
@property (strong, nonatomic) IBOutlet UILabel *videoNameLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *videoNameContainerHeightConstraints;
@property (strong, nonatomic) IBOutlet UITextField *videoNametextField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *videoNameLabelHeightConstraints;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *countTextFieldTopConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *countTextFieldHeightConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *repsTextFieldTopConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *repsTextFieldHeightConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *timeButtonTopConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *timeButtonHeightConstraints;

@property (strong, nonatomic) IBOutlet UIView *shareContentView;
@property (strong, nonatomic) IBOutlet UIButton *videoPlayButton;

@property(strong,nonatomic) IBOutlet UIStackView *stackView;
@property(strong,nonatomic) IBOutlet UIView *countView;
@property(strong,nonatomic) IBOutlet UIView *repsView;
@property(strong,nonatomic) IBOutlet UIView *timeView;
//End

@end
