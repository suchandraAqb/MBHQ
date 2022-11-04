//
//  PodcastViewController.h
//  The Life
//
//  Created by AQB Mac 4 on 20/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
@interface PodcastViewController : UIViewController<UINavigationControllerDelegate,UIWebViewDelegate>
@property (nonatomic,strong) NSString * urlString;

@end
