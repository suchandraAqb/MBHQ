//
//  MealMatchViewController.h
//  Squad
//
//  Created by AQB-Mac-Mini 3 on 11/09/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "DatePickerViewController.h"
#import "DailyGoodnessDetailViewController.h"
#import "MealAddViewController.h"
#import "MealTypeViewController.h"
#import "FoodScanViewController.h"
#import "NewMealAddViewController.h"
#import "WaterTrackerViewController.h"
#import "CustomNutritionPlanListViewController.h"
@protocol MealMatchViewDelegate<NSObject>
@optional -(void)didCheckAnyChangeForMealMatch:(BOOL)ischanged;
@end
@interface MealMatchViewController : UIViewController <UITextFieldDelegate,DatePickerViewControllerDelegate,DailyGoodnessDetailDelegate,MealTypeViewDelagete,MealAddViewDelegate,NewMealAddDelegate,UIWebViewDelegate,WaterTrackerDelegate,MealPlanViewDelagete>{
    id<MealMatchViewDelegate>delegate;
}
@property (strong,nonatomic) id delegate;
@property (nonatomic, weak) IBOutlet UIWebView *webView;//Pie-chart JS
@property BOOL fromToday;
@end
