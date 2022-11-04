//
//  PersonalChallengeViewController.h
//  Squad
//
//  Created by aqb-mac-mini3 on 12/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetReminderViewController.h"
#import "PersonalChallengeAddEditViewController.h"
#import "PersonalChallengeDetailsViewController.h"

@interface PersonalChallengeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ReminderDelegate,PersonalChallengeAddEditDelegate,PersonalChallengeDetailsDelegate>

@end
