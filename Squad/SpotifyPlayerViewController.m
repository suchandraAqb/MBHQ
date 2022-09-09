//
//  SpotifyPlayerViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 21/12/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "SpotifyPlayerViewController.h"
#import "Config.h"
#import <Spotify/Spotify.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NSString+TimeToString.h"
#import "SettingsViewController.h"

@interface SpotifyPlayerViewController ()<SPTAudioStreamingDelegate,SPTAudioStreamingPlaybackDelegate>{
    IBOutlet UIImageView *imageAlbum;
    IBOutlet UILabel * labelTitle; //Above slider
    IBOutlet UILabel * labelArtist; //Above slider
    IBOutlet UILabel * labelElapsed; //Left of slider
    IBOutlet UILabel * labelDuration; //Below Slider
    IBOutlet UILabel *labelRemaining; // Right of slider
    IBOutlet UISlider *sliderTime;
    IBOutlet UIButton *playPause;
    IBOutlet UIButton *suffle;
    IBOutlet UIButton* nextButton;
    IBOutlet UIButton* prevButton;
    UIView *contentView;
    SettingsViewController *parent;
    ExerciseVideoViewController *parentOfParent;
}

@property (nonatomic) BOOL isChangingProgress;
@end

@implementation SpotifyPlayerViewController

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getNotification:) name:@"spotifyLoginNotification" object:nil];
   
}
-(void)viewWillAppear:(BOOL)animated{
    if (![Utility isEmptyCheck:self.parentViewController.parentViewController] && [self.parentViewController.parentViewController isKindOfClass:[ExerciseVideoViewController class]]) {
        parentOfParent = (ExerciseVideoViewController *)self.parentViewController.parentViewController;
    }
    if (![Utility isEmptyCheck:self.parentViewController] && [self.parentViewController isKindOfClass:[SettingsViewController class]]) {
        parent = (SettingsViewController *)self.parentViewController;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    if (![Utility isEmptyCheck:parentOfParent] && parentOfParent.isWeightSheetButtonPressed) {
        return;
    }
    if (![Utility isEmptyCheck:parent] && parent.keepPlaying) {
        return;
    }
    if (![Utility isEmptyCheck:parent] && parent.circuitPlaying) {
        return;
    }
    [self.player setIsPlaying:NO callback:nil];
    
}
-(void)reloadUI{
    if (![Utility isEmptyCheck:self.parentViewController.parentViewController] && [self.parentViewController.parentViewController isKindOfClass:[ExerciseVideoViewController class]]) {
        parentOfParent = (ExerciseVideoViewController *)self.parentViewController.parentViewController;
    }
    if (![Utility isEmptyCheck:self.parentViewController] && [self.parentViewController isKindOfClass:[SettingsViewController class]]) {
        parent = (SettingsViewController *)self.parentViewController;
    }
    SPTAuth *auth = [SPTAuth defaultInstance];
    if (auth.session != nil) { //AY 29-Dec-2017
        if (auth.session.isValid) {
            [self loginUsingSession:auth.session];
        } else {
            [self login];
        }
    }else {
        [self login];
    }
    
    
    
}
- (void)renewTokenAndShowPlayer
{
    SPTAuth *auth = [SPTAuth defaultInstance];
    [auth renewSession:auth.session callback:^(NSError *error, SPTSession *session) {
        auth.session = session;
        
        if (error) {
            NSLog(@"*** Error renewing session: %@", error);
            return;
        }
        [self loginUsingSession:auth.session];
    }];
}


#pragma mark - Local Notification

-(void)getNotification:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        SPTAuth *auth = [SPTAuth defaultInstance];
        if (auth.session && [auth.session isValid]) {
            [self loginUsingSession:auth.session];
        }else {
            NSLog(@"*** Failed to log in");
        }
    });
}

