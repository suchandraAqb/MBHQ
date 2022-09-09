//
//  SetReminderViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 07/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@import UserNotifications;   //ah ln

@protocol ReminderDelegate
-(void) reminderSettingsValue:(NSMutableDictionary *)reminderDict;
-(void) cancelReminder;
@end

@interface SetReminderViewController : UIViewController<UNUserNotificationCenterDelegate>{   //ah ln
    id<ReminderDelegate>reminderDelegate;
}
@property (strong, nonatomic) id reminderDelegate;
@property (strong, nonatomic) NSDictionary *defaultSettingsDict;

+ (BOOL) setLocalNotificationFromDictionary:(NSMutableDictionary *)notificationDict ExtraData:(NSMutableDictionary *)extraDict FromController:(NSString *)fromController Title:(NSString *)title Type:(NSString *)type Id:(NSInteger)eventID;   //ah ln

+ (BOOL) setOldLocalNotificationFromDictionary:(NSMutableDictionary *)notificationDict ExtraData:(NSMutableDictionary *)extraDict FromController:(NSString *)fromController Title:(NSString *)title Type:(NSString *)type Id:(NSInteger)eventID;   //ah ln1
+ (BOOL) setNotificationAt:(NSDate *)fireDate FromController:(NSString *)fromController Id:(NSString *) remID Title:(NSString *) title Body:(NSString *) body;  //ahn
@property BOOL fromGratitude;
@property BOOL isFirstTime; //gami_badge_popup
@property NSString *fromController;
@property BOOL fromAddVitaminGp;
@property BOOL isFromHacker;
@property BOOL isfromHabitHideYearly;
@property BOOL isremoveDailyTwiceDaily;
@property BOOL isFromReminder;
@end
