//
//  AchieveHomeViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 06/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "PersonalChallengeViewController.h"
#import "VisionGoalActionViewController.h"
#import "VisionHomeViewController.h"
#import "BucketListNewViewController.h"

@interface AchieveHomeViewController : UIViewController
- (IBAction)visionGoalsActionsButtonTapped:(id)sender;
- (IBAction)bucketListTapped:(id)sender;
- (IBAction)accountabilityBuddiesTapped:(id)sender;
-(IBAction)personalChallengesButtonTapped:(id)sender;
- (IBAction)visionBoardButtonTapped:(id)sender;
@property BOOL fromTodayPage;
@property BOOL redirectBackToTodayPage;
@end
