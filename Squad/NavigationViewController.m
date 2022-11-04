//
//  NavigationViewController.m
//  The Life
//
//  Created by AQB SOLUTIONS on 28/03/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "NavigationViewController.h"
#import "Utility.h"
#import "SignupWithEmailViewController.h"
@interface NavigationViewController ()

@end

@implementation NavigationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    /*if (![Utility isSubscribedUser] && [Utility isSevenDaysCrossedFromInstallation] && ![[[viewController class] description] isEqualToString:@"SignupWithEmailViewController"] && ![[[viewController class] description] isEqualToString:@"ParentViewController"] && ![[[viewController class] description] isEqualToString:@"LoginController"]) {
        [Utility showAlertAfterSevenDayTrail:self];
    }else if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"] && [notAllowedWithoutTrailLoginArray containsObject:[[viewController class] description]]) {
        if ([[[viewController class] description] isEqualToString:@"CustomNutritionPlanListViewController"]) {
            [Utility showTrailLoginAlert:self ofType:viewController];
        }else{
            [Utility showTrailLoginAlert:self ofType:self];
        }
    } else{
        [super pushViewController:viewController animated:animated];
    }*/
    
    [super pushViewController:viewController animated:animated];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated{
    return [super popViewControllerAnimated:NO];
}
-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    return [super popToViewController:viewController animated:NO];
}
-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    return [super popToRootViewControllerAnimated:NO];
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
