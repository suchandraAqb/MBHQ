//
//  AccountabilityBuddiesListViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 9/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AccountabilityBuddiesListViewController.h"
#import "AccountabilityBuddiesListTableViewCell.h"
#import "HealthyHabitBuilderViewController.h"
#import "MessageViewController.h"
#import "MyHealthyHabitListViewController.h"

@interface AccountabilityBuddiesListViewController (){
    IBOutlet UILabel *buddiesRequestNumber;

    IBOutlet UITableView *accountabilityBuddiesTable;
//    IBOutlet UIButton *buddyButton;
    UIView *contentView;
    NSArray *accountabilityBuddiesArray;
    NSArray *requestArray;
    BOOL isUserFound;
}

@end

@implementation AccountabilityBuddiesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    accountabilityBuddiesTable.estimatedRowHeight = 95;
    accountabilityBuddiesTable.rowHeight = UITableViewAutomaticDimension;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self GetbuddyListApiCall];
}
#pragma mark -ApiCall

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
                                                                          [self GetbuddyListApiCall];
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
-(void)toggleNotificationApiCall:(NSNumber *)frndId{
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
        [mainDict setObject:frndId forKey:@"FriendId"];

        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleNotification" append:@""forAction:@"POST"];
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
                                                                          [self GetbuddyListApiCall];
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
-(void) GetbuddyListApiCall{
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
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetbuddyList" append:@""forAction:@"POST"];
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
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          NSArray *tempArray =[responseDict objectForKey:@"FriendListDetail"];
                                                                          accountabilityBuddiesArray = [tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(StatusFromFriend == %d)", 0]];
                                                                          NSLog(@"%@",accountabilityBuddiesArray);
                                                                          requestArray =[tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(StatusFromFriend == %d)", 1]];
                                                                          if(requestArray.count >0){
                                                                              buddiesRequestNumber.hidden = false;
                                                                              buddiesRequestNumber.text = [NSString stringWithFormat:@"%lu",(unsigned long)requestArray.count];
                                                                          }else{
                                                                              buddiesRequestNumber.hidden = true;
                                                                          }
                                                                          
                                                                          
                                                                              
                                                                          [accountabilityBuddiesTable reloadData];
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
-(void)sendFriendRequest:(NSString *)email{
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
        [mainDict setObject:email forKey:@"EmailId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SendFriendRequest" append:@""forAction:@"POST"];
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
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          [Utility msg:@"Friend request sent successfully" title:@"Success" controller:self haveToPop:NO];
                                                                          [self sendPushToUserWithEmail:email friendId:[responseDict[@"ShareChecklistId"] intValue]];
                                                                          return;
                                                                      }else{
                                                                          //[Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                          return;
                                                                      }
                                                                  }else{
                                                                      [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                      return;
                                                                  }
                                                              });
                                                              
                                                          }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
#pragma mark - End


#pragma mark - IBAction

- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}

- (IBAction)backTapped:(UIButton *)sender {
    [self.navigationController  popViewControllerAnimated:YES];
}


