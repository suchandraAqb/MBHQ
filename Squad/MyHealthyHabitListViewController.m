//
//  MyHealthyHabitListViewController.m
//  Squad
//
//  Created by MAC 6- AQB SOLUTIONS on 24/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "MyHealthyHabitListViewController.h"
#import "MyHealthyHabitListTableViewCell.h"
#import "CreateMyHealthyHabitListViewController.h"

@interface MyHealthyHabitListViewController (){

    IBOutlet UITableView *table;
    IBOutlet UIButton *helpButton;
    NSMutableArray *listArray;
    UIView *contentView;
    IBOutlet UIView *addHabitMessageView;
}

@end

@implementation MyHealthyHabitListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    listArray=[[NSMutableArray alloc] init];
}

//chayan 31/10/2017
- (void) viewWillAppear:(BOOL)animated{
    [self getUserHabitListApiCall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}
- (IBAction)backTapped:(id)sender {
    [self.navigationController  popViewControllerAnimated:YES];
}

- (IBAction)downArrowPressed:(UIButton *)sender {
    NSInteger section = [sender.accessibilityHint integerValue];
    NSInteger index=sender.tag;
    NSDictionary *dict =listArray[section][index];
    if (![Utility isEmptyCheck:dict]) {
        [self togglePositionApiCall:dict withType:0];
    }

}
- (IBAction)upArrowPressed:(UIButton *)sender {
    NSInteger section = [sender.accessibilityHint integerValue];
    NSInteger index=sender.tag;
    NSDictionary *dict =listArray[section][index];
    if (![Utility isEmptyCheck:dict]) {
        [self togglePositionApiCall:dict withType:1];
    }
}

- (IBAction)visibleButtonPressed:(UIButton *)sender {
    NSInteger section = [sender.accessibilityHint integerValue];
    NSInteger index=sender.tag;
    NSDictionary *dict =listArray[section][index];
    if (![Utility isEmptyCheck:dict]) {
        [self toggleVisibleApiCall:dict];
    }
}

- (IBAction)deleteButtonPressed:(UIButton *)sender {
    NSInteger section = [sender.accessibilityHint integerValue];
    NSInteger index=sender.tag;
    NSDictionary *dict =listArray[section][index];
    if (![Utility isEmptyCheck:dict]) {
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle:@"alert"      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                    message:@"Do you want to delete this habit?"
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* button0 = [UIAlertAction
                                  actionWithTitle:@"Cancel"
                                  style:UIAlertActionStyleCancel
                                  handler:^(UIAlertAction * action)
                                  {
                                      //  UIAlertController will automatically dismiss the view
                                  }];
        
        UIAlertAction* button1 = [UIAlertAction
                                  actionWithTitle:@"Yes"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      [self deleteHabitApiCall:dict];
                                      
                                  }];
        
        [alert addAction:button0];
        [alert addAction:button1];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}




- (IBAction)plusButtonPressed:(id)sender {
    CreateMyHealthyHabitListViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateMyHealthyHabitList"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.delegate=self;
    [self presentViewController:controller animated:YES completion:nil];

}

- (IBAction)activeButtonPressed:(UIButton *)sender {
    NSInteger section = [sender.accessibilityHint integerValue];
    NSInteger index=sender.tag;
    NSDictionary *dict =listArray[section][index];
    if (![Utility isEmptyCheck:dict]) {
        [self toggleActiveApiCall:dict];
    }
}

- (IBAction)helpButtonPressed:(id)sender {
    NSString *urlString=@"https://player.vimeo.com/external/220937662.m3u8?s=38a17694e14093b93c516efe24d9c6592677ba25";
    
    if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeHealthyHabitBuilder"] boolValue]) {
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
        NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeHealthyHabitBuilder"];
        [defaults setObject:dict forKey:@"firstTimeHelpDict"];
        
        
    }
    else{
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
    }
}
-(void) animateHelp {   //ah ux
    [UIView animateWithDuration:1.5 animations:^{
        helpButton.alpha = 0.2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            helpButton.alpha = 1;
        } completion:^(BOOL finished) {
            UIViewController *vc = [self.navigationController visibleViewController];
            if (vc == self)
                [self animateHelp];
        }];
    }];
}

#pragma mark - End

#pragma mark - Api Call

- (void)getUserHabitListApiCall{
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserHabitList" append:@""forAction:@"POST"];
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
                                                                          if (![Utility isEmptyCheck:[responseDict objectForKey:@"HabitList"]]) {
                                                                            NSArray  *initialListArray = [responseDict objectForKey:@"HabitList"];
                                                                              NSSortDescriptor * statusDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Status" ascending:NO];
                                                                              NSArray * sortDescriptors = [NSArray arrayWithObject:statusDescriptor];
                                                                              NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"Status = %@", @1];
                                                                              NSArray *active = [initialListArray filteredArrayUsingPredicate:aPredicate];
                                                                              
                                                                              NSPredicate *inPredicate = [NSPredicate predicateWithFormat:@"Status = %@", @0];
                                                                              NSArray *inactive = [initialListArray filteredArrayUsingPredicate:inPredicate];

                                                                              listArray= [[NSMutableArray alloc]initWithObjects:active,inactive, nil];
                                                                              addHabitMessageView.hidden=true;
                                                                              table.hidden=false;
                                                                              [table reloadData];
                                                                              
                                                                          }else{
                                                                              if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeHealthyHabitBuilder"] boolValue]) {
                                                                                  [self animateHelp];
                                                                              }
                                                                              addHabitMessageView.hidden=false;
                                                                              table.hidden=true;
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


