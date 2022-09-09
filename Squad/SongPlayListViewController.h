//
//  SongPlayListViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 27/01/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SongPlaylistHeaderView.h"
#import "SpotifyPlaylistViewController.h"
@protocol PlayListViewDelegate <NSObject>
@optional - (void) getPlayListName:(NSString *)playListName;
@optional - (void) sportifySelSongName:(NSString *)name Url:(NSString *)songUrlStr;
@end

@interface SongPlayListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate,SpotifyPlaylistDelegate>{
    id<PlayListViewDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
@property BOOL isSelectMusic;   //ah song

@end
