//
//  ExerciseDailyListViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 03/01/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseTypeViewController.h"

@interface ExerciseDailyListViewController : UIViewController<ExerciseTypeDelegate>

@property BOOL isOnlyToday;

@end
