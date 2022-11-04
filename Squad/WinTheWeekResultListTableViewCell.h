//
//  WinTheWeekResultListTableViewCell.h
//  Squad
//
//  Created by Admin on 15/02/21.
//  Copyright © 2021 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WinTheWeekResultListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIView *bracketTopView;
@property (strong, nonatomic) IBOutlet UIView *bracketMiddleView;
@property (strong, nonatomic) IBOutlet UIView *bracketBottomView;
@property (strong, nonatomic) IBOutlet UIButton *bracketCountButton;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;



@end

NS_ASSUME_NONNULL_END
