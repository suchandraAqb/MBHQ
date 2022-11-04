//
//  TrackViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 19/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
@interface TrackViewController : UIViewController
-(IBAction)itemButtonPressed:(UIButton *)sender;

@property BOOL fromTodayPage;
@property BOOL redirectBackToTodayPage;
@end
