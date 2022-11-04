//
//  WebinarSelectedViewController.m
//  The Life
//
//  Created by AQB SOLUTIONS on 07/04/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "WebinarSelectedViewController.h"
#import "WebinarSelectedTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PodcastViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
#import "PrivacyPolicyAndTermsServiceViewController.h"
#import "VisualizerView.h"
#define visualizerAnimationDuration 0.01
#import "TableViewCell.h"

@import Photos;


@interface WebinarSelectedViewController (){
    AppDelegate *appDelegate;
    AVPlayer *playerForDownloadedVideo;
    IBOutlet UIView *playerContainerView;
    IBOutlet UIView *upcomingWebinrMessageContainerView;
    IBOutlet UILabel *upcomingMessageLabel;
    IBOutlet UIImageView *quoteOftheWeekImage;
    
    IBOutlet UIImageView *headerBg;
    IBOutlet UITableView *table;
    IBOutlet UIView *mainView;
    IBOutlet UIView *clearView;
    IBOutlet UIButton *playPauseButton;
    IBOutlet UILabel *currentTime;
    IBOutlet UILabel *totalTimeLabel;
    
    IBOutlet UILabel *presenterNameVideoView;
    IBOutlet UILabel *eventNameNameVideoView;
    
    IBOutlet UILabel *eventName;
    IBOutlet UILabel *presenterName;
    IBOutlet UILabel *eventDetail;
    IBOutlet UIImageView *eventImage;
    
    IBOutlet UILabel *eventTagView;
    IBOutlet NSLayoutConstraint *eventTagViewHeightConstraint;
    IBOutlet UIButton *eventLikeDislike;
    IBOutlet UILabel *eventLikeCount;
    IBOutlet UIButton *eventWatchListButton;
    IBOutlet UIButton *eventDownloadButton;
    IBOutlet UIButton *eventPodcastButton;
    IBOutlet NSLayoutConstraint *eventWatchListButtonConstraint;
    IBOutlet NSLayoutConstraint *eventDownloadButtonConstraint;
    
    IBOutlet UILabel *moreFromPresenterLabel;

    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *previousButton;
    

    //    IBOutlet UISlider *volumeSlider;
    IBOutlet UISlider *progressBar;
    IBOutlet UIView *playerLabelView;
    IBOutlet UIButton *muteButton;
    int tapCount;
    UIImage *playButtonImage;
    UIImage *pauseButtonImage;
    UIButton *button;
    UIView *contentView;
    NSMutableArray *webinarsOfPresenter;
    NSInteger selectedIndex;
    
    IBOutlet UILabel *eventstatus;
    IBOutlet UIProgressView *eventProgress;
    NSURLSessionDownloadTask *eventDownloadTask;
    
    NSMutableDictionary *backgroundDownloadDict;
    NSMutableDictionary *indexPathAndTaskDict;
    
    IBOutlet UIButton *backwardButton;
    IBOutlet UIButton *forwardButton;
    IBOutlet UIButton *eventAttachmentButton;
    IBOutlet UIView *attachmentView;
    IBOutlet UIStackView *attachmentStackView;
    
    IBOutlet UIWebView *webView;
    IBOutlet UIView *soundCloudAudioView;
    IBOutlet UIView *progressBarView;
    IBOutlet UIStackView *playStackView;
    double videoStartTime;
    IBOutlet UIButton *fullScreenButton;
    
    IBOutlet UIView *nonHealingDescView;
    IBOutlet UIView *testNowView;
    IBOutlet UILabel *nonHealingLabel;
    IBOutlet UIButton *checkedNonQuedButton;
    IBOutlet UIView *nonQuedView;
    IBOutlet UIView *nonQuedDescriptionView;
    IBOutlet UITextView *nonQuedDescriptiontext;
    IBOutlet  UIView *nonQuedSubDescriptionView;
    
    IBOutlet UIButton *nonQueDropdownButton;
    
    IBOutlet UIView *guidedMainView;
    IBOutletCollection(UIButton) NSArray *guidedCheckButtonArray;
    
    IBOutlet UIView *guidedView1;
    IBOutlet UILabel *guidedLabel1;
    
    IBOutlet UIView *guidedView2;
    IBOutlet UILabel *guidedLabel2;
    
    IBOutlet UIView *guidedView3;
    IBOutlet UILabel *guidedLabel3;
    
    IBOutlet UIView *guidedView4;
    IBOutlet UILabel *guidedLabel4;
    
    IBOutlet UIView *guidedView5;
    IBOutlet UILabel *guidedLabel5;
    
    
    IBOutlet UIView *visualizeView;
    IBOutlet UIView *backgroundView;
    IBOutlet UILabel *currentVisualTime;
    IBOutlet UILabel *totalVisualLabel;
    IBOutlet UISlider *progressVisualSlider;
    IBOutlet UIButton *shopNow;
    IBOutlet UIButton *testNow;
    IBOutlet UILabel *shopNowLabel;
    IBOutlet UILabel *testNowLabel;
    IBOutlet UIView *shopView;
    IBOutlet UIImageView *imgView;
    IBOutlet UIButton *shopNowDropButton;
    IBOutlet UIButton *testNowDropButton;
    IBOutlet UIStackView *shopDescStackView;
    IBOutlet UIStackView *testDescStackView;
    IBOutlet UIButton *questionButton;
    IBOutlet UIButton *doubleArrow;
    IBOutlet UIView *questionmarkGuidedView;
    IBOutlet UIButton *gotItButton;
    IBOutlet UITableView *searchTableView;
    IBOutlet UIView *serachView;
    IBOutlet UIView *searchTableSuperView;
    IBOutlet NSLayoutConstraint *searchTableHeightConstant;
    AVPlayerViewController *avplayerViewController;
    NSMutableArray *addDropdownList;
    NSTimer *visualizerTimer;
    double lowPassReslts;
    double lowPassReslts1;
    VisualizerView *visualizer;
    BOOL isCheck;
    NSArray *dropDownListArray;
    int indexValue;
    BOOL isDefaultSelect;
    BOOL isfromDropDown;
    int indexGuided;
    BOOL isUpdateTimeCalled;
}

@end

@implementation WebinarSelectedViewController
@synthesize webinar,upcomingWebinarsData,isFromWatchList,isShowFavAlert;

#pragma mark - ViewLifeCycle -
- (void)viewDidLoad {
    [super viewDidLoad];
    self->visualizeView.hidden = true;
    guidedMainView.hidden=true;
    addDropdownList = [[NSMutableArray alloc]init];
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        headerBg.image = [UIImage imageNamed:@"header-4s.png"];
    }else{
        headerBg.image = [UIImage imageNamed:@"header.png"];
    }
    
    eventDownloadButton.hidden = YES;
    
    eventDownloadButton.layer.borderColor = [UIColor colorWithRed:50/255.0f green:205/255.0f blue:184/255.0f alpha:1.0f].CGColor;
    eventDownloadButton.layer.borderWidth = 1.2;
    eventDownloadButton.clipsToBounds = YES;
    eventDownloadButton.layer.cornerRadius = eventDownloadButton.frame.size.height/2.0;
    
    eventAttachmentButton.layer.borderColor = [UIColor colorWithRed:50/255.0f green:205/255.0f blue:184/255.0f alpha:1.0f].CGColor;
    eventAttachmentButton.layer.borderWidth = 1.2;
    eventAttachmentButton.clipsToBounds = YES;
    eventAttachmentButton.layer.cornerRadius = eventAttachmentButton.frame.size.height/2.0;
    
    attachmentView.hidden = YES;
    
    nonQuedSubDescriptionView.layer.cornerRadius = 15;
    nonQuedSubDescriptionView.layer.masksToBounds = YES;
    
    serachView.hidden = true;
    shopNow.layer.cornerRadius = 15;
    shopNow.layer.masksToBounds = YES;
    
    testNow.layer.cornerRadius = 15;
    testNow.layer.masksToBounds = YES;
    
    eventImage.layer.cornerRadius = eventImage.frame.size.width/2;
    eventImage.clipsToBounds = YES;
    
    imgView.layer.cornerRadius = 15;
    imgView.layer.masksToBounds = YES;
    
    gotItButton.layer.cornerRadius = 15;
    gotItButton.layer.masksToBounds = YES;
    
    webinarsOfPresenter = [[NSMutableArray alloc]init];
    progressBar.value = 0.0;
    progressVisualSlider.value = 0.0;
    //customize progressBar
//    [progressBar setMinimumTrackTintColor:[UIColor colorWithRed:(126/255.0) green:(200/255.0) blue:(222/255.0) alpha:1]];
//    [progressBar setMaximumTrackTintColor:[UIColor colorWithRed:(209/255.0) green:(209/255.0) blue:(209/255.0) alpha:1]];
//    UIImage *thumbImage = [UIImage imageNamed:@"vol_cir.png"];
//    [progressBar setThumbImage:thumbImage forState:UIControlStateNormal];
    
    //ProgressBar
    [progressBar setMinimumTrackTintColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1]];//50 205 184
    [progressBar setMaximumTrackTintColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1]];
    UIImage *thumbImage = [UIImage imageNamed:@"progressbar_line_black.png"];
    [progressBar setThumbImage:thumbImage forState:UIControlStateNormal];
    
    [progressVisualSlider setMinimumTrackTintColor:[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1]];
    [progressVisualSlider setMaximumTrackTintColor:[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1]];
    UIImage *thumbImage1 = [UIImage imageNamed:@"progressbar_line_white.png"];
    [progressVisualSlider setThumbImage:thumbImage1 forState:UIControlStateNormal];
    
    
    //hide/show play/pause button
    playButtonImage = [UIImage imageNamed:@"play_button.png"];
    pauseButtonImage = [UIImage imageNamed:@"pause_button.png"];
//    playPauseButton.hidden = true;
    playerLabelView.hidden = true;
//    [playPauseButton setBackgroundImage:pauseButtonImage forState:UIControlStateNormal];
    // Delay execution of for 10 seconds.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"tc %d",self->tapCount);
        if (self->tapCount == 0) {
//            playPauseButton.hidden = true;
            self->playerLabelView.hidden = true;
        }
    });
    table.estimatedRowHeight = 55.0;
    table.rowHeight = UITableViewAutomaticDimension;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.TheSquatWebinarDetails"];
    sessionConfiguration.allowsCellularAccess = YES;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil];

    NSURLSessionConfiguration *sessionConfiguration1 = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.TheSquatWebinarDetails1"];
    sessionConfiguration.allowsCellularAccess = YES;
    
    self.session1 = [NSURLSession sessionWithConfiguration:sessionConfiguration1
                                                 delegate:self
                                            delegateQueue:nil];

    
    NSURLSessionConfiguration *sessionConfiguration2 = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.TheSquatWebinarNonQued"];
       sessionConfiguration.allowsCellularAccess = YES;
       
    self.session2 = [NSURLSession sessionWithConfiguration:sessionConfiguration2
                                                    delegate:self
                                               delegateQueue:nil];

    
    
    //[self getWebinarDetails:[webinar valueForKey:@"PresenterName"]];
    if (isFromWatchList) {
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
        dispatch_async(myQueue, ^{
            NSArray *eventItemVideoDetailsArray = [self->webinar valueForKey:@"EventItemVideoDetails"];
            if (self->upcomingWebinarsData && [[self->upcomingWebinarsData objectForKey:@"EventItemID"] isEqual: [self->webinar objectForKey:@"EventItemID"]] ){
                eventItemVideoDetailsArray = [self->upcomingWebinarsData valueForKey:@"EventItemVideoDetails"];
            }
            if (eventItemVideoDetailsArray.count > 0) {
                NSDictionary *eventItemVideoDetails = [eventItemVideoDetailsArray objectAtIndex:0];
                if (![Utility isEmptyCheck:eventItemVideoDetails]) {
                    if (![Utility isEmptyCheck:[eventItemVideoDetails valueForKey:@"IsViewedVideo"]] && ![[eventItemVideoDetails valueForKey:@"IsViewedVideo"] boolValue]) {
                        [self setIsViewedServiceCall];
                    }
                }
            }
            
        });
    }
    eventProgress.hidden = true;
    //[self getWebinarDetails:[webinar valueForKey:@"PresenterName"]];
    
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"RunningVideoSection"]]) {
        if ([[defaults objectForKey:@"RunningVideoSection"] isEqualToString:@"Course"]) {
            if (![Utility isEmptyCheck:[defaults objectForKey:@"PlayingCourse"]]) {
                NSString *courseStr=[defaults objectForKey:@"PlayingCourse"];
                NSData *data = [courseStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                CMTime startTime = appDelegate.playerController.player.currentTime;
                double videoStartTime = CMTimeGetSeconds(startTime);
                [Utility updateCourseVideoTime:dict videoStartTime:videoStartTime];
                [defaults removeObjectForKey:@"PlayingCourse"];
            }
        }else if ([[defaults objectForKey:@"RunningVideoSection"] isEqualToString:@"Meditation"]){
            if (![Utility isEmptyCheck:[defaults objectForKey:@"PlayingMeditation"]]) {
                NSString *webinarstr=[defaults objectForKey:@"PlayingMeditation"];
                NSData *data = [webinarstr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if ([webinar objectForKey:@"EventItemID"]!=[dict objectForKey:@"EventItemID"]) {
                    CMTime startTime = appDelegate.playerController.player.currentTime;
                    double videoStartTime = CMTimeGetSeconds(startTime);
//                    [Utility updateWebinarVideoTime:dict videoStartTime:videoStartTime];
                    [Utility saveWebinarVideoStartTimeIntoTable:dict videoStartTime:videoStartTime];
                    [defaults removeObjectForKey:@"PlayingMeditation"];
                    [defaults removeObjectForKey:@"RunningVideoSection"];
                }
            }
        }
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self->mainView.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    searchTableView.estimatedRowHeight = 50;
    searchTableView.rowHeight = UITableViewAutomaticDimension;
    [searchTableView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    indexValue = -1;
    isfromDropDown = false;
    NSError *sessionError = nil;

    @try {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord  withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionAllowBluetoothA2DP error:&sessionError];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
//        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
    } @catch (NSException *exception) {
        NSLog(@"Audio Session error %@, %@", exception.reason, exception.userInfo);
        
    } @finally {
        NSLog(@"Audio Session finally");
    }
    [self getGuidedMeditations_Webservicecall];
    searchTableSuperView.hidden = true;
    questionmarkGuidedView.hidden = true;
    [self nonQueDropdownPressed:nil];
    if (![Utility isEmptyCheck:webinar]) {
        if ([Utility reachable]) {
            [self getVideoStartTimeFromTable];
        }else{
            [self updateView];
        }
    }else{
        [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        

        self->backgroundDownloadDict = [[NSMutableDictionary alloc]init];
        self->indexPathAndTaskDict = [[NSMutableDictionary alloc]init];
        if (![Utility isEmptyCheck:[defaults objectForKey:@"indexPathAndTaskDictWebnairDetails"]]) {
            self->indexPathAndTaskDict = [[defaults objectForKey:@"indexPathAndTaskDictWebnairDetails"] mutableCopy];
        }
    }];
    if (appDelegate.FBWAudioPlayer.rate == 0) {
//        [playPauseButton setBackgroundImage:playButtonImage forState:UIControlStateNormal];
        playPauseButton.selected=NO;
    } else if (appDelegate.FBWAudioPlayer.rate == 1){
//        [playPauseButton setBackgroundImage:pauseButtonImage forState:UIControlStateNormal];
        playPauseButton.selected=YES;

    }
    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc]initWithString:@""];
       [attributedString3 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Bold" size:20] range:NSMakeRange(0, [attributedString3 length])];
       [attributedString3 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"8f8f8f"] range:NSMakeRange(0, [attributedString3 length])];
       
       NSMutableAttributedString *attributedString4 =[[NSMutableAttributedString alloc]initWithString:@"Take your meditations next level. Reduce sensory input with a 'Meditation Mask' by MindbodyHQ."];
       [attributedString4 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Bold" size:15] range:NSMakeRange(0, [attributedString4 length])];
       [attributedString4 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"8f8f8f"] range:NSMakeRange(0, [attributedString4 length])];
       
       [attributedString3 appendAttributedString:attributedString4];
       shopNowLabel.attributedText = attributedString3;
    
        NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc]initWithString:@""];
          [attributedString5 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Bold" size:20] range:NSMakeRange(0, [attributedString5 length])];
          [attributedString5 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"8f8f8f"] range:NSMakeRange(0, [attributedString5 length])];
          
          NSMutableAttributedString *attributedString6 =[[NSMutableAttributedString alloc]initWithString:@"Unsure of the perfect level for you? Do a quick test now."];
          [attributedString6 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Bold" size:15] range:NSMakeRange(0, [attributedString6 length])];
          [attributedString6 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"8f8f8f"] range:NSMakeRange(0, [attributedString6 length])];
          
          [attributedString5 appendAttributedString:attributedString6];
          testNowLabel.attributedText = attributedString5;
}


