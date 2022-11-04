//
//  LegendViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 03/05/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "LegendViewController.h"

@interface LegendViewController (){
    IBOutlet UIView *contentView;
}

@end

@implementation LegendViewController
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    contentView.layer.cornerRadius = 5.0;
    contentView.layer.masksToBounds = YES;
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
