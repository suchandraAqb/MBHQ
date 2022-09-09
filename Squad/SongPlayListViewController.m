//
//  SongPlayListViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 27/01/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "SongPlayListViewController.h"
#import "TableViewCell.h"
//#import "SongListViewController.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "SongListViewController.h"
#import "AddActionViewController.h"

@interface SongPlayListViewController ()
{
    IBOutlet UITableView *playListTable;
    AVAudioPlayer *player;
    NSArray *playlists;
    NSInteger selectedIndex;
    NSMutableArray *mutableDataArray;
    Utility *util;
    AppDelegate *ad;
    UIView *contentView;
    
    IBOutlet UIButton *playPauseButton;
    int selectedSection;
    
    IBOutlet UIView *selectionView;
}
@end

@implementation SongPlayListViewController
@synthesize delegate;

#pragma mark - IBAction
- (IBAction)expandCollapseButton:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = false;
        selectedSection = (int)sender.tag;
        [self getPlaylist:selectedSection];
    }else{
        sender.selected = true;
        selectedSection = -1;
        playlists = [[NSArray alloc]init];
        [playListTable reloadData];
    }
}
- (IBAction)backButton:(id)sender {
    //suchandra 4/1/17
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)playPauseButtonTapped:(id)sender {
    if (ad.mainAudioPlayer.isPlaying) {
        [ad.mainAudioPlayer pause];
        [playPauseButton setImage:[UIImage imageNamed:@"timer_pause_button.png"] forState:UIControlStateNormal];
        [defaults setObject:@"paused" forKey:@"isMusicPlaying"];
        [defaults setBool:false forKey:@"wasMusicPlaying"];
    } else {
        [ad.mainAudioPlayer play];
        [playPauseButton setImage:[UIImage imageNamed:@"play_all.png"] forState:UIControlStateNormal];
        [defaults setObject:@"playing" forKey:@"isMusicPlaying"];
        [defaults setBool:true forKey:@"wasMusicPlaying"];
    }
}
-(IBAction)appleAndSpotifyPressed:(UIButton *)sender {
    if (sender.tag == 0) {//apple
        selectionView.hidden = true;
    } else {//spotify
        SpotifyPlaylistViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpotifyPlaylist"];
        controller.delegate = delegate;
        controller.tempDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}
#pragma mark - End
-(void)sportifySongName:(NSString *)name Url:(NSString *)songUrlStr{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self->delegate respondsToSelector:@selector(sportifySelSongName:Url:)]) {
            [self->delegate sportifySelSongName:name Url:songUrlStr];
        }
    }];
}
#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    selectionView.hidden = true;
    if (![Utility isEmptyCheck:[defaults objectForKey:@"MusicListTypeIndex"]]) {
        selectedSection = [[defaults objectForKey:@"MusicListTypeIndex"] intValue];
    }else{
        selectedSection = -1;
    }
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"SongPlaylistHeaderView" bundle:nil];
    [playListTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"SongPlaylistHeaderView"];

    playListTable.estimatedSectionHeaderHeight = 50;
    playListTable.sectionHeaderHeight = UITableViewAutomaticDimension;
    util =[[Utility alloc]init];
    playListTable.delegate = self;
    playListTable.dataSource = self;
    selectedIndex=-1;
    mutableDataArray =[[NSMutableArray alloc]init];
    
    //    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    ////    NSArray *itemsFromGenericQuery = [everything items];
    //    MPMediaQuery *totalPlayListQuery=[MPMediaQuery playlistsQuery];
    ////    self.songsList = [NSMutableArray arrayWithArray:itemsFromGenericQuery];
    //    [playListTable reloadData];
    
    
    //    for(int i = 0; i < [playlists count]; i++)
    //    {
    //        NSLog(@"Playlist : %@", [[playlists objectAtIndex:i] valueForProperty: MPMediaPlaylistPropertyName]);
    //    }
    
    if (_isSelectMusic) {
        playPauseButton.hidden = true;
    } else {
        playPauseButton.hidden = false;
    }
