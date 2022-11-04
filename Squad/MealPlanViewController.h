//
//  MealPlanViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 03/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MealPlanViewDelagete<NSObject>
@optional - (void)didCheckAnyChangeForMealPlan:(BOOL)ischanged;
@end

@interface MealPlanViewController : UIViewController<UITextFieldDelegate,DatePickerViewControllerDelegate>{
    id<MealPlanViewDelagete>delegate;
}
@property(nonatomic,strong) id delegate;
@property int stepNumber;
@property(assign,nonatomic) BOOL isfirstTime;//su22
@property BOOL isFromMyplan;
@end
