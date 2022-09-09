//  Utility.m
//  The Life
//
//  Created by AQB Solutions-Mac Mini 2 on 09/06/2016.
//  Copyright (c) 2016 AQB Solutions-Mac MacBookAir. All rights reserved.
//

#import "Utility.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"    //ah edit add these files
#import "SignupWithEmailViewController.h"
#import "SevenDayTrialViewController.h"
#import "CustomAlertViewController.h"
#import "BadgePopUpViewController.h" //gami_badge_popup

#import "LoginController.h"
#import "InitialViewController.h"

//chayan
#import "HelpVideoPlayerViewController.h"
#import "NonSubscribedAlertViewController.h"
#import "GratitudePopUpViewController.h"
#define errorTitleArray @[@"opps",@"oops",@"oops!",@"oops !",@"error !",@"error",@"error!",@"oops!\n"] //Added on AY 17042018

AMPopTip *popTip;   //ah
NSInteger overlayCount = 0; //ah ov
NSArray *totalOverlayedViews;   //ah ov
UIView *overlayContentView;   //ah ov
BOOL buttonFlashing = false;

@implementation Utility
@synthesize session, downloadTask, audioNameArray, audioDownloadCount;

#pragma mark- Custom Alert Controller Delegate
+(void)sendActionToController:(UIViewController *)sender isSubscribed:(BOOL)isSubscribed ofType:(UIViewController *)ofType isDowngrade:(BOOL)isDowngrade isUpgrade:(BOOL)isUpgrade{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (isSubscribed) {
        
        if([Utility isSquadLiteUser] || isDowngrade || isUpgrade){
           
            
        }else{
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
            if([sender isKindOfClass:[UINavigationController class]]){
                UINavigationController *nav = (UINavigationController *)sender;
                [nav pushViewController:signupController animated:YES];
            }else if([sender isKindOfClass:[MasterMenuViewController class]]){
                MasterMenuViewController *master = (MasterMenuViewController *)sender;
                [master.transitionsNavigationController pushViewController:signupController animated:YES];
            }else{
                [sender.navigationController pushViewController:signupController animated:YES];
            }
        }
        
    }else{
        SevenDayTrialViewController *trail=[storyboard instantiateViewControllerWithIdentifier:@"SevenDayTrial"];
        trail.isFromFb = NO;
        trail.ofType = ofType;
        if([sender isKindOfClass:[UINavigationController class]]){
            UINavigationController *nav = (UINavigationController *)sender;
            [nav pushViewController:trail animated:YES];
        }else if([sender isKindOfClass:[MasterMenuViewController class]]){
            MasterMenuViewController *master = (MasterMenuViewController *)sender;
            [master.transitionsNavigationController pushViewController:trail animated:YES];
        }else{
            NSLog(@"%@",sender);
            [sender.navigationController pushViewController:trail animated:YES];
        }
    }
}


+(void)redirectToAppstore{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:APPSTORE_URL]]){
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_URL] options:@{} completionHandler:^(BOOL success) {
                            if(success){
                                NSLog(@"Opened");
                                }
                            }];
    }
}

+ (void) sendActionToControllerForTrialUser:(UIViewController *)sender ofType:(UIViewController *)ofType{
    BOOL isTrialAvail = [defaults boolForKey:@"HasTrialAvail"];
    if(isTrialAvail && [self isSevenDaysCrossedFromInstallation])
    {
        
        NSString *redirectUrl = @"https://www.ashybines.com/squad50off/index";
        
        if(![Utility isEmptyCheck:[defaults valueForKey:@"UserID"]]){
            redirectUrl = [@"" stringByAppendingFormat:@"%@?userId=%@",redirectUrl,[defaults valueForKey:@"UserID"]];
        }
        
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:redirectUrl]]){
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl] options:@{} completionHandler:^(BOOL success) {
        if(success){
            NSLog(@"Opened");
            }
        }];
        }
    }else{
        [defaults setObject:[NSDate date] forKey:@"TrialStartDate"];
        [defaults setObject:[NSDate date] forKey:@"QuoteStartDate"];
        //[defaults setBool:NO forKey:@"CompletedStartupChecklist"]; //AmitY
        [defaults setBool:YES forKey:@"CompletedStartupChecklist"]; //AmitY
        [defaults setBool:YES forKey:@"HasTrialAvail"];
        
        [AppDelegate updateTrialStartDate];
        
        [Utility cancelscheduleLocalNotificationsForFreeUser];
        [Utility cancelscheduleLocalNotificationsForQuote];
        [AppDelegate scheduleLocalNotificationsForFreeUser];
        [AppDelegate scheduleLocalNotificationsForQuote:![defaults boolForKey:@"isInitialQuoteSet"]];
        
        //        if([sender isKindOfClass:[HomePageViewController class]]){
        //            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHomePage" object:nil];
        //        }else{
        //        [sender.navigationController popToRootViewControllerAnimated:YES];
        //        }
        
        // [Utility showTrialWelcomeAlert:sender];
        [CustomNavigation startNavigation:sender fromMenu:NO navDict:@{@"Identifier":@"AfterTrial",@"isTrail":@true}];
        
    }
    
}

+ (void)redirectionForInappPromo:(UIViewController *)sender withData:(NSDictionary *)data{
    
    if(![Utility isEmptyCheck:data[@"fromController"]]){
        NSString *redirectUrl = data[@"fromController"];
        
        if(![Utility isEmptyCheck:[defaults valueForKey:@"UserID"]]){
            redirectUrl = [@"" stringByAppendingFormat:@"%@?userId=%@",redirectUrl,[defaults valueForKey:@"UserID"]];
        }
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:redirectUrl]]){
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl] options:@{} completionHandler:^(BOOL success) {
        if(success){
            NSLog(@"Opened");
            }
        }];
        }
    }
}

+ (void) welcomeAlertAction:(UIViewController *)sender{
    
}

+ (void) redirectionForSetProgram:(UIViewController *)sender withData:(NSDictionary *)data{
    
    NSString *redirectUrl = @"https://www.ashybines.com/squad50off/index";
    if(![Utility isEmptyCheck:data[@"Url"]]){
        redirectUrl = data[@"Url"];
    }
    
    if(![Utility isEmptyCheck:[defaults valueForKey:@"UserID"]]){
        redirectUrl = [@"" stringByAppendingFormat:@"%@?userId=%@",redirectUrl,[defaults valueForKey:@"UserID"]];
    }
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:redirectUrl]]){
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl] options:@{} completionHandler:^(BOOL success) {
        if(success){
            NSLog(@"Opened");
            }
        }];
        }
    
}
+ (void) redirectionForUpgrade:(UIViewController *)sender{
    NSString *redirectUrl =@"";
    if(![Utility isEmptyCheck:[defaults valueForKey:@"UserID"]]){
        redirectUrl = [@"" stringByAppendingFormat:@"%@/home/MbhqRedirect?mode=signup&userId=%@",BASEURL,[defaults valueForKey:@"UserID"]];
    }
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:redirectUrl]]){
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl] options:@{} completionHandler:^(BOOL success) {
        if(success){
            NSLog(@"Opened");
            }
        }];
    }
    
}
+ (void)redirectionToLogin:(UIViewController *)sender{
    
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
    
    InitialViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InitialView"];
    controller.openLoginView = true;
    
    if([sender isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)sender;
        [nav pushViewController:controller animated:YES];
    }else if([sender isKindOfClass:[MasterMenuViewController class]]){
        MasterMenuViewController *master = (MasterMenuViewController *)sender;
        [master.transitionsNavigationController pushViewController:controller animated:YES];
    }else{
        NSLog(@"%@",sender);
        [sender.navigationController pushViewController:controller animated:YES];
    }
}
+ (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60; int minutes = (totalSeconds / 60) % 60; int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d",hours, minutes];//[NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds]
}
+(NSString *)strFromDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd'T'HH:mm:ss
    NSString *str =[formatter stringFromDate:date];
    NSString *dateStr = [@"" stringByAppendingFormat:@"%@T00:00:00",str];
    return dateStr;
}
+(int)weeksOfMonth:(int)month inYear:(int)year{
    NSString *dateString=[NSString stringWithFormat:@"%4d/%d/1",year,month];

    NSDateFormatter *dfMMddyyyy=[NSDateFormatter new];
    [dfMMddyyyy setDateFormat:@"yyyy/MM/dd"];
    NSDate *date=[dfMMddyyyy dateFromString:dateString];

    NSCalendar *calender = [NSCalendar currentCalendar];
    [calender setFirstWeekday:2];
    NSRange weekRange = [calender rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:date];
    int weeksCount=(int)weekRange.length;

    return weeksCount;
}
#pragma mark- End
+(void)showNonSubscribedAlert:(UIViewController *)parent sectionName:(NSString *)sectionName{
    NonSubscribedAlertViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NonSubscribedAlert"];
    controller.sectionName=sectionName;
    controller.parent = parent;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [parent presentViewController:controller animated:YES completion:nil];
}

+(void)showAlertAfterSevenDayTrail:(UIViewController *)controller{
    BOOL isTrialAvail = [defaults boolForKey:@"HasTrialAvail"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomAlertViewController *custom=[storyboard instantiateViewControllerWithIdentifier:@"CustomAlert"];
    custom.modalPresentationStyle = UIModalPresentationCustom;
    custom.alertTitleString = @"HEY GORGEOUS";
    //custom.alertMsgString = @"Hey Gorgeous,\nThank you so much for trialling SQUAD.\nWe hope you absolutely LOVED it as much as we do!\nTo gain access to the entire SQUAD app including the community forum and complete 7 Step System, all you need to do is SIGN UP here and chose one of our affordable member options.";
    custom.alertMsgString = @"This amazing feature is for full members only.";
    
    custom.delegate = self;
    custom.isSubscribed = YES;
    custom.fromContoller = controller;
    custom.haveToShowCross = YES;
    custom.trialUserAlert = YES;
    custom.isShowBottomAlert = YES;
    custom.loginButton.hidden = YES;
    //custom.actionButtonTitleString = @"SIGN UP NOW";
//    if(isTrialAvail && [self isSevenDaysCrossedFromInstallation]){
//        custom.actionButtonTitleString = @"GET ACCESS NOW!";
//    }else{
//        custom.actionButtonTitleString = @"TRIAL IT NOW FOR 7 DAYS";
//    }
    custom.actionButtonTitleString =@"PURCHASE NOW";
    if([controller isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)controller;
        [nav presentViewController:custom animated:YES completion:nil];
    }else if([controller isKindOfClass:[MasterMenuViewController class]]){
        MasterMenuViewController *master = (MasterMenuViewController *)controller;
        [master.transitionsNavigationController presentViewController:custom animated:YES completion:nil];
    }else{
        [controller presentViewController:custom animated:YES completion:nil];
    }
    
}
+(void)showTrailLoginAlert:(UIViewController *)controller ofType:(UIViewController *)ofType{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomAlertViewController *custom=[storyboard instantiateViewControllerWithIdentifier:@"CustomAlert"];
    custom.modalPresentationStyle = UIModalPresentationCustom;
    custom.alertTitleString = @"Alert!";
    custom.alertMsgString = @"Hey!\nThis awesome feature requires a name and email so it can be customised to your needs.";
    custom.delegate = self;
    custom.isSubscribed = NO;
    custom.fromContoller = controller;
    custom.ofType = ofType;
    custom.haveToShowCross=YES;
    
    custom.actionButtonTitleString = @"ADD EMAIL NOW";
    if([controller isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)controller;
        [nav presentViewController:custom animated:YES completion:nil];
    }else if([controller isKindOfClass:[MasterMenuViewController class]]){
        MasterMenuViewController *master = (MasterMenuViewController *)controller;
        [master.transitionsNavigationController presentViewController:custom animated:YES completion:nil];
    }else{
        [controller presentViewController:custom animated:YES completion:nil];
    }
}
+(void)showSubscribedAlert:(UIViewController *)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomAlertViewController *custom=[storyboard instantiateViewControllerWithIdentifier:@"CustomAlert"];
    custom.modalPresentationStyle = UIModalPresentationCustom;
    /*if([Utility isSquadLiteUser]){
     custom.alertTitleString = @"Unlock Now";
     custom.alertMsgString = @"Hey!\nYou've clicked on an awesome feature.\nClick OK to gain access to the entire Squad app NOW\nOr click 'cancel' to keep using the limited version.";
     }else{
     custom.alertTitleString = @"Members Only!";
     custom.alertMsgString = @"Hey!\nYou've clicked on an awesome members ONLY feature.\nClick OK to gain access to the entire Squad app NOW\nOr click 'cancel' to keep using the limited trial version.";
     }*/
    
    custom.alertTitleString = @"HEY GORGEOUS";
    custom.alertMsgString = @"This program is not available to trial but can be purchased here.";
    
    custom.delegate = self;
    custom.isSubscribed = YES;
    custom.fromContoller = controller;
    custom.actionButtonTitleString = @"SIGN UP NOW";
    custom.haveToShowCross=NO;
    custom.isShowBottomAlert = YES;
    if([controller isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)controller;
        [nav presentViewController:custom animated:YES completion:nil];
    }else if([controller isKindOfClass:[MasterMenuViewController class]]){
        MasterMenuViewController *master = (MasterMenuViewController *)controller;
        [master.transitionsNavigationController presentViewController:custom animated:YES completion:nil];
    }else{
        [controller presentViewController:custom animated:YES completion:nil];
    }
}

+(void)showUpgradeDowngradeAlert:(UIViewController *)controller isDowngrade:(BOOL)isDowngrade isUpgrade:(BOOL)isUpgrade{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomAlertViewController *custom=[storyboard instantiateViewControllerWithIdentifier:@"CustomAlert"];
    custom.modalPresentationStyle = UIModalPresentationCustom;
    
    custom.alertTitleString = @"Cancel Subscription!";
    
    if(isDowngrade){
        custom.alertMsgString = @"You have signed up for Squad through the app store. To cancel, simply go to the store settings in your phone and cancel your subscription at any time OR downgrade your subscription to Squad Lite.\nClick OK to downgrade now.";
        
    }else if(isUpgrade){
        custom.alertMsgString = @"You have signed up for Squad through the app store. To cancel, simply go to the store settings in your phone and cancel your subscription at any time OR downgrade your subscription to Squad Lite.\nClick OK to upgrade now.";
    }
    
    custom.delegate = self;
    custom.isSubscribed = YES;
    custom.fromContoller = controller;
    custom.actionButtonTitleString = @"OK";
    
    
    custom.haveToShowCross=NO;
    custom.isDowngrade = isDowngrade;
    custom.isUpgrade = isUpgrade;
    if([controller isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)controller;
        [nav presentViewController:custom animated:YES completion:nil];
    }else if([controller isKindOfClass:[MasterMenuViewController class]]){
        MasterMenuViewController *master = (MasterMenuViewController *)controller;
        [master.transitionsNavigationController presentViewController:custom animated:YES completion:nil];
    }else{
        [controller presentViewController:custom animated:YES completion:nil];
    }
}

+(void)showAlertForAppUpdate:(UIViewController *)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomAlertViewController *custom=[storyboard instantiateViewControllerWithIdentifier:@"CustomAlert"];
    custom.modalPresentationStyle = UIModalPresentationCustom;
    custom.alertTitleString = @"UPDATE AVAILABLE";
    custom.alertMsgString = @"Hey Gorgeous,\nA new version of SQUAD is available in app store. Please update to latest version now.";
    custom.delegate = self;
    custom.isSubscribed = YES;
    custom.fromContoller = controller;
    custom.haveToShowCross = NO;
    custom.isAppstoreAlert = YES;
    
    custom.actionButtonTitleString = @"UPDATE NOW";
    [custom.cancelButton setTitle:@"NEXT TIME" forState:UIControlStateNormal];
    
    if([controller isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)controller;
        [nav presentViewController:custom animated:YES completion:nil];
    }else if([controller isKindOfClass:[MasterMenuViewController class]]){
        MasterMenuViewController *master = (MasterMenuViewController *)controller;
        [master.transitionsNavigationController presentViewController:custom animated:YES completion:nil];
    }else{
        [controller presentViewController:custom animated:YES completion:nil];
    }
    
}

+(void)showProfileEditRestrictionAlert:(UIViewController *)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomAlertViewController *custom=[storyboard instantiateViewControllerWithIdentifier:@"CustomAlert"];
    custom.modalPresentationStyle = UIModalPresentationCustom;
    
    custom.alertTitleString = @"Unlock Now";
    custom.alertMsgString = @"Hey!\nYou've clicked on an awesome feature.Click OK to Sign Up and edit your profile NOW Or click 'cancel' to keep using the Trial.";
    
    custom.delegate = self;
    custom.isSubscribed = YES;
    custom.fromContoller = controller;
    custom.actionButtonTitleString = @"OK";
    custom.haveToShowCross=NO;
    if([controller isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)controller;
        [nav presentViewController:custom animated:YES completion:nil];
    }else if([controller isKindOfClass:[MasterMenuViewController class]]){
        MasterMenuViewController *master = (MasterMenuViewController *)controller;
        [master.transitionsNavigationController presentViewController:custom animated:YES completion:nil];
    }else{
        [controller presentViewController:custom animated:YES completion:nil];
    }
}


+(void)cancelSubscriptionAlert:(UIViewController *)controller isWeb:(BOOL)isWeb{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomAlertViewController *custom=[storyboard instantiateViewControllerWithIdentifier:@"CustomAlert"];
    custom.modalPresentationStyle = UIModalPresentationCustom;
    
    custom.alertTitleString = @"";
    if(isWeb){
        custom.alertMsgString = @"Hi, please email customercare@mindbodyhq.com to cancel your paid membership.";
    }else{
        custom.alertMsgString = @"You have signed up for mindbodyHQ through the app store. To cancel, simply go to the store settings in your phone and cancel your subscription at any time.";
    }
    
    
    custom.delegate = self;
    custom.isSubscribed = YES;
    custom.fromContoller = controller;
    custom.actionButtonTitleString = @"OK";
    custom.haveToShowCross=NO;
    custom.isCancelSubsAlert = YES;
    custom.isShowBottomAlert = YES;
    
    if([controller isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)controller;
        [nav presentViewController:custom animated:YES completion:nil];
    }else if([controller isKindOfClass:[MasterMenuViewController class]]){
        MasterMenuViewController *master = (MasterMenuViewController *)controller;
        [master.transitionsNavigationController presentViewController:custom animated:YES completion:nil];
    }else{
        [controller presentViewController:custom animated:YES completion:nil];
    }
}

+(void)inAppPromoAlert:(UIViewController *)controller{
    
    NSArray *arr = [defaults objectForKey:@"InAppPromoArray"];
    //NSDate *lastShownDate = [defaults objectForKey:@"LastPromoShownDate"];
    
    if(![Utility isEmptyCheck:arr]){ //&& (!lastShownDate || (lastShownDate && ![lastShownDate isToday]))
        
        NSDictionary *dict = arr[0];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CustomAlertViewController *custom=[storyboard instantiateViewControllerWithIdentifier:@"CustomAlert"];
        custom.modalPresentationStyle = UIModalPresentationCustom;
        
        custom.alertTitleString = dict[@"title"];
        
        custom.alertMsgString = dict[@"body"];
        custom.delegate = self;
        custom.isSubscribed = YES;
        custom.fromContoller = controller;
        custom.actionButtonTitleString = dict[@"actionTitle"];
        custom.haveToShowCross=NO;
        custom.isInAppPromo = YES;
        custom.isShowBottomAlert = YES;
        custom.inAppPromoData = dict;
        
        if([controller isKindOfClass:[UINavigationController class]]){
            UINavigationController *nav = (UINavigationController *)controller;
            [nav presentViewController:custom animated:YES completion:nil];
        }else if([controller isKindOfClass:[MasterMenuViewController class]]){
            MasterMenuViewController *master = (MasterMenuViewController *)controller;
            [master.transitionsNavigationController presentViewController:custom animated:YES completion:nil];
        }else{
            [controller presentViewController:custom animated:YES completion:nil];
        }
        
        NSMutableArray *newArr = [[NSMutableArray alloc]initWithArray:arr];
        [newArr removeObject:dict];
        [newArr addObject:dict];
        [defaults setObject:newArr forKey:@"InAppPromoArray"];
        [defaults setObject:[NSNumber numberWithInt:0] forKey:@"LogoClickCount"];
        [defaults setObject:[NSDate date] forKey:@"LastPromoShownDate"];
        
    }
    
    
}
+(void)showTrialWelcomeAlert:(UIViewController *)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomAlertViewController *custom=[storyboard instantiateViewControllerWithIdentifier:@"CustomAlert"];
    custom.modalPresentationStyle = UIModalPresentationCustom;
    
    
    custom.alertTitleString = @"HEY GORGEOUS";
    custom.alertMsgString = @"Welcome to Your 7 Day Trial.\nIt's time to help you.";
    
    custom.delegate = self;
    custom.isSubscribed = YES;
    custom.fromContoller = controller;
    custom.actionButtonTitleString = @"ACHIEVE YOUR GOALS";
    custom.haveToShowCross=NO;
    custom.isShowBottomAlert = YES;
    custom.isWelcomeTrialAlert = YES;
    if([controller isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)controller;
        [nav presentViewController:custom animated:YES completion:nil];
    }else if([controller isKindOfClass:[MasterMenuViewController class]]){
        MasterMenuViewController *master = (MasterMenuViewController *)controller;
        [master.transitionsNavigationController presentViewController:custom animated:YES completion:nil];
    }else{
        [controller presentViewController:custom animated:YES completion:nil];
    }
}

+(void)showSetProgramSubscribedAlert:(UIViewController *)controller withData:(NSDictionary *)data{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomAlertViewController *custom=[storyboard instantiateViewControllerWithIdentifier:@"CustomAlert"];
    custom.modalPresentationStyle = UIModalPresentationCustom;
    
    custom.alertTitleString = @"HEY GORGEOUS";
    custom.alertMsgString = @"This program is not available to trial but can be purchased here.";
    
    custom.delegate = self;
    custom.isSubscribed = YES;
    custom.fromContoller = controller;
    custom.actionButtonTitleString = @"FIND OUT MORE";
    custom.haveToShowCross=NO;
    custom.isShowBottomAlert = YES;
    custom.setProgramData = data;
    custom.isSetProgramSubsAlert = YES;
    if([controller isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)controller;
        [nav presentViewController:custom animated:YES completion:nil];
    }else if([controller isKindOfClass:[MasterMenuViewController class]]){
        MasterMenuViewController *master = (MasterMenuViewController *)controller;
        [master.transitionsNavigationController presentViewController:custom animated:YES completion:nil];
    }else{
        [controller presentViewController:custom animated:YES completion:nil];
    }
}

