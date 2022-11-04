//
//  MyWatchListViewController.m
//  The Life
//
//  Created by AQB Mac 4 on 09/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "MyWatchListViewController.h"
#import "WebinarListTableViewCell.h"
#import "WebinarSelectedViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utility.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PodcastViewController.h"
#import "AppDelegate.h"

@import Photos;

@interface MyWatchListViewController (){
    AVPlayer *player;
    IBOutlet UITableView *watchListTable;
    IBOutlet UIImageView* headerBg;
    NSMutableArray *webinarList;
    IBOutlet UIButton *filterButton;

    NSMutableArray *unFilteredWebinarList;
    UIView *contentView;
    NSArray *filterArray;
    int selectedIndex;
    
    NSMutableDictionary *backgroundDownloadDict;
    NSMutableDictionary *indexPathAndTaskDict;
    

}


@end

@implementation MyWatchListViewController

#pragma mark - Private Function
-(void)getWatchList:(NSDictionary *)dict{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        contentView = [Utility activityIndicatorView:self];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:dict];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"User_id"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetWatchlistApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                         self->webinarList = [[NSMutableArray alloc]initWithArray:[responseDict objectForKey:@"WatchList"]];
                                                                         if (![Utility isEmptyCheck:self->webinarList] && ![Utility isEmptyCheck:self->webinarList]) {
                                                                             self->unFilteredWebinarList = [self->webinarList mutableCopy];
                                                                             if (self->selectedIndex > -1) {
                                                                                 [self filter:[[self->filterArray objectAtIndex:self->selectedIndex] valueForKey:@"Value"]];
                                                                             }else{
                                                                                 [self->watchListTable reloadData];
                                                                             }
                                                                             
                                                                         }else{
                                                                             self->webinarList = [[NSMutableArray alloc]init];
                                                                             self->unFilteredWebinarList = [[NSMutableArray alloc]init];
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
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        return;
    }
    
}
#pragma mark - End



#pragma mark - IBAction
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)filterButtonPressed:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        FilterViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Filter"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.filterDataArray = filterArray;
        controller.selectedIndex = self->selectedIndex;
        controller.mainKey = @"Value";
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    });
}

