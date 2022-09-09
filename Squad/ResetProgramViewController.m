//
//  ResetProgramViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 03/05/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "ResetProgramViewController.h"

@interface ResetProgramViewController ()
{
    IBOutlet UIButton *commomCurrentDateButton;
    IBOutlet UIButton *commonNextDateButton;
    IBOutlet UILabel *commonCancelHeaderLabel;
    IBOutlet UILabel *commonCancelDetailsLabel;
    IBOutlet UIStackView *commonStack;
    UIView *contentView;
    NSString *cancelCurrentDateStr;
    NSString *cancelNextDateStr;
}
@end

@implementation ResetProgramViewController
@synthesize programIdStr,userprogramIdStr,weekStartDayStr,option,delegate;
#pragma mark - View Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self webSerViceCall_GetDatesForResetExerciseNutritionPlan:option];
}
#pragma mark - End

#pragma mark  - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - End

#pragma mark - IBAction
-(IBAction)crossButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:^{
//        if ([delegate respondsToSelector:@selector(didCancelDropdownOption)]) {
//            [delegate didCancelRevertOption];
//        }
//    }];
}

-(IBAction)resetExerciseNutritionPlan:(UIButton*)sender{
        NSString *fromdate=@"";
        NSString *fromWhere=@"";
        if ([commonCancelHeaderLabel.text isEqualToString:@"Cancel Exercise"]) {
            fromWhere =@"ResetExercise";
        }else{
            fromWhere = @"ResetNutrition";
        }
        if ([sender isEqual:commomCurrentDateButton]) {
            fromdate = cancelCurrentDateStr;
        }else{
            fromdate = cancelNextDateStr;
        }
        if (![Utility isEmptyCheck:fromWhere] && ![Utility isEmptyCheck:fromdate]) {
            [self webSerViceCall_ResetPlan:fromWhere with:fromdate];
        }
}
#pragma mark  -End

#pragma mark - WebService Call
-(void)webSerViceCall_GetDatesForResetExerciseNutritionPlan:(NSString*)option{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:programIdStr forKey:@"ProgramId"];
        [mainDict setObject:userprogramIdStr forKey:@"UserProgramId"];
        [mainDict setObject:weekStartDayStr forKey:@"WeekStartDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSString *exerciseNutritionStr;
        if ([option isEqualToString:@"CancelExercise"]) {
            exerciseNutritionStr = @"GetDatesForResetExercisePlan";
        }else{
            exerciseNutritionStr = @"GetDatesForResetNutritionPlan";
        }
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:exerciseNutritionStr append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"%@",responseString);
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                        
                                                                         
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"CurrentWeekDate"]] ) {
                                                                             [commonStack insertArrangedSubview:commomCurrentDateButton atIndex:0];
                                                                             cancelCurrentDateStr =[responseDict objectForKey:@"CurrentWeekDate"];
                                                                             NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                                                             [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                                                                             NSDate *startDate = [dateFormat dateFromString:[responseDict objectForKey:@"CurrentWeekDate"]];
                                                                             [dateFormat setDateFormat:@"dd MMM YYYY"];
                                                                             NSString *date = [dateFormat stringFromDate:startDate];
                                                                             [commomCurrentDateButton setTitle:date forState:UIControlStateNormal];
                                                                         }else{
                                                                             [commomCurrentDateButton setTitle:@"" forState:UIControlStateNormal];
                                                                             [commonStack removeArrangedSubview:commomCurrentDateButton];
                                                                             [commomCurrentDateButton removeFromSuperview];
                                                                         }
                                                                         
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"NextWeekDate"]]) {
                                                                             [commonStack insertArrangedSubview:commonNextDateButton atIndex:1];
                                                                             cancelNextDateStr = [responseDict objectForKey:@"NextWeekDate"];
                                                                             NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                                                             [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                                                                             NSDate *nextWeekDate = [dateFormat dateFromString:[responseDict objectForKey:@"NextWeekDate"]];
                                                                             [dateFormat setDateFormat:@"dd MMM YYYY"];
                                                                             NSString *date = [dateFormat stringFromDate:nextWeekDate];
                                                                             [commonNextDateButton setTitle:date forState:UIControlStateNormal];
                                                                         }else{
                                                                             [commonNextDateButton setTitle:@"" forState:UIControlStateNormal];
                                                                             [commonStack removeArrangedSubview:commonNextDateButton];
                                                                             [commonNextDateButton removeFromSuperview];
                                                                         }
                                                                         
                                                                         if ([option isEqualToString:@"CancelExercise"]) {
                                                                             commonCancelHeaderLabel.text = @"Cancel Exercise";
                                                                         }else{
                                                                             commonCancelHeaderLabel.text = @"Cancel Nutrition";
                                                                         }
                                                                         
//                                                                         if (![Utility isEmptyCheck:commomCurrentDateButton.titleLabel.text] && ![Utility isEmptyCheck:commonNextDateButton.titleLabel.text] ) {
//                                                                             commonCancelDetailsLabel.text = [@"" stringByAppendingFormat:@"Do you want the new plan effective from this week monday (%@) or next week monday (%@)",commomCurrentDateButton.titleLabel.text,commonNextDateButton.titleLabel.text];
//                                                                         }else if(![Utility isEmptyCheck:commomCurrentDateButton.titleLabel.text]){
//                                                                              commonCancelDetailsLabel.text = [@"" stringByAppendingFormat:@"Do you want the new plan effective from this week monday (%@)",commomCurrentDateButton.titleLabel.text];
//                                                                         }else if(![Utility isEmptyCheck:commonNextDateButton.titleLabel.text]){
//                                                                              commonCancelDetailsLabel.text = [@"" stringByAppendingFormat:@"Do you want the new plan effective from next week monday (%@)",commonNextDateButton.titleLabel.text];
//                                                                         }
                                                                         
                                                                         if (![Utility isEmptyCheck:commomCurrentDateButton.titleLabel.text] ||![Utility isEmptyCheck:commonNextDateButton.titleLabel.text] ) {
                                                                            if ([option isEqualToString:@"CancelExercise"]) {
                                                                                commonCancelDetailsLabel.text = @"Are you sure, you want to revert to your custom exercise plan from";

                                                                            }else{
                                                                                commonCancelDetailsLabel.text = @"Are you sure, you want to revert to your custom nutrition plan from";

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
-(void)webSerViceCall_ResetPlan:(NSString*)option with:(NSString*)dateStr{  //Add_new
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:programIdStr forKey:@"ProgramId"];
        [mainDict setObject:userprogramIdStr forKey:@"UserProgramId"];
        [mainDict setObject:dateStr forKey:@"fromDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSString *exerciseNutritionStr;
        if ([option isEqualToString:@"ResetExercise"]) {
            exerciseNutritionStr = @"ResetExercisePlan";
        }else{
            exerciseNutritionStr = @"ResetNutritionPlan";
        }
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:exerciseNutritionStr append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"%@",responseString);
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self dismissViewControllerAnimated:YES completion:^{
                                                                             if ([delegate respondsToSelector:@selector(didPerformRevertOption)]) {
                                                                                 [delegate didPerformRevertOption];
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
#pragma mark  -End
@end
