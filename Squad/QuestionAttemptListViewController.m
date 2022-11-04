//
//  QuestionAttemptListViewController.m
//  Squad
//
//  Created by AQB Solutions Private Limited on 28/12/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "QuestionAttemptListViewController.h"
#import "ResultsTableViewCell.h"
#import "QuestionnaireHomeViewController.h"

@interface QuestionAttemptListViewController (){
    
    
    __weak IBOutlet UIButton *headerButton;
    
    __weak IBOutlet UITableView *listTable;
    
    UIView *contentView;
    int apiCount;
    NSArray *listArray;
    
}

@end

@implementation QuestionAttemptListViewController
@synthesize typeId;
#pragma mark-View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup_view];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getQuestionnaireAttemptList_Webservicecall];
}
#pragma mark-End

#pragma mark - IBAction
- (IBAction)backButtonPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)deleteButtonPressed:(UIButton *)sender{
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Alert!"
                                  message:@"Do you want to delete this result ?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self deleteAttempt_Webservicecall:(int)sender.tag];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"No"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 
                             }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - End

#pragma mark-Private Method
-(void)setup_view{
    
    if(typeId == COHENSTRESS){
        [headerButton setTitle:@"RESULTS: STRESS TEST" forState:UIControlStateNormal];
    }else if(typeId == RAHEPERCEIVED){
        [headerButton setTitle:@"RESULTS: RAHE PERCEIVED STRESS" forState:UIControlStateNormal];
    }else if(typeId == HAPPINESS){
        [headerButton setTitle:@"RESULTS: HAPINESS TEST" forState:UIControlStateNormal];
    }else{
        [headerButton setTitle:@"RESULTS" forState:UIControlStateNormal];
    }
    
}
#pragma mark-End

#pragma mark-Web Service Call
-(void)getQuestionnaireAttemptList_Webservicecall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:typeId] forKey:@"QuestionnaireTypeId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserQuestionnaireAttemptList" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         
                                                                         self->listArray = [responseDict objectForKey:@"Details"];
                                                                         [self->listTable reloadData];
//                                                                         if(self->listArray.count>0){
//                                                                             [self->listTable reloadData];
//                                                                         }
                                                                         
                                                                         
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

-(void)deleteAttempt_Webservicecall:(int)attemptId{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:attemptId] forKey:@"questionnaireAttemptId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteUserQuestionnaire" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         
                                                                         [self getQuestionnaireAttemptList_Webservicecall];
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
#pragma mark-End

#pragma mark - Table View Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *CellIdentifier =@"ResultsTableViewCell";
    ResultsTableViewCell *cell = (ResultsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[ResultsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = [listArray objectAtIndex:indexPath.section];
    
    
    if(![Utility isEmptyCheck:dict]){
        
        if(![Utility isEmptyCheck:dict[@"CreatedAt"]]){
            
            NSString *createdAt = dict[@"CreatedAt"];
            NSArray *dateArr = [createdAt componentsSeparatedByString:@"T"];
            createdAt = [dateArr objectAtIndex:0];
            
            NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
            [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *dailyDate = [dailyDateformatter dateFromString:createdAt];
            [dailyDateformatter setDateFormat:@"dd/MM/yyyy"];
            cell.dateLabel.text = [NSString stringWithFormat:@"%@",[dailyDateformatter stringFromDate:dailyDate]];
            
        }
        
        if(typeId == HAPPINESS){
            if(![Utility isEmptyCheck:dict[@"Total"]]){
                
                double totalMaxPoints = 120.0;
                double totalPoint  = [dict[@"Total"] doubleValue];
                cell.scoreLabel.text = [@"" stringByAppendingFormat:@"%.0f",(totalPoint/totalMaxPoints)*100];
            }
            
            
        }else if (typeId == COHENSTRESS){
            if(![Utility isEmptyCheck:dict[@"Total"]]){
                int total = [dict[@"Total"] intValue] * 4;
                cell.scoreLabel.text = [@"" stringByAppendingFormat:@"SCORE: %d",total];
            }
        }else{
            if(![Utility isEmptyCheck:dict[@"Total"]]){
                int total = [dict[@"Total"] intValue];
                cell.scoreLabel.text = [@"" stringByAppendingFormat:@"SCORE: %d",total];
            }
        }
        
        int attemptId = [dict[@"QuestionnaireAttemptId"] intValue];
        cell.deleteButton.tag = attemptId;
        
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *details = [listArray objectAtIndex:indexPath.section];
    
    if(typeId == COHENSTRESS){
        CSScaleViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CSScaleView"];
        controller.attemptDetailsDict = details;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(typeId == RAHEPERCEIVED){
        RPStressViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RPStressView"];
        controller.attemptDetailsDict = details;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(typeId == HAPPINESS){
        HQuestionnaireViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HQuestionnaireView"];
        controller.attemptDetailsDict = details;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

#pragma mark - End


@end
