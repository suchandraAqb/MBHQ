//
//  SongListViewController.m
//  Ashy Bines Super Circuit
//
//  Created by AQB Solutions-Mac Mini 2 on 03/01/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "SongListViewController.h"
#import "TableViewCell.h"
#import "SongPlayListViewController.h"
#import "Utility.h"

@interface SongListViewController ()
{
    IBOutlet UITableView *songListTable;
    IBOutlet UILabel *playerListNameLabel;
    IBOutlet UILabel *noDataListFound;
    AVAudioPlayer *player;
    
    NSString *selectedUrlStr;
    NSString *selectedName;

}
@end

@implementation SongListViewController
@synthesize songListArray,playerName,songListDelegate;

#pragma mark - IBAction
- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)doneButton:(id)sender {
    if (![Utility isEmptyCheck:selectedName] && ![Utility isEmptyCheck:selectedUrlStr]) {
        if ([songListDelegate respondsToSelector:@selector(getSelectedSongName:Url:)]) {
            [songListDelegate getSelectedSongName:selectedName Url:selectedUrlStr];
        }
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [Utility msg:@"Please select a song" title:@"Oops!" controller:self haveToPop:NO];
    }
    
}
#pragma mark - End

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    songListTable.delegate = self;
    songListTable.dataSource = self;
    playerListNameLabel.text=[NSString stringWithFormat:@"%@",playerName];
    if (![songListArray isEqual:[NSNull null]] && (songListArray.count>0)) {
        [songListTable reloadData];
        noDataListFound.hidden=true;
    }else{
        noDataListFound.hidden=false;
        songListTable.hidden=true;
    }
    
    selectedName = @"";
    selectedUrlStr = @"";
}
#pragma mark - End

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - End

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return songListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TableViewCell";
    TableViewCell *tablecell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    MPMediaItem *song = [songListArray objectAtIndex:indexPath.row];
    
    NSString *songTitle =   [song valueForProperty: MPMediaItemPropertyTitle];
    tablecell.songListLabel.text = songTitle;
    
    return tablecell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MPMediaItem *song = [songListArray objectAtIndex:indexPath.row];
    NSURL *url = [song valueForProperty:MPMediaItemPropertyAssetURL];
    
    selectedUrlStr = [url absoluteString];
    selectedName = [song valueForProperty:MPMediaItemPropertyTitle];
    
//    NSString *songID = [song valueForProperty:MPMediaItemPropertyPersistentID];
//    [[NSUserDefaults standardUserDefaults] setObject:songID forKey:@"songID"];
//     [[NSUserDefaults standardUserDefaults] setObject:[url absoluteString] forKey:@"songURL"];
    
    //    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    //    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    //    [player play];
    
        NSError *error;
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    
        if (!error) {
            [player prepareToPlay];
            [player play];
        }
}
@end
