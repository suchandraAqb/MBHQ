//
//  NewMealAddViewController.h
//  Squad
//
//  Created by AQB Solutions Private Limited on 09/11/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddToPlanViewController.h"
#import "EdamamSearchViewController.h"

@protocol NewMealAddDelegate<NSObject>
@optional -(void)checkChangeMealAdd:(BOOL)ischanged;
@end
@interface NewMealAddViewController : UIViewController<AddToPlanViewDelegate,foodScanDelegate,EdamamSearchDelegate>{
    id<NewMealAddDelegate>delegate;
}

@property(nonatomic,strong) id delegate;
@property int mealType;
@property (nonatomic,strong) NSDictionary *quickMeal;
@property(nonatomic,strong)NSDate *currentDate;
@end
