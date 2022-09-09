//
//  AudioBookViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 04/08/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AudioBookViewController.h"
#import "AudioBookTableViewCell.h"
#import "AppDelegate.h"


@interface AudioBookViewController (){
    IBOutlet UIWebView *soundCloudWebView;
    IBOutlet UIButton *webBack;
    IBOutlet UIButton *webForward;
    IBOutlet UIView *webButtonContainer;
    //    IBOutlet UITableView *audioListTable;
    IBOutlet UIView *waveformView;
    IBOutlet UISlider *progressBar;
    IBOutlet UILabel *totalTimeLabel;
    IBOutlet UILabel *currentTimeLabel;
    IBOutlet UIActivityIndicatorView *activity;
    
    UIView *contentView;
    AppDelegate *appDelegate;
    
    __weak IBOutlet UIView *loadingView;
    __weak IBOutlet UIImageView *animationImageView;
}

@end

@implementation AudioBookViewController
//ah 31.8

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loadingView.hidden = true;
    
    animationImageView.image = [UIImage animatedImageNamed:@"animation-" duration:1.0f];
    
    /*contentView = [Utility activityIndicatorView:self];
     NSString *htmlPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sound_cloud_widget.html"]; //sound_cloud_widget.html
     
     NSString *html = [NSString stringWithContentsOfFile:htmlPath
     encoding:NSUTF8StringEncoding
     error:nil];
     soundCloudWebView.scrollView.scrollEnabled = NO;
     soundCloudWebView.scrollView.bounces = NO;
     
     [soundCloudWebView loadHTMLString:html
     baseURL:[NSURL fileURLWithPath:
     [NSString stringWithFormat:@"%@/HTML_Files/",
     [[NSBundle mainBundle] bundlePath]]]];
     soundCloudWebView.mediaPlaybackRequiresUserAction = NO;
     //    NSString *soundCloudStringUrl =@"https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/342835604%3Fsecret_token%3Ds-hI5A9";
     //    NSString* urlParam =[soundCloudStringUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
     //    NSURL* url = [NSURL URLWithString:soundCloudStringUrl];
     //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
     //    [soundCloudWebView loadRequest:request];*/
    
    
    //    NSString *trackID = @"336192073";
    //    NSString *clientID = @"82649c2cccfd457641a40c7e952c1ce8";
    self.audioListTable.estimatedRowHeight = 60;
    self.audioListTable.rowHeight = UITableViewAutomaticDimension;
    
    [progressBar setMinimumTrackTintColor:[UIColor colorWithRed:(126/255.0) green:(200/255.0) blue:(222/255.0) alpha:1]];
    [progressBar setMaximumTrackTintColor:[UIColor colorWithRed:(209/255.0) green:(209/255.0) blue:(209/255.0) alpha:1]];
    UIImage *thumbImage = [UIImage imageNamed:@"vol_cir.png"];
    [progressBar setThumbImage:thumbImage forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[appDelegate.FBWAudioPlayer currentItem]];
    

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
    if(appDelegate.playerController){
        appDelegate.playerController.player = nil;
        appDelegate.playerController=nil;
        appDelegate.FBWAudioPlayer=nil;
    }
    if ([Utility isEmptyCheck:appDelegate.audioListArray]) {
        [self getEventDetailsByType];
    }
    
    if (appDelegate.FBWAudioPlayer != nil) {
        [activity stopAnimating];
        activity.hidden = true;
        progressBar.hidden = false;
    }
    
    if (appDelegate.FBWAudioPlayer.rate != 0 && appDelegate.FBWAudioPlayer.error == nil) {
        [activity stopAnimating];
        activity.hidden = true;
        progressBar.hidden = false;
        
        double interval = .1f;
        
        CMTime playerDuration = appDelegate.FBWAudioPlayer.currentItem.duration; // return player duration.
        if (CMTIME_IS_INVALID(playerDuration))
        {
            return;
        }
        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration))
        {
            CGFloat width = CGRectGetWidth([progressBar bounds]);
            interval = 0.5f * duration / width;
        }
        __weak typeof(self) weakSelf = self;
        /* Update the scrubber during normal playback. */
        if (interval > 0) {
            [appDelegate.FBWAudioPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                                     queue:NULL
                                                                usingBlock:
             ^(CMTime time)
             {
                 //NSLog(@"int %f",interval);
                 [weakSelf syncScrubber];
             }];
        }
    }else if (![Utility isEmptyCheck:appDelegate.audioListArray] && appDelegate.activeIndex < appDelegate.audioListArray.count) { //appDelegate.FBWAudioPlayer== nil &&
        [self playAudioWithUrl:[[appDelegate.audioListArray objectAtIndex:appDelegate.activeIndex] objectForKey:@"audioUrl"]];
    }
    
}



- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}
-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
//    [appDelegate.FBWAudioPlayer pause]; //AY 16042018
//    appDelegate.FBWAudioPlayer = nil; //AY 16042018
}
#pragma mark - Web View Delegate
- (IBAction)forwardButtonPressed:(UIButton *)sender {
    [soundCloudWebView goForward];
    //webBack.hidden = !soundCloudWebView.canGoBack;
    //webForward.hidden = !soundCloudWebView.canGoForward;
    
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [soundCloudWebView goBack];
    //webBack.hidden = !soundCloudWebView.canGoBack;
    //webForward.hidden = !soundCloudWebView.canGoForward;
}


- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [webView sizeToFit];
    //webBack.hidden = !soundCloudWebView.canGoBack;
    // webForward.hidden = !soundCloudWebView.canGoForward;
    [contentView removeFromSuperview];
}
#pragma mark - End
#pragma mark - IBAction
-(IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)playPauseButtonTapped:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setSelected:NO];
        [appDelegate.FBWAudioPlayer pause];
    } else {
        [sender setSelected:YES];
        if (appDelegate.activeIndex == sender.tag)
            [appDelegate.FBWAudioPlayer play];
        else {
            appDelegate.activeIndex = sender.tag;
            [self playAudioWithUrl:[[appDelegate.audioListArray objectAtIndex:sender.tag] objectForKey:@"audioUrl"]];
        }
    }
}
-(IBAction)progressBarValueChanged:(id)sender{
    [appDelegate.FBWAudioPlayer pause];
    float progressBarValue = progressBar.value;
    CMTime playerDuration = appDelegate.FBWAudioPlayer.currentItem.asset.duration;
    double duration = CMTimeGetSeconds(playerDuration);
    CMTime newTime = CMTimeMakeWithSeconds(progressBarValue * duration, appDelegate.FBWAudioPlayer.currentTime.timescale);
    [appDelegate.FBWAudioPlayer seekToTime:newTime];
    [appDelegate.FBWAudioPlayer play];
}
#pragma mark - API Call

