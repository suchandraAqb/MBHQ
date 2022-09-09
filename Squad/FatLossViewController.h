//
//  FatLossViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 17/01/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface FatLossViewController : UIViewController

@property (nonatomic,strong) NSDictionary *fatLossDict;
@property (nonatomic,strong) NSDictionary *squadProgram;
@property (nonatomic,strong) NSArray *fatLossAmountArray;
@property(nonatomic,assign) BOOL isNutritionSettings;

@property(assign,nonatomic) BOOL isfirstTime;//su22


@end
