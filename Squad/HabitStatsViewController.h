//
//  HabitStatsViewController.h
//  Squad
//
//  Created by Suchandra Bhattacharya on 16/12/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HabitStatsViewController : UIViewController<JTCalendarDelegate>
@property (strong,nonatomic) NSDictionary *habitDict;
@property BOOL isCreateOrTick;
@property BOOL isFromHabitList;
@property BOOL isfromLocalNotification;
@end

NS_ASSUME_NONNULL_END
