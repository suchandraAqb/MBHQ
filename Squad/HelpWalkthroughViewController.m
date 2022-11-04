//
//  HelpWalkthroughViewController.m
//  Squad
//
//  Created by Admin on 09/09/20.
//  Copyright © 2020 AQB Solutions. All rights reserved.
//

#import "HelpWalkthroughViewController.h"
#import "WebinarListViewController.h"

@interface HelpWalkthroughViewController ()<WKNavigationDelegate>{
    
    IBOutlet WKWebView *webView;
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *manualButton;
    IBOutlet UIButton *walkThroughButton;
    IBOutlet UIView *manualView;
    IBOutlet UIView *walkthroughMenuView;
    IBOutletCollection(UIButton) NSArray *walkThroughMenuButtons;
    
    IBOutlet UIView *walkThroughMeditationView;
    IBOutlet UIButton *walkThroughMeditationOkButton;
    IBOutlet UIButton *walkThroughMeditationLaterButton;
    
    IBOutlet UIView *walkThroughNonQuedView;
    IBOutlet UIButton *nonQuedGotItButton;

    
    
    IBOutlet UIView *walkThroughOverview;
    IBOutlet UIScrollView *overviewScroll;
    IBOutlet UIPageControl *overviewPageControll;

    
    IBOutlet UIView *walkThroughForumView;
    IBOutlet UIScrollView *forumScroll;
    IBOutlet UIPageControl *forumPageControll;
    IBOutlet UIButton *openForumButton;
    
    IBOutlet UIView *walkThroughHabitView;
    IBOutlet UIButton *createHabitButton;
    IBOutlet UIButton *showMeExampleButton;
    
    IBOutlet UIView *walkThroughBucketListView;
    IBOutlet UIButton *gotItButton;//bucketlist
    
    IBOutlet UIView *walkThroughGratitudeView;
    IBOutlet UIView *walkThroughGrowthView;
    IBOutlet UIView *walkThroughProgramView;
    IBOutlet UIView *walkThroughTestView;
    
    IBOutlet UIButton *gratitudeGotItButton;
    IBOutlet UIButton *growthGotItButton;
//    IBOutlet UIButton *meditationGotItButton;
    IBOutlet UIButton *habitGotItButton;
    IBOutlet UIButton *programGotItButton;
    IBOutlet UIButton *testGotItButton;
    IBOutlet UIView *walkThroughAeroplaneModeView;
    IBOutlet UIButton *walkThroughGotItButton;
    
    UIView *contentView;
    NSURLSession *session;
    BOOL forumPageControlIsChangingPage;
    BOOL overviewPageControlIsChangingPage;

    
}
@end


@implementation HelpWalkthroughViewController

@synthesize url,parent;
#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(forumScrollTapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [forumScroll addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(overviewScrollTapAction:)];
    tapGesture1.numberOfTapsRequired = 1;
    [overviewScroll addGestureRecognizer:tapGesture1];
    
    if ([self checkForDownload]) {
         shareButton.hidden = false;
    }else{
         shareButton.hidden = true;
    }
    
    if (![Utility isEmptyCheck:url]) {
        if ([Utility reachable]) {
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            webView.navigationDelegate = self;
            [webView loadRequest:request];
        }
    }
    
    manualButton.selected=true;
    walkThroughButton.selected=false;
    
//    manualButton.titleLabel.textColor = [Utility colorWithHexString:mbhqBaseColor];//255
    manualButton.backgroundColor = [UIColor whiteColor];
    manualButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:14];

