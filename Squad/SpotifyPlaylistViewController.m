//
//  SpotifyPlaylistViewController.m
//  Ashy Bines Super Circuit
//
//  Created by AQB SOLUTIONS on 13/09/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "SpotifyPlaylistViewController.h"
#import "Utility.h"
#import "TableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SpotifyTrackListViewController.h"
#import "AddActionViewController.h"

@interface SpotifyPlaylistViewController (){
    IBOutlet UIImageView *bgImageView;
    IBOutlet UITableView *spotifyListTableView;
    NSString *accessToken;
    NSString *userName;
    NSMutableArray *totalItemsArray;
    int offset;
    int limit;
    NSString *nextStr;
    
    UIView *contentView;
    UIActivityIndicatorView *activityView;
    NSString *playlistAPI;
    
    IBOutlet UITableView *songTableView;
    NSMutableDictionary *songPlaylistDict;
    NSString *activePlaylist;
    IBOutlet UILabel *headerLabel;
}

//@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) SPTAudioStreamingController *player;
@end

@implementation SpotifyPlaylistViewController
//@synthesize session;
- (void)viewDidLoad {
    [super viewDidLoad];
    songPlaylistDict = [NSMutableDictionary new];
    activePlaylist = @"";
    songTableView.hidden = true;
    songTableView.rowHeight = UITableViewAutomaticDimension;
    playlistAPI = @"";
//    NSError *sessionError = nil;
//    @try {
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient  error:&sessionError];
//        //[[AVAudioSession sharedInstance] setMode:AVAudioSessionModeVoiceChat error:&sessionError];
//        [[AVAudioSession sharedInstance] setActive:YES error:nil];
//        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//
//
//    }@catch (NSException *exception) {
//        NSLog(@"Audio Session error %@, %@", exception.reason, exception.userInfo);
//
//    } @finally {
//        NSLog(@"Audio Session finally");
//    }
    if ([UIScreen mainScreen].bounds.size.height ==480) {
        [bgImageView setImage:[UIImage imageNamed:@"bg_4s@2x.png"]];
    }
    
    contentView=[[UIView alloc]initWithFrame:self.parentViewController.view.frame];
    contentView.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:1.0f/255.0f blue:1.0f/255.0f alpha:0.8];
    activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame= CGRectMake(contentView.frame.size.width/2,20, 24, 24);
    activityView.color =[UIColor grayColor];
    activityView.center = [contentView convertPoint:contentView.center fromView:contentView.superview];
    [activityView startAnimating];
    [contentView addSubview: activityView];
    [self.view addSubview:contentView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getNotification:) name:@"spotifyLoginNotification" object:nil];
    
    totalItemsArray = [[NSMutableArray alloc]init];
    
    offset = 0;
    limit = 10;
    nextStr = @"";
    SPTAuth *auth = [SPTAuth defaultInstance];
    NSLog(@"%@",auth.session);
    if (![Utility isEmptyCheck:auth.session]) {
        if (auth.session.isValid) {
            [self loginUsingSession:auth.session];
        } else {
            [self login];
        }
    }else {
        [self login];
    }
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"spotifyLoginNotification" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)login{
    [[SPTAuth defaultInstance] setClientID:@"e92637672d6f485c9251f43094cad696"];    //ah new1
    [[SPTAuth defaultInstance] setRedirectURL:[NSURL URLWithString:@"squad-app-login://callback"]]; //ah new1
    [[SPTAuth defaultInstance] setRequestedScopes:@[SPTAuthStreamingScope]];
    
    // Construct a login URL and open it
    NSURL *loginURL = [[SPTAuth defaultInstance] loginURL];
    NSLog(@"%@",loginURL);
    // Opening a URL in Safari close to application launch may trigger
    // an iOS bug, so we wait a bit before doing so.
    [[UIApplication sharedApplication] performSelector:@selector(openURL:)
                                            withObject:loginURL afterDelay:0.7];
    [contentView removeFromSuperview];
    [activityView stopAnimating];
}


