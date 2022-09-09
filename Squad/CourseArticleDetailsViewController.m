//
//  CourseArticleDetailsViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 23/02/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CourseArticleDetailsViewController.h"
#import "Utility.h"
#import "MasterMenuViewController.h"
#import "PrivacyPolicyAndTermsServiceViewController.h"
#import "AppDelegate.h"
#define visualizerAnimationDuration 0.01

@interface CourseArticleDetailsViewController () {
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *detailsHeadingLabel;
    IBOutlet UILabel *detailsLabel;
    IBOutlet UIButton *favouriteButton;
    
    IBOutlet UIStackView *attachmentStackView;
    IBOutlet UIButton *topDisplayTickUntickButton;
    IBOutlet UIButton *tickUntickButton;
    IBOutlet UIButton *belowTickUntickButton;
    IBOutlet UILabel *taskLabel;
    IBOutlet UIView *taskViewBorder;
    UIView *contentView;
    NSMutableDictionary *dataDict;
    
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UISlider *eventSlider;
    IBOutlet UILabel *totalTimeLabel;
    IBOutlet UILabel *currentTimeLabel;
    
    IBOutlet UILabel *eventstatus;
    IBOutlet UIProgressView *eventProgress;
    IBOutlet UIButton *eventDownloadButton;
    IBOutlet UIButton *eventAttachmentButton;
    
    NSURLSessionDownloadTask *eventDownloadTask;
    NSMutableDictionary *backgroundDownloadDict;
    NSMutableDictionary *indexPathAndTaskDict;
    AppDelegate *appDelegate;
    __weak IBOutlet UILabel *courseName;
    __weak IBOutlet UIButton *fullScreenButton;
    
    IBOutlet UIView *attachmentView;
    
    IBOutlet UIButton *backwardButton;
    IBOutlet UIButton *playPauseBtn;
    
    IBOutlet UIButton *forwardButton;
    IBOutlet UIView *progressBarView;
    IBOutlet UIView *videoView;
    IBOutlet UIView *favouriteView;
    IBOutlet UIStackView *playStackView;
    double videoStartTime;
    IBOutlet UIWebView *webView;
    IBOutlet UIView *soundCloudAudioView;
    AVPlayerViewController *avplayerViewController;
    NSTimer *visualizerTimer;
    double lowPassReslts;
    double lowPassReslts1;
    IBOutlet UIImageView *courseImage;
    IBOutlet UIView *courseImageSubView;
    
    IBOutlet UIView *separator1;
    IBOutlet UIView *viewTodo;
    IBOutlet UIView *separator2;
    IBOutlet UIView *taskView;
    
    
}

@end

