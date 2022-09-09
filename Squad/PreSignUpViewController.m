//
//  PreSignUpViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 26/05/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "PreSignUpViewController.h"
#import "SignupWithEmailViewController.h"

@interface PreSignUpViewController (){
    IBOutlet UIButton *backButton;
    IBOutlet UIScrollView *scrollImageView;
    IBOutlet UIView *pageView;
    IBOutlet UIPageControl *pageControl;
    BOOL pageControlIsChangingPage;
    UIView *contentView;
    NSString *facebookUserId;
    NSString *facebookTokenString;
}

@end

@implementation PreSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - IBAction
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)loginButtonPressed:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.navigationController pushViewController:controller animated:YES];

}
- (IBAction)signupWithFaceBookButtonPressed:(id)sender{
    if (Utility.reachable) {
        
    }else
    {
        [Utility msg:@"Check Your network connection and try again." title:@"Error!" controller:self haveToPop:NO];
    }
}
- (IBAction)signupWithEmailButtonPressed:(id)sender{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SevenDayTrialViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"SevenDayTrial"];
//    controller.isFromFb = NO;
//    [self.navigationController pushViewController:controller animated:YES];
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
#pragma mark - End
#pragma mark - UIScrollViewDelegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (pageControlIsChangingPage) {
        return;
    }
    CGFloat pageWidth = scrollImageView.frame.size.width;
    float fractionalPage = scrollImageView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlIsChangingPage = NO;
}

#pragma mark - End

#pragma mark - UIPageControl method

//Method to swipe between the pages
- (IBAction)changePage:(id)sender
{
    //move the scroll view
    CGRect frame = scrollImageView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [scrollImageView scrollRectToVisible:frame animated:YES];
    //scrollViewDidEndDecelerating will turn this off
    pageControlIsChangingPage = YES;
}

#pragma mark - End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
