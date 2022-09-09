//
//  AddEditCustomNutritionViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 04/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "MasterMenuViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DropdownViewController.h"
#import "PECropViewController.h"
#import "AddEditIngredientViewController.h"

@protocol AddEditCustomNutritionDelegate<NSObject>
@optional -(void)didCheckAnyChange:(BOOL)ischanged;
@optional -(void)reloadWithNewMeal:(NSNumber *)mealId;
@end

@interface AddEditCustomNutritionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,DropdownViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, PECropViewControllerDelegate>{
    id<AddEditCustomNutritionDelegate>delegate;//Nutrition_local_catch
}
@property (strong,nonatomic) id delegate; //Nutrition_loval_catch
@property (strong, nonatomic)  NSNumber *mealId;
@property (strong, nonatomic)  NSNumber *mealSessionId;
@property (strong, nonatomic)  NSString *dateString;
@property (nonatomic)  BOOL add;
@property(nonatomic,strong)NSDate *currentDate;//AmitY //For Meal Match
@property (nonatomic)  BOOL isFromMealMatch;//AmitY //For Meal Match
@property (strong, nonatomic) NSString *fromController; //ah ux
@property BOOL fromMealView;
@property int MealType;
@end