-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
//    [appDelegate.FBWAudioPlayer pause];
    
    if (appDelegate.FBWAudioPlayer.rate>0 ) {
        
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:webinar options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [appDelegate.FBWAudioPlayer pause];
            NSLog(@"Error -- %@",error.debugDescription);
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        [defaults setObject:jsonString forKey:@"PlayingMeditation"];
        [defaults setObject:@"Meditation" forKey:@"RunningVideoSection"];
    }else{
        [appDelegate.FBWAudioPlayer pause];
        if (![Utility isEmptyCheck:[defaults objectForKey:@"PlayingMeditation"]]) {
            [defaults removeObjectForKey:@"PlayingMeditation"];
        }
        if (![Utility isEmptyCheck:[defaults objectForKey:@"RunningVideoSection"]]) {
            [defaults removeObjectForKey:@"RunningVideoSection"];
        }
    }
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [defaults setObject:self->indexPathAndTaskDict forKey:@"indexPathAndTaskDictWebnairDetails"];
    }];
    
        
//    if (videoStartTime>0) {
        if ([Utility reachable]) {
//            [self UpdateEventItemVideoTime];
            [self saveVideoStartTimeIntoTable];
        }else{
            [self updateVideoTimeForOffline];
        }
    
//    }
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self sizeHeaderToFit];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (searchTableView.contentSize.height<20) {
        searchTableHeightConstant.constant = 50;
    }else{
        searchTableHeightConstant.constant = searchTableView.contentSize.height+10;

    }
}
#pragma mark - End -
#pragma mark - Webservice call
-(void)getGuidedMeditations_Webservicecall{
    if (Utility.reachable) {
            NSURLSession *loginSession = [NSURLSession sharedSession];
            
            NSError *error;
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
            [mainDict setObject:AccessKey forKey:@"Key"];
            [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
            [mainDict setObject:[[webinar objectForKey:@"Tags"]objectAtIndex:0] forKey:@"EventTagName"];
//            [mainDict setObject:[NSNumber numberWithInt:count*10] forKey:@"Count"];

            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetGuidedMeditationsBySearchTag" append:@"" forAction:@"POST"];
            NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
//
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                                 self->dropDownListArray = [responseDictionary objectForKey:@"Webinars"];
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
    }
}



#pragma mark - Private Function -

-(void)setGuidedView{
    if (![Utility isEmptyCheck:webinar]) {
        isCheck = false;
        if (![Utility isEmptyCheck:webinar[@"Guided1Title"]] && ![Utility isEmptyCheck:webinar[@"Guided1Url"]]) {
            guidedLabel1.text=webinar[@"Guided1Title"];
            guidedView1.hidden=false;
            isCheck = true;
        }else{
            guidedView1.hidden=true;
        }
        
        if (![Utility isEmptyCheck:webinar[@"Guided2Title"]] && ![Utility isEmptyCheck:webinar[@"Guided2Url"]]) {
            guidedLabel2.text=webinar[@"Guided2Title"];
            guidedView2.hidden=false;
            isCheck = true;

        }else{
            guidedView2.hidden=true;
        }
        
        if (![Utility isEmptyCheck:webinar[@"Guided3Title"]] && ![Utility isEmptyCheck:webinar[@"Guided3Url"]]) {
            guidedLabel3.text=webinar[@"Guided3Title"];
            guidedView3.hidden=false;
            isCheck = true;

        }else{
            guidedView3.hidden=true;
        }
        
        if (![Utility isEmptyCheck:webinar[@"Guided4Title"]] && ![Utility isEmptyCheck:webinar[@"Guided4Url"]]) {
            guidedLabel4.text=webinar[@"Guided4Title"];
            guidedView4.hidden=false;
            isCheck = true;

        }else{
            guidedView4.hidden=true;
        }
        
        if (![Utility isEmptyCheck:webinar[@"Guided5Title"]] && ![Utility isEmptyCheck:webinar[@"Guided5Url"]]) {
            guidedLabel5.text=webinar[@"Guided5Title"];
            guidedView5.hidden=false;
            isCheck = true;

        }else{
            guidedView5.hidden=true;
        }
        
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        if (isCheck ==true){
            if([DBQuery isRowExist:@"guidedDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]] && isCheck){
            int index = 0;
                DAOReader *dbObject = [DAOReader sharedInstance];
                if([dbObject connectionStart]){
                    NSArray *guidedArr = [dbObject selectBy:@"guidedDetails" withColumn:[[NSArray alloc]initWithObjects:@"GuidedIndex",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]];
                    if (guidedArr.count>0) {
                        index = [[[guidedArr objectAtIndex:0]objectForKey:@"GuidedIndex"]intValue];
                    }
                    
                }
            for (UIButton *btn in guidedCheckButtonArray) {
                if (btn.tag == index) {
                    btn.selected = true;
                }else{
                    btn.selected = false;
                }

            }
        }
     }
        
   }
}

-(void)backToWebinarList{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[WebinarListViewController class]]) {
            WebinarListViewController *c=(WebinarListViewController *)controller;
            c.isFromDetails=YES;
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    WebinarListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarListView"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)fetchDataFromTable{
    int userId = [[defaults objectForKey:@"UserID"] intValue];
      if([DBQuery isRowExist:@"nonQuedDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@'",[NSNumber numberWithInt:userId]]]){
         DAOReader *dbObject = [DAOReader sharedInstance];
          if([dbObject connectionStart]){
              NSArray *webniarArr = [dbObject selectBy:@"nonQuedDetails" withColumn:[[NSArray alloc]initWithObjects:@"NonQuedValue",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@' AND EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]];
                    if (![Utility isEmptyCheck:webniarArr] && (webniarArr.count>0)) {
                        NSDictionary *dict = [webniarArr objectAtIndex:0];
                    if ([[dict objectForKey:@"NonQuedValue"]boolValue]) {
//                        checkedNonQuedButton.selected = true;
                            [self playNonQued];
                            self->visualizeView.hidden = false;
                    }else if(indexValue>=0){
                        [self playNonQued];
                        self->visualizeView.hidden = false;
                    }else if(indexGuided>=0){
                        [self playNonQued];
                        self->visualizeView.hidden = false;
                    }else{
//                        checkedNonQuedButton.selected = false;
                        self->visualizeView.hidden = true;
                    }
                }else{
//                    checkedNonQuedButton.selected = false;
                        self->visualizeView.hidden = true;
                }
          }
          [dbObject connectionEnd];
      }else if(indexValue>=0){
          [self playNonQued];
          self->visualizeView.hidden = false;
      }else if(indexGuided>=0){
          [self playNonQued];
          self->visualizeView.hidden = false;
      }else{
          BOOL isCheck = [DBQuery createTableDBForNonQued];
          if (isCheck) {
              [DBQuery addNonQuedDetails:checkedNonQuedButton.isSelected with:[[webinar objectForKey:@"EventItemID"]intValue] withNonQuePlay:false];
              if (checkedNonQuedButton.isSelected) {
                   dispatch_async(dispatch_get_main_queue(), ^{//dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0
                     [self playNonQued];
                     self->visualizeView.hidden = false;

                    });

              }
          }else{
              [Utility msg:@"DataBase Not Updated" title:@"" controller:self haveToPop:NO];
          }
      }
}
-(void)addUpdateDBForNonQued:(BOOL)tick{
        BOOL isAdeed = NO;
        int userId = [[defaults objectForKey:@"UserID"] intValue];
            if([DBQuery isRowExist:@"nonQuedDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' AND EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]]){
                 [DBQuery updateNonQuedDetails:tick with:[[webinar objectForKey:@"EventItemID"]intValue]];
            }else{
                 isAdeed = [DBQuery addNonQuedDetails:tick with:[[webinar objectForKey:@"EventItemID"]intValue] withNonQuePlay:false];
            
                if (!isAdeed) {
                   NSLog(@"--");
                   BOOL isCheck = [DBQuery createTableDBForNonQued];
                   if (isCheck) {
                       [DBQuery addNonQuedDetails:tick with:[[webinar objectForKey:@"EventItemID"]intValue] withNonQuePlay:false];
                   }else{
                       [Utility msg:@"DataBase Not Updated" title:@"" controller:self haveToPop:NO];
                   }
               }
            }
}
-(void)addUpdateDBForDropDown:(int)tickIndex{
        BOOL isAdeed = NO;
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        NSString *jsonString = @"";
        if (!(indexValue>=0)) {
            jsonString  = @"";
        }else{
            NSData *postData = [NSJSONSerialization dataWithJSONObject:[addDropdownList objectAtIndex:indexValue] options:NSJSONWritingPrettyPrinted  error:nil];
            jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        }
            if([DBQuery isRowExist:@"dropDownDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' AND EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]]){
                if ([DBQuery checkColumnExists:@"IsDropdownPlay" with:@"dropDownDetails"]) {
                    [DBQuery updateDropdownDetails:tickIndex with:[[webinar objectForKey:@"EventItemID"]intValue] with:jsonString];
                }else{
                    BOOL isAlter = [DBQuery alterTableColumn:@"dropDownDetails" with:@"IsDropdownPlay" With:1];
                    if (isAlter) {
                        [DBQuery updateDropdownDetails:tickIndex with:[[webinar objectForKey:@"EventItemID"]intValue] with:jsonString];
                    }

                }

            }else{
                 isAdeed = [DBQuery addDropdownDetails:tickIndex with:[[webinar objectForKey:@"EventItemID"]intValue] with:jsonString];
            
                if (!isAdeed) {
                   NSLog(@"--");
                   BOOL isCheck = [DBQuery createTableDBForDropdown];
                   if (isCheck) {
                       [DBQuery addDropdownDetails:tickIndex with:[[webinar objectForKey:@"EventItemID"]intValue] with:jsonString];
                   }else{
                       [Utility msg:@"DataBase Not Updated" title:@"" controller:self haveToPop:NO];
                   }
               }
            }
}
-(void)addUpdateDBForGuided:(int)tickIndex{
        BOOL isAdeed = NO;
        int userId = [[defaults objectForKey:@"UserID"] intValue];
            if([DBQuery isRowExist:@"guidedDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' AND EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]]){
                if ([DBQuery checkColumnExists:@"IsGuidedPlaying" with:@"guidedDetails"]) {
                    [DBQuery updateGuidedDetails:tickIndex with:[[webinar objectForKey:@"EventItemID"]intValue]];
                }else{
                    BOOL isAlter = [DBQuery alterTableColumn:@"guidedDetails" with:@"IsGuidedPlaying" With:1];
                    if (isAlter) {
                        [DBQuery updateGuidedDetails:tickIndex with:[[webinar objectForKey:@"EventItemID"]intValue]];
                     }
                }
            }else{
                 isAdeed = [DBQuery addGuidedDetails:tickIndex with:[[webinar objectForKey:@"EventItemID"]intValue]];
            
                if (!isAdeed) {
                   NSLog(@"--");
                   BOOL isCheck = [DBQuery createTableDBForGuided];
                   if (isCheck) {
                       [DBQuery addGuidedDetails:tickIndex with:[[webinar objectForKey:@"EventItemID"]intValue]];
                   }else{
                       [Utility msg:@"DataBase Not Updated" title:@"" controller:self haveToPop:NO];
                   }
               }
            }
}
-(void)addUpdateDBForNonQuedPlaying:(BOOL)isNonQuedPlaying{
    int userId = [[defaults objectForKey:@"UserID"] intValue];
    if([DBQuery isRowExist:@"nonQuedDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' AND EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]]){
         [DBQuery updateNonQuedDetailsForPlayNonQued:isNonQuedPlaying with:[[webinar objectForKey:@"EventItemID"]intValue]];
      }
}
-(void)addUpdateDBForDropDownPlaying:(BOOL)isDropDownPlaying{
    int userId = [[defaults objectForKey:@"UserID"] intValue];
    if([DBQuery isRowExist:@"dropDownDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' AND EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]]){
         [DBQuery updateDropDownDetailsForPlay:isDropDownPlaying with:[[webinar objectForKey:@"EventItemID"]intValue]];
      }
}
-(void)addUpdateDBForGuidedPlaying:(BOOL)isGuidedPlaying{
    int userId = [[defaults objectForKey:@"UserID"] intValue];
    if([DBQuery isRowExist:@"guidedDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' AND EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]]){
     [DBQuery updateGuidedDetailsForPlay:isGuidedPlaying with:[[webinar objectForKey:@"EventItemID"]intValue]];
  }
}
-(void)showFavAlert{
     NSString *str = @"Did you like this meditation? Make it a favourite now so you can find it again quickly.";
        UIAlertController *alertController = [UIAlertController
                                                 alertControllerWithTitle:@""
                                                 message:str
                                                 preferredStyle:UIAlertControllerStyleAlert];
        
           UIAlertAction *okAction = [UIAlertAction
                                      actionWithTitle:@"Ok"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction *action)
                                      {
                                            [self favouriteApiCall];
                                            [self backToWebinarList];
               
//                                            for (UIViewController *controller in self.navigationController.viewControllers) {
//                                                if ([controller isKindOfClass:[WebinarListViewController class]]) {
//                                                    [self.navigationController popToViewController:controller animated:YES];
//                                                    return;
//                                                }
//                                            }
//                                            WebinarListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarListView"];
//                                            [self.navigationController pushViewController:controller animated:YES];
               
                                      }];
           UIAlertAction *cancelAction = [UIAlertAction
                                          actionWithTitle:@"Cancel"
                                          style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction *action)
                                          {
                                                [self backToWebinarList];
                                            
                                          }];
           [alertController addAction:cancelAction];
           [alertController addAction:okAction];
           [self presentViewController:alertController animated:YES completion:nil];
}




-(void)sizeHeaderToFit{
    UIView *headerView = table.tableHeaderView;
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    float height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;
    
    table.tableHeaderView = headerView;
    CGRectGetMaxX(table.frame);
}
-(void)updateView{
    if (_isShowShopping) {
        shopView.hidden = false;
        shopDescStackView.hidden = true;
        shopNowDropButton.selected = false;
    }else{
        shopView.hidden = true;
    }
    testDescStackView.hidden = true;
    testNowDropButton.selected = false;
    doubleArrow.selected = false;
    
    if (![Utility isEmptyCheck:webinar]) {
        if (![Utility isEmptyCheck:[webinar objectForKey:@"ImageUrl"]]) {
            [imgView sd_setImageWithURL:[NSURL URLWithString:[webinar objectForKey:@"ImageUrl"]] placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
                
        }else{
            [imgView setImage:[UIImage imageNamed:@"place_holder1.png"]];
        }
        nonQuedDescriptionView.hidden = true;
        NSString *eventString = [webinar valueForKey:@"EventName"];
        if (![Utility isEmptyCheck:eventString]) {
            eventName.text = eventString;
            eventNameNameVideoView.text =eventString;
        }else{
            eventName.text = @"";
            eventNameNameVideoView.text =@"";
        }
        NSString *imageString =[webinar valueForKey:@"ImageUrl"];
        NSString *presenterString =[webinar valueForKey:@"PresenterName"];
        NSDictionary *presenterDict = [defaults valueForKey:@"presenterDict"];

        if (![Utility isEmptyCheck:imageString]) {
            [eventImage sd_setImageWithURL:[NSURL URLWithString:[imageString stringByAddingPercentEncodingWithAllowedCharacters:
                                                                 [NSCharacterSet URLQueryAllowedCharacterSet]]]
                          placeholderImage:[UIImage imageNamed:@"Photo.png"] options:SDWebImageScaleDownLargeImages];
        }else{
            if (![Utility isEmptyCheck:presenterString] && ![Utility isEmptyCheck:[presenterDict valueForKey:presenterString]]) {
                [eventImage sd_setImageWithURL:[NSURL URLWithString:[[@"" stringByAppendingFormat:@"%@/Images/Presenters/%@",BASEURL,[presenterDict valueForKey:presenterString]] stringByAddingPercentEncodingWithAllowedCharacters:
                                                                             [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                      placeholderImage:[UIImage imageNamed:@"Photo.png"] options:SDWebImageScaleDownLargeImages];
            }else{
                eventImage.image = [UIImage imageNamed:@"Photo.png"];
            }
        }
        
        if ([presenterString isEqualToString:@" "]) {
            presenterName.text = @"";
            presenterNameVideoView.text = @"";
            moreFromPresenterLabel.text =@"No more events found.";
        }else if (![Utility isEmptyCheck:presenterString]) {
            presenterName.text = presenterString;
            presenterNameVideoView.text = presenterString;
            moreFromPresenterLabel.text =[@"MORE FROM " stringByAppendingString:[presenterString uppercaseString]];
        }else{
            presenterName.text = @"";
            presenterNameVideoView.text = @"";
            moreFromPresenterLabel.text =@"No more events found.";
        }
//        NSString *descriptionString =[webinar valueForKey:@"Content"];
//        if (![Utility isEmptyCheck:descriptionString]) {
//            descriptionString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: %@\";>%@</span>", eventDetail.font.fontName, eventDetail.font.pointSize,[Utility hexStringFromColor:eventDetail.textColor], descriptionString];
//
//            NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[descriptionString dataUsingEncoding:NSUTF8StringEncoding]
//                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
//                                                                                           }
//                                                                      documentAttributes:nil error:nil];
//
//            eventDetail.attributedText = strAttributed;
//        }else{
//            eventDetail.text = @"";
//        }
        
        eventLikeDislike.selected = [[webinar valueForKey:@"Likes"] boolValue];
        NSString *likeCountString = [[webinar valueForKey:@"LikeCount"] stringValue];
        if (![Utility isEmptyCheck:likeCountString]) {
            eventLikeCount.text = likeCountString;
        }
        NSArray *eventItemVideoDetailsArray = [webinar valueForKey:@"EventItemVideoDetails"];
        if (upcomingWebinarsData && [[upcomingWebinarsData objectForKey:@"EventItemID"] isEqual: [webinar objectForKey:@"EventItemID"]] ){
            eventItemVideoDetailsArray = [upcomingWebinarsData valueForKey:@"EventItemVideoDetails"];
        }
        if (eventItemVideoDetailsArray.count > 0) {
            NSDictionary *eventItemVideoDetails = [eventItemVideoDetailsArray objectAtIndex:0];
            if (![Utility isEmptyCheck:eventItemVideoDetails]) {
                eventWatchListButton.selected =  [[eventItemVideoDetails objectForKey:@"IsWatchListVideo"] boolValue];
            }
            if (![Utility isEmptyCheck:[eventItemVideoDetails objectForKey:@"DownloadURL" ]]) {
                NSURL *video_url = [NSURL URLWithString:[eventItemVideoDetails objectForKey:@"DownloadURL" ]];
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[video_url lastPathComponent]];
                if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
//                    [eventDownloadButton setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];
                    [self addUpdateDB];
                }else{
//                    [eventDownloadButton setImage:[UIImage imageNamed:@"w_download.png"] forState:UIControlStateNormal];
                    [self download:webinar sender:eventDownloadButton];
                }
                eventDownloadButton.hidden = true;
            }else{
                eventDownloadButton.hidden = true;
                eventDownloadButtonConstraint.constant = 0;
            }
            if (![Utility isEmptyCheck:[webinar objectForKey:@"NoCueUrl"]]) {
                 NSURL *video_url = [NSURL URLWithString:[webinar objectForKey:@"NoCueUrl"]];
                 NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                 NSString* documentsDirectory = [paths objectAtIndex:0];
                 NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[video_url lastPathComponent]];
                 if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
//                     [self addUpdateDB];
                 }else{
                     [self downloadNonQued:[webinar objectForKey:@"NoCueUrl"] sender:eventDownloadButton];
                 }
            }
            
            //-----------
            if (![Utility isEmptyCheck:[webinar objectForKey:@"Guided1Url"]]) {
                NSURL *video_url = [NSURL URLWithString:[webinar objectForKey:@"Guided1Url"]];
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[video_url lastPathComponent]];
                if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                                 
                }else{
                    [self downloadNonQued:[webinar objectForKey:@"Guided1Url"] sender:eventDownloadButton];
                }
            }
            
            if (![Utility isEmptyCheck:[webinar objectForKey:@"Guided2Url"]]) {
                NSURL *video_url = [NSURL URLWithString:[webinar objectForKey:@"Guided2Url"]];
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[video_url lastPathComponent]];
                if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                                 
                }else{
                    [self downloadNonQued:[webinar objectForKey:@"Guided2Url"] sender:eventDownloadButton];
                }
            }
            
            if (![Utility isEmptyCheck:[webinar objectForKey:@"Guided3Url"]]) {
                NSURL *video_url = [NSURL URLWithString:[webinar objectForKey:@"Guided3Url"]];
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[video_url lastPathComponent]];
                if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                                 
                }else{
                    [self downloadNonQued:[webinar objectForKey:@"Guided3Url"] sender:eventDownloadButton];
                }
            }
            
            if (![Utility isEmptyCheck:[webinar objectForKey:@"Guided4Url"]]) {
                NSURL *video_url = [NSURL URLWithString:[webinar objectForKey:@"Guided4Url"]];
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[video_url lastPathComponent]];
                if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                                 
                }else{
                    [self downloadNonQued:[webinar objectForKey:@"Guided4Url"] sender:eventDownloadButton];
                }
            }
            
            if (![Utility isEmptyCheck:[webinar objectForKey:@"Guided5Url"]]) {
                NSURL *video_url = [NSURL URLWithString:[webinar objectForKey:@"Guided5Url"]];
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[video_url lastPathComponent]];
                if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                                 
                }else{
                    [self downloadNonQued:[webinar objectForKey:@"Guided5Url"] sender:eventDownloadButton];
                }
            }
            //-----------
            
            
            
            NSString *urlString = [eventItemVideoDetails objectForKey:@"PodcastURL" ];
            if (![Utility isEmptyCheck:urlString]) {
                eventPodcastButton.hidden = false;
            }else{
                eventPodcastButton.hidden = true;
            }
            if (![Utility isEmptyCheck:[eventItemVideoDetails objectForKey:@"EventItemVideoID"]]) {
                eventWatchListButton.hidden = false;
            }else{
                eventWatchListButton.hidden = true;
                eventWatchListButtonConstraint.constant = 0;
            }
        }else{
            eventDownloadButton.hidden = true;
            eventDownloadButtonConstraint.constant = 0;
            eventWatchListButton.hidden = true;
            eventWatchListButtonConstraint.constant = 0;
        }

        
        
        // Foe attachment section ---
        for (UIView * subView in attachmentStackView.arrangedSubviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                [attachmentStackView removeArrangedSubview:subView];
                [subView removeFromSuperview];
            }
        }
        NSArray *attachmentArray = [webinar objectForKey:@"Attachments"];
        if (attachmentArray.count > 0) {
            eventAttachmentButton.hidden = false;
            for (int i = 0; i < attachmentArray.count; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self action:@selector(attachmentTapped:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:[NSString stringWithFormat:@"ATTACHMENT %d",i+1] forState:UIControlStateNormal];
                [button setTag:i];
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                button.titleLabel.font = [UIFont fontWithName:@"Raleway-Semibold" size:17.0];
                button.backgroundColor = UIColor.whiteColor;
                [button setTitleColor:[UIColor colorWithRed:50/255.0f green:205/255.0f blue:184/255.0f alpha:1.0f] forState:UIControlStateNormal];
                button.frame = CGRectMake(0, 0, attachmentStackView.frame.size.width, 50.0);
                [button setTitleEdgeInsets: UIEdgeInsetsMake(0, 10, 0, 10)];
                button.clipsToBounds = YES;
                button.layer.borderWidth = 1;
                button.layer.borderColor = [UIColor colorWithRed:50/255.0f green:205/255.0f blue:184/255.0f alpha:1.0f].CGColor;
                button.layer.cornerRadius = 18.0;
                [attachmentStackView addArrangedSubview:button];
            }
        } else {
            eventAttachmentButton.hidden = true;
        }
        
        NSArray *tags = [webinar objectForKey:@"Tags"];
        
        int curLevel = [[webinar objectForKey:@"Level"] intValue];
        
        [self attDescLabel:curLevel];
       
        
            if([tags containsObject:@"Visualisations"] || [tags containsObject:@"Healing Meditations"]){
                nonHealingDescView.hidden = true;
                testNowView.hidden = true;
            }else{
                nonHealingDescView.hidden = false;
                testNowView.hidden = false;
            }
           testNowView.hidden = true;
           shopView.hidden = true;
