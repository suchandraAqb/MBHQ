//
//  InitialViewController.m
//  Squad
//
//  Created by AQB Solutions Private Limited on 04/06/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "InitialViewController.h"
#import "LoginController.h"
#import "SevenDayTrialViewController.h"
#import "SignupWithEmailViewController.h"


@interface InitialViewController (){
    IBOutlet UIButton *loginButton;
    IBOutletCollection(UIView)NSArray *roundedView;
    __weak IBOutlet UIView *duringTrialInfoView;
    __weak IBOutlet UIView *isPaidCheckView;
    __weak IBOutlet UIButton *continueTrialButton;
    __weak IBOutlet UILabel *userNameLabel;
    
    __weak IBOutlet UIView *sevenDayTrialView;
    __weak IBOutlet UIView *freeUserView;
    
    IBOutletCollection(UILabel) NSArray *userNameLabels;
    IBOutletCollection(UIButton) NSArray *roundedButtons;
    
    IBOutletCollection(UIButton) NSArray *loginButtons;
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UITextField *EmailTextField;
    IBOutlet UILabel *mindsetLabel;
    IBOutlet UILabel *mindsetLabelForPaididuserView;
    IBOutlet UIView *subscriptionAlertView;
    IBOutlet UILabel *popupUserNameLabel;
    IBOutlet UILabel *discountLabel;
    IBOutlet UIButton *updateNowButton;
    IBOutlet UIView *subscriptionAlertSubView;
    IBOutlet UILabel *subScriptionPopUpEmailLabel;
    UIView *contentView;
    int apiCount;
    UITextField *activeTextField;
    UIToolbar *toolBar;
    NSDictionary *responseDict;
}

@end

