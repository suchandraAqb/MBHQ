//
//  AddEditIngredientViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 28/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "MasterMenuViewController.h"
#import "DropdownViewController.h"

@protocol AddEditIngredientDelegate<NSObject>
@optional -(void)didCheckAnyChangeIngredient:(BOOL)isChanged;
@end

@interface AddEditIngredientViewController : UIViewController<DropdownViewDelegate>

@property (nonatomic,strong) id delegate;
@property (nonatomic,strong)NSNumber *IngredientId;
@property (nonatomic,strong)NSString *mealType;
@property(nonatomic,strong)NSDate *currentDate;//AmitY //For Meal Match
@property (nonatomic)  BOOL isFromMealMatch;//AmitY //For Meal Match
@end
