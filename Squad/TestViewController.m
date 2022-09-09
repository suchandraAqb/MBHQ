//
//  TestViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 10/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "TestViewController.h"
#import "SessionListTableViewCell.h"
#import "ExerciseDetailsViewController.h"
@interface TestViewController (){
    IBOutlet UIButton *mySessionButton;
    IBOutlet UIButton *sessionListButton;
    
    IBOutlet UITableView *table;
    IBOutlet UIImageView *buttonBg;
    IBOutlet UITextField *searchTextField;
    NSArray *sessionListArray;
    UIView *contentView;
    NSMutableDictionary *defaultFilterDictionary;
}

@end
@interface TestViewController ()

@end

@implementation TestViewController

#pragma -mark APICall
-(void)advanceSearch:(NSDictionary *)dict{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:dict];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SearchExerciseSessionsApiCall" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
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
                                                                         sessionListArray = [responseDict objectForKey:@"Sessions"];
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
#pragma -mark End

#pragma -mark IBAction
-(IBAction)AdvanceSearchButtonPressed:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        AdvanceSearchForSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AdvanceSearchForSessionViewController"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    });
    
}

-(IBAction)sessionOrMysessionListButtonPressed:(UIButton *)sender{
    if (sender == sessionListButton) {
        sessionListButton.selected = true;
        mySessionButton.selected = false;
        buttonBg.image = [UIImage imageNamed:@"sq_tab_bar.png"];
        [defaultFilterDictionary removeObjectForKey:@"Category"];
        
    }else{
        mySessionButton.selected = true;
        sessionListButton.selected = false;
        buttonBg.image = [UIImage imageNamed:@"sq_tab_bar_flip.png"];
        [defaultFilterDictionary setObject:[NSNumber numberWithInt:4] forKey:@"Category"];
        
    }
    [self advanceSearch:defaultFilterDictionary];
    
}
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma -mark End

#pragma -mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    sessionListButton.selected = true;
    mySessionButton.selected=false;
    buttonBg.image = [UIImage imageNamed:@"sq_tab_bar.png"];
    defaultFilterDictionary = [[NSMutableDictionary alloc]init];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Core"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Fullbody"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Upperbody"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Lowerbody"];
    [defaultFilterDictionary removeObjectForKey:@"Category"];
    
    [self advanceSearch:defaultFilterDictionary];
}
#pragma -mark End

#pragma mark - TableView Datasource & Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sessionListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"SessionListTableViewCell";
    SessionListTableViewCell *cell = (SessionListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[SessionListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = [sessionListArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        cell.sessionName.text= ![Utility isEmptyCheck:[dict objectForKey:@"SessionTitle"]] ? [dict objectForKey:@"SessionTitle"]:@"";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",[sessionListArray objectAtIndex:indexPath.row]);
    NSDictionary *sessionDictionary = [sessionListArray objectAtIndex:indexPath.row];
    ExerciseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDetails"];
    controller.exSessionId = [[sessionDictionary objectForKey:@"ExerciseSessionId"] intValue];
    controller.sessionDate = @"";  //ah 2.2
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma -mark End
#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == searchTextField) {
        [textField resignFirstResponder];
        NSString *searchString = textField.text;
        textField.text = @"";
        [defaultFilterDictionary setObject:searchString forKey:@"SessionName"];
        [self advanceSearch:defaultFilterDictionary];
        
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
#pragma -mark End
#pragma -mark Advance Search Delegate
- (void) applyForSesionFilter:(NSDictionary *)data{
    NSLog(@"------------%@",data);
    [self advanceSearch:data];
}
#pragma -mark End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
