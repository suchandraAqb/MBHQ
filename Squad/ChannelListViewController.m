//
//  ChannelListViewController.m
//  The Life
//
//  Created by AQB Mac 4 on 09/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "ChannelListViewController.h"
#import "ChannelListCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PlayListViewController.h"

@interface ChannelListViewController (){
    IBOutlet UICollectionView *collection;
    NSArray *channelDataList;
    UIView *contentView;
    IBOutlet UIImageView *headerBg;

}

@end

@implementation ChannelListViewController

#pragma -mark IBAction
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma -mark End

#pragma mark - Private Function
-(void)getChannelList{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:YOUTUBECHANNELURL];
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
                                                                         NSArray *channelItemsArray = [responseDict objectForKey:@"items"];                                                                         if (![Utility isEmptyCheck:channelItemsArray]) {
                                                                             //change_new_240318
                                                                             NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"snippet.publishedAt" ascending:NO];
                                                                             NSArray *descriptors=[NSArray arrayWithObject: descriptor];
                                                                             channelDataList=[channelItemsArray sortedArrayUsingDescriptors:descriptors];
                                                                             [collection reloadData];
                                                                             
                                                                         }else{
                                                                             channelDataList = [[NSArray alloc]init];
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
    [self getChannelList];

    
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

#pragma -mark CollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return channelDataList.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"ChannelListCollectionViewCell";
    ChannelListCollectionViewCell *cell = (ChannelListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = [channelDataList objectAtIndex:indexPath.row];
    NSDictionary *snippet = [dict objectForKey:@"snippet"];
    
    if (![Utility isEmptyCheck:snippet]) {
        NSString *title =[snippet valueForKey:@"title"];
        cell.chennelTitle.text = title;
        NSDictionary *thumbnails = [snippet objectForKey:@"thumbnails"];
        if (![Utility isEmptyCheck:thumbnails]) {
            NSDictionary *highQualityPicDict = [thumbnails valueForKey:@"high"];//medium //change_new_240318
            if (![Utility isEmptyCheck:highQualityPicDict]) {
                NSString *imageString =[highQualityPicDict valueForKey:@"url"];
                if (![Utility isEmptyCheck:imageString]) {
                    [cell.channelImage sd_setImageWithURL:[NSURL URLWithString:[imageString stringByAddingPercentEncodingWithAllowedCharacters:
                                                                                [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                         placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
                }else{
                    cell.channelImage.image = [UIImage imageNamed:@"place_holder1.png"];
                }
            }else{
                cell.channelImage.image = [UIImage imageNamed:@"place_holder1.png"];
            }
        }else{
            cell.channelImage.image = [UIImage imageNamed:@"place_holder1.png"];
        }
    }
   
    
    return cell;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PlayListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayList"];
    NSDictionary *dict = [channelDataList objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        controller.playListId = [dict objectForKey:@"id"];
    }
    [self.navigationController pushViewController:controller animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w1 = (CGRectGetWidth(collection.frame)-21)/2;
    return CGSizeMake(w1, w1);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 7;
}

#pragma -mark End

#pragma -mark Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma -mark End



@end