-(void)getEventDetailsByType {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            //contentView = [Utility activityIndicatorView:self];
             loadingView.hidden = false;
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[NSNumber numberWithInt:100] forKey:@"Count"];
        [mainDict setObject:[NSNumber numberWithInt:20] forKey:@"EventTypeID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetEventDetailsByTypeApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 loadingView.hidden = true;
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         dispatch_async(dispatch_get_main_queue(),^ {
                                                                             NSArray* listArray = [[NSMutableArray alloc]initWithArray:[responseDictionary objectForKey:@"Webinars"]];
                                                                             
                                                                             if (![Utility isEmptyCheck:listArray]) {
                                                                                 for (int i = 0; i < listArray.count; i++) {
                                                                                     NSString *eventName = [[listArray objectAtIndex:i] objectForKey:@"EventName"];
                                                                                     NSString *presenterName = [[listArray objectAtIndex:i] objectForKey:@"PresenterName"];
                                                                                     
                                                                                     NSArray *audioDetails = [[listArray objectAtIndex:i] objectForKey:@"EventItemVideoDetails"];
                                                                                     if (![Utility isEmptyCheck:audioDetails]) {
                                                                                         for (int j = 0; j < audioDetails.count; j++) {
                                                                                             NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                                                                             [dict setObject:eventName forKey:@"eventName"];
                                                                                             [dict setObject:presenterName forKey:@"presenterName"];
                                                                                             [dict setObject:[[audioDetails objectAtIndex:j] objectForKey:@"AppURL"] forKey:@"audioUrl"];
                                                                                             [appDelegate.audioListArray addObject:dict];
                                                                                         }
                                                                                     }
                                                                                 }
                                                                                 [_audioListTable reloadData];
                                                                                 [self playAudioWithUrl:[[appDelegate.audioListArray objectAtIndex:appDelegate.activeIndex] objectForKey:@"audioUrl"]];
                                                                             }
                                                                         });
                                                                         
                                                                     }else{
                                                                         [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                                                                         return;
                                                                         
                                                                     }
                                                                     
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                         }];
        [dataTask resume];
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
        return;
    }
}
#pragma mark - Private Method
- (void) playAudioWithUrl:(NSString *) urlString {
    NSURL *trackURL = [NSURL URLWithString:urlString];
    appDelegate.FBWAudioPlayer = nil;
    appDelegate.FBWAudioPlayer =  [[AVPlayer alloc] initWithURL:trackURL];
    [appDelegate.FBWAudioPlayer play];
    [appDelegate setUpRemoteControl];
    [_audioListTable reloadData];
    
    [activity startAnimating];
    activity.hidden = false;
    progressBar.hidden = true;
    
    //slider ah tr1
    double interval = .1f;
    
    CMTime playerDuration = appDelegate.FBWAudioPlayer.currentItem.duration; // return player duration.
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        CGFloat width = CGRectGetWidth([progressBar bounds]);
        interval = 0.5f * duration / width;
    }
    __weak typeof(self) weakSelf = self;
    /* Update the scrubber during normal playback. */
    if (interval > 0) {
        //        [appDelegate.FBWAudioPlayer removeTimeObserver:<#(nonnull id)#>]
        [appDelegate.FBWAudioPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                                 queue:NULL
                                                            usingBlock:
         ^(CMTime time)
         {
             //NSLog(@"int %f",interval);
             [weakSelf syncScrubber];
         }];
    }
}
- (void)syncScrubber
{
    CMTime playerDuration = appDelegate.FBWAudioPlayer.currentItem.asset.duration;
    if (CMTIME_IS_INVALID(playerDuration))
    {
        progressBar.minimumValue = 0.0;
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration) && (duration > 0))
    {
        float minValue = [ progressBar minimumValue];
        float maxValue = [ progressBar maximumValue];
        double time = CMTimeGetSeconds([appDelegate.FBWAudioPlayer currentTime]);
        [progressBar setValue:(maxValue - minValue) * time / duration + minValue];
        
        NSUInteger dMinutes = floor((NSUInteger)duration / 60);
        NSUInteger dSeconds = floor((NSUInteger)duration % 3600 % 60);
        NSString *videoDurationText = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
        totalTimeLabel.text = videoDurationText;
        
        if (activity.isAnimating && progressBar.isHidden && time>0) {
            [activity stopAnimating];
            activity.hidden = true;
            progressBar.hidden = false;
        }
    }
    
    //time label
    NSUInteger playerTime = CMTimeGetSeconds(appDelegate.FBWAudioPlayer.currentTime);
    NSUInteger dMinutes = floor(playerTime / 60);
    NSUInteger dSeconds = floor(playerTime % 3600 % 60);
    
    NSString *videoDurationText = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
    currentTimeLabel.text = videoDurationText;
}

