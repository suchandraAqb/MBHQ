//
//  VideoViewController.m
//  The Life
//
//  Created by AQB Mac 4 on 13/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController (){
    IBOutlet UIImageView *headerBg;

}

@end

@implementation VideoViewController
@synthesize videoId,playerView;
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        headerBg.image = [UIImage imageNamed:@"header-4s.png"];
    }else{
        headerBg.image = [UIImage imageNamed:@"header.png"];
    }
    playerView.backgroundColor = [UIColor blackColor];
    if (playerView != nil) {
        [playerView pauseVideo];
    }
    
    NSDictionary* playerVars   = @{
                                   @"controls" : @2,
                                   @"playsinline" : @1,
                                   @"autohide" : @1,
                                   @"showinfo" : @0,
                                   @"rel"      : @0,
                                   @"modestbranding" : @1
                                     
                                   };
    playerView.delegate = self;
    [playerView loadWithVideoId:videoId playerVars:playerVars];
}

-(void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error{
    [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    return;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
