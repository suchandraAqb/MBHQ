//
//  MealAddViewController.h
//  Squad
//
//  Created by AQB-Mac-Mini 3 on 13/09/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "DropdownViewController.h"
#import "PECropViewController.h"
#import "FoodPrepSearchViewController.h"
@protocol MealAddViewDelegate<NSObject>
@optional -(void) didCheckAnyChangeForMealAdd:(BOOL)ischanged with:(BOOL)isFrom;
@end

@interface MealAddViewController : UIViewController <DropdownViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, PECropViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,FoodPrepSearchViewDelegate>{
    id<MealAddViewDelegate>delegate;
}
@property(strong,nonatomic) id delegate;

@property(strong,nonatomic)NSDictionary *mealDetails;
@property BOOL isAdd;
@property BOOL isStatic;
@property int mealTypeData;
@property(strong,nonatomic)NSMutableArray *mealListArray;
@property BOOL isStaticIngredient;
@property(nonatomic,strong)NSDate *currentDate;
@property int MealId;
@property int mealCategory;
@end
