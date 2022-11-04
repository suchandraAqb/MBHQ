//
//  AppDelegate.h
//  Squad
//
//  Created by AQB SOLUTIONS on 06/12/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Bolts/Bolts.h>

//faf
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Spotify/Spotify.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Reachability.h"
#import <SafariServices/SafariServices.h>
@import Firebase;

@import UserNotifications;  //ah ln

@interface AppDelegate : UIResponder <UIApplicationDelegate, SPTAudioStreamingDelegate, UNUserNotificationCenterDelegate,SFSafariViewControllerDelegate,FIRMessagingDelegate>{
   
}    //ah ln
@property (nonatomic, strong) id  _tokenDelegate;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *token;
@property (nonatomic, copy) void(^backgroundTransferCompletionHandler)();
@property (retain, nonatomic)  Reachability* reachability; // AY 22022018




@property (strong, nonatomic) AVAudioPlayer *mainAudioPlayer;

@property () NSInteger mediaPlayingIndex;
@property (strong, nonatomic) NSMutableArray *indexArray;
@property()BOOL autoRotate;  //ah 21.3
@property (strong, nonatomic) AVPlayer *FBWAudioPlayer;//ah 14.8
@property (strong, nonatomic) AVPlayerViewController *playerController;


@property (strong, nonatomic) NSMutableArray *audioListArray;
@property NSInteger activeIndex;
@property (strong, nonatomic) NSMutableArray *latLongArray;       //ah tr
@property int totalTime;
@property (strong, nonatomic) MPRemoteCommandCenter *commandCenter;
@property (nonatomic) int badge;
@property()BOOL isShowingMenu;;
@property (strong, nonatomic) SFSafariViewController *safariBrowser;
-(void)setUpRemoteControl;
-(void)redirectionForDeeplinkAndChat:(NSString *)redirectTo userInfo:(NSDictionary *)userInfo;
-(void)sendToViewControllerFromLocalNotification:(UIApplication *)application userInfo:(NSDictionary *)userInfo nav:(UINavigationController *)nav isShowAlert:(BOOL)isShowAlert;
+(void)scheduleLocalNotificationsForFreeUser;
+(void)scheduleLocalNotificationsForFreeWorkoutUser;
+(void)scheduleLocalNotificationsForQuote:(BOOL)isInitial;
+(void)sendDeviceToken;
+(void)updateTrialStartDate;
@end