@implementation CourseArticleDetailsViewController
@synthesize taskId,courseArticleDelegate,imageUrl;

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //RU
    NSLog(@"***AutherName**** :: %@", self->_autherStr);
    
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
    
    //Tick/UnTick Button
    //Top
    [self->tickUntickButton setBackgroundColor:[UIColor colorWithRed:50/255.0f green:205/255.0f blue:184/255.0f alpha:1.0f]];
    self->tickUntickButton.layer.borderColor = [UIColor colorWithRed:50.0/255.0f green:205.0/255.0f blue:184.0/255.0f alpha:1.0f].CGColor;
    self->tickUntickButton.clipsToBounds = YES;
    self->tickUntickButton.layer.borderWidth = 1.2;
    self->tickUntickButton.layer.cornerRadius = tickUntickButton.frame.size.height/2.0;
    
    //Bottom
    [self->belowTickUntickButton setBackgroundColor:[UIColor colorWithRed:50/255.0f green:205/255.0f blue:184/255.0f alpha:1.0f]];
    self->belowTickUntickButton.layer.borderColor = [UIColor colorWithRed:50.0/255.0f green:205.0/255.0f blue:184.0/255.0f alpha:1.0f].CGColor;
    self->belowTickUntickButton.clipsToBounds = YES;
    self->belowTickUntickButton.layer.borderWidth = 1.2;
    self->belowTickUntickButton.layer.cornerRadius = belowTickUntickButton.frame.size.height/2.0;
    
    //ProgressBar
    [eventSlider setMinimumTrackTintColor:[UIColor colorWithRed:(50/255.0) green:(205/255.0) blue:(184/255.0) alpha:1]];
    [eventSlider setMaximumTrackTintColor:[UIColor colorWithRed:(50/255.0) green:(205/255.0) blue:(184/255.0) alpha:1]];
    UIImage *thumbImage = [UIImage imageNamed:@"progressbar_line.png"];
    [eventSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    
    
    dataDict = [[NSMutableDictionary alloc] init];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.TheSquatCourses"];
    sessionConfiguration.allowsCellularAccess = YES;
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 1;
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil];
    
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"RunningVideoSection"]]) {
         if ([[defaults objectForKey:@"RunningVideoSection"] isEqualToString:@"Meditation"]){
            if (![Utility isEmptyCheck:[defaults objectForKey:@"PlayingMeditation"]]) {
                NSString *webinarstr=[defaults objectForKey:@"PlayingMeditation"];
                NSData *data = [webinarstr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                CMTime startTime = appDelegate.playerController.player.currentTime;
                double videoStartTime = CMTimeGetSeconds(startTime);
//                [Utility updateWebinarVideoTime:dict videoStartTime:videoStartTime];
                [Utility saveWebinarVideoStartTimeIntoTable:dict videoStartTime:videoStartTime];
                
                [defaults removeObjectForKey:@"PlayingMeditation"];
            }
             [self getData];
         }else if ([[defaults objectForKey:@"RunningVideoSection"] isEqualToString:@"Course"]){
             if (![Utility isEmptyCheck:[defaults objectForKey:@"PlayingCourse"]]) {
                 NSString *courseStr=[defaults objectForKey:@"PlayingCourse"];
                 NSData *data = [courseStr dataUsingEncoding:NSUTF8StringEncoding];
                 NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                 
                 if ([dict objectForKey:@"ArticleId"]==_articleId && [dict objectForKey:@"CourseId"]==_courseId) {
                     CMTime startTime = appDelegate.playerController.player.currentTime;
                     videoStartTime = CMTimeGetSeconds(startTime);
                     if (![Utility isEmptyCheck:[dict objectForKey:@"DataDict"]]) {
                         dataDict=[[dict objectForKey:@"DataDict"] mutableCopy];
                     }
                     [self prepareViews];
                 }else{
                     CMTime startTime = appDelegate.playerController.player.currentTime;
                     double videoStartTime = CMTimeGetSeconds(startTime);
                     [Utility updateCourseVideoTime:dict videoStartTime:videoStartTime];
                     [defaults removeObjectForKey:@"PlayingCourse"];
                     [defaults removeObjectForKey:@"RunningVideoSection"];
                     [self getData];
                 }
             }
         }
    }else{
         [self getData];
    }
    
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
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
    
}
-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
//    [appDelegate.FBWAudioPlayer pause];
    
    if (appDelegate.FBWAudioPlayer.rate>0 ) {
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:_articleId forKey:@"ArticleId"];
        [mainDict setObject:_courseId forKey:@"CourseId"];
        
        if (![Utility isEmptyCheck:_autherStr]) {
            [mainDict setObject:_autherStr forKey:@"AutherStr"];
        }else{
            [mainDict setObject:@"" forKey:@"AutherStr"];
        }
        
        if (![Utility isEmptyCheck:taskId]) {
            [mainDict setObject:taskId forKey:@"TaskId"];
        }else{
            [mainDict setObject:@"" forKey:@"TaskId"];
        }
        if (![Utility isEmptyCheck:dataDict]) {
            [mainDict setObject:dataDict forKey:@"DataDict"];
        }else{
            [mainDict setObject:@"" forKey:@"DataDict"];
        }
        
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [appDelegate.FBWAudioPlayer pause];
            NSLog(@"Error -- %@",error.debugDescription);
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        [defaults setObject:jsonString forKey:@"PlayingCourse"];
        [defaults setObject:@"Course" forKey:@"RunningVideoSection"];
    }else{
//        [appDelegate.FBWAudioPlayer pause];
        if (![Utility isEmptyCheck:[defaults objectForKey:@"PlayingCourse"]]) {
            [defaults removeObjectForKey:@"PlayingCourse"];
        }
        if (![Utility isEmptyCheck:[defaults objectForKey:@"RunningVideoSection"]]) {
            [defaults removeObjectForKey:@"RunningVideoSection"];
        }
    }
    
    if (videoStartTime>0) {
        [self updateVideoTime];
    }
    if (_audioPlayer) {
        _audioPlayer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - API Call
-(void) saveDataIsRead:(BOOL) isArticleRead {
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
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:_articleId forKey:@"ArticleId"];
        [mainDict setObject:_courseId forKey:@"CourseId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSString *api;
        if (isArticleRead) {
            api = @"UnreadArticle";
        } else {
            api = @"ArticleRead";
        }
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:api append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         if ([[responseDict objectForKey:@"IsSuccess"] boolValue]) {
                                                                             //
                                                                             /* commenting chayan
                                                                             [self->tickUntickButton setTitle:@"DONE" forState:UIControlStateNormal];
                                                                             self->tickUntickButton.layer.borderColor = [UIColor colorWithRed:50.0/255.0f green:205.0/255.0f blue:184.0/255.0f alpha:1.0f].CGColor;
                                                                             self->tickUntickButton.clipsToBounds = YES;
                                                                             self->tickUntickButton.layer.borderWidth = 1.2;
                                                                             self->tickUntickButton.layer.cornerRadius = self->tickUntickButton.frame.size.height/2.0;
                                                                             
                                                                             [self->belowTickUntickButton setTitle:@"DONE" forState:UIControlStateNormal];
                                                                             
                                                                             self->belowTickUntickButton.layer.borderColor = [UIColor colorWithRed:50.0/255.0f green:205.0/255.0f blue:184.0/255.0f alpha:1.0f].CGColor;
                                                                             self->belowTickUntickButton.clipsToBounds = YES;
                                                                             self->belowTickUntickButton.layer.borderWidth = 1.2;
                                                                             self->belowTickUntickButton.layer.cornerRadius = self->belowTickUntickButton.frame.size.height/2.0;
                                                                             */
                                                                             [self setTickItOffButton:self->tickUntickButton isRead:YES];
                                                                             [self setTickItOffButton:self->belowTickUntickButton isRead:YES];
                                                                             
                                                                         }else
                                                                         {
                                                                             /* commenting - chayan
                                                                             [self->tickUntickButton setTitle:@"TICK IT OFF" forState:UIControlStateNormal];
                                                                             [self->tickUntickButton setBackgroundColor:[UIColor colorWithRed:50.0/255.0f green:205.0/255.0f blue:184.0/255.0f alpha:1.0f]];
                                                                             self->tickUntickButton.layer.borderColor = [UIColor colorWithRed:50.0/255.0f green:205.0/255.0f blue:184.0/255.0f alpha:1.0f].CGColor;
                                                                             self->tickUntickButton.clipsToBounds = YES;
                                                                             self->tickUntickButton.layer.borderWidth = 1.2;
                                                                             self->tickUntickButton.layer.cornerRadius = self->tickUntickButton.frame.size.height/2.0;
                                                                             
                                                                             [self->belowTickUntickButton setTitle:@"TICK IT OFF" forState:UIControlStateNormal];
                                                                             [self->belowTickUntickButton setBackgroundColor:[UIColor colorWithRed:50.0/255.0f green:205.0/255.0f blue:184.0/255.0f alpha:1.0f]];
                                                                             self->belowTickUntickButton.layer.borderColor = [UIColor colorWithRed:50.0/255.0f green:205.0/255.0f blue:184.0/255.0f alpha:1.0f].CGColor;
                                                                             self->belowTickUntickButton.clipsToBounds = YES;
                                                                             self->belowTickUntickButton.layer.borderWidth = 1.2;
                                                                             self->belowTickUntickButton.layer.cornerRadius = self->belowTickUntickButton.frame.size.height/2.0;
                                                                              */
                                                                             [self setTickItOffButton:self->tickUntickButton isRead:NO];
                                                                             [self setTickItOffButton:self->belowTickUntickButton isRead:NO];
                                                                             
                                                                             
                                                                         }
                                                                         if (![Utility isEmptyCheck:self->taskId]) {
                                                                             [self updateTask:self->taskId isDone:[[responseDict objectForKey:@"IsSuccess"] boolValue]];
                                                                         }else{
                                                                             if ([self->courseArticleDelegate respondsToSelector:@selector(didCheckAnyChangeForCourseArticle:)]) {
                                                                                 [self->courseArticleDelegate didCheckAnyChangeForCourseArticle:true];
                                                                             }
                                                                             [self getData];
                                                                         }
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
-(void)updateTask:(NSNumber *)tId isDone:(BOOL)isDone{
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
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:tId forKey:@"TaskId"];
        [mainDict setObject:[NSNumber numberWithBool:isDone] forKey:@"IsDone"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateMbhqTaskApiCall" append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         if ([self->courseArticleDelegate respondsToSelector:@selector(didCheckAnyChangeForCourseArticle:)]) {
                                                                             [self->courseArticleDelegate didCheckAnyChangeForCourseArticle:true];
                                                                         }
                                                                         [self getData];
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
-(void) getData {
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
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:_articleId forKey:@"ArticleId"];
        [mainDict setObject:_courseId forKey:@"CourseId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMbhqArticleDetail" append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         [self->dataDict addEntriesFromDictionary:[responseDict objectForKey:@"Article"]];
                                                                         
                                                                         if (![Utility isEmptyCheck:[dataDict objectForKey:@"PublicVideoUrls"]] && ![Utility isEmptyCheck:[[dataDict objectForKey:@"PublicVideoUrls"] objectAtIndex:0]]) {
                                                                             if (![Utility isEmptyCheck:[self->dataDict objectForKey:@"Videos"]] && ![Utility isEmptyCheck:[self->dataDict objectForKey:@"VideoWithTime"]]) {
                                                                                 NSString* videoId=[[self->dataDict objectForKey:@"Videos"] objectAtIndex:0];
                                                                                 NSArray *timeArr=[self->dataDict objectForKey:@"VideoWithTime"];
                                                                                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(VideoUrl==%@)",videoId];
                                                                                 NSArray *tmp=[timeArr filteredArrayUsingPredicate:predicate];
                                                                                 if (![Utility isEmptyCheck:tmp]) {
                                                                                    self->videoStartTime = [[[tmp objectAtIndex:0] objectForKey:@"Time"] doubleValue];
                                                                                 }
                                                                             }
                                                                             
                                                                         }else if (![Utility isEmptyCheck:[self->dataDict objectForKey:@"Audios"]] && ![Utility isEmptyCheck:[[self->dataDict objectForKey:@"Audios"] objectAtIndex:0]]){
                                                                             if (![Utility isEmptyCheck:[self->dataDict objectForKey:@"Time"]]) {
                                                                             double currentTime = [[NSString stringWithFormat:@"%@",[self->dataDict objectForKey:@"Time"]]doubleValue];
                                                                                 self->videoStartTime=currentTime;
                                                                             }
                                                                         }
                                                                         //FIREBASELOG
                                                                         [FIRAnalytics logEventWithName:@"join_group" parameters:@{
                                                                                                                                   @"week_course_8":[self->dataDict objectForKey:@"ArticleTitle"] }];
                                                                         [self prepareViews];
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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

-(void)updateVideoTime{
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
        //        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:_articleId forKey:@"ArticleId"];
        //        [mainDict setObject:_courseId forKey:@"CourseId"];
        NSNumber *videoId = [[dataDict objectForKey:@"Videos"]objectAtIndex:0];
        [mainDict setObject:videoId forKey:@"VideoId"];
        [mainDict setObject:[NSString stringWithFormat:@"%f",videoStartTime] forKey:@"Time"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateVideoTime" append:@"" forAction:@"POST"];
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
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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







#pragma -mark IBAction

- (IBAction)downloadButtonPressed:(UIButton *)sender {
    
    if (![Utility isEmptyCheck:dataDict]) {
        NSString * videoUrlString = [[dataDict objectForKey:@"PublicVideoUrls"] objectAtIndex:0];
        if (![Utility isEmptyCheck:videoUrlString]) {
            NSURL *video_url = [NSURL URLWithString:videoUrlString];
            if([video_url absoluteString].length < 1) {
                return;
            }
            NSLog(@"source will be : %@", video_url.absoluteString);
            NSURL *sourceURL = video_url;
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* documentsDirectory = [paths objectAtIndex:0];
            NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];
            NSLog(@"fullPathToFile=%@",fullPathToFile);
            if (appDelegate.FBWAudioPlayer) {
                [appDelegate.FBWAudioPlayer pause];
                appDelegate.FBWAudioPlayer = nil;
            }
            
            if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                NSURL *fileURL = [NSURL fileURLWithPath:fullPathToFile];
                AVPlayer *playerForDownloadedVideo = [AVPlayer playerWithURL:fileURL];
                AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
                [self presentViewController:controller animated:YES completion:nil];
                controller.view.frame = self.view.frame;
                controller.player = playerForDownloadedVideo;
                controller.showsPlaybackControls = YES;
                [playerForDownloadedVideo play];
                return;
            }
            [Utility msg:@"This video have started downloading , will be available for playing locally" title:@"Alert" controller:self haveToPop:NO];
            
            [UIView animateWithDuration:0.3/1 animations:^{
                sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.7, 1.7);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3/1.5 animations:^{
                    sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3/1.5 animations:^{
                        sender.transform = CGAffineTransformIdentity;
                        [sender setBackgroundColor:[UIColor clearColor]];
                        
                    }];
                }];
            }];
            if(Utility.reachable){
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    sender.enabled = false;
                    self->eventDownloadTask = [self.session downloadTaskWithURL:sourceURL];
                    self->eventProgress.hidden = false;
                    [self->eventDownloadTask resume];
                }];
            }else{
                [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
            }
        }
    }
    
}

