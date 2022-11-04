//
//  SearchBuddyListViewController.m
//  Squad
//
//  Created by AQB Solutions Private Limited on 04/11/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "SearchBuddyListViewController.h"
#import "FindMeABuddyListTableViewCell.h"

@interface SearchBuddyListViewController (){
    __weak IBOutlet UIButton *addYourselfButton;
    IBOutlet UIButton *squadMemberFilterButton;
    IBOutlet UITableView *buddiesMemberTable;
    UIView *contentView;
    NSMutableArray *membersList;
    int apiCount;
    BOOL isUserFound;
    NSArray *sortingItemsArray;
    NSDictionary *selectedSortingItem;
    
}

@end

@implementation SearchBuddyListViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sortingItemsArray = @[@{@"id":@1,
                            @"value":@"A-Z"},
                          @{@"id":@2,
                            @"value":@"Distance"},
                          @{@"id":@3,
                            @"value":@"Recent"}
                          ];
    
    selectedSortingItem = [sortingItemsArray objectAtIndex:0];
    
    membersList= [[NSMutableArray alloc]init];
    squadMemberFilterButton.layer.borderColor = squadSubColor.CGColor;
    squadMemberFilterButton.layer.borderWidth = 1;
    buddiesMemberTable.estimatedRowHeight = 100;
    buddiesMemberTable.rowHeight= UITableViewAutomaticDimension;
    [squadMemberFilterButton setTitle:selectedSortingItem[@"value"] forState:UIControlStateNormal];
    [self getFindBuddyRequestList_WebserviceCall];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}
#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End

#pragma mark - IBAction

-(IBAction)squadMemberFilterButtonPressed:(id)sender{
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = sortingItemsArray;
    controller.mainKey = @"value";
    controller.apiType = @"sort";
    controller.selectedIndex = -1;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}
-(IBAction)requestButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:[membersList objectAtIndex:sender.tag]]) {
        NSDictionary *dict = [membersList objectAtIndex:sender.tag];
        [self addUpdateFindBuddyDetail_WebserviceCall:dict];
    }
}