- (IBAction)podcastButtonPressed:(UIButton *)sender {
    NSMutableDictionary *webinarsData = [[NSMutableDictionary alloc]initWithDictionary:[webinarList objectAtIndex:sender.tag]];
    
    NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinarsData valueForKey:@"EventItemVideoDetails"]];
    if (eventItemVideoDetailsArray.count > 0) {
        NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
        if (![Utility isEmptyCheck:eventItemVideoDetails]) {
            NSString *urlString = [eventItemVideoDetails objectForKey:@"PodcastURL" ];
            if (![Utility isEmptyCheck:urlString]) {
                PodcastViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Podcast"];
                controller.urlString = urlString;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }
    
}
- (IBAction)downloadButtonPressed:(UIButton *)sender {
    NSMutableDictionary *webinarsData = [[NSMutableDictionary alloc]initWithDictionary:[webinarList objectAtIndex:sender.tag]];
    
    NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinarsData valueForKey:@"EventItemVideoDetails"]];
    if (eventItemVideoDetailsArray.count > 0) {
        NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
        if (![Utility isEmptyCheck:eventItemVideoDetails]) {
            if (![Utility isEmptyCheck:[eventItemVideoDetails objectForKey:@"DownloadURL" ]]) {
                NSURL *video_url = [NSURL URLWithString:[eventItemVideoDetails objectForKey:@"DownloadURL" ]];
                
                if([video_url absoluteString].length < 1) {
                    return;
                }
                NSLog(@"source will be : %@", video_url.absoluteString);
                NSURL *sourceURL = video_url;
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];
                NSLog(@"fullPathToFile=%@",fullPathToFile);
                if (player) {
                    [player pause];
                    player = nil;
                }
                
                if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                    NSURL    *fileURL = [NSURL fileURLWithPath:fullPathToFile];
                    player = [AVPlayer playerWithURL:fileURL];
                    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
                    [self presentViewController:controller animated:YES completion:nil];
                    controller.view.frame = self.view.frame;
                    controller.player = player;
                    controller.showsPlaybackControls = YES;
                    [player play];
                    return;
                }
                [Utility msg:@"This video have started downloading , will be available for playing locally" title:@"Alert" controller:self haveToPop:NO];
                
                [UIView animateWithDuration:0.3/1 animations:^{
                    sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.7, 1.7);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3/1.5 animations:^{
                        sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.3/1.5 animations:^{
                            sender.transform = CGAffineTransformIdentity;
                            [sender setBackgroundColor:[UIColor clearColor]];
                            
                        }];
                    }];
                }];
                if(Utility.reachable){
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        sender.enabled = false;
                        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self->watchListTable];
                        NSIndexPath *indexPath = [self->watchListTable indexPathForRowAtPoint:buttonPosition];
                        WebinarListTableViewCell *cell = (WebinarListTableViewCell *)[self->watchListTable cellForRowAtIndexPath:indexPath];
                        cell.downloadTask = [self.session downloadTaskWithURL:sourceURL];
                        cell.progress.hidden = false;
                        [self->backgroundDownloadDict setObject:cell forKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)cell.downloadTask.taskIdentifier]];
                        [self->indexPathAndTaskDict setObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)cell.downloadTask.taskIdentifier] forKey:[@"" stringByAppendingFormat:@"%ld",(long)sender.tag]];
                        
                        [cell.downloadTask resume];
                    }];
                    //                    NSURLSessionTask *download = [[NSURLSession sharedSession] downloadTaskWithURL:sourceURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                    //                        if(error) {
                    //                            NSLog(@"error saving: %@", error.localizedDescription);
                    //                            return;
                    //                        }
                    //
                    //                        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPathToFile] error:nil];
                    //                        dispatch_async(dispatch_get_main_queue(), ^{
                    //                            if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                    //                                [sender setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];
                    //                            }else{
                    //                                [sender setImage:[UIImage imageNamed:@"w_download.png"] forState:UIControlStateNormal];
                    //                            }
                    //                        });
                    //
                    //                    }];
                    //                    [download resume];
                }else{
                    [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
                }
            }
        }
    }
    
}
- (IBAction)likeDislikeButtonPressed:(UIButton *)sender {
    if (Utility.reachable) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            if (contentView) {
        //                [contentView removeFromSuperview];
        //            }
        //            contentView = [Utility activityIndicatorView:self];
        //        });
        NSMutableDictionary *webinarsData = [[NSMutableDictionary alloc]initWithDictionary:[webinarList objectAtIndex:sender.tag]];
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[webinarsData valueForKey:@"EventItemID"] forKey:@"EventID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:0  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleEventLikeApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [Utility isEmptyCheck:[responseDict objectForKey:@"Message"]]) {
                                                                         CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self->watchListTable];
                                                                         NSIndexPath *indexPath = [self->watchListTable indexPathForRowAtPoint:buttonPosition];
                                                                         [webinarsData setObject:[responseDict valueForKey:@"LikeCount"] forKey:@"LikeCount"];
                                                                         [webinarsData setObject:[responseDict valueForKey:@"Likes"] forKey:@"Likes"];
                                                                         [self->webinarList replaceObjectAtIndex:sender.tag withObject:webinarsData];
                                                                         NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
                                                                         [self->watchListTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
                                                                         
                                                                         
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
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
- (IBAction)watchListButtonPressed:(UIButton *)sender {
    if (Utility.reachable) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            if (contentView) {
        //                [contentView removeFromSuperview];
        //            }
        //            contentView = [Utility activityIndicatorView:self];
        //        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *webinarsData = [[NSMutableDictionary alloc]initWithDictionary:[webinarList objectAtIndex:sender.tag]];
        
        NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinarsData valueForKey:@"EventItemVideoDetails"]];
        if (eventItemVideoDetailsArray.count > 0) {
            NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
            if (![Utility isEmptyCheck:eventItemVideoDetails]) {
                if (![[eventItemVideoDetails objectForKey:@"IsWatchListVideo"] boolValue]) {
                    [Utility msg:[@"" stringByAppendingFormat:@"%@ has now been saved to your watchlist. You can find this anytime from the menu.",[webinarsData objectForKey:@"EventName"]] title:@"Alert" controller:self haveToPop:NO];
                }

                NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
                [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"User_id"];
                [mainDict setObject:AccessKey forKey:@"Key"];
                [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
                [mainDict setObject:[eventItemVideoDetails objectForKey:@"EventItemVideoID"] forKey:@"Video_id"];
                
                NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:0  error:&error];
                if (error) {
                    [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                    return;
                }
                NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
                
                NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleWatchlistApiCall" append:@"" forAction:@"POST"];
                NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         if (contentView) {
                                                                             [self->contentView removeFromSuperview];
                                                                         }
                                                                         if(error == nil)
                                                                         {
                                                                             NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                             
                                                                             NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                             if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && ![Utility isEmptyCheck:[responseDict objectForKey:@"ToggleFlag"]]) {
                                                                                 if (![[responseDict objectForKey:@"ToggleFlag"] boolValue]) {
//                                                                                     CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:watchListTable];
//                                                                                     NSIndexPath *indexPath = [watchListTable indexPathForRowAtPoint:buttonPosition];
//                                                                                     NSArray* rowsToDelete = [NSArray arrayWithObjects:indexPath, nil];
                                                                                     [webinarList removeObjectAtIndex:sender.tag];
                                                                                     [self->watchListTable reloadData];
                                                                                     //[watchListTable deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:YES];
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
            }
        }else{
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
- (IBAction)isViewedPressed:(UIButton *)sender{
    [self isviewed:(int)sender.tag];
}
-(void)isviewed:(int)index{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSDictionary *webinar = [webinarList objectAtIndex:index];
        NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinar valueForKey:@"EventItemVideoDetails"]];
        if (eventItemVideoDetailsArray.count > 0) {
            NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
            if (![Utility isEmptyCheck:eventItemVideoDetails] && ![Utility isEmptyCheck:[eventItemVideoDetails objectForKey:@"EventItemVideoID"]]) {
                NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
                [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserId"];
                [mainDict setObject:AccessKey forKey:@"Key"];
                [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
                [mainDict setObject:[eventItemVideoDetails objectForKey:@"EventItemVideoID"] forKey:@"EventItemVideoID"];
                
                NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:0  error:&error];
                if (error) {
                    [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                    return;
                }
                NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
                
                NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SaveViewVideoStatusApiCall" append:@"" forAction:@"POST"];
                NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         if (self->contentView) {
                                                                             [self->contentView removeFromSuperview];
                                                                         }
                                                                         if(error == nil)
                                                                         {
                                                                             NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                             
                                                                             NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                             if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] ) {
//                                                                                 if ([[responseDict objectForKey:@"Status"] boolValue]) {
//                                                                                     sender.hidden = false;
//                                                                                 }else{
//                                                                                     sender.hidden = true;
//                                                                                 }
                                                                                 NSLog(@"%@",responseDict);
                                                                                 [self getWatchList:nil];
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
            }
        }
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
    }
}

- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
#pragma mark - End -
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        headerBg.image = [UIImage imageNamed:@"header-4s.png"];
    }else{
        headerBg.image = [UIImage imageNamed:@"header.png"];
    }
    webinarList = [[NSMutableArray alloc]init];
    unFilteredWebinarList = [[NSMutableArray alloc]init];
    filterArray = [[NSArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"Key",@"Remove Filter",@"Value",nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"Key",@"Upcoming",@"Value",nil],
                   [[NSDictionary alloc]initWithObjectsAndKeys:@"2",@"Key",@"Live and still to view",@"Value",nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"3",@"Key",@"Already viewed",@"Value",nil], nil];
    selectedIndex = -1;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.TheSquatWatchList"];
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil];
    NSLog(@"%@",self.session);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MasterMenuViewController class]]) {
        MasterMenuViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterMenuView"];
        controller.delegateMasterMenu=self;
        self.slidingViewController.underLeftViewController  = controller;
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self->backgroundDownloadDict = [[NSMutableDictionary alloc]init];
        self->indexPathAndTaskDict = [[NSMutableDictionary alloc]init];
        if (![Utility isEmptyCheck:[defaults objectForKey:@"indexPathAndTaskDictWatchList"]]) {
            self->indexPathAndTaskDict = [[defaults objectForKey:@"indexPathAndTaskDictWatchList"] mutableCopy];
        }
    }];