#pragma mark - End
#pragma mark - Private Method
-(void)loginUsingSession:(SPTSession *)currentSession {
    dispatch_async(dispatch_get_main_queue(), ^{
        SPTAuth *auth = [SPTAuth defaultInstance];
        
        if (self.player == nil) {
            NSError *error = nil;
            NSLog(@"%@\n%@",auth.clientID,auth.session.accessToken);
            if(![Utility isEmptyCheck:auth.clientID] && ![Utility isEmptyCheck:auth.session.accessToken]){
                self.player = [SPTAudioStreamingController sharedInstance];
                self.player.delegate = self;
                self.player.playbackDelegate = self;
                if (!self.player.initialized) {
                    if ([self.player startWithClientId:auth.clientID audioController:nil allowCaching:YES error:&error]) {
                        self.player.diskCache = [[SPTDiskCache alloc] initWithCapacity:1024 * 1024 * 64];
                        [self.player loginWithAccessToken:auth.session.accessToken];
                        
                    }else{
                        self.player = nil;
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error init" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                        [self presentViewController:alert animated:YES completion:nil];
                        [self closeSession];
                    }
                }else{
                    [self initializeSpotify];
                }
            }else{
                [self login];
            }
        }else{
            [self initializeSpotify];
        }
    });
}
-(void)updateUI {
    SPTAuth *auth = [SPTAuth defaultInstance];
    if (self.player.metadata == nil || self.player.metadata.currentTrack == nil) {
        imageAlbum.image = nil;
        return;
    }
    nextButton.enabled = self.player.metadata.nextTrack != nil;
    prevButton.enabled = self.player.metadata.prevTrack != nil;
    labelTitle.text = self.player.metadata.currentTrack.name;
    labelArtist.text = self.player.metadata.currentTrack.artistName;
    [SPTTrack trackWithURI: [NSURL URLWithString:self.player.metadata.currentTrack.uri]
               accessToken:auth.session.accessToken
                    market:nil
                  callback:^(NSError *error, SPTTrack *track) {
                      MPNowPlayingInfoCenter *center  = [MPNowPlayingInfoCenter defaultCenter];
                      NSMutableDictionary *songInfo = [[NSMutableDictionary alloc]initWithDictionary: @{MPMediaItemPropertyTitle: self.player.metadata.currentTrack.name, MPMediaItemPropertyArtist: self.player.metadata.currentTrack.artistName}];
                      NSURL *imageURL = track.album.largestCover.imageURL;
                      if (imageURL == nil) {
                          NSLog(@"Album %@ doesn't have any images!", track.album);
                          //                          self.coverView.image = nil;
                          //                          self.coverView2.image = nil;
                          return;
                      }
                      
                      // Pop over to a background queue to load the image over the network.
                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                          NSError *error = nil;
                          UIImage *image = nil;
                          NSData *imageData = [NSData dataWithContentsOfURL:imageURL options:0 error:&error];
                          
                          if (imageData != nil) {
                              image = [UIImage imageWithData:imageData];
                          }
                          
                          
                          // …and back to the main queue to display the image.
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //                              [self.spinner stopAnimating];
                              //                              self.coverView.image = image;
                              if (image == nil) {
                                  NSLog(@"Couldn't load cover image with error: %@", error);
                                  return;
                              }else{
                                  imageAlbum.image = image; //AY 29-Dec-2017
                                  MPMediaItemArtwork *art = [[MPMediaItemArtwork alloc]initWithBoundsSize:image.size requestHandler:^UIImage * _Nonnull(CGSize size) {
                                      
                                      return image;
                                  }];
                                  if (art) {
                                      songInfo[MPMediaItemPropertyArtwork] = art;
                                  }
                              }
                              center.nowPlayingInfo = songInfo;
                          });
                      });
                      
                  }];
    
}

