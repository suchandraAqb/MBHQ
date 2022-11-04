//
//  BucketListViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 28/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "BucketListViewController.h"

@interface BucketListViewController ()

@end

@implementation BucketListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)homeButtonPressed:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}
- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