//    walkThroughButton.titleLabel.textColor = [UIColor blackColor];//245
    walkThroughButton.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    walkThroughButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:14];
    
    for (UIButton *btn in walkThroughMenuButtons) {
        btn.clipsToBounds=YES;
        btn.backgroundColor=squadMainColor;
        btn.layer.cornerRadius=btn.frame.size.height/2;
    }
    
    walkThroughMeditationOkButton.layer.cornerRadius=15;
    walkThroughMeditationOkButton.layer.masksToBounds=true;
    walkThroughMeditationLaterButton.layer.cornerRadius=15;
    walkThroughMeditationLaterButton.layer.masksToBounds=true;
    openForumButton.layer.cornerRadius = 15;
    openForumButton.layer.masksToBounds = YES;
    showMeExampleButton.layer.cornerRadius = 15;
    showMeExampleButton.layer.masksToBounds = YES;
    createHabitButton.layer.cornerRadius = 15;
    createHabitButton.layer.masksToBounds = YES;
    
    gotItButton.layer.cornerRadius = 15;
    gotItButton.layer.masksToBounds = YES;
    
    gratitudeGotItButton.layer.cornerRadius = 15;
    gratitudeGotItButton.layer.masksToBounds = YES;
    growthGotItButton.layer.cornerRadius = 15;
    growthGotItButton.layer.masksToBounds = YES;
    habitGotItButton.layer.cornerRadius = 15;
    habitGotItButton.layer.masksToBounds = YES;
    programGotItButton.layer.cornerRadius = 15;
    programGotItButton.layer.masksToBounds = YES;
    testGotItButton.layer.cornerRadius = 15;
    testGotItButton.layer.masksToBounds = YES;
    
    nonQuedGotItButton.layer.cornerRadius = 15;
    nonQuedGotItButton.layer.masksToBounds = YES;
    
    
    
    manualView.hidden=false;
    walkthroughMenuView.hidden=true;
    walkThroughOverview.hidden=true;
    walkThroughMeditationView.hidden=true;
    walkThroughNonQuedView.hidden=true;
    walkThroughForumView.hidden=true;
    walkThroughHabitView.hidden=true;
    walkThroughBucketListView.hidden=true;
    walkThroughGratitudeView.hidden=true;
    walkThroughGrowthView.hidden=true;
    walkThroughProgramView.hidden=true;
    walkThroughTestView.hidden=true;
    walkThroughAeroplaneModeView.hidden = true;
    walkThroughGotItButton.layer.cornerRadius = 15;
    walkThroughGotItButton.layer.masksToBounds = YES;
    [self walkThroughButtonPressed:walkThroughButton];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
[super viewWillAppear:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -End


#pragma mark - IBActions

- (IBAction)MeditateNowAction:(UIButton *)sender {
    [self walkThroughBackButtonPressed:0];
    [self dismissViewControllerAnimated:NO completion:nil];
    dispatch_async(dispatch_get_main_queue(),^ {
    WebinarListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarListView"];
    [self.parent.navigationController pushViewController:controller animated:YES];
     });
}
- (IBAction)findMyLevelAction:(UIButton *)sender {
    [self walkThroughBackButtonPressed:0];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:TEST_LEVEL_URL]]){
    NSString *detailsStr = [@"" stringByAppendingFormat:@"%@/members?token=%@",TEST_LEVEL_URL,[defaults valueForKey:@"LoginToken"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:detailsStr] options:@{} completionHandler:^(BOOL success) {
        if(success){
            NSLog(@"Opened");
            }
        }];
    }
}


- (IBAction)createHabitButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    dispatch_async(dispatch_get_main_queue(),^ {
    HabitHackerListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HabitHackerListView"];
    if (sender.tag ==0) {
        controller.isFromhelpSectionCreate = true;
    }else{
        controller.isFromhelpSectionshowME = true;
        }
         [self.parent.navigationController pushViewController:controller animated:YES];
     });
}


