//
//  HelpVideoPlayerViewController.m
//  Squad
//
//  Created by MAC 6- AQB SOLUTIONS on 12/06/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "HelpVideoPlayerViewController.h"

@interface HelpVideoPlayerViewController ()
{
    
IBOutlet UIView *playerView;
    
AVPlayer *videoPlayer;
AVPlayerViewController *playerController;
    BOOL isFinished;
    BOOL isFirst;
}

@end


@implementation HelpVideoPlayerViewController
@synthesize delegate;
@synthesize videoURLString;

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self playVideo];
    isFinished = false;
    isFirst = true;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self playVideo];
}

- (void) playVideo{
   // videoURLString = @"https://player.vimeo.com/external/125750379.m3u8?s=c85a3928071e47c744698cf66662e8543adcf3f8";
    [[AVAudioSession sharedInstance]
                setCategory: AVAudioSessionCategoryPlayback
                      error: nil];
    NSURL *videoURL = [NSURL URLWithString:videoURLString];
    videoPlayer = [AVPlayer playerWithURL:videoURL];
    playerController = [[AVPlayerViewController alloc]init];
    playerController.player = videoPlayer;
    playerController.showsPlaybackControls = true;
    [videoPlayer play];
    [self addChildViewController:playerController];
    [playerView addSubview:playerController.view];
    playerController.view.frame = playerView.bounds;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerController.player.currentItem];

}
- (IBAction)doneButtonPressed:(id)sender {
    [playerController.player pause];
    if (isFinished) {
        //[self dismissViewControllerAnimated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self->delegate respondsToSelector:@selector(controllerDismissed)]){
                [self->delegate controllerDismissed];
            }
        }]; // AY 05012018
    } else {
        [self showAlert];
    }
}
-(void)itemDidFinishPlaying:(NSNotification *) notification {
    isFinished = true;
//    if (([delegate isKindOfClass: [VisionHomeViewController class]]) && isFirst) {
//        isFirst = false;
//        videoURLString = @"https://player.vimeo.com/external/125750377.m3u8?s=2bce1b1ce005b50c1098506cc28934b892d87145";
//        [self playVideo];
//    }
}

-(void) showAlert {
    NSString *msgAlert = @"";
    if (_isFromMessage) {
        msgAlert = @"Are you sure? You want to close the video";
    }else{
        msgAlert = @"Are you sure? You will get the best results if you know how to use the app";
    }
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:msgAlert
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Confirm"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   //Added For Firebase tutorial_complete Tracking AY 21032018
                                   [FIRAnalytics logEventWithName:@"tutorial_complete" parameters:nil];
                                   //End
                                   //[self dismissViewControllerAnimated:YES completion:nil];
                                   [self dismissViewControllerAnimated:YES completion:^{
                                       if ([self->delegate respondsToSelector:@selector(controllerDismissed)]){
                                           [self->delegate controllerDismissed];
                                       }
                                   }]; // AY 05012018
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self->playerController.player play];
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
@end
