//
//  CommunityViewController.m
//  
//
//  Created by Suchandra Bhattacharya on 14/02/2020.
//

#import "CommunityViewController.h"
#import "ChatVideoListViewController.h"
#import "ChatDetailsVideoViewController.h"

@interface CommunityViewController ()<WKNavigationDelegate>
{
    UIView *contentView;
    NSURLSession *session;
    IBOutlet WKWebView *communityWebView;
    IBOutlet UIView *silderView;
    IBOutlet UIView *lastView;
    IBOutlet UIButton *openForum;
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIPageControl *pageControl;
    BOOL pageControlIsChangingPage;
    BOOL isLoaded;
    UIRefreshControl *refreshControl;
    BOOL isWebViewLoaded;
    AppDelegate *appDelegate;

}
@end

@implementation CommunityViewController
@synthesize isFromCourse,liveForumUrlStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    openForum.layer.cornerRadius = 15;
    openForum.layer.masksToBounds = YES;
    isLoaded = false;
    isWebViewLoaded = false;
    
    if (isFromCourse) {
        if (![Utility isEmptyCheck:[defaults objectForKey:@"forumAccessToken"]] && ![Utility isEmptyCheck:liveForumUrlStr]){
            isFromCourse=false;
            if ([Utility reachable]) {
                if (contentView) {
                    [contentView removeFromSuperview];
                }
                  if ([defaults boolForKey:@"isFirstTimeForumLink"]) {
                      contentView = [Utility activityIndicatorView:self];
                  }
                isWebViewLoaded = true;
                NSString *s=[NSString stringWithFormat:@"%@?token=%@",liveForumUrlStr,[defaults objectForKey:@"forumAccessToken"]];
                NSURL *url = [NSURL URLWithString:s];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                communityWebView.navigationDelegate = self;
                [communityWebView loadRequest:request];
                
            }else{
                [Utility msg:@"Somthing went wrong" title:@"Alert" controller:self haveToPop:NO];
            }
        }else{
            if (![defaults boolForKey:@"IsFromCommunity"]) {
                [Utility communityLoginWebserviceCall];
                [defaults setBool:true forKey:@"IsFromCommunity"];
            }
        }
    }else{
        if (![Utility isEmptyCheck:[defaults objectForKey:@"locationUrl"]]) {
            if ([Utility reachable]) {
                if (contentView) {
                    [contentView removeFromSuperview];
                }
                  if ([defaults boolForKey:@"isFirstTimeForumLink"]) {
                      contentView = [Utility activityIndicatorView:self];
                  }
                isWebViewLoaded = true;
                NSURL *url = [NSURL URLWithString:[defaults objectForKey:@"locationUrl"]];
                NSLog(@"url-> %@",[defaults objectForKey:@"locationUrl"]);
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                communityWebView.navigationDelegate = self;
                [communityWebView loadRequest:request];
            }else{
                [Utility msg:@"Somthing went wrong" title:@"Alert" controller:self haveToPop:NO];
            }
        }else{
            if (![defaults boolForKey:@"IsFromCommunity"]) {
                [Utility communityLoginWebserviceCall];
                [defaults setBool:true forKey:@"IsFromCommunity"];
            }
          
        }
    }
    
    
        dispatch_async(dispatch_get_main_queue(), ^{
        if (![defaults boolForKey:@"isFirstTimeForumLink"]) {
                 [defaults setBool:true forKey:@"isFirstTimeForumLink"];
                 self->lastView.hidden = true;
                 self->silderView.hidden = false;
                 [defaults setBool:NO forKey:@"isFirstTimeForumRefresh"];
                 UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapAction:)];
                 tapGesture.numberOfTapsRequired = 1;
                 [self->mainScroll addGestureRecognizer:tapGesture];
             }else{
                 self->silderView.hidden = true;
                 self->lastView.hidden = false;
                 [self setLastView];
             }
            self->refreshControl = [[UIRefreshControl alloc]init];
            [self->refreshControl addTarget:self action:@selector(refreshCommunityView) forControlEvents:UIControlEventValueChanged];
            [self->communityWebView.scrollView addSubview:self->refreshControl];
    });
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![communityWebView isLoading] && !isLoaded) {
        [communityWebView reloadFromOrigin];
    }
}
#pragma mark - WebKitView Delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
   
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if (contentView) {
        [contentView removeFromSuperview];
    }
    isLoaded = true;
    if (![defaults boolForKey:@"isFirstTimeForumRefresh"]) {
        [defaults setBool:YES forKey:@"isFirstTimeForumRefresh"];
        [self refreshCommunityView];
    }
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation  withError:(NSError *)error{
      if (contentView) {
         [contentView removeFromSuperview];
      }
    isLoaded = false;
    [Utility msg:@"Something went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.relativeString hasPrefix:@"https://livechat.mindbodyhq.com/"]) {
        if (![Utility isEmptyCheck:[defaults objectForKey:@"IsPlayingLiveChat"]] && [[defaults objectForKey:@"IsPlayingLiveChat"] boolValue]) {
                       NSDictionary *dict=[defaults objectForKey:@"PlayingLiveChatDict"];
                       CMTime startTime = CMTimeMake(0, 0);
                       if ([defaults boolForKey:@"IsPlayingLiveChat"]) {
                           [appDelegate.FBWAudioPlayer pause];
                           startTime = appDelegate.playerController.player.currentTime;
                       }
                       BOOL isCheck = false;
                       NSArray *controllers = [self.navigationController viewControllers];
                       for(UIViewController *controller in controllers){
                           if ([controller isKindOfClass:[ChatDetailsVideoViewController class]]) {
                               isCheck = true;
                               [self.navigationController popToViewController:controller animated:NO];
                           }
                       }
                       if (!isCheck) {
                           ChatDetailsVideoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ChatDetailsVideo"];
                                controller.videoDict = dict;
                           if (CMTimeGetSeconds(startTime)>0) {
                                controller.videoTime = startTime;
                              }
                            [self.navigationController pushViewController:controller animated:NO];
                       }
                       
                   }else{
                       ChatVideoListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ChatVideoList"];
                       [self.navigationController pushViewController:controller animated:NO];
                   }
                    decisionHandler(WKNavigationActionPolicyCancel);
                    return;
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - End
#pragma mark - Private function
-(void)refreshCommunityView{
    [refreshControl endRefreshing];
    if (![communityWebView isLoading]) {
        [communityWebView reloadFromOrigin];
    }
}
-(void)setLastView{
     silderView.hidden = true;
     lastView.hidden = false;
}
- (void)communityLoginWebserviceCall{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (Utility.reachable) {
            NSString *deviceidStr = @"";
            if([FIRMessaging messaging].FCMToken){
                deviceidStr = [FIRMessaging messaging].FCMToken;
            }
            NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&squad_user_id=%@&server_key=%@&squad_access_token=%@&ios_m_device_id=%@",[defaults objectForKey:@"Email"],[@"" stringByAppendingFormat:@"%@%@",BASEPASSWORD_COMMUNITY,[defaults objectForKey:@"UserID"]],[defaults objectForKey:@"UserID"],CommunityServerKey,[defaults objectForKey:@"UserSessionID"],deviceidStr];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://forum.mindbodyhq.com/api/auth"]]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            NSURLSession *loginSession = [NSURLSession sharedSession];
            NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@",responseString);
                NSMutableDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
                if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"api_status"]intValue] == 200) {
                    if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"access_token"]]) {
                        [defaults setObject:[responseDictionary objectForKey:@"access_token"] forKey:@"forumAccessToken"];
                    }
                    if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"location"]]) {
                        [defaults setObject:[responseDictionary objectForKey:@"location"]forKey:@"locationUrl"];
                    }
                    if (![Utility isEmptyCheck:[defaults objectForKey:@"locationUrl"]]) {
                       if ([Utility reachable]) {
                           if (self->contentView) {
                               [self->contentView removeFromSuperview];
                           }
                            self->contentView = [Utility activityIndicatorView:self];
                             
                           NSURL *url = [NSURL URLWithString:[defaults objectForKey:@"locationUrl"]];
                           NSURLRequest *request = [NSURLRequest requestWithURL:url];
                           self->communityWebView.navigationDelegate = self;
                           [self->communityWebView loadRequest:request];
                           
                       }else{
                           [Utility msg:@"Somthing went wrong" title:@"Alert" controller:self haveToPop:NO];
                       }
                   }
                }else{
                    [Utility msg:@"Somthing went wrong" title:@"Alert" controller:self haveToPop:NO];
                 }
            }];
             [dataTask resume];
        }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
     }
  });
}
#pragma mark - UITapGesture Action
- (void)tapAction:(UITapGestureRecognizer *)tap
{
//    if(pageControl.currentPage == pageControl.numberOfPages-1){
//        sliderView.hidden = true;
//        lastView.hidden = false;
//        [self setLastView];
//        return;
//    }
    pageControl.currentPage = pageControl.currentPage+1;
    [self changePage:0];
}
-(IBAction)changePage:(id)sender
{
    //move the scroll view
    CGRect frame = mainScroll.frame;
    frame.origin.x = frame.size.width *pageControl.currentPage;
    frame.origin.y = 0;
    //    frame.origin.x = frame.size.width * 1;
    [mainScroll scrollRectToVisible:frame animated:YES];
    //scrollViewDidEndDecelerating will turn this off
    pageControlIsChangingPage = YES;
}
-(IBAction)openForumPressed:(id)sender{
     [self setLastView];
}
#pragma mark - UIScrollViewDelegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if ((scrollView.contentOffset.x + scrollView.frame.size.width) > scrollView.contentSize.width) {
//         sliderView.hidden = true;
//         lastView.hidden = false;
//         [self setLastView];
//        return;
//    }
    if (pageControlIsChangingPage) {
        return;
    }
    CGFloat pageWidth = mainScroll.frame.size.width;
    float fractionalPage = mainScroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlIsChangingPage = NO;
    CGFloat pageWidth = mainScroll.frame.size.width;
    float fractionalPage = mainScroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
    //    uint page = mainScroll.contentOffset.x / SCROLLWIDTH;
    //    [self.pageControl setCurrentPage:page];
}
@end
