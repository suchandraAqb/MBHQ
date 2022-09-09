//
//  SignupWithEmailViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 02/06/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "SignupWithEmailViewController.h"
#import "LoginController.h"

#import "PrivacyPolicyAndTermsServiceViewController.h"
#import "TrailHomeViewController.h"
#import "NavigationViewController.h"
#import "AppDelegate.h"
#import "ParentViewController.h"
@interface SignupWithEmailViewController (){
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIButton *backButton;

    IBOutlet UIButton *loginButton;
    IBOutlet UIStackView *outerStackView;
    IBOutlet UIView *signupButtonContainerView;
    __weak IBOutlet UIButton *signupWithEmailButton;
    IBOutlet UIView *passwordContainerView;

    __weak IBOutlet UIButton *signupWithFacebook;
    IBOutlet UITextField *firstNameTextField;
    IBOutlet UITextField *LastNameTextField;
    IBOutlet UITextField *EmailTextField;
    IBOutlet UITextField *mobileTextField;
    IBOutlet UITextField *passwordTextField;
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

@implementation SignupWithEmailViewController
@synthesize isFromFb,isFromNonSubscribedUser,fName,lName,email,password;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareLayout];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"By continuing you accept our Privacy Policy and Terms of Service."];
    [text addAttribute:NSLinkAttributeName value:@"PrivacyPolicy://" range:NSMakeRange(29, 14)];
    [text addAttribute:NSLinkAttributeName value:@"TermsofService://" range:NSMakeRange(48, 16)];

    [text addAttribute:NSUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                      range:NSMakeRange(29, 14)];
    [text addAttribute:NSUnderlineStyleAttributeName
                 value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                 range:NSMakeRange(48, 16)];
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Raleway-SemiBold" size:12.0],
                               NSForegroundColorAttributeName : [UIColor whiteColor],
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
    for(UIView *view in roundedView){
        view.layer.cornerRadius = 20.0;
        view.clipsToBounds = YES;
    }
    
    NSDictionary *userData = [defaults objectForKey:@"NonSubscribedUserData"];
    if (![Utility isEmptyCheck:userData] && ![Utility isEmptyCheck:userData[@"Email"]]) {
        
        if([Utility isEmptyCheck:password]){
            password = ![Utility isEmptyCheck:userData[@"Password"]]?userData[@"Password"] : @"";
            passwordTextField.text = password;
        }
        [self gotoPaymentButtonPressed:0];
    }
    
}