@implementation InitialViewController
#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [self registerForKeyboardNotifications];
    [self setUpMindBodyLabel];
    if (_isShowTrialInfoView && ![Utility isEmptyCheck:[defaults objectForKey:@"TempTrialEndDate"]]) {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd"];
        if ([[df dateFromString:[defaults objectForKey:@"TempTrialEndDate"]] isLaterThanOrEqualTo:[df dateFromString:[df stringFromDate:[NSDate date]]]]) {
            [self LoginButtonPressed:nil];
        }
    }
    
    
    
    //// Add Attributed Text To Login Button /////
     NSMutableAttributedString *atrText = [[NSMutableAttributedString alloc] initWithString:@"Already have an account? Login"];
     
     NSRange foundRange = [atrText.mutableString rangeOfString:@"Login"];
     
     [atrText addAttribute:NSUnderlineStyleAttributeName
     value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
     range:foundRange];
     
     NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
     paragraphStyle.alignment = NSTextAlignmentCenter;
     
     NSDictionary *attrDict1 = @{
     NSFontAttributeName : [UIFont fontWithName:@"Oswald-Regular" size:15.0],
     NSForegroundColorAttributeName : [UIColor whiteColor],
     NSParagraphStyleAttributeName:paragraphStyle
     };
     [atrText addAttributes:attrDict1 range:NSMakeRange(0, atrText.length)];
    
    for(UIButton *login in loginButtons){
        NSLog(@"%@",login.accessibilityHint);
        if([login.accessibilityHint isEqualToString:@"signup"]){
            
            NSMutableAttributedString *atrText = [[NSMutableAttributedString alloc] initWithString:@"Ready to sign up? Click here"];
            
            NSRange foundRange = [atrText.mutableString rangeOfString:@"Click here"];
            
            [atrText addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                            range:foundRange];
            
            NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary *attrDict1 = @{
                                        NSFontAttributeName : [UIFont fontWithName:@"Oswald-Regular" size:15.0],
                                        NSForegroundColorAttributeName : [UIColor whiteColor],
                                        NSParagraphStyleAttributeName:paragraphStyle
                                        };
            [atrText addAttributes:attrDict1 range:NSMakeRange(0, atrText.length)];
            [login setAttributedTitle:atrText forState:UIControlStateNormal];
            
        }else{
            [login setAttributedTitle:atrText forState:UIControlStateNormal];
        }
       
    }
    
    
    
    //// END ////
    
    for(UIView *view in roundedView){
        view.layer.cornerRadius = 5.0;
        view.clipsToBounds = YES;
    }
    
    for(UIButton *view in roundedButtons){
        if (view.tag == 1) {
            view.layer.backgroundColor = [Utility colorWithHexString:mbhqBaseColor].CGColor;
        }
        view.layer.cornerRadius = 20.0;
        view.clipsToBounds = YES;
        view.layer.borderColor = [Utility colorWithHexString:mbhqBaseColor].CGColor;
        view.layer.borderWidth = 1.0;
    }
    
    EmailTextField.layer.cornerRadius = 20.0;
    EmailTextField.clipsToBounds = YES;
    EmailTextField.layer.borderColor = [Utility colorWithHexString:mbhqBaseColor].CGColor;
    EmailTextField.layer.borderWidth = 1;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, EmailTextField.frame.size.height)];
    EmailTextField.leftView = paddingView;
    EmailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    updateNowButton.layer.cornerRadius = 15;
    updateNowButton.layer.masksToBounds = YES;
    
    subscriptionAlertSubView.layer.cornerRadius = 8;
    subscriptionAlertSubView.layer.masksToBounds = YES;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateView];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //_isShowTrialInfoView = false;
    [self btnClickedDone:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - End

#pragma mark - Private Method
- (void)purchasedErrorApiCall{
    
    NSString *email = EmailTextField.text;
    
    if([Utility isEmptyCheck:email] || ![Utility validateEmail:email]){
        [Utility msg:@"Please enter a valid email." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
    
    if (Utility.reachable) {
        
        NSString *commonErrorMsg = @"Please email customercare@mindbodyhq.com to have your issue fixed with 48 hours";
        
        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
        
        if (!receipt) {
//            [Utility msg:commonErrorMsg title:@"" controller:self haveToPop:NO];
            [self checkIsPaidUser:false];
            return;
        }
        
        NSString *receiptString = [receipt base64EncodedStringWithOptions:0];
        NSString *bodyText = [@"" stringByAppendingFormat:@"Please note user with following details failed to be registered via InAppPurchase API on MbHQ.\n\nEmail:%@\n\nReceipt Data:%@",email,receiptString];
        
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:@-1 forKey:@"UserSessionID"];
        [mainDict setObject:@"Urgent: Purchased but can't login" forKey:@"Subject"];
        [mainDict setObject:bodyText forKey:@"Body"];
        if (![Utility isEmptyCheck:[defaults objectForKey:@"InappPurchaseRequestString"]]) {
                NSString *inappPurchaseStr = [defaults objectForKey:@"InappPurchaseRequestString"];
                NSData *inAppData = [inappPurchaseStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *inAppDictionary = [NSJSONSerialization JSONObjectWithData:inAppData options:0 error:nil];
                [mainDict setObject:inAppDictionary forKey:@"MbhqRegistrationDetails"];
            }
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        
        if (error) {
            [Utility msg:commonErrorMsg title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            
            self->contentView = [Utility activityIndicatorView:self];
        });
        
        
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"InAppPurchaseErrorReport" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
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
                                                                         [self checkIsPaidUser:false];
//                                                                         [Utility msg:@"Request has been sent to support." title:@"" controller:self haveToPop:NO];
 
                                                                     }else{
                                                                         NSLog(@"Something is wrong.Please try later.");
                                                                         [Utility msg:commonErrorMsg title:@"" controller:self haveToPop:NO];
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
-(void)updateView{
    duringTrialInfoView.hidden = true;
    isPaidCheckView.hidden = true;
    EmailTextField.text = @"";
    subscriptionAlertView.hidden =true;
    if ([defaults boolForKey:@"IsNonSubscribedUser"]){
        if(_isShowTrialInfoView){
            duringTrialInfoView.hidden = false;
        }
        NSDictionary *userData = [defaults objectForKey:@"NonSubscribedUserData"];
        if(![Utility isEmptyCheck:userData]){
            NSString *firstName = ![Utility isEmptyCheck:userData[@"FirstName"]]?userData[@"FirstName"] : @"";
            for(UILabel *label in userNameLabels){
               label.text = [@"" stringByAppendingFormat:@"%@",firstName];
            }
        }
        
       /* if([defaults objectForKey:@"TrialStartDate"]){
            NSDate *trialStartDate = [defaults objectForKey:@"TrialStartDate"];
            NSDate *currentDate = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                                                fromDate:trialStartDate
                                                                  toDate:currentDate
                                                                 options:0];
            
            int days = (int)[components day];
            int daysLeft = 7 - days;
            NSString *title = [@"" stringByAppendingFormat:@"Continue 7 day trial. %d Days left.",(daysLeft>=0)?daysLeft:0];
            [continueTrialButton setTitle:title forState:UIControlStateNormal];
            if(_isShowTrialInfoView){
                duringTrialInfoView.hidden = false;
            }
            
        }*/
        
        if([Utility isSquadFreeUser]){
            freeUserView.hidden = false;
            sevenDayTrialView.hidden = true;
        }else{
            freeUserView.hidden = true;
            sevenDayTrialView.hidden = false;
        }
        
    }
    
    if(_openLoginView){
        _openLoginView = false;
        [self LoginButtonPressed:0];
    }
}

-(void)checkIsPaidUser:(BOOL)isCheckError{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:EmailTextField.text forKey:@"Email"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"IsValidMbHQUser" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 self->apiCount--;
                                                                 if (self->apiCount == 0 && self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if ([[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                             [self redirectUserWithDataPostPaidChecking:responseDictionary isCheckErrorSubscription:isCheckError];
                                                                             
                                                                         }else{
                                                                             [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                         return;
                                                                         
                                                                     }
                                                                 }
                                                                 
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

-(void)redirectUserWithDataPostPaidChecking:(NSDictionary *)dataDict isCheckErrorSubscription:(BOOL)isCheckError{
    
    NSString *existingPurchasedEmail = @"";
       if (![Utility isEmptyCheck:[defaults objectForKey:@"InappPurchaseRequestString"]]) {
           NSString *inappPurchaseStr = [defaults objectForKey:@"InappPurchaseRequestString"];
           NSData *inAppData = [inappPurchaseStr dataUsingEncoding:NSUTF8StringEncoding];
           NSDictionary *inappDict = [NSJSONSerialization JSONObjectWithData:inAppData options:0 error:nil];
           if (![Utility isEmptyCheck:[inappDict objectForKey:@"Model"]] && ![Utility isEmptyCheck:[[inappDict objectForKey:@"Model"]objectForKey:@"Email"]]) {
               existingPurchasedEmail = [[inappDict objectForKey:@"Model"]objectForKey:@"Email"];
           }
       }

    if(![Utility isEmptyCheck:dataDict]){
        responseDict = dataDict;
        if([dataDict[@"IsPaid"] boolValue]){//some error 04/04
            [defaults setObject:EmailTextField.text forKey:@"Email"];
            [defaults setObject:@"" forKey:@"Password"];
            [self goToLogin];
        }else if(isCheckError && [EmailTextField.text isEqualToString:existingPurchasedEmail]){
            [self purchasedErrorApiCall];
        }else if(![Utility isEmptyCheck:dataDict[@"FreeMbhqSubscriber"]]){//FreeWorkoutsUser
            subscriptionAlertView.hidden = false;
            [self updateSubcription];
        }else{
            [self createFreeAccountButtonPressed:0];
        }

        
//        if([dataDict[@"IsPaid"] boolValue]){//some error 04/04
//            [defaults setObject:EmailTextField.text forKey:@"Email"];
//            [defaults setObject:@"" forKey:@"Password"];
//            [self goToLogin];
//        }else if(![Utility isEmptyCheck:dataDict[@"FreeWorkoutsUser"]]){
//            [self goToFreeAccountWithData:dataDict[@"FreeWorkoutsUser"]];
//        }else{
//            [self createFreeAccountButtonPressed:0];
//        }
//
    }
}
-(void)updateSubcription{
    popupUserNameLabel.text = [@"" stringByAppendingFormat:@"Hi %@",[[responseDict objectForKey:@"FreeMbhqSubscriber"]objectForKey:@"FirstName"]];
               NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Please update your membership. Use "]];
               [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:20] range:NSMakeRange(0, [attributedString length])];
               [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString length])];
               
               NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[@""stringByAppendingFormat:@"discount code mb20 for 20%%off "]];
               [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Bold" size:20] range:NSMakeRange(0, [attributedString2 length])];
               [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString2 length])];
               [attributedString appendAttributedString:attributedString2];
                  
               NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc]initWithString:[@""stringByAppendingFormat:@"at checkout."]];
               [attributedString3 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:20] range:NSMakeRange(0, [attributedString3 length])];
               [attributedString3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString3 length])];

               [attributedString appendAttributedString:attributedString3];
               discountLabel.attributedText = attributedString;
    
            subScriptionPopUpEmailLabel.text = [@"" stringByAppendingFormat:@"Use is : %@",EmailTextField.text];
}
-(void)showAlertForNonMember{
    NSString *str = @"'Oops, your email has not been recognised. Click here NOW'";
   
    
    UIAlertController *alertController = [UIAlertController
                                                alertControllerWithTitle:@""
                                                message:str
                                                preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:[Utility getattributedMessage:str] forKey:@"attributedMessage"];

          UIAlertAction *okAction = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action)
                                     {
//                                NSString *redirectUrl = BASEURL;
//                                if(![Utility isEmptyCheck:[defaults valueForKey:@"UserID"]]){
//                                    redirectUrl = [@"" stringByAppendingFormat:@"%@/Home/UpgradeToUltimateLifestyle?userId=%@",redirectUrl,[defaults valueForKey:@"UserID"]];
//                                }else{
//                                    redirectUrl = [@"" stringByAppendingFormat:@"%@/Home/UpgradeToUltimateLifestyle",redirectUrl];
//                                }
                        NSString *redirectUrl = @"https://mindbodyhq.com/pages/email-not-recognised-page";
                        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:redirectUrl]]){
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl] options:@{} completionHandler:^(BOOL success) {
                            if(success){
                                NSLog(@"Opened");
                                }
                            }];
                        }
                    return ;
              
          }];
          [alertController addAction:okAction];
          [self presentViewController:alertController animated:YES completion:nil];
}
-(void)goToLogin{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
    
    controller.initialEmail = (![Utility isEmptyCheck:EmailTextField.text])?EmailTextField.text:@"";
    if(_isPresented && _presentingNav){
        
        [self dismissViewControllerAnimated:YES completion:^{
            NSArray *arr = self->_presentingNav.viewControllers;
            if(arr.count>0){
                UIViewController *lastController = [arr lastObject];
                if([lastController isKindOfClass:[LoginController class]]){
                    return;
                }
            }
            [self->_presentingNav pushViewController:controller animated:NO];
        }];
    }else{
        [self.navigationController pushViewController:controller animated:NO];
    }
}
-(void)setUpMindBodyLabel{
               NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@""];//RE-TRAIN YOUR BRAIN
               [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Bold" size:25] range:NSMakeRange(0, [attributedString length])];
               [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])];
               
               NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:@""];
               [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Bold" size:25] range:NSMakeRange(0, [attributedString2 length])];
               [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString2 length])];
    
            NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc]initWithString:@""];
             [attributedString3 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway" size:18] range:NSMakeRange(0, [attributedString3 length])];
             [attributedString3 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString3 length])];
               
               [attributedString appendAttributedString:attributedString2];
               [attributedString appendAttributedString:attributedString3];
                mindsetLabel.attributedText = attributedString;
            mindsetLabelForPaididuserView.attributedText = attributedString;
}
-(void)goToFreeAccountWithData:(NSDictionary *)dataDict{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SevenDayTrialViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"SevenDayTrial"];
    controller.email = (![Utility isEmptyCheck:EmailTextField.text])?EmailTextField.text:@"";
    controller.fName = ![Utility isEmptyCheck:[dataDict objectForKey:@"FirstName"]]?[dataDict objectForKey:@"FirstName"]:@"";
    controller.lName = [Utility isEmptyCheck:[dataDict objectForKey:@"LastName"]]?[dataDict objectForKey:@"LastName"]:@"";
    
    if(_isPresented && _presentingNav){
        [self dismissViewControllerAnimated:YES completion:^{
            
            NSArray *arr = self->_presentingNav.viewControllers;
            if(arr.count>0){
                UIViewController *lastController = [arr lastObject];
                if([lastController isKindOfClass:[SevenDayTrialViewController class]]){
                    return;
                }
            }
            
            [self->_presentingNav pushViewController:controller animated:YES];
        }];
    }else{
        [self.navigationController pushViewController:controller animated:NO];
        
        if(![Utility isEmptyCheck:dataDict]){
            NSMutableDictionary *userDataDict = [NSMutableDictionary new];
            [userDataDict setObject:(![Utility isEmptyCheck:dataDict[@"FirstName"]])?dataDict[@"FirstName"]:@"" forKey:@"FirstName"];
            [userDataDict setObject:(![Utility isEmptyCheck:dataDict[@"LastName"]])?dataDict[@"LastName"]:@"" forKey:@"LastName"];
            [userDataDict setObject:(![Utility isEmptyCheck:dataDict[@"Password"]])?dataDict[@"Password"]:@"" forKey:@"Password"];
            [userDataDict setObject:EmailTextField.text forKey:@"Email"];
            [userDataDict setObject:@"" forKey:@"Mobile"] ;
            [userDataDict setObject:[NSNumber numberWithBool:[dataDict[@"IsFBUser"] boolValue]] forKey:@"IsFbUser"];
            
            [controller updateUserData:userDataDict];
            
        }
    }
}
#pragma mark - End

