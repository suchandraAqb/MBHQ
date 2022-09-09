//
//  SpotifyTrackListViewController.h
//  Ashy Bines Super Circuit
//
//  Created by AQB SOLUTIONS on 14/09/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpotifyTrackListViewController : UIViewController
@property (strong, nonatomic) NSString *playlistName;
@property (strong, nonatomic) NSString *playlistID;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *href;
@end