//    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self getWatchList:nil];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [defaults setObject:self->indexPathAndTaskDict forKey:@"indexPathAndTaskDictWatchList"];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    return webinarList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier =@"watchListTableViewCell";
    WebinarListTableViewCell *cell = (WebinarListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[WebinarListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *webinarsData = [webinarList objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:webinarList]) {
        NSString *eventString = [webinarsData valueForKey:@"EventName"];
        if (![Utility isEmptyCheck:eventString]) {
            cell.listHeadingTextLabel.text = eventString;
        }//@"Photo.png"
        
        NSString *imageString =[webinarsData valueForKey:@"ImageUrl"];
        cell.listImageView.layer.cornerRadius = cell.listImageView.frame.size.width/2;
        cell.listImageView.clipsToBounds = YES;
        NSString *presenterString =[webinarsData valueForKey:@"PresenterName"];
        NSDictionary *presenterDict = [defaults valueForKey:@"presenterDict"];
        if (![Utility isEmptyCheck:imageString]) {
            [cell.listImageView sd_setImageWithURL:[NSURL URLWithString:[imageString stringByAddingPercentEncodingWithAllowedCharacters:
                                                                         [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                  placeholderImage:[UIImage imageNamed:@"Photo.png"] options:SDWebImageScaleDownLargeImages];
        }else{
            if (![Utility isEmptyCheck:presenterString] && ![Utility isEmptyCheck:[presenterDict valueForKey:presenterString]]) {
                [cell.listImageView sd_setImageWithURL:[NSURL URLWithString:[[@"" stringByAppendingFormat:@"%@/Images/Presenters/%@",BASEURL,[presenterDict valueForKey:presenterString]] stringByAddingPercentEncodingWithAllowedCharacters:
                                                                             [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                      placeholderImage:[UIImage imageNamed:@"Photo.png"] options:SDWebImageScaleDownLargeImages];
            }else{
                cell.listImageView.image = [UIImage imageNamed:@"Photo.png"];
            }
        }
        
        if (![Utility isEmptyCheck:presenterString]) {
            cell.listSubheadingTextLabel.text = presenterString;
        }
        NSString *descriptionString =[webinarsData valueForKey:@"Content"];
        if (![Utility isEmptyCheck:descriptionString]) {
            descriptionString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: %@\";>%@</span>", cell.listDetailsTextLabel.font.fontName, cell.listDetailsTextLabel.font.pointSize,[Utility hexStringFromColor:cell.listDetailsTextLabel.textColor], descriptionString];
            NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[descriptionString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding),
                                                                                           NSFontAttributeName : cell.listDetailsTextLabel.font,
                                                                                           NSForegroundColorAttributeName : cell.listDetailsTextLabel.textColor
                                                                                           }
                                                                      documentAttributes:nil error:nil];
            
            cell.listDetailsTextLabel.attributedText = strAttributed;
        }else{
            cell.listDetailsTextLabel.attributedText = [[NSAttributedString alloc]initWithString:@""];
        }
        cell.likeDislike.tag =(int) indexPath.row;
        cell.watchListButton.tag =(int) indexPath.row;
        cell.downloadButton.tag = (int) indexPath.row;
        cell.podcastButton.tag =  (int) indexPath.row;
        cell.isViewedButton.tag =  (int) indexPath.row;
        
        cell.likeDislike.selected = [[webinarsData valueForKey:@"Likes"] boolValue];
        NSString *likeCountString = [[webinarsData valueForKey:@"LikeCount"] stringValue];
        if (![Utility isEmptyCheck:likeCountString]) {
            cell.likeCount.text = likeCountString;
        }
        NSArray *eventItemVideoDetailsArray = [webinarsData valueForKey:@"EventItemVideoDetails"];
        if (eventItemVideoDetailsArray.count > 0) {
            NSDictionary *eventItemVideoDetails = [eventItemVideoDetailsArray objectAtIndex:0];
            if (![Utility isEmptyCheck:eventItemVideoDetails]) {
                cell.watchListButton.selected =  [[eventItemVideoDetails objectForKey:@"IsWatchListVideo"] boolValue];
                if (![Utility isEmptyCheck:[eventItemVideoDetails objectForKey:@"DownloadURL" ]]) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        NSString *index = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.row];
                        NSURL *video_url = [NSURL URLWithString:[eventItemVideoDetails objectForKey:@"DownloadURL" ]];
                        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString* documentsDirectory = [paths objectAtIndex:0];
                        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[video_url lastPathComponent]];
                        if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                            cell.downloadButton.enabled = true;
                            cell.progress.hidden = true;
                            [cell.downloadButton setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];
                        }else{
                            if ([[self->indexPathAndTaskDict allKeys] containsObject:index]) {
                                cell.downloadButton.enabled =false;
                                cell.progress.hidden = false;
                                NSString *taskIndentifire = [self->indexPathAndTaskDict objectForKey:index];
                                [self->backgroundDownloadDict setObject:cell forKey:taskIndentifire];
                            }else{
                                cell.downloadButton.enabled =true;
                                cell.progress.hidden = true;
                            }
                            [cell.downloadButton setImage:[UIImage imageNamed:@"w_download.png"] forState:UIControlStateNormal];
                        }
                        cell.downloadButton.hidden = false;
                        cell.downloadButtonConstraint.constant = 25;
                    }];
                    
                }else{
                    cell.downloadButton.hidden = true;
                    cell.downloadButtonConstraint.constant = 0;
                }
                if (![Utility isEmptyCheck:[eventItemVideoDetails valueForKey:@"IsViewedVideo"]] && [[eventItemVideoDetails valueForKey:@"IsViewedVideo"] boolValue]) {
                    cell.isViewedButton.hidden = false;
                    cell.isViewedWidthConstraint.constant = 26;
                }else{
                    cell.isViewedButton.hidden = true;
                    cell.isViewedWidthConstraint.constant = 0;
                }
                if (![Utility isEmptyCheck:[eventItemVideoDetails objectForKey:@"EventItemVideoID"]]) {
                    cell.watchListButton.hidden = false;
                }else{
                    cell.watchListButton.hidden = true;
                    cell.watchListButtonConstraint.constant = 0;
                }
                NSString *urlString = [eventItemVideoDetails objectForKey:@"PodcastURL" ];
                if (![Utility isEmptyCheck:urlString]) {
                    cell.podcastButton.hidden = false;
                }else{
                    cell.podcastButton.hidden = true;
                }
            }
        }else{
            cell.downloadButton.hidden = true;
            cell.downloadButtonConstraint.constant = 0;
            cell.watchListButton.hidden = true;
            cell.watchListButtonConstraint.constant = 0;
        }
        
        NSString *startDateString =[webinarsData valueForKey:@"StartDate"];
        if (![Utility isEmptyCheck:startDateString]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
            NSString *dateString = startDateString;
            NSDate *date = [formatter dateFromString:dateString];
            formatter.dateFormat = @"dd MMM, YYYY";
            NSString *formattedString = [formatter stringFromDate:date];
            cell.listTimeTextLabel.text = formattedString;
        }
        
        
        
        
        NSMutableAttributedString *newString =[[NSMutableAttributedString alloc] init];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"p_tag.png"];
        textAttachment.bounds = CGRectMake(0, -3, textAttachment.image.size.width, textAttachment.image.size.height);
        NSDictionary *attrsDictionary = @{
                                          NSFontAttributeName : cell.tagView.font,
                                          NSForegroundColorAttributeName : cell.tagView.textColor
                                          
                                          };
        NSArray *items =[webinarsData valueForKey:@"Tags"];
        for (int i = 0 ; i<items.count; i++) {
            NSString *itemsName = [items objectAtIndex:i];
            itemsName = [[itemsName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:[@"" stringByAppendingFormat:@" %@   ",itemsName] attributes:attrsDictionary];
            
            
            
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            
            [newString appendAttributedString:attrStringWithImage];
            [newString appendAttributedString:attributedString];
            
        }
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:5];
        [newString addAttribute:NSParagraphStyleAttributeName
                          value:style
                          range:NSMakeRange(0, newString.length)];
        cell.tagView.attributedText = newString;
        
    }
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(),^ {
        NSDictionary *webinarsData = [self->webinarList objectAtIndex:indexPath.row];
        NSString *eventType = [@"" stringByAppendingFormat:@"%@",webinarsData[@"EventType"] ];
        NSString *eventName = [@"" stringByAppendingFormat:@"%@",webinarsData[@"EventName"] ];
        
        if (![Utility isEmptyCheck:eventType] && ([eventType isEqualToString:@"14"] || [eventName isEqualToString:@"AshyLive"] || [eventType isEqualToString:@"17"] || [eventName isEqualToString:@"FridayFoodAndNutrition"] || [eventType isEqualToString:@"16"] || [eventName isEqualToString:@"WeeklyWellness"])){
            NSString *urlString = [webinarsData objectForKey:@"FbAppUrl"];
            if (![Utility isEmptyCheck:urlString]) {
                NSURL *url = [NSURL URLWithString:urlString];
                if (([[UIApplication sharedApplication] canOpenURL:url])){
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        if(success){
                            NSLog(@"well done");
                            }
                    }];
                }else {
                    urlString = [webinarsData objectForKey:@"FbUrl"];
                    if (![Utility isEmptyCheck:urlString]) {
                        url = [NSURL URLWithString:urlString];
                        if (([[UIApplication sharedApplication] canOpenURL:url])){
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                            if(success){
                                NSLog(@"well done");
                                }
                        }];
                    }
                }
             }
            }else{
                urlString = [webinarsData objectForKey:@"FbUrl"];
                if (![Utility isEmptyCheck:urlString]) {
                    NSURL *url = [NSURL URLWithString:urlString];
                     [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                       if(success){
                           NSLog(@"well done");
                           }
                   }];
                }
            }
        }else if(![Utility isEmptyCheck:eventType] && [eventType isEqualToString:@"2"]){
            NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinarsData valueForKey:@"EventItemVideoDetails"]];
            if (eventItemVideoDetailsArray.count > 0) {
                NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
                if (![Utility isEmptyCheck:eventItemVideoDetails]) {
                    NSString *urlString = [eventItemVideoDetails objectForKey:@"PodcastURL" ];
                    if (![Utility isEmptyCheck:urlString]) {
                        PodcastViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Podcast"];
                        controller.urlString = urlString;
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                }
            }
        }else{
            WebinarSelectedViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarSelectedView"];
            controller.webinar = [webinarsData mutableCopy];
            if ([[webinarsData objectForKey:@"IsUpcomingEvent"] boolValue]) {
                controller.upcomingWebinarsData = webinarsData;
            }
            //controller.isFromWatchList = YES;
            dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
            dispatch_async(myQueue, ^{
                NSArray *eventItemVideoDetailsArray = [webinarsData valueForKey:@"EventItemVideoDetails"];
                if (eventItemVideoDetailsArray.count > 0) {
                    NSDictionary *eventItemVideoDetails = [eventItemVideoDetailsArray objectAtIndex:0];
                    if (![Utility isEmptyCheck:eventItemVideoDetails]) {
                        if (![Utility isEmptyCheck:[eventItemVideoDetails valueForKey:@"IsViewedVideo"]] && ![[eventItemVideoDetails valueForKey:@"IsViewedVideo"] boolValue]) {
                            [self isviewed:(int)indexPath.row];
                        }
                    }
                }
                
            });
            
            [self.navigationController pushViewController:controller animated:YES];
        }

    });
}

