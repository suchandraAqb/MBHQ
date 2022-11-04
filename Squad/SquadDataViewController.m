//
//  SquadDataViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 31/07/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "SquadDataViewController.h"
#import "SquadDataTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DropdownViewController.h"
#import "AppDelegate.h"

@interface SquadDataViewController () {
    IBOutlet UITableView *table;
    
    UIView *contentView;
    NSMutableArray *activityDataArray;
    NSMutableArray *filterArray;
    int dayFilter;
    AppDelegate *appDelegate;
}

@end

@implementation SquadDataViewController
//ah sc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    activityDataArray = [[NSMutableArray alloc] init];
    filterArray = [[NSMutableArray alloc] init];
    dayFilter = 0;
    
    [self getActivityHistory];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    filterArray = [@[@{
                         @"id" : @0,
                         @"name" : @"All"
                         },
                     @{
                         @"id" : @1,
                         @"name" : @"Today"
                         },
                     @{
                         @"id" : @2,
                         @"name" : @"Weekly"
                         },
                     @{
                         @"id" : @3,
                         @"name" : @"Monthly"
                         }
                     ] mutableCopy];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
-(IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)filterButtonTapped:(id)sender {
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = filterArray;
    controller.mainKey = @"name";
    controller.apiType = @"filter";
    controller.selectedIndex = dayFilter;
    controller.shouldScrollToIndexpath = NO;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark - API Calls
-(void) getActivityHistory {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[NSNumber numberWithInt:dayFilter] forKey:@"Days"];
        [mainDict setObject:@"" forKey:@"FacebookToken"];

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadActivityData" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  if (contentView) {
                                                                      [contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          activityDataArray = [responseDict objectForKey:@"ActivityHistory"];
                                                                          [table reloadData];
                                                                      }
                                                                      else{
                                                                          [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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

#pragma mark - Dropdown Delegate
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData{
    //    NSLog(@"ty %@ \ndata %@",type,selectedData);
    
    if ([type caseInsensitiveCompare:@"filter"] == NSOrderedSame) {
        dayFilter = [[selectedData objectForKey:@"id"] intValue];
        [self getActivityHistory];
    }
}
#pragma mark - TableView Datasource & Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return activityDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"SquadDataTableViewCell";
    SquadDataTableViewCell *cell = (SquadDataTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[SquadDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = [activityDataArray objectAtIndex:indexPath.row];
    NSLog(@"dict -> %@",dict);
    
    cell.slNoLabel.text = [NSString stringWithFormat:@"%ld.",(long)indexPath.row+1];
    cell.userNameLabel.text = [dict objectForKey:@"Name"];
    cell.timeLabel.text = [dict objectForKey:@"Time"];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%0.3f",[[dict objectForKey:@"Distance"] floatValue]];
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEIMAGE_URL,[dict objectForKey:@"ProfilePic"]]] placeholderImage:[UIImage imageNamed:@"fitbit_user.png"] options:SDWebImageScaleDownLargeImages];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSDictionary *dict = [activityDataArray objectAtIndex:indexPath.row];
//    TrackerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Tracker"];
//    controller.dataDict = dict;
//    [self.navigationController pushViewController:controller animated:YES];
}


@end