-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

-(IBAction)backButtonPressed:(id)sender{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[CourseDetailsViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    CoursesListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CoursesList"];
    [self.navigationController pushViewController:controller animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)doneButtonTapped:(id)sender {
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }// AY 19032018
    [self saveDataIsRead:[[dataDict objectForKey:@"IsRead"] boolValue]];
}
- (IBAction)topTickUntickButtonPressed:(UIButton *)sender {
}
-(IBAction)attachmentTapped:(UIButton*)sender {
    if ([[[dataDict objectForKey:@"Attachments"] objectAtIndex:[sender tag]] isKindOfClass:[NSString class]]) {
        NSString *urlStr = [[dataDict objectForKey:@"Attachments"] objectAtIndex:[sender tag]];
        if (![Utility isEmptyCheck:urlStr]) {
            PrivacyPolicyAndTermsServiceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PrivacyPolicyAndTermsService"];
            controller.modalPresentationStyle = UIModalPresentationCustom;
            controller.url=[NSURL URLWithString:urlStr];
            controller.isFromCourse=YES;
            [self presentViewController:controller animated:YES completion:nil];
            //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlStr]];
        }else{
            [Utility msg:@"Attachment can't be open" title:@"Oops!" controller:self haveToPop:NO];
        }
    } else {
        [Utility msg:@"Attachment can't be open" title:@"Oops!" controller:self haveToPop:NO];
    }
}

- (IBAction)fullScreenPressed:(UIButton *)sender {
    NSString * videoUrlString = [[dataDict objectForKey:@"PublicVideoUrls"] objectAtIndex:0];
    if (![Utility isEmptyCheck:videoUrlString]) {
        NSURL *fileURL = [NSURL URLWithString:videoUrlString];
        if([fileURL absoluteString].length < 1) {
            return;
        }
        
        CMTime startTime=appDelegate.playerController.player.currentTime;
        UIButton *btn;
        if (playPauseBtn.selected) {
            [self playPauseBtnPressed:btn];
        }
        
        
        
//        playPauseBtn.selected = false;
//        CMTime startTime=appDelegate.playerController.player.currentTime;
//        if (appDelegate.FBWAudioPlayer) {
//            [appDelegate.FBWAudioPlayer pause];
//            appDelegate.FBWAudioPlayer = nil;
//
//        }
        
        
        
        //        NSURL *fileURL = video_url;
        @try {
            //            AVPlayer *playerForDownloadedVideo = appDelegate.FBWAudioPlayer;
            //            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
           
            AVPlayer *playerForDownloadedVideo = [[AVPlayer alloc]initWithURL:fileURL];
            avplayerViewController = [[AVPlayerViewController alloc]init];
//            [self presentViewController:controller animated:YES completion:nil];
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

- (IBAction)attachmentViewPressed:(UIButton *)sender
{
    attachmentView.hidden = NO;
}

- (IBAction)attachmentClosePressed:(UIButton *)sender
{
    attachmentView.hidden = YES;
    
}
- (IBAction)playPauseBtnPressed:(UIButton *)sender
{
    playPauseBtn.selected = !playPauseBtn.selected;
//
//    if(playPauseBtn.selected)
//    {
//        [appDelegate.playerController.player play];
//    }
//    else
//    {
//        [appDelegate.playerController.player pause];
//    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self->playPauseBtn.selected)
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
                        [self->appDelegate.playerController.player play];
                    }];
                }
                
                if(self->_audioPlayer){
                    
                   [self->_audioPlayer setCurrentTime:audioPlaytime];
                }
                
            }else{
                [self->appDelegate.playerController.player play];
            }
             if(self->_audioPlayer){
                self->_audioPlayer.delegate = self;
                [self->_audioPlayer prepareToPlay];
                [self->_audioPlayer setVolume:0];
                [self->_audioPlayer play];
                [self startAudioVisualizer];
             }
            
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
            
        }
        else
        {
            [self->appDelegate.playerController.player pause];
            if(self->_audioPlayer){
                [self->_audioPlayer pause];
                [self stopAudioVisualizer];
            }
            CMTime startTime = self->appDelegate.playerController.player.currentTime;
            self->videoStartTime = CMTimeGetSeconds(startTime);
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
        }
    });
}


