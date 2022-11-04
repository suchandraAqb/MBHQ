//
//  ExcerciseTitleTableViewCell.h
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 16/05/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExcerciseTitleTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *excerciseName;
@property(strong,nonatomic) IBOutlet UIStackView *stackView;
@property(strong,nonatomic) IBOutlet UIView *finisherNameView;
@property(strong,nonatomic) IBOutlet UIView *detailsView;
@property(strong,nonatomic) IBOutlet UIView *startDateView;
@property(strong,nonatomic) IBOutlet UIView *endDateView;
@property(strong,nonatomic) IBOutlet UILabel *detailsLabel;
@property(strong,nonatomic) IBOutlet UILabel *startDateLabel;
@property(strong,nonatomic) IBOutlet UILabel *lastDateLabel;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *finisherHeightConstant; //add_11

@end
