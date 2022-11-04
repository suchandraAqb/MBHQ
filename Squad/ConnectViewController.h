//
//  ConnectViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 07/12/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"

@interface ConnectViewController : UIViewController //add_discover

-(IBAction)findASquadMemberButtonPressed:(id)sender;
-(void) fbForumButtonPressedWithSender:(UIButton *)sender; //ah ux
-(IBAction)findASquadMemberButtonPressed:(id)sender;

@property BOOL fromTodayPage;
@property BOOL redirectBackToTodayPage;
@end
