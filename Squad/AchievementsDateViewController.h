//
//  AchievementsDateViewController.h
//  Squad
//
//  Created by Rupbani Mukherjee on 04/09/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AchievementsAddEditViewController.h"
#import "NotesViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AchievementsDateViewController : UIViewController<ExerciseDetailsDelegate, AchievementsAddEditDelegate,NotesViewDeleagte>{
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

NS_ASSUME_NONNULL_END
