//
//  AddRecipeViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 21/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEditCustomNutritionViewController.h"

@protocol AddRecipeViewDelegate<NSObject>
@optional - (void)didCheckAnyChangeForAddRecipe:(BOOL)ischanged;
@end

@interface AddRecipeViewController : UIViewController<AddEditCustomNutritionDelegate>{
    id<AddRecipeViewDelegate>delegate;
}
@property (strong,nonatomic) id delegate;

@property(nonatomic,strong)NSDate *currentDate;//AmitY //For Meal Match
@property (nonatomic)  BOOL isFromMealMatch;//AmitY //For Meal Match

@property int MealType;
@end