#pragma mark - TableView Datasource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return appDelegate.audioListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"AudioBookTableViewCell";
    AudioBookTableViewCell *cell = (AudioBookTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[AudioBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = [appDelegate.audioListArray objectAtIndex:indexPath.row];
    cell.eventListName.text = ![Utility isEmptyCheck:[dict objectForKey:@"eventName"]] ? [dict objectForKey:@"eventName"]:@"";
    if (![Utility isEmptyCheck:[dict objectForKey:@"presenterName"]] && ![[dict objectForKey:@"presenterName"] isEqualToString:@" "]) {
        cell.presenterNameLabel.text = [dict objectForKey:@"presenterName"];
        cell.presenterNameLabel.hidden =false;
    }else{
        cell.presenterNameLabel.hidden =true;
    }
    [cell.playPauseButton addTarget:self action:@selector(playPauseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.playPauseButton setTag:indexPath.row];
    
    if (indexPath.row == appDelegate.activeIndex) {
        [cell.playPauseButton setSelected:YES];
    } else {
        [cell.playPauseButton setSelected:NO];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - AVPlayer Observer & Notification

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == appDelegate.FBWAudioPlayer && [keyPath isEqualToString:@"status"]) {
        if (appDelegate.FBWAudioPlayer.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
            
        } else if (appDelegate.FBWAudioPlayer.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            //            [appDelegate.FBWAudioPlayer play];
            
            
        } else if (appDelegate.FBWAudioPlayer.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
            
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - RemoteControlEvents
//ah 31.8
- (void) playTrackCommandSelector {
    //    NSIndexPath *ip = [NSIndexPath indexPathForRow:appDelegate.activeIndex inSection:0];
    //    AudioBookTableViewCell *cell = (AudioBookTableViewCell *)[_audioListTable cellForRowAtIndexPath:ip];
    //    [cell.playPauseButton setSelected:YES];
    [appDelegate.FBWAudioPlayer play];
}
- (void) pauseTrackCommandSelector {
    //    NSIndexPath *ip = [NSIndexPath indexPathForRow:appDelegate.activeIndex inSection:0];
    //    AudioBookTableViewCell *cell = (AudioBookTableViewCell *)[_audioListTable cellForRowAtIndexPath:ip];
    //    [cell.playPauseButton setSelected:NO];
    [appDelegate.FBWAudioPlayer pause];
}
- (void)nextTrackCommandSelector {
    [appDelegate.FBWAudioPlayer pause];
    appDelegate.activeIndex++;
    //    AudioBookViewController *audioBook = [[AudioBookViewController alloc] init];
    if (appDelegate.activeIndex < appDelegate.audioListArray.count) {
        //        [audioBook playAudioWithUrl:[[self.audioListArray objectAtIndex:self.activeIndex] objectForKey:@"audioUrl"]];
        NSURL *trackURL = [NSURL URLWithString:[[appDelegate.audioListArray objectAtIndex:appDelegate.activeIndex] objectForKey:@"audioUrl"]];
        
        appDelegate.FBWAudioPlayer = nil;
        appDelegate.FBWAudioPlayer =  [[AVPlayer alloc] initWithURL:trackURL];
        [appDelegate.FBWAudioPlayer play];
        
        
    } else {
        appDelegate.activeIndex = 0;
        //        [audioBook playAudioWithUrl:[[self.audioListArray objectAtIndex:self.activeIndex] objectForKey:@"audioUrl"]];
        NSURL *trackURL = [NSURL URLWithString:[[appDelegate.audioListArray objectAtIndex:appDelegate.activeIndex] objectForKey:@"audioUrl"]];
        
        appDelegate.FBWAudioPlayer = nil;
        appDelegate.FBWAudioPlayer =  [[AVPlayer alloc] initWithURL:trackURL];
        [appDelegate.FBWAudioPlayer play];
        
    }
}
- (void)prevTrackCommandSelector {
    [appDelegate.FBWAudioPlayer pause];
    appDelegate.activeIndex--;
    //    AudioBookViewController *audioBook = [[AudioBookViewController alloc] init];
    if (appDelegate.activeIndex < 0) {
        appDelegate.activeIndex = 0;
        //        [audioBook playAudioWithUrl:[[self.audioListArray objectAtIndex:self.activeIndex] objectForKey:@"audioUrl"]];
        NSURL *trackURL = [NSURL URLWithString:[[appDelegate.audioListArray objectAtIndex:appDelegate.activeIndex] objectForKey:@"audioUrl"]];
        
        appDelegate.FBWAudioPlayer = nil;
        appDelegate.FBWAudioPlayer =  [[AVPlayer alloc] initWithURL:trackURL];
        [appDelegate.FBWAudioPlayer play];
        
    } else {
        //        [audioBook playAudioWithUrl:[[self.audioListArray objectAtIndex:self.activeIndex] objectForKey:@"audioUrl"]];
        NSURL *trackURL = [NSURL URLWithString:[[appDelegate.audioListArray objectAtIndex:appDelegate.activeIndex] objectForKey:@"audioUrl"]];
        
        appDelegate.FBWAudioPlayer = nil;
        appDelegate.FBWAudioPlayer =  [[AVPlayer alloc] initWithURL:trackURL];
        [appDelegate.FBWAudioPlayer play];
        
    }
}

#pragma mark - End

#pragma mark - AVPlayer Notification
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    appDelegate.activeIndex++;
    if (appDelegate.activeIndex < appDelegate.audioListArray.count) {
        
         [self playAudioWithUrl:[[appDelegate.audioListArray objectAtIndex:appDelegate.activeIndex] objectForKey:@"audioUrl"]];
    }else{
        appDelegate.activeIndex = 0;
        [self playAudioWithUrl:[[appDelegate.audioListArray objectAtIndex:appDelegate.activeIndex] objectForKey:@"audioUrl"]];
    }
   
    
}
#pragma mark - End



@end
