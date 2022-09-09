//
//  TimerViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 06/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "TimerViewController.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "AudioPlayerViewController.h"
#import "SettingsViewController.h"

@interface TimerViewController (){
    IBOutlet UIView *backgroundView;
    IBOutlet UIImageView *bgImageView;
    IBOutlet UIView *timerView;
    IBOutlet UIView *stationView;
    IBOutlet UIView *roundView;
    IBOutlet UIView *buttonView;
    
    IBOutlet UILabel *timerTitleLabel;
    IBOutlet UILabel *timerLabel;
    IBOutlet UILabel *stationCountLabel;
    IBOutlet UILabel *roundCountlabel;
    IBOutlet UIButton *playPauseButton;
    IBOutlet UILabel *resetStartLabel;
    
    IBOutlet UIButton *repsDoneButton;
    
    IBOutlet UIView *flashingView;
    IBOutlet UILabel *totalStationCountLabel;
    IBOutlet UILabel *totalRoundCountlabel;
    IBOutlet UILabel *sessionTimeLabel;
    
    IBOutlet UIView *repsDoneView;
    IBOutlet UIView *repsDoneFlashingView;
    
    NSTimer *mainTimer;
    int maincounter;
    int stage;
    int roundCount;
    int stationCount;
    BOOL isPrepTime;
    BOOL isPlaying;
    BOOL isStart;
    BOOL isFirstLoad;
    BOOL isFirstLoadRoundEdit;
    BOOL isFirstLoadStationEdit;
    
    
    NSMutableArray *roundArray;     //roundEdit
    NSMutableDictionary *stationDict;   //stationEdit
    NSString *roundKey;
    BOOL isPrepRunning;
    
    NSTimer *flashingTimer;
    int flashingCount;
    int roundCountValue;
    int stationCountValue;
    int sessionTimeCounter;
    NSTimer *sessionTimer;
    BOOL isMusicPlaying;
    
    AVAudioPlayer *audioPlayer;
    
    BOOL shouldPlayCountdown;
    BOOL isHighVolume;
    BOOL wasPlaying;
    
    NSString *roundFinishState;
    NSString *endOfRoundState;
    NSString *roundEndOfRoundState;
    
    NSMutableArray *motivationArray;
    int totalTime;
    BOOL newShouldPlayCountdown;
    int sayingRoundNo;
    int sayingStationNo;
    BOOL shouldPlaySaying;
    NSMutableArray *sayingArray;
    BOOL isLetsGoPlayed;
    NSArray *motivationStaticArray;
    NSArray *sayingStaticArray;
    
    int shuffleOnTimeCountdown;
    BOOL isshuffleOnCountdownPlayed;
    
    NSMutableArray *mediaArray;
    AppDelegate *appDelegate;
    
    __weak IBOutlet UIButton *volumeButton;
    __weak IBOutlet UIButton *voiceOverButton;
    __weak IBOutlet UIButton *bellButton;
    __weak IBOutlet NSLayoutConstraint *roundViewHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *repsDoneViewHeightConstraint;
    BOOL autoPlayTimer;
    __weak IBOutlet UIButton *musicButton;
}

@end

@implementation TimerViewController
@synthesize dataDict,roundEditDataDict,stationEditdataDict,mode,roundPrepTime;

- (void)viewDidLoad {
    [super viewDidLoad];
    autoPlayTimer = false;
    flashingView.hidden = YES;
    repsDoneFlashingView.hidden = YES;
    flashingCount = 0;
    stage = 1;
    isPlaying = YES;
    isStart = YES;
    isPrepRunning = YES;
    roundArray = [[NSMutableArray alloc]init];
    stationDict = [[NSMutableDictionary alloc]init];
    roundKey = @"round0";
    roundCountValue = 1;
    stationCountValue = 1;
    sessionTimeCounter = 0;
    isMusicPlaying = NO;
    shouldPlayCountdown = NO;
    isHighVolume = YES;
    wasPlaying = YES;
    roundFinishState = @"";
    endOfRoundState = @"";
    roundEndOfRoundState = @"";
    motivationArray = [[NSMutableArray alloc]init];
    totalTime = 0;
    newShouldPlayCountdown = NO;
    sayingRoundNo = 0;
    sayingStationNo = 0;
    shouldPlaySaying = NO;
    sayingArray = [[NSMutableArray alloc]init];
    isLetsGoPlayed = NO;
    motivationStaticArray = [[NSArray alloc]init];
    sayingStaticArray = [[NSArray alloc]init];
    shuffleOnTimeCountdown = 2;
    isshuffleOnCountdownPlayed = NO;
    isFirstLoad=YES;
    isFirstLoadRoundEdit=YES;
    isFirstLoadStationEdit=YES;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"appDelegate:  %@ %@",appDelegate,appDelegate.mainAudioPlayer);
    mediaArray = [[NSMutableArray alloc]init];
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.height);
    if ([UIScreen mainScreen].bounds.size.height <= 668) {
        [timerTitleLabel setFont:[UIFont fontWithName:@"Oswald-Light" size:17]];
        [timerLabel setFont:[UIFont fontWithName:@"Oswald-Regular" size:55]];
        [sessionTimeLabel setFont:[UIFont fontWithName:@"Oswald-Regular" size:17]];
    }
    musicButton.layer.borderWidth = 1;
    musicButton.layer.borderColor = [UIColor colorWithRed:(228/255.0) green:(39/255.0) blue:(160/255.0) alpha:1.0].CGColor;
//    [backgroundView setBackgroundColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:0.5]];
    [timerView setBackgroundColor:[UIColor colorWithRed:(57/255.0) green:(255/255.0) blue:(20/255.0) alpha:1.0]];
    //[roundView setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(188/255.0) alpha:0.7]];
    //suchandra Change 2/1/17
//    [roundView setBackgroundColor:[UIColor colorWithRed:(112/255.0) green:(153/255.0) blue:(253/255.0) alpha:0.7]];
//    [stationView setBackgroundColor:[UIColor colorWithRed:(239/255.0) green:(0/255.0) blue:(172/255.0) alpha:0.7]];
    //
    //[stationView setBackgroundColor:[UIColor colorWithRed:(112/255.0) green:(153/255.0) blue:(253/255.0) alpha:0.7]];
//    [buttonView setBackgroundColor:[UIColor colorWithRed:(112/255.0) green:(153/255.0) blue:(253/255.0) alpha:0.7]];
    
    if ([mode caseInsensitiveCompare:@"DEFAULT"] == NSOrderedSame) {
        NSArray *timeArray = [[dataDict objectForKey:@"roundPrepTime"] componentsSeparatedByString:@":"];
        int minutes = [[timeArray objectAtIndex:0] intValue];
        int seconds = [[timeArray objectAtIndex:1] intValue];
        int newCounter = minutes*60 + seconds;
        if (newCounter > 0) {
            stage = 0;
        }
        [self startTimerWithTime:[dataDict objectForKey:@"roundPrepTime"]];
        stage = 1;
        roundCount = [[dataDict objectForKey:@"roundsCount"] intValue];
        stationCount = [[dataDict objectForKey:@"stationCount"] intValue];
        timerLabel.text = [dataDict objectForKey:@"roundPrepTime"];
        totalRoundCountlabel.text = [dataDict objectForKey:@"roundsCount"];
        totalStationCountLabel.text = [dataDict objectForKey:@"stationCount"];
        //saying
        if ([[dataDict objectForKey:@"roundsCount"] intValue] > 2 || [[dataDict objectForKey:@"stationCount"] intValue] > 2) {
            NSArray *timeArray = [[dataDict objectForKey:@"onTime"] componentsSeparatedByString:@":"];
            int minutes = [[timeArray objectAtIndex:0] intValue];
            int seconds = [[timeArray objectAtIndex:1] intValue];
            int newCounter = minutes*60 + seconds;
            if (newCounter > 25) {
                sayingRoundNo = ceil([[dataDict objectForKey:@"roundsCount"] intValue]/2.0f);
                sayingStationNo = ceil([[dataDict objectForKey:@"stationCount"] intValue]/2.0f);
                shouldPlaySaying = YES;
            }
        }
        
    } else if ([mode caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame) {
        
        roundArray = [roundEditDataDict objectForKey:@"round"];
        roundCount = (int)roundArray.count;
        stationCount = [[roundEditDataDict objectForKey:@"station"] intValue];
        timerLabel.text = roundPrepTime;
        totalRoundCountlabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)roundArray.count];
        totalStationCountLabel.text = [roundEditDataDict objectForKey:@"station"];
        [self startTimerWithTime:roundPrepTime];
        
        //saying
        NSMutableArray *sCount = [[NSMutableArray alloc]init];
        NSMutableArray *rArray = [[NSMutableArray alloc]init];
        [rArray addObjectsFromArray:[roundEditDataDict objectForKey:@"round"]];
        if (rArray.count > 2 || [[roundEditDataDict objectForKey:@"station"] intValue] > 2) {
            for (int i = 0; i < rArray.count; i++) {
                NSArray *timeArray = [[[rArray objectAtIndex:i] objectForKey:@"onTime"] componentsSeparatedByString:@":"];
                int minutes = [[timeArray objectAtIndex:0] intValue];
                int seconds = [[timeArray objectAtIndex:1] intValue];
                int newCounter = minutes*60 + seconds;
                if (newCounter > 25) {
                    [sCount addObject:[NSString stringWithFormat:@"%d",i]];
                }
            }
            if (sCount.count > 0) {
                NSInteger indexNo = ceil(sCount.count/2.0f);
                if (indexNo >= sCount.count) {
                    indexNo = sCount.count - 1;
                }
                sayingRoundNo = [[sCount objectAtIndex:indexNo] intValue];
                sayingStationNo = ceil([[roundEditDataDict objectForKey:@"station"] intValue]/2.0f);
                shouldPlaySaying = YES;
            }
        }
        
    } else if ([mode caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
        
        roundCount = (int)stationEditdataDict.count;
        stationDict = [stationEditdataDict objectForKey:@"round0"];
        stationCount = (int)stationDict.count;
        timerLabel.text = roundPrepTime;
        totalRoundCountlabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)stationEditdataDict.count];
        totalStationCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)stationDict.count];
        [self startTimerWithTime:roundPrepTime];
        
        //saying
        NSMutableArray *sCount = [[NSMutableArray alloc]init];
        NSMutableArray *sArray = [[NSMutableArray alloc]init];
        [sArray addObjectsFromArray:[stationEditdataDict objectForKey:@"round0"]];
        if (stationEditdataDict.count > 2 || sArray.count > 2) {
            for (int r = 0; r < stationEditdataDict.count; r++) {
                [sArray removeAllObjects];
                NSString *newRoundKey = [NSString stringWithFormat:@"round%d",r];
                [sArray addObjectsFromArray:[stationEditdataDict objectForKey:newRoundKey]];
                for (int i = 0; i < sArray.count; i++) {
                    NSArray *timeArray = [[[sArray objectAtIndex:i] objectForKey:@"onTime"] componentsSeparatedByString:@":"];
                    int minutes = [[timeArray objectAtIndex:0] intValue];
                    int seconds = [[timeArray objectAtIndex:1] intValue];
                    int newCounter = minutes*60 + seconds;
                    if (newCounter > 25) {
                        [sCount addObject:@{@"round":[NSString stringWithFormat:@"%d",r],@"station":[NSString stringWithFormat:@"%d",i]}];
                    }
                }
            }
            if (sCount.count > 0) {
                NSInteger indexNo = ceil(sCount.count/2.0f);
                if (indexNo >= sCount.count) {
                    indexNo = sCount.count - 1;
                }
                sayingRoundNo = [[[sCount objectAtIndex:indexNo] objectForKey:@"round"] intValue];
                sayingStationNo = [[[sCount objectAtIndex:indexNo] objectForKey:@"station"] intValue];
                shouldPlaySaying = YES;
            }
        }
    }
    isPrepTime = YES;
    timerTitleLabel.text = @"ROUND PREP TIME";
    stationCountLabel.text = @"1";//[NSString stringWithFormat:@"%d",stationCount];
    roundCountlabel.text = @"1";//[NSString stringWithFormat:@"%d",roundCount];
