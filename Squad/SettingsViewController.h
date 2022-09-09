//
//  SettingsViewController.h
//  Ashy Bines Super Circuit
//
//  Created by AQB SOLUTIONS on 09/09/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsPickersViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SongPlayListViewController.h"

#import "AudioPlayerViewController.h"
#import "SpotifyPlayerViewController.h"
@protocol RoundListDelegate<NSObject>
-(void) updateRoundlist;
@end

@interface SettingsViewController : UIViewController<SettingsCustomPickerDelegate,PlayListViewDelegate,MPMediaPickerControllerDelegate>{
    id<RoundListDelegate>delegate;
}
@property (strong,atomic) id delegate;
@property BOOL circuitPlaying;

@property (nonatomic, strong) AudioPlayerViewController *audioPlayerViewController;
@property (nonatomic, strong) SpotifyPlayerViewController *spotifyPlayerViewController;
// Keep track of the current selected view controller
@property (nonatomic, strong) UIViewController *currentViewController;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (assign) BOOL keepPlaying;
-(void)refreshTable;

@end
