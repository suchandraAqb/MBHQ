//
//  PlayListViewController.m
//  The Life
//
//  Created by AQB Mac 4 on 13/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "PlayListViewController.h"
#import "PlayListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "VideoViewController.h"

@interface PlayListViewController (){
    UIView *contentView;
    NSArray *playListArray;
    IBOutlet UITableView *playListTable;
    IBOutlet UIImageView *headerBg;

}

@end

@implementation PlayListViewController
@synthesize playListId;

#pragma -mark IBAction
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
#pragma -mark End

#pragma mark - Private Function
-(void)getPlayList{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        contentView = [Utility activityIndicatorView:self];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:[YOUTUBEPLAYLISTURL stringByAppendingFormat:@"%@",playListId]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                         NSArray *playListArr = [responseDict objectForKey:@"items"];                                                                         if (![Utility isEmptyCheck:playListArr]) {
                                                                             //change_new_240318
                                                                             NSSortDescriptor *sortDescriptor;
                                                                             sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"snippet.publishedAt" ascending:NO];
                                                                             playListArray = [playListArr sortedArrayUsingDescriptors:@[sortDescriptor]];
                                                                             [playListTable reloadData];
                                                                             
                                                                         }else{
                                                                             playListArray = [[NSArray alloc]init];
                                                                             [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                         
                                                                     }else{
                                                                         [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                     
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
            return;
        });
    }
    
}
#pragma mark - End
#pragma -mark ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        headerBg.image = [UIImage imageNamed:@"header-4s.png"];
    }else{
        headerBg.image = [UIImage imageNamed:@"header.png"];
    }
    [self getPlayList];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
//    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MasterMenuViewController class]]) {
//        MasterMenuViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterMenuView"];
//        controller.delegateMasterMenu=self;
//        self.slidingViewController.underLeftViewController  = controller;
//    }
//    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

#pragma -mark End

#pragma mark - TableView Datasource & Delegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return playListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier =@"PlayListTableViewCell";
    PlayListTableViewCell *cell = (PlayListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[PlayListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = [playListArray objectAtIndex:indexPath.row];
    NSDictionary *snippet = [dict objectForKey:@"snippet"];
    
    if (![Utility isEmptyCheck:snippet]) {
        NSString *title =[snippet valueForKey:@"title"];
        cell.playListTitle.text = title;
        cell.chennelTitle.text = [snippet objectForKey:@"channelTitle"];
        NSDictionary *thumbnails = [snippet objectForKey:@"thumbnails"];
        if (![Utility isEmptyCheck:thumbnails]) {
            NSDictionary *highQualityPicDict = [thumbnails valueForKey:@"medium"];
            if (![Utility isEmptyCheck:highQualityPicDict]) {
                NSString *imageString =[highQualityPicDict valueForKey:@"url"];
                if (![Utility isEmptyCheck:imageString]) {
                    [cell.playListImage sd_setImageWithURL:[NSURL URLWithString:[imageString stringByAddingPercentEncodingWithAllowedCharacters:
                                                                                [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                         placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
                }else{
                    cell.playListImage.image = [UIImage imageNamed:@"place_holder1.png"];
                }
            }else{
                cell.playListImage.image = [UIImage imageNamed:@"place_holder1.png"];
            }
        }else{
            cell.playListImage.image = [UIImage imageNamed:@"place_holder1.png"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VideoView"];
    NSDictionary *dict = [playListArray objectAtIndex:indexPath.row];
    NSDictionary *resource = [[dict objectForKey:@"snippet"] valueForKey:@"resourceId"];

    if (![Utility isEmptyCheck:resource]) {
        controller.videoId = [resource objectForKey:@"videoId"];
    }
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -end

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