- (IBAction)eventSliderValueChanged:(UISlider *)sender
{
    [appDelegate.playerController.player pause];
    float progressBarValue = eventSlider.value;
    CMTime playerDuration = appDelegate.playerController.player.currentItem.asset.duration;
    double duration = CMTimeGetSeconds(playerDuration);
    CMTime newTime = CMTimeMakeWithSeconds(progressBarValue * duration, appDelegate.playerController.player.currentTime.timescale);
    [appDelegate.playerController.player seekToTime:newTime];
    [appDelegate.playerController.player play];
    playPauseBtn.selected = true;
    double currentTime = CMTimeGetSeconds(newTime);
    [_audioPlayer setCurrentTime:currentTime];
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
    
    playPauseBtn.selected = true;
    
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
    playPauseBtn.selected = true;
}

#pragma mark - Private Methods
-(void)PlayPauseButtonPressed{
    
        playPauseBtn.selected = !playPauseBtn.selected;
    //
    //    if(playPauseBtn.selected)
    //    {
    //        [appDelegate.playerController.player play];
    //    }
    //    else
    //    {
    //        [appDelegate.playerController.player pause];
    //    }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self->playPauseBtn.selected)
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
                            [self->appDelegate.playerController.player play];
                        }];
                    }
                    
                    if(self->_audioPlayer){
                        
                       [self->_audioPlayer setCurrentTime:audioPlaytime];
                    }
                    
                }else{
                    [self->appDelegate.playerController.player play];
                }
                 if(self->_audioPlayer){
                    self->_audioPlayer.delegate = self;
                    [self->_audioPlayer prepareToPlay];
                    [self->_audioPlayer setVolume:0];
                    [self->_audioPlayer play];
                    [self startAudioVisualizer];
                 }
                
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
                self->contentView = [Utility activityIndicatorView:self];
                
            }
            else
            {
                [self->appDelegate.playerController.player pause];
                if(self->_audioPlayer){
                    [self->_audioPlayer pause];
                    [self stopAudioVisualizer];
                }
                CMTime startTime = self->appDelegate.playerController.player.currentTime;
                self->videoStartTime = CMTimeGetSeconds(startTime);
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
            }
        });
    
}
-(void)setTickItOffButton:(UIButton *)btn isRead:(bool)isRead{
    if (isRead) {
        [btn setTitle:@"DONE" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:147.0/255.0f green:226.0/255.0f blue:226.0/255.0f alpha:1.0f]];
        btn.layer.borderColor = [UIColor colorWithRed:147.0/255.0f green:226.0/255.0f blue:226.0/255.0f alpha:1.0f].CGColor;
        btn.clipsToBounds = YES;
        btn.layer.borderWidth = 1.2;
        btn.layer.cornerRadius = btn.frame.size.height/2.0;
    }else{
        [btn setTitle:@"TICK IT OFF" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:147.0/255.0f green:226.0/255.0f blue:221.0/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.borderColor = [UIColor colorWithRed:147.0/255.0f green:226.0/255.0f blue:221.0/255.0f alpha:1.0f].CGColor;
        btn.clipsToBounds = YES;
        btn.layer.borderWidth = 1.2;
        btn.layer.cornerRadius = btn.frame.size.height/2.0;
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
    if(visualizerTimer && visualizerTimer.isValid) return;
    soundCloudAudioView.hidden = false;
    [visualizerTimer invalidate];
    visualizerTimer = nil;
    visualizerTimer = [NSTimer scheduledTimerWithTimeInterval:visualizerAnimationDuration target:self selector:@selector(visualizerTimer:) userInfo:nil repeats:YES];

}
- (void) stopAudioVisualizer
{
    soundCloudAudioView.hidden = true;
    [visualizerTimer invalidate];
    visualizerTimer = nil;
    [_audioVisualizer stopAudioVisualizer];
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

- (void)syncScrubber
{

    CMTime playerDuration = appDelegate.playerController.player.currentItem.asset.duration;
    if (CMTIME_IS_INVALID(playerDuration))
    {
        eventSlider.minimumValue = 0.0;
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration) && (duration > 0))
    {
        float minValue = [ eventSlider minimumValue];
        float maxValue = [ eventSlider maximumValue];
        double time = CMTimeGetSeconds([appDelegate.playerController.player currentTime]);
        if (time>0) {
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
        }
        [eventSlider setValue:(maxValue - minValue) * time / duration + minValue];
        
        NSUInteger dMinutes = floor((NSUInteger)duration / 60);
        NSUInteger dSeconds = floor((NSUInteger)duration % 3600 % 60);
        NSString *videoDurationText = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
        totalTimeLabel.text = videoDurationText;
        
    }
    
    //time label
    NSUInteger playerTime = CMTimeGetSeconds(appDelegate.playerController.player.currentTime);
    NSUInteger dMinutes = floor(playerTime / 60);
    NSUInteger dSeconds = floor(playerTime % 3600 % 60);
//    self->videoStartTime = dSeconds;
    
    NSString *videoDurationText = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
    currentTimeLabel.text = videoDurationText;
    if ([totalTimeLabel.text isEqualToString:currentTimeLabel.text]) {
        [self playPauseBtnPressed:playPauseBtn];
    }
}


-(void) prepareViews {
    titleLabel.text = [dataDict objectForKey:@"ArticleTitle"];
    nameLabel.text = self->_autherStr;
    courseName.text = [dataDict objectForKey:@"ArticleTitle"];
    
    
    //-------
    if (![Utility isEmptyCheck:[dataDict objectForKey:@"PublicVideoUrls"]] && ![Utility isEmptyCheck:[[dataDict objectForKey:@"PublicVideoUrls"] objectAtIndex:0]]) {//change_new_240318
        
        //if(![Utility isEmptyCheck:[[dataDict objectForKey:@"PublicVideoUrls"] objectAtIndex:0]]){
            [self playVideoFromUrl:[[dataDict objectForKey:@"PublicVideoUrls"] objectAtIndex:0] isAudio:NO];
            progressBarView.hidden = NO;
            videoView.hidden = NO;
            courseImageSubView.hidden=YES;
            eventDownloadButton.hidden = NO;
            playStackView.hidden = NO;
            soundCloudAudioView.hidden = true;
        //}
        
    }else if (![Utility isEmptyCheck:[dataDict objectForKey:@"Audios"]] && ![Utility isEmptyCheck:[[dataDict objectForKey:@"Audios"] objectAtIndex:0]]){
        /*
                soundCloudAudioView.hidden = false;
                progressBarView.hidden = true;
                videoView.hidden = YES;
                eventDownloadButton.hidden = YES;
                playStackView.hidden = YES;
                
                    if ([Utility reachable]) {
                        if (contentView) {
                            [contentView removeFromSuperview];
                        }
                        contentView = [Utility activityIndicatorView:self];
                        
                        NSString *urlStr = [[dataDict objectForKey:@"Audios"] objectAtIndex:0];
                        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"hide_related=false" withString:@"hide_related=true"];
                        
                        NSURL *targetURL = [NSURL URLWithString:urlStr];
                        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
                        [webView loadRequest:request];
                        [webView setScalesPageToFit:YES];
                        webView.mediaPlaybackRequiresUserAction = NO;
                    }*/

        [self initAudioVisualizer];
       [self playVideoFromUrl:[[dataDict objectForKey:@"Audios"] objectAtIndex:0] isAudio:YES];
        progressBarView.hidden = NO;
        videoView.hidden = YES;
        courseImageSubView.hidden=NO;
        eventDownloadButton.hidden = NO;
        playStackView.hidden = NO;
        //soundCloudAudioView.hidden = false;
        
        
    }
    else{
        progressBarView.hidden = YES;
        videoView.hidden = YES;
        courseImageSubView.hidden=NO;
        eventDownloadButton.hidden = YES;
        playStackView.hidden = YES;
        soundCloudAudioView.hidden = true;
    }
    //-------
    
    
    courseImage.layer.cornerRadius = 15;
    courseImage.clipsToBounds=YES;
    if (![Utility isEmptyCheck:imageUrl]) {
        [courseImage sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                               [NSCharacterSet URLQueryAllowedCharacterSet]]]
        placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
    }else{
        courseImage.image=[UIImage imageNamed:@"place_holder1.png"];
    }
    
    
    
    
    //   titleLabel.text = @"hfjkbhflkhjfklhjf;khdf;kdfh;kdfh;kfhbfklbfh;bl;blh;blbh;xlb;hxclb;xbl;b;blkh;dblkh;bdflb;flf;blfh;blfbh;flbh;flb;hlbh;lbh;blh;blbhflb;lb;hbl;blhkhbiuhegureghufhbufghfugbfjbhvfughifghfihbfuhgfihifhgfhifhihuguhfubhufhbuhfuhfjkbhflkhjfklhjf;khdf;kdfh;kdfh;kfhbfklbfh;bl;blh;blbh;xlb;hxclb;xbl;b;blkh;dblkh;bdflb;flf;blfh;blfbh;flbh;flb;hlbh;lbh;blh;blbhflb;lb;hbl;blhkhbiuhegureghufhbufghfugbfjbhvfughifghfihbfuhgfihifhghfjkbhflkhjfklhjf;khdf;kdfh;kdfh;kfhbfklbfh;bl;blh;blbh;xlb;hxclb;xbl;b;blkh;dblkh;bdflb;flf;blfh;blfbh;flbh;flb;hlbh;lbh;blh;blbhflb;lb;hbl;blhkhbiuhegureghufhbufghfugbfjbhvfughifghfihbfuhgfihifhghfjkbhflkhjfklhjf;khdf;kdfh;kdfh;kfhbfklbfh;bl;blh;blbh;xlb;hxclb;xbl;b;blkh;dblkh;bdflb;flf;blfh;blfbh;flbh;flb;hlbh;lbh;blh;blbhflb;lb;hbl;blhkhbiuhegureghufhbufghfugbfjbhvfughifghfihbfuhgfihifhg";
    
    
    //    if(![Utility isEmptyCheck:dataDict[@"RelatedTask"]] && ![Utility isEmptyCheck:dataDict[@"RelatedTask"][@"TaskTitle"]]){
    //        //Prev
    //        // detailsHeadingLabel.text = [NSString stringWithFormat:@"TO DO: %@",[[dataDict objectForKey:@"RelatedTask"] objectForKey:@"TaskTitle"]];
    //
    //        //Acc to Feedback
    //        detailsHeadingLabel.text = [NSString stringWithFormat:@"%@", [[dataDict objectForKey:@"RelatedTask"]objectForKey:@"TaskTitle"]];
    //
    //    }else{
    //        detailsHeadingLabel.text =@"";
    //    }
    
    
    if([Utility isEmptyCheck:dataDict[@"RelatedTask"]] || ([Utility isEmptyCheck:dataDict[@"RelatedTask"][@"TaskTitle"]] && [Utility isEmptyCheck:dataDict[@"RelatedTask"][@"Instructions"]])){
        separator1.hidden=true;
        viewTodo.hidden=true;
    }else{
        separator1.hidden=false;
        viewTodo.hidden=false;
    }
    
    
    if(![Utility isEmptyCheck:dataDict[@"RelatedTask"]] && ![Utility isEmptyCheck:dataDict[@"RelatedTask"][@"TaskTitle"]]){
        NSString *detailsString = [NSString stringWithFormat:@"%@", [[dataDict objectForKey:@"RelatedTask"]objectForKey:@"TaskTitle"]];
        detailsString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: black;\">%@</span>", detailsHeadingLabel.font.fontName, detailsHeadingLabel.font.pointSize, detailsString];
        NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[detailsString dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                       NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                       }
                                                                  documentAttributes:nil error:nil];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentLeft];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:strAttributed];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strAttributed length])];
        detailsHeadingLabel.attributedText = attributedString;
        
    }else{
        detailsHeadingLabel.text =@"";
    }
    //Ru
    if(![Utility isEmptyCheck:dataDict[@"RelatedTask"]] && ![Utility isEmptyCheck:dataDict[@"RelatedTask"][@"TaskText"]]){
        separator2.hidden=false;
        taskView.hidden=false;
        NSString *detailsString = [NSString stringWithFormat:@"%@", [[dataDict objectForKey:@"RelatedTask"]objectForKey:@"TaskText"]];
        detailsString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: black;\">%@</span>", taskLabel.font.fontName, taskLabel.font.pointSize, detailsString];
        NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[detailsString dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                       NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                       }
                                                                  documentAttributes:nil error:nil];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentLeft];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:strAttributed];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strAttributed length])];
        taskLabel.attributedText = attributedString;
        
    }else{
        separator2.hidden=true;
        taskView.hidden=true;
        taskLabel.text =@"";
    }
    
    if(![Utility isEmptyCheck:dataDict[@"RelatedTask"]] && ![Utility isEmptyCheck:dataDict[@"RelatedTask"][@"Instructions"]]){
        NSString *detailsString = [@"" stringByAppendingFormat:@"%@",[[[dataDict objectForKey:@"RelatedTask"] objectForKey:@"Instructions"] componentsJoinedByString:@"\n\u2022  "]];
        detailsString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: black;\">%@</span>", detailsLabel.font.fontName, detailsLabel.font.pointSize, detailsString];
        NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[detailsString dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                       NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                       }
                                                                  documentAttributes:nil error:nil];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentLeft];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:strAttributed];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strAttributed length])];
        detailsLabel.attributedText = attributedString;
        
    }else{
        detailsLabel.text =@"";
    }//Changes Null Checking on 25-Feb-2017 AmitY
    
    
    
    for (UIView * subView in attachmentStackView.arrangedSubviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [attachmentStackView removeArrangedSubview:subView];
            [subView removeFromSuperview];
        }
    }
    NSArray *attachmentArray = [dataDict objectForKey:@"Attachments"];
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
    
    if ([[dataDict objectForKey:@"IsRead"] boolValue]) {
        
        /*comment chayan
        [tickUntickButton setTitle:@"DONE" forState:UIControlStateNormal];
        self->tickUntickButton.clipsToBounds = YES;
        self->tickUntickButton.layer.borderWidth = 1.2;
        self->tickUntickButton.layer.cornerRadius = tickUntickButton.frame.size.height/2.0;
        
        [belowTickUntickButton setTitle:@"DONE" forState:UIControlStateNormal];
        self->belowTickUntickButton.clipsToBounds = YES;
        self->belowTickUntickButton.layer.borderWidth = 1.2;
        self->belowTickUntickButton.layer.cornerRadius = belowTickUntickButton.frame.size.height/2.0;
         */
        [self setTickItOffButton:self->tickUntickButton isRead:YES];
        [self setTickItOffButton:self->belowTickUntickButton isRead:YES];
       
    } else {
        /*comment chayan
        [tickUntickButton setTitle:@"TICK IT OFF" forState:UIControlStateNormal];
        [self->tickUntickButton setBackgroundColor:[UIColor colorWithRed:50.0/255.0f green:205.0/255.0f blue:184.0/255.0f alpha:1.0f]];
        self->tickUntickButton.layer.borderColor = [UIColor colorWithRed:50.0/255.0f green:205.0/255.0f blue:184.0/255.0f alpha:1.0f].CGColor;
        self->tickUntickButton.clipsToBounds = YES;
        self->tickUntickButton.layer.borderWidth = 1.2;
        self->tickUntickButton.layer.cornerRadius = tickUntickButton.frame.size.height/2.0;
        
        [belowTickUntickButton setTitle:@"TICK IT OFF" forState:UIControlStateNormal];
        [self->belowTickUntickButton setBackgroundColor:[UIColor colorWithRed:50.0/255.0f green:205.0/255.0f blue:184.0/255.0f alpha:1.0f]];
        self->belowTickUntickButton.layer.borderColor = [UIColor colorWithRed:50.0/255.0f green:205.0/255.0f blue:184.0/255.0f alpha:1.0f].CGColor;
        self->belowTickUntickButton.clipsToBounds = YES;
        self->belowTickUntickButton.layer.borderWidth = 1.2;
        self->belowTickUntickButton.layer.cornerRadius = belowTickUntickButton.frame.size.height/2.0;
         */
        
        [self setTickItOffButton:self->tickUntickButton isRead:NO];
        [self setTickItOffButton:self->belowTickUntickButton isRead:NO];
        
    }
    // #mark - View appear depend on VideoURL Checking [Ru]
    
    
    
    
    eventDownloadButton.hidden = YES;
    /* Prev
     if (![Utility isEmptyCheck:[dataDict objectForKey:@"PublicVideoUrls"]]) {//change_new_240318
     
     if(![Utility isEmptyCheck:[[dataDict objectForKey:@"PublicVideoUrls"] objectAtIndex:0]]){
     [self playVideoFromUrl:[[dataDict objectForKey:@"PublicVideoUrls"] objectAtIndex:0]];
     }
     }
     */
}
-(void) playVideoFromUrl:(NSString *)videoUrlStr isAudio:(BOOL)isAudio{
    CMTime startTime = CMTimeMake(0,0);
    if (appDelegate.playerController.player || appDelegate.FBWAudioPlayer) {
        [appDelegate.playerController.player pause];
        [appDelegate.FBWAudioPlayer pause];
        appDelegate.FBWAudioPlayer = nil;
        startTime = CMTimeMake(0, self->appDelegate.playerController.player.currentTime.timescale);

        [self resignFirstResponder];
    }
    if (isAudio) {
        [self stopAudioVisualizer];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 2), ^{
            
            NSURL *url = [NSURL URLWithString:videoUrlStr];
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSError *error;

            self->_audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
            [self->_audioPlayer setMeteringEnabled:YES];
            
            if (error)
            {
                NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
            }
            else
            {
                
            }
        }) ;
    }
        NSURL *videoURL = [NSURL URLWithString:videoUrlStr];
        appDelegate.FBWAudioPlayer = [AVPlayer playerWithURL:videoURL];
        // create a player view controller
        appDelegate.playerController = [[AVPlayerViewController alloc]init];
        appDelegate.playerController.player = appDelegate.FBWAudioPlayer;
    appDelegate.playerController.view.backgroundColor=[UIColor whiteColor];
        appDelegate.playerController.showsPlaybackControls = false;
        if (![[dataDict objectForKey:@"IsRead"] boolValue]) {
            [appDelegate.FBWAudioPlayer play];
        }
        [appDelegate setUpRemoteControl];
        
        // create an AVPlayer
        
        // show the view controller
        [self addChildViewController:appDelegate.playerController];
        [videoView addSubview:appDelegate.playerController.view];
        appDelegate.playerController.view.frame = videoView.bounds;
    appDelegate.playerController.view.contentMode=UIViewContentModeScaleToFill;
