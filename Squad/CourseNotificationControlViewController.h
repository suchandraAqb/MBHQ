//
//  CourseNotificationControlViewController.h
//  Squad
//
//  Created by Admin on 20/01/20.
//  Copyright © 2020 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol courseNotificationDelegate <NSObject>
@optional -(void)resetCourseData:(NSMutableDictionary *)courseDetailsDict isBack:(BOOL)isBack;
@end

@interface CourseNotificationControlViewController : UIViewController{
    id<courseNotificationDelegate>course_notification_delegate;
}

@property (strong,nonatomic) id course_notification_delegate;
@property (strong,nonatomic) NSMutableDictionary *courseDetailsDict;
@property (assign,nonatomic) BOOL messageNotification;
@property (assign,nonatomic) BOOL seminarNotification;

@end

NS_ASSUME_NONNULL_END
