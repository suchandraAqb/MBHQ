//
//  ExerciseTypeViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 02/01/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "ExerciseDetailsViewController.h"

@protocol ExerciseTypeDelegate <NSObject>
@optional - (void) didCheckAnyChange:(BOOL)ischanged;
@end

@interface ExerciseTypeViewController : UIViewController<ExerciseDetailsDelegate>{
    id<ExerciseTypeDelegate>delegate;
}

@property (nonatomic,strong)id delegate;
@property () int exSessionID;   //ah28
@property (strong, nonatomic) NSString *dateStr;
@property (strong, nonatomic) NSString *sessionTitle;
@property BOOL isPersonalisedSession;
@property (strong, nonatomic) NSString *exerciseSessionType; //AY 23102017

@property (strong, nonatomic) NSArray *dailyWorkoutLists;
@property BOOL isOnlyToday;
@end
