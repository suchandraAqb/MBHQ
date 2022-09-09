//
//  CustomNutritionMealSettingsViewController.h
//  Squad
//
//  Created by aqbsol iPhone on 02/02/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomNutritionMealSettingsDelegate<NSObject>
@optional -(void)didCheckAnyChangeForMealSettings:(BOOL)ischanged;
@end

@interface CustomNutritionMealSettingsViewController : UIViewController{
    id<CustomNutritionMealSettingsDelegate>delegate;
}
@property (strong,nonatomic) id delegate;
@property (strong, nonatomic)  NSNumber *mealId;
@property (strong, nonatomic)  NSNumber *mealSessionId;
@property (strong, nonatomic)  NSString *dateString;
@property (strong, nonatomic) NSString *fromController;
@property(nonatomic,strong)NSDate *weekDate;
@property(nonatomic,strong)NSDictionary *mealData;


@end
