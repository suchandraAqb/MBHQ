//
//  MasterMenuViewController.m
//  The Life
//
//  Created by AQB SOLUTIONS on 28/03/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "MasterMenuViewController.h"
#import "TableViewCell.h"
#import "HomePageViewController.h"
#import "NavigationViewController.h"
#import "CalendarViewController.h"
#import "LoginController.h"
#import "AchieveHomeViewController.h"
#import "DailyGoodnessViewController.h"
#import "CourseDetailsViewController.h"
#import "LeaderBoardViewController.h"
#import "MyProgramsViewController.h"
#import "ShopifyListViewController.h"
#import "SettingsViewController.h"
#import "MenuSettingsViewController.h"
#import "PreSignUpViewController.h"
#import "SignupWithEmailViewController.h"
#import "InitialViewController.h"
#import "LearnHomeViewController.h"
#import "SetProgramViewController.h"

#import "MyProfileSettingsViewController.h"
#import "NutritionSettingHomeViewController.h"
#import "CustomExerciseSettingsViewController.h"
#import "ContentManagementViewController.h"
#import "HelpViewController.h"
#import "ConnectViewController.h"

@interface MasterMenuViewController (){
    IBOutlet UITableView *masterTable;
    IBOutlet UIView *signOutButtonContainer;
    IBOutlet UIView *logInButtonContainer;
    __weak IBOutlet UIView *signUpButtonContainer;
    
    IBOutletCollection(UIButton)NSArray *roundButtons;

    NSMutableArray *menuArray;
    NSMutableArray *imageArray;
    NSArray *regularFontTextArray;
    UIView *contentView;
    
    NSString *programNameForExercise;
    NSString *programNameForNutrition;
    int ProgramIdForNutrition;
    int ProgramIdForExercise;
    int apiCount;
    BOOL ischeckingError;
    
}

@end

@implementation MasterMenuViewController
@synthesize delegateMasterMenu;


#pragma mark -ViewLifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.slidingViewController setAnchorLeftRevealAmount:self.view.bounds.size.width];
    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
//    [self prefersStatusBarHidden];
    
    for(UIButton *btn in roundButtons){
        btn.layer.cornerRadius = 10.0;
        btn.clipsToBounds = YES;
    }
    
}
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isShowingMenu = YES;
    
//    menuArray=[[NSMutableArray alloc]initWithObjects:@"PROFILE",@"COMMUNITY",@"ACHIEVE",@"APPRECIATE",@"SETTINGS",@"NUTRITION SETTINGS",@"EXERCISE SETTINGS",@"OFFLINE",@"OFFLINE MODE",@"OFFLINE SESSIONS",@"HELP",@"FEATURES",nil];
     menuArray=[[NSMutableArray alloc]initWithObjects:@"PROFILE",@"COMMUNITY",@"HELP",nil];
//    menuArray=[[NSMutableArray alloc]initWithObjects:@"PROFILE",@"COMMUNITY",@"SETTINGS",@"NUTRITION SETTINGS",@"EXERCISE SETTINGS",@"OFFLINE",@"OFFLINE MODE",@"OFFLINE SESSIONS",@"HELP",@"FEATURES",nil];

    imageArray=[[NSMutableArray alloc]initWithObjects:@"m_profile.png",@"m_nutri_settings.png",@"m_exercise.png",@"m_audio.png",@"m_offline.png", @"m_offline_sessions.png",nil];
    
     regularFontTextArray=[[NSArray alloc]initWithObjects:@"NUTRITION SETTINGS",@"EXERCISE SETTINGS",@"OFFLINE MODE",@"OFFLINE SESSIONS",nil];
    
    [masterTable reloadData];
    
    if ([defaults boolForKey:@"IsNonSubscribedUser"]){
        signOutButtonContainer.hidden = true;
        signUpButtonContainer.hidden = false;
        logInButtonContainer.hidden = false;
    }else if([Utility isSubscribedUser] || [Utility isSquadLiteUser]) {
        signOutButtonContainer.hidden = false;
        signUpButtonContainer.hidden = true;
        logInButtonContainer.hidden = true;
    }else{
        signOutButtonContainer.hidden = true;
        signUpButtonContainer.hidden = false;
        logInButtonContainer.hidden = false;
    }
    //chayan 18/9/2017: 8 week challenge added in array
    
    //    [self setUpMenuView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitMenu:) name:@"backButtonPressed" object:nil];
    
    self->ischeckingError = false;
    apiCount=0;
    if([Utility isSubscribedUser] && ![Utility isOfflineMode]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self webserviceCall_CheckMiniProgramForExercise];
//            [self webserviceCall_CheckMiniProgramForNutrition];
        });
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isShowingMenu = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -End
#pragma mark -IBAction

