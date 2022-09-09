//
//  ExerciseVideoViewController.m
//  Ashy Bines Super Circuit
//
//  Created by AQB SOLUTIONS on 07/09/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "ExerciseVideoViewController.h"
#import "VideoTableViewCell.h"
#import "Utility.h"
#import "HomePageViewController.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "CircleProgressBar.h"
#import "WeightRecordSheetViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MenuSettingsViewController.h"
#import "GamificationViewController.h"
#import "ExerciseDetailsTableViewCell.h"


@interface ExerciseVideoViewController (){
    IBOutlet UIView *mainView;
    IBOutlet UIButton *playPauseButton;
    IBOutlet UIButton *landScapePlayPauseButton;
    IBOutlet UIButton *rightLandScapePlayPauseButton;
    IBOutlet UIButton *backwardButton;
    IBOutlet UIButton *landscapeBackwardButton;
    IBOutlet UIButton *landscapeRightSideBackwardButton;
    

    IBOutlet UIButton *forwardButton;
    IBOutlet UIButton *landscapeForwardButton;
    IBOutlet UIButton *landscapeRightSideForwardButton;
    

    IBOutlet UILabel *timerCountLabel;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *leftLandscapeTitleLabel;
    IBOutlet UILabel *rightlandscapeTitleLabel;
    IBOutlet UILabel *landScapeTimerCountLabel;
    IBOutlet UILabel *rightLandScapeTimerCountLabel;
    
    
//    IBOutlet UILabel *titleTimeLabel;
    IBOutlet UITableView *exerciseTable;
    IBOutlet UILabel *sessionTimeLabel;
    IBOutlet UILabel *landscapeSessionTimeLabel;
    IBOutlet UILabel *rightLandscapeSessionTimeLabel;

    IBOutlet UIButton *repsDoneButton;
    IBOutlet UIButton *landscapeRepsDoneButton;
    IBOutlet UIButton *rightLandscapeRepsDoneButton;

    IBOutlet UIView *repsDoneView;
    
    IBOutlet UILabel *repsSetLabel;
    IBOutlet UILabel *landscapeRepsSetLabel;
    IBOutlet UILabel *rightLandscapeRepsSetLabel;
    
    IBOutlet NSLayoutConstraint *exerciseTableHeightConstraint;
    
    IBOutlet UIView *customProgressView;
    IBOutlet CircleProgressBar *circleProgressBar;      //ah 1.2
    
    IBOutlet UIButton *volumeButton;
    IBOutlet UIButton *voiceOverButton;
    IBOutlet UIButton *bellButton;
    
    IBOutlet UILabel *sessionCompleteLabel;
    IBOutlet UILabel *circuitNameLabel;
    IBOutlet UIView *sessionCompleteView;
    
    //ah 3.5
    IBOutlet UIImageView *mainImageView;
    IBOutlet UILabel *sessionDetailsLabel;
    IBOutlet UIImageView *shareImageView;
    IBOutlet UIView *sessionCompleteViewWithImage;
    IBOutlet UIView *screenshotView;
    //ah 3.5 end
    
    //ah ux2(storyboard)
    IBOutlet UILabel *gameOnCountdownLabel;
    
    IBOutlet UIView *nextUpView;
    IBOutlet UILabel *nextUpTitleLabel;
    IBOutlet UIView *nextUpMainView;
    IBOutlet CircleProgressBar *nextUpCircleProgressBar;
    IBOutlet UILabel *nextUpRepsSetLabel;
    IBOutlet UILabel *nextUpTipsLabel;
    IBOutlet NSLayoutConstraint *nextUpProgressBarHeightConstraint;
    IBOutlet UIImageView *weightArrowImage;
    
    NSInteger tempCurrentPage;
    AVPlayer *videoPlayer;
    AVAudioPlayer *audioPlayer;
    NSMutableArray *videoNamesArray;
    NSArray *audioNamesArray;
    BOOL isPlaying;
    NSTimer *mainTimer;
    int mainOffTime;
    int mainOnTime;
    int offTime;
    int onTime;
    int videoCounter;
    int audioCounter;
    float timerCount;
    CGFloat newTimerCount;
    int firstCounter;
    
    NSMutableArray *dataArray;
    int roundID;
    int prevRoundID;
    BOOL isprepTime;
    int mainFirstCounter;
    NSMutableArray *exerciseNameArray;
    
    int sessionTimeCounter;
    NSTimer *sessionTimer;
    
    int reps;
    NSMutableArray *rowIdArr;
    int currentCount;
    
    int setCount;
    BOOL isSuperSet;
    BOOL isSuperSetCell;
    CGFloat yOffset;
    NSString *scrollDirection;
    
    int cktCounter;
    int exCounter;
    
    int shuffleOnTimeCountdown;
    BOOL isshuffleOnCountdownPlayed;
    
    NSURLSessionDownloadTask *downloadTask;
    NSURLSession *session;
    int downloadCount;
    UIView *contentView;
    UILabel *contentViewLabel;
    int supersetPosition_j;
    int supersetPosition_setCount;
    int supersetPosition_currentCount;
    int supersetPosition_i;
    int supersetPositionI_setCount;
    int supersetPositionI_currentCount;
    BOOL isFirstVideo;
    
    NSArray *motivationStaticArray;
    NSArray *sayingStaticArray;
    NSMutableArray *motivationArray;
    NSMutableArray *sayingArray;
    
    BOOL isHighVolume;
    BOOL wasPlaying;
    int currentCircuit;
    int repSideCount;
    int repSideCountPlay;
    int nextUpRepSideCountPlay;
    BOOL isRepsEachSideFormat;
    int normalSetCount;
    int currentSetCount;
    int setPosition_i;
    int setPosition_j;
    CustomizationState _state;
    BOOL isEachSide;
    BOOL shouldCktTitleShow;
    NSString *cktName;
    NSString *previousSide;
    BOOL isMusicPausedHere;
    
    //ah ux1
    BOOL isCompleted;
    BOOL shouldStopMotivation;
    NSTimer *gameOnTimer;
    BOOL isNameAudioPlaying;
    BOOL isNextUpPlaying;
    
    NSURLSessionDownloadTask *audioDownloadTask;
    NSURLSession *audioUrlSession;
    int audioDownloadCount;
    UIProgressView *progressView;
    BOOL isOffTime;
    BOOL isFirstExDownloading;
    
    NSTimer *timerNew123;
    float timerNew123Count;
    BOOL isForwardChanged;
    BOOL isBackwardChanged;
    
    IBOutlet UIButton *weightRecordButton; //AY 02112017
    
    BOOL isRepsBuzzPlay; //AY 07122017
    BOOL isYogaSession; //AY 11122017
    BOOL playBuzzforYoga; //AY 11122017
    BOOL playVoiceOverforYoga; //AY 11122017
    BOOL pageControlIsChangingPage;
    IBOutlet NSLayoutConstraint *nextUpTopConstant;
    BOOL isNextUp;
    IBOutlet UILabel *exerciseNameLabel;
    IBOutlet UIView *footerView;
    IBOutlet NSLayoutConstraint *nextUpHeightConstant;
    IBOutlet UIView *nextView;
    IBOutlet UIView *restViewDetails;
    IBOutlet UILabel *nextUpTimerlabel;
    IBOutlet UIScrollView *scroll;
    IBOutlet UIButton *myMusicButton;
    IBOutlet UIView *nextExerciseView; ///add_SB
    IBOutlet UIButton *nextExerciseButton; ///add_SB
    IBOutlet UIButton *nextUpButton; //AY 16032018
    BOOL isClearAll; //AY 22022018
    NSURLSession *singleDownloadSession;//AY 26022018
    NSURLSessionDownloadTask *singleDownloadTask;//AY 27022018
    NSURLSession *followAlongDownloadSession;
    NSURLSessionDownloadTask *followAlongDownloadTask;
    NSOperationQueue *audioDownloadQueue;
    
    NSInteger totalMediaCount;
    NSInteger totalMediaDownloaded;
    IBOutlet UILabel *mediaDownloadLabel;
    
    
    __weak IBOutlet UIView *loadingView;    
    __weak IBOutlet UIImageView *loadingImageView;
    
    __weak IBOutlet UIView *circuitTimerStartingView;
    __weak IBOutlet UILabel *circuitTimerLabel;
    __weak IBOutlet UILabel *currentCircuitNameLabel;
    __weak IBOutlet UILabel *circuitExerciseNamesLabel;
    __weak IBOutlet UIButton *downloadButton;
    __weak IBOutlet UIView *nextUpPreview;
    
    IBOutlet UIScrollView *nextUpScrollView;
    IBOutlet UIView *landscapeView;
    IBOutlet UIView *landscapePlayerView;
    IBOutlet UIView *leftLandscapeforwarBackwardButtonView;
    IBOutlet UIView *rightLandscapeforwarBackwardButtonView;
    IBOutlet UIView *landscapeNextUpPlayerView;
    IBOutlet UIView *landscapeNextUpView;
    IBOutlet UIButton *skipRestButton;
    IBOutlet UILabel *landscapeNextUpTimerLabel;
    IBOutlet UILabel *rightLandscapeNextUpTimerLabel;
    IBOutlet UIView *leftLandscapeTimerCountRepsView;
    IBOutlet UIView *rightLandscapeTimerCountRepsView;
    IBOutlet UIView *leftNextupTimerView;
    IBOutlet UIView *rightNextupTimerView;
    IBOutlet UIView *leftNextUpRestDetailsView;
    IBOutlet UIView *rightNextUpRestDetailsView;
    IBOutlet UILabel *leftNextUpLabel;
    IBOutlet UILabel *rightNextUpLabel;
    IBOutlet UIButton *landscapeRestDetailsButton;
    IBOutlet UIButton *rightLandscapeRestDetailsButton;
    IBOutlet UIView *roundNumberShowView;
    IBOutlet UILabel *roundNumberLabel;
    IBOutlet UILabel *roundTimerLabel;
    IBOutlet UILabel *circuitName;
    IBOutlet UITableView *nextCircuitsTable;
    IBOutlet UIView *circuitTimerView;
    NSArray *nextCircuitList;
    
    int numberOfRound;
    NSTimer *roundTimer;
    BOOL islandScapeEnable;
    AVPlayerViewController *avPlayerController;
    int circuitCount;
    NSTimer *circuitTimer;
    
    int currentCircuitTime;
    int currentCircuitIndex;
    BOOL isSkip;
    BOOL isfirstTime;
    BOOL isRepeat;
    BOOL isShowRound;
}

@end

@implementation ExerciseVideoViewController
@synthesize isFromCustom,weekDate,parentScroll,currentPage,isWeightSheetButtonPressed,completeSessionId,gameOnView;
#pragma mark - ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //FIREBASELOG
    [FIRAnalytics logEventWithName:@"select_content" parameters:@{@"name_of_workout_selected":_sessionName}];
    loadingImageView.image = [UIImage animatedImageNamed:@"animation-" duration:1.0f];
    loadingView.hidden = true;
    
     tempCurrentPage = -123;
    isWeightSheetButtonPressed = NO;
    isPlaying = YES;
    mainOffTime = 0;
    mainOnTime = 0;
    videoCounter = audioCounter = 0;
    onTime = mainOnTime;
    offTime = mainOffTime;
    timerCount = 0.0;
    newTimerCount = 0.0;
    firstCounter = 0;
    
    roundID = 0;
    prevRoundID = 0;
    isprepTime = NO;
    mainFirstCounter = 0;
    sessionTimeCounter = 0;
    
    reps = 0;
    currentCount = 0;
    
    setCount = 1;
    isSuperSet = NO;
    isSuperSetCell = NO;
    yOffset = 0.0;
    scrollDirection = @"up";
    
    cktCounter = exCounter = 0;
    
    shuffleOnTimeCountdown = 2;
    isshuffleOnCountdownPlayed = NO;
    downloadCount = 0;
    audioDownloadCount = 0;
    supersetPosition_j = supersetPosition_setCount = -1;
    supersetPosition_currentCount = 0;
    supersetPosition_i = supersetPositionI_setCount = -1;
    supersetPositionI_currentCount = 0;
    
    normalSetCount = setPosition_i = setPosition_j = -1;
    currentSetCount = 0;
    
    isFirstVideo = YES;
    
    isHighVolume = YES;
    wasPlaying = YES;
    currentCircuit = 0;
    repSideCount = repSideCountPlay = 0;
    nextUpRepSideCountPlay = 0;     //ah 4.9
    isRepsEachSideFormat = NO;
    isEachSide = NO;
    isOffTime = NO;
    
    isForwardChanged = NO;
    isBackwardChanged = NO;
    
    dataArray = [[NSMutableArray alloc]init];
    exerciseNameArray = [[NSMutableArray alloc]init];
    rowIdArr = [[NSMutableArray alloc]init];
    
    motivationArray = [[NSMutableArray alloc]init];
    sayingArray = [[NSMutableArray alloc]init];
    motivationStaticArray = [[NSArray alloc]init];
    sayingStaticArray = [[NSArray alloc]init];
    
    shouldCktTitleShow = YES;
    cktName = @"";
    previousSide = @"";
    
    isCompleted = NO;   //ah ux1
    shouldStopMotivation = NO;
    isNameAudioPlaying = NO;
    isNextUpPlaying = NO;
    isFirstExDownloading = NO;
    landscapeView.hidden = true;//UIUpdate
    islandScapeEnable = false;//UIUpdate
    landscapeNextUpView.hidden = true;
    
    if([[_workoutType lowercaseString] isEqualToString:@"weights"] && ![Utility isEmptyCheck:weekDate]){
        weightRecordButton.hidden = false;
        weightArrowImage.hidden = false;

    }else{
        weightRecordButton.hidden = true;
        weightArrowImage.hidden = true;

    } //AY 02112017
    [self setupMusicWeightButton];

    
//    if (weightRecordButton.hidden) {
//        [myMusicButton setBackgroundImage:[UIImage imageNamed:@"mymusic_vdo.png"] forState:UIControlStateNormal];
//    }else{
//        [myMusicButton setBackgroundImage:[UIImage imageNamed:@"mymusic.png"] forState:UIControlStateNormal];
//    }
    
//    [dataArray addObjectsFromArray:_mainDataArray];
    videoNamesArray = [[NSMutableArray alloc]initWithObjects:@"Crunch- Bicycle",@"Crunch- Heel Touch Horizontal",@"Dip and Butt Squeeze",@"Dips- Bench Advanced",@"Crunch- Bicycle",@"Crunch- Heel Touch Horizontal",@"Dip and Butt Squeeze",@"Dips- Bench Advanced",@"Crunch- Bicycle",@"Crunch- Heel Touch Horizontal",@"Dip and Butt Squeeze",@"Dips- Bench Advanced",@"Crunch- Bicycle",@"Crunch- Heel Touch Horizontal",@"Dip and Butt Squeeze",@"Dips- Bench Advanced", nil];
//    audioNamesArray = [[NSArray alloc]initWithObjects:@"Crunches",@"DoubleLegStretch",@"ForwardFoldWithHands",@"FrogJumps",@"Crunches",@"DoubleLegStretch",@"ForwardFoldWithHands",@"FrogJumps",@"Crunches",@"DoubleLegStretch",@"ForwardFoldWithHands",@"FrogJumps",@"Crunches",@"DoubleLegStretch",@"ForwardFoldWithHands",@"FrogJumps", nil];
    audioNamesArray = [[NSArray alloc]init];
    
    sessionCompleteView.hidden = YES;
    sessionCompleteViewWithImage.hidden = YES;
    nextUpView.hidden = true;
    parentScroll.scrollEnabled = true;

    if(_rowIdArray.count>0){
        NSDictionary *rowDict = [_rowIdArray objectAtIndex:0];
        for (int i = 0; i < rowDict.count; i++) {
            NSString *rowName = [NSString stringWithFormat:@"row%d",i];
            NSArray *rowArr = [rowDict objectForKey:rowName];
            [rowIdArr addObjectsFromArray:rowArr];
        }
    }
    
    //dataArray = [dbManager fetchExerciseDetailsWithRoundIdArray:rowIdArr];
    
    for (int i = 1; i < _mainDataArray.count; i++) {
//        NSLog(@"i1 %d",i);
        NSArray *exArr = [[_mainDataArray objectAtIndex:i] objectForKey:@"CircuitExercises"];
        
        NSMutableDictionary *circuitDict = [[NSMutableDictionary alloc]init];
        [circuitDict setObject:[[_mainDataArray objectAtIndex:i] objectForKey:@"Id"] forKey:@"id"];
        [circuitDict setObject:[[_mainDataArray objectAtIndex:i] objectForKey:@"Id"] forKey:@"ExerciseId"];//AY 02112017
        [circuitDict setObject:[[_mainDataArray objectAtIndex:i] objectForKey:@"Name"] forKey:@"ExerciseName"];
        NSString *repGoal = [[_mainDataArray objectAtIndex:i] objectForKey:@"ExerciseRepGoal"];     //@"RepGoal"];
        [circuitDict setObject:(![repGoal isEqual:[NSNull null]] && repGoal.length > 0) ? repGoal : @"0" forKey:@"RepGoal"];
        NSString *restComm = [[_mainDataArray objectAtIndex:i] objectForKey:@"RepsUnitText"];
        [circuitDict setObject: restComm forKey:@"RepsUnitText"];
        //ah 8.51
        if ([restComm caseInsensitiveCompare:@"Minutes"] == NSOrderedSame || [restComm caseInsensitiveCompare:@"Min"] == NSOrderedSame) {
            [circuitDict setObject:(![repGoal isEqual:[NSNull null]] && repGoal.length > 0) ? [NSString stringWithFormat:@"%d",[repGoal intValue]*60] : @"0" forKey:@"RepGoal"];
        }
        [circuitDict setObject:[[_mainDataArray objectAtIndex:i] objectForKey:@"SuperSetPosition"] forKey:@"SuperSetPosition"];
        if (supersetPositionI_currentCount < supersetPositionI_setCount) {
            [circuitDict setObject:@"0" forKey:@"SuperSetPosition"];
        } else if (supersetPositionI_currentCount == supersetPositionI_setCount) {
            [circuitDict setObject:@"1" forKey:@"SuperSetPosition"];
        }
        [circuitDict setObject:[[_mainDataArray objectAtIndex:i] objectForKey:@"IsSuperSet"] forKey:@"isSuperSet"];
        [circuitDict setObject:[[_mainDataArray objectAtIndex:i] objectForKey:@"RestComment"] forKey:@"offTime"];
        NSString *videoUrl = @"";   //[[_mainDataArray objectAtIndex:i] objectForKey:@"VideoUrl"];
//        NSString *localVIdeoUrl = [videoNamesArray objectAtIndex:i];
//        [circuitDict setObject:(![videoUrl isEqual:[NSNull null]] && videoUrl.length > 0) ? videoUrl : localVIdeoUrl forKey:@"videoUrl"];
        [circuitDict setObject:videoUrl forKey:@"videoUrl"];
//        NSString *audioUrl = [[_mainDataArray objectAtIndex:i] objectForKey:@"audioUrl"];
        [circuitDict setObject:@"null" forKey:@"audioUrl"];
        [circuitDict setObject:([[[_mainDataArray objectAtIndex:i] objectForKey:@"IsCircuit"] boolValue]) ? [NSNumber numberWithBool:1] : [NSNumber numberWithBool:0] forKey:@"isCircuit"];
        
        [circuitDict setObject:([[[_mainDataArray objectAtIndex:i] objectForKey:@"IsCircuit"] boolValue]) ? [NSNumber numberWithBool:1] : [NSNumber numberWithBool:0] forKey:@"isExerciseCircuit"];
//        [circuitDict setObject:([[[_mainDataArray objectAtIndex:i] objectForKey:@"IsCircuit"] boolValue]) ? @"yes" : @"no" forKey:@"isCircuit"];
        [circuitDict setObject:[[_mainDataArray objectAtIndex:i] objectForKey:@"SetCount"] forKey:@"setCount"];
        [circuitDict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"cktNo"];
        [circuitDict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"srNo"];
        [circuitDict setObject:@"" forKey:@"eachSideText"];
        [circuitDict setObject:@"" forKey:@"tips"];     //ah ux2
        
        if([[[_mainDataArray objectAtIndex:i] objectForKey:@"IsCircuit"] boolValue]){
            if(![Utility isEmptyCheck:[[_mainDataArray objectAtIndex:i] objectForKey:@"CircuitMinutes"]]){
                int circuitMinute = [[[_mainDataArray objectAtIndex:i] objectForKey:@"CircuitMinutes"] intValue] *60;
               //int circuitMinute = 1*15;
                [circuitDict setObject:[NSNumber numberWithInt:circuitMinute] forKey:@"CircuitMinutes"];
            }else{
                [circuitDict setObject:[NSNumber numberWithInt:0] forKey:@"CircuitMinutes"];
            }
        }
        
        [dataArray addObject:circuitDict];
        //ah28
        if (![[[_mainDataArray objectAtIndex:i] objectForKey:@"IsCircuit"] boolValue]) {
            if ([[[_mainDataArray objectAtIndex:i] objectForKey:@"IsSuperSet"] intValue] > 0) {
                if ([[[_mainDataArray objectAtIndex:i] objectForKey:@"SuperSetPosition"] intValue] == -1) {
                    if (supersetPositionI_currentCount == 0)
                        supersetPosition_i = i ;
                    supersetPositionI_setCount = [[[_mainDataArray objectAtIndex:i] objectForKey:@"SetCount"] intValue];
                    supersetPositionI_currentCount++;
                } else if ([[[_mainDataArray objectAtIndex:i] objectForKey:@"SuperSetPosition"] intValue] == 1 && supersetPositionI_currentCount <= supersetPositionI_setCount) {
                    i = supersetPosition_i-1;
                }
                
                if (supersetPositionI_currentCount == supersetPositionI_setCount) {
                    supersetPosition_i = supersetPositionI_setCount = -1;
                    supersetPositionI_currentCount = 0;
                }
            } else {
//                if (currentSetCount == 0 && [[[_mainDataArray objectAtIndex:i] objectForKey:@"SetCount"] intValue] > 1) {
//                    normalSetCount = [[[_mainDataArray objectAtIndex:i] objectForKey:@"SetCount"] intValue];
//                    currentSetCount++;
//                    i--;
//                } else if (currentSetCount > 0 && currentSetCount < normalSetCount) {
//                    i--;
//                    currentSetCount++;
//                } else if (currentSetCount == normalSetCount) {
//                    normalSetCount = setPosition_i = setPosition_j = -1;
//                    currentSetCount = 0;
//                }
            }
            
//            if ([restComm length] > 0) {
//                if ([restComm caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame && !isRepsEachSideFormat) {
//                    if (i > 1)  //ah123
//                        i--;
//                    isRepsEachSideFormat = YES;
//                } else if ([restComm caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame && isRepsEachSideFormat) {
//                    isRepsEachSideFormat = NO;
//                }
//            }
        }
        
        
        dispatch_queue_t queue = dispatch_queue_create("com.foo.samplequeue", NULL);
        dispatch_sync(queue, ^{
//            [self downloadVideoWithName:[[_mainDataArray objectAtIndex:i] objectForKey:@"Name"]];
        });
        
        
        
//        NSLog(@"i2 %d",i);
        
        if (![exArr isEqual:[NSNull null]]) {
            for (int j = 0; j < exArr.count; j++) {
                NSMutableDictionary *ExDict = [[NSMutableDictionary alloc]init];
                [ExDict setObject:@"0" forKey:@"id"];
                [ExDict setObject:[[_mainDataArray objectAtIndex:i] objectForKey:@"Id"] forKey:@"ExerciseId"];//AY 02112017
                [ExDict setObject:[[exArr objectAtIndex:j] objectForKey:@"ExerciseId"] forKey:@"ExerciseCircuitId"];//AY 02112017
                
                
                [ExDict setObject:[[exArr objectAtIndex:j] objectForKey:@"ExerciseName"] forKey:@"ExerciseName"];
                NSString *exRepGoal = [[exArr objectAtIndex:j] objectForKey:@"RepGoal"];
                [ExDict setObject:(![exRepGoal isEqual:[NSNull null]] && exRepGoal.length > 0) ? exRepGoal : @"0" forKey:@"RepGoal"];
                NSString *exRestComm = [[exArr objectAtIndex:j] objectForKey:@"RepsUnitText"];
                
                if ([exRestComm caseInsensitiveCompare:@"Minutes"] == NSOrderedSame || [exRestComm caseInsensitiveCompare:@"Min"] == NSOrderedSame) {
                    [ExDict setObject:(![exRepGoal isEqual:[NSNull null]] && exRepGoal.length > 0) ? [NSString stringWithFormat:@"%d",[exRepGoal intValue]*60] : @"0" forKey:@"RepGoal"];
                }
                
                [ExDict setObject:exRestComm forKey:@"RepsUnitText"];
                [ExDict setObject:[[exArr objectAtIndex:j] objectForKey:@"SuperSetPosition"] forKey:@"SuperSetPosition"];
                if (supersetPosition_currentCount < supersetPosition_setCount) {
                    [ExDict setObject:@"0" forKey:@"SuperSetPosition"];
                } else if (supersetPosition_currentCount == supersetPosition_setCount) {
                    [ExDict setObject:@"1" forKey:@"SuperSetPosition"];
                }
                [ExDict setObject:[[exArr objectAtIndex:j] objectForKey:@"IsSuperSet"] forKey:@"isSuperSet"];
                [ExDict setObject:[[exArr objectAtIndex:j] objectForKey:@"RestComment"] forKey:@"offTime"];
                NSString *exVideoUrl = @""; //[[exArr objectAtIndex:j] objectForKey:@"VideoUrl"];
//                NSString *exLocalVIdeoUrl = [videoNamesArray objectAtIndex:j];
                [ExDict setObject:exVideoUrl forKey:@"videoUrl"];
                [ExDict setObject:@"null" forKey:@"audioUrl"];
                [ExDict setObject:[NSNumber numberWithBool:0] forKey:@"isCircuit"];//AY 03112017
                [ExDict setObject:([[[_mainDataArray objectAtIndex:i] objectForKey:@"IsCircuit"] boolValue]) ? [NSNumber numberWithBool:1] : [NSNumber numberWithBool:0] forKey:@"isExerciseCircuit"];//AY 03112017
                [ExDict setObject:[[exArr objectAtIndex:j] objectForKey:@"SetCount"] forKey:@"setCount"];
                [ExDict setObject:[NSString stringWithFormat:@"%d",j] forKey:@"exNo"];
                [ExDict setObject:[NSString stringWithFormat:@"%c",j+97] forKey:@"srNo"];
                [ExDict setObject:@"" forKey:@"eachSideText"];
                [ExDict setObject:[[exArr objectAtIndex:j] objectForKey:@"CircuitExerciseTips"] forKey:@"tips"];
                if([[[_mainDataArray objectAtIndex:i] objectForKey:@"IsCircuit"] boolValue]){
                    if(![Utility isEmptyCheck:[[_mainDataArray objectAtIndex:i] objectForKey:@"CircuitMinutes"]]){
                        int circuitMinute = [[[_mainDataArray objectAtIndex:i] objectForKey:@"CircuitMinutes"] intValue] *60;
                       //int circuitMinute = 1*15;
                        [ExDict setObject:[NSNumber numberWithInt:circuitMinute] forKey:@"CircuitMinutes"];
                    }else{
                        [ExDict setObject:[NSNumber numberWithInt:0] forKey:@"CircuitMinutes"];
                    }
                }
                [dataArray addObject:ExDict];
                if ([[[exArr objectAtIndex:j] objectForKey:@"IsSuperSet"] intValue] > 0) {
                    if ([[[exArr objectAtIndex:j] objectForKey:@"SuperSetPosition"] intValue] == -1) {
                        if (supersetPosition_currentCount == 0)
                            supersetPosition_j = j ;
                        supersetPosition_setCount = [[[exArr objectAtIndex:j] objectForKey:@"SetCount"] intValue];
                        supersetPosition_currentCount++;
                    } else if ([[[exArr objectAtIndex:j] objectForKey:@"SuperSetPosition"] intValue] == 1 && supersetPosition_currentCount <= supersetPosition_setCount) {
                        j = supersetPosition_j-1;
                    }
                    
                    if (supersetPosition_currentCount == supersetPosition_setCount) {
                        supersetPosition_j = supersetPosition_setCount = -1;
                        supersetPosition_currentCount = 0;
                    }
                }
                
//                if ([exRestComm length] > 0) {
//                    if ([exRestComm caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame && !isRepsEachSideFormat) {
//                        if(j > 1)       //ah123
//                        j--;
//                        isRepsEachSideFormat = YES;
//                    } else if ([exRestComm caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame && isRepsEachSideFormat) {
//                        isRepsEachSideFormat = NO;
//                    }
//                }
            
//                 NSLog(@"j %d",j);
                dispatch_queue_t queue = dispatch_queue_create("com.foo.samplequeue", NULL);
                dispatch_sync(queue, ^{
//                    [self downloadVideoWithName:[[exArr objectAtIndex:j] objectForKey:@"ExerciseName"]];
                });
            }
        }
    }
