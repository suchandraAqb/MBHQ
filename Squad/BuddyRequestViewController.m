//
//  BuddyRequestViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 27/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "BuddyRequestViewController.h"
#import "BuddyRequestTableViewCell.h"

@interface BuddyRequestViewController (){
    IBOutlet UITableView *buddiesRequestTable;
    IBOutlet UIButton *cancelButton;
    IBOutlet UILabel *nodataLabel;
    UIView *contentView;
}

@end

@implementation BuddyRequestViewController
@synthesize requestArray,delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (requestArray.count > 0) {
        buddiesRequestTable.hidden = false;
        nodataLabel.hidden = true;
    }else{
        buddiesRequestTable.hidden = true;
        nodataLabel.hidden = false;
        [buddiesRequestTable reloadData];
    }
}
#pragma mark -IBAction
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)deleteButtonPressed:(UIButton *)sender {
    NSDictionary *dict = [requestArray objectAtIndex:sender.tag];
    if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Id"]]){
        [self deleteHabitApiCall:dict[@"Id"]];
    }
}

- (IBAction)acceptButtonPressed:(UIButton *)sender {
    NSDictionary *dict = [requestArray objectAtIndex:sender.tag];
    if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"FriendUserId"]]){
        [self acceptApiCall:dict[@"Id"]];
    }
}
#pragma mark -End

#pragma mark -ApiCall
-(void)acceptApiCall:(NSNumber *)habitId{
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
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:habitId forKey:@"Id"];
        
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"FriendRequestAccept" append:@""forAction:@"POST"];
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
                                                                      NSLog(@"responseDict: \n %@",responseDict);
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          [self dismissViewControllerAnimated:YES completion:^{
                                                                              if ([delegate respondsToSelector:@selector(didDismiss)]) {
                                                                                  [delegate didDismiss];
                                                                              }
                                                                          }];
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
-(void)deleteHabitApiCall:(NSNumber *)habitId{
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
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:habitId forKey:@"FrindshipId"];
        
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteMyFriend" append:@""forAction:@"POST"];
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
                                                                      NSLog(@"responseDict: \n %@",responseDict);
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          [self dismissViewControllerAnimated:YES completion:^{
                                                                              if ([delegate respondsToSelector:@selector(didDismiss)]) {
                                                                                  [delegate didDismiss];
                                                                              }
                                                                          }];
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
#pragma mark -End
#pragma mark - TableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return requestArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuddyRequestTableViewCell *cell = (BuddyRequestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BuddyRequestTableViewCell"];
    // Configure the cell...
    if (cell == nil) {
        cell = [[BuddyRequestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BuddyRequestTableViewCell"];
    }
    
    NSDictionary *dict = [requestArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        NSLog(@"name: %@",[dict objectForKey:@"Name"]);
        NSLog(@"name: %@",[dict objectForKey:@"City"]);
        cell.nameLabel.text = [dict objectForKey:@"Name"];
        cell.cityLabel.text = [dict objectForKey:@"City"];
        cell.acceptButton.tag=indexPath.row;
        cell.deleteButton.tag=indexPath.row;
    }
    
    return cell;
}
#pragma Mark End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