- (IBAction)openForumButtonPressed:(UIButton *)sender {
//    [self dismissViewControllerAnimated:NO completion:nil];
//    dispatch_async(dispatch_get_main_queue(),^ {
//    CommunityViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CommunityView"];
////    [self.parent.navigationController pushViewController:controller animated:YES];
//    });
//    [self dismissViewControllerAnimated:NO completion:nil];
//    dispatch_async(dispatch_get_main_queue(),^ {
//        NSString *urlString=@"https://www.facebook.com/groups/250625228700325";
//        FBForumViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FBForum"];
//        controller.urlString = urlString;
//        [self.parent.navigationController pushViewController:controller animated:YES];
//    });
    [self dismissViewControllerAnimated:NO completion:^{
   //        FacebookGroupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"FacebookGroupView"];
   //        controller.url = [NSURL URLWithString:FaceBookGroup];
           NSString *urlString=@"https://www.facebook.com/groups/250625228700325";
           NSURL *facebookURL = [NSURL URLWithString:urlString];
           if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
               [[UIApplication sharedApplication] openURL:facebookURL options:@{} completionHandler:^(BOOL success) {
                   if (success) {
                        NSLog(@"Opened url");
                   }
                   
               }];
               
           } else {
               [[UIApplication sharedApplication] openURL:facebookURL options:@{} completionHandler:^(BOOL success) {
                   if (success) {
                        NSLog(@"Opened url");
                   }
                   
               }];
           }
   //        [self.parent.navigationController pushViewController:controller animated:NO];
           

       }];
}

- (IBAction)walkThroughBackButtonPressed:(UIButton *)sender {
    walkThroughOverview.hidden=true;
    walkThroughMeditationView.hidden=true;
    walkThroughNonQuedView.hidden=true;
    walkThroughForumView.hidden=true;
    walkThroughHabitView.hidden=true;
    walkThroughBucketListView.hidden=true;
    walkThroughGratitudeView.hidden=true;
    walkThroughGrowthView.hidden=true;
    walkThroughProgramView.hidden=true;
    walkThroughTestView.hidden=true;
    walkThroughAeroplaneModeView.hidden = true;
    
}

- (IBAction)walkThroughMenuButtonPressed:(UIButton *)sender {
    [self walkThroughBackButtonPressed:0];
    if (sender.tag==0) {
        walkThroughOverview.hidden=false;
    }else if (sender.tag==1){
        walkThroughGratitudeView.hidden=false;
    }else if (sender.tag==2){
        walkThroughGrowthView.hidden=false;
    }else if (sender.tag==3){
        walkThroughMeditationView.hidden=false;
    }else if (sender.tag==4){
        walkThroughHabitView.hidden=false;
    }else if (sender.tag==5){
        walkThroughBucketListView.hidden=false;
    }else if (sender.tag==6){
        walkThroughProgramView.hidden=false;
    }else if (sender.tag==7){
        walkThroughTestView.hidden=false;
    }else if (sender.tag==8){
        walkThroughForumView.hidden=true;
//        [self dismissViewControllerAnimated:NO completion:nil];
//        dispatch_async(dispatch_get_main_queue(),^ {
//            NSString *urlString=@"https://www.facebook.com/groups/250625228700325";
//            FBForumViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FBForum"];
//            controller.urlString = urlString;
//            [self.parent.navigationController pushViewController:controller animated:YES];
//        });
        [self dismissViewControllerAnimated:NO completion:^{
       //        FacebookGroupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"FacebookGroupView"];
       //        controller.url = [NSURL URLWithString:FaceBookGroup];
               NSString *urlString=@"https://www.facebook.com/groups/250625228700325";
               NSURL *facebookURL = [NSURL URLWithString:urlString];
               if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
                   [[UIApplication sharedApplication] openURL:facebookURL options:@{} completionHandler:^(BOOL success) {
                       if (success) {
                            NSLog(@"Opened url");
                       }
                       
                   }];
                   
               } else {
                   [[UIApplication sharedApplication] openURL:facebookURL options:@{} completionHandler:^(BOOL success) {
                       if (success) {
                            NSLog(@"Opened url");
                       }
                       
                   }];
               }
       //        [self.parent.navigationController pushViewController:controller animated:NO];
               

           }];
    }else if (sender.tag==9){
        walkThroughAeroplaneModeView.hidden = false;
    }else if (sender.tag==10){
        walkThroughNonQuedView.hidden = false;
    }
}

