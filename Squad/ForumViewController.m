//
//  ForumViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 15/09/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "ForumViewController.h"
#import "ForumTableViewCell.h"
#import "MasterMenuViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyForumTableViewCell.h"
#import "CreateForumViewController.h"

@interface ForumViewController ()
{
    IBOutlet UITableView *forumTable;
    IBOutlet UITextField *searchText;
    IBOutlet UIButton *searchButton;
    IBOutlet UILabel *headerLabel;
    IBOutlet UIImageView *buttonBg;
    IBOutlet UIButton *myForum;
    IBOutlet UIButton *requestForum;
    IBOutlet UILabel *blankMsgLabel;
    IBOutlet UIButton *selectTagButton;
    
    NSMutableArray *forumListArray;
    UIView *contentView;
    NSArray *tagArray;
    
    NSMutableArray *filteredTagListArray;
    NSMutableArray *filteredTagNameArray;
    int selectedTagIndex;
    int apiCount;
    
}
@end

@implementation ForumViewController

#pragma mark - IBAction

- (IBAction)createForumButtonPressed:(id)sender {
    CreateForumViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateForum"];
    [self.navigationController pushViewController:controller animated:YES ];
}

-(IBAction)selectTagButtonTapped:(id)sender{
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = filteredTagNameArray;
    controller.selectedIndex = selectedTagIndex;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

-(IBAction)joinButtonTapped:(UIButton*)sender{
    NSDictionary *dict = [forumListArray objectAtIndex:sender.tag];
    double userId = [[dict objectForKey:@"UserId"]doubleValue];
    double forumId= [[dict objectForKey:@"Id"]doubleValue];
    [self webServiceCall_JoinSquadForumRequest:forumId with:userId rowIndex:sender.tag];
}
-(IBAction)removeButtonTapped:(UIButton*)sender{
    NSDictionary *dict = [forumListArray objectAtIndex:sender.tag];
    double userId = [[dict objectForKey:@"UserId"]doubleValue];
    double forumId= [[dict objectForKey:@"Id"]doubleValue];
    [self webServiceCall_RemoveSquadForumRequest:forumId with:userId rowIndex:sender.tag];
}
-(IBAction)chatButtonTapped:(UIButton *)sender{
    NSDictionary *dict = [forumListArray objectAtIndex:sender.tag];
    if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:[dict objectForKey:@"FacebookUrl"]]) {
        NSString *urlString =[dict objectForKey:@"FacebookUrl"];
        NSString *substractString =[urlString stringByReplacingOccurrencesOfString:@"https://www.facebook.com/groups" withString:@"fb://profile"];
            NSLog(@"%@\n %@",urlString,substractString);
            NSURL *url = [NSURL URLWithString:substractString];
            if ([[UIApplication sharedApplication] openURL:url]){
                NSLog(@"well done");
            }else {
                url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }
    }
}

- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}
-(IBAction)requsetForumOrMyForumTapped:(UIButton*)sender{
    if (sender == requestForum) {
        [self getForumListRequest];
    }else{
        [self getMyForumList];
    }
}

