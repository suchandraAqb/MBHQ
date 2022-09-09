//
//  MenuViewController.m
//  Squad
//
//  Created by Admin on 21/11/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
{
    
    IBOutlet UIButton *helpButton;
    IBOutlet UIButton *profileButton;
    IBOutlet UIButton *homeButton;
    IBOutlet UIButton *signoutButton;
    
    
}
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    signoutButton.layer.cornerRadius=10.0;
}



@end
