//
//  SongListViewController.h
//  Ashy Bines Super Circuit
//
//  Created by AQB Solutions-Mac Mini 2 on 03/01/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol SongListDelegate <NSObject>
@optional - (void) getSelectedSongName:(NSString *)name Url:(NSString *)songUrlStr;
@end

@interface SongListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    id<SongListDelegate>songListDelegate;
}
@property(strong,nonatomic) NSArray *songListArray;
@property(strong,nonatomic) NSString *playerName;
@property (strong, nonatomic) id songListDelegate;

@end
