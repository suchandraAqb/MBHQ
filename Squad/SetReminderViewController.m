//
//  SetReminderViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 07/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "SetReminderViewController.h"
#import "DropdownViewController.h"

@interface SetReminderViewController () {
    
    IBOutlet UIView *mainView;
    IBOutlet UIStackView *mainStackView;
    IBOutlet UIView *pushNotificationView;
    IBOutlet UIView *emailView;
    IBOutlet UIView *frequencyView;
    IBOutlet UIView *daysView;
    IBOutlet UIView *monthsView;
    IBOutlet UIView *dayForMonthView;
    IBOutlet UIView *firstReminderView;
    IBOutlet UIView *secondReminderView;
    IBOutlet UISwitch *pushNotificationSwitch;
    IBOutlet UISwitch *emailSwitch;
    IBOutlet UIButton *frequencyButton;
    IBOutletCollection(UIButton) NSArray *daysButtons;
    IBOutletCollection(UIButton) NSArray *monthsButtons;
    IBOutlet UIButton *daysForMonthButton;
    IBOutlet UIView *backgroundView;
    IBOutlet UIButton *reminderMiddleButton;
    IBOutlet UIButton *reminderTimeButton;
    IBOutlet UIButton *reminderAndTimeButton;
    IBOutlet UILabel *applyText;
    IBOutlet UIButton *applyButton;
    IBOutlet UILabel *reminderSettingslabel;
    IBOutlet UILabel *reminderFrequencyLabel;
    IBOutlet UILabel *reminderLabel;
    IBOutlet UILabel *selctdayForMonthLabel;
    NSMutableArray *frequencyArray;
    NSMutableArray *dayForMonthArray;
    NSMutableArray *reminderMiddleArray;
    NSMutableArray *reminderTimeArray;
    NSMutableDictionary *resultDict;
    NSArray *monthArray;
    NSArray *dayArray;
}

@end

UNUserNotificationCenter *center;   //ah ln

@implementation SetReminderViewController
@synthesize defaultSettingsDict,reminderDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    frequencyArray = [[NSMutableArray alloc]init];
    dayForMonthArray = [[NSMutableArray alloc]init];
    reminderMiddleArray = [[NSMutableArray alloc]init];
    reminderTimeArray = [[NSMutableArray alloc]init];
    resultDict = [[NSMutableDictionary alloc]init];
    monthArray = [[NSArray alloc]init];
    dayArray = [[NSArray alloc]init];
    [mainView setNeedsLayout];
    [mainView layoutIfNeeded];
    mainView.layer.cornerRadius = 25.0;
    mainView.layer.masksToBounds = YES;
    
    for (UIButton  *daysButton in daysButtons) {
        daysButton.layer.cornerRadius = daysButton.frame.size.height/2;
        [self changeButtonBackground:daysButton selected:false];
//        [daysButton setBackgroundImage:[UIImage imageNamed:@"ash_circle.png"] forState:UIControlStateNormal];
//        [daysButton setBackgroundImage:[UIImage imageNamed:@"blue_circle.png"] forState:UIControlStateSelected];
    }
    for (UIButton  *monthsButton in monthsButtons) {
        monthsButton.layer.cornerRadius = monthsButton.frame.size.height/2;
        [self changeButtonBackground:monthsButton selected:false];
//        [monthsButton setBackgroundImage:[UIImage imageNamed:@"ash_circle.png"] forState:UIControlStateNormal];
//        [monthsButton setBackgroundImage:[UIImage imageNamed:@"blue_circle.png"] forState:UIControlStateSelected];
    }
    [pushNotificationSwitch setOn:YES];
    [emailSwitch setOn:NO];
    if (_fromGratitude) {
        [frequencyButton setTitle:@"Monthly" forState:UIControlStateNormal];
    }else if([_fromController isEqualToString:@"Vitamin"]){//ADD_SB_1
        [frequencyButton setTitle:@"Weekly" forState:UIControlStateNormal];
    }else if(_isremoveDailyTwiceDaily){
        [frequencyButton setTitle:@"Weekly" forState:UIControlStateNormal];
    }
    else{
        [frequencyButton setTitle:@"Daily" forState:UIControlStateNormal];
    }
    [reminderMiddleButton setTitle:@"At" forState:UIControlStateNormal];
    [reminderTimeButton setTitle:@"12:00 PM" forState:UIControlStateNormal];
    
    NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
    monthArray = [newDateformatter monthSymbols];
    dayArray = [newDateformatter weekdaySymbols];
    
    if (_isFromHacker) {
        pushNotificationView.hidden = true;
        emailView.hidden = true;
        reminderSettingslabel.text = @"";//NEW HABIT SETTINGS
        reminderFrequencyLabel.text = @"Frequency";
        reminderLabel.text =@"";
        selctdayForMonthLabel.text = @"Select Day for Month";
        firstReminderView.hidden = true;
        secondReminderView.hidden = true;
    }else{
        reminderSettingslabel.text = @"REMINDER SETTINGS";
        reminderFrequencyLabel.text = @"Reminder Frequency";
        reminderLabel.text = @"Reminder";
        selctdayForMonthLabel.text = @"Select Day for Month Reminder";
        firstReminderView.hidden = false;
        secondReminderView.hidden = false;
    }
    
    daysView.hidden = YES;
    monthsView.hidden = YES;
    dayForMonthView.hidden = YES;
    secondReminderView.hidden = YES;
