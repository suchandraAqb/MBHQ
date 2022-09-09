//
//  WaterTrackerDetailsViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 26/02/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <math.h>
@protocol WaterTrackerDetailsDelegate<NSObject>
-(void)dataReload:(NSDate *)currentDate;
@end
NS_ASSUME_NONNULL_BEGIN

@interface WaterTrackerDetailsViewController : UIViewController{
    id<WaterTrackerDetailsDelegate>delegate;
}
@property (strong,nonatomic) id delegate;
@property (strong,nonatomic) NSDictionary *trackDict;
@end

NS_ASSUME_NONNULL_END
