//
//  SpotifyPlaylistViewController.h
//  Ashy Bines Super Circuit
//
//  Created by AQB SOLUTIONS on 13/09/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>
@protocol SpotifyPlaylistDelegate <NSObject>
@optional - (void) sportifyPlaylistSelected:(NSString *)uri;
@optional - (void) sportifySongName:(NSString *)name Url:(NSString *)songUrlStr;
@end

@interface SpotifyPlaylistViewController : UIViewController<SPTAudioStreamingDelegate,SPTAudioStreamingPlaybackDelegate>
-(void)loginUsingSession:(SPTSession *)session;
//@property (strong,nonatomic) SPTSession *session;
@property (strong,nonatomic) id delegate;
@property (strong,nonatomic) id tempDelegate;
@end
