//
//  AddVisionBoardViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 15/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetReminderViewController.h"
#import "DatePickerViewController.h"
#import "PECropViewController.h"
#import "AddVisionEntryViewController.h"
#import "QBImagePickerController.h"

@interface AddVisionBoardViewController : UIViewController<ReminderDelegate, DatePickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PECropViewControllerDelegate, AddVisionEntryDelegate, UICollectionViewDelegate, UICollectionViewDataSource, QBImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource,UITextViewDelegate,ReminderDelegate>
@property (strong, nonatomic) NSMutableDictionary *visionBoardDict;
@property BOOL isFromReminder;

@property (nonatomic) NSInteger picMaxLimit;
@property (nonatomic, strong) SPTAudioStreamingController *sPlayer;

@end
