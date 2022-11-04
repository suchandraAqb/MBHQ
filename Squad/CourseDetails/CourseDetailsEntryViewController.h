//
//  CourseDetailsEntryViewController.h
//  Squad
//
//  Created by Admin on 28/07/20.
//  Copyright © 2020 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseDetailsEntryViewController : UIViewController

@property (strong, nonatomic)  NSDictionary *courseData;
@property (strong,nonatomic) UIViewController *originVC;

@end

NS_ASSUME_NONNULL_END