#pragma mark - IBAction

- (IBAction)createFreeAccountButtonPressed:(UIButton *)sender {
    [self goToFreeAccountWithData:nil];
    
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    SquadInfoViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"SquadInfoView"];
    //    [self.navigationController pushViewController:controller animated:NO];

}

- (IBAction)LoginButtonPressed:(UIButton *)sender {
    //[self goToLogin];
    isPaidCheckView.hidden = false;
    duringTrialInfoView.hidden = true;
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    
    isPaidCheckView.hidden = true;
    _openLoginView = false;
    
}

- (IBAction)isPaidCheckButtonPressed:(UIButton *)sender {
    [self.view endEditing:true];
    if ([Utility isEmptyCheck:EmailTextField.text]) {
            [Utility msg:@"Email is required" title:@"Error!" controller:self haveToPop:NO];
            return;
     }else if (![Utility validateEmail:EmailTextField.text]) {
         [Utility msg:@"Enter a valid email." title:@"Error!" controller:self haveToPop:NO];
         return;
     }
    
    [self checkIsPaidUser:true];
}

- (IBAction)continueTrialButtonPressed:(UIButton *)sender {
    
    ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
    HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
    NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
    slider.topViewController = nav;
    [slider resetTopViewAnimated:YES];
    
    if(_isPresented && _presentingNav){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController pushViewController:slider animated:YES];
    }
    
    
}

