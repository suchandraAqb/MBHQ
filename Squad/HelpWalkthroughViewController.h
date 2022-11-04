//
//  HelpWalkthroughViewController.h
//  Squad
//
//  Created by Admin on 09/09/20.
//  Copyright © 2020 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelpWalkthroughViewController : UIViewController<UINavigationControllerDelegate>
@property (nonatomic,strong) NSURL * url;
@property (strong,nonatomic) UIViewController *parent;

@end

NS_ASSUME_NONNULL_END
