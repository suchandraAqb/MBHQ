//
//  AppreciateViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 26/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"

@interface AppreciateViewController : UIViewController
-(IBAction)itemButtonPressed:(UIButton *)sender;
-(IBAction)viewAllMeditationButtonPressed:(id)sender;

@property BOOL fromTodayPage;
@property BOOL redirectBackToTodayPage;
@end
