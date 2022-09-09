//
//  HQuestionnaireViewController.m
//  Squad
//
//  Created by AQB Solutions Private Limited on 26/12/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "HQuestionnaireViewController.h"

@interface HQuestionnaireViewController (){
    
    IBOutletCollection(UIView) NSArray *questionViewArray;
    IBOutletCollection(UILabel) NSArray *answerLabelArray;
    
    __weak IBOutlet UILabel *scoreLabel;
    int attemptId;
    NSString *createdDate;
    NSString *updatedDate;
    NSMutableArray *scoresArray;
    UIView *contentView;
    int apiCount;
}

@end

@implementation HQuestionnaireViewController
@synthesize attemptDetailsDict;
#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    scoresArray = [NSMutableArray new];
    
    [self setup_view];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for(UIView *view in self->questionViewArray){
        view.hidden = false;
    }
    
}
#pragma mark - End

#pragma mark - IBAction

- (IBAction)backButtonPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)answerButtonPressed:(UIButton *)sender {
    
    if(sender.isSelected) return;
    
    NSString *accesssHint = sender.accessibilityHint;
    
    if(accesssHint.length > 0){
        NSArray *hints = [accesssHint componentsSeparatedByString:@"-"];
        if(hints.count>0){
            NSString *questionSection = [hints firstObject];
            NSString *qId=@"";
            if(questionSection.length>1){
                qId = [questionSection substringFromIndex:1];
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"QuestionnaireHappinessMasterId = %d",[qId intValue]];
            NSArray *arr = [scoresArray filteredArrayUsingPredicate:predicate];
            
            for(NSDictionary *dict in arr){
                [scoresArray removeObject:dict];
            }
            
            
            for(UILabel *lbl in answerLabelArray){
                
                if([lbl.accessibilityHint containsString:questionSection]){
                    
                    if([lbl.accessibilityHint isEqualToString:sender.accessibilityHint]){
                        
                        [self makeLabelSelected:lbl withQSection:questionSection];
                        
                    }else{
                        [lbl.superview setBackgroundColor:[UIColor whiteColor]];
                        [lbl setTextColor:[Utility colorWithHexString:@"32cdb8"]];
                        
                    }
                    
                }
                
            }
            
            [self calculateTotalScore];
        }
    }
    
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    if(![Utility isEmptyCheck:scoresArray] && scoresArray.count>9){
        [self AddUpdateQuestionnaire_Webservicecall];
    }else{
        [Utility msg:@"Please answer all the questions" title:@"Alert!" controller:self haveToPop:NO];
    }
    
}

#pragma mark - End

#pragma mark - Private Method
-(void)setup_view{
    NSLog(@"Total ANswer Options: %ld",answerLabelArray.count);
    
    if(![Utility isEmptyCheck:attemptDetailsDict]){
        
        if(![Utility isEmptyCheck:attemptDetailsDict[@"QuestionnaireAttemptId"]]){
            attemptId = [attemptDetailsDict[@"QuestionnaireAttemptId"] intValue];
            [self getQuestionnaireAttemptDetails_Webservicecall];
        }
        
        if(![Utility isEmptyCheck:attemptDetailsDict[@"CreatedAt"]]){
            createdDate = attemptDetailsDict[@"CreatedAt"];
        }
        
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZZ"];     //2017-03-06T10:38:18.7877+00:00
        updatedDate = [formatter stringFromDate:currentDate];
        
    }
}

-(void)makeLabelSelected:(UILabel *)lbl withQSection:(NSString *)questionSection{
    
    NSString *qId=@"";
    if(questionSection.length>1){
        qId = [questionSection substringFromIndex:1];
    }
    
    [lbl.superview setBackgroundColor:[Utility colorWithHexString:@"32cdb8"]];
    [lbl setTextColor:[UIColor whiteColor]];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    //[dict setObject:questionSection forKey:@"section"];
    [dict setObject:[NSNumber numberWithInteger:lbl.tag] forKey:@"Value"];
    [dict setObject:[NSNumber numberWithInt:[qId intValue]] forKey:@"QuestionnaireHappinessMasterId"];
    [dict setObject:[NSNumber numberWithInt:attemptId] forKey:@"QuestionnaireAttemptId"];
    [dict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
    
    
    [scoresArray addObject:dict];
    
}

-(void)populateAnswersFromResponse:(NSArray *)answerList{
    
    for(NSDictionary *dataDict in answerList){
        
        if(![Utility isEmptyCheck:dataDict[@"QuestionnaireHappinessMasterId"]]){
            NSString *qSection = [@"" stringByAppendingFormat:@"q%@",dataDict[@"QuestionnaireHappinessMasterId"]];
            
            int Value = [dataDict[@"Value"] intValue];
            
            for(UILabel *lbl in answerLabelArray){
                
                if([lbl.accessibilityHint containsString:qSection] && lbl.tag == Value){
                    [self makeLabelSelected:lbl withQSection:qSection];
                    break;
                }
            }
            
        }
    }
    
    [self calculateTotalScore];
    
}

-(void)calculateTotalScore{
    
    NSNumber* sum = [scoresArray valueForKeyPath: @"@sum.Value"];
    NSLog(@"Score of %ld questions is : %@",scoresArray.count,sum);
    
    double totalMaxPoints = 120.0;
    double totalPoint  = [sum doubleValue];
    
    NSLog(@"Score  is : %.0f%%",(totalPoint/totalMaxPoints)*100);
    
    scoreLabel.text = [@"" stringByAppendingFormat:@"%.0f",(totalPoint/totalMaxPoints)*100];//@"%.2f%%"
    
}
#pragma mark - End
#pragma mark-Web Service Call
-(void)AddUpdateQuestionnaire_Webservicecall{
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
        [mainDict setObject:scoresArray forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateUserQuestionnaireHappinessAnswerList" append:@""forAction:@"POST"];
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
                                                                         
                                                                         [Utility msg:@"Score saved successfully" title:@"" controller:self haveToPop:YES];
                                                                         
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

-(void)getQuestionnaireAttemptDetails_Webservicecall{
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserQuestionnaireAttemptDetails" append:@""forAction:@"POST"];
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
                                                                         
                                                                         NSDictionary *detailsDict = [responseDict objectForKey:@"Details"];
                                                                         
                                                                         
                                                                         if(![Utility isEmptyCheck:detailsDict]){
                                                                             if(![Utility isEmptyCheck:detailsDict[@"QuestionnaireHappinessAnswerList"]]){
                                                                                 
                                                                                 [self populateAnswersFromResponse:detailsDict[@"QuestionnaireHappinessAnswerList"]];
                                                                                 
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
#pragma mark - End

@end
