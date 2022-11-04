//
//  PersonalChallengeAddEditViewController.h
//  Squad
//
//  Created by aqb-mac-mini3 on 17/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"
#import "DropdownViewController.h"
#import "SetReminderViewController.h"
#import "CalendarPopUpViewController.h"

@protocol PersonalChallengeAddEditDelegate<NSObject>
@optional - (void)didChangePersonalChallengeAddEdit:(BOOL)ischanged;
@end
@interface PersonalChallengeAddEditViewController : UIViewController<DatePickerViewControllerDelegate,DropdownViewDelegate,ReminderDelegate,CalendarPopUpDelegate>{
    id<PersonalChallengeAddEditDelegate>delegate;
}
@property (strong,nonatomic)id delegate;
@property BOOL isAdd;
@end
