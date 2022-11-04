//
//  AddToPlanViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 13/11/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "DropdownViewController.h"
#import "PECropViewController.h"
#import "FoodPrepSearchViewController.h"

@protocol AddToPlanViewDelegate<NSObject>
@optional -(void) didCheckAnyChangeForMealAdd:(BOOL)ischanged with:(BOOL)isFrom;
@end
@interface AddToPlanViewController : UIViewController<DropdownViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, PECropViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,FoodPrepSearchViewDelegate>{
    //id<AddToPlanViewDelegate>delegate;
}
@property(strong,nonatomic) id delegate;

@property(strong,nonatomic)NSMutableDictionary *mealDetails;
@property BOOL isAdd;
@property BOOL isStatic;
@property int mealTypeData;
@property(strong,nonatomic)NSMutableArray *mealListArray;
@property BOOL isStaticIngredient;
@property(nonatomic,strong)NSDate *currentDate;
@property int MealId;
@property int mealCategory;
@property int MealType;
@property int actualMealType;//SqMeal,SqIngredient,Nutritionix,Quick
@property BOOL quickRecentFreq;
@property BOOL fromMyPlan;
@property(strong,nonatomic)NSDictionary *planMealData;
@end
