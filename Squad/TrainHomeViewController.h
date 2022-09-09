//
//  TrainHomeViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 15/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"

@interface TrainHomeViewController : UIViewController
@property BOOL haveToSendToExerciseSettings;

- (IBAction)itemButtonPressed:(UIButton *)sender;
@property BOOL fromTodayPage;
@property BOOL redirectBackToTodayPage;
@property (nonatomic,strong) UIViewController *returnController;
@end