//    if([delegate isKindOfClass:[AddGoalsViewController class]] || [delegate isKindOfClass:[AddActionViewController class]] || [delegate isKindOfClass:[AddVisionBoardViewController class]]){
//        selectionView.hidden = false;
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status){
        switch (status) {
            case MPMediaLibraryAuthorizationStatusNotDetermined: {
                // not determined
                [self showAlert];
                break;
            }
            case MPMediaLibraryAuthorizationStatusRestricted: {
                // restricted
                [self showAlert];
                break;
            }
            case MPMediaLibraryAuthorizationStatusDenied: {
                // denied
                [self showAlert];
                break;
            }
            case MPMediaLibraryAuthorizationStatusAuthorized: {
                // authorized
                if (![Utility isEmptyCheck:[defaults objectForKey:@"MusicListTypeIndex"]]) {
                    [self getPlaylist:[[defaults objectForKey:@"MusicListTypeIndex"] intValue]];
                }
                break;
            }
            default: {
                break;
            }
        }
    }];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [ad.mainAudioPlayer pause];
}
#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End

- (void) getPlaylist:(int) index{  //ah30
    dispatch_async(dispatch_get_main_queue(), ^{
        if (contentView) {
            [contentView removeFromSuperview];
        }
        contentView = [Utility activityIndicatorView:self];
    });
    MPMediaQuery *query;
    if (index == 0) {
        query = [MPMediaQuery albumsQuery];
    }else if(index == 1){
        query = [MPMediaQuery artistsQuery];
    }else if (index == 2){
        query = [MPMediaQuery genresQuery];
    }else if (index == 3){
        query = [MPMediaQuery playlistsQuery];
    }
    playlists = [query collections];
    if (playlists.count>0){
        /*for (MPMediaPlaylist *playlist in playlists) {
         //            NSLog (@"Playlist :%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
         NSArray *songs = [playlist items];
         for (MPMediaItem *song in songs) {
         NSString *strSongTitle =
         [song valueForProperty: MPMediaItemPropertyAssetURL];
         //                NSLog (@"Title : %@", strSongTitle);
         }
         }*/
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [playListTable reloadData];
            
            if (contentView) {
                [contentView removeFromSuperview];
            }
        });
        if([[defaults objectForKey:@"MusicListTypeIndex"] intValue] == index){
            MPMediaPlaylist *specificplaylist = [playlists objectAtIndex:[[defaults objectForKey:@"mediaSelectedIndex"] intValue]];
            NSArray *songs = [specificplaylist items];
            ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if (songs.count > 0 && !_isSelectMusic) {
                if ([defaults objectForKey:@"Shuffle"] && ![[defaults objectForKey:@"Shuffle"] isEqual:[NSNull null]]  && [[defaults objectForKey:@"Shuffle"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                    NSMutableArray *array = [NSMutableArray array];
                    for(int i=0; i<songs.count; i++) {
                        [array addObject:@(i)]; // @() is the modern objective-c syntax, to box the value into an NSNumber.
                    }
                    [ad.indexArray removeAllObjects];
                    [ad.indexArray addObjectsFromArray:[Utility shuffleFromArray:array]];
                    NSLog(@"arr %@",ad.indexArray);
                    [self playAudioWithName:@"" Extension:@"" Url:[[songs objectAtIndex:[[ad.indexArray objectAtIndex:0] intValue]] valueForProperty:MPMediaItemPropertyAssetURL]];
                    ad.mediaPlayingIndex = 0;
                } else {
                    [self playAudioWithName:@"" Extension:@"" Url:[[songs objectAtIndex:0] valueForProperty:MPMediaItemPropertyAssetURL]];
                    ad.mediaPlayingIndex = 0;
                }
                [defaults setBool:true forKey:@"wasMusicPlaying"];
                [defaults setObject:@"playing" forKey:@"isMusicPlaying"];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [playListTable reloadData];
                    
                    if (contentView) {
                        [contentView removeFromSuperview];
                    }
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [playListTable reloadData];
                
                if (contentView) {
                    [contentView removeFromSuperview];
                }
            });
        }
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [playListTable reloadData];
            
            if (contentView) {
                [contentView removeFromSuperview];
            }
        });
    }
    
    
   
}

