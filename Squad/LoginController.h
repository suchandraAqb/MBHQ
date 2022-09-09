//
//  LoginController.h
//  The Life
//
//  Created by AQB SOLUTIONS on 25/03/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+ECSlidingViewController.h"
#import "MasterMenuViewController.h"
#import "ECSlidingViewController.h"
#import "Utility.h"
#import "AppDelegate.h"




//faf
@interface LoginController : UIViewController
@property (nonatomic) BOOL isFromSignUp;
@property (nonatomic) BOOL isFromAppDelegate;
@property(nonatomic,strong)NSString *initialEmail;
@property (nonatomic) BOOL isMovedToToday;


//faf
@end
