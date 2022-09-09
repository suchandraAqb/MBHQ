//
//  VideoViewController.h
//  The Life
//
//  Created by AQB Mac 4 on 13/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "Utility.h"

@interface VideoViewController : UIViewController<YTPlayerViewDelegate>
@property(nonatomic,strong) NSString *videoId;
@property(nonatomic,strong) IBOutlet YTPlayerView *playerView;


@end
