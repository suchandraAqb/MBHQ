//
//  ForgetPasswordViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 18/9/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController (){
    IBOutlet UITextField *emailTextField;
    IBOutlet UIButton *forgetPasswordButton;
    IBOutlet UIButton *cancelButton;
    UITextView *activeTextField;
    UIView *contentView;

}

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([emailTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
      UIColor *color = [UIColor whiteColor];
      emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your email" attributes:@{NSForegroundColorAttributeName: color}];
    } else {
      NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
}
#pragma mark IBAction
-(IBAction)cancelButtonPressed:(id)sender{
    [emailTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)forgetPasswordButtonPressed:(id)sender{
    [emailTextField resignFirstResponder];
    NSString *email = emailTextField.text;
    if(![Utility isEmptyCheck:email]){
        if (![Utility validateEmail:email]) {
            [Utility msg:@"Please enter a valid email." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        
    }else{
        [Utility msg:@"Please enter your email." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
    
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:email forKey:@"Email"];

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ForgotPasswordApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSMutableDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [responseDictionary[@"SuccessFlag"] boolValue]) {

                                                                         [self dismissViewControllerAnimated:YES completion:^{
                                                                             [[NSNotificationCenter defaultCenter]postNotificationName:@"forgetApiSuceessAlert" object:self userInfo:nil];

                                                                         }];
                                                                     }else{
                                                                         if (![Utility isEmptyCheck:responseString]) {
                                                                             [Utility msg:responseString title:@"Error !" controller:self haveToPop:NO];
                                                                         }else{
                                                                             [Utility msg:@"Something went wrong. Try again later." title:@"Error !" controller:self haveToPop:NO];
                                                                         }
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
#pragma mark End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



@end
