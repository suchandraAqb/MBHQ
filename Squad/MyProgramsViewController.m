//
//  MyProgramsViewController.m
//  The Life
//
//  Created by AQB Mac 4 on 20/07/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "MyProgramsViewController.h"
#import "ChalengesHomeViewController.h"
#import "ResourceViewController.h"

#import "HelpViewController.h"
#import "SetProgramViewController.h"
#import "LearnHomeViewController.h"
#import "CalendarViewController.h"
#import "LeaderBoardViewController.h"
#import "ShopifyListViewController.h"

@interface MyProgramsViewController (){
    UIView *contentView;
    NSArray *myProgramArray;
    IBOutlet UIImageView *headerBg;
}

@end

@implementation MyProgramsViewController


#pragma mark -Private Function
-(void)getMyPrograms{
    if (Utility.reachable) {
        if (contentView) {
            [contentView removeFromSuperview];
        }
        contentView = [Utility activityIndicatorView:self];
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"MyProgramsApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             if (self->contentView) {
                                                                 [self->contentView removeFromSuperview];
                                                             }
                                                             if(error == nil)
                                                             {
                                                                 NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                 NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                 if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                     dispatch_async(dispatch_get_main_queue(),^ {
                                                                         self->myProgramArray = [responseDictionary valueForKey:@"ProgramList"];
                                                                     });
                                                                     
                                                                 }else{
                                                                     [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                                                                     return;
                                                                     
                                                                 }
                                                                 
                                                             }else{
                                                                 [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                             }
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
    }
}
#pragma mark -End

#pragma mark -IBAction
- (IBAction)myProgramButtonPressed:(UIButton *)sender {
    
    if (sender.tag == 0){
        NSURL *url = [NSURL URLWithString:@"abbbcbooty://"];
        if([[UIApplication sharedApplication] openURL:url]) {
            NSLog(@"Well done!");
        } else {
            url = [NSURL URLWithString:@"https://appsto.re/au/Gzu1ab.i"];
            [[UIApplication sharedApplication] openURL:url];
        }
    }else if (sender.tag == 1){
//        NSURL *url = [NSURL URLWithString:@"abbbcbooty://"];
//        if([[UIApplication sharedApplication] openURL:url]) {
//            NSLog(@"Well done!");
//        } else {
//            url = [NSURL URLWithString:@"https://appsto.re/au/Gzu1ab.i"];
//            [[UIApplication sharedApplication] openURL:url];
//        }
         NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/abbbc-online-app/id992087929?mt=8"];
        [[UIApplication sharedApplication] openURL:url];

        
    }else if (sender.tag == 2){
        NSURL *url = [NSURL URLWithString:@"abbbcabs://"];
        if([[UIApplication sharedApplication] openURL:url]) {
            NSLog(@"Well done!");
        } else {
            url = [NSURL URLWithString:@"https://appsto.re/au/MGfTcb.i"];
            [[UIApplication sharedApplication] openURL:url];
        }
    }else if (sender.tag == 3){
        ChalengesHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChalengesHome"];
        [self.navigationController pushViewController:controller animated:YES];
//        NSURL *url = [NSURL URLWithString:@"abbbcfinisher://"];
//        if([[UIApplication sharedApplication] openURL:url]) {
//            NSLog(@"Well done!");
//        } else {
//            url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/ashy-bines-finishers/id1120650120?mt=8"];
//            [[UIApplication sharedApplication] openURL:url];
//
//        }
    }else if (sender.tag == 4){
        NSURL *url = [NSURL URLWithString:@"abbbcbooty2://"];
        if([[UIApplication sharedApplication] openURL:url]) {
            NSLog(@"Well done!");
        } else {
            url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/ashy-bines-booty-2/id1131223824?mt=8"];
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }else if (sender.tag == 5){
        NSURL *url = [NSURL URLWithString:@"abbbcfinisher://"];
        if([[UIApplication sharedApplication] openURL:url]) {
            NSLog(@"Well done!");
        } else {
            url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/ashy-bines-finishers/id1120650120?ls=1&mt=8"];
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }else if (sender.tag == 6){//sweet potato
        NSURL *url = [NSURL URLWithString:@"abbbcsweetpotato://"];
        if([[UIApplication sharedApplication] openURL:url]) {
            NSLog(@"Well done!");
        } else {
            url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/ashys-101-sweet-potato-recipe/id1265835676?mt=8"];
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }else if (sender.tag == 7){//resource
        ResourceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ResourceViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (sender.tag == 8){//Set programs
            
            /*if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:self];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:self];
                return;
            }else if(![Utility isSubscribedUser] || [defaults boolForKey:@"IsNonSubscribedUser"]){
                [Utility showSubscribedAlert:self];
                return;
            }*/
        
            if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]){
                [Utility showTrailLoginAlert:self ofType:self];
            }else{
                LearnHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LearnHome"];
                controller.fromTodayPage = true;
                controller.redirectBackToTodayPage = true;
                [self.navigationController pushViewController:controller animated:YES];
                UIButton *button = [UIButton new];
                button.tag = 6;
                [controller itemButtonPressed:button];
            }
    }else if(sender.tag == 9){
        
        if([Utility isSquadLiteUser]){
            [Utility showSubscribedAlert:self];
            return;
        }else if([Utility isSquadFreeUser]){
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
        
        CalendarViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Calendar"];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if(sender.tag == 10){
        
        if([Utility isSquadLiteUser]){
            [Utility showSubscribedAlert:self];
            return;
        }else if([Utility isSquadFreeUser]){
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
        
        if ([Utility isSubscribedUser]) {
            LeaderBoardViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeaderBoard"];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [Utility showSubscribedAlert:self];
        }
        
    }else if(sender.tag == 11){
        
        if([Utility isSquadLiteUser]){
            [Utility showSubscribedAlert:self];
            return;
        }else if([Utility isSquadFreeUser]){
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
        
        if ([Utility isSubscribedUser]) {
            ShopifyListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShopifyList"];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [Utility showSubscribedAlert:self];
        }
    }
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
-(IBAction)logoTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark -End

#pragma mark -ViewLife cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        headerBg.image = [UIImage imageNamed:@"header-4s.png"];
    }else{
        headerBg.image = [UIImage imageNamed:@"header.png"];
    }
    //[self getMyPrograms];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MasterMenuViewController class]]) {
        MasterMenuViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterMenuView"];
        controller.delegateMasterMenu=self;
        self.slidingViewController.underLeftViewController  = controller;
    }
//    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

#pragma mark -End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
