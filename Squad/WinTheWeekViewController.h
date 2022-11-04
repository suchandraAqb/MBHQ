//
//  WinTheWeekViewController.h
//  Squad
//
//  Created by Admin on 01/02/21.
//  Copyright © 2021 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WinTheWeekViewController : UIViewController

@property (strong,nonatomic) NSString *winType;
@property (strong,nonatomic) UIViewController *parent;
@property int dayDoneCount;
@property (strong,nonatomic) NSString *WeekStartDateStr;
@property (strong,nonatomic) NSString *todayDateStr;

@end

NS_ASSUME_NONNULL_END
