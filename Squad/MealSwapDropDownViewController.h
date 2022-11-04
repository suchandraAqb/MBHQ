//
//  MealSwapDropDownViewController.h
//  Squad
//
//  Created by AQB Solutions Private Limited on 15/05/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MealSwapDropDownDelegate <NSObject>
@optional - (void)didSelectMeal:(NSDictionary *)mealDict;
@optional - (void)didSwapComplete:(BOOL)isComplete;
@optional - (void)didMultiSwapCompleteWithDropdown:(NSDictionary *)swapDict;
@end

@interface MealSwapDropDownViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    id<MealSwapDropDownDelegate>delegate;
}

@property (nonatomic,strong)id delegate;
@property () BOOL isFromFoodPrep;
@property(weak,nonatomic) id controllerNeedToUpdate;
@property()int mealSessionIdToReplace;
@end
