//
//  VitaminMonthlyTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 19/03/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VitaminMonthlyTableViewCell : UITableViewCell<JTCalendarDelegate>
@property (strong,nonatomic) IBOutlet UIButton *monthlySmileyButton;
@property (strong,nonatomic) IBOutlet UILabel *monthlyVitaminLabel;
-(void)setUpView:(NSArray*)arr vitaminArr:(NSArray*)vitaminArr indexValue:(int)index;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *collectionHeightConstant;
@property (strong,nonatomic) IBOutlet UIButton *vitamimEditMonthlyButton;

@end

NS_ASSUME_NONNULL_END