- (IBAction)signupNowButtonPressed:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignupWithEmailViewController *signupController=[storyboard instantiateViewControllerWithIdentifier:@"SignupWithEmail"];
    NSDictionary *userData = [defaults objectForKey:@"NonSubscribedUserData"];
    if (![Utility isEmptyCheck:userData] && ![Utility isEmptyCheck:userData[@"Email"]]) {
        signupController.isFromFb = ![Utility isEmptyCheck:userData[@"IsFbUser"]]?[userData[@"IsFbUser"] boolValue] : NO;
        signupController.fName = ![Utility isEmptyCheck:userData[@"FirstName"]]?userData[@"FirstName"] : @"";
        signupController.lName = ![Utility isEmptyCheck:userData[@"LastName"]]?userData[@"LastName"] : @"";
        signupController.email = userData[@"Email"];
        if (![Utility isEmptyCheck:userData[@"IsFbUser"]] && [userData[@"IsFbUser"] boolValue]) {
            signupController.password = ![Utility isEmptyCheck:userData[@"Password"]]?userData[@"Password"] : @"";
        }else{
            signupController.password =  @"";
        }
        signupController.isFromNonSubscribedUser = YES;
    }
    
    if(_isPresented && _presentingNav){
        
        [self dismissViewControllerAnimated:YES completion:^{
            NSArray *arr = self->_presentingNav.viewControllers;
            if(arr.count>0){
                UIViewController *lastController = [arr lastObject];
                if([lastController isKindOfClass:[SignupWithEmailViewController class]]){
                    return;
                }
            }
           [self->_presentingNav pushViewController:signupController animated:YES];
        }];
    }else{
        [self.navigationController pushViewController:signupController animated:YES];
    }
    
}

