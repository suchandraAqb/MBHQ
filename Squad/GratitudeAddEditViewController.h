//
//  GratitudeAddEditViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 14/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "MasterMenuViewController.h"
#import "SetReminderViewController.h"
#import "PECropViewController.h"
#import "ProgressBarViewController.h"
#import "NotesViewController.h"
#import "DatePickerViewController.h"
@protocol GratitudeAddEditDelegate<NSObject>
@optional - (void)didGratitudeBackAction:(BOOL)ischanged;
@end
@interface GratitudeAddEditViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,ReminderDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, PECropViewControllerDelegate,progressViewDelegate,NotesViewDeleagte>{
    
    id<GratitudeAddEditDelegate>gratitudeDelegate;
}
@property (strong, nonatomic) NSMutableDictionary *gratitudeData;
@property (nonatomic)bool isEdit;
@property (nonatomic)BOOL isNewGratitude; //gami_badge_popup
@property (strong, nonatomic) id gratitudeDelegate;
@property (strong,nonatomic) NSString *selectGrowth;
@property BOOL isFromListReminder;

@end
