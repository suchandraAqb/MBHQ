//
//  SavedNutritionPlanViewController.h
//  Squad
//
//  Created by aqb-mac-mini3 on 25/06/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResetProgramViewController.h"

@protocol SavedNutritionViewDelegate<NSObject>
@optional - (void)didCheckAnyChangeForSavedNutrition:(BOOL)ischanged;
@end
@interface SavedNutritionPlanViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ResetProgramViewDelegate>{
    id<SavedNutritionViewDelegate>delegate;
}
@property (strong,nonatomic)id delegate;

@end
