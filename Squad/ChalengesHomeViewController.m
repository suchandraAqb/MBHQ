//
//  ChalengesHomeViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 15/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "ChalengesHomeViewController.h"
#import "DashboardViewController.h"
#import "ExcerciseTitleViewController.h"
#import "MasterMenuViewController.h"
#import "LeaderBoardViewController.h"

@interface ChalengesHomeViewController ()

@end

@implementation ChalengesHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark -IBAction
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ashyFinisherButtonPressed:(id)sender {
//    DashboardViewController*controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DashboardView"];
//    [self.navigationController pushViewController:controller animated:YES];
    ExcerciseTitleViewController*controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseTitleView"];
    controller.mainFinishSquadWowButtonTag = @"";
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)squadEliteButtonPressed:(id)sender {
    ExcerciseTitleViewController*controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseTitleView"];
    controller.mainFinishSquadWowButtonTag = @"squad";
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)wowButtonPressed:(id)sender {
    ExcerciseTitleViewController*controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseTitleView"];
    controller.mainFinishSquadWowButtonTag = @"wow";
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)battleButtonPressed:(id)sender {
    ExcerciseTitleViewController*controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseTitleView"];
    controller.mainFinishSquadWowButtonTag = @"battle";
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(IBAction)leaaderBoardButtonPressed:(id)sender {
    LeaderBoardViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeaderBoard"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)compositionchallengeButtonPressed:(id)sender {
    [Utility msg:@"Coming Soon." title:@"Alert" controller:self haveToPop:NO];
  /*  ExcerciseTitleViewController*controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseTitleView"];
    controller.mainFinishSquadWowButtonTag = @"composition";
    [self.navigationController pushViewController:controller animated:YES];
   */
}
- (IBAction)collectiveButtonPressed:(id)sender {
    ExcerciseTitleViewController*controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseTitleView"];
    controller.mainFinishSquadWowButtonTag = @"collective";
    [self.navigationController pushViewController:controller animated:YES];
   
}

#pragma mark -End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
