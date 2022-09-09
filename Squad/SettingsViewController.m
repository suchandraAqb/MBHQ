//
//  SettingsViewController.m
//  Ashy Bines Super Circuit
//
//  Created by AQB SOLUTIONS on 09/09/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "SettingsViewController.h"
#import "SpotifyPlaylistViewController.h"
#import "TableViewCell.h"
#import "PlayListViewController.h"
#import "FaqViewController.h"
#import "CustomProgramSetupViewController.h"
#import "SettingListHeader.h"
#import "ExerciseVideoViewController.h"
#import "MenuSettingsViewController.h"

@interface SettingsViewController (){
    IBOutlet UITableView *settingTable;
    IBOutlet UIButton *menuButton;  //ah123
    IBOutlet UIButton *backButton;
    
    NSMutableArray *settingArray;

    UIView *contentView;
    ExerciseVideoViewController *parent;
    BOOL keepPlaying;
    
    

}
@end

@implementation SettingsViewController
@synthesize audioPlayerViewController,spotifyPlayerViewController,currentViewController,keepPlaying,delegate,circuitPlaying;

- (void)viewDidLoad {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"SettingListHeader" bundle:nil];
    [settingTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"SettingListHeader"];
    [self refreshTable];
    // Get the storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // Fetch the iOSProductsList and iOSPurchasesList view controllers from our storyboard
    audioPlayerViewController = [storyboard instantiateViewControllerWithIdentifier:@"AudioPlayer"];
    spotifyPlayerViewController = [storyboard instantiateViewControllerWithIdentifier:@"SpotifyPlayer"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    
    if ([self.parentViewController isKindOfClass:[ExerciseVideoViewController class]]) {
        parent = (ExerciseVideoViewController *)self.parentViewController;
    }else{
        keepPlaying = NO;
    }
    [self refreshTable];
    if(![Utility isEmptyCheck:[defaults objectForKey:@"selectedSpotifyCollectionUri"]]){
        [self cycleFromViewController:self.currentViewController toViewController:spotifyPlayerViewController];
    }else{
        [self cycleFromViewController:self.currentViewController toViewController:audioPlayerViewController];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - PrivateMethod
// Transition from the old view controller to the new one
-(void)cycleFromViewController:(UIViewController *)oldViewController toViewController:(UIViewController *)newViewController
{
    assert(newViewController != nil);
    if (oldViewController != nil){
//        if ([self.currentViewController isKindOfClass:[SpotifyPlayerViewController class]]) {
//            SpotifyPlayerViewController *controller = (SpotifyPlayerViewController *)self.currentViewController;
//            [controller.player setIsPlaying:NO callback:nil];
//        }// AY 29-Dec-2017
        
        [oldViewController willMoveToParentViewController:nil];
        [oldViewController.view removeFromSuperview];
        [oldViewController removeFromParentViewController];
        
    }
    
    [self addChildViewController:newViewController];
    
    CGRect frame = newViewController.view.frame;
    frame.size.height = CGRectGetHeight(self.containerView.frame);
    frame.size.width = CGRectGetWidth(self.containerView.frame);
    newViewController.view.frame = frame;
    [self.containerView addSubview:newViewController.view];
    [newViewController didMoveToParentViewController:self];
    self.currentViewController = newViewController;
    [self refreshView];
    
}
-(void)refreshTable{
    settingArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *musicDict1 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *musicDict2 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *musicDict3 = [[NSMutableDictionary alloc] init];
    [musicDict1 setObject:@"APPLE" forKey:@"title"];
    [musicDict1 setObject:@"ic_playlist.png" forKey:@"image"];
    if ([defaults objectForKey:@"playlistname"] && ![[defaults objectForKey:@"playlistname"] isEqual:[NSNull null]]) {
        [musicDict1 setObject:[defaults objectForKey:@"playlistname"] forKey:@"subtitle"];
    }else{
        [musicDict1 setObject:@"" forKey:@"subtitle"];
    }
    
    [musicDict2 setObject:@"SPOTIFY" forKey:@"title"];
    [musicDict2 setObject:@"ic_spotify.png" forKey:@"image"];
    [musicDict2 setObject:@"" forKey:@"subtitle"];
    //NSLog(@"%@\n%@\n%@\n%@",[defaults objectForKey:@"Motivation"],[defaults objectForKey:@"Inbetween Rounds"],[defaults objectForKey:@"Motivation"],[defaults objectForKey:@"Voice Over"],[defaults objectForKey:@"Bell"]);
    
    [musicDict3 setObject:@"INBETWEEN ROUNDS" forKey:@"title"];
    if ([defaults objectForKey:@"Inbetween Rounds"] && ![[defaults objectForKey:@"Inbetween Rounds"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Inbetween Rounds"] caseInsensitiveCompare:@"KEEPS PLAYING"] == NSOrderedSame) {
        [musicDict3 setObject:@"KEEPS PLAYING" forKey:@"subtitle"];
    } else if ([defaults objectForKey:@"Inbetween Rounds"] && ![[defaults objectForKey:@"Inbetween Rounds"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Inbetween Rounds"] caseInsensitiveCompare:@"STOPS PLAYING"] == NSOrderedSame) {
        [musicDict3 setObject:@"STOPS PLAYING" forKey:@"subtitle"];
    } else if ([defaults objectForKey:@"Inbetween Rounds"] && ![[defaults objectForKey:@"Inbetween Rounds"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Inbetween Rounds"] caseInsensitiveCompare:@"PLAY SOFTER"] == NSOrderedSame) {
        [musicDict3 setObject:@"PLAY SOFTER" forKey:@"subtitle"];
    }
    [musicDict3 setObject:@"ic_headphone.png" forKey:@"image"];
    
    //NSArray *musicArray = [[NSArray alloc]initWithObjects:musicDict1,musicDict2,musicDict3, nil];
    NSArray *musicArray = [[NSArray alloc]initWithObjects:musicDict1,musicDict2, nil];
    NSMutableDictionary *soundsDict1 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *soundsDict2 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *soundsDict3 = [[NSMutableDictionary alloc] init];
    
    [soundsDict1 setObject:@"MUSIC SOUND" forKey:@"title"];
    [soundsDict1 setObject:@"ic_playlist.png" forKey:@"image"];
    if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
        [soundsDict1 setObject:@"OFF" forKey:@"subtitle"];
    } else if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
        [soundsDict1 setObject:@"ON" forKey:@"subtitle"];
    }
    [soundsDict2 setObject:@"VOICE OVER" forKey:@"title"];
    [soundsDict2 setObject:@"ic_voice.png" forKey:@"image"];
    if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
        [soundsDict2 setObject:@"OFF" forKey:@"subtitle"];
    } else if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
        [soundsDict2 setObject:@"ON" forKey:@"subtitle"];
    }
    
    [soundsDict3 setObject:@"BELL" forKey:@"title"];
    [soundsDict3 setObject:@"bell.png" forKey:@"image"];
    if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
        [soundsDict3 setObject:@"OFF" forKey:@"subtitle"];
    } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
        [soundsDict3 setObject:@"ON" forKey:@"subtitle"];
    }
    NSArray *soundsArray = [[NSArray alloc]initWithObjects:soundsDict1,soundsDict2,soundsDict3, nil];
    NSDictionary *musicDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"MY MUSIC",@"title",@"settings_header_bg_music.png",@"bg_image",musicArray,@"data", nil];
    NSDictionary *soundDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"SOUND",@"title",@"settings_header_bg_sound.png",@"bg_image",soundsArray,@"data", nil];
    
    settingArray = [[NSMutableArray alloc]initWithObjects:musicDict,soundDict, nil];
    [settingTable reloadData];
}
-(void)refreshView{
    //dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.currentViewController isKindOfClass:[AudioPlayerViewController class]]) {
            AudioPlayerViewController *controller = (AudioPlayerViewController *)self.currentViewController;
            [controller reloadUI];
        }else if ([self.currentViewController isKindOfClass:[SpotifyPlayerViewController class]]) {
            SpotifyPlayerViewController *controller = (SpotifyPlayerViewController *)self.currentViewController;
            [controller reloadUI];
        }
   // });
}


