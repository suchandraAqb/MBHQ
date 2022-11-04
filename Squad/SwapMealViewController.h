//
//  SwapMealViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 13/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "DropdownViewController.h"

@protocol SwapMealViewControllerDelegate <NSObject>

@optional - (void) didCancel;
@optional - (void) didSelectAdvanceSearch:(NSNumber *)mealId mealSessionId:(NSNumber *)mealSessionId mealDate:(NSDate *)mealDate;


@end
@interface SwapMealViewController : UIViewController<DropdownViewDelegate>{
    id<SwapMealViewControllerDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
@property (strong, nonatomic)  NSNumber *mealId;
@property (strong, nonatomic)  NSNumber *mealSessionId;
@property (strong, nonatomic)  NSDate *mealDate;
@end
