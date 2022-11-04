//
//  FBForumViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 28/01/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "FBForumViewController.h"
#import "Utility.h"
@interface FBForumViewController ()

{
    IBOutlet UIImageView *headerBg;
    IBOutlet UIWebView *webView;
    UIView *contentView;
    
}

@end

@implementation FBForumViewController
@synthesize urlString;
#pragma mark - IBAction
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(IBAction)backButtonPressed:(id)sender{
    dispatch_async(dispatch_get_main_queue(),^ {
        [self.navigationController popViewControllerAnimated:YES];
    });
}
#pragma mark -End

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        headerBg.image = [UIImage imageNamed:@"header-4s.png"];
    }else{
        headerBg.image = [UIImage imageNamed:@"header.png"];
    }
    if (![Utility isEmptyCheck:urlString]) {
        if ([Utility reachable]) {
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
            NSURL *targetURL = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
            [webView loadRequest:request];
            [webView setScalesPageToFit:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - End

#pragma mark - WebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (contentView) {
        [contentView removeFromSuperview];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (contentView) {
        [contentView removeFromSuperview];
    }
    [Utility msg:@"Something went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:YES];
    
}
#pragma mark - End
#pragma mark - ReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - End
@end
