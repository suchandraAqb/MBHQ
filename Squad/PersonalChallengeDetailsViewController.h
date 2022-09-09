//
//  PersonalChallengeDetailsViewController.h
//  Squad
//
//  Created by aqb-mac-mini3 on 17/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"

@protocol PersonalChallengeDetailsDelegate<NSObject>
@optional - (void)didChangePersonalChallengeDetails:(BOOL)ischanged;
@end

@interface PersonalChallengeDetailsViewController : UIViewController<JTCalendarDelegate,UITableViewDelegate,UITableViewDataSource>{
    id<PersonalChallengeDetailsDelegate>delegate;
}
@property (strong,nonatomic)id delegate;
@property (strong,nonatomic) NSNumber *habitId;
@property (strong,nonatomic) NSNumber *taskId;
@end
