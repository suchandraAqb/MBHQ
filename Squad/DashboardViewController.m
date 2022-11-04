//
//  DashboardViewController.m
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 16/05/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import "DashboardViewController.h"
#import "ExcerciseTitleViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

#pragma mark - IBAction
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (IBAction)allFinisherButtonPressed:(UIButton*)sender {
    ExcerciseTitleViewController*controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseTitleView"];
    controller.buttontag=[NSString stringWithFormat:@"%ld", (long)sender.tag];
    controller.mainFinishSquadWowButtonTag = @"finisher";
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - End

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}
#pragma mark - End

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - End

@end
