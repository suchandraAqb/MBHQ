//
//  MealSettingInfoPopUpViewController.m
//  Squad
//
//  Created by aqbsol iPhone on 16/02/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "MealSettingInfoPopUpViewController.h"

@interface MealSettingInfoPopUpViewController ()
{
    IBOutlet UIView *popUpView;
}
@end

@implementation MealSettingInfoPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    popUpView.layer.cornerRadius = 25;
    popUpView.layer.masksToBounds = true;
}
-(IBAction)backPressed:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
