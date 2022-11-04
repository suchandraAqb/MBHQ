//
//  SectionTabViewController.h
//  Squad
//
//  Created by aqb-mac-mini3 on 06/03/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNutritionPlanListViewController.h"
#import "SectionCollectionViewCell.h"
#import "DailyGoodnessViewController.h"
#import "NutritionSettingHomeViewController.h"
#import "ExerciseDailyListViewController.h"
#import "SessionListViewController.h"
#import "RoundListViewController.h"
#import "TimerViewController.h"
#import "ChalengesHomeViewController.h"
#import "CustomExerciseSettingsViewController.h"
#import "CustomNavigation.h"
#import "MyPhotosCompareViewController.h"
#import "LegendViewController.h"
#import "TrackAllViewController.h"
#import "VitaminViewController.h"
#import "GratitudeListViewController.h"
#import "AchievementsDateViewController.h"
#import "HabitStatsViewController.h"
#import "CommunityViewController.h"
@interface SectionTabViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

-(void)tabFooterNavigation:(UIViewController *)parent section:(NSString *)section frmMenu:(BOOL)frmMenu;
-(void)tabSwipeNavigation:(UIViewController *)parent section:(NSString *)section position:(int)position frmMenu:(BOOL)frmMenu;

@end