//        [self doubleDropDownPressed:nil];
    
    CMTime startTime = appDelegate.playerController.player.currentTime;
    double time = CMTimeGetSeconds(startTime);
    appDelegate.playerController.player = nil;
    [appDelegate.playerController willMoveToParentViewController:nil];
    [appDelegate.playerController.view removeFromSuperview];
    [appDelegate.playerController removeFromParentViewController];
    
    [appDelegate.FBWAudioPlayer pause];
    appDelegate.FBWAudioPlayer = nil;
    //Video
    tapCount = 0;
    //[self showVolume];
    // grab an URL to our video
    // progress bar
    progressBar.value = 0.0;
    progressVisualSlider.value = 0.0;
    double interval = .1f;
        
      
   if (![Utility isEmptyCheck:[webinar objectForKey:@"NoCueUrl"]]){
       nonQuedView.hidden = false;
       nonQueDropdownButton.hidden = false;
       questionButton.hidden = true;
       [self setGuidedView];
    }else{
        nonQuedView.hidden = true;
        nonQueDropdownButton.hidden = true;
        questionButton.hidden = true;
    }

//    NSString *appUrl = @"https://player.vimeo.com/external/360033920.m3u8?s=323ac0dd1cb7d9a392b86387cd25b0618b3f066f";
    int userId = [[defaults objectForKey:@"UserID"] intValue];
//    if([DBQuery isRowExist:@"nonQuedDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d' and IsNonQuedPlaying ='%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue],1]] && ![Utility isEmptyCheck:[defaults objectForKey:@"PlayingMeditation"]] && ![Utility isEmptyCheck:[defaults objectForKey:@"RunningVideoSection"]]){
//             checkedNonQuedButton.selected = true;
//           dispatch_async(dispatch_get_main_queue(), ^{
//               self->progressBarView.hidden = NO;
//               self->mainView.hidden = YES;
//               self->eventDownloadButton.hidden = YES;
//               self->playStackView.hidden = NO;
//               [self playNonQued];
//               for (UIButton *btn in self->guidedCheckButtonArray) {
//                   btn.selected = false;
//               }
//           });
//    }else
        if([DBQuery isRowExist:@"guidedDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]] && isCheck){
        
            checkedNonQuedButton.selected = false;
            DAOReader *dbObject = [DAOReader sharedInstance];
            if([dbObject connectionStart]){
                NSArray *guidedArr = [dbObject selectBy:@"guidedDetails" withColumn:[[NSArray alloc]initWithObjects:@"GuidedIndex",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]];
                if (guidedArr.count>0) {
                    indexGuided = [[[guidedArr objectAtIndex:0]objectForKey:@"GuidedIndex"]intValue];
                }
                
            }
        for (UIButton *btn in guidedCheckButtonArray) {
            if (btn.tag == indexGuided) {
                btn.selected = true;
            }else{
                btn.selected = false;
            }
        }
            if (indexGuided>=0) {
                nonQueDropdownButton.userInteractionEnabled=false;
                nonQueDropdownButton.alpha = 0.5;
                [self nonQueDropdownPressed:nil];
            }else if([DBQuery isRowExist:@"dropDownDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]]){
                DAOReader *dbObject = [DAOReader sharedInstance];
                if([dbObject connectionStart]){
                   NSArray *dropdownArr = [dbObject selectBy:@"dropDownDetails" withColumn:[[NSArray alloc]initWithObjects:@"DropDownIndex",@"DataDict",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]];
                            if (dropdownArr.count>0) {
                                checkedNonQuedButton.selected = false;
                                for (UIButton *btn in guidedCheckButtonArray) {
                                        btn.selected = false;
                                }
                                indexValue = [[[dropdownArr objectAtIndex:0]objectForKey:@"DropDownIndex"]intValue];
                                if (indexValue>=0) {
                                isDefaultSelect = true;
                                NSData* data = [[[dropdownArr objectAtIndex:0]objectForKey:@"DataDict"] dataUsingEncoding:NSUTF8StringEncoding];
                                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                if (![Utility isEmptyCheck:responseDictionary]) {
                                    [addDropdownList addObject:responseDictionary];
                                }
                                serachView.hidden = false;
                                searchTableSuperView.hidden = false;
                                [searchTableView reloadData];
                        }else{
                              nonQueDropdownButton.userInteractionEnabled = true;
                              nonQueDropdownButton.alpha = 1;
                               UIButton *btn = [[UIButton alloc]init];
                               btn.selected = false;
                              [self checkUncheckNonQuedPressed:btn];
                        }
                }else{
                    nonQueDropdownButton.userInteractionEnabled = true;
                    nonQueDropdownButton.alpha = 1;
                    UIButton *btn = [[UIButton alloc]init];
                    btn.selected = false;
                    [self checkUncheckNonQuedPressed:btn];
                 }
                
            }
        }
        
    }else if([DBQuery isRowExist:@"nonQuedDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d' and NonQuedValue ='%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue],1]]){
            checkedNonQuedButton.selected = true;
            for (UIButton *btn in guidedCheckButtonArray) {
                   btn.selected = false;
                }

    }else if([DBQuery isRowExist:@"dropDownDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]]){
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            NSArray *dropdownArr = [dbObject selectBy:@"dropDownDetails" withColumn:[[NSArray alloc]initWithObjects:@"DropDownIndex",@"DataDict",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]];
            if (dropdownArr.count>0) {
                checkedNonQuedButton.selected = false;
                for (UIButton *btn in guidedCheckButtonArray) {
                        btn.selected = false;
                }
                indexValue = [[[dropdownArr objectAtIndex:0]objectForKey:@"DropDownIndex"]intValue];
                if (indexValue>=0) {
                isDefaultSelect = true;
                NSData* data = [[[dropdownArr objectAtIndex:0]objectForKey:@"DataDict"] dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (![Utility isEmptyCheck:responseDictionary]) {
                    [addDropdownList addObject:responseDictionary];
                }
                serachView.hidden = false;
                searchTableSuperView.hidden = false;
                [searchTableView reloadData];
        }else{
              nonQueDropdownButton.userInteractionEnabled = true;
              nonQueDropdownButton.alpha = 1;
               UIButton *btn = [[UIButton alloc]init];
               btn.selected = false;
              [self checkUncheckNonQuedPressed:btn];
            }
          }else{
             nonQueDropdownButton.userInteractionEnabled = true;
             nonQueDropdownButton.alpha = 1;
             UIButton *btn = [[UIButton alloc]init];
             btn.selected = false;
             [self checkUncheckNonQuedPressed:btn];
          }
        }
    }else{
//            checkedNonQuedButton.selected = false;
             UIButton *btn = [[UIButton alloc]init];
             btn.selected = false;
             [self checkUncheckNonQuedPressed:btn];
         }
    
    
        NSString *appUrl = @"";
        NSArray *videoUrls = [webinar objectForKey:@"EventItemVideoDetails"];
    
    if (![Utility isEmptyCheck:videoUrls] && videoUrls.count > 0) {
        NSDictionary *appUrlDict =[videoUrls objectAtIndex:0];
        if (![Utility isEmptyCheck:[appUrlDict objectForKey:@"AppURL"]] ) {
            
            if ([[defaults objectForKey:@"RunningVideoSection"] isEqualToString:@"Meditation"]){
                    videoStartTime=time;
            }else{
                if (![Utility isEmptyCheck:[appUrlDict objectForKey:@"Time"]]) {
                    videoStartTime = [[appUrlDict objectForKey:@"Time"] doubleValue];
                }else{
                    videoStartTime=0;
                }
            }
            progressBarView.hidden = NO;
            mainView.hidden = YES;
            eventDownloadButton.hidden = YES;
            playStackView.hidden = NO;
            appUrl =[appUrlDict objectForKey:@"AppURL"];//
//            appUrl = @"https://api.soundcloud.com/tracks/289807820/stream?client_id=82649c2cccfd457641a40c7e952c1ce8";
//            appUrl=@"https://player.vimeo.com/external/360033920.m3u8?s=323ac0dd1cb7d9a392b86387cd25b0618b3f066f";
//            if ([Utility isEmptyCheck:appUrl]) {
//                appUrl = [appUrl stringByAddingPercentEncodingWithAllowedCharacters:
//                          [NSCharacterSet URLQueryAllowedCharacterSet]];
//            }
            
            NSURL *videoURL = [NSURL URLWithString:appUrl];
            
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* documentsDirectory = [paths objectAtIndex:0];
            NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[videoURL lastPathComponent]];
            NSLog(@"fullPathToFile=%@",fullPathToFile);

            if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                videoURL = [NSURL fileURLWithPath:fullPathToFile];
            }
            
            
            [appDelegate.playerController.player pause];
            [appDelegate.FBWAudioPlayer pause];
            appDelegate.FBWAudioPlayer = nil;
            [appDelegate.playerController removeFromParentViewController];
            // create an AVPlayer
            appDelegate.FBWAudioPlayer =  [[AVPlayer alloc] initWithURL:videoURL];
            UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
            [clearView addGestureRecognizer:singleTapGestureRecognizer];
            
            
            
            if (appDelegate.FBWAudioPlayer) {
                // create a player view controller
                appDelegate.playerController = [[AVPlayerViewController alloc]init];
                appDelegate.playerController.player = appDelegate.FBWAudioPlayer;
                appDelegate.playerController.showsPlaybackControls = true;//false chilo
                [appDelegate.FBWAudioPlayer play];
                [visualizer setAudioPlayer:_audioPlayer];
                // show the view controller
                [self addChildViewController:appDelegate.playerController];
                [mainView addSubview:appDelegate.playerController.view];
                [mainView bringSubviewToFront:fullScreenButton];
                [appDelegate setUpRemoteControl];
                appDelegate.playerController.view.frame = mainView.bounds;
                
               appDelegate.playerController.player.automaticallyWaitsToMinimizeStalling = NO;

                
                if([[self->appDelegate.playerController.player.currentItem.asset tracksWithMediaType:AVMediaTypeVideo] count] != 0){
                    mainView.hidden = false;
                    soundCloudAudioView.hidden = true;
                }else{
                   mainView.hidden = true;
                   soundCloudAudioView.hidden = true;
                    if([videoURL isFileURL]){
//                       soundCloudAudioView.hidden = false;
                       [self initAudioVisualizer];
                               NSData *data = [NSData dataWithContentsOfURL:videoURL];
                               NSError *error;
                               
                               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                                   if([Utility isEmptyCheck:self->_audioPlayer]){
                                       self->_audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
                                       [self->_audioPlayer setMeteringEnabled:YES];
//                                   }
                                   if (error)
                                   {
                                       NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
                                   }
                                   else
                                   {
                                        self->_audioPlayer.delegate = self;
                                        [self->_audioPlayer prepareToPlay];
                                        [self->_audioPlayer setVolume:0];
                                   }
                               }) ;
                    }
                }
               
                [self playPause:playPauseButton];
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
                    if(_audioPlayer){
                       [self startAudioVisualizer];
                    }
                     
                    [appDelegate.FBWAudioPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                         queue:NULL
                                                    usingBlock:
                     ^(CMTime time)
                     {
                        [weakSelf syncScrubber];
                         
                     }];
                }
                
                
      //------------- Pause at entry
                if([DBQuery isRowExist:@"nonQuedDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d' and IsNonQuedPlaying ='%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue],1]]){
                    videoStartTime = 0;
                }
                else if([DBQuery isRowExist:@"dropDownDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d' and IsDropdownPlay = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue],1]]){                 videoStartTime = 0;
                    
                }else if([DBQuery isRowExist:@"guidedDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d' and IsGuidedPlaying = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue],1]]){
                    videoStartTime = 0;
                }
                if (![[defaults objectForKey:@"RunningVideoSection"] isEqualToString:@"Meditation"]){
                        if (self->videoStartTime) {
                            CMTime playerDuration = self->appDelegate.playerController.player.currentItem.asset.duration;
                            double maxDuration = CMTimeGetSeconds(playerDuration);

                        //                double currentTime = [[NSString stringWithFormat:@"%@",[self->dataDict objectForKey:@"Time"]]doubleValue];
                            double currentTime = self->videoStartTime;
                            double audioPlaytime = self->videoStartTime;

                            if (currentTime > maxDuration) {
                                CMTime startTime = CMTimeMake(0, self->appDelegate.playerController.player.currentTime.timescale);
                                [self->appDelegate.playerController.player seekToTime:startTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                                    [self->appDelegate.playerController.player pause];
                                }];
                            audioPlaytime = 0;
                            }else{
                                CMTime startTime = CMTimeMake(currentTime, 1);
                        //                    int s=self->appDelegate.playerController.player.currentTime.timescale;
                                            //self->appDelegate.playerController.player.currentTime.timescale
                                [self->appDelegate.playerController.player seekToTime:startTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                                    [self->appDelegate.playerController.player pause];
                                }];
                            }

                            if(self->_audioPlayer){
                                [self->_audioPlayer setCurrentTime:audioPlaytime];
                            }
                        }else{
                            [self->appDelegate.playerController.player pause];
                        }
                }

        //------------- Pause at entry
            }
         
        }
        else{
            progressBarView.hidden = YES;
            mainView.hidden = YES;
            eventDownloadButton.hidden = YES;
            playStackView.hidden = YES;
//            soundCloudAudioView.hidden = true;
        }
    }else{
        progressBarView.hidden = YES;
        mainView.hidden = YES;
        eventDownloadButton.hidden = YES;
        playStackView.hidden = YES;
//        soundCloudAudioView.hidden = true;
        }
      }
    }

