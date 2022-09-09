//
//  FoodPrepViewController.h
//  Squad
//
//  Created by aqbsol iPhone on 05/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodPrepAddEditViewController.h"

@protocol FoodPrepViewDelegate<NSObject>
@optional - (void)didCheckAnyChangeForFoodPrep:(BOOL)ischanged;
@end
@interface FoodPrepViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,FoodPrepAddEditViewDelegate>{
    id<FoodPrepViewDelegate>delegate;
}
@property (strong,nonatomic)id delegate;
@end
