//
//  HealthyHabitBuilderViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 05/09/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "DatePickerViewController.h"
@interface HealthyHabitBuilderViewController : UIViewController<DatePickerViewControllerDelegate>
@property (strong, nonatomic) NSNumber *friendId;
@property (strong, nonatomic) NSNumber *friendName;
@property (strong, nonatomic) NSString *friendEmail;


//ah 5.9 (storyboard && main)
@end
