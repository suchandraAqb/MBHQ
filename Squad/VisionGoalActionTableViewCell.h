//
//  VisionGoalActionTableViewCell.h
//  Squad
//
//  Created by AQB SOLUTIONS on 03/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisionGoalActionTableViewCell : UITableViewCell
#pragma mark - Goals    
//ah ac
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (strong, nonatomic) IBOutlet UIImageView *goalImageView;
@property (strong, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UIButton *expCollRowButton;
@property (weak, nonatomic) IBOutlet UIButton *goalImageButton;

@property (weak, nonatomic) IBOutlet UIView *tempHistoryView;
@property (weak, nonatomic) IBOutlet UILabel *completedLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *dayCollectionView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *tickCollectionButton;
@property (weak, nonatomic) IBOutlet UIButton *reminderOnOffButton;
@property (weak, nonatomic) IBOutlet UIButton *viewHistoryButton;

@property (weak, nonatomic) IBOutlet UIView *actionAddView;
@property (weak, nonatomic) IBOutlet UIButton *actionAddButton;
@property (weak, nonatomic) IBOutlet UIView *arrowView;
@property (weak, nonatomic) IBOutlet UIButton *createdDateButton;
@property (weak, nonatomic) IBOutlet UILabel *addActionLabel;

#pragma mark - Actions
@property (strong, nonatomic) IBOutlet UIImageView *actionsImageView;
@property (strong, nonatomic) IBOutlet UILabel *actionsTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *actionsSubTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *checkUncheckButton;
@property (strong, nonatomic) IBOutlet UIButton *actionStartDate;

#pragma mark - Values
@property (strong, nonatomic) IBOutlet UILabel *valuesLabel;
@property (strong, nonatomic) IBOutlet UIButton *valuesDownArrow;
@property (strong, nonatomic) IBOutlet UIButton *valuesUpArrow;
@property (strong, nonatomic) IBOutlet UIButton *valuesDeleteButton;

#pragma mark - Vision
@property (weak, nonatomic) IBOutlet UILabel *statementLabel;
@property (weak, nonatomic) IBOutlet UITextView *statementTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statementTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UITextView *pictureTitleTextView;
@property (weak, nonatomic) IBOutlet UITextView *futureMeTextView;
@property (weak, nonatomic) IBOutlet UITextView *liveItNowTextView;

@property (weak, nonatomic) IBOutlet UILabel *pictureTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *futureMeLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveItNowLabel;

@property (weak, nonatomic) IBOutlet UIButton *pictureTitleLabel_btn;
@property (weak, nonatomic) IBOutlet UIButton *futureMeLabel_btn;
@property (weak, nonatomic) IBOutlet UIButton *liveItNowLabel_btn;




@end
