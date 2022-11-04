//
//  LearnNotificationViewController.h
//  Squad
//
//  Created by Amit Yadav on 24/10/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LearnNotificationViewController : UIViewController

@property (strong, nonatomic)  UIViewController *fromContoller;
@property (assign)  BOOL isSeminar;
@property (assign)  BOOL isMessage;
@property (nonatomic,strong) NSString *courseName;

@end

NS_ASSUME_NONNULL_END