#pragma mark -end

-(void)filter:(NSString *)value{
    if([value isEqualToString:@"Remove Filter"]){
        webinarList = [unFilteredWebinarList mutableCopy];
        [watchListTable reloadData];
        [filterButton setImage:[UIImage imageNamed:@"webner_filter.png"] forState:UIControlStateNormal];
        
    }else if([value isEqualToString:@"Upcoming"]){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"IsUpcomingEvent = 1"];
        webinarList = [[unFilteredWebinarList filteredArrayUsingPredicate:predicate] mutableCopy];
        [watchListTable reloadData];
        [filterButton setImage:[UIImage imageNamed:@"selected_Filter.png"] forState:UIControlStateNormal];
        
    }else if([value isEqualToString:@"Live and still to view"]){
        webinarList = [[NSMutableArray alloc]init];
        for (NSDictionary *webinarsData in unFilteredWebinarList) {
            NSArray *eventItemVideoDetailsArray = [webinarsData valueForKey:@"EventItemVideoDetails"];
            if (eventItemVideoDetailsArray.count > 0) {
                NSDictionary *eventItemVideoDetails = [eventItemVideoDetailsArray objectAtIndex:0];
                if (![Utility isEmptyCheck:eventItemVideoDetails]) {
                    if (![[eventItemVideoDetails valueForKey:@"IsViewedVideo"] boolValue] && ![[webinarsData valueForKey:@"IsUpcomingEvent"] boolValue]) {
                        [webinarList addObject:webinarsData];
                    }
                }
            }
        }
        [watchListTable reloadData];
        [filterButton setImage:[UIImage imageNamed:@"selected_Filter.png"] forState:UIControlStateNormal];
        
    }else if([value isEqualToString:@"Already viewed"]){
        webinarList = [[NSMutableArray alloc]init];
        for (NSDictionary *webinarsData in unFilteredWebinarList) {
            NSArray *eventItemVideoDetailsArray = [webinarsData valueForKey:@"EventItemVideoDetails"];
            if (eventItemVideoDetailsArray.count > 0) {
                NSDictionary *eventItemVideoDetails = [eventItemVideoDetailsArray objectAtIndex:0];
                if (![Utility isEmptyCheck:eventItemVideoDetails]) {
                    if ([[eventItemVideoDetails valueForKey:@"IsViewedVideo"] boolValue] && ![[webinarsData valueForKey:@"IsUpcomingEvent"] boolValue]) {
                        [webinarList addObject:webinarsData];
                    }
                }
            }
        }
        [watchListTable reloadData];
        [filterButton setImage:[UIImage imageNamed:@"selected_Filter.png"] forState:UIControlStateNormal];
    }
}
#pragma mark - FilterViewDelegate
-(void)didSelectAnyFilterOption:(NSString *)type data:(NSDictionary *)data{
    selectedIndex =[[data valueForKey:@"Key"] intValue];
    NSString *value = [data valueForKey:@"Value"];
    if ([Utility isEmptyCheck:type]) {
        [self filter:value];
    }
}

