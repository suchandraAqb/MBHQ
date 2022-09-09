//
//  LearnNotificationViewController.m
//  Squad
//
//  Created by Amit Yadav on 24/10/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "LearnNotificationViewController.h"
#import "AllMessageViewController.h"

@interface LearnNotificationViewController (){
    
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UILabel *msgLabel;
    
    __weak IBOutlet UIButton *actionButton;
}

@end

@implementation LearnNotificationViewController
#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    actionButton.layer.cornerRadius = actionButton.frame.size.height /2.0;
    actionButton.clipsToBounds = YES;
    containerView.layer.cornerRadius = 15.0;
    containerView.clipsToBounds = YES;
    
    if(_isMessage){
        msgLabel.text = @"You've got a new message";
        [actionButton setTitle:@"READ" forState:UIControlStateNormal];
    }else if(_isSeminar){
        msgLabel.text = @"New program hacks have been released!";
        [actionButton setTitle:@"WATCH NOW" forState:UIControlStateNormal];
    }
    
}
#pragma mark- End

#pragma mark- IBAction
- (IBAction)actionButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if(_isMessage){
        
        AllMessageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AllMessageView"];
        
        if([_fromContoller isKindOfClass:[MasterMenuViewController class]]){
            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
            _fromContoller.slidingViewController.topViewController = nav;
            [_fromContoller.slidingViewController resetTopViewAnimated:YES];
        }else{
            [_fromContoller.navigationController pushViewController:controller animated:YES];
        }
    }else if(_isSeminar){
        CoursesListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CoursesList"];
        if (![Utility isEmptyCheck:_courseName]) {
            controller.courseName = _courseName;
            controller.fromSetProgram = true;
            controller.isRedirectToSetProgram = true;
        }
        if([_fromContoller isKindOfClass:[MasterMenuViewController class]]){
            NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
            _fromContoller.slidingViewController.topViewController = nav;
            [_fromContoller.slidingViewController resetTopViewAnimated:YES];
        }else{
            [_fromContoller.navigationController pushViewController:controller animated:YES];
        }
    }
}
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark- End
@end
