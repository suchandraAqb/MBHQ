//
//  AudioPlayerViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 21/12/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AudioPlayerViewController.h"
#import "NSString+TimeToString.h"
#import "SettingsViewController.h"

@interface AudioPlayerViewController (){
    NSTimer *timer;
    MPMusicPlayerController *mp;
    IBOutlet UIImageView *imageAlbum;
    IBOutlet UILabel * labelTitle; //Above slider
    IBOutlet UILabel * labelArtist; //Above slider
    IBOutlet UILabel * labelElapsed; //Left of slider
    IBOutlet UILabel * labelDuration; //Below Slider
    IBOutlet UILabel *labelRemaining; // Right of slider
    IBOutlet UISlider *sliderTime;
    IBOutlet UIButton *playPause;
    IBOutlet UIButton *suffle;
    BOOL interrupted;
    MPMediaItemCollection *mediaItemCollection;
    SettingsViewController *parent;
    ExerciseVideoViewController *parentOfParent;
    BOOL haveToSuffle;
    

}

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *shuffled;
@end


@implementation NSArray (GVShuffledArray)

- (NSArray *)shuffled {
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[self count]];
    
    for (id anObject in self) {
        NSUInteger randomPos = arc4random()%([tmpArray count]+1);
        [tmpArray insertObject:anObject atIndex:randomPos];
    }
    
    return [NSArray arrayWithArray:tmpArray];
}

@end
@implementation AudioPlayerViewController

