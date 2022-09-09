//
//  AddActionViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 14/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetReminderViewController.h"
#import "JTCalendar.h"

@interface AddActionViewController : UIViewController <ReminderDelegate,JTCalendarDelegate>

@property (strong,nonatomic)id delegate;
@property (strong, nonatomic) NSMutableArray *goalListArray;
@property (strong, nonatomic) NSMutableDictionary *actionSelectedDict;
@property BOOL isNewAction; //gami_badge_popup

@property (strong, nonatomic) NSMutableDictionary *selectedGoal;
@property (strong, nonatomic) NSString *actionName;
@property (strong, nonatomic) NSDictionary *buddyDict;
@property (nonatomic, strong) SPTAudioStreamingController *sPlayer;
@end
//ah ac1