//    [timerView setBackgroundColor:[UIColor colorWithRed:(112/255.0) green:(153/255.0) blue:(253/255.0) alpha:0.7]];
    [flashingTimer invalidate];
    
    //    if ([[defaults objectForKey:@"wasMusicPlaying"] boolValue] && [defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
    //        [appDelegate.mainAudioPlayer play];
    //
    //        //suchandra 2/1/17
    //        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isMusicPaused"];
    //        //
    //
    //    }
    
    [self playAudioWithName:@"Let's Get Started" Extension:@"wav"];
    sessionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sessionCounter) userInfo:nil repeats:YES];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTimerNotification:) name:@"timer_notification" object:nil];
    
    //    if ([defaults objectForKey:@"mediaDetails"] && ![[defaults objectForKey:@"mediaDetails"] isEqual:[NSNull null]]) {
    //        NSLog(@"da %@",[defaults objectForKey:@"mediaDetails"]);
    //        NSArray *array = [[NSArray alloc]init];
    ////        array = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"mediaDetails"]];
    ////        [mediaArray addObjectsFromArray:array];
    ////        NSLog(@"ma %@",mediaArray);
    //
    //        NSData *newSessionData = [[NSUserDefaults standardUserDefaults] objectForKey:@"mediaDetails"];
    ////        array = [[NSKeyedUnarchiver unarchiveObjectWithData:newSessionData] mutableCopy];
    //        [mediaArray addObjectsFromArray:[[NSKeyedUnarchiver unarchiveObjectWithData:newSessionData] mutableCopy]];
    //    }
    
    //    [self playNewAudioWithName:@"Your mind will quit before your body gives up!" Extension:@"wav"];
    //    [self playAudioWithName:@"Car-Horn" Extension:@"mp3"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateFooter];
//    NSError *error = nil;
//    @try {
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error];
//        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
//        [[AVAudioSession sharedInstance] setActive:YES error:nil];
//        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//
//    } @catch (NSException *exception) {
//        NSLog(@"Audio Session error %@, %@", exception.reason, exception.userInfo);
//
//    } @finally {
//        NSLog(@"Audio Session finally");
//    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitList:) name:@"backButtonPressed" object:nil];
    if ([[defaults objectForKey:@"keepCircuitMusicPlaying"] boolValue]) {
        [self startMusic];
    }
    if (autoPlayTimer) {
        [self playPauseButtonTapped:nil];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    if (isPlaying) {
        autoPlayTimer = true;
        [self playPauseButtonTapped:nil];
    }else{
        autoPlayTimer = false;
    }
    [mainTimer invalidate];
    [flashingTimer invalidate];
    [sessionTimer invalidate];
    [audioPlayer stop];
    [appDelegate.mainAudioPlayer pause];
    [self stopMusic];
    
    //suchandra 2/1/17
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isMusicPaused"];
    //
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
//    repsDoneViewHeightConstraint.constant = backgroundView.frame.size.height / 6;
    roundViewHeightConstraint.constant = backgroundView.frame.size.height / 3;
    motivationStaticArray = @[@{@"name":@"Awesome job!",@"duration":@"2"},
                              @{@"name":@"Feel the burn!",@"duration":@"3"},
                              @{@"name":@"Hold!!",@"duration":@"3"},
                              @{@"name":@"I know it's tough, but you're tougher!",@"duration":@"4"},
                              @{@"name":@"I know your legs are burning right now but don't you dare quit!",@"duration":@"5"},
                              @{@"name":@"I refuse to quit!",@"duration":@"3"},
                              @{@"name":@"If everything you ever wanted was on the other side of this workout -",@"duration":@"7"},
                              @{@"name":@"If you're feeling tired or sore, ask yourself why you started!",@"duration":@"7"},
                              @{@"name":@"Keep it Up! You're Killing it!",@"duration":@"3"},
                              @{@"name":@"Keep Pushing Babe",@"duration":@"3"},
                              @{@"name":@"Killing it Babe! Keep up the Good Work!",@"duration":@"3"},
                              @{@"name":@"Looking good babe, keep smashing it!",@"duration":@"3"},
                              @{@"name":@"Love it!",@"duration":@"2"},
                              @{@"name":@"Nothing worth having comes easy. Keep Pushing!",@"duration":@"5"},
                              @{@"name":@"Remember why you came to training today!",@"duration":@"4"},
                              @{@"name":@"Stay with me! Keep pushing babe!",@"duration":@"4"},
                              @{@"name":@"We don't stop when we're tired, we stop when we're done!",@"duration":@"5"},
                              @{@"name":@"We're coming home strong now! It's the downhill run, you've got this!",@"duration":@"4"},
                              @{@"name":@"We're over halfway now babe, home stretch! You've got this",@"duration":@"5"},
                              @{@"name":@"We've Got This",@"duration":@"2"},
                              @{@"name":@"What was I thinking putting this in the program!_",@"duration":@"5"},
                              @{@"name":@"You are doing so well! Lets finish it off.",@"duration":@"5"},
                              @{@"name":@"You are one amazing lady! Keep that shit up!",@"duration":@"4"},
                              @{@"name":@"You are unstoppable!",@"duration":@"4"},
                              @{@"name":@"You can do anything for just 30 seconds, stay strong!",@"duration":@"5"},
                              @{@"name":@"You seriously are wonderwoman, smash it up!",@"duration":@"4"},
                              @{@"name":@"You've Got This",@"duration":@"2"},
                              @{@"name":@"Your mind will quit before your body gives up!",@"duration":@"5"}];
    
    sayingStaticArray = @[@{@"name":@"Control your reps and keep that range! Don't cheat yourself!",@"duration":@"6"},
                          @{@"name":@"Keep your form, no shortcuts!",@"duration":@"3"},
                          @{@"name":@"Lock that Core, Stop yourself from peeing, Bellybutton to spine",@"duration":@"6"},
                          @{@"name":@"Lock your core and squeeze your gluts!",@"duration":@"4"},
                          @{@"name":@"This is a tough one, keep your core turned on and control!",@"duration":@"5"}];
    
    motivationArray = [motivationStaticArray mutableCopy];
    sayingArray = [sayingStaticArray mutableCopy];
    //    NSLog(@"dd %@",[defaults objectForKey:@"isMusicPlaying"]);
    //    [[defaults objectForKey:@"isMusicPaused"] boolValue]
    if ([[defaults objectForKey:@"wasMusicPlaying"] boolValue] && [defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
        //        if ([defaults objectForKey:@"Shuffle"] && ![[defaults objectForKey:@"Shuffle"] isEqual:[NSNull null]]  && [[defaults objectForKey:@"Shuffle"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
        //            MPMediaQuery *query = [MPMediaQuery playlistsQuery];
        //            NSArray *playlists = [query collections];
        //
        //            NSInteger selectedMediaIndex = [[defaults objectForKey:@"mediaSelectedIndex"] integerValue];
        //
        //            MPMediaPlaylist *specificplaylist = [playlists objectAtIndex:selectedMediaIndex];
        //            NSArray *songs = [specificplaylist items];
        //
        //            NSMutableArray *array = [NSMutableArray array];
        //            for(int i=0; i<songs.count; i++) {
        //                [array addObject:@(i)]; // @() is the modern objective-c syntax, to box the value into an NSNumber.
        //            }
        //            [appDelegate.indexArray addObjectsFromArray:[Utility shuffleFromArray:array]];
        //                        NSLog(@"ma %@",appDelegate.indexArray);
        //            appDelegate.mediaPlayingIndex++;
        //            [self playAudioWithName:@"" Extension:@"" Url:[[songs objectAtIndex:[[appDelegate.indexArray objectAtIndex:appDelegate.mediaPlayingIndex] intValue]] valueForProperty:MPMediaItemPropertyAssetURL]];
        //        }else {
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.mainAudioPlayer.delegate = self;
        [appDelegate.mainAudioPlayer play];
        //        }
    } else if ([[defaults objectForKey:@"isMusicPlaying"] caseInsensitiveCompare:@"playing"] == NSOrderedSame && [defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
        MPMediaQuery *query = [MPMediaQuery playlistsQuery];
        NSArray *playlists = [query collections];
        
        NSInteger selectedMediaIndex = [[defaults objectForKey:@"mediaSelectedIndex"] integerValue];
        
        MPMediaPlaylist *specificplaylist = [playlists objectAtIndex:selectedMediaIndex];
        NSArray *songs = [specificplaylist items];
        
        if ([defaults objectForKey:@"Shuffle"] && ![[defaults objectForKey:@"Shuffle"] isEqual:[NSNull null]]  && [[defaults objectForKey:@"Shuffle"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
            NSMutableArray *array = [NSMutableArray array];
            for(int i=0; i<songs.count; i++) {
                [array addObject:@(i)]; // @() is the modern objective-c syntax, to box the value into an NSNumber.
            }
            [appDelegate.indexArray addObjectsFromArray:[Utility shuffleFromArray:array]];
            //            NSLog(@"ma %@",appDelegate.indexArray);
            appDelegate.mediaPlayingIndex++;
            [self playAudioWithName:@"" Extension:@"" Url:[[songs objectAtIndex:[[appDelegate.indexArray objectAtIndex:appDelegate.mediaPlayingIndex] intValue]] valueForProperty:MPMediaItemPropertyAssetURL]];
        } else {
            appDelegate.mediaPlayingIndex++;
            //[self playAudioWithName:@"" Extension:@"" Url:[[songs objectAtIndex:appDelegate.mediaPlayingIndex] valueForProperty:MPMediaItemPropertyAssetURL]];
            NSString *musicUrlStr = [defaults objectForKey:@"currentMusicUrl"];
            NSURL *musicUrl = [NSURL URLWithString:musicUrlStr];
            [self playAudioWithName:@"" Extension:@"" Url:musicUrl];
        }
    }
    NSLog(@"%d",stage);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Local Notification Observer and delegate

-(void)quitList:(NSNotification *)notification{
    
    NSString *text = notification.object;
    
    
    if([text isEqualToString:@"homeButtonPressed"]){
        [self homeButtonPressed:0];
    }else{
        [self backButtonPressed:0];
    }
    
}
-(IBAction)homeButtonPressed:(UIButton*)sender{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    //add_new_7/8/17
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            if(([Utility isSubscribedUser] && [Utility isOfflineMode]) || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
                if (!isAllTaskCompleted ){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
//                    TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
                    GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }
    }];
}
-(IBAction)backButtonPressed:(id)sender{
    // [self.navigationController popViewControllerAnimated:YES];
    //add_new_7/8/17
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.navigationController  popViewControllerAnimated:YES];
        }
    }];
}
- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Stop Circuit Timer?"
                                          message:@"This will restart the circuit timer. Are you sure you want to quit?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                       response(NO);
                                   }];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Quit"
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   
                                   response(YES);
                               }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -End