-(void)loginUsingSession:(SPTSession *)currentSession {
    dispatch_async(dispatch_get_main_queue(), ^{
        accessToken = currentSession.accessToken;
        //    // Get the player instance
        //    self.player = [SPTAudioStreamingController sharedInstance];
        //    self.player.delegate = self;
        //    // Start the player (will start a thread)
        //    [self.player startWithClientId:@"91d5b102c16b42a5a6c81e802e8f397b" error:nil];
        //    // Login SDK before we can start playback
        //    [self.player loginWithAccessToken:currentSession.accessToken];
        //    NSLog(@"at %@",currentSession.accessToken);
        
        SPTAuth *auth = [SPTAuth defaultInstance];
        
        if (self.player == nil) {
            NSError *error = nil;
            NSLog(@"%@\n%@",auth.clientID,auth.session.accessToken);
            if(![Utility isEmptyCheck:auth.clientID] && ![Utility isEmptyCheck:auth.session.accessToken]){
                self.player = [SPTAudioStreamingController sharedInstance];
                if (!self.player.initialized) {
                    if ([self.player startWithClientId:auth.clientID audioController:nil allowCaching:YES error:&error]) {
                        self.player.delegate = self;
                        self.player.playbackDelegate = self;
                        self.player.diskCache = [[SPTDiskCache alloc] initWithCapacity:1024 * 1024 * 64];
                        [self.player loginWithAccessToken:auth.session.accessToken];
                    }else{
                        self.player = nil;
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error init" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                        [self presentViewController:alert animated:YES completion:nil];
                        [self closeSession];
                    }
                }else{
                    [self getProfileWebserviceCall];
                }
            }else{
                [self login];
            }
        }else{
            [self getProfileWebserviceCall];
        }
    });
}

-(void)updateUI {
    SPTAuth *auth = [SPTAuth defaultInstance];
    
//    if (self.player.metadata == nil || self.player.metadata.currentTrack == nil) {
//        self.coverView.image = nil;
//        self.coverView2.image = nil;
//        return;
//    }
//
//    [self.spinner startAnimating];
//
//    self.nextButton.enabled = self.player.metadata.nextTrack != nil;
//    self.prevButton.enabled = self.player.metadata.prevTrack != nil;
//    self.trackTitle.text = self.player.metadata.currentTrack.name;
//    self.artistTitle.text = self.player.metadata.currentTrack.artistName;
//    self.playbackSourceTitle.text = self.player.metadata.currentTrack.playbackSourceName;
    
    [SPTTrack trackWithURI: [NSURL URLWithString:self.player.metadata.currentTrack.uri]
               accessToken:auth.session.accessToken
                    market:nil
                  callback:^(NSError *error, SPTTrack *track) {
                      MPNowPlayingInfoCenter *center  = [MPNowPlayingInfoCenter defaultCenter];
                      NSMutableDictionary *songInfo = [[NSMutableDictionary alloc]initWithDictionary: @{MPMediaItemPropertyTitle: self.player.metadata.currentTrack.name, MPMediaItemPropertyArtist: self.player.metadata.currentTrack.artistName}];
                      NSURL *imageURL = track.album.largestCover.imageURL;
                      if (imageURL == nil) {
                          NSLog(@"Album %@ doesn't have any images!", track.album);
//                          self.coverView.image = nil;
//                          self.coverView2.image = nil;
                          return;
                      }
                      
                      // Pop over to a background queue to load the image over the network.
                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                          NSError *error = nil;
                          UIImage *image = nil;
                          NSData *imageData = [NSData dataWithContentsOfURL:imageURL options:0 error:&error];
                          
                          if (imageData != nil) {
                              image = [UIImage imageWithData:imageData];
                          }
                          
                          
                          // …and back to the main queue to display the image.
                          dispatch_async(dispatch_get_main_queue(), ^{
//                              [self.spinner stopAnimating];
//                              self.coverView.image = image;
                              if (image == nil) {
                                  NSLog(@"Couldn't load cover image with error: %@", error);
                                  return;
                              }else{
                                  
                                  MPMediaItemArtwork *art = [[MPMediaItemArtwork alloc]initWithBoundsSize:image.size requestHandler:^UIImage * _Nonnull(CGSize size) {
                                      return image;
                                  }];
                                  if (art) {
                                      songInfo[MPMediaItemPropertyArtwork] = art;
                                  }
                              }
                              center.nowPlayingInfo = songInfo;
                          });
                      });

                  }];
    
    
}

- (void)closeSession {
    NSError *error = nil;
    if (![self.player stopWithError:&error]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error deinit" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [SPTAuth defaultInstance].session = nil;
   // [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)audioStreamingDidLogin:(SPTAudioStreamingController *)audioStreaming {
    
    [contentView removeFromSuperview];
    [activityView stopAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getProfileWebserviceCall];
    });
    
    [defaults setBool:YES forKey:@"isSpotifyPremium"];
    
