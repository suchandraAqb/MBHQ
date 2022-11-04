//
//  AccountabilityGoalActionViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 31/10/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountabilityGoalActionViewController :  UIViewController<AVPlayerViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic)  BOOL *isfromLocalNotification;
@property BOOL isFromSetGoal;  //add_new_new
@property BOOL isFromCreateAction;  //add_new_new
@property(strong,nonatomic) NSDictionary *buddiesDict;
@end