#pragma mark - End

#pragma mark - IBAction
-(IBAction)logoTapped:(id)sender {  //ah30
    if(([Utility isSubscribedUser] && [Utility isOfflineMode]) || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
        if (!isAllTaskCompleted ){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
//            TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
            GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    
}
- (IBAction)backButton:(id)sender {
    if (![Utility isEmptyCheck:parent]) {
        [parent changePage:nil];
    }else{
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self.slidingViewController anchorTopViewToLeftAnimated:YES];
            [self.slidingViewController resetTopViewAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        if ([self->delegate respondsToSelector:@selector(updateRoundlist)]) {
            [self->delegate updateRoundlist];
        }
    }
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
-(IBAction)spotifyButtonTapped:(id)sender{
 //   [Utility msg:@"Coming on March 20." title:@"Alert" controller:self haveToPop:NO];
    SpotifyPlaylistViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpotifyPlaylist"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)faqButtonTapped:(id)sender {
    [Utility msg:@"Coming Soon." title:@"Alert" controller:self haveToPop:NO];
//    CustomProgramSetupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomProgramSetup"];
//    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - PlayListDelegate

#pragma mark - SettingsPickerDelegate
-(void) updateSettingsCustomPickerValue:(NSString *)key withValue:(NSString *)pickerValue {
    [defaults setObject:pickerValue forKey:key];
    [defaults synchronize];
    [self refreshTable];
}
#pragma mark - TableView Datasource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  settingArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (settingArray.count >section) {
        NSDictionary *dataDict = settingArray[section];
        if(![Utility isEmptyCheck:dataDict] &&![Utility isEmptyCheck:dataDict[@"data"]]){
            NSArray *dataArray = dataDict[@"data"];
            return dataArray.count;
        }else{
            return 0;
        }
    }
    return 0;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SettingListHeader *settingListHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SettingListHeader"];
    if (settingArray.count >section) {
        NSDictionary *dataDict = settingArray[section];
        settingListHeader.headerBg.image = [UIImage imageNamed:dataDict[@"bg_image"]];
        settingListHeader.headerName.text = ![Utility isEmptyCheck:dataDict[@"title"]] ? dataDict[@"title"] : @"";;
    }
    return  settingListHeader;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"TableViewCell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (settingArray.count >indexPath.section) {
        NSDictionary *dataDict = settingArray[indexPath.section];
        if(![Utility isEmptyCheck:dataDict] &&![Utility isEmptyCheck:dataDict[@"data"]]){
            NSArray *dataArray = dataDict[@"data"];
            if (dataArray.count > indexPath.row) {
                NSDictionary *cellData =dataArray[indexPath.row];
                if (![Utility isEmptyCheck:cellData]) {
                    cell.settingsMusicImageView.image = [UIImage imageNamed:cellData[@"image"]];
                    cell.settingsMusicTitleLabel.text = ![Utility isEmptyCheck:cellData[@"title"]] ? cellData[@"title"] :@""; ;
                    cell.settingsMusicSubTitleLabel.text =![Utility isEmptyCheck:cellData[@"subtitle"]] ? cellData[@"subtitle"] :@"";
                }
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (settingArray.count >indexPath.section) {
        NSDictionary *dataDict = settingArray[indexPath.section];
        if(![Utility isEmptyCheck:dataDict] &&![Utility isEmptyCheck:dataDict[@"data"]]){
            NSArray *dataArray = dataDict[@"data"];
            if (dataArray.count > indexPath.row) {
                NSDictionary *cellData =dataArray[indexPath.row];
                if (![Utility isEmptyCheck:cellData]) {
                    if (indexPath.section == 0 && indexPath.row == 0) {
                        /*
                         [[MPMusicPlayerController systemMusicPlayer] pause];
                         //            //suchandra 2/1/17
                         
                         [defaults setBool:true forKey:@"isMusicPaused"];
                         //
                         NSString *stringURL = @"music:";
                         NSURL *url = [NSURL URLWithString:stringURL];
                         [[UIApplication sharedApplication] openURL:url];
                         
                         */
                        //            SongPlayListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayListView"];
                        //            controller.delegate=self;
                        //            [self presentViewController:controller animated:YES completion:nil];
                        MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
                        picker.delegate = self;
                        picker.allowsPickingMultipleItems = YES;
                        picker.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1];
                        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
                        self.navigationController.navigationBar.tintColor = [UIColor greenColor];
                        keepPlaying = NO;
                        parent.isWeightSheetButtonPressed = NO;
                        [self presentViewController:picker animated:YES completion:nil];
                        
                    }else if(indexPath.section == 0 && indexPath.row == 1){
                        SpotifyPlaylistViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpotifyPlaylist"];
                        keepPlaying = NO;
                        parent.isWeightSheetButtonPressed = NO;
                        [self presentViewController:controller animated:YES completion:nil];
                    }else if(indexPath.section == 0 && indexPath.row == 2){
                        SettingsPickersViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingsPickers"];
                        controller.settingsCustomPickerDelegate = self;
                        NSArray *pickerArray = [[NSArray alloc]initWithObjects:@"keeps playing",@"stops playing",@"play softer", nil];
                        controller.pickerArray = pickerArray;
                        controller.titleName = @"Inbetween Rounds";
                        NSLog(@"%@",[defaults objectForKey:@"Inbetween Rounds"]);
                        if ([pickerArray containsObject:[(NSString *)[defaults objectForKey:@"Inbetween Rounds"]lowercaseString]]) {
                            controller.selectRow = [pickerArray indexOfObject:[(NSString *)[defaults objectForKey:@"Inbetween Rounds"]lowercaseString]];
                        }else{
                            controller.selectRow =0 ;
                        }
                        controller.key =@"Inbetween Rounds";
                        keepPlaying=YES;
                        parent.isWeightSheetButtonPressed = YES;
                        [self presentViewController:controller animated:YES completion:nil];
                    }else if(indexPath.section == 1 && indexPath.row == 0){
                        SettingsPickersViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingsPickers"];
                        controller.settingsCustomPickerDelegate = self;
                        NSArray *pickerArray = [[NSArray alloc]initWithObjects:@"on",@"off", nil];
                        controller.pickerArray = pickerArray;
                        controller.titleName = @"Music Sound";
                        if ([pickerArray containsObject:[(NSString *)[defaults objectForKey:@"Motivation"]lowercaseString]]) {
                            controller.selectRow = [pickerArray indexOfObject:[(NSString *)[defaults objectForKey:@"Motivation"]lowercaseString]];
                        }else{
                            controller.selectRow =0 ;
                        }
                        controller.key =@"Motivation";
                        keepPlaying=YES;
                        parent.isWeightSheetButtonPressed = YES;
                        [self presentViewController:controller animated:YES completion:nil];
                    }else if(indexPath.section == 1 && indexPath.row == 1){
                        SettingsPickersViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingsPickers"];
                        controller.settingsCustomPickerDelegate = self;
                        NSArray *pickerArray = [[NSArray alloc]initWithObjects:@"on",@"off", nil];
                        controller.pickerArray = pickerArray;
                        controller.titleName = @"Voice Over";
                        if ([pickerArray containsObject:[(NSString *)[defaults objectForKey:@"Voice Over"]lowercaseString]]) {
                            controller.selectRow = [pickerArray indexOfObject:[(NSString *)[defaults objectForKey:@"Voice Over"]lowercaseString]];
                        }else{
                            controller.selectRow =0 ;
                        }
                        controller.key =@"Voice Over";
                        keepPlaying=YES;
                        parent.isWeightSheetButtonPressed = YES;
                        [self presentViewController:controller animated:YES completion:nil];
                    }else if(indexPath.section == 1 && indexPath.row == 2){
                        SettingsPickersViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingsPickers"];
                        controller.settingsCustomPickerDelegate = self;
                        NSArray *pickerArray = [[NSArray alloc]initWithObjects:@"on",@"off", nil];
                        controller.pickerArray = pickerArray;
                        controller.titleName = @"Bell";
                        if ([pickerArray containsObject:[(NSString *)[defaults objectForKey:@"Voice Over"]lowercaseString]]) {
                            controller.selectRow = [pickerArray indexOfObject:[(NSString *)[defaults objectForKey:@"Bell"]lowercaseString]];
                        }else{
                            controller.selectRow =0 ;
                        }
                        controller.key =@"Bell";
                        keepPlaying = YES;
                        parent.isWeightSheetButtonPressed = YES;
                        [self presentViewController:controller animated:YES completion:nil];
                    }
                }
            }
        }
    }
}
-(void)stopMusic{
    if (![Utility isEmptyCheck:[defaults objectForKey:@"mediaItemCollection"]] && [MPMusicPlayerController systemMusicPlayer].currentPlaybackRate == 1) {
        [[MPMusicPlayerController systemMusicPlayer] pause];
    }else if(![Utility isEmptyCheck:[defaults objectForKey:@"selectedSpotifyCollectionUri"]] && [[SPTAudioStreamingController sharedInstance] initialized] && [SPTAudioStreamingController sharedInstance].playbackState.isPlaying){
        [[SPTAudioStreamingController sharedInstance] setIsPlaying:NO callback:nil];
    }
}
#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    [self stopMusic];
    NSData *mediaItemCollectionData = [NSKeyedArchiver archivedDataWithRootObject:mediaItemCollection];
    [defaults setObject:mediaItemCollectionData forKey:@"mediaItemCollection"];
    [defaults setObject:nil forKey:@"selectedSpotifyCollectionUri"];
    [defaults synchronize];
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}
@end
