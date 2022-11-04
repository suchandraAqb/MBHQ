//
//  FreeModeAlertViewController.m
//  Squad
//
//  Created by Suchandra Bhattacharya on 11/09/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "FreeModeAlertViewController.h"
#import "SignupWithEmailViewController.h"
@interface FreeModeAlertViewController ()
{
     __weak IBOutlet UIButton *createMyHappinessHabitBtn;
    
}
@end

@implementation FreeModeAlertViewController

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    createMyHappinessHabitBtn.layer.cornerRadius = 15;
    createMyHappinessHabitBtn.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view.
}

#pragma mark - End

#pragma mark - IBAction
-(IBAction)createMyHapinessHabitBtnPressed:(id)sender{
    [defaults setObject:nil forKey:@"taskListArray"];
    [defaults setBool:YES forKey:@"isFirstTimeForum"];
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
-(IBAction)freeVersionTapped:(id)sender{
    [defaults setObject:nil forKey:@"taskListArray"];
    [defaults setBool:YES forKey:@"isFirstTimeForum"];
    dispatch_async(dispatch_get_main_queue(), ^{
        ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
        HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
        NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        slider.topViewController = nav;
        [slider resetTopViewAnimated:NO];
        [self.navigationController pushViewController:slider animated:NO];
    });
}
#pragma mark - End
@end
