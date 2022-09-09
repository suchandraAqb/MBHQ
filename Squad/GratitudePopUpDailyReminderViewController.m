//
//  GratitudePopUpDailyReminderViewController.m
//  Squad
//
//  Created by Amit Yadav on 08/09/22.
//  Copyright © 2022 AQB Solutions. All rights reserved.
//

#import "GratitudePopUpDailyReminderViewController.h"

@interface GratitudePopUpDailyReminderViewController ()
{
    IBOutlet UIButton *crossButton;
    IBOutlet UILabel *heyUserLabel;
    IBOutlet UIButton *iAmGratefulButton;
    
}

@end

@implementation GratitudePopUpDailyReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)crossButtonPressed:(id)sender {
//    if ([self.reminderDelegate respondsToSelector:@selector(cancelReminder)]) {
//        [self.reminderDelegate cancelReminder];
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)iAmGratefulButtonPressed:(id)sender {
    
}

@end
