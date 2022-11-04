//
//  FindMeABuddyListViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 25/10/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "FindMeABuddyListViewController.h"
#import "FindMeABuddyListTableViewCell.h"
#import "AddYourselfBuddyViewController.h"
@interface FindMeABuddyListViewController ()
{
    
    __weak IBOutlet UIButton *addYourselfButton;
    IBOutlet UIButton *squadMemberFilterButton;
    IBOutlet UITableView *buddiesMemberTable;
    UIView *contentView;
    NSMutableArray *membersList;
    int apiCount;
}
@end

@implementation FindMeABuddyListViewController
@synthesize isRequestExists;
#pragma mark - IBAction

-(IBAction)addToAccountabilityList:(id)sender{
    AddYourselfBuddyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddYourselfBuddyView"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)squadMemberFilterButtonPressed:(id)sender{
    
}
-(IBAction)requestButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:[membersList objectAtIndex:sender.tag]]) {
        NSDictionary *dict = [membersList objectAtIndex:sender.tag];
        [self addUpdateFindBuddyDetail_WebserviceCall:dict];
    }
}
#pragma mark - End

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    membersList= [[NSMutableArray alloc]init];
    squadMemberFilterButton.layer.borderColor = squadSubColor.CGColor;
    squadMemberFilterButton.layer.borderWidth = 1;
    buddiesMemberTable.estimatedRowHeight = 100;
    buddiesMemberTable.rowHeight= UITableViewAutomaticDimension;
    
    
    
    [self getFindBuddyRequestList_WebserviceCall];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(isRequestExists){
        addYourselfButton.hidden = true;
    }else{
        [self findBuddyRequestExists_WebserviceCall];
    }
    
}
#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        cell.requestButton.tag = indexPath.row;

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
        }
    }
        return cell;
    }

@end
