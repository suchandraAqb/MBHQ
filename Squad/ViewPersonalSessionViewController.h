//
//  ViewPersonalSessionViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 14/02/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResetProgramViewController.h"
#import "ExerciseDetailsViewController.h"
#import "AddCustomSessionViewController.h"

@interface ViewPersonalSessionViewController : UIViewController<ResetProgramViewDelegate,ExerciseDetailsDelegate>
@property (strong,nonatomic) NSDate *weekStartDate;
@property BOOL isFromSetProgram;
@end
