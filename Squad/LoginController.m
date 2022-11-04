//
//  LoginController.m
//  The Life
//
//  Created by AQB SOLUTIONS on 25/03/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "LoginController.h"
#import "NavigationViewController.h"
#import "HomePageViewController.h"
#import "PreSignUpViewController.h"
#import "PrivacyPolicyAndTermsServiceViewController.h"
#import "SetReminderViewController.h"   //ahn
#import <AdSupport/ASIdentifierManager.h>
#import "ForgetPasswordViewController.h"
#import "SignupWithEmailViewController.h"
#import "SevenDayTrialViewController.h"
#import "InitialViewController.h"
#import "SquadInfoViewController.h"

//#import "HelpViewController.h"
@interface LoginController (){
    IBOutlet UIButton *backButton;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIImageView *bgImage;
    IBOutlet UIButton *signUpButton;
    IBOutlet UITextView *termsAndConditionTextView;

    IBOutlet UIButton *forgetPasswordButton;

    UITextField *activeTextField;
    UIView *contentView;
    UIToolbar *toolBar;
    //faf
   NSString *facebookUserId;
    NSString *facebookTokenString;
    IBOutletCollection(UIView)NSArray *roundedView;
    IBOutlet UIView *passwordUpdateView;
    IBOutlet UITextField *updatepasswordTextField;
    IBOutlet UIButton *updatePasswordButton;
    
    IBOutlet UIView *subscriptionAlertView;
    IBOutlet UIView *subscriptionAlertSubview;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *alertL2;
    IBOutlet UILabel *alertL3;
    IBOutlet UILabel *alertL4;
    IBOutlet UIButton *updateNowButton;
    
}

@end

@implementation LoginController
@synthesize isFromSignUp,isFromAppDelegate,isMovedToToday;

#pragma mark - Private method

- (NSString *)identifierForAdvertising
{
    if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled])
    {
        NSUUID *IDFA = [[ASIdentifierManager sharedManager] advertisingIdentifier];
        
        return [IDFA UUIDString];
    }
    
    return nil;
}
-(IBAction)btnClickedDone:(id)sender{
    [self loginButtonPressed:nil];
}
-(void)setAfterSignupNotification{
    
    if ([Utility isEmptyCheck:[defaults objectForKey:@"firstLoginDate"]]) {
        [defaults setObject:[NSDate date] forKey:@"firstLoginDate"];
    }//AY 06042018
    
    if (![defaults boolForKey:@"isInitialNotiSet"]) {
        
        NSError *error;
        NSString *filePath;
        if([Utility isSquadLiteUser]){
           filePath = [[NSBundle mainBundle] pathForResource:@"SquadLiteSignUpNotification" ofType:@"json"];
        }else{
           filePath = [[NSBundle mainBundle] pathForResource:@"SquadSignUpNotification" ofType:@"json"];
        }
        
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSArray *notiArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        
        if(error){
            NSLog(@"Signup Notification JSON Read Error:%@",error.debugDescription);
            return;
        }
        
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        
        NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
        if (requests.count > 55) {
            for (int r = 0; r < 13; r++) {
                UILocalNotification *req = requests[r];
                [[UIApplication sharedApplication] cancelLocalNotification:req];
            }
        }
        for (UILocalNotification *req in requests) {
            NSString *remType = [req.userInfo objectForKey:@"remType"];
            if ([remType caseInsensitiveCompare:@"initialReminder"] == NSOrderedSame) {
                
                [[UIApplication sharedApplication] cancelLocalNotification:req];
                
            }
        }
        
        //                                                                         int i = 0;
        for (int i = 0; i < notiArray.count; i++) {
            NSDate *newDate = [NSDate date];
            
            NSDictionary *dict = [notiArray objectAtIndex:i];
            
            int day = [dict[@"day"] intValue];
            
            NSString *body = [dict objectForKey:@"body"];
            if(i==0){
                NSString *name = @"";
                if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
                    name = [defaults objectForKey:@"FirstName"];
                }
                
                body = [@"" stringByAppendingFormat:@"Hey %@, welcome to the most amazing health and fitness community of positive, proactive women on the planet! We are so excited to have you on board!  If you haven’t already, please join our worldwide forum",name];
            }
           
            
            switch (i) {
                case 0:
                    
                   newDate = [theCalendar dateByAddingUnit:NSCalendarUnitMinute
                                                   value:60
                                                  toDate:[NSDate date]
                                                 options:0];;//[newDate dateByAddingTimeInterval:10];//10*60];
                    break;
                    
                default:
                    
                    dayComponent.day = day-1;
                    newDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
                    break;
            }
            
            [SetReminderViewController setNotificationAt:newDate FromController:[dict objectForKey:@"fromController"] Id:[NSString stringWithFormat:@"id_%d",i] Title:[dict objectForKey:@"title"] Body:body];
        }
        
        [defaults setBool:YES forKey:@"isInitialNotiSet"];
    }
    
}
-(void)setQuoteNotification{
    
    if (![defaults boolForKey:@"isInitialQuoteSet"]) {
        
        /*NSError *error;
        NSString *filePath;
        filePath = [[NSBundle mainBundle] pathForResource:@"Quote" ofType:@"json"];
        
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSArray *notiArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        
        if(error){
            NSLog(@"Quote Notification JSON Read Error:%@",error.debugDescription);
            return;
        }
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSDate *installationDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"InstallationDate"];
        
        //        NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
        //        if (requests.count > 55) {
        //            for (int r = 0; r < 13; r++) {
        //                UILocalNotification *req = requests[r];
        //                [[UIApplication sharedApplication] cancelLocalNotification:req];
        //            }
        //        }
        //        for (UILocalNotification *req in requests) {
        //            NSString *remType = [req.userInfo objectForKey:@"remType"];
        //            if ([remType caseInsensitiveCompare:@"initialReminder"] == NSOrderedSame) {
        //
        //                [[UIApplication sharedApplication] cancelLocalNotification:req];
        //
        //            }
        //        }
        
        for (int i = 0; i < notiArray.count; i++) {
            
            NSDate *day;
            day =  [theCalendar dateByAddingUnit:NSCalendarUnitDay
                                           value:i
                                          toDate:installationDate
                                         options:0];
            NSDictionary *dict =notiArray[i];
            NSString *str = [dict objectForKey:@"QUOTE"];
            NSString *detailsStr= [str stringByAppendingFormat:@"\n%@",[dict objectForKey:@"Credit"]];
            
            [SetReminderViewController setNotificationAt:day FromController:@"QuoteController" Id:[NSString stringWithFormat:@"id_%d",i] Title:@"Quote" Body:detailsStr];
        }*/
        
        [Utility cancelscheduleLocalNotificationsForQuote];
        [defaults setBool:YES forKey:@"QuoteNotification"];
        [AppDelegate scheduleLocalNotificationsForQuote:YES];
    }else{
        [Utility cancelscheduleLocalNotificationsForQuote];
        [AppDelegate scheduleLocalNotificationsForQuote:NO];
    }
}