-(void)playNonQued{
    double interval = .1f;
    NSURL *videoURL;
    if (checkedNonQuedButton.isSelected && ![Utility isEmptyCheck:[self->webinar objectForKey:@"NoCueUrl"]]) {
        videoURL = [NSURL URLWithString:[self->webinar objectForKey:@"NoCueUrl"]];
        [self addUpdateDBForNonQuedPlaying:true];

    }else if(indexValue>=0){
        NSDictionary *dict = [addDropdownList objectAtIndex:indexValue];
        NSDictionary *eventItemVideoDetailsDict = [[dict objectForKey:@"EventItemVideoDetails"]objectAtIndex:0];
        videoURL = [NSURL URLWithString:[eventItemVideoDetailsDict objectForKey:@"VideoURL"]];
        [self addUpdateDBForDropDownPlaying:true];
    }else{
         [self addUpdateDBForGuidedPlaying:true];
        for (UIButton *btn in guidedCheckButtonArray) {
            if (btn.isSelected) {
                if (btn.tag==0 &&  ![Utility isEmptyCheck:webinar[@"Guided1Url"]]) {
                    videoURL = [NSURL URLWithString:[self->webinar objectForKey:@"Guided1Url"]];
                }else if (btn.tag==1 &&  ![Utility isEmptyCheck:webinar[@"Guided2Url"]]){
                    videoURL = [NSURL URLWithString:[self->webinar objectForKey:@"Guided2Url"]];
                }else if (btn.tag==2 &&  ![Utility isEmptyCheck:webinar[@"Guided3Url"]]){
                    videoURL = [NSURL URLWithString:[self->webinar objectForKey:@"Guided3Url"]];
                }else if (btn.tag==3 &&  ![Utility isEmptyCheck:webinar[@"Guided4Url"]]){
                    videoURL = [NSURL URLWithString:[self->webinar objectForKey:@"Guided4Url"]];
                }else if (btn.tag==4 &&  ![Utility isEmptyCheck:webinar[@"Guided5Url"]]){
                    videoURL = [NSURL URLWithString:[self->webinar objectForKey:@"Guided5Url"]];
                }
            }
        }
    }
    
          if (![Utility isEmptyCheck:videoURL]) {
               
               NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
               NSString* documentsDirectory = [paths objectAtIndex:0];
               NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[videoURL lastPathComponent]];
               NSLog(@"fullPathToFile=%@",fullPathToFile);

               if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                   videoURL = [NSURL fileURLWithPath:fullPathToFile];
               }
               
             [self->appDelegate.playerController.player pause];
             [self->appDelegate.FBWAudioPlayer pause];
             self->appDelegate.FBWAudioPlayer = nil;
             [self->appDelegate.playerController removeFromParentViewController];
                  // create an AVPlayer
             self->appDelegate.FBWAudioPlayer =  [[AVPlayer alloc] initWithURL:videoURL];
                  UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
             [self->clearView addGestureRecognizer:singleTapGestureRecognizer];
              
             if (self->appDelegate.FBWAudioPlayer) {
                  // create a player view controller
                 self->appDelegate.playerController = [[AVPlayerViewController alloc]init];
                 self->appDelegate.playerController.player = self->appDelegate.FBWAudioPlayer;
                 self->appDelegate.playerController.showsPlaybackControls = true;//false chillo
                 
                 [self->appDelegate.FBWAudioPlayer play];
                  // show the view controller
                 [self addChildViewController:self->appDelegate.playerController];
                 [self->mainView addSubview:self->appDelegate.playerController.view];
                 [self->mainView bringSubviewToFront:self->fullScreenButton];
                 [self->appDelegate setUpRemoteControl];
                 self->appDelegate.playerController.view.frame = self->mainView.bounds;
                  
                 appDelegate.playerController.player.automaticallyWaitsToMinimizeStalling = NO;
                 
                  if([[self->appDelegate.playerController.player.currentItem.asset tracksWithMediaType:AVMediaTypeVideo] count] != 0){
                      self->mainView.hidden = false;
                      self->soundCloudAudioView.hidden = true;
                  }else{
                      self->mainView.hidden = true;
                      self->soundCloudAudioView.hidden = true;
                      if([videoURL isFileURL]){
//                          self->soundCloudAudioView.hidden = false;
                          [self initAudioVisualizer];
                                 NSData *data = [NSData dataWithContentsOfURL:videoURL];
                                 NSError *error;

                                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                                     if ([Utility isEmptyCheck:self->_audioPlayer]) {
                                         self->_audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
                                         [self->_audioPlayer setMeteringEnabled:YES];
//                                     }
                                     if (error)
                                     {
                                         NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
                                     }
                                     else
                                     {
                                          self->_audioPlayer.delegate = self;
                                          [self->_audioPlayer prepareToPlay];
                                          [self->_audioPlayer setVolume:0];
                                     }
                                 }) ;
                      }
                  }
                 playPauseButton.selected = false;
                 [self playPause:self->playPauseButton];
                 CMTime playerDuration = self->appDelegate.FBWAudioPlayer.currentItem.duration; // return player duration.
                  if (CMTIME_IS_INVALID(playerDuration))
                  {
                      return;
                  }
                  double duration = CMTimeGetSeconds(playerDuration);
                  if (isfinite(duration))
                  {
                      CGFloat width = CGRectGetWidth([self->progressBar bounds]);
                      interval = 0.5f * duration / width;
                  }
                  __weak typeof(self) weakSelf = self;
                   //Update the scrubber during normal playback.
                  if (interval > 0) {
                      if(self->_audioPlayer){
                         [self startAudioVisualizer];
                      }

                      [self->appDelegate.FBWAudioPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                           queue:NULL
                                                      usingBlock:
                       ^(CMTime time)
                       {
                          [weakSelf syncScrubber];

                       }];
                  }
                  
                  
       // ------------- Pause at entry
                  if (![[defaults objectForKey:@"RunningVideoSection"] isEqualToString:@"Meditation"]){
                          if (self->videoStartTime) {
                              CMTime playerDuration = self->appDelegate.playerController.player.currentItem.asset.duration;
                              double maxDuration = CMTimeGetSeconds(playerDuration);

                          //                double currentTime = [[NSString stringWithFormat:@"%@",[self->dataDict objectForKey:@"Time"]]doubleValue];
                              double currentTime = self->videoStartTime;
                              double audioPlaytime = self->videoStartTime;

                              if (currentTime > maxDuration) {
                                  CMTime startTime = CMTimeMake(0, self->appDelegate.playerController.player.currentTime.timescale);
                                  [self->appDelegate.playerController.player seekToTime:startTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                                      [self->appDelegate.playerController.player pause];
                                  }];
                              audioPlaytime = 0;
                              }else{
                                  CMTime startTime = CMTimeMake(currentTime, 1);
                          //                    int s=self->appDelegate.playerController.player.currentTime.timescale;
                                              //self->appDelegate.playerController.player.currentTime.timescale
                                  [self->appDelegate.playerController.player seekToTime:startTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                                      [self->appDelegate.playerController.player pause];
                                  }];
                              }

                              if(self->_audioPlayer){
                                  [self->_audioPlayer setCurrentTime:audioPlaytime];
                              }
                          }else{
                              [self->appDelegate.playerController.player pause];
                          }
                  }

         // ------------- Pause at entry
                  
                  
                }
      
            }
}
-(void)attDescLabel:(int)curLabel{
    NSDictionary *attrDict = @{
    NSFontAttributeName : [UIFont fontWithName:@"Raleway-Bold" size:16.0],
    NSForegroundColorAttributeName : [Utility colorWithHexString:@"8F8F8F"],
    };
    NSString *detailsStr =@"";
    if (curLabel == 1 || curLabel == 2) {
        detailsStr = @"If the breath cues in this track feel too fast and you would like to breathe slower, please try level";
    }else if (curLabel == 6){
        detailsStr = @"Don't have 'feels to fast' \n But if it feels too slow, go to level 5.";
    }
    NSMutableAttributedString *myString;
//     if (curLabel == 1 || curLabel == 2) {
//         myString= [[NSMutableAttributedString alloc] initWithString:[@"" stringByAppendingFormat:@"This is a level %d meditation.\n\n%@ %d.",curLabel,detailsStr,curLabel+1]];
//     }else if(curLabel == 6){
//         myString= [[NSMutableAttributedString alloc] initWithString:[@"" stringByAppendingFormat:@"This is a level %d meditation.\n\n%@ .",curLabel,detailsStr]];
//
//     }else{
//         myString= [[NSMutableAttributedString alloc] initWithString:[@"" stringByAppendingFormat:@"This is a level %d meditation.",curLabel]];
//
//     }
     myString= [[NSMutableAttributedString alloc] initWithString:[@"" stringByAppendingFormat:@"This is a level %d meditation.",curLabel]];

    [myString addAttributes:attrDict range:NSMakeRange(0,myString.length)];
    

    nonHealingLabel.attributedText = myString;
//    nonHealingLabel.hidden = true;
}
-(void)setIsViewedServiceCall{
    if (Utility.reachable) {
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinar valueForKey:@"EventItemVideoDetails"]];
        if (eventItemVideoDetailsArray.count > 0) {
            NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
            if (![Utility isEmptyCheck:eventItemVideoDetails] && ![Utility isEmptyCheck:[eventItemVideoDetails objectForKey:@"EventItemVideoID"]]) {
                NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
                [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserId"];
                [mainDict setObject:AccessKey forKey:@"Key"];
                [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
                [mainDict setObject:[eventItemVideoDetails objectForKey:@"EventItemVideoID"] forKey:@"EventItemVideoID"];
                
                NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:0  error:&error];
                if (error) {
                    [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                    return;
                }
                NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
                
                NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SaveViewVideoStatusApiCall" append:@"" forAction:@"POST"];
                NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         if (contentView) {
                                                                             [contentView removeFromSuperview];
                                                                         }
                                                                         if(error == nil)
                                                                         {
                                                                             NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                             
                                                                             NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                             if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Status"] boolValue]) {
                                                                                 NSLog(@"%@",responseDict);
                                                                             }else{
                                                                                 [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                                 return;
                                                                             }
                                                                         }else{
                                                                             [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                         }
                                                                     });
                                                                 }];
                [dataTask resume];
            }
        }

    }else{
       // [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
    }
}

-(void)getWebinarDetails:(NSString *)presenterNameString{
    if (Utility.reachable) {
        
        NSArray *presenterArray = [defaults objectForKey:@"PresenterList"];
        NSString *presenterId = @"0";
        for (NSDictionary *dict in presenterArray) {
            if (![Utility isEmptyCheck:presenterNameString] && ![Utility isEmptyCheck:[dict valueForKey:@"EventName"]] && [presenterNameString isEqualToString:[dict valueForKey:@"EventName"]]) {
                presenterId =[[dict valueForKey:@"EventID"] stringValue];
                break;
            }
        }
        if (![Utility isEmptyCheck:presenterArray] && ![presenterId isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (contentView) {
                    [contentView removeFromSuperview];
                }
                contentView = [Utility activityIndicatorView:self];
            });
            
            NSURLSession *loginSession = [NSURLSession sharedSession];
            NSError *error;
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            [mainDict setObject:presenterId forKey:@"PresenterID"];
            [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
            [mainDict setObject:AccessKey forKey:@"Key"];
            [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
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
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                             webinarsOfPresenter = [[NSMutableArray alloc]initWithArray:[responseDictionary valueForKey:@"Webinars"]];
                                                                             if (![Utility isEmptyCheck:webinarsOfPresenter] && ![Utility isEmptyCheck:webinarsOfPresenter]) {
                                                                                 if ([webinarsOfPresenter containsObject:webinar]) {
                                                                                     selectedIndex = [webinarsOfPresenter indexOfObject:webinar];
                                                                                 }else{
                                                                                     selectedIndex = 0;
                                                                                 }
                                                                                 if (selectedIndex==0) {
                                                                                     previousButton.enabled=false;
                                                                                 }else{
                                                                                     previousButton.enabled=true;
                                                                                 }
                                                                                 if (selectedIndex==webinarsOfPresenter.count-1) {
                                                                                     nextButton.enabled=false;
                                                                                 }else{
                                                                                     nextButton.enabled=true;
                                                                                 }
                                                                                 [webinarsOfPresenter removeObject:webinar];
//                                                                                 [table reloadData];
                                                                                 [self updateView];
                                                                             }else{
                                                                                 webinarsOfPresenter = [[NSMutableArray alloc]init];
                                                                                 [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:YES];
                                                                                 return;
                                                                             }
                                                                             
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
        }

        
    }else{
      //  [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
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
                    [self addUpdateDB];
                  /*  if (appDelegate.FBWAudioPlayer) {
                        [appDelegate.FBWAudioPlayer pause];
                    }
                    if (playerForDownloadedVideo) {
                        [playerForDownloadedVideo pause];
                        playerForDownloadedVideo = nil;
                    }
                    NSURL    *fileURL = [NSURL fileURLWithPath:fullPathToFile];
                    playerForDownloadedVideo = [AVPlayer playerWithURL:fileURL];
                    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
                    [self presentViewController:controller animated:YES completion:nil];
                    controller.view.frame = self.view.frame;
                    controller.player = playerForDownloadedVideo;
                    controller.showsPlaybackControls = YES;
                    [playerForDownloadedVideo play];*/
                    return;
                }
                /*[Utility msg:@"This video have started downloading , will be available for playing locally" title:@"Alert" controller:self haveToPop:NO];
                [UIView animateWithDuration:0.3/1 animations:^{
                    sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.7, 1.7);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3/1.5 animations:^{
                        sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                        //[sender setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:0.1]];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.3/1.5 animations:^{
                            sender.transform = CGAffineTransformIdentity;
                            [sender setBackgroundColor:[UIColor clearColor]];
                            
                        }];
                    }];
                }];*/
                if(Utility.reachable){
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        sender.enabled = false;
                        if ([sender isEqual:eventDownloadButton]) {
                            eventDownloadTask = [self.session1 downloadTaskWithURL:sourceURL];
                            eventProgress.hidden = false;
                            [eventDownloadTask resume];
                        }else{
                            CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:table];
                            NSIndexPath *indexPath = [table indexPathForRowAtPoint:buttonPosition];
                            WebinarSelectedTableViewCell *cell = (WebinarSelectedTableViewCell *)[table cellForRowAtIndexPath:indexPath];
                            cell.downloadTask = [self.session downloadTaskWithURL:sourceURL];
                            cell.progress.hidden = false;
                            [backgroundDownloadDict setObject:cell forKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)cell.downloadTask.taskIdentifier]];
                            [indexPathAndTaskDict setObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)cell.downloadTask.taskIdentifier] forKey:[@"" stringByAppendingFormat:@"%ld",(long)sender.tag]];
                            [cell.downloadTask resume];
                        }
                }];
                }else{
                   // [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
                }
            }
        }
    }
}
//-(void)downloadNonQued:(NSDictionary *)webinarsData sender:(UIButton *)sender
-(void)downloadNonQued:(NSString *)urlString sender:(UIButton *)sender{
            if (![Utility isEmptyCheck:urlString]) {
                NSURL *video_url = [NSURL URLWithString:urlString];
                
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
//                    [self addUpdateDB];
                }
                if(Utility.reachable){
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        sender.enabled = false;
                        if ([sender isEqual:self->eventDownloadButton]) {
                            self->eventDownloadTask = [self.session2 downloadTaskWithURL:sourceURL];
                            self->eventProgress.hidden = false;
                            [self->eventDownloadTask resume];
                        }else{
                            CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self->table];
                            NSIndexPath *indexPath = [self->table indexPathForRowAtPoint:buttonPosition];
                            WebinarSelectedTableViewCell *cell = (WebinarSelectedTableViewCell *)[self->table cellForRowAtIndexPath:indexPath];
                            cell.downloadTask = [self.session2 downloadTaskWithURL:sourceURL];
                            cell.progress.hidden = false;
                            [self->backgroundDownloadDict setObject:cell forKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)cell.downloadTask.taskIdentifier]];
                            [self->indexPathAndTaskDict setObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)cell.downloadTask.taskIdentifier] forKey:[@"" stringByAppendingFormat:@"%ld",(long)sender.tag]];
                            [cell.downloadTask resume];
                        }
                }];
                }else{
                   // [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
                }
            }
    }