#pragma mark -IBAction
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)checkExistingUser:(NSDictionary *)userDataDict{
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
        [mainDict setObject:userDataDict[@"Email"] forKey:@"Email"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"CheckSquadOnlineRequestApiCall" append:@"" forAction:@"POST"];
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
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                            ParentViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Parent"];
                                                                            controller.userDataDict = userDataDict;
                                                                            controller.isShowSquadLite = self->_isShowSquadLite;
                                                                            [self.navigationController pushViewController:controller animated:YES];
                                                                             
                                                                         }else{
                                                                             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                             LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
                                                                             controller.isFromSignUp = NO;
                                                                             [Utility msgWithPush:@"You are already registered.Please sign in." title:@"Oops!" controller:self haveToAnimate:YES toController:controller];
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
-(void)prepareView{
    if (isFromFb) {
        firstNameTextField.text = fName;
        LastNameTextField.text = lName;
        if (![Utility isEmptyCheck:email]) {
            EmailTextField.text = email;
            EmailTextField.enabled = false;
        }else{
            EmailTextField.enabled = true;
        }
        passwordTextField.text = password;
        passwordTextField.enabled = false;
        passwordContainerView.hidden = true;
        signupWithFacebook.hidden = true;
        loginButton.hidden = true;
        
    }else if (isFromNonSubscribedUser) {
        firstNameTextField.text = fName;
        LastNameTextField.text = lName;
        if (![Utility isEmptyCheck:email]) {
            EmailTextField.text = email;
        }
        EmailTextField.enabled = true;
        if(isFromFb){
            passwordTextField.text = password;
            passwordTextField.enabled = false;
            passwordContainerView.hidden = true;
        }else{
            passwordTextField.text = @"";
            passwordTextField.enabled = true;
            passwordContainerView.hidden = false;
        }
        signupWithFacebook.hidden = true;
        loginButton.hidden = true;
        
    }else{
        EmailTextField.enabled = true;
        passwordTextField.enabled = true;
        passwordContainerView.hidden = false;
        signupButtonContainerView.hidden = false;
        loginButton.hidden = false;
        
    }
}
- (IBAction)LoginButtonPressed:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
- (IBAction)gotoPaymentButtonPressed:(UIButton *)sender {
    if ([Utility isEmptyCheck:firstNameTextField.text]) {
        [Utility msg:@"First Name is required" title:@"Error!" controller:self haveToPop:NO];
        return;
    }
    if ([Utility isEmptyCheck:LastNameTextField.text]) {
        [Utility msg:@"Last Name is required" title:@"Error!" controller:self haveToPop:NO];
        return;
    }
//    if ([Utility isEmptyCheck:mobileTextField.text]) {
//        [Utility msg:@"Mobile Number is required" title:@"Error!" controller:self haveToPop:NO];
//        return;
//    }
    if ([Utility isEmptyCheck:EmailTextField.text]) {
        [Utility msg:@"Email is required" title:@"Error!" controller:self haveToPop:NO];
        return;
    }else{
        if (![Utility validateEmail:EmailTextField.text]) {
            [Utility msg:@"Enter a valid email." title:@"Error!" controller:self haveToPop:NO];
            return;
        }
    }
    if ([Utility isEmptyCheck:passwordTextField.text]) {
        [Utility msg:@"Password is required" title:@"Error!" controller:self haveToPop:NO];
        return;
    }
    NSMutableDictionary *userDataDict = [[NSMutableDictionary alloc]init];
    [userDataDict setObject:firstNameTextField.text forKey:@"FirstName"];
    [userDataDict setObject:LastNameTextField.text forKey:@"LastName"];
   // [userDataDict setObject:mobileTextField.text forKey:@"Mobile"];
    [userDataDict setObject:EmailTextField.text forKey:@"Email"];
    [userDataDict setObject:passwordTextField.text forKey:@"Password"];
    [userDataDict setObject:[NSNumber numberWithBool:isFromFb] forKey:@"IsFbUser"];
    [self checkExistingUser:userDataDict];
}
- (IBAction)faceBookButtonPressed:(UIButton *)sender {
    if (Utility.reachable) {
        
    }else
    {
        [Utility msg:@"Check Your network connection and try again." title:@"Error!" controller:self haveToPop:NO];
    }
}


#pragma mark End

#pragma mark - Private Function
-(void)prepareLayout{
    firstNameTextField.layer.cornerRadius = 20;
    firstNameTextField.layer.masksToBounds = YES;
    firstNameTextField.layer.borderColor = [Utility colorWithHexString:mbhqBaseColor].CGColor;
    firstNameTextField.layer.borderWidth = 1;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, firstNameTextField.frame.size.height)];
    firstNameTextField.leftView = paddingView;
    firstNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    LastNameTextField.layer.cornerRadius = 20;
    LastNameTextField.layer.masksToBounds = YES;
    LastNameTextField.layer.borderColor = [Utility colorWithHexString:mbhqBaseColor].CGColor;
    LastNameTextField.layer.borderWidth = 1;
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, LastNameTextField.frame.size.height)];
    LastNameTextField.leftView = paddingView1;
    LastNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    EmailTextField.layer.cornerRadius = 20;
    EmailTextField.layer.masksToBounds = YES;
    EmailTextField.layer.borderColor = [Utility colorWithHexString:mbhqBaseColor].CGColor;
    EmailTextField.layer.borderWidth = 1;
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, EmailTextField.frame.size.height)];
    EmailTextField.leftView = paddingView2;
    EmailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    passwordTextField.layer.cornerRadius = 20;
    passwordTextField.layer.masksToBounds = YES;
    passwordTextField.layer.borderColor = [Utility colorWithHexString:mbhqBaseColor].CGColor;
    passwordTextField.layer.borderWidth = 1;
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, passwordTextField.frame.size.height)];
    passwordTextField.leftView = paddingView3;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
}
#pragma mark - End

#pragma mark - KeyboardNotifications
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
#pragma mark - End -
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