+(BOOL)isSubscribedUser{
    BOOL subscribedUser = NO;
    if([self isSquadFreeUser]){
        return subscribedUser;
        
    }else if ((![self isEmptyCheck:[defaults objectForKey:@"UserID"]] && [[defaults objectForKey:@"UserID"] intValue] > -1 && ![self isEmptyCheck:[defaults objectForKey:@"UserSessionID"]] && [[defaults objectForKey:@"UserSessionID"] intValue] > -1 && ![self isSquadLiteUser]) || [defaults boolForKey:@"IsNonSubscribedUser"]) {
        subscribedUser  = YES;
    }
    return subscribedUser;
}
+(BOOL)isSevenDaysCrossedFromInstallation{
    BOOL crossed = NO;
    if (![self isEmptyCheck:[defaults objectForKey:@"TrialStartDate"]]) {
        NSDate *trialStartDate = [defaults objectForKey:@"TrialStartDate"];
        NSDate *currentDate= [NSDate date];
        if ([trialStartDate isLaterThan:currentDate] || [currentDate timeIntervalSinceDate:trialStartDate] > 7*24*60*60) {
            crossed  = YES;
            [defaults setBool:true forKey:@"CompletedStartupChecklist"]; //AmitY
        }
    }
    return crossed;
    
}
+(BOOL)isSquadLiteUser{
    return [defaults boolForKey:@"isSquadLite"];
}

+(BOOL)isSquadFreeUser{
    
    if([defaults boolForKey:@"IsNonSubscribedUser"] && [self isSevenDaysCrossedFromInstallation]){
        [defaults setBool:NO forKey:@"isOffline"];
        return YES;
    }else{
        return NO;
    }
    
}

+(BOOL)isOnlyProgramMember{
    return [defaults boolForKey:@"IsSubscribed"];
}
+(void) startFlashingbuttonForManualSort:(UIButton *)button{
    //if (buttonFlashing) return;
    // buttonFlashing = YES;
 
    button.hidden = false;
    button.alpha = 1.0f;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionRepeat |
     UIViewAnimationOptionAutoreverse |
     UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         button.alpha = 0.1f;
                     }
                     completion:^(BOOL finished){
                         // Do nothing
                         NSLog(@"/ Do nothing-------------------");
                     }];
   
}
+(void) startFlashingbutton:(UIButton *)button{
    //if (buttonFlashing) return;
    // buttonFlashing = YES;
    [button setBackgroundColor:squadMainColor];
    /*
    button.hidden = false;
    button.alpha = 1.0f;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionRepeat |
     UIViewAnimationOptionAutoreverse |
     UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         button.alpha = 0.1f;
                     }
                     completion:^(BOOL finished){
                         // Do nothing
                         NSLog(@"/ Do nothing-------------------");
                     }];
     */
}

+(void) stopFlashingbutton:(UIButton *)button{
    //if (!buttonFlashing) return;
    //buttonFlashing = NO;
    //button.hidden = true;
    [button setBackgroundColor:[UIColor grayColor]];
//    [UIView animateWithDuration:0.5
//                          delay:0.0
//                        options:UIViewAnimationOptionCurveEaseInOut |
//     UIViewAnimationOptionBeginFromCurrentState
//                     animations:^{
//                         button.alpha = 1.0f;
//                     }
//                     completion:^(BOOL finished){
//                         // Do nothing
//                     }];
}

+(void) stopFlashingbuttonForManual:(UIButton *)button{
    //if (!buttonFlashing) return;
    //buttonFlashing = NO;
    //button.hidden = true;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         button.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         // Do nothing
                     }];
}
+(Calorie *)ingredientCalorieCalculation:(float)quantity proteinPer100:(float)proteinPer100 fatPer100:(float)fatPer100 carbPer100:(float)carbPer100 alcoholPer100:(float)alcoholPer100 unit:(NSString *)unit conversionUnit:(NSString *)conversionUnit conversionFactor:(float)conversionFactor{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    Calorie *calc = [[Calorie alloc]init];
    float quantityGrams = quantity;
    if ([unit isEqualToString:conversionUnit])
        quantityGrams = quantity * 100 / (float)conversionFactor;
    calc.proteinGrams =[formatter numberFromString:[@"" stringByAppendingFormat:@"%f",quantityGrams * proteinPer100 /(float) 100]];
    calc.proteinCalories = [formatter numberFromString:[@"" stringByAppendingFormat:@"%f",[calc.proteinGrams floatValue] * CaloriePerProteinGram]];
    calc.fatGrams = [formatter numberFromString:[@"" stringByAppendingFormat:@"%f",(float)quantityGrams * fatPer100 /(float) 100]];
    calc.fatCalories = [formatter numberFromString:[@"" stringByAppendingFormat:@"%f",[calc.fatGrams floatValue] * CaloriePerFatGram]];
    calc.carbGrams = [formatter numberFromString:[@"" stringByAppendingFormat:@"%f",(float)quantityGrams * carbPer100 / (float)100]];
    calc.carbCalories =[formatter numberFromString:[@"" stringByAppendingFormat:@"%f",[calc.carbGrams floatValue]* CaloriePerCarbGram]];
    calc.alcoholGrams = [formatter numberFromString:[@"" stringByAppendingFormat:@"%f",(float)quantityGrams * alcoholPer100 /(float) 100]];
    calc.alcoholCalories = [formatter numberFromString:[@"" stringByAppendingFormat:@"%f",[calc.alcoholGrams floatValue] * CaloriePerAlcoholGram]];
    NSLog(@"=========%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@",calc.proteinGrams,calc.proteinCalories,calc.fatGrams,calc.fatCalories,calc.carbGrams,calc.carbCalories,calc.alcoholGrams,calc.alcoholCalories);
    return calc;
    
}
+(NSString *)totalCalories:(Calorie *)cals
{
    NSString *totalCal = [@"" stringByAppendingFormat:@"%ld",lroundf([cals.alcoholCalories floatValue] + [cals.proteinCalories floatValue] + [cals.fatCalories floatValue] + [cals.carbCalories floatValue])];
    return  totalCal;
}

+(Calorie *)ingredientCalorieCalculationDetails:(float)quantity proteinPer100:(float)proteinPer100 fatPer100:(float)fatPer100 carbPer100:(float)carbPer100 alcoholPer100:(float)alcoholPer100 unit:(NSString *)unit conversionUnit:(NSString *)conversionUnit conversionFactor:(float)conversionFactor{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    Calorie *calc = [[Calorie alloc]init];
    float quantityGrams = quantity;
    if ([unit isEqualToString:conversionUnit])
        quantityGrams = quantity * 100 / (float)conversionFactor;
    calc.proteinGrams =[formatter numberFromString:[@"" stringByAppendingFormat:@"%.2f",quantityGrams * proteinPer100 /(float) 100]];
    calc.proteinCalories = [formatter numberFromString:[@"" stringByAppendingFormat:@"%.2f",[calc.proteinGrams floatValue] * CaloriePerProteinGram]];
    calc.fatGrams = [formatter numberFromString:[@"" stringByAppendingFormat:@"%.2f",(float)quantityGrams * fatPer100 /(float) 100]];
    calc.fatCalories = [formatter numberFromString:[@"" stringByAppendingFormat:@"%.2f",[calc.fatGrams floatValue] * CaloriePerFatGram]];
    calc.carbGrams = [formatter numberFromString:[@"" stringByAppendingFormat:@"%.2f",(float)quantityGrams * carbPer100 / (float)100]];
    calc.carbCalories =[formatter numberFromString:[@"" stringByAppendingFormat:@"%.2f",[calc.carbGrams floatValue]* CaloriePerCarbGram]];
    calc.alcoholGrams = [formatter numberFromString:[@"" stringByAppendingFormat:@"%.2f",(float)quantityGrams * alcoholPer100 /(float) 100]];
    calc.alcoholCalories = [formatter numberFromString:[@"" stringByAppendingFormat:@"%.2f",[calc.alcoholGrams floatValue] * CaloriePerAlcoholGram]];
    NSLog(@"=========%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@",calc.proteinGrams,calc.proteinCalories,calc.fatGrams,calc.fatCalories,calc.carbGrams,calc.carbCalories,calc.alcoholGrams,calc.alcoholCalories);
    return calc;
}

+(NSString *)calPercentage:(float)totalcal with:(NSNumber*)cal{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    float value =[cal floatValue] *100;
    NSString *percentageCal = [@"" stringByAppendingFormat:@"%ld ",lroundf(value/totalcal)];
    return  percentageCal;
}
+(BOOL)isEmptyCheck:(id)data{
    BOOL isEmpty=YES;
    if ([data class] !=[NSNull class]) {
        if (data !=nil) {
            if ([data isKindOfClass:[NSString class]] && ([data isEqualToString:@""] || [data isEqualToString:@"<null>"])) {
                return YES;
            }else if([data isKindOfClass:[NSDictionary class]] || [data isKindOfClass:[NSMutableDictionary class]]){
                NSDictionary *temp = (NSDictionary *)data;
                if (temp.count > 0) {
                    return NO;
                }else{
                    return YES;
                }
            }else if([data isKindOfClass:[NSMutableArray class]] || [data isKindOfClass:[NSArray class]]){
                NSArray *temp = (NSArray *)data;
                if (temp.count > 0) {
                    return NO;
                }else{
                    return YES;
                }
            }
            isEmpty = NO;
        }
    }
    return isEmpty;
}

