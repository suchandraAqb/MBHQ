//
//  VitaminViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 07/03/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
#import "VitaminEditViewController.h"
#import "AddVitaminViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface VitaminViewController : UIViewController<JTCalendarDelegate,vitaminEditViewDelegate,AddVitaminViewDelegate>

@end

NS_ASSUME_NONNULL_END
