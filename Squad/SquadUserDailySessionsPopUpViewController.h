//
//  SquadUserDailySessionsPopUpViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 17/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SquadUserDailySessionsPopUpViewControllerDelegate <NSObject>

@optional - (void) didChooseOption:(int)index sessionDate:(NSDate *)sessionDate;

@end
@interface SquadUserDailySessionsPopUpViewController : UIViewController{
    id<SquadUserDailySessionsPopUpViewControllerDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
@property (strong, nonatomic)  NSDate *sessionDate;
@end