//    if (![Utility isEmptyCheck:_fromController] && [_fromController caseInsensitiveCompare:@"PersonalChallenge"]==NSOrderedSame) {
//        pushNotificationView.hidden = true;
//        emailView.hidden = true;
//    }
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if (![Utility isEmptyCheck:_fromController] && [_fromController caseInsensitiveCompare:@"PersonalChallenge"]) {
        frequencyArray = [@[@"Daily",@"Twice Daily",@"Weekly",@"Fortnightly",@"Monthly"] mutableCopy];
    }else if(_isFromHacker || _isfromHabitHideYearly){
        frequencyArray = [@[@"Daily",@"Weekly",@"Fortnightly",@"Monthly"] mutableCopy];//@"Twice Daily"
    }else if(_isremoveDailyTwiceDaily){
        frequencyArray = [@[@"Weekly",@"Fortnightly",@"Monthly",@"Yearly",@"This time next year"] mutableCopy];
        
    } else{
        frequencyArray = [@[@"Daily",@"Twice Daily",@"Weekly",@"Fortnightly",@"Monthly",@"Yearly"] mutableCopy];
    }
    
    for (int i = 0; i < 30; i++) {
        [dayForMonthArray addObject:[NSString stringWithFormat:@"%d Day of Month",i+1]];
    }
    
    reminderMiddleArray = [@[@"At",@"Between",@"Twice Between"] mutableCopy];
    
    [reminderTimeArray addObject:@"12 am"];
    for (int i = 1; i < 12; i++) {
        [reminderTimeArray addObject:[NSString stringWithFormat:@"%d am",i]];
    }
    [reminderTimeArray addObject:@"12 pm"];
    for (int i = 1; i < 12; i++) {
        [reminderTimeArray addObject:[NSString stringWithFormat:@"%d pm",i]];
    }
    
    if (![Utility isEmptyCheck:defaultSettingsDict] && defaultSettingsDict.count > 0) {
        @try {      //ah ac1
            [resultDict addEntriesFromDictionary:defaultSettingsDict];
            
            if (_fromAddVitaminGp || (![Utility isEmptyCheck:[defaultSettingsDict objectForKey:@"ReminderVitaminId"]] && [[defaultSettingsDict objectForKey:@"ReminderVitaminId"]intValue]>0)) {
                [pushNotificationSwitch setUserInteractionEnabled:false];
                [emailSwitch setUserInteractionEnabled:false];
                [frequencyButton setUserInteractionEnabled:false];
                [daysForMonthButton setUserInteractionEnabled:false];
                [reminderTimeButton setUserInteractionEnabled:false];
                [reminderAndTimeButton setUserInteractionEnabled:false];
                [reminderMiddleButton setUserInteractionEnabled:false];
                [firstReminderView setUserInteractionEnabled:false];
                [secondReminderView setUserInteractionEnabled:false];
                [daysView setUserInteractionEnabled:false];
                [monthsView setUserInteractionEnabled:false];
                [dayForMonthView setUserInteractionEnabled:false];
                applyText.text = @"GROUP";
            }else{
                applyText.text = @"APPLY";
                [pushNotificationSwitch setUserInteractionEnabled:true];
                [emailSwitch setUserInteractionEnabled:true];
                [frequencyButton setUserInteractionEnabled:true];
                [daysForMonthButton setUserInteractionEnabled:true];
                [reminderTimeButton setUserInteractionEnabled:true];
                [reminderAndTimeButton setUserInteractionEnabled:true];
                [reminderMiddleButton setUserInteractionEnabled:true];
                [firstReminderView setUserInteractionEnabled:true];
                [secondReminderView setUserInteractionEnabled:true];
                [daysView setUserInteractionEnabled:true];
                [monthsView setUserInteractionEnabled:true];
                [dayForMonthView setUserInteractionEnabled:true];
            }
           
            //set switchs
            if (![Utility isEmptyCheck:[defaultSettingsDict objectForKey:@"PushNotification"]] && [[defaultSettingsDict objectForKey:@"PushNotification"] boolValue]) {
                [pushNotificationSwitch setOn:YES];
            } else {
                [pushNotificationSwitch setOn:NO];
            }
            if (![Utility isEmptyCheck:[defaultSettingsDict objectForKey:@"Email"]] &&[[defaultSettingsDict objectForKey:@"Email"] boolValue]) {
                [emailSwitch setOn:YES];
            } else {
                [emailSwitch setOn:NO];
            }
            
            //set title of all buttons
            if (![Utility isEmptyCheck:[defaultSettingsDict objectForKey:@"FrequencyId"]] && [[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue] > 0){
                if (_isFromReminder) {
                    [frequencyButton setTitle:[frequencyArray objectAtIndex:[[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]-3] forState:UIControlStateNormal];

                }else if(_isFromHacker || _isfromHabitHideYearly){
                    if ([[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue] == 1) {
                        [frequencyButton setTitle:[frequencyArray objectAtIndex:[[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]-1] forState:UIControlStateNormal];
                    }else if ([[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue] >= 3) {
                        [frequencyButton setTitle:[frequencyArray objectAtIndex:[[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]-2] forState:UIControlStateNormal];
                        }
//                    else if ([[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue] >= 4) {
//                        [frequencyButton setTitle:[frequencyArray objectAtIndex:[[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]-1] forState:UIControlStateNormal];
//                        }
                    }
                
                else{
                    [frequencyButton setTitle:[frequencyArray objectAtIndex:[[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]-1] forState:UIControlStateNormal];

                }
            }
            
            if (![Utility isEmptyCheck:[defaultSettingsDict objectForKey:@"MonthReminder"]] && [[defaultSettingsDict objectForKey:@"MonthReminder"] integerValue] > 0)
                [daysForMonthButton setTitle:[dayForMonthArray objectAtIndex:[[defaultSettingsDict objectForKey:@"MonthReminder"] integerValue]-1] forState:UIControlStateNormal];
            
            if (![Utility isEmptyCheck:[defaultSettingsDict objectForKey:@"ReminderAt1"]]){
                int interval=[[defaultSettingsDict objectForKey:@"ReminderAt1"] intValue];
                        NSDate * date = [NSDate date];
                        int totalSeconds=[Utility secondsFromDate:date includeSeconds:YES];
                        date=[date dateBySubtractingSeconds:totalSeconds];
                        date=[date dateByAddingSeconds:interval];
                        NSDateFormatter *df = [NSDateFormatter new];
                        [df setDateFormat:@"hh:mm a"];//hh:mm a
                        [reminderTimeButton setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
                
//                [reminderTimeButton setTitle:[reminderTimeArray objectAtIndex:[[defaultSettingsDict objectForKey:@"ReminderAt1"] integerValue]] forState:UIControlStateNormal];
            }
            
            if (![Utility isEmptyCheck:[defaultSettingsDict objectForKey:@"ReminderAt2"]]){
                int interval=[[defaultSettingsDict objectForKey:@"ReminderAt2"] intValue];
                NSDate * date = [NSDate date];
                int totalSeconds=[Utility secondsFromDate:date includeSeconds:YES];
                date=[date dateBySubtractingSeconds:totalSeconds];
                date=[date dateByAddingSeconds:interval];
                NSDateFormatter *df = [NSDateFormatter new];
                [df setDateFormat:@"hh:mm a"];//hh:mm a
                [reminderAndTimeButton setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
                
//                [reminderAndTimeButton setTitle:[reminderTimeArray objectAtIndex:[[defaultSettingsDict objectForKey:@"ReminderAt2"] integerValue]] forState:UIControlStateNormal];

            }
            
            if (![Utility isEmptyCheck:[defaultSettingsDict objectForKey:@"ReminderOption"]] && [[defaultSettingsDict objectForKey:@"ReminderOption"] integerValue] > 0)
                [reminderMiddleButton setTitle:[reminderMiddleArray objectAtIndex:[[defaultSettingsDict objectForKey:@"ReminderOption"] integerValue]-1] forState:UIControlStateNormal];
            
            //middle button settings
            if (_isFromHacker) {
                firstReminderView.hidden = YES;
            }else{
                firstReminderView.hidden = NO;
            }
            
            if (_isFromHacker) {
                secondReminderView.hidden = YES;
            }else{
                if (![Utility isEmptyCheck:[defaultSettingsDict objectForKey:@"ReminderOption"]] && [[defaultSettingsDict objectForKey:@"ReminderOption"] integerValue] > 0 && [[reminderMiddleArray objectAtIndex:[[defaultSettingsDict objectForKey:@"ReminderOption"] integerValue]-1] caseInsensitiveCompare:@"At"] == NSOrderedSame) {
                               secondReminderView.hidden = YES;
                           }else {
                               secondReminderView.hidden = NO;
                           }
            }
           
            
            //frequency button settings
            if (![Utility isEmptyCheck:[defaultSettingsDict objectForKey:@"FrequencyId"]] && [[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue] > 0) {
                daysView.hidden = YES;
                monthsView.hidden = YES;
                dayForMonthView.hidden = YES;
                if (_isFromHacker) {
                    firstReminderView.hidden = YES;
                }else{
                    firstReminderView.hidden = NO;
                }
                
                if (_isFromHacker) {
                    secondReminderView.hidden = YES;
                }else{
                    NSString *middleButtonTitle = [reminderMiddleButton titleForState:UIControlStateNormal];
                    if ([middleButtonTitle caseInsensitiveCompare:@"At"] == NSOrderedSame) {
                        secondReminderView.hidden = YES;
                    } else {
                        secondReminderView.hidden = NO;
                    }
                }
                if (_isFromReminder) {
                 if ([[frequencyArray objectAtIndex:[[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]-3] caseInsensitiveCompare:@"Weekly"] == NSOrderedSame) {
                          daysView.hidden = NO;
                       } else if ([[frequencyArray objectAtIndex:[[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]-3] caseInsensitiveCompare:@"Fortnightly"] == NSOrderedSame) {
                           daysView.hidden = NO;
                       } else if ([[frequencyArray objectAtIndex:[[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]-3] caseInsensitiveCompare:@"Monthly"] == NSOrderedSame) {
                           dayForMonthView.hidden = NO;
                       } else if ([[frequencyArray objectAtIndex:[[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]-3] caseInsensitiveCompare:@"Yearly"] == NSOrderedSame) {
                           monthsView.hidden = NO;
                           dayForMonthView.hidden = NO;
                       }
            }else if(_isFromHacker || _isfromHabitHideYearly){
                int value = 0;
                if ([[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]>1) {
                   value = [[defaultSettingsDict objectForKey:@"FrequencyId"] intValue]-2;
                }else{
                    value = [[defaultSettingsDict objectForKey:@"FrequencyId"] intValue]-1;
                }
            if ([[frequencyArray objectAtIndex:value] caseInsensitiveCompare:@"Daily"] == NSOrderedSame) {
                //default
            } else if ([[frequencyArray objectAtIndex:value] caseInsensitiveCompare:@"Weekly"] == NSOrderedSame) {
                daysView.hidden = NO;
            } else if ([[frequencyArray objectAtIndex:value] caseInsensitiveCompare:@"Fortnightly"] == NSOrderedSame) {
                daysView.hidden = NO;
            } else if ([[frequencyArray objectAtIndex:value] caseInsensitiveCompare:@"Monthly"] == NSOrderedSame) {
                dayForMonthView.hidden = NO;
            }
            }else{
                if ([[frequencyArray objectAtIndex:[[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]-1] caseInsensitiveCompare:@"Daily"] == NSOrderedSame) {
                    //default
                } else if ([[frequencyArray objectAtIndex:[[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]-1] caseInsensitiveCompare:@"Twice Daily"] == NSOrderedSame) {
                    if (_isFromHacker) {
                         secondReminderView.hidden = YES;
                    }else{
                         secondReminderView.hidden = NO;
                    }
                } else if ([[frequencyArray objectAtIndex:[[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]-1] caseInsensitiveCompare:@"Weekly"] == NSOrderedSame) {
                    daysView.hidden = NO;
                } else if ([[frequencyArray objectAtIndex:[[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]-1] caseInsensitiveCompare:@"Fortnightly"] == NSOrderedSame) {
                    daysView.hidden = NO;
                } else if ([[frequencyArray objectAtIndex:[[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]-1] caseInsensitiveCompare:@"Monthly"] == NSOrderedSame) {
                    dayForMonthView.hidden = NO;
                } else if ([[frequencyArray objectAtIndex:[[defaultSettingsDict objectForKey:@"FrequencyId"] integerValue]-1] caseInsensitiveCompare:@"Yearly"] == NSOrderedSame) {
                    monthsView.hidden = NO;
                    dayForMonthView.hidden = NO;
                    }
                }
            }
        
            //selected day and month names settings
            for (UIButton  *daysButton in daysButtons) {
                if (![Utility isEmptyCheck:[defaultSettingsDict objectForKey:[dayArray objectAtIndex:daysButton.tag-1]]] && [[defaultSettingsDict objectForKey:[dayArray objectAtIndex:daysButton.tag-1]] boolValue]) {
                    [daysButton setSelected:YES];
                    [self changeButtonBackground:daysButton selected:YES];
                } else {
                    [daysButton setSelected:NO];
                    [self changeButtonBackground:daysButton selected:NO];
                }
            }
            for (UIButton  *monthsButton in monthsButtons) {
                if (![Utility isEmptyCheck:[defaultSettingsDict objectForKey:[monthArray objectAtIndex:monthsButton.tag-101]]] && [[defaultSettingsDict objectForKey:[monthArray objectAtIndex:monthsButton.tag-101]] boolValue]) {
                    [monthsButton setSelected:YES];
                    [self changeButtonBackground:monthsButton selected:YES];
                } else {
                    [monthsButton setSelected:NO];
                    [self changeButtonBackground:monthsButton selected:NO];
                }
            }
            
        } @catch (NSException *exception) {
            NSLog(@"reminderException %@",exception);
        } @finally {
            
        }
    }else {
        if (_fromGratitude) {
            [resultDict setObject:[NSNumber numberWithInt:5] forKey:@"FrequencyId"];
            dayForMonthView.hidden = NO;
        }else if([_fromController isEqualToString:@"Vitamin"]){
            [self dropdownSelected:@"Weekly" sender:frequencyButton type:@""];
        }else{
            [resultDict setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
            dayForMonthView.hidden = YES;
        }
        [resultDict setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
        [resultDict setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt1"];
        [resultDict setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt2"];
        [resultDict setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
        [resultDict setObject:[NSNumber numberWithBool:true] forKey:@"PushNotification"];
        [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
        applyText.text = @"APPLY";
 
        for (int i = 0; i < monthArray.count; i++) {
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:i]];
        }
        for (int i = 0; i < dayArray.count; i++) {
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
        }
    }
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)changeButtonBackground:(UIButton *)button selected:(BOOL)selected{
    if (selected) {
        [button setBackgroundColor:squadMainColor];
    } else {
        [button setBackgroundColor:squadSubColor];
    }
}

#pragma mark - IBAction
- (IBAction)frequencyButtonTapped:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = self->frequencyArray;
        controller.sender = sender;
        controller.selectedIndex = (int)[self->frequencyArray indexOfObject:[sender currentTitle]];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
- (IBAction)pushNotificationChange:(id)sender {
    if ([sender isOn]) {
        [resultDict setObject:[NSNumber numberWithBool:true] forKey:@"PushNotification"];
    } else {
        [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
    }
}
- (IBAction)emailChange:(id)sender {
    if ([sender isOn]) {
        [resultDict setObject:[NSNumber numberWithBool:true] forKey:@"Email"];
    } else {
        [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
    }
}
- (IBAction)daysButtonTapped:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setSelected:NO];
        [self changeButtonBackground:sender selected:NO];
        [resultDict setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:sender.tag-1]];
    } else {
        [sender setSelected:YES];
        [self changeButtonBackground:sender selected:YES];
        [resultDict setObject:[NSNumber numberWithBool:true] forKey:[dayArray objectAtIndex:sender.tag-1]];
    }
}
- (IBAction)monthsButtonsTapped:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setSelected:NO];
        [self changeButtonBackground:sender selected:NO];
        [resultDict setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:sender.tag-101]];
    } else {
        [sender setSelected:YES];
        [self changeButtonBackground:sender selected:YES];
        [resultDict setObject:[NSNumber numberWithBool:true] forKey:[monthArray objectAtIndex:sender.tag-101]];
    }
}
- (IBAction)daysForMonthTapped:(id)sender {
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = dayForMonthArray;
    controller.sender = sender;
    controller.selectedIndex = (int)[dayForMonthArray indexOfObject:[sender currentTitle]];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)reminderMiddleButtonTapped:(id)sender {
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = reminderMiddleArray;
    controller.sender = sender;
    controller.selectedIndex = (int)[reminderMiddleArray indexOfObject:[sender currentTitle]];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)reminderTimeTapped:(id)sender {
    NSDate * date = [NSDate date];
    int totalSeconds=[Utility secondsFromDate:date includeSeconds:YES];
    date=[date dateBySubtractingSeconds:totalSeconds];
    if (![Utility isEmptyCheck:[resultDict objectForKey:@"ReminderAt1"]]){
        int interval=[[resultDict objectForKey:@"ReminderAt1"] intValue];
        date=[date dateByAddingSeconds:interval];
    }else{
        int interval=12*3600;
        date=[date dateByAddingSeconds:interval];
    }
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
//  controller.maxDate = [NSDate date];
//  NSTimeInterval sixmonth = 5*60*60;
//  controller.minDate = [[NSDate date]dateByAddingTimeInterval:sixmonth];
    controller.senderButton=sender;
    controller.selectedDate = date;
    controller.datePickerMode = UIDatePickerModeTime;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
    
    
    
    
    
    
    
    
    
//    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
//    controller.modalPresentationStyle = UIModalPresentationCustom;
//    controller.dropdownDataArray = reminderTimeArray;
//    controller.sender = sender;
//    controller.selectedIndex = (int)[reminderTimeArray indexOfObject:[sender currentTitle]];
//    controller.delegate = self;
//    [self presentViewController:controller animated:YES completion:nil];
    
}
- (IBAction)reminderAndTimeTapped:(id)sender {
    NSDate * date = [NSDate date];
    int totalSeconds=[Utility secondsFromDate:date includeSeconds:YES];
    date=[date dateBySubtractingSeconds:totalSeconds];
    if (![Utility isEmptyCheck:[resultDict objectForKey:@"ReminderAt2"]]){
        int interval=[[resultDict objectForKey:@"ReminderAt2"] intValue];
        date=[date dateByAddingSeconds:interval];
    }else{
        int interval=12*3600;
        date=[date dateByAddingSeconds:interval];
    }
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
    //  controller.maxDate = [NSDate date];
    //  NSTimeInterval sixmonth = 5*60*60;
    //  controller.minDate = [[NSDate date]dateByAddingTimeInterval:sixmonth];
        controller.senderButton=sender;
        controller.selectedDate = date;
        controller.datePickerMode = UIDatePickerModeTime;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    
    
    
    
    
//    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
//    controller.modalPresentationStyle = UIModalPresentationCustom;
//    controller.dropdownDataArray = reminderTimeArray;
//    controller.sender = sender;
//    controller.selectedIndex = (int)[reminderTimeArray indexOfObject:[sender currentTitle]];
//    controller.delegate = self;
//    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)doneTapped:(id)sender {
    //gami_badge_popup
    int frequencyId = [resultDict[@"FrequencyId"] intValue];
    if (_isremoveDailyTwiceDaily){
        if ([frequencyButton.titleLabel.text isEqualToString:@"Weekly"]) {
            frequencyId = 3;
        }else if ([frequencyButton.titleLabel.text isEqualToString:@"Fortnightly"]){
            frequencyId = 4;
        }else if ([frequencyButton.titleLabel.text isEqualToString:@"Monthly"]){
            frequencyId = 5;
        }else if ([frequencyButton.titleLabel.text isEqualToString:@"Yearly"]){
            frequencyId = 6;
        }
        else if ([frequencyButton.titleLabel.text isEqualToString:@"This time next year"]){
            frequencyId = 6;
        }
        [resultDict setObject:[NSNumber numberWithInt:frequencyId] forKey:@"FrequencyId"];
    }else if(_isFromHacker || _isfromHabitHideYearly){
        if ([frequencyButton.titleLabel.text isEqualToString:@"Weekly"]) {
            frequencyId = 3;
        }else if ([frequencyButton.titleLabel.text isEqualToString:@"Fortnightly"]){
            frequencyId = 4;
        }else if ([frequencyButton.titleLabel.text isEqualToString:@"Monthly"]){
            frequencyId = 5;
        }
        [resultDict setObject:[NSNumber numberWithInt:frequencyId] forKey:@"FrequencyId"];

    }
    if(frequencyId != 2){
        if (![Utility isEmptyCheck:resultDict[@"ReminderAt1"]]) {
            int reminder1 = [resultDict[@"ReminderAt1"] intValue];
            [resultDict setObject:[NSNumber numberWithInt:reminder1] forKey:@"ReminderAt2"];
        } else {
            [resultDict setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt1"];
            [resultDict setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt2"];
        }
    } else {
        if ([Utility isEmptyCheck:resultDict[@"ReminderAt1"]]) {
            [resultDict setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt1"];
            [resultDict setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt2"];
        }
    }
    if (frequencyId == 6 && [frequencyButton.titleLabel.text isEqualToString:@"This time next year"]) {
       NSDate * date = [NSDate date];
       int totalSeconds=[Utility secondsFromDate:date includeSeconds:YES];
       date=[date dateBySubtractingSeconds:totalSeconds];
       if (![Utility isEmptyCheck:[resultDict objectForKey:@"ReminderAt1"]]){
           [resultDict setObject:[NSNumber numberWithInt:totalSeconds] forKey:@"ReminderAt1"];
           [resultDict setObject:[NSNumber numberWithInt:totalSeconds] forKey:@"ReminderAt2"];

       }
        int month =(int)[date month];
        [resultDict setObject:[NSNumber numberWithBool:true] forKey:[monthArray objectAtIndex:(month-1)]];
    }
    
    if (_fromAddVitaminGp || (![Utility isEmptyCheck:[defaultSettingsDict objectForKey:@"ReminderVitaminId"]] && [[defaultSettingsDict objectForKey:@"ReminderVitaminId"]intValue]>0)){
        [resultDict setObject:[NSNumber numberWithBool:YES] forKey:@"isGruopEnable"];
    }
    if ([self.reminderDelegate respondsToSelector:@selector(reminderSettingsValue:)]) {
        [self.reminderDelegate reminderSettingsValue:resultDict];
    }
    if (_isFirstTime) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    //gami_badge_popup

}
-(IBAction)closeTapped:(id)sender {
    if ([self.reminderDelegate respondsToSelector:@selector(cancelReminder)]) {
        [self.reminderDelegate cancelReminder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark end

#pragma mark -Date Picker Delegate
-(void) didSelectDate:(NSDate *)date withSenderButton:(UIButton *)senderButton{
    if (date) {
        int interval=[Utility secondsFromDate:date includeSeconds:NO];
        if (senderButton == reminderTimeButton) {
            [resultDict setObject:[NSNumber numberWithInteger:interval] forKey:@"ReminderAt1"];
            NSDate * date = [NSDate date];
            int totalSeconds=[Utility secondsFromDate:date includeSeconds:YES];
            date=[date dateBySubtractingSeconds:totalSeconds];
            date=[date dateByAddingSeconds:interval];
            NSDateFormatter *df = [NSDateFormatter new];
            [df setDateFormat:@"hh:mm a"];//hh:mm a
            [reminderTimeButton setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
        } else if (senderButton == reminderAndTimeButton) {
            [resultDict setObject:[NSNumber numberWithInteger:interval] forKey:@"ReminderAt2"];
            NSDate * date = [NSDate date];
            int totalSeconds=[Utility secondsFromDate:date includeSeconds:YES];
            date=[date dateBySubtractingSeconds:totalSeconds];
            date=[date dateByAddingSeconds:interval];
            NSDateFormatter *df = [NSDateFormatter new];
            [df setDateFormat:@"hh:mm a"];//hh:mm a
            [reminderAndTimeButton setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
        }
    }
    
}

#pragma mark End




#pragma mark - Dropdown Delegate

-(void) dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{
    [sender setTitle:selectedValue forState:UIControlStateNormal];
    if (sender == frequencyButton) {
        daysView.hidden = YES;
        monthsView.hidden = YES;
        dayForMonthView.hidden = YES;
        if (_isFromHacker) {
             firstReminderView.hidden = YES;
        }
        else if ([frequencyButton.titleLabel.text isEqualToString:@"This time next year"]){
            firstReminderView.hidden = YES;
        }
        else{
            firstReminderView.hidden = NO;
        }
        
        if (_isFromHacker) {
            secondReminderView.hidden = YES;
        }else{
            NSString *middleButtonTitle = [reminderMiddleButton titleForState:UIControlStateNormal];
            if ([middleButtonTitle caseInsensitiveCompare:@"At"] == NSOrderedSame) {
                secondReminderView.hidden = YES;
            } else {
                secondReminderView.hidden = NO;
            }
        }
        if ([selectedValue caseInsensitiveCompare:@"Daily"] == NSOrderedSame) {
            //default
        } else if ([selectedValue caseInsensitiveCompare:@"Twice Daily"] == NSOrderedSame) {
            if (_isFromHacker) {
                 secondReminderView.hidden = YES;
            }else{
                secondReminderView.hidden = NO;
            }
        } else if ([selectedValue caseInsensitiveCompare:@"Weekly"] == NSOrderedSame) {
            daysView.hidden = NO;
        } else if ([selectedValue caseInsensitiveCompare:@"Fortnightly"] == NSOrderedSame) {
            daysView.hidden = NO;
        } else if ([selectedValue caseInsensitiveCompare:@"Monthly"] == NSOrderedSame) {
            dayForMonthView.hidden = NO;
        } else if ([selectedValue caseInsensitiveCompare:@"Yearly"] == NSOrderedSame) {
            monthsView.hidden = NO;
            dayForMonthView.hidden = NO;
        }
        [resultDict setObject:[NSNumber numberWithInteger:[frequencyArray indexOfObject:selectedValue]+1] forKey:@"FrequencyId"];
    } else if (sender == reminderMiddleButton) {
        if (_isFromHacker) {
           firstReminderView.hidden = YES;
        }else{
            firstReminderView.hidden = NO;
        }

        if (_isFromHacker) {
            secondReminderView.hidden = YES;
        }else{
            if ([selectedValue caseInsensitiveCompare:@"At"] == NSOrderedSame) {
                      secondReminderView.hidden = YES;
                  } else {
                      secondReminderView.hidden = NO;
                  }
        }
        [resultDict setObject:[NSNumber numberWithInteger:[reminderMiddleArray indexOfObject:selectedValue]+1] forKey:@"ReminderOption"];
    } else if (sender == reminderAndTimeButton) {
        [resultDict setObject:[NSNumber numberWithInteger:[reminderTimeArray indexOfObject:selectedValue]] forKey:@"ReminderAt2"];
    } else if (sender == reminderTimeButton) {
        [resultDict setObject:[NSNumber numberWithInteger:[reminderTimeArray indexOfObject:selectedValue]] forKey:@"ReminderAt1"];
    } else if (sender == daysForMonthButton) {
        [resultDict setObject:[NSNumber numberWithInteger:[dayForMonthArray indexOfObject:selectedValue]+1] forKey:@"MonthReminder"];
    }
}

#pragma mark - Local Notification (iOS 10+, UNUserNotificationCenter)
+ (BOOL) setLocalNotificationFromDictionary:(NSMutableDictionary *)notificationDict ExtraData:(NSMutableDictionary *)extraDict FromController:(NSString *)fromController Title:(NSString *)title Type:(NSString *)type Id:(NSInteger)eventID {   //ah ln
    __block BOOL isNotiCreated = NO;
    
    
    NSDateFormatter *nameDf = [[NSDateFormatter alloc] init];
    
    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
    
    int weekdayOrdinalNo = 1;
    __block int wOrdinal = 0;
    
    if ([[notificationDict objectForKey:@"FrequencyId"] intValue] == 3) {
        for (int i = 0; i < [nameDf weekdaySymbols].count; i++) {
            NSString *key = [[nameDf weekdaySymbols] objectAtIndex:i];
            if (![Utility isEmptyCheck:[notificationDict objectForKey:key]] && [[notificationDict objectForKey:key] boolValue]) {
                [nameArray addObject:[NSNumber numberWithInteger:i+1]];
            }
        }
    } else if ([[notificationDict objectForKey:@"FrequencyId"] intValue] == 4) {
        NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *todayDateComps = [gregorianCal components: (NSCalendarUnitWeekdayOrdinal) fromDate: [NSDate date]];
        if ([todayDateComps weekdayOrdinal] % 2 == 0) {
            weekdayOrdinalNo = 2;
            wOrdinal = 2;
        } else {
            weekdayOrdinalNo = 3;
            wOrdinal = 1;
        }
        
        for (int i = 0; i < [nameDf weekdaySymbols].count; i++) {
            NSString *key = [[nameDf weekdaySymbols] objectAtIndex:i];
            if (![Utility isEmptyCheck:[notificationDict objectForKey:key]] && [[notificationDict objectForKey:key] boolValue]) {
                [nameArray addObject:[NSNumber numberWithInteger:i+1]];
            }
        }
    } else if ([[notificationDict objectForKey:@"FrequencyId"] intValue] == 6) {
        for (int i = 0; i < [nameDf monthSymbols].count; i++) {
            NSString *key = [[nameDf monthSymbols] objectAtIndex:i];
            if (![Utility isEmptyCheck:[notificationDict objectForKey:key]] && [[notificationDict objectForKey:key] boolValue]) {
                [nameArray addObject:[NSNumber numberWithInteger:i+1]];
            }
        }
    } else if ([[notificationDict objectForKey:@"FrequencyId"] intValue] == 2) {
        for (int i = 0; i < 2; i++) {
            [nameArray addObject:[NSNumber numberWithInteger:i+1]];
        }
    } else {
        nameArray = nil;
    }
    
    
    
    center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        NSLog(@"req goal sn -> %@",requests);;
        
    }];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus != UNAuthorizationStatusAuthorized) {
            // Notifications not allowed
            UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
            [center requestAuthorizationWithOptions:options
                                  completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                      if (!granted) {
                                          NSLog(@"Something went wrong");
                                          isNotiCreated = NO;
                                      } else {
                                          for (int wo = 0; wo < weekdayOrdinalNo; wo++) {
                                              if ([[notificationDict objectForKey:@"ReminderOption"] intValue] == 3) {
                                                  //twice btw
                                                  if (![Utility isEmptyCheck:nameArray]) {
                                                      for (int i = 0; i < nameArray.count; i++) {
                                                          for (int t = 0; t < 2; t++) {
                                                              isNotiCreated = [self sendLocalNotificationFromDictionary:notificationDict ExtraData:(NSMutableDictionary *)extraDict Sequence:
                                                                               i NameArray:(NSMutableArray *)nameArray TwiceBtwSeq:t FromController:(NSString *)fromController Title:title WeekOrdinal:wOrdinal Type:(NSString *)type Id:(NSInteger)eventID];
                                                          }
                                                      }
                                                  } else {
                                                      for (int t = 0; t < 2; t++) {
                                                          isNotiCreated = [self sendLocalNotificationFromDictionary:notificationDict ExtraData:(NSMutableDictionary *)extraDict Sequence:0 NameArray:(NSMutableArray *)nil TwiceBtwSeq:t FromController:(NSString *)fromController Title:title WeekOrdinal:wOrdinal Type:(NSString *)type Id:(NSInteger)eventID ];
                                                      }
                                                  }
                                              } else if (![Utility isEmptyCheck:nameArray]) {
                                                  for (int i = 0; i < nameArray.count; i++) {
                                                      isNotiCreated = [self sendLocalNotificationFromDictionary:notificationDict ExtraData:(NSMutableDictionary *)extraDict Sequence:i NameArray:(NSMutableArray *)nameArray TwiceBtwSeq:0 FromController:(NSString *)fromController Title:title WeekOrdinal:wOrdinal Type:(NSString *)type Id:(NSInteger)eventID ];
                                                  }
                                              } else {
                                                  isNotiCreated = [self sendLocalNotificationFromDictionary:notificationDict ExtraData:(NSMutableDictionary *)extraDict Sequence:0 NameArray:(NSMutableArray *)nil TwiceBtwSeq:0 FromController:(NSString *)fromController Title:title WeekOrdinal:wOrdinal Type:(NSString *)type Id:(NSInteger)eventID ];
                                              }
                                              wOrdinal += 2;
                                          }
                                      }
                                  }];
        } else {
            for (int wo = 0; wo < weekdayOrdinalNo; wo++) {
                if ([[notificationDict objectForKey:@"ReminderOption"] intValue] == 3) {
                    //twice btw
                    if (![Utility isEmptyCheck:nameArray]) {
                        for (int i = 0; i < nameArray.count; i++) {
                            for (int t = 0; t < 2; t++) {
                                isNotiCreated = [self sendLocalNotificationFromDictionary:notificationDict ExtraData:(NSMutableDictionary *)extraDict Sequence:i NameArray:(NSMutableArray *)nameArray TwiceBtwSeq:t FromController:(NSString *)fromController Title:title WeekOrdinal:wOrdinal Type:(NSString *)type Id:(NSInteger)eventID ];
                            }
                        }
                    } else {
                        for (int t = 0; t < 2; t++) {
                            isNotiCreated = [self sendLocalNotificationFromDictionary:notificationDict ExtraData:(NSMutableDictionary *)extraDict Sequence:0 NameArray:(NSMutableArray *)nil TwiceBtwSeq:t FromController:(NSString *)fromController Title:title WeekOrdinal:wOrdinal Type:(NSString *)type Id:(NSInteger)eventID ];
                        }
                    }
                } else if (![Utility isEmptyCheck:nameArray]) {
                    for (int i = 0; i < nameArray.count; i++) {
                        isNotiCreated = [self sendLocalNotificationFromDictionary:notificationDict ExtraData:(NSMutableDictionary *)extraDict Sequence:i NameArray:(NSMutableArray *)nameArray TwiceBtwSeq:0 FromController:(NSString *)fromController Title:title WeekOrdinal:wOrdinal Type:(NSString *)type Id:(NSInteger)eventID ];
                    }
                } else {
                    isNotiCreated = [self sendLocalNotificationFromDictionary:notificationDict ExtraData:(NSMutableDictionary *)extraDict Sequence:0 NameArray:(NSMutableArray *)nil TwiceBtwSeq:0 FromController:(NSString *)fromController Title:title WeekOrdinal:wOrdinal Type:(NSString *)type Id:(NSInteger)eventID ];
                }
                wOrdinal += 2;
            }
        }
    }];
    
    
    return isNotiCreated;
}

+ (BOOL) sendLocalNotificationFromDictionary:(NSMutableDictionary *)notificationDict ExtraData:(NSMutableDictionary *)extraDict Sequence:(int)seqNo  NameArray:(NSMutableArray *)nameArray TwiceBtwSeq:(int)tbSeqNo FromController:(NSString *)fromController Title:(NSString *)title WeekOrdinal:(NSInteger)weekOrdinal Type:(NSString *)type Id:(NSInteger)eventID {      //ah ln
    __block BOOL isNotiCreated = NO;
    
    //    center.delegate = self;
    
    
    //for current date
    //    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //    NSDateComponents *todayDateComps = [gregorianCal components: (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate: [NSDate date]];
    //end f c d
    
    //set content
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = title;
    //    content.subtitle = @"Timed Notification";
    content.body = @"Check Now!";
    content.sound = [UNNotificationSound defaultSound];
    content.userInfo = @{@"pushTo" : fromController, @"data" : @"sample data", @"extraData": extraDict};
    content.categoryIdentifier = @"Squad";
    
    
    //set trigger
    NSInteger remHour = 0;
    NSInteger remHour1 = ![Utility isEmptyCheck:[notificationDict objectForKey:@"ReminderAt1"]] ? [[notificationDict objectForKey:@"ReminderAt1"] integerValue] : 12;
    NSInteger remHour2 = ![Utility isEmptyCheck:[notificationDict objectForKey:@"ReminderAt2"]] ? [[notificationDict objectForKey:@"ReminderAt2"] integerValue] : 12;
    NSInteger remMin = 0;
    
    switch ([[notificationDict objectForKey:@"ReminderOption"] intValue]) {
        case 0:
        case 1:
            //at
            remHour = remHour1;
            break;
            
        case 2:
            //between
            if (labs(remHour2 - remHour1) == 1) {
                remHour = remHour1;
                remMin = 30;
            } else {
                remHour = abs((int)(floor(remHour2 - remHour1))/2);
                CGFloat div = (remHour2 - remHour1)/2.0;
                CGFloat diff = fabs(div - remHour);
                remMin = diff*60;
            }
            break;
            
        case 3:
            //twice between
            if (tbSeqNo == 0) {
                remHour = remHour1;
            } else {
                remHour = remHour2;
            }
            break;
            
        default:
            break;
    }
    
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSCalendarUnit calUnit = NSCalendarUnitDay;
    
    switch ([[notificationDict objectForKey:@"FrequencyId"] intValue]) {
            
        case 1:
            //daily
            [components setHour: remHour];
            [components setMinute: remMin];
            [components setSecond: 00];
            calUnit = NSCalendarUnitDay;
            break;
            
        case 2:
            //twice daily
        {
            NSInteger remAt = 0;
            if (seqNo == 0) {
                if (![Utility isEmptyCheck:[notificationDict objectForKey:@"ReminderAt1"]]) {
                    remAt = [[notificationDict objectForKey:@"ReminderAt1"] integerValue];
                }
            } else {
                if (![Utility isEmptyCheck:[notificationDict objectForKey:@"ReminderAt2"]]) {
                    remAt = [[notificationDict objectForKey:@"ReminderAt2"] integerValue];
                }
            }
            
            [components setHour: remAt];
            [components setMinute: 00];
            [components setSecond: 00];
            calUnit = NSCalendarUnitDay;
        }
            break;
            
        case 3:
            //weekly
            [components setWeekday:![Utility isEmptyCheck:nameArray] ? [[nameArray objectAtIndex:seqNo] integerValue] : 0];
            [components setHour: remHour];
            [components setMinute: remMin];
            [components setSecond: 00];
            calUnit = NSCalendarUnitWeekday;
            break;
            
        case 4:
            //fortnightly
            [components setWeekday:![Utility isEmptyCheck:nameArray] ? [[nameArray objectAtIndex:seqNo] integerValue] : 0];
            [components setWeekdayOrdinal:weekOrdinal];//[todayDateComps weekdayOrdinal]
            [components setHour: remHour];
            [components setMinute: remMin];
            [components setSecond: 00];
            calUnit = NSCalendarUnitWeekdayOrdinal;
            break;
            
        case 5:
            //monthly
            [components setDay: [[notificationDict objectForKey:@"MonthReminder"] integerValue]];
            [components setHour: remHour];
            [components setMinute: remMin];
            [components setSecond: 00];
            calUnit = NSCalendarUnitMonth;
            break;
            
        case 6:
            //yearly
            [components setMonth: ![Utility isEmptyCheck:nameArray] ? [[nameArray objectAtIndex:seqNo] integerValue] : 0];
            
            [components setDay: [[notificationDict objectForKey:@"MonthReminder"] integerValue]];
            
            [components setHour: remHour];
            [components setMinute: remMin];
            [components setSecond: 00];
            calUnit = NSCalendarUnitYear;
            break;
            
        default:
            break;
    }
    
    NSDateComponents *triggerDateComponents = components;
    
    
    //    NSString *timestamp = [NSString stringWithFormat:@"%d",(int)[[NSDate date] timeIntervalSince1970]];
    NSString *identifier = [NSString stringWithFormat:@"Squad_%@_%ld_%d_%ld_%d",type,(long)eventID,seqNo,(long)weekOrdinal,tbSeqNo];
    
    
    //check if available
    /*__block BOOL shouldCreate = YES;
     UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
     [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
     for (UNNotificationRequest *req in requests) {
     NSLog(@"req id --> %@",req.identifier);
     if ([req.identifier caseInsensitiveCompare:identifier] == NSOrderedSame) {
     shouldCreate = NO;
     }
     }
     }];
     
     if (!shouldCreate) {
     return YES;
     }*/
    //end
    
    UNNotificationRequest *request = nil;
    
    //    if ([[notificationDict objectForKey:@"FrequencyId"] intValue] == 4) {
    //
    //        //fortnightly (start from specific day ?? )
    //        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:(14*24*3600) repeats: YES];
    //        NSLog(@"td %@", trigger.nextTriggerDate);
    //
    //        request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    //    } else {
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDateComponents repeats:calUnit];
    
    //Create the request
    request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    //    }
    
    //Schedule the request
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Something went wrong: %@",error);
            isNotiCreated = NO;
        } else {
            NSLog(@"Created! --> \n\n    %@\n\n",request);
            isNotiCreated = YES;
            
            /*NSMutableArray *remArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"ReminderDetailsArray"]];
             NSDictionary *remDict = @{
             @"type" : type,
             @"id" : [NSNumber numberWithInteger:eventID],
             @"seqNo" : [NSNumber numberWithInt:seqNo],
             @"weekOrdinal" : [NSNumber numberWithInteger:weekOrdinal],
             @"tbSeqNo" : [NSNumber numberWithInt:tbSeqNo]
             };
             [remArray removeObject:remDict];
             [remArray addObject:remDict];
             
             [defaults setObject:remArray forKey:@"ReminderDetailsArray"];
             [defaults synchronize];
             NSLog(@"def remArray -> %@",[defaults objectForKey:@"ReminderDetailsArray"]);*/
        }
    }];
    
    return isNotiCreated;
}

#pragma mark - Local Notification (less than iOS 10, UILocalNotification) 
//ah ln1
+ (BOOL) setOldLocalNotificationFromDictionary:(NSMutableDictionary *)notificationDict ExtraData:(NSMutableDictionary *)extraDict FromController:(NSString *)fromController Title:(NSString *)title Type:(NSString *)type Id:(NSInteger)eventID {
    BOOL isNotiCreated = NO;
    
    NSDateFormatter *nameDf = [[NSDateFormatter alloc] init];
    
    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
    
    int weekdayOrdinalNo = 1;
    __block int wOrdinal = 0;
    
    if ([[notificationDict objectForKey:@"FrequencyId"] intValue] == 3) {
        for (int i = 0; i < [nameDf weekdaySymbols].count; i++) {
            NSString *key = [[nameDf weekdaySymbols] objectAtIndex:i];
            if (![Utility isEmptyCheck:[notificationDict objectForKey:key]] && [[notificationDict objectForKey:key] boolValue]) {
                [nameArray addObject:[NSNumber numberWithInteger:i+1]];
            }
        }
    } else if ([[notificationDict objectForKey:@"FrequencyId"] intValue] == 4) {
        NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *todayDateComps = [gregorianCal components: (NSCalendarUnitWeekdayOrdinal) fromDate: [NSDate date]];
        if ([todayDateComps weekdayOrdinal] % 2 == 0) {
            weekdayOrdinalNo = 2;
            wOrdinal = 2;
        } else {
            weekdayOrdinalNo = 3;
            wOrdinal = 1;
        }
        
        for (int i = 0; i < [nameDf weekdaySymbols].count; i++) {
            NSString *key = [[nameDf weekdaySymbols] objectAtIndex:i];
            if (![Utility isEmptyCheck:[notificationDict objectForKey:key]] && [[notificationDict objectForKey:key] boolValue]) {
                [nameArray addObject:[NSNumber numberWithInteger:i+1]];
            }
        }
    } else if ([[notificationDict objectForKey:@"FrequencyId"] intValue] == 6) {
        for (int i = 0; i < [nameDf monthSymbols].count; i++) {
            NSString *key = [[nameDf monthSymbols] objectAtIndex:i];
            if (![Utility isEmptyCheck:[notificationDict objectForKey:key]] && [[notificationDict objectForKey:key] boolValue]) {
                [nameArray addObject:[NSNumber numberWithInteger:i+1]];
            }
        }
    } else if ([[notificationDict objectForKey:@"FrequencyId"] intValue] == 2) {
        for (int i = 0; i < 2; i++) {
            [nameArray addObject:[NSNumber numberWithInteger:i+1]];
        }
    } else {
        nameArray = nil;
    }
    
    for (int wo = 0; wo < weekdayOrdinalNo; wo++) {
        if ([[notificationDict objectForKey:@"ReminderOption"] intValue] == 3) {
            //twice btw
            if (![Utility isEmptyCheck:nameArray]) {
                for (int i = 0; i < nameArray.count; i++) {
                    for (int t = 0; t < 2; t++) {
                        isNotiCreated = [self sendOldLocalNotificationFromDictionary:notificationDict ExtraData:(NSMutableDictionary *)extraDict Sequence:
                                         i NameArray:(NSMutableArray *)nameArray TwiceBtwSeq:t FromController:(NSString *)fromController Title:title WeekOrdinal:wOrdinal Type:(NSString *)type Id:(NSInteger)eventID];
                    }
                }
            } else {
                for (int t = 0; t < 2; t++) {
                    isNotiCreated = [self sendOldLocalNotificationFromDictionary:notificationDict ExtraData:(NSMutableDictionary *)extraDict Sequence:0 NameArray:(NSMutableArray *)nil TwiceBtwSeq:t FromController:(NSString *)fromController Title:title WeekOrdinal:wOrdinal Type:(NSString *)type Id:(NSInteger)eventID ];
                }
            }
        } else if (![Utility isEmptyCheck:nameArray]) {
            for (int i = 0; i < nameArray.count; i++) {
                isNotiCreated = [self sendOldLocalNotificationFromDictionary:notificationDict ExtraData:(NSMutableDictionary *)extraDict Sequence:i NameArray:(NSMutableArray *)nameArray TwiceBtwSeq:0 FromController:(NSString *)fromController Title:title WeekOrdinal:wOrdinal Type:(NSString *)type Id:(NSInteger)eventID ];
            }
        } else {
            isNotiCreated = [self sendOldLocalNotificationFromDictionary:notificationDict ExtraData:(NSMutableDictionary *)extraDict Sequence:0 NameArray:(NSMutableArray *)nil TwiceBtwSeq:0 FromController:(NSString *)fromController Title:title WeekOrdinal:wOrdinal Type:(NSString *)type Id:(NSInteger)eventID ];
        }
        wOrdinal += 2;
    }
    
    return isNotiCreated;
}

+ (BOOL) sendOldLocalNotificationFromDictionary:(NSMutableDictionary *)notificationDict ExtraData:(NSMutableDictionary *)extraDict Sequence:(int)seqNo  NameArray:(NSMutableArray *)nameArray TwiceBtwSeq:(int)tbSeqNo FromController:(NSString *)fromController Title:(NSString *)title WeekOrdinal:(NSInteger)weekOrdinal Type:(NSString *)type Id:(NSInteger)eventID {
    
    //    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //    NSDateComponents *todayDateComps = [gregorianCal components: (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate: [NSDate date]];
    
    
    NSInteger remHour = 0;
    NSInteger remMin = 0;
    NSInteger remHour1 = 0;
    if (![Utility isEmptyCheck:[notificationDict objectForKey:@"ReminderAt1"]]) {
        int seconds =[[notificationDict objectForKey:@"ReminderAt1"]intValue];
        NSString *hourMinStr = [Utility timeFormatted:seconds];
        NSArray *arr = [hourMinStr componentsSeparatedByString:@":"];
        if (![Utility isEmptyCheck:arr] && arr.count>0) {
            remHour1 = [[arr objectAtIndex:0]intValue];
            remMin = [[arr objectAtIndex:1]intValue];
        }
    }else{
        remHour1 = 12;
    }
    NSInteger remHour2 =0;
    if (![Utility isEmptyCheck:[notificationDict objectForKey:@"ReminderAt2"]]) {
        int seconds = [[notificationDict objectForKey:@"ReminderAt2"]intValue];
        NSString *hourMinStr = [Utility timeFormatted:seconds];
        NSArray *arr = [hourMinStr componentsSeparatedByString:@":"];
        if (![Utility isEmptyCheck:arr] && arr.count>0) {
            remHour2 = [[arr objectAtIndex:0]intValue];
            remMin = [[arr objectAtIndex:1]intValue];
        }
    }else{
        remHour2 = 12;
    }
//    NSInteger remHour1 = ![Utility isEmptyCheck:[notificationDict objectForKey:@"ReminderAt1"]] ? [[notificationDict objectForKey:@"ReminderAt1"] integerValue] : 12;
//    NSInteger remHour2 = ![Utility isEmptyCheck:[notificationDict objectForKey:@"ReminderAt2"]] ? [[notificationDict objectForKey:@"ReminderAt2"] integerValue] : 12;
   
    
    switch ([[notificationDict objectForKey:@"ReminderOption"] intValue]) {
        case 0:
        case 1:
            //at
            remHour = remHour1;
            break;
            
        case 2:
            //between
            if (labs(remHour2 - remHour1) == 1) {
                remHour = remHour1;
                remMin = 30;
            } else {
                remHour = abs((int)(floor(remHour2 - remHour1))/2);
                CGFloat div = (remHour2 - remHour1)/2.0;
                CGFloat diff = fabs(div - remHour);
                remMin = diff*60;
                remHour = remHour1 + remHour;
            }
            break;
            
        case 3:
            //twice between
            if (tbSeqNo == 0) {
                remHour = remHour1;
            } else {
                remHour = remHour2;
            }
            break;
            
        default:
            break;
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone: [NSTimeZone systemTimeZone]];
    
    //(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute)
    
    NSDateComponents *components;// = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate: [NSDate date]];
    if ([fromController caseInsensitiveCompare:@"PersonalChallenge"] == NSOrderedSame) {
        NSDictionary *selectedChallangeDict = extraDict[@"selectedChallangeDict"];
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString *dateStr = selectedChallangeDict[@"CreatedAt"];
        components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate: [df dateFromString:dateStr]];
    }else{
        components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate: [NSDate date]];
    }
    NSCalendarUnit calUnit = NSCalendarUnitDay;
    
    switch ([[notificationDict objectForKey:@"FrequencyId"] intValue]) {
            
        case 1:
            //daily
            [components setHour: remHour];
            [components setMinute: remMin];
            [components setSecond: 00];
            calUnit = NSCalendarUnitDay;
            break;
            
        case 2:
            //twice daily
        {
            NSInteger remAt = 0;
            NSInteger remAtMin = 0;
            if (seqNo == 0) {
                if (![Utility isEmptyCheck:[notificationDict objectForKey:@"ReminderAt1"]]) {
                    int seconds =[[notificationDict objectForKey:@"ReminderAt1"] intValue];
                    NSString *hourMinStr = [Utility timeFormatted:seconds];
                    NSArray *arr = [hourMinStr componentsSeparatedByString:@":"];
                    if (![Utility isEmptyCheck:arr] && arr.count>0) {
                        remAt = [[arr objectAtIndex:0]intValue];
                        remAtMin = [[arr objectAtIndex:1]intValue];
                    }
                }
            } else {
                if (![Utility isEmptyCheck:[notificationDict objectForKey:@"ReminderAt2"]]) {
                    int seconds =[[notificationDict objectForKey:@"ReminderAt2"] intValue];
                    NSString *hourMinStr = [Utility timeFormatted:seconds];
                    NSArray *arr = [hourMinStr componentsSeparatedByString:@":"];
                    if (![Utility isEmptyCheck:arr] && arr.count>0) {
                        remAt = [[arr objectAtIndex:0]intValue];
                        remAtMin = [[arr objectAtIndex:1]intValue];
                    }
                }
            }
            
            [components setHour: remAt];
            [components setMinute: remAtMin];
            [components setSecond: 00];
            calUnit = NSCalendarUnitDay;
        }
            break;
            
        case 3:
            //weekly
        {
            NSInteger todayComp = [components weekday];
            NSInteger daysLeft = [[nameArray objectAtIndex:seqNo] integerValue] - todayComp;
            NSDate *toDate = [[NSDate date] dateByAddingTimeInterval:daysLeft*24*3600];
            NSDateComponents *toComp = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:toDate];
            
            [components setYear:[toComp year]];
            [components setMonth:[toComp month]];
            [components setDay:[toComp day]];
            [components setWeekday:![Utility isEmptyCheck:nameArray] ? [[nameArray objectAtIndex:seqNo] integerValue] : 0];
            [components setHour: remHour];
            [components setMinute: remMin];
            [components setSecond: 00];
            calUnit = NSCalendarUnitWeekOfYear;
        }
            break;
            
        case 4:
            //fortnightly
        {
            NSInteger todayComp = [components weekday];
            NSInteger todayWeekOrdinal = [components weekdayOrdinal];
            NSInteger daysLeft = [[nameArray objectAtIndex:seqNo] integerValue] - todayComp;
            NSInteger weeksLeft = weekOrdinal - todayWeekOrdinal;;
            daysLeft = daysLeft + weeksLeft * 7;
            NSDate *toDate = [[NSDate date] dateByAddingTimeInterval:daysLeft*24*3600];
            NSDateComponents *toComp = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:toDate];
            
            [components setYear:[toComp year]];
            [components setMonth:[toComp month]];
            [components setDay:[toComp day]];
            [components setWeekday:![Utility isEmptyCheck:nameArray] ? [[nameArray objectAtIndex:seqNo] integerValue] : 0];
            [components setWeekdayOrdinal:weekOrdinal];//[todayDateComps weekdayOrdinal]
            [components setHour: remHour];
            [components setMinute: remMin];
            [components setSecond: 00];
            calUnit = NSCalendarUnitMonth; //NSCalendarUnitWeekdayOrdinal;
        }
            break;
            
        case 5:
            //monthly
            [components setDay: [[notificationDict objectForKey:@"MonthReminder"] integerValue]];
            [components setHour: remHour];
            [components setMinute: remMin];
            [components setSecond: 00];
            calUnit = NSCalendarUnitMonth;
            break;
            
        case 6:
            //yearly
            [components setMonth: ![Utility isEmptyCheck:nameArray] ? [[nameArray objectAtIndex:seqNo] integerValue] : 0];
            
            [components setDay: [[notificationDict objectForKey:@"MonthReminder"] integerValue]];
            
            [components setHour: remHour];
            [components setMinute: remMin];
            [components setSecond: 00];
            calUnit = NSCalendarUnitYear;
            break;
            
        default:
            break;
    }
    
//    [components setMinute: [[NSDate date]minute]];
//    [components setSecond: [[NSDate date]second]+5];
    NSDate *dateToFire = [calendar dateFromComponents:components];
    NSLog(@"fire date:\n\n%@", dateToFire);
    
    int eventID1 = 0;
    NSDictionary *dict = [[NSDictionary alloc] init];
    NSString *alertBody = @"";
    
    if ([fromController caseInsensitiveCompare:@"Goal"] == NSOrderedSame) {
        NSDictionary* dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:[[extraDict objectForKey:@"selectedGoalDict"] objectForKey:@"id"],@"id", nil];
        eventID1 = [[[extraDict objectForKey:@"selectedGoalDict"] objectForKey:@"id"] intValue];
        
        NSMutableArray *valuesArr = [[NSMutableArray alloc] initWithArray:[extraDict objectForKey:@"valuesArray"]];
        for (int i = 0; i < valuesArr.count; i++) {
            NSMutableDictionary *dictV = [[NSMutableDictionary alloc] initWithDictionary:[valuesArr objectAtIndex:i]];
            [dictV setObject:@"" forKey:@"GoalValuesMaps"];
            [valuesArr removeObjectAtIndex:i];
            [valuesArr insertObject:dictV atIndex:i];
        }
        dict = [[NSDictionary alloc] initWithObjectsAndKeys:dict1, @"selectedGoalDict", valuesArr, @"valuesArray", nil];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *dueDateStr = [[extraDict objectForKey:@"selectedGoalDict"] objectForKey:@"DueDate"];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        NSDate *dueDate = [df dateFromString:dueDateStr];
        if ([Utility isEmptyCheck:dueDate]) {
            [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
            dueDate = [df dateFromString:dueDateStr];
        }
        if ([Utility isEmptyCheck:dueDate]) {
            [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            dueDate = [df dateFromString:dueDateStr];
        }
        if ([Utility isEmptyCheck:dueDate]) {
            [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZZ"];
            dueDate = [df dateFromString:dueDateStr];
        }
        [df setDateFormat:@"dd/MM/yyyy"];
        alertBody = [NSString stringWithFormat:@"#Squadgoals %@",[df stringFromDate:dueDate]];
        
    } else if ([fromController caseInsensitiveCompare:@"Action"] == NSOrderedSame) {
        NSDictionary* dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:[[extraDict objectForKey:@"selectedActionDict"] objectForKey:@"Id"],@"Id", nil];
        eventID1 = [[[extraDict objectForKey:@"selectedActionDict"] objectForKey:@"Id"] intValue];
        
        dict = [[NSDictionary alloc] initWithObjectsAndKeys:dict1, @"selectedActionDict", [extraDict objectForKey:@"GoalListArray"], @"GoalListArray", nil];
        
        alertBody = @"Chose your hard - You got this!";
        
    } else if ([fromController caseInsensitiveCompare:@"BucketList"] == NSOrderedSame) {
        dict = [[NSDictionary alloc] initWithObjectsAndKeys:[extraDict objectForKey:@"id"],@"id", nil];
        eventID1 = [[extraDict objectForKey:@"id"] intValue];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *dueDateStr = [extraDict objectForKey:@"CompletionDate"];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *dueDate = [df dateFromString:dueDateStr];
        if ([Utility isEmptyCheck:dueDate]) {
            [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
            dueDate = [df dateFromString:dueDateStr];
        }
        [df setDateFormat:@"dd/MM/yyyy"];
        alertBody = [NSString stringWithFormat:@"How cool will it be when you tick this off. %@",[df stringFromDate:dueDate]];
        
    } else if ([fromController caseInsensitiveCompare:@"Vision"] == NSOrderedSame) {
        dict = [[NSDictionary alloc] initWithDictionary:extraDict];
        alertBody = @"Click here to see your vision board, re-connect with your vision and set your intention. You are #unstoppable";
        
    } else if ([fromController caseInsensitiveCompare:@"Gratitude"] == NSOrderedSame) {
        dict = [[NSDictionary alloc] initWithDictionary:extraDict];
        eventID1 = [[extraDict objectForKey:@"Id"] intValue];
        
        alertBody = @"ahhhh Gratitude.. Doesn’t that feel good? Please make just one minute away from your busy, busy schedule to sit and appreciate how much this means to you";
    } else if ([fromController caseInsensitiveCompare:@"Achievement"] == NSOrderedSame) {
        dict = [[NSDictionary alloc] initWithDictionary:extraDict];
        eventID1 = [[extraDict objectForKey:@"Id"] intValue];
        
        alertBody = @"What an awesome achievement! Don’t dismiss it, don’t quickly ignore it.. Let yourself feel proud for at least a few seconds. You earned it";
    }
    //shabbir
    else if ([fromController caseInsensitiveCompare:@"PersonalChallenge"] == NSOrderedSame) {
        dict = [[NSDictionary alloc] initWithDictionary:extraDict];
        eventID1 = [[extraDict objectForKey:@"Id"] intValue];
        
        alertBody = @"Personal Challenge reminder";
    }
    else if(([fromController caseInsensitiveCompare:@"Vitamin"] == NSOrderedSame)){ //Vitamin
        dict = [[NSDictionary alloc] initWithDictionary:extraDict];
        eventID1 = [[extraDict objectForKey:@"Id"] intValue];
        alertBody = @"Vitamin reminder";
    }
    else if(([fromController caseInsensitiveCompare:@"HabitList"] == NSOrderedSame)){ //Vitamin
        dict = [[NSDictionary alloc] initWithDictionary:extraDict];
        eventID1 = [[extraDict objectForKey:@"Id"] intValue];
        alertBody = @"Habit reminder";
    }
    
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:fromController, @"pushTo", dict, @"extraData", @"reminder", @"remType", [NSNumber numberWithInt:eventID1], @"ID",nil];
    //extraDict, @"extraData",

    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = dateToFire;
    localNotification.alertTitle = title;//alertBody;
    localNotification.alertBody = alertBody;//title;
    localNotification.alertAction = @"Check Now";
    [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
    [localNotification setRepeatInterval: calUnit];
    //    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
//    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.soundName = @"Notification.caf";
    [localNotification setUserInfo:userInfo];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSLog(@"localNoti --> \n%@",localNotification);
    
    return YES;
}
//ahn
+ (BOOL) setNotificationAt:(NSDate *)fireDate FromController:(NSString *)fromController Id:(NSString *) remID Title:(NSString *) title Body:(NSString *) body {
    
    NSDictionary *userInfo;
    if ([fromController isEqualToString:@"QuoteController"]) {//Quote
        userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:fromController, @"pushTo", @"initialReminder", @"remType", remID, @"ID",body,@"quoteText",nil];
    }else{
        userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:fromController, @"pushTo", @"initialReminder", @"remType", remID, @"ID",nil];
    }
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.alertTitle = title;
    localNotification.alertBody = body;
    localNotification.alertAction = @"Check Now";
    [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
    //    [localNotification setRepeatInterval:];
    localNotification.soundName = @"Notification.caf";
    [localNotification setUserInfo:userInfo];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSLog(@"localNoti --> \n%@",localNotification);
    
    if ([fromController isEqualToString:@"QuoteController"]) {//Quote
        int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd
        NSString *personalDateStr = @"";
        NSString *addedDateStr = [formatter stringFromDate:fireDate];
        
        [formatter setDateFormat:@"MMM"];//yyyy-MM-dd
        NSString *addedMonthStr = [formatter stringFromDate:fireDate];
        
        if(![DBQuery isRowExist:@"quoteList" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and quoteList = '%@'",userId,body]]){
            [DBQuery addQuoteDetails:body addedDate:addedDateStr addedMonth:addedMonthStr personalAddDate:personalDateStr personalQuote:@"" favStatues:@"0"];
        }
    }
    
    return YES;
}
@end
