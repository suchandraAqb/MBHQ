//
//  HabitHackerListViewController.h
//  Squad
//
//  Created by Suchandra Bhattacharya on 03/12/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HabitHackerDetailsViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface HabitHackerListViewController : UIViewController<HackerDetailsDelegate,DropdownViewDelegate>
@property BOOL isHabitFirstViewOpen;
@property BOOL isFromhelpSectionshowME;
@property BOOL isFromhelpSectionCreate;
@property (strong,nonatomic) NSArray *ActiveHabitArray;
@end

NS_ASSUME_NONNULL_END