//    SpotifyTrackListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpotifyTrackList"];
    //    controller.playlistID = [[totalItemsArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    //    controller.playlistName = [[totalItemsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    //    controller.accessToken = session.accessToken;
    //    controller.href = [[[totalItemsArray objectAtIndex:indexPath.row] objectForKey:@"tracks"] objectForKey:@"href"];
//    [self.navigationController pushViewController:controller animated:YES];
    
//        NSURL *url = [NSURL URLWithString:@"spotify:track:58s6EuEYJdlb0kO7awm3Vp"];
//        [self.player playSpotifyURI:@"spotify:track:1PTqbs9FV8hSJCS7OOF5OC" startingWithIndex:0 startingWithPosition:0 callback:^(NSError *error) {
//            if (error != nil) {
//                NSLog(@"*** failed to play: %@", error);
//                return;
//            }
//        }];
}

-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveError:(SpErrorCode)errorCode withName:(NSString*)name {
    NSLog(@"login err %lu ||| name %@",(unsigned long)errorCode,name);
    
    if(errorCode==SPTErrorCodeNeedsPremium){
        [contentView removeFromSuperview];
        [activityView stopAnimating];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getProfileWebserviceCall];
        });
        [defaults setBool:NO forKey:@"isSpotifyPremium"];
    }
}

#pragma mark - Local Notification

-(void)getNotification:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        contentView=[[UIView alloc]initWithFrame:self.parentViewController.view.frame];
        contentView.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:1.0f/255.0f blue:1.0f/255.0f alpha:0.8];
        activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.frame= CGRectMake(contentView.frame.size.width/2,20, 24, 24);
        activityView.color =[UIColor grayColor];
        activityView.center = [contentView convertPoint:contentView.center fromView:contentView.superview];
        [activityView startAnimating];
        [contentView addSubview: activityView];
        [self.view addSubview:contentView];
        
        NSLog(@"noti recd");
        SPTAuth *auth = [SPTAuth defaultInstance];
        if (auth.session && [auth.session isValid]) {
            [self loginUsingSession:auth.session];
        }else {
            NSLog(@"*** Failed to log in");
            [self login];
        }
    });
}

-(void)nonPremiumSpotifyAlert:(NSString *)openSpotifyUrl{
    
    NSString *title = @"Alert" ;
    NSString *message = @"Hi Spotify only allows premium users to stream playlists within other apps. \nIf you use the free Spotify version, simply start your music in the Spotify app and then come back to Squad to play your session.";
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Open Spotify"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                                   NSURL *spotify = [NSURL URLWithString:openSpotifyUrl];
                                   [[UIApplication sharedApplication] openURL:spotify];
                                   
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - End
#pragma mark - IBAction
-(IBAction)rewind:(id)sender {
    [self.player skipPrevious:nil];
}

-(IBAction)playPause:(id)sender {
    [self.player setIsPlaying:!self.player.playbackState.isPlaying callback:nil];
}

-(IBAction)fastForward:(id)sender {
    [self.player skipNext:nil];
}

- (IBAction)backButton:(id)sender {
//    NSArray *viewControllers = [[self navigationController] viewControllers];
//    //    NSLog(@"vc %@",viewControllers);
//    id prevObj = [viewControllers objectAtIndex:viewControllers.count-3];
//    [[self navigationController] popToViewController:prevObj animated:YES];
   // [self.navigationController popViewControllerAnimated:YES];
    if (!songTableView.isHidden) {
        songTableView.hidden = true;
        spotifyListTableView.hidden = false;
        headerLabel.text = @"Spotify Playlist";
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Webservice Call
-(void)getProfileWebserviceCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
            contentView.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:1.0f/255.0f blue:1.0f/255.0f alpha:0.8];
        });
        NSMutableURLRequest *request=[Utility getRequestForSpofity:@"" api:@"profile" append:@"" forAction:@"GET" accessToken:accessToken url:@""];
        
        NSURLSession *urlSession = [NSURLSession sharedSession];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        urlSession = [NSURLSession sessionWithConfiguration:configuration];
        
        [[urlSession dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (contentView) {
                                [contentView removeFromSuperview];
                            }
                            if (!error) {
                                //NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                //NSLog(@"responseString %@",responseString);
                                
                                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                userName = [json objectForKey:@"id"];
                                [self getPlaylistWebserviceCallWithCell:nil withApiName:playlistAPI];
                                
                            }else{
                                [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                            }
                        });
                    }] resume];
        
    }
    else{
        [Utility msg:@"Please Check Your network connection and try again." title:@"Error !" controller:self haveToPop:NO];
    }
}