#pragma mark - NSURLSession Delegate method implementation

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *destinationFilename = downloadTask.originalRequest.URL.lastPathComponent;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:destinationFilename];
    NSURL *destinationURL = [NSURL fileURLWithPath:fullPathToFile];
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]) {
        [fileManager removeItemAtURL:destinationURL error:nil];
    }
    
    BOOL success = [fileManager copyItemAtURL:location
                                        toURL:destinationURL
                                        error:&error];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        WebinarListTableViewCell *cell = (WebinarListTableViewCell *)[self->backgroundDownloadDict objectForKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]];
        cell.downloadButton.enabled = false;
        cell.progress.hidden = true;
        if (success) {
            if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                cell.downloadButton.enabled = true;
                cell.progress.hidden = true;
                cell.status.text = @"Download finished successfully.";
                cell.status.hidden = false;
                [cell.downloadButton setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];
            }else{
                [cell.downloadButton  setImage:[UIImage imageNamed:@"w_download.png"] forState:UIControlStateNormal];
            }
        }
        else{
            cell.status.text = [error localizedDescription];
            cell.status.hidden = false;
            
            NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
        }
        [self->backgroundDownloadDict removeObjectForKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]];
        if ([self->indexPathAndTaskDict allKeysForObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]].count > 0) {
            [self->indexPathAndTaskDict removeObjectForKey:[[self->indexPathAndTaskDict allKeysForObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]]objectAtIndex:0]];
        }
        
    }];
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        WebinarListTableViewCell *cell = (WebinarListTableViewCell *)[self->backgroundDownloadDict objectForKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)task.taskIdentifier]];
        cell.downloadButton.enabled = false;
        cell.progress.hidden = true;
        cell.status.hidden = false;
        if (error != nil) {
            cell.status.text = [@"" stringByAppendingFormat:@"Download completed with error: %@",[error localizedDescription]];
            NSLog(@"Download completed with error: %@", [error localizedDescription]);
        }
        else{
            cell.status.text = @"Download finished successfully.";
            NSLog(@"Download finished successfully.");
        }
        [self->backgroundDownloadDict removeObjectForKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)task.taskIdentifier]];
        if ([self->indexPathAndTaskDict allKeysForObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)task.taskIdentifier]].count > 0) {
            [self->indexPathAndTaskDict removeObjectForKey:[[self->indexPathAndTaskDict allKeysForObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)task.taskIdentifier]]objectAtIndex:0]];
        }
        
        
    }];
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        WebinarListTableViewCell *cell = (WebinarListTableViewCell *)[self->backgroundDownloadDict objectForKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]];
        
        if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
            NSLog(@"Unknown transfer size");
            cell.status.text = @"Unknown transfer size";
            cell.status.hidden = false;
            cell.progress.hidden= true;
            
        }else{
            NSLog(@"%lld---------%lld",totalBytesWritten,totalBytesExpectedToWrite);
            double downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
            cell.progress.progress= downloadProgress;
            cell.status.hidden = false;
        }
    }];
}


-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Check if all download tasks have been finished.
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        if ([downloadTasks count] == 0) {
            if (appDelegate.backgroundTransferCompletionHandler != nil) {
                // Copy locally the completion handler.
                void(^completionHandler)(void) = appDelegate.backgroundTransferCompletionHandler;
                
                // Make nil the backgroundTransferCompletionHandler.
                appDelegate.backgroundTransferCompletionHandler = nil;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    [defaults removeObjectForKey:@"indexPathAndTaskDictWatchList"];
                    
                    // Show a local notification when all downloads are over.
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    localNotification.alertBody = @"All files have been downloaded!";
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }];
            }
        }
    }];
}


@end