- (void)closeSession {
    NSError *error = nil;
    if (![self.player stopWithError:&error]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error deinit" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [SPTAuth defaultInstance].session = nil;
    // [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveError:(SpErrorCode)errorCode withName:(NSString*)name {
    NSLog(@"login err %lu ||| name %@",(unsigned long)errorCode,name);
    if(errorCode==SPTErrorCodeNeedsPremium){
        [defaults setBool:NO forKey:@"isSpotifyPremium"];
    }
    
}
-(void)login{
    [[SPTAuth defaultInstance] setClientID:@"e92637672d6f485c9251f43094cad696"];    //ah new1
    [[SPTAuth defaultInstance] setRedirectURL:[NSURL URLWithString:@"squad-app-login://callback"]]; //ah new1
    [[SPTAuth defaultInstance] setRequestedScopes:@[SPTAuthStreamingScope]];
    
    // Construct a login URL and open it
    NSURL *loginURL = [[SPTAuth defaultInstance] loginURL];
    
    // Opening a URL in Safari close to application launch may trigger
    // an iOS bug, so we wait a bit before doing so.
    [[UIApplication sharedApplication] performSelector:@selector(openURL:)
                                            withObject:loginURL afterDelay:0.1];
}
-(void)initializeSpotify{
    if (self.player != nil && ![Utility isEmptyCheck:[defaults objectForKey:@"selectedSpotifyCollectionUri"]]) {
        NSLog(@"Spotify URI:%@",[defaults objectForKey:@"selectedSpotifyCollectionUri"]);
        if (!self.player.playbackState.isPlaying) {
            [self.player playSpotifyURI:[defaults objectForKey:@"selectedSpotifyCollectionUri"] startingWithIndex:0 startingWithPosition:10 callback:^(NSError *error) {
                if (error != nil) {
                    NSLog(@"*** failed to play: %@", error);
                    return;
                }else{
                    [self.player setIsPlaying:NO callback:nil];
                    if (![Utility isEmptyCheck:parent]) {
                        if ([Utility isEmptyCheck:parentOfParent]) {
                            [self play];
                        }else{
                            if(parentOfParent.gameOnView.hidden){
                                [self play];
                            }else{
                                if (parentOfParent.currentPage == 1) {
                                    [parentOfParent changePage:nil];
                                }
                            }
                        }
                    }
                }
            }];
            
        }
        /*else if((![Utility isEmptyCheck:[defaults objectForKey:@"Motivation"]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"off"] == NSOrderedSame) || (![Utility isEmptyCheck:[defaults objectForKey:@"Inbetween Rounds"]] && [[defaults objectForKey:@"Inbetween Rounds"] caseInsensitiveCompare:@"STOPS PLAYING"] == NSOrderedSame)){
            [self.player setIsPlaying:NO callback:nil];
        }*/
    }
}
-(void)play{
    if([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame && [[defaults objectForKey:@"Inbetween Rounds"] caseInsensitiveCompare:@"STOPS PLAYING"] != NSOrderedSame){
        [self.player setIsPlaying:YES callback:nil];
    }else{
        [self.player setIsPlaying:NO callback:nil];
    }
    playPause.selected = !self.player.playbackState.isPlaying; //AY 29-Dec-2017
    if (self.player.playbackState.isPlaying) {
        [self activateAudioSession];
    }
}
#pragma mark - End
#pragma mark - Track Player Delegates

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message from Spotify" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePlaybackStatus:(BOOL)isPlaying {
    //NSLog(@"is playing = %d", isPlaying);
    playPause.selected =!self.player.playbackState.isPlaying;
    if (isPlaying) {
        [self activateAudioSession];
    } else {
        [self deactivateAudioSession];
    }
}

-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeMetadata:(SPTPlaybackMetadata *)metadata {
    [self updateUI];
}

-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceivePlaybackEvent:(SpPlaybackEvent)event withName:(NSString *)name {
    //NSLog(@"didReceivePlaybackEvent: %zd %@", event, name);
//    NSLog(@"isPlaying=%d isRepeating=%d isShuffling=%d isActiveDevice=%d positionMs=%f",
//          self.player.playbackState.isPlaying,
//          self.player.playbackState.isRepeating,
//          self.player.playbackState.isShuffling,
//          self.player.playbackState.isActiveDevice,
//          self.player.playbackState.position);
}

- (void)audioStreamingDidLogout:(SPTAudioStreamingController *)audioStreaming {
    //[self closeSession]; //AY 29-Dec-2017
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveError:(NSError* )error {
    //NSLog(@"didReceiveError: %zd %@", error.code, error.localizedDescription);
    
    if (error.code == SPErrorNeedsPremium) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Premium account required" message:@"Premium account is required to showcase application functionality. Please login using premium account." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            [self closeSession];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePosition:(NSTimeInterval)position {
    if (self.isChangingProgress) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        sliderTime.value = position/self.player.metadata.currentTrack.duration;
        labelElapsed.text = [NSString stringFromTime:position];
        labelRemaining.text = [NSString stringFromTime:self.player.metadata.currentTrack.duration - position];
    });
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didStartPlayingTrack:(NSString *)trackUri {
    //NSLog(@"Starting %@", trackUri);
    //NSLog(@"Source %@", self.player.metadata.currentTrack.playbackSourceUri);
    // If context is a single track and the uri of the actual track being played is different
    // than we can assume that relink has happended.
//    [self stopMusic];
    BOOL isRelinked = [self.player.metadata.currentTrack.playbackSourceUri containsString: @"spotify:track"]
    && ![self.player.metadata.currentTrack.playbackSourceUri isEqualToString:trackUri];
    NSLog(@"Relinked %d", isRelinked);
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didStopPlayingTrack:(NSString *)trackUri {
    NSLog(@"Finishing: %@", trackUri);
}

- (void)audioStreamingDidLogin:(SPTAudioStreamingController *)audioStreaming {
    [self updateUI];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initializeSpotify];
    });
    
    [defaults setBool:YES forKey:@"isSpotifyPremium"];
}
- (void)audioStreamingDidSkipToNextTrack:(SPTAudioStreamingController *)audioStreaming{
  
}
-(void)audioStreamingDidDisconnect:(SPTAudioStreamingController *)audioStreaming{
    NSLog(@"audioStreamingDidDisconnect: %d", self.player.playbackState.isPlaying);
}

