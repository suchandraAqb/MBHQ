//
//  BuddyRequestViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 27/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BuddyRequestViewDelegate <NSObject>
@optional - (void)didDismiss;


@end

@interface BuddyRequestViewController : UIViewController{
    id<BuddyRequestViewDelegate>delegate;
}
@property (strong, nonatomic)  NSArray *requestArray;
@property (nonatomic,strong)id delegate;

@end
