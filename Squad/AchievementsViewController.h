//
//  AchievementsViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 16/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "AchievementsAddEditViewController.h"
#import "NotesViewController.h"
@interface AchievementsViewController : UIViewController<AchievementsAddEditDelegate,NotesViewDeleagte>
@property (strong, nonatomic) NSArray *goalValueArray;
@property BOOL isFromToday;
@property (strong,nonatomic) NSDate *todaySelectDate;
@property BOOL isFromGrowthList;
@property BOOL isMoveToday;
@end
