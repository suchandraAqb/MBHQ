//
//  CongratulationViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 22/9/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CongratulationViewController.h"
#import "SignupWithEmailViewController.h"

@interface CongratulationViewController (){
    IBOutlet UIButton *tryNowButton;
}

@end

@implementation CongratulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(IBAction)tryNowButtonPressed:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignupWithEmailViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"SignupWithEmail"];
    NSDictionary *userData = [defaults objectForKey:@"NonSubscribedUserData"];
    if (![Utility isEmptyCheck:userData] && ![Utility isEmptyCheck:userData[@"Email"]]) {
        controller.isFromFb = ![Utility isEmptyCheck:userData[@"IsFbUser"]]?[userData[@"IsFbUser"] boolValue] : NO;
        controller.fName = ![Utility isEmptyCheck:userData[@"FirstName"]]?userData[@"FirstName"] : @"";
        controller.lName = ![Utility isEmptyCheck:userData[@"LastName"]]?userData[@"LastName"] : @"";
        controller.email = userData[@"Email"];
        if (![Utility isEmptyCheck:userData[@"IsFbUser"]] && [userData[@"IsFbUser"] boolValue]) {
            controller.password = ![Utility isEmptyCheck:userData[@"Password"]]?userData[@"Password"] : @"";
        }else{
            controller.password =  @"";
        }
        controller.isFromNonSubscribedUser = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else{
        [Utility msg:@"Sorry, there are some issues. Please try later" title:@"Error !" controller:self haveToPop:NO];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
