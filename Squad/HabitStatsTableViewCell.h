//
//  HabitStatsTableViewCell.h
//  Squad
//
//  Created by Suchandra Bhattacharya on 24/12/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HabitStatsTableViewCell : UITableViewCell
-(void)setUpView:(NSArray*)arr indexValue:(int)index with:(NSArray*)habitArray with:(int)currentMonth;
@property (strong,nonatomic)IBOutlet NSLayoutConstraint *collectionHeightConstant;
@property (strong,nonatomic) IBOutlet UILabel *habitName;
@property (strong,nonatomic) IBOutlet UILabel *monthLabel;
@property (strong,nonatomic) IBOutlet UIButton *habitCreateButton;
@property (strong,nonatomic) IBOutlet UIButton *habitBreakButton;
@property (strong,nonatomic) IBOutlet UIButton *habitNameButton;
@property (strong,nonatomic) IBOutlet UIView *monthSeperatorview;
@property (strong,nonatomic) IBOutlet UIStackView *stack;
@property (strong,nonatomic) IBOutlet UIButton *editButton;
@property (strong,nonatomic) IBOutlet UILabel *habitPercentageLabel;
@property (strong,nonatomic) IBOutlet UIView *notesView;
@property (strong,nonatomic) IBOutlet UILabel *notesTextlabel;
@property (strong,nonatomic) IBOutlet UILabel *habitPercentageForYearly;
@property (strong,nonatomic) IBOutlet UILabel *habitYearNameForYearly;
@property (strong,nonatomic) IBOutlet UILabel *habitNameForQuater;
@property (strong,nonatomic) IBOutlet UILabel *habitPercentageForQuater;
@property (strong,nonatomic) IBOutletCollection(UILabel) NSArray *percentageLabelMonthly;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *percentageHeightConstant;
@end

NS_ASSUME_NONNULL_END