-(void)showAppUpdateAlert:(UIViewController *)presentingController latestApversion:(float)version;
{
   /* NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if(![Utility isEmptyCheck:currentVersion]){
        float curVer = [currentVersion floatValue];
        if(version > curVer){
            //[Utility showAlertForAppUpdate:presentingController];
        }
        
    }*/
    
    [Utility showAlertForAppUpdate:presentingController];
    
}
-(void)addDiscoverablePoints{
    if ([defaults objectForKey:@"Discoverable"] && ![[defaults objectForKey:@"Discoverable"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Discoverable"] caseInsensitiveCompare:@"yes"] == NSOrderedSame) {
        
        NSMutableDictionary *dataDict = [NSMutableDictionary new];
        [dataDict setObject:[NSNumber numberWithInt:4] forKey:@"UserActionId"];
        if([[defaults objectForKey:@"ABBBCOnlineUserId"] intValue] > 0){
           [dataDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"ReferenceEntityId"];
        }
        
        [dataDict setObject:@"users" forKey:@"ReferenceEntityType"];
        
//        [Utility addGamificationPointWithData:dataDict];
    }
}
-(void)webServiceCall_UpdatePassword{
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
        
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"Password"] forKey:@"OldPassword"];
        [mainDict setObject:updatepasswordTextField.text forKey:@"NewPassword"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdatePassword" append:@""forAction:@"POST"];
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
                                                                         [defaults removeObjectForKey:@"NonSubscribedUserData"];
                                                                         [defaults setObject:self->updatepasswordTextField.text forKey:@"Password"];
                                                                         self->passwordUpdateView.hidden = true;
                                                                             //Change+
                                                                         if ([Utility isOnlyProgramMember]) {
                                                                             ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
                                                                             CoursesListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CoursesList"];
                                                                             NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                                                                             slider.topViewController = nav;
                                                                             [slider resetTopViewAnimated:NO];
                                                                             [self.navigationController pushViewController:slider animated:NO];
                                                                         }else{
                                                                             ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
                                                                             SquadInfoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SquadInfoView"];
                                                                             NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];                                                                      slider.topViewController = nav;
                                                                                [slider resetTopViewAnimated:NO];
                                                                                [self.navigationController pushViewController:slider animated:NO];
                                                                         }
                                                                     }
                                                                     else{
                                                                         if (![Utility isEmptyCheck:responseDict]) {
                                                                             [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                             return;
                                                                         }else{
                                                                             [Utility msg:responseString title:@"Error !" controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                        
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
#pragma mark - IBAction -

- (IBAction)crossPressed:(UIButton *)sender {
    subscriptionAlertView.hidden=true;
}
- (IBAction)updateNowPressed:(UIButton *)sender {
    subscriptionAlertView.hidden=true;
}

-(IBAction)passwordUpdateButtonPressed:(id)sender{
    NSString *str = updatepasswordTextField.text;
    if (![Utility isEmptyCheck:str]) {
        [self webServiceCall_UpdatePassword];
    }else{
        [Utility msg:@"Please enter your new password" title:@"Alert" controller:self haveToPop:NO];
    }
}
-(IBAction)backButtonPressed:(id)sender{
    if (!passwordUpdateView.hidden) {
         passwordUpdateView.hidden = true;
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(IBAction)forgetPasswordButtonPressed:(id)sender{
    ForgetPasswordViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ForgetPassword"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];

}
- (IBAction)signinWithFb:(UIButton *)sender {
    if (Utility.reachable) {
       
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Error!" controller:self haveToPop:NO];
    }
}
- (IBAction)signUpButtonPressed:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PreSignUpViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"PreSignUp"];
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
- (IBAction)sevenDayTrialPressed:(UIButton *)sender {
    
   /* ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
    HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
    NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
    slider.topViewController = nav;
    [slider resetTopViewAnimated:YES];
    [self.navigationController pushViewController:slider animated:YES];*/
    
    NSArray *controllers = [self.navigationController viewControllers];
    
   /* if(controllers && controllers.count>=2){
        UIViewController *prvController = [controllers objectAtIndex:controllers.count-2];
        if([prvController isKindOfClass:[SevenDayTrialViewController class]]){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SevenDayTrialViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"SevenDayTrial"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SevenDayTrialViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"SevenDayTrial"];
        [self.navigationController pushViewController:controller animated:YES];
    }*/
    
    BOOL isControllerPushed = NO;
    for(UIViewController *controller in controllers){
        if([controller isKindOfClass:[InitialViewController class]]){
            isControllerPushed = YES;
          [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
    
    if(!isControllerPushed){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         InitialViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"InitialView"];
         [self.navigationController pushViewController:controller animated:YES];
    }
    
    
    
}
-(IBAction)loginButtonPressed:(id)sender{
    [Utility logoutAccount_CommunityWebserviceCall];
    NSString *email = emailTextField.text;
    NSString *password = passwordTextField.text;
    if(![Utility isEmptyCheck:email]){
        if (![Utility validateEmail:email]) {
            [Utility msg:@"Please enter a valid email." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        
    }else{
        [Utility msg:@"Please enter your email." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
    if([Utility isEmptyCheck:password]){
        [Utility msg:@"Please enter your password." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
    [defaults setBool:false forKey:@"IsFbUser"];
    if (Utility.reachable) {
        //[Utility logoutChatSdk];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
 
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:email forKey:@"Email"];//EmailAddress //Email
        [mainDict setObject:password forKey:@"Password"];
        [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IncludeAbbbcOnline"];
        
        if([FIRMessaging messaging].FCMToken){
            [mainDict setObject:[FIRMessaging messaging].FCMToken forKey:@"FirebaseIosToken"];
        }
        
        //Added on AY 17042018
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if(![Utility isEmptyCheck:version]){
            [mainDict setObject:version forKey:@"AppVersion"];
        }
        [mainDict setObject:@"ios" forKey:@"AppPlatform"];
        //End
        
        
        NSLog(@"%@",[self identifierForAdvertising]);
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"LogInApiCall" append:@"" forAction:@"POST"];
        NSLog(@"request============login=========>%@",request);
        NSLog(@"");
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSMutableDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
                                                                           if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"]boolValue]) {
                                                                               
                                                                               NSMutableDictionary *sessionDetailDict = [[NSMutableDictionary alloc]init];
                                                                               sessionDetailDict = [[responseDictionary objectForKey:@"SessionDetail"]mutableCopy];
                                                                               
                                                                               for (NSString *key in [sessionDetailDict allKeys]) {
                                                                                    if ([[sessionDetailDict objectForKey:key] class] ==[NSNull class]) {
                                                                                        [sessionDetailDict removeObjectForKey:key];
                                                                                    }
                                                                               }
                                                                               BOOL isVersionMisMatch = [[sessionDetailDict valueForKey:@"IsVersionMismatch"] boolValue];
                                                                               
                                                                               if(isVersionMisMatch){
                                                                                   [self showAppUpdateAlert:self latestApversion:0.0];
                                                                                   return;
                                                                               }
                                                                               [Utility cancelscheduleLocalNotificationsForFreeUser]; //AY 19022018
                                                                               
                                                                               self->emailTextField.text = @"";
                                                                               self->passwordTextField.text = @"";
                                                                               
                                                                               //Added For Firebase Login Tracking AY 15012018
                                                                               [FIRAnalytics logEventWithName:@"squad_login" parameters:@{
                                                                                                                                          @"email": [sessionDetailDict valueForKey:@"EmailAddress"],
                                                                                                                                          @"type": @"email"
                                                                                                                                          }];
                                                                               
                                                                               if([defaults boolForKey:@"IsNonSubscribedUser"]){
                                                                                   [Utility logoutChatSdk];
                                                                               }
                                                                               [defaults setBool:NO forKey:@"isOffline"];
                                                                               [defaults setBool:[[sessionDetailDict valueForKey:@"isLimeLightUser"] boolValue] forKey:@"isLimeLightUser"];
                                                                               
                                                                               [defaults setObject:[sessionDetailDict valueForKey:@"ActiveUntil"] forKey:@"TempTrialEndDate"];
                                                                               [defaults setObject:nil forKey:@"taskListArray"];
                                                                               
                                                                               [defaults setBool:YES forKey:@"CompletedStartupChecklist"]; //AmitY
                                                                               
                                                                               [defaults setBool:false forKey:@"IsNonSubscribedUser"];
                                                                               [defaults setObject:[sessionDetailDict valueForKey:@"EmailAddress"] forKey:@"Email"];
                                                                               [defaults setObject:password forKey:@"Password"];
                                                                               [defaults setObject:sessionDetailDict forKey:@"LoginData"];
                                                                               [defaults setObject:[sessionDetailDict valueForKey:@"UserID"] forKey:@"UserID"];
                                                                               [defaults setObject:[sessionDetailDict valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
                                                                               [defaults setObject:[sessionDetailDict valueForKey:@"ABBBCOnlineUserId"] forKey:@"ABBBCOnlineUserId"];
                                                                               
                                                                               if(![Utility isEmptyCheck:sessionDetailDict[@"ProfilePicUrl"]]){
                                                                                   [defaults setObject:sessionDetailDict[@"ProfilePicUrl"] forKey:@"ProfilePicUrl"];
                                                                               }
                                                                               
                                                                               [defaults setObject:[sessionDetailDict valueForKey:@"FirstName"] forKey:@"FirstName"];//add24
                                                                               
                                                                               [defaults setObject:[sessionDetailDict valueForKey:@"LastName"] forKey:@"LastName"];//Added by AY 25042018
                                                                               
                                                                               [defaults setObject:[sessionDetailDict valueForKey:@"ABBBCOnlineUserSessionId"] forKey:@"ABBBCOnlineUserSessionId"];
                                                                               
                                                                               [defaults setObject:[sessionDetailDict valueForKey:@"FbWorldForumUrl"] forKey:@"FbWorldForumUrl"];
                                                                               [defaults setObject:[sessionDetailDict valueForKey:@"FbCityForumUrl"] forKey:@"FbCityForumUrl"];
                                                                               [defaults setObject:[sessionDetailDict valueForKey:@"FbSuburbForumUrl"] forKey:@"FbSuburbForumUrl"];
                                                                               
                                                                               NSString *disStat = ([[sessionDetailDict valueForKey:@"DiscoverableStatus"] boolValue]) ? @"yes" : @"no";
                                                                               [defaults setObject:disStat forKey:@"Discoverable"];
                                                                               [defaults setObject:[sessionDetailDict valueForKey:@"FirebaseToken"] forKey:@"FirebaseToken"];
                                                                               
                                                                               if(![Utility isEmptyCheck:[sessionDetailDict valueForKey:@"Token"]]){
                                                                                   [defaults setObject:[sessionDetailDict valueForKey:@"Token"] forKey:@"LoginToken"];
                                                                               }
                                                                               
                                                                               int access_level = [[sessionDetailDict valueForKey:@"access_level"] intValue];
                                                                               
                                                                               if(access_level == 2){
                                                                                   [defaults setBool:true forKey:@"isSquadLite"];
                                                                                   [defaults setBool:true forKey:@"CompletedStartupChecklist"];
                                                                               }else{
                                                                                   [defaults setBool:false forKey:@"isSquadLite"];
                                                                               }
                                                                               
                                                                               if(![Utility isEmptyCheck:sessionDetailDict[@"LifeToken"]]){
                                                                                   
                                                                                   NSMutableDictionary *dict = [NSMutableDictionary new];
                                                                                   [dict setObject:sessionDetailDict[@"LifeToken"] forKey:@"LifeToken"];
                                                                                   [dict setObject:[NSDate date] forKey:@"ExpiryDate"];
                                                                                   
                                                                                   [defaults setObject:dict forKey:@"LifeTokenDetails"];
                                                                                   
                                                                               }
                                                                               
                                                                               int signupVia = [[sessionDetailDict objectForKey:@"SignupMethod"] intValue];
                                                                               
                                                                               [defaults setObject:[NSNumber numberWithInt:signupVia] forKey:@"SignupVia"];
                                                                               
                                                                               [Utility loginToChatSDK:sessionDetailDict isFb:false];
                                                                               
                                                                               [AppDelegate sendDeviceToken];
                                                                               [Utility communityLoginWebserviceCall];

                                                                               
                                                                               //ahn
                                                                               //[self setAfterSignupNotification];
                                                                               //ahn end
                                                                               if ([Utility isEmptyCheck:[defaults objectForKey:@"firstLoginDate"]]) {
                                                                                      [defaults setObject:[NSDate date] forKey:@"firstLoginDate"];
                                                                                }//AY 06042018
                                                                               
//                                                                               [self addDiscoverablePoints];
//                                                                               [self setQuoteNotification];//Quote
                                                                               NSArray * purchasePrograArr;
                                                                               if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"PurchasedPrograms"]]) {
                                                                                   purchasePrograArr = [responseDictionary objectForKey:@"PurchasedPrograms"];
                                                                               }
                                                                               
                                                                               if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"IsSubscribed"]] && ![[responseDictionary objectForKey:@"IsSubscribed"]boolValue] && purchasePrograArr.count>0) {
                                                                                   [defaults setBool:true forKey:@"IsSubscribed"];
                                                                                 
                                                                                   NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                                                                                   NSDictionary *sessionDict = [responseDictionary objectForKey:@"SessionDetail"];
                                                                                   [dict setObject:[sessionDict objectForKey:@"FirstName"]forKey:@"FirstName"];
                                                                                   [dict setObject:[sessionDict objectForKey:@"LastName"]forKey:@"LastName"];
                                                                                   [dict setObject:[sessionDict objectForKey:@"Password"]forKey:@"Password"];
                                                                                   [dict setObject:[sessionDict objectForKey:@"EmailAddress"]forKey:@"Email"];
                                                                                   [defaults setObject:dict forKey:@"OnlyProgramMember"];

                                                                               }else{
                                                                                   [defaults setBool:NO forKey:@"IsSubscribed"];
                                                                                   
                                                                               }
                                                                           
                                                                               if (![[sessionDetailDict objectForKey:@"IsPasswordUpdated"]boolValue]) {                   self->passwordUpdateView.hidden = false;
                                                                               }else{
                                                                                     self->passwordUpdateView.hidden = true;
                                                                                   
                                                                                     if ([Utility isOnlyProgramMember]) {
                                                                                           ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
                                                                                            CoursesListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CoursesList"];
                                                                                            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                                                                                            slider.topViewController = nav;
                                                                                            [slider resetTopViewAnimated:NO];
                                                                                             [self.navigationController pushViewController:slider animated:NO];
                                                                                     }else{
                                                                                         if ([[sessionDetailDict objectForKey:@"IsFirstLogon"]boolValue]) {
                                                                                              ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
                                                                                              SquadInfoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SquadInfoView"];
                                                                                              NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                                                                                              slider.topViewController = nav;
                                                                                              [slider resetTopViewAnimated:NO];
                                                                                               [self.navigationController pushViewController:slider animated:NO];
                                                                                           }else{
                                                                                             
                                                                                              ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
                                                                                               HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
                                                                                               controller.isMovedToToday = self->isMovedToToday;
                                                                                              NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                                                                                               slider.topViewController = nav;
                                                                                              [slider resetTopViewAnimated:NO];
                                                                                              [self.navigationController pushViewController:slider animated:NO];
                                                                                            }
                                                                                     }
                                                                               }
                                                                           }else{
//                                                                               [Utility msg:responseString title:@"Error !" controller:self haveToPop:NO];
                                                                                 [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
-(void)sendFbToken{
   
    NSString *fbToken =[defaults objectForKey:@"facebookTokenString"];
    NSString *email = emailTextField.text;
    NSString *password = passwordTextField.text;
    if(![Utility isEmptyCheck:email]){
        if (![Utility validateEmail:email]) {
            [Utility msg:@"Please enter a valid email." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        
    }else{
        [Utility msg:@"Please enter your email." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
//    if([Utility isEmptyCheck:password]){
//        [Utility msg:@"Please enter your password." title:@"Oops" controller:self haveToPop:NO];
//        return;
//    }
    if (![Utility isEmptyCheck:fbToken]) {
        if (Utility.reachable) {
             //[Utility logoutChatSdk];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
                self->contentView = [Utility activityIndicatorView:self];
            });
            NSURLSession *loginSession = [NSURLSession sharedSession];
            
            NSError *error;
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            [mainDict setObject:AccessKey forKey:@"Key"];
            [mainDict setObject:fbToken forKey:@"FbToken"];//FacebookToken
            [mainDict setObject:email forKey:@"Email"];//EmailAddress
            [mainDict setObject:password forKey:@"Password"];
            [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IncludeAbbbcOnline"];
            
            if([FIRMessaging messaging].FCMToken){
                [mainDict setObject:[FIRMessaging messaging].FCMToken forKey:@"FirebaseIosToken"];
            }
            
            
            //Added on AY 17042018
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            if(![Utility isEmptyCheck:version]){
                [mainDict setObject:version forKey:@"AppVersion"];
            }
            [mainDict setObject:@"ios" forKey:@"AppPlatform"];
            //End

            NSLog(@"%@",[self identifierForAdvertising]);

            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"LogInApiCall" append:@"" forAction:@"POST"];
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
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                             for (NSString *key in [responseDictionary allKeys]) {
                                                                                 if ([[responseDictionary objectForKey:key] class] ==[NSNull class]) {
                                                                                     [responseDictionary removeObjectForKey:key];
                                                                                 }
                                                                             }
                                                                             
                                                                             BOOL isVersionMisMatch = [[responseDictionary valueForKey:@"IsVersionMismatch"] boolValue];
                                                                             
                                                                             if(isVersionMisMatch){
                                                                                 [self showAppUpdateAlert:self latestApversion:0.0];
                                                                                 return;
                                                                             }
                                                                             
                                                                              [Utility cancelscheduleLocalNotificationsForFreeUser]; //AY 19022018
                                                                             
                                                                             self->emailTextField.text = @"";
                                                                             self->passwordTextField.text = @"";
                                                                             [Utility updateLeanPlumUserAttributes:responseDictionary]; //AmitY 13-06-2017
                                                                             
                                                                             //Added For Firebase Login Tracking AY 15012018
                                                                             [FIRAnalytics logEventWithName:@"squad_login" parameters:@{
                                                                                                                                        @"email": [responseDictionary valueForKey:@"EmailAddress"],
                                                                                                                                        @"type": @"facebook"
                                                                                                                                        }];
                                                                             //End
                                                                             
                                                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
                                                                             
                                                                             if([defaults boolForKey:@"IsNonSubscribedUser"]){
                                                                                 [Utility logoutChatSdk];
                                                                             }
                                                                             
                                                                             [defaults setBool:[[responseDictionary valueForKey:@"isLimeLightUser"] boolValue] forKey:@"isLimeLightUser"];
                                                                             
                                                                             [defaults setObject:[responseDictionary valueForKey:@"ActiveUntil"] forKey:@"TempTrialEndDate"];
                                                                             [defaults setObject:nil forKey:@"taskListArray"];
                                                                             
                                                                              [defaults setBool:YES forKey:@"CompletedStartupChecklist"]; //AmitY
                                                                             
                                                                             [defaults setBool:false forKey:@"IsNonSubscribedUser"];
                                                                             [defaults setObject:[responseDictionary valueForKey:@"EmailAddress"] forKey:@"Email"];
                                                                             [defaults   setObject:password forKey:@"Password"];
                                                                             [defaults setObject:responseDictionary forKey:@"LoginData"];
                                                                             [defaults setObject:[responseDictionary valueForKey:@"UserID"] forKey:@"UserID"];
                                                                             [defaults setObject:[responseDictionary valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
                                                                             [defaults setObject:[responseDictionary valueForKey:@"ABBBCOnlineUserId"] forKey:@"ABBBCOnlineUserId"];
                                                                             
                                                                             if(![Utility isEmptyCheck:responseDictionary[@"ProfilePicUrl"]]){
                                                                                 [defaults setObject:responseDictionary[@"ProfilePicUrl"] forKey:@"ProfilePicUrl"];
                                                                             }
                                                                             
                                                                             [defaults setObject:[responseDictionary valueForKey:@"FirstName"] forKey:@"FirstName"];//add24
                                                                             
                                                                             [defaults setObject:[responseDictionary valueForKey:@"LastName"] forKey:@"LastName"];//Added by AY 25042018
                                                                             
                                                                             [defaults setObject:[responseDictionary valueForKey:@"ABBBCOnlineUserSessionId"] forKey:@"ABBBCOnlineUserSessionId"];
                                                                             
                                                                             [defaults setObject:[responseDictionary valueForKey:@"FbWorldForumUrl"] forKey:@"FbWorldForumUrl"];
                                                                             [defaults setObject:[responseDictionary valueForKey:@"FbCityForumUrl"] forKey:@"FbCityForumUrl"];
                                                                             [defaults setObject:[responseDictionary valueForKey:@"FbSuburbForumUrl"] forKey:@"FbSuburbForumUrl"];
                                                                             
                                                                             NSString *disStat = ([[responseDictionary valueForKey:@"DiscoverableStatus"] boolValue]) ? @"yes" : @"no";
                                                                             [defaults setObject:disStat forKey:@"Discoverable"];
                                                                             [defaults setObject:[responseDictionary valueForKey:@"FirebaseToken"] forKey:@"FirebaseToken"];
                                                                             
                                                                             int access_level = [[responseDictionary valueForKey:@"access_level"] intValue];
                                                                             
                                                                             if(access_level == 2){
                                                                                 [defaults setBool:true forKey:@"isSquadLite"];
                                                                                 [defaults setBool:true forKey:@"CompletedStartupChecklist"];
                                                                             }else{
                                                                                 [defaults setBool:false forKey:@"isSquadLite"];
                                                                             }
                                                                             
                                                                             if(![Utility isEmptyCheck:responseDictionary[@"LifeToken"]]){
                                                                                 
                                                                                 NSMutableDictionary *dict = [NSMutableDictionary new];
                                                                                 [dict setObject:responseDictionary[@"LifeToken"] forKey:@"LifeToken"];
                                                                                 [dict setObject:[NSDate date] forKey:@"ExpiryDate"];
                                                                                 
                                                                                 [defaults setObject:dict forKey:@"LifeTokenDetails"];
                                                                                 
                                                                             }
                                                                             
                                                                             int signupVia = [[responseDictionary objectForKey:@"SignupMethod"] intValue];
                                                                             
                                                                             [defaults setObject:[NSNumber numberWithInt:signupVia] forKey:@"SignupVia"];
                                                                             
                                                                             [Utility loginToChatSDK:responseDictionary isFb:true];
                                                                            [AppDelegate sendDeviceToken];
                                                                             
                                                                             //ahn
                                                                             //[self setAfterSignupNotification];
                                                                             //ahn end
                                                                             
                                                                             [self addDiscoverablePoints];
                                                                             [self setQuoteNotification];//Quote

                                                                             
                                                                             ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
                                                                             HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
                                                                             controller.isMovedToToday = self->isMovedToToday;
                                                                             NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                                                                             slider.topViewController = nav;
                                                                             [slider resetTopViewAnimated:NO];
                                                                             [self.navigationController pushViewController:slider animated:NO];
                                                                         }else{
                                                                             [defaults setBool:false forKey:@"IsFbUser"];
                                                                             emailTextField.text = @"";
                                                                             passwordTextField.text = @"";
                                                                             if (![Utility isEmptyCheck:responseString]) {
                                                                                 [Utility msg:responseString title:@"Error !" controller:self haveToPop:NO];
                                                                             }else{
                                                                                 [Utility msg:@"Facebook session expired." title:@"Error !" controller:self haveToPop:NO];
                                                                             }
                                                                             return;
                                                                         }
                                                                         
                                                                     }else{
                                                                         [defaults setBool:false forKey:@"IsFbUser"];
                                                                         [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                     }
                                                                 });
                                                             }];
            [dataTask resume];
            
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }else{
        [Utility msg:@"Somthing went wrong" title:@"Oops" controller:self haveToPop:NO];
        return;
    }
}
- (IBAction)purchasedErrorButtonPressed:(UIButton *)sender {
    
    NSString *email = emailTextField.text;
    
    if([Utility isEmptyCheck:email] || ![Utility validateEmail:email]){
        [Utility msg:@"Please enter a valid email." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
    
    if (Utility.reachable) {
        
        NSString *commonErrorMsg = @"Please email customercare@mindbodyhq.com to have your issue fixed with 48 hours";
        
        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
        
        if (!receipt) {
            [Utility msg:commonErrorMsg title:@"" controller:self haveToPop:NO];
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
                  NSDictionary *inappDict = [NSJSONSerialization JSONObjectWithData:inAppData options:0 error:nil];
                  if (![Utility isEmptyCheck:emailTextField.text] && ![Utility isEmptyCheck:[[inappDict objectForKey:@"Model"]objectForKey:@"Email"]]) {
                                if ([emailTextField.text isEqualToString:[[inappDict objectForKey:@"Model"]objectForKey:@"Email"]]) {
                                    [mainDict setObject:inappDict forKey:@"MbhqRegistrationDetails"];
                                }
                   }
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
                                                                         
                                                                         [Utility msg:@"Request has been sent to support." title:@"" controller:self haveToPop:NO];
 
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


#pragma mark - End -

#pragma mark - ViewLifeCycle -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    subscriptionAlertSubview.layer.cornerRadius=10;
    subscriptionAlertSubview.layer.masksToBounds=YES;
    updateNowButton.layer.cornerRadius = 20;
    updateNowButton.layer.masksToBounds = YES;
    
    
    
    
    if(![Utility isEmptyCheck:_initialEmail]){
        emailTextField.text = _initialEmail;
    }
//       toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//       toolBar.barStyle = UIBarStyleBlackOpaque;
//       toolBar.translucent = YES;
//       UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"LET'S GO!"
//                                                                style:UIBarButtonItemStylePlain
//                                                               target:nil
//                                                               action:@selector(btnClickedDone:)];
//
//       UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                                                               target:nil
//                                                                               action:nil];
//
//       NSArray *items = [[NSArray alloc] initWithObjects:spacer, item, spacer, nil];
//       [toolBar setItems:items];
       UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
       [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    
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
    AppDelegate *appDelegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
    appDelegate._tokenDelegate = self;
    [self registerForKeyboardNotifications];
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        bgImage.image = [UIImage imageNamed:@"background1-4s.png"];
    }else{
        bgImage.image = [UIImage imageNamed:@"background1.png"];
    }
//    [emailTextField setValue:[UIColor whiteColor]
//                    forKeyPath:@"_placeholderLabel.textColor"];
//    [passwordTextField setValue:[UIColor whiteColor]
//                    forKeyPath:@"_placeholderLabel.textColor"];
    if (![Utility isEmptyCheck:[defaults objectForKey:@"LoginData"]] && ![Utility isEmptyCheck:[defaults objectForKey:@"UserID"]] && ![Utility isEmptyCheck:[defaults objectForKey:@"UserSessionID"]]) {
        //        ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
        //        if ([defaults boolForKey:@"isHelpDisplayed"]) {
        //            HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
        //            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        //            slider.topViewController = nav;
        //
        //        }else{
        //            HelpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Help"];
        //            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        //            slider.topViewController = nav;
        //        }
        //        [self.navigationController pushViewController:slider animated:YES];
        NSLog(@"%@",[defaults objectForKey:@"LoginData"]);
        emailTextField.text = [defaults objectForKey:@"Email"];
        passwordTextField.text = [defaults objectForKey:@"Password"];
        signUpButton.hidden = false;
        if ([defaults boolForKey:@"IsFbUser"]) {
            if(![Utility isEmptyCheck:[defaults objectForKey:@"facebookTokenString"]]){
                [self sendFbToken];
            }
        }else{
            [self loginButtonPressed:nil];
        }
        
    }else if(isFromSignUp){
        emailTextField.text = [defaults objectForKey:@"Email"];
        passwordTextField.text = [defaults objectForKey:@"Password"];
        [Utility communityUpdateUserDataWebserviceCall];

        signUpButton.hidden = true;
        if ([defaults boolForKey:@"IsFbUser"]) {
            if(![Utility isEmptyCheck:[defaults objectForKey:@"facebookTokenString"]]){
                [self sendFbToken];
            }
        }else{
            [self loginButtonPressed:nil];
        }
    }else{
        signUpButton.hidden = false;
    }
    
    for(UIView *view in roundedView){
        view.layer.cornerRadius = 20.0;
        view.clipsToBounds = YES;
        view.layer.borderColor = squadMainColor.CGColor;
        view.layer.borderWidth = 1;
    }
    updatepasswordTextField.layer.borderColor = squadMainColor.CGColor;
    updatepasswordTextField.layer.borderWidth = 1;
    updatepasswordTextField.layer.cornerRadius = 15;
    updatepasswordTextField.layer.masksToBounds = YES;
    updatePasswordButton.layer.cornerRadius = 15;
    updatePasswordButton.layer.masksToBounds = YES;
    NSDictionary *dict = [defaults objectForKey:@"NonSubscribedUserData"];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd"];
    if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:[defaults objectForKey:@"TempTrialEndDate"]]) {
        if ([[df dateFromString:[defaults objectForKey:@"TempTrialEndDate"]] isLaterThanOrEqualTo:[df dateFromString:[df stringFromDate:[NSDate date]]]]) {
            emailTextField.text = [dict objectForKey:@"Email"];
            passwordTextField.text = [dict objectForKey:@"Password"];
            signUpButton.hidden = false;
            if ([defaults boolForKey:@"IsFbUser"]) {
                if(![Utility isEmptyCheck:[defaults objectForKey:@"facebookTokenString"]]){
                    [self sendFbToken];
                }
            }else{
                [self loginButtonPressed:nil];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] addObserverForName:@"forgetApiSuceessAlert" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        [Utility msg:@"Reset url is sent to your email successfully.Please check your email." title:@"Success" controller:self haveToPop:NO];

    }];
 
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    passwordUpdateView.hidden = true;
    self->subscriptionAlertView.hidden=true;

    emailTextField.layer.cornerRadius = 20;
    emailTextField.layer.masksToBounds = YES;
    passwordTextField.layer.cornerRadius = 20;
    passwordTextField.layer.masksToBounds = YES;
    //emailTextField.layer.borderColor = [Utility colorWithHexString:mbhqBaseColor].CGColor;
    //emailTextField.layer.borderWidth = 1;
   // passwordTextField.layer.borderColor =[Utility colorWithHexString:mbhqBaseColor].CGColor;
   // passwordTextField.layer.borderWidth = 1;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, emailTextField.frame.size.height)];
    emailTextField.leftView = paddingView;
    emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, passwordTextField.frame.size.height)];
    passwordTextField.leftView = paddingView1;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, updatepasswordTextField.frame.size.height)];
    updatepasswordTextField.leftView = paddingView2;
    updatepasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    if (isFromAppDelegate) {
        backButton.hidden = true;
    }else{
        backButton.hidden = false;
    }
    
    if(isFromSignUp){
        signUpButton.hidden = true;
    }else{
        signUpButton.hidden = false;
    }
    

}
#pragma mark - End -

#pragma mark - MemoryWarning -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - End -


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
    // Store the data
//    if (activeTextField == emailTextField) {
//        [passwordTextField becomeFirstResponder];
//    }
//    else if (activeTextField == passwordTextField){
//        //[self loginButtonPress:nil];
//        [textField resignFirstResponder];
//    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    [activeTextField setInputAccessoryView:toolBar];
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
#pragma mark - TokenDelegate
-(void)tokenRceived{
    [AppDelegate sendDeviceToken];
}
#pragma mark - End
@end