//    NSLog(@"mda %@",dataArray);
    
    //ah 1.2
    NSMutableArray *newDataArray = [[NSMutableArray alloc]init];
    [newDataArray addObjectsFromArray:dataArray];
    [dataArray removeAllObjects];
    int cktNumber = 0;
    int exerciseNo=0;

    for (int i = 0; i < newDataArray.count; i++) {
        BOOL isCircuit = [[[newDataArray objectAtIndex:i] objectForKey:@"isCircuit"] boolValue];
        if ([[[newDataArray objectAtIndex:i] objectForKey:@"RepsUnitText"] length] > 0 && !isCircuit) {
            if ([[[newDataArray objectAtIndex:i] objectForKey:@"RepsUnitText"] rangeOfString:@"Each Side" options:NSCaseInsensitiveSearch].location != NSNotFound && !isRepsEachSideFormat) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict addEntriesFromDictionary:[newDataArray objectAtIndex:i]];
                if ([[dict objectForKey:@"SuperSetPosition"] intValue ] == 1) {
                    [dict setObject:[NSNumber numberWithInt:0] forKey:@"SuperSetPosition"];
                }
                [dict setObject:@"side 1" forKey:@"eachSideText"];
                //ADD_SB_
                NSString *srNo = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"srNo"]];
                int isexvalue = [[dict objectForKey:@"exNo"]intValue];
                if (isexvalue == 0) {
                    cktNumber = cktNumber+1;
                }else{
                    if (exerciseNo >= [[dict objectForKey:@"exNo"]intValue]) {
                        cktNumber = cktNumber+1;
                    }
                }

                srNo = [@"" stringByAppendingFormat:@"%i%@",cktNumber,srNo];
                exerciseNo = [[dict objectForKey:@"exNo"]intValue];

                [dict setObject:srNo forKey:@"srNo"];
                //ADD_SB_
                [dataArray addObject:dict];
                i--;
                isRepsEachSideFormat = YES;
            } else if ([[[newDataArray objectAtIndex:i] objectForKey:@"RepsUnitText"] rangeOfString:@"Each Side" options:NSCaseInsensitiveSearch].location != NSNotFound && isRepsEachSideFormat) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict addEntriesFromDictionary:[newDataArray objectAtIndex:i]];
                if ([[dict objectForKey:@"SuperSetPosition"] intValue ] == -1) {
                    [dict setObject:[NSNumber numberWithInt:0] forKey:@"SuperSetPosition"];
                }
                [dict setObject:@"side 2" forKey:@"eachSideText"];
                //ADD_SB_
                NSString *srNo = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"srNo"]];
         
                srNo = [@"" stringByAppendingFormat:@"%i%@",cktNumber,srNo];
                [dict setObject:srNo forKey:@"srNo"];
                //ADD_SB_
                [dataArray addObject:dict];
                isRepsEachSideFormat = NO;
            } else {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict addEntriesFromDictionary:[newDataArray objectAtIndex:i]];
                //ADD_SB_
                NSString *srNo = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"srNo"]];
                int isSuperCircuitvalue = [[dict objectForKey:@"exNo"]intValue];
                if (isSuperCircuitvalue == 0) {
                    cktNumber = cktNumber+1;
                }else{
                    if (exerciseNo >= [[dict objectForKey:@"exNo"]intValue]) {
                        cktNumber = cktNumber+1;
                    }
                }
                srNo = [@"" stringByAppendingFormat:@"%i%@",cktNumber,srNo];
                exerciseNo = [[dict objectForKey:@"exNo"]intValue];

                [dict setObject:srNo forKey:@"srNo"];
                //ADD_SB_
                [dataArray addObject:dict];
            }
        }else{
            cktNumber = 0;//ADD_SB_
            [dataArray addObject:[newDataArray objectAtIndex:i]];
        }
    }
    
    
    //ah 2.2
    NSMutableArray *newSetDataArray = [[NSMutableArray alloc]init];
    [newSetDataArray addObjectsFromArray:dataArray];
    [dataArray removeAllObjects];
    NSString *exerciseId;//ADD_SB_
    int number=1;//ADD_SB_
    int count = 0;
    int number1=1;
    int count1=0;
    int exerciseNumber1 = 0;
    int exerciseNumber = 0;
    for (int s = 0; s < newSetDataArray.count; s++) {
        if ([[[newSetDataArray objectAtIndex:s] objectForKey:@"isSuperSet"] intValue] == 0 && ![[[newSetDataArray objectAtIndex:s] objectForKey:@"isCircuit"] boolValue]) {
            //            NSLog(@"s %d",s);
            for (int sc = 0; sc < [[[newSetDataArray objectAtIndex:s] objectForKey:@"setCount"] intValue]; sc++) {
                //                NSLog(@"sc %d",sc);
                
                if (![Utility isEmptyCheck:[[newSetDataArray objectAtIndex:s] objectForKey:@"eachSideText"]]) {
                    NSString *localSideStr = [[newSetDataArray objectAtIndex:s] objectForKey:@"eachSideText"];
                    if ([previousSide caseInsensitiveCompare:[[newSetDataArray objectAtIndex:s] objectForKey:@"eachSideText"]] == NSOrderedSame) {
                        if ([previousSide caseInsensitiveCompare:@"side 1"] == NSOrderedSame) {
                            localSideStr = @"side 2";
                        } else if ([previousSide caseInsensitiveCompare:@"side 2"] == NSOrderedSame) {
                            localSideStr = @"side 1";
                        }
                    }
                    previousSide = localSideStr;
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict addEntriesFromDictionary:[newSetDataArray objectAtIndex:s]];
                    [dict setObject:localSideStr forKey:@"eachSideText"];
                    //ADD_SB_
                    if ([exerciseId isEqualToString:[@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ExerciseCircuitId"]]] && exerciseNumber == [[dict objectForKey:@"exNo"]intValue]) {
                        count=count+1;
                    }else{
                        number = 1;
                    }
                    if ([exerciseId isEqualToString:[@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ExerciseCircuitId"]]] && exerciseNumber == [[dict objectForKey:@"exNo"]intValue] && (count >= 2)) {
                        NSString *srNo = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"srNo"]];
                        
                        //                         NSString *numbers = [srNo stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
                        NSString *srCharacters = [srNo stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
                        if(!([previousSide isEqual:@"side 2"])){
                            number=number+1;
                        }
                        srNo = [@"" stringByAppendingFormat:@"%i%@",number,srCharacters];
                        [dict setObject:srNo forKey:@"srNo"];
                    }
                    exerciseId = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ExerciseCircuitId"]];
                    exerciseNumber = [[dict objectForKey:@"exNo"]intValue];
                    
                    //ADD_SB_
                    NSLog(@"=============%d",sc);
                    [dataArray addObject:dict];
                }else {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict addEntriesFromDictionary:[newSetDataArray objectAtIndex:s]];
                    if ([exerciseId isEqualToString:[@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ExerciseCircuitId"]]]&& exerciseNumber1 == [[dict objectForKey:@"exNo"]intValue]) {
                        count1=count1+1;
                    }else{
                        number1 = 1;
                    }
                    if ([exerciseId isEqualToString:[@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ExerciseCircuitId"]]] && exerciseNumber1 == [[dict objectForKey:@"exNo"]intValue] && (count1 >= 1)) {
                        NSString *srNo = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"srNo"]];
                        
                        //                         NSString *numbers = [srNo stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
                        number1=number1+1;
                        NSString *srCharacters = [srNo stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
                        srNo = [@"" stringByAppendingFormat:@"%i%@",number1,srCharacters];
                        [dict setObject:srNo forKey:@"srNo"];
                    }
                    exerciseId = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ExerciseCircuitId"]];
                    exerciseNumber1 = [[dict objectForKey:@"exNo"]intValue];
                    [dataArray addObject:dict];
                    //                    [dataArray addObject:[newSetDataArray objectAtIndex:s]];
                }
            }
        } else {
            [dataArray addObject:[newSetDataArray objectAtIndex:s]];
        }
    }
    
    NSMutableArray *newCircuitDataArray = [[NSMutableArray alloc]init];
    [newCircuitDataArray addObjectsFromArray:dataArray];
    [dataArray removeAllObjects];
    
    
    int circuitIndex = 0;
    
    for (int c = 0; c < newCircuitDataArray.count; c++) {
        
        if([[[newCircuitDataArray objectAtIndex:c] objectForKey:@"isCircuit"] boolValue]){
            circuitIndex = c;
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict addEntriesFromDictionary:[newCircuitDataArray objectAtIndex:c]];
        [dict setObject:[NSNumber numberWithInt:circuitIndex] forKey:@"circuitIndex"];
        [dataArray addObject:dict];
        
    }
    
    NSMutableArray *newCircuitIndexDataArray = [[NSMutableArray alloc]init];
    [newCircuitIndexDataArray addObjectsFromArray:dataArray];
    [dataArray removeAllObjects];
    
    NSMutableArray *circuitsArray = [[newCircuitIndexDataArray valueForKeyPath:@"@distinctUnionOfObjects.circuitIndex"] mutableCopy];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    circuitsArray = [[circuitsArray sortedArrayUsingDescriptors:@[sd]] mutableCopy];
    
    if(circuitsArray.count){
        [circuitsArray removeObjectAtIndex:0];
    }
    
    for (int c = 0; c < newCircuitIndexDataArray.count; c++) {
        
        int nextIndex = 0;
        if(circuitsArray.count &&   c < [[circuitsArray objectAtIndex:0] intValue]){
            nextIndex = [[circuitsArray objectAtIndex:0] intValue];
        }else if(circuitsArray.count){
            [circuitsArray removeObjectAtIndex:0];
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict addEntriesFromDictionary:[newCircuitIndexDataArray objectAtIndex:c]];
        [dict setObject:[NSNumber numberWithInt:nextIndex] forKey:@"nextCircuitIndex"];
        [dataArray addObject:dict];
        
    }
    
    
    NSLog(@"da %@",dataArray);
    
        if(dataArray.count>0){
            
            titleLabel.text = [[dataArray objectAtIndex:0] objectForKey:@"ExerciseName"];
            leftLandscapeTitleLabel.text = [[dataArray objectAtIndex:0] objectForKey:@"ExerciseName"];
            rightlandscapeTitleLabel.text = [[dataArray objectAtIndex:0] objectForKey:@"ExerciseName"];

            cktName = [[dataArray objectAtIndex:0] objectForKey:@"ExerciseName"];
            int repsNo = 0;
            NSString *repStr = @"reps";
            if ([[[dataArray objectAtIndex:0] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps"] == NSOrderedSame) {
                repsNo = [[[dataArray objectAtIndex:0] objectForKey:@"RepGoal"] intValue];
                repsSetLabel.text = [NSString stringWithFormat:@"%d %@",repsNo,repStr];    //ah30
                landscapeRepsSetLabel.text= [NSString stringWithFormat:@"%d %@",repsNo,repStr];
                rightLandscapeRepsSetLabel.text= [NSString stringWithFormat:@"%d %@",repsNo,repStr];

            } else if ([[[dataArray objectAtIndex:0] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame) {
                repsNo = [[[dataArray objectAtIndex:0] objectForKey:@"RepGoal"] intValue];
                repStr = @"reps side 1";
                repSideCountPlay = 0;
                repsSetLabel.text = [NSString stringWithFormat:@"%d %@",repsNo,repStr];    //ah30
                landscapeRepsSetLabel.text = [NSString stringWithFormat:@"%d %@",repsNo,repStr];    //ah30
                rightLandscapeRepsSetLabel.text = [NSString stringWithFormat:@"%d %@",repsNo,repStr];    //ah30
                
            } else if ([[[dataArray objectAtIndex:0] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Seconds Each Side"] == NSOrderedSame) {
                repStr = @"side 1";
                repSideCountPlay = 0;
                repsSetLabel.text = [NSString stringWithFormat:@"%@",repStr];    //ah30
                landscapeRepsSetLabel.text = [NSString stringWithFormat:@"%@",repStr];    //ah30
                rightLandscapeRepsSetLabel.text = [NSString stringWithFormat:@"%@",repStr];    //ah30

            } else {
                repsSetLabel.text = @"";    //ah30
                landscapeRepsSetLabel.text = @"";    //ah30
                rightLandscapeRepsSetLabel.text = @"";    //ah30
            }
            int setCountNo = [[[dataArray objectAtIndex:0] objectForKey:@"setCount"] intValue];
            if (setCountNo <= 0) {
                setCountNo = 1;
            }
            if (repsNo > 0) {
                //        repsSetLabel.text = [NSString stringWithFormat:@"%d %@ x %d sets",repsNo,repStr,setCountNo];
            } else {
                //        repsSetLabel.text = [NSString stringWithFormat:@"%d sets",setCountNo];
                //        repsSetLabel.text = @"";
            }
            
            //    titleTimeLabel.text = _prepTime;     //prepT
            _prepTime = @"1";  //new
            [videoNamesArray removeAllObjects];
            
            for (int i = 0; i < dataArray.count; i++) {
                [exerciseNameArray addObject:[[dataArray objectAtIndex:i] objectForKey:@"ExerciseName"]];
                [videoNamesArray addObject:[[dataArray objectAtIndex:i] objectForKey:@"videoUrl"]];
            }
            [exerciseTable reloadData];
            prevRoundID = roundID = [[[dataArray objectAtIndex:0] objectForKey:@"id"] intValue];
            
            setCount = [[[dataArray objectAtIndex:0] objectForKey:@"setCount"] intValue];
            if (setCount <= 0) {
                setCount = 1;
            }
            
            if ([[[dataArray objectAtIndex:0] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps"] == NSOrderedSame)//|| [[[dataArray objectAtIndex:0] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame
            {
                reps = [[[dataArray objectAtIndex:0] objectForKey:@"RepGoal"] intValue];
                if(reps == 0){
                    reps = 10;
                }
                isRepsBuzzPlay = true;
                //        reps = reps*setCount;
            } else {
                mainOnTime = onTime = [self getTimeFromString:[[dataArray objectAtIndex:0] objectForKey:@"RepGoal"]];
                mainOffTime = offTime = [self getTimeFromString:[[dataArray objectAtIndex:0] objectForKey:@"offTime"]];
                //        mainOnTime = onTime = mainOnTime*setCount;
            }
            
            mainFirstCounter = firstCounter = [self getTimeFromString:_prepTime];
            
            int isSuperSetCount = [[[dataArray objectAtIndex:0] objectForKey:@"isSuperSet"] intValue];
            if (isSuperSetCount == 1) {
                isSuperSet = true;
            } else if (isSuperSetCount == 2) {
                isSuperSet = false;
            }
            
            int minutes = (onTime % 3600) / 60;
            int seconds = (onTime %3600) % 60;
            
            timerCountLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
            landScapeTimerCountLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
            rightLandScapeTimerCountLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];

            //    timerCountLabel.text = [NSString stringWithFormat:@"%d",onTime];
            
            [backwardButton setAlpha:0.5];
            backwardButton.userInteractionEnabled = NO;
            [landscapeBackwardButton setAlpha:0.5];
            landscapeBackwardButton.userInteractionEnabled = NO;
            
            [landscapeRightSideBackwardButton setAlpha:0.5];
            landscapeRightSideBackwardButton.userInteractionEnabled = NO;
            
            if (contentView) {
                [contentView removeFromSuperview];
            }
            //    contentView = [Utility activityIndicatorView:self];   //ah go
            //    [self contentViewLabelWithText:@"Checking Video Files"];
            
            
            NSArray *filterarray = [dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(isCircuit == false)"]];
            totalMediaCount =  filterarray.count *2;
            mediaDownloadLabel.text = @"";
            
            audioDownloadQueue = [NSOperationQueue new];
            [audioDownloadQueue setMaxConcurrentOperationCount:1000];
            
            NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.TheSquat"];
            sessionConfiguration.allowsCellularAccess = YES;
            session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                    delegate:self
                                               delegateQueue:nil];
            
            
            NSURLSessionConfiguration *audioSessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.TheSquatAudio"];
            audioUrlSession = [NSURLSession sessionWithConfiguration:audioSessionConfiguration
                                                            delegate:self
                                                       delegateQueue:nil];
            
            for (int i = 0; i < dataArray.count; i++) {
                
                if ([[[dataArray objectAtIndex:i] objectForKey:@"isCircuit"] boolValue]) {
                    continue;
                }
                
                [self downloadVideoWithName:[[dataArray objectAtIndex:i] objectForKey:@"ExerciseName"] dataIndex:i];
                
                [self downloadAudioWithName:[[dataArray objectAtIndex:i] objectForKey:@"ExerciseName"] dataIndex:i];
            }
            
        }
    
    
        [playPauseButton setUserInteractionEnabled:NO];
        [landScapePlayPauseButton setUserInteractionEnabled:NO];
        [rightLandScapePlayPauseButton setUserInteractionEnabled:NO];


        sessionTimeLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        landscapeSessionTimeLabel.textColor = [UIColor whiteColor]; //[Utility colorWithHexString:@"E425A0"]
        rightLandscapeSessionTimeLabel.textColor = [UIColor whiteColor]; //[Utility colorWithHexString:@"E425A0"]


        if(_sessionFlowId == TIMER || _sessionFlowId == CIRCUITTIMER){
            sessionTimeCounter = _sessionDuration*60; //_sessionDuration*60;
            //sessionTimeCounter = 20;
            sessionTimeLabel.textColor = [Utility colorWithHexString:@"66c8db"];
            landscapeSessionTimeLabel.textColor = [Utility colorWithHexString:@"66c8db"];
            rightLandscapeSessionTimeLabel.textColor = [Utility colorWithHexString:@"66c8db"];

        }else if(_sessionFlowId == FOLLOWALONG){
            if(_sessionName){
                if(![Utility isEmptyCheck:_followAlongSessiondata[@"VideoLink"]]){
                    
                    [exerciseNameArray addObject:[@"" stringByAppendingFormat:@"%@%@",_sessionName,_followAlongSessiondata[@"VideoLink"]]];
                }
            }
            [self setupViewForFollowAlongSession];
        }
    
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didBecomeActive:) name:@"didBecomeActive" object:nil]; //AY 28112017
    
}
//Arnab 17
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    isClearAll = true;
    numberOfRound = 1;
    circuitCount = 1;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitSession:) name:@"backButtonPressed" object:nil];// AY 22022018
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuButtonPressed:) name:@"menuButtonPressed" object:nil];// AY 22022018
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkReachability:) name:@"kNetworkReachabilityChangedNotification" object:nil];// AY 22022018
    
    //UIUpdate
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    //UIUpdate

   dispatch_async(dispatch_get_main_queue(), ^{
       self->parentScroll.delegate = self;
        if(self->isWeightSheetButtonPressed){
            self->isWeightSheetButtonPressed = NO;
        }
        if (self->currentPage ==-1) {
            self->currentPage = 0;
            [self changePage:nil];
        }else{
            self->tempCurrentPage = self->currentPage;
        }
        
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->gameOnTimer == nil && self->currentPage ==0) {
            NSLog(@"%ld",(long)self->videoCounter);
            if(self->videoCounter > 0){
                self->currentCount--;
                [self->exerciseTable reloadData];
                self->videoCounter --;
                self->audioCounter --;
            }
            self->isPlaying = YES;
            [self->nextExerciseButton setUserInteractionEnabled:YES];
            [self->repsDoneButton setUserInteractionEnabled:YES];
            [self->landscapeRepsDoneButton setUserInteractionEnabled:YES];
            [self->rightLandscapeRepsDoneButton setUserInteractionEnabled:YES];


            [self->nextUpButton setUserInteractionEnabled:YES];
            if (self->isForwardChanged) {
                [self->forwardButton setUserInteractionEnabled:YES];
                [self->landscapeForwardButton setUserInteractionEnabled:YES];
                [self->landscapeRightSideForwardButton setUserInteractionEnabled:YES];
            }
            if (self->isBackwardChanged) {
                [self->backwardButton setUserInteractionEnabled:YES];
                [self->landscapeBackwardButton setUserInteractionEnabled:YES];
                [self->landscapeRightSideBackwardButton setUserInteractionEnabled:YES];
                
            }
            self->gameOnTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(gameOnCounter) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self->gameOnTimer forMode:NSRunLoopCommonModes];
            if (self->gameOnView.hidden) {
                [self->gameOnTimer fire];
            }else{
                [self->circleProgressBar setHintTextGenerationBlock:(YES ? ^NSString *(CGFloat progress) {
                    return @"";
                } : nil)];
            }

        }
    });
    exerciseTable.hidden = true;
    exerciseTableHeightConstraint.constant =0;
    nextExerciseView.hidden = true; //add_7
    timerCountLabel.text =@"";
    landScapeTimerCountLabel.text = @"";
    rightLandScapeTimerCountLabel.text = @"";
    
    if(_sessionFlowId == FOLLOWALONG){
       timerCountLabel.text = @"FOLLOW ALONG SESSION";
        leftLandscapeTitleLabel.text =@"FOLLOW ALONG SESSION"; //self->titleLabel.text; //landScapeTimerCountLabel
        rightlandscapeTitleLabel.text =@"FOLLOW ALONG SESSION"; //rightLandScapeTimerCountLabel
        landScapeTimerCountLabel.text = self->titleLabel.text;
        rightLandScapeTimerCountLabel.text = self->titleLabel.text;
        landscapeRepsSetLabel.text = @"";
        landscapeRepsSetLabel.hidden = true;
        rightLandscapeRepsSetLabel.text=@"";
        rightLandscapeRepsSetLabel.hidden = true;
    }else{
        landscapeRepsSetLabel.hidden = false;
        rightLandscapeRepsSetLabel.hidden = false;
        
    }
   
    repsSetLabel.text =@"";
    landscapeRepsSetLabel.text =@"";
    rightLandscapeRepsSetLabel.text =@"";

}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
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
    
    NSLog(@"wasMusicPlaying %d | isMusicPlaying %@ | Motivation %@",[[defaults objectForKey:@"wasMusicPlaying"] intValue],[defaults objectForKey:@"isMusicPlaying"], [defaults objectForKey:@"Motivation"]);
    //background
    NSError *error = nil;
    @try {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient  error:&error];
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
    } @catch (NSException *exception) {
        NSLog(@"Audio Session error %@, %@", exception.reason, exception.userInfo);
        
    } @finally {
        NSLog(@"Audio Session finally");
    }
    isNextUp = true;
    
    
    NSLog(@"Exercise Array-%@----%d",exerciseNameArray,isPlaying);
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];//AY 22022018
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"menuButtonPressed" object:nil];//AY 22022018
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kNetworkReachabilityChangedNotification" object:nil];//AY 26022018
    
    //UIUpdate
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([[UIDevice currentDevice] isGeneratingDeviceOrientationNotifications]) {
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    }
    //UIUpdate
    
   if(isClearAll)[self clearAll]; //AY 22022018
}
-(void)viewDidLayoutSubviews //Today_Work
{
    [super viewDidLayoutSubviews];
    [self setPostionOfLeftLandScape];
    [self setPostionOfRightLandScape];
    
}
-(void)dealloc{
    [session finishTasksAndInvalidate];
    [session invalidateAndCancel];
    session = nil;
    
    [audioUrlSession finishTasksAndInvalidate];
    [audioUrlSession invalidateAndCancel];
    audioUrlSession = nil;
    
    [singleDownloadSession finishTasksAndInvalidate];
    [singleDownloadSession invalidateAndCancel];
    singleDownloadSession = nil;
    
    self->avPlayerController = nil;

}

#pragma mark - End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)showMenu:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.slidingViewController anchorTopViewToRightAnimated:YES];
            [self.slidingViewController resetTopViewAnimated:YES];
        }
    }];
}

