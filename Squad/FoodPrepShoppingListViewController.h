//
//  FoodPrepShoppingListViewController.h
//  Squad
//
//  Created by aqbsol iPhone on 05/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodPrepAddEditViewController.h"

@protocol FoodPrepShoppingListViewDelagate<NSObject>
@optional -(void)didCheckAnyChange:(BOOL)ischanged;
@end
@interface FoodPrepShoppingListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,FoodPrepAddEditViewDelegate>{
    id<FoodPrepShoppingListViewDelagate>delegate;
}
@property (nonatomic,strong)id delegate;
@property (nonatomic, strong)NSNumber *foodPrepId;
@end
