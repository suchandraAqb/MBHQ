//
//  WebinarSelectedViewController.h
//  The Life
//
//  Created by AQB SOLUTIONS on 07/04/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MasterMenuViewController.h"
#import "Utility.h"

@interface WebinarSelectedViewController : UIViewController<NSURLSessionDelegate,AVPlayerViewControllerDelegate,AVAudioPlayerDelegate,DropdownViewDelegate>

@property (strong, nonatomic)NSMutableDictionary *webinar;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray* buttons;
@property (strong, nonatomic)NSDictionary *upcomingWebinarsData;
@property (nonatomic)BOOL isFromWatchList;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSession *session1;
@property (nonatomic, strong) NSURLSession *session2;

@property (strong, nonatomic) AudioVisualizer *audioVisualizer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic)BOOL isShowFavAlert;
@property BOOL isShowShopping;
@property NSString *shopUrl;


@end