-(IBAction)nextUpButtonTapped:(id)sender{ //CHANGE_NEW
    
    if (isNextUp) {
        nextUpTopConstant.constant = 0;
        isNextUp = false;
        exerciseTable.hidden = false;
        exerciseTableHeightConstraint.constant = (scroll.frame.size.height - (60+60+84));
      
    }else{
        nextUpTopConstant.constant = 340;
        isNextUp = true;
        exerciseTable.hidden = true;
        exerciseTableHeightConstraint.constant =0;
    }
}
-(IBAction)logoTapped:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}
- (IBAction)backButton:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
            if (shouldPop) {
                [self->videoPlayer pause];
                self->videoPlayer = nil;
                [self->audioPlayer pause];
                [self->audioPlayer stop];
                [self->mainTimer invalidate];
                [self->sessionTimer invalidate];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    });

}
-(IBAction)playPauseButtonTapped:(UIButton *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
      
        if (self->isPlaying){
            self->isPlaying = NO;
            [self->mainTimer invalidate];
            [self->sessionTimer invalidate];
            [self->audioPlayer pause];
            if (self->isNextUpPlaying)
                [self->timerNew123 invalidate] ;
            
             [self->nextExerciseButton setUserInteractionEnabled:NO];
            [self->repsDoneButton setUserInteractionEnabled:NO];
            [self->landscapeRepsDoneButton setUserInteractionEnabled:NO];
            [self->rightLandscapeRepsDoneButton setUserInteractionEnabled:NO];


            [self->nextUpButton setUserInteractionEnabled:NO];
            if (self->forwardButton.userInteractionEnabled || self->landscapeForwardButton.userInteractionEnabled || self->landscapeRightSideForwardButton.userInteractionEnabled) {
                [self->forwardButton setUserInteractionEnabled:NO];
                [self->landscapeForwardButton setUserInteractionEnabled:NO];
                 [self->landscapeRightSideForwardButton setUserInteractionEnabled:NO];
                [self->nextExerciseButton setUserInteractionEnabled:NO]; ///add_SB
                self->isForwardChanged = YES;
            }
            if (self->backwardButton.userInteractionEnabled || self->landscapeBackwardButton.userInteractionEnabled || self->landscapeRightSideBackwardButton.userInteractionEnabled) {
                [self->backwardButton setUserInteractionEnabled:NO];
                [self->landscapeBackwardButton setUserInteractionEnabled:NO];
                 [self->landscapeRightSideBackwardButton setUserInteractionEnabled:NO];
                self->isBackwardChanged = YES;
            }
            
            if ([self isBgMusicPlaying]) {
                [self stopMusic];;
            }
            [self->playPauseButton setImage:[UIImage imageNamed:@"play_all_vdo.png"] forState:UIControlStateNormal];
            [self->landScapePlayPauseButton setImage:[UIImage imageNamed:@"play_exVdo.png"] forState:UIControlStateNormal];
            [self->rightLandScapePlayPauseButton setImage:[UIImage imageNamed:@"play_exVdo.png"] forState:UIControlStateNormal];
            

            if (!self->isNextUp) {
                self->isNextUp = true;
                self->nextUpTopConstant.constant = 340;
                self->exerciseTable.hidden = true;
                self->exerciseTableHeightConstraint.constant =0;
            }
            
            if(self->_sessionFlowId == FOLLOWALONG){
                [self->videoPlayer pause];
            }
            
        }else {
            self->isPlaying = YES;
            //        mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
            self->sessionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sessionCounter) userInfo:nil repeats:YES];
            
            if(self->_sessionFlowId != FOLLOWALONG){
                
                if (self->isNextUpPlaying)
                    self->timerNew123 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
                else
                    self->mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
                
            }
            
            
            UIViewController *vc = [self.navigationController visibleViewController];
            if (vc == self)
                //[audioPlayer play]; //AY 26022018
            [self->nextExerciseButton setUserInteractionEnabled:YES];
            [self->repsDoneButton setUserInteractionEnabled:YES];
            [self->landscapeRepsDoneButton setUserInteractionEnabled:YES];
            [self->rightLandscapeRepsDoneButton setUserInteractionEnabled:YES];


            [self->nextUpButton setUserInteractionEnabled:YES];
            
            if (self->isForwardChanged) {
                [self->forwardButton setUserInteractionEnabled:YES];
                [self->landscapeForwardButton setUserInteractionEnabled:YES];
                [self->landscapeRightSideForwardButton setUserInteractionEnabled:YES];
            }
            if (self->isBackwardChanged) {
                [self->backwardButton setUserInteractionEnabled:YES];
                [self->landscapeBackwardButton setUserInteractionEnabled:YES];
                [self->landscapeRightSideBackwardButton setUserInteractionEnabled:YES];
            }
            
            [self startMusic];
            [self->playPauseButton setImage:[UIImage imageNamed:@"timer_pause_button.png"] forState:UIControlStateNormal];
            [self->landScapePlayPauseButton setImage:[UIImage imageNamed:@"pause_vid_exVdo.png"] forState:UIControlStateNormal];
            [self->rightLandScapePlayPauseButton setImage:[UIImage imageNamed:@"pause_vid_exVdo.png"] forState:UIControlStateNormal];

            if(self->_sessionFlowId == FOLLOWALONG){
                [self->videoPlayer play];
            }
        }
    });
    
}
-(IBAction)forwardButtonTapped:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        
    if(self->_sessionFlowId == TIMER || self->_sessionFlowId == CIRCUITTIMER){
        if(self->isShowRound){
            self->isShowRound = NO;
            [self roundCircuitDetails];
            return;
        }else if (self->videoCounter+1 < self->dataArray.count) {
            
            if (![[[self->dataArray objectAtIndex:self->videoCounter+1] objectForKey:@"isCircuit"] boolValue] && ![[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"isCircuit"] boolValue]) {
                
                int exNo = [[[self->dataArray objectAtIndex:self->videoCounter+1] objectForKey:@"exNo"]intValue];
                
                if(exNo == 0){
                    self->isShowRound = YES;
                }else{
                    self->isShowRound = NO;
                }
                
                
            }else if([[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"isCircuit"] boolValue] || [[[self->dataArray objectAtIndex:self->videoCounter+1] objectForKey:@"isCircuit"] boolValue]){
                
                self->isShowRound = NO;
            }else{
                self->isShowRound = NO;
            }
            
        }else{
            self->isShowRound = NO;
        }
    }
        
    
        
    [self->exerciseTable setContentOffset:CGPointZero animated:YES];
    [self->mainTimer invalidate];
//    [sessionTimer invalidate];
    self->mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
    [self->playPauseButton setImage:[UIImage imageNamed:@"timer_pause_button.png"] forState:UIControlStateNormal];
    [self->landScapePlayPauseButton setImage:[UIImage imageNamed:@"pause_vid_exVdo.png"] forState:UIControlStateNormal];
    [self->rightLandScapePlayPauseButton setImage:[UIImage imageNamed:@"pause_vid_exVdo.png"] forState:UIControlStateNormal];

    self->isPlaying = YES;
    //self->isSkip = YES;
//    [self nextVideo];
//        if (!self->isNextUpPlaying && !self->islandScapeEnable) {

        if (!self->isNextUpPlaying) {
            if (self->videoCounter < self->dataArray.count) {
                [self->mainTimer invalidate];
                
                if(self->islandScapeEnable){//chng//
                    self->landscapeView.hidden = true;
                    self->nextUpView.hidden = true;
                    self->landscapeNextUpView.hidden = false;
                }else{
                    self->landscapeView.hidden = true;
                    self->nextUpView.hidden = false;
                    self->nextUpScrollView.hidden = false;
                    self->restViewDetails.hidden = true;
                    self->landscapeNextUpView.hidden = true;
                }//chng//
                
                [self playNextUpWithTime:NO];
            } else {
                [self nextVideo];
            }
    } else {
        self->isNameAudioPlaying = NO;
        self->nextUpView.hidden = true;
        self->parentScroll.scrollEnabled = true;
        self->isNextUpPlaying = NO;
        
        if (self->islandScapeEnable) {//chng//
            self->landscapeView.hidden = false;
            self->landscapeNextUpView.hidden = true;
            self->nextUpView.hidden = true;
        }//chng//
        
        [self nextVideo];
    }
});
}
-(IBAction)backwardButtonTapped:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->isSkip = YES;
       /* [mainTimer invalidate];
        //    [sessionTimer invalidate];
        mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
        [playPauseButton setImage:[UIImage imageNamed:@"timer_pause_button.png"] forState:UIControlStateNormal];
        isPlaying = YES;
        [self previousVideo];*/ // AY 05032018
        [self playPreviousVideo:self->videoCounter]; //AY 05032018
    });
}
-(IBAction)repsDoneButtonTapped:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
     
        if(self->_sessionFlowId == FOLLOWALONG){
            [self followAlongCompleteAlert];
            return;
        }
        
        if(self->_sessionFlowId == TIMER || self->_sessionFlowId == CIRCUITTIMER){
            if(self->isShowRound){
                self->isShowRound = NO;
                [self roundCircuitDetails];
                return;
            }else if (self->videoCounter+1 < self->dataArray.count) {
                
                if (![[[self->dataArray objectAtIndex:self->videoCounter+1] objectForKey:@"isCircuit"] boolValue] && ![[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"isCircuit"] boolValue]) {
                    
                    int exNo = [[[self->dataArray objectAtIndex:self->videoCounter+1] objectForKey:@"exNo"]intValue];
                    
                    if(exNo == 0){
                        self->isShowRound = YES;
                    }else{
                        self->isShowRound = NO;
                    }
                    
                    
                }else if([[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"isCircuit"] boolValue] || [[[self->dataArray objectAtIndex:self->videoCounter+1] objectForKey:@"isCircuit"] boolValue]){
                    
                    self->isShowRound = NO;
                }else{
                    self->isShowRound = NO;
                }
                
            }else{
                self->isShowRound = NO;
            }
        }
        
    //self->isSkip = YES;
    self->repsDoneView.hidden = true;