-(void)getPlaylistWebserviceCallWithCell:(UITableViewCell *)cell withApiName:(NSString *)apiName{
    if (Utility.reachable) {
        if (cell) {
            contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, spotifyListTableView.frame.size.width, cell.frame.size.height)];
            contentView.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:1.0f/255.0f blue:1.0f/255.0f alpha:0.8];
            
            [cell addSubview:contentView];
        }else{
            contentView=[[UIView alloc]initWithFrame:self.parentViewController.view.frame];
            contentView.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:1.0f/255.0f blue:1.0f/255.0f alpha:0.8];
            [self.view addSubview:contentView];
        }
        activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.frame= CGRectMake(contentView.frame.size.width/2,20, 24, 24);
        activityView.color =[UIColor grayColor];
        activityView.center = [contentView convertPoint:contentView.center fromView:contentView.superview];
        [activityView startAnimating];
        [contentView addSubview: activityView];
        
        NSString *lastQueryParameters = [NSString stringWithFormat:@"%@&offset=%d&limit=%d",accessToken,offset,limit];
        NSMutableURLRequest *request;
        if([apiName isEqualToString:@"featureList"]){
            request=[Utility getRequestForSpofity:@"" api:@"featureList" append:@"" forAction:@"GET" accessToken:lastQueryParameters url:@""];
            //albums
        }else{
           request=[Utility getRequestForSpofity:@"" api:@"playlists" append:userName forAction:@"GET" accessToken:lastQueryParameters url:@""];
        }
        

        NSURLSession *urlSession = [NSURLSession sharedSession];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        urlSession = [NSURLSession sessionWithConfiguration:configuration];
        
        [[urlSession dataTaskWithRequest:request
                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               if (!error) {
                                   NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   //                                NSLog(@"responseString %@",responseString);
                                   
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   
                                   [self->contentView removeFromSuperview];
                                   [self->activityView stopAnimating];
                                   
                                   if (![Utility isEmptyCheck:[json objectForKey:@"items"]] && ![self->playlistAPI isEqualToString:@"featureList"]) {
                                       
                                       [self->totalItemsArray addObjectsFromArray:[json objectForKey:@"items"]];
                                       if ([json objectForKey:@"next"] && ![[json objectForKey:@"next"] isEqual:[NSNull null]]) {
                                           self->nextStr = [json objectForKey:@"next"];
                                       }
                                       [self->spotifyListTableView reloadData];
                                       
                                   }else if (![Utility isEmptyCheck:json] && [self->playlistAPI isEqualToString:@"featureList"]) {
                                       [self->totalItemsArray addObject:json];
                                           if ([json objectForKey:@"next"] && ![[json objectForKey:@"next"] isEqual:[NSNull null]]) {
                                               self->nextStr = [json objectForKey:@"next"];
                                           }
                                           [self->spotifyListTableView reloadData];
                                   }
                                   else{
                                       if(![self->playlistAPI isEqualToString:@"featureList"]){
                                           self->playlistAPI = @"featureList";
                                           [self getPlaylistWebserviceCallWithCell:cell withApiName:self->playlistAPI];
                                       }
                                       [self->spotifyListTableView reloadData];
                                   }
                                   
                              }else{
                                   [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                   [self->contentView removeFromSuperview];
                                   [self->activityView stopAnimating];
                               }
                           });
                       }] resume];
        
    }else{
        [Utility msg:@"Please Check Your network connection and try again." title:@"Error !" controller:self haveToPop:NO];
    }
}
-(void)getSongListAPI:(NSString *)uriKey{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->contentView=[[UIView alloc]initWithFrame:self.view.frame];
            self->contentView.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:1.0f/255.0f blue:1.0f/255.0f alpha:0.8];
            [self.view addSubview:self->contentView];
            
            self->activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            self->activityView.frame= CGRectMake(self->contentView.frame.size.width/2,20, 24, 24);
            self->activityView.color =[UIColor grayColor];
            self->activityView.center = [self->contentView convertPoint:self->contentView.center fromView:self->contentView.superview];
            [self->activityView startAnimating];
            [self->contentView addSubview: self->activityView];
        });
