//
//  GratitudeViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 10/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "GratitudeAddEditViewController.h"
#import "NotesViewController.h"

@interface GratitudeViewController: UIViewController<ExerciseDetailsDelegate, GratitudeAddEditDelegate,NotesViewDeleagte>{
    id<ExerciseTypeDelegate>delegate;
}
@property (strong, nonatomic) NSArray *goalValueArray;
@property (strong, nonatomic) NSArray *dailyWorkoutLists;

@property BOOL isOnlyToday;
@property () int exSessionID;
@property (strong, nonatomic) NSString *dateStr;
@property (strong, nonatomic) NSString *sessionTitle;
@property BOOL isPersonalisedSession;
@property (strong, nonatomic) NSString *exerciseSessionType;
@property BOOL loadForSelected;
@property (strong,nonatomic)id delegate;

@end