#pragma mark - IBAction
- (IBAction)backButton:(id)sender {
    [mainTimer invalidate];
    [flashingTimer invalidate];
    [sessionTimer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)playPauseButtonTapped:(id)sender {
    if (isPlaying) {
        [playPauseButton setImage:[UIImage imageNamed:@"round_play.png"] forState:UIControlStateNormal];
        [resetStartLabel setText:@"PLAY"];
        [mainTimer invalidate];
        [sessionTimer invalidate];
        isPlaying = NO;
        if (appDelegate.mainAudioPlayer.isPlaying) {
            [appDelegate.mainAudioPlayer pause];
            
            //suchandra 2/1/17
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isMusicPaused"];
            //
            
            isMusicPlaying = YES;
        } else {
            isMusicPlaying = NO;
        }
        flashingView.hidden = YES;
//        [timerView setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(0/255.0) alpha:1.0]];
    } else {
        [playPauseButton setImage:[UIImage imageNamed:@"round_pause.png"] forState:UIControlStateNormal];
        [resetStartLabel setText:@"PAUSE"];
//        [timerView setBackgroundColor:[UIColor colorWithRed:(57/255.0) green:(255/255.0) blue:(20/255.0) alpha:1.0]];
        if (isStart) {
            if ([mode caseInsensitiveCompare:@"DEFAULT"] == NSOrderedSame) {
                mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
            } else if ([mode caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame) {
                mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounterForRoundEdit) userInfo:nil repeats:YES];
            } else if ([mode caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
                mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounterForStationEdit) userInfo:nil repeats:YES];
            }
        } else {
            if ([mode caseInsensitiveCompare:@"DEFAULT"] == NSOrderedSame) {
                [self startTimerWithTime:[dataDict objectForKey:@"roundPrepTime"]];
            } else if ([mode caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame) {
                [self startTimerWithTime:roundPrepTime];
            } else if ([mode caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
                isPrepRunning = YES;
                [self startTimerWithTime:roundPrepTime];
            }
        }
        
        isPlaying = YES;
        [resetStartLabel setText:@"PAUSE"];
        isStart = YES;
        sessionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sessionCounter) userInfo:nil repeats:YES];
        if (isMusicPlaying && [defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
            [appDelegate.mainAudioPlayer play];
            
            //suchandra 2/1/17
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isMusicPaused"];
            //
            
        }
    }
}
-(IBAction)resetStartButtonTapped:(id)sender {
    if (isStart) {
        [resetStartLabel setText:@"PLAY"];
        isStart = NO;
        [mainTimer invalidate];
        [sessionTimer invalidate];
        stage = 1;
        
        [playPauseButton setImage:[UIImage imageNamed:@"round_play.png"] forState:UIControlStateNormal];
        isPlaying = NO;
        
        if ([mode caseInsensitiveCompare:@"DEFAULT"] == NSOrderedSame) {
            roundCount = [[dataDict objectForKey:@"roundsCount"] intValue];
            stationCount = [[dataDict objectForKey:@"stationCount"] intValue];
            timerLabel.text = [dataDict objectForKey:@"roundPrepTime"];
        } else if ([mode caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame) {
            roundArray = [roundEditDataDict objectForKey:@"round"];
            roundCount = (int)roundArray.count;
            stationCount = [[roundEditDataDict objectForKey:@"station"] intValue];
            timerLabel.text = roundPrepTime;
        } else if ([mode caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
            roundCount = (int)stationEditdataDict.count;
            stationDict = [stationEditdataDict objectForKey:@"round0"];
            stationCount = (int)stationDict.count;
            timerLabel.text = roundPrepTime;
        }
        
        isPrepTime = YES;
        timerTitleLabel.text = @"ROUND PREP TIME";
        stationCountLabel.text = [NSString stringWithFormat:@"%d",stationCount];
        roundCountlabel.text = [NSString stringWithFormat:@"%d",roundCount];
        
        playPauseButton.hidden = NO;
        repsDoneButton.hidden = YES;
        [timerView setBackgroundColor:[UIColor colorWithRed:(57/255.0) green:(255/255.0) blue:(20/255.0) alpha:1.0]];
        //        [flashingTimer invalidate];
        flashingView.hidden = true;
    } else {
        [resetStartLabel setText:@"PAUSE"];
        isStart = YES;
        
        [playPauseButton setImage:[UIImage imageNamed:@"round_pause.png"] forState:UIControlStateNormal];
        isPlaying = YES;
        
        if ([mode caseInsensitiveCompare:@"DEFAULT"] == NSOrderedSame) {
            [self startTimerWithTime:[dataDict objectForKey:@"roundPrepTime"]];
        } else if ([mode caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame) {
            [self startTimerWithTime:roundPrepTime];
        } else if ([mode caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
            isPrepRunning = YES;
            [self startTimerWithTime:roundPrepTime];
        }
        [timerView setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(0/255.0) alpha:1.0]];
        //        [flashingTimer invalidate];
    }
}
-(IBAction)repsDoneButtonTapped:(id)sender {
    //    play the paused timer
    //    mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounterForStationEdit) userInfo:nil repeats:YES];
    playPauseButton.hidden = NO;
    repsDoneButton.hidden = YES;
    repsDoneView.hidden = YES;
    isPlaying = YES;
    [resetStartLabel setText:@"PAUSE"];
    isStart = YES;
    shouldPlayCountdown = YES;
    [flashingTimer invalidate];
    /*
     //    stationCount--;
     if (stationCount == 0 && roundCount > 0) {
     stationCount = (int)stationDict.count;
     //        roundCount--;
     if (roundCount == 0) {
     [mainTimer invalidate];
     timerLabel.text = @"00:00";
     timerTitleLabel.text = @"THE END";
     stationCountLabel.text = @"0";
     roundCountlabel.text = @"0";
     stationCount = 0;
     } else {
     [mainTimer invalidate];
     timerTitleLabel.text = @"ROUND PREP TIME";
     timerLabel.text = roundPrepTime;
     isPrepTime = YES;
     isPrepRunning = YES;
     [self startTimerWithTime:roundPrepTime];
     stage = 1;
     }
     } else if (stationCount > 0 && roundCount > 0) {
     [mainTimer invalidate];
     //        change this logic according to incTimrStn
     timerTitleLabel.text = @"WORKOUT TIME";
     timerLabel.text = [[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"onTime"];
     stage = 2;
     [self startTimerWithTime:[[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"onTime"]];
     } else if (stationCount > 0 && roundCount == 0) {
     [mainTimer invalidate];
     timerTitleLabel.text = @"WORKOUT TIME";
     timerLabel.text = [[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"onTime"];
     stage = 2;
     [self startTimerWithTime:[[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"onTime"]];
     } else if (stationCount == 0 && roundCount == 0) {
     [mainTimer invalidate];
     [mainTimer invalidate];
     timerLabel.text = @"00:00";
     timerTitleLabel.text = @"THE END";
     stationCountLabel.text = @"0";
     roundCountlabel.text = @"0";
     stationCount = 0;
     }*/
    
    /*
     //    [mainTimer invalidate];
     //    [self startTimerWithTime:[[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"offTime"]];
     timerLabel.text = [[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"offTime"];
     timerTitleLabel.text = @"REST TIME";
     
     //    NSString *timeStr = [[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"offTime"];
     //    NSArray *timeArray = [timeStr componentsSeparatedByString:@":"];
     //    int minutes = [[timeArray objectAtIndex:0] intValue];
     //    int seconds = [[timeArray objectAtIndex:1] intValue];
     //    maincounter = minutes*60 + seconds;
     stage = 2;
     maincounter = -1;
     [self incrementCounterForStationEdit];
     //    mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounterForStationEdit) userInfo:nil repeats:YES];
     
     //    stationCount--;
     //    stationCountValue++;
     //    if (stationCount == 0 && roundCount > 0) {
     //
     //        roundCount--;
     //        roundCountValue++;
     //
     //        mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounterForStationEdit) userInfo:nil repeats:YES];
     //
     //        stage = 0;
     //        if (roundCount == 0) {
     //            stage = 1;
     //            stationCountValue--;
     //            roundCountValue--;
     //        } else {
     //            stationCount = (int)stationDict.count;
     //            stationCountValue = 1;
     //        }
     //    } else {
     //        stage = 1;
     //    }
     */
    
    
    playPauseButton.hidden = NO;
    repsDoneButton.hidden = YES;
    repsDoneView.hidden = YES;
    //                [flashingTimer invalidate];
    
    //    [mainTimer invalidate];
    [self startTimerWithTime:[[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"offTime"]];
    timerLabel.text = [[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"offTime"];
    timerTitleLabel.text = @"REST TIME";
    stationCount--;
    stationCountValue++;
    if (stationCount == 0 && roundCount > 0) {
        
        roundCount--;
        roundCountValue++;
        stage = 0;
        if (roundCount == 0) {
            stage = 1;
            stationCountValue--;
            roundCountValue--;
        } else {
            stationCount = (int)stationDict.count;
            stationCountValue = 1;
        }
    } else {
        stage = 1;
    }
    
}
-(IBAction)home:(id)sender{
    //    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
    //        if (shouldPop) {
    //    HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
    //    [self.navigationController pushViewController:controller animated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            
            [self.navigationController  popToRootViewControllerAnimated:YES];
        }
    }];
    //        }
    //    }];
}
-(IBAction)motivaionButtonTapped:(UIButton *)sender {
    if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
        [volumeButton setImage:[UIImage imageNamed:@"vdo_sound.png"] forState:UIControlStateNormal];
        [defaults setObject:@"on" forKey:@"Motivation"];
        [defaults synchronize];
        if ([[defaults objectForKey:@"wasMusicPlaying"] boolValue]) {
            [appDelegate.mainAudioPlayer play];
        }
        [self startMusic];
    } else if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
        [volumeButton setImage:[UIImage imageNamed:@"vdo_mute.png"] forState:UIControlStateNormal];
        [defaults setObject:@"off" forKey:@"Motivation"];
        [defaults synchronize];
        [appDelegate.mainAudioPlayer pause];
        [self stopMusic];
    }
}
-(IBAction)voiceOverButtonTapped:(UIButton *)sender {
    
    /* if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
     [voiceOverButton setImage:[UIImage imageNamed:@"vdo_soundVO.png"] forState:UIControlStateNormal];
     [defaults setObject:@"on" forKey:@"Voice Over"];
     [defaults synchronize];
     } else if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
     [voiceOverButton setImage:[UIImage imageNamed:@"vdo_muteVO.png"] forState:UIControlStateNormal];
     [defaults setObject:@"off" forKey:@"Voice Over"];
     [defaults synchronize];
     }*/
    
    if (sender.isSelected){
        sender.selected = false;
        [defaults setObject:@"on" forKey:@"Voice Over"];
        [defaults synchronize];
        //        if (audioPlayer && !audioPlayer.isPlaying) {
        //            [audioPlayer play];
        //        }
        //        if ([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
        //            playVoiceOverforYoga = true;
        //        }
        
    }else{
        sender.selected = true;
        [defaults setObject:@"off" forKey:@"Voice Over"];
        [defaults synchronize];
        //        if (audioPlayer && audioPlayer.isPlaying) {
        //            [audioPlayer pause];
        //        }
        //        if ([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
        //            playVoiceOverforYoga = false;
        //        }
        
    }//AY 11122017
    
    
}
-(IBAction)bellButtonTapped:(UIButton *)sender {
    /*if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
     [bellButton setImage:[UIImage imageNamed:@"vdo_bell.png"] forState:UIControlStateNormal];
     [defaults setObject:@"on" forKey:@"Bell"];
     [defaults synchronize];
     } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
     [bellButton setImage:[UIImage imageNamed:@"vdo_no_bell.png"] forState:UIControlStateNormal];
     [defaults setObject:@"off" forKey:@"Bell"];
     [defaults synchronize];
     }*/
    
    if (sender.isSelected){
        sender.selected = false;
        [defaults setObject:@"on" forKey:@"Bell"];
        [defaults synchronize];
        
        //        if ([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
        //            playBuzzforYoga = true;
        //
        //        }
        
    }else{
        sender.selected = true;
        [defaults setObject:@"off" forKey:@"Bell"];
        [defaults synchronize];
        
        //        if ([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
        //            playBuzzforYoga = false;
        //        }
        
    }//AY 11122017
}
-(void)stopMusic{
    if (![Utility isEmptyCheck:[defaults objectForKey:@"mediaItemCollection"]] && [MPMusicPlayerController systemMusicPlayer].currentPlaybackRate == 1) {
        [[MPMusicPlayerController systemMusicPlayer] pause];
        [defaults setBool:true forKey:@"keepCircuitMusicPlaying"];
        return;
    }else if(![Utility isEmptyCheck:[defaults objectForKey:@"selectedSpotifyCollectionUri"]] && [[SPTAudioStreamingController sharedInstance] initialized] && [SPTAudioStreamingController sharedInstance].playbackState.isPlaying){
        [[SPTAudioStreamingController sharedInstance] setIsPlaying:NO callback:nil];
        [defaults setBool:true forKey:@"keepCircuitMusicPlaying"];
        return;
    }
    [defaults setBool:false forKey:@"keepCircuitMusicPlaying"];
    [defaults synchronize];
}
-(void) startMusic {
    if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame && [[defaults objectForKey:@"Inbetween Rounds"] caseInsensitiveCompare:@"STOPS PLAYING"] != NSOrderedSame) {
        NSLog(@"%ld",(long)[MPMusicPlayerController systemMusicPlayer].currentPlaybackRate);
        if (![Utility isEmptyCheck:[defaults objectForKey:@"mediaItemCollection"]] && [MPMusicPlayerController systemMusicPlayer].currentPlaybackRate == 0) {
            [[MPMusicPlayerController systemMusicPlayer] play];
        }else if(![Utility isEmptyCheck:[defaults objectForKey:@"selectedSpotifyCollectionUri"]] && [[SPTAudioStreamingController sharedInstance] initialized] && ![SPTAudioStreamingController sharedInstance].playbackState.isPlaying){
            NSLog(@"------%@",[SPTAudioStreamingController sharedInstance]);
            [[SPTAudioStreamingController sharedInstance] setIsPlaying:YES callback:nil];
        }
    }
}
- (IBAction)myMusicPressed:(UIButton *)sender {
    SettingsViewController *mController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Settings"];
    mController.delegate = self;
    mController.circuitPlaying = true;
    [self.navigationController pushViewController:mController animated:YES];
}
#pragma mark - PrivateMethod
-(void)updateFooter{
    if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
        [volumeButton setImage:[UIImage imageNamed:@"vdo_mute.png"] forState:UIControlStateNormal];
    } else if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
        [volumeButton setImage:[UIImage imageNamed:@"vdo_sound.png"] forState:UIControlStateNormal];
    }

    if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame){
        voiceOverButton.selected = true;
    }else{
        voiceOverButton.selected = false;
    }

    if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"off"] == NSOrderedSame){
        bellButton.selected = true;
    }else{
        bellButton.selected = false;
    }
}
-(void)startTimerWithTime:(NSString *)timeStr {
    //    stationCountLabel.text = [NSString stringWithFormat:@"%d",stationCount];
    //    roundCountlabel.text = [NSString stringWithFormat:@"%d",roundCount];
    //chch
    
    if (stage == 2) {
        //off
        [flashingTimer invalidate];
        flashingCount = 0;
        flashingView.hidden = YES;
        [timerView setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(0/255.0) alpha:1.0]];
    } else if (stage == 1) {
        //on
        [timerView setBackgroundColor:[UIColor colorWithRed:(57/255.0) green:(255/255.0) blue:(20/255.0) alpha:1.0]];
        flashingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(flashCounter) userInfo:nil repeats:YES];
    } else if (stage == 0) {
        //prep
        [flashingTimer invalidate];
        flashingCount = 0;
        flashingView.hidden = YES;
        [timerView setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(165/255.0) blue:(0/255.0) alpha:1.0]];
    }
    
    NSArray *timeArray = [timeStr componentsSeparatedByString:@":"];
    int minutes = [[timeArray objectAtIndex:0] intValue];
    int seconds = [[timeArray objectAtIndex:1] intValue];
    maincounter = minutes*60 + seconds;
    totalTime = maincounter;
    
    if ([mode caseInsensitiveCompare:@"DEFAULT"] == NSOrderedSame) {
        mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
    } else if ([mode caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame) {
        mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounterForRoundEdit) userInfo:nil repeats:YES];
    } else if ([mode caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
        roundKey = [NSString stringWithFormat:@"round%d",(int)stationEditdataDict.count-roundCount];
        
        if (!isPrepRunning) {
            int reps = [[[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"reps"] intValue];
            if (stage != 1) {
                reps = 0;
            }
            if (reps > 0) {
                [mainTimer invalidate];
                isPlaying = NO;
                timerLabel.text = [[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"reps"];
                timerTitleLabel.text = @"REPS";
                playPauseButton.hidden = YES;
                repsDoneButton.hidden = NO;
                repsDoneView.hidden = NO;
            } else {
                playPauseButton.hidden = NO;
                repsDoneButton.hidden = YES;
                repsDoneView.hidden = YES;
                //                [flashingTimer invalidate];
                mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounterForStationEdit) userInfo:nil repeats:YES];
                
            }
        } else {
            playPauseButton.hidden = NO;
            repsDoneButton.hidden = YES;
            repsDoneView.hidden = YES;
            [flashingTimer invalidate];
            mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounterForStationEdit) userInfo:nil repeats:YES];
        }
    }
    
    
}
-(void)incrementCounter {
    maincounter--;
    int minute = (maincounter % 3600) / 60;
    int second = (maincounter %3600) % 60;
    timerLabel.text = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    if ((shouldPlayCountdown || newShouldPlayCountdown) && maincounter == 1) {
        if (shouldPlayCountdown) {
            //            [self playAudioWithName:@"countdown5" Extension:@"mp3"];
            shouldPlayCountdown = false;
        }
        if ([roundFinishState caseInsensitiveCompare:@"start"] == NSOrderedSame) {
            //aanew
            if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                roundFinishState = @"finish";
            } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //                    [self playBipAudioWithName:@"Door Buzzer" Extension:@"wav"];
                });
            }
            
        }
        
        //aanew
        //        NSLog(@"rcv %d -- rc %d",roundCountValue,roundCount);
        /*  if ([timerTitleLabel.text caseInsensitiveCompare:@"OFF TIME"] == NSOrderedSame) {
         if (roundCount == 1) {
         //            endOfRoundState = @"finished";
         //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
         [self playAudioWithName:@"Last Round Coming Up 2" Extension:@"wav"];
         endOfRoundState = @"";
         //            }
         roundFinishState = @"";
         } else if (roundCountValue == 2) {
         //            roundEndOfRoundState = @"r1finished";
         //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
         [self playAudioWithName:@"Round 1 Down, Great Start!" Extension:@"wav"];
         roundEndOfRoundState = @"";
         //            }
         roundFinishState = @"";
         } else if (roundCountValue == 3) {
         //            roundEndOfRoundState = @"r2finished";
         //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
         [self playAudioWithName:@"Round Complete Youre Doing So Well" Extension:@"wav"];    //Round 2 complete, you're doing so well
         roundEndOfRoundState = @"";
         //            }
         roundFinishState = @"";
         }
         newShouldPlayCountdown = false;
         }*/
        //end aanew
    }
    
    
    //bb
    if ([timerTitleLabel.text caseInsensitiveCompare:@"ROUND PREP TIME"] == NSOrderedSame && maincounter == totalTime-1) {
        if (roundCount == 1) {
            //            endOfRoundState = @"finished";
            //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
            [self playAudioWithName:@"Last Round Coming Up 2" Extension:@"wav"];
            endOfRoundState = @"";
            //            }
            roundFinishState = @"";
        } else if (roundCountValue == 2) {
            //            roundEndOfRoundState = @"r1finished";
            //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
            [self playAudioWithName:@"Round 1 Down, Great Start!" Extension:@"wav"];
            roundEndOfRoundState = @"";
            //            }
            roundFinishState = @"";
        } else if (roundCountValue == 3) {
            //            roundEndOfRoundState = @"r2finished";
            //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
            [self playAudioWithName:@"Round Complete Youre Doing So Well" Extension:@"wav"];    //Round 2 complete, you're doing so well
            roundEndOfRoundState = @"";
            //            }
            roundFinishState = @"";
        }
        newShouldPlayCountdown = false;
    }
    if ([timerTitleLabel.text caseInsensitiveCompare:@"ROUND PREP TIME"] == NSOrderedSame){
        //suchandra 4/1/17
        if (isFirstLoad) {
            if (isHighVolume || wasPlaying) {
                isFirstLoad=false;
                [self inBetweenRoundControll];
            }
            
        }
    }
    
    
    //end bb
    
    
    //aanew motivation
    if ([timerTitleLabel.text caseInsensitiveCompare:@"ON TIME"] == NSOrderedSame) {
        if (maincounter == roundf(totalTime/2)) {
            if (maincounter > 12) {
                if (shouldPlaySaying && sayingRoundNo == roundCountValue && sayingStationNo == stationCountValue) {     //saying
                    NSMutableArray *newSayingArray = [[NSMutableArray alloc]init];
                    int remainingTime = maincounter - 10;
                    for (int i = 0; i < sayingArray.count; i++) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict addEntriesFromDictionary:[sayingArray objectAtIndex:i]];
                        int duration = [[dict objectForKey:@"duration"] intValue];
                        if (remainingTime > duration) {
                            [dict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"index"];
                            [newSayingArray addObject:dict];
                            //                            [sayingArray removeObjectAtIndex:i];
                        }
                    }
                    if (newSayingArray.count > 0) {
                        NSUInteger randomIndex = arc4random_uniform((int)(newSayingArray.count-1));  //arc4random() % [newMotivationArray count];
                        [self playAudioWithName:[[newSayingArray objectAtIndex:randomIndex] objectForKey:@"name"] Extension:@"wav"];
                        shouldPlaySaying = false;
                        [sayingArray removeObjectAtIndex:[[[newSayingArray objectAtIndex:randomIndex] objectForKey:@"index"] intValue]];
                    }
                } else {
                    NSMutableArray *newMotivationArray = [[NSMutableArray alloc]init];
                    int remainingTime = maincounter - 10;
                    for (int i = 0; i < motivationArray.count; i++) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict addEntriesFromDictionary:[motivationArray objectAtIndex:i]];
                        int duration = [[dict objectForKey:@"duration"] intValue];
                        if (remainingTime > duration) {
                            [dict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"index"];
                            [newMotivationArray addObject:dict];
                            //                            [motivationArray removeObjectAtIndex:i];
                        }
                    }
                    if (newMotivationArray.count > 0) {
                        NSUInteger randomIndex = arc4random_uniform((int)(newMotivationArray.count-1));  //arc4random() % [newMotivationArray count];
                        [self playAudioWithName:[[newMotivationArray objectAtIndex:randomIndex] objectForKey:@"name"] Extension:@"wav"];
                        [motivationArray removeObjectAtIndex:[[[newMotivationArray objectAtIndex:randomIndex] objectForKey:@"index"] intValue]];
                        //                        NSLog(@"nma %@ - %lu",newMotivationArray,(unsigned long)randomIndex);
                    }
                }
            }
        }
        
        if (totalTime < 11) {
            if (totalTime < 6) {
                shuffleOnTimeCountdown = 0;
            } else {
                if (shuffleOnTimeCountdown == 2) {
                    shuffleOnTimeCountdown = 1;
                }
            }
        }
        //        NSLog(@"sot %d",shuffleOnTimeCountdown);
        if (maincounter == 10 && shuffleOnTimeCountdown == 2 && !isshuffleOnCountdownPlayed) {
            [self playAudioWithName:@"TEN SECONDS TO GO 1" Extension:@"mp3"];
            shuffleOnTimeCountdown--;
            isshuffleOnCountdownPlayed = YES;
        } else if (maincounter == 6 && shuffleOnTimeCountdown == 1 && !isshuffleOnCountdownPlayed) {
            [self playAudioWithName:@"countdown5" Extension:@"mp3"];
            shuffleOnTimeCountdown--;
            isshuffleOnCountdownPlayed = YES;
        } else if (maincounter == 3 && shuffleOnTimeCountdown == 0 && !isshuffleOnCountdownPlayed) {
            [self playAudioWithName:@"countdownVoice" Extension:@"mp3"];
            shuffleOnTimeCountdown = 2;
            isshuffleOnCountdownPlayed = YES;
        }
    }
    //end aanew motivation
    
    
    if (![defaults objectForKey:@"Motivation"] || [[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] || [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] != NSOrderedSame) {
        [appDelegate.mainAudioPlayer pause];
    } else  if ([[defaults objectForKey:@"wasMusicPlaying"] boolValue] && [defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame&& wasPlaying) {
        [appDelegate.mainAudioPlayer play];
    }
    
    //aanew
    if ([[dataDict objectForKey:@"offTime"] caseInsensitiveCompare:@"00:00"] == NSOrderedSame && stage == 2 && maincounter < 1) {
        [flashingTimer invalidate];
        flashingCount = 0;
        flashingView.hidden = YES;
        stage = 1;
        stationCount--;
        stationCountValue++;
        if (stationCount == 0 && roundCount > 0) {
            
            roundCount--;
            roundCountValue++;
            if (roundCount == 0) {
                stage = 1;
                stationCountValue--;
                roundCountValue--;
            } else {
                stage = 0;
                stationCount = [[dataDict objectForKey:@"stationCount"] intValue];
                stationCountValue = 1;
                
                if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                    roundFinishState = @"start";
                } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame){
                    roundFinishState = @"start";
                }
            }
            newShouldPlayCountdown = true;
        }
    }
    //end aanew
    
    if (maincounter < 1) {//aanew
        
        isshuffleOnCountdownPlayed = NO;
        if (stage == 1) {
            [mainTimer invalidate];
            
            
            if (isPrepTime) {
                isPrepTime = NO;
                [mainTimer invalidate];
                [self startTimerWithTime:[dataDict objectForKey:@"onTime"]];
                timerTitleLabel.text = @"WORKOUT TIME";
                timerLabel.text = [dataDict objectForKey:@"onTime"];
                stage = 2;
                
                //shuffleOnTimeCountdown = arc4random_uniform(3);
            } else {
                //                stationCount--;
                if (stationCount == 0 && roundCount > 0) {
                    //                    stationCount = [[dataDict objectForKey:@"stationCount"] intValue];
                    //                    roundCount--;
                    if (roundCount == 0) {
                        [mainTimer invalidate];
                        [sessionTimer invalidate];
                        [self sessionCounter];  //aanew
                        timerLabel.text = @"00:00";
                        timerTitleLabel.text = @"THE END";
                        stationCountLabel.text = @"0";
                        roundCountlabel.text = @"0";
                        stationCount = 0;
                        if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                            [self playAudioWithName:@"End of Circuit" Extension:@"wav"];
                        } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame){
                            [self playBipAudioWithName:@"Air_Horn" Extension:@"wav"];
                        }
                    } else {
                        [mainTimer invalidate];
                        [self startTimerWithTime:[dataDict objectForKey:@"roundPrepTime"]];
                        timerTitleLabel.text = @"ROUND PREP TIME";
                        //suchandra 4/1/17
                        if (isHighVolume || wasPlaying) {
                            [self inBetweenRoundControll];
                        }
                        //
                        timerLabel.text = [dataDict objectForKey:@"roundPrepTime"];
                        stage = 1;
                        isPrepTime = YES;
                        
                        if (([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) && roundCount > 0 && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame)) {
                            [self playBipAudioWithName:@"Air_Horn" Extension:@"wav"];
                        }
                    }
                } else if (stationCount > 0 && roundCount > 0) {
                    [mainTimer invalidate];
                    [self startTimerWithTime:[dataDict objectForKey:@"onTime"]];
                    timerTitleLabel.text = @"WORKOUT TIME";
                    timerLabel.text = [dataDict objectForKey:@"onTime"];
                    stage = 2;
                    //shuffleOnTimeCountdown = arc4random_uniform(3);
                } else if (stationCount > 0 && roundCount == 0) {
                    [mainTimer invalidate];
                    [self startTimerWithTime:[dataDict objectForKey:@"onTime"]];
                    timerTitleLabel.text = @"WORKOUT TIME";
                    timerLabel.text = [dataDict objectForKey:@"onTime"];
                    stage = 2;
                    //shuffleOnTimeCountdown = arc4random_uniform(3);
                } else if (stationCount == 0 && roundCount == 0) {
                    [mainTimer invalidate];
                    [mainTimer invalidate];
                    [sessionTimer invalidate];
                    [self sessionCounter];  //aanew
                    timerLabel.text = @"00:00";
                    timerTitleLabel.text = @"THE END";
                    stationCountLabel.text = @"0";
                    roundCountlabel.text = @"0";
                    stationCount = 0;
                    if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                        [self playAudioWithName:@"End of Circuit" Extension:@"wav"];
                    } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame){
                        [self playBipAudioWithName:@"Air_Horn" Extension:@"wav"];
                    }
                }
            }
            if (!isPrepTime && (![defaults objectForKey:@"Voice Over"] || [[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] || [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame) && roundCount > 0) {
                [self playBipAudioWithName:@"Car-Horn" Extension:@"mp3"];
            } else if (!isPrepTime && ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) && roundCount > 0 && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame) && !appDelegate.mainAudioPlayer.isPlaying) {
                //                [self playAudioWithName:@"Lets Go" Extension:@"wav"]; //aanew
                [self playAudioWithName:@"Car-Horn" Extension:@"mp3"];
                isLetsGoPlayed = YES;
            }
            if (!isHighVolume || !wasPlaying) {
                [self inBetweenRoundControll];
            }
            stationCountLabel.text = [NSString stringWithFormat:@"%d",stationCountValue];
            roundCountlabel.text = [NSString stringWithFormat:@"%d",roundCountValue];
        } else if (stage == 2) {
            [mainTimer invalidate];
            [self startTimerWithTime:[dataDict objectForKey:@"offTime"]];
            timerLabel.text = [dataDict objectForKey:@"offTime"];
            timerTitleLabel.text = @"REST TIME";
            shouldPlayCountdown = true;
            stage = 1;
            stationCount--;
            stationCountValue++;
            if (stationCount == 0 && roundCount > 0) {
                
                roundCount--;
                roundCountValue++;
                if (roundCount == 0) {
                    stage = 1;
                    stationCountValue--;
                    roundCountValue--;
                } else {
                    stage = 0;
                    stationCount = [[dataDict objectForKey:@"stationCount"] intValue];
                    stationCountValue = 1;
                    if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                        roundFinishState = @"start";
                    } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame){
                        roundFinishState = @"start";
                    }
                }
                //                roundFinishState = @"start";    //aanew
            }
            if ((![defaults objectForKey:@"Voice Over"] || [[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] || [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame)) {
                [self playBipAudioWithName:@"Buzzer-Sound" Extension:@"mp3"];
            } else if (([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame)) {
                [self playAudioWithName:@"Rest" Extension:@"mp3"]; //aanew
            }
            if (isHighVolume || wasPlaying) {
                [self inBetweenRoundControll];
            }
        } else if (stage == 0) {
            [mainTimer invalidate];
            [self startTimerWithTime:[dataDict objectForKey:@"roundPrepTime"]];
            timerLabel.text = [dataDict objectForKey:@"roundPrepTime"];
            timerTitleLabel.text = @"ROUND PREP TIME";
            stage++;
            isPrepTime = YES;
            //            if (!isHighVolume || !wasPlaying) {
            //                [self inBetweenRoundControll];
            //            }
            //suchandra 4/1/17
            if (isHighVolume || wasPlaying) {
                //                NSLog(@"vv %f",appDelegate.mainAudioPlayer.volume);
                if (appDelegate.mainAudioPlayer.volume > 0.5) {
                    [self inBetweenRoundControll];
                }
            }
            //
            stationCountLabel.text = [NSString stringWithFormat:@"%d",stationCountValue];
            roundCountlabel.text = [NSString stringWithFormat:@"%d",roundCountValue];
            
            if (([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) && roundCount > 0 && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame)) {
                [self playBipAudioWithName:@"Air_Horn" Extension:@"wav"];
            }
        }
    }
    //    stationCountLabel.text = [NSString stringWithFormat:@"%d",stationCount];
    //    roundCountlabel.text = [NSString stringWithFormat:@"%d",roundCount];
    
    //    stationCountLabel.text = [NSString stringWithFormat:@"%d",stationCountValue];
    //    roundCountlabel.text = [NSString stringWithFormat:@"%d",roundCountValue];
}