/** Called when network connectivitiy is back after being lost.
 @param audioStreaming The object that sent the message.
 */
-(void)audioStreamingDidReconnect:(SPTAudioStreamingController *)audioStreaming{
    NSLog(@"audioStreamingDidReconnect: %d", self.player.playbackState.isPlaying);
}
-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeShuffleStatus:(BOOL)isShuffled{
    
}
-(void)stopMusic{
    if (![Utility isEmptyCheck:[defaults objectForKey:@"mediaItemCollection"]] && [MPMusicPlayerController systemMusicPlayer].currentPlaybackRate == 1) {
        [[MPMusicPlayerController systemMusicPlayer] pause];
    }else if(![Utility isEmptyCheck:[defaults objectForKey:@"selectedSpotifyCollectionUri"]] && [[SPTAudioStreamingController sharedInstance] initialized] && [SPTAudioStreamingController sharedInstance].playbackState.isPlaying){
        [[SPTAudioStreamingController sharedInstance] setIsPlaying:NO callback:nil];
    }
}
#pragma mark - Audio Session

- (void)activateAudioSession{
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    @try {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord  withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionAllowBluetoothA2DP error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self becomeFirstResponder];
    }
    @catch (NSException *exception) {
        NSLog(@"Something error...");
    }
}

- (void)deactivateAudioSession
{
   // [self.player setIsPlaying:NO callback:nil];
    //[[AVAudioSession sharedInstance] setActive:NO error:nil];
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    NSLog(@"received event!");
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause: {
                [self playPause:nil];
                break;
            }
            case UIEventSubtypeRemoteControlPlay: {
                [self playPause:nil];
                break;
            }
            case UIEventSubtypeRemoteControlPause: {
                [self playPause:nil];
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack: {
                [self rewind:prevButton];
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack: {
                [self fastForward:nextButton];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - Actions
-(IBAction)suffleButtonPressed:(id)sender {
    
}
-(IBAction)rewind:(id)sender {
    [self.player skipPrevious:nil];
}

-(IBAction)playPause:(id)sender {
    [self.player setIsPlaying:!self.player.playbackState.isPlaying callback:nil];
    //playPause.selected = !self.player.playbackState.isPlaying; //AY 29-Dec-2017
}

-(IBAction)fastForward:(id)sender {
    [self.player skipNext:nil];
}

- (IBAction)seekValueChanged:(id)sender {
    self.isChangingProgress = NO;
    NSUInteger dest = self.player.metadata.currentTrack.duration * sliderTime.value;
    [self.player seekTo:dest callback:nil];
}

- (IBAction)logoutClicked:(id)sender {
    if (self.player) {
        [self.player logout];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)proggressTouchDown:(id)sender {
    self.isChangingProgress = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
