//
//  SavedNutritionPlanViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 25/06/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "SavedNutritionPlanViewController.h"
#import "SavedNutritionTableViewCell.h"

@interface SavedNutritionPlanViewController (){

    __weak IBOutlet UITableView *nutritionTable;
    __weak IBOutlet UILabel *noDataLabel;
    int apiCount;
    UIView *contentView;
    NSArray *savedPlanList;
    int rowNo;
    NSDateFormatter *dateFormatter;
    
    __weak IBOutlet UIView *nutritionView;
    __weak IBOutlet UITextField *nutritionNameTextField;
    __weak IBOutlet UITextView *descriptionTextView;
    UIToolbar *toolBar;
    NSNumber *mealId;
    BOOL isChanged;
    NSString *textWeek;
    int selectedTag;
    
    NSString *UserProgramIdStr;//Today_SetProgram_In
    NSString *ProgramIdStr;//Today_SetProgram_In
}

@end

@implementation SavedNutritionPlanViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nutritionTable.hidden = true;
    noDataLabel.hidden = true;
    NSString *msgStr = [@"" stringByAppendingFormat:@"Hi  %@\n\nTo save a meal plan go to MY PLAN, edit the weekly plan to be exactly how you want and then click 'SHOP LIST' and click 'SAVE MEAL PLAN'.",[[defaults objectForKey:@"FirstName"] uppercaseString]];
    self->noDataLabel.text = msgStr;
    isChanged = false;
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    nutritionTable.estimatedRowHeight = 58;
    nutritionTable.rowHeight = UITableViewAutomaticDimension;
    rowNo = -1;
    apiCount = 0;
    nutritionView.hidden = true;
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *keyBoardDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(keyBoardDoneButtonClicked:)];
    [toolBar setItems:[NSArray arrayWithObject:keyBoardDone]];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    nutritionNameTextField.leftView = paddingView;
    nutritionNameTextField.leftViewMode = UITextFieldViewModeAlways;
    nutritionNameTextField.layer.borderWidth = 1.0f;
    nutritionNameTextField.layer.borderColor =[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    descriptionTextView.layer.borderWidth = 1.0f;
    descriptionTextView.layer.borderColor =[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    
    [self registerForKeyboardNotifications];
    [self GetSquadUserSavedMealPlan];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
}
#pragma mark -IBAction

- (IBAction)keyBoardDoneButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
}
- (IBAction)showButtonPressed:(UIButton *)sender {
    int r = (int)sender.tag;
    if (rowNo == r) {
        rowNo = -1;
    }else{
        rowNo = r;
    }
    [nutritionTable reloadData];
}
- (IBAction)editButtonPressed:(UIButton *)sender {
    nutritionView.hidden = false;
    NSDictionary *dict = [savedPlanList objectAtIndex:sender.tag];
    mealId = ![Utility isEmptyCheck:dict[@"Id"]]?dict[@"Id"]:@0;
    nutritionNameTextField.text = ![Utility isEmptyCheck:dict[@"Name"]]?dict[@"Name"]:@"";
    descriptionTextView.text = ![Utility isEmptyCheck:dict[@"Description"]]?dict[@"Description"]:@"";
}
- (IBAction)deleteButtonPressed:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"By deleleting this meal plan you will lose track of all the weeks you had used this meal plan for. Are you sure you want to delete this saved plan ?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSDictionary *dict = self->savedPlanList[sender.tag];
                                                              NSNumber *mealId = dict[@"Id"];
                                                              [self deleteSavedMealPlan:mealId];
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                          }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)currentWeekPressed:(UIButton *)sender {
    textWeek = @"this";
    selectedTag = (int)sender.tag;
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:currentDate];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:currentDate options:0];
    
    NSDictionary *dict = [savedPlanList objectAtIndex:sender.tag];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [self SwapSquadUserSavedMealPlanEntry:dict[@"Id"] weekDate:[dateFormatter stringFromDate:beginningOfWeek] week:@"this"];
//    [self getSquadMealPlanWithSettings:beginningOfWeek];
}
- (IBAction)nextWeekPressed:(UIButton *)sender {
    textWeek = @"next";
    selectedTag = (int)sender.tag;
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:currentDate];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:currentDate options:0];
    
    NSTimeInterval interval = 7*24*60*60;
    NSDate *nextWeek = [beginningOfWeek dateByAddingTimeInterval:interval];
    
    NSDictionary *dict = [savedPlanList objectAtIndex:sender.tag];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [self SwapSquadUserSavedMealPlanEntry:dict[@"Id"] weekDate:[dateFormatter stringFromDate:nextWeek] week:@"next"];
