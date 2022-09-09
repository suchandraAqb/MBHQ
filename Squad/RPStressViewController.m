//
//  RPStressViewController.m
//  Squad
//
//  Created by AQB Solutions Private Limited on 26/12/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "RPStressViewController.h"

@interface RPStressViewController (){
    
    
    IBOutletCollection(UITextField) NSArray *answerTextFieldArray;
    IBOutlet UILabel *scoreInterPretationLabel;
    __weak IBOutlet UILabel *scoreLabel;
     __weak IBOutlet UIScrollView *mainScroll;
    UITextField *activeTextField;
    UIToolbar *toolBar;
    UIView *contentView;
    int attemptId;
    NSString *createdDate;
    NSString *updatedDate;
    int apiCount;
    
    NSMutableArray *scoresArray;
}

@end

@implementation RPStressViewController
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




- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    if(![Utility isEmptyCheck:scoresArray]){ //&& scoresArray.count>40
        [self AddUpdateQuestionnaire_Webservicecall];
    }else{
        [Utility msg:@"Please answer all the questions" title:@"Alert!" controller:self haveToPop:NO];
    }
    
}

#pragma mark - End

#pragma mark - Private Method

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
    
    for(UITextField *textField in answerTextFieldArray){
        textField.placeholder = @"0";
        textField.text = @"";
    }
    [self populateScoreInterpretation];
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [self registerForKeyboardNotifications];
}

-(void)updateScore:(UITextField *)sender{
    
    
    NSString *questionSection = sender.accessibilityHint;
    
    NSString *qId=@"";
    if(questionSection.length>1){
        qId = [questionSection substringFromIndex:1];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"QuestionnaireRahePerceivedStressMasterId = %d",[qId intValue]];
    NSArray *arr = [scoresArray filteredArrayUsingPredicate:predicate];
            
    /*for(NSDictionary *dict in arr){
        [scoresArray removeObject:dict];
    }*/
    
    if(arr.count>0){
        [scoresArray removeObjectsInArray:arr];
    }
            
            
    for(UITextField *field in answerTextFieldArray){
        
        if([field.accessibilityHint containsString:questionSection]){
            
            if(field == sender){
                [self makeTextFieldUpdated:field withQSection:questionSection];
            }
            
        }
        
    }
            
    [self calculateTotalScore];
        
    
}

-(void)makeTextFieldUpdated:(UITextField *)field withQSection:(NSString *)questionSection{
    
    NSString *qId=@"";
    if(questionSection.length>1){
        qId = [questionSection substringFromIndex:1];
    }
    
    NSInteger fieldTag = field.tag;
    int fieldValue = [field.text intValue];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    //[dict setObject:questionSection forKey:@"section"];
    [dict setObject:[NSNumber numberWithInteger:fieldTag*fieldValue] forKey:@"Value"];
    [dict setObject:[NSNumber numberWithInt:[qId intValue]] forKey:@"QuestionnaireRahePerceivedStressMasterId"];
    [dict setObject:[NSNumber numberWithInt:attemptId] forKey:@"QuestionnaireAttemptId"];
    [dict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
    
    
    [scoresArray addObject:dict];
    
}

-(void)calculateTotalScore{
    
    NSNumber* sum = [scoresArray valueForKeyPath: @"@sum.Value"];
    NSLog(@"Score of %ld questions is : %@",scoresArray.count,sum);
    scoreLabel.text = [@"" stringByAppendingFormat:@"%@",sum];
    
}

-(void)showBlankView{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->contentView) {
            [self->contentView removeFromSuperview];
        }
        self->contentView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:self->contentView];
    });
}

-(void)removeBlankView{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->contentView) {
            [self->contentView removeFromSuperview];
        }
    });
}

