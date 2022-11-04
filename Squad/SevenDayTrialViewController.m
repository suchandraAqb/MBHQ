#import "SevenDayTrialViewController.h"
#import "LoginController.h"
#import "PrivacyPolicyAndTermsServiceViewController.h"
#import "SignupWithEmailViewController.h"
#import "SquadInfoViewController.h"
#import "InitialViewController.h"
#import "ParentViewController.h"


@interface SevenDayTrialViewController (){
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIButton *loginButton;
    IBOutlet UIStackView *outerStackView;
    IBOutlet UIButton *backButton;
    IBOutlet UITextField *firstNameTextField;
    IBOutlet UITextField *LastNameTextField;
    IBOutlet UITextField *EmailTextField;
    __weak IBOutlet UITextField *passwordTextField;
    IBOutlet UITextView *termsAndConditionTextView;
    
    
    NSString *facebookUserId;
    NSString *facebookTokenString;
    UITextField *activeTextField;
    UIToolbar *toolBar;
    UIView *contentView;
    int apiCount;
    IBOutletCollection(UIView)NSArray *roundedView;
}

@end

@implementation SevenDayTrialViewController
@synthesize isFromFb,fName,lName,email,password,isFromAppDelegate,ofType;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (isFromAppDelegate) {
        backButton.hidden = true;
    }else{
        backButton.hidden = false;
    }
    //    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"By continuing you accept our Privacy Policy and Terms of Service."];
    //    [text addAttribute:NSLinkAttributeName value:@"PrivacyPolicy://" range:NSMakeRange(29, 14)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Your privacy is important to us. View our privacy policy here."]; //Creating a custom plan does not require payment of any kind.
    NSRange foundRange = [text.mutableString rangeOfString:@"privacy policy here"];
    [text addAttribute:NSLinkAttributeName value:@"PrivacyPolicy://" range:foundRange];
    //    [text addAttribute:NSLinkAttributeName value:@"TermsofService://" range:NSMakeRange(48, 16)];
    
    [text addAttribute:NSUnderlineStyleAttributeName
                 value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                 range:foundRange];//(29, 14)];
    //    [text addAttribute:NSUnderlineStyleAttributeName
    //                 value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
    //                 range:NSMakeRange(48, 16)];
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Raleway-SemiBold" size:12.0],
                               NSForegroundColorAttributeName : [Utility colorWithHexString:mbhqBaseColor],
                               NSParagraphStyleAttributeName:paragraphStyle
                               };
    [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
    
    
    termsAndConditionTextView.attributedText = text;
    termsAndConditionTextView.editable = NO;
    termsAndConditionTextView.delaysContentTouches = NO;
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [self registerForKeyboardNotifications];
    [self prepareView];
    /* NSDictionary *userData = [defaults objectForKey:@"NonSubscribedUserData"];
     if (![Utility isEmptyCheck:userData] && ![Utility isEmptyCheck:userData[@"Email"]]) {
     
     }*/
    
    for(UIView *view in roundedView){
        
        if([view isKindOfClass:[UITextField class]]){
            view.layer.cornerRadius = 20.0;
            view.clipsToBounds = YES;
            view.layer.borderColor =[ Utility colorWithHexString:mbhqBaseColor].CGColor;
            view.layer.borderWidth = 1;
            UITextField *tField = (UITextField *)view;
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, view.frame.size.height)];
            tField.leftView = paddingView;
            tField.leftViewMode = UITextFieldViewModeAlways;
        }else{
            view.layer.cornerRadius = 20.0;
            view.clipsToBounds = YES;
            //            view.layer.borderColor = [UIColor whiteColor].CGColor;
            //            view.layer.borderWidth = 2.0;
        }
    }
    
    loginButton.layer.borderColor = [UIColor clearColor].CGColor;
    loginButton.layer.borderWidth = 0.0;
    
    backButton.layer.borderColor = [UIColor whiteColor].CGColor;
    backButton.layer.borderWidth = 1.0;
}
#pragma mark -IBAction
-(IBAction)backButtonPrssed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)prepareView{
    if (isFromFb) {
        firstNameTextField.text = fName;
        LastNameTextField.text = lName;
        passwordTextField.hidden = true;
        if (![Utility isEmptyCheck:email]) {
            EmailTextField.text = email;
            EmailTextField.enabled = false;
        }else{
            EmailTextField.enabled = true;
        }
        
    }else{
        
        if(![Utility isEmptyCheck:email]){
            EmailTextField.text = email;
        }
        EmailTextField.enabled = true;
        passwordTextField.hidden = false;
    }
}
-(void)checkExistingUser:(NSDictionary *)userDataDict{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            //            apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:userDataDict[@"Email"] forKey:@"Email"];
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
                                                                 //                                                                 self->apiCount--;
                                                                 if (self->contentView) {//self->apiCount == 0 &&
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if ([[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                             if ([[responseDictionary objectForKey:@"IsPaid"] boolValue]) {
                                                                                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                                 LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
                                                                                 controller.isFromSignUp = NO;
                                                                                 [Utility msgWithPush:@"You are already registered.Please sign in." title:@"Oops!" controller:self haveToAnimate:YES toController:controller];
                                                                                 return;
                                                                             }else{
                                                                                 if([Utility isEmptyCheck:[responseDictionary objectForKey:@"FreeMbhqSubscriber"]]){
                                                                                    [self saveContact:userDataDict];
                                                                                 }else{
                                                                                     [self updateUserData:userDataDict];
                                                                                 }
                                                                                 
                                                                                 
                                                                             }
                                                                           
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

-(void)saveContact:(NSDictionary *)userDataDict{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        NSMutableArray *profileArr = [[NSMutableArray alloc]init];
        NSMutableDictionary *mainHeaderDict = [[NSMutableDictionary alloc]init];
        [mainDict setObject:[userDataDict objectForKey:@"FirstName"] forKey:@"first_name"];
        [mainDict setObject:[userDataDict objectForKey:@"Email"] forKey:@"email"];
        [mainDict setObject:[userDataDict objectForKey:@"LastName"] forKey:@"last_name"];
        [profileArr addObject:mainDict];
        [mainHeaderDict setObject:profileArr forKey:@"profiles"];
        //        [mainDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:CHALLENGE_ID,@"campaignId", nil] forKey:@"campaign"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainHeaderDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SaveContact" append:@"" forAction:@"POST"];
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                 
                                                                 NSLog(@"%@",responseString);
                                                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                                 NSLog(@"-------------%ld",(long)httpResponse.statusCode);
                                                                 if(error == nil)
                                                                 {
                                                                     if (httpResponse.statusCode == 202 || httpResponse.statusCode == 409 || httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {

                                                                         [self updateUserData:userDataDict];
                                                                         
                                                                     }else{
                                                                         [Utility msg:@"Please Enter a valid Email" title:@"Oops! " controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                     
                                                                 }else{
                                                                     [Utility msg:@"Please Enter a valid Email" title:@"Oops! " controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
// shabbir 4/1/18
- (IBAction)faceBookButtonPressed:(UIButton *)sender {
    if (Utility.reachable) {
       
    }else
    {
        [Utility msg:@"Check Your network connection and try again." title:@"Error!" controller:self haveToPop:NO];
    }
}
- (IBAction)LoginButtonPressed:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)signUpNowPressed:(UIButton *)sender {
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
    [self.navigationController pushViewController:signupController animated:YES];
}
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
- (IBAction)gotoPaymentButtonPressed:(UIButton *)sender {
    if ([Utility isEmptyCheck:firstNameTextField.text]) {
        [Utility msg:@"First Name is required" title:@"Error!" controller:self haveToPop:NO];
        return;
    }else if ([Utility isEmptyCheck:LastNameTextField.text]) {
        [Utility msg:@"Last Name is required" title:@"Error!" controller:self haveToPop:NO];
        return;
    }
    //    if ([Utility isEmptyCheck:mobileTextField.text]) {
    //        [Utility msg:@"Mobile Number is required" title:@"Error!" controller:self haveToPop:NO];
    //        return;
    //    }
    else if ([Utility isEmptyCheck:EmailTextField.text]) {
        [Utility msg:@"Email is required" title:@"Error!" controller:self haveToPop:NO];
        return;
    }else if (![Utility validateEmail:EmailTextField.text]) {
        [Utility msg:@"Enter a valid email." title:@"Error!" controller:self haveToPop:NO];
        return;
        
    }else if ([Utility isEmptyCheck:passwordTextField.text] && !isFromFb) {
        [Utility msg:@"Password is required" title:@"Error!" controller:self haveToPop:NO];
        return;
    }
    
    NSMutableDictionary *userDataDict = [[NSMutableDictionary alloc]init];
    [userDataDict setObject:firstNameTextField.text forKey:@"FirstName"];
    [userDataDict setObject:LastNameTextField.text forKey:@"LastName"];
    [userDataDict setObject:EmailTextField.text forKey:@"Email"];
    [userDataDict setObject:@"" forKey:@"Mobile"];
    [userDataDict setObject:[NSNumber numberWithBool:isFromFb] forKey:@"IsFbUser"];
    
    NSTimeZone *myTimeZone = [NSTimeZone systemTimeZone];
    NSString *timezoneName = myTimeZone.name;
    NSString *offset = myTimeZone.abbreviation;
    [userDataDict setObject:timezoneName forKey:@"TimezoneName"];
    [userDataDict setObject:offset forKey:@"GMTOffset"];
    
    
    if(isFromFb){
        [userDataDict setObject:password forKey:@"Password"];
    }else{
        password = passwordTextField.text;
        [userDataDict setObject:password forKey:@"Password"];
    }

    [self checkExistingUser:userDataDict];
}

#pragma mark End

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

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    PrivacyPolicyAndTermsServiceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PrivacyPolicyAndTermsService"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    
    if ([[URL scheme] isEqualToString:@"PrivacyPolicy"])
    {
        controller.url=[NSURL URLWithString:PRIVACY_POLICY_URL];
        [self presentViewController:controller animated:YES completion:nil];
        return NO;
    }else if([[URL scheme] isEqualToString:@"TermsofService"]){
        /*controller.url=[NSURL fileURLWithPath:[[NSBundle mainBundle]
         pathForResource:@"squad_terms" ofType:@"pdf"]isDirectory:NO];*/
        controller.url=[NSURL URLWithString:PRIVACY_POLICY_URL];
        
        
        [self presentViewController:controller animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

#pragma mark - End

#pragma mark - Private Method



-(void)updateUserData:(NSDictionary *)userDataDict{
    
    [Utility removeDefaultObjects];
    
    /*[defaults setBool:true forKey:@"IsNonSubscribedUser"];
    [defaults setObject:userDataDict forKey:@"NonSubscribedUserData"];*/
    
    [defaults setObject:[userDataDict valueForKey:@"Email"] forKey:@"Email"];
    [defaults setObject:userDataDict[@"Password"] forKey:@"Password"];
    [defaults setObject:[userDataDict valueForKey:@"FirstName"] forKey:@"FirstName"];
    [defaults setObject:[userDataDict valueForKey:@"LastName"] forKey:@"LastName"];
    
    [self movedToSignup:userDataDict];
    
    
}


-(void)movedToSignup:(NSDictionary *)userData{
    dispatch_async(dispatch_get_main_queue(),^ {
        //NSDictionary *userData = [defaults objectForKey:@"NonSubscribedUserData"];
        ParentViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Parent"];
        controller.userDataDict = userData;
        controller.isShowSquadLite = NO;
        controller.isShowBack = true;
        [self.navigationController pushViewController:controller animated:NO];
    });
    
}


#pragma mark - End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
