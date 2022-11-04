//
//  AchievementsAddEditViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 16/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "MasterMenuViewController.h"
#import "SetReminderViewController.h"
#import "PECropViewController.h"
#import "DropdownViewController.h"
#import "ProgressBarViewController.h"
#import "NotesViewController.h"
@protocol AchievementsAddEditDelegate<NSObject>
@optional - (void)didAchievementsBackAction:(BOOL)ischanged;
@end

@interface AchievementsAddEditViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,ReminderDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, PECropViewControllerDelegate,DropdownViewDelegate,progressViewDelegate,NotesViewDeleagte>
{
    
    id<AchievementsAddEditDelegate>achievementDelegate;
}
@property (strong, nonatomic) NSMutableDictionary *achievementsData;
@property (nonatomic)bool isEdit;
@property (nonatomic)BOOL isNewAchievements;

@property (strong, nonatomic) id achievementDelegate;


@property (nonatomic)BOOL isNewReverseBucket;
@property BOOL isFromListReminder;
@property BOOL isremoveDailyTwiceDaily;


@end