- (void)toggleActiveApiCall:(NSDictionary*) paramDict{
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
        [mainDict setObject:[paramDict objectForKey:@"HabitId"] forKey:@"HabitId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleActive" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  if (contentView) {
                                                                      [contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSLog(@"\n\n response string: \n%@",responseString);
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      NSLog(@"\n\n response dict: \n%@",responseDict);
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          [self getUserHabitListApiCall];
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

- (void)toggleVisibleApiCall:(NSDictionary*) paramDict{
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
        [mainDict setObject:[paramDict objectForKey:@"HabitId"] forKey:@"HabitId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleVisible" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  if (contentView) {
                                                                      [contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSLog(@"\n\n response string: \n%@",responseString);
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      NSLog(@"\n\n response dict: \n%@",responseDict);
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          [self getUserHabitListApiCall];
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


- (void)deleteHabitApiCall:(NSDictionary*) paramDict{
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
        [mainDict setObject:[paramDict objectForKey:@"HabitId"] forKey:@"HabitId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteHabit" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  if (contentView) {
                                                                      [contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSLog(@"\n\n response string: \n%@",responseString);
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      NSLog(@"\n\n response dict: \n%@",responseDict);
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          [self getUserHabitListApiCall];
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


- (void)togglePositionApiCall:(NSDictionary *) paramDict withType:(NSInteger) type{
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
        [mainDict setObject:[paramDict objectForKey:@"HabitId"] forKey:@"HabitId"];
        [mainDict setObject:[NSNumber numberWithInteger:type] forKey:@"Type"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ChangePosition" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  if (contentView) {
                                                                      [contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSLog(@"\n\n response string: \n%@",responseString);
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      NSLog(@"\n\n response dict: \n%@",responseDict);
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          [self getUserHabitListApiCall];
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





#pragma mark - TableView Datasource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return listArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *customLabel = [[UILabel alloc] init];
    customLabel.backgroundColor=[UIColor whiteColor];
    customLabel.textColor = [UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1];
    customLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:17.0];
    if(section == 0){
        customLabel.text = @"  Active";
        
    }else{
        customLabel.text = @"  Inactive";
    }
    return customLabel;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array =listArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyHealthyHabitListTableViewCell *cell = (MyHealthyHabitListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyHealthyHabitListTableViewCell"];
    // Configure the cell...
    if (cell == nil) {
        cell = [[MyHealthyHabitListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyHealthyHabitListTableViewCell"];
    }
    NSArray *array = [listArray objectAtIndex:indexPath.section];
    if (array.count> 0) {
        NSDictionary *dict = [array objectAtIndex:indexPath.row];
        cell.nameLabel.text=[dict objectForKey:@"HabitName"];
        cell.activeButton.selected=[[dict objectForKey:@"Status"] boolValue];
        cell.visibleButton.selected=[[dict objectForKey:@"Shareable"] boolValue];
        if(cell.visibleButton.selected){
            cell.visibleInvisiableLabel.text = @"Buddy Visible";
        }else{
            cell.visibleInvisiableLabel.text = @"Buddy Invisible";
        }
        cell.downArrowButton.accessibilityHint=[NSString stringWithFormat:@"%ld",(long)indexPath.section ];
        cell.upArrowButton.accessibilityHint=[NSString stringWithFormat:@"%ld",(long)indexPath.section ];
        cell.activeButton.accessibilityHint=[NSString stringWithFormat:@"%ld",(long)indexPath.section ];
        cell.visibleButton.accessibilityHint=[NSString stringWithFormat:@"%ld",(long)indexPath.section ];
        cell.deleteButton.accessibilityHint=[NSString stringWithFormat:@"%ld",(long)indexPath.section ];
        
        cell.downArrowButton.tag=indexPath.row;
        cell.upArrowButton.tag=indexPath.row;
        cell.activeButton.tag=indexPath.row;
        cell.visibleButton.tag=indexPath.row;
        cell.deleteButton.tag=indexPath.row;
        if (indexPath.row==0) {
            cell.upArrowButton.hidden=true;
        }
        else{
            cell.upArrowButton.hidden=false;
            
        }
        
        if (indexPath.row==array.count-1) {
            cell.downArrowButton.hidden=true;
        }
        else{
            cell.downArrowButton.hidden=false;
        }
    }
    
    return cell;
}
#pragma Mark End


#pragma mark creation Delegate
//chayan 31/10/2017
- (void) creationCompleted{
    
    [self getUserHabitListApiCall];
    
}

#pragma mark End



@end












