//
//  MealAddViewController.h
//  Squad
//
//  Created by AQB-Mac-Mini 3 on 12/09/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "MealAddViewController.h"
@protocol MealTypeViewDelagete<NSObject>
@optional - (void)didCheckAnyChangeForMealType:(BOOL)ischanged;
@end

@interface MealTypeViewController : UIViewController<MealAddViewDelegate>{
    id<MealTypeViewDelagete>delegate;
}
@property(nonatomic,strong) id delegate;
@property(nonatomic,strong)NSArray *mealTypeArray;
@property(nonatomic,strong)NSDate *currentDate;
@property int mealCategory;
@end
