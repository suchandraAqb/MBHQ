//
//  ChatDetailsVideoViewController.m
//
//  Created by Dhiman on 22/12/20.
//  Copyright © 2020 Dhiman. All rights reserved.
//

#import "ChatDetailsVideoViewController.h"

@interface ChatDetailsVideoViewController ()
{
    IBOutlet UIView *exerciseplayerView;
    IBOutlet UILabel *videoTitleLabel;
    IBOutlet UILabel *videoAuthorLabel;
    AVPlayer *player;
    AppDelegate *appDelegate;
    NSURLSessionDownloadTask *eventDownloadTask;
    UIView *contentView;
}
@end

@implementation ChatDetailsVideoViewController
@synthesize playerController,videoTime;
#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
       appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
       NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.BalanceVideoDetails"];
    
       sessionConfiguration.allowsCellularAccess = YES;
       self.session1 = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                    delegate:self
                                               delegateQueue:nil];
//       [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//       [self becomeFirstResponder];
         [self setUpView];
}
-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:YES];
        NSError *sessionError = nil;
        @try {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord  withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionAllowBluetoothA2DP error:&sessionError];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            
        } @catch (NSException *exception) {
            NSLog(@"Audio Session error %@, %@", exception.reason, exception.userInfo);
            
        } @finally {
            NSLog(@"Audio Session finally");
        }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (appDelegate.FBWAudioPlayer.rate>0) {
        NSError *error;
           NSData *postData = [NSJSONSerialization dataWithJSONObject:_videoDict options:NSJSONWritingPrettyPrinted  error:&error];
           if (error) {
               [appDelegate.FBWAudioPlayer pause];
               NSLog(@"Error -- %@",error.debugDescription);
               return;
           }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        [defaults setObject:jsonString forKey:@"PlayingLiveChatDict"];
        [defaults setBool:true forKey:@"IsPlayingLiveChat"];
    }else{
        if (![Utility isEmptyCheck:[defaults objectForKey:@"PlayingLiveChatDict"]]) {
            [defaults removeObjectForKey:@"PlayingLiveChatDict"];
        }
        if ([defaults boolForKey:@"IsPlayingLiveChat"]) {
            [defaults setBool:NO forKey:@"IsPlayingLiveChat"];
        }
    }
}
#pragma mark - End

#pragma mark - IBAction
-(IBAction)closeButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - End

