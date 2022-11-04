//
//  CustomNutritionPlanListCollectionViewController.h
//  Squad
//
//  Created by aqbsol iPhone on 22/01/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCartPopUpViewController.h"
#import "DailyGoodnessDetailViewController.h"
@protocol CustomNutritionPlanListCollectionViewControllerDelegate
@optional -(void)selectedCartOPtion:(int)numberOfMeal row:(int)rowNumber section:(int)sectionNumber;
@optional -(void)selectedSaveOption:(int)numberOfMeal row:(int)rowNumber section:(int)sectionNumber;
@optional -(void)closeShopView;
@optional -(void)didCheckAnyChangeForCollection:(BOOL)ischanged;
@optional -(void)swapMealHeaderName:(NSDictionary *)swapDict active:(BOOL)isActive;
@optional -(void)shoppingButtonFlashCheck:(BOOL)isFlash;
@end
@interface CustomNutritionPlanListCollectionViewController : UIViewController
<UICollectionViewDelegate,UICollectionViewDataSource,DailyGoodnessDetailDelegate,FoodPrepSearchViewDelegate>{
    id<CustomNutritionPlanListCollectionViewControllerDelegate>delegate;
    
}

@property BOOL isComplete;
@property BOOL isMultipleSwap;
@property BOOL isListView;
@property (nonatomic, strong) NSDictionary *swapMealDict;
@property(nonatomic)int stepnumber;
@property(assign)BOOL isFromShoppingList;
@property(nonatomic,strong)NSDate *weekDate;
@property (strong, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UIButton *applyMultipleSwapButton;
@property BOOL isCustom;

@property(nonatomic,strong)id delegate;

- (void)nextButton;
- (void)previousButton;
- (void)reloadMyCollection;
-(void)saveCustomShoppingListButtonPressed;
@end
