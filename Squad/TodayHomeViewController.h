//
//  TodayHomeViewController.h
//  Squad
//
//  Created by aqb-mac-mini3 on 21/08/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>
#import "JTCalendar.h"
#import "AddImageViewController.h"
#import "SquadInfoViewController.h"
#import "TodayMealView.h"
#import "NotesViewController.h"
@interface TodayHomeViewController : UIViewController<UICollectionViewDelegate,JTCalendarDelegate,NotesViewDeleagte>
@property BOOL isFromHabit;
@property BOOL isMoveToday;
@end