-(void)likeDislike:(NSMutableDictionary *)webinarsData sender:(UIButton *)sender{
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    if (Utility.reachable) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            if (contentView) {
        //                [contentView removeFromSuperview];
        //            }
        //            contentView = [Utility activityIndicatorView:self];
        //        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[webinarsData valueForKey:@"EventItemID"] forKey:@"EventID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:0  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleEventLikeApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [Utility isEmptyCheck:[responseDict objectForKey:@"Message"]]) {
                                                                         if (upcomingWebinarsData && [[upcomingWebinarsData objectForKey:@"EventItemID"] isEqual: [webinar objectForKey:@"EventItemID"]] ){
                                                                             eventLikeDislike.selected = [[responseDict valueForKey:@"Likes"] boolValue];
                                                                             NSString *likeCountString = [[responseDict valueForKey:@"LikeCount"] stringValue];
                                                                             if (![Utility isEmptyCheck:likeCountString]) {
                                                                                 eventLikeCount.text = likeCountString;
                                                                             }
                                                                             return ;
                                                                         }
                                                                         else if (webinarsData == webinar) {
                                                                             eventLikeDislike.selected = [[responseDict valueForKey:@"Likes"] boolValue];
                                                                             NSString *likeCountString = [[responseDict valueForKey:@"LikeCount"] stringValue];
                                                                             if (![Utility isEmptyCheck:likeCountString]) {
                                                                                 eventLikeCount.text = likeCountString;
                                                                             }
                                                                             return ;
                                                                         }
                                                                         CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:table];
                                                                         NSIndexPath *indexPath = [table indexPathForRowAtPoint:buttonPosition];
                                                                         [webinarsData setObject:[responseDict valueForKey:@"LikeCount"] forKey:@"LikeCount"];
                                                                         [webinarsData setObject:[responseDict valueForKey:@"Likes"] forKey:@"Likes"];
                                                                         [webinarsOfPresenter replaceObjectAtIndex:sender.tag withObject:webinarsData];
                                                                         NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
                                                                         [table reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
                                                                         
                                                                         
                                                                     }else{
                                                                         [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                         }];
        [dataTask resume];
    }else{
      //  [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
-(void)watchList:(NSMutableDictionary *)webinarsData sender:(UIButton *)sender{
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    if (Utility.reachable) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            if (contentView) {
        //                [contentView removeFromSuperview];
        //            }
        //            contentView = [Utility activityIndicatorView:self];
        //        });
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinarsData valueForKey:@"EventItemVideoDetails"]];
        if (eventItemVideoDetailsArray.count > 0) {
            NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
            if (![Utility isEmptyCheck:eventItemVideoDetails]) {
                if (![[eventItemVideoDetails objectForKey:@"IsWatchListVideo"] boolValue]) {
                    [Utility msg:[@"" stringByAppendingFormat:@"%@ has now been saved to your watchlist. You can find this anytime from the menu.",[webinarsData objectForKey:@"EventName"]] title:@"Alert" controller:self haveToPop:NO];
                }

                NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
                [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"User_id"];
                [mainDict setObject:AccessKey forKey:@"Key"];
                [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
                [mainDict setObject:[eventItemVideoDetails objectForKey:@"EventItemVideoID"] forKey:@"Video_id"];
                
                NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:0  error:&error];
                if (error) {
                    [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                    return;
                }
                NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
                
                NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleWatchlistApiCall" append:@"" forAction:@"POST"];
                NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         if (contentView) {
                                                                             [contentView removeFromSuperview];
                                                                         }
                                                                         if(error == nil)
                                                                         {
                                                                             NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                             
                                                                             NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                             if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && ![Utility isEmptyCheck:[responseDict objectForKey:@"ToggleFlag"]]) {
                                                                                 if (upcomingWebinarsData && [[upcomingWebinarsData objectForKey:@"EventItemID"] isEqual: [webinar objectForKey:@"EventItemID"]] ){
                                                                                     eventWatchListButton.selected = [[responseDict objectForKey:@"ToggleFlag"] boolValue];
                                                                                     return;
                                                                                 }else if (webinarsData == webinar) {
                                                                                     eventWatchListButton.selected = [[responseDict objectForKey:@"ToggleFlag"] boolValue];
                                                                                   
                                                                                     return ;
                                                                                 }
                                                                                 CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:table];
                                                                                 NSIndexPath *indexPath = [table indexPathForRowAtPoint:buttonPosition];
                                                                                 [eventItemVideoDetails setObject:[responseDict objectForKey:@"ToggleFlag"] forKey:@"IsWatchListVideo"];
                                                                                 [eventItemVideoDetailsArray removeObjectAtIndex:0];
                                                                                 [eventItemVideoDetailsArray insertObject:eventItemVideoDetails atIndex:0];
                                                                                 [webinarsData setObject:eventItemVideoDetailsArray forKey:@"EventItemVideoDetails"];
                                                                                 
                                                                                 [webinarsOfPresenter replaceObjectAtIndex:sender.tag withObject:webinarsData];
                                                                                 NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
                                                                                 [table reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
                                                                                 
                                                                                 
                                                                             }else{
                                                                                 [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                                 return;
                                                                             }
                                                                         }else{
                                                                             [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                         }
                                                                     });
                                                                 }];
                [dataTask resume];
            }
        }else{
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
    }else{
       // [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
-(void)podcast:(NSMutableDictionary *)webinarsData sender:(UIButton *)sender{
    NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinarsData valueForKey:@"EventItemVideoDetails"]];
    if (eventItemVideoDetailsArray.count > 0) {
        NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
        if (![Utility isEmptyCheck:eventItemVideoDetails]) {
            NSString *urlString = [eventItemVideoDetails objectForKey:@"PodcastURL" ];
            if (![Utility isEmptyCheck:urlString]) {
                PodcastViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Podcast"];
                controller.urlString = urlString;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }

}



-(void)UpdateEventItemVideoTime{
    NSLog(@"UpdateEventItemVideoTime called");
    if (Utility.reachable) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            if (self->contentView) {
        //                [self->contentView removeFromSuperview];
        //            }
        //            self->contentView = [Utility activityIndicatorView:self];
        //        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        [mainDict setObject:[webinar objectForKey:@"EventItemID"] forKey:@"EventItemId"];
        
        NSString *appUrl=@"";
        NSArray *videoUrls = [webinar objectForKey:@"EventItemVideoDetails"];
        if (![Utility isEmptyCheck:videoUrls] && videoUrls.count > 0) {
            NSDictionary *appUrlDict =[videoUrls objectAtIndex:0];
            if (![Utility isEmptyCheck:[appUrlDict objectForKey:@"AppURL"]] ) {
                
                appUrl =[appUrlDict objectForKey:@"AppURL"];
            }
        }
        [mainDict setObject:appUrl forKey:@"VideoUrl"];
        NSUInteger playerTime = CMTimeGetSeconds(appDelegate.FBWAudioPlayer.currentTime);
        [mainDict setObject:[NSString stringWithFormat:@"%d",(int)playerTime] forKey:@"Time"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateEventItemVideoTime" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 //                                                                 if (self->contentView) {
                                                                 //                                                                     [self->contentView removeFromSuperview];
                                                                 //                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
//                                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadWebinarList" object:self userInfo:nil];
                                                                     }
                                                                     else{
                                                                         //[Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         self->isUpdateTimeCalled = NO;
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     self->isUpdateTimeCalled = NO;
                                                                    // [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
       // [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        isUpdateTimeCalled = NO;
    }
    
}
- (void) initAudioVisualizer
{
    CGRect frame = soundCloudAudioView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    UIColor *visualizerColor = squadMainColor;
    _audioVisualizer = [[AudioVisualizer alloc] initWithBarsNumber:50 frame:frame andColor:visualizerColor];
    [soundCloudAudioView addSubview:_audioVisualizer];
}

- (void) startAudioVisualizer
{
    self->visualizer = [[VisualizerView alloc] initWithFrame:self->backgroundView.frame];
    [self->visualizer setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self->backgroundView addSubview:self->visualizer];
    self->visualizer.audioPlayer = self->_audioPlayer;
    
//    if(visualizerTimer && visualizerTimer.isValid) return;
//    soundCloudAudioView.hidden = false;
//    [visualizerTimer invalidate];
//    visualizerTimer = nil;
//    visualizerTimer = [NSTimer scheduledTimerWithTimeInterval:visualizerAnimationDuration target:self selector:@selector(visualizerTimer:) userInfo:nil repeats:YES];

}
- (void) stopAudioVisualizer
{
        self->visualizeView.hidden = true;
//
//    soundCloudAudioView.hidden = true;
//    [visualizerTimer invalidate];
//    visualizerTimer = nil;
//    [_audioVisualizer stopAudioVisualizer];
}

- (void) visualizerTimer:(CADisplayLink *)timer
{
    if(!_audioPlayer) return;
    [_audioPlayer updateMeters];
    
    const double ALPHA = 1.05;
    
    double averagePowerForChannel = pow(10, (0.05 * [_audioPlayer averagePowerForChannel:0]));
    lowPassReslts = ALPHA * averagePowerForChannel + (1.0 - ALPHA) * lowPassReslts;
    
    double averagePowerForChannel1 = pow(10, (0.05 * [_audioPlayer averagePowerForChannel:1]));
    lowPassReslts1 = ALPHA * averagePowerForChannel1 + (1.0 - ALPHA) * lowPassReslts1;
    
    [_audioVisualizer animateAudioVisualizerWithChannel0Level:lowPassReslts andChannel1Level:lowPassReslts1];
//    [self updateLabels];
}

-(void)updateVideoTimeForOffline{
    NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinar valueForKey:@"EventItemVideoDetails"]];
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
                    NSMutableArray *videoUrls = [[webinar objectForKey:@"EventItemVideoDetails"] mutableCopy];
                    if (![Utility isEmptyCheck:videoUrls] && videoUrls.count > 0) {
                        NSMutableDictionary *appUrlDict =[[videoUrls objectAtIndex:0] mutableCopy];
                    //      [appUrlDict setObject:[NSString stringWithFormat:@"%f",videoStartTime] forKey:@"Time"];
                        [appUrlDict setObject:[NSNumber numberWithDouble:videoStartTime] forKey:@"Time"];
                        [videoUrls replaceObjectAtIndex:0 withObject:appUrlDict];
                        [webinar setObject:videoUrls forKey:@"EventItemVideoDetails"];
                        [self addUpdateDB];
                        if(![Utility reachable]){
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadWebinarList" object:self userInfo:nil];
                        }
                    }
                }
            }
        }
    }
    //------------
    
}

-(void)addUpdateDB{
    if(![Utility isEmptyCheck:webinar]){
        
        NSError *error;
        NSData *webinardata = [NSJSONSerialization dataWithJSONObject:webinar options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            NSLog(@"Error Favorite Array-%@",error.debugDescription);
            return;
        }
        
        NSString *detailsString = [[NSString alloc] initWithData:webinardata encoding:NSUTF8StringEncoding];
        int eventItemId = [[webinar objectForKey:@"EventItemID"] intValue];
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        if([DBQuery isRowExist:@"meditationList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and EventId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:eventItemId]]]){
             [DBQuery updateMeditationDetails:detailsString with:eventItemId];
         }else{
             [DBQuery addMeditationData:detailsString with:eventItemId];
        }
    }
}



-(void)saveVideoStartTimeIntoTable{
    if(![Utility isEmptyCheck:webinar]){
        NSMutableDictionary *videoTimeDict=[[NSMutableDictionary alloc] init];
        [videoTimeDict setObject:[NSNumber numberWithDouble:videoStartTime] forKey:@"Time"];
        
        NSError *error;
        NSData *videoTimeData = [NSJSONSerialization dataWithJSONObject:videoTimeDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            NSLog(@"Error Favorite Array-%@",error.debugDescription);
            return;
        }
        
        NSString *detailsString = [[NSString alloc] initWithData:videoTimeData encoding:NSUTF8StringEncoding];
        int eventItemId = [[webinar objectForKey:@"EventItemID"] intValue];
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        BOOL isAdded = NO;
        if([DBQuery isRowExist:@"webniarTimeTable" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and EventItemId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:eventItemId]]]){
             [DBQuery updateMeditationTime:detailsString with:eventItemId];
         }else{
             isAdded = [DBQuery addMeditationTime:detailsString with:eventItemId];
             
             if (!isAdded && (![Utility isEmptyCheck:[defaults objectForKey:@"TableUpdateCheck"]] && ![defaults boolForKey:@"TableUpdateCheck"])) {
                 BOOL isCheck = [DBQuery createTableDBForWebniarSelcted];
                 if (isCheck) {
                     [DBQuery addMeditationTime:detailsString with:eventItemId];
                 }else{
                     [Utility msg:@"Database not updated" title:@"" controller:self haveToPop:NO];
                 }
             }
        }
    }
}


