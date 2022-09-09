//
//  AfterTrialViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 01/04/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "AfterTrialViewController.h"

@interface AfterTrialViewController (){
    
    IBOutlet UILabel *headerLabel;
    IBOutlet UILabel *footerLabel;
    IBOutlet UIButton *doItButton;
    IBOutletCollection(UIView) NSArray *roundedView;
    
}

@end

@implementation AfterTrialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    doItButton.clipsToBounds = YES;
    doItButton.layer.cornerRadius = 25.0;
    
    doItButton.layer.borderColor = squadMainColor.CGColor;
    doItButton.layer.borderWidth = 1;
    
    if (_isTrail) {
        headerLabel.text = @"Welcome to your 7 Day Trial";
        footerLabel.text = @"Let’s set your goals and create a personalised program to get maximum results!";
    }else{
        headerLabel.text = @"Welcome to mbHQ";
        footerLabel.text = @"Let’s set your goals and create a personalised program to get maximum results!";
    }
}
#pragma mark - IBAction -
- (IBAction)doItButtonPressed:(UIButton *)sender {
//    if (_isTrail) {
//        [CustomNavigation startNavigation:self fromMenu:NO navDict:@{@"Identifier":@"ViewPersonalSession"}];//@"CustomNutritionPlanList"
//    }else
//    {
        if (_isAchieve) {
            [CustomNavigation startNavigation:self fromMenu:NO navDict:@{@"Identifier":@"HabitHackerListView"}];
        } else {
            [CustomNavigation startNavigation:self fromMenu:NO navDict:@{@"Identifier":@"GratitudeListView"}];
        }
//    }
}
#pragma mark - End
@end