//- (IBAction)mailButtonPressed:(UIButton *)sender {
//    NSDictionary *dict = [accountabilityBuddiesArray objectAtIndex:sender.tag];
//
//    /*if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"FriendUserId"]]){
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//        MessageViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"Message"];
//        controller.receiverId = [dict[@"FriendUserId"] intValue];
//        controller.receiverName =dict[@"Name"];
//        [self.navigationController pushViewController:controller animated:NO];
//    }*/
//
//    if(![Utility isUserLoggedInToChatSdk]){
//       [Utility msg:@"Authentication error while creating chat thread." title:@"" controller:self haveToPop:NO];
//        return;
//    }
//
//
//    if(![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Email"]]){
//
//        NSString *email = dict[@"Email"];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            if (self->contentView) {
//                [self->contentView removeFromSuperview];
//            }
//
//            self->contentView = [Utility activityIndicatorView:self];
//
//        });
//
//        isUserFound = false;
//
//        [NM.search usersForIndexes:@[bUserEmailKey] withValue:email limit: 1 userAdded: ^(id<PUser> user) {
//
//            // Make sure we run this on the main thread
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                if (user != Nil && user != NM.currentUser) {
//                    // Only display a user if they have a name set
//                    self->isUserFound = true;
//                    [NM.core createThreadWithUsers:@[user] threadCreated:^(NSError * error, id<PThread> thread) {
//
//                        dispatch_async(dispatch_get_main_queue(),^ {
//
//                            if (self->contentView) {
//                                [self->contentView removeFromSuperview];
//                            }
//                        });
//
//                        if(!error){
//
//                            UIViewController * chatViewController = [[BInterfaceManager sharedManager].a chatViewControllerWithThread:thread];
//                            [self.navigationController pushViewController:chatViewController animated:YES];
//                        }else{
//                            [Utility msg:@"Unable to create chat thread.Try Again.." title:@"" controller:self haveToPop:NO];
//                        }
//
//
//                    }];
//                }else{
//
//                    dispatch_async(dispatch_get_main_queue(),^ {
//
//                        if (self->contentView) {
//                            [self->contentView removeFromSuperview];
//                        }
//                       if(!self->isUserFound) [Utility msg:ChatCreationError title:@"" controller:self haveToPop:NO];
//                    });
//                }
//
//
//            });
//
//        }].thenOnMain(^id(id success) {
//
//            dispatch_async(dispatch_get_main_queue(),^ {
//
//                if (self->contentView) {
//                    [self->contentView removeFromSuperview];
//                }
//               if(!self->isUserFound) [Utility msg:ChatCreationError title:@"" controller:self haveToPop:NO];
//            });
//
//            return Nil;
//        }, ^id(NSError * error) {
//
//            dispatch_async(dispatch_get_main_queue(),^ {
//
//                if (self->contentView) {
//                    [self->contentView removeFromSuperview];
//                }
//                if(!self->isUserFound)[Utility msg:ChatCreationError title:@"" controller:self haveToPop:NO];
//            });
//
//            return error;
//        });
//
//
//
//    }
//
//
//
//}

- (IBAction)sortButtonPressed:(UIButton *)sender {
    NSDictionary *dict = [accountabilityBuddiesArray objectAtIndex:sender.tag];
    if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Id"]]){
        HealthyHabitBuilderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthyHabitBuilder"];
        controller.friendId =dict[@"FriendUserId"];
        controller.friendName=[dict objectForKey:@"Name"];
        controller.friendEmail=[dict objectForKey:@"Email"];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (IBAction)deleteButtonPressed:(UIButton *)sender {
    NSDictionary *dict = [accountabilityBuddiesArray objectAtIndex:sender.tag];
    if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Id"]]){
        [self deleteHabitApiCall:dict[@"Id"]];
    }
}

- (IBAction)bellButtonPressed:(UIButton *)sender {
    NSDictionary *dict = [accountabilityBuddiesArray objectAtIndex:sender.tag];
    if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"FriendUserId"]]){
        [self toggleNotificationApiCall:dict[@"Id"]];
    }
}

- (IBAction)addBuddiesButtonPressed:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Add New Friend"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Enter Friend's Email Address";
         textField.keyboardType = UIKeyboardTypeEmailAddress;
         
     }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Add"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *emailText = alertController.textFields.firstObject;
                                   NSString *email =emailText.text;
                                   if(![Utility isEmptyCheck:email]){
                                       if (![Utility validateEmail:email]) {
                                           [Utility msg:@"Please enter a valid email." title:@"Oops" controller:self haveToPop:NO];
                                           return;
                                       }else{
                                           [self sendFriendRequest:email];
                                       }
                                       
                                   }else{
                                       [Utility msg:@"Please enter friend's email." title:@"Oops" controller:self haveToPop:NO];
                                       return;
                                   }
                                    
                                   
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)requestListButtonPressed:(UIButton *)sender {
    BuddyRequestViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BuddyRequest"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.requestArray = requestArray;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)accountabilityButtonPressed:(UIButton *)sender {
    MyHealthyHabitListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyHealthyHabitList"];
    [self.navigationController pushViewController:controller animated:YES ];
    
}


#pragma mark - End

