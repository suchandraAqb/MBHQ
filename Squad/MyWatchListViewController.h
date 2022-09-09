//
//  MyWatchListViewController.h
//  The Life
//
//  Created by AQB Mac 4 on 09/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "Utility.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "FilterViewController.h"

@interface MyWatchListViewController : UIViewController<FilterViewDelegate,NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *session;

@end