-(void)getVideoStartTimeFromTable{
    double startTime=0;
    if(![Utility isEmptyCheck:webinar]){
        int eventItemId = [[webinar objectForKey:@"EventItemID"] intValue];
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        if([DBQuery isRowExist:@"webniarTimeTable" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and EventItemId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:eventItemId]]]){
            DAOReader *dbObject = [DAOReader sharedInstance];
            if([dbObject connectionStart]){
                NSArray *timeArr = [dbObject selectBy:@"webniarTimeTable" withColumn:[[NSArray alloc]initWithObjects:@"VideoTime",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@' and EventItemId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:eventItemId]]];
                NSString *str = timeArr[0][@"VideoTime"];
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *timeDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                startTime=[[timeDict objectForKey:@"Time"] doubleValue];
                videoStartTime = startTime;
                
                NSMutableArray *videoUrls = [[webinar objectForKey:@"EventItemVideoDetails"] mutableCopy];
                if (![Utility isEmptyCheck:videoUrls] && videoUrls.count > 0) {
                    NSMutableDictionary *appUrlDict =[[videoUrls objectAtIndex:0] mutableCopy];
                    [appUrlDict setObject:[NSNumber numberWithDouble:startTime] forKey:@"Time"];
                    [videoUrls replaceObjectAtIndex:0 withObject:appUrlDict];
                    [webinar setObject:videoUrls forKey:@"EventItemVideoDetails"];
                }
            }
        }
        [self updateView];
    }
}
//- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
//    if (event.type == UIEventTypeRemoteControl) {
//        if (event.subtype == UIEventSubtypeRemoteControlPlay)
//        {
////            playPauseButton.selected = true;
//            [self playPause:nil];
//            CMTime startTime = self->appDelegate.playerController.player.currentTime;
//            self->videoStartTime = CMTimeGetSeconds(startTime);
//            [self->appDelegate.playerController.player play];
//            NSLog(@"UIEventSubtypeRemoteControlPlay");
//        }
//        else if (event.subtype == UIEventSubtypeRemoteControlPause)
//        {
//            playPauseButton.selected = false;
//            [self stopAudioVisualizer];
//            CMTime startTime = self->appDelegate.playerController.player.currentTime;
//            self->videoStartTime = CMTimeGetSeconds(startTime);
//            [self->appDelegate.playerController.player pause];
//            NSLog(@"UIEventSubtypeRemoteControlPause");
//        }
//        else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause)
//        {
//            NSLog(@"UIEventSubtypeRemoteControlTogglePlayPause");
//        }
//        else if (event.subtype == UIEventSubtypeRemoteControlNextTrack)
//        {
//            NSLog(@"UIEventSubtypeRemoteControlToggleNext");
//            //??? ki korbo
//        }
//        else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack)
//        {
//            NSLog(@"UIEventSubtypeRemoteControlPrevious");
//            //??? ki korbo
//        }
//    }
//}

#pragma mark - End -
#pragma mark - IBAction -

- (IBAction)nonQueDropdownPressed:(UIButton *)sender {
    if (guidedMainView.hidden==true) {
        guidedMainView.hidden=false;
        nonQueDropdownButton.selected=YES;
        serachView.hidden = false;
        questionmarkGuidedView.hidden = false;
        
    }else{
        guidedMainView.hidden=true;
        nonQueDropdownButton.selected=NO;
        serachView.hidden = true;
        questionmarkGuidedView.hidden = true;
    }
}


- (IBAction)previousButton:(UIButton *)sender {
    if (selectedIndex > 0 && webinarsOfPresenter.count >0) {
        NSDictionary *dict = [webinarsOfPresenter objectAtIndex:selectedIndex-1];
        if (![Utility isEmptyCheck:dict]) {
            webinar  = [dict mutableCopy] ;
            [self getWebinarDetails:[webinar valueForKey:@"PresenterName"]];
        }
        
    }
    
}
- (IBAction)nextButton:(UIButton *)sender {
    if (selectedIndex >= 0 && webinarsOfPresenter.count >0) {
        NSDictionary *dict = [webinarsOfPresenter objectAtIndex:selectedIndex];
        if (![Utility isEmptyCheck:dict]) {
            webinar  = [dict mutableCopy];
            [self getWebinarDetails:[webinar valueForKey:@"PresenterName"]];
        }
    }
    
}
-(IBAction)checkUncheckNonQuedPressed:(UIButton*)sender{
    if (!sender.isSelected) {
        indexValue = -1;
        [self addUpdateDBForDropDown:indexValue];
        [searchTableView reloadData];
        sender.selected=true;
        checkedNonQuedButton.selected = true;
        for (UIButton *btn in guidedCheckButtonArray) {
            btn.selected=false;
        }
        int indexValue = -1;
        [self addUpdateDBForGuided:indexValue];
        [self addUpdateDBForNonQued:true];
    }else{
        checkedNonQuedButton.selected = false;
        [self addUpdateDBForNonQued:false];

    }
    
}

- (IBAction)checkUncheckGuidedPressed:(UIButton *)sender {
    int index = 0;
    if (!sender.isSelected) {
        indexValue = -1;
        [self addUpdateDBForDropDown:indexValue];
        [searchTableView reloadData];
        for (UIButton *btn in guidedCheckButtonArray) {
            if (btn==sender) {
                btn.selected=true;
                index = (int)btn.tag;
            }else{
                btn.selected=false;
            }
        }
        checkedNonQuedButton.selected=false;
        [self addUpdateDBForGuided:index];
    }else{
        BOOL isTrue = false;
        for (UIButton *btn in guidedCheckButtonArray) {
            if (btn==sender) {
                btn.selected = false;
            }
        }
         for (UIButton *btn in guidedCheckButtonArray) {
             if (btn.isSelected) {
                 isTrue = true;
             }
         }
        if (!isTrue) {
            index = -1;
            [self addUpdateDBForGuided:index];

        }
       
    }
    BOOL isselect = false;
    for (UIButton *btn in guidedCheckButtonArray) {
                if (btn.isSelected) {
                    isselect = true;
                }
            }
    if (isselect) {
        nonQueDropdownButton.userInteractionEnabled = false;
        nonQueDropdownButton.alpha = 0.5;
    }else{
        nonQueDropdownButton.userInteractionEnabled = true;
        nonQueDropdownButton.alpha = 1;
    }
}



-(IBAction)questionPressedForNonQued:(UIButton*)sender{
    nonQuedDescriptionView.hidden = false;
}
-(IBAction)questionCrossPressed:(id)sender{
    nonQuedDescriptionView.hidden = true;

}
- (IBAction)downloadButtonPressed:(UIButton *)sender {
    //NSMutableDictionary *webinarsData = [[NSMutableDictionary alloc]initWithDictionary:[webinarsOfPresenter objectAtIndex:sender.tag]];
    [self download:webinar sender:sender];
}

- (IBAction)likeDislikeButtonPressed:(UIButton *)sender {
    if(Utility.reachable){
        NSMutableDictionary *webinarsData = [[NSMutableDictionary alloc]initWithDictionary:[webinarsOfPresenter objectAtIndex:sender.tag]];
        [self likeDislike:webinarsData sender:sender];
    }else{
        //[Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
    }
}
- (IBAction)watchListButtonPressed:(UIButton *)sender {
    if(Utility.reachable){
        NSMutableDictionary *webinarsData = [[NSMutableDictionary alloc]initWithDictionary:[webinarsOfPresenter objectAtIndex:sender.tag]];
        [self watchList:webinarsData sender:sender];
    }else{
        //[Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
    }
}
- (IBAction)podcastButtonPressed:(UIButton *)sender {
    if(Utility.reachable){
        NSMutableDictionary *webinarsData = [[NSMutableDictionary alloc]initWithDictionary:[webinarsOfPresenter objectAtIndex:sender.tag]];
        [self podcast:webinarsData sender:sender];
    }else{
        //[Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
    }
}


- (IBAction)webinarDownloadButtonPressed:(UIButton *)sender {
    if(Utility.reachable){
    }else{
        //[Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
    }
    if (upcomingWebinarsData && [[upcomingWebinarsData objectForKey:@"EventItemID"] isEqual: [webinar objectForKey:@"EventItemID"]] ){
        [self download:upcomingWebinarsData sender:sender];
    }else
        [self download:webinar sender:sender];
}

- (IBAction)webinarLikeDislikeButtonPressed:(UIButton *)sender {
    if(Utility.reachable){
        if (upcomingWebinarsData && [[upcomingWebinarsData objectForKey:@"EventItemID"] isEqual: [webinar objectForKey:@"EventItemID"]] ){
            [self likeDislike:[upcomingWebinarsData mutableCopy] sender:sender];
        }else
            [self likeDislike:webinar sender:sender];
    }else{
        //[Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
    }
        
}
- (IBAction)webinarWatchListButtonPressed:(UIButton *)sender {
    if(Utility.reachable){
        if (upcomingWebinarsData && [[upcomingWebinarsData objectForKey:@"EventItemID"] isEqual:[webinar objectForKey:@"EventItemID"]] ){
            [self watchList:[upcomingWebinarsData mutableCopy] sender:sender];
        }else
            [self watchList:webinar sender:sender];
    }else{
        //[Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
    }
}
- (IBAction)webinarPodcastButtonPressed:(UIButton *)sender {
    if(Utility.reachable){
        if (upcomingWebinarsData && [[upcomingWebinarsData objectForKey:@"EventItemID"] isEqual: [webinar objectForKey:@"EventItemID"]] ){
            [self podcast:[upcomingWebinarsData mutableCopy] sender:sender];
        }else
            [self podcast:webinar sender:sender];
    }else{
       // [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
    }
}

-(IBAction)progressBarValueChanged:(id)sender{
    [appDelegate.FBWAudioPlayer pause];
    playPauseButton.selected=false;
    float progressBarValue;
    if (!visualizeView.hidden) {
        progressBarValue = progressVisualSlider.value;
    }else{
        progressBarValue = progressBar.value;
    }
    CMTime playerDuration = appDelegate.FBWAudioPlayer.currentItem.asset.duration;
    double duration = CMTimeGetSeconds(playerDuration);
    CMTime newTime = CMTimeMakeWithSeconds(progressBarValue * duration, appDelegate.FBWAudioPlayer.currentTime.timescale);
    [appDelegate.FBWAudioPlayer seekToTime:newTime];
//    [appDelegate.FBWAudioPlayer play];
    videoStartTime=progressBarValue * duration;
    double currentTime = CMTimeGetSeconds(newTime);
    [_audioPlayer setCurrentTime:currentTime];
    if (!visualizeView.hidden) {
        playPauseButton.selected = false;
        [self playPause:nil];
    }
}

-(IBAction)playPause:(id)sender{
    NSLog(@"%f",appDelegate.FBWAudioPlayer.rate);
    playPauseButton.selected = !playPauseButton.selected;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self->playPauseButton.selected)
            {
                
                if (self->videoStartTime) {
                    CMTime playerDuration = self->appDelegate.playerController.player.currentItem.asset.duration;
                    double maxDuration = CMTimeGetSeconds(playerDuration);
    //                double currentTime = [[NSString stringWithFormat:@"%@",[self->dataDict objectForKey:@"Time"]]doubleValue];
                    double currentTime = self->videoStartTime;
                    double audioPlaytime = self->videoStartTime;
                  
                    
                    if (currentTime > maxDuration) {
                        CMTime startTime = CMTimeMake(0, self->appDelegate.playerController.player.currentTime.timescale);
                        [self->appDelegate.playerController.player seekToTime:startTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                            [self->appDelegate.playerController.player play];
                        }];
                        audioPlaytime = 0;
                    }else{
                        CMTime startTime = CMTimeMake(currentTime, 1);
    //                    int s=self->appDelegate.playerController.player.currentTime.timescale;
                        //self->appDelegate.playerController.player.currentTime.timescale
                        [self->appDelegate.playerController.player seekToTime:startTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
//                            [self->appDelegate.playerController.player play];
                            [self visulaizerBtnPressed:nil];
                        }];
                    }
                    
                    if(self->_audioPlayer){
                       [self->_audioPlayer setCurrentTime:audioPlaytime];
                    }
                }else{
                      [self visulaizerBtnPressed:nil];
//                    [self->appDelegate.playerController.player play];
                }
                
                if(self->_audioPlayer){
//                    self->_audioPlayer.delegate = self;
//                    [self->_audioPlayer prepareToPlay];
//                    [self->_audioPlayer setVolume:0];
//                    [self->_audioPlayer play];
                  
                }
                self->visualizeView.hidden = false;
                [self startAudioVisualizer];
               // NSString *eventItemID = [NSString stringWithFormat:@"%@",[self->webinar objectForKey:@"EventItemID"]];
                /*if (![defaults boolForKey:eventItemID]) {
                    [defaults setBool:true forKey:[NSString stringWithFormat:@"%@",[self->webinar objectForKey:@"EventItemID"]]]; //Commented for calling every time when play button pressed
                    [self UpdateEventItemVideoTime];
                }*/

            }
            else
            {
                
                if (!([[self->appDelegate.playerController.player.currentItem.asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) && self->_audioPlayer) {

                    [self->_audioPlayer pause];
                    [self stopAudioVisualizer];
                }
                [self->appDelegate.playerController.player pause];
                CMTime startTime = self->appDelegate.playerController.player.currentTime;
                self->videoStartTime = CMTimeGetSeconds(startTime);
                self->_audioPlayer.currentTime = self->videoStartTime;
                self->visualizeView.hidden = true;
                
            }
        });
    
//    if (appDelegate.FBWAudioPlayer.rate == 0) {
//        [appDelegate.FBWAudioPlayer play];
////        [playPauseButton setBackgroundImage:pauseButtonImage forState:UIControlStateNormal];
//    } else if (appDelegate.FBWAudioPlayer.rate == 1){
//        [appDelegate.FBWAudioPlayer pause];
////        [playPauseButton setBackgroundImage:playButtonImage forState:UIControlStateNormal];
//    }
}



-(IBAction)setVolumeUp:(id)sender{
    NSLog(@"pv1 %f",appDelegate.FBWAudioPlayer.volume);
    if (appDelegate.FBWAudioPlayer.volume < 1.0) {
        appDelegate.FBWAudioPlayer.volume = appDelegate.FBWAudioPlayer.volume + 0.1;
    }
    NSLog(@"pv2 %f",appDelegate.FBWAudioPlayer.volume);
    [self showVolume];
}
-(IBAction)setVolumeDown:(id)sender{
    NSLog(@"pv1 %f",appDelegate.FBWAudioPlayer.volume);
    if (appDelegate.FBWAudioPlayer.volume > 0.0) {
        appDelegate.FBWAudioPlayer.volume = appDelegate.FBWAudioPlayer.volume - 0.1;
    }
    NSLog(@"pv2 %f",appDelegate.FBWAudioPlayer.volume);
    [self showVolume];
}
-(IBAction)mute:(id)sender{
    if (appDelegate.FBWAudioPlayer.isMuted) {
        appDelegate.FBWAudioPlayer.muted = NO;
        [self showVolume];
        UIImage *muteButtonImage = [UIImage imageNamed:@"ic_sound_plus.png"];
        [muteButton setImage:muteButtonImage forState:UIControlStateNormal];
//        for (UIButton *b in self.buttons) {
//            UIImage *buttonImage = [UIImage imageNamed:@"vol_incr.png"];
//            [b setBackgroundImage:buttonImage forState:UIControlStateNormal];
//        }
    } else {
        appDelegate.FBWAudioPlayer.muted = YES;
        UIImage *muteButtonImage = [UIImage imageNamed:@"ic_sound_mute.png"];
        [muteButton setImage:muteButtonImage forState:UIControlStateNormal];
        for (UIButton *b in self.buttons) {
            UIImage *buttonImage = [UIImage imageNamed:@"vol_dcr.png"];
            [b setBackgroundImage:buttonImage forState:UIControlStateNormal];
        }
    }
}

- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
-(IBAction)backButtonPressed:(id)sender{
    bool isFavAlertShown;
    NSArray *eventIdList=[[NSArray alloc] init];
    NSMutableArray *eventIdMutableList=[[NSMutableArray alloc] init];
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"MeditationFavAlertShownArr"]]) {
        eventIdList=[defaults objectForKey:@"MeditationFavAlertShownArr"];
        if ([eventIdList containsObject:[webinar objectForKey:@"EventItemID"]]) {
            isFavAlertShown=YES;
        }else{
            isFavAlertShown=NO;
            eventIdMutableList=[eventIdList mutableCopy];
            [eventIdMutableList addObject:[webinar objectForKey:@"EventItemID"]];
        }
    }else{
        isFavAlertShown=NO;
        [eventIdMutableList addObject:[webinar objectForKey:@"EventItemID"]];
    }
    if (isShowFavAlert && !isFavAlertShown) {
        [defaults setObject:eventIdMutableList forKey:@"MeditationFavAlertShownArr"];
        [self showFavAlert];
    }else{
        [self backToWebinarList];
    }
}
- (IBAction)backwardBtnPressed:(UIButton *)sender {
    
    CMTime currentTime = appDelegate.playerController.player.currentTime;
    double duration = CMTimeGetSeconds(currentTime) ;
    if(duration > 30){
        duration = duration - 30;
    }else{
        duration = 0;
    }
    
    CMTime newTime = CMTimeMakeWithSeconds(duration, appDelegate.playerController.player.currentTime.timescale);
    [appDelegate.playerController.player seekToTime:newTime];
    [appDelegate.playerController.player play];
    double time = CMTimeGetSeconds(newTime);
    [_audioPlayer setCurrentTime:time];
    
    playPauseButton.selected = true;
     self->visualizeView.hidden = false;
        [self startAudioVisualizer];

    
}
- (IBAction)forwardBtnPressed:(UIButton *)sender {
    
    CMTime playerDuration = appDelegate.playerController.player.currentItem.asset.duration;
    double totalDuration = CMTimeGetSeconds(playerDuration) ;
    CMTime currentTime = appDelegate.playerController.player.currentTime;
    double duration = CMTimeGetSeconds(currentTime) ;
    if(duration+30 > totalDuration){
        duration = totalDuration;
    }else{
        duration = duration+30;
    }
    
    CMTime newTime = CMTimeMakeWithSeconds(duration, appDelegate.playerController.player.currentTime.timescale);
    [appDelegate.playerController.player seekToTime:newTime];
    [appDelegate.playerController.player play];
    double time = CMTimeGetSeconds(newTime);
    [_audioPlayer setCurrentTime:time];
    playPauseButton.selected = true;
     self->visualizeView.hidden = false;
     [self startAudioVisualizer];
}
- (IBAction)visulaizerBtnPressed:(UIButton *)sender {
    
    CMTime playerDuration = appDelegate.playerController.player.currentItem.asset.duration;
    double totalDuration = CMTimeGetSeconds(playerDuration) ;
    CMTime currentTime = appDelegate.playerController.player.currentTime;
    double duration = CMTimeGetSeconds(currentTime);
    CMTime newTime = CMTimeMakeWithSeconds(duration, appDelegate.playerController.player.currentTime.timescale);
    [appDelegate.playerController.player seekToTime:newTime];
    [appDelegate.playerController.player play];
    double time = CMTimeGetSeconds(newTime);
    [_audioPlayer setCurrentTime:time];
    playPauseButton.selected = true;
}
-(IBAction)attachmentTapped:(UIButton*)sender {
    if ([[[webinar objectForKey:@"Attachments"] objectAtIndex:[sender tag]] isKindOfClass:[NSString class]]) {
        NSString *urlStr = [[webinar objectForKey:@"Attachments"] objectAtIndex:[sender tag]];
        if (![Utility isEmptyCheck:urlStr]) {
            PrivacyPolicyAndTermsServiceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PrivacyPolicyAndTermsService"];
            controller.modalPresentationStyle = UIModalPresentationCustom;
            controller.url=[NSURL URLWithString:urlStr];
            [self presentViewController:controller animated:YES completion:nil];
            //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlStr]];
        }else{
            [Utility msg:@"Attachment can't be open" title:@"Oops!" controller:self haveToPop:NO];
        }
    } else {
        [Utility msg:@"Attachment can't be open" title:@"Oops!" controller:self haveToPop:NO];
    }
}

