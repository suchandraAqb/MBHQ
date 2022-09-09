//
//  WaterTrackerViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 26/02/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetReminderViewController.h"
#import "JTCalendar.h"
#import "DatePickerViewController.h"
#import "WaterTrackerDetailsViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol WaterTrackerDelegate<NSObject>
-(void)didCheckAnyChangeInWaterTracker:(BOOL)ischanged;
@end
@interface WaterTrackerViewController : UIViewController<JTCalendarDelegate,DatePickerViewControllerDelegate,WaterTrackerDetailsDelegate>{
    id<WaterTrackerDelegate>waterTrackerdelegate;
}

@property (strong,nonatomic)  id waterTrackerdelegate;
@property (strong, nonatomic) NSMutableArray *goalListArray;
@property (strong, nonatomic) NSMutableDictionary *actionSelectedDict;
@property BOOL isNewAction; //gami_badge_popup

@property (strong, nonatomic) NSMutableDictionary *selectedGoal;
@property (strong, nonatomic) NSString *actionName;
@property (strong, nonatomic) NSDictionary *buddyDict;
@property (nonatomic, strong) SPTAudioStreamingController *sPlayer;
@property BOOL isFromTodayOrMealMatch;
@end

NS_ASSUME_NONNULL_END