- (void)viewDidLoad {
    
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
    [[MPMusicPlayerController systemMusicPlayer] endGeneratingPlaybackNotifications];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter   defaultCenter];
    [notificationCenter removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:[MPMusicPlayerController systemMusicPlayer]];
    [notificationCenter removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:[MPMusicPlayerController systemMusicPlayer]];
    
    if (![Utility isEmptyCheck:parentOfParent] && parentOfParent.isWeightSheetButtonPressed) {
        return;
    }
    if (![Utility isEmptyCheck:parent] && parent.keepPlaying) {
        return;
    }
    if (![Utility isEmptyCheck:parent] && parent.circuitPlaying) {
        return;
    }
    [mp stop];
    [timer invalidate];
    timer = nil;
}
-(void)reloadUI{
    if (![Utility isEmptyCheck:self.parentViewController.parentViewController] && [self.parentViewController.parentViewController isKindOfClass:[ExerciseVideoViewController class]]) {
        parentOfParent = (ExerciseVideoViewController *)self.parentViewController.parentViewController;
    }
    if (![Utility isEmptyCheck:self.parentViewController] && [self.parentViewController isKindOfClass:[SettingsViewController class]]) {
        parent = (SettingsViewController *)self.parentViewController;
    }
    NSNotificationCenter *notificationCenter = [NSNotificationCenter   defaultCenter];
    [notificationCenter addObserver:self selector:@selector(updateNowPlayingInfo) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:[MPMusicPlayerController systemMusicPlayer]];
    [notificationCenter addObserver:self selector:@selector(updatePlaybackState) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:[MPMusicPlayerController systemMusicPlayer]];
    
    
    mp = [MPMusicPlayerController systemMusicPlayer];
    // Add a notification observer for MPMusicPlayerControllerNowPlayingItemDidChangeNotification that fires a method when the track changes (to update track info label)
    
    [mp beginGeneratingPlaybackNotifications];
    
    NSData *mediaItemCollectionData = [[NSUserDefaults standardUserDefaults] objectForKey:@"mediaItemCollection"];
    mediaItemCollection = [NSKeyedUnarchiver unarchiveObjectWithData:mediaItemCollectionData];
    if ([Utility isEmptyCheck:[defaults objectForKey:@"Shuffle"]] || [[defaults objectForKey:@"Shuffle"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
        suffle.selected = false;
    }else{
        suffle.selected = true;
    }
    if (![Utility isEmptyCheck:mediaItemCollection] ) {
        if (mp.currentPlaybackRate != 1) {
            [self shuffleMediaItem:suffle.selected];
        }
        /* else if((![Utility isEmptyCheck:[defaults objectForKey:@"Motivation"]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"off"] == NSOrderedSame) || (![Utility isEmptyCheck:[defaults objectForKey:@"Inbetween Rounds"]] && [[defaults objectForKey:@"Inbetween Rounds"] caseInsensitiveCompare:@"STOPS PLAYING"] == NSOrderedSame)){
         [mp pause];
         }
         */
    }
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}
-(void)shuffleMediaItem:(BOOL)shuffleOrNot{
    NSData *mediaItemCollectionData = [[NSUserDefaults standardUserDefaults] objectForKey:@"mediaItemCollection"];
    MPMediaItemCollection *beforeShuffleMediaItemCollection = [NSKeyedUnarchiver unarchiveObjectWithData:mediaItemCollectionData];
    if (![Utility isEmptyCheck:beforeShuffleMediaItemCollection] && shuffleOrNot) {
        NSArray *suffledArray = [[beforeShuffleMediaItemCollection items] shuffled];
        mediaItemCollection = [[MPMediaItemCollection alloc]initWithItems:suffledArray];
    }else{
        mediaItemCollection = beforeShuffleMediaItemCollection;
    }
    [mp setQueueWithItemCollection:mediaItemCollection];
    if (suffle.selected) {
        mp.shuffleMode = MPMusicShuffleModeSongs;
        [defaults setObject:@"on" forKey:@"Shuffle"];
    } else {
        mp.shuffleMode = MPMusicShuffleModeOff;
        [defaults setObject:@"off" forKey:@"Shuffle"];
    }
    //[mp setNowPlayingItem:mediaItemCollection.items[0]];
    if([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame && [[defaults objectForKey:@"Inbetween Rounds"] caseInsensitiveCompare:@"STOPS PLAYING"] != NSOrderedSame){
//        if (!parentOfParent.gameOnView.hidden) {
//            [self performSelector:@selector(play) withObject:self afterDelay:10.0];
//        }else{
//            [self play];
//
//        }
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
}
-(void)play{
    [mp play];
}
- (void)beginInterruption {
    if (mp.currentPlaybackRate == 1) {
        interrupted = YES;
    }
    [mp pause];
}

- (void)endInterruptionWithFlags:(NSUInteger)flags {
    if (interrupted && (flags & AVAudioSessionInterruptionOptionShouldResume)) {
        [mp play];
    }
    interrupted = NO;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMusicPlayerControllerVolumeDidChangeNotification
                                                  object:[MPMusicPlayerController systemMusicPlayer]];
}
-(void)updatePlaybackState{
        if (mp.currentPlaybackRate == 1) {
            playPause.selected = false;
        }else{
            playPause.selected = true;
        }
}

-(void)updateNowPlayingInfo{
    if (haveToSuffle) {
        haveToSuffle =NO;
        [self shuffleMediaItem:suffle.selected];
    }
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void)stopMusicWhenApplicationQuits{
    [mp stop];
}
-(void)updateUI{
    //Ensure the track exists before pulling the info
    MPMediaItem *currentTrack = [mp nowPlayingItem];
    if (currentTrack){
        //pull artist and title for current track and show in labelTitle
        NSString *trackName = currentTrack.title;
        NSString * trackArtist = currentTrack.artist;
        labelTitle.text = trackName;
        labelArtist.text = trackArtist;
        // Display album artwork. self.artworkImageView is a UIImageView.
        CGSize artworkImageViewSize = imageAlbum.bounds.size;
        MPMediaItemArtwork *artwork = [currentTrack valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork != nil) {
            imageAlbum.image = [artwork imageWithSize:artworkImageViewSize];
        } else {
            imageAlbum.image = nil;
        }
        //Pull length of current track in seconds
        int trackDuration = currentTrack.playbackDuration;
        labelDuration.text =[NSString stringFromTime:trackDuration ];
        //Find elapsed time by pulling currentPlaybackTime
        int trackElapsed = mp.currentPlaybackTime;
        labelElapsed.text = [NSString stringFromTime:trackElapsed ];
        //Find remaining time by subtraction the elapsed time from the duration
        int trackRemaining = trackDuration - trackElapsed;
        labelRemaining.text = [NSString stringFromTime:trackRemaining];
        //set maximum value of the slider
        sliderTime.maximumValue = (float)trackDuration;
        //changes slider to as song progresses
        sliderTime.value =(float)trackElapsed;
    }
}

#pragma mark - IBAction
//Function to make adjusting the slider move through the song.
-(IBAction) suffleButtonPressed:(UIButton *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        suffle.selected = !suffle.selected;
        haveToSuffle = YES;
    });
}
- (IBAction)sliderTimeChanged:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
    if (![Utility isEmptyCheck:mediaItemCollection]){
        mp.currentPlaybackTime = (NSTimeInterval)sliderTime.value;
    }
    });
}
//Button functions -- I'm pretty sure these are self explanatory enough
-(IBAction) buttonPlayPause:(UIButton *)sender{
    if (![Utility isEmptyCheck:mediaItemCollection]){
        if (mp.currentPlaybackRate == 1) {
            [mp pause];
        }else{
            [mp play];
        }
    }
}
-(IBAction) buttonPrevious:(UIButton *)sender{
    if (![Utility isEmptyCheck:mediaItemCollection]){
        [mp skipToPreviousItem];
    }
}

-(IBAction) buttonBeginning:(UIButton *)sender{
    if (![Utility isEmptyCheck:mediaItemCollection]){
        [mp skipToBeginning];
    }
}

-(IBAction) buttonNext:(UIButton *)sender{
    if (![Utility isEmptyCheck:mediaItemCollection]){
        [mp skipToNextItem];
    }
}
#pragma mark - End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
