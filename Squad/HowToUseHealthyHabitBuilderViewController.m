//
//  HowToUseHealthyHabitBuilderViewController.m
//  Squad
//
//  Created by MAC 6- AQB SOLUTIONS on 26/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "HowToUseHealthyHabitBuilderViewController.h"

@interface HowToUseHealthyHabitBuilderViewController (){
    
    IBOutlet UITextView *instructionTextView;
    UIView *contentView;
    
}

@end

@implementation HowToUseHealthyHabitBuilderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (contentView) {
            [contentView removeFromSuperview];
        }
        [self.webView setBackgroundColor:[UIColor clearColor]];
        [self.webView setOpaque:NO];
        contentView = [Utility activityIndicatorView:self];
    });
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HowToUseHealthyHabitBuilder.html" ofType:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}
#pragma mark - WebView Methods

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (contentView) {
            [self.webView setBackgroundColor:[UIColor clearColor]];
            [self.webView setOpaque:NO];
            [contentView removeFromSuperview];
        };
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