#pragma mark - Private Method
-(void)sendPushToUserWithEmail:(NSString *)email friendId:(int)friendShipId{
    /*
    if(![Utility isUserLoggedInToChatSdk]) return;
    
    NSString *firstName = (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]])?[defaults objectForKey:@"FirstName"]:@"";
    
    NSString *msg = @"";
    
    if(![Utility isEmptyCheck:firstName]){
        msg = [@"" stringByAppendingFormat:@"%@ ,sent you a friend request. Click here to accept.",firstName];
    }else{
        msg = [@"" stringByAppendingFormat:@"You have a new friend request. Click here to accept."];
    }
    
    NSDictionary * dict = @{@"isFriendRequest": @YES,
                            @"friendShipId": [NSNumber numberWithInt:friendShipId],
                            bMessageTextKey:msg
                            };
    
    [Utility sendFriendRequestWithPush:email messageDetails:dict];
    */
}
#pragma mark - End



-(void)didDismiss{
    [self viewWillAppear:YES];
}

#pragma mark - TableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return accountabilityBuddiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountabilityBuddiesListTableViewCell *cell = (AccountabilityBuddiesListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AccountabilityBuddiesListTableViewCell"];
    // Configure the cell...
    if (cell == nil) {
        cell = [[AccountabilityBuddiesListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountabilityBuddiesListTableViewCell"];
    }
    
    NSDictionary *dict = [accountabilityBuddiesArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        NSLog(@"name: %@",[dict objectForKey:@"Name"]);
        NSLog(@"name: %@",[dict objectForKey:@"City"]);
        cell.nameLabel.text = [dict objectForKey:@"Name"];
        cell.cityLabel.text = [dict objectForKey:@"City"];
//        if (![Utility isEmptyCheck:dict[@"UnreadMessage"]] && ![dict[@"UnreadMessage"] isEqualToNumber:@0]) {
//            cell.unreadMessage.hidden = false;
//            cell.unreadMessage.text = [NSString stringWithFormat:@"%@",dict[@"UnreadMessage"]];
//        }else{
//            cell.unreadMessage.hidden = true;
//        }
        if(![Utility isEmptyCheck:dict[@"Notification"]]){
            cell.bellButton.selected = [dict[@"Notification"] boolValue];
        }else{
            cell.bellButton.selected = false;
        }
        cell.mailButton.tag=indexPath.row;
        cell.sortButton.tag=indexPath.row;
        cell.deleteButton.tag=indexPath.row;
        cell.bellButton.tag=indexPath.row;
        
        cell.unreadMessage.hidden = true;
        NSLog(@"IsUser Authenticated USER:%@",[FIRAuth auth].currentUser.displayName);
        if(![Utility isEmptyCheck:dict[@"Email"]] && [Utility isUserLoggedInToChatSdk]){
            
//            NSString *email = dict[@"Email"];
//            [NM.search usersForIndexes:@[bUserEmailKey] withValue:email limit: 1 userAdded: ^(id<PUser> user) {
//                
//                // Make sure we run this on the main thread
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    if (user != Nil && user != NM.currentUser) {
//                        // Only display a user if they have a name set
//                        
//                        NSString *name = user.name;
//                        
//                        if([Utility isEmptyCheck:name] && ![Utility isEmptyCheck:[dict objectForKey:@"Name"]]){
//                            NSString *name=[dict objectForKey:@"Name"];
//                            [user setName:name];
//                        }
//                        
//                        [NM.core createThreadWithUsers:@[user] threadCreated:^(NSError * error, id<PThread> thread) {
//                            int unreadCount =  thread.unreadMessageCount;
//                            if(unreadCount>0){
//                                cell.unreadMessage.hidden = false;
//                                cell.unreadMessage.text = [NSString stringWithFormat:@"%d",unreadCount];
//                            }
//                        }];
//                    }
//                    
//                    
//                });
//                
//            }].thenOnMain(^id(id success) {
//                
//                return Nil;
//            }, ^id(NSError * error) {
//                
//                return error;
//            });
//            
            
            
        }
    }
    
    cell.cityLabel.text = @"";
    
    return cell;
}
#pragma Mark End






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