//    [self nextVideo];
    [self->mainTimer invalidate];
    [self playNextUpWithTime:NO];
    });
}
-(IBAction)settingsButtonTapped:(id)sender{
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            SettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Settings"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
}
-(IBAction)home:(id)sender{
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
}
-(IBAction)motivaionButtonTapped:(id)sender {
    if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
        [volumeButton setImage:[UIImage imageNamed:@"vdo_sound.png"] forState:UIControlStateNormal];
        [defaults setObject:@"on" forKey:@"Motivation"];
        [defaults synchronize];
        [self startMusic];

    } else if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
        [volumeButton setImage:[UIImage imageNamed:@"vdo_mute.png"] forState:UIControlStateNormal];
        [defaults setObject:@"off" forKey:@"Motivation"];
        [defaults synchronize];
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
        if ([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
            playVoiceOverforYoga = true;
        }
        
    }else{
        sender.selected = true;
        [defaults setObject:@"off" forKey:@"Voice Over"];
        [defaults synchronize];
//        if (audioPlayer && audioPlayer.isPlaying) {
//            [audioPlayer pause];
//        }
        if ([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
            playVoiceOverforYoga = false;
        }
        
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
        
        if ([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
            playBuzzforYoga = true;
            
        }
        
    }else{
        sender.selected = true;
        [defaults setObject:@"off" forKey:@"Bell"];
        [defaults synchronize];
        
        if ([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
            playBuzzforYoga = false;
        }
        
    }//AY 11122017
}
-(IBAction)shareButtonTapped:(id)sender {   //ah 3.5
    UIImage *shareImage = [self captureView:screenshotView];
    NSArray *items = @[shareImage];
    
    // build an activity view controller
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    
    // and present it
    [self presentActivityController:controller];
}
-(IBAction)weightRecordButtonTapped:(UIButton *)sender {
    
    if ([Utility isSubscribedUser] && [Utility isOfflineMode]) {
        [Utility msg:@"You are in OFFLINE mode. Go Online to access this functionality." title:@"Oops!\n" controller:self haveToPop:NO];
        return;
    }// AY 07032018
    
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]){
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }// AY 21022018
    
    int count = videoCounter - 1;
    if (count < dataArray.count) {
        isWeightSheetButtonPressed = YES;
        NSDictionary *dict = [dataArray objectAtIndex:count];
        WeightRecordSheetViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WeightRecordSheetView"];
        controller.sessionDate = weekDate;
        controller.exSessionId = _exSessionId;
        controller.fromWhere= (isFromCustom)?@"customSession":@"DailyWorkout";
        controller.workoutTypeId=_workoutTypeId;
        controller.isPlaySession = true;
        controller.isCircuit =  [[dict objectForKey:@"isExerciseCircuit"] boolValue];
        controller.exerciseId =  [[dict objectForKey:@"ExerciseId"] intValue];
        if([[dict objectForKey:@"isExerciseCircuit"] boolValue]){
           controller.exerciseCircuitId =  [[dict objectForKey:@"ExerciseCircuitId"] intValue];
        }        
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(IBAction)restDetailsButtonPressed:(id)sender{
    [self playPauseButtonTapped:playPauseButton];//AY 09032018
    restViewDetails.hidden = false;
    if(islandScapeEnable){
        landscapeNextUpView.hidden = true;
        nextUpView.hidden = false;
        nextUpScrollView.hidden = true;
    }
    
}
-(IBAction)quitWorkoutButtonTaped:(id)sender{
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [videoPlayer pause];
            [audioPlayer stop];
            [mainTimer invalidate];
            [sessionTimer invalidate];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(IBAction)skipRestButtonTapped:(UIButton *)sender {
    if (isPlaying) {
        dispatch_async(dispatch_get_main_queue(), ^{
            timerNew123Count = 0.0;
            [timerNew123 invalidate];
            nextUpProgressBarHeightConstraint.constant = 0;
            nextUpCircleProgressBar.hidden = true;
            nextUpView.hidden = true;//add_n
            landscapeNextUpView.hidden = true;
            parentScroll.scrollEnabled = true;
            restViewDetails.hidden = false; //chng from false to true
            isNextUpPlaying = NO;
            [self nextVideo];
        });
    }
    
   // [timerNew123 invalidate];
} // AY 04012018
-(IBAction)keepTrainingButtonTapped:(id)sender{ ///add_SB
   
    //nextUpView.hidden = true;
    //parentScroll.scrollEnabled = true;
     [self playPauseButtonTapped:playPauseButton]; //AY 09032018
     restViewDetails.hidden = true;
    if (islandScapeEnable) {
        landscapeNextUpView.hidden = false;
        nextUpView.hidden = true;
        nextUpScrollView.hidden = true;
    }
}
-(IBAction)downloadVideoButtonTapped:(UIButton *)sender{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Hey!"
                                          message:@"This is a 'follow along' session and consists of one video that plays the entire session (instead of our normal circuits). The file will take longer to download than normal. Would you like to continue?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self downloadFollowAlongSessionVideo];
                               }];
   
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(IBAction)nextCircuitStartButtonPressed:(UIButton *)sender{
    self->parentScroll.scrollEnabled = YES;
    [self->circuitTimer invalidate];
    self->circuitTimerStartingView.hidden = true;
    [self playPauseButtonTapped:playPauseButton];
    self->circuitCount = 1;
    [self forwardButtonTapped:0];
}
/*
-(IBAction)landScapeButtonpressed:(id)sender{ //CHANGE_100
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(appdelegate.autoRotate){
        appdelegate.autoRotate=NO;
        islandScape = NO;
        [defaults setBool:islandScape forKey:@"isLandScape"];
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        self->nextUpTopConstant.constant = 340; ///add_SB 340
        
    }else{
        appdelegate.autoRotate=YES;
        islandScape = YES;
        [defaults setBool:islandScape forKey:@"isLandScape"];
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        
        self->nextUpTopConstant.constant = 540; ///add_SB 340
//        CGRect frame = mainView.frame;
//        frame.origin.y = 0;
//        [scroll scrollRectToVisible:frame animated:YES];
        [scroll scrollRectToVisible:mainView.frame animated:YES];
    }
}
 */
#pragma mark - Private Methods
-(void)clearAll{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setBackgroundMusicVolume:0.8];
        self->isfirstTime = false;
        self->islandScapeEnable = false;
        [self->videoPlayer pause];
         self->videoPlayer = nil;
        [self->audioPlayer pause];
        [self->audioPlayer stop];
        [self->mainTimer invalidate];
        [self->sessionTimer invalidate];
        [self->gameOnTimer invalidate];
        [self->timerNew123 invalidate];
        [self->circuitTimer invalidate];
        [self->roundTimer invalidate];
        self->mainTimer = nil;
        self->sessionTimer = nil;
        self->gameOnTimer = nil;
        self->timerNew123 = nil;
        self->circuitTimer = nil;
        self->roundTimer = nil;
        
        if (!self->isWeightSheetButtonPressed) {
            [self stopMusic];;
        }
        [self->playPauseButton setImage:[UIImage imageNamed:@"play_all_vdo.png"] forState:UIControlStateNormal];
        [self->landScapePlayPauseButton setImage:[UIImage imageNamed:@"play_exVdo.png"] forState:UIControlStateNormal];
        [self->rightLandScapePlayPauseButton setImage:[UIImage imageNamed:@"play_exVdo.png"] forState:UIControlStateNormal];

        self->isPlaying = NO;
        
        [self->singleDownloadSession finishTasksAndInvalidate];
        [self->singleDownloadSession invalidateAndCancel];
        [self->singleDownloadTask cancel];
        self->singleDownloadSession = nil;
        self->singleDownloadTask = nil;
        [self->followAlongDownloadSession finishTasksAndInvalidate];
        [self->followAlongDownloadSession invalidateAndCancel];
        [self->followAlongDownloadTask cancel];
        self->followAlongDownloadSession = nil;
        self->followAlongDownloadTask = nil;
        
    });
}
-(void)refreshView{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
            self->isYogaSession = true;
        } //AY 11122017
        
        if ([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame || [_workoutType caseInsensitiveCompare:@"Pilates"] == NSOrderedSame || [_workoutType containsString:@"core"] || [_workoutType containsString:@"Pilates"]) {     //AH UX1
            shouldStopMotivation = YES;
        }
        
        /*if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
         [voiceOverButton setImage:[UIImage imageNamed:@"vdo_muteVO.png"] forState:UIControlStateNormal];
         } else if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
         [voiceOverButton setImage:[UIImage imageNamed:@"vdo_soundVO.png"] forState:UIControlStateNormal];
         }*/
        
        if (([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) || (isYogaSession && !playVoiceOverforYoga)) {
            voiceOverButton.selected = true;
        }else{
            voiceOverButton.selected = false;
        }// AY 11122017
        
        if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
            [volumeButton setImage:[UIImage imageNamed:@"vdo_sound.png"] forState:UIControlStateNormal];
            [self startMusic];
            
        } else if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
            [volumeButton setImage:[UIImage imageNamed:@"vdo_mute.png"] forState:UIControlStateNormal];
            [self stopMusic];
        }
        if(isPlaying){
            [playPauseButton setImage:[UIImage imageNamed:@"timer_pause_button.png"] forState:UIControlStateNormal];
            [landScapePlayPauseButton setImage:[UIImage imageNamed:@"pause_vid_exVdo.png"] forState:UIControlStateNormal];
            [rightLandScapePlayPauseButton setImage:[UIImage imageNamed:@"pause_vid_exVdo.png"] forState:UIControlStateNormal];

        }else{
            [playPauseButton setImage:[UIImage imageNamed:@"play_all_vdo.png"] forState:UIControlStateNormal];
            [landScapePlayPauseButton setImage:[UIImage imageNamed:@"pause_vid_exVdo.png"] forState:UIControlStateNormal];
            [rightLandScapePlayPauseButton setImage:[UIImage imageNamed:@"pause_vid_exVdo.png"] forState:UIControlStateNormal];

        }
        /*if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
         [bellButton setImage:[UIImage imageNamed:@"vdo_no_bell.png"] forState:UIControlStateNormal];
         } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
         [bellButton setImage:[UIImage imageNamed:@"vdo_bell.png"] forState:UIControlStateNormal];
         }*/
        
        if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame && !isYogaSession) {
            bellButton.selected = false;
        }else{
            bellButton.selected = true;
        }// AY 11122017
    });
    [self inBetweenRoundControll];
}
-(void)playVideoWithName:(NSString *)videoUrl {
    if (isFirstVideo) {
        [self customizeAccordingToState:CustomizationStateCustom];
        [self playAudioWithName:@"Let's Get Started"];
        isFirstVideo = NO;
        
        //ah 01
        if (videoCounter == 0) {
            currentCount++;
            [exerciseTable reloadData];
            audioCounter++;
            videoCounter++;
        }
    }
//    NSBundle *mainBundle = [NSBundle mainBundle];
//    NSString *myFile = [mainBundle pathForResource: videoName ofType: @"mp4"];
    //    NSLog(@"Main bundle path: %@", mainBundle);
    //    NSLog(@"myFile path: %@", myFile);
    [[AVAudioSession sharedInstance]
                setCategory: AVAudioSessionCategoryPlayback
                      error: nil];
    
    NSURL *videoURL = [NSURL fileURLWithPath:videoUrl];
    
    // create an AVPlayer
    videoPlayer = [AVPlayer playerWithURL:videoURL];
    
    if (avPlayerController) {
        avPlayerController = nil;
    }
    
    // create a player view controller
    avPlayerController = [[AVPlayerViewController alloc]init];
    avPlayerController.player = videoPlayer;
    avPlayerController.showsPlaybackControls = false;
    
    //loops
    videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[videoPlayer currentItem]];
    
    [videoPlayer play];
    
    // remove if the view controller is already present
    UIViewController *vc = [self.childViewControllers lastObject];
    //    NSLog(@"vc %@",vc);
    if ([vc isKindOfClass:[AVPlayerViewController class]]) {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
  
    [[mainView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    
    // show the view controller
    [self addChildViewController:avPlayerController];

    [mainView addSubview:avPlayerController.view];
    avPlayerController.view.frame = mainView.bounds;
    
    if (islandScapeEnable) {
        [self orientationChangedDetails];
    }

    //    [self playAudioWithName:[audioNamesArray objectAtIndex:audioCounter]];
}
-(void)playNextUpVideoWithName:(NSString *)videoUrl {
    [self customizeAccordingToState:CustomizationStateCustom];
    
    [[AVAudioSession sharedInstance]
                setCategory: AVAudioSessionCategoryPlayback
                      error: nil];
    
    NSURL *videoURL = [NSURL fileURLWithPath:videoUrl];
    
    // create an AVPlayer
    videoPlayer = [AVPlayer playerWithURL:videoURL];
    
    // create a player view controller
    avPlayerController = [[AVPlayerViewController alloc]init];
    avPlayerController.player = videoPlayer;
    avPlayerController.showsPlaybackControls = false;
    
    //loops
    videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[videoPlayer currentItem]];
    
    [videoPlayer play];
    
    // remove if the view controller is already present
    UIViewController *vc = [self.childViewControllers lastObject];
    //    NSLog(@"vc %@",vc);
    if ([vc isKindOfClass:[AVPlayerViewController class]]) {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    [[nextUpMainView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // show the view controller
    [self addChildViewController:avPlayerController];
    [nextUpMainView addSubview:avPlayerController.view];
    avPlayerController.view.frame = mainView.bounds;
    
    if (islandScapeEnable) {
        
        [self orientationChangedDetails];
    }
  
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    if(_sessionFlowId == FOLLOWALONG){
        [self endSession];
        return;
    }
    AVPlayerItem *videoPlayerItem = [notification object];
    [videoPlayerItem seekToTime:kCMTimeZero];
}
-(void)playAudioWithName:(NSString *)audioName {
    if (([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame && !isYogaSession) || (isYogaSession && playVoiceOverforYoga)){
        // Construct URL to sound file
        NSString *path = [NSString stringWithFormat:@"%@/%@.wav", [[NSBundle mainBundle] resourcePath],audioName];
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
        //    NSLog(@"su %@",path);
        
        // Create audio player object and initialize with URL to sound
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        audioPlayer.delegate = self;
        UIViewController *vc = [self.navigationController visibleViewController];
        if (vc == self)
            [audioPlayer play];
        
        [self setBackgroundMusicVolume:0.6];
        [audioPlayer setVolume:0.8];
    }else{
        [self inBetweenRoundControll];
    }
}

-(void)playMp3AudioWithName:(NSString *)audioName {
    
    if (([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame && !isYogaSession) || (isYogaSession && playVoiceOverforYoga)) {
        // Construct URL to sound file
        NSString *path = [NSString stringWithFormat:@"%@/%@.mp3", [[NSBundle mainBundle] resourcePath],audioName];
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
        
        
        NSLog(@"Path of Mp3 File %@",[[NSBundle mainBundle] pathForResource:audioName ofType:@"mp3"]);
        
        if(audioPlayer){
            audioPlayer = nil;
        }
        
        // Create audio player object and initialize with URL to sound
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        audioPlayer.delegate = self;
        UIViewController *vc = [self.navigationController visibleViewController];
        if (vc == self)
            [audioPlayer play];
        
        [self setBackgroundMusicVolume:0.6];
        [audioPlayer setVolume:0.8];
    }else{
        [self inBetweenRoundControll];
    }
}

-(void)playMotivationAudioWithName:(NSString *)audioName {
    
    
    if (([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame && !shouldStopMotivation) && (([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame && !isYogaSession) || (isYogaSession && playVoiceOverforYoga))) {    //ahd
        // Construct URL to sound file
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *path = [NSString stringWithFormat:@"%@/%@.wav", documentsDirectory,audioName];
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
        //    NSLog(@"su %@",path);
        
        // Create audio player object and initialize with URL to sound
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        audioPlayer.delegate = self;
        UIViewController *vc = [self.navigationController visibleViewController];
        if (vc == self)
            [audioPlayer play];
        
        [self setBackgroundMusicVolume:0.6];
        [audioPlayer setVolume:0.8];
    }else{
        [self inBetweenRoundControll];
    }
}

-(void)playExNameAudioWithName:(NSString *)audioPath {
    if (([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) || isYogaSession) { //AY 11122017
        // Construct URL to sound file
//        NSString *path = [NSString stringWithFormat:@"%@/%@.wav", [[NSBundle mainBundle] resourcePath],audioName];
        NSURL *soundUrl = [NSURL fileURLWithPath:audioPath];
        //    NSLog(@"su %@",path);
        NSError *error;
        // Create audio player object and initialize with URL to sound
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
        audioPlayer.delegate = self;
        
        if(error){
            NSLog(@"Error Playing Exrecise Name:%@ and Error:%@",[soundUrl absoluteString],error.debugDescription);
        }
        
        UIViewController *vc = [self.navigationController visibleViewController];
        if (vc == self)
            [audioPlayer play];
        [self setBackgroundMusicVolume:0.6];
        [audioPlayer setVolume:0.8];
        
    }else{
        [self inBetweenRoundControll];
    }
}

-(void)incrementCounter{
    dispatch_async(dispatch_get_main_queue(), ^{

    if (isprepTime) {
        timerCount++;
        newTimerCount = (float)timerCount/mainFirstCounter; //div by
//        percentageDoughnut.percentage = newTimerCount;
//        percentageDoughnut.gradientColor1 = [MCUtil iOS7DefaultGrayColorForBackground];
//        percentageDoughnut.gradientColor2 = [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1.0];
        [circleProgressBar setProgress:newTimerCount animated:YES];
        
        firstCounter--;
        int minutes = (firstCounter % 3600) / 60;
        int seconds = (firstCounter %3600) % 60;
        timerCountLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];//add_min
        landScapeTimerCountLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];//add_min
        rightLandScapeTimerCountLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];//add_min

        [circleProgressBar setHintTextGenerationBlock:(YES ? ^NSString *(CGFloat progress) {
            return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        } : nil)];
        [circleProgressBar setHintTextFont:[UIFont fontWithName:@"Raleway-Medium" size:12]];
        
        if (firstCounter == 0) {
            isprepTime = NO;
            timerCount = 0.0;
        }
    }else {
        if (reps > 0) {
            timerCountLabel.hidden = true;//add_n
            landScapeTimerCountLabel.hidden = true;//add_n
            rightLandScapeTimerCountLabel.hidden = true;//add_n

            onTime = offTime = 0;
            [mainTimer invalidate];
//            [audioPlayer pause];
            repsDoneView.hidden = false;
            nextExerciseView.hidden = true; ///add_SB
            circleProgressBar.hidden = true;
            
            repsSetLabel.hidden = false;//add_n
            landscapeRepsSetLabel.hidden = false;//add_n
            rightLandscapeRepsSetLabel.hidden = false;//add_n
            
            //saugata 070118
//            if ([self isBgMusicPlaying]) {
//                [self setBackgroundMusicVolume:0.8];;
//            }
            [self inBetweenRoundControll];
            
            if(isRepsBuzzPlay ){
                
                if(isYogaSession && playBuzzforYoga && !audioPlayer.isPlaying){
                   //[self playBipAudioWithName:@"session_buzzer" Extension:@"wav"]; //AY 12122017
                }else if(!isYogaSession){
                    if ((([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame) && !audioPlayer.isPlaying)) { //&& !appDelegate.mainAudioPlayer.isPlaying
                        
                        //[self playBipAudioWithName:@"session_buzzer" Extension:@"wav"]; //AY 12122017
                    }
                }
                
                
                isRepsBuzzPlay = false;
            } //AY 07122017
        } else {
            if (onTime > 0 ) {  //&& offTime > 0
//                [videoPlayer play];
                timerCount++;
                newTimerCount = (float)timerCount/mainOnTime;
                [circleProgressBar setProgress:newTimerCount animated:YES];
                repsDoneView.hidden = true;    //ah ux
                nextExerciseView.hidden = false; ///add_SB
                
                timerCountLabel.hidden = false; //add_n
                landScapeTimerCountLabel.hidden = false; //add_n
                rightLandScapeTimerCountLabel.hidden = false; //add_n
                repsSetLabel.hidden = true; //add_n
                landscapeRepsSetLabel.hidden = true; //add_n
                rightLandscapeRepsSetLabel.hidden = true; //add_n

                if ((int)timerCount == mainOnTime) {
                    timerCount = 0.0;
                }
                int minutes = (onTime % 3600) / 60;
                int seconds = (onTime %3600) % 60;
                timerCountLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds]; //add_min
                landScapeTimerCountLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds]; //add_min
                rightLandScapeTimerCountLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds]; //add_min
               // timerCountLabel.hidden = YES;//add_min
                
                [circleProgressBar setHintTextGenerationBlock:(YES ? ^NSString *(CGFloat progress) {
                    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
                } : nil)];
                [circleProgressBar setHintTextFont:[UIFont fontWithName:@"Raleway-Medium" size:12]];
                [circleProgressBar setProgressBarProgressColor:([UIColor colorWithRed:244/255.0 green:39/255.0 blue:171.0/255.0 alpha:0.8])];
                
                //ah 17
//                if (onTime < 12) {
                    if (mainOnTime < 11) {
                        if (mainOnTime < 6) {
                            shuffleOnTimeCountdown = 0;
                        } else {
                            if (shuffleOnTimeCountdown == 2) {
                                shuffleOnTimeCountdown = 1;
                            }
                        }
                    }
                
                    if (onTime == 10 && shuffleOnTimeCountdown == 2 && !isshuffleOnCountdownPlayed) {
                        [self playMp3AudioWithName:@"TEN SECONDS TO GO 1"];
                        shuffleOnTimeCountdown--;
                        isshuffleOnCountdownPlayed = YES;
                    } else if (onTime == 6 && shuffleOnTimeCountdown == 1 && !isshuffleOnCountdownPlayed) {
                        [self playMp3AudioWithName:@"countdown5"];
                        shuffleOnTimeCountdown--;
                        isshuffleOnCountdownPlayed = YES;
                    } else if (onTime == 3 && shuffleOnTimeCountdown == 0 && !isshuffleOnCountdownPlayed) {
                        [self playMp3AudioWithName:@"countdownVoice"];
                        shuffleOnTimeCountdown = 2;
                        isshuffleOnCountdownPlayed = YES;
                    }
                
//                }
                //end ah 17
                
                if ((!isHighVolume || !wasPlaying) && onTime == mainOnTime) {
                    [self inBetweenRoundControll];
                }
                if (onTime == mainOnTime && !audioPlayer.isPlaying) {
                   /* if ((![defaults objectForKey:@"Voice Over"] || [[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] || [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame)) {
                        //[self playBipAudioWithName:@"Car-Horn" Extension:@"mp3"];
                        [self playBipAudioWithName:@"session_buzzer" Extension:@"wav"]; //AY 07122017
                        
                    } else if (([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) && ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame) && !appDelegate.mainAudioPlayer.isPlaying) {
                        //                [self playAudioWithName:@"Lets Go" Extension:@"wav"]; //aanew
                        //[self playBipAudioWithName:@"Car-Horn" Extension:@"mp3"];
                        [self playBipAudioWithName:@"session_buzzer" Extension:@"wav"]; //AY 07122017
                    }*/
                    if(isYogaSession && playBuzzforYoga && !audioPlayer.isPlaying){
                        [self playBipAudioWithName:@"session_buzzer" Extension:@"wav"];
                    }else if(!isYogaSession){
                        if ((([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame) && !audioPlayer.isPlaying)) { //&& !appDelegate.mainAudioPlayer.isPlaying
                            
                            [self playBipAudioWithName:@"session_buzzer" Extension:@"wav"]; //AY 07122017
                        }
                    }// AY 11122017
                }
                
                //motivation & saying
                
                    if (onTime == roundf(mainOnTime/2)) {
                        if (onTime > 12) {
                            if (currentCircuit == (dataArray.count/2)+1) {     //saying
                                NSMutableArray *newSayingArray = [[NSMutableArray alloc]init];
                                int remainingTime = mainOnTime - 10;
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
                                    [self playMotivationAudioWithName:[[newSayingArray objectAtIndex:randomIndex] objectForKey:@"name"]];
                                    [sayingArray removeObjectAtIndex:[[[newSayingArray objectAtIndex:randomIndex] objectForKey:@"index"] intValue]];
                                }
                            } else {
                                NSMutableArray *newMotivationArray = [[NSMutableArray alloc]init];
                                int remainingTime = mainOnTime - 10;
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
                                    [self playMotivationAudioWithName:[[newMotivationArray objectAtIndex:randomIndex] objectForKey:@"name"]];
                                    [motivationArray removeObjectAtIndex:[[[newMotivationArray objectAtIndex:randomIndex] objectForKey:@"index"] intValue]];
                                }
                            }
                        }
                    }
                
                //end motivation & saying
                
                onTime--;
            } else if (onTime == 0 && offTime > 0){     //&& !isSuperSet
                if (!isNextUpPlaying) {
                    [self playNextUpWithTime:NO]; // Change YES to NO AY 23022018
                }
                
                timerCount++;
                newTimerCount = (float)timerCount/mainOffTime;
                [nextUpCircleProgressBar setProgress:newTimerCount animated:YES];
                
                if ((int)timerCount == mainOffTime) {
                    timerCount = 0.0;
                }
                
                if ((isHighVolume || wasPlaying) && offTime == mainOffTime) {
                    [self inBetweenRoundControll];
                }
                
                offTime--;
//                int minutes = (offTime % 3600) / 60;
//                int seconds = (offTime %3600) % 60;
                //                timerCountLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
                
                int timerCountforRest=(int)newTimerCount;
                nextUpTimerlabel.text =[NSString stringWithFormat:@"%02d",timerCountforRest]; //add_n
                landscapeNextUpTimerLabel.text =[NSString stringWithFormat:@"%02d",timerCountforRest];
                rightLandscapeNextUpTimerLabel.text =[NSString stringWithFormat:@"%02d",timerCountforRest];

                [nextUpCircleProgressBar setHintTextGenerationBlock:(YES ? ^NSString *(CGFloat progress) {
                    //return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
                    return @"";
                } : nil)];
                [nextUpCircleProgressBar setHintTextFont:[UIFont fontWithName:@"Raleway-Medium" size:12]];
                [nextUpCircleProgressBar setProgressBarProgressColor:([UIColor colorWithRed:0.2 green:0.7 blue:1.0 alpha:0.8])];
                
                
  
            } else {
                //                [self nextVideo];       //ah 23.6
               /* if (!isNextUpPlaying) {
                    if (videoCounter < dataArray.count) {
                        [mainTimer invalidate];
                        [self playNextUpWithTime:NO];
                    } else {
                        [self nextVideo];
                    }
                } else {
                    isNameAudioPlaying = NO;
                    nextUpView.hidden = true;
                    parentScroll.scrollEnabled = true;
                    isNextUpPlaying = NO;
                    [self nextVideo];
                }*/
                [self forwardButtonTapped:0];
            }
        }
    }
    });
}
-(void)nextVideo {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self->islandScapeEnable){//chng//
            if (self->isNextUpPlaying) {
                self->landscapeView.hidden = true;
                self->nextUpView.hidden = true;
                self->landscapeNextUpView.hidden = false;
                
            }else{
                self->landscapeView.hidden = false;
                self->nextUpView.hidden = true; //chng//
                self->landscapeNextUpView.hidden = true;
            }
        }//chng//
        
    if(!self->loadingView.isHidden){
        self->loadingView.hidden = true;
    }
        
    if(self->contentView){
        [self->contentView removeFromSuperview];
        [self->contentViewLabel removeFromSuperview];
        [self->progressView removeFromSuperview];
    }
       

    self->isshuffleOnCountdownPlayed = NO;
    
    self->currentCircuit ++;
    [self->circleProgressBar setHintTextGenerationBlock:(YES ? ^NSString *(CGFloat progress) {
        return @"";
    } : nil)];
    if (self->videoCounter < self->dataArray.count) {
        if ([[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"isCircuit"] boolValue]) {
            BOOL isCircuit = NO;
            if(self->videoCounter == 0 || self->videoCounter+1 == self->dataArray.count || self->isRepeat){ //self->videoCounter == 0 ||
                isCircuit = NO;
                //self->isRepeat = NO;
            }else{
                isCircuit = YES;
            }
            
            self->cktName = [[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"ExerciseName"];
            self->currentCount++;
            [self->exerciseTable reloadData];
            self->audioCounter++;
            self->videoCounter++;
            
            if((self->_sessionFlowId == TIMER || self->_sessionFlowId == CIRCUITTIMER) && isCircuit){
                if(self->currentCircuitTime>0 && !self->isSkip){
                    [self resetCircuit];;
                }else{
                    self->isSkip = NO;
                    if(self->videoCounter == self->dataArray.count){
                        
                        self->currentCircuitTime = [[[self->dataArray objectAtIndex:self->videoCounter-1] objectForKey:@"CircuitMinutes"] intValue];
                        self->currentCircuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter-1] objectForKey:@"circuitIndex"] intValue];
                    }else{
                        
                        self->currentCircuitTime = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"CircuitMinutes"] intValue];
                        self->currentCircuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"circuitIndex"] intValue];
                    }
                    
                    [self startCircuitCounter];
                }
            }else{
                self->isSkip = NO;
                if(self->_sessionFlowId == TIMER || self->_sessionFlowId == CIRCUITTIMER){
                    
                    if(self->isRepeat){
                        self->isRepeat = NO;
                    }else if(self->videoCounter == self->dataArray.count){
                        
                        self->currentCircuitTime = [[[self->dataArray objectAtIndex:self->videoCounter-1] objectForKey:@"CircuitMinutes"] intValue];
                        self->currentCircuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter-1] objectForKey:@"circuitIndex"] intValue];
                    }else{
                        
                        self->currentCircuitTime = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"CircuitMinutes"] intValue];
                        self->currentCircuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"circuitIndex"] intValue];
                    }
                    
                    [self nextVideo];
                }else{
                    if(self->videoCounter>2){
                        [self startCircuitCounter];
                    }else{
                        [self nextVideo];
                    }
                }
                
            }
            
            
        } else {
            
            if((self->_sessionFlowId == TIMER || self->_sessionFlowId == CIRCUITTIMER)){
                if(self->isSkip){
                    self->isSkip = NO;
                    int circuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"circuitIndex"] intValue];
                    if(self->currentCircuitIndex != circuitIndex){
                        self->circuitCount = 1;
                        self->currentCircuitTime = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"CircuitMinutes"] intValue];
                        self->currentCircuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"circuitIndex"] intValue];
                    }
                }
                
            }
            
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            self->nextUpTopConstant.constant = 340; ///add_SB 340
            
            self->isNextUp = true; ///add_SB
            self->exerciseTable.hidden = true; ///add_SB
            self->exerciseTableHeightConstraint.constant =0; ///add_SB
            
            NSString *destinationFilename = [NSString stringWithFormat:@"%@.mp4",[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"ExerciseName"]];
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* documentsDirectory = [paths objectAtIndex:0];
            NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:destinationFilename];
            NSURL *destinationURL = [NSURL fileURLWithPath:fullPathToFile];
            
            BOOL isReCheckedDownload = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"isReCheckedDownload"] boolValue];
            
            if (([fileManager fileExistsAtPath:[destinationURL path]] && ![self checkDownloadFileSize:fullPathToFile]) || isReCheckedDownload) {
                
                if (![Utility isInt:[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"srNo"]]) {
                    self->shouldCktTitleShow = YES;
                    self->circuitNameLabel.text = self->cktName;
                } else {
                    self->shouldCktTitleShow = NO;
                    self->circuitNameLabel.text = @"";
                }
                if (self->videoCounter > 0 && ![[[self->dataArray objectAtIndex:(self->videoCounter-1)] objectForKey:@"isCircuit"] boolValue] && (self->backwardButton.alpha < 1 || self->landscapeBackwardButton.alpha < 1 || self->landscapeRightSideBackwardButton.alpha < 1 )) {
                    [self->backwardButton setAlpha:1.0];
                    self->backwardButton.userInteractionEnabled = YES;
                    
                    [self->landscapeBackwardButton setAlpha:1.0];
                    self->landscapeBackwardButton.userInteractionEnabled = YES;
                    [self->landscapeRightSideBackwardButton setAlpha:1.0];
                    self->landscapeRightSideBackwardButton.userInteractionEnabled = YES;

                } else if (self->videoCounter == self->dataArray.count-1){
                    [self->forwardButton setAlpha:0.5];
                    self->forwardButton.userInteractionEnabled = NO;
                    [self->landscapeForwardButton setAlpha:0.5];
                    self->landscapeForwardButton.userInteractionEnabled = NO;
                    self->nextExerciseButton.userInteractionEnabled = NO; ///add_SB
                    [self->landscapeRightSideForwardButton setAlpha:0.5];
                    self->landscapeRightSideForwardButton.userInteractionEnabled = NO;

                }else{
                    [self->backwardButton setAlpha:1.0];
                    [self->landscapeBackwardButton setAlpha:1.0];
                    [self->landscapeRightSideBackwardButton setAlpha:1.0];
                    [self->forwardButton setAlpha:1.0];
                    [self->landscapeForwardButton setAlpha:1.0];
                    [self->landscapeRightSideForwardButton setAlpha:1.0];
                    self->backwardButton.userInteractionEnabled = YES;
                    self->landscapeBackwardButton.userInteractionEnabled = YES;
                    self->landscapeRightSideBackwardButton.userInteractionEnabled = YES;
                    self->forwardButton.userInteractionEnabled = YES;
                    self->landscapeForwardButton.userInteractionEnabled = YES;
                    self->landscapeRightSideForwardButton.userInteractionEnabled = YES;
                    self->nextExerciseButton.userInteractionEnabled = YES;
                }
                
                NSLog(@"videoUrl Played-%@",[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"videoUrl"]);
                
                [self playVideoWithName:[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"videoUrl"]];
                
                self->currentCount++;
                [self->exerciseTable reloadData];
                
                self->titleLabel.text = [[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"ExerciseName"];
                self->leftLandscapeTitleLabel.text = [[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"ExerciseName"];
                self->rightlandscapeTitleLabel.text = [[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"ExerciseName"];
                
                if (self->videoCounter+1 < self->dataArray.count) {
                    self->exerciseNameLabel.text = [[self->dataArray objectAtIndex:self->videoCounter+1] objectForKey:@"ExerciseName"];
                }else{
                    self->exerciseNameLabel.text = @"";
                }
                
                int repsNo = 0;
                NSString *repStr = @"reps";
                if ([[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps"] == NSOrderedSame) {
                    repsNo = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepGoal"] intValue];
//                    if(repsNo == 0){
//                        repsNo = 10;
//                    }
                    repsSetLabel.text = [NSString stringWithFormat:@"%d %@",repsNo,repStr];
                    landscapeRepsSetLabel.text = [NSString stringWithFormat:@"%d %@",repsNo,repStr];
                    rightLandscapeRepsSetLabel.text = [NSString stringWithFormat:@"%d %@",repsNo,repStr];


                } else if ([[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame) {
                    repsNo = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepGoal"] intValue];
                    if (repSideCountPlay == 0) {
                        repStr = @"reps side 1";
                        repSideCountPlay = 1;
                    } else if (repSideCountPlay == 1) {
                        repStr = @"reps side 2";
                        repSideCountPlay = 0;
                    }
                    repsSetLabel.text = [NSString stringWithFormat:@"%d %@",repsNo,repStr];
                    landscapeRepsSetLabel.text = [NSString stringWithFormat:@"%d %@",repsNo,repStr];
                    rightLandscapeRepsSetLabel.text = [NSString stringWithFormat:@"%d %@",repsNo,repStr];

                } else if ([[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Seconds Each Side"] == NSOrderedSame) {
                    if (repSideCountPlay == 0) {
                        repStr = @"side 1";
                        repSideCountPlay = 1;
                    } else if (repSideCountPlay == 1) {
                        repStr = @"side 2";
                        repSideCountPlay = 0;
                    }
                    repsSetLabel.text = [NSString stringWithFormat:@"%@",repStr];
                    landscapeRepsSetLabel.text = [NSString stringWithFormat:@"%@",repStr];
                    rightLandscapeRepsSetLabel.text = [NSString stringWithFormat:@"%@",repStr];

                } else {
                    repsSetLabel.text = @"";
                    landscapeRepsSetLabel.text = @"";
                    rightLandscapeRepsSetLabel.text = @"";
                }
                
                
                int setCountNo = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"setCount"] intValue];
                if (setCountNo <= 0) {
                    setCountNo = 1;
                }
                
                roundID = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"id"] intValue];
                
                if ([[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps"] == NSOrderedSame || [[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame)//|| [[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame
                {
                    reps = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepGoal"] intValue];
                    if(reps == 0){
                        reps = 10;
                    }
                    isRepsBuzzPlay = true;
                } else {
                    mainOnTime = onTime = [self getTimeFromString:[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepGoal"]];
                    mainOffTime = offTime = [self getTimeFromString:[[dataArray objectAtIndex:videoCounter] objectForKey:@"offTime"]];
                    reps = 0;
                    isRepsBuzzPlay = false;
                }
                
                setCount = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"setCount"] intValue];
                if (setCount <= 0) {
                    setCount = 1;
                }
                
                int isSuperSetCount = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"isSuperSet"] intValue];
                if (isSuperSetCount > 0) {
                    isSuperSet = true;
                } else if (isSuperSetCount == 0) {
                    isSuperSet = false;
                }
                audioCounter++;
                videoCounter++;
                
                if (prevRoundID == roundID || roundID == 0) {
                    isprepTime = NO;
                } else {
                    isprepTime = YES;
                    prevRoundID = roundID;
                    mainFirstCounter = firstCounter = [self getTimeFromString:_prepTime];
                    
                }
                timerCount = 0.0;
                
                int minutes = (offTime % 3600) / 60;
                int seconds = (offTime %3600) % 60;
                if (isprepTime) {
                    timerCountLabel.hidden = false;
                    timerCountLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
                    landScapeTimerCountLabel.hidden = false;
                    landScapeTimerCountLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
                    rightLandScapeTimerCountLabel.hidden = false;
                    rightLandScapeTimerCountLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];

                }else{
                    timerCountLabel.text = @"";
                    timerCountLabel.hidden = true;
                    landScapeTimerCountLabel.text = @"";
                    landScapeTimerCountLabel.hidden = true;
                    rightLandScapeTimerCountLabel.text = @"";
                    rightLandScapeTimerCountLabel.hidden = true;
                }
                if (![mainTimer isValid]) {
                    mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
                }
                
                isprepTime = NO;
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                       if(!loadingView.isHidden){
                           loadingView.hidden = true;
                       }
                        if(contentView){
                            [contentView removeFromSuperview];
                            [contentViewLabel removeFromSuperview];
                            [progressView removeFromSuperview];
                        }
                    });
                
                    NSMutableDictionary *dict = [dataArray objectAtIndex:videoCounter];
                    [dict setObject:[NSNumber numberWithBool:1] forKey:@"isReCheckedDownload"];
                    [dataArray removeObjectAtIndex:videoCounter];
                    [dataArray insertObject:dict atIndex:videoCounter];
                
                
                    NSString *videoName = [[dataArray objectAtIndex:videoCounter] objectForKey:@"ExerciseName"];
                
                    if([Utility reachable]){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //contentView = [Utility activityIndicatorView:self];   //ah go
                            //[self contentViewLabelWithText:@"Downloading Video Files"];
                            if(loadingView.isHidden){
                                loadingView.hidden = false;
                            }
                        });
                        
                        isFirstExDownloading = YES;
                        [self downloadSingleVideo:videoName dataIndex:videoCounter];
                        [self playPauseButtonTapped:playPauseButton];

                    }else{
                        [self playPauseButtonTapped:playPauseButton];

                        [self errorDownloadingAlert:[videoName stringByAppendingString:@" Video not downloaded.Check Your network connection and try again."] title:@"Oops! "];
                        return;
                    }// AY 22022018
            }
        }
    } else {
        [self endSession];
    }
    });
}
-(void)roundCircuitDetails{
    if (!self->roundTimer.isValid) {
        [self playPauseButtonTapped:self->playPauseButton];
        
        self->circuitCount = self->circuitCount + 1;
        self->roundTimerLabel.text = @"5";
        self->roundNumberLabel.text = [NSString stringWithFormat:@"ROUND : %d",self->circuitCount];
        self->roundTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(roundCircuitCounter) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self->roundTimer forMode:NSRunLoopCommonModes];
        self->roundNumberShowView.hidden = false;
        [self orientationChangedDetails]; //Update
    }
}
-(void)roundCircuitCounter{
    dispatch_async(dispatch_get_main_queue(), ^{
        int roundCount = [self->roundTimerLabel.text intValue];
        roundCount--;
        self->roundTimerLabel.text = [NSString stringWithFormat:@"%d",roundCount];
        if (roundCount <= 0) {
            [self->roundTimer invalidate];
            self->roundNumberShowView.hidden = true;
            [self playPauseButtonTapped:playPauseButton];
            [self forwardButtonTapped:0];
        }
    });

}
-(void)playPreviousVideo:(int)counter{
    
    int tempCounter = counter - 2;
    
   if (tempCounter > 0 && tempCounter  < dataArray.count) {
        if ([[[dataArray objectAtIndex:tempCounter] objectForKey:@"isCircuit"] boolValue]) {
           
            [self playPreviousVideo:tempCounter];
        } else {
            
            currentCircuit = tempCounter;
            currentCount = tempCounter;
            videoCounter = tempCounter;
            audioCounter = tempCounter;
            
            
            if (videoCounter == 1) {
                [backwardButton setAlpha:0.5];
                backwardButton.userInteractionEnabled = NO;
                [landscapeBackwardButton setAlpha:0.5];
                landscapeBackwardButton.userInteractionEnabled = NO;
                
                [landscapeRightSideBackwardButton setAlpha:0.5];
                landscapeRightSideBackwardButton.userInteractionEnabled = NO;
            }else{
                [backwardButton setAlpha:1.0];
                backwardButton.userInteractionEnabled = YES;
                [landscapeBackwardButton setAlpha:1.0];
                landscapeBackwardButton.userInteractionEnabled = YES;
                [landscapeRightSideBackwardButton setAlpha:1.0];
                landscapeRightSideBackwardButton.userInteractionEnabled = YES;
            }
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [exerciseTable setContentOffset:CGPointZero animated:YES];
                [mainTimer invalidate];
                //    [sessionTimer invalidate];
                mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
                [playPauseButton setImage:[UIImage imageNamed:@"timer_pause_button.png"] forState:UIControlStateNormal];
                [landScapePlayPauseButton setImage:[UIImage imageNamed:@"pause_vid_exVdo.png"] forState:UIControlStateNormal];
                [rightLandScapePlayPauseButton setImage:[UIImage imageNamed:@"pause_vid_exVdo.png"] forState:UIControlStateNormal];

                isPlaying = YES;
                //    [self nextVideo];
                if (!isNextUpPlaying) {
                    
                    [self nextVideo];
                    
                } else {
                    isNameAudioPlaying = NO;
                    nextUpView.hidden = true;
                    parentScroll.scrollEnabled = true;
                    isNextUpPlaying = NO;
                    [self nextVideo];
                }
            });
        }
    }else{
        [backwardButton setAlpha:0.5];
        backwardButton.userInteractionEnabled = NO;
        [landscapeBackwardButton setAlpha:0.5];
        landscapeBackwardButton.userInteractionEnabled = NO;
        
        [landscapeRightSideBackwardButton setAlpha:0.5];
        landscapeRightSideBackwardButton.userInteractionEnabled = NO;
        

    }
}// AY 05032018

-(void)previousVideo{
    currentCircuit -= 2;
    currentCount -= 2;
    videoCounter -= 2;
    audioCounter -= 2;
    
    BOOL isCkt = NO;
    if ([[[dataArray objectAtIndex:videoCounter] objectForKey:@"isCircuit"] boolValue]) {
        isCkt = YES;
    }
    [forwardButton setAlpha:1];
    forwardButton.userInteractionEnabled = YES;
    [landscapeForwardButton setAlpha:1];
    landscapeForwardButton.userInteractionEnabled = YES;
    [landscapeRightSideForwardButton setAlpha:1];
    landscapeRightSideForwardButton.userInteractionEnabled = YES;

    nextExerciseButton.userInteractionEnabled = YES; ///add_SB


    BOOL isFirst = YES;
    for (int i = videoCounter-1; i > 0; i--) {
        currentCircuit --;
        currentCount --;
        videoCounter --;
        audioCounter --;
        
        if (![[[dataArray objectAtIndex:i] objectForKey:@"isCircuit"] boolValue]) {
            isFirst = NO;
            break;
        }
    }
    if (isFirst) {
        [backwardButton setAlpha:0.5];
        backwardButton.userInteractionEnabled = NO;
        [landscapeBackwardButton setAlpha:0.5];
        landscapeBackwardButton.userInteractionEnabled = NO;
        [landscapeRightSideBackwardButton setAlpha:0.5];
        landscapeRightSideBackwardButton.userInteractionEnabled = NO;
        
    }
    [self nextVideo];
    
    
    
//    if (videoCounter > 1) {
//        if (videoCounter == 2) {
//            [backwardButton setAlpha:0.5];
//            backwardButton.userInteractionEnabled = NO;
//        } else if (videoCounter == dataArray.count){
//            [forwardButton setAlpha:1.0];
//            forwardButton.userInteractionEnabled = YES;
//        }
//        videoCounter -= 2;
//        audioCounter -= 2;
//        
//        currentCount--;
//        [exerciseTable reloadData];
//        
//        [self playVideoWithName:[[dataArray objectAtIndex:videoCounter] objectForKey:@"videoUrl"]];
//        
//        if ([[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps"] == NSOrderedSame || [[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame) {
//            reps = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepGoal"] intValue];
//        } else {
//            mainOnTime = onTime = [self getTimeFromString:[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepGoal"]];
//            mainOffTime = offTime = [self getTimeFromString:[[dataArray objectAtIndex:videoCounter] objectForKey:@"offTime"]];
//            reps = 0;
//        }
//        
//        setCount = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"setCount"] intValue];
//        if (setCount <= 0) {
//            setCount = 1;
//        }
//
//        int isSuperSetCount = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"isSuperSet"] intValue];
//        if (isSuperSetCount == 1) {
//            isSuperSet = true;
//        } else if (isSuperSetCount == 2) {
//            isSuperSet = false;
//        }
//        titleLabel.text = [[dataArray objectAtIndex:videoCounter] objectForKey:@"ExerciseName"];
//        
//        int repsNo = 0;
//        NSString *repStr = @"reps";
//        if ([[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps"] == NSOrderedSame) {
//            repsNo = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepGoal"] intValue];
//            repsSetLabel.text = [NSString stringWithFormat:@"%d %@",repsNo,repStr];
//
//        } else if ([[[dataArray objectAtIndex:0] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame) {
//            repsNo = [[[dataArray objectAtIndex:0] objectForKey:@"RepGoal"] intValue];
//            if (repSideCount == 0) {
//                repStr = @"reps side 1";
//                repSideCount = 1;
//            } else if (repSideCount == 1) {
//                repStr = @"reps side 2";
//                repSideCount = 0;
//            }
//            repsSetLabel.text = [NSString stringWithFormat:@"%d %@",repsNo,repStr];
//
//        } else if ([[[dataArray objectAtIndex:0] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Seconds Each Side"] == NSOrderedSame) {
//            repsNo = [[[dataArray objectAtIndex:0] objectForKey:@"RepGoal"] intValue];
//            if (repSideCount == 0) {
//                repStr = @"side 1";
//                repSideCount = 1;
//            } else if (repSideCount == 1) {
//                repStr = @"side 2";
//                repSideCount = 0;
//            }
//            repsSetLabel.text = [NSString stringWithFormat:@"%@",repStr];
//
//        } else {
//            repsSetLabel.text = @"";
//
//        }
//        
//        int setCountNo = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"setCount"] intValue];
//        if (setCountNo <= 0) {
//            setCountNo = 1;
//        }
//        
//        roundID = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"id"] intValue];
//        
//        audioCounter++;
//        videoCounter++;
//        
//        if (videoCounter-2 < 0) {
//            isprepTime = YES;
//            prevRoundID = roundID;
//            mainFirstCounter = firstCounter = [self getTimeFromString:_prepTime];
//        } else {
//            prevRoundID = [[[dataArray objectAtIndex:videoCounter-2] objectForKey:@"id"] intValue];
//            if (prevRoundID == roundID) {
//                isprepTime = NO;
//            } else {
//                isprepTime = YES;
//                prevRoundID = roundID;
//                mainFirstCounter = firstCounter = [self getTimeFromString:_prepTime];
//            }
//        }
//    
//        int minutes = (offTime % 3600) / 60;
//        int seconds = (offTime %3600) % 60;
//        timerCountLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
//    } else {
//        
//    }
}