- (IBAction)manualButtonPressed:(UIButton *)sender {
    if (!sender.isSelected) {
        sender.selected=true;
        walkThroughButton.selected=false;
        sender.backgroundColor = [UIColor whiteColor];
        sender.titleLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:14];
        walkThroughButton.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        walkThroughButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:14];
        
        [self walkThroughBackButtonPressed:0];
        manualView.hidden=false;
        walkthroughMenuView.hidden=true;
        
    }
}

- (IBAction)walkThroughButtonPressed:(UIButton *)sender {
    if (!sender.isSelected) {
        sender.selected=true;
        manualButton.selected=false;
        sender.backgroundColor = [UIColor whiteColor];
        sender.titleLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:14];
        manualButton.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        manualButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:14];
        
        [self walkThroughBackButtonPressed:0];
        walkthroughMenuView.hidden=false;
        manualView.hidden=true;
        
    }
}

-(IBAction)backButtonPressed:(id)sender{
    dispatch_async(dispatch_get_main_queue(),^ {
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

-(IBAction)shareButtonPressed:(id)sender{
    NSURL *sourceURL = url;
            shareButton.hidden = false;
            if ([self checkForDownload]) {
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];
    //            NSLog(@"fullPathToFile=%@",fullPathToFile);
                NSURL *documentDirectoryURl = [NSURL fileURLWithPath:fullPathToFile];
                NSArray *activityItems = @[documentDirectoryURl];
                UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
                activityController.excludedActivityTypes = @[
                                                             UIActivityTypeAssignToContact,
                                                             UIActivityTypePrint,
                                                             UIActivityTypeAddToReadingList,
                                                             UIActivityTypeSaveToCameraRoll,
                                                             UIActivityTypeOpenInIBooks,
                                                             @"com.apple.mobilenotes.SharingExtension",
                                                             @"com.apple.reminders.RemindersEditorExtension"
                                                             ];
                [self presentViewController:activityController animated:YES completion:nil];
            }else{
                if (contentView) {
                    [contentView removeFromSuperview];
                }
                contentView = [Utility activityIndicatorView:self];
                
                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                
                NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    
                    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString* documentsDirectory = [paths objectAtIndex:0];
                    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];
                    NSURL *destinationURL = [NSURL fileURLWithPath:fullPathToFile];
                    
                    if ([fileManager fileExistsAtPath:[destinationURL path]]) {
                        [fileManager removeItemAtURL:destinationURL error:nil];
                    }
                    return destinationURL;
                    
                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    NSLog(@"File downloaded to: %@", filePath);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(self->contentView){
                            [self->contentView removeFromSuperview];
                        }
                    });
                    
                    if(!error){
                        if(self->contentView){
                            [self->contentView removeFromSuperview];
                        }
                       
                        NSURL *sourceURL = self->url;
                        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString* documentsDirectory = [paths objectAtIndex:0];
                        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];
                        
                        if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                            [self->shareButton setImage:[UIImage imageNamed:@"share_course.png"] forState:UIControlStateNormal];
                            NSLog(@"Single Download success. original main.");
                            NSLog(@"url %@",fullPathToFile);
                            NSURL *documentDirectoryURl = [NSURL fileURLWithPath:fullPathToFile];
                            NSArray *activityItems = @[documentDirectoryURl];
                            UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
                            activityController.excludedActivityTypes = @[
                                                                         UIActivityTypeAssignToContact,
                                                                         UIActivityTypePrint,
                                                                         UIActivityTypeAddToReadingList,
                                                                         UIActivityTypeSaveToCameraRoll,
                                                                         UIActivityTypeOpenInIBooks,
                                                                         @"com.apple.mobilenotes.SharingExtension",
                                                                         @"com.apple.reminders.RemindersEditorExtension"
                                                                         ];
                            [self presentViewController:activityController animated:YES completion:nil];
                        }
                        
                    }else{
                        if(self->contentView){
                            [self->contentView removeFromSuperview];
                        }
                        NSLog(@"Download completed with error: %@", [error localizedDescription]);
                        if(![Utility isOfflineMode])[Utility msg: [@"" stringByAppendingString:@" Error downloading video.Check Your network connection and try again."] title:@"Oops! " controller:self haveToPop:NO];
                    }
                }];
                [downloadTask resume];
            }
    
}