//        [self playPauseBtnPressed:playPauseBtn];
    
    //---- playpause
            playPauseBtn.selected = !playPauseBtn.selected;
            if(self->playPauseBtn.selected)
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
                            [self->appDelegate.playerController.player play];
                        }];
                    }

                    if(self->_audioPlayer){

                       [self->_audioPlayer setCurrentTime:audioPlaytime];
                    }

                }else{
                    [self->appDelegate.playerController.player play];
                }
                 if(self->_audioPlayer){
                    self->_audioPlayer.delegate = self;
                    [self->_audioPlayer prepareToPlay];
                    [self->_audioPlayer setVolume:0];
                    [self->_audioPlayer play];
                    [self startAudioVisualizer];
                 }
            }
            else
            {
                [self->appDelegate.playerController.player pause];
                if(self->_audioPlayer){
                    [self->_audioPlayer pause];
                    [self stopAudioVisualizer];
                }
                CMTime startTime = self->appDelegate.playerController.player.currentTime;
                self->videoStartTime = CMTimeGetSeconds(startTime);
            }
    //---- playpause


//    }
    
    
#pragma -mark ProgressBar
    //slider ah tr1
    double interval = .1f;
    CMTime playerDuration = appDelegate.playerController.player.currentItem.duration; // return player duration.
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        CGFloat width = CGRectGetWidth([eventSlider bounds]);
        interval = 0.5f * duration / width;
    }
    __weak typeof(self) weakSelf = self;
    /* Update the scrubber during normal playback. */
    if (interval > 0) {
        [self startAudioVisualizer];
        [appDelegate.playerController.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                                          queue:NULL
                                                                     usingBlock:
         ^(CMTime time)
         {
            
           
             [weakSelf syncScrubber];
//             [self->_audioPlayer setCurrentTime:CMTimeGetSeconds(time)];

         }];
    }
    [videoView bringSubviewToFront:fullScreenButton];
    
    // ---- pause at entry
    if (![[defaults objectForKey:@"RunningVideoSection"] isEqualToString:@"Course"]){
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
        [self stopAudioVisualizer];
        playPauseBtn.selected=NO;
    }
    // ----- pause at entry
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
            self->eventDownloadButton.enabled = false;
            self->eventProgress.hidden = true;
            if (success) {
                if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                    self->eventDownloadButton.enabled = false;
                    //self->eventDownloadButton.enabled = true;
                    self->eventProgress.hidden = true;
                    self->eventstatus.text = @"Download finished successfully.";
                    self->eventstatus.hidden = false;
                    [self->eventDownloadButton setTitle:@"DOWNLOADED" forState:UIControlStateNormal];
                }else{
                    [self->eventDownloadButton setTitle:@"DOWNLOAD" forState:UIControlStateNormal];
                }
               
            }
            else{
                self->eventstatus.text = [error localizedDescription];
                self->eventstatus.hidden = false;
                
                NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
            }
        }
    }];
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if ([task isEqual:self->eventDownloadTask]) {
            self->eventDownloadButton.enabled = false;
            self->eventProgress.hidden = true;
            self->eventstatus.hidden = false;
            if (error != nil) {
                self->eventstatus.text = [@"" stringByAppendingFormat:@"Download completed with error: %@",[error localizedDescription]];
                NSLog(@"Download completed with error: %@", [error localizedDescription]);
            }
            else{
                self->eventstatus.text = @"Download finished successfully.";
                NSLog(@"Download finished successfully.");
            }
            
        }
    }];
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if ([downloadTask isEqual:self->eventDownloadTask]) {
            if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
                NSLog(@"Unknown transfer size");
                self->eventstatus.text = @"Unknown transfer size";
                self->eventstatus.hidden = false;
                self->eventProgress.hidden= true;
                
            }else{
                double downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
                self->eventProgress.progress= downloadProgress;
                self->eventstatus.hidden = false;
            }
        }
        
    }];
}


-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    // Check if all download tasks have been finished.
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        if ([downloadTasks count] == 0) {
            if (self->appDelegate.backgroundTransferCompletionHandler != nil) {
                // Copy locally the completion handler.
                void(^completionHandler)(void) = self->appDelegate.backgroundTransferCompletionHandler;
                
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



#pragma mark - AVPlayerViewController Delegate
- (void)playerViewController:(AVPlayerViewController *)playerViewController willEndFullScreenPresentationWithAnimationCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    videoStartTime=CMTimeGetSeconds(avplayerViewController.player.currentTime);
    [appDelegate.playerController.player seekToTime:avplayerViewController.player.currentTime];
    if (avplayerViewController.player.rate>0) {
        [appDelegate.playerController.player play];
        playPauseBtn.selected = true;
        
    }else{
        [appDelegate.playerController.player pause];
        playPauseBtn.selected = false;
        
    }
    
}

#pragma mark - End

@end

