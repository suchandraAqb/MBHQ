//
//  HabitHackerDetailNewViewController.h
//  Squad
//
//  Created by Admin on 30/12/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol HabitDetailsDelegate <NSObject>
@optional -(void)reloadUpdatedData:(NSDictionary *)habitDictionary;
@optional -(void)setHAbitDetailsDictionary:(NSDictionary *)habitDictionary;
@end


@interface HabitHackerDetailNewViewController : UIViewController{
    id<HabitDetailsDelegate>habitDetailDelegate;
}

@property (strong,nonatomic) id habitDetailDelegate;

@property (strong,nonatomic) NSDictionary *habitDictFromStat;
@property (strong,nonatomic) NSString *habitId;
@property BOOL isEditMode;
@property BOOL isFromHabitList;
@property BOOL isFromNotification;
@end

NS_ASSUME_NONNULL_END
