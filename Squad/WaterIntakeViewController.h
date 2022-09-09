//
//  WaterIntakeViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 20/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "Utility.h"
#import "MasterMenuViewController.h"

@interface WaterIntakeViewController : UIViewController <FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance>

@property (weak  , nonatomic) IBOutlet FSCalendar *calendar;
@property (strong, nonatomic) NSDictionary<NSString *, UIImage *> *images;

@end
