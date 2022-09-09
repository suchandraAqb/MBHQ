//
//  CreateMyHealthyHabitListViewController.h
//  Squad
//
//  Created by MAC 6- AQB SOLUTIONS on 27/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol myHealthyHabitDelegate <NSObject>
@optional - (void) creationCompleted;
@end

@interface CreateMyHealthyHabitListViewController : UIViewController{
    id<myHealthyHabitDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
@end