#pragma mark -End

#pragma mark -Privete method
-(BOOL)checkForDownload{
    BOOL alreadyExist = NO;
    NSURL *sourceURL = url;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];
    NSLog(@"fullPathToFile=%@",fullPathToFile);
    
    if([fileManager fileExistsAtPath:fullPathToFile]) {
        [shareButton setImage:[UIImage imageNamed:@"share_course.png"] forState:UIControlStateNormal];
        alreadyExist = true;
    }else{
        [shareButton setImage:[UIImage imageNamed:@"cloud_course.png"] forState:UIControlStateNormal];
        alreadyExist = false;
    }
    return alreadyExist;
}

#pragma mark -End

#pragma mark - UITapGesture Action
- (void)forumScrollTapAction:(UITapGestureRecognizer *)tap
{
    forumPageControll.currentPage = forumPageControll.currentPage+1;
    [self forumScrollChangePage:0];
}
-(IBAction)forumScrollChangePage:(id)sender
{
    //move the scroll view
    CGRect frame = forumScroll.frame;
    frame.origin.x = frame.size.width *forumPageControll.currentPage;
    frame.origin.y = 0;
    //    frame.origin.x = frame.size.width * 1;
    [forumScroll scrollRectToVisible:frame animated:YES];
    //scrollViewDidEndDecelerating will turn this off
    forumPageControlIsChangingPage = YES;
}

- (void)overviewScrollTapAction:(UITapGestureRecognizer *)tap
{
    overviewPageControll.currentPage = overviewPageControll.currentPage+1;
    [self overviewScrollChangePage:0];
}
-(IBAction)overviewScrollChangePage:(id)sender
{
    //move the scroll view
    CGRect frame = overviewScroll.frame;
    frame.origin.x = frame.size.width *overviewPageControll.currentPage;
    frame.origin.y = 0;
    //    frame.origin.x = frame.size.width * 1;
    [overviewScroll scrollRectToVisible:frame animated:YES];
    //scrollViewDidEndDecelerating will turn this off
    overviewPageControlIsChangingPage = YES;
}

#pragma mark -End

#pragma mark - WebView Delegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if (contentView) {
           [contentView removeFromSuperview];
            if (![self checkForDownload]) {
                shareButton.hidden = false;
            }
       }
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation  withError:(NSError *)error{
     if (contentView) {
             [contentView removeFromSuperview];
         }
         [Utility msg:@"Something went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:YES];
}
#pragma mark - End

#pragma mark - UIScrollViewDelegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView==forumScroll) {
        if (forumPageControlIsChangingPage) {
            return;
        }
        CGFloat pageWidth = forumScroll.frame.size.width;
        float fractionalPage = forumScroll.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        forumPageControll.currentPage = page;
    }else if (scrollView==overviewScroll){
        if (overviewPageControlIsChangingPage) {
            return;
        }
        CGFloat pageWidth = overviewScroll.frame.size.width;
        float fractionalPage = overviewScroll.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        overviewPageControll.currentPage = page;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==forumScroll) {
        forumPageControlIsChangingPage = NO;
        CGFloat pageWidth = forumScroll.frame.size.width;
        float fractionalPage = forumScroll.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        forumPageControll.currentPage = page;
    }else if (scrollView==overviewScroll){
        overviewPageControlIsChangingPage = NO;
        CGFloat pageWidth = overviewScroll.frame.size.width;
        float fractionalPage = overviewScroll.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        overviewPageControll.currentPage = page;
    }
    
}

#pragma mark -End

@end
