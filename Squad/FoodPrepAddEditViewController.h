//
//  FoodPrepAddEditViewController.h
//  Squad
//
//  Created by aqbsol iPhone on 05/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodPrepSearchViewController.h"
#import "MealSwapDropDownViewController.h"
#import "DailyGoodnessDetailViewController.h"
#import "FoodPrepSearchViewController.h"

@protocol FoodPrepAddEditViewDelegate<NSObject>
@optional -(void)didCheckAnyChange:(BOOL)ischanged;
@end
@interface FoodPrepAddEditViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,DropdownViewDelegate,FoodPrepSearchViewDelegate,MealSwapDropDownDelegate,DailyGoodnessDetailDelegate,FoodPrepSearchViewDelegate>{
    id<FoodPrepAddEditViewDelegate>delegate;
}
@property(strong,nonatomic)id delegate;
@property(nonatomic,strong) NSArray *mealNameArray;
@property()BOOL isEdit;

@end
