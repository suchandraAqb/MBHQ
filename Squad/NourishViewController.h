//
//  NourishViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 26/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"

@interface NourishViewController : UIViewController
@property BOOL isFromNotification;
@property BOOL isFromMealMatchNotification; //AY 21032018
@property BOOL isFromShoppingListNotification; //AY 21032018
-(IBAction)itemButtonPressed:(UIButton *)sender;
-(IBAction)customShoppingListViewButtonTapped:(id)sender;

@property BOOL isWeeklyShopping;
@property BOOL fromTodayPage;
@property BOOL redirectBackToTodayPage;
@property BOOL isCustom;
@end
