//
//  CSScaleViewController.m
//  Squad
//
//  Created by AQB Solutions Private Limited on 24/12/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "CSScaleViewController.h"

@interface CSScaleViewController (){
    
    
    IBOutletCollection(UIButton) NSArray *answerButtonsArray;
    
    __weak IBOutlet UILabel *scoreLabel;
    __weak IBOutlet UILabel *scaleDescLabel;
    NSMutableArray *scoresArray;
    int attemptId;
    NSString *createdDate;
    NSString *updatedDate;
    UIView *contentView;
    int apiCount;
}

@end

@implementation CSScaleViewController
@synthesize attemptDetailsDict;
#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    scoresArray = [NSMutableArray new];
    
    [self setup_view];
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
            
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"QuestionnaireCohenStressScaleMasterId = %d",[qId intValue]];
            NSArray *arr = [scoresArray filteredArrayUsingPredicate:predicate];
            
            /*for(NSDictionary *dict in arr){
             [scoresArray removeObject:dict];
             }*/
            
            if(arr.count>0){
                [scoresArray removeObjectsInArray:arr];
            }
            
            
            for(UIButton *btn in answerButtonsArray){
                
                if([btn.accessibilityHint containsString:questionSection]){
                    
                    if(btn == sender){
                        [self makeButtonSelected:btn withQSection:questionSection];
                        
                    }else{
                        btn.selected = NO;
                        [btn setBackgroundColor:[UIColor whiteColor]];
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
-(void)makeButtonSelected:(UIButton *)btn withQSection:(NSString *)questionSection{
    
    NSString *qId=@"";
    if(questionSection.length>1){
        qId = [questionSection substringFromIndex:1];
    }
    
    btn.selected = YES;
    [btn setBackgroundColor:[Utility colorWithHexString:@"32cdb8"]];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    //[dict setObject:questionSection forKey:@"section"];
    [dict setObject:[NSNumber numberWithInteger:btn.tag] forKey:@"Value"];
    [dict setObject:[NSNumber numberWithInt:[qId intValue]] forKey:@"QuestionnaireCohenStressScaleMasterId"];
    [dict setObject:[NSNumber numberWithInt:attemptId] forKey:@"QuestionnaireAttemptId"];
    [dict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
    
    
    [scoresArray addObject:dict];
    
}
-(void)setup_view{
    
    
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
    
    
    
    NSString *textStr = @"Perceived Stress Scale Scoring.";
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:textStr];
    
    
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Raleway-Bold" size:15.0],
                               NSForegroundColorAttributeName : [Utility colorWithHexString:@"58595B"],
                               NSParagraphStyleAttributeName:paragraphStyle
                               };
    [text addAttributes:attrDict range:NSMakeRange(0,text.length)];
    
    
    NSString *textStr1 = @"Your goal is to reduce your score over time.";
    
//    NSString *textStr1 = @"Your goal is to reduce your score over time\n\nCompare your score to the \"Average\" scores below. You may compare against people of your age or your gender. If you are more than six points above the \"average\" than you probably have a medium-high amount of stress, and if you are six points below than you are relatively stress free. If you are 12 points above the noted average score, than you likely are experiencing significantly high amounts of stress and may be endangering your health.";
    
    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:textStr1];
    
    NSDictionary *attrDict1 = @{
                                NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:15.0],
                                NSForegroundColorAttributeName : [Utility colorWithHexString:@"58595B"],
                                NSParagraphStyleAttributeName:paragraphStyle
                                };
    [text1 addAttributes:attrDict1 range:NSMakeRange(0,text1.length)];
    
    [text appendAttributedString:text1];
    
    scaleDescLabel.attributedText = text1;
}

-(void)calculateTotalScore{
    
    NSNumber* sum = [scoresArray valueForKeyPath: @"@sum.Value"];
    int b = [sum intValue];
    b = b * 4;
    sum = [NSNumber numberWithInt:b];
    
    NSLog(@"Score of %ld questions is : %@",scoresArray.count,sum);
    scoreLabel.text = [@"" stringByAppendingFormat:@"%@",sum];

}

-(void)populateAnswersFromResponse:(NSArray *)answerList{
    
    for(NSDictionary *dataDict in answerList){
        
        if(![Utility isEmptyCheck:dataDict[@"QuestionnaireCohenStressScaleMasterId"]]){
            NSString *qSection = [@"" stringByAppendingFormat:@"q%@",dataDict[@"QuestionnaireCohenStressScaleMasterId"]];
            
            int Value = [dataDict[@"Value"] intValue];
            
            for(UIButton *btn in answerButtonsArray){
                
                if([btn.accessibilityHint containsString:qSection] && btn.tag == Value){
                    [self makeButtonSelected:btn withQSection:qSection];
                    break;
                }
            }
            
        }
    }
    
    [self calculateTotalScore];
    
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateUserQuestionnaireCohenStressScaleAnswerList" append:@""forAction:@"POST"];
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
                                                                             if(![Utility isEmptyCheck:detailsDict[@"CohenStressScaleAnswerList"]]){
                                                                                 
                                                                                 [self populateAnswersFromResponse:detailsDict[@"CohenStressScaleAnswerList"]];
                                                                                 
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