-(void)showAlert {
    NSString *title = @"Media Library Permission is not enabled";
    NSString *message = @"To use Music Player you must turn on Media Library Permission in the Settings menu. Go to 'Settings'->'Media Library' and Tap on switch";
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Settings"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                    [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:^(BOOL success) {
                                            if(success){
                                                NSLog(@"Opened");
                                                }
                                            }];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(selectedSection == section)
        return playlists.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TableViewCell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSString *songTitle = @"";
    int selectedRow = -1;
    int tempSelectedSection = -1;
    if(indexPath.section == 0){
        MPMediaItemCollection *collection =[playlists objectAtIndex:indexPath.row];
        MPMediaItem *item = [collection representativeItem];
        songTitle = [item valueForProperty: MPMediaItemPropertyAlbumTitle];
    }else if(indexPath.section == 1){
        MPMediaItemCollection *collection =[playlists objectAtIndex:indexPath.row];
        MPMediaItem *item = [collection representativeItem];
        songTitle = [item valueForProperty: MPMediaItemPropertyArtist];
    }else if(indexPath.section == 2){
        MPMediaItemCollection *collection =[playlists objectAtIndex:indexPath.row];
        MPMediaItem *item = [collection representativeItem];
        songTitle = [item valueForProperty: MPMediaItemPropertyGenre];
    }else{
        MPMediaItem *song = [playlists objectAtIndex:indexPath.row];
        songTitle = [song valueForProperty: MPMediaPlaylistPropertyName];
    }
    cell.playListLabel.text = songTitle;
    if (!_isSelectMusic) {
        if ([defaults objectForKey:@"MusicListTypeIndex"] && ![[defaults objectForKey:@"MusicListTypeIndex"] isEqual:[NSNull null]]) {
            tempSelectedSection = [[defaults objectForKey:@"MusicListTypeIndex"] intValue];
        }
        if ([defaults objectForKey:@"saveselecttedrow"] && ![[defaults objectForKey:@"saveselecttedrow"] isEqual:[NSNull null]]) {
            selectedRow = [[defaults objectForKey:@"saveselecttedrow"] intValue];
        }
        if (indexPath.section == tempSelectedSection && indexPath.row == selectedRow) {
            cell.selectedView.layer.borderWidth = 2;
            cell.selectedView.layer.borderColor =[util colorWithHexString:@"EF00AC"].CGColor;
            cell.selectedView.alpha=0.5;
            cell.selectedView.layer.backgroundColor =[util colorWithHexString:@"7099FD"].CGColor;
        }else{
            cell.selectedView.layer.borderWidth = 0;
            cell.selectedView.layer.borderColor =[UIColor clearColor].CGColor;
            cell.selectedView.alpha=1;
            cell.selectedView.layer.backgroundColor =[UIColor whiteColor].CGColor;
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isSelectMusic) {
        selectedIndex=indexPath.row;
        MPMediaPlaylist *specificplaylist = [playlists objectAtIndex:indexPath.row];
        NSArray *songsList = [specificplaylist items];
        
        [mutableDataArray addObject:songsList];
        NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:mutableDataArray.count];
        //    for (NSArray *song in mutableDataArray) {
        NSData *songData = [NSKeyedArchiver archivedDataWithRootObject:archiveArray];
        [archiveArray addObject:songData];
        //    }
        [defaults setObject:[NSNumber numberWithInteger:indexPath.section] forKey:@"MusicListTypeIndex"];
        [defaults setInteger:selectedIndex forKey:@"saveselecttedrow"];
        //    NSLog (@"Playlist :%@", [specificplaylist valueForProperty: MPMediaPlaylistPropertyName]);
        NSString *songTitle = @"";
        if(indexPath.section == 0){
            MPMediaItemCollection *collection =[playlists objectAtIndex:indexPath.row];
            MPMediaItem *item = [collection representativeItem];
            songTitle = [item valueForProperty: MPMediaItemPropertyAlbumTitle];
        }else if(indexPath.section == 1){
            MPMediaItemCollection *collection =[playlists objectAtIndex:indexPath.row];
            MPMediaItem *item = [collection representativeItem];
            songTitle = [item valueForProperty: MPMediaItemPropertyArtist];
        }else if(indexPath.section == 2){
            MPMediaItemCollection *collection =[playlists objectAtIndex:indexPath.row];
            MPMediaItem *item = [collection representativeItem];
            songTitle = [item valueForProperty: MPMediaItemPropertyGenre];
        }else{
            MPMediaItem *song = [playlists objectAtIndex:indexPath.row];
            songTitle = [song valueForProperty: MPMediaPlaylistPropertyName];
        }
        [defaults setObject:songTitle forKey:@"playlistpropertylist"];
        
        //    [defaults setObject:specificplaylist forKey:@"mediaDetails"];
        [defaults setInteger:selectedIndex forKey:@"mediaSelectedIndex"];
        
        NSArray *songs = [specificplaylist items];
        ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (songs.count > 0) {
            if ([defaults objectForKey:@"Shuffle"] && ![[defaults objectForKey:@"Shuffle"] isEqual:[NSNull null]]  && [[defaults objectForKey:@"Shuffle"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
                NSMutableArray *array = [NSMutableArray array];
                for(int i=0; i<songs.count; i++) {
                    [array addObject:@(i)]; // @() is the modern objective-c syntax, to box the value into an NSNumber.
                }
                [ad.indexArray removeAllObjects];
                [ad.indexArray addObjectsFromArray:[Utility shuffleFromArray:array]];
                //            NSLog(@"arr %@",ad.indexArray);
                [self playAudioWithName:@"" Extension:@"" Url:[[songs objectAtIndex:[[ad.indexArray objectAtIndex:0] intValue]] valueForProperty:MPMediaItemPropertyAssetURL]];
                ad.mediaPlayingIndex = 0;
            } else {
                [self playAudioWithName:@"" Extension:@"" Url:[[songs objectAtIndex:0] valueForProperty:MPMediaItemPropertyAssetURL]];
                ad.mediaPlayingIndex = 0;
            }
            [defaults setBool:true forKey:@"wasMusicPlaying"];
            
        }
        
        
        //[self dismissViewControllerAnimated:YES completion:nil];
        
        //    MPMusicPlayerController *controller = [MPMusicPlayerController systemMusicPlayer];
        //    for (MPMediaItem *song in songsList) {
        //        [controller setNowPlayingItem:song];
        //        [controller prepareToPlay];
        //        [controller play];
        //    }
        //
        if ([delegate respondsToSelector:@selector(getPlayListName:)]) {
            [defaults setBool:true  forKey:@"PlaylistSet"];
            [delegate getPlayListName:songTitle];
            NSLog (@"Playlist :%@", songTitle);
            
        }
    } else {
    //********
    MPMediaPlaylist *specificplaylist = [playlists objectAtIndex:indexPath.row];

    NSArray *songsList = [specificplaylist items];
        for (int i=0; i<songsList.count; i++) {
//            MPMediaItem *song = [songsList objectAtIndex:i];
    //        NSURL *url = [song valueForProperty:MPMediaItemPropertyAssetURL];
    
//            [controller setNowPlayingItem:song];
//            [controller prepareToPlay];
//            [controller play];
        }
    
    
    
//        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
//        AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
//        [player play];
//    
//            NSError *error;
//            player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//    
//            if (!error) {
//                [player prepareToPlay];
//                [player play];
//            }
    
    
        SongListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SongListView"];
        controller.songListArray=songsList;
        NSString *songTitle = @"";
        if(indexPath.section == 0){
            MPMediaItemCollection *collection =[playlists objectAtIndex:indexPath.row];
            MPMediaItem *item = [collection representativeItem];
            songTitle = [item valueForProperty: MPMediaItemPropertyAlbumTitle];
        }else if(indexPath.section == 1){
            MPMediaItemCollection *collection =[playlists objectAtIndex:indexPath.row];
            MPMediaItem *item = [collection representativeItem];
            songTitle = [item valueForProperty: MPMediaItemPropertyArtist];
        }else if(indexPath.section == 2){
            MPMediaItemCollection *collection =[playlists objectAtIndex:indexPath.row];
            MPMediaItem *item = [collection representativeItem];
            songTitle = [item valueForProperty: MPMediaItemPropertyGenre];
        }else{
            MPMediaItem *song = [playlists objectAtIndex:indexPath.row];
            songTitle = [song valueForProperty: MPMediaPlaylistPropertyName];
        }
        controller.playerName=songTitle;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.songListDelegate = delegate;//(id)self.presentingViewController; //ah song
        [self presentViewController:controller animated:YES completion:nil];
    
    
    
//        for (MPMediaPlaylist *playlist in playlists) {
//            NSLog (@"Playlist :%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
//            NSArray *songs = [playlist items];
//            for (MPMediaItem *song in songs) {
//                NSString *strSongTitle =
//                [song valueForProperty: MPMediaItemPropertyTitle];
//                NSLog (@"Title : %@", strSongTitle);
//            }
//        }
    }
//        NSURL *url = [song valueForProperty:MPMediaItemPropertyAssetURL];
//    
//    //    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
//    //    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
//    //    [player play];
//    
//        NSError *error;
//        player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//    
//        if (!error) {
//            [player prepareToPlay];
//            [player play];
//        }
}

-(void)playAudioWithName:(NSString *)audioName Extension:(NSString *)extension Url:(NSURL *)mediaUrl{
    //    if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
    // Construct URL to sound file
    //        NSString *path = audioName; //[NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath],audioName,extension];
    NSURL *soundUrl = mediaUrl; //[NSURL fileURLWithPath:mediaUrl];
    //    NSLog(@"su %@",path);
    [defaults setObject:[mediaUrl absoluteString] forKey:@"currentMusicUrl"];
    
    //background
    NSError *sessionError = nil;
    @try {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient   error:&sessionError];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
    } @catch (NSException *exception) {
        NSLog(@"Audio Session error %@, %@", exception.reason, exception.userInfo);
        
    } @finally {
        NSLog(@"Audio Session finally");
    }

    
    
    // Create audio player object and initialize with URL to sound
    ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    ad.mainAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    //        NSLog(@"avv %f",audioPlayer.volume);
    ad.mainAudioPlayer.delegate = self;
    [ad.mainAudioPlayer setVolume:1.0]; //music volume
    [ad.mainAudioPlayer play];
    //    }
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SongPlaylistHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SongPlaylistHeaderView"];
    if (musicListTypeArray.count > 0) {
        if(selectedSection == section){
            sectionHeaderView.expandButton.selected = false;
        }else{
            sectionHeaderView.expandButton.selected = true;
        }
        sectionHeaderView.typeName.text =musicListTypeArray[section];
    }
    sectionHeaderView.expandButton.tag = section;
    [sectionHeaderView.expandButton addTarget:self
                                                    action:@selector(expandCollapseButton:)
                             forControlEvents:UIControlEventTouchUpInside];
    return  sectionHeaderView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  musicListTypeArray.count;
}
@end
