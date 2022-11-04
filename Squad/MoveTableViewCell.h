//
//  MoveTableViewCell.h
//  Squad
//
//  Created by AQB SOLUTIONS on 13/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoveTableViewCell : UITableViewCell
//ah cs
#pragma mark - First Table
@property (strong, nonatomic) IBOutlet UILabel *dayNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *firstMoveHereButton;

#pragma mark - Second Table
@property (strong, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondSubTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *secondMoveHereButton;
@property (strong, nonatomic) IBOutlet UIButton *secondSelectButton;
@property (strong, nonatomic) IBOutlet UIImageView *secondEqualImageView;

#pragma mark - Third Table
@property (strong, nonatomic) IBOutlet UILabel *thirdTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdSubTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *thirdMoveHereButton;
@property (strong, nonatomic) IBOutlet UIButton *thirdSelectButton;
@property (strong, nonatomic) IBOutlet UIImageView *thirdEqualImageView;

//design chng
@property (weak, nonatomic) IBOutlet UIButton *editButton;


@end