#pragma mark - Private Function
-(void)setUpView{
    if (![Utility isEmptyCheck:_videoDict]) {
        if (![Utility isEmptyCheck:[_videoDict objectForKey:@"EventName"]]) {
            videoTitleLabel.text = [_videoDict objectForKey:@"EventName"];
        }
        if (![Utility isEmptyCheck:[_videoDict objectForKey:@"PresenterName"]]) {
            videoAuthorLabel.text = [_videoDict objectForKey:@"PresenterName"];
        }
    }
    BOOL isFromBackGround = false;
    if (![Utility isEmptyCheck:[defaults objectForKey:@"IsPlayingLiveChat"]] && [[defaults objectForKey:@"IsPlayingLiveChat"] boolValue]) {
                  NSString *webinarstr=[defaults objectForKey:@"PlayingLiveChatDict"];
                  NSData *data = [webinarstr dataUsingEncoding:NSUTF8StringEncoding];
                  NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                  if ([dict isEqualToDictionary:_videoDict]) {
                      isFromBackGround = true;
                }
   }
    NSDictionary *videoDict=[[_videoDict objectForKey:@"EventItemVideoDetails"] objectAtIndex:0];
    if (![Utility isEmptyCheck:videoDict]) {
        NSString * videoString = [[videoDict objectForKey:@"DownloadURL"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSURL *videoURL = [NSURL URLWithString:videoString];
        appDelegate.playerController = [[AVPlayerViewController alloc]init];
        appDelegate.FBWAudioPlayer = nil;
        appDelegate.FBWAudioPlayer =  [[AVPlayer alloc] initWithURL:videoURL];
        appDelegate.playerController.player = appDelegate.FBWAudioPlayer;
        appDelegate.playerController.showsPlaybackControls = true;
        appDelegate.FBWAudioPlayer.muted = false;
        if (CMTimeGetSeconds(videoTime)>0 && isFromBackGround) {
                [self->appDelegate.playerController.player seekToTime:videoTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                  [self->appDelegate.playerController.player play];
              }];
           }
        [appDelegate.FBWAudioPlayer play];
        NSLog(@"%@",appDelegate.FBWAudioPlayer);
        // show the view controller
        [self addChildViewController:appDelegate.playerController];
        [exerciseplayerView addSubview:appDelegate.playerController.view];
        appDelegate.playerController.view.frame = exerciseplayerView.bounds;
        
        /*NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[videoURL lastPathComponent]];
        NSLog(@"fullPathToFile=%@",fullPathToFile);

        if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
               videoURL = [NSURL fileURLWithPath:fullPathToFile];
               appDelegate.playerController = [[AVPlayerViewController alloc]init];
               appDelegate.FBWAudioPlayer = nil;
               appDelegate.FBWAudioPlayer =  [[AVPlayer alloc] initWithURL:videoURL];
               appDelegate.playerController.player = appDelegate.FBWAudioPlayer;
               appDelegate.playerController.showsPlaybackControls = true;
               [appDelegate.FBWAudioPlayer play];
               NSLog(@"%@",appDelegate.FBWAudioPlayer);
               // show the view controller
               [self addChildViewController:appDelegate.playerController];
               [exerciseplayerView addSubview:appDelegate.playerController.view];
               appDelegate.playerController.view.frame = exerciseplayerView.bounds;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
                self->contentView = [Utility activityIndicatorView:self];
            });

            [self download:_videoDict sender:nil];
            
        }*/
       
    }
}
-(void)download:(NSDictionary *)webinarsData sender:(UIButton *)sender{
    NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinarsData valueForKey:@"EventItemVideoDetails"]];
    if (eventItemVideoDetailsArray.count > 0) {
        NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
        if (![Utility isEmptyCheck:eventItemVideoDetails]) {
            if (![Utility isEmptyCheck:[eventItemVideoDetails objectForKey:@"DownloadURL" ]]) {
                NSURL *video_url = [NSURL URLWithString:[eventItemVideoDetails objectForKey:@"DownloadURL" ]];
                
                if([video_url absoluteString].length < 1) {
                    return;
                }
                NSLog(@"source will be : %@", video_url.absoluteString);
                NSURL *sourceURL = video_url;
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];
                NSLog(@"fullPathToFile=%@",fullPathToFile);

                if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                
                  if (appDelegate.FBWAudioPlayer) {
                    // create a player view controller
                    appDelegate.playerController = [[AVPlayerViewController alloc]init];
                    appDelegate.playerController.player = appDelegate.FBWAudioPlayer;
                    appDelegate.playerController.showsPlaybackControls = false;
                    [appDelegate.FBWAudioPlayer play];
                    // show the view controller
                    [self addChildViewController:appDelegate.playerController];
                    [exerciseplayerView addSubview:appDelegate.playerController.view];
                    appDelegate.playerController.view.frame = exerciseplayerView.bounds;
                    return;
                    }
                }
                if(Utility.reachable){
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        sender.enabled = false;
                        self->eventDownloadTask = [self.session1 downloadTaskWithURL:sourceURL];
                        [self->eventDownloadTask resume];
                        
                        
                }];
                }else{
                   // [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
                    }
                }
            }
    }
}

#pragma mark - NSURLSession Delegate method implementation

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *destinationFilename = downloadTask.originalRequest.URL.lastPathComponent;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:destinationFilename];
    NSURL *destinationURL = [NSURL fileURLWithPath:fullPathToFile];
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]) {
        [fileManager removeItemAtURL:destinationURL error:nil];
    }
    
    BOOL success = [fileManager copyItemAtURL:location
                                        toURL:destinationURL
                                        error:&error];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if ([downloadTask isEqual:self->eventDownloadTask]) {
            
              if (success) {
                   if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                       NSLog(@"Download SuccessFully");
                       if (self->contentView) {
                              [self->contentView removeFromSuperview];
                            }
                               [self setUpView];
                            }
                        }
                    }
               }];
    }

#pragma mark - End


@end
