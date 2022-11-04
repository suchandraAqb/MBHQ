//
//  ShowImageViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 24/05/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "ShowImageViewController.h"

@interface ShowImageViewController () {
    IBOutlet UILabel *goodnessNameLabel;
    IBOutlet UILabel *goodnessDateLabel;
    IBOutlet UIImageView *imageView;
}

@end

@implementation ShowImageViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    goodnessNameLabel.text = _goodnessName;
    goodnessDateLabel.text = _goodnessDate;
    imageView.image = _image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoTapped:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)back:(id)sender {
    if ([delegate respondsToSelector:@selector(didCheckAnyChangeForShowImage:)]) {
        [delegate didCheckAnyChangeForShowImage:false];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
