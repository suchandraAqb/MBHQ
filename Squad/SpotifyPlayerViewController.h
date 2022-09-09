//
//  SpotifyPlayerViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 21/12/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewDataSource.h"
#import "ExerciseVideoViewController.h"

@interface SpotifyPlayerViewController : UIViewController<SettingsViewDataSource>
@property (nonatomic, strong) SPTAudioStreamingController *player;
@end
