//
//  SevenDayTrialViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 19/9/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "HomePageViewController.h"
#import "NavigationViewController.h"

@interface SevenDayTrialViewController : UIViewController
@property (nonatomic) BOOL isFromAppDelegate;
@property (nonatomic) BOOL isFromFb;
@property (strong, nonatomic)  NSString *fName;
@property (strong, nonatomic)  NSString *lName;
@property (strong, nonatomic)  NSString *email;
@property (strong, nonatomic)  NSString *password;
@property (strong, nonatomic)  UIViewController *ofType;
-(void)updateUserData:(NSDictionary *)userDataDict;

@end