- (IBAction)attachmentViewPressed:(UIButton *)sender
{
    attachmentView.hidden = NO;
}

- (IBAction)attachmentClosePressed:(UIButton *)sender
{
    attachmentView.hidden = YES;
}


- (IBAction)fullScreenPressed:(UIButton *)sender {
    NSString * videoUrlString = @"";
    
    NSArray *videoUrls = [webinar objectForKey:@"EventItemVideoDetails"];
    
    if (![Utility isEmptyCheck:videoUrls] && videoUrls.count > 0) {
        NSDictionary *appUrlDict =[videoUrls objectAtIndex:0];
        if (![Utility isEmptyCheck:[appUrlDict objectForKey:@"AppURL"]] ) {
            videoUrlString=[appUrlDict objectForKey:@"AppURL"];
        }
    }
    
    
    if (![Utility isEmptyCheck:videoUrlString]) {
        NSURL *fileURL = [NSURL URLWithString:videoUrlString];
        if([fileURL absoluteString].length < 1) {
            return;
        }
        
        CMTime startTime=appDelegate.playerController.player.currentTime;
        if (playPauseButton.selected) {
            [self playPause:0];
        }
        
//        playPauseButton.selected = false;
//        CMTime startTime=appDelegate.playerController.player.currentTime;
//        if (appDelegate.FBWAudioPlayer) {
//            [appDelegate.FBWAudioPlayer pause];
//            appDelegate.FBWAudioPlayer = nil;
//
//        }
        
        @try {
            //            AVPlayer *playerForDownloadedVideo = appDelegate.FBWAudioPlayer;
            //            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            AVPlayer *playerForDownloadedVideo = [[AVPlayer alloc]initWithURL:fileURL];
            avplayerViewController = [[AVPlayerViewController alloc]init];
//            [self presentViewController:avplayerViewController animated:YES completion:nil];
            avplayerViewController.view.frame = self.view.frame;
            avplayerViewController.player = playerForDownloadedVideo;
            avplayerViewController.showsPlaybackControls = YES;
            avplayerViewController.delegate=self;
            [self presentViewController:avplayerViewController animated:YES completion:nil];
            [playerForDownloadedVideo seekToTime:startTime];
            [playerForDownloadedVideo play];
        } @catch (NSException *exception) {
            NSLog(@"error -> %@",exception);
        }
    }
}
-(IBAction)shopNowDropDownPressed:(UIButton*)sender{
    if (shopDescStackView.hidden) {
        shopNowDropButton.selected = true;
        shopDescStackView.hidden = false;
    }else{
        shopNowDropButton.selected = false;
        shopDescStackView.hidden = true;

    }
}
-(IBAction)testNowDropDownPressed:(UIButton*)sender{
    if (testDescStackView.hidden) {
        testNowDropButton.selected = true;
        testDescStackView.hidden = false;
    }else{
        testNowDropButton.selected = false;
        testDescStackView.hidden = true;
    }
}
-(IBAction)searchButtonPressed:(id)sender{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i =0; i<dropDownListArray.count; i++) {
        [arr addObject:[[dropDownListArray objectAtIndex:i]objectForKey:@"GuidedMeditationDescription"]];
    }
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
       controller.modalPresentationStyle = UIModalPresentationCustom;
       controller.dropdownDataArray = arr;
       controller.mainKey = @"";
       controller.apiType = @"";
       controller.selectedIndex = (int)selectedIndex;
       controller.delegate = self;
       [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)minusButtonPressed:(UIButton*)sender{
    if (addDropdownList.count>0) {
        NSDictionary *dict = [addDropdownList objectAtIndex:sender.tag];
        if (![Utility isEmptyCheck:dict]) {
            if (sender.tag == indexValue) {
                indexValue = -1;
                [self addUpdateDBForDropDown:indexValue];
            }
            [addDropdownList removeObject:dict];
            [searchTableView reloadData];
        }
        serachView.hidden = false;
        searchTableSuperView.hidden = false;
        
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        if([DBQuery isRowExist:@"dropDownDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]]){
       DAOReader *dbObject = [DAOReader sharedInstance];
       if([dbObject connectionStart]){
          NSArray *dropdownArr = [dbObject selectBy:@"dropDownDetails" withColumn:[[NSArray alloc]initWithObjects:@"DropDownIndex",@"DataDict",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue]]];
                   if (dropdownArr.count>0) {
                       checkedNonQuedButton.selected = false;
                       for (UIButton *btn in guidedCheckButtonArray) {
                               btn.selected = false;
                       }
                       indexValue = [[[dropdownArr objectAtIndex:0]objectForKey:@"DropDownIndex"]intValue];
                       if (indexValue>=0) {
                       NSData* data = [[[dropdownArr objectAtIndex:0]objectForKey:@"DataDict"] dataUsingEncoding:NSUTF8StringEncoding];
                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                       if(![Utility isEmptyCheck:responseDictionary]){
                           int index = (int)[addDropdownList indexOfObject:responseDictionary];
                           indexValue = index;
                       }
                    }
                }
            }
        }
                     
    }
    if(!(addDropdownList.count>0)){
        serachView.hidden = false;
        searchTableSuperView.hidden = true;
        indexValue = -1;
        [self addUpdateDBForDropDown:indexValue];
    }
    [searchTableView reloadData];
}

- (IBAction)shopNowButtonPressed:(UIButton *)sender {
    if (![Utility isEmptyCheck:_shopUrl]) {
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_shopUrl]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_shopUrl] options:@{} completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"Opened");
                }
            }];
        }
    }
    
}
-(IBAction)checkUncheckDropDownPressed:(UIButton*)sender{
    if (!sender.isSelected) {
        checkedNonQuedButton.selected = false;
        for (UIButton *btn in guidedCheckButtonArray) {
                btn.selected = false;
        }
        [self addUpdateDBForGuided:-1];
        indexValue = (int)sender.tag;
        [self addUpdateDBForNonQued:false];
        [self addUpdateDBForDropDown:indexValue];
        [searchTableView reloadData];
    }else{
        sender.selected = false;
        indexValue = -1;
        [self addUpdateDBForDropDown:indexValue];
        [searchTableView reloadData];

    }
    if (indexValue>0) {
     if (![Utility isEmptyCheck:[addDropdownList objectAtIndex:indexValue]]) {
         NSDictionary *dict = [addDropdownList objectAtIndex:indexValue];
         if (![Utility isEmptyCheck:[dict objectForKey:@"EventItemVideoDetails"]]) {
             NSDictionary *eventItemVideoDetailsDict = [[dict objectForKey:@"EventItemVideoDetails"]objectAtIndex:0];
             if (![Utility isEmptyCheck:[eventItemVideoDetailsDict objectForKey:@"VideoURL"]]) {
                     NSURL *video_url = [NSURL URLWithString:[eventItemVideoDetailsDict objectForKey:@"VideoURL"]];
                     NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     NSString* documentsDirectory = [paths objectAtIndex:0];
                     NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[video_url lastPathComponent]];
                     if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
    //                     [self addUpdateDB];
                     }else{
                         [self downloadNonQued:[eventItemVideoDetailsDict objectForKey:@"VideoURL"] sender:eventDownloadButton];
                     }
                }
         }
       }
    }
}
- (IBAction)testNowButtonPressed:(UIButton *)sender {
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:TEST_LEVEL_URL]]){
    NSString *detailsStr = [@"" stringByAppendingFormat:@"%@/members?token=%@",TEST_LEVEL_URL,[defaults valueForKey:@"LoginToken"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:detailsStr] options:@{} completionHandler:^(BOOL success) {
        if(success){
            NSLog(@"Opened");
            }
        }];
    }
}//https://meditate.mindbodyhq.com/members?token={token}

-(IBAction)doubleDropDownPressed:(id)sender{
    if (testNowView.hidden) {
        doubleArrow.selected = true;
        testNowView.hidden = false;
        testDescStackView.hidden = true;
        [self testNowDropDownPressed:nil];
          if (_isShowShopping) {
              shopView.hidden = false;
              shopDescStackView.hidden = true;
              [self shopNowDropDownPressed:nil];
          }else{
              shopView.hidden = true;
          }
    }else{
        testNowView.hidden= true;
        shopView.hidden = true;
        doubleArrow.selected = false;
    }
}
-(IBAction)gotItButtonPressed:(id)sender{
    [self questionCrossPressed:nil];
}
#pragma mark - End -

#pragma mark - Api Call
- (void)favouriteApiCall {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[webinar valueForKey:@"EventItemID"] forKey:@"EventID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:0  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleEventLikeApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [Utility isEmptyCheck:[responseDict objectForKey:@"Message"]]) {
                                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadWebinarList" object:self userInfo:nil];
                                                                         
                                                                     }else{
                                                                         [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                         }];
        [dataTask resume];
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

#pragma mark - End



#pragma mark - Private Methods -
- (void)syncScrubber
{
    if(!self->_audioPlayer.isPlaying){
        [self->_audioPlayer play];
    }
    CMTime playerDuration = appDelegate.FBWAudioPlayer.currentItem.asset.duration;
    if (CMTIME_IS_INVALID(playerDuration))
    {
        progressBar.minimumValue = 0.0;
        progressVisualSlider.minimumValue = 0.0;
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration) && (duration > 0))
    {
        float minValue = [ progressBar minimumValue];
        float maxValue = [ progressBar maximumValue];
        double time = CMTimeGetSeconds([appDelegate.FBWAudioPlayer currentTime]);
        [progressBar setValue:(maxValue - minValue) * time / duration + minValue];
        [progressVisualSlider setValue:(maxValue - minValue) *time / duration + minValue];
        
        NSUInteger dMinutes = floor((NSUInteger)duration / 60);
        NSUInteger dSeconds = floor((NSUInteger)duration % 3600 % 60);
        NSString *videoDurationText = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
        totalTimeLabel.text = videoDurationText;
        totalVisualLabel.text = videoDurationText;
    }
    
    //time label
    NSUInteger playerTime = CMTimeGetSeconds(appDelegate.FBWAudioPlayer.currentTime);
    NSUInteger dMinutes = floor(playerTime / 60);
    NSUInteger dSeconds = floor(playerTime % 3600 % 60);
//    self->videoStartTime = dSeconds;
    NSLog(@"Player Time:%02lu",playerTime);
    
    if (isUpdateTimeCalled && playerTime < 30){
        isUpdateTimeCalled = NO;
    }
    
    if(playerTime >= 30 && !isUpdateTimeCalled){
        NSLog(@"Update Time Called");
        isUpdateTimeCalled = YES;
        [self UpdateEventItemVideoTime];
    }
    
    NSString *videoDurationText = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
    //NSLog(@"Current Duration:%@",videoDurationText);
    currentTime.text = videoDurationText;
    currentVisualTime.text = videoDurationText;
    appDelegate.FBWAudioPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    if ([totalTimeLabel.text isEqualToString:currentTime.text]|| [totalVisualLabel.text isEqualToString:currentVisualTime.text]) {
//         [self playPause:0];
            [appDelegate.FBWAudioPlayer pause];
            self->visualizeView.hidden = true;
            int userId = [[defaults objectForKey:@"UserID"] intValue];
            if(![DBQuery isRowExist:@"nonQuedDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@'and EventItemID = '%d' and IsNonQuedPlaying ='%d'",[NSNumber numberWithInt:userId],[[webinar objectForKey:@"EventItemID"]intValue],1]]){
               playPauseButton.selected=false;
            }
            float progressBarValue = 0;//progressBar.value;
            CMTime playerDuration = appDelegate.FBWAudioPlayer.currentItem.asset.duration;
            double duration = CMTimeGetSeconds(playerDuration);
            CMTime newTime = CMTimeMakeWithSeconds(progressBarValue * duration, appDelegate.FBWAudioPlayer.currentTime.timescale);
            [appDelegate.FBWAudioPlayer seekToTime:newTime];
            videoStartTime=progressBarValue * duration;
            double currentTime = CMTimeGetSeconds(newTime);
            [_audioPlayer setCurrentTime:currentTime];
            [self stopAudioVisualizer];
            [self fetchDataFromTable];
    }
    
    
//    double maxDuration = CMTimeGetSeconds(playerDuration);
//    double currentTime = self->videoStartTime;
//    double audioPlaytime = self->videoStartTime;
//    double currentPayerTime=CMTimeGetSeconds(appDelegate.FBWAudioPlayer.currentTime);
//    if (currentPayerTime>maxDuration) {
//    }else if (currentPayerTime<maxDuration){
//    }else{
//        CMTime startTime = CMTimeMake(0, self->appDelegate.playerController.player.currentTime.timescale);
//        [self->appDelegate.playerController.player seekToTime:startTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
//                            [self playPause:0];
//                        }];
//        audioPlaytime = 0;
//    }
                    
}


-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer{
    NSLog(@"tap");
    if (playPauseButton.isHidden) {
//        playPauseButton.hidden = false;
        playerLabelView.hidden = false;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            playPauseButton.hidden = true;
            self->playerLabelView.hidden = true;
        });
    } else if (!playPauseButton.isHidden){
//        playPauseButton.hidden = true;
        playerLabelView.hidden = true;
    }
    tapCount++;
    //    if (tapCount % 2 == 0) {
    //        playPauseButton.hidden = true;
    //    }
    //    else{
    //        playPauseButton.hidden = false;
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    //            playPauseButton.hidden = true;
    //        });
    //    }
}

-(void)showVolume{
    NSLog(@"pv3 %f",appDelegate.FBWAudioPlayer.volume);
    int playerVolume = roundf(appDelegate.FBWAudioPlayer.volume * 10);
    NSLog(@"PV %d",playerVolume);
    for (UIButton *b in self.buttons) {
        if (b.tag > 0 && b.tag<= playerVolume) {
            UIImage *buttonImage = [UIImage imageNamed:@"vol_incr.png"];
            [b setBackgroundImage:buttonImage forState:UIControlStateNormal];
        } else if (b.tag > playerVolume){
            UIImage *buttonImage = [UIImage imageNamed:@"vol_dcr.png"];
            [b setBackgroundImage:buttonImage forState:UIControlStateNormal];
        }
    }
}
#pragma mark - End -