-(void)incrementCounterForRoundEdit {
    maincounter--;
    int minute = (maincounter % 3600) / 60;
    int second = (maincounter %3600) % 60;
    timerLabel.text = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    
    if ((shouldPlayCountdown || newShouldPlayCountdown) && maincounter == 1) {
        if (shouldPlayCountdown) {
            //            [self playAudioWithName:@"countdown5" Extension:@"wav"];
            shouldPlayCountdown = false;
        }
        newShouldPlayCountdown = false;
        if ([roundFinishState caseInsensitiveCompare:@"start"] == NSOrderedSame) {
            if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                roundFinishState = @"finish";
            } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //                    [self playBipAudioWithName:@"Door Buzzer" Extension:@"wav"];
                });
            }
        }
        //aanew
        //        NSLog(@"rcv %d -- rc %d",roundCountValue,roundCount);
        //        if (roundCount == 1) {
        //            endOfRoundState = @"finished";
        //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
        //                [self playAudioWithName:@"Last Round Coming Up 2" Extension:@"wav"];
        //                endOfRoundState = @"";
        //            }
        //            roundFinishState = @"";
        //        } else if (roundCountValue == 2) {
        //            roundEndOfRoundState = @"r1finished";
        //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
        //                [self playAudioWithName:@"Round 1 Down, Great Start!" Extension:@"wav"];
        //                roundEndOfRoundState = @"";
        //            }
        //            roundFinishState = @"";
        //        } else if (roundCountValue == 3) {
        //            roundEndOfRoundState = @"r2finished";
        //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
        //                [self playAudioWithName:@"Round Complete Youre Doing So Well" Extension:@"wav"];    //Round 2 complete, you're doing so well
        //                roundEndOfRoundState = @"";
        //            }
        //            roundFinishState = @"";
        //        }
        //        newShouldPlayCountdown = false;
        //end aanew
    }
    
    //bb
    if ([timerTitleLabel.text caseInsensitiveCompare:@"ROUND PREP TIME"] == NSOrderedSame && maincounter == totalTime-1) {
        if (roundCount == 1) {
            //            endOfRoundState = @"finished";
            //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
            [self playAudioWithName:@"Last Round Coming Up 2" Extension:@"wav"];
            endOfRoundState = @"";
            //            }
            roundFinishState = @"";
        } else if (roundCountValue == 2) {
            //            roundEndOfRoundState = @"r1finished";
            //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
            [self playAudioWithName:@"Round 1 Down, Great Start!" Extension:@"wav"];
            roundEndOfRoundState = @"";
            //            }
            roundFinishState = @"";
        } else if (roundCountValue == 3) {
            //            roundEndOfRoundState = @"r2finished";
            //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
            [self playAudioWithName:@"Round Complete Youre Doing So Well" Extension:@"wav"];    //Round 2 complete, you're doing so well
            roundEndOfRoundState = @"";
            //            }
            roundFinishState = @"";
        }
        newShouldPlayCountdown = false;
    }
    if ([timerTitleLabel.text caseInsensitiveCompare:@"ROUND PREP TIME"] == NSOrderedSame){
        //suchandra 4/1/17
        if (isFirstLoadRoundEdit) {
            if (isHighVolume || wasPlaying) {
                isFirstLoadRoundEdit=false;
                [self inBetweenRoundControll];
            }
        }
    }
    //end bb
    
    //aanew motivation
    if ([timerTitleLabel.text caseInsensitiveCompare:@"ON TIME"] == NSOrderedSame) {
        if (maincounter == roundf(totalTime/2)) {
            if (maincounter > 12) {
                if (shouldPlaySaying && sayingRoundNo == roundCountValue-1 && sayingStationNo == stationCountValue) {     //saying
                    NSMutableArray *newSayingArray = [[NSMutableArray alloc]init];
                    int remainingTime = maincounter - 10;
                    for (int i = 0; i < sayingArray.count; i++) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict addEntriesFromDictionary:[sayingArray objectAtIndex:i]];
                        int duration = [[dict objectForKey:@"duration"] intValue];
                        if (remainingTime > duration) {
                            [dict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"index"];
                            [newSayingArray addObject:dict];
                            //                            [sayingArray removeObjectAtIndex:i];
                        }
                    }
                    if (newSayingArray.count > 0) {
                        NSUInteger randomIndex = arc4random_uniform((int)(newSayingArray.count-1));  //arc4random() % [newMotivationArray count];
                        [self playAudioWithName:[[newSayingArray objectAtIndex:randomIndex] objectForKey:@"name"] Extension:@"wav"];
                        shouldPlaySaying = false;
                        [sayingArray removeObjectAtIndex:[[[newSayingArray objectAtIndex:randomIndex] objectForKey:@"index"] intValue]];
                    }
                } else {
                    NSMutableArray *newMotivationArray = [[NSMutableArray alloc]init];
                    int remainingTime = maincounter - 10;
                    for (int i = 0; i < motivationArray.count; i++) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict addEntriesFromDictionary:[motivationArray objectAtIndex:i]];
                        int duration = [[dict objectForKey:@"duration"] intValue];
                        if (remainingTime > duration) {
                            [dict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"index"];
                            [newMotivationArray addObject:dict];
                            //                            [motivationArray removeObjectAtIndex:i];
                        }
                    }
                    if (newMotivationArray.count > 0) {
                        NSUInteger randomIndex = arc4random_uniform((int)(newMotivationArray.count-1));  //arc4random() % [newMotivationArray count];
                        [self playAudioWithName:[[newMotivationArray objectAtIndex:randomIndex] objectForKey:@"name"] Extension:@"wav"];
                        [motivationArray removeObjectAtIndex:[[[newMotivationArray objectAtIndex:randomIndex] objectForKey:@"index"] intValue]];
                    }
                }
            }
        }
        
        if (totalTime < 11) {
            if (totalTime < 6) {
                shuffleOnTimeCountdown = 0;
            } else {
                if (shuffleOnTimeCountdown == 2) {
                    shuffleOnTimeCountdown = 1;
                }
            }
        }
        //        NSLog(@"sot %d",shuffleOnTimeCountdown);
        if (maincounter == 10 && shuffleOnTimeCountdown == 2 && !isshuffleOnCountdownPlayed) {
            [self playAudioWithName:@"TEN SECONDS TO GO 1" Extension:@"mp3"];
            shuffleOnTimeCountdown--;
            isshuffleOnCountdownPlayed = YES;
        } else if (maincounter == 6 && shuffleOnTimeCountdown == 1 && !isshuffleOnCountdownPlayed) {
            [self playAudioWithName:@"countdown5" Extension:@"mp3"];
            shuffleOnTimeCountdown--;
            isshuffleOnCountdownPlayed = YES;
        } else if (maincounter == 3 && shuffleOnTimeCountdown == 0 && !isshuffleOnCountdownPlayed) {
            [self playAudioWithName:@"countdownVoice" Extension:@"mp3"];
            shuffleOnTimeCountdown = 2;
            isshuffleOnCountdownPlayed = YES;
        }
    }
    //end aanew motivation
    
    if (![defaults objectForKey:@"Motivation"] || [[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] || [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] != NSOrderedSame) {
        [appDelegate.mainAudioPlayer pause];
        //suchandra 2/1/17
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isMusicPaused"];
        //
        
    } else  if ([[defaults objectForKey:@"wasMusicPlaying"] boolValue] && [defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame&& wasPlaying) {
        [appDelegate.mainAudioPlayer play];
        
        //suchandra 2/1/17
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isMusicPaused"];
        //
        
    }
    
    //aanew
    if (roundCount > 0) {
        if ([[[[roundEditDataDict objectForKey:@"round"] objectAtIndex:((int)roundArray.count - roundCount)] objectForKey:@"offTime"] caseInsensitiveCompare:@"00:00"] == NSOrderedSame && stage == 2 && maincounter < 1) {
            [flashingTimer invalidate];
            flashingCount = 0;
            flashingView.hidden = YES;
            stage = 1;
            stationCount--;
            stationCountValue++;
            if (stationCount == 0 && roundCount > 0) {
                
                roundCount--;
                roundCountValue++;
                if (roundCount == 0) {
                    stage = 1;
                    stationCountValue--;
                    roundCountValue--;
                } else {
                    stage = 0;
                    stationCount = [[roundEditDataDict objectForKey:@"station"] intValue];
                    stationCountValue = 1;
                    if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                        roundFinishState = @"start";
                    } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame){
                        roundFinishState = @"start";
                    }
                }
            }
        }
    }
    //end aanew
    
    if (maincounter < 1) {
        
        isshuffleOnCountdownPlayed = NO;
        if (stage == 1) {
            [mainTimer invalidate];
            
            if (isPrepTime) {
                isPrepTime = NO;
                [mainTimer invalidate];
                [self startTimerWithTime:[[[roundEditDataDict objectForKey:@"round"] objectAtIndex:((int)roundArray.count - roundCount)] objectForKey:@"onTime"]];
                timerTitleLabel.text = @"WORKOUT TIME";
                timerLabel.text = [[[roundEditDataDict objectForKey:@"round"] objectAtIndex:((int)roundArray.count - roundCount)] objectForKey:@"onTime"];
                stage = 2;
                //shuffleOnTimeCountdown = arc4random_uniform(3);
            } else {
                //                stationCount--;
                if (stationCount == 0 && roundCount > 0) {
                    //                    stationCount = [[roundEditDataDict objectForKey:@"station"] intValue];
                    //                    roundCount--;
                    //                    stage = 0;
                    if (roundCount == 0) {
                        [mainTimer invalidate];
                        [sessionTimer invalidate];
                        timerLabel.text = @"00:00";
                        [self sessionCounter];  //aanew
                        timerTitleLabel.text = @"THE END";
                        stationCountLabel.text = @"0";
                        roundCountlabel.text = @"0";
                        stationCount = 0;
                        if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                            [self playAudioWithName:@"End of Circuit" Extension:@"wav"];
                        } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame){
                            [self playBipAudioWithName:@"Air_Horn" Extension:@"wav"];
                        }
                    } else {
                        [mainTimer invalidate];
                        [self startTimerWithTime:roundPrepTime];
                        timerTitleLabel.text = @"ROUND PREP TIME";
                        //suchandra 4/1/17
                        if (isHighVolume || wasPlaying) {
                            [self inBetweenRoundControll];
                        }
                        //
                        timerLabel.text = roundPrepTime;
                        stage = 1;
                        isPrepTime = YES;
                        
                        if (([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) && roundCount > 0 && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame)) {
                            [self playBipAudioWithName:@"Air_Horn" Extension:@"wav"];
                        }
                    }
                } else if (stationCount > 0 && roundCount > 0) {
                    [mainTimer invalidate];
                    [self startTimerWithTime:[[[roundEditDataDict objectForKey:@"round"] objectAtIndex:((int)roundArray.count - roundCount)] objectForKey:@"onTime"]];
                    timerTitleLabel.text = @"WORKOUT TIME";
                    timerLabel.text = [[[roundEditDataDict objectForKey:@"round"] objectAtIndex:((int)roundArray.count - roundCount)] objectForKey:@"onTime"];
                    stage = 2;
                    //                stationCount--;
                    //shuffleOnTimeCountdown = arc4random_uniform(3);
                } else if (stationCount > 0 && roundCount == 0) {
                    [mainTimer invalidate];
                    [self startTimerWithTime:[[[roundEditDataDict objectForKey:@"round"] objectAtIndex:((int)roundArray.count - roundCount)] objectForKey:@"onTime"]];
                    timerTitleLabel.text = @"WORKOUT TIME";
                    timerLabel.text = [[[roundEditDataDict objectForKey:@"round"] objectAtIndex:((int)roundArray.count - roundCount)] objectForKey:@"onTime"];
                    stage = 2;
                    //                stationCount--;
                    //shuffleOnTimeCountdown = arc4random_uniform(3);
                } else if (stationCount == 0 && roundCount == 0) {
                    [mainTimer invalidate];
                    [mainTimer invalidate];
                    [sessionTimer invalidate];
                    timerLabel.text = @"00:00";
                    [self sessionCounter];  //aanew
                    timerTitleLabel.text = @"THE END";
                    stationCountLabel.text = @"0";
                    roundCountlabel.text = @"0";
                    stationCount = 0;
                    if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                        [self playAudioWithName:@"End of Circuit" Extension:@"wav"];
                    } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame){
                        [self playBipAudioWithName:@"Air_Horn" Extension:@"wav"];
                    }
                }
            }
            if (!isPrepTime && (![defaults objectForKey:@"Voice Over"] || [[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] || [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame) && roundCount > 0) {
                [self playBipAudioWithName:@"Car-Horn" Extension:@"mp3"];
            } else if (!isPrepTime && ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) && roundCount > 0 && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame) && !appDelegate.mainAudioPlayer.isPlaying) {
                //                [self playAudioWithName:@"Lets Go" Extension:@"wav"]; //aanew
                [self playAudioWithName:@"Car-Horn" Extension:@"mp3"];
                isLetsGoPlayed = YES;
            }
            if (!isHighVolume || !wasPlaying) {
                [self inBetweenRoundControll];
            }
            stationCountLabel.text = [NSString stringWithFormat:@"%d",stationCountValue];
            roundCountlabel.text = [NSString stringWithFormat:@"%d",roundCountValue];
        } else if (stage == 2) {
            [mainTimer invalidate];
            [self startTimerWithTime:[[[roundEditDataDict objectForKey:@"round"] objectAtIndex:((int)roundArray.count - roundCount)] objectForKey:@"offTime"]];
            timerLabel.text = [[[roundEditDataDict objectForKey:@"round"] objectAtIndex:((int)roundArray.count - roundCount)] objectForKey:@"offTime"];
            timerTitleLabel.text = @"REST TIME";
            shouldPlayCountdown = true;
            stage = 1;
            stationCount--;
            stationCountValue++;
            if (stationCount == 0 && roundCount > 0) {
                
                roundCount--;
                roundCountValue++;
                stage = 0;
                if (roundCount == 0) {
                    stationCountValue--;
                    roundCountValue--;
                    stage = 1;
                } else {
                    stationCount = [[roundEditDataDict objectForKey:@"station"] intValue];
                    stationCountValue = 1;
                    if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                        roundFinishState = @"start";
                    } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame){
                        roundFinishState = @"start";
                    }
                }
            }
            if ((![defaults objectForKey:@"Voice Over"] || [[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] || [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame)) {
                [self playBipAudioWithName:@"Buzzer-Sound" Extension:@"mp3"];
            } else if (([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame)) {
                [self playAudioWithName:@"Rest" Extension:@"mp3"]; //aanew
            }
            if (isHighVolume || wasPlaying) {
                [self inBetweenRoundControll];
            }
        } else if (stage == 0) {
            [mainTimer invalidate];
            [self startTimerWithTime:roundPrepTime];
            timerLabel.text = roundPrepTime;
            timerTitleLabel.text = @"ROUND PREP TIME";
            stage++;
            isPrepTime = YES;
            //            if (!isHighVolume || !wasPlaying) {
            //                [self inBetweenRoundControll];
            //            }
            //suchandra 4/1/17
            if (isHighVolume || wasPlaying) {
                if (appDelegate.mainAudioPlayer.volume > 0.5) {
                    [self inBetweenRoundControll];
                }
                //                [self inBetweenRoundControll];
            }
            //
            stationCountLabel.text = [NSString stringWithFormat:@"%d",stationCountValue];
            roundCountlabel.text = [NSString stringWithFormat:@"%d",roundCountValue];
            
            if (([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) && roundCount > 0 && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame)) {
                [self playBipAudioWithName:@"Air_Horn" Extension:@"wav"];
            }
        }
        //        stage++;
    }
}