-(IBAction)searchbuttonPressed:(id)sender{
    [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        searchText.hidden = !searchText.hidden;
        if (searchText.hidden) {
            [self.view endEditing:YES];
        }else{
            [searchText becomeFirstResponder];
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - End

#pragma mark - API Call

//chayan 21/9/2017
-(void)webServiceCall_SearchForumByTag {
    dispatch_async(dispatch_get_main_queue(),^ {
        forumTable.hidden = true;
        blankMsgLabel.hidden = false;
    });
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
        [mainDict setObject:[[filteredTagListArray objectAtIndex:selectedTagIndex] objectForKey:@"EventTagID"] forKey:@"Tag"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SearchForumByTagRequest" append:@""forAction:@"POST"];
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
                                                                      //                                                                     NSLog(@"\n response\n %@",responseDict);
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          forumListArray = [[responseDict objectForKey:@"ForumLIst"] mutableCopy];
                                                                          forumTable.hidden = false;
                                                                          blankMsgLabel.hidden = true;
                                                                          [forumTable reloadData];
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

-(void)webServiceCall_GetForumListRequest {
    dispatch_async(dispatch_get_main_queue(),^ {
        forumTable.hidden = true;
        blankMsgLabel.hidden = false;
    });
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetForumListRequest" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  apiCount--;
                                                                  if (contentView && apiCount == 0) {
                                                                      [contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          forumListArray = [[responseDict objectForKey:@"ForumLIst"] mutableCopy];
                                                                          
                                                                          NSLog(@"\n Forum list array \n %@",forumListArray);
                                                                          forumTable.hidden = false;
                                                                          blankMsgLabel.hidden = true;
                                                                           if (apiCount == 0) {
                                                                              [self parseTag];
                                                                              [forumTable reloadData];
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
-(void)webServiceCall_SearchForum:(NSString*)search{
    dispatch_async(dispatch_get_main_queue(),^ {
        forumTable.hidden = true;
        blankMsgLabel.hidden = false;
    });
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
        [mainDict setObject:search forKey:@"SearchText"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SearchForum" append:@""forAction:@"POST"];
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
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]){
                                                                          forumListArray = [[responseDict objectForKey:@"ForumLIst"] mutableCopy];
                                                                          if (forumListArray.count>0) {
                                                                              forumTable.hidden = false;
                                                                              blankMsgLabel.hidden = true;
                                                                              [forumTable reloadData];
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
-(void)webServiceCall_JoinSquadForumRequest:(double)forumId with: (double)userId rowIndex:(NSInteger)rowIndex{
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
        [mainDict setObject:[NSNumber numberWithDouble:forumId] forKey:@"ForumId"];
        //[mainDict setObject:[NSNumber numberWithDouble:userId] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"]; //AY 28112017
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"JoinSquadForumRequest" append:@""forAction:@"POST"];
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
                                                                      NSLog(@"\nresponse dict:\n %@",responseDict);
                                                                      //chayan 12/10/2017 --ForKey:@"Success"
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          [Utility msg:@"You have been successfully joined this group." title:@"Success!" controller:self haveToPop:NO];
                                                                          [forumListArray removeObjectAtIndex:rowIndex];
                                                                          [forumTable reloadData];
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
-(void)webServiceCall_GetEventTagListApiCall {
    
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
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
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetEventTagListApiCall" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  apiCount --;
                                                                  if (contentView && apiCount == 0) {
                                                                      [contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [responseDict objectForKey:@"Count"]>0) {
                                                                          tagArray = [responseDict objectForKey:@"Tags"];
                                                                          //NSLog(@"\n\n tagarray: \n %@",tagArray);
                                                                          if (apiCount == 0) {
                                                                              [self parseTag];
                                                                              [forumTable reloadData];
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


-(void)webServiceCall_GetMyForumList {
    dispatch_async(dispatch_get_main_queue(),^ {
        forumTable.hidden = true;
        blankMsgLabel.hidden = false;
    });
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMyForumList" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  apiCount--;
                                                                  if (contentView && apiCount == 0) {
                                                                      [contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          forumTable.hidden = false;
                                                                          blankMsgLabel.hidden = true;
                                                                          forumListArray = [[responseDict objectForKey:@"ForumLIst"] mutableCopy];
                                                                          if (apiCount == 0) {
                                                                              [self parseTag];
                                                                              [forumTable reloadData];
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


//chayan: 12/10/2017 Remove forum api call
-(void)webServiceCall_RemoveSquadForumRequest:(double)forumId with: (double)userId rowIndex:(NSInteger)rowIndex{
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
        [mainDict setObject:[NSNumber numberWithDouble:forumId] forKey:@"ForumId"];
        [mainDict setObject:[NSNumber numberWithDouble:userId] forKey:@"UserId"];
        //[mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"RemoveSquadForumRequest" append:@""forAction:@"POST"];
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
                                                                      NSLog(@"\nresponse dict:\n %@",responseDict);
                                                                      //chayan 12/10/2017 --ForKey:@"Success"
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          [Utility msg:@"You have been successfully removed from this group." title:@"Success!" controller:self haveToPop:NO];
                                                                          [forumListArray removeObjectAtIndex:rowIndex];
                                                                          [forumTable reloadData];
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


#pragma mark - Private method
//chayan 20/9/2017
-(void)parseTag{
    filteredTagListArray=[[NSMutableArray alloc]init];
    filteredTagNameArray=[[NSMutableArray alloc]init];
    for (int i = 0 ; i<forumListArray.count; i++) {
        NSDictionary *dict = [forumListArray objectAtIndex:i];
        NSArray *items =[dict valueForKey:@"Tags"];
        for (int j = 0 ; j<items.count; j++) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(EventTagID == %d)", [[items objectAtIndex:j] intValue]];
            NSArray *tagDetails = [tagArray filteredArrayUsingPredicate:predicate];
            NSDictionary *d=[tagDetails objectAtIndex:0];
            if (![Utility isEmptyCheck:d]) {
                NSArray *existingTagDetails = [filteredTagListArray filteredArrayUsingPredicate:predicate];
                if ([Utility isEmptyCheck:existingTagDetails]) {
                    NSString *tagName = [[tagDetails objectAtIndex:0]objectForKey:@"Description"];
                    //  NSLog(@"\n\n tagName: \n %@",tagName);
                    [filteredTagNameArray addObject:tagName];
                    [filteredTagListArray addObject:[tagDetails objectAtIndex:0]];
                }
            }
        }
        //NSLog(@"\nfilteredTagListArray\n%@",filteredTagListArray);
        //NSLog(@"\nfilteredTagNameArray\n%@",filteredTagNameArray);
    }
}
-(void)getForumListRequest{
    dispatch_async(dispatch_get_main_queue(),^ {
        selectTagButton.hidden=false;
        requestForum.selected = true;
        myForum.selected = false;
        selectedTagIndex=-1;
        buttonBg.image = [UIImage imageNamed:@"sq_tab_bar.png"];
        headerLabel.text = @"";
        [defaults setBool:false forKey:@"isFromMyList"];
    });
    [self webServiceCall_GetForumListRequest];
}

-(void)getMyForumList{
    myForum.selected = true;
    requestForum.selected = false;
    buttonBg.image = [UIImage imageNamed:@"sq_tab_bar_flip.png"];
    headerLabel.text = @"My Forum";
    [defaults setBool:true forKey:@"isFromMyList"];
    [self webServiceCall_GetMyForumList];
}
#pragma mark - End

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedTagIndex=-1;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    buttonBg.image = [UIImage imageNamed:@"sq_tab_bar.png"];
    headerLabel.text = @"";
    if(!forumListArray){
        forumListArray=[[NSMutableArray alloc] init];
    }
    apiCount= 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self webServiceCall_GetEventTagListApiCall];
        if ([defaults boolForKey:@"isFromMyList"]) {
            [self getMyForumList];
        }else{
            [self getForumListRequest];
        }
    });

}
#pragma mark -  End

#pragma mark - memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End

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
    return forumListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([defaults boolForKey:@"isFromMyList"]) {
        MyForumTableViewCell *mycell = (MyForumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyForumTableViewCell"];
        if (mycell == nil) {
            mycell = [[MyForumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyForumTableViewCell"];
        }
        NSDictionary *dict = [forumListArray objectAtIndex:indexPath.row];
        mycell.removeButton.layer.cornerRadius = 15;
        mycell.removeButton.tag = indexPath.row;
        mycell.chatButton.layer.cornerRadius = 15;
        mycell.chatButton.tag = indexPath.row;
        mycell.chatButton.hidden = false;
        mycell.forumImage.layer.cornerRadius = mycell.forumImage.frame.size.width/2;
        mycell.forumImage.clipsToBounds = YES;
        if (![Utility isEmptyCheck:[dict objectForKey:@"PictureUrl"]]) {
            NSString *baseUrl = [BASEURL stringByAppendingFormat:@"/Content/images/Forum/%@",[dict objectForKey:@"PictureUrl"]];
            [mycell.forumImage sd_setImageWithURL:[NSURL URLWithString:[baseUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                                                        [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                 placeholderImage:[UIImage imageNamed:@"Photo.png"] options:SDWebImageScaleDownLargeImages];
        }
        if (![Utility isEmptyCheck:[dict objectForKey:@"ForumName"]]) {
            mycell.forumTitle.text = [dict objectForKey:@"ForumName"];
        }
        if (![Utility isEmptyCheck:[dict objectForKey:@"Overview"]]) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"Overview :"];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Bold" size:15] range:NSMakeRange(0, [attributedString length])];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"5f5f5f"] range:NSMakeRange(0, [attributedString length])];
            
            NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",[dict objectForKey:@"Overview"]]];
            [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway" size:15] range:NSMakeRange(0, [attributedString2 length])];
            [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"908E8E"] range:NSMakeRange(0, [attributedString2 length])];
            
            [attributedString appendAttributedString:attributedString2];
            mycell.forumDescrip.attributedText = attributedString;
        }
        if (![Utility isEmptyCheck:[dict objectForKey:@"Description"]]) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"Description :"];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Bold" size:15] range:NSMakeRange(0, [attributedString length])];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"5f5f5f"] range:NSMakeRange(0, [attributedString length])];
            
            NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",[dict objectForKey:@"Description"]]];
            [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway" size:15] range:NSMakeRange(0, [attributedString2 length])];
            [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"908E8E"] range:NSMakeRange(0, [attributedString2 length])];
            
            [attributedString appendAttributedString:attributedString2];
            mycell.forumDetails.attributedText = attributedString;
            
        }if (![Utility isEmptyCheck:[dict objectForKey:@"Rules"]]) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"Rules :"];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Bold" size:15] range:NSMakeRange(0, [attributedString length])];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"5f5f5f"] range:NSMakeRange(0, [attributedString length])];
            
            NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",[dict objectForKey:@"Rules"]]];
            [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway" size:15] range:NSMakeRange(0, [attributedString2 length])];
            [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"908E8E"] range:NSMakeRange(0, [attributedString2 length])];
            
            [attributedString appendAttributedString:attributedString2];
            mycell.forumRules.attributedText = attributedString;
        }
        
        if (![Utility isEmptyCheck:[dict objectForKey:@"UserName"]]) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"post by"];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway" size:15] range:NSMakeRange(0, [attributedString length])];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"908E8E"] range:NSMakeRange(0, [attributedString length])];
            
            NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",[dict objectForKey:@"UserName"]]];
            [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway" size:15] range:NSMakeRange(0, [attributedString2 length])];
            [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"F427AB"] range:NSMakeRange(0, [attributedString2 length])];
            
            [attributedString appendAttributedString:attributedString2];
            mycell.forumPost.attributedText = attributedString;
        }
        if (![Utility isEmptyCheck:[dict objectForKey:@"CreatedDate"]]) {
            static NSDateFormatter *dateFormatter;
            dateFormatter = [NSDateFormatter new];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
            NSDate *date = [dateFormatter dateFromString:[dict objectForKey:@"CreatedDate"]];
            //NSLog(@"%@",date);
            YLMoment *moment = [YLMoment momentWithDate:date];
            NSString *detailString=[moment fromNow];
            //NSLog(@"%@",detailString);
            mycell.forumDate.text = detailString;
            
        }
        if (![Utility isEmptyCheck:[dict valueForKey:@"Tags"]]) {
            NSArray *items =[dict valueForKey:@"Tags"];
            NSMutableAttributedString *newString =[[NSMutableAttributedString alloc] init];
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"p_tag.png"];
            textAttachment.bounds = CGRectMake(0, -3, textAttachment.image.size.width, textAttachment.image.size.height);
            NSDictionary *attrsDictionary = @{
                                              NSFontAttributeName : mycell.forumTag.font,
                                              NSForegroundColorAttributeName : mycell.forumTag.textColor
                                              };
            
            for (int i = 0 ; i<items.count; i++) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(EventTagID == %d)", [[items objectAtIndex:i] intValue]];
                NSArray *tagDetails = [tagArray filteredArrayUsingPredicate:predicate];
                
                NSString *itemsName = [[tagDetails objectAtIndex:0]objectForKey:@"Description"];
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
            mycell.forumTag.attributedText = newString;
        }
        return mycell;
        
    }else{
        ForumTableViewCell *cell = (ForumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ForumTableViewCell"];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[ForumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ForumTableViewCell"];
        }
        NSDictionary *dict = [forumListArray objectAtIndex:indexPath.row];
        cell.joinButton.layer.cornerRadius = 15;
        cell.joinButton.tag = indexPath.row;
        cell.forumImage.layer.cornerRadius = cell.forumImage.frame.size.width/2;
        cell.forumImage.clipsToBounds = YES;
        if (![Utility isEmptyCheck:[dict objectForKey:@"PictureUrl"]]) {
            NSString *baseUrl = [BASEURL stringByAppendingFormat:@"/Content/images/Forum/%@",[dict objectForKey:@"PictureUrl"]];
            [cell.forumImage sd_setImageWithURL:[NSURL URLWithString:[baseUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                                                      [NSCharacterSet URLQueryAllowedCharacterSet]]]
                               placeholderImage:[UIImage imageNamed:@"Photo.png"] options:SDWebImageScaleDownLargeImages];
        }
        if (![Utility isEmptyCheck:[dict objectForKey:@"ForumName"]]) {
            cell.forumTitle.text = [dict objectForKey:@"ForumName"];
        }
        if (![Utility isEmptyCheck:[dict objectForKey:@"Overview"]]) {
            cell.forumDescrip.text = [dict objectForKey:@"Overview"];
        }
        
        if (![Utility isEmptyCheck:[dict objectForKey:@"UserName"]]) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"post by"];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway" size:15] range:NSMakeRange(0, [attributedString length])];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"908E8E"] range:NSMakeRange(0, [attributedString length])];
            
            NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",[dict objectForKey:@"UserName"]]];
            [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway" size:15] range:NSMakeRange(0, [attributedString2 length])];
            [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"F427AB"] range:NSMakeRange(0, [attributedString2 length])];
            
            [attributedString appendAttributedString:attributedString2];
            cell.forumPost.attributedText = attributedString;
        }
        if (![Utility isEmptyCheck:[dict objectForKey:@"CreatedDate"]]) {
            static NSDateFormatter *dateFormatter;
            dateFormatter = [NSDateFormatter new];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
            NSDate *date = [dateFormatter dateFromString:[dict objectForKey:@"CreatedDate"]];
            //NSLog(@"%@",date);
            YLMoment *moment = [YLMoment momentWithDate:date];
            NSString *detailString=[moment fromNow];
            NSLog(@"%@",detailString);
            cell.forumDate.text = detailString;
            
        }
        if (![Utility isEmptyCheck:[dict valueForKey:@"Tags"]]) {
            NSArray *items =[dict valueForKey:@"Tags"];
            NSMutableAttributedString *newString =[[NSMutableAttributedString alloc] init];
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"p_tag.png"];
            textAttachment.bounds = CGRectMake(0, -3, textAttachment.image.size.width, textAttachment.image.size.height);
            NSDictionary *attrsDictionary = @{
                                              NSFontAttributeName : cell.forumTag.font,
                                              NSForegroundColorAttributeName : cell.forumTag.textColor
                                              };
            
            for (int i = 0 ; i<items.count; i++) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(EventTagID == %d)", [[items objectAtIndex:i] intValue]];
                NSArray *tagDetails = [tagArray filteredArrayUsingPredicate:predicate];
                
                NSString *itemsName = [[tagDetails objectAtIndex:0]objectForKey:@"Description"];
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
            cell.forumTag.attributedText = newString;
        }
        return cell;
        
    }
}
#pragma mark - End
#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length > 0){
        [self webServiceCall_SearchForum:textField.text];
        searchText.text=@"";
        [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            searchText.hidden = true;
            [self.view endEditing:YES];
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

#pragma mark - End
#pragma mark -DropdownViewDelegate
//chayan 21/9/2017
- (void) tagSelected:(int)index{
    selectedTagIndex=index;
    [self webServiceCall_SearchForumByTag];
}
#pragma mark -End
@end