//        activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        activityView.frame= CGRectMake(contentView.frame.size.width/2,20, 24, 24);
//        activityView.color =[UIColor grayColor];
//        activityView.center = [contentView convertPoint:contentView.center fromView:contentView.superview];
//        [activityView startAnimating];
//        [contentView addSubview: activityView];
        
        NSString *lastQueryParameters = [NSString stringWithFormat:@"%@",accessToken];//&offset=%d&limit=%d",accessToken,offset,limit];
        NSMutableURLRequest *request = [Utility getRequestForSpofity:@"" api:@"songList" append:uriKey forAction:@"GET" accessToken:lastQueryParameters url:@""];
        
        NSURLSession *urlSession = [NSURLSession sharedSession];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        urlSession = [NSURLSession sessionWithConfiguration:configuration];
        
        [[urlSession dataTaskWithRequest:request
                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               [self->contentView removeFromSuperview];
                               [self->activityView stopAnimating];
                               if (!error) {
//                                   NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   //                                NSLog(@"responseString %@",responseString);
                                   
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   
                                   
                                   if (![Utility isEmptyCheck:[json objectForKey:@"items"]]) {
                                       NSArray *song = [json objectForKey:@"items"];
                                       [self->songPlaylistDict setObject:song forKey:uriKey];
                                       self->songTableView.hidden = false;
                                       self->spotifyListTableView.hidden = true;
                                       self->headerLabel.text = @"Songs";
                                       [self->songTableView reloadData];
                                       
                                   }
                                   
                               }else{
                                   [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                   
                               }
                           });
                       }] resume];
        
    }else{
        [Utility msg:@"Please Check Your network connection and try again." title:@"Error !" controller:self haveToPop:NO];
    }
}
#pragma mark - TableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == songTableView) {
        NSArray *songArray = [songPlaylistDict objectForKey:activePlaylist];
        return songArray.count;
    }
    return totalItemsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == songTableView){
        return UITableViewAutomaticDimension;
    }else{
        return 80;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"TableViewCell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //    NSLog(@"ir %ld ta %lu",(long)indexPath.row,(unsigned long)[totalArray count]);
    if (tableView == songTableView) {
        NSArray *songArray = [songPlaylistDict objectForKey:activePlaylist];
        
        NSString *songName = ![Utility isEmptyCheck:[[[songArray objectAtIndex:indexPath.row] objectForKey:@"track"]objectForKey:@"name"]]?[[[songArray objectAtIndex:indexPath.row] objectForKey:@"track"]objectForKey:@"name"]:@"";
        cell.spotifyListLabel.text = songName;
        
        return cell;
    }
    if ([nextStr length] > 0 && indexPath.row == [totalItemsArray count]-1) {
        nextStr = @"";
        offset+=limit;
        [self getPlaylistWebserviceCallWithCell:(TableViewCell *)cell withApiName:playlistAPI];
    } else {
        NSArray *imageArray = [[totalItemsArray objectAtIndex:indexPath.row] objectForKey:@"images"];
        [cell.spotifyListImageView sd_setImageWithURL:[NSURL URLWithString:[[imageArray objectAtIndex:0] objectForKey:@"url"]]
                                     placeholderImage:[UIImage imageNamed:@"details_no_image.png"] options:SDWebImageScaleDownLargeImages];
        
        cell.spotifyListLabel.text = [[totalItemsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        NSString *trackNoStr = [[[[totalItemsArray objectAtIndex:indexPath.row] objectForKey:@"tracks"] objectForKey:@"total"] stringValue];
        cell.spotifyTracksNo.text = [NSString stringWithFormat:@"%@ tracks",trackNoStr];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if(tableView == songTableView){
        NSArray *songArray = [songPlaylistDict objectForKey:activePlaylist];
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self->_tempDelegate respondsToSelector:@selector(sportifySongName:Url:)]) {
                [self->_tempDelegate sportifySongName:[[[songArray objectAtIndex:indexPath.row] objectForKey:@"track"]objectForKey:@"name"] Url:[[[songArray objectAtIndex:indexPath.row] objectForKey:@"track"]objectForKey:@"uri"]];
            }
        }];
        return;
    }
    if(![defaults boolForKey:@"isSpotifyPremium"]){
        
        NSDictionary *dict = [totalItemsArray objectAtIndex:indexPath.row];
        NSString *spotify = @"https://open.spotify.com/browse";
        if(![Utility isEmptyCheck:dict[@"external_urls"]]){
            NSDictionary *external_urls = dict[@"external_urls"];
            if(![Utility isEmptyCheck:external_urls[@"spotify"]]){
                spotify = external_urls[@"spotify"];
            }
        }
        
        [self nonPremiumSpotifyAlert:spotify];
       
       return;
    }