-(void)incrementCounterForStationEdit {
    maincounter--;
    int minute = (maincounter % 3600) / 60;
    int second = (maincounter %3600) % 60;
    timerLabel.text = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    
    if ((shouldPlayCountdown || newShouldPlayCountdown) && maincounter == 1) {
        if (shouldPlayCountdown) {
            //            [self playAudioWithName:@"countdown5" Extension:@"wav"];
            shouldPlayCountdown = false;
        }
        newShouldPlayCountdown = false;
        if ([roundFinishState caseInsensitiveCompare:@"start"] == NSOrderedSame) {
            if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                roundFinishState = @"finish";
            } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //                    [self playBipAudioWithName:@"Door Buzzer" Extension:@"wav"];
                });
            }
        }
        //aanew
        //        NSLog(@"rcv %d -- rc %d",roundCountValue,roundCount);
        //        if (roundCount == 1) {
        //            endOfRoundState = @"finished";
        //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
        //                [self playAudioWithName:@"Last Round Coming Up 2" Extension:@"wav"];
        //                endOfRoundState = @"";
        //            }
        //            roundFinishState = @"";
        //        } else if (roundCountValue == 2) {
        //            roundEndOfRoundState = @"r1finished";
        //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
        //                [self playAudioWithName:@"Round 1 Down, Great Start!" Extension:@"wav"];
        //                roundEndOfRoundState = @"";
        //            }
        //            roundFinishState = @"";
        //        } else if (roundCountValue == 3) {
        //            roundEndOfRoundState = @"r2finished";
        //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
        //                [self playAudioWithName:@"Round Complete Youre Doing So Well" Extension:@"wav"];    //Round 2 complete, you're doing so well
        //                roundEndOfRoundState = @"";
        //            }
        //            roundFinishState = @"";
        //        }
        //        newShouldPlayCountdown = false;
        //end aanew
    }
    
    //bb
    if ([timerTitleLabel.text caseInsensitiveCompare:@"ROUND PREP TIME"] == NSOrderedSame && maincounter == totalTime-1) {
        if (roundCount == 1) {
            //            endOfRoundState = @"finished";
            //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
            [self playAudioWithName:@"Last Round Coming Up 2" Extension:@"wav"];
            endOfRoundState = @"";
            //            }
            roundFinishState = @"";
        } else if (roundCountValue == 2) {
            //            roundEndOfRoundState = @"r1finished";
            //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
            [self playAudioWithName:@"Round 1 Down, Great Start!" Extension:@"wav"];
            roundEndOfRoundState = @"";
            //            }
            roundFinishState = @"";
        } else if (roundCountValue == 3) {
            //            roundEndOfRoundState = @"r2finished";
            //            if (!shouldPlayCountdown && newShouldPlayCountdown) {
            [self playAudioWithName:@"Round Complete Youre Doing So Well" Extension:@"wav"];    //Round 2 complete, you're doing so well
            roundEndOfRoundState = @"";
            //            }
            roundFinishState = @"";
        }
        newShouldPlayCountdown = false;
    }
    if ([timerTitleLabel.text caseInsensitiveCompare:@"ROUND PREP TIME"] == NSOrderedSame){
        //suchandra 4/1/17
        if (isFirstLoadStationEdit) {
            if (isHighVolume || wasPlaying) {
                isFirstLoadStationEdit=false;
                [self inBetweenRoundControll];
            }
        }
    }
    //end bb
    
    //aanew motivation
    //    NSLog(@"rr %f cc %f",roundf(totalTime/2),ceil(totalTime/2));
    if ([timerTitleLabel.text caseInsensitiveCompare:@"ON TIME"] == NSOrderedSame) {
        if (maincounter == roundf(totalTime/2)) {
            if (maincounter > 12) {
                if (shouldPlaySaying && sayingRoundNo == roundCountValue-1 && sayingStationNo == stationCountValue-1) {     //saying
                    NSMutableArray *newSayingArray = [[NSMutableArray alloc]init];
                    int remainingTime = maincounter - 10;
                    for (int i = 0; i < sayingArray.count; i++) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict addEntriesFromDictionary:[sayingArray objectAtIndex:i]];
                        
                        int duration = [[dict objectForKey:@"duration"] intValue];
                        //                        NSLog(@"dur %d , rt %d",duration,remainingTime);
                        if (remainingTime > duration) {
                            [dict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"index"];
                            [newSayingArray addObject:dict];
                            //                            [sayingArray removeObjectAtIndex:i];
                        }
                    }
                    //                    NSLog(@"nsa %@",newSayingArray);
                    if (newSayingArray.count > 0) {
                        NSUInteger randomIndex = arc4random_uniform((int)(newSayingArray.count-1));  //arc4random() % [newMotivationArray count];
                        [self playAudioWithName:[[newSayingArray objectAtIndex:randomIndex] objectForKey:@"name"] Extension:@"wav"];
                        shouldPlaySaying = false;
                        [sayingArray removeObjectAtIndex:[[[newSayingArray objectAtIndex:randomIndex] objectForKey:@"index"] intValue]];
                    }
                } else {
                    NSMutableArray *newMotivationArray = [[NSMutableArray alloc]init];
                    int remainingTime = maincounter - 10;
                    for (int i = 0; i < motivationArray.count; i++) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict addEntriesFromDictionary:[motivationArray objectAtIndex:i]];
                        int duration = [[dict objectForKey:@"duration"] intValue];
                        if (remainingTime > duration) {
                            [dict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"index"];
                            [newMotivationArray addObject:dict];
                            //                            [motivationArray removeObjectAtIndex:i];
                        }
                    }
                    if (newMotivationArray.count > 0) {
                        NSUInteger randomIndex = arc4random_uniform((int)(newMotivationArray.count-1));  //arc4random() % [newMotivationArray count];
                        [self playAudioWithName:[[newMotivationArray objectAtIndex:randomIndex] objectForKey:@"name"] Extension:@"wav"];
                        [motivationArray removeObjectAtIndex:[[[newMotivationArray objectAtIndex:randomIndex] objectForKey:@"index"] intValue]];
                    }
                }
            }
        }
        
        if (totalTime < 11) {
            if (totalTime < 6) {
                shuffleOnTimeCountdown = 0;
            } else {
                if (shuffleOnTimeCountdown == 2) {
                    shuffleOnTimeCountdown = 1;
                }
            }
        }
        //        NSLog(@"sot %d",shuffleOnTimeCountdown);
        if (maincounter == 10 && shuffleOnTimeCountdown == 2 && !isshuffleOnCountdownPlayed) {
            [self playAudioWithName:@"TEN SECONDS TO GO 1" Extension:@"mp3"];
            shuffleOnTimeCountdown--;
            isshuffleOnCountdownPlayed = YES;
        } else if (maincounter == 6 && shuffleOnTimeCountdown == 1 && !isshuffleOnCountdownPlayed) {
            [self playAudioWithName:@"countdown5" Extension:@"mp3"];
            shuffleOnTimeCountdown--;
            isshuffleOnCountdownPlayed = YES;
        } else if (maincounter == 3 && shuffleOnTimeCountdown == 0 && !isshuffleOnCountdownPlayed) {
            [self playAudioWithName:@"countdownVoice" Extension:@"mp3"];
            shuffleOnTimeCountdown = 2;
            isshuffleOnCountdownPlayed = YES;
        }
    }
    //end aanew motivation
    
    if (![defaults objectForKey:@"Motivation"] || [[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] || [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] != NSOrderedSame) {
        [appDelegate.mainAudioPlayer pause];
        //suchandra 2/1/17
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isMusicPaused"];
        //
        
    } else  if ([[defaults objectForKey:@"wasMusicPlaying"] boolValue] && [defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame && wasPlaying) {
        [appDelegate.mainAudioPlayer play];
        
        //suchandra 2/1/17
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isMusicPaused"];
        //
        
    }
    
    //aanew
    if (stationCount > 0) {
        if ([[[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"offTime"] caseInsensitiveCompare:@"00:00"] == NSOrderedSame && stage == 2 && maincounter < 1) {
            [flashingTimer invalidate];
            flashingCount = 0;
            flashingView.hidden = YES;
            stage = 1;
            stationCount--;
            stationCountValue++;
            if (stationCount == 0 && roundCount > 0) {
                
                roundCount--;
                roundCountValue++;
                if (roundCount == 0) {
                    stage = 1;
                    stationCountValue--;
                    roundCountValue--;
                } else {
                    stage = 0;
                    stationCount = (int)stationDict.count;;
                    stationCountValue = 1;
                    if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                        roundFinishState = @"start";
                    } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame){
                        roundFinishState = @"start";
                    }
                }
            }
        }
    }
    //end aanew
    
    if (maincounter < 1) {
        
        isshuffleOnCountdownPlayed = NO;
        if (stage == 1) {
            [mainTimer invalidate];
            
            if (isPrepTime) {
                isPrepTime = NO;
                isPrepRunning = NO;
                [mainTimer invalidate];
                
                timerTitleLabel.text = @"WORKOUT TIME";
                timerLabel.text = [[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"onTime"];
                
                [self startTimerWithTime:[[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"onTime"]];
                stage = 2;
                //shuffleOnTimeCountdown = arc4random_uniform(3);
            } else {
                //                stationCount--;
                /*                int reps = [[[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"reps"] intValue];
                 if (reps > 0) {
                 [mainTimer invalidate];
                 isPlaying = NO;
                 repsView.hidden = false;
                 repsLabel.text = [[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"reps"];
                 } else {*/
                //                    repsView.hidden = true;
                if (stationCount == 0 && roundCount > 0) {
                    //                        stationCount = (int)stationDict.count;
                    //                        roundCount--;
                    //                    stage = 0;
                    if (roundCount == 0) {
                        [mainTimer invalidate];
                        [sessionTimer invalidate];
                        timerLabel.text = @"00:00";
                        timerTitleLabel.text = @"THE END";
                        [self sessionCounter]; //aanew
                        stationCountLabel.text = @"0";
                        roundCountlabel.text = @"0";
                        stationCount = 0;
                        if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                            [self playAudioWithName:@"End of Circuit" Extension:@"wav"];
                        } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame){
                            [self playBipAudioWithName:@"Air_Horn" Extension:@"wav"];
                        }
                    } else {
                        [mainTimer invalidate];
                        [self startTimerWithTime:roundPrepTime];
                        timerTitleLabel.text = @"ROUND PREP TIME";
                        //suchandra 4/1/17
                        if (isHighVolume || wasPlaying) {
                            [self inBetweenRoundControll];
                        }
                        //
                        timerLabel.text = roundPrepTime;
                        stage = 1;
                        isPrepTime = YES;
                        isPrepRunning = YES;
                        
                        if (([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) && roundCount > 0 && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame)) {
                            [self playBipAudioWithName:@"Air_Horn" Extension:@"wav"];
                        }
                    }
                } else if (stationCount > 0 && roundCount > 0) {
                    [mainTimer invalidate];
                    //                        [self startTimerWithTime:[[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"onTime"]];
                    timerTitleLabel.text = @"WORKOUT TIME";
                    timerLabel.text = [[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"onTime"];
                    [self startTimerWithTime:[[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"onTime"]];
                    stage = 2;
                    //shuffleOnTimeCountdown = arc4random_uniform(3);
                } else if (stationCount > 0 && roundCount == 0) {
                    [mainTimer invalidate];
                    //                        [self startTimerWithTime:[[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"onTime"]];
                    timerTitleLabel.text = @"WORKOUT TIME";
                    timerLabel.text = [[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"onTime"];
                    [self startTimerWithTime:[[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"onTime"]];
                    stage = 2;
                    //shuffleOnTimeCountdown = arc4random_uniform(3);
                } else if (stationCount == 0 && roundCount == 0) {
                    [mainTimer invalidate];
                    [mainTimer invalidate];
                    [sessionTimer invalidate];
                    timerLabel.text = @"00:00";
                    timerTitleLabel.text = @"THE END";
                    [self sessionCounter];  //aanew
                    stationCountLabel.text = @"0";
                    roundCountlabel.text = @"0";
                    stationCount = 0;
                    if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                        [self playAudioWithName:@"End of Circuit" Extension:@"wav"];
                    } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame){
                        [self playBipAudioWithName:@"Air_Horn" Extension:@"wav"];
                    }
                }
                //}
            }
            if (!isPrepTime && (![defaults objectForKey:@"Voice Over"] || [[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] || [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame) && roundCount > 0) {
                [self playBipAudioWithName:@"Car-Horn" Extension:@"mp3"];
            } else if (!isPrepTime && ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) && roundCount > 0 && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame) && !appDelegate.mainAudioPlayer.isPlaying) {
                //                [self playAudioWithName:@"Lets Go" Extension:@"wav"]; //aanew
                [self playAudioWithName:@"Car-Horn" Extension:@"mp3"];
                isLetsGoPlayed = YES;
            }
            if (!isHighVolume || !wasPlaying) {
                [self inBetweenRoundControll];
            }
            stationCountLabel.text = [NSString stringWithFormat:@"%d",stationCountValue];
            roundCountlabel.text = [NSString stringWithFormat:@"%d",roundCountValue];
        } else if (stage == 2) {
            [mainTimer invalidate];
            [self startTimerWithTime:[[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"offTime"]];
            timerLabel.text = [[[stationEditdataDict objectForKey:roundKey] objectAtIndex:(int)stationDict.count - stationCount] objectForKey:@"offTime"];
            timerTitleLabel.text = @"REST TIME";
            shouldPlayCountdown = true;
            stationCount--;
            stationCountValue++;
            if (stationCount == 0 && roundCount > 0) {
                
                roundCount--;
                roundCountValue++;
                stage = 0;
                if (roundCount == 0) {
                    stage = 1;
                    stationCountValue--;
                    roundCountValue--;
                } else {
                    stationCount = (int)stationDict.count;
                    stationCountValue = 1;
                    if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                        roundFinishState = @"start";
                    } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame){
                        roundFinishState = @"start";
                    }
                }
            } else {
                stage = 1;
            }
            if (isHighVolume || wasPlaying) {
                [self inBetweenRoundControll];
            }
            if (maincounter == 0) {
                shouldPlayCountdown = false;
            }
            if ((![defaults objectForKey:@"Voice Over"] || [[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] || [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame)) {
                [self playBipAudioWithName:@"Buzzer-Sound" Extension:@"mp3"];
            } else if (([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame)) {
                [self playAudioWithName:@"Rest" Extension:@"mp3"]; //aanew
            }
        } else if (stage == 0) {
            [mainTimer invalidate];
            [self startTimerWithTime:roundPrepTime];
            timerLabel.text = roundPrepTime;
            timerTitleLabel.text = @"ROUND PREP TIME";
            stage++;
            isPrepTime = YES;
            isPrepRunning = YES;
            //            if (!isHighVolume || !wasPlaying) {
            //                [self inBetweenRoundControll];
            //            }
            //suchandra 4/1/17
            if (isHighVolume || wasPlaying) {
                if (appDelegate.mainAudioPlayer.volume > 0.5) {
                    [self inBetweenRoundControll];
                }
                //                [self inBetweenRoundControll];
            }
            //
            stationCountLabel.text = [NSString stringWithFormat:@"%d",stationCountValue];
            roundCountlabel.text = [NSString stringWithFormat:@"%d",roundCountValue];
            
            if (([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) && roundCount > 0 && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame)) {
                [self playBipAudioWithName:@"Air_Horn" Extension:@"wav"];
            }
        }
        //        stage++;
    }
}

-(void) flashCounter {
    if (isPlaying) {
        if (flashingCount % 2 == 0) {
            flashingView.hidden = NO;
        } else {
            flashingView.hidden = YES;
        }
    } else {
        if (flashingCount % 2 == 0) {
            repsDoneFlashingView.hidden = NO;
        } else {
            repsDoneFlashingView.hidden = YES;
        }
    }
    
    flashingCount++;
}
-(void) sessionCounter {
    sessionTimeCounter++;
    int minutes = (sessionTimeCounter % 3600) / 60;
    int seconds = (sessionTimeCounter %3600) % 60;
    sessionTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

-(void)playAudioWithName:(NSString *)audioName Extension:(NSString *)extension{
    if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
        // Construct URL to sound file
        NSString *path = [NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath],audioName,extension];
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
        //    NSLog(@"su %@",path);
        
        
        //background
//        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *error = nil;
        //        NSLog(@"Activating audio session");
        
        @try {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error];
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            
        } @catch (NSException *exception) {
            NSLog(@"Audio Session error %@, %@", exception.reason, exception.userInfo);
            
        } @finally {
            NSLog(@"Audio Session finally");
        }
        
//
//        if (![audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error]) {
//            NSLog(@"Unable to set audio session category: %@", error);
//        }
//        BOOL result = [audioSession setActive:YES error:&error];
//        if (!result) {
//            NSLog(@"Error activating audio session: %@", error);
//        }
//        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        //end
        
        
        // Create audio player object and initialize with URL to sound
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        //        NSLog(@"avv %f",audioPlayer.volume);
        audioPlayer.delegate = self;
        [audioPlayer setVolume:1.0];
        //        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        [audioPlayer play];
        
        [appDelegate.mainAudioPlayer setVolume:0.2];
    }
}

-(void)playBipAudioWithName:(NSString *)audioName Extension:(NSString *)extension{
    // Construct URL to sound file
    NSString *path = [NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath],audioName,extension];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    //    NSLog(@"su %@",path);
    
    
    //background
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    //    NSLog(@"Activating audio session");
//    if (![audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error]) {
//        NSLog(@"Unable to set audio session category: %@", error);
//    }
//    BOOL result = [audioSession setActive:YES error:&error];
//    if (!result) {
//        NSLog(@"Error activating audio session: %@", error);
//    }
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//
    @try {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error];
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
    } @catch (NSException *exception) {
        NSLog(@"Audio Session error %@, %@", exception.reason, exception.userInfo);
        
    } @finally {
        NSLog(@"Audio Session finally");
    }
    
    //end
    
    
    // Create audio player object and initialize with URL to sound
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    //        NSLog(@"avv %f",audioPlayer.volume);
    audioPlayer.volume = 1.0;
    [audioPlayer play];
    
    [appDelegate.mainAudioPlayer setVolume:0.2];
}

