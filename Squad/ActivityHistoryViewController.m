//
//  ActivityHistoryViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 27/07/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "ActivityHistoryViewController.h"
#import "ActivityHistoryTableViewCell.h"
#import "DropdownViewController.h"
#import "AppDelegate.h"

@interface ActivityHistoryViewController () {
    IBOutlet UITableView *table;
    
    UIView *contentView;
    NSMutableArray *activityHistoryArray;
    NSMutableArray *filterArray;
    int dayFilter;
    AppDelegate *appDelegate;
}

@end

@implementation ActivityHistoryViewController
//ah 31.8

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    activityHistoryArray = [[NSMutableArray alloc] init];
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
- (IBAction)deleteButtonTapped:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Comfirm Delete"
                                          message:@"Do you want to delete this activity?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Delete"
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   [self deleteActivityHistoryWithID:sender.tag];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - API Calls
-(void) getActivityHistory {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!contentView || ![contentView isDescendantOfView:self.view]) {
                contentView = [Utility activityIndicatorView:self];
            }
        });
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[NSNumber numberWithInt:dayFilter] forKey:@"Days"];

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetActivityHistory" append:@""forAction:@"POST"];
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
                                                                          activityHistoryArray = [responseDict objectForKey:@"ActivityHistory"];
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
-(void) deleteActivityHistoryWithID:(NSInteger)historyID {
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
        [mainDict setObject:[NSNumber numberWithInteger:historyID] forKey:@"Id"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteActivityData" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
//                                                                  if (contentView) {
                                                                      //[contentView removeFromSuperview];
//                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          [self getActivityHistory];
                                                                          [Utility msg:@"Deteled Successfully" title:@"" controller:self haveToPop:NO];
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
    return activityHistoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"ActivityHistoryTableViewCell";
    ActivityHistoryTableViewCell *cell = (ActivityHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[ActivityHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = [activityHistoryArray objectAtIndex:indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *newDate = [formatter dateFromString:[dict objectForKey:@"Logdate"]];
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *dateStr = [formatter stringFromDate:newDate];
    
    cell.dateLabel.text = dateStr;
    cell.timeLabel.text = [dict objectForKey:@"Time"];
    
    //    cell.distanceLabel.text = [NSString stringWithFormat:@"%.03f",[[dict objectForKey:@"Distance"] floatValue]];
    NSString *myDistance = [NSString stringWithFormat:@"%.03f",[[dict objectForKey:@"Distance"] floatValue]];
    NSString *calcDistance = @"";
    if (![Utility isEmptyCheck:[defaults objectForKey:@"UnitPreference"]] && [[defaults objectForKey:@"UnitPreference"]intValue] == 2) {
        //imperial
        float convDistance = [myDistance floatValue];
        convDistance *= 0.621371;
        calcDistance = [NSString stringWithFormat:@"%.03f",convDistance];
        cell.distanceType.text = @"MILES";
    } else {
        //metric
        calcDistance = myDistance;
        cell.distanceType.text = @"KM";
    }
    cell.distanceLabel.text = calcDistance;
    
    [cell.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton setTag:[[dict objectForKey:@"Id"] integerValue]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

@end