-(void)prepareProgressView{
    @autoreleasepool {
    /*percentageDoughnut = [[MCPercentageDoughnutView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    percentageDoughnut.dataSource              = self;
    percentageDoughnut.percentage              = 0.0;
    percentageDoughnut.linePercentage          = 0.1;
    percentageDoughnut.animationDuration       = 2;
    percentageDoughnut.decimalPlaces           = 1;
    percentageDoughnut.showTextLabel           = NO;
    percentageDoughnut.animatesBegining        = NO;
    percentageDoughnut.fillColor               = [UIColor greenColor];
    percentageDoughnut.unfillColor             = [MCUtil iOS7DefaultGrayColorForBackground];
    percentageDoughnut.textLabel.textColor     = [UIColor blackColor];
    percentageDoughnut.textLabel.font          = [UIFont systemFontOfSize:50];
    percentageDoughnut.gradientColor1          = [MCUtil iOS7DefaultGrayColorForBackground];
    percentageDoughnut.gradientColor2          = [UIColor colorWithRed:(112/255.0) green:(153/255.0) blue:(253/255.0) alpha:1.0];
    
    
    percentageDoughnut.roundedBackgroundImage = [UIImage imageNamed:@"rounded-shadowed-background"];
    percentageDoughnut.roundedImageOverlapPercentage = 0.08;
    percentageDoughnut.enableGradient = YES;
    [percentageDoughnut reloadData];
    
    [customProgressView addSubview:percentageDoughnut];
        */
    }
}

-(int)getTimeFromString:(NSString *)str {
    if ([str containsString:@":"]) {
        NSArray *timeArray = [str componentsSeparatedByString:@":"];
        int minutes = [[timeArray objectAtIndex:0] intValue];
        int seconds = [[timeArray objectAtIndex:1] intValue];
        return minutes*60 + seconds;
    } else {
        return [str intValue];
    }
}

-(void)sessionCounter {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_sessionFlowId == TIMER || _sessionFlowId == CIRCUITTIMER){
            sessionTimeCounter--;
            
            if(currentCircuitTime>0 && sessionTimeCounter>0){
                currentCircuitTime--;
                
                if(currentCircuitTime <= 0){
                    [self jumpToNextCircuit];
                    return;
                }
            }
            
            if(sessionTimeCounter == 0){
                [self endSession];
                return;
            }
            
        }else{
            sessionTimeCounter++;
        }
        
        if(_sessionFlowId == CIRCUITTIMER){
            int hour = currentCircuitTime /3600;
            int minutes = (currentCircuitTime % 3600) / 60;
            int seconds = (currentCircuitTime %3600) % 60;
            if(hour>0){
                sessionTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minutes, seconds];
                landscapeSessionTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minutes, seconds];
                rightLandscapeSessionTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minutes, seconds];

            }else{
                sessionTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
                landscapeSessionTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
                rightLandscapeSessionTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];

            }
            
        }else{
            int hour = sessionTimeCounter /3600;
            int minutes = (sessionTimeCounter % 3600) / 60;
            int seconds = (sessionTimeCounter %3600) % 60;
            if(hour>0){
                sessionTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minutes, seconds];
                landscapeSessionTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minutes, seconds];
                rightLandscapeSessionTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minutes, seconds];

            }else{
                sessionTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
                landscapeSessionTimeLabel.text=[NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
                rightLandscapeSessionTimeLabel.text=[NSString stringWithFormat:@"%02d:%02d", minutes, seconds];

            }
        }
        
        
    });
}

-(void)downloadVideoWithName:(NSString *)videoName dataIndex:(int)dataIndex {
    
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",videoName]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSURL *destinationURL = [NSURL fileURLWithPath:fullPathToFile];
    
        NSMutableDictionary *dict = [dataArray objectAtIndex:dataIndex];
        [dict setObject:fullPathToFile forKey:@"videoUrl"];
        [dict setObject:[NSNumber numberWithBool:0] forKey:@"isReCheckedDownload"];
        [dataArray removeObjectAtIndex:dataIndex];
        [dataArray insertObject:dict atIndex:dataIndex];
    
    
        
        if (![fileManager fileExistsAtPath:[destinationURL path]] || [self checkDownloadFileSize:fullPathToFile]) {
           
            if(![Utility reachable]){
                return;
            }
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSString *newVideoName = [videoName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                if (session) {
                    
                    // NSLog(@"Video Download Server URL-%@",[NSString stringWithFormat:@"%@/exercise_videos/Mini/%@.mp4",BASEURL_ABBBC,newVideoName]);
                    downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.mp4",BASE_VIDEO_DOWNLOAD_URL,newVideoName]]];
                    [downloadTask resume];
                }
            }];
        }else{
            totalMediaDownloaded++;
            if(totalMediaDownloaded == totalMediaCount){
                [self downloadStatusUpdate];
            }
            
            
        }
    
}

-(BOOL)isAudioExist:(NSString *)audioURL{
    BOOL isExist = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *destinationURL = [NSURL fileURLWithPath:audioURL];
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]) {
        isExist = YES;
    }
    
    return isExist;
    
}

- (void)downloadAudioWithName:(NSString *)audioName dataIndex:(int)dataIndex{
    
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",audioName]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *destinationURL = [NSURL fileURLWithPath:fullPathToFile];
        
        NSString* fullPathToFileMp3 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",audioName]];
        NSURL *destinationURLMp3 = [NSURL fileURLWithPath:fullPathToFileMp3];

        if ([fileManager fileExistsAtPath:[destinationURL path]]) {
            //don't download
            NSMutableDictionary *dict = [dataArray objectAtIndex:dataIndex];
            [dict setObject:fullPathToFile forKey:@"audioUrl"];
            [dataArray removeObjectAtIndex:dataIndex];
            [dataArray insertObject:dict atIndex:dataIndex];
            totalMediaDownloaded++;
            if(totalMediaDownloaded == totalMediaCount){
                [self downloadStatusUpdate];
            }
            
        } else if ([fileManager fileExistsAtPath:[destinationURLMp3 path]]) {
            //don't download
            NSMutableDictionary *dict = [dataArray objectAtIndex:dataIndex];
            [dict setObject:fullPathToFileMp3 forKey:@"audioUrl"];
            [dataArray removeObjectAtIndex:dataIndex];
            [dataArray insertObject:dict atIndex:dataIndex];
            totalMediaDownloaded++;
            if(totalMediaDownloaded == totalMediaCount){
                [self downloadStatusUpdate];
            }
            
            
        } else {
            
            if(![Utility reachable]){
               return;
            }
            
            NSString *newAudioName = [audioName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

            //NSLog(@"Audio Download URL -%@",[NSString stringWithFormat:@"%@/content/audio/%@.wav",@"https://www.thesquadtours.com",newAudioName]);
            
            NSURLSession *checkingSession = [NSURLSession sharedSession];
            [[checkingSession dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.wav",BASE_AUDIO_DOWNLOAD_URL,newAudioName]]
                    completionHandler:^(NSData *data,
                                        NSURLResponse *response,
                                        NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (!error) {
                                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                    if (statusCode == 200) {
                                        [audioDownloadQueue addOperationWithBlock:^{
                                            if (audioUrlSession) {
                                                NSMutableDictionary *dict = [dataArray objectAtIndex:dataIndex];
                                                [dict setObject:fullPathToFile forKey:@"audioUrl"];
                                                [dataArray removeObjectAtIndex:dataIndex];
                                                [dataArray insertObject:dict atIndex:dataIndex];
                                                
                                                audioDownloadTask = [audioUrlSession downloadTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.wav",BASE_AUDIO_DOWNLOAD_URL,newAudioName]]];
                                                [audioDownloadTask resume];
                                            }
                                        }];
                                    } else {
                                        [audioDownloadQueue addOperationWithBlock:^{
                                            if (audioUrlSession) {
                                                NSMutableDictionary *dict = [dataArray objectAtIndex:dataIndex];
                                                [dict setObject:fullPathToFileMp3 forKey:@"audioUrl"];
                                                [dataArray removeObjectAtIndex:dataIndex];
                                                [dataArray insertObject:dict atIndex:dataIndex];
                                                audioDownloadTask = [audioUrlSession downloadTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.mp3",BASE_AUDIO_DOWNLOAD_URL,newAudioName]]];
                                                [audioDownloadTask resume];
                                            }
                                        }];
                                    }
                                }
                            }
                        });
                    }] resume];
        }
    
}
-(void) contentViewLabelWithText:(NSString *)lblText {
    if (![self.view.subviews containsObject:contentViewLabel]) {
        UIFont * customFont = [UIFont fontWithName:@"Raleway-SemiBold" size:20]; //custom font
        NSString * text = lblText;
        
        //    CGSize lblSize = [lblText sizeWithAttributes: @{NSFontAttributeName: customFont}];
        
        contentViewLabel = [[UILabel alloc]initWithFrame:CGRectMake(contentView.frame.size.width/2-150,contentView.frame.size.height/2, 300, 100)];
        contentViewLabel.text = text;
        contentViewLabel.font = customFont;
        contentViewLabel.numberOfLines = 1;
        contentViewLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
        contentViewLabel.adjustsFontSizeToFitWidth = YES;
        contentViewLabel.minimumScaleFactor = 10.0f/12.0f;
        contentViewLabel.clipsToBounds = YES;
        contentViewLabel.backgroundColor = [UIColor clearColor];
        contentViewLabel.textColor = [UIColor blackColor];
        contentViewLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:contentViewLabel];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentViewLabel
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                               constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentViewLabel
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0
                                                               constant:50.0]];
        
        progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.progressTintColor = [UIColor greenColor];
        progressView.trackTintColor = [UIColor whiteColor];
        [[progressView layer]setFrame:CGRectMake(contentViewLabel.frame.origin.x,contentViewLabel.frame.origin.y + 30, 300, 5)];
        [progressView setProgress:0 animated:YES];
        [[progressView layer]setMasksToBounds:TRUE];
        progressView.clipsToBounds = YES;
        [self.view addSubview:progressView];

        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:progressView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:contentViewLabel
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:10.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:progressView
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                               constant:50.0]];
    } else {
        contentViewLabel.text = lblText;
    }
}

-(void)inBetweenRoundControll {
    if ([[defaults objectForKey:@"Inbetween Rounds"] caseInsensitiveCompare:@"PLAY SOFTER"] == NSOrderedSame && [self isBgMusicPlaying]) {
        
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
            
            //            [[MPMusicPlayerController systemMusicPlayer] setVolume:0.5];
            [self setBackgroundMusicVolume:0.6];    //music volume
            [audioPlayer setVolume:1.0];
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
            //            audioPlayer.volume = 0.8;
            [self setBackgroundMusicVolume:0.8];    //music volume
            [audioPlayer setVolume:0.8];
            isHighVolume = YES;
        }
        
//        [self setBackgroundMusicVolume:0.6];    music volume
//        [audioPlayer setVolume:0.8];
    } else if ([[defaults objectForKey:@"Inbetween Rounds"] caseInsensitiveCompare:@"STOPS PLAYING"] == NSOrderedSame) {
        if (wasPlaying && [self isBgMusicPlaying]) {
            [self stopMusic];
            //suchandra 2/1/17
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isMusicPaused"];
            //
            wasPlaying = NO;
        } else {
            [self startMusic];
            //suchandra 2/1/17
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isMusicPaused"];
            //
            wasPlaying = YES;
        }
        
    }else{
        [self setBackgroundMusicVolume:0.8];    //music volume
        [audioPlayer setVolume:0.6];
    }
}
-(void)playBipAudioWithName:(NSString *)audioName Extension:(NSString *)extension{
    // Construct URL to sound file
    NSString *path = [NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath],audioName,extension];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    // Create audio player object and initialize with URL to sound
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    audioPlayer.delegate = self;
    //        NSLog(@"avv %f",audioPlayer.volume);
    UIViewController *vc = [self.navigationController visibleViewController];
    if (vc == self)
        [audioPlayer play];
    
    [self setBackgroundMusicVolume:0.6];
    [audioPlayer setVolume:0.8];
}

- (void)customizeAccordingToState:(CustomizationState)state {
    BOOL customized = state != CustomizationStateDefault;
    
    // Progress Bar Customization
    [circleProgressBar setProgressBarWidth:(customized ? 5.0f : 0)];
    [circleProgressBar setProgressBarProgressColor:(customized ? [UIColor colorWithRed:0.2 green:0.7 blue:1.0 alpha:0.8] : nil)];
    [circleProgressBar setProgressBarTrackColor:(customized ? [Utility colorWithHexString:@"efefef"] : nil)];
    
    // Hint View Customization
    [circleProgressBar setHintViewSpacing:(customized ? 10.0f : 0)];
    [circleProgressBar setHintViewBackgroundColor:(customized ? [UIColor colorWithWhite:1.000 alpha:0.800] : nil)];

    // Progress Bar Customization
    [nextUpCircleProgressBar setProgressBarWidth:(customized ? 5.0f : 0)];
    [nextUpCircleProgressBar setProgressBarProgressColor:(customized ? [UIColor colorWithRed:0.2 green:0.7 blue:1.0 alpha:0.8] : nil)];
    [nextUpCircleProgressBar setProgressBarTrackColor:(customized ? [Utility colorWithHexString:@"efefef"] : nil)];
    
    // Hint View Customization
    [nextUpCircleProgressBar setHintViewSpacing:(customized ? 10.0f : 0)];
    [nextUpCircleProgressBar setHintViewBackgroundColor:(customized ? [UIColor colorWithWhite:1.000 alpha:0.800] : nil)];
}
-(void)stopMusic{
    if (![Utility isEmptyCheck:[defaults objectForKey:@"mediaItemCollection"]] && [MPMusicPlayerController systemMusicPlayer].currentPlaybackRate == 1) {
        [[MPMusicPlayerController systemMusicPlayer] pause];
    }else if(![Utility isEmptyCheck:[defaults objectForKey:@"selectedSpotifyCollectionUri"]] && [[SPTAudioStreamingController sharedInstance] initialized] && [SPTAudioStreamingController sharedInstance].playbackState.isPlaying){
        [[SPTAudioStreamingController sharedInstance] setIsPlaying:NO callback:nil];
    }
}
-(BOOL) isBgMusicPlaying {
    if (![Utility isEmptyCheck:[defaults objectForKey:@"mediaItemCollection"]]) {
        if ([MPMusicPlayerController systemMusicPlayer].currentPlaybackRate == 1) {
            return YES;
        }else{
            return false;
        }
    }else if(![Utility isEmptyCheck:[defaults objectForKey:@"selectedSpotifyCollectionUri"]]){
        if (![[SPTAudioStreamingController sharedInstance] initialized]) {
            return NO;
        }
        return [SPTAudioStreamingController sharedInstance].playbackState.isPlaying;
    }
    return false;
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
-(void)setBackgroundMusicVolume:(float)vol{
    NSLog(@"%ld",(long)[[SPTAudioStreamingController sharedInstance] initialized]);
    if (![Utility isEmptyCheck:[defaults objectForKey:@"mediaItemCollection"]] && [MPMusicPlayerController systemMusicPlayer].currentPlaybackRate == 1) {
//        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
//        for (id view in volumeView.subviews) {
//            if([view isKindOfClass:[UISlider class]]){
//                UISlider *slider = (UISlider *)view;
//                //slider.value = vol;
//                slider.value = [AVAudioSession sharedInstance].outputVolume;
//            }
//        }
    }else if(![Utility isEmptyCheck:[defaults objectForKey:@"selectedSpotifyCollectionUri"]] && [[SPTAudioStreamingController sharedInstance] initialized] && [SPTAudioStreamingController sharedInstance].playbackState.isPlaying){
        [[SPTAudioStreamingController sharedInstance] setVolume:vol callback:nil];
    }
}
//ah 3.5
- (UIImage*)captureView:(UIView *)captureView {
    CGRect rect = captureView.bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [captureView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)presentActivityController:(UIActivityViewController *)controller {
    
    // for iPad: make the presentation a Popover
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.leftBarButtonItem;
    
    // access the completion handler
    controller.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        // react to the completion
        if (completed) {
            
            // user shared an item
            NSLog(@"We used activity type%@", activityType);
            
        } else {
            
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }
        
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}
- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {    //ah ux1
    if (!isCompleted) {
        BOOL wasPlaying1 = NO;
        if (isPlaying) {
            [self playPauseButtonTapped:nil];
            wasPlaying1 = YES;
        }
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Stop Session?"
                                              message:@"Are you sure you want to stop your session? Don't take the easy road, you got this."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Quit"
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction *action)
                                   {
                                       response(YES);
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           if (wasPlaying1) {
                                               [self playPauseButtonTapped:nil];
                                           }
                                           response(NO);
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        response(YES);
    }
}
- (void) gameOnCounter {
    dispatch_async(dispatch_get_main_queue(), ^{

    int gameOnCount = [gameOnCountdownLabel.text intValue];
    gameOnCount--;
    gameOnCountdownLabel.text = [NSString stringWithFormat:@"%d",gameOnCount];
    
    if (gameOnCount <= 0) {
        [gameOnTimer invalidate];
        gameOnView.hidden = true;
        [self refreshView];
        [self reloadSettingsTable];
        [playPauseButton setUserInteractionEnabled:YES];
        [landScapePlayPauseButton setUserInteractionEnabled:YES];
        [rightLandScapePlayPauseButton setUserInteractionEnabled:YES];


//        mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:mainTimer forMode:NSRunLoopCommonModes]; //AY 05032018

        sessionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sessionCounter) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:sessionTimer forMode:NSRunLoopCommonModes];
        
        if(_sessionFlowId == FOLLOWALONG){
            if(isFirstVideo){
                //[self playAudioWithName:@"Let's Get Started"];
                isFirstVideo = NO;
            }
            
            [videoPlayer play];
        }else{
           [self nextVideo];
        }
        
        }
    });
}

-(void)startCircuitCounter{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self->circuitTimer.isValid) {
            self->parentScroll.scrollEnabled = NO;
            [self showCircuitDetails];
            [self playPauseButtonTapped:playPauseButton];
            self->circuitTimerLabel.text = @"10";
            if([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
                self->circuitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(circuitCounter) userInfo:nil repeats:YES];
            }else{
                self->circuitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(circuitCounter) userInfo:nil repeats:NO];
            }
            
            [[NSRunLoop mainRunLoop] addTimer:self->circuitTimer forMode:NSRunLoopCommonModes];
            self->circuitTimerStartingView.hidden = false;
            [self orientationChangedDetails]; //Update

        }
    });
    
}

-(void)circuitCounter {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int gameOnCount = 10;
        if([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
           gameOnCount = [self->circuitTimerLabel.text intValue];
        }
        
        if(gameOnCount == 10){
            [self playMp3AudioWithName:@"Next Circuit Is"];
        }
        gameOnCount--;
        self->circuitTimerLabel.text = [NSString stringWithFormat:@"%d",gameOnCount];
        if (gameOnCount <= 0) {
            self->parentScroll.scrollEnabled = YES;
            [self->circuitTimer invalidate];
            self->circuitTimerStartingView.hidden = true;
            [self playPauseButtonTapped:playPauseButton];
            self->circuitCount = 1;
            [self forwardButtonTapped:0];
            
        }
    });
}
-(void)timerFired{
    if (timerNew123Count >0) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"---------------------/n/n/n/n%f",timerNew123Count);
            timerNew123Count--;

            nextUpCircleProgressBar.hidden = false;
            CGFloat x=(float)timerNew123Count/5.0;
            int timerCountforRest=(int)timerNew123Count;
            nextUpTimerlabel.text =[NSString stringWithFormat:@"%02d",timerCountforRest]; //add_n
            landscapeNextUpTimerLabel.text = [NSString stringWithFormat:@"%02d",timerCountforRest];
            rightLandscapeNextUpTimerLabel.text = [NSString stringWithFormat:@"%02d",timerCountforRest];

            [nextUpCircleProgressBar setProgress:x animated:YES];
            [nextUpCircleProgressBar setHintTextGenerationBlock:(YES ? ^NSString *(CGFloat progress) {
                return @"";
            } : nil)];
            [nextUpCircleProgressBar setHintTextFont:[UIFont fontWithName:@"Raleway-Medium" size:12]];
            [nextUpCircleProgressBar setProgressBarProgressColor:([UIColor colorWithRed:0.2 green:0.7 blue:1.0 alpha:0.8])];
            nextUpProgressBarHeightConstraint.constant = 60;
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [timerNew123 invalidate];
            nextUpProgressBarHeightConstraint.constant = 0;
            nextUpCircleProgressBar.hidden = true;
            nextUpView.hidden = true;
            parentScroll.scrollEnabled = true;
            isNextUpPlaying = NO;
            [self nextVideo];
        });
        //[timerNew123 invalidate];
    }
    
}
- (void)playNextUpWithTime:(BOOL) isTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(islandScapeEnable){
            //        [self forwardButtonTapped:0];
            //        return;
            if (!self->isNextUpPlaying) {
                self->landscapeView.hidden = true;
                self->nextUpView.hidden = true;
                self->landscapeNextUpView.hidden = false;
            }else{
                self->landscapeView.hidden = false;
                self->nextUpView.hidden = true; //chng//
                self->landscapeNextUpView.hidden = true;
            }
        }

    if (videoCounter < dataArray.count) {
        if ([[[dataArray objectAtIndex:videoCounter] objectForKey:@"isCircuit"] boolValue]) {
            
            BOOL isCircuit = NO;
            if(self->videoCounter == 0 || videoCounter+1 == dataArray.count || self->isRepeat){ //videoCounter == 0 ||
                isCircuit = NO;
            }else{
                isCircuit = YES;
            }
            cktName = [[dataArray objectAtIndex:videoCounter] objectForKey:@"ExerciseName"];
            currentCount++;
            [exerciseTable reloadData];
            audioCounter++;
            videoCounter++;
            //int circuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"circuitIndex"] intValue];
            if((self->_sessionFlowId == TIMER || _sessionFlowId == CIRCUITTIMER) && isCircuit){
                if(self->currentCircuitTime>0 && !self->isSkip){
                    [self resetCircuit];
                }else{
                    self->isSkip = NO;
                    if(videoCounter == dataArray.count){
                        
                       /* if(self->currentCircuitIndex == circuitIndex && self->currentCircuitTime>0){
                            
                            int newTime = [[[self->dataArray objectAtIndex:self->videoCounter-1] objectForKey:@"CircuitMinutes"] intValue];
                            self->currentCircuitTime =  newTime -(newTime - self->currentCircuitTime) ;
                        }else{
                            self->currentCircuitTime = [[[self->dataArray objectAtIndex:self->videoCounter-1] objectForKey:@"CircuitMinutes"] intValue];
                        }
                        
                        self->currentCircuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter-1] objectForKey:@"circuitIndex"] intValue];
                    }else{
                        if(self->currentCircuitIndex == circuitIndex && self->currentCircuitTime>0){
                            
                            int newTime = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"CircuitMinutes"] intValue];
                            self->currentCircuitTime =  newTime -(newTime - self->currentCircuitTime) ;
                        }else{
                            self->currentCircuitTime = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"CircuitMinutes"] intValue];
                        }
                        self->currentCircuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"circuitIndex"] intValue];
                    }*/
                        
                     self->currentCircuitTime = [[[self->dataArray objectAtIndex:self->videoCounter-1] objectForKey:@"CircuitMinutes"] intValue];
                     self->currentCircuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter-1] objectForKey:@"circuitIndex"] intValue];
                     }else{
                     
                     self->currentCircuitTime = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"CircuitMinutes"] intValue];
                     self->currentCircuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"circuitIndex"] intValue];
                     }
                        
                    [self startCircuitCounter];
                }
            }else{
                self->isSkip = NO;
                if(self->_sessionFlowId == TIMER || _sessionFlowId == CIRCUITTIMER){
                    if(self->isRepeat){
                        self->isRepeat = NO;
                    }else if(videoCounter == dataArray.count){
                        self->currentCircuitTime = [[[self->dataArray objectAtIndex:self->videoCounter-1] objectForKey:@"CircuitMinutes"] intValue];
                        self->currentCircuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter-1] objectForKey:@"circuitIndex"] intValue];
                    }else{
                        
                        self->currentCircuitTime = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"CircuitMinutes"] intValue];
                        self->currentCircuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"circuitIndex"] intValue];
                    }
                    
                    [self playNextUpWithTime:isTime];
                }else{
                    if(self->videoCounter>2){
                        [self startCircuitCounter];
                    }else{
                       [self playNextUpWithTime:isTime];
                    }
                }
            }
            
            
        } else {
            
            if((self->_sessionFlowId == TIMER || _sessionFlowId == CIRCUITTIMER)){
                
                if(self->isSkip){
                    self->isSkip = NO;
                    int circuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"circuitIndex"] intValue];
                    if(self->currentCircuitIndex != circuitIndex){
                        self->circuitCount = 1;
                        self->currentCircuitTime = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"CircuitMinutes"] intValue];
                        self->currentCircuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"circuitIndex"] intValue];
                    }
                }
            }
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSString *destinationFilename = [NSString stringWithFormat:@"%@.mp4",[[dataArray objectAtIndex:videoCounter] objectForKey:@"ExerciseName"]];
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* documentsDirectory = [paths objectAtIndex:0];
            NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:destinationFilename];
            NSURL *destinationURL = [NSURL fileURLWithPath:fullPathToFile];
            
            BOOL isReCheckedDownload = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"isReCheckedDownload"] boolValue];
            
            if (([fileManager fileExistsAtPath:[destinationURL path]] && ![self checkDownloadFileSize:fullPathToFile]) || isReCheckedDownload) {
                
                nextUpView.hidden = false;//add_n
                restViewDetails.hidden = true; //add_n
                parentScroll.scrollEnabled = false;
                if (!isTime) {
                    /*nextUpProgressBarHeightConstraint.constant = 0;
                    nextUpCircleProgressBar.hidden = true;*/
                    isNameAudioPlaying = YES;
                    timerNew123=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
                    timerNew123Count =5.0;
                    
                    nextUpCircleProgressBar.hidden = false;     //ah 27.6
                    nextUpProgressBarHeightConstraint.constant = 60;
                    
                    int timerCountforRest=(int)timerNew123Count;
                    nextUpTimerlabel.text =[NSString stringWithFormat:@"%02d",timerCountforRest]; //add_n
                    landscapeNextUpTimerLabel.text =[NSString stringWithFormat:@"%02d",timerCountforRest];
                    rightLandscapeNextUpTimerLabel.text =[NSString stringWithFormat:@"%02d",timerCountforRest];

                    [nextUpCircleProgressBar setProgress:1.0 animated:YES];
                    [nextUpCircleProgressBar setHintTextGenerationBlock:(YES ? ^NSString *(CGFloat progress) {
                        return @"";
                    } : nil)];
                    [nextUpCircleProgressBar setHintTextFont:[UIFont fontWithName:@"Raleway-Medium" size:12]];
                    [nextUpCircleProgressBar setProgressBarProgressColor:([UIColor colorWithRed:0.2 green:0.7 blue:1.0 alpha:0.8])];
                    
                    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        nextUpView.hidden = true;
                        parentScroll.scrollEnabled = true;
                        isNextUpPlaying = NO;
                        [self nextVideo];
                    });*/
                } else {
                    nextUpProgressBarHeightConstraint.constant = 60;
                    nextUpCircleProgressBar.hidden = false;
                    isNameAudioPlaying = NO;
                }
                
                nextUpTitleLabel.text = [[dataArray objectAtIndex:videoCounter] objectForKey:@"ExerciseName"];
                
                int repsNo = 0;
                NSString *repStr = @"reps";
                if ([[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps"] == NSOrderedSame) {
                    repsNo = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepGoal"] intValue];
                    nextUpRepsSetLabel.text = [NSString stringWithFormat:@"%d %@",repsNo,repStr];
                    
                } else if ([[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame) {
                    repsNo = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepGoal"] intValue];
                    if (nextUpRepSideCountPlay == 0) {
                        repStr = @"reps side 1";
                        nextUpRepSideCountPlay = 1;
                    } else if (nextUpRepSideCountPlay == 1) {
                        repStr = @"reps side 2";
                        nextUpRepSideCountPlay = 0;
                    }
                    nextUpRepsSetLabel.text = [NSString stringWithFormat:@"%d %@",repsNo,repStr];
                    
                } else if ([[[dataArray objectAtIndex:videoCounter] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Seconds Each Side"] == NSOrderedSame) {
                    if (nextUpRepSideCountPlay == 0) {
                        repStr = @"side 1";
                        nextUpRepSideCountPlay = 1;
                    } else if (nextUpRepSideCountPlay == 1) {
                        repStr = @"side 2";
                        nextUpRepSideCountPlay = 0;
                    }
                    nextUpRepsSetLabel.text = [NSString stringWithFormat:@"%@",repStr];
                    
                } else {
                    nextUpRepsSetLabel.text = @"";
                }
                
                isNextUpPlaying = YES;
                [self playNextUpVideoWithName:[[dataArray objectAtIndex:videoCounter] objectForKey:@"videoUrl"]];
                
                nextUpTipsLabel.text = ![Utility isEmptyCheck:[[dataArray objectAtIndex:videoCounter] objectForKey:@"tips"]] ? [[dataArray objectAtIndex:videoCounter] objectForKey:@"tips"] : @"";
                
                //        [self playAudioWithName:@"Let's Get Started"];
                
                
                if([self isAudioExist:[[dataArray objectAtIndex:audioCounter] objectForKey:@"audioUrl"]]){
                    [self playExNameAudioWithName:[[dataArray objectAtIndex:audioCounter] objectForKey:@"audioUrl"]];
                }else{
                   [self downloadAudioWithName:[[dataArray objectAtIndex:audioCounter] objectForKey:@"ExerciseName"] dataIndex:audioCounter];
                }
               
//                isNextUpPlaying = YES; //Chng position due to landscape
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(!loadingView.isHidden){
                        loadingView.hidden = true;
                    }
                    
                    if(contentView){
                        [contentView removeFromSuperview];
                        [contentViewLabel removeFromSuperview];
                        [progressView removeFromSuperview];
                    }
                });
                
                NSMutableDictionary *dict = [dataArray objectAtIndex:videoCounter];
                [dict setObject:[NSNumber numberWithBool:1] forKey:@"isReCheckedDownload"];
                [dataArray removeObjectAtIndex:videoCounter];
                [dataArray insertObject:dict atIndex:videoCounter];
                
                NSString *videoName = [[dataArray objectAtIndex:videoCounter] objectForKey:@"ExerciseName"];
                if([Utility reachable]){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        contentView = [Utility activityIndicatorView:self];   //ah go
//                        [self contentViewLabelWithText:@"Downloading Video Files"];
                        if(loadingView.isHidden){
                            loadingView.hidden = false;
                        }
                    });
                    
                    isOffTime = isTime;
                    [self downloadSingleVideo:videoName dataIndex:videoCounter];
                    [self playPauseButtonTapped:playPauseButton];
       
                }else{
                    [self playPauseButtonTapped:playPauseButton];

                    [self errorDownloadingAlert:[videoName stringByAppendingString:@" Video not downloaded.Check Your network connection and try again."] title:@"Oops! "];
                    return;
                }// AY 22022018
                
            }
        }
    } else {
        [self endSession];
    }
});
}
-(BOOL)isFileExistInDocumentDirectory:(NSString *)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *destinationFilename = fileName;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:destinationFilename];
    NSURL *destinationURL = [NSURL fileURLWithPath:fullPathToFile];
    
    return [fileManager fileExistsAtPath:[destinationURL path]];
}

