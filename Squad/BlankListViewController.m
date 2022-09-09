//
//  BlankListViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 03/05/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "BlankListViewController.h"
#import "BlankListTableViewCell.h"
#import "AddEditBlankListViewController.h"


@interface BlankListViewController (){
    IBOutlet UITableView *blankListTable;
    IBOutlet UILabel *blankMsgLabel;
    IBOutlet UIButton *dropDownButton;

    NSArray *blankListArray;
    UIView *contentView;
    int apiCount;
    NSDictionary *selectedType;

}

@end

@implementation BlankListViewController


#pragma marl -Private Method
-(void)deleteBlankListApiCall:(NSNumber *)blankId{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:blankId forKey:@"CheckListId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteSquadCheckListApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 apiCount--;
                                                                 if (apiCount == 0 && contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else {
                                                                             [Utility msg:@"Check List deleted Successfully." title:@"Success" controller:self haveToPop:NO];
                                                                             
                                                                             [self getBlankListApiCall];

                                                                             
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
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
-(void)getBlankListApiCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            [dropDownButton setTitle:[selectedType objectForKey:@"value"] forState:UIControlStateNormal];
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        if (![Utility isEmptyCheck:selectedType]) {
            [mainDict setObject:selectedType[@"key"] forKey:@"ChecklistPref"];
        }
        [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"ChangeFlagValue"];

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetCheckListApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 apiCount--;
                                                                 if (apiCount == 0 && contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                             //[Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else {
                                                                             blankListArray = [responseDictionary objectForKey:@"CheckList"];
                                                                             if (blankListArray.count >0) {
                                                                                 blankListTable.hidden = false;
                                                                                 blankMsgLabel.hidden = true;
                                                                             }else{
                                                                                 blankListTable.hidden = true;
                                                                                 blankMsgLabel.hidden = false;
                                                                             }
                                                                             [blankListTable reloadData];
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
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

-(void)getUserflagValueApiCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[NSNumber numberWithInt:3] forKey:@"FlagId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserflagValueApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 apiCount--;
                                                                 if (apiCount == 0 && contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if ([[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                             if (![Utility isEmptyCheck:responseDictionary[@"FlagNumber"]]) {
                                                                                 selectedType =[Utility getDictByValue:blankTypeArray value:responseDictionary[@"FlagNumber"] type:@"key"];
                                                                             }
                                                                            
                                                                         }
                                                                     }
                                                                 }
                                                                 [dropDownButton setTitle:[selectedType objectForKey:@"value"] forState:UIControlStateNormal];
                                                                 [self getBlankListApiCall];
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
#pragma mark -End


#pragma mark -IBAction
- (IBAction)dropdownType:(id)sender {
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = blankTypeArray;
    controller.mainKey = @"value";
    controller.apiType = @"Type";
    if (![Utility isEmptyCheck:selectedType]) {
        controller.selectedIndex = (int)[blankTypeArray indexOfObject:selectedType];
    }else{
        controller.selectedIndex = -1;
    }
    controller.delegate = self;
    controller.sender = sender;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
-(IBAction)logoTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)doneButtonPressed:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSDictionary *dict = blankListArray[sender.tag];
    if (![Utility isEmptyCheck:dict]) {
        if (Utility.reachable) {
            dispatch_async(dispatch_get_main_queue(),^ {
                apiCount++;
                if (contentView) {
                    [contentView removeFromSuperview];
                }
                contentView = [Utility activityIndicatorView:self];
            });
            NSURLSession *dailySession = [NSURLSession sharedSession];
            NSError *error;
            
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            [mainDict setObject:AccessKey forKey:@"Key"];
            [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
            [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
            [mainDict setObject:dict[@"Id"] forKey:@"CheckListId"];
            [mainDict setObject:[NSNumber numberWithBool:sender.selected] forKey:@"CheckedValue"];

            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ChangeChecklistFlagApiCall" append:@"" forAction:@"POST"];
            NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 dispatch_async(dispatch_get_main_queue(),^ {
                                                                     apiCount--;
                                                                     if (apiCount == 0 && contentView) {
                                                                         [contentView removeFromSuperview];
                                                                     }
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         
                                                                         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                             if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                                 [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                             } else {
                                                                                 
                                                                                 [self getBlankListApiCall];
                                                                                 
                                                                             }
                                                                         }else{
                                                                             [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
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
    }else{
        [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
}
-(IBAction)editButtonPressed:(UIButton *)sender{
    NSDictionary *dict = blankListArray[sender.tag];
    if (![Utility isEmptyCheck:dict]) {
        AddEditBlankListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddEditBlankList"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.delegate=self;
        controller.blankData=dict;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
}
-(IBAction)addButtonPressed:(UIButton *)sender{
    AddEditBlankListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddEditBlankList"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.delegate=self;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)deleteButtonPressed:(UIButton *)sender{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Delete confirmation"
                                  message:@"Are you sure you want to delete the uploaded file?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Confirm"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             NSDictionary *dict = blankListArray[sender.tag];
                             if (![Utility isEmptyCheck:dict]) {
                                 [self deleteBlankListApiCall:dict[@"Id"]];
                             }else{
                                 [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                                 return;
                             }
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"No"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"Resolving UIAlertActionController for tapping cancel button");
                                 
                             }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark -End
#pragma mark -View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    selectedType = blankTypeArray[0];
    blankListTable.estimatedRowHeight=105;
    blankListTable.rowHeight = UITableViewAutomaticDimension;
    [dropDownButton setTitle:[selectedType objectForKey:@"value"] forState:UIControlStateNormal];
}
#pragma mark -End
-(void)viewWillAppear:(BOOL)animated{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getUserflagValueApiCall];
    });
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return blankListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"BlankListTableViewCell";
    BlankListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BlankListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.containerView.layer.masksToBounds = NO;
    cell.containerView.layer.shadowColor = [Utility colorWithHexString:@"#2e312d"].CGColor;
    cell.containerView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    cell.containerView.layer.shadowOpacity = 0.4f;
    cell.containerView.layer.shadowRadius = 5;
    cell.containerView.layer.cornerRadius = 3;
    

    
    cell.editButton.tag = indexPath.row;
    cell.deleteButton.tag = indexPath.row;
    cell.doneButton.tag = indexPath.row;
    NSDictionary *dict = blankListArray[indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *date = [formatter dateFromString:dict[@"Date"]];
        if (date) {
            [formatter setDateFormat:@"dd-MMM-yyyy"];
            cell.todoDate.text = [formatter stringFromDate:date];

        }
        cell.todoDescription.text = ![Utility isEmptyCheck:dict[@"Description"]]? dict[@"Description"]:@"";
        if (cell.todoDescription.text.length == 0) {
            cell.todoDescription.hidden = true;
        }else{
            cell.todoDescription.hidden = false;
        }
        cell.doneButton.selected = ![Utility isEmptyCheck:dict[@"isDone"]]?[dict[@"isDone"] boolValue]: false;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = blankListArray[indexPath.row];
    if (![Utility isEmptyCheck:dict]) {}
}
#pragma mark -End

#pragma mark -DropdownViewDelegate
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData sender:(UIButton *)sender{
    if ([type caseInsensitiveCompare:@"Type"] == NSOrderedSame) {
        [sender setTitle:[selectedData objectForKey:@"value"] forState:UIControlStateNormal];
        selectedType = selectedData;
        [self getBlankListApiCall];
    }
}
#pragma mark -End

#pragma mark -AddEditBlankListViewControllerDelegate
-(void)didDismiss{
    [self getBlankListApiCall];
}
#pragma mark -End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
