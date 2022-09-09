//
//  BucketListNewAddEditViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 17/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "MasterMenuViewController.h"
#import "SetReminderViewController.h"
#import "PECropViewController.h"
#import "DropdownViewController.h"
#import "DatePickerViewController.h"
#import "ProgressBarViewController.h"
@interface BucketListNewAddEditViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,ReminderDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, PECropViewControllerDelegate,DropdownViewDelegate,DatePickerViewControllerDelegate,progressViewDelegate>
@property (strong, nonatomic) NSMutableDictionary *bucketData;
@property (nonatomic)bool isEdit;
@property (nonatomic)bool isNewBucket; //gami_badge_popup
@property BOOL isFromNotificaton;
@property BOOL isFromListReminder;
@property BOOL isremoveDailyTwiceDaily;
@end

