//
//  GratitudeListViewController.h
//  Squad
//
//  Created by Rupbani Mukherjee on 04/06/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface GratitudeListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, GratitudeAddEditDelegate,NotesViewDeleagte>
@property (strong, nonatomic) NSArray *filterArray;
@property BOOL isFromToday;
@property (strong,nonatomic) NSDate *todaySelectDate;
@property BOOL isFromGratitudeList;
@property BOOL isMoveToday;
@end

NS_ASSUME_NONNULL_END
