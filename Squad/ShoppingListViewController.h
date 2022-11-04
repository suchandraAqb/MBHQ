//
//  ShoppingListViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 27/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "PopoverViewController.h"
#import "DropdownViewController.h"
#import "FoodPrepShoppingListTableViewCell.h"

@protocol ShoppingListViewDelegate<NSObject>
@optional -(void)didCheckAnyChangeForShoppingList:(BOOL)ischanged;
@end

@interface ShoppingListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DropdownViewDelegate>{
    id<ShoppingListViewDelegate>delegate;
}
@property (strong,nonatomic)id delegate;
@property BOOL isCustom;
@property(nonatomic,strong)NSDate *weekdate;
@end