//    [self getSquadMealPlanWithSettings:nextWeek];
}
- (IBAction)savePressed:(UIButton *)sender {
    if (nutritionNameTextField.text.length <= 0) {
        [Utility msg:@"Please enter Name." title:@"" controller:self haveToPop:NO];
        return;
    }
    if (descriptionTextView.text.length <= 0) {
        [Utility msg:@"Please enter Description." title:@"" controller:self haveToPop:NO];
        return;
    }
    [self.view endEditing:YES];
    [self updateSavedMealPlan:mealId name:nutritionNameTextField.text desc:descriptionTextView.text];
}
- (IBAction)cancelPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    nutritionView.hidden = true;
}

#pragma mark -End
#pragma mark -Private Method
-(void)checkForChange:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"backButtonPressed"]) {
        [delegate didCheckAnyChangeForSavedNutrition:isChanged];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)GetSquadUserSavedMealPlan{
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadUserSavedMealPlan" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->nutritionView.hidden = true;
                                                                         if (![Utility isEmptyCheck:responseDict[@"SquadUserSavedMealPlanList"]] ) {
                                                                             self->savedPlanList = responseDict[@"SquadUserSavedMealPlanList"];
                                                                         } else {
                                                                             self->savedPlanList = [NSArray new];
                                                                         }
                                                                         if (self->savedPlanList.count>0) {
                                                                             self->nutritionTable.hidden = false;
                                                                             self->noDataLabel.hidden = true;
                                                                             [self->nutritionTable reloadData];
                                                                         } else {
                                                                             self->nutritionTable.hidden = true;
                                                                             self->noDataLabel.hidden = false;
//                                                                             UIAlertController *alertController = [UIAlertController
//                                                                                                                   alertControllerWithTitle:@""
//                                                                                                                   message:msgStr
//                                                                                                                   preferredStyle:UIAlertControllerStyleAlert];
//                                                                             UIAlertAction *okAction = [UIAlertAction
//                                                                                                        actionWithTitle:@"Ok"
//                                                                                                        style:UIAlertActionStyleDefault
//                                                                                                        handler:^(UIAlertAction *action)
//                                                                                                        {
//                                                                                                            [self.navigationController popViewControllerAnimated:YES];
//                                                                                                        }];
//                                                                             
//                                                                             [alertController addAction:okAction];
//
//                                                                             [self presentViewController:alertController animated:YES completion:nil];
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
-(void)updateSavedMealPlan:(NSNumber *)mealId name:(NSString *)name desc:(NSString *)desc{
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealId forKey:@"SavedMealPlanId"];
        [mainDict setObject:name forKey:@"Name"];
        [mainDict setObject:desc forKey:@"Description"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateSavedMealPlan" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->isChanged = true;
                                                                         [self GetSquadUserSavedMealPlan];
                                                                         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                                                                                        message:@"Successfully saved"
                                                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                                                         
                                                                         UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                                            style:UIAlertActionStyleDefault
                                                                                                                          handler:^(UIAlertAction * action) {
                                                                                                                              
                                                                                                                          }];
                                                                         
                                                                         [alert addAction:okAction];
                                                                         
                                                                         [self presentViewController:alert animated:YES completion:nil];
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
-(void)deleteSavedMealPlan:(NSNumber *)mealId{
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealId forKey:@"SavedMealPlanId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteSavedMealPlan" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->isChanged = true;
                                                                         [self GetSquadUserSavedMealPlan];
                                                                         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                                                                                        message:@"Successfully deleted"
                                                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                                                         
                                                                         UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                                            style:UIAlertActionStyleDefault
                                                                                                                          handler:^(UIAlertAction * action) {
                                                                                                                              
                                                                                                                          }];
                                                                         
                                                                         [alert addAction:okAction];
                                                                         
                                                                         [self presentViewController:alert animated:YES completion:nil];
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
-(void)SwapSquadUserSavedMealPlanEntry:(NSNumber *)mealPlanId weekDate:(NSString *)weekDate week:(NSString *)week{
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealPlanId forKey:@"SavedMealPlanId"];
        [mainDict setObject:weekDate forKey:@"WeekDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SwapSquadUserSavedMealPlanEntry" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->isChanged = true;
                                                                         NSString *txt = [NSString stringWithFormat:@"This meal plan applied successfully for %@ week",week];
                                                                         UIAlertController *alertController = [UIAlertController
                                                                                                               alertControllerWithTitle:@""
                                                                                                               message:txt
                                                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                                         UIAlertAction *okAction = [UIAlertAction
                                                                                                    actionWithTitle:@"Ok"
                                                                                                    style:UIAlertActionStyleDefault
                                                                                                    handler:^(UIAlertAction *action)
                                                                                                    {
                                                                                                        NSDate *pDate = [self->dateFormatter dateFromString:weekDate];
//                                                                                                        [self->dateFormatter setDateFormat:@"yyyy-MM-dd"];
//                                                                                                        NSString *strDate = [self->dateFormatter stringFromDate:pDate];
                                                                                                        CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
                                                                                                        controller.weekDate =pDate;
                                                                                                        [self.navigationController pushViewController:controller animated:YES];
                                                                                                    }];
                                                                         [alertController addAction:okAction];
                                                                         [self presentViewController:alertController animated:YES completion:nil];
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

-(void)getSquadMealPlanWithSettings:(NSDate *)weekDate{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (weekDate) {
            NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
            [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
            [mainDict setObject:[dailyDateformatter stringFromDate:weekDate ] forKey:@"WeekDate"];
            [mainDict setObject:[dailyDateformatter stringFromDate:weekDate ] forKey:@"UserSessionStartSessionDate"];
            NSDate *nxtDate = [weekDate dateByAddingTimeInterval:6*24*60*60];
            [mainDict setObject:[dailyDateformatter stringFromDate:nxtDate ] forKey:@"UserSessionEndSessionDate"];
            
        }
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadMealPlanWithSettingsApiCall" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:responseDict[@"WeekStartDate"] ]) {
                                                                             NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
                                                                             [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
                                                                             NSDate *date = [dailyDateformatter dateFromString:responseDict[@"WeekStartDate"]];
                                                                             if (date) {
                                                                                 
                                                                                 //SetProgram_In
                                                                                 if (![Utility isEmptyCheck:responseDict[@"MealPlanResponse"]]) {
                                                                                     NSDictionary *dict = responseDict[@"MealPlanResponse"];
//                                                                                     if (![Utility isEmptyCheck:[dict objectForKey:@"ProgramName"]]) {
//                                                                                         self->programName = [dict objectForKey:@"ProgramName"];
//                                                                                     }else{
//                                                                                         self->programName = @"";
//                                                                                     }
//                                                                                     if (![Utility isEmptyCheck:[dict objectForKey:@"WeekNumber"]]) {
//                                                                                         self->weekNumber = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"WeekNumber"]];
//                                                                                     }else{
//                                                                                         self->weekNumber =@"";
//                                                                                     }
                                                                                     //Today_SetProgram_In
                                                                                     if (![Utility isEmptyCheck:[dict objectForKey:@"UserProgramId"]]) {
                                                                                         self->UserProgramIdStr = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"UserProgramId"]];
                                                                                     }else{
                                                                                         self->UserProgramIdStr = @"";
                                                                                     }
                                                                                     if (![Utility isEmptyCheck:[dict objectForKey:@"ProgramId"]]) {
                                                                                         self->ProgramIdStr = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ProgramId"]];
                                                                                     }else{
                                                                                         self->ProgramIdStr = @"";
                                                                                     }
//                                                                                     if.
                                                                                     if (![Utility isEmptyCheck:self->ProgramIdStr] && ![Utility isEmptyCheck:self->UserProgramIdStr] && ![Utility isEmptyCheck:weekDate]) {
                                                                                         ResetProgramViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ResetProgramView"];
                                                                                         
                                                                                         NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                                                                         [dateFormat setDateFormat:@"yyyy-MM-dd"];//@"yyyy-MM-dd'T'HH:mm:ss"
                                                                                         NSString *weekStartStr = [dateFormat stringFromDate:weekDate];
                                                                                         controller.weekStartDayStr = weekStartStr;
                                                                                         
                                                                                         controller.programIdStr = self->ProgramIdStr;
                                                                                         controller.userprogramIdStr = self->UserProgramIdStr;
                                                                                         controller.option = @"CancelNutrition";
                                                                                         controller.modalPresentationStyle = UIModalPresentationCustom;
                                                                                         controller.delegate = self;
                                                                                         [self presentViewController:controller animated:YES completion:nil];
                                                                                     }
                                                                                 }
                                                                             }
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
 

#pragma mark -End
#pragma mark -TableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return savedPlanList.count;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SavedNutritionTableViewCell *cell = (SavedNutritionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SavedNutritionTableViewCell"];
    NSDictionary *dict = savedPlanList[indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        NSString *strDate = ![Utility isEmptyCheck:dict[@"WeekStartDate"]]?dict[@"WeekStartDate"]:@"";
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *myDate = [dateFormatter dateFromString:strDate];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        strDate = [dateFormatter stringFromDate:myDate];
        cell.nameLabel.text = ![Utility isEmptyCheck:dict[@"Name"]]?dict[@"Name"]:@"";
        cell.dateLabel.text = ![Utility isEmptyCheck:strDate]?strDate:@"";
        [cell.arrowButton setImage:[UIImage imageNamed:@"new_gray_arrow.png"] forState:UIControlStateNormal];
        cell.weekView.hidden = true;
        if (rowNo == indexPath.row) {
            [cell.arrowButton setImage:[UIImage imageNamed:@"new_gray_arrow_up.png"] forState:UIControlStateNormal];
            cell.weekView.hidden = false;
        }
        
        cell.currentWeek.layer.masksToBounds = YES;
        cell.currentWeek.layer.cornerRadius = 8.0;
       
        cell.nextWeek.layer.masksToBounds = YES;
        cell.nextWeek.layer.cornerRadius = 8.0;
        
        cell.applyShowButton.tag = indexPath.row;
        cell.editButton.tag = indexPath.row;
        cell.deleteButton.tag = indexPath.row;
        cell.currentWeek.tag = indexPath.row;
        cell.nextWeek.tag = indexPath.row;
    }
    
    return cell;
}

#pragma mark -End
#pragma mark - TextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [textView setInputAccessoryView:toolBar];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [textView resignFirstResponder];
    
}
#pragma mark - End
#pragma mark - ResetViewControllerDelegate

-(void)didPerformRevertOption{
    NSDate *currentDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:currentDate];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    NSDate *firstWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:currentDate options:0];
    
    NSTimeInterval interval = 7*24*60*60;
    NSDate *nextWeek = [firstWeek dateByAddingTimeInterval:interval];
    
    NSDictionary *dict = [savedPlanList objectAtIndex:selectedTag];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    if ([textWeek caseInsensitiveCompare:@"this"] == NSOrderedSame) {
        [self SwapSquadUserSavedMealPlanEntry:dict[@"Id"] weekDate:[dateFormatter stringFromDate:firstWeek] week:textWeek];
    } else if([textWeek caseInsensitiveCompare:@"next"] == NSOrderedSame) {
        [self SwapSquadUserSavedMealPlanEntry:dict[@"Id"] weekDate:[dateFormatter stringFromDate:nextWeek] week:textWeek];
    }
}
#pragma mark - End
#pragma mark - KeyboardNotifications -
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.



- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSInteger orientation=[UIDevice currentDevice].orientation;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        //ios7
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            kbSize=CGSizeMake(kbSize.height, kbSize.width);
        }else if (UIDeviceOrientationIsPortrait(orientation)){
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }
    }
    else {
        //iOS 8 specific code here
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }else if (UIDeviceOrientationIsPortrait(orientation)){
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }
    }
    
    //    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    //    mainScroll.contentInset = contentInsets;
    //    mainScroll.scrollIndicatorInsets = contentInsets;
    //
    //    if (activeTextField !=nil) {
    //        CGRect aRect = mainScroll.frame;
    //        CGRect frame = [mainScroll convertRect:activeTextField.frame fromView:activeTextField.superview];
    //        aRect.size.height -= kbSize.height;
    //        CGPoint tempPoint = CGPointMake(frame.origin.x, frame.origin.y+frame.size.height);
    //        if (!CGRectContainsPoint(aRect,tempPoint) ) {
    //            [mainScroll scrollRectToVisible:frame animated:YES];
    //        }
    //    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    //    mainScroll.contentInset = contentInsets;
    //    mainScroll.scrollIndicatorInsets = contentInsets;
    
}
#pragma mark - End
#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField endEditing:YES];
}

#pragma mark - End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