- (IBAction)accessSquadFreeButtonPressed:(UIButton *)sender {
    ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
    HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
    NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
    slider.topViewController = nav;
    [slider resetTopViewAnimated:YES];
    if(_isPresented && _presentingNav){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController pushViewController:slider animated:YES];
    }
}

-(IBAction)updateNowPressed:(id)sender{
    if (![Utility isEmptyCheck:responseDict]) {
        // http://dev1.thesquadtours.com/home/MbhqRedirect?mode=signup&userId=15180
        //[[responseDict objectForKey:@"FreeMbhqSubscriber"]objectForKey:@"FirstName"]
        
        NSString *urlStr=[NSString stringWithFormat:@"%@/home/MbhqRedirect?mode=signup&userId=%@",BASEURL,[[responseDict objectForKey:@"FreeMbhqSubscriber"]objectForKey:@"SquadUserId"]];
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"Opened");
                }
            }];
        }
        
//        [self goToFreeAccountWithData:responseDict[@"FreeMbhqSubscriber"]];
    }
}
-(IBAction)alertCrossButtonPressed:(id)sender{
    subscriptionAlertView.hidden = true;
}
#pragma mark - End
#pragma mark - KeyboardNotifications -
// Call this method somewhere in your view controller setup code.
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
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
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
}
#pragma mark - End -

#pragma mark - textField Delegate
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
    activeTextField = nil;
}



#pragma mark - End

@end