//- (IBAction)chatButtonPressed:(UIButton *)sender {
//    NSDictionary *dict = [membersList objectAtIndex:sender.tag];
//    
//    if(![Utility isUserLoggedInToChatSdk]){
//        [Utility msg:@"Authentication error while creating chat thread." title:@"" controller:self haveToPop:NO];
//        return;
//    }
//    
//    
//    if(![Utility isEmptyCheck:dict]){
//        
//        if (![Utility isEmptyCheck:[dict objectForKey:@"UserDetail"]]) {
//            NSDictionary *userDetailDict = [dict objectForKey:@"UserDetail"];
//            if (![Utility isEmptyCheck:[userDetailDict objectForKey:@"EmailAddress"]]) {
//                NSString *email = userDetailDict[@"EmailAddress"];
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    if (self->contentView) {
//                        [self->contentView removeFromSuperview];
//                    }
//                    
//                    self->contentView = [Utility activityIndicatorView:self];
//                    
//                });
//                
//                isUserFound = false;
//                
//                [NM.search usersForIndexes:@[bUserEmailKey] withValue:email limit: 1 userAdded: ^(id<PUser> user) {
//                    
//                    // Make sure we run this on the main thread
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        if (user != Nil && user != NM.currentUser) {
//                            // Only display a user if they have a name set
//                            self->isUserFound = true;
//                            [NM.core createThreadWithUsers:@[user] threadCreated:^(NSError * error, id<PThread> thread) {
//                                
//                                dispatch_async(dispatch_get_main_queue(),^ {
//                                    
//                                    if (self->contentView) {
//                                        [self->contentView removeFromSuperview];
//                                    }
//                                });
//                                
//                                if(!error){
//                                    
//                                    UIViewController * chatViewController = [[BInterfaceManager sharedManager].a chatViewControllerWithThread:thread];
//                                    [self.navigationController pushViewController:chatViewController animated:YES];
//                                }else{
//                                    [Utility msg:@"Unable to create chat thread.Try Again.." title:@"" controller:self haveToPop:NO];
//                                }
//                                
//                                
//                            }];
//                        }else{
//                            
//                            dispatch_async(dispatch_get_main_queue(),^ {
//                                
//                                if (self->contentView) {
//                                    [self->contentView removeFromSuperview];
//                                }
//                                if(!self->isUserFound) [Utility msg:ChatCreationError title:@"" controller:self haveToPop:NO];
//                            });
//                        }
//                        
//                        
//                    });
//                    
//                }].thenOnMain(^id(id success) {
//                    
//                    dispatch_async(dispatch_get_main_queue(),^ {
//                        
//                        if (self->contentView) {
//                            [self->contentView removeFromSuperview];
//                        }
//                        if(!self->isUserFound) [Utility msg:ChatCreationError title:@"" controller:self haveToPop:NO];
//                    });
//                    
//                    return Nil;
//                }, ^id(NSError * error) {
//                    
//                    dispatch_async(dispatch_get_main_queue(),^ {
//                        
//                        if (self->contentView) {
//                            [self->contentView removeFromSuperview];
//                        }
//                        if(!self->isUserFound)[Utility msg:ChatCreationError title:@"" controller:self haveToPop:NO];
//                    });
//                    
//                    return error;
//                });
//            }
//        }
//        
//    }
//}


#pragma mark - End

#pragma mark - API Call
-(void)getFindBuddyRequestList_WebserviceCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        //        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetFindBuddyRequestList" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  self->apiCount--;
                                                                  if (self->apiCount==0 && self->contentView) {
                                                                      [self->contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          self->membersList = [[responseDict objectForKey:@"List"]mutableCopy];
                                                                          if (![Utility isEmptyCheck:self->membersList] && self->membersList.count>0) {
                                                                              
                                                                              NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(UserDetail.UserID == %@)",[defaults objectForKey:@"UserID"]];
                                                                              NSArray *filteredArray = [self->membersList filteredArrayUsingPredicate:predicate];
                                                                              if (![Utility isEmptyCheck:filteredArray] && filteredArray.count>0) {
                                                                                  [self->membersList removeObjectsInArray:filteredArray];
                                                                              }
                                                                              [self->buddiesMemberTable reloadData];
                                                                          }
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
-(void)addUpdateFindBuddyDetail_WebserviceCall:(NSDictionary*)dict{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        NSDictionary *userDetail= [dict objectForKey:@"UserDetail"];
        [mainDict setObject:[userDetail objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:dict forKey:@"Model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateFindBuddyDetail" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  if (self->contentView) {
                                                                      [self->contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
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
-(void)findBuddyRequestExists_WebserviceCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"FindBuddyRequestExists" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  self->apiCount--;
                                                                  if (self->apiCount==0 && self->contentView) {
                                                                      [self->contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      NSLog(@"responseDict: \n %@",responseDict);
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          if ([[responseDict objectForKey:@"Exists"]boolValue]) {
                                                                              self->addYourselfButton.hidden = true;
                                                                              
                                                                          }else{
                                                                              self->addYourselfButton.hidden = false;
                                                                          }
                                                                          
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
#pragma mark - End

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return membersList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"FindMeABuddyListTableViewCell";
    FindMeABuddyListTableViewCell *cell = (FindMeABuddyListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[FindMeABuddyListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.buddiesMemberImage.layer.cornerRadius = cell.buddiesMemberImage.frame.size.height/2;
    cell.buddiesMemberImage.layer.masksToBounds = YES;
    cell.requestButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    cell.requestButton.layer.borderWidth = 1;
    
    NSDictionary *dict = [membersList objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        cell.buddiesLocationView.hidden = true;
        if (![Utility isEmptyCheck:[dict objectForKey:@"UserDetail"]]) {
            NSDictionary *userDetailDict = [dict objectForKey:@"UserDetail"];
            NSString *detailsStr=@"";
            if (![Utility isEmptyCheck:[userDetailDict objectForKey:@"FirstName"]]) {
                detailsStr = [userDetailDict objectForKey:@"FirstName"];
            }
            if (![Utility isEmptyCheck:[userDetailDict objectForKey:@"LastName"]]) {
                detailsStr = [detailsStr stringByAppendingString:[userDetailDict objectForKey:@"LastName"]];
            }
            cell.buddiesNameLabel.text = detailsStr;
            
            detailsStr=@"";
            
            if (![Utility isEmptyCheck:[userDetailDict objectForKey:@"City"]]) {
                detailsStr = [@"" stringByAppendingFormat:@"%@,",[userDetailDict objectForKey:@"City"]];
            }
            
            if (![Utility isEmptyCheck:[userDetailDict objectForKey:@"State"]]) {
                detailsStr = [detailsStr stringByAppendingFormat:@"%@,",[userDetailDict objectForKey:@"State"]];
            }
            
            if (![Utility isEmptyCheck:[userDetailDict objectForKey:@"Country"]]) {
                detailsStr = [detailsStr stringByAppendingFormat:@"%@,",[userDetailDict objectForKey:@"Country"]];
            }
            
            if(detailsStr.length>0){
              cell.buddiesLocationView.hidden = false;
              detailsStr = [detailsStr substringToIndex:[detailsStr length]-1];
            }
            
            cell.buddiesLocationLabel.text = detailsStr;
            
        }
        
        if (![Utility isEmptyCheck:[dict objectForKey:@"Message"]]) {
            cell.buddiesMessageLabel.text = [dict objectForKey:@"Message"];
        }
        if (![Utility isEmptyCheck:[dict objectForKey:@"Photo"]]) {
            NSString *imageUrl= [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"Photo"]];
            [cell.buddiesMemberImage sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                                                              [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                       placeholderImage:[UIImage imageNamed:@"lb_avatar.png"]
                                                options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                    });
                                                }];
        }else{
            cell.buddiesMemberImage.image = [UIImage imageNamed:@"lb_avatar.png"];
        }
        
        
        cell.requestButton.tag = indexPath.row;
        cell.buddiesChatButton.tag = indexPath.row;
    }
    return cell;
}

#pragma mark - Dropdown Delegate

- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData{
    NSLog(@"ty %@ \ndata %@",type,selectedData);
    //    isChanged = YES;
    
    if ([type caseInsensitiveCompare:@"sort"] == NSOrderedSame) {
        if(![Utility isEmptyCheck:selectedData]){
            [squadMemberFilterButton setTitle:[selectedData objectForKey:@"value"] forState:UIControlStateNormal];
            selectedSortingItem = selectedData;
        }
        
    }
    
}


#pragma mark End

@end