-(void)playAudioWithName:(NSString *)audioName Extension:(NSString *)extension Url:(NSURL *)mediaUrl{
    //    if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
    // Construct URL to sound file
    //        NSString *path = audioName; //[NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath],audioName,extension];
    NSURL *soundUrl = mediaUrl; //[NSURL fileURLWithPath:mediaUrl];
    //    NSLog(@"su %@",path);
    [defaults setObject:[mediaUrl absoluteString] forKey:@"currentMusicUrl"];
    
    //background
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    //    NSLog(@"Activating audio session");
//    if (![audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error]) {
//        NSLog(@"Unable to set audio session category: %@", error);
//    }
//    BOOL result = [audioSession setActive:YES error:&error];
//    if (!result) {
//        NSLog(@"Error activating audio session: %@", error);
//    }
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    @try {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error];
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
    } @catch (NSException *exception) {
        NSLog(@"Audio Session error %@, %@", exception.reason, exception.userInfo);
        
    } @finally {
        NSLog(@"Audio Session finally");
    }
    
    //end
    
    // Create audio player object and initialize with URL to sound
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.mainAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    //        NSLog(@"avv %f",audioPlayer.volume);
    appDelegate.mainAudioPlayer.delegate = self;
    [appDelegate.mainAudioPlayer setVolume:1.0];    //music volume
    [appDelegate.mainAudioPlayer play];
    //    }
}

