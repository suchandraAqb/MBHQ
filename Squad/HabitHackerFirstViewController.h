//
//  HabitHackerFirstViewController.h
//  Squad
//
//  Created by Dhiman on 26/08/20.
//  Copyright © 2020 AQB Solutions. All rights resehhhrved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HabitHackerFirstViewController : UIViewController
@property BOOL isFromHabit;
@property BOOL isMoveToday;
@property (strong,nonatomic) NSDate *todaySelectDate;

@end

NS_ASSUME_NONNULL_END
