//
//  VisionGoalActionViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 01/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@import UserNotifications;   //ah ln

@interface VisionGoalActionViewController : UIViewController<AVPlayerViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic)  BOOL *isfromLocalNotification;
@property BOOL isFromSetGoal;  //add_new_new
@property BOOL isFromCreateAction;  //add_new_new

@property BOOL isFromBuddy;
@end
