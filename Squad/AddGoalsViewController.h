//
//  AddGoalsViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 07/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetReminderViewController.h"
#import "DatePickerViewController.h"
#import "PECropViewController.h"
#import "ProgressBarViewController.h"
#import "SpotifyPlaylistViewController.h"
#import "SongPlayListViewController.h"
#import "NotesViewController.h"

//ah ac1 add PE
@interface AddGoalsViewController : UIViewController<ReminderDelegate, DatePickerViewControllerDelegate, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, PECropViewControllerDelegate,progressViewDelegate,UITableViewDelegate,UITableViewDataSource,SpotifyPlaylistDelegate,PlayListViewDelegate,NotesViewDeleagte>
@property (strong, nonatomic) NSMutableDictionary *selectedGoalDict;
@property (strong, nonatomic) NSArray *valuesArray;
@property BOOL setNewGoal; //gami_badge_popup

@property BOOL editMode;
@property (strong, nonatomic) NSString *goalName;
@property (strong, nonatomic) NSDictionary *buddyDict;
@property (nonatomic, strong) SPTAudioStreamingController *sPlayer;
@end