-(IBAction)logoButtonPressed:(id)sender{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
-(IBAction)infoButtonPressed:(id)sender{
    NSString *urlString=@"https://player.vimeo.com/external/220933773.m3u8?s=04d41e4e04fa8ce700db0f52f247acce968b72e5";
    
    if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeHome"] boolValue]) {
        
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
        NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeHome"];
        [defaults setObject:dict forKey:@"firstTimeHelpDict"];
    }
    else
    {
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
    }
}
- (IBAction)logInButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    /*LoginController *controller = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    NavigationViewController *nav = [[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
    self.slidingViewController.topViewController = nav;
    [self.slidingViewController resetTopViewAnimated:YES];*/
    
    BOOL isControllerFound = NO;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[InitialViewController class]]) {
            InitialViewController *controller1 =(InitialViewController *)controller;
            controller1.openLoginView = true;
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            isControllerFound = YES;
            break;
        }
    }
    
    if(!isControllerFound){
        InitialViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InitialView"];
        controller.openLoginView = true;
        //[self.navigationController pushViewController:controller animated:YES];
        NavigationViewController *nav = [[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        self.slidingViewController.topViewController = nav;
        [self.slidingViewController resetTopViewAnimated:YES];
    }

}
- (IBAction)logOutButtonPressed:(id)sender {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"LogOutApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 
                                                                 [Utility logoutChatSdk];
                                                                 
                                                                 
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     [defaults setObject:@"" forKey:@"CurrentProgramName"];
                                                                     
                                                                     [defaults removeObjectForKey:@"TempTrialEndDate"];
                                                                     [defaults setBool:NO forKey:@"isOffline"]; // AY 27022018 (For Offline)
                                                                     [defaults setBool:NO forKey:@"isSquadLite"];
                                                                     [defaults setBool:NO forKey:@"IsNonSubscribedUser"];
                                                                     [defaults setBool:NO forKey:@"isInitialNotiSet"];
                                                                     [defaults setBool:NO forKey:@"isInitialQuoteSet"];//Quote
                                                                     
                                                                     if([responseString boolValue]) {
                                                                         
                                                                         [defaults setObject:nil forKey:@"taskListArray"];
                                                                         
                                                                         //[defaults setObject:nil forKey:@"healthDataSyncDate"];
                                                                         [defaults setObject:nil forKey:@"NonSubscribedUserData"];
                                                                         [defaults setObject:nil forKey:@"LoginData"];
                                                                         [defaults setObject:nil forKey:@"UserID"];
                                                                         [defaults setObject:nil forKey:@"UserSessionID"];
                                                                         [defaults setObject:nil forKey:@"PresenterList"];
                                                                         //[defaults setObject:nil forKey:@"Email"];
                                                                         //[defaults setObject:nil forKey:@"Password"];
                                                                         [defaults setObject:nil forKey:@"ABBBCOnlineUserId"];
                                                                         [defaults setObject:nil forKey:@"ABBBCOnlineUserSessionId"];
                                                                         
                                                                         [defaults setObject:nil forKey:@"FbWorldForumUrl"];
                                                                         [defaults setObject:nil forKey:@"FbCityForumUrl"];
                                                                         [defaults setObject:nil forKey:@"FbSuburbForumUrl"];
                                                                         
                                                                         [defaults setBool:NO forKey:@"isVisionGoalExpanded"];
                                                                         
                                                                         //su
                                                                         
                                                                         [defaults setObject:nil forKey:@"rightSelectedPic"];
                                                                         [defaults setObject:nil forKey:@"leftSelectedPic"];
                                                                         [defaults setObject:nil forKey:@"BadgeImageText"];

                                                                         
                                                                         [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"UserID"];
                                                                         [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"UserSessionID"];
                                                                         [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"ABBBCOnlineUserId"];
                                                                         [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"ABBBCOnlineUserSessionId"];
                                                                         [defaults setBool:false forKey:@"isFirstTimeGratitude"];
                                                                         [defaults setBool:false forKey:@"isFirstTimeBucket"];
                                                                         [defaults setBool:false forKey:@"isFirstTimeHabit"];
                                                                         [defaults setBool:false forKey:@"isFirstTimeMeditation"]; //24/7/2020
                                                                         [defaults setBool:false forKey:@"isFirstTimeCourse"];
                                                                         [defaults setBool:false forKey:@"isFirstTimeTest"];
                                                                         [defaults setBool:false forKey:@"isFirstTimeGratitude"];
                                                                         [defaults setBool:false forKey:@"isFirstTimeGrowth"];
                                                                         
                                                                         [defaults removeObjectForKey:@"defaultStatesView"];
                                                                         [defaults removeObjectForKey:@"habitListFilterStatus"];
                                                                         [defaults removeObjectForKey:@"bucketListFilterStatus"];
                                                                         [defaults removeObjectForKey:@"habitViewStatus"];
                                                                         [Utility logoutAccount_CommunityWebserviceCall];
                                                                        
                                                                         
                                                                         BOOL isControllerFound = NO;
                                                                         for (UIViewController *controller in self.navigationController.viewControllers) {
                                                                             if ([controller isKindOfClass:[InitialViewController class]]) {
                                                                                 [self.navigationController popToViewController:controller
                                                                                       animated:YES];
                                                                                 isControllerFound = YES;
                                                                                 break;
                                                                             }
                                                                         }
                                                                         
                                                                         if(!isControllerFound){
                                                                                                                                                      InitialViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InitialView"];
                                                                                                                                                      [self.navigationController pushViewController:controller animated:YES];
                                                                         }
                                                                         
                                                                         return ;
                                                                     }else{
//                                                                         [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                                                                         BOOL isControllerFound = NO;
                                                                         for (UIViewController *controller in self.navigationController.viewControllers) {
                                                                             if ([controller isKindOfClass:[InitialViewController class]]) {
                                                                                 InitialViewController *controller1 =(InitialViewController *)controller;
                                                                                 
                                                                                 [self.navigationController popToViewController:controller
                                                                                                                       animated:YES];
                                                                                 isControllerFound = YES;
                                                                                 break;
                                                                             }
                                                                         }
                                                                         
                                                                         if(!isControllerFound){
                                                                             InitialViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InitialView"];
                                                                             [self.navigationController pushViewController:controller animated:YES];
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

- (IBAction)signUpButtonPressed:(id)sender{
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
    NavigationViewController *nav = [[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:signupController];
    self.slidingViewController.topViewController = nav;
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)offlineModeChange:(UISwitch *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.intValue];
    TableViewCell *tableCell = (TableViewCell *)[masterTable cellForRowAtIndexPath:indexPath];
    
    UIViewController *topController;
    
    if([self.slidingViewController.topViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)self.slidingViewController.topViewController;
        NSArray *controllers = [nav viewControllers];
        topController = [controllers lastObject];
        NSLog(@"Top Controller:%@",topController.debugDescription);
    }else{
        topController = self.slidingViewController.topViewController;
    }
    
    if([Utility isSquadLiteUser]){
        tableCell.offlineSwitch.on = false;
        [self.slidingViewController anchorTopViewToLeftAnimated:YES];
        [self.slidingViewController resetTopViewAnimated:YES];
        [Utility showSubscribedAlert:topController];
        return;
    }else if([Utility isSquadFreeUser]){
        tableCell.offlineSwitch.on = false;
        [self.slidingViewController anchorTopViewToLeftAnimated:YES];
        [self.slidingViewController resetTopViewAnimated:YES];
        [Utility showAlertAfterSevenDayTrail:topController];
        return;
    }
    
    if([Utility isSubscribedUser]){
        [defaults setBool:sender.isOn forKey:@"isOffline"];
        if(!sender.isOn){
            if([defaults boolForKey:@"IsNonSubscribedUser"]){
//                [self syncOfflineDailyWorkOutData];
//                [self syncOfflineCustomWorkOutData];
            }else{
                [self makeUserLogin];
            }
            
        }// AY 02032018
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeOfflineStatus" object:nil];// AY 06032018
    }else{
        
        tableCell.offlineSwitch.on = false;
        [self.slidingViewController anchorTopViewToLeftAnimated:YES];
        [self.slidingViewController resetTopViewAnimated:YES];
        [Utility showSubscribedAlert:self];
    }
}
#pragma mark -End

#pragma mark - Private Function

///////////////// FOR NUTRITION SETTINGS /////////////////

-(void)nutritionButtonDetails{
    
        BOOL isSetProgramActive = NO;
        if (![Utility isEmptyCheck:programNameForNutrition] && ProgramIdForNutrition>0) {
            isSetProgramActive = YES;
        }
    
        if (![defaults boolForKey:@"IsNonSubscribedUser"] && ![Utility isSubscribedUser] && ![Utility isSquadLiteUser]) {//today__
            NutritionSettingHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionSettingHomeView"];
            [Utility showTrailLoginAlert:self ofType:controller];
            return;
        }
        
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self checkOfflineAccess];
            return;
        }
        dispatch_async(dispatch_get_main_queue(),^ {
            NSString *msgStr=@"";
            NSString *okStr;
            if (isSetProgramActive) {
                msgStr = [@"" stringByAppendingFormat:@"\nYou are currently doing the %@.\nCustom Settings cannot be changed once a program begins.\nTo cancel the %@ and revert to your customised plan today click REVERT and then on the program screen click CANCEL.\nTo continue on the %@ , click CLOSE.",[self->programNameForNutrition uppercaseString],[self->programNameForNutrition uppercaseString],[self->programNameForNutrition uppercaseString]];
                okStr = @"REVERT";
            }else{
                msgStr = @"Are you certain you want to change your nutrition settings?  This will change your nutrition plan from today onward.";
                okStr = @"OK";
            }
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"ALERT!"
                                                  message:msgStr
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"CLOSE"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               
                                           }];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:okStr
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           if (isSetProgramActive) {
                                               LearnHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LearnHome"];
                                               NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                                               self.slidingViewController.topViewController = nav;
                                               [self.slidingViewController resetTopViewAnimated:YES];
                                               
                                               UIButton *button = [UIButton new];
                                               button.tag = 6;
                                               [controller itemButtonPressed:button];
                                           }else{
                                               
                                               NutritionSettingHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionSettingHomeView"];
                                               NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                                               self.slidingViewController.topViewController = nav;
                                               [self.slidingViewController resetTopViewAnimated:YES];
                                           }
                                           
                                       }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
    
}
-(void)checkOfflineAccess{
    [Utility msg:@"You are in OFFLINE mode. Go Online to access this functionality." title:@"Oops!\n" controller:self haveToPop:NO];
}
-(void)webserviceCall_CheckMiniProgramForNutrition{
    if (Utility.reachable) {
        apiCount++;
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            if (contentView) {
        //                [contentView removeFromSuperview];
        //            }
        //            contentView = [Utility activityIndicatorView:self];
        //        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"SquadUserId"];
        //        [mainDict setObject:[dict objectForKey:@"ProgramId"] forKey:@"ProgramId"];
        //        [mainDict setObject:[dict objectForKey:@"UserMiniProgramId"] forKey:@"UserProgramId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"CheckMiniProgramForNutrition" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 //                                                                 if (contentView) {
                                                                 //                                                                     [contentView removeFromSuperview];
                                                                 //                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"SquadMiniProgramModel"]]) {
                                                                             NSDictionary *squadMiniProgramModel = [responseDict objectForKey:@"SquadMiniProgramModel"];
                                                                             if (![Utility isEmptyCheck:[squadMiniProgramModel objectForKey:@"ProgramName"]]) {
                                                                                 self->programNameForNutrition = [squadMiniProgramModel objectForKey:@"ProgramName"];
                                                                             }
                                                                             if (![Utility isEmptyCheck:[squadMiniProgramModel objectForKey:@"ProgramId"]]) {
                                                                                 self->ProgramIdForNutrition = [[squadMiniProgramModel objectForKey:@"ProgramId"] intValue];
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

///////////////// END /////////////////

///////////////// FOR EXERCISE SETTINGS /////////////////

-(void)exerciseButtonDetails{
    
        BOOL isSetProgramActive = NO;
        if (![Utility isEmptyCheck:self->programNameForExercise] && ProgramIdForExercise>0) {
            isSetProgramActive = YES;
        }
        
    
        
        if (![defaults boolForKey:@"IsNonSubscribedUser"] && ![Utility isSubscribedUser] && ![Utility isSquadLiteUser]) {//today__
            CustomProgramSetupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomProgramSetup"];
            [Utility showTrailLoginAlert:self ofType:controller];
            return;
        }
        
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self checkOfflineAccess];
            return;
        }
        dispatch_async(dispatch_get_main_queue(),^ {
            NSString *msgStr=@"";
            NSString *okStr;
            if (isSetProgramActive) {
                msgStr = [@"" stringByAppendingFormat:@"\nYou are currently doing the %@.\nCustom Settings cannot be changed once a program begins.\nTo cancel the %@ and revert to your customised plan today click REVERT and then on the program screen click CANCEL.\nTo continue on the %@ , click CLOSE.",[self->programNameForExercise uppercaseString],[self->programNameForExercise uppercaseString],[self->programNameForExercise uppercaseString]];
                okStr = @"REVERT";
            }else{
                msgStr = @"Are you certain you want to change your workout settings?  This will change your custom workout plan from next week onward.";
                okStr = @"OK";
            }
            UIAlertController *alertController = [UIAlertController //15may2018
                                                  alertControllerWithTitle:@"ALERT!"
                                                  message:msgStr
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"CLOSE"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               
                                           }];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:okStr
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           if (isSetProgramActive) {
                                               LearnHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LearnHome"];
                                               NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                                               self.slidingViewController.topViewController = nav;
                                               [self.slidingViewController resetTopViewAnimated:YES];
                                               
                                               UIButton *button = [UIButton new];
                                               button.tag = 6;
                                               [controller itemButtonPressed:button];
                                           }else{
                                               CustomExerciseSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomExerciseSettings"];
                                               NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                                               self.slidingViewController.topViewController = nav;
                                               [self.slidingViewController resetTopViewAnimated:YES];
                                           }
                                           
                                       }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        });
        
    
}
-(void)webserviceCall_CheckMiniProgramForExercise{
    if (Utility.reachable) {
        apiCount++;
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            if (contentView) {
        //                [contentView removeFromSuperview];
        //            }
        //            contentView = [Utility activityIndicatorView:self];
        //        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"SquadUserId"];
        //        [mainDict setObject:[dict objectForKey:@"ProgramId"] forKey:@"ProgramId"];
        //        [mainDict setObject:[dict objectForKey:@"UserMiniProgramId"] forKey:@"UserProgramId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"CheckMiniProgramForExercise" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 //                                                                 if (contentView) {
                                                                 //                                                                     [contentView removeFromSuperview];
                                                                 //                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"SquadMiniProgramModel"]]) {
                                                                             NSDictionary *squadMiniProgramModel = [responseDict objectForKey:@"SquadMiniProgramModel"];
                                                                             if (![Utility isEmptyCheck:[squadMiniProgramModel objectForKey:@"ProgramName"]]) {
                                                                                 self->programNameForExercise = [squadMiniProgramModel objectForKey:@"ProgramName"];
                                                                             }
                                                                             if (![Utility isEmptyCheck:[squadMiniProgramModel objectForKey:@"ProgramId"]]) {
                                                                                 self->ProgramIdForExercise = [[squadMiniProgramModel objectForKey:@"ProgramId"] intValue];
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

-(void)audioButtonDetails{
    
        dispatch_async(dispatch_get_main_queue(),^ {
            SettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Settings"];
            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
            self.slidingViewController.topViewController = nav;
            [self.slidingViewController resetTopViewAnimated:YES];
        });
}

-(void)contentManagementDetails{
    if([Utility isSubscribedUser]){
        dispatch_async(dispatch_get_main_queue(),^ {
            ContentManagementViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContentManagementView"];
            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
            self.slidingViewController.topViewController = nav;
            [self.slidingViewController resetTopViewAnimated:YES];
        });
    }else{
        [Utility showSubscribedAlert:self];
        [self.slidingViewController anchorTopViewToLeftAnimated:YES];
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}
-(void)profileButtonDetails{
        if ([Utility isSubscribedUser] || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
            
            if([Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            dispatch_async(dispatch_get_main_queue(),^ {
                MyProfileSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyProfileSettingsView"];
                NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                self.slidingViewController.topViewController = nav;
                [self.slidingViewController resetTopViewAnimated:YES];
                
            });
        }else if([Utility isSquadFreeUser]){
            [self.slidingViewController anchorTopViewToLeftAnimated:YES];
            [self.slidingViewController resetTopViewAnimated:YES];
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
        else{
            [self.slidingViewController anchorTopViewToLeftAnimated:YES];
            [self.slidingViewController resetTopViewAnimated:YES];
            [Utility showSubscribedAlert:self];
        }
}

-(void)helpButtonDetails{
    
    dispatch_async(dispatch_get_main_queue(),^ {
        HelpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpView"];
        NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        self.slidingViewController.topViewController = nav;
        [self.slidingViewController resetTopViewAnimated:YES];
    });
}

-(void)featuresButtonDetails{
    
    dispatch_async(dispatch_get_main_queue(),^ {
        MyProgramsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPrograms"];
        NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        self.slidingViewController.topViewController = nav;
        [self.slidingViewController resetTopViewAnimated:YES];
    });
}
-(void)achieveButtonDetails{
    
    dispatch_async(dispatch_get_main_queue(),^ {
        AchieveHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AchieveHome"];
        NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        self.slidingViewController.topViewController = nav;
        [self.slidingViewController resetTopViewAnimated:YES];
    });
}
-(void)appreciateButtonDetails{
    
    dispatch_async(dispatch_get_main_queue(),^ {
        AppreciateViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Appreciate"];
        NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        self.slidingViewController.topViewController = nav;
        [self.slidingViewController resetTopViewAnimated:YES];
    });
}
-(void)locationPermissionforConnect{
    
}

-(void)communityButtonDetails{
    dispatch_async(dispatch_get_main_queue(),^ {
        ConnectViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Connect"];
        NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        self.slidingViewController.topViewController = nav;
        [self.slidingViewController resetTopViewAnimated:YES];
    });
}

-(void)makeUserLogin{
    
    NSString *email = [defaults objectForKey:@"Email"];
    NSString *password = [defaults objectForKey:@"Password"];
    
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
    
    if (Utility.reachable) {
        //[Utility logoutChatSdk];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:email forKey:@"EmailAddress"];
        [mainDict setObject:password forKey:@"Password"];
        [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IncludeAbbbcOnline"];
        
        if ([defaults boolForKey:@"IsFbUser"]) {
            if(![Utility isEmptyCheck:[defaults objectForKey:@"facebookTokenString"]]){
                NSString *fbToken =[defaults objectForKey:@"facebookTokenString"];
                [mainDict setObject:fbToken forKey:@"FacebookToken"];
            }
        }
        
        //Added on AY 17042018
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if(![Utility isEmptyCheck:version]){
            [mainDict setObject:version forKey:@"AppVersion"];
        }
        [mainDict setObject:@"ios" forKey:@"AppPlatform"];
        //End
        
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
                                                                     
                                                                    self->ischeckingError = false;
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSMutableDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         for (NSString *key in [responseDictionary allKeys]) {
                                                                             if ([[responseDictionary objectForKey:key] class] ==[NSNull class]) {
                                                                                 [responseDictionary removeObjectForKey:key];
                                                                             }
                                                                         }
                                                                         [defaults setObject:[responseDictionary valueForKey:@"ActiveUntil"] forKey:@"TempTrialEndDate"];
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
                                                                         
                                                                         
//                                                                         [self syncOfflineDailyWorkOutData];
//                                                                         [self syncOfflineCustomWorkOutData];
                                                                         
                                                                         
                                                                     }else{
                                                                         
                                                                         self->ischeckingError = true;
                                                                         
                                                                         if (![Utility isEmptyCheck:responseString]) {
                                                                             [Utility msg:responseString title:@"Error !" controller:self haveToPop:NO];
                                                                         }else{
                                                                             [Utility msg:@"Email or Password is not correct.Please enter correct Email & Password and try again." title:@"Error !" controller:self haveToPop:NO];
                                                                         }
                                                                         return;
                                                                     }
                                                                     
                                                                 }else{
                                                                     self->ischeckingError = true;
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
         self->ischeckingError = true;
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

-(void)syncOfflineDailyWorkOutData{
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    if([DBQuery isRowExist:@"dailyworkout" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and isSync = 0",userId]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            NSArray *arr = [dbObject selectBy:@"dailyworkout" withColumn:[[NSArray alloc]initWithObjects:@"favSessionList",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and isSync = 0",userId]];
            
            if(arr.count>0){
                
                if(![Utility isEmptyCheck:arr[0][@"favSessionList"]]){
                    NSString *str = arr[0][@"favSessionList"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    NSMutableArray *favArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    if(favArray){
                        NSArray *filterarray = [favArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsFavDone == true OR IsCountDone == true)"]];
                        
                        if(filterarray.count>0)[self webserviceCall_FavoriteSessionandCountUpdate:filterarray];
                    }
                }
                dispatch_async(dispatch_get_main_queue(),^ {
                    
                });
            }
            
            [dbObject connectionEnd];
        }
    }
    
}// AY 02032018

-(void)syncOfflineCustomWorkOutData{
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    if([DBQuery isRowExist:@"customExerciseList" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and isSync = 0",userId]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            //NSArray *arr = [dbObject selectBy:@"customExerciseList" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"exerciseList",@"joiningDate",@"weekStartDate",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStartDateStr]];
            
            NSArray *arr = [dbObject selectBy:@"customExerciseList" withColumn:[[NSArray alloc]initWithObjects:@"exerciseList",@"weekStartDate",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and isSync = 0",userId]];
            
            if(arr.count>0){
                
                for(int i=0;i<arr.count;i++){
                    
                    if(![Utility isEmptyCheck:arr[i][@"exerciseList"]]){
                        NSString *str = arr[i][@"exerciseList"];
                        NSString *weekStart = arr[i][@"weekStartDate"];
                        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                        NSMutableArray *favArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        
                        if(favArray){
                            NSArray *filterarray = [favArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsFavDone == true OR IsCountDone == true)"]];
                            
                            if(filterarray.count>0){
                                [self webserviceCall_CustomWorkOutFavoriteSessionandCountUpdate:filterarray weekStart:weekStart];
                            }
                        }
                    }
                    
                }
                
            }
            
            [dbObject connectionEnd];
        }
    }
    
}// AY 07032018

-(void)webserviceCall_FavoriteSessionandCountUpdate:(NSArray *)favArray{
    
    if (Utility.reachable) {
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:favArray forKey:@"FavoriteSessionList"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"FavoriteSessionandCountUpdate" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     NSLog(@"Update Offline data Response: %@",responseString);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
                                                                         
                                                                         NSArray *favouriteArray = [responseDict objectForKey:@"FavoriteSessionList"];
                                                                         NSString *favString =@"";
                                                                         if(favouriteArray.count>0){
                                                                             NSError *error;
                                                                             NSData *favData = [NSJSONSerialization dataWithJSONObject:favouriteArray options:NSJSONWritingPrettyPrinted  error:&error];
                                                                             
                                                                             if (error) {
                                                                                 
                                                                                 NSLog(@"Error Favorite Array-%@",error.debugDescription);
                                                                             }
                                                                             
                                                                             favString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
                                                                         }
                                                                         
                                                                         if(favString.length <= 0){
                                                                             return ;
                                                                         }
                                                                         
                                                                         NSMutableString *modifiedExList = [NSMutableString stringWithString:favString];
                                                                         [modifiedExList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExList length])]; //AY 07032018
                                                                         
                                                                         DAOReader *dbObject = [DAOReader sharedInstance];
                                                                         if([dbObject connectionStart]){
                                                                             
                                                                             NSString *date = [NSDate date].description;
                                                                             NSArray *columnArray = [[NSArray alloc]initWithObjects:@"favSessionList",@"isSync",@"lastUpdate",nil];
                                                                             NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedExList,[NSNumber numberWithInt:1],date, nil];
                                                                             
                                                                             [dbObject updateWithCondition:@"dailyworkout" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]];
                                                                         }
                                                                         
                                                                         
                                                                         [dbObject connectionEnd];
                                                                     }
                                                                     
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }
}// AY 02032018

-(void)webserviceCall_CustomWorkOutFavoriteSessionandCountUpdate:(NSArray *)favArray weekStart:(NSString *)weekStart{
    
    if (Utility.reachable) {
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:favArray forKey:@"FavoriteSessionList"];
        [mainDict setObject:weekStart forKey:@"dt"];
        [mainDict setObject:weekStart forKey:@"UserStep"];
        [mainDict setObject:[NSNumber numberWithInteger:0] forKey:@"UserStep"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SyncSquadUserWorkoutSessionData" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     NSLog(@"Update Offline data Response: %@",responseString);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
                                                                         
                                                                         NSArray *favouriteArray = [responseDict objectForKey:@"SquadUserWorkoutSessionList"];
                                                                         NSString *favString =@"";
                                                                         if(favouriteArray.count>0){
                                                                             NSError *error;
                                                                             NSData *favData = [NSJSONSerialization dataWithJSONObject:favouriteArray options:NSJSONWritingPrettyPrinted  error:&error];
                                                                             
                                                                             if (error) {
                                                                                 
                                                                                 NSLog(@"Error Favorite Array-%@",error.debugDescription);
                                                                             }
                                                                             
                                                                             favString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
                                                                         }
                                                                         
                                                                         if(favString.length <= 0){
                                                                             return ;
                                                                         }
                                                                         
                                                                         NSMutableString *modifiedExList = [NSMutableString stringWithString:favString];
                                                                         [modifiedExList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExList length])]; //AY 07032018
                                                                         
                                                                         DAOReader *dbObject = [DAOReader sharedInstance];
                                                                         if([dbObject connectionStart]){
                                                                             
                                                                             NSString *date = [NSDate date].description;
                                                                             NSArray *columnArray = [[NSArray alloc]initWithObjects:@"exerciseList",@"isSync",@"lastUpdate",nil];
                                                                             NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedExList,[NSNumber numberWithInt:0],date, nil];
                                                                             
                                                                             [dbObject updateWithCondition:@"customExerciseList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStart]];
                                                                         }
                                                                         
                                                                         
                                                                         [dbObject connectionEnd];
                                                                     }
                                                                     
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }
}
//-(void)setUpMenuView{
//    if ([Utility isSubscribedUser]) {
//        profileButtonContainer.alpha = 1.0f;
//        contentMgmtView.alpha = 1.0f;
//        offlineSwitch.superview.alpha = 1.0f;
//        audioContainerView.alpha = 1.0;
//        nutritionContainerView.alpha = 1.0;
//        exerciseContainerView.alpha = 1.0;
//    }else if([Utility isSquadLiteUser]){
//        profileButtonContainer.alpha = 1.0f;
//        contentMgmtView.alpha = 0.5f;
//        offlineSwitch.superview.alpha = 0.5f;
//        audioContainerView.alpha = 0.5;
//        nutritionContainerView.alpha = 0.5;
//        exerciseContainerView.alpha = 0.5;
//    }
//    else{
//        profileButtonContainer.alpha = 0.5f;
//        contentMgmtView.alpha = 0.5f;
//        offlineSwitch.superview.alpha = 0.5f;
//        audioContainerView.alpha = 0.5;
//        nutritionContainerView.alpha = 0.5;
//        exerciseContainerView.alpha = 0.5;
//    }
//}
#pragma mark - End


#pragma mark - TableView Datasource & Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"TableViewCell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=[UIColor clearColor];
    NSString *menu=[menuArray objectAtIndex:indexPath.row];
    
    
    if(![regularFontTextArray containsObject:menu]){
        cell.menuName.font = [UIFont fontWithName:@"Raleway-Bold" size:22.0];
    }
    
    if (![Utility isEmptyCheck:menu]) {
        cell.menuName.text=[menuArray objectAtIndex:indexPath.row];
        //cell.menuImage.contentMode = UIViewContentModeScaleAspectFit;
        //cell.menuImage.image=[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
        cell.offlineSwitch.tag = indexPath.row;
        
        if ([menu isEqualToString:@"OFFLINE MODE"]) {
            cell.offlineSwitch.hidden = false;
        }else{
            cell.offlineSwitch.hidden = true;
        }
        cell.offlineSwitch.on = [defaults boolForKey:@"isOffline"];

        if (ischeckingError) {
            cell.offlineSwitch.on = !cell.offlineSwitch.isOn;
            [defaults setBool:cell.offlineSwitch.isOn forKey:@"isOffline"];
        }
        if ([Utility isSubscribedUser]) {
            cell.menuName.alpha = 1.0f;
            cell.menuImage.alpha = 1.0f;

        }else if([Utility isSquadLiteUser] || [Utility isSquadFreeUser]){//BOOTY & ABS
            if (([menu isEqualToString:@"HOME"] || [menu isEqualToString:@"PROFILE"] || [menu isEqualToString:@"COMMUNITY"] || [menu isEqualToString:@"HELP"])) {
                cell.menuName.alpha = 1.0f;
                cell.menuImage.alpha = 1.0f;
            }else{
                cell.menuName.alpha = 0.5f;
                cell.menuImage.alpha = 0.5f;
            }
        }
        else{
            if([Utility isSquadFreeUser] && [menu isEqualToString:@"HOME"]){
                cell.menuName.alpha = 1.0f;
                cell.menuImage.alpha = 1.0f;
            }else{
                cell.menuName.alpha = 0.5f;
                cell.menuImage.alpha = 0.5f;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *menu=[self->menuArray objectAtIndex:indexPath.row];
        
        
        UIViewController *topController;
        
        if([self.slidingViewController.topViewController isKindOfClass:[UINavigationController class]]){
            UINavigationController *nav = (UINavigationController *)self.slidingViewController.topViewController;
            NSArray *controllers = [nav viewControllers];
            topController = [controllers lastObject];
            NSLog(@"Top Controller:%@",topController.debugDescription);
        }else{
            topController = self.slidingViewController.topViewController;
        }
        
        if ([menu isEqualToString:@"HOME"]){
            
            int logoClickCount = [[defaults objectForKey:@"LogoClickCount"] intValue];
            [defaults setObject:[NSNumber numberWithInt:logoClickCount+1] forKey:@"LogoClickCount"];

            if(topController && [topController isKindOfClass:[HomePageViewController class]]){
                [[NSNotificationCenter defaultCenter]postNotificationName:@"offlineModeDetails" object:nil];// AY 06032018
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                return;
            }
            
            
            HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
            self.slidingViewController.topViewController = nav;
            [self.slidingViewController resetTopViewAnimated:YES];
            
        } else if ([menu isEqualToString:@"PROFILE"]){
           
            if(topController && [topController isKindOfClass:[MyProfileSettingsViewController class]]){
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                return;
            }
      
            [self profileButtonDetails];
            
        }else if ([menu isEqualToString:@"NUTRITION SETTINGS"]){
            
            if([Utility isSquadLiteUser]){
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                [Utility showSubscribedAlert:topController];
                return;
            }else if([Utility isSquadFreeUser]){
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                [Utility showAlertAfterSevenDayTrail:topController];
                return;
            }else if(topController && [topController isKindOfClass:[NutritionSettingHomeViewController class]]){
                
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                return;
                
            }
            
            
                [self nutritionButtonDetails];
            
        }else if ([menu isEqualToString:@"EXERCISE SETTINGS"]){
            
            if([Utility isSquadLiteUser]){
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                [Utility showSubscribedAlert:topController];
                return;
            }else if([Utility isSquadFreeUser]){
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                [Utility showAlertAfterSevenDayTrail:topController];
                return;
            }else if(topController && [topController isKindOfClass:[CustomExerciseSettingsViewController class]]){
                
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                return;
                
            }
        
                [self exerciseButtonDetails];
           
        }else if ([menu isEqualToString:@"AUDIO SETTINGS"]){
            if([Utility isSquadLiteUser]){
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                [Utility showSubscribedAlert:topController];
                return;
            }else if([Utility isSquadFreeUser]){
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                [Utility showAlertAfterSevenDayTrail:topController];
                return;
            }else if(topController && [topController isKindOfClass:[SettingsViewController class]]){
                
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                return;
                
            }
           
                [self audioButtonDetails];
           
        }else if ([menu isEqualToString:@"OFFLINE MODE"]){
  
        }else if ([menu isEqualToString:@"OFFLINE SESSIONS"]){
            if([Utility isSquadLiteUser]){
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                [Utility showSubscribedAlert:topController];
                return;
            }else if([Utility isSquadFreeUser]){
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                [Utility showAlertAfterSevenDayTrail:topController];
                return;
            }else if(topController && [topController isKindOfClass:[ContentManagementViewController class]]){
                
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                return;
                
            }
           
            [self contentManagementDetails];
            
        }else if ([menu isEqualToString:@"COMMUNITY"]){
            
            if(topController && [topController isKindOfClass:[ConnectViewController class]]){
                
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                return;
                
            }
            if([Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            [self locationPermissionforConnect];
            
        }
        else if ([menu isEqualToString:@"HELP"]){
            
            if(topController && [topController isKindOfClass:[HelpViewController class]]){
                
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                return;
                
            }
            
            [self helpButtonDetails];
            
        }else if ([menu isEqualToString:@"FEATURES"]){
            
            if([Utility isSquadLiteUser]){
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                [Utility showSubscribedAlert:topController];
                return;
            }else if([Utility isSquadFreeUser]){
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                [Utility showAlertAfterSevenDayTrail:topController];
                return;
            }else if(topController && [topController isKindOfClass:[MyProgramsViewController class]]){
                
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                return;
                
            }
            if([Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            [self featuresButtonDetails];
            
        }else if ([menu isEqualToString:@"ACHIEVE"]){
            
            if([Utility isSquadLiteUser]){
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                [Utility showSubscribedAlert:topController];
                return;
            }else if([Utility isSquadFreeUser]){
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                [Utility showAlertAfterSevenDayTrail:topController];
                return;
            }else if(topController && [topController isKindOfClass:[AchieveHomeViewController class]]){

                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                return;

            }
            if([Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            [self achieveButtonDetails];
            
        }else if ([menu isEqualToString:@"APPRECIATE"]){
            
            if([Utility isSquadLiteUser]){
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                [Utility showSubscribedAlert:topController];
                return;
            }else if([Utility isSquadFreeUser]){
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                [Utility showAlertAfterSevenDayTrail:topController];
                return;
            }else if(topController && [topController isKindOfClass:[AppreciateViewController class]]){
                
                [self.slidingViewController anchorTopViewToLeftAnimated:YES];
                [self.slidingViewController resetTopViewAnimated:YES];
                return;
            }
            if([Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            [self appreciateButtonDetails];
            
        }
        
        
    });
}
#pragma mark - End -



#pragma mark - Local Notification Observer and delegate

-(void)quitMenu:(NSNotification *)notification{
    
    NSString *text = notification.object;
    if([text isEqualToString:@"homeButtonPressed"]){
        if(([Utility isSubscribedUser] && [Utility isOfflineMode]) || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
            HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
            self.slidingViewController.topViewController = nav;
            [self.slidingViewController resetTopViewAnimated:YES];
            
        }else{
            BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
            if (!isAllTaskCompleted ){
                HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
                NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                self.slidingViewController.topViewController = nav;
                [self.slidingViewController resetTopViewAnimated:YES];
                
            }else{
//                TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//                GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Achievements"];
                NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                self.slidingViewController.topViewController = nav;
                [self.slidingViewController resetTopViewAnimated:YES];
            }
        }
      
    }
    
}


#pragma mark - End
#pragma mark - Location Manager Delegate Methods -

#pragma mark - End

@end
