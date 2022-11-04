//
//  ActionViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 30/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "ActionViewController.h"

@interface ActionViewController (){

    IBOutlet UIButton *nameDropdown;
    IBOutlet NSLayoutConstraint *reminderAndHeightConstraint;
    IBOutlet UIButton *categoryDropdown;
    IBOutlet UISwitch *pushnotification;
    IBOutlet UISwitch *reminderSwitch;
    IBOutlet UISwitch *email;
    IBOutlet UIButton *reminderFrequencyButton;
    IBOutlet UIButton *reminderAnd;
    IBOutlet UIButton *reminderTime;
    IBOutlet UIButton *reminder;
    
    NSArray *reminderFrequency;
    NSArray *timeArray;
    NSArray *reminderAt;
}

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    reminderFrequency =@[
                            @{
                             @"key":@"1",
                             @"value":@"Daily"
                             },@{
                             @"key":@"1",
                             @"value":@"Twice Daily"
                             },@{
                             @"key":@"1",
                             @"value":@"Weekly"
                             },@{
                             @"key":@"1",
                             @"value":@"Fortnightly"
                             },@{
                             @"key":@"1",
                             @"value":@"Monthly"
                             },@{
                             @"key":@"1",
                             @"value":@"Yearly"
                             }
                       ];
    timeArray =@[
                         @{
                             @"key":@"0",
                             @"value":@"12 am"
                             },@{
                             @"key":@"1",
                             @"value":@"1 am"
                             },@{
                             @"key":@"2",
                             @"value":@"2 am"
                             },@{
                             @"key":@"3",
                             @"value":@"3 am"
                             },@{
                             @"key":@"4",
                             @"value":@"4 am"
                             },@{
                             @"key":@"5",
                             @"value":@"5 am"
                             },@{
                             @"key":@"6",
                             @"value":@"6 am"
                             },@{
                             @"key":@"7",
                             @"value":@"7 am"
                             },@{
                             @"key":@"8",
                             @"value":@"8 am"
                             },@{
                             @"key":@"9",
                             @"value":@"9 am"
                             },@{
                             @"key":@"10",
                             @"value":@"10 am"
                             },@{
                             @"key":@"11",
                             @"value":@"11 am"
                             },@{
                             @"key":@"12",
                             @"value":@"12 pm"
                             },@{
                             @"key":@"13",
                             @"value":@"1 pm"
                             },@{
                             @"key":@"14",
                             @"value":@"2 pm"
                             },@{
                             @"key":@"15",
                             @"value":@"3 pm"
                             },@{
                             @"key":@"16",
                             @"value":@"4 pm"
                             },@{
                             @"key":@"17",
                             @"value":@"5 pm"
                             },@{
                             @"key":@"18",
                             @"value":@"6 pm"
                             },@{
                             @"key":@"19",
                             @"value":@"7 pm"
                             },@{
                             @"key":@"20",
                             @"value":@"8 pm"
                             },@{
                             @"key":@"21",
                             @"value":@"9 pm"
                             },@{
                             @"key":@"22",
                             @"value":@"10 pm"
                             },@{
                             @"key":@"23",
                             @"value":@"11 pm"
                             },

                         ];
    reminderAt =@[
                         @{
                             @"key":@"1",
                             @"value":@"At"
                             },@{
                             @"key":@"1",
                             @"value":@"Between"
                             },@{
                             @"key":@"1",
                             @"value":@"Twice Between"
                             }
                         ];
    [self setDefaultValue:reminderFrequency sender:reminderFrequencyButton defaultIndex:0];
    [self setDefaultValue:timeArray sender:reminderAnd defaultIndex:0];
    [self setDefaultValue:timeArray sender:reminderTime defaultIndex:0];
    [self setDefaultValue:reminderAt sender:reminder defaultIndex:0];
    reminderAndHeightConstraint.constant = 0;


    
}
-(void)setDefaultValue:(NSArray *)dataArray sender:(UIButton *)sender defaultIndex:(int)defaultIndex{
    NSDictionary *dict = [dataArray objectAtIndex:defaultIndex];
    [sender setTitle:[dict objectForKey:@"value"] forState:UIControlStateNormal];
    sender.tag = [[dict objectForKey:@"key"] intValue];;

}
- (IBAction)homeButtonPressed:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}
- (IBAction)categoryPressed:(id)sender {
}
- (IBAction)namePressed:(id)sender {
}
- (IBAction)reminderFrequency:(UIButton *)sender {
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSDictionary *dict in reminderFrequency) {
        UIAlertAction* action = [UIAlertAction
                                  actionWithTitle:[dict objectForKey:@"value"]
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      [reminderFrequencyButton setTitle:[dict objectForKey:@"value"] forState:UIControlStateNormal];
                                      reminderFrequencyButton.tag = [[dict objectForKey:@"key"] intValue];
                                  }];
        [alert addAction:action];
    }
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 //  UIAlertController will automatically dismiss the view
                             }];
    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)reminderChange:(id)sender {
}
- (IBAction)pushnotificationChange:(id)sender {
}
- (IBAction)emailChange:(id)sender {
}

- (IBAction)reminderButtonPressed:(UIButton *)sender {
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSDictionary *dict in reminderAt) {
        UIAlertAction* action = [UIAlertAction
                                 actionWithTitle:[dict objectForKey:@"value"]
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [sender setTitle:[dict objectForKey:@"value"] forState:UIControlStateNormal];
                                     sender.tag = [[dict objectForKey:@"key"] intValue];
                                     if ([reminderAt indexOfObject:dict] > 0) {
                                         reminderAndHeightConstraint.constant = 40;
                                     }else{
                                         reminderAndHeightConstraint.constant = 0;
                                     }
                                 }];
        [alert addAction:action];
    }
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 //  UIAlertController will automatically dismiss the view
                             }];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)reminderTimeButtonPressed:(UIButton *)sender {
    [self openTimePicker:sender];
}
- (IBAction)reminderAndButtonPressed:(UIButton *)sender {
    [self openTimePicker:sender];
}
-(void)openTimePicker:(UIButton *)sender{
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSDictionary *dict in timeArray) {
        UIAlertAction* action = [UIAlertAction
                                 actionWithTitle:[dict objectForKey:@"value"]
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [sender setTitle:[dict objectForKey:@"value"] forState:UIControlStateNormal];
                                     sender.tag = [[dict objectForKey:@"key"] intValue];
                                 }];
        [alert addAction:action];
    }
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 //  UIAlertController will automatically dismiss the view
                             }];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
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