+ (BOOL)reachable {
    Reachability *reachable = [Reachability reachabilityWithHostName:@"apple.com"];
    NetworkStatus internetStatus = [reachable currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

+ (void)msg:(NSString*)str title:(NSString *)title controller:(UIViewController *)controller haveToPop:(BOOL)haveToPop{
    
    //Added on AY 17042018
    title = [title lowercaseString];
    title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
    title = ([errorTitleArray containsObject:title])?@" ":[title capitalizedString];
    //End
    
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:[Utility getattributedMessage:str] forKey:@"attributedMessage"];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:haveToPop ? UIAlertActionStyleCancel : UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   if (haveToPop) {
                                       [controller.navigationController popViewControllerAnimated:YES];
                                   }
                               }];
    [alertController addAction:okAction];
    [controller presentViewController:alertController animated:YES completion:nil];
    
}
+ (void)msgWithPush:(NSString*)str title:(NSString *)title controller:(UIViewController *)controller haveToAnimate:(BOOL)haveToAnimate toController:(UIViewController *)toController{
    
    //Added on AY 17042018
    title = [title lowercaseString];
    title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
    title = ([errorTitleArray containsObject:title])?@" ":[title capitalizedString];
    //End
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:str
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction *action)
                               {
                                   [controller.navigationController pushViewController:toController animated:haveToAnimate];
                                   
                               }];
    [alertController addAction:okAction];
    [controller presentViewController:alertController animated:YES completion:nil];
    
}
+ (NSString *)getUrl:(NSString *)api{
    NSString * base=[BASEURL stringByAppendingString:@"/api"];
    NSString * baseABBBC=[BASEURL_ABBBC stringByAppendingString:@"/api"];
    
    NSString *urlString=@"";
    if ([api isEqualToString:@"LogInApiCall"] ) {
        //      urlString =[urlString stringByAppendingFormat:@"%@/account/Logon",baseABBBC];    // @"%@/UserLogon"     //ah 17
        urlString =[urlString stringByAppendingFormat:@"%@/MbhqMember/MbHQLogon",base];
        //        urlString =[urlString stringByAppendingFormat:@"%@/UserLogon",base];
    }else if([api isEqualToString:@"LogOutApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/UserLogout",base];
    }else if([api isEqualToString:@"ForgotPasswordApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqMember/ForgotPassword",base];
    }else if([api isEqualToString:@"RegisterFreeMbhqUser"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqMember/RegisterFreeMbhqUser",base];
    }else if([api isEqualToString:@"ResourcesApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Resources",base];
    }else if([api isEqualToString:@"UpcomingWebinarsApiCall"]){
        //urlString = [urlString stringByAppendingFormat:@"%@/UpcomingWebinars",base];
        urlString = [urlString stringByAppendingFormat:@"%@/UpcomingWebinarsAbsolute",base];
    }else if([api isEqualToString:@"ArchivedWebinarsApiCall"]){
        //urlString = [urlString stringByAppendingFormat:@"%@/ArchivedWebinars",base];
        urlString = [urlString stringByAppendingFormat:@"%@/GetArchivedWebinarsAbsolute",base];
    }else if([api isEqualToString:@"GetPresenterListApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/GetPresenterList",base];
    }else if([api isEqualToString:@"GetEventDetailsByTypeApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/GetEventDetailsByType",base];
    }else if([api isEqualToString:@"GetEventDetailsByIDApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/GetEventDetailsByID",base];
    }else if([api isEqualToString:@"GetArchiveYearsApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/GetArchiveYears",base];
    }else if([api isEqualToString:@"GetEventTypeListApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/GetEventTypeList",base];
    }else if([api isEqualToString:@"GetEventTagListApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/GetEventTagList",base];
    }else if([api isEqualToString:@"MyProgramsApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MyPrograms",base];
    }else if([api isEqualToString:@"GetMbhqUserProfile"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqMember/GetMbhqUserProfile",base];
    }else if([api isEqualToString:@"ManageProfile"]){
        urlString = [urlString stringByAppendingFormat:@"%@/ManageProfile",base];
    }else if([api isEqualToString:@"GetUserNotificationApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/GetUserNotification",base];
    }else if([api isEqualToString:@"SaveUserNotificationApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/SaveUserNotification",base];
    }else if([api isEqualToString:@"InitializeUserNotificationApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/InitializeUserNotification",base];
    }else if([api isEqualToString:@"ToggleEventLikeApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/ToggleEventLike",base];
    }else if([api isEqualToString:@"ToggleWatchlistApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/ToggleWatchlist",base];
    }else if([api isEqualToString:@"GetWatchlistApiCall"]){
        urlString = [urlString stringByAppendingFormat:@"%@/GetWatchlist",base];
    }else if ([api isEqualToString:@"GetFinisherListByTypeId"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/GetFinisherListByTypeId",base];
    }else if([api isEqualToString:@"GetAllLeaderBoard"]){
        urlString = [urlString stringByAppendingFormat:@"%@/GetAllLeaderBoard",base];
    }else if([api isEqualToString:@"ToggleFavoriteList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/ToggleFavoriteList",base];
    }else if([api isEqualToString:@"GetScoreBoard"]){
        urlString = [urlString stringByAppendingFormat:@"%@/GetScoreBoard",base];
    }else if([api isEqualToString:@"GetFinisherDetail"]){
        urlString = [urlString stringByAppendingFormat:@"%@/GetFinisherDetail",base];
    }else if([api isEqualToString:@"IndividualLeaderBoard"]){
        urlString = [urlString stringByAppendingFormat:@"%@/IndividualLeaderBoard",base];
    }else if([api isEqualToString:@"FinisherLevelCheck"]){
        urlString = [urlString stringByAppendingFormat:@"%@/FinisherLevelCheck",base];
    }else if([api isEqualToString:@"UpgradeFinisherLevel"]){
        urlString = [urlString stringByAppendingFormat:@"%@/UpgradeFinisherLevel",base];
    }else if([api isEqualToString:@"SaveScoreBoard"]){
        urlString = [urlString stringByAppendingFormat:@"%@/SaveScoreBoard",base];
    }//Added on 27-Oct-2016 //AmitY
    else if([api isEqualToString:@"UploadExecriseVideo"]){
        urlString = [urlString stringByAppendingFormat:@"%@/UploadExecriseVideo",base];
    }
    //faf
    else if([api isEqualToString:@"GetMessageList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/GetMessageList",base];
    } else if([api isEqualToString:@"GetMessageDetail"]){
        urlString = [urlString stringByAppendingFormat:@"%@/GetMessageDetail",base];
    } else if([api isEqualToString:@"SendMessageToFriend"]){
        urlString = [urlString stringByAppendingFormat:@"%@/SendMessageToFriend",base];
    } else if([api isEqualToString:@"UpdateUserLocation"]){
        urlString = [urlString stringByAppendingFormat:@"%@/UpdateUserLocation",base];
    } else if([api isEqualToString:@"NearByUser"]){
        urlString = [urlString stringByAppendingFormat:@"%@/NearByUser",base];
    }
    //arnab new
    else if ([api isEqualToString:@"GetCourseWeekApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetCourseWeek",base];
    } else if ([api isEqualToString:@"MyExerciseDataApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetWeekPlan",base];
    } else if ([api isEqualToString:@"GetWorkoutDetailsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetWorkoutDetails",baseABBBC];
    } else if ([api isEqualToString:@"GetExerciseSessionsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetExerciseSessions",base];
    } else if ([api isEqualToString:@"UpdateUserExerciseSessionApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/UpdateUserExerciseSession",base];
    } else if ([api isEqualToString:@"UpdateUserExerciseSessionStatusApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/exercise/UpdateUserExerciseSessionStatus",base];
    } else if ([api isEqualToString:@"CurrentWeekApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetUserByEmail",baseABBBC];
    }
    //end arnab new
    //ah 17
    else if ([api isEqualToString:@"GetDailySessionList"] ) {
        //urlString =[urlString stringByAppendingFormat:@"%@/SquadDailySession/GetDailySessionList",baseABBBC];
        urlString =[urlString stringByAppendingFormat:@"%@/SquadDailySession/GetDailySessionListAbsolute",baseABBBC];
    } else if ([api isEqualToString:@"EditSquadDailySession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadDailySession/EditSquadDailySession",baseABBBC];
    } else if ([api isEqualToString:@"GetExercises"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/GetExercises",baseABBBC];
    } else if ([api isEqualToString:@"GetCircuits"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetCircuits",baseABBBC];
    }else if ([api isEqualToString:@"GetExercisesApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/GetExercises",baseABBBC];
    }else if ([api isEqualToString:@"GetExerciseApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/GetExercise",baseABBBC];
    }else if ([api isEqualToString:@"GetCircuitsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/GetCircuits",baseABBBC];
    }else if ([api isEqualToString:@"GetMyCircuitsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/GetMyCircuits",baseABBBC];
    }else if ([api isEqualToString:@"GetCircuitDetailsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/GetCircuitDetails",baseABBBC];
    }else if ([api isEqualToString:@"SearchExercisesApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/SearchExercises",baseABBBC];
    }else if ([api isEqualToString:@"SearchCircuitsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/SearchCircuits",baseABBBC];
    }else if ([api isEqualToString:@"SearchExerciseSessionsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/SearchExerciseSessionsPaginate",baseABBBC];
        //urlString =[urlString stringByAppendingFormat:@"%@/Exercise/SearchExerciseSessions",baseABBBC];
    }else if ([api isEqualToString:@"UserSettings"]) {
        urlString =[urlString stringByAppendingFormat:@"%@/UserSettings",base];
    } else if ([api isEqualToString:@"SquadDailySessionSplit"]) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadDailySession/SquadDailySessionSplit",baseABBBC];
    }else if ([api isEqualToString:@"QuickEditDailySession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadDailySession/QuickEditDailySession",baseABBBC];
    }else if ([api isEqualToString:@"GetSquadCurrentProgramApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetSquadCurrentProgram",baseABBBC];
    }else if ([api isEqualToString:@"SaveSquadProgramApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/SaveSquadProgram",baseABBBC];
    }else if ([api isEqualToString:@"GetDailyMealList"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/GetSquadDailyMeal",baseABBBC];
    }else if ([api isEqualToString:@"GetMealDetailsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/GetMealDetails",baseABBBC];
    }else if ([api isEqualToString:@"SquadGetMealSessionDetailApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/SquadGetMealSessionDetail",baseABBBC];
    }else if ([api isEqualToString:@"SaveViewVideoStatusApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SaveViewVideoStatus",baseABBBC];
    }
    //ah new
    else if ([api isEqualToString:@"GetUserExercisePlan"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetUserExercisePlan",baseABBBC];
    } else if ([api isEqualToString:@"CreateUserExercisePlan"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/CreateUserExercisePlan",baseABBBC];
    } else if ([api isEqualToString:@"GetUserPersonalSessions"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetUserPersonalSessions",baseABBBC];
    } else if ([api isEqualToString:@"GetGymClasses"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/GetGymClasses",baseABBBC];
    } else if ([api isEqualToString:@"GetSports"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/GetSports",baseABBBC];
    } else if ([api isEqualToString:@"CreateUserPersonalSession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/CreateUserPersonalSession",baseABBBC];
    } else if ([api isEqualToString:@"UpdateUserRegistrationBodyData"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/UpdateUserRegistrationBodyData",baseABBBC];
    } else if ([api isEqualToString:@"GetUserFlags"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetUserFlags",baseABBBC];
    } else if ([api isEqualToString:@"AddUpateUserFlags"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/AddUpateUserFlags",baseABBBC];
    } else if ([api isEqualToString:@"UpdateRepeateSession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/UpdateRepeateSession",baseABBBC];
    }else if ([api isEqualToString:@"GetUserFlags"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetUserFlags",baseABBBC];
    }
    //ah 02
    else if ([api isEqualToString:@"GetSquadUserData"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetSquadUserData",baseABBBC];
    }
    //ah c
    else if ([api isEqualToString:@"GetMbhqArticleDetail"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/MbhqCourse/GetMbhqArticleDetail",base];
    } else if ([api isEqualToString:@"ArticleRead"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/MbhqCourse/ArticleRead",base];
    } else if ([api isEqualToString:@"UnreadArticle"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/MbhqCourse/UnreadArticle",base];
    }
    
    
    else if ([api isEqualToString:@"GetCourseListApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/MbhqCourse/GetCourseList",base];

    }else if ([api isEqualToString:@"GetUserCourseListApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/GetUserCourseList",base];
    }else if ([api isEqualToString:@"GetCourseDetailApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/MbhqCourse/GetCourseDetail",base];
    }
    //chayan 19/9/2017 ResetWeekChallange
    else if ([api isEqualToString:@"ResetWeekChallengeApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/ResetWeekChallenge",base];
    }
    else if ([api isEqualToString:@"AddCourseApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/MbhqCourse/AddUserCourse",base];// AddCourse
    }else if ([api isEqualToString:@"SetProgressBarApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/MbhqCourse/SetProgressBar",base];
    }else if ([api isEqualToString:@"UpdateMbhqTaskApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/MbhqCourse/UpdateMbhqTask",base];
    }else if ([api isEqualToString:@"SquadCityLeaderboard"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadCityLeaderboard",base];
    }else if ([api isEqualToString:@"SquadSubursLeaderboard"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadSubursLeaderboard",base];
    }else if ([api isEqualToString:@"GetDairyListApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetDairyListAPI",base];
    }else if ([api isEqualToString:@"GetGoalValueListApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetGoalValueListAPI",base];
    }else if ([api isEqualToString:@"AddUpdateDairyApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/AddUpdateDairyAPI",base];
    }else if ([api isEqualToString:@"GetDairySelectApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetDairySelectAPI",base];
    }else if ([api isEqualToString:@"DeleteDairyApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/DeleteDairyAPI",base];
    }else if ([api isEqualToString:@"GetCheckListApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetCheckList",base];
    }else if ([api isEqualToString:@"DeleteSquadCheckListApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/DeleteSquadCheckList",base];
    }else if ([api isEqualToString:@"ChangeChecklistFlagApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/ChangeChecklistFlag",base];
    }else if ([api isEqualToString:@"GetUserflagValueApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetUserflagValue",base];
    }else if ([api isEqualToString:@"EditCheckListApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/EditCheckList",base];
    }else if ([api isEqualToString:@"AddSquadCheckListApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/AddSquadCheckList",base];
    }
    
    //ah ac
    else if ([api isEqualToString:@"GetVisionBoardAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetVisionBoardAPI",base];
    } else if ([api isEqualToString:@"GetGoalListAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetGoalListAPI",base];
    } else if ([api isEqualToString:@"GetActionListAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetActionListAPI",base];
    } else if ([api isEqualToString:@"GetGoalValueListAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetGoalValueListAPI",base];
    } else if ([api isEqualToString:@"ChangeGoalValueRankUpAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/ChangeGoalValueRankUpAPI",base];
    } else if ([api isEqualToString:@"ChangeGoalValueRankDownAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/ChangeGoalValueRankDownAPI",base];
    } else if ([api isEqualToString:@"DeleteGoalValueAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/DeleteGoalValueAPI",base];
    } else if ([api isEqualToString:@"AddUpdateGoalValueAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/AddUpdateGoalValueAPI",base];
    } else if ([api isEqualToString:@"GetMotivationQuestionAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetMotivationQuestionAPI",base];
    } else if ([api isEqualToString:@"GetCategoryAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetCategoryAPI",base];
    } else if ([api isEqualToString:@"AddUpdateGoalAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/AddUpdateGoalAPI",base];
    }else if ([api isEqualToString:@"GetGratitudeListListAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetGratitudeListListAPI",base];
    }else if ([api isEqualToString:@"GetGratitudeSelectApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetGratitudeSelectAPI",base];
    }else if ([api isEqualToString:@"AddUpdateGratitudeApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/AddUpdateGratitudeAPI",base];
    }else if ([api isEqualToString:@"DeleteGratitudeApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/DeleteGratitudeAPI",base];
    }
    
    else if ([api isEqualToString:@"GetReverseBucketListApiCall"]){
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetReverseBucketListAPI",base];
    }else if ([api isEqualToString:@"GetReverseBuckeSelectApiCall"]){
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetReverseBuckeSelectAPI",base];
    }else if ([api isEqualToString:@"AddUpdateReverseBucketApiCall"]) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/AddUpdateReverseBucketAPI",base];
    }else if ([api isEqualToString:@"DeleteReverseBucketApiCall"]) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/DeleteReverseBucketAPI",base];
    }
    
    else if ([api isEqualToString:@"GetBucketListApiCall"]){
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetBucketListAPI",base];
    }else if ([api isEqualToString:@"GetBucketSelectApiCall"]){
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetBucketSelectAPI",base];
    }else if ([api isEqualToString:@"AddUpdateBucketApiCall"]) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/AddUpdateBucketAPI",base];
    }else if ([api isEqualToString:@"DeleteBucketApiCall"]) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/DeleteBucketAPI",base];
    }else if ([api isEqualToString:@"GetMealPlanApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/GetSquadMealPlan",baseABBBC];
    }else if ([api isEqualToString:@"GetSquadUserMealSessionJoiningDateApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/GetSquadUserMealSessionJoiningDate",baseABBBC];
    }else if ([api isEqualToString:@"SquadRemoveUserMealSessionApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/SquadRemoveUserMealSession",baseABBBC];
    }else if ([api isEqualToString:@"SquadRepeatMealNextWeekApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/SquadRepeatMealNextWeek",baseABBBC];
    }else if ([api isEqualToString:@"GetIngredientsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/GetIngredients",baseABBBC];
    }else if ([api isEqualToString:@"AddUpdateMealRecipeApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/AddUpdateMealRecipe",baseABBBC];
    }else if ([api isEqualToString:@"SquadUpdateMealForSessionApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/SquadUpdateMealForSession",baseABBBC];
    }else if ([api isEqualToString:@"GetMealsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/GetMeals",baseABBBC];
    }else if ([api isEqualToString:@"SquadUserSessionCountListApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/SquadUserSessionCountList",baseABBBC];
    }else if ([api isEqualToString:@"SaveSquadUserSessionCountApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/SaveSquadUserSessionCount",baseABBBC];
    }else if ([api isEqualToString:@"GetMealsWithUserFlagsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/GetMealsWithUserFlags",baseABBBC];
    }else if ([api isEqualToString:@"GetQuickMealsWithUserFlags"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/GetQuickMealsWithUserFlags",baseABBBC];
    }else if ([api isEqualToString:@"GetSquadMealPlanWithSettingsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/GetSquadMealPlanWithSettings",baseABBBC];
    }else if ([api isEqualToString:@"GetMyDaySquadUserActualMealApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/nutrition/GetMyDaySquadUserActualMeal",baseABBBC];
    }else if ([api isEqualToString:@"AvoidMealApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/AvoidMeal",baseABBBC];
    }else if ([api isEqualToString:@"AvoidMealDataApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/AvoidMealData",baseABBBC];
    }else if ([api isEqualToString:@"SubmitMealApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/SubmitMeal",baseABBBC];
    }else if ([api isEqualToString:@"GetMyIngredientsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/GetMyIngredients",baseABBBC];
    }else if ([api isEqualToString:@"GetIngredientUnitApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/GetIngredientUnit",baseABBBC];
    }else if ([api isEqualToString:@"GetIngredientCategoryListApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/GetIngredientCategoryList",baseABBBC];
    }else if ([api isEqualToString:@"GetIngredientDetailsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/GetIngredientDetails",baseABBBC];
    }else if ([api isEqualToString:@"AddIngredientApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/AddIngredient",baseABBBC];
    }else if ([api isEqualToString:@"SubmitIngredientApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/SubmitIngredient",baseABBBC];
    }else if ([api isEqualToString:@"GenerateSquadUserMealPlansApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/GenerateSquadUserMealPlans",baseABBBC];
    }
    //ah cs
    else if ([api isEqualToString:@"SetUpSquadUserSession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/SetUpSquadUserSession",baseABBBC];
    }else if ([api isEqualToString:@"SquadSwapExerciseSession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/SquadSwapExerciseSession",baseABBBC];
    }
    
    //ah ac1
    else if ([api isEqualToString:@"AddUpdateActionAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/AddUpdateActionAPI",base];
    } else if ([api isEqualToString:@"AddUpdateVisionBoardAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/AddUpdateVisionBoardAPI",base];
    } else if ([api isEqualToString:@"DeleteActionAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/DeleteActionAPI",base];
    } else if ([api isEqualToString:@"GetGoalSelectAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetGoalSelectAPI",base];
    } else if ([api isEqualToString:@"DeleteGoalAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/DeleteGoalAPI",base];
    }else if ([api isEqualToString:@"GetActionSelectAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetActionSelectAPI",base];
    }else if ([api isEqualToString:@"AddUpdatePhotos"] ) {//add on 16.3.17
        //        urlString =[urlString stringByAppendingFormat:@"%@/mindset/AddUpdatePhotos",base];
        urlString =[urlString stringByAppendingFormat:@"%@/AddUpdatePhotos",base];
    }else if ([api isEqualToString:@"GetBodyPhotos"] ) {//add on 16.3.17
        //        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetUserPhotos",base];
        urlString =[urlString stringByAppendingFormat:@"%@/GetBodyPhotos",base];
        
    }else if ([api isEqualToString:@"GetChartDataApiCall"] ) {//add on 16.3.17
        urlString =[urlString stringByAppendingFormat:@"%@/GetChartData",base];
    }else if ([api isEqualToString:@"GetBodyCompositionWeightApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/GetBodyCompositionWeight",base];
    }else if ([api isEqualToString:@"GetBodyMeasurementsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/GetBodyMeasurements",base];
    }else if ([api isEqualToString:@"BodyRefrencesPantDetailApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/BodyRefrencesPantDetail",base];
    }else if ([api isEqualToString:@"BodyRefrencesTopDetailApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/BodyRefrencesTopDetail",base];
    }else if ([api isEqualToString:@"DeleteBodyCompositionApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/DeleteBodyComposition",base];
    }else if ([api isEqualToString:@"DeleteRefrenceApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/DeleteRefrence",base];
    }else if ([api isEqualToString:@"GetBodyWeight"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/GetBodyWeight",base];
    }else if ([api isEqualToString:@"BodyMeasurements"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/BodyMeasurements",base];
    }else if ([api isEqualToString:@"GetBodyRefrenceTop"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/GetBodyRefrenceTop",base];
    }else if ([api isEqualToString:@"GetBodyRefrencePant"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/GetBodyRefrencePant",base];
    }else if ([api isEqualToString:@"SaveBodyWeight"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SaveBodyWeight",base];
    }else if ([api isEqualToString:@"SaveBodyMeasurements"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SaveBodyMeasurements",base];
    }else if ([api isEqualToString:@"SaveBodyRefrenceTop"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SaveBodyRefrenceTop",base];
    }else if ([api isEqualToString:@"SaveBodyRefrencePant"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SaveBodyRefrencePant",base];
    }
    //ah 21.3
    else if ([api isEqualToString:@"BodyPicsCompare"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/BodyPicsCompare",base];
    }
    
    //ah 22.3
    else if ([api isEqualToString:@"DeleteBodyPhotoById"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/DeleteBodyPhotoById",base];
    }
    else if ([api isEqualToString:@"SquadNutritionSettingStep"] ) {//add on 28.3.17
        urlString =[urlString stringByAppendingFormat:@"%@/SquadNutritionSettingStep",base];
    }
    else if ([api isEqualToString:@"UpdateNutrationStep"] ) {//add on 28.3.17
        urlString =[urlString stringByAppendingFormat:@"%@/UpdateNutrationStep",base];
    }
    //    else if ([api isEqualToString:@"GetUserFlags"] ) {//add on 28.3.17
    //        urlString =[urlString stringByAppendingFormat:@"%@/GetUserFlags",baseABBBC];
    //    }
    else if ([api isEqualToString:@"GetUserMealVariety"] ) {//add on 29.3.17
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetUserMealVariety",baseABBBC];
    }
    else if ([api isEqualToString:@"SaveUserMealVarietyWithMealClassification"] ) {//add_16/8/17
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/SaveUserMealVarietyWithMealClassification",baseABBBC];
    }else if ([api isEqualToString:@"GetUserMealClassifiedUserMap"] ) {//add_16/8/17
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/GetUserMealClassifiedUserMap",baseABBBC];
    }
    else if ([api isEqualToString:@"AddUpateUserFlags"] ) {//add on 30.3.17
        urlString =[urlString stringByAppendingFormat:@"%@/values/AddUpateUserFlags",baseABBBC];
    }
    else if ([api isEqualToString:@"GetUserMealFrequencyAbsolute"] ) {//add on 31.3.17
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetUserMealFrequencyAbsolute",baseABBBC];
    }
    else if ([api isEqualToString:@"SaveUserMealFrequency"] ) {//add on 03.4.17
        urlString =[urlString stringByAppendingFormat:@"%@/values/SaveUserMealFrequency",baseABBBC];
    }
    else if ([api isEqualToString:@"GetMealPlans"] ) {//add on 03.4.17
        urlString =[urlString stringByAppendingFormat:@"%@/meal/GetMealPlans",baseABBBC];
    }
    else if ([api isEqualToString:@"SquadGetRecommendedMealPlanForUser"] ) {//add on 03.4.17
        urlString =[urlString stringByAppendingFormat:@"%@/values/SquadGetRecommendedMealPlanForUser",baseABBBC];
    }
    else if ([api isEqualToString:@"GetUserCustomMealPlan"] ) {//add on 03.4.17
        urlString =[urlString stringByAppendingFormat:@"%@/meal/GetUserCustomMealPlan",baseABBBC];
    }
    else if ([api isEqualToString:@"CreateSquadUserMealPlan"] ) {//add on 03.4.17
        urlString =[urlString stringByAppendingFormat:@"%@/values/CreateSquadUserMealPlan",baseABBBC];
    }
    else if ([api isEqualToString:@"CreateCustomMealPlan"] ) {//add on 04.4.17
        urlString =[urlString stringByAppendingFormat:@"%@/meal/CreateCustomMealPlan",baseABBBC];
    }
    else if ([api isEqualToString:@"CreateSquadUserMealPlan"] ) {//add on 04.4.17
        urlString =[urlString stringByAppendingFormat:@"%@/values/CreateSquadUserMealPlan",baseABBBC];
    }
    //ah cpn
    else if ([api isEqualToString:@"CheckStepNumberForSetup"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/CheckStepNumberForSetup",base];
    } else if ([api isEqualToString:@"CheckUserProgramStep"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/CheckUserProgramStep",base];
    } else if ([api isEqualToString:@"UpdatedUserProgramSetupStep"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/UpdatedUserProgramSetupStep",base];
    } else if ([api isEqualToString:@"DeleteSquadPersonalSessionOfUser"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/exercise/DeleteSquadPersonalSessionOfUser",baseABBBC];
    } else if ([api isEqualToString:@"GetSquadExercisePlan"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetSquadExercisePlan",baseABBBC];
    } else if ([api isEqualToString:@"AddUpdateUserFlags"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/AddUpateUserFlags",baseABBBC];
    } else if ([api isEqualToString:@"CreateSquadExercisePlan"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/CreateSquadExercisePlan",baseABBBC];
    } else if ([api isEqualToString:@"SquadSwapPersonalExerciseSession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/SquadSwapPersonalExerciseSession",baseABBBC];
    } else if ([api isEqualToString:@"GetSquadUserWorkoutSession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/GetSquadUserWorkoutSession",baseABBBC];
    } else if ([api isEqualToString:@"SetSquadUserWorkoutSessionIsDone"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/SetSquadUserWorkoutSessionIsDone",baseABBBC];
    } else if ([api isEqualToString:@"SetSquadUserWorkoutSessionRepeatNextWeek"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/SetSquadUserWorkoutSessionRepeatNextWeek",baseABBBC];
    } else if ([api isEqualToString:@"SquadCreateUserPersonalSession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/SquadCreateUserPersonalSession",baseABBBC];
    } else if ([api isEqualToString:@"ResetExercisePlanForCurrentWeek"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/ResetExercisePlanForCurrentWeek",baseABBBC];
    }
    //ah aec
    else if ([api isEqualToString:@"GetSquadExerciseSessions"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetSquadExerciseSessions",baseABBBC];
    } else if ([api isEqualToString:@"AddUpdateSquadUserWorkoutSession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/AddUpdateSquadUserWorkoutSession",baseABBBC];
    } else if ([api isEqualToString:@"GetSquadWorkoutSession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/GetSquadWorkoutSession",baseABBBC];
    } else if ([api isEqualToString:@"DeleteSquadUserWorkoutSession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/DeleteSquadUserWorkoutSession",baseABBBC];
    } else if ([api isEqualToString:@"SwapSquadUserWorkoutSession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/SwapSquadUserWorkoutSession",baseABBBC];
    } else if ([api isEqualToString:@"MoveSquadUserWorkoutSession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/MoveSquadUserWorkoutSession",baseABBBC];
    }
    //addRecipe21
    else if ([api isEqualToString:@"IsMealNameExisting"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/IsMealNameExisting",baseABBBC];
    }else if ([api isEqualToString:@"GetUserRecipeByName"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/GetUserRecipeByName",baseABBBC];
    }
    //ah edit
    else if ([api isEqualToString:@"SaveSquadEditUserExerciseSession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadDailySession/SaveSquadEditUserExerciseSession",baseABBBC];
    } else if ([api isEqualToString:@"GetRepsUnits"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetRepsUnits",baseABBBC];
    } else if ([api isEqualToString:@"GetRestUnits"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetRestUnits",baseABBBC];
    }
    
    //ah se
    else if ([api isEqualToString:@"GetCircuitsForSquad"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadexercise/GetCircuitsForSquad",baseABBBC];
    }
    //ah ce
    else if ([api isEqualToString:@"GetCircuitDetails"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/exercise/GetCircuitDetails",baseABBBC];
    } else if ([api isEqualToString:@"EditCircuitExercise"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/exercise/EditCircuitExercise",baseABBBC];
    }else if ([api isEqualToString:@"GetSquadShoppingList"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/GetSquadShoppingList",baseABBBC];
    }else if ([api isEqualToString:@"GetShoppinglistDataWithSettingsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/GetShoppinglistDataWithSettings",baseABBBC];
    }else if ([api isEqualToString:@"RemoveSquadShoppingItem"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/RemoveSquadShoppingItem",baseABBBC];
    }else if ([api isEqualToString:@"UpdateSquadShopping"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/UpdateSquadShopping",baseABBBC];
    }else if ([api isEqualToString:@"UpdateSquadShoppingList"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/UpdateSquadShoppingList",baseABBBC];
    }else if ([api isEqualToString:@"GetShoppingIngredientCategory"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/GetShoppingIngredientCategory",baseABBBC];
    }
    else if ([api isEqualToString:@"AddSquadShoppingList"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/AddSquadShoppingList",baseABBBC];
    }
    
    //ah 2.5
    else if ([api isEqualToString:@"SquadAddCircuit"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadexercise/SquadAddCircuit",baseABBBC];
    } else if ([api isEqualToString:@"ReplaceCircuitInExerciseSessionExercise"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/exercise/ReplaceCircuitInExerciseSessionExercise",baseABBBC];
    }
    //ah 3.5
    else if ([api isEqualToString:@"UpdateSquadUserBodyData"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/UpdateSquadUserBodyData",baseABBBC];
    }
    //4/05/17
    else if ([api isEqualToString:@"GetFavoriteSessionList"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadexercise/GetFavoriteSessionList",baseABBBC];
    }
    else if ([api isEqualToString:@"CountSessionDone"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadexercise/CountSessionDone",baseABBBC];
    }
    else if ([api isEqualToString:@"GetSquadCircuitListApiCall"] ) {//sunew
        urlString =[urlString stringByAppendingFormat:@"%@/squadexercise/GetSquadCircuitList",baseABBBC];
    }
    
    //ah 4.5
    else if ([api isEqualToString:@"AddSession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/AddSession",baseABBBC];
    }
    else if ([api isEqualToString:@"FavoriteSessionToggle"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadexercise/FavoriteSessionToggle",baseABBBC];
    }else if ([api isEqualToString:@"FavoriteSessionandCountUpdate"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadexercise/FavoriteSessionandCountUpdate",baseABBBC];
    }//AY 02032018
    else if ([api isEqualToString:@"SyncSquadUserWorkoutSessionData"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadexercise/SyncSquadUserWorkoutSessionData",baseABBBC];
    }//AY 07032018
    else if ([api isEqualToString:@"SubmitWorkout"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/exercise/SubmitWorkout",baseABBBC];
    }
    else if ([api isEqualToString:@"GetSquadCurrentProgram"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetSquadCurrentProgram",baseABBBC];
    } else if ([api isEqualToString:@"GetGoalBucketList"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetGoalBucketList",baseABBBC];
    } else if ([api isEqualToString:@"SquadUpdateCircuitForIsDeleted"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadExercise/SquadUpdateCircuitForIsDeleted",baseABBBC];
    }else if ([api isEqualToString:@"GetSquadCountriesApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/GetSquadCountries",base];
    }else if ([api isEqualToString:@"GetSquadStatesApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/GetSquadStates",base];
    }else if ([api isEqualToString:@"GetSquadCitiesApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/GetSquadCities",base];
    }else if ([api isEqualToString:@"GetSquadCitySuburbsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/GetSquadCitySuburbs",base];
    }else if ([api isEqualToString:@"InAppPurchaseApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/MbhqMember/RegisterSubscribedUser",base];
    }else if ([api isEqualToString:@"ChangeActionReminderStatusListAPI"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/ChangeActionReminderStatusListAPI",base];
    }else if ([api isEqualToString:@"CheckSquadOnlineRequestApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/CheckSquadOnlineUser",base];
    }else if ([api isEqualToString:@"UpdateParticipantSuburbApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/UpdateParticipantSuburb",base];
    }else if ([api isEqualToString:@"GetConnectInfoApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/GetConnectInfo",base];
    }
    //fitbit
    else if ([api isEqualToString:@"GetMyWearableApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Fitbit/GetMyWearable",base];
    }else if ([api isEqualToString:@"AddFitbitDeviceApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Fitbit/AddFitbitDevice",base];
    }else if ([api isEqualToString:@"GetActivittyDataApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Fitbit/GetActivittyData",base];
    }
    else if ([api isEqualToString:@"GetFitbitLeaderboardApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Fitbit/GetFitbitLeaderboard",base];
    }else if ([api isEqualToString:@"ChangeDashboardApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Fitbit/ChnageDashboard",base];
    }else if ([api isEqualToString:@"EditFitbitDataApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Fitbit/EditFitbitData",base];
    }else if ([api isEqualToString:@"DeleteMyWearableApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Fitbit/DeleteMyWearable",base];
    }else if ([api isEqualToString:@"ToggleFitbitflagApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Fitbit/ToggleFitbitflag",base];
    }else if ([api isEqualToString:@"SaveIwatchData"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Fitbit/SaveIwatchData",base];
    }// AY 15022018
    else if ([api isEqualToString:@"GetTempGarminAuthToken"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Fitbit/GetTempGarminAuthToken",base];
    }// AY 15022018
    else if ([api isEqualToString:@"SaveGarminAuthToken"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Fitbit/SaveGarminAuthToken",base];
    }// AY 15022018
    
    //ah fbw
    else if ([api isEqualToString:@"AddTrackData"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/FBW/AddTrackData",base];
    } else if ([api isEqualToString:@"GetActivityHistory"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/FBW/GetActivityHistory",base];
    }
    
    //ah fbw2
    else if ([api isEqualToString:@"GetSquadActivityData"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/FBW/GetSquadActivityData",base];
    }
    
    //ah ph
    else if ([api isEqualToString:@"DeleteBodyPhoto"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/DeleteBodyPhoto",base];
    } else if ([api isEqualToString:@"UpdateBodyPhoto"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/UpdateBodyPhoto",base];
    }
    
    //ahd
    else if ([api isEqualToString:@"QuickSwapExerciseSession"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/QuickSwapExerciseSession",baseABBBC];
    }
    
    //ah 31.8
    else if ([api isEqualToString:@"DeleteActivityData"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/FBW/DeleteActivityData",base];
    }
    
    //ah accb
    else if ([api isEqualToString:@"GetWeeklyCheckView"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetWeeklyCheckView",base];
    } else if ([api isEqualToString:@"ToggleDailyCheck"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/ToggleDailyCheck",base];
    }else if ([api isEqualToString:@"GetSquadWelcomeData"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/GetSquadWelcomeData",base];
    }else if ([api isEqualToString:@"SaveSquadWelcomeData"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SaveSquadWelcomeData",base];
    }
    
    
    //AY mealmatch
    else if ([api isEqualToString:@"SetSquadUserActualMealOrderDown"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/nutrition/SetSquadUserActualMealOrderDown",baseABBBC];
        
    }else if ([api isEqualToString:@"SetSquadUserActualMealOrderUp"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/nutrition/SetSquadUserActualMealOrderUp",baseABBBC];
        
    }else if ([api isEqualToString:@"DeleteSquadUserActualMeal"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/nutrition/DeleteSquadUserActualMeal",baseABBBC];
        
    }else if ([api isEqualToString:@"GetSquadUserActualMealList"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/nutrition/GetSquadUserActualMealList",baseABBBC];
        
    }else if ([api isEqualToString:@"SaveWaterData"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SaveWaterData",base];
        
    }else if ([api isEqualToString:@"GetWaterData"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/GetWaterData",base];
    }else if ([api isEqualToString:@"AddSquadUserActualMeal"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/nutrition/AddSquadUserActualMeal",baseABBBC];
        
    }else if ([api isEqualToString:@"GetIngredientById"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/GetIngredientById",baseABBBC];
        
    }else if ([api isEqualToString:@"GetSquadUserActualMeal"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/nutrition/GetSquadUserActualMeal",baseABBBC];
    }else if ([api isEqualToString:@"GetMyDayIngredientSquadUserActualMeal"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/nutrition/GetMyDayIngredientSquadUserActualMeal",baseABBBC];
    }else if ([api isEqualToString:@"SaveContact"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@",BASEURL_GETRESPONSE];
    }else if ([api isEqualToString:@"AddNewPhotos"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/AddNewPhotos",base];
    }
    
    //add_su_new_forum
    else if ([api isEqualToString:@"GetForumListRequest"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadForum/GetForumList",base];
    }else if ([api isEqualToString:@"GetMyForumList"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadForum/GetMyForumList",base];
    }
    //chayan 12/10/2017 -- JoinForum
    else if ([api isEqualToString:@"JoinSquadForumRequest"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadForum/JoinForum",base];
    }else if ([api isEqualToString:@"SearchForum"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadForum/SearchForum",base];
    }
    
    //chayan 12/10/2017
    else if ([api isEqualToString:@"RemoveSquadForumRequest"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadForum/RemoveForum",base];
    }
    
    //chayan 21/9/2017
    else if ([api isEqualToString:@"SearchForumByTagRequest"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadForum/SearchForumByTag",base];
    }else if ([api isEqualToString:@"AddNewForum"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadForum/AddNewForum",base];
    }else if ([api isEqualToString:@"GetSquadCustomMealSessionApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/nutrition/GetSquadCustomMealSession",baseABBBC];
    }else if ([api isEqualToString:@"GetSquadCustomShoppingListSettingsApiCall"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/GetSquadCustomShoppingListSettings",baseABBBC];
    }else if ([api isEqualToString:@"GetSquadMealPlanCalories"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/GetSquadMealPlanCalories",baseABBBC];
    }else if ([api isEqualToString:@"GetMyDaySquadUserActualMealCalories"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/nutrition/GetMyDaySquadUserActualMealCalories",baseABBBC];
    }else if ([api isEqualToString:@"AddCustomShoppingList"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/nutrition/AddCustomShoppingList",baseABBBC];
    }//chayan 11/10/2017
    else if ([api isEqualToString:@"GetbuddyList"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetbuddyList",base];
    }else if ([api isEqualToString:@"ToggleNotification"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/ToggleNotification",base];
    }else if ([api isEqualToString:@"DeleteMyFriend"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/DeleteMyFriend",base];
    }else if ([api isEqualToString:@"SendFriendRequest"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/SendFriendRequest",base];
    }else if ([api isEqualToString:@"FriendRequestAccept"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/FriendRequestAccept",base];
    }
    //chayan
    else if ([api isEqualToString:@"AddUpdateVisionBoardWithPhoto"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/AddUpdateVisionBoardWithPhoto",base];
    }
    //chayan 18/10/2017
    else if ([api isEqualToString:@"AddUpdateMealRecipeWithPhoto"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/meal/AddUpdateMealRecipeWithPhoto",baseABBBC];
    }
    
    //AY Weight Record Sheet
    else if ([api isEqualToString:@"GetDailyWeightSheet"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/GetDailyWeightSheet",baseABBBC];
        
    }else if ([api isEqualToString:@"DeleteDailySquadSet"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/DeleteDailySquadSet",baseABBBC];
        
    }else if ([api isEqualToString:@"AddDailyWeightsheetSets"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/AddDailyWeightsheetSets",baseABBBC];
        
    }else if ([api isEqualToString:@"AddGenerateSquadWeightSheet"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/AddGenerateSquadWeightSheet",baseABBBC];
        
    }
    else if ([api isEqualToString:@"DeleteSquadSet"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/DeleteSquadSet",baseABBBC];
        
    }else if ([api isEqualToString:@"AddSquadSets"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/AddSquadSets",baseABBBC];
        
    }
    else if ([api isEqualToString:@"SquadSessionHistory"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/SquadSessionHistory",baseABBBC];
    }else if ([api isEqualToString:@"SquadExerciseSessionHistory"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/Exercise/SquadExerciseSessionHistory",baseABBBC];
    }
    
    //chayan 23/10/2017
    else if ([api isEqualToString:@"AddSquadUserActualMealWithPhoto"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/nutrition/AddSquadUserActualMealWithPhoto",baseABBBC];
        
    }
    //chayan 25/10/2017
    else if ([api isEqualToString:@"GetUserHabitList"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetUserHabitList",base];
    }
    else if ([api isEqualToString:@"ToggleActive"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/ToggleActive",base];
    }
    //chayan 26/10/2017
    else if ([api isEqualToString:@"ToggleVisible"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/ToggleVisible",base];
    }
    else if ([api isEqualToString:@"DeleteHabit"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/DeleteHabit",base];
    }
    else if ([api isEqualToString:@"ChangePosition"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/ChangePosition",base];
    }
    else if ([api isEqualToString:@"AddUpdateGoalAPIWithPhoto"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/AddUpdateGoalAPIWithPhoto",base];
    }
    //chayan 31/10/2017
    else if ([api isEqualToString:@"AddHabitList"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/AddHabitList",base];
    }else if ([api isEqualToString:@"AddUpdateGratitudeApiCallWithPhoto"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/AddUpdateGratitudeAPIWithPhoto",base];
    }else if ([api isEqualToString:@"AddUpdateReverseBucketApiCallWithPhoto"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/AddUpdateReverseBucketAPIWithPhoto",base];
    }else if ([api isEqualToString:@"AddUpdateBucketApiCallWithPhoto"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/AddUpdateBucketAPIWithPhoto",base];
    }else if([api isEqualToString:@"ManageProfileWithPhoto"]){
        urlString = [urlString stringByAppendingFormat:@"%@/ManageProfileWithPhoto",base];
    }
    
    //AY 29112017
    else if ([api isEqualToString:@"GetSquadActionList"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetSquadActionList",base];
    }
    //shabbir
    else if ([api isEqualToString:@"FavoriteMealToggle"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/squadnourish/FavoriteMealToggle",baseABBBC];
        
    }else if ([api isEqualToString:@"GetTargetExercises"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/values/GetTargetExercises",baseABBBC]; //GetTargetExercises
        
    }else if([api isEqualToString:@"UpdateBodyDataWithUnitPref"]){
        urlString = [urlString stringByAppendingFormat:@"%@/UpdateBodyDataWithUnitPref",base];
        
    }//AY 03042018
    //shabbir
    else if([api isEqualToString:@"GetFoodPrepList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Nutrition/GetFoodPrepList",baseABBBC];
        
    }else if([api isEqualToString:@"DeleteFoodPrepList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Nutrition/DeleteFoodPrepList",baseABBBC];
        
    }else if([api isEqualToString:@"GetMealList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Nutrition/GetMealList",baseABBBC];
        
    }else if([api isEqualToString:@"AddSquadUserWeeklyFoodPrep"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Nutrition/AddSquadUserWeeklyFoodPrep",baseABBBC];
        
    }else if([api isEqualToString:@"GetFoodPerpSquadShoppingList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Nutrition/GetFoodPerpSquadShoppingList",baseABBBC];
        
    }else if([api isEqualToString:@"GetSquadUserWeeklyFoodPrep"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Nutrition/GetSquadUserWeeklyFoodPrep",baseABBBC];
        
    }else if([api isEqualToString:@"GetMealDetailsBySize"]){
        urlString = [urlString stringByAppendingFormat:@"%@/meal/GetMealDetailsBySize",baseABBBC];
        
    }else if([api isEqualToString:@"UpdateFoodPrepShopping"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Nutrition/UpdateFoodPrepShopping",baseABBBC];
        
    }else if([api isEqualToString:@"GetFoodPrepMealsWithUserFlags"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/GetFoodPrepMealsWithUserFlags",baseABBBC];
        
    }else if([api isEqualToString:@"GetFoodPrepIngredients"]){
        urlString = [urlString stringByAppendingFormat:@"%@/meal/GetFoodPrepIngredients",baseABBBC];
        
    }
    //SetProgram_In
    else if ([api isEqualToString:@"GetSquadMiniProgram"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadMiniProgram/GetSquadMiniProgram",baseABBBC];
    }
    else if ([api isEqualToString:@"StartProgram"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadMiniProgram/StartProgram",baseABBBC];
    } else if ([api isEqualToString:@"StartProgramCourse"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadMiniProgram/StartProgramCourse",baseABBBC];
    }else if ([api isEqualToString:@"GetStartDateOfNextProgram"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadMiniProgram/GetStartDateOfNextProgram",baseABBBC];
    }
    else if ([api isEqualToString:@"DeleteQueuedProgram"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadMiniProgram/DeleteQueuedProgram",baseABBBC];
    }else if ([api isEqualToString:@"UpdateProgram"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadMiniProgram/UpdateProgram",baseABBBC];
    }
    else if ([api isEqualToString:@"GetDatesForResetExercisePlan"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadMiniProgram/GetDatesForResetExercisePlan",baseABBBC];
    }else if ([api isEqualToString:@"GetDatesForResetNutritionPlan"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/SquadMiniProgram/GetDatesForResetNutritionPlan",baseABBBC];
    }else if ([api isEqualToString:@"ResetExercisePlan"] ) {//Add_new
        urlString =[urlString stringByAppendingFormat:@"%@/SquadMiniProgram/ResetExercisePlan",baseABBBC];
    }else if ([api isEqualToString:@"ResetNutritionPlan"] ) {//Add_new
        urlString =[urlString stringByAppendingFormat:@"%@/SquadMiniProgram/ResetNutritionPlan",baseABBBC];
    }else if ([api isEqualToString:@"CancelMiniProgram"] ) {//Add_new
        urlString =[urlString stringByAppendingFormat:@"%@/SquadMiniProgram/CancelMiniProgram",baseABBBC];
    }
    
    //Gamification
    else if ([api isEqualToString:@"GetSquadUserActionProfile"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/user/GetSquadUserActionProfile",baseABBBC];
        
    }
    else if ([api isEqualToString:@"GetUserRewardPoints"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/user/GetUserRewardPoints",baseABBBC];
        
    }else if ([api isEqualToString:@"GetSquadMoreRewards"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/user/GetSquadMoreRewards",baseABBBC];
    }
    //food prep
    else if([api isEqualToString:@"GetMealCalorie"]){
        urlString = [urlString stringByAppendingFormat:@"%@/nutrition/GetMealCalorie",baseABBBC];
        
    }else if([api isEqualToString:@"GetSquadUserAvoidIngredientGroup"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/GetSquadUserAvoidIngredientGroup",baseABBBC];
        
    }else if([api isEqualToString:@"AvoidIngredientGroup"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/AvoidIngredientGroup",baseABBBC];
        
    }else if([api isEqualToString:@"RemoveAvoidIngredientGroup"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/RemoveAvoidIngredientGroup",baseABBBC];
        
    }else if([api isEqualToString:@"GetFoodPrepIngredientMeal"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Nutrition/GetFoodPrepIngredientMeal",baseABBBC];
        
    }
    //Multiple SWAP
    else if([api isEqualToString:@"SquadMultipleUpdateMealForSession"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/SquadMultipleUpdateMealForSession",baseABBBC];
        
    }
    //shabbir
    else if([api isEqualToString:@"GetSavedAnalysingNutritionSearchList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/GetSavedAnalysingNutritionSearchList",baseABBBC];
        
    }else if([api isEqualToString:@"DeleteSavedAnalysingNutritionSearch"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/DeleteSavedAnalysingNutritionSearch",baseABBBC];
        
    }else if([api isEqualToString:@"GetNutritionAnalysingMealIngredientDetail"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/GetNutritionAnalysingMealIngredientDetail",baseABBBC];
        
    }else if([api isEqualToString:@"GetNutritionAnalysingEmotionMealDetail"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/GetNutritionAnalysingEmotionMealDetail",baseABBBC];
        
    }else if([api isEqualToString:@"GetNutritionAnalysingMealDetail"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/GetNutritionAnalysingMealDetail",baseABBBC];
        
    }else if([api isEqualToString:@"SaveSearchAnalysingNutrition"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/SaveSearchAnalysingNutrition",baseABBBC];
        
    }else if ([api isEqualToString:@"AddSquadUserAction"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/user/AddSquadUserAction",baseABBBC];
    }
    else if ([api isEqualToString:@"CheckMiniProgramForNutrition"] ) {//CheckRevert
        urlString =[urlString stringByAppendingFormat:@"%@/SquadMiniProgram/CheckMiniProgramForNutrition",baseABBBC];
    }
    else if ([api isEqualToString:@"CheckMiniProgramForExercise"] ) {//CheckRevert
        urlString =[urlString stringByAppendingFormat:@"%@/SquadMiniProgram/CheckMiniProgramForExercise",baseABBBC];
    }
    //save meal plan
    else if([api isEqualToString:@"SquadUserSavedMealPlan"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/SquadUserSavedMealPlan",baseABBBC];
        
    }else if([api isEqualToString:@"GetSquadUserSavedMealPlan"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/GetSquadUserSavedMealPlan",baseABBBC];
        
    }else if([api isEqualToString:@"SwapSquadUserSavedMealPlanEntry"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/SwapSquadUserSavedMealPlanEntry",baseABBBC];
        
    }else if([api isEqualToString:@"UpdateSavedMealPlan"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/UpdateSavedMealPlan",baseABBBC];
        
    }else if([api isEqualToString:@"DeleteSavedMealPlan"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/DeleteSavedMealPlan",baseABBBC];
        
    }else if([api isEqualToString:@"GetSavedMealPlanUsage"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/GetSavedMealPlanUsage",baseABBBC];
        
    }
    //addSwapSession
    else if([api isEqualToString:@"GetWorkoutSessionsFromDate"]){
        urlString = [urlString stringByAppendingFormat:@"%@/SquadDailySession/GetWorkoutSessionsFromDate",baseABBBC];
        
    }else if([api isEqualToString:@"AddSwapCustomSession"]){
        urlString = [urlString stringByAppendingFormat:@"%@/SquadDailySession/AddSwapCustomSession",baseABBBC];
        
    }
    else if([api isEqualToString:@"ResetMealPlanForSquadUserFromSavedPlan"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/ResetMealPlanForSquadUserFromSavedPlan",baseABBBC];
        
    }
    //Personal Challenge
    else if([api isEqualToString:@"GetMyPersonalChallenge"]){
        urlString = [urlString stringByAppendingFormat:@"%@/PersonalChallenge/GetMyPersonalChallenge",base];
        
    }else if([api isEqualToString:@"GetPersonalChallenge"]){
        urlString = [urlString stringByAppendingFormat:@"%@/PersonalChallenge/GetPersonalChallenge",base];
        
    }else if([api isEqualToString:@"GetParticipantsList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/PersonalChallenge/GetParticipantsList",base];
        
    }else if([api isEqualToString:@"DeleteMyChallenge"]){
        urlString = [urlString stringByAppendingFormat:@"%@/PersonalChallenge/DeleteMyChallenge",base];
        
    }else if([api isEqualToString:@"GetChatData"]){
        urlString = [urlString stringByAppendingFormat:@"%@/PersonalChallenge/GetChatData",base];
        
    }else if([api isEqualToString:@"ToggleChallengeShareStatus"]){
        urlString = [urlString stringByAppendingFormat:@"%@/ToggleChallengeShareStatus",base];
        
    }else if([api isEqualToString:@"UpdatePersonalChallengeReminder"]){
        urlString = [urlString stringByAppendingFormat:@"%@/UpdatePersonalChallengeReminder",base];
        
    }else if([api isEqualToString:@"JoinSquadChallenge"]){
        urlString = [urlString stringByAppendingFormat:@"%@/PersonalChallenge/JoinSquadChallenge",base];
        
    }else if([api isEqualToString:@"AddPersonalChallenge"]){
        urlString = [urlString stringByAppendingFormat:@"%@/PersonalChallenge/AddPersonalChallenge",base];
        
    }else if([api isEqualToString:@"JoinChallenge"]){
        urlString = [urlString stringByAppendingFormat:@"%@/PersonalChallenge/JoinChallenge",base];
        
    }else if([api isEqualToString:@"PersonalChallengeCalendarView"]){
        urlString = [urlString stringByAppendingFormat:@"%@/PersonalChallenge/PersonalChallengeCalendarView",base];
        
    }else if([api isEqualToString:@"TogglePersonalChallengeTask"]){
        urlString = [urlString stringByAppendingFormat:@"%@/PersonalChallenge/TogglePersonalChallengeTask",base];
        
    }else if([api isEqualToString:@"GetAppHomePageValues"]){
        urlString = [urlString stringByAppendingFormat:@"%@/GetAppHomePageValues",base];
        
    }else if([api isEqualToString:@"InAppPurchaseErrorReport"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqMember/InAppPurchaseErrorReport",base];
        
    }else if([api isEqualToString:@"UpdateUnitPreference"]){
        urlString = [urlString stringByAppendingFormat:@"%@/UpdateUnitPreference",base];
        
    }else if([api isEqualToString:@"UpdateRoundingFlag"]){
        urlString = [urlString stringByAppendingFormat:@"%@/UpdateRoundingFlag",base];
        
    }
    else if([api isEqualToString:@"SetGoalsOrderAPI"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/SetGoalsOrderAPI",base];
        
    }
    else if([api isEqualToString:@"GetFindBuddyRequestList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/FindBuddy/GetFindBuddyRequestList",base];
        
    }else if([api isEqualToString:@"AddUpdateFindBuddyDetail"]){
        urlString = [urlString stringByAppendingFormat:@"%@/FindBuddy/AddUpdateFindBuddyDetail",base];
        
    }else if([api isEqualToString:@"FindBuddyRequestExists"]){
        urlString = [urlString stringByAppendingFormat:@"%@/FindBuddy/FindBuddyRequestExists",base];
        
    }else if([api isEqualToString:@"AddUpdateFindBuddyRequestWithPhoto"]){
        urlString = [urlString stringByAppendingFormat:@"%@/FindBuddy/AddUpdateFindBuddyRequestWithPhoto",base];
        
    }else if([api isEqualToString:@"GetFoodDetails"]){
        urlString = [urlString stringByAppendingFormat:@"%@",FOOD_SCAN_API];
        
    }else if([api isEqualToString:@"GoalVisionBoardStatementList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/GoalVisionBoardStatementList",base];
        
    }else if([api isEqualToString:@"UpdateVisionBoardStatement"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/UpdateVisionBoardStatement",base];
        
    }else if([api isEqualToString:@"UpdateTrialDate"]){
        urlString = [urlString stringByAppendingFormat:@"%@/UpdateTrialDate/UpdateTrialDate",base];
        
    }else if([api isEqualToString:@"DeleteVisionBoardImage"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/DeleteVisionBoardImage",base];
        
    }else if([api isEqualToString:@"GetUserQuestionnaireAttemptList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Questionnaire/GetUserQuestionnaireAttemptList",base];
        
    }else if([api isEqualToString:@"AddUpdateUserQuestionnaireAttemptDetails"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Questionnaire/AddUpdateUserQuestionnaireAttemptDetails",base];
        
    }else if([api isEqualToString:@"AddUpdateUserQuestionnaireCohenStressScaleAnswerList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Questionnaire/AddUpdateUserQuestionnaireCohenStressScaleAnswerList",base];
        
    }else if([api isEqualToString:@"GetUserQuestionnaireAttemptDetails"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Questionnaire/GetUserQuestionnaireAttemptDetails",base];
        
    }else if([api isEqualToString:@"AddUpdateUserQuestionnaireRahePerceivedStressAnswerList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Questionnaire/AddUpdateUserQuestionnaireRahePerceivedStressAnswerList",base];
        
    }else if([api isEqualToString:@"AddUpdateUserQuestionnaireHappinessAnswerList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Questionnaire/AddUpdateUserQuestionnaireHappinessAnswerList",base];
        
    }else if([api isEqualToString:@"GetUserQuestionnaireAttemptListMixedType"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Questionnaire/GetUserQuestionnaireAttemptListMixedType",base];
        
    }else if([api isEqualToString:@"DeleteUserQuestionnaire"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Questionnaire/DeleteUserQuestionnaire",base];
        
    }else if([api isEqualToString:@"IsValidMbHQUser"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqMember/IsValidMbHQUser",base];
        
    }else if([api isEqualToString:@"GetFrequentMeals"]){
        urlString = [urlString stringByAppendingFormat:@"%@/nutrition/GetFrequentMeals",baseABBBC];
        
    }else if([api isEqualToString:@"SearchAllFood"]){
        urlString = [urlString stringByAppendingFormat:@"%@/meal/SearchAllFood",baseABBBC];
        
    }else if([api isEqualToString:@"SearchCalHistory"]){
        urlString = [urlString stringByAppendingFormat:@"%@/nutrition/SearchCalHistory",baseABBBC];
        
    }else if([api isEqualToString:@"CalHistoryEmail"]){
        urlString = [urlString stringByAppendingFormat:@"%@/nutrition/CalHistoryEmail",baseABBBC];
        
    }else if([api isEqualToString:@"GetWaterLevel"]){
        urlString = [urlString stringByAppendingFormat:@"%@/GetWaterLevel",base];
        
    }else if([api isEqualToString:@"AddUpdateWaterTrack"]){
        urlString = [urlString stringByAppendingFormat:@"%@/AddUpdateWaterTrack",base];
        
    }else if([api isEqualToString:@"AddUpdateWaterGoal"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Water/AddUpdateWaterGoal",base];
        
    }else if([api isEqualToString:@"GetVitaminTasks"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Vitamin/GetVitaminTasks",base];
        
    }else if([api isEqualToString:@"UpdateTaskStatus"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Vitamin/UpdateTaskStatus",base];
        
    }else if([api isEqualToString:@"AddUpdateUserVitamin"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Vitamin/AddUpdateUserVitamin",base];
        
    }else if([api isEqualToString:@"GetUserVitamin"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Vitamin/GetUserVitamin",base];
        
    }else if([api isEqualToString:@"DeleteUserVitamin"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Vitamin/DeleteUserVitamin",base];
        
    }else if([api isEqualToString:@"GetGratitudeStreakData"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/GetGratitudeStreakData",base];
    }else if([api isEqualToString:@"LogAppUsage"]){
        urlString = [urlString stringByAppendingFormat:@"%@/AppStreak/LogAppUsage",base];
        
    }else if([api isEqualToString:@"TurnUserVitaminReminderOff"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Vitamin/TurnUserVitaminReminderOff",base];
        
    }else if([api isEqualToString:@"NutritionixMealSearchById"]){
        urlString = [urlString stringByAppendingFormat:@"%@/search/item?nix_item_id=",NutritionixURL];
        
    }else if([api isEqualToString:@"NutritionixMealSearchByUpc"]){
        urlString = [urlString stringByAppendingFormat:@"%@/search/item?upc=",NutritionixURL];
        
    }
    else if([api isEqualToString:@"GetLatestWeightData"]){
        urlString = [urlString stringByAppendingFormat:@"%@/UserBmr/GetLatestWeightData",base];
        
    }else if([api isEqualToString:@"SetBMRData"]){
        urlString = [urlString stringByAppendingFormat:@"%@/UserBmr/SetBMRData",base];
        
    }else if([api isEqualToString:@"GetUserPersonalFoods"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadnourish/GetUserPersonalFoods",baseABBBC];
        
    }else if([api isEqualToString:@"GetUserVitaminGroups"]){
        urlString = [urlString stringByAppendingFormat:@"%@/Vitamin/GetUserVitaminGroups",base];
        
    }else if([api isEqualToString:@"GetRecentlyAddedMeal"]){
        urlString = [urlString stringByAppendingFormat:@"%@/nutrition/GetRecentlyAddedMeal",baseABBBC];
        
    }else if([api isEqualToString:@"GetUnreadMessageCountForMbhqUser"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqCourse/GetUnreadMessageCountForMbhqUser",base];
        
    }else if([api isEqualToString:@"GetUserCourseMessagesByAuthors"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqCourse/GetUserCourseMessagesByAuthors",base];
        
    }else if([api isEqualToString:@"SearchAndEmailGratitudeList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/SearchAndEmailGratitudeList",base];
        
    }else if([api isEqualToString:@"UpdateVideoTime"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqCourse/UpdateVideoTime",base];
        
    }else if([api isEqualToString:@"MarkMessageRead"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqCourse/MarkMessageRead",base];
        
    }else if([api isEqualToString:@"GetUserSquadMiniProgramDetail"]){
        urlString = [urlString stringByAppendingFormat:@"%@/SquadMiniProgram/GetUserSquadMiniProgramDetail",baseABBBC];
        
    }else if([api isEqualToString:@"GetUserHabitSwaps"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/GetUserHabitSwaps",base];
        
    }else if([api isEqualToString:@"SearchUserHabitSwaps"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/SearchUserHabitSwaps",base];
        
    }else if([api isEqualToString:@"AddUpdateHabitSwap"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/AddUpdateHabitSwap",base];
        
    }else if([api isEqualToString:@"GetHabitStats"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/GetHabitStats",base];
        
    }else if([api isEqualToString:@"UpdateTaskStatusForHabit"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/UpdateTaskStatus",base];
        
    }else if([api isEqualToString:@"UpdateTaskNote"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/UpdateTaskNote",base];
        
    }else if([api isEqualToString:@"GetUserHabitSwap"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/GetUserHabitSwap",base];
        
    }else if([api isEqualToString:@"UpdateHabitSwapManualOrder"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/UpdateHabitSwapManualOrder",base];
        
    }else if([api isEqualToString:@"DeleteHabitSwap"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/DeleteHabitSwap",base];
    }else if([api isEqualToString:@"UpdateHabitStatus"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/UpdateHabitStatus",base];
    }else if([api isEqualToString:@"HasNewNotifications"]){
        urlString = [urlString stringByAppendingFormat:@"%@/squadcourse/HasNewNotifications",base];
        
    }else if ([api isEqualToString:@"UpdateCourseStatus"] ) {
    urlString =[urlString stringByAppendingFormat:@"%@/MbhqCourse/UpdateCourseStatus",base];
        
    }else if([api isEqualToString:@"ToggleMessageNotificationFlag"]){
    urlString = [urlString stringByAppendingFormat:@"%@/MbhqCourse/ToggleMessageNotificationFlag",base];
        
    }else if([api isEqualToString:@"ToggleSeminarNotificationFlag"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqCourse/ToggleSeminarNotificationFlag",base];
    }else if([api isEqualToString:@"UpdatePassword"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqMember/UpdatePassword",base];
    }else if([api isEqualToString:@"GetGrowthHomePage"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/GetGrowthHomePage",base];
    }else if([api isEqualToString:@"GetGrowthHomePageHabitOnly"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/GetGrowthHomePageHabitOnly",base];
    }else if([api isEqualToString:@"ChangeBucketStatusAPI"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/ChangeBucketStatusAPI",base];
    }else if([api isEqualToString:@"CommumityAPI"]){
        urlString = [urlString stringByAppendingFormat:@"http://13.237.18.166/mbhq/api/auth"];
    }else if([api isEqualToString:@"UpdateBucketListManualOrder"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/UpdateBucketListManualOrder",base];
    }else if([api isEqualToString:@"GetVisionBoardStatementImages"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/GetVisionBoardStatementImages",base];
    }else if([api isEqualToString:@"AddUpdateVisionBoardStatementImage"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/AddUpdateVisionBoardStatementImage",base];
    }else if([api isEqualToString:@"EmailUserHabitSwaps"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/EmailUserHabitSwaps",base];
    }else if([api isEqualToString:@"EmailReverseBucketList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/EmailReverseBucketList",base];
    }else if([api isEqualToString:@"EmailGoalVisionBoardStatementList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/EmailGoalVisionBoardStatementList",base];
    }else if([api isEqualToString:@"AddUpdateGratitudeList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/AddUpdateGratitudeList",base];
    }else if([api isEqualToString:@"AddUpdateMultiReverseBucketList"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/AddUpdateMultiReverseBucketList",base];
    }else if([api isEqualToString:@"UpdateEventItemVideoTime"]){
        urlString = [urlString stringByAppendingFormat:@"%@/UpdateEventItemVideoTime",base];
    }else if([api isEqualToString:@"UploadUniqueMbhqImage"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/UploadUniqueMbhqImage",base];
    }else if([api isEqualToString:@"UpdateTaskStatusForMultiple"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/UpdateMultipleTaskStatus",base];
    }else if([api isEqualToString:@"UpdateHabitStatsPreference"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqMember/UpdateHabitStatsPreference",base];
    }else if([api isEqualToString:@"GetHabitTemplates"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/GetHabitTemplates",base];
    }else if([api isEqualToString:@"UpdateHabitWeeklyOverview"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqMember/UpdateWeeklyOverviewFlag",base];
    }else if([api isEqualToString:@"GetHabitWeeklyOverview"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqMember/GetWeeklyOverviewFlag",base];
    }
    else if([api isEqualToString:@"GetEventDetailsBySearchTagLite"]){
        urlString = [urlString stringByAppendingFormat:@"%@/user/GetEventDetailsBySearchTagLite",base];
    }
    else if([api isEqualToString:@"IsCacheExpired"]){
           urlString = [urlString stringByAppendingFormat:@"%@/MbhqMember/IsCacheExpired",base];
       }
    else if([api isEqualToString:@"GetMeditationCacheExpiryTime"]){
             urlString = [urlString stringByAppendingFormat:@"%@/MbhqMember/GetMeditationCacheExpiryTime",base];
      }
    else if ([api isEqualToString:@"GetWinTheWeekStats"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetWinTheWeekStats",base];
    }
    else if ([api isEqualToString:@"GetTaskStatusForDate"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/GetTaskStatusForDate",base];
    }
    else if ([api isEqualToString:@"UpdateBadgeShown"] ) {
        urlString =[urlString stringByAppendingFormat:@"%@/mindset/UpdateBadgeShown",base];
    }
    else if([api isEqualToString:@"SearchMbhqLiveChatByTag"]){
           urlString = [urlString stringByAppendingFormat:@"%@/user/SearchMbhqLiveChatByTag",base];
    }else if([api isEqualToString:@"GetMbhqLiveChatTags"]){
           urlString = [urlString stringByAppendingFormat:@"%@/user/GetMbhqLiveChatTags",base];
    }else if([api isEqualToString:@"GetGuidedMeditationsBySearchTag"]){
           urlString = [urlString stringByAppendingFormat:@"%@/user/GetGuidedMeditationsBySearchTag",base];
    }
    
    else if([api isEqualToString:@"UpdateAutoCompleteHabitFlag"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqMember/UpdateAutoCompleteHabitFlag",base];
    }else if([api isEqualToString:@"GetAutoCompleteHabitFlag"]){
        urlString = [urlString stringByAppendingFormat:@"%@/MbhqMember/GetAutoCompleteHabitFlag",base];
    }
    else if([api isEqualToString:@"getCoachToken"]){
        urlString = [urlString stringByAppendingFormat:@"%@/coach/GetCoachToken",base];
    }else if([api isEqualToString:@"GetMeditationStreakData"]){
        urlString = [urlString stringByAppendingFormat:@"%@/mindset/GetMeditationStreakData",base];
    }
         
    
    return urlString;
}
+(NSDictionary *)replaceDictionaryNullValue:(NSDictionary *)dict{
    NSMutableDictionary *mutableDict = [dict mutableCopy];
    for (NSString *key in [dict allKeys]) {
        if ([dict[key] class] ==[NSNull class] || [dict[key] isEqual:[NSNull null]] || ([dict[key] class] ==[NSString class] && [dict[key] isEqualToString:@"<null>"])) {
            mutableDict[key] = @"";//or [NSNull null] or whatever value you want to change it to
        }
    }
    dict = [mutableDict copy];
    return dict;
}
+ (NSMutableURLRequest *)getRequest:(NSString *)jsonString api:(NSString *)api append:(NSString *)appendString forAction:(NSString *)action{
    NSString *urlString=[Utility getUrl:api];
    if (appendString.length > 0) {
        urlString = [urlString stringByAppendingFormat:@"/%@",appendString];
    }
    // create request object with that URL
    NSLog(@"Request URL: %@",urlString);
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:100];
    [request setHTTPMethod:action];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:API_TOKEN forHTTPHeaderField:@"X-Auth-Token"];
    [request setValue:X_DOMAIN forHTTPHeaderField:@"X-Domain"];
    
    if (jsonString.length>0) {
        NSLog(@"Request Data: %@",jsonString);
        NSString *post = [NSString stringWithFormat:@"%@", jsonString];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        [request setHTTPBody: postData];
    }
    return  request;
}





+ (NSMutableURLRequest *)getRequestForNutritionix:(NSString *)jsonString api:(NSString *)api append:(NSString *)appendString forAction:(NSString *)action{
    NSString *urlString=[Utility getUrl:api];
    if (appendString.length > 0) {
        urlString = [urlString stringByAppendingFormat:@"%@",appendString];
    }
    // create request object with that URL
    NSLog(@"Request URL: %@",urlString);
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:100];
    [request setHTTPMethod:action];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:Nutr_app_id forHTTPHeaderField:@"x-app-id"];
    [request setValue:Nutr_app_key forHTTPHeaderField:@"x-app-key"];
    
    if (jsonString.length>0) {
        NSLog(@"Request Data: %@",jsonString);
        NSString *post = [NSString stringWithFormat:@"%@", jsonString];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        [request setHTTPBody: postData];
    }
    return  request;
}
//SetProgram_In
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}
//SetProgram_In

+(NSDictionary*)getPointsImage:(double)point{ //gami_badge_popup
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *imageStr;
    NSString *colorcode;
    NSString *pointRange;
    if (point>=0 && point<=50) {
        imageStr = @"SAPPHIRE";
        colorcode = @"333398";
        pointRange = @"0 - 50";
    }else if (point>=51 && point<=100){
        imageStr = @"RUBY";
        colorcode = @"bb1a43";
        pointRange = @"50 - 100";
        
    }else if (point>=101 && point<=200){
        imageStr = @"EMERALD";
        colorcode = @"019775";
        pointRange = @"100 - 200";
        
    }else if (point>=201 && point<=300){
        imageStr = @"SILVER";
        colorcode = @"d7d7d7";
        pointRange = @"200 - 300";
        
    }else if (point>=301 && point<=400){
        imageStr = @"GOLD";
        colorcode = @"c9af63";
        pointRange = @"300 - 400";
        
    }else if (point>=401 && point<=500){
        imageStr = @"PURPLE";
        colorcode = @"663398";
        pointRange = @"400 - 500";
        
    }else if (point>=501 && point<=750){
        imageStr = @"TURQUOISE";
        colorcode = @"64aea7";
        pointRange = @"500 - 750";
        
    }else if (point>=751 && point<=1000){
        imageStr = @"ORANGE";
        colorcode = @"ff7300";
        pointRange = @"750 - 1000";
        
    }else if (point>=1001 && point<=1500){
        imageStr = @"GREEN";
        colorcode = @"31a200";
        pointRange = @"1000 - 1500";
        
    }else if (point>=1501 && point<=2000){
        imageStr = @"NAVY BLUE";
        colorcode = @"142954";
        pointRange = @"1500 - 2000";
        
    }else if (point>=2001 && point<=3000){
        imageStr = @"SKY BLUE";
        colorcode = @"91e1fc";
        pointRange = @"2000 - 3000";
        
    }else if (point>=3001 && point<=5000){//5000
        imageStr = @"YELLOW";
        colorcode = @"ffd402";
        pointRange = @"3000 - 5000";
        
    }else if (point>=5001 && point<=10000){//5001
        imageStr = @"RED";
        colorcode = @"e21c45";
        pointRange = @"5000 - 10000";
        
    }else if (point>=10001 && point<=25000){
        imageStr = @"PINK";
        colorcode = @"ee9cb3";
        pointRange = @"10000 - 25000";
        
    }else if (point>25000){
        imageStr = @"BLACK";
        colorcode = @"231f20";
        pointRange = @"25000";
    }else{
        imageStr = @"";
        colorcode = @"";
        pointRange = @"";
    }
    
    [dict setObject:imageStr forKey:@"imageText"];
    [dict setObject:colorcode forKey:@"colorCode"];
    [dict setObject:pointRange forKey:@"pointRange"];
    return dict;
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return  [UIColor grayColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+ (BOOL) validateEmail: (NSString *) email {
    // VALIDATE EMAIL ADDRESS
    email = [email lowercaseString];
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    /*
     email = [email lowercaseString];
     BOOL stricterFilter = NO;
     NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
     NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
     NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
     NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
     return [emailTest evaluateWithObject:email];
     */
    
}

+ (BOOL)  validatePhoneNumber: (NSString *)  phone{
    BOOL phoneCheck=false;
    NSArray *phoneRegexArray=[[NSArray alloc]initWithObjects:@"\\d{2}-\\d{10}", nil];
    // NSArray *phoneRegexArray=[[NSArray alloc]initWithObjects:@"\\d{3}-\\d{3}-\\d{4}",@"\\(\\d{3}\\)\\ \\d{3}-\\d{4}",@"\\d{3}\\ \\d{3}\\ \\d{4}",@"\\d{3}.\\d{3}.\\d{4}",@"\\d{10}", nil];
    // NSString *phoneRegex = @"\\d{3}-\\d{3}-\\d{4}";
    //{"\\d{3}-\\d{3}-\\d{4}","\\(\\d{3}\\)\\ \\d{3}-\\d{4}","\\d{3}\\ \\d{3}\\ \\d{4}","\\d{3}.\\d{3}.\\d{4}","\\d{10}"}
    for (NSString *phoneRegex in phoneRegexArray) {
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        if([phoneTest evaluateWithObject:phone]){
            phoneCheck=TRUE;
            break;
        }
    }
    return phoneCheck;
}

+ (NSMutableURLRequest *)uploadImageWithFileName:(NSString *)fileName withapi:(NSString *)api append:(NSString *)appendString {
    
    //  NSError *error;
    
    NSURL *outputFileURL;
    NSString *urlString= [Utility getUrl:api];
    if (appendString.length > 0) {
        urlString =[urlString stringByAppendingFormat:@"/%@",appendString];
    }
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               fileName,
                               nil];
    outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"shopkeeper" forHTTPHeaderField:@"apps"];
    if([defaults objectForKey:@"auth"]){
        [request setValue:[defaults objectForKey:@"auth"] forHTTPHeaderField:@"authentication"];
    }
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"image.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithContentsOfURL:outputFileURL]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    return request;
}
//gami_badge_popup
+(void)showBadgePopUp:(UIViewController*)controller ofType:(NSString*)type withcolourCode:(NSString*)colourcodeStr ofRange:(NSString*)range{
    
    if([self isSquadFreeUser] || [self isSquadLiteUser]) return;
    /*
     BadgePopUpViewController *custom = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BadgePopUpView"];
     custom.type = type;
     custom.colourCode = colourcodeStr;
     custom.pointRange = range;
     custom.modalPresentationStyle = UIModalPresentationCustom;
     if([controller isKindOfClass:[UINavigationController class]]){
     UINavigationController *nav = (UINavigationController *)controller;
     [nav presentViewController:custom animated:YES completion:nil];
     }else if([controller isKindOfClass:[MasterMenuViewController class]]){
     MasterMenuViewController *master = (MasterMenuViewController *)controller;
     [master.transitionsNavigationController presentViewController:custom animated:YES completion:nil];
     }else{
     [controller presentViewController:custom animated:YES completion:nil];
     }
     */
}
//gami_badge_popup

+(NSString *)convertOneDateFormatStringToAnother:(NSString *)dateString fromDateFormat:(NSString *)fromDateFormat toDateFormat:(NSString *)toDateFormat{
    //Dec 20,2016
    NSDate *date = [self convertStringToDate:dateString dateFormat:fromDateFormat];
    //2016-12-27T00:00:00
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // converting into our required date format
    dateFormatter.dateFormat = toDateFormat;
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;
}
+(NSDate *)convertStringToDate:(NSString *)dateString dateFormat:(NSString *)dateFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSZ"];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *date  = [dateFormatter dateFromString:dateString];//2016-12-27 18:30:00 +0000
    if (date == nil) {
        date =[NSDate date];
    }
    return date;
}

+(NSMutableURLRequest *)uploadvideoWithData:(NSDictionary *)dataDict withapi:(NSString *)api{
    
    //  NSError *error;
    
    NSURL *outputFileURL;
    NSString *urlString= [Utility getUrl:api];
    NSString *scoreId=[@"" stringByAppendingFormat:@"%@",[dataDict objectForKey:@"Id"]];
    
    if (scoreId.length > 0) {
        urlString =[urlString stringByAppendingFormat:@"?id=%@",scoreId];
    }
    
    outputFileURL = [NSURL URLWithString:[dataDict objectForKey:@"MobilePath"]];
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"video.mov\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithContentsOfURL:outputFileURL]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    return request;
    
}

+ (CGRect)contentViewWithOrientationForMasterView{
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = CGRectMake(0, 0, [screen bounds].size.width, [screen bounds].size.height);
    return fullScreenRect;
}
+ (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

+ (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return  [UIColor grayColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}



+ (UILabel*)nodataFound:(NSString *)str originY:(int)originY fontSize:(float)fontSize{
    UILabel *msg;
    UIScreen *screen = [UIScreen mainScreen];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft){
            msg=[[UILabel alloc]initWithFrame:CGRectMake(0, originY, [screen bounds].size.height, 20)];
        }
        else{
            msg=[[UILabel alloc]initWithFrame:CGRectMake(0, originY, [screen bounds].size.width, 20)];
        }
        msg.font=[UIFont systemFontOfSize:fontSize];
    }
    else {
        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft){
            msg=[[UILabel alloc]initWithFrame:CGRectMake(0, originY, [screen bounds].size.height, 20)];
        }
        else{
            msg=[[UILabel alloc]initWithFrame:CGRectMake(0, originY, [screen bounds].size.width, 20)];
        }
        msg.font=[UIFont systemFontOfSize:fontSize];
    }
    msg.backgroundColor=[UIColor clearColor];
    msg.text=str;
    msg.textColor=[UIColor blackColor];
    msg.textAlignment=NSTextAlignmentCenter;
    return msg;
}




+ (BOOL)containsKey: (NSString *)key dictionary:(NSMutableDictionary *)dict {
    BOOL retVal = 0;
    NSArray *allKeys = [dict allKeys];
    retVal = [allKeys containsObject:key];
    return retVal;
}



+ (NSMutableAttributedString *)setSuperscript_StringName:(NSString *)string location:(NSUInteger)location length:(NSUInteger)length mainFont:(UIFont*)mainFont subFont:(UIFont*)subFont{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:string
                                                   attributes:@{NSFontAttributeName: mainFont}];
    [attributedString setAttributes:@{NSFontAttributeName : subFont,
                                      NSBaselineOffsetAttributeName : @10}
                              range:NSMakeRange(location, length)];
    return attributedString;
}

+ (UIImage *)scaleImage:(UIImage *)originalImage width:(int)width height:(int)height{
    float actualHeight = originalImage.size.height;
    float actualWidth = originalImage.size.width;
    if (actualWidth >= width) {
        float imgRatio = actualWidth/actualHeight;
        float maxRatio = width/height;
        //if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = height / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = height;
        }
        else{
            imgRatio = width / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = width;
        }
        // }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [originalImage drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    scaledImage=[UIImage imageWithData:UIImageJPEGRepresentation(scaledImage, 0.2)];
    return scaledImage;
}
+ (UIImage *)resizeImage:(UIImage *)image withMaxDimension:(CGFloat)maxDimension{
    if (fmax(image.size.width, image.size.height) <= maxDimension) {
        return image;
    }
    
    CGFloat aspect = image.size.width / image.size.height;
    CGSize newSize;
    
    if (image.size.width > image.size.height) {
        newSize = CGSizeMake(maxDimension, maxDimension / aspect);
    } else {
        newSize = CGSizeMake(maxDimension * aspect, maxDimension);
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    CGRect newImageRect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
    [image drawInRect:newImageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(NSString *)formatTimeFromSeconds:(int)numberOfSeconds
{
    
    //int seconds = numberOfSeconds % 60;
    int minutes = (numberOfSeconds / 60) % 60;
    int hours = numberOfSeconds / 3600;
    
    //we have >=1 hour => example : 3h:25m
    if (hours) {
        return [NSString stringWithFormat:@"%dH:%02dMIN", hours, minutes];
    }
    //    //we have 0 hours and >=1 minutes => example : 3m:25s
    //    if (minutes) {
    //        return [NSString stringWithFormat:@"%dm:%02ds", minutes, seconds];
    //    }
    //we have only seconds example : 25s
    return [NSString stringWithFormat:@"%d MIN", minutes];
}


+(NSDate *) nextMondayDate{
//    NSCalendar *_calendar = [NSCalendar currentCalendar];
//    NSDate *date = [NSDate date];
    NSInteger daysToMonday;
    NSInteger day_of_week = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:[NSDate date]];
    if (day_of_week==2) {
        daysToMonday = 7;
    }else{
        daysToMonday = (9 - day_of_week) % 7;
    }
    NSDate *dateMonday=[[NSDate date] dateByAddingDays:daysToMonday];
    
    return dateMonday;
}

+(NSString *) durationStringFromSeconds:(int)totalSeconds includeSeconds:(BOOL)includeSeconds{
    NSString *durationStr=@"";
    int hours = totalSeconds / 3600;
    int minutes = (totalSeconds / 60) % 60;
    int seconds= totalSeconds%60;
    NSString *hourStr=@"";
    NSString *minStr=@"";
    NSString *secStr=@"";
    
    if ( hours==1) {
        hourStr=@"1 Hour";
    }else if (hours>1){
        hourStr=[@"" stringByAppendingFormat:@"%d Hours",hours];
    }
    if ( minutes==1) {
        minStr=@"1 Minute";
    }else if (minutes>1){
        minStr=[@"" stringByAppendingFormat:@"%d Minutes",minutes];
    }
    if ( seconds==1) {
        secStr=@"1 Second";
    }else if (seconds>1){
        secStr=[@"" stringByAppendingFormat:@"%d Seconds",minutes];
    }
        
    if (includeSeconds) {
        durationStr=[hourStr stringByAppendingFormat:@" %@ %@",minStr,secStr];
    }else{
        durationStr=[hourStr stringByAppendingFormat:@" %@",minStr];
    }
    
    return durationStr;
}

+(NSString *) selectedDayStringForReminder:(NSDictionary *)dict{
    NSString *str=@"";
    if ([[dict objectForKey:@"Sunday"] intValue]==1) {
       str = [str stringByAppendingFormat:@"Sun "];
    }
    if ([[dict objectForKey:@"Monday"] intValue]==1) {
        str = [str stringByAppendingFormat:@"Mon "];
    }
    if ([[dict objectForKey:@"Tuesday"] intValue]==1) {
        str = [str stringByAppendingFormat:@"Tue "];
    }
    if ([[dict objectForKey:@"Wednesday"] intValue]==1) {
        str = [str stringByAppendingFormat:@"Wed "];
    }
    if ([[dict objectForKey:@"Thursday"] intValue]==1) {
        str = [str stringByAppendingFormat:@"Thu "];
    }
    if ([[dict objectForKey:@"Friday"] intValue]==1) {
        str = [str stringByAppendingFormat:@"Fri "];
    }
    if ([[dict objectForKey:@"Saturday"] intValue]==1) {
        str = [str stringByAppendingFormat:@"Sat "];
    }
    
    return str;
}


+(void)updateCourseVideoTime:(NSDictionary *)courseDict videoStartTime:(double)videoStartTime{
    if (Utility.reachable) {
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[courseDict objectForKey:@"ArticleId"] forKey:@"ArticleId"];
        NSNumber *videoId = [[[courseDict objectForKey:@"DataDict"] objectForKey:@"Videos"]objectAtIndex:0];
        [mainDict setObject:videoId forKey:@"VideoId"];
        [mainDict setObject:[NSString stringWithFormat:@"%f",videoStartTime] forKey:@"Time"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:nil haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateVideoTime" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                     }
                                                                     else{
//                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:nil haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
//                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:nil haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:nil haveToPop:NO];
    }
    
}


+(void)updateWebinarVideoTime:(NSDictionary *)webinar videoStartTime:(double)videoStartTime{
    if (Utility.reachable) {
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        [mainDict setObject:[webinar objectForKey:@"EventItemID"] forKey:@"EventItemId"];
        
        NSString *appUrl=@"";
        NSArray *videoUrls = [webinar objectForKey:@"EventItemVideoDetails"];
        if (![Utility isEmptyCheck:videoUrls] && videoUrls.count > 0) {
            NSDictionary *appUrlDict =[videoUrls objectAtIndex:0];
            if (![Utility isEmptyCheck:[appUrlDict objectForKey:@"AppURL"]] ) {
                appUrl =[appUrlDict objectForKey:@"AppURL"];
            }
        }
        [mainDict setObject:appUrl forKey:@"VideoUrl"];
        
        [mainDict setObject:[NSString stringWithFormat:@"%f",videoStartTime] forKey:@"Time"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:nil haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateEventItemVideoTime" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadWebinarList" object:self userInfo:nil];
                                                                     }
                                                                     else{
                                                                         //[Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                    // [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
       // [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}


+(void)updateWebinarVideoTime_offline:(NSMutableDictionary *)webinar{
   if(![Utility isEmptyCheck:webinar]){
        
        NSError *error;
        NSData *webinardata = [NSJSONSerialization dataWithJSONObject:webinar options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            NSLog(@"Error Favorite Array-%@",error.debugDescription);
            return;
        }
        
        NSString *detailsString = [[NSString alloc] initWithData:webinardata encoding:NSUTF8StringEncoding];
        int eventItemId = [[webinar objectForKey:@"EventItemID"] intValue];
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        if([DBQuery isRowExist:@"meditationList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and EventId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:eventItemId]]]){
             [DBQuery updateMeditationDetails:detailsString with:eventItemId];
         }else{
             [DBQuery addMeditationData:detailsString with:eventItemId];
        }
    }
}



+(void)saveWebinarVideoStartTimeIntoTable:(NSDictionary *)webinar videoStartTime:(double)videoStartTime{
    if(![Utility isEmptyCheck:webinar]){
        NSMutableDictionary *videoTimeDict=[[NSMutableDictionary alloc] init];
        [videoTimeDict setObject:[NSNumber numberWithDouble:videoStartTime] forKey:@"Time"];
        
        NSError *error;
        NSData *videoTimeData = [NSJSONSerialization dataWithJSONObject:videoTimeDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            NSLog(@"Error Favorite Array-%@",error.debugDescription);
            return;
        }
        
        NSString *detailsString = [[NSString alloc] initWithData:videoTimeData encoding:NSUTF8StringEncoding];
        int eventItemId = [[webinar objectForKey:@"EventItemID"] intValue];
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        if([DBQuery isRowExist:@"webniarTimeTable" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and EventItemId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:eventItemId]]]){
             [DBQuery updateMeditationTime:detailsString with:eventItemId];
         }else{
             [DBQuery addMeditationTime:detailsString with:eventItemId];
        }
    }
}

+(void)saveShareAlert:(NSDictionary*)dict with:(UIViewController*)vc{
    UIAlertController *alertController = [UIAlertController
                                               alertControllerWithTitle:@"Share Type"
                                               message:@""
                                               preferredStyle:UIAlertControllerStyleActionSheet];
         UIAlertAction *action1 = [UIAlertAction
                                    actionWithTitle:@"Text and Pic"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
                                    {
                                       GratitudePopUpViewController *controller =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudePopUpView"];
                                       controller.modalPresentationStyle = UIModalPresentationCustom;
                                       controller.dict = dict;
                                       controller.type = @"TextWithPic";
                                        if ([vc isKindOfClass:[NotesViewController class]]) {
                                            controller.controller = vc;
                                        }
                                       [vc presentViewController:controller animated:YES completion:nil];
                                    }];
         UIAlertAction *action2 = [UIAlertAction
                                        actionWithTitle:@"Text over pic"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action)
                                        {
                                           GratitudePopUpViewController *controller =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudePopUpView"];
                                            controller.modalPresentationStyle = UIModalPresentationCustom;
                                            controller.dict = dict;
                                            controller.type = @"TextOverPic";
                                            if ([vc isKindOfClass:[NotesViewController class]]) {
                                                controller.controller = vc;
                                            }
                                            [vc presentViewController:controller animated:YES completion:nil];
                                        }];
         UIAlertAction *action3 = [UIAlertAction
                                           actionWithTitle:@"Text only"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                            GratitudePopUpViewController *controller =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudePopUpView"];
                                               controller.modalPresentationStyle = UIModalPresentationCustom;
                                               controller.dict = dict;
                                               controller.type = @"";
                                            if ([vc isKindOfClass:[NotesViewController class]]) {
                                                controller.controller = vc;
                                                }
                                                [vc presentViewController:controller animated:YES completion:nil];
                                           }];
//        UIAlertAction *action4 = [UIAlertAction
//                                     actionWithTitle:@"Cancel"
//                                     style:UIAlertActionStyleCancel
//                                     handler:^(UIAlertAction *action)
//                                     {
//
//       }];
         [alertController addAction:action1];
         [alertController addAction:action2];
         [alertController addAction:action3];
//         [alertController addAction:action4];
         [vc presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - Save image to and get image from documentDirectory
+ (void)saveImageToDocumentDirectoryFromImageUrl:(NSString *)imageUrlString imageName:(NSString *)imageName {
    NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
    NSString *fileNameString=[imageUrl lastPathComponent];
    if (imageName.length > 0) {
        fileNameString = imageName;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:fileNameString];
    NSData *imagedata = [[NSData alloc]initWithContentsOfURL:imageUrl];
    [imagedata writeToFile:savedImagePath atomically:NO];
}


+ (UIImage *)getImageFromDocumentDirectoryWithImageName:(NSString *)imageName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
}

+ (void)removeImage:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    NSLog(@"%d",success);
}

+ (void)writeImageInDocumentsDirectory:(UIImage *)image imageName:(NSString *)imageName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO];
}


+(BOOL)deleteImageInDocumentsDirectory:(NSString *)imageName{
    BOOL success;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    success = [fileManager removeItemAtPath:savedImagePath error:&error];
    return success;
}
+ (UIView *)activityIndicatorView:(UIViewController  *)controller withMsg:(NSString *)msg font:(UIFont *)font color:(UIColor *)color{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIView *contentView=[[UIView alloc]initWithFrame:screenRect];
    contentView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:.7f];
    [controller.view addSubview:contentView];
    [contentView.centerXAnchor constraintEqualToAnchor:contentView.superview.centerXAnchor].active = true;
    [contentView.centerYAnchor constraintEqualToAnchor:contentView.superview.centerYAnchor].active = true;
    [contentView.widthAnchor constraintEqualToAnchor:contentView.superview.widthAnchor].active = true;
    [contentView.heightAnchor constraintEqualToAnchor:contentView.superview.heightAnchor].active = true;
    
    UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    msgLabel.numberOfLines = 0;
    msgLabel.translatesAutoresizingMaskIntoConstraints = NO;
    msgLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview: msgLabel];
    [msgLabel.centerXAnchor constraintEqualToAnchor:msgLabel.superview.centerXAnchor].active = true;
    [contentView.centerYAnchor constraintEqualToAnchor:msgLabel.bottomAnchor constant:5].active = true;
    [msgLabel.widthAnchor constraintEqualToAnchor:msgLabel.superview.widthAnchor multiplier:0.8f].active = true;
    msgLabel.text = msg;
    msgLabel.font = font ? font :[UIFont systemFontOfSize:13];
    msgLabel.textColor = color;
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame= CGRectMake(contentView.frame.size.width/2,20, 24, 24);
    activityView.color =[UIColor grayColor];
    [activityView startAnimating];
    [activityView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [contentView addSubview: activityView];
    [activityView.centerXAnchor constraintEqualToAnchor:activityView.superview.centerXAnchor].active = true;
    [activityView.topAnchor constraintEqualToAnchor:contentView.centerYAnchor constant:5].active = true;
    
    return contentView;
}
+ (UIView *)activityIndicatorView:(UIViewController  *)controller{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIView *contentView=[[UIView alloc]initWithFrame:screenRect];
    contentView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:.7f];
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame= CGRectMake(contentView.frame.size.width/2,20, 24, 24);
    activityView.color =[UIColor grayColor];
    activityView.center=contentView.center;
    [activityView startAnimating];
    [activityView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //animated loader
    //    UIImageView *activityView = [UIImageView new];
    //    activityView.image = [UIImage animatedImageNamed:@"animation-" duration:1.0f];
    //    activityView.frame = CGRectMake(contentView.frame.size.width/2,20, 128, 128);
    ////    activityView.color =[UIColor grayColor];
    //    activityView.center = contentView.center;
    ////    [activityView startAnimating];
    //    [activityView setTranslatesAutoresizingMaskIntoConstraints:NO];
    //
    
    [contentView addSubview: activityView];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:activityView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0
                                                             constant:0.0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:activityView
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0
                                                             constant:0.0]];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [controller.view addSubview:contentView];
    
    
    [controller.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:controller.view
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0
                                                                 constant:0.0]];
    [controller.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:controller.view
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1.0
                                                                 constant:0.0]];
    [controller.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:controller.view
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0
                                                                 constant:0.0]];
    [controller.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:controller.view
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0
                                                                 constant:0.0]];
    return contentView;
    
}
+ (UIView *)overlayActivityIndicatorView:(UIViewController  *)controller {  //ah ov
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIView *contentView=[[UIView alloc]initWithFrame:screenRect];
    contentView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:.1f];
    
    [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [controller.view addSubview:contentView];
    
    
    [controller.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:controller.view
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0
                                                                 constant:0.0]];
    [controller.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:controller.view
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1.0
                                                                 constant:0.0]];
    [controller.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:controller.view
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0
                                                                 constant:0.0]];
    [controller.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:controller.view
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0
                                                                 constant:0.0]];
    return contentView;
    
}
+(NSMutableAttributedString *)getStringWithHeader:(NSString *)headerString headerFont:(UIFont *)headerFont headerColor:(UIColor *)headerColor bodyString:(NSString *)bodyString bodyFont:(UIFont *)bodyFont BodyColor:(UIColor *)BodyColor{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:headerString];
    [attributedString addAttribute:NSFontAttributeName value:headerFont range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:headerColor range:NSMakeRange(0, [attributedString length])];
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:bodyString];
    [attributedString2 addAttribute:NSFontAttributeName value:bodyFont range:NSMakeRange(0, [attributedString2 length])];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:BodyColor range:NSMakeRange(0, [attributedString2 length])];
    
    [attributedString appendAttributedString:attributedString2];
    return  attributedString;
}
+ (NSString *)daySuffixForDate:(NSDate *)date {     //ah 17
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger dayOfMonth = [calendar component:NSCalendarUnitDay fromDate:date];
    switch (dayOfMonth) {
        case 1:
        case 21:
        case 31: return @"st";
        case 2:
        case 22: return @"nd";
        case 3:
        case 23: return @"rd";
        default: return @"th";
    }
}

+(NSMutableURLRequest *)getRequestForSpofity:(NSString *)jsonString api:(NSString *)api append:(NSString *)appendString forAction:(NSString *)action accessToken:(NSString *)accessToken url:(NSString *)urlStr{
    if ([urlStr length] == 0) {
        urlStr = [Utility getUrlForSpofity:api append:appendString accessToken:accessToken];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:90];
    [request setHTTPMethod:action];
    //    [request setValue:@"customer" forHTTPHeaderField:@"apps"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];  //ah
    //    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    // NSLog(@"%@",[defaults objectForKey:@"auth"]);
    if([defaults objectForKey:@"auth"]){
        [request setValue:[defaults objectForKey:@"auth"] forHTTPHeaderField:@"authentication"];
    }
    if (jsonString.length>0) {
        NSString *post = [NSString stringWithFormat:@"%@", jsonString];
        //NSLog(@"post~~~~~~>>>>> %@",post);
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
        [request setHTTPBody: postData];
    }
    NSLog(@"re %@",request);
    return  request;
}

+(NSString *)getUrlForSpofity:(NSString *)api append:(NSString *)appendString accessToken:(NSString *)accessToken{
    NSString *string=@"";
    
    NSString * base=@"https://api.spotify.com/v1/";
    
    if ([api isEqualToString:@"profile"] ) {
        string =[string stringByAppendingFormat:@"%@me/?access_token=%@",base,accessToken];
    } else if ([api isEqualToString:@"playlists"] ) {
        string =[string stringByAppendingFormat:@"%@users/%@/playlists/?access_token=%@",base,appendString,accessToken];
        //string=@"https://api.spotify.com/v1/albums";
    } else if ([api isEqualToString:@"tracks"] ) {
        string =[string stringByAppendingFormat:@"%@users/%@/playlists/?access_token=%@",base,appendString,accessToken];
    }else if ([api isEqualToString:@"featureList"] ) {
        //string =[string stringByAppendingFormat:@"%@browse/featured-playlists/?access_token=%@",base,accessToken];
        string =[string stringByAppendingFormat:@"%@playlists/5fnIgGf2n3KSkZ7x8Z1YhL?access_token=%@",base,accessToken];
        //        string =[string stringByAppendingFormat:@"%@users/%@/playlists/5fnIgGf2n3KSkZ7x8Z1YhL?access_token=%@",base,appendString,accessToken];
    }else if([api isEqualToString:@"songList"]){
        string =[string stringByAppendingFormat:@"%@playlists/%@/tracks?access_token=%@",base,appendString,accessToken];
    }
    
    //NSLog(@"urlstring~~~~~~~~~~~~~~~~> %@",string);tracks
    return string;
}
+ (NSArray *)shuffleFromArray:(NSMutableArray *)arr
{
    NSUInteger count = [arr count];
    if (count < 1) return nil;
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [arr exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    NSArray *newArr = [[NSArray alloc]init];
    newArr = [arr copy];
    return newArr;
}
+ (BOOL) isInt:(NSString *)toCheck {    //ah 2.2
    NSScanner* scan = [NSScanner scannerWithString:toCheck];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
+ (NSAttributedString *)htmlParseWithString:(NSString *)htmlString{
    // NSString * htmlString = [[totalSortedArray objectAtIndex:i] objectForKey:@"labelname"];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
    
}
+(NSDictionary *)getDictByValue:(NSArray *)filterArray value:(id)value type:(NSString *)type{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",type, value];
    NSArray *filteredSessionCategoryArray = [filterArray filteredArrayUsingPredicate:predicate];
    if (filteredSessionCategoryArray.count > 0) {
        NSDictionary *dict = [filteredSessionCategoryArray objectAtIndex:0];
        return dict;
    }
    return  nil;
}
+(NSMutableAttributedString *)convertString:(NSString *)str ToMutableAttributedStringOfFont:(NSString *)font Size:(CGFloat)size WithRangeString:(NSString *)rangeStr RangeFont:(NSString *)rangeFont Size:(CGFloat)rangeSize {      //ah cpn
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:font size:size] range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:rangeFont size:rangeSize] range:[str rangeOfString:rangeStr]];
    [attrString endEditing];
    
    return attrString;
}
+ (void) showToastInsideView:(UIView *)toastSuperView WithMessage:(NSString *)toastMessage {    //ah edit
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageFont = [UIFont fontWithName:@"Raleway-Medium" size:14.0];
    style.messageColor = [UIColor whiteColor];
    style.messageAlignment = NSTextAlignmentCenter;
    style.backgroundColor = [UIColor blackColor];
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGPoint toastPoint = CGPointMake(screenWidth/2, screenHeight-100);
    [toastSuperView makeToast:toastMessage
                     duration:2.0
                     position:[NSValue valueWithCGPoint:toastPoint]
                        style:style];
}

+ (BOOL)compareImage:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}


//chayan
+ (void)showHelpAlertWithURL:(NSString*)str controller:(UIViewController *)controller haveToPop:(BOOL)haveToPop{
    
    if(haveToPop)
    {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Please Note"
                                              message:@"On every main page there is a [i] in the top right. Click to learn all the tricks so you can get the absolute most from Squad. (you may need wifi to play this video)."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"PLAY"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       //Added For Firebase tutorial_begin Tracking AY 21032018
                                       [FIRAnalytics logEventWithName:@"tutorial_begin" parameters:nil];
                                       //End
                                       
                                       HelpVideoPlayerViewController *helpVideoPlayerViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpVideoPlayerView"];
                                       helpVideoPlayerViewController.modalPresentationStyle = UIModalPresentationCustom;
                                       helpVideoPlayerViewController.videoURLString = str;
                                       helpVideoPlayerViewController.delegate = controller;
                                       [controller presentViewController:helpVideoPlayerViewController animated:YES completion:nil];
                                       
                                   }];
        [alertController addAction:okAction];
        
        [controller presentViewController:alertController animated:YES completion:nil];
        //        [defaults setBool:NO forKey:@"isFirstTimeHelp"];
    }
    else
    {
        //Added For Firebase tutorial_begin Tracking AY 21032018
        [FIRAnalytics logEventWithName:@"tutorial_begin" parameters:nil];
        //End
        
        HelpVideoPlayerViewController *helpVideoPlayerViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpVideoPlayerView"];
        helpVideoPlayerViewController.modalPresentationStyle = UIModalPresentationCustom;
        helpVideoPlayerViewController.videoURLString = str;
        //        if ([controller isKindOfClass: [VisionHomeViewController class]]) {
        //            helpVideoPlayerViewController.delegate = controller;
        //        }else if ([controller.parentViewController isKindOfClass:[VisionHomeViewController class]]) {
        //            helpVideoPlayerViewController.delegate = controller.parentViewController;
        //        }
        [controller presentViewController:helpVideoPlayerViewController animated:YES completion:nil];
    }
    
}


#pragma mark-Update Leanplum User Attributes
+(void)updateLeanPlumUserAttributes:(NSDictionary *)dataDict{
    
    //    [Leanplum setUserAttributes:@{@"Name": [NSNull null]}];
    //    [Leanplum setUserAttributes:@{@"Age": [NSNull null]}];
    
    
    /*  if(![self isEmptyCheck:dataDict[@"FirstName"]]){
     [Leanplum setUserAttributes:@{@"FirstName": dataDict[@"FirstName"]}];
     }
     
     if(![self isEmptyCheck:dataDict[@"LastName"]]){
     [Leanplum setUserAttributes:@{@"LastName": dataDict[@"LastName"]}];
     }
     
     if(![self isEmptyCheck:dataDict[@"EmailAddress"]]){
     [Leanplum setUserAttributes:@{@"EmailAddress": dataDict[@"EmailAddress"]}];
     }
     
     if(![self isEmptyCheck:dataDict[@"PhoneNumber"]]){
     [Leanplum setUserAttributes:@{@"PhoneNumber": dataDict[@"PhoneNumber"]}];
     }
     
     if(![self isEmptyCheck:dataDict[@"FbWorldForumUrl"]]){
     [Leanplum setUserAttributes:@{@"FbWorldForumUrl": dataDict[@"FbWorldForumUrl"]}];
     }
     
     if(![self isEmptyCheck:dataDict[@"FbCityForumUrl"]]){
     [Leanplum setUserAttributes:@{@"FbCityForumUrl": dataDict[@"FbCityForumUrl"]}];
     }
     
     if(![self isEmptyCheck:dataDict[@"FbSuburbForumUrl"]]){
     [Leanplum setUserAttributes:@{@"FbSuburbForumUrl": dataDict[@"FbSuburbForumUrl"]}];
     }
     
     if(![self isEmptyCheck:dataDict[@"CityName"]]){
     [Leanplum setUserAttributes:@{@"CityName": dataDict[@"CityName"]}];
     }
     
     if(![self isEmptyCheck:dataDict[@"SubrubName"]]){
     [Leanplum setUserAttributes:@{@"SubrubName": dataDict[@"SubrubName"]}];
     }
     
     if(![self isEmptyCheck:dataDict[@"CountryName"]]){
     [Leanplum setUserAttributes:@{@"CountryName": dataDict[@"CountryName"]}];
     }
     
     [Leanplum setUserAttributes:@{@"HasLife": [NSNumber numberWithBool:[dataDict[@"HasLife"] boolValue]]}];
     [Leanplum setUserAttributes:@{@"HasBootyTrial": [NSNumber numberWithBool:[dataDict[@"HasBootyTrial"] boolValue]]}];
     [Leanplum setUserAttributes:@{@"HasAbsTrial": [NSNumber numberWithBool:[dataDict[@"HasAbsTrial"] boolValue]]}];
     
     [Leanplum setUserAttributes:@{@"HasLifeTrial": [NSNumber numberWithBool:[dataDict[@"HasLifeTrial"] boolValue]]}];
     [Leanplum setUserAttributes:@{@"HasFinishedAbsTrial": [NSNumber numberWithBool:[dataDict[@"HasFinishedAbsTrial"] boolValue]]}];
     
     [Leanplum setUserAttributes:@{@"HasFinishedBootyTrial": [NSNumber numberWithBool:[dataDict[@"HasFinishedBootyTrial"] boolValue]]}];
     
     [Leanplum setUserAttributes:@{@"IsBootyCustomer": [NSNumber numberWithBool:[dataDict[@"IsBootyCustomer"] boolValue]]}];
     
     [Leanplum setUserAttributes:@{@"IsAbsCustomer": [NSNumber numberWithBool:[dataDict[@"IsAbsCustomer"] boolValue]]}];
     
     [Leanplum setUserAttributes:@{@"IsBCCustomer": [NSNumber numberWithBool:[dataDict[@"IsBCCustomer"] boolValue]]}];
     
     [Leanplum setUserAttributes:@{@"IsTCCustomer": [NSNumber numberWithBool:[dataDict[@"IsTCCustomer"] boolValue]]}];
     
     [Leanplum setUserAttributes:@{@"HasUltimateResultsPack": [NSNumber numberWithBool:[dataDict[@"HasUltimateResultsPack"] boolValue]]}];
     
     [Leanplum setUserAttributes:@{@"HasUtopia": [NSNumber numberWithBool:[dataDict[@"HasUtopia"] boolValue]]}];*/
    
}

   
#pragma mark-End
#pragma mark-Offline Image Saved
+(void)saveImageDetails:(NSString*)localImageName imagetype:(int)imageType Itemid:(int)item_Id existingImageChange:(BOOL)isExistingImageChange selectedImage:(UIImage*)chooseImage{
    
    if(!chooseImage) return;
    
    if (![Utility isEmptyCheck:localImageName]) {
         int userId = [[defaults objectForKey:@"UserID"] intValue];

         if([DBQuery isRowExist:@"LocalImageSync" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and Image_type = '%d' and Item_Id = '%d'",[NSNumber numberWithInt:userId],imageType,item_Id]]){
             if (isExistingImageChange) {
                 BOOL isUpdate =[DBQuery updateImageLocally:imageType itemId:item_Id imagename:localImageName issync:0];
                 if (isUpdate) {
                     isExistingImageChange = false;
                    [self uploadFile:@"UploadUniqueMbhqImage" image:chooseImage withName:localImageName imageType:imageType itemId:item_Id ];
                 }
             }
         }else{
             BOOL isAdd =  [DBQuery addImageLocally:imageType itemId:item_Id imagename:localImageName issync:0];
             if (isAdd) {
                  [self uploadFile:@"UploadUniqueMbhqImage" image:chooseImage withName:localImageName imageType:imageType itemId:item_Id ];
             }
         }
     }
}
#pragma mark-End
#pragma mark - audio Download
//ahd
- (void) downloadSessionConfiguration {
    audioNameArray = [[NSMutableArray alloc] init];
    audioDownloadCount = 0;
    
    audioNameArray = [@[@{@"name":@"Awesome job!",@"duration":@"2"},
                        @{@"name":@"Feel the burn!",@"duration":@"3"},
                        @{@"name":@"Hold!!",@"duration":@"3"},
                        @{@"name":@"I know it's tough, but you're tougher!",@"duration":@"4"},
                        @{@"name":@"Control your reps and keep that range! Don't cheat yourself!",@"duration":@"6"},
                        @{@"name":@"I know your legs are burning right now but don't you dare quit!",@"duration":@"5"},
                        @{@"name":@"I refuse to quit!",@"duration":@"3"},
                        @{@"name":@"If everything you ever wanted was on the other side of this workout -",@"duration":@"7"},
                        @{@"name":@"Keep your form, no shortcuts!",@"duration":@"3"},
                        @{@"name":@"If you're feeling tired or sore, ask yourself why you started!",@"duration":@"7"},
                        @{@"name":@"Keep it Up! You're Killing it!",@"duration":@"3"},
                        @{@"name":@"Keep Pushing Babe",@"duration":@"3"},
                        @{@"name":@"Killing it Babe! Keep up the Good Work!",@"duration":@"3"},
                        @{@"name":@"Looking good babe, keep smashing it!",@"duration":@"3"},
                        @{@"name":@"Lock that Core, Stop yourself from peeing, Bellybutton to spine",@"duration":@"6"},
                        @{@"name":@"Love it!",@"duration":@"2"},
                        @{@"name":@"Nothing worth having comes easy. Keep Pushing!",@"duration":@"5"},
                        @{@"name":@"Remember why you came to training today!",@"duration":@"4"},
                        @{@"name":@"Stay with me! Keep pushing babe!",@"duration":@"4"},
                        @{@"name":@"Lock your core and squeeze your gluts!",@"duration":@"4"},
                        @{@"name":@"We don't stop when we're tired, we stop when we're done!",@"duration":@"5"},
                        @{@"name":@"We're coming home strong now! It's the downhill run, you've got this!",@"duration":@"4"},
                        @{@"name":@"We're over halfway now babe, home stretch! You've got this",@"duration":@"5"},
                        @{@"name":@"We've Got This",@"duration":@"2"},
                        @{@"name":@"What was I thinking putting this in the program!_",@"duration":@"5"},
                        @{@"name":@"This is a tough one, keep your core turned on and control!",@"duration":@"5"},
                        @{@"name":@"You are doing so well! Lets finish it off.",@"duration":@"5"},
                        @{@"name":@"You are one amazing lady! Keep that shit up!",@"duration":@"4"},
                        @{@"name":@"You are unstoppable!",@"duration":@"4"},
                        @{@"name":@"You can do anything for just 30 seconds, stay strong!",@"duration":@"5"},
                        @{@"name":@"You seriously are wonderwoman, smash it up!",@"duration":@"4"},
                        @{@"name":@"You've Got This",@"duration":@"2"},
                        @{@"name":@"Your mind will quit before your body gives up!",@"duration":@"5"}] mutableCopy];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.TheSquatHome"];
    sessionConfiguration.allowsCellularAccess = YES;
    session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                            delegate:self
                                       delegateQueue:nil];
    [self downloadAudioWithName:[[audioNameArray objectAtIndex:audioDownloadCount] objectForKey:@"name"]];
}

- (void) downloadAudioWithName:(NSString *) audioName {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",audioName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *destinationURL = [NSURL fileURLWithPath:fullPathToFile];
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]) {
        //don't download
        audioDownloadCount++;
        if (audioDownloadCount < audioNameArray.count) {
            [self downloadAudioWithName:[[audioNameArray objectAtIndex:audioDownloadCount] objectForKey:@"name"]];
        } else {
            [downloadTask suspend];
            [session finishTasksAndInvalidate];
            [session invalidateAndCancel];
            session = nil;
            audioDownloadCount = 0;
        }
    } else {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString *newAudioName = [audioName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            if (self->session) {
                //                    NSLog(@"url --> %@",[NSURL URLWithString:[NSString stringWithFormat:@"%@/content/audio/%@.wav",@"https://www.thesquadtours.com",newAudioName]]);
                self->downloadTask = [self->session downloadTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.wav",BASE_AUDIO_DOWNLOAD_URL,newAudioName]]];
                [self->downloadTask resume];
            }
        }];
    }
}

#pragma mark - NSURLSession Delegate method implementation

-(void)URLSession:(NSURLSession *)session1 downloadTask:(NSURLSessionDownloadTask *)downloadTask1 didFinishDownloadingToURL:(NSURL *)location{
    if (session1 == session) {
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *destinationFilename = downloadTask1.originalRequest.URL.lastPathComponent;
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:destinationFilename];
        NSURL *destinationURL = [NSURL fileURLWithPath:fullPathToFile];
        
        if ([fileManager fileExistsAtPath:[destinationURL path]]) {
            [fileManager removeItemAtURL:destinationURL error:nil];
        }
        
        BOOL success = [fileManager copyItemAtURL:location
                                            toURL:destinationURL
                                            error:&error];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                    NSLog(@"Download success. original main.");
                    NSLog(@"url %@",fullPathToFile);
                    audioDownloadCount++;
                    if (audioDownloadCount < audioNameArray.count) {
                        [self downloadAudioWithName:[[audioNameArray objectAtIndex:audioDownloadCount] objectForKey:@"name"]];
                    } else {
                        [defaults setBool:YES forKey:@"isAudioDownloaded"];
                        [downloadTask suspend];
                        [session finishTasksAndInvalidate];
                        [session invalidateAndCancel];
                        session = nil;
                        audioDownloadCount = 0;
                    }
                }else{
                    
                }
            }
            else{
                NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
            }
        }];
    }
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (error != nil) {
            NSLog(@"Download completed with error: %@", [error localizedDescription]);
        }
        else{
            //            NSLog(@"Download finished successfully.");
        }
    }];
}


-(void)URLSession:(NSURLSession *)session1 downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
            NSLog(@"Unknown transfer size");
            //            progress.hidden= true;
            
        }else{
            //            if ([progressView isDescendantOfView:self.view] && session1 == session) {
            //                double downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
            //                //            progressPercentageLabel.text = [NSString stringWithFormat:@"%d",(int)(downloadProgress * 100)];
            //                progressView.progress = downloadProgress;
            //            }
        }
    }];
}


-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    
}

- (void)URLSession:(NSURLSession *)session1 didBecomeInvalidWithError:(nullable NSError *)error {
    NSLog(@"Invalid session (%@) WithError %@",session1,error);
}

#pragma mark - instruction
//ah ov
+ (void) initializeInstructionAt:(UIViewController *)viewController OnViews:(NSArray *) overlayedViews {
    totalOverlayedViews = [Utility isEmptyCheck:totalOverlayedViews] ? overlayedViews : totalOverlayedViews;
    overlayedViews = ![Utility isEmptyCheck:overlayedViews] ? overlayedViews : totalOverlayedViews;
    if (overlayCount < overlayedViews.count) {
        UIView *newOverlayedView = [[overlayedViews objectAtIndex:overlayCount] objectForKey:@"view"];
        BOOL isOnTop = [[[overlayedViews objectAtIndex:overlayCount] objectForKey:@"onTop"] boolValue];
        NSString *instructionText = [[overlayedViews objectAtIndex:overlayCount] objectForKey:@"insText"];
        BOOL isCustomFrame = [[[overlayedViews objectAtIndex:overlayCount] objectForKey:@"isCustomFrame"] boolValue];
        if (![overlayContentView isDescendantOfView:viewController.view])
            overlayContentView = [Utility overlayActivityIndicatorView:viewController];
        if (isCustomFrame) {
            [Utility showCustomInstructionAt:viewController OnView:newOverlayedView OnTop:isOnTop InstructionText:instructionText CustomFrame:[[[overlayedViews objectAtIndex:overlayCount] objectForKey:@"frame"] CGRectValue]];
        }else {
            [Utility showInstructionAt:viewController OnView:newOverlayedView OnTop:isOnTop InstructionText:instructionText];
        }
    }else {
        overlayCount = 0;
        overlayContentView.hidden = true;
        totalOverlayedViews = nil;
        [overlayContentView removeFromSuperview];
    }
}

+(void) showInstructionAt:(UIViewController *)viewController OnView:(UIView *) overlayedView OnTop:(BOOL)isOnTop InstructionText:(NSString *) instructionText {
    popTip = [[AMPopTip alloc] init];
    AMPopTipDirection direction = isOnTop ? AMPopTipDirectionUp : AMPopTipDirectionDown;
    popTip.entranceAnimation = AMPopTipEntranceAnimationScale;
    popTip.actionAnimation = AMPopTipActionAnimationBounce;
    popTip.popoverColor = [self colorWithHexString:@"4cb4d6"];//87d2e4
    popTip.shouldDismissOnTap = YES;
    popTip.shouldDismissOnTapOutside = YES;
    popTip.font = [UIFont fontWithName:@"Raleway-Semibold" size:17.0];
    
    [popTip showText:instructionText direction:direction maxWidth:300 inView:viewController.view fromFrame:overlayedView.frame];
    
    [popTip setDismissHandler:^{
        overlayCount++;
        [Utility initializeInstructionAt:viewController OnViews:nil];
    }];
}
+(void) showCustomInstructionAt:(UIViewController *)viewController OnView:(UIView *) overlayedView OnTop:(BOOL)isOnTop InstructionText:(NSString *) instructionText CustomFrame:(CGRect)customFrame {
    popTip = [[AMPopTip alloc] init];
    AMPopTipDirection direction = isOnTop ? AMPopTipDirectionUp : AMPopTipDirectionDown;
    popTip.entranceAnimation = AMPopTipEntranceAnimationScale;
    popTip.actionAnimation = AMPopTipActionAnimationBounce;
    popTip.popoverColor = [self colorWithHexString:@"4cb4d6"];
    popTip.shouldDismissOnTap = YES;
    popTip.shouldDismissOnTapOutside = YES;
    popTip.font = [UIFont fontWithName:@"Raleway-Semibold" size:17.0];
    
    [popTip showText:instructionText direction:direction maxWidth:300 inView:viewController.view fromFrame:customFrame];
    
    [popTip setDismissHandler:^{
        overlayCount++;
        [Utility initializeInstructionAt:viewController OnViews:nil];
    }];
}

+(NSAttributedString *)getattributedMessage:(NSString *)msg{
    NSString *instructionString=[NSString stringWithFormat:@"<span style=\"font-family: Raleway; font-size: 15; color: grey;padding:5px 10px;display:block;text-align: center;\">%@</span>",msg];
    NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[instructionString dataUsingEncoding:NSUTF8StringEncoding]
                                                                         options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                   NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                   }
                                                              documentAttributes:nil error:nil];
    return strAttributed;
}
#pragma mark - Multipart Image Upload

+(NSMutableURLRequest *)uploadImageWithFileName:(NSString *)filename withapi:(NSString *)api append:(NSString *)appendString image:(UIImage *)image jsonString:(NSString *)jsonString {
    NSData * imagedata;
    if (image) {
        //imagedata = UIImageJPEGRepresentation(image, 0.4);
        imagedata = UIImagePNGRepresentation(image);
    }
    //    NSData * imagedata = UIImageJPEGRepresentation(image, 1.0);
    //    NSUInteger imageSize = imagedata.length;
    //    if (imageSize>=1000000) {
    //        imagedata = UIImageJPEGRepresentation(image, 0.4);
    //    }
    
    NSString *urlString=[self getUrl:api];
    if (appendString.length > 0) {
        urlString =[urlString stringByAppendingFormat:@"/%@",appendString];
    }
    
    //    NSString *filename = @"property";
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    if (image) {
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@.png\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[NSData dataWithData:imagedata]];
        [postbody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //     NSLog(@"\n json string: \n %@",jsonString);
    if (jsonString.length>0) {
        //        [postbody appendData:[[NSString stringWithFormat:@"%@\r\n", jsonString] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *post = [NSString stringWithFormat:@"%@", jsonString];
        
        [postbody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"jsonString\" \r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO]];
    }
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    return request;
}
+(void)uploadFile:(NSString *)api image:(UIImage *)image withName: (NSString *) name imageType:(int)imageType itemId:(int)itemId {
    
    if([Utility reachable]){
        dispatch_async(dispatch_get_main_queue(),^ {
        });
        NSData * file;
        if (image) {
            //imagedata = UIImageJPEGRepresentation(image, 0.4);
            file = UIImagePNGRepresentation(image);
        }
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:name forKey:@"ImageName"];
        [mainDict setObject:[NSNumber numberWithInt:imageType] forKey:@"ImageType"];
        [mainDict setObject:[NSNumber numberWithInt:itemId] forKey:@"UniqueId"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSError *error;
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
       if (error) {
           return;
       }
        
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[self getUrl:api] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if(file){
                 [formData appendPartWithFileData:file name:@"image" fileName:name mimeType:@"image/png"];
            }
            
            if(postData){
                [formData appendPartWithFormData:postData name:@"jsonString"];
            }
           
        } error:nil];
        
        NSLog(@"Request Data-%@",mainDict.debugDescription);
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          
                          dispatch_async(dispatch_get_main_queue(),^ {
                              if (error) {
                                  NSLog(@"Error: %@", error);
                                  
//                                  [Utility msg:error.localizedDescription title:NSLocalizedString(@"Alert", Nil) controller:self haveToPop:NO];
                                  
                              } else {
                                  
                                  //NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                  NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                                  NSLog(@"%@ %@", response, responseDict);
                                  
                                  if(![Utility isEmptyCheck:responseDict]){
                                      
                                      if([responseDict[@"SuccessFlag"] boolValue]){
                                          [DBQuery updateImageLocally:imageType itemId:itemId imagename:name issync:1];

                                      }
                                  }else{

                                  }
                              }
                          });
                          
                          
                          
                      }];
        
        [uploadTask resume];
        
    }else{

    }
}
+(NSMutableURLRequest *)uploadMultipleImage:(NSString *)filename withapi:(NSString *)api append:(NSString *)appendString imageData:(NSDictionary *)imageData jsonString:(NSString *)jsonString {
    
    //    NSDictionary *aParametersDic; // It's contains other parameters.
    //    NSDictionary *aImageDic; // It's contains multiple image data as value and a image name as key
    NSString *urlString = [self getUrl:api]; // an url where the request to be posted
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] initWithURL:url] ;
    
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postbody = [NSMutableData data];
    //    NSString *postData = [self getHTTPBodyParamsFromDictionary:aParametersDic boundary:boundary];
    //    [postbody appendData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    if (![Utility isEmptyCheck:imageData]) {
        [imageData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if(obj != nil)
            {
                [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@.png\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [postbody appendData:[NSData dataWithData:UIImagePNGRepresentation(obj)]];//obj]];//UIImagePNGRepresentation(image)
                [postbody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }];
    } else {
        NSData * imagedata;
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@.png\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[NSData dataWithData:imagedata]];
        [postbody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    //     NSLog(@"\n json string: \n %@",jsonString);
    if (jsonString.length>0) {
        //        [postbody appendData:[[NSString stringWithFormat:@"%@\r\n", jsonString] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *post = [NSString stringWithFormat:@"%@", jsonString];
        
        [postbody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"jsonString\" \r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO]];
    }
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    return request;
}
/*//create image data
 UIImage *image = ......
 NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
 
 UIImage *image2 = ......
 NSData *imageData2 = UIImageJPEGRepresentation(image2, 0.5);
 
 //Now add to array and also create array of images data
 NSArray *arrImagesData = [NSArray arrayWithObjects:imageData,imageData2,nil];
 
 //Create manager
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 //parameters if any
 NSDictionary *parameters = .......
 //Now post
 [manager POST:@"your url here" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 //add img data one by one
 for(int i=0; i<[arrImagesData count];i++)
 {
 NSData *imageData = arrImagesData[i];
 NSString *strName = [NSString stringWithFormat:@"name%d",i]
 [formData appendPartWithFormData:imageData name:strName];
 }
 
 
 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSLog(@"Success: %@", responseObject);
 
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"Error: %@", error);
 }];*/

#pragma mark - Get Database Path

+ (NSString *) getDBPath:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    //[self forfileLock];
    return [documentsDir stringByAppendingPathComponent:fileName];
}

#pragma mark - End

#pragma mark - isOffline User
+(BOOL)isOfflineMode{
    return [defaults boolForKey:@"isOffline"];
}
#pragma mark - End

#pragma mark- ChatSDK Login & Logout

+(void)loginToChatSDK:(NSDictionary *)dict isFb:(BOOL)isFb{
    
}
+(void)loginToChatSDK:(BOOL)isFb{
    
}

+(void)logoutChatSdk{
   
}
+(void)updateUserDetailsToFirebase{
    
    //Update user Name AY
    
    NSString *name=@"";
    
    if(![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]){
        name = [name stringByAppendingString:[defaults objectForKey:@"FirstName"]];
        
    }
    
    if(![Utility isEmptyCheck:[defaults objectForKey:@"LastName"]]){
        name =  [@"" stringByAppendingFormat:@"%@ %@",name,[defaults objectForKey:@"LastName"]];
        
    }
    
    
    NSString *profilePicUrl=@""; //images/members/PAl6GmmdCDQbdUukroOx.png.png
    
    if(![Utility isEmptyCheck:[defaults objectForKey:@"ProfilePicUrl"]]){
        profilePicUrl =  [@"" stringByAppendingFormat:@"%@/%@",BASEURL,[defaults objectForKey:@"ProfilePicUrl"]];
        
    }
    
//    NSString *fcmToken = [FIRMessaging messaging].FCMToken;
//    if(fcmToken){
////        [BChatSDK.currentUser setMetaValue:fcmToken forKey:bUserPushTokenKey];
//    }
//
//
//    [BIntegrationHelper updateUserWithName:name image:nil url:profilePicUrl];
    
    //End
    
    [self updateDataToFirebaseUserMetaUsingAPI];
    
}

+(void)UpdatePushTokenToFireBaseDBForChat{
    
//    //Update FCM Token
//    NSString *fcmToken = [FIRMessaging messaging].FCMToken;
//    if(fcmToken && [Utility isUserLoggedInToChatSdk]){
//        NSString * currentToken = [BChatSDK.currentUser.meta metaValueForKey:bUserPushTokenKey];
//
//        if((currentToken && ![currentToken isEqualToString: fcmToken]) || !currentToken) {
//
//            FIRDatabaseReference * ref = [FIRDatabaseReference userMetaRef:NM.currentUser.entityID];
//            [ref setValue:@{bUserPushTokenKey: fcmToken} withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
//                if (!error) {
//                    [BEntity pushUserMetaUpdated:NM.currentUser.entityID];
//                }
//                else {
//                    NSLog(@"Error Updating Push Token %@",error.debugDescription);
//                }
//            }];
//        }
//
//
//    }else{
//        NSLog(@"User Not Logged In");
//    }
//    //End
//
//
    
}

//+(void)updateDataToFirebaseUserMetaUsingAPI{
//    //AppDelegate *appDelegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
//
//    if(![Utility isUserLoggedInToChatSdk]) return;
//
//    if (Utility.reachable) {
//        NSURLSession *loginSession = [NSURLSession sharedSession];
//        NSError *error;
//
//        NSString *name=@"";
//
//        if(![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]){
//            name = [name stringByAppendingString:[defaults objectForKey:@"FirstName"]];
//
//        }
//
//        if(![Utility isEmptyCheck:[defaults objectForKey:@"LastName"]]){
//            name =  [@"" stringByAppendingFormat:@"%@ %@",name,[defaults objectForKey:@"LastName"]];
//
//        }
//
//        [BChatSDK.currentUser setName:name];
//        [BChatSDK.currentUser setMetaValue:name forKey:bUserNameLowercase];
//        NSString *profilePicUrl=@""; //images/members/PAl6GmmdCDQbdUukroOx.png.png
//
//        if(![Utility isEmptyCheck:[defaults objectForKey:@"ProfilePicUrl"]]){
//            profilePicUrl =  [@"" stringByAppendingFormat:@"%@/%@",BASEURL,[defaults objectForKey:@"ProfilePicUrl"]];
//
//        }
//
//        [BChatSDK.currentUser setImageURL:profilePicUrl];
//        NSDictionary *mainDict=BChatSDK.currentUser.meta;
//
//        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
//        if (error) {
//            return;
//        }
//        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
//        FIRDatabaseReference * ref = [FIRDatabaseReference userMetaRef:BChatSDK.currentUser.entityID];
//        NSString *urlStr = [@"" stringByAppendingFormat:@"%@.json?auth=%@",ref.description,BChatSDK.auth.loginInfo[bTokenKey]];
//
//        NSLog(@"Meta Data Update URL:%@",urlStr);
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:100];
//        [request setHTTPMethod:@"PATCH"];
//
//        if (jsonString.length>0) {
//            NSLog(@"Meta Data Request Data: %@",jsonString);
//            NSString *post = [NSString stringWithFormat:@"%@", jsonString];
//            NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
//            [request setHTTPBody: postData];
//        }
//
//
//
//        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
//                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                             if(error == nil)
//                                                             {
//                                                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//
//                                                                 if(httpResponse.statusCode == 200){
//                                                                     NSLog(@"User Meta Updated");
//                                                                     [BEntity pushUserMetaUpdated:BChatSDK.currentUser.entityID];
//
//                                                                     // We only want to do this if we are logged in
//                                                                     if (BChatSDK.auth.userAuthenticated) {
//                                                                         [BChatSDK.search updateIndexForUser:BChatSDK.currentUser];
//
//                                                                     }
//                                                                 }else{
//                                                                     NSLog(@"User Meta Update error status code:%ld",httpResponse.statusCode);
//
//
//                                                                 }
//
//                                                             }else{
//                                                                 NSLog(@"User Meta Update error : %@",error.localizedDescription);
//                                                             }
//                                                         }];
//        [dataTask resume];
//
//    }
//
//}

//+(void)sendFriendRequestWithPush:(NSString *)friendEmail messageDetails:(NSDictionary *)dict{
//    if(![Utility isEmptyCheck:friendEmail]){
//
//        NSString *email = friendEmail;
//
//        [NM.search usersForIndexes:@[bUserEmailKey] withValue:email limit: 1 userAdded: ^(id<PUser> user) {
//
//            // Make sure we run this on the main thread
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                if (user != Nil && user != NM.currentUser) {
//                    // Only display a user if they have a name set
//                    [NM.core createThreadWithUsers:@[user] threadCreated:^(NSError * error, id<PThread> thread) {
//
//                        if(!error){
//
//                            // Set the URLs for the images and save it in CoreData
//                            [[BStorageManager sharedManager].a beginUndoGroup];
//
//                            id<PMessage> message = [[BStorageManager sharedManager].a createEntity:bMessageEntity];
//
//                            id<PThread> newThread = [[BStorageManager sharedManager].a fetchEntityWithID:thread.entityID withType:bThreadEntity];
//
//                            message.type = @(bMessageTypeText);
//                            [message setTextAsDictionary:dict];
//
//                            message.date = [NSDate date];
//                            message.userModel = NM.core.currentUserModel;
//                            message.delivered = @NO;
//                            message.read = @YES;
//                            message.flagged = @NO;
//                            message.meta = dict;
//
//                            [newThread addMessage: message];
//
//                            [NM.core sendMessage:message];
//
//                        }//[NM.core sendMessageWithText:dict[@"body"] withThreadEntityID:thread.entityID withMetaData:dict];
//                    }];
//                }
//
//            });
//
//        }].thenOnMain(^id(id success) {
//
//
//
//            return Nil;
//        }, ^id(NSError * error) {
//
//            return error;
//        });
//
//
//    }
//}
+(BOOL)isUserLoggedInToChatSdk{
//    return [NM.core currentUserModel] != Nil;
    return false;
}
#pragma mark - End
#pragma mark - Cancel Free User Notification
+(void)cancelscheduleLocalNotificationsForFreeUser{
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    if(notifications && notifications.count>0){
        for(UILocalNotification *notification in notifications){
            NSDictionary *dict = notification.userInfo;
            
            if(![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"notificationType"]] && [[dict objectForKey:@"notificationType"] isEqualToString:@"freeUser"]){
                [[UIApplication sharedApplication]cancelLocalNotification:notification];
                
            }
            
        }
    }
    
}// AY 19022018

+(void)cancelscheduleLocalNotificationsForQuote{
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    if(notifications && notifications.count>0){
        for(UILocalNotification *notification in notifications){
            NSDictionary *dict = notification.userInfo;
            
            if(![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"notificationType"]] && [[dict objectForKey:@"notificationType"] isEqualToString:@"quote"]){
                
                if(([notification.fireDate isToday] && [defaults boolForKey:@"QuoteNotification"]) || [notification.fireDate isLaterThan:[NSDate date]]){
                    continue;
                }
                
                [[UIApplication sharedApplication]cancelLocalNotification:notification];
                
            }
            
        }
    }
    
}// AY 19022018

#pragma mark - End
#pragma mark - Add Gamification Point For World Forum
+(void)addGamificationPointWithData:(NSDictionary *)data{
    
    if (Utility.reachable) {
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if(![Utility isEmptyCheck:data[@"UserActionId"]]){
            [mainDict setObject:[NSNumber numberWithInt:[data[@"UserActionId"] intValue]] forKey:@"UserActionId"];
        }
        
        if(![Utility isEmptyCheck:data[@"ReferenceEntityId"]]){
            NSString *ReferenceEntityId = data[@"ReferenceEntityId"];
            if(ReferenceEntityId)[mainDict setObject:ReferenceEntityId forKey:@"ReferenceEntityId"];
        }
        
        if(![Utility isEmptyCheck:data[@"ReferenceEntityType"]]){
            [mainDict setObject:data[@"ReferenceEntityType"] forKey:@"ReferenceEntityType"];
        }
        
        
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddSquadUserAction" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             if(error == nil)
                                                             {
                                                                 NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                 
                                                                 NSLog(@"%@",responseString);
                                                                 
                                                                 NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                 if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                     //                                                                         NSString *iosDeviceID = [responseDict valueForKey:@"IosDeviceID"];
                                                                     
                                                                     
                                                                     //                                                                         if (![Utility isEmptyCheck:iosDeviceID] && [iosDeviceID isEqualToString:appDelegate.token]) {
                                                                     //                                                                             [defaults setBool:YES forKey:@"IsTokenSaved"];
                                                                     //                                                                         }
                                                                     
                                                                     
                                                                     
                                                                 }
                                                             }else{
                                                                 NSLog(@"%@",error.localizedDescription);
                                                             }
                                                         }];
        [dataTask resume];
        
    }
    
    
    
}
+(NSString *)customRoundNumber:(float)value{
    if(value > 0){
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 2;
        int ch = value * 1000.0;
        ch = ch % 10;
        if (ch >= 5) {
            formatter.roundingMode = NSNumberFormatterRoundUp;
        } else {
            formatter.roundingMode = NSNumberFormatterRoundDown;
        }
        
        NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
        //        NSLog(@"%@", numberString);
        return numberString;
    }else{
        return @"0";
    }
}
+(NSString *)getDateOnly:(NSString *)dateStr{
    if ([Utility isEmptyCheck:dateStr]) {
        return @"";
    }
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"T"];
    dateStr = [dateArr objectAtIndex:0];
    return dateStr;
}
#pragma mark - End
+(NSArray *)getInAppPurchaseFromJSON{
    NSError *error;
    NSString *filePath;
    filePath = [[NSBundle mainBundle] pathForResource:@"InAppPurchaseDetails" ofType:@"json"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSArray *quoteArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if(error){
        NSLog(@"JSON Read Error:%@",error.debugDescription);
        return nil;
    }
    
    return quoteArray;
}
#pragma mark - Quote
+(NSArray *)getQuoteListFromJSON{
    NSError *error;
    NSString *filePath;
    filePath = [[NSBundle mainBundle] pathForResource:@"Quote" ofType:@"json"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSArray *quoteArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if(error){
        NSLog(@"Quote Notification JSON Read Error:%@",error.debugDescription);
        return nil;
    }
    
    return quoteArray;
}
#pragma mark - End
#pragma mark - Today Page Move Conditions
+(BOOL)needToRedirectToTodayPage{
    BOOL isTrue = NO;
    
    //BOOL isSeenWelcomeVid =[[defaults objectForKey:@"isSeenWelcomeVid"] boolValue];
    BOOL isSpalshShown = true;//[defaults boolForKey:@"isSpalshShown"];//true;
    BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
    if(![Utility isSquadLiteUser] && ![Utility isOfflineMode] && isSpalshShown && isAllTaskCompleted){
        
        isTrue = YES;
        
    }
    
    return isTrue;
}
#pragma mark - End

+(void)removeDefaultObjects{
   
    [defaults removeObjectForKey:@"AchievePosition"];
    [defaults removeObjectForKey:@"TrainPosition"];
    [defaults removeObjectForKey:@"TrackPosition"];
    [defaults removeObjectForKey:@"CoursesPosition"];
    [defaults removeObjectForKey:@"todaySet"];
    [defaults removeObjectForKey:@"StreakCurrentDate"];
    [defaults removeObjectForKey:@"isTodayFirst"];
    [defaults removeObjectForKey:@"isFirstTimeCustom"];//SB
    [defaults removeObjectForKey:@"SelectMealAddIndex"];
    [defaults setBool:false forKey:@"IsPopUpShowForFreeMode"];
    [defaults setBool:false forKey:@"isFirstTimeGratitude"];
    [defaults setBool:false forKey:@"isFirstTimeBucket"];
    [defaults setBool:false forKey:@"isFirstTimeHabit"];
    [defaults removeObjectForKey:@"defaultStatesView"];
    [defaults removeObjectForKey:@"isFirstTimeVision"];
    [defaults setBool:false forKey:@"isFirstTimeMeditation"];
    [defaults removeObjectForKey:@"InappPurchaseRequestString"];
    [defaults removeObjectForKey:@"isFirstTimeForumLink"];
    [defaults removeObjectForKey:@"IsFromCommunity"];
    [defaults removeObjectForKey:@"FirstTimeLiveProgram"];
    [defaults removeObjectForKey:@"defaultStatesViewFromList"];
    [defaults removeObjectForKey:@"IsSubscribed"];
    [defaults removeObjectForKey:@"OnlyProgramMember"];
    [defaults setBool:false forKey:@"isFirstTimeCourse"];
    [defaults setBool:false forKey:@"isFirstTimeTest"];
    [defaults setBool:false forKey:@"isFirstTimeGratitude"];
    [defaults setBool:false forKey:@"isFirstTimeGrowth"];
    [defaults removeObjectForKey:@"CourseNameArray"];
    [defaults removeObjectForKey:@"defaultPopularHabitFrequency"];
    [defaults removeObjectForKey:@"isFirstTimeAeroplaneMode"];
    [defaults removeObjectForKey:@"isSyncApiAlreadyCal"];
    [defaults removeObjectForKey:@"timeLineTick"];
    [defaults removeObjectForKey:@"bucketListTimeLineFilterStatus"];
    [defaults removeObjectForKey:@"SortFilter"];
    [defaults removeObjectForKey:@"LoginToken"];
    [defaults removeObjectForKey:@"IsExpired"];
    [defaults removeObjectForKey:@"MeditationListSyncDate"];
    [defaults setBool:false forKey:@"isNonQuedCheccked"];
    [defaults removeObjectForKey:@"PlayingLiveChatDict"];
    [defaults removeObjectForKey:@"MeditationFavAlertShownArr"];
    [defaults removeObjectForKey:@"EQShowDate"];
    [defaults removeObjectForKey:@"MeditationWalkthroughShownDate"];
    [defaults removeObjectForKey:@"DontShowMeditationPopupAgain"];
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (![Utility isEmptyCheck:[defaults objectForKey:@"IsPlayingLiveChat"]] && [[defaults objectForKey:@"IsPlayingLiveChat"] boolValue]) {
        [appDelegate.FBWAudioPlayer pause];
        [defaults removeObjectForKey:@"IsPlayingLiveChat"];
    }else{
        [defaults setBool:NO forKey:@"IsPlayingLiveChat"];
    }
    
    
    [Utility logoutAccount_CommunityWebserviceCall];
    
    
}
+(BOOL)checkForFirstDailyWorkout:(UIViewController *)myView{
    BOOL check = false;
    if ([myView isKindOfClass:[ExerciseTypeViewController class]]) {
        ExerciseTypeViewController *new = (ExerciseTypeViewController *)myView;
        if(new.isOnlyToday){
            check = true;
        }
    }
    if(check){
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Don't go, try a workout NOW!"
                                              message:@"You won't regret it!!"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Choose workout"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Explore squad"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           if(!myView.navigationController){
                                               [CustomNavigation startNavigation:myView fromMenu:YES navDict:@{@"Identifier":@"TodayHome"}];
                                               
                                           }else if ([[myView.navigationController.viewControllers lastObject] isKindOfClass:[ECSlidingViewController class]]){
                                               
                                               [CustomNavigation startNavigation:myView fromMenu:YES navDict:@{@"Identifier":@"TodayHome"}];
                                               
                                           }else{
                                               [CustomNavigation startNavigation:myView fromMenu:NO navDict:@{@"Identifier":@"TodayHome"}];
                                           }
                                       }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [myView presentViewController:alertController animated:YES completion:nil];
    }
    return check;
}

#pragma mark - ConvertHtml to text
+(NSAttributedString*)converHtmltotext:(NSString*)htmlText{
    NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[htmlText dataUsingEncoding:NSUTF8StringEncoding]
                                                                         options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                              documentAttributes:nil error:nil];
    return strAttributed;
}
+(void)setTheCursorPosition:(UITextView*)textView{
    if ([textView.text isEqualToString:@"Start typing"]) {
        textView.text =@"";
    }
    CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin;
    UIView *cursorView = [[UIView alloc]initWithFrame: CGRectMake(cursorPosition.x,cursorPosition.y, 2, 20)];
    cursorView.backgroundColor =[Utility colorWithHexString:@"007AFF"];// [UIColor blueColor];
    cursorView.tag = 982;
    for (UIView *view in [textView subviews])
    {
        if (view.tag==982) {
            [view removeFromSuperview];
        }
    }
    [textView addSubview:cursorView];
    NSLog(@"%f",cursorView.frame.origin.y);
    if ([textView.text isEqualToString:@""]) {
        textView.text =@"Start typing";
    }
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionRepeat
                     animations:^{ [cursorView setAlpha:0]; }
                     completion:^(BOOL animated){ [cursorView setAlpha:1]; } ];
    
}
+(void)removeCursor:(UITextView*)textView{
    for (UIView *view in [textView subviews])
    {
        if (view.tag==982) {
            [view removeFromSuperview];
        }
    }
}

+(int)secondsFromDate:(NSDate *)date includeSeconds:(BOOL)includeSeconds{
    int totalSeconds;
    if (includeSeconds) {
        int hour=(int)[date hour];
        int min=(int)[date minute];
        int sec=(int)[date second];
        totalSeconds=(hour*60*60)+(min*60)+sec;
    }else{
        int hour=(int)[date hour];
        int min=(int)[date minute];
        totalSeconds=(hour*60*60)+(min*60);
    }
    return totalSeconds;
}
+(NSString *)createImageFileNameFromTimeStamp{
    NSString *fileName = @"";
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithInt: timeStamp];
    
    fileName = [@"" stringByAppendingFormat:@"%@.png",timeStampObj];
    
    return fileName;
    
}

#pragma mark- Community APIs
+ (void)communityLoginWebserviceCall{
    
    if (Utility.reachable) {
        NSString *deviceidStr = @"";
        if([FIRMessaging messaging].FCMToken){
            deviceidStr = [FIRMessaging messaging].FCMToken;
        }
        
        NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&squad_user_id=%@&server_key=%@&squad_access_token=%@&ios_m_device_id=%@",[defaults objectForKey:@"Email"],[@"" stringByAppendingFormat:@"%@%@",BASEPASSWORD_COMMUNITY,[defaults objectForKey:@"UserID"]],[defaults objectForKey:@"UserID"],CommunityServerKey,[defaults objectForKey:@"UserSessionID"],deviceidStr];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://forum.mindbodyhq.com/api/auth"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",responseString);
            NSMutableDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
            if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"api_status"]intValue] == 200) {
                if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"access_token"]]) {
                    [defaults setObject:[responseDictionary objectForKey:@"access_token"] forKey:@"forumAccessToken"];
                }
                if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"location"]]) {
                    [defaults setObject:[responseDictionary objectForKey:@"location"]forKey:@"locationUrl"];
                }
               
                [self communityUpdateUserDataWebserviceCall];
            }else{
                [self createAccount_CommunityWebserviceCall];
            }
            if ([defaults boolForKey:@"IsFromCommunity"]) {
                dispatch_async(dispatch_get_main_queue(),^ {
                    CommunityViewController *controller = [[CommunityViewController alloc]init];
                    [controller viewDidLoad];
                });
            }
            }];
            [dataTask resume];
    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
+ (void)createAccount_CommunityWebserviceCall{
   if (Utility.reachable) {
        NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&squad_user_id=%@&server_key=%@&confirm_password=%@&email=%@",[@"" stringByAppendingFormat:@"%@%@",[defaults objectForKey:@"FirstName"],[defaults objectForKey:@"UserID"]],[@"" stringByAppendingFormat:@"%@%@",BASEPASSWORD_COMMUNITY,[defaults objectForKey:@"UserID"]],[defaults objectForKey:@"UserID"],CommunityServerKey,[@"" stringByAppendingFormat:@"%@%@",BASEPASSWORD_COMMUNITY,[defaults objectForKey:@"UserID"]],[defaults objectForKey:@"Email"]];//
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://forum.mindbodyhq.com/api/create-account"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",responseString);
            NSMutableDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
            if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"api_status"]intValue] == 200) {
                [self communityLoginWebserviceCall];
                
                }
            }];
            [dataTask resume];
   }else{
       
   }
}
+ (void)logoutAccount_CommunityWebserviceCall{
   if (Utility.reachable) {
       if ([Utility isEmptyCheck:[defaults objectForKey:@"forumAccessToken"]]) {
           return;
       }
       NSString *post =[NSString stringWithFormat:@"server_key=%@",CommunityServerKey];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *utlStr = @"https://forum.mindbodyhq.com/api/delete-access-token";
              if (![Utility isEmptyCheck:[defaults objectForKey:@"forumAccessToken"]]) {
                  utlStr = [@"" stringByAppendingFormat:@"%@?access_token=%@",utlStr,[defaults objectForKey:@"forumAccessToken"]];
              }
        [request setURL:[NSURL URLWithString:utlStr]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",responseString);
            NSMutableDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
            if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"api_status"]intValue] == 200) {
                [defaults removeObjectForKey:@"locationUrl"];
                [defaults removeObjectForKey:@"forumAccessToken"];
                }
            }];
            [dataTask resume];
   }else{
       
   }
}
+(void)communityUpdateUserDataWebserviceCall{
    if (Utility.reachable) {

        NSString *post =[NSString stringWithFormat:@"first_name=%@&last_name=%@&server_key=%@",[defaults objectForKey:@"FirstName"],[defaults objectForKey:@"LastName"],CommunityServerKey];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *utlStr = @"https://forum.mindbodyhq.com/api/update-user-data";

              if (![Utility isEmptyCheck:[defaults objectForKey:@"forumAccessToken"]]) {
                  utlStr = [@"" stringByAppendingFormat:@"%@?access_token=%@",utlStr,[defaults objectForKey:@"forumAccessToken"]];
              }
        [request setURL:[NSURL URLWithString:utlStr]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request

                                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

            NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",responseString);
            NSMutableDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];

            if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"api_status"]intValue] == 200) {
               
            }
            }];

            [dataTask resume];

    }else{

//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];

    }

}
#pragma mark- End
#pragma mark- Sync Local Images
+(void)localImageSync{

    int userId = [[defaults objectForKey:@"UserID"] intValue];
    if([DBQuery isRowExist:@"LocalImageSync" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and isSync = 0",[NSNumber numberWithInt:userId]]]){
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){

             NSArray *arr = [dbObject selectBy:@"LocalImageSync" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"Image_type",@"Item_Id",@"Image_name",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@' and isSync = 0",[NSNumber numberWithInt:userId]]];
            if(arr.count>0){

                  for (int i=0; i<arr.count; i++ ) {
                        NSDictionary *dict = [arr objectAtIndex:i];
                        UIImage *selectedImage = [Utility getImageFromDocumentDirectoryWithImageName:[dict objectForKey:@"Image_name"]];
                        [Utility uploadFile:@"UploadUniqueMbhqImage" image:selectedImage withName:[dict objectForKey:@"Image_name"] imageType:[[dict objectForKey:@"Image_type"]intValue] itemId:[[dict objectForKey:@"Item_Id"]intValue]];
                }
                 [dbObject connectionEnd];

             }
        }
    }
}
#pragma mark- End
@end


