//
//  HelpVideoPlayerViewController.h
//  Squad
//
//  Created by MAC 6- AQB SOLUTIONS on 12/06/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@protocol  HelpVideoPlayerViewDelegate <NSObject>
@optional - (void)controllerDismissed;
@end
@interface HelpVideoPlayerViewController : UIViewController{
     id<HelpVideoPlayerViewDelegate>delegate;
}

@property (nonatomic,strong)id delegate;
@property (strong, nonatomic) NSString *videoURLString;
@property BOOL isFromMessage;
@end
