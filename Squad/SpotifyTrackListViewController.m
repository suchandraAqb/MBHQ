//
//  SpotifyTrackListViewController.m
//  Ashy Bines Super Circuit
//
//  Created by AQB SOLUTIONS on 14/09/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "SpotifyTrackListViewController.h"
#import "Utility.h"
#import "TableViewCell.h"

@interface SpotifyTrackListViewController (){
    IBOutlet UITableView *spotifyTrackListTableView;
    
    Utility *util;
//    NSUserDefaults *defaults;
    UIView *contentView;
    UIActivityIndicatorView *activityView;
    
    NSString *nextStr;
    NSMutableArray *totalItemsArray;
}

@end

@implementation SpotifyTrackListViewController
@synthesize playlistID,playlistName,accessToken,href;
- (void)viewDidLoad {
    [super viewDidLoad];
    util = [[Utility alloc]init];
    totalItemsArray = [[NSMutableArray alloc]init];
    [self getTracklistWebserviceCallWithCell:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IBAction
- (IBAction)backButton:(id)sender {
    //    NSArray *viewControllers = [[self navigationController] viewControllers];
    //    //    NSLog(@"vc %@",viewControllers);
    //    id prevObj = [viewControllers objectAtIndex:viewControllers.count-3];
    //    [[self navigationController] popToViewController:prevObj animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Webservice Call
-(void)getTracklistWebserviceCallWithCell:(UITableViewCell *)cell{
    if (Utility.reachable) {
        if (cell) {
            contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, spotifyTrackListTableView.frame.size.width, cell.frame.size.height)];
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
        
        NSMutableURLRequest *request=[Utility getRequestForSpofity:@"" api:@"tracks" append:@"" forAction:@"GET" accessToken:accessToken url:href];
        [request setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];
        
        NSURLSession *urlSession = [NSURLSession sharedSession];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        urlSession = [NSURLSession sessionWithConfiguration:configuration];
        
        [[urlSession dataTaskWithRequest:request
                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                           if (!error) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   //                                NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   //                                NSLog(@"responseString %@",responseString);
                                   
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   [totalItemsArray addObjectsFromArray:[json objectForKey:@"items"]];
                                   if ([json objectForKey:@"next"] && ![[json objectForKey:@"next"] isEqual:[NSNull null]]) {
                                       nextStr = [json objectForKey:@"next"];
                                   }
                                   [spotifyTrackListTableView reloadData];
                                   
                                   [contentView removeFromSuperview];
                                   [activityView stopAnimating];
                                   
                                   
                               });
                           }else{
                               [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                               
                               [contentView removeFromSuperview];
                               [activityView stopAnimating];
                           }
                       }] resume];
        
    }
    else{
        [Utility msg:@"Please Check Your network connection and try again." title:@"Error !" controller:self haveToPop:NO];
    }
}

#pragma mark - TableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return totalItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"TableViewCell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //    NSLog(@"ir %ld ta %lu",(long)indexPath.row,(unsigned long)[totalArray count]);
    if ([nextStr length] > 0 && indexPath.row == [totalItemsArray count]-1) {
        href = nextStr;
        nextStr = @"";
        [self getTracklistWebserviceCallWithCell:(TableViewCell *)cell];
    } else {
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SpotifyTrackListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpotifyTrackList"];
    controller.playlistID = [[totalItemsArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    controller.playlistName = [[totalItemsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
