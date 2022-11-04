//
//  FBWHomeViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 20/07/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//


#import "WebinarListViewController.h"
#import "CoursesListViewController.h"
#import "AudioBookViewController.h"
#import "AppDelegate.h"

@interface FBWHomeViewController () {
    IBOutletCollection(UIView) NSArray *bgViews;
    
    AppDelegate *appDelegate;
}

@end

@implementation FBWHomeViewController
//ah sc

- (void)viewDidLoad {
    [super viewDidLoad];

    for (int i = 0; i < bgViews.count; i++) {
        UIView *bgView = [bgViews objectAtIndex:i];
        CGFloat alpha = 0.4;
        if (i == 0) {
            alpha = 0.4;
        } else if (i == 1) {
            alpha = 0.6;
        }else if (i == 2) {
            alpha = 0.7;
        }
        [bgView setBackgroundColor:[UIColor colorWithRed:131/255.0 green:29/255.0 blue:92/255.0 alpha:alpha]];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
-(IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)fbTrackerTapped:(id)sender {
   
}
- (IBAction)webinarTapped:(id)sender {
    WebinarListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarListView"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)coursesTapped:(id)sender {
    CoursesListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CoursesList"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)audioBookTapped:(id)sender {
    AudioBookViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AudioBook"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