-(void)populateAnswersFromResponse:(NSArray *)answerList{
    
    for(NSDictionary *dataDict in answerList){
        
        if(![Utility isEmptyCheck:dataDict[@"QuestionnaireRahePerceivedStressMasterId"]]){
            NSString *qSection = [@"" stringByAppendingFormat:@"q%@",dataDict[@"QuestionnaireRahePerceivedStressMasterId"]];
            
            int Value = [dataDict[@"Value"] intValue];
            
            for(UITextField *field in answerTextFieldArray){
                
                if([field.accessibilityHint containsString:qSection]){
                    
                    if(Value>0){
                       field.text = [@"" stringByAppendingFormat:@"%d",(int)(Value/field.tag)];
                    }else{
                        field.text = @"0";
                    }
                    
                    
                    [self makeTextFieldUpdated:field withQSection:qSection];
                    break;
                }
            }
            
        }
    }
    
    [self calculateTotalScore];
    
}
-(void)populateScoreInterpretation{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"\nYour score represents how much cumulative stress you are under.\n\nThe higher the number the more critical it is for you to be exercising regularly, eating a nutritious diet, sleeping well and practicing mindfulness or other stress reduction techniques.\n\nThe following ratings are directly from Holmes/Rahe. Please don't take them as fact IE you 'will' be getting sick..\n\nIt is just an indication that if you are in the higher levels, you may be under more stress than you realise and you really do need to work on minimising and managing your stress so it won't effect your health in the future."];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Light" size:14] range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString length])];
    
    
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc]initWithString:@"\n\nScore Interpretation\n\n11-150"];
    [attributedString1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:16] range:NSMakeRange(0, [attributedString1 length])];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString1 length])];
    
    
    
    NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:@"\nYou have only a low to moderate chance of becoming ill in the near future."];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Light" size:14] range:NSMakeRange(0, [attributedString2 length])];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString2 length])];
    
    [attributedString1 appendAttributedString:attributedString2];
    
    NSMutableAttributedString *attributedString3 =[[NSMutableAttributedString alloc]initWithString:@"\n\n150-299"];
    [attributedString3 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:16] range:NSMakeRange(0, [attributedString3 length])];
    [attributedString3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString3 length])];
    
    NSMutableAttributedString *attributedString4 =[[NSMutableAttributedString alloc]initWithString:@"\nYou have a moderate to high chance of becoming ill in the near future."];
    [attributedString4 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Light" size:14] range:NSMakeRange(0, [attributedString4 length])];
    [attributedString4 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString4 length])];
    
    [attributedString3 appendAttributedString:attributedString4];
    
    NSMutableAttributedString *attributedString5 =[[NSMutableAttributedString alloc]initWithString:@"\n\n300+"];
    [attributedString5 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:16] range:NSMakeRange(0, [attributedString5 length])];
    [attributedString5 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString5 length])];
    
    NSMutableAttributedString *attributedString6 =[[NSMutableAttributedString alloc]initWithString:@"\nYou have a high or very high risk of becoming ill in the near future.\n"];
    [attributedString6 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Light" size:14] range:NSMakeRange(0, [attributedString6 length])];
    [attributedString6 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString6 length])];
    
    [attributedString5 appendAttributedString:attributedString6];
    
    [attributedString appendAttributedString:attributedString1];
    [attributedString appendAttributedString:attributedString3];
    [attributedString appendAttributedString:attributedString5];
    scoreInterPretationLabel.attributedText = attributedString;
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
    //[self showBlankView];
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
    if (activeTextField !=nil) {
        CGRect aRect = mainScroll.frame;
        CGRect frame = [mainScroll convertRect:activeTextField.frame fromView:activeTextField.superview];
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect,frame.origin) ) {
            [mainScroll scrollRectToVisible:frame animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self removeBlankView];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
//    [self updateScore:activeTextField];
//    activeTextField = nil;
    
}
#pragma mark - End

#pragma mark - textField Delegate
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [textField setInputAccessoryView:toolBar];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateScore:activeTextField];
    activeTextField = nil;
    
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateUserQuestionnaireRahePerceivedStressAnswerList" append:@""forAction:@"POST"];
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
                                                                             if(![Utility isEmptyCheck:detailsDict[@"RahePerceivedStressAnswerList"]]){
                                                                                 
                                                                                 [self populateAnswersFromResponse:detailsDict[@"RahePerceivedStressAnswerList"]];
                                                                                 
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
