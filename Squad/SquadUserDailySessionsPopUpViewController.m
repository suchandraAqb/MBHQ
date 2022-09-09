//
//  SquadUserDailySessionsPopUpViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 17/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "SquadUserDailySessionsPopUpViewController.h"

@interface SquadUserDailySessionsPopUpViewController (){
    IBOutlet UIView *contentView;
}

@end

@implementation SquadUserDailySessionsPopUpViewController
@synthesize delegate,sessionDate;
- (void)viewDidLoad {
    [super viewDidLoad];
    contentView.layer.cornerRadius = 7;
    contentView.clipsToBounds = YES;
}
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)optionButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if([delegate respondsToSelector:@selector(didChooseOption:sessionDate:)]){
            [delegate didChooseOption:(int)sender.tag sessionDate:sessionDate];
        }
    }];
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