-(BOOL)checkDownloadFileSize:(NSString *)filePath{
    BOOL isNeedToDownload = NO;
    
    unsigned  long long size= ([[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize]);
    
    NSLog(@"File Size: %llu bytes,%llu KB",size,size/1024);
    
    if(size/1024 <= 10){
        isNeedToDownload = YES;
        [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:filePath] error:nil];
    }
    
    return isNeedToDownload;
}

-(void)downloadSingleVideo:(NSString *)videoName dataIndex:(int)dataIndex {
    
    /*if(!singleDownloadSession){
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.TheSquat.singleDownload"];
        sessionConfiguration.allowsCellularAccess = YES;
        sessionConfiguration.timeoutIntervalForResource = 60;
        sessionConfiguration.timeoutIntervalForRequest = 60;
        singleDownloadSession = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                              delegate:self
                                                         delegateQueue:nil];
    }*/
    
   
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",videoName]];
    
    NSMutableDictionary *dict = [dataArray objectAtIndex:dataIndex];
    [dict setObject:fullPathToFile forKey:@"videoUrl"];
    [dataArray removeObjectAtIndex:dataIndex];
    [dataArray insertObject:dict atIndex:dataIndex];
    
        
    if(![Utility reachable] || ([Utility isSubscribedUser] && [Utility isOfflineMode])){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!loadingView.isHidden){
                loadingView.hidden = true;
            }
            if(contentView){
                [contentView removeFromSuperview];
                [contentViewLabel removeFromSuperview];
                [progressView removeFromSuperview];
            }
        });
        
        NSString *errorMsg = [videoName stringByAppendingString:@" Video not downloaded.Check Your network connection and try again."];
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            errorMsg = [videoName stringByAppendingString:@" Video not downloaded.Please go online and try again"];
        }
        
        [self errorDownloadingAlert:errorMsg title:@"Oops! "];
        return;
    }
    
   /* NSOperationQueue *queue=[NSOperationQueue new];
    [queue setMaxConcurrentOperationCount:1];
    
    [queue addOperationWithBlock:^{
        NSString *newVideoName = [videoName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        if (singleDownloadSession) {
            
            // NSLog(@"Video Download Server URL-%@",[NSString stringWithFormat:@"%@/exercise_videos/Mini/%@.mp4",BASEURL_ABBBC,newVideoName]);
            singleDownloadTask = [singleDownloadSession downloadTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/exercise_videos/Mini/%@.mp4",BASEURL_ABBBC,newVideoName]]];
            [singleDownloadTask resume];
            
        }
    }];
    
    NSLog(@"Single Queue Ops: %@",queue.operations.debugDescription);
    
    NSOperation *op = [queue.operations firstObject];
    [op setQueuePriority:NSOperationQueuePriorityVeryHigh];*/
    
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *newVideoName = [videoName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.mp4",BASE_VIDEO_DOWNLOAD_URL,newVideoName]]; //@"https://ebox.emailpros.com/portal/s/1403219968"
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *destinationFilename = [response suggestedFilename];
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:destinationFilename];
        NSURL *destinationURL = [NSURL fileURLWithPath:fullPathToFile];
        
        if ([fileManager fileExistsAtPath:[destinationURL path]]) {
            [fileManager removeItemAtURL:destinationURL error:nil];
        }
        return destinationURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!loadingView.isHidden){
                loadingView.hidden = true;
            }
            if(contentView){
                [contentView removeFromSuperview];
                [contentViewLabel removeFromSuperview];
                [progressView removeFromSuperview];
            }
        });
        
        
        
        if(!error){
            
            NSError *error;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *destinationFilename = [response suggestedFilename];
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* documentsDirectory = [paths objectAtIndex:0];
            NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:destinationFilename];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile] && ![self checkDownloadFileSize:fullPathToFile]) {
                NSLog(@"Single Download success. original main.");
                NSLog(@"url %@",fullPathToFile);
                
                [self playPauseButtonTapped:playPauseButton];
                
                isOffTime = NO;
                if (isFirstExDownloading) {
                    isFirstExDownloading = NO;
                    [self nextVideo];
                } else {
                    [self playNextUpWithTime:isOffTime];
                }
                
                totalMediaDownloaded++;
                if(totalMediaDownloaded == totalMediaCount){
                    [self downloadStatusUpdate];
                }
            }
            
        }else{
            NSLog(@"Single Download completed with error: %@", [error localizedDescription]);
            if(![Utility isOfflineMode])[Utility msg: [@"" stringByAppendingString:@" Error downloading video.Check Your network connection and try again."] title:@"Oops! " controller:self haveToPop:NO];
            
            [self playPauseButtonTapped:playPauseButton];
            
            isOffTime = NO;
            if (isFirstExDownloading) {
                isFirstExDownloading = NO;
                [self nextVideo];
            } else {
                [self playNextUpWithTime:isOffTime];
            }
        }
        
        
    }];
    
    [downloadTask resume];
    
    
    
}

-(void)downloadFollowAlongSessionVideo{
    
    if(!followAlongDownloadSession){
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.TheSquat.followAlongDownload"];
        sessionConfiguration.allowsCellularAccess = YES;
        sessionConfiguration.timeoutIntervalForResource = 1000;
        sessionConfiguration.timeoutIntervalForRequest = 1000;
        followAlongDownloadSession = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                              delegate:self
                                                         delegateQueue:nil];
    }
    
    if(![Utility reachable] || ([Utility isSubscribedUser] && [Utility isOfflineMode])){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
        NSString *errorMsg = [@"" stringByAppendingString:@" Video not downloaded.Check Your network connection and try again."];
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            errorMsg = [@"" stringByAppendingString:@"Video not downloaded.Please go online and try again"];
        }
        
        [self errorDownloadingAlert:errorMsg title:@"Oops! "];
        return;
    }
    
    NSOperationQueue *queue=[NSOperationQueue new];
    [queue setMaxConcurrentOperationCount:1];
    
    [queue addOperationWithBlock:^{
        NSString * videoDownloadUrlStr = @"";
        
        if(![Utility isEmptyCheck:_followAlongSessiondata[@"DownloadVideoLink"]]){
            videoDownloadUrlStr = _followAlongSessiondata[@"DownloadVideoLink"];
        }
        
        if (followAlongDownloadSession) {
            followAlongDownloadTask = [followAlongDownloadSession downloadTaskWithURL:[NSURL URLWithString:videoDownloadUrlStr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                downloadButton.hidden = true;
                [circleProgressBar setProgress:0.0 animated:YES];
                [circleProgressBar setHintTextGenerationBlock:(YES ? ^NSString *(CGFloat progress) {
                    return @"";
                } : nil)];
                circleProgressBar.hidden = false;
            });
            
            [followAlongDownloadTask resume];
            
        }
    }];
    
    NSLog(@"Single Queue Ops: %@",queue.operations.debugDescription);
    
    NSOperation *op = [queue.operations firstObject];
    [op setQueuePriority:NSOperationQueuePriorityVeryHigh];
    
}

-(void)errorDownloadingAlert:(NSString *)errorMsg title:(NSString *)title{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:errorMsg
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   if(_sessionFlowId == FOLLOWALONG){
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           self->downloadButton.hidden = false;
                                           [self->circleProgressBar setProgress:0.0 animated:YES];
                                           self->circleProgressBar.hidden = true;
                                           [self->followAlongDownloadSession finishTasksAndInvalidate];
                                           [self->followAlongDownloadSession invalidateAndCancel];
                                           self->followAlongDownloadSession = nil;
                                           self->followAlongDownloadTask = nil;
                                       });
                                   }else{
                                       self->nextUpTopConstant.constant = 340;
                                       isNextUp = true; ///add_SB
                                       exerciseTable.hidden = true; ///add_SB
                                       exerciseTableHeightConstraint.constant =0; ///add_SB
                                       [self playPauseButtonTapped:playPauseButton];

                                   }
                                   
                               }];
   
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



-(void)downloadStatusUpdate{
    
     dispatch_async(dispatch_get_main_queue(), ^{
         
        /* if(totalMediaDownloaded<=totalMediaCount){
             double downloadPercentage = (double)totalMediaDownloaded / (double)totalMediaCount;
             //NSLog(@"Download%% -%f ",downloadPercentage);
             mediaDownloadLabel.text = [@"" stringByAppendingFormat:@"Media Downloaded: %ld/%ld (%d%%)",totalMediaDownloaded,totalMediaCount,(int)(downloadPercentage * 100)];
         }else if(totalMediaDownloaded>totalMediaCount){
             double downloadPercentage = (double)totalMediaCount / (double)totalMediaCount;
             mediaDownloadLabel.text = [@"" stringByAppendingFormat:@"Media Downloaded: %ld/%ld (%d%%)",totalMediaCount,totalMediaCount,(int)downloadPercentage];
         }*/
         
         NSLog(@"Download Status: %ld/%ld",totalMediaDownloaded,totalMediaCount);
         [self updateExerciseNamesToDB];

         mediaDownloadLabel.hidden = NO;
         mediaDownloadLabel.text = @"Session Downloaded";
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             mediaDownloadLabel.hidden = YES;
         });
       
     });
    
}//AY 09032018

-(void)updateExerciseNamesToDB{
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    if([DBQuery isRowExist:@"exerciseDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,_exSessionId]]){
        
        NSString *detailsString = @"";
        
        if(exerciseNameArray.count>0){
            
            NSArray *uniqueArray = [exerciseNameArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
            
            NSError *error;
            NSData *detailsData = [NSJSONSerialization dataWithJSONObject:uniqueArray options:NSJSONWritingPrettyPrinted  error:&error];
            
            if (error) {
                
                NSLog(@"Error ExerciseNames Array-%@",error.debugDescription);
            }
            
            detailsString = [[NSString alloc] initWithData:detailsData encoding:NSUTF8StringEncoding];
        }
        
        [DBQuery updateExerciseDetailsNames:detailsString sessionId:_exSessionId];
    }
}

-(void)isUpdateSeasonCount{
    NSArray *arr = [self.navigationController viewControllers];
    if(arr.count>=2){
        UIViewController *prvController = [arr objectAtIndex:arr.count-2];
        if([prvController isKindOfClass:[ExerciseDetailsViewController class]]){
            ExerciseDetailsViewController *controller = (ExerciseDetailsViewController *)prvController;
            controller.isChanged = YES;
        }
    }
    
}

-(void)endSession{
        if((_sessionFlowId == TIMER || _sessionFlowId == CIRCUITTIMER) && sessionTimeCounter > 0){
            circuitCount = 1;
            [self resetSessionData];
            return;
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
        
        timerCountLabel.text = [NSString stringWithFormat:@"00:00"];
        landScapeTimerCountLabel.text = [NSString stringWithFormat:@"00:00"];
        rightLandScapeTimerCountLabel.text = [NSString stringWithFormat:@"00:00"];
            
        if (self->islandScapeEnable) {
            landscapeView.hidden = true;
            landscapeNextUpView.hidden = true;
        }

        [videoPlayer pause];
        [audioPlayer pause];
        [audioPlayer stop];
        [mainTimer invalidate];
        [sessionTimer invalidate];
        timerCount = 0.0;
        currentCount++;
        [exerciseTable reloadData];
        isCompleted = YES;      //ah ux1
        //FIREBASELOG
        [FIRAnalytics logEventWithName:@"unlock_achievement" parameters:@{@"workout_name":_sessionName}];
        
        if(isFromCustom || _isAddedToCustomSession){
            [self updateSessionDoneStatusApi];
        }else{
            [self webserviceCall_CountSessionDone];
        }
        
        if (![Utility isEmptyCheck:_sessionDate]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];     //2017-03-20T00:00:00
            NSDate *sessionDateDt = [dateFormatter dateFromString:_sessionDate];
            [dateFormatter setDateFormat:@"EEEE"];
            NSString *todayDayName = [dateFormatter stringFromDate:sessionDateDt];
            
            if ([todayDayName caseInsensitiveCompare:@"Sunday"] == NSOrderedSame) {
                sessionCompleteView.hidden = NO;
                sessionCompleteViewWithImage.hidden = YES;
            } else {
                sessionCompleteView.hidden = NO;
                sessionCompleteViewWithImage.hidden = NO;
                [self stopMusic];
                parentScroll.scrollEnabled = NO;
                
                mainImageView.image = [UIImage imageNamed:todayDayName];
                
                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                NSString *newSessionDate = [dateFormatter stringFromDate:sessionDateDt];
                
                sessionDetailsLabel.text = [NSString stringWithFormat:@"%@ %@ %@",newSessionDate,_sessionName,sessionTimeLabel.text];
            }
            
            if (![Utility isEmptyCheck:_sessionDate]) {
                NSString *dateStr = _sessionDate;
                NSArray *dateArr = [dateStr componentsSeparatedByString:@"T"];
                dateStr = [dateArr objectAtIndex:0];
                
                NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
                [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *dailyDate = [dailyDateformatter dateFromString:dateStr];
                [dailyDateformatter setDateFormat:@"EEEE d"];
                
                NSString *suffix = @"";
                if (![dailyDate isEqual:[NSNull null]]) {
                    suffix = [Utility daySuffixForDate:dailyDate];
                }
                NSString *sessionDateStr = [NSString stringWithFormat:@"%@%@",[dailyDateformatter stringFromDate:dailyDate],suffix];
                sessionCompleteLabel.text = [NSString stringWithFormat:@"%@, %@ Completed!!",sessionDateStr,_sessionName];
            } else {
                sessionCompleteLabel.text = [NSString stringWithFormat:@"%@ Completed!!",_sessionName];
            }
        } else if (![Utility isEmptyCheck:_workoutType]) {
            sessionCompleteView.hidden = NO;
            sessionCompleteViewWithImage.hidden = NO;
            [self stopMusic];
            parentScroll.scrollEnabled = NO;
            mainImageView.image = [UIImage imageNamed:_workoutType];
            sessionDetailsLabel.text = [NSString stringWithFormat:@"%@ %@",_sessionName,sessionTimeLabel.text];     //ah 10.5
            
            
        } else {
            sessionCompleteView.hidden = NO;
            sessionCompleteViewWithImage.hidden = YES;
            [self stopMusic];
            parentScroll.scrollEnabled = NO;
        }
        
        circuitNameLabel.text = @"";
        playPauseButton.userInteractionEnabled = NO;
        [playPauseButton setImage:[UIImage imageNamed:@"play_all_vdo.png"] forState:UIControlStateNormal];  //ah 9.5
        landScapePlayPauseButton.userInteractionEnabled = NO;
        [landScapePlayPauseButton setImage:[UIImage imageNamed:@"play_exVdo.png"] forState:UIControlStateNormal];  //ah 9.5
        rightLandScapePlayPauseButton.userInteractionEnabled = NO;
        [rightLandScapePlayPauseButton setImage:[UIImage imageNamed:@"play_exVdo.png"] forState:UIControlStateNormal];  //ah 9.5
    });
    
}

-(void)resetSessionData{
    
    currentCircuit = 0;
    downloadCount = 0; //AY 11122017
    isNameAudioPlaying = NO;
    nextUpView.hidden = true;
    parentScroll.scrollEnabled = true;
    isNextUpPlaying = NO;
    currentCount = 0;
    [exerciseTable reloadData];
    audioCounter = 0;
    videoCounter = 0;
    [audioPlayer pause];
    [audioPlayer stop];
    isShowRound = NO;
    [self forwardButtonTapped:nil];
    
}

-(void)resetCircuit{
    

    currentCircuit = currentCircuitIndex;
    downloadCount = currentCircuitIndex; //AY 11122017
    isNameAudioPlaying = NO;
    nextUpView.hidden = true;
    parentScroll.scrollEnabled = true;
    isNextUpPlaying = NO;
    currentCount = currentCircuitIndex;
    [exerciseTable reloadData];
    audioCounter = currentCircuitIndex;
    videoCounter = currentCircuitIndex;
    [audioPlayer pause];
    [audioPlayer stop];
    isShowRound = YES;
    
    int circuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"circuitIndex"] intValue];

    if(self->currentCircuitIndex != circuitIndex){
        self->currentCircuitTime = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"CircuitMinutes"] intValue];
        self->currentCircuitIndex = [[[self->dataArray objectAtIndex:self->videoCounter] objectForKey:@"circuitIndex"] intValue];
    }
    
//    if (self->videoCounter < self->dataArray.count) {
//        currentCircuitTime = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"CircuitMinutes"] intValue];
//        currentCircuitIndex = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"circuitIndex"] intValue];
//    }
    
    
    self->isRepeat = YES;
    [self forwardButtonTapped:nil];
    //[self playNextUpWithTime:NO];
}

-(void)jumpToNextCircuit{
    if (self->videoCounter < self->dataArray.count) {
        int nextCircuitIndex = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"nextCircuitIndex"] intValue];
        self->circuitCount = 1;
        
        if(nextCircuitIndex+1>=dataArray.count){
            nextCircuitIndex = 0;
        }
        if (nextCircuitIndex < self->dataArray.count) {
            currentCircuit = nextCircuitIndex;
            downloadCount = nextCircuitIndex; //AY 11122017
            isNameAudioPlaying = NO;
            nextUpView.hidden = true;
            parentScroll.scrollEnabled = true;
            isNextUpPlaying = NO;
            currentCount = nextCircuitIndex;
            [exerciseTable reloadData];
            audioCounter = nextCircuitIndex;
            videoCounter = nextCircuitIndex;
            [audioPlayer pause];
            [audioPlayer stop];
            
            if (self->videoCounter < self->dataArray.count) {
                currentCircuitTime = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"CircuitMinutes"] intValue];
                currentCircuitIndex = [[[dataArray objectAtIndex:videoCounter] objectForKey:@"circuitIndex"] intValue];
            }
            self->isSkip = YES;
            [self forwardButtonTapped:nil];
            
        }else{
           [self endSession];
        }
        
    }else{
        [self endSession];
    }
}


-(void)showCircuitDetails{
    
    if([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
        circuitTimerView.hidden = NO;
    }else{
        circuitTimerView.hidden = YES;
    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:cktName];
    
    
    [text addAttribute:NSUnderlineStyleAttributeName
                 value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                 range:NSMakeRange(0, cktName.length)];
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Oswald-Regular" size:21.0],
                               NSForegroundColorAttributeName : [Utility colorWithHexString:@"E427A0"],
                               NSParagraphStyleAttributeName:paragraphStyle
                               };
    [text addAttributes:attrDict range:NSMakeRange(0,cktName.length)];
    currentCircuitNameLabel.attributedText = text;
    circuitName.attributedText = text;
    
    int circuitCounter = videoCounter-1;
    if (circuitCounter < dataArray.count) {
        if ([[[dataArray objectAtIndex:circuitCounter] objectForKey:@"isCircuit"] boolValue]) {
            int ExerciseId = [[[dataArray objectAtIndex:circuitCounter] objectForKey:@"ExerciseId"] intValue];
            if(ExerciseId > 0){
                /*NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ExerciseId == %d)",ExerciseId];
                NSMutableArray *filteredAvailableDataArray = [NSMutableArray new];
                filteredAvailableDataArray = [[dataArray filteredArrayUsingPredicate:predicate] mutableCopy];
                
                if(filteredAvailableDataArray.count>0){
                    [filteredAvailableDataArray removeObjectAtIndex:0];
                    NSArray *exercises= [filteredAvailableDataArray valueForKeyPath:@"@distinctUnionOfObjects.ExerciseName"];
                    if(exercises.count>0){
                        NSString *exercisesStr = [exercises componentsJoinedByString:@"\n"];
                        circuitExerciseNamesLabel.text = exercisesStr;
                    }
                    
                }*/
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Id == %d)",ExerciseId];
                NSArray *filterArray = [[_mainDataArray filteredArrayUsingPredicate:predicate] mutableCopy];
                
                if(filterArray.count>0){
                    NSDictionary *circuitDict = [filterArray firstObject];
                    
                    if(![Utility isEmptyCheck:circuitDict[@"CircuitExercises"]]){
                        nextCircuitList = circuitDict[@"CircuitExercises"];
                        [nextCircuitsTable reloadData];
                    }
                }
                
                
            }
            
        }
    }
    
}

-(BOOL)isFollowAlongSessionDownloaded{
    NSString *destinationFilename = @"";
    if(![Utility isEmptyCheck:_followAlongSessiondata[@"VideoLink"]]){
      destinationFilename = [@"" stringByAppendingFormat:@"%@%@.mp4",_sessionName,_followAlongSessiondata[@"VideoLink"]];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:destinationFilename];
    NSURL *destinationURL = [NSURL fileURLWithPath:fullPathToFile];
    return ([fileManager fileExistsAtPath:[destinationURL path]] && ![self checkDownloadFileSize:fullPathToFile]);
}