-(void) getTimerNotification:(NSNotification *)notification {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict addEntriesFromDictionary:notification.userInfo];
    if ([[dict objectForKey:@"isRunning"] caseInsensitiveCompare:@"running"] == NSOrderedSame) {
        [playPauseButton setImage:[UIImage imageNamed:@"round_play.png"] forState:UIControlStateNormal];
        [resetStartLabel setText:@"PLAY"];
        [mainTimer invalidate];
        [sessionTimer invalidate];
        isPlaying = NO;
        NSLog(@"mm %ld  st %ld",(long)[[MPMusicPlayerController systemMusicPlayer] playbackState],(long)MPMusicPlaybackStatePlaying
              );
        if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
            [[MPMusicPlayerController systemMusicPlayer] pause];
            isMusicPlaying = YES;
        } else {
            isMusicPlaying = NO;
        }
        flashingView.hidden = YES;
    }
}

-(void)inBetweenRoundControll {
    if ([[defaults objectForKey:@"Inbetween Rounds"] caseInsensitiveCompare:@"PLAY SOFTER"] == NSOrderedSame && appDelegate.mainAudioPlayer.isPlaying) {
        if (isHighVolume) {
            //            MPVolumeView* volumeView = [[MPVolumeView alloc] init];
            ////            [volumeView setBackgroundColor:[UIColor clearColor]];
            //            volumeView.showsRouteButton = false;
            //            volumeView.showsVolumeSlider = false;
            //            volumeView.hidden = true;
            //            //find the volumeSlider
            //            UISlider* volumeViewSlider = nil;
            //            for (UIView *view in [volumeView subviews]){
            //                if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            //                    volumeViewSlider = (UISlider*)view;
            //                    break;
            //                }
            //            }
            //            float vol = [[AVAudioSession sharedInstance] outputVolume];
            //            [volumeViewSlider setValue:vol/2 animated:YES];
            //            [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
            //        NSLog(@"avplayer volume: %f",audioPlayer.volume);
            //            audioPlayer.volume = 1.0;
            
//                        [[MPMusicPlayerController systemMusicPlayer] setVolume:0.5];
            [audioPlayer setVolume:1.0];
            [appDelegate.mainAudioPlayer setVolume:0.2];    //music volume
            //            NSLog(@"ibrc");
            isHighVolume = NO;
        } else {
            //            MPVolumeView* volumeView = [[MPVolumeView alloc] init];
            //            //find the volumeSlider
            //            UISlider* volumeViewSlider = nil;
            //            for (UIView *view in [volumeView subviews]){
            //                if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            //                    volumeViewSlider = (UISlider*)view;
            //                    break;
            //                }
            //            }
            //            float vol = [[AVAudioSession sharedInstance] outputVolume];
            //            //        NSLog(@"output volume: %f", vol);
            //            [volumeViewSlider setValue:vol*2 animated:YES];
            //            [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
            //        NSLog(@"avplayer volume: %f",audioPlayer.volume);
            //            audioPlayer.volume = 1.0;
            [audioPlayer setVolume:1.0];
            [appDelegate.mainAudioPlayer setVolume:1.0];    //music volume
            isHighVolume = YES;
        }
        
    } else if ([[defaults objectForKey:@"Inbetween Rounds"] caseInsensitiveCompare:@"STOPS PLAYING"] == NSOrderedSame) {
        if (wasPlaying && appDelegate.mainAudioPlayer.isPlaying) {
            [appDelegate.mainAudioPlayer pause];
            //suchandra 2/1/17
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isMusicPaused"];
            //
            wasPlaying = NO;
        } else {
            [appDelegate.mainAudioPlayer play];
            //suchandra 2/1/17
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isMusicPaused"];
            //
            wasPlaying = YES;
        }
        
    }
}