#pragma mark - TableView Datasource & Delegate -
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return webinarsOfPresenter.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    NSString *CellIdentifier =@"WebinarSelectedTableViewCell";
//    WebinarSelectedTableViewCell *cell = (WebinarSelectedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    // Configure the cell...
//    if (cell == nil) {
//        cell = [[WebinarSelectedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    NSDictionary *webinarsData = [webinarsOfPresenter objectAtIndex:indexPath.row];
//    if (![Utility isEmptyCheck:webinarsData]) {
//        NSString *eventString = [webinarsData valueForKey:@"EventName"];
//        if (![Utility isEmptyCheck:eventString]) {
//            cell.moreListHeading.text = eventString;
//        }//@"Photo.png"
//        NSString *imageString =[webinarsData valueForKey:@"ImageUrl"];
//        cell.moreListImage.layer.cornerRadius = cell.moreListImage.frame.size.width/2;
//        cell.moreListImage.clipsToBounds = YES;
//        NSString *presenterString =[webinarsData valueForKey:@"PresenterName"];
//        NSDictionary *presenterDict = [defaults valueForKey:@"presenterDict"];
//
//        if (![Utility isEmptyCheck:imageString]) {
//            [cell.moreListImage sd_setImageWithURL:[NSURL URLWithString:[imageString stringByAddingPercentEncodingWithAllowedCharacters:
//                                                                         [NSCharacterSet URLQueryAllowedCharacterSet]]]
//                                  placeholderImage:[UIImage imageNamed:@"Photo.png"] options:SDWebImageScaleDownLargeImages];
//        }else{
//            if (![Utility isEmptyCheck:presenterString] && ![Utility isEmptyCheck:[presenterDict valueForKey:presenterString]]) {
//                [cell.moreListImage sd_setImageWithURL:[NSURL URLWithString:[[@"" stringByAppendingFormat:@"%@/Images/Presenters/%@",BASEURL,[presenterDict valueForKey:presenterString]] stringByAddingPercentEncodingWithAllowedCharacters:
//                                                                             [NSCharacterSet URLQueryAllowedCharacterSet]]]
//                                      placeholderImage:[UIImage imageNamed:@"Photo.png"] options:SDWebImageScaleDownLargeImages];
//            }else{
//                cell.moreListImage.image = [UIImage imageNamed:@"Photo.png"];
//            }
//        }
//
//        if (![Utility isEmptyCheck:presenterString]) {
//            cell.moreListSubheading.text = presenterString;
//        }
//        NSString *descriptionString =[webinarsData valueForKey:@"Content"];
//        if (![Utility isEmptyCheck:descriptionString]) {
//            descriptionString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: %@\";>%@</span>", cell.moreListDetails.font.fontName, cell.moreListDetails.font.pointSize,[Utility hexStringFromColor:cell.moreListDetails.textColor], descriptionString];
//            NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[descriptionString dataUsingEncoding:NSUTF8StringEncoding]
//                                             options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                                       NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
//                                                       }
//                                  documentAttributes:nil error:nil];
//
//            cell.moreListDetails.attributedText = strAttributed;
//        }else{
//            cell.moreListDetails.attributedText = [[NSAttributedString alloc]initWithString:@""];
//        }
//        cell.likeDislike.tag =(int) indexPath.row;
//        cell.watchListButton.tag =(int) indexPath.row;
//        cell.downloadButton.tag = (int) indexPath.row;
//        cell.podcastButton.tag =  (int) indexPath.row;
//        cell.likeDislike.selected = [[webinarsData valueForKey:@"Likes"] boolValue];
//        NSString *likeCountString = [[webinarsData valueForKey:@"LikeCount"] stringValue];
//        if (![Utility isEmptyCheck:likeCountString]) {
//            cell.likeCount.text = likeCountString;
//        }
//        NSArray *eventItemVideoDetailsArray = [webinarsData valueForKey:@"EventItemVideoDetails"];
//        if (eventItemVideoDetailsArray.count > 0) {
//            NSDictionary *eventItemVideoDetails = [eventItemVideoDetailsArray objectAtIndex:0];
//            if (![Utility isEmptyCheck:eventItemVideoDetails]) {
//                cell.watchListButton.selected =  [[eventItemVideoDetails objectForKey:@"IsWatchListVideo"] boolValue];
//            }
//            if (![Utility isEmptyCheck:[eventItemVideoDetails objectForKey:@"DownloadURL" ]]) {
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    NSString *index = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.row];
//
//                    NSURL *video_url = [NSURL URLWithString:[eventItemVideoDetails objectForKey:@"DownloadURL" ]];
//                    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                    NSString* documentsDirectory = [paths objectAtIndex:0];
//                    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[video_url lastPathComponent]];
//                    if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
//                        cell.downloadButton.enabled = true;
//                        cell.progress.hidden = true;
//                        [cell.downloadButton setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];
//                    }else{
//                        if ([[indexPathAndTaskDict allKeys] containsObject:index]) {
//                            cell.downloadButton.enabled =false;
//                            cell.progress.hidden = false;
//                            NSString *taskIndentifire = [indexPathAndTaskDict objectForKey:index];
//                            [backgroundDownloadDict setObject:cell forKey:taskIndentifire];
//                        }else{
//                            cell.downloadButton.enabled =true;
//                            cell.progress.hidden = true;
//                        }
//                        [cell.downloadButton setImage:[UIImage imageNamed:@"w_download.png"] forState:UIControlStateNormal];
//                    }
//                    cell.downloadButton.hidden = false;
//                    cell.downloadButtonConstraint.constant = 25;
//                }];
//
//            }else{
//                cell.downloadButton.hidden = true;
//                cell.downloadButtonConstraint.constant = 0;
//            }
//            if (![Utility isEmptyCheck:[eventItemVideoDetails objectForKey:@"EventItemVideoID"]]) {
//                cell.watchListButton.hidden = false;
//                cell.watchListButtonConstraint.constant = 25;
//
//            }else{
//                cell.watchListButton.hidden = true;
//                cell.watchListButtonConstraint.constant = 0;
//            }
//            NSString *urlString = [eventItemVideoDetails objectForKey:@"PodcastURL" ];
//            if (![Utility isEmptyCheck:urlString]) {
//                cell.podcastButton.hidden = false;
//            }else{
//                cell.podcastButton.hidden = true;
//            }
//        }else{
//            cell.downloadButton.hidden = true;
//            cell.downloadButtonConstraint.constant = 0;
//            cell.watchListButton.hidden = true;
//            cell.watchListButtonConstraint.constant = 0;
//        }
//        NSMutableAttributedString *newString =[[NSMutableAttributedString alloc] init];
//        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//        textAttachment.image = [UIImage imageNamed:@"p_tag.png"];
//        textAttachment.bounds = CGRectMake(0, -3, textAttachment.image.size.width, textAttachment.image.size.height);
//        NSDictionary *attrsDictionary = @{
//                                          NSFontAttributeName : cell.tagView.font,
//                                          NSForegroundColorAttributeName : cell.tagView.textColor
//
//                                          };
//        NSArray *items =[webinarsData valueForKey:@"Tags"];
//        for (int i = 0 ; i<items.count; i++) {
//            NSString *itemsName = [items objectAtIndex:i];
//            itemsName = [[itemsName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
//            NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:[@"" stringByAppendingFormat:@" %@   ",itemsName] attributes:attrsDictionary];
//
//
//
//            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
//
//            [newString appendAttributedString:attrStringWithImage];
//            [newString appendAttributedString:attributedString];
//
//        }
//        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//        [style setLineSpacing:5];
//        [newString addAttribute:NSParagraphStyleAttributeName
//                          value:style
//                          range:NSMakeRange(0, newString.length)];
//        cell.tagView.attributedText = newString;
//
//
//    }
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    dispatch_async(dispatch_get_main_queue(),^ {
//        NSDictionary *webinarsData = [webinarsOfPresenter objectAtIndex:indexPath.row];
//        NSString *eventType = [@"" stringByAppendingFormat:@"%@",webinarsData[@"EventType"] ];
//        NSString *eventName1 = [@"" stringByAppendingFormat:@"%@",webinarsData[@"EventName"] ];
//
//        if (![Utility isEmptyCheck:eventType] && ([eventType isEqualToString:@"14"] || [eventName1 isEqualToString:@"AshyLive"] || [eventType isEqualToString:@"17"] || [eventName1 isEqualToString:@"FridayFoodAndNutrition"] || [eventType isEqualToString:@"16"] || [eventName1 isEqualToString:@"WeeklyWellness"])){
//            NSString *urlString = [webinarsData objectForKey:@"FbAppUrl"];
//            if (![Utility isEmptyCheck:urlString]) {
//                NSURL *url = [NSURL URLWithString:urlString];
//                if ([[UIApplication sharedApplication] openURL:url]){
//                    NSLog(@"well done");
//                }else {
//                    urlString = [webinarsData objectForKey:@"FbUrl"];
//                    if (![Utility isEmptyCheck:urlString]) {
//                        url = [NSURL URLWithString:urlString];
//                        [[UIApplication sharedApplication] openURL:url];
//                    }
//                }
//            }else{
//                urlString = [webinarsData objectForKey:@"FbUrl"];
//                if (![Utility isEmptyCheck:urlString]) {
//                    NSURL *url = [NSURL URLWithString:urlString];
//                    [[UIApplication sharedApplication] openURL:url];
//                }
//            }
//        }else if(![Utility isEmptyCheck:eventType] && [eventType isEqualToString:@"2"]){
//            NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinarsData valueForKey:@"EventItemVideoDetails"]];
//            if (eventItemVideoDetailsArray.count > 0) {
//                NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
//                if (![Utility isEmptyCheck:eventItemVideoDetails]) {
//                    NSString *urlString = [eventItemVideoDetails objectForKey:@"PodcastURL" ];
//                    if (![Utility isEmptyCheck:urlString]) {
//                        PodcastViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Podcast"];
//                        controller.urlString = urlString;
//                        [self.navigationController pushViewController:controller animated:YES];
//                    }
//                }
//            }
//        }else{
//            webinar = [webinarsData mutableCopy];
//            [self getWebinarDetails:[webinar valueForKey:@"PresenterName"]];
//
//        }
//
//    });
//}

#pragma mark - end -


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
            self->eventDownloadButton.enabled = false;
            self->eventProgress.hidden = true;
            if (success) {
                if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                    [self addUpdateDB];
                    self->eventDownloadButton.enabled = true;
                    self->eventProgress.hidden = true;
                    self->eventstatus.text = @"Download finished successfully.";
                    self->eventstatus.hidden = false;
                    [self->eventDownloadButton setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];
                }else{
                    [self->eventDownloadButton  setImage:[UIImage imageNamed:@"w_download.png"] forState:UIControlStateNormal];
                }
            }
            else{
                self->eventstatus.text = [error localizedDescription];
                self->eventstatus.hidden = false;
                
                NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
            }
        }else{
            WebinarSelectedTableViewCell *cell = (WebinarSelectedTableViewCell *)[backgroundDownloadDict objectForKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]];
            cell.downloadButton.enabled = false;
            cell.progress.hidden = true;
            if (success) {
                if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                    cell.downloadButton.enabled = true;
                    cell.progress.hidden = true;
                    cell.status.text = @"Download finished successfully.";
                    cell.status.hidden = false;
                    [cell.downloadButton setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];

                }else{
                    [cell.downloadButton  setImage:[UIImage imageNamed:@"w_download.png"] forState:UIControlStateNormal];
                }
            }
            else{
                cell.status.text = [error localizedDescription];
                cell.status.hidden = false;
                
                NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
            }
           
            [backgroundDownloadDict removeObjectForKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]];
            if ([indexPathAndTaskDict allKeysForObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]].count > 0) {
                [indexPathAndTaskDict removeObjectForKey:[[indexPathAndTaskDict allKeysForObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]]objectAtIndex:0]];
            }
        }
        if (success) {
            if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
//                [self UpdateEventItemVideoTime];
            }
        }
        
    }];
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if ([task isEqual:eventDownloadTask]) {
            eventDownloadButton.enabled = false;
            eventProgress.hidden = true;
            eventstatus.hidden = false;
            if (error != nil) {
                eventstatus.text = [@"" stringByAppendingFormat:@"Download completed with error: %@",[error localizedDescription]];
                NSLog(@"Download completed with error: %@", [error localizedDescription]);
            }
            else{
                eventstatus.text = @"Download finished successfully.";
                NSLog(@"Download finished successfully.");
            }

        }else{
            WebinarSelectedTableViewCell *cell = (WebinarSelectedTableViewCell *)[backgroundDownloadDict objectForKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)task.taskIdentifier]];
            cell.downloadButton.enabled = false;
            cell.progress.hidden = true;
            cell.status.hidden = false;
            if (error != nil) {
                cell.status.text = [@"" stringByAppendingFormat:@"Download completed with error: %@",[error localizedDescription]];
                NSLog(@"Download completed with error: %@", [error localizedDescription]);
            }
            else{
                cell.status.text = @"Download finished successfully.";
                NSLog(@"Download finished successfully.");
            }
            [backgroundDownloadDict removeObjectForKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)task.taskIdentifier]];
            if ([indexPathAndTaskDict allKeysForObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)task.taskIdentifier]].count > 0) {
                [indexPathAndTaskDict removeObjectForKey:[[indexPathAndTaskDict allKeysForObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)task.taskIdentifier]]objectAtIndex:0]];
            }
        }
    }];
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if ([downloadTask isEqual:eventDownloadTask]) {
            if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
                NSLog(@"Unknown transfer size");
                eventstatus.text = @"Unknown transfer size";
                eventstatus.hidden = false;
                eventProgress.hidden= true;
                
            }else{
                double downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
                eventProgress.progress= downloadProgress;
                eventstatus.hidden = false;
            }
        }else{
            WebinarSelectedTableViewCell *cell = (WebinarSelectedTableViewCell *)[backgroundDownloadDict objectForKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]];
            
            if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
                NSLog(@"Unknown transfer size");
                cell.status.text = @"Unknown transfer size";
                cell.status.hidden = false;
                cell.progress.hidden= true;
                
            }else{
                double downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
                cell.progress.progress= downloadProgress;
                cell.status.hidden = false;
            }
        }
       
    }];
}


-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    
    // Check if all download tasks have been finished.
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        if ([downloadTasks count] == 0) {
            if (appDelegate.backgroundTransferCompletionHandler != nil) {
                // Copy locally the completion handler.
                void(^completionHandler)() = appDelegate.backgroundTransferCompletionHandler;
                
                // Make nil the backgroundTransferCompletionHandler.
                appDelegate.backgroundTransferCompletionHandler = nil;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    [defaults removeObjectForKey:@"indexPathAndTaskDictWebnairDetails"];
                    
                    // Show a local notification when all downloads are over.
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    localNotification.alertBody = @"All files have been downloaded!";
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }];
            }
        }
    }];
    [self.session1 getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        if ([downloadTasks count] == 0) {
            if (appDelegate.backgroundTransferCompletionHandler != nil) {
                // Copy locally the completion handler.
                void(^completionHandler)() = appDelegate.backgroundTransferCompletionHandler;
                
                // Make nil the backgroundTransferCompletionHandler.
                appDelegate.backgroundTransferCompletionHandler = nil;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    // Show a local notification when all downloads are over.
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    localNotification.alertBody = @"All files have been downloaded!";
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }];
            }
        }
    }];

}



#pragma mark - WebView Delegate
    - (void)webViewDidFinishLoad:(UIWebView *)webView1{
        if (contentView) {
            [contentView removeFromSuperview];
        }
    }
    - (void)webView:(UIWebView *)webView1 didFailLoadWithError:(NSError *)error{
        if (contentView) {
            [contentView removeFromSuperview];
        }
        [Utility msg:@"Something went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:YES];
        
    }
#pragma mark - End



#pragma mark - TableViewDatasource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return addDropdownList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    if (![Utility isEmptyCheck:addDropdownList] && addDropdownList.count>0) {
        NSDictionary *dict = [addDropdownList objectAtIndex:indexPath.row];
        if (![Utility isEmptyCheck:dict]) {
            if (![Utility isEmptyCheck:[dict objectForKey:@"EventName"]]) {
                cell.guidedMeditationTitle.text = [dict objectForKey:@"EventName"];
            }else{
                cell.guidedMeditationTitle.text = @"";

            }
        }
    }
    if (isDefaultSelect) {
        if (indexPath.row == 0) {
            cell.checkUncheckButton.selected = true;
        }else{
            cell.checkUncheckButton.selected = false;
        }
    }else if(isfromDropDown){
            cell.checkUncheckButton.selected = false;
    }else{
        if (indexValue == indexPath.row) {
             cell.checkUncheckButton.selected = true;
        }else{
             cell.checkUncheckButton.selected = false;
        }
    }
  
    

    if (isDefaultSelect) {
        indexValue = 0;
        isDefaultSelect = false;
    }
    if (isfromDropDown) {
        isfromDropDown = false;
    }
    cell.minusButton.tag = indexPath.row;
    cell.checkUncheckButton.tag = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


#pragma mark - AVPlayerViewController Delegate
- (void)playerViewController:(AVPlayerViewController *)playerViewController willEndFullScreenPresentationWithAnimationCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    videoStartTime=CMTimeGetSeconds(avplayerViewController.player.currentTime);
    [appDelegate.playerController.player seekToTime:avplayerViewController.player.currentTime];
    if (avplayerViewController.player.rate>0) {
        [appDelegate.playerController.player play];
        playPauseButton.selected = true;
        
    }else{
        [appDelegate.playerController.player pause];
        playPauseButton.selected = false;
    }
    
}

#pragma mark - End

#pragma mark - PopoverViewDelegate
- (void)didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)data{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(GuidedMeditationDescription =%@)",type];
    NSArray *filterArray = [dropDownListArray filteredArrayUsingPredicate:predicate];
    selectedIndex = [dropDownListArray indexOfObject:[filterArray objectAtIndex:0]];
    [addDropdownList addObjectsFromArray:filterArray];
    if (indexValue>=0) {
        isfromDropDown = false;
    }else{
        isfromDropDown = true;
    }
    if (addDropdownList.count>0) {
        searchTableSuperView.hidden = false;
    }
    [searchTableView reloadData];
}
-(void)didCancelDropdownOption{
}


@end












