//
//  DailyGoodnessDetailViewController.h
//  Squad
//
//  Created by MAC 6- AQB SOLUTIONS on 15/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "MasterMenuViewController.h"
#import "DropdownViewController.h"
#import "AddEditCustomNutritionViewController.h"
#import "ShowImageViewController.h"

@protocol DailyGoodnessDetailDelegate<NSObject>
@optional - (void) didCheckAnyChangeForDailyGoodness:(BOOL)ischanged;
@end

@interface DailyGoodnessDetailViewController : UIViewController<DropdownViewDelegate,AddEditCustomNutritionDelegate,ShowImageViewDelegate>{
    id<DailyGoodnessDetailDelegate>delegate;
}
@property (strong,nonatomic) id delegate;
@property (strong, nonatomic)  NSNumber *mealId;
@property (strong, nonatomic)  NSString *dateString;
@property (strong, nonatomic)  NSNumber *mealSessionId;
@property (strong, nonatomic) NSString *fromController; //ah ux
@property (strong, nonatomic)  NSNumber *Calorie;
@property BOOL isFromMealMatch;
@property int MealType;

@property BOOL showTab;
@end