#pragma mark - AVAudioPlayer Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //aanew
    if (player == appDelegate.mainAudioPlayer) {
        NSLog(@"found avplr");
        MPMediaQuery *query = [MPMediaQuery playlistsQuery];
        NSArray *playlists = [query collections];
        
        NSInteger selectedMediaIndex = [[defaults objectForKey:@"mediaSelectedIndex"] integerValue];
        
        MPMediaPlaylist *specificplaylist = [playlists objectAtIndex:selectedMediaIndex];
        NSArray *songs = [specificplaylist items];
        
        if ([defaults objectForKey:@"Shuffle"] && ![[defaults objectForKey:@"Shuffle"] isEqual:[NSNull null]]  && [[defaults objectForKey:@"Shuffle"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
            appDelegate.mediaPlayingIndex++;
            [self playAudioWithName:@"" Extension:@"" Url:[[songs objectAtIndex:[[appDelegate.indexArray objectAtIndex:appDelegate.mediaPlayingIndex] intValue]] valueForProperty:MPMediaItemPropertyAssetURL]];
        } else {
            appDelegate.mediaPlayingIndex++;
            [self playAudioWithName:@"" Extension:@"" Url:[[songs objectAtIndex:appDelegate.mediaPlayingIndex] valueForProperty:MPMediaItemPropertyAssetURL]];
        }
        
        //        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //        NSError *error = nil;
        //        NSLog(@"Deactivating audio session");
        //        BOOL result = [audioSession setActive:NO error:&error];
        //        if (!result) {
        //            NSLog(@"Error deactivating audio session: %@", error);
        //        }
    } else if (player == audioPlayer) {
        //        NSLog(@"tt %@",timerTitleLabel.text);
        if ([[defaults objectForKey:@"Inbetween Rounds"] caseInsensitiveCompare:@"PLAY SOFTER"] == NSOrderedSame && appDelegate.mainAudioPlayer.isPlaying && [timerTitleLabel.text caseInsensitiveCompare:@"ON time"] != NSOrderedSame) {
            //no change
        } else {
            NSLog(@"vv1 %f",appDelegate.mainAudioPlayer.volume);
            [appDelegate.mainAudioPlayer setVolume:1.0];
            NSLog(@"vv2 %f \n ---",appDelegate.mainAudioPlayer.volume);
        }
    }
    //    NSLog(@"pl %@",player);
    if (flag) {
        //        if ([roundFinishState caseInsensitiveCompare:@"finish"] == NSOrderedSame) {
        //            [self playAudioWithName:@"End of Round" Extension:@"wav"];
        //            roundFinishState = @"";
        //        } else if ([roundEndOfRoundState caseInsensitiveCompare:@"r1finished"] == NSOrderedSame) {
        //            [self playAudioWithName:@"Round 1 Down, Great Start!" Extension:@"wav"];
        //            roundEndOfRoundState = @"";
        //        } else if ([roundEndOfRoundState caseInsensitiveCompare:@"r2finished"] == NSOrderedSame) {
        //            [self playAudioWithName:@"Round Complete Youre Doing So Well" Extension:@"wav"];    //Round 2 complete, you're doing so well
        //            roundEndOfRoundState = @"";
        //        } else if ([endOfRoundState caseInsensitiveCompare:@"finished"] == NSOrderedSame) {
        //            [self playAudioWithName:@"Last Round Coming Up 2" Extension:@"wav"];
        //            endOfRoundState = @"";
        //        }
    }
}
@end