-(void)setupViewForFollowAlongSession{
    [self customizeAccordingToState:CustomizationStateCustom];
    backwardButton.hidden = true;
    landscapeBackwardButton.hidden = true;
    landscapeRightSideBackwardButton.hidden = true;
    forwardButton.hidden = true;
    landscapeForwardButton.hidden = true;
    landscapeRightSideForwardButton.hidden = true;
    weightRecordButton.hidden = true;
    NSArray *subviews = [nextUpPreview subviews];
    for(UIView *view in subviews){
        view.hidden = true;
    }
    
    nextExerciseButton.hidden = true;
    repsDoneButton.hidden = false;
    landscapeRepsDoneButton.hidden = false;
    rightLandscapeRepsDoneButton.hidden = false;

    titleLabel.text = (_sessionName)?_sessionName:@"";
    leftLandscapeTitleLabel.text = (_sessionName)?_sessionName:@"";
    rightlandscapeTitleLabel.text = (_sessionName)?_sessionName:@"";
    
    mediaDownloadLabel.hidden = true;
    [circleProgressBar setHintTextFont:[UIFont fontWithName:@"Oswald-Regular" size:10]];
    [circleProgressBar setHintTextColor:[Utility colorWithHexString:@"E427A0"]];
    
    if ([self isFollowAlongSessionDownloaded]) {
        downloadButton.hidden = true;
    }else{
        downloadButton.hidden = false;
    }
    
    [self setFollowAlongVideo];
}
-(void)setFollowAlongVideo{
    
    NSString *videoUrl;
    NSURL *videoURL;
    
     if([self isFollowAlongSessionDownloaded]){
         NSString *destinationFilename = @"";
         if(![Utility isEmptyCheck:_followAlongSessiondata[@"VideoLink"]]){
             destinationFilename = [@"" stringByAppendingFormat:@"%@%@.mp4",_sessionName,_followAlongSessiondata[@"VideoLink"]];
         }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:destinationFilename];
        videoURL = [NSURL fileURLWithPath:fullPathToFile];
     }else if(![Utility isEmptyCheck:_followAlongSessiondata[@"PublicVideoUrl"]]){
         
         if([self isFollowAlongSessionDownloaded]){
             
             NSString *destinationFilename = @"";
             if(![Utility isEmptyCheck:_followAlongSessiondata[@"VideoLink"]]){
                 destinationFilename = [@"" stringByAppendingFormat:@"%@%@.mp4",_sessionName,_followAlongSessiondata[@"VideoLink"]];
             }
             
             NSFileManager *fileManager = [NSFileManager defaultManager];
             NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
             NSString* documentsDirectory = [paths objectAtIndex:0];
             NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:destinationFilename];
             videoURL = [NSURL fileURLWithPath:fullPathToFile];
             
         }else{
             videoUrl = _followAlongSessiondata[@"PublicVideoUrl"];
             videoURL = [NSURL URLWithString:videoUrl];
         }
     }
    
    if(videoURL){
        [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                          error: nil];
        // create an AVPlayer
        videoPlayer = [AVPlayer playerWithURL:videoURL];
        
        // create a player view controller
        avPlayerController = [[AVPlayerViewController alloc]init];
        avPlayerController.player = videoPlayer;
        avPlayerController.showsPlaybackControls = true;
        
        //loops
        videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndPause;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[videoPlayer currentItem]];
        
        // remove if the view controller is already present
        UIViewController *vc = [self.childViewControllers lastObject];
        //    NSLog(@"vc %@",vc);
        if ([vc isKindOfClass:[AVPlayerViewController class]]) {
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
        [[mainView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        // show the view controller
        [self addChildViewController:avPlayerController];
        [mainView addSubview:avPlayerController.view];
        avPlayerController.view.frame = mainView.bounds;
        [videoPlayer pause];
    }
}

-(void)setupMusicWeightButton{
  
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"my"];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Eye Catching Pro" size:45] range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString length])];
    
    NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:@"MUSIC"];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:16] range:NSMakeRange(0, [attributedString2 length])];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString2 length])];
    
    [attributedString appendAttributedString:attributedString2];
    
    myMusicButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    myMusicButton.layer.borderWidth=1;
    
    [myMusicButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    
    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc]initWithString:@"my"];
    [attributedString3 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Eye Catching Pro" size:45] range:NSMakeRange(0, [attributedString3 length])];
    [attributedString3 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString3 length])];
    
    NSMutableAttributedString *attributedString4 =[[NSMutableAttributedString alloc]initWithString:@"WEIGHTS"];
    [attributedString4 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:16] range:NSMakeRange(0, [attributedString4 length])];
    [attributedString4 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString4 length])];
    
    [attributedString3 appendAttributedString:attributedString4];
    
    weightRecordButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    weightRecordButton.layer.borderWidth=1;
    
    [weightRecordButton setAttributedTitle:attributedString3 forState:UIControlStateNormal];
  
}

- (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 40);
    }
    return size;
}

-(void)followAlongCompleteAlert{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Complete Session?"
                                          message:@"Are you sure you want to complete your session?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self endSession];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == parentScroll) {
        if (pageControlIsChangingPage) {
            return;
        }
        CGFloat pageWidth = parentScroll.frame.size.width;
        float fractionalPage = parentScroll.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        currentPage = page;
        
    }else{
        if (scrollView.contentOffset.y < yOffset) {
            // scrolls down.
            yOffset = scrollView.contentOffset.y;
            scrollDirection = @"down";
        }
        else {
            // scrolls up.
            yOffset = scrollView.contentOffset.y;
            scrollDirection = @"up";
        }
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == parentScroll) {
        pageControlIsChangingPage = NO;
        [self reloadAfterPageChange];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == parentScroll) {
        pageControlIsChangingPage = NO;
        [self reloadAfterPageChange];
    }
}

#pragma mark - End
#pragma mark - WebService Call

-(void)webserviceCall_CountSessionDone{ //add8
    
     if (![defaults boolForKey:@"IsNonSubscribedUser"] && ![Utility isSubscribedUser] && ![Utility isSquadLiteUser]) {
         return;
     }
    
    
    if (Utility.reachable && ![Utility isOfflineMode]) {
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:completeSessionId] forKey:@"SessionId"]; //_exSessionId
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"CountSessionDone" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self isUpdateSeasonCount];
                                                                     }
                                                                     else{
                                                                         //[Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     //[Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self offlineSessionDoneDailyWorkout:NO];
        }else{
            //[Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
    
}

- (void) updateSessionDoneStatusApi{
    
    if (![defaults boolForKey:@"IsNonSubscribedUser"] && ![Utility isSubscribedUser] && ![Utility isSquadLiteUser]) {
        return;
    }
    
    if (Utility.reachable && ![Utility isOfflineMode]) {
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInteger:_workoutTypeId] forKey:@"Id"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SetSquadUserWorkoutSessionIsDone" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self isUpdateSeasonCount];
                                                                         
                                                                     }
                                                                     else{
                                                                        // [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     //[Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self offlineSessionDoneCustomWorkout:NO];
        }else{
            //[Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
    
}
#pragma mark - End
#pragma mark - TableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView == nextCircuitsTable){
        return nextCircuitList.count;
    }
    
    return exerciseNameArray.count-currentCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(tableView == nextCircuitsTable){
        
        NSString *CellIdentifier = @"ExerciseDetailsTableViewCell";
        ExerciseDetailsTableViewCell *cell;
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ExerciseDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
            NSDictionary *dict = [nextCircuitList objectAtIndex:indexPath.row];
            NSMutableAttributedString *exerciseName = [dict objectForKey:@"ExerciseName"];
            //        if (![Utility isEmptyCheck:exerciseName]) {
            //            cell.exerciseName.text = exerciseName;
            //        }
            //        cell.numberLabel.text = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.row];
            cell.numberLabel.text = [NSString stringWithFormat:@"%c.",(int)indexPath.row+97];
            NSString *reps =@"";
            if (![Utility isEmptyCheck:exerciseName]) {
                reps = [@"" stringByAppendingFormat:@" %@\n%d",[dict objectForKey:@"ExerciseName"],[[dict valueForKey:@"RepGoal"] intValue]];
            }
            if (![Utility isEmptyCheck:reps]) {
                if ([[dict objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps"] == NSOrderedSame) {
                    
                    cell.reps.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",reps] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" reps" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                    
                    cell.reps.hidden = false;
                    
                } else if ([[dict objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame) {
                    cell.reps.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",reps] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" reps each side" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                    cell.reps.hidden = false;
                    
                } else if ([[dict objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Seconds Each Side"] == NSOrderedSame) {
                    cell.reps.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",reps] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" secs each side" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                    cell.reps.hidden = false;
                    //ah 1.2
                } else {
                    if (![Utility isEmptyCheck:[dict objectForKey:@"RepsUnitText"]]) {
                        cell.reps.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",reps] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:[@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"RepsUnitText"]] bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                        cell.reps.hidden = false;
                    }else{
                        cell.reps.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",reps] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" secs" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                        cell.reps.hidden = false;
                    }
                }
                
                
            }else{
                cell.reps.text = @"";
                cell.reps.hidden = true;
            }
        
            NSString *sets = [@"" stringByAppendingFormat:@"%d",[[dict valueForKey:@"SetCount"] intValue]];
            if (![Utility isEmptyCheck:sets] && [[dict objectForKey:@"IsSuperSet"] intValue] == 0) {
                
                cell.reps.hidden = false;
                if (![Utility isEmptyCheck:cell.reps.attributedText]) {
                    NSAttributedString *setsAttrString =[Utility getStringWithHeader:[NSString stringWithFormat:@"  X %@",(_sessionFlowId == TIMER || _sessionFlowId == CIRCUITTIMER)?@"∞":sets] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" sets" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                    NSMutableAttributedString* result = [cell.reps.attributedText mutableCopy];
                    [result appendAttributedString:setsAttrString];
                    cell.reps.attributedText =result;
                    
                }else{
                    cell.reps.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",sets] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" sets" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                }
                
            }
            
            NSArray *equipments = [dict objectForKey:@"Equipments"];
            if (![Utility isEmptyCheck:equipments] && equipments.count > 0) {
                cell.equipmentRequired.text = [@"\u2022  " stringByAppendingString:[equipments componentsJoinedByString:@"\n\u2022  "]];
                cell.equipmentRequiredStackView.hidden = false;
                
            }else{
                cell.equipmentRequiredStackView.hidden = true;
            }
            NSArray *tips = [dict objectForKey:@"Tips"];
            if (![Utility isEmptyCheck:tips] && tips.count > 0) {
                cell.exerciseTips.text = [@"\u2022  " stringByAppendingString:[tips componentsJoinedByString:@"\n\u2022  "]];
                cell.exerciseTipsStackView.hidden = false;
                cell.tipsStackView.hidden = true;
                
            }else{
                cell.exerciseTipsStackView.hidden = true;
                cell.tipsStackView.hidden = true;
            }
            
            //ah 17
            for (UIView *view in cell.equipmentBasedAlternativesButtonStackView.arrangedSubviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    [cell.equipmentBasedAlternativesButtonStackView removeArrangedSubview:view] ;
                    [view removeFromSuperview];
                }
            }
            NSArray *substituteEquipments = [dict objectForKey:@"SubstituteExercises"];
            if (substituteEquipments.count > 0) {
                for (int i=0; i<substituteEquipments.count; i++) {
                    NSDictionary *substituteExercisesDict = [substituteEquipments objectAtIndex:i];
                    if (![Utility isEmptyCheck:[substituteExercisesDict objectForKey:@"SubstituteExerciseName"]]) {
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        if (![Utility isEmptyCheck:[substituteExercisesDict objectForKey:@"SubstituteExerciseId"]]) {
                            [button addTarget:self
                                       action:@selector(substituteExercisesButtonPressed:)
                             forControlEvents:UIControlEventTouchUpInside];
                            NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[@"  \u2022  " stringByAppendingString:[substituteExercisesDict objectForKey:@"SubstituteExerciseName"]] attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),NSForegroundColorAttributeName:[UIColor blueColor]}];
                            [button setAttributedTitle:titleString forState:UIControlStateNormal];
                            button.tag =[[substituteExercisesDict objectForKey:@"SubstituteExerciseId"] integerValue];
                            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                            
                            button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                        }else{
                            
                            [button setTitle:[@"  \u2022  " stringByAppendingString:[substituteExercisesDict objectForKey:@"SubstituteExerciseName"]] forState:UIControlStateNormal];
                            
                            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                            
                            button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        }
                        [cell.equipmentBasedAlternativesButtonStackView addArrangedSubview:button];
                        
                    }
                }
                cell.equipmentBasedAlternativesStackView.hidden = false;
                
            }else{
                cell.equipmentBasedAlternativesStackView.hidden = true;
                
            }
            
            for (UIView *view in cell.bodyWeightAlternativesButtonStackView.arrangedSubviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    [cell.bodyWeightAlternativesButtonStackView removeArrangedSubview:view] ;
                    [view removeFromSuperview];
                }
            }
            NSArray *AltBodyWeightExercises = [dict objectForKey:@"AltBodyWeightExercises"];
            if (![Utility isEmptyCheck:AltBodyWeightExercises] && AltBodyWeightExercises.count > 0) {
                for (int i=0; i<AltBodyWeightExercises.count; i++) {
                    NSDictionary *altBodyWeightExercisesDict = [AltBodyWeightExercises objectAtIndex:i];
                    if (![Utility isEmptyCheck:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseName"]]) {
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        if (![Utility isEmptyCheck:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseId"]]) {
                            [button addTarget:self
                                       action:@selector(substituteExercisesButtonPressed:)
                             forControlEvents:UIControlEventTouchUpInside];
                            NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[@"  \u2022  " stringByAppendingString:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseName"]] attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),NSForegroundColorAttributeName:[UIColor blueColor]}];
                            [button setAttributedTitle:titleString forState:UIControlStateNormal];
                            button.tag =[[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseId"] integerValue];
                            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                            
                            button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                        }else{
                            
                            [button setTitle:[@"  \u2022  " stringByAppendingString:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseName"]] forState:UIControlStateNormal];
                            
                            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                            
                            button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        }
                        [cell.bodyWeightAlternativesButtonStackView addArrangedSubview:button];
                        
                    }
                }
                cell.bodyWeightAlternativesStackView.hidden = false;
            }else{
                cell.bodyWeightAlternativesStackView.hidden = true;
            }
            cell.restPeriodStackView.hidden = YES;
            
            
            NSArray *photoList = [dict objectForKey:@"PhotoList"];
            NSString  *videoUrlString = [dict objectForKey:@"VideoUrlPublic"];
            
            [cell.detailContainerStackView removeArrangedSubview:cell.playerContainer];
            [cell.playerContainer removeFromSuperview];
            
            if ((![Utility isEmptyCheck:photoList] && photoList.count > 0 && ![Utility isEmptyCheck:[photoList objectAtIndex:0]]) ||(![Utility isEmptyCheck:videoUrlString])) {
                [cell.detailContainerStackView insertArrangedSubview:cell.playerContainer atIndex:2];
                if (![Utility isEmptyCheck:photoList] && photoList.count > 0 && ![Utility isEmptyCheck:[photoList objectAtIndex:0]]) {
                    [cell.exerciseImageView sd_setImageWithURL:[NSURL URLWithString:[photoList objectAtIndex:0]]
                                              placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageScaleDownLargeImages];
                    cell.exerciseImageView.hidden = false;
                    
                }else{
                    cell.exerciseImageView.hidden = true;
                }
                if (![Utility isEmptyCheck:videoUrlString]) {
                    
                }else{
                    cell.exercisePlayerView.hidden = true;
                }
                //ah 17
                [cell.scrollNextButton setTag:indexPath.row+10001];
                cell.scrollNextButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",(int)indexPath.section + 10001];
                [cell.scrollNextButton addTarget:self
                                          action:@selector(scrollNextButtonTapped:)
                                forControlEvents:UIControlEventTouchUpInside];
                
                [cell.scrollPreviousButton setTag:indexPath.row+20001];
                cell.scrollPreviousButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",(int)indexPath.section + 20001];
                [cell.scrollPreviousButton addTarget:self
                                              action:@selector(scrollPreviousButtonTapped:)
                                    forControlEvents:UIControlEventTouchUpInside];
                
                if([Utility isEmptyCheck:photoList] || photoList.count == 0 || [Utility isEmptyCheck:[photoList objectAtIndex:0]]){
                    cell.exercisePlayerView.hidden = false;
                    cell.exerciseImageView.hidden = true;
                    cell.scrollNextButton.hidden = YES;
                    cell.scrollPreviousButton.hidden = YES;
                }else if([Utility isEmptyCheck:videoUrlString]){
                    cell.exercisePlayerView.hidden = true;
                    cell.exerciseImageView.hidden = false;
                    cell.scrollNextButton.hidden = YES;
                    cell.scrollPreviousButton.hidden = YES;
                }else{
                    cell.exercisePlayerView.hidden = true;
                    cell.exerciseImageView.hidden = false;
                    cell.scrollNextButton.hidden = NO;
                    cell.scrollPreviousButton.hidden = YES;
                }
                
            }
            
            
            
            //superSet
            if ([[dict objectForKey:@"IsSuperSet"] intValue] >= 1) {
                cell.circuitSuperSetView.hidden = NO;
                cell.setLabel.hidden = YES;
                if ([[dict objectForKey:@"SuperSetPosition"] intValue] == -1) {
                    //first
                    cell.circuitSuperSetUpperView.hidden = YES;
                    cell.circuitSuperSetMiddleView.hidden = NO;
                    cell.circuitSuperSetLowerView.hidden = NO;
                    
                    if(_sessionFlowId == TIMER || _sessionFlowId == CIRCUITTIMER){
                        cell.setLabel.text = [NSString stringWithFormat:@"x ∞ sets"];
                    }else{
                        cell.setLabel.text = [NSString stringWithFormat:@"x %@ sets",[[dict objectForKey:@"SetCount"] stringValue]];
                    }
                    
                    
                    cell.setLabel.hidden = NO;
                    cell.setLabel.textColor = [UIColor whiteColor];
                    
                    //                if ([scrollDirection caseInsensitiveCompare:@"down"] == NSOrderedSame)    //ah 27.2
                    //                    isSsOnce = NO;
                    
                    cell.cellSeparatorRightView.backgroundColor = [UIColor whiteColor]; //ah 27.2
                } else if ([[dict objectForKey:@"SuperSetPosition"] intValue] == 0) {
                    //middle
                    cell.circuitSuperSetUpperView.hidden = NO;
                    cell.circuitSuperSetMiddleView.hidden = YES;
                    cell.circuitSuperSetLowerView.hidden = NO;
                    if(_sessionFlowId == TIMER || _sessionFlowId == CIRCUITTIMER){
                        cell.setLabel.text = [NSString stringWithFormat:@"x ∞ sets"];
                    }else{
                        cell.setLabel.text = [NSString stringWithFormat:@"x %@ sets",[[dict objectForKey:@"SetCount"] stringValue]];
                    }
                    
                    cell.setLabel.hidden = NO;
                    cell.setLabel.textColor = [UIColor whiteColor];
                    
                    cell.cellSeparatorRightView.backgroundColor = [UIColor whiteColor]; //ah 27.2
                } else if ([[dict objectForKey:@"SuperSetPosition"] intValue] == 1) {
                    //third
                    cell.circuitSuperSetUpperView.hidden = NO;
                    cell.circuitSuperSetMiddleView.hidden = NO;
                    cell.circuitSuperSetLowerView.hidden = YES;
                    
                    if(_sessionFlowId == TIMER || _sessionFlowId == CIRCUITTIMER){
                        cell.setLabel.text = [NSString stringWithFormat:@"x ∞ sets"];
                    }else{
                        cell.setLabel.text = [NSString stringWithFormat:@"x %@ sets",[[dict objectForKey:@"SetCount"] stringValue]];
                    }
                    
                    cell.setLabel.hidden = NO;
                    cell.setLabel.textColor = [UIColor whiteColor];
                    cell.cellSeparatorRightView.backgroundColor = [UIColor lightGrayColor]; //ah 27.2
                }
                if ([[dict objectForKey:@"isMiddle"] boolValue]) {
                    cell.setLabel.textColor = [UIColor grayColor];
                }else{
                    cell.setLabel.textColor = [UIColor clearColor];
                }
            } else {
                cell.circuitSuperSetView.hidden = YES;
                cell.setLabel.hidden = YES;
            }
        
        
        cell.mainViewWidthConstraint.constant = [[UIScreen mainScreen] bounds].size.width - 30;
        
        CGRect frame = cell.cellScrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        [cell.cellScrollView scrollRectToVisible:frame animated:NO];
        //end
        
        
        
        return cell;
        
    }else{
        NSString *CellIdentifier =@"VideoTableViewCell";
        VideoTableViewCell *cell = (VideoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if ([[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"isCircuit"] boolValue]) { //AY 02112017
            cell.exerciseNameLabel.text = [exerciseNameArray objectAtIndex:indexPath.row+currentCount];
            
            
            //cell.exerciseCircuitNo.text = [[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"srNo"];
            cell.exerciseCircuitNo.text = @"";
            cell.exerciseExName.hidden = YES;
            cell.exerciseExNo.hidden = YES;
            cell.exerciseNameLabel.hidden = NO;
            cell.exerciseCircuitNo.hidden = NO;
            
            //        cell.exerciseCircuitNo.hidden = YES;
        } else {
            cell.exerciseExName.text = [exerciseNameArray objectAtIndex:indexPath.row+currentCount];
            
            
            cell.exerciseExNo.text = [[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"srNo"];
            cell.exerciseExName.hidden = NO;
            cell.exerciseExNo.hidden = NO;
            cell.exerciseNameLabel.hidden = YES;
            cell.exerciseCircuitNo.hidden = YES;
            
            //        cell.exerciseExNo.hidden = YES;
        }
        
        cell.exerciseTimeLabel.text = [[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"RepGoal"];
        //    cell.exerciseSetCountLabel.text = [[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"setCount"];
        cell.exerciseRepsCountLabel.text = @"10 Reps";
        int isSupersetCount = [[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"isSuperSet"] intValue];
        //    int nextSupersetCount = 0;
        
        if (isSupersetCount > 0 && ![[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"isCircuit"] boolValue]) {
            
            if ([[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"SuperSetPosition"] intValue] == -1) {
                cell.exerciseSupersetTopView.hidden = true;
                cell.exerciseSupersetMiddleView.hidden = false;
                cell.exerciseSupersetBottomView.hidden = false;
            } else if ([[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"SuperSetPosition"] intValue] == 0) {
                cell.exerciseSupersetTopView.hidden = false;
                cell.exerciseSupersetMiddleView.hidden = true;
                cell.exerciseSupersetBottomView.hidden = false;
            } else if ([[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"SuperSetPosition"] intValue] == 1) {
                
                if ([[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"RepsUnitText"] rangeOfString:@"Each Side" options:NSCaseInsensitiveSearch].location != NSNotFound && !isEachSide) {
                    cell.exerciseSupersetTopView.hidden = false;
                    cell.exerciseSupersetMiddleView.hidden = true;
                    cell.exerciseSupersetBottomView.hidden = false;
                    isEachSide = YES;
                } else {
                    cell.exerciseSupersetTopView.hidden = false;
                    cell.exerciseSupersetMiddleView.hidden = false;
                    cell.exerciseSupersetBottomView.hidden = true;
                    isEachSide = NO;
                }
                //                }
            }
            
            
            isSuperSetCell = YES;
            [cell.contentView setNeedsUpdateConstraints];
            //        cell.exerciseBgView.backgroundColor = [UIColor colorWithRed:(112/255.0) green:(153/255.0) blue:(253/255.0) alpha:0.5];
            
        } else {
            cell.exerciseSupersetLabel.hidden = true;
            cell.exerciseSupersetTopView.hidden = true;
            cell.exerciseSupersetMiddleView.hidden = true;
            cell.exerciseSupersetBottomView.hidden = true;
            isSuperSetCell = NO;
            //        cell.exerciseBgView.backgroundColor = [UIColor whiteColor];
            //        cell.repsSecsLabel.hidden = YES;
        }
        //    cell.repsLabel.text
        
        if ([[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"isCircuit"] boolValue]) {
            cell.repsSecsLabel.hidden = YES;
        } else {
            cell.repsSecsLabel.hidden = NO;
            if ([[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps"] == NSOrderedSame) {
                cell.repsSecsLabel.text = [NSString stringWithFormat:@"%d reps",[[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"RepGoal"] intValue]];
            } else if ([[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame) {
                
                
                NSString *localSideStr = [[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"eachSideText"];
                
                cell.repsSecsLabel.text = [NSString stringWithFormat:@"%d reps %@",[[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"RepGoal"] intValue],localSideStr];
                
                //}
            } else if ([[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Seconds Each Side"] == NSOrderedSame) {
                
                
                
                NSString *repsUnitText =[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"RepsUnitText"];
                
                if ([repsUnitText caseInsensitiveCompare:@"Minutes"] == NSOrderedSame || [repsUnitText caseInsensitiveCompare:@"Min"] == NSOrderedSame) {
                    cell.repsSecsLabel.text = [NSString stringWithFormat:@"%d Min %@",[[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"RepGoal"] intValue]/60,[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"eachSideText"]];
                }else{
                    cell.repsSecsLabel.text = [NSString stringWithFormat:@"%d secs %@",[[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"RepGoal"] intValue],[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"eachSideText"]];
                }
                
                
                //            }
            } else {
                NSString *repsUnitText =[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"RepsUnitText"];
                
                if ([repsUnitText caseInsensitiveCompare:@"Minutes"] == NSOrderedSame || [repsUnitText caseInsensitiveCompare:@"Min"] == NSOrderedSame) {
                    cell.repsSecsLabel.text = [NSString stringWithFormat:@"%d Min",[[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"RepGoal"] intValue]/60];
                }else{
                    cell.repsSecsLabel.text = [NSString stringWithFormat:@"%d secs",[[[dataArray objectAtIndex:indexPath.row+currentCount] objectForKey:@"RepGoal"] intValue]];
                }
                
            }
        }
        //}
        return cell;
    }
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int count = (int)indexPath.row + currentCount;
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Change Section"
                                          message:@"Would you like to jump to this section?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                                   NSString *destinationFilename = [NSString stringWithFormat:@"%@.mp4",[[dataArray objectAtIndex:count] objectForKey:@"ExerciseName"]];
                                   NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                   NSString* documentsDirectory = [paths objectAtIndex:0];
                                   NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:destinationFilename];
                                   NSURL *destinationURL = [NSURL fileURLWithPath:fullPathToFile];
                                   
                                  if ((![[NSFileManager defaultManager] fileExistsAtPath:[destinationURL path]] || [self checkDownloadFileSize:fullPathToFile]) && ![Utility reachable]) {
                                       
                                       NSString *videoName = [[dataArray objectAtIndex:count] objectForKey:@"ExerciseName"];
                                       [self playPauseButtonTapped:playPauseButton];

                                       [self errorDownloadingAlert:[videoName stringByAppendingString:@" Video not downloaded.Check Your network connection and try again."] title:@"Oops! "];
                                       return;
                                       
                                   }
                                   
                                   currentCircuit = count;
                                   downloadCount = count; //AY 11122017
                                   //audioDownloadCount = count-1;
                                   
                                   isNameAudioPlaying = NO;
                                   nextUpView.hidden = true;
                                   parentScroll.scrollEnabled = true;
                                   isNextUpPlaying = NO;
                                   currentCount = count;
                                   [exerciseTable reloadData];
                                   audioCounter = count;
                                   videoCounter = count;
                                   [audioPlayer pause];
                                   [audioPlayer stop];
                                   self->isSkip = YES;
                                   [self forwardButtonTapped:nil];
                                   
                                   
                                   
                                   //[self nextVideo];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - NSURLSession Delegate method implementation

-(void)URLSession:(NSURLSession *)session1 downloadTask:(NSURLSessionDownloadTask *)downloadTask1 didFinishDownloadingToURL:(NSURL *)location{
    
    if(session1 == followAlongDownloadSession){
        
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *destinationFilename = downloadTask1.originalRequest.URL.lastPathComponent;
        
        
        if(![Utility isEmptyCheck:_followAlongSessiondata[@"VideoLink"]]){
            destinationFilename = [@"" stringByAppendingFormat:@"%@%@.mp4",_sessionName,_followAlongSessiondata[@"VideoLink"]];
        }
        
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
        
        
        if (success) {
            if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile] && ![self checkDownloadFileSize:fullPathToFile]) {
                NSLog(@"Single Download success. original main.");
                NSLog(@"url %@",fullPathToFile);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    mediaDownloadLabel.hidden = NO;
                    mediaDownloadLabel.text = @"Session Downloaded";
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        mediaDownloadLabel.hidden = YES;
                    });
                    [self updateExerciseNamesToDB];
                    downloadButton.hidden = true;
                    [circleProgressBar setProgress:0.0 animated:YES];
                    circleProgressBar.hidden = true;
                    
                });
                
            }
            
        }
        else{
            NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
            // [Utility msg: [@"" stringByAppendingString:@" Error downloading video.Check Your network connection and try again."] title:@"Oops! " controller:self haveToPop:NO];
            [self errorDownloadingAlert:[error localizedDescription] title:@""];
        }
        
    }else if(session1 == singleDownloadSession){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!loadingView.isHidden){
                loadingView.hidden = true;
            }
            if(contentView){
                [contentView removeFromSuperview];
                [contentViewLabel removeFromSuperview];
                [progressView removeFromSuperview];
            }
        });
        
        
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *destinationFilename = downloadTask1.originalRequest.URL.lastPathComponent;
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
        
        
        if (success) {
            if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile] && ![self checkDownloadFileSize:fullPathToFile]) {
                NSLog(@"Single Download success. original main.");
                NSLog(@"url %@",fullPathToFile);
                
                [self playPauseButtonTapped:playPauseButton];

                isOffTime = NO;
                if (isFirstExDownloading) {
                    isFirstExDownloading = NO;
                    [self nextVideo];
                } else {
                    [self playNextUpWithTime:isOffTime];
                }
            }
            
            totalMediaDownloaded++;
            if(totalMediaDownloaded == totalMediaCount){
                [self downloadStatusUpdate];
            }
        }
        else{
            NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
            // [Utility msg: [@"" stringByAppendingString:@" Error downloading video.Check Your network connection and try again."] title:@"Oops! " controller:self haveToPop:NO];
            
          
        }
        
    }else if (session1 == session) {
        
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *destinationFilename = downloadTask1.originalRequest.URL.lastPathComponent;
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
        
       
        if (success) {
            if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                NSLog(@"Download success. original main.");
                NSLog(@"url %@",fullPathToFile);
                totalMediaDownloaded++;
                if(totalMediaDownloaded == totalMediaCount){
                     [self downloadStatusUpdate];
                }
               
            }
        }
        else{
           
           
            NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
        }
        
        
    } else if (session1 == audioUrlSession) {
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *destinationFilename = downloadTask1.originalRequest.URL.lastPathComponent;
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
            if (success) {
                if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                    NSLog(@"Download success. original main. Audio.");
                    NSLog(@"url %@",fullPathToFile);
                    totalMediaDownloaded++;
                    if(totalMediaDownloaded == totalMediaCount){
                        [self downloadStatusUpdate];
                    }
                }else{
                    
                }
            }
            else{
               
               
                NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
            }
        }];
    }
}


-(void)URLSession:(NSURLSession *)session1 task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    if(session1 == session){
        [downloadTask resume];
    }else if(session1 == audioUrlSession){
        [audioDownloadTask resume];
    }
    
    if (error != nil) {
        
       
            if(session1 == singleDownloadSession){
                
              
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(!loadingView.isHidden){
                        loadingView.hidden = true;
                    }
                    
                    if(contentView){
                        [contentView removeFromSuperview];
                        [contentViewLabel removeFromSuperview];
                        [progressView removeFromSuperview];
                    }
                });
                
                NSLog(@"Single Download completed with error: %@", [error localizedDescription]);
                if(![Utility isOfflineMode])[Utility msg: [@"" stringByAppendingString:@" Error downloading video.Check Your network connection and try again."] title:@"Oops! " controller:self haveToPop:NO];
                
                [self playPauseButtonTapped:playPauseButton];

                isOffTime = NO;
                if (isFirstExDownloading) {
                    isFirstExDownloading = NO;
                    [self nextVideo];
                } else {
                    [self playNextUpWithTime:isOffTime];
                }
                
            }else if(session1 == followAlongDownloadSession){
                [self errorDownloadingAlert:[error localizedDescription] title:@""];
            }
            else{
                 NSLog(@"Download completed with error: %@", [error localizedDescription]);
            }
        
        }
        else{
            
            if(session1 == singleDownloadSession){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(!loadingView.isHidden){
                        loadingView.hidden = true;
                    }
                    
                    if(contentView){
                        [contentView removeFromSuperview];
                        [contentViewLabel removeFromSuperview];
                        [progressView removeFromSuperview];
                    }
                });
                
                
                NSString *destinationFilename = singleDownloadTask.originalRequest.URL.lastPathComponent;
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:destinationFilename];
                
                if([self checkDownloadFileSize:fullPathToFile]){
                    if(![Utility isOfflineMode])[Utility msg: [@"" stringByAppendingString:@"Error downloading video.Check Your network connection and try again."] title:@"Oops! " controller:self haveToPop:NO];
                    
                    NSLog(@"Single Download Size Error");
                    
                    [self playPauseButtonTapped:playPauseButton];

                    isOffTime = NO;
                    if (isFirstExDownloading) {
                        isFirstExDownloading = NO;
                        [self nextVideo];
                    } else {
                        [self playNextUpWithTime:isOffTime];
                    }
                    
                }else{
                NSLog(@"Download finished successfully.");
                }
            }else if(session1 == followAlongDownloadSession){
                
                NSString *destinationFilename = followAlongDownloadTask.originalRequest.URL.lastPathComponent;
                if(![Utility isEmptyCheck:_followAlongSessiondata[@"VideoLink"]]){
                    destinationFilename = [@"" stringByAppendingFormat:@"%@%@.mp4",_sessionName,_followAlongSessiondata[@"VideoLink"]];
                }
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:destinationFilename];
                
                if([self checkDownloadFileSize:fullPathToFile]){
                    if(![Utility isOfflineMode])[self errorDownloadingAlert:@"Error downloading video.Check Your network connection and try again." title:@""];
                    
                }else{
                    NSLog(@"Single Download finished successfully.");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        downloadButton.hidden = true;
                        [circleProgressBar setProgress:0.0 animated:YES];
                        circleProgressBar.hidden = true;
                        [self updateExerciseNamesToDB];
                    });
                    
                }
                
            }
        }
   
}