//    if ([_delegate isKindOfClass:[AddGoalsViewController class]] || [_delegate isKindOfClass:[AddActionViewController class]] || [_delegate isKindOfClass:[AddVisionBoardViewController class]]) {
//        NSDictionary *dict = [self->totalItemsArray objectAtIndex:indexPath.row];
//        activePlaylist = [dict objectForKey:@"id"];
//        if (![Utility isEmptyCheck:[songPlaylistDict objectForKey:activePlaylist]]) {
//            self->songTableView.hidden = false;
//            self->spotifyListTableView.hidden = true;
//            self->headerLabel.text = @"Songs";
//            [self->songTableView reloadData];
//        } else {
//            [self getSongListAPI:activePlaylist];
//        }
//    }else{
        [defaults setObject:nil forKey:@"mediaItemCollection"];
        [defaults setObject:[[totalItemsArray objectAtIndex:indexPath.row] objectForKey:@"uri"] forKey:@"selectedSpotifyCollectionUri"];
        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[totalItemsArray objectAtIndex:indexPath.row] objectForKey:@"external_urls"] objectForKey:@"spotify"]]];
    
//    SpotifyTrackListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpotifyTrackList"];
//    controller.playlistID = [[totalItemsArray objectAtIndex:indexPath.row] objectForKey:@"id"];
//    controller.playlistName = [[totalItemsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
//    controller.accessToken = session.accessToken;
//    controller.href = [[[totalItemsArray objectAtIndex:indexPath.row] objectForKey:@"tracks"] objectForKey:@"href"];
//    [self.navigationController pushViewController:controller animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == songTableView) {
        return;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - Track Player Delegates

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message from Spotify"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePlaybackStatus:(BOOL)isPlaying {
    NSLog(@"is playing = %d", isPlaying);
    if (isPlaying) {
        [self activateAudioSession];
    } else {
        [self deactivateAudioSession];
    }
}

-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeMetadata:(SPTPlaybackMetadata *)metadata {
    [self updateUI];
}

-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceivePlaybackEvent:(SpPlaybackEvent)event withName:(NSString *)name {
    NSLog(@"didReceivePlaybackEvent: %zd %@", event, name);
    NSLog(@"isPlaying=%d isRepeating=%d isShuffling=%d isActiveDevice=%d positionMs=%f",
          self.player.playbackState.isPlaying,
          self.player.playbackState.isRepeating,
          self.player.playbackState.isShuffling,
          self.player.playbackState.isActiveDevice,
          self.player.playbackState.position);
}

- (void)audioStreamingDidLogout:(SPTAudioStreamingController *)audioStreaming {
    [self closeSession];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveError:(NSError* )error {
    NSLog(@"didReceiveError: %zd %@", error.code, error.localizedDescription);
    
    if (error.code == SPErrorNeedsPremium) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Premium account required" message:@"Premium account is required to showcase application functionality. Please login using premium account." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            [self closeSession];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePosition:(NSTimeInterval)position {
//    if (self.isChangingProgress) {
//        return;
//    }
//    self.progressSlider.value = position/self.player.metadata.currentTrack.duration;
    
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didStartPlayingTrack:(NSString *)trackUri {
    NSLog(@"Starting %@", trackUri);
    NSLog(@"Source %@", self.player.metadata.currentTrack.playbackSourceUri);
    // If context is a single track and the uri of the actual track being played is different
    // than we can assume that relink has happended.
    BOOL isRelinked = [self.player.metadata.currentTrack.playbackSourceUri containsString: @"spotify:track"]
    && ![self.player.metadata.currentTrack.playbackSourceUri isEqualToString:trackUri];
    NSLog(@"Relinked %d", isRelinked);
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didStopPlayingTrack:(NSString *)trackUri {
    NSLog(@"Finishing: %@", trackUri);
}


- (void)audioStreamingDidSkipToNextTrack:(SPTAudioStreamingController *)audioStreaming{
    
    
}
#pragma mark - Audio Session

- (void)activateAudioSession
{
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionAllowBluetoothA2DP error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];

    
}

- (void)deactivateAudioSession
{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [self resignFirstResponder];
}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    NSLog(@"received event!");
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause: {
                [self playPause:nil];
                break;
            }
            case UIEventSubtypeRemoteControlPlay: {
                [self playPause:nil];
                break;
            }
            case UIEventSubtypeRemoteControlPause: {
                [self playPause:nil];
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack: {
                [self rewind:nil];
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack: {
                [self fastForward:nil];
                break;
            }
            default:
                break;
        }
    }
}
@end
