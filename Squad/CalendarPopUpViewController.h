//
//  CalendarPopUpViewController.h
//  Squad
//
//  Created by aqb-mac-mini3 on 18/08/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"

@protocol CalendarPopUpDelegate<NSObject>
@optional - (void)didSelectDateInPopUp:(NSDate *)date;
@optional - (void)cancelInPopUp;
@end
@interface CalendarPopUpViewController : UIViewController<JTCalendarDelegate>{
    id<CalendarPopUpDelegate>delegate;
}
@property (strong,nonatomic)id delegate;
@property (strong,nonatomic) NSDate *selectedDate;
@property (strong,nonatomic) NSString *fromController;


@end