-(void)URLSession:(NSURLSession *)session1 downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
            NSLog(@"Unknown transfer size");
            //            progress.hidden= true;
            
        }else{
            double downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
            
            if (progressView && session1 == singleDownloadSession) {
                
                //            progressPercentageLabel.text = [NSString stringWithFormat:@"%d",(int)(downloadProgress * 100)];
                progressView.progress = downloadProgress;
            }else if(session1 == followAlongDownloadSession){
                NSLog(@"Download Progress:%@",[@"" stringByAppendingFormat:@"%.0f%%",downloadProgress*100]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->circleProgressBar setProgress:downloadProgress animated:YES];
                    [self->circleProgressBar setHintTextGenerationBlock:(YES ? ^NSString *(CGFloat progress) {
                        return [@"" stringByAppendingFormat:@"%.0f%%",downloadProgress*100];
                    } : nil)];
                });
            }
            
            
        }
    }];
}


-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    
}

- (void)URLSession:(NSURLSession *)session1 didBecomeInvalidWithError:(nullable NSError *)error {
    NSLog(@"Invalid session (%@) WithError %@",session1,error);
    
     if(session1 == singleDownloadSession){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(!loadingView.isHidden){
                loadingView.hidden = true;
            }
            if(contentView){
                [contentView removeFromSuperview];
                [contentViewLabel removeFromSuperview];
                [progressView removeFromSuperview];
            }
        });
     }else if(session1 == followAlongDownloadSession){
         [self errorDownloadingAlert:[error localizedDescription] title:@""];
     }
    
}
#pragma mark - AVAudioPlayer Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"%@",[defaults objectForKey:@"Inbetween Rounds"]);
    if (player == audioPlayer) {
        if (onTime > 0) {
            //no change
            NSLog(@"\n\n\n-----------------On time>0");
            [audioPlayer setVolume:0.6];
            [self setBackgroundMusicVolume:0.8];
        }else if ([[defaults objectForKey:@"Inbetween Rounds"] caseInsensitiveCompare:@"PLAY SOFTER"] == NSOrderedSame  && onTime == 0){
            [self setBackgroundMusicVolume:0.6];
            NSLog(@"\n\n\n-----------------On PLAY SOFTER");

        }else{
            NSLog(@"\n\n\n-----------------OnElse");
            [audioPlayer setVolume:0.6];
            [self setBackgroundMusicVolume:0.8];
        }
        
//        if (isNameAudioPlaying) {
//            isNameAudioPlaying = NO;
//            nextUpView.hidden = true;
//            parentScroll.scrollEnabled = true;
//            isNextUpPlaying = NO;
//            [self nextVideo];
//        }
    }
}

#pragma mark - End

#pragma mark - Local Notification Observer
-(void)didBecomeActive:(NSNotification *)notification{
    
    if (videoPlayer && videoPlayer.rate == 0.0){
        [videoPlayer play];
    }
}
-(void)quitSession:(NSNotification *)notification{
    
    NSString *text = notification.object;
    

    if([text isEqualToString:@"homeButtonPressed"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
                if (shouldPop) {
                    [videoPlayer pause];
                    [audioPlayer pause];
                    [audioPlayer stop];
                    [mainTimer invalidate];
                    [sessionTimer invalidate];
                    if(([Utility isSubscribedUser] && [Utility isOfflineMode]) || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
                        if (!isAllTaskCompleted ){
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }else{
//                            TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
                            GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                            [self.navigationController pushViewController:controller animated:YES];
                        }
                    }
                }
            }];
        });
    }else{
        [self backButton:0];
    }
   
}

-(void)menuButtonPressed:(NSNotification *)notification{
    isClearAll = false;
    
    MenuSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuSettingsView"];
    [self.navigationController pushViewController:controller animated:true];
    
}

-(void)checkReachability:(NSNotification *)notification{
    
    if([Utility reachable]){
        
        if(downloadTask.state == NSURLSessionTaskStateSuspended){
            [downloadTask resume];
        }
        
        if(audioDownloadTask.state == NSURLSessionTaskStateSuspended){
            [audioDownloadTask resume];
        }
        
        
    }else{
        
        if(downloadTask.state == NSURLSessionTaskStateRunning){
            [downloadTask suspend];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(!loadingView.isHidden){
                    loadingView.hidden = true;
                }
                if(contentView){
                    [contentView removeFromSuperview];
                    [contentViewLabel removeFromSuperview];
                    [progressView removeFromSuperview];
                    [self playPauseButtonTapped:playPauseButton];
                }
            });
        }
        
        if(audioDownloadTask.state == NSURLSessionTaskStateRunning){
            [audioDownloadTask suspend];
        }
    }
   
}

#pragma mark - End

//UIUpdate
#pragma mark - OrientationChange
- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            NSLog(@"potrait 1");
            landscapeView.hidden = true;
            scroll.hidden = false;
            islandScapeEnable = false;
            [self orientationChangedDetails];
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"potraitDown 2");
            landscapeView.hidden = true;
            scroll.hidden = false;
            islandScapeEnable = false;
            [self orientationChangedDetails];
            break;
            
        case  UIDeviceOrientationLandscapeLeft:
            NSLog(@"LandscapeLeft 3");
            landscapeView.hidden =false;
            scroll.hidden = true;
            islandScapeEnable = true;
            float degrees1 = 90; //the value in degrees
            landscapePlayerView.transform = CGAffineTransformMakeRotation(degrees1 * M_PI/180);
            landscapePlayerView.frame =  CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            leftLandscapeforwarBackwardButtonView.hidden = false;
            rightLandscapeforwarBackwardButtonView.hidden = true;
            leftLandscapeTimerCountRepsView.hidden = false;
            rightLandscapeTimerCountRepsView.hidden = true;
            leftNextupTimerView.hidden = true;
            rightNextupTimerView.hidden = false;
            leftNextUpRestDetailsView.hidden =false;
            rightNextUpRestDetailsView.hidden =true;
            
            [landScapePlayPauseButton setTransform:CGAffineTransformMakeRotation(M_PI / 2)];

           
            [landscapeSessionTimeLabel setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
            [rightLandscapeNextUpTimerLabel setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
            self->landscapeNextUpPlayerView.transform = CGAffineTransformMakeRotation(degrees1 * M_PI/180);
            self->landscapeNextUpPlayerView.frame =  CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            [rightNextUpLabel setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
            [landscapeRestDetailsButton setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
            
            [landScapeTimerCountLabel setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
            [landscapeRepsSetLabel setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
            [leftLandscapeTitleLabel setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
            
            [self setPostionOfLeftLandScape];
            [self orientationChangedDetails];

            break;
            
        case  UIDeviceOrientationLandscapeRight:
            NSLog(@"LandscapeRight 4");
            landscapeView.hidden = false;
            scroll.hidden = true;
            islandScapeEnable = true;
            float degrees = 90; //the value in degrees
            landscapePlayerView.transform = CGAffineTransformMakeRotation(degrees * -M_PI/180);
            landscapePlayerView.frame =  CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            leftLandscapeforwarBackwardButtonView.hidden = true;
            rightLandscapeforwarBackwardButtonView.hidden = false;
            leftLandscapeTimerCountRepsView.hidden = true;
            rightLandscapeTimerCountRepsView.hidden = false;
            leftNextupTimerView.hidden=false;
            rightNextupTimerView.hidden= true;
            leftNextUpRestDetailsView.hidden =true;
            rightNextUpRestDetailsView.hidden =false;
            
            [rightLandScapePlayPauseButton setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];

            [rightLandscapeSessionTimeLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];

            [landscapeNextUpTimerLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];

            self->landscapeNextUpPlayerView.transform = CGAffineTransformMakeRotation(degrees * -M_PI/180);
            self->landscapeNextUpPlayerView.frame =  CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            
            [leftNextUpLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
            [rightLandscapeRestDetailsButton setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
            
            [rightLandScapeTimerCountLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
            [rightLandscapeRepsSetLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
            [rightlandscapeTitleLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
            
            [self setPostionOfRightLandScape];
            [self orientationChangedDetails];
            break;
            
        default:
            break;
    };
}

-(void)orientationChangedDetails{ //Update
    if (islandScapeEnable) {
        if (gameOnView.hidden && circuitTimerStartingView.hidden && roundNumberShowView.hidden) {//check
            if(isCompleted){
                self->landscapeView.hidden = true;
                self->landscapeNextUpView.hidden = true;
            }else{
                self->landscapeView.hidden = false;
            }
        }else{
            self->landscapeView.hidden = true;
            self->landscapeNextUpView.hidden = true;
        }
        if (self->isNextUpPlaying) {
            if (!restViewDetails.hidden) {
                self->landscapeNextUpView.hidden = true;
                self->nextUpView.hidden = false;
                self->nextUpScrollView.hidden = true;
                self->landscapeView.hidden = true;
            }else{
                self->landscapeView.hidden = true;
                self->nextUpView.hidden = true;
                self->landscapeNextUpView.hidden = false;
            }
            
            [[landscapeNextUpPlayerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [landscapeNextUpPlayerView addSubview:avPlayerController.view];
            avPlayerController.view.frame = landscapeNextUpPlayerView.bounds;
            [avPlayerController setVideoGravity:AVLayerVideoGravityResizeAspectFill]; //AVVideoScalingModeResizeAspectFill
            
        }else{
            
            [[landscapePlayerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [landscapePlayerView addSubview:avPlayerController.view];
            avPlayerController.view.frame = landscapePlayerView.bounds;
            [avPlayerController setVideoGravity:AVLayerVideoGravityResizeAspectFill]; //AVVideoScalingModeResizeAspectFill
        }
        
    }else{
        if (self->isNextUpPlaying) {
            self->landscapeView.hidden = true;
            self->nextUpView.hidden = false; //chng//
            self->nextUpScrollView.hidden = false;
            self->landscapeNextUpView.hidden = true;
            
            [[nextUpMainView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [nextUpMainView addSubview:avPlayerController.view];
            avPlayerController.view.frame = mainView.bounds;
        }else{
            [[mainView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [mainView addSubview:avPlayerController.view];
            avPlayerController.view.frame = mainView.bounds;
        }
    }
}

-(void)setPostionOfLeftLandScape{
    leftLandscapeTitleLabel.frame = CGRectMake(leftLandscapeTimerCountRepsView.frame.origin.y , 0, 30,leftLandscapeTitleLabel.intrinsicContentSize.width+10);
    landScapeTimerCountLabel.frame = CGRectMake(-leftLandscapeTimerCountRepsView.frame.origin.y-5 , 0, 30,landScapeTimerCountLabel.intrinsicContentSize.width+10);
    landscapeRepsSetLabel.frame = CGRectMake(-leftLandscapeTimerCountRepsView.frame.origin.y-5 , 0, 30,landscapeRepsSetLabel.intrinsicContentSize.width+10);//getRepsCountString
    
    rightNextUpLabel.frame= CGRectMake(rightNextupTimerView.frame.origin.y, 0, 30, rightNextUpLabel.intrinsicContentSize.width+10);
    
}

-(void)setPostionOfRightLandScape{
    rightlandscapeTitleLabel.frame = CGRectMake(rightLandscapeTimerCountRepsView.frame.origin.y,rightLandscapeTimerCountRepsView.frame.size.height, 30,-rightlandscapeTitleLabel.intrinsicContentSize.width-10);
    rightLandScapeTimerCountLabel.frame = CGRectMake(rightLandscapeTimerCountRepsView.frame.origin.y+rightlandscapeTitleLabel.frame.size.width+5, rightLandscapeTimerCountRepsView.frame.size.height, 30,-rightLandScapeTimerCountLabel.intrinsicContentSize.width-10);
    rightLandscapeRepsSetLabel.frame = CGRectMake(rightLandscapeTimerCountRepsView.frame.origin.y+rightlandscapeTitleLabel.frame.size.width+5, rightLandscapeTimerCountRepsView.frame.size.height, 30,-rightLandscapeRepsSetLabel.intrinsicContentSize.width-10);
    
    leftNextUpLabel.frame = CGRectMake(leftNextupTimerView.frame.origin.y, leftNextupTimerView.frame.size.height, 30, -leftNextUpLabel.intrinsicContentSize.width-10);
}
#pragma mark - End
//UIUpdate

#pragma mark - UIPageControl method

//Method to swipe between the pages
-(void)reloadSettingsTable{
    for(UIViewController *controller in [self childViewControllers]){
        if ([controller isKindOfClass:[SettingsViewController class]]) {
            SettingsViewController *new = (SettingsViewController *)controller;
            [new refreshTable];
        }
    }
}
- (IBAction)changePage:(id)sender
{
    if (currentPage == 0) {
        currentPage = 1;
    }else{
        currentPage = 0;
    }
    //move the scroll view
    CGRect frame = parentScroll.frame;
    frame.origin.x = frame.size.width * currentPage;
    frame.origin.y = 0;
    [parentScroll scrollRectToVisible:frame animated:YES];
    //scrollViewDidEndDecelerating will turn this off
    pageControlIsChangingPage = YES;
}
-(void)reloadAfterPageChange{
    dispatch_async(dispatch_get_main_queue(), ^{
      
        if (tempCurrentPage != currentPage) {
            tempCurrentPage = currentPage;
            if (currentPage == 1) {
                isWeightSheetButtonPressed = YES;
                if(gameOnTimer.isValid){
                   [self clearAll];
                }else{
                    if(isPlaying){
                        [self playPauseButtonTapped:playPauseButton];
                    }
                }

            }else{
                if (gameOnTimer== nil && currentPage == 0) {
                    
                    if(videoCounter > 0){
                        currentCount--;
                        [exerciseTable reloadData];
                        videoCounter--;
                        audioCounter--;
                    }
                    
                    isPlaying = YES;
                    
                    [nextExerciseButton setUserInteractionEnabled:YES];
                    [repsDoneButton setUserInteractionEnabled:YES];
                    [landscapeRepsDoneButton setUserInteractionEnabled:YES];
                    [rightLandscapeRepsDoneButton setUserInteractionEnabled:YES];


                    [nextUpButton setUserInteractionEnabled:YES];
                    
                    if (isForwardChanged) {
                        [forwardButton setUserInteractionEnabled:YES];
                        [landscapeForwardButton setUserInteractionEnabled:YES];
                        [landscapeRightSideForwardButton setUserInteractionEnabled:YES];
                    }
                    
                    if (isBackwardChanged) {
                        [backwardButton setUserInteractionEnabled:YES];
                        [landscapeBackwardButton setUserInteractionEnabled:YES];
                        [landscapeRightSideBackwardButton setUserInteractionEnabled:YES];
                    }
                    gameOnTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(gameOnCounter) userInfo:nil repeats:YES];
                    [[NSRunLoop mainRunLoop] addTimer:gameOnTimer forMode:NSRunLoopCommonModes];
                    if (gameOnView.hidden) {
                        [gameOnTimer fire];
                    }

                }else{
                    [self playPauseButtonTapped:playPauseButton];
                }
            }
            
        }
    });
}
#pragma mark-End
#pragma mark-OfflineSessionDone

-(void)offlineSessionDoneDailyWorkout:(BOOL)isFav{
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    int sessionId = completeSessionId;
    if([DBQuery isRowExist:@"dailyworkout" condition:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            NSArray *arr = [dbObject selectBy:@"dailyworkout" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"dailyWorkoutList",@"favSessionList",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]];
            
            if(arr.count>0){
                NSMutableArray *favArray = [[NSMutableArray alloc]init];
                if(![Utility isEmptyCheck:arr[0][@"favSessionList"]]){
                    NSString *str = arr[0][@"favSessionList"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    favArray = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
                    
                    NSArray *filterarray = [favArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SessionId == %d)", sessionId]];
                    if(filterarray.count>0){
                        NSInteger objectIndex= [favArray indexOfObject:filterarray[0]];
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:filterarray[0]];
                        int sessionCount = [dict[@"SessionCount"]intValue];
                        
                        if(sessionCount>0 && isFav){
                            BOOL IsFavorite = [dict[@"IsFavorite"] boolValue];
                            [dict setObject:[NSNumber numberWithBool:!IsFavorite] forKey:@"IsFavorite"];
                            [dict setObject:[NSNumber numberWithBool:true] forKey:@"IsFavDone"];
                            [favArray replaceObjectAtIndex:objectIndex withObject:dict];
                        }else if(!isFav){
                            sessionCount++;
                            [dict setObject:[NSNumber numberWithInt:sessionCount] forKey:@"SessionCount"];
                            [dict setObject:[NSNumber numberWithBool:true] forKey:@"IsCountDone"];
                            [favArray replaceObjectAtIndex:objectIndex withObject:dict];
                        }
                        
                    }else{
                        if(!isFav){
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsFavorite"];
                            [dict setObject:[NSNumber numberWithInt:1] forKey:@"SessionCount"];
                            [dict setObject:[NSNumber numberWithBool:true] forKey:@"IsCountDone"];
                            [dict setObject:[NSNumber numberWithInt:userId] forKey:@"UserId"];
                            [dict setObject:[NSNumber numberWithInt:sessionId] forKey:@"SessionId"];
                            [favArray addObject:dict];
                        }
                    }
                    
                    
                }else{
                    if(!isFav){
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsFavorite"];
                        [dict setObject:[NSNumber numberWithInt:1] forKey:@"SessionCount"];
                        [dict setObject:[NSNumber numberWithBool:true] forKey:@"isDone"];
                        [dict setObject:[NSNumber numberWithInt:userId] forKey:@"UserId"];
                        [dict setObject:[NSNumber numberWithInt:sessionId] forKey:@"SessionId"];
                        [favArray addObject:dict];
                    }
                    
                }
                
                
                if(favArray.count<=0){
                    return;
                }
                
                NSString *favString = @"";
                
                if(favArray.count>0){
                    NSError *error;
                    NSData *favData = [NSJSONSerialization dataWithJSONObject:favArray options:NSJSONWritingPrettyPrinted  error:&error];
                    
                    if (error) {
                        
                        NSLog(@"Error Favorite Array-%@",error.debugDescription);
                    }
                    
                    favString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
                }
                
                NSMutableString *modifiedExList = [NSMutableString stringWithString:favString];
                [modifiedExList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExList length])]; //AY 07032018
                
                if([dbObject connectionStart]){
                    
                    NSString *date = [NSDate date].description;
                    NSArray *columnArray = [[NSArray alloc]initWithObjects:@"favSessionList",@"isSync",@"lastUpdate",nil];
                    NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedExList,[NSNumber numberWithInt:0],date, nil];
                    
                    [dbObject updateWithCondition:@"dailyworkout" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]];
                    [self isUpdateSeasonCount];
                }
                [dbObject connectionEnd];
                
                
            }
            
            
        }
    }
    
}// AY 02032018

-(void)offlineSessionDoneCustomWorkout:(BOOL)isFav{
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    int sessionId = _workoutTypeId;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDate *weekStart = [formatter dateFromString:weekDate];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *weekStartDateStr = [formatter stringFromDate:weekStart]; //;
    
    if([DBQuery isRowExist:@"customExerciseList" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStartDateStr]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            
            NSArray *arr = [dbObject selectBy:@"customExerciseList" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"exerciseList",@"joiningDate",@"weekStartDate",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStartDateStr]];
            
            
            if(arr.count>0){
                NSMutableArray *favArray = [[NSMutableArray alloc]init];
                if(![Utility isEmptyCheck:arr[0][@"exerciseList"]]){
                    NSString *str = arr[0][@"exerciseList"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    favArray = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
                    
                    NSArray *filterarray = [favArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Id == %d)", sessionId]];
                    if(filterarray.count>0){
                        NSInteger objectIndex= [favArray indexOfObject:filterarray[0]];
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:filterarray[0]];
                        BOOL isDone = [dict[@"IsDone"]boolValue];
                        
                        if(isDone && isFav){
                            BOOL IsFavorite = [dict[@"IsFavourite"] boolValue];
                            [dict setObject:[NSNumber numberWithBool:!IsFavorite] forKey:@"IsFavourite"];
                            [dict setObject:[NSNumber numberWithBool:true] forKey:@"IsFavDone"];
                            [favArray replaceObjectAtIndex:objectIndex withObject:dict];
                        }else if(!isFav){
                            [dict setObject:[NSNumber numberWithBool:!isDone] forKey:@"IsDone"];
                            [dict setObject:[NSNumber numberWithBool:true] forKey:@"IsCountDone"];
                            [favArray replaceObjectAtIndex:objectIndex withObject:dict];
                        }
                        
                    }
                    
                }
                
                
                if(favArray.count<=0){
                    return;
                }
                
                NSString *favString = @"";
                if(favArray.count>0){
                    NSError *error;
                    NSData *favData = [NSJSONSerialization dataWithJSONObject:favArray options:NSJSONWritingPrettyPrinted  error:&error];
                    
                    if (error) {
                        
                        NSLog(@"Error Favorite Array-%@",error.debugDescription);
                    }
                    
                    favString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
                }
                
                NSMutableString *modifiedExList = [NSMutableString stringWithString:favString];
                [modifiedExList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExList length])];
                
                if([dbObject connectionStart]){
                    
                    NSString *date = [NSDate date].description;
                    NSArray *columnArray = [[NSArray alloc]initWithObjects:@"exerciseList",@"isSync",@"lastUpdate",nil];
                    NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedExList,[NSNumber numberWithInt:0],date, nil];
                    
                    [dbObject updateWithCondition:@"customExerciseList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStartDateStr]];
                    [self isUpdateSeasonCount];
                    
                }
                [dbObject connectionEnd];
            }
            
            
        }
    }
}
#pragma mark-End

@end
