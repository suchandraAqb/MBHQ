//
//  DatePickerViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 07/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController (){
    IBOutlet UIDatePicker *picker;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *doneButton;
    IBOutlet UIButton *noSetTimeButton;
}

@end

@implementation DatePickerViewController
@synthesize delegate,datePickerMode,selectedDate,maxDate,minDate,dateType,senderButton;
#pragma mark - IBAction

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (!self->_isfromhabit) {
            if ([self->delegate respondsToSelector:@selector(didSelectDate:)]) {
                [self->delegate didSelectDate:self->picker.date];
                   }
        }else{
            if ([self->delegate respondsToSelector:@selector(didSelectSeconds:with:)]) {
                [self->delegate didSelectSeconds:self->picker.countDownDuration with:self->picker.date];
                   }
        }
        if ([self->delegate respondsToSelector:@selector(didSelectDate:withSenderObject:)]) {
            [self->delegate didSelectDate:self->picker.date withSenderObject:self->_sender];
        }
        if ([self->delegate respondsToSelector:@selector(didSelectDate:dateType:)]) {
            [self->delegate didSelectDate:self->picker.date dateType:self->dateType];
        }
        
        if ([self->delegate respondsToSelector:@selector(didSelectDate:withSenderButton:)]) {
            [self->delegate didSelectDate:self->picker.date withSenderButton:self->senderButton];
        }
        
    }];
}
- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)noSetTimeButtonPressed:(id)sender{
     [self dismissViewControllerAnimated:YES completion:^{
            if ([self->delegate respondsToSelector:@selector(didSelectSeconds:with:)]) {
                int timeValue = 0;
                [self->delegate didSelectSeconds:timeValue with:nil];
               }
         }];
}
#pragma  -mark End

- (void)viewDidLoad {
    [super viewDidLoad];
    doneButton.layer.cornerRadius = 4;
    doneButton.clipsToBounds = YES;
    cancelButton.layer.cornerRadius = 4;
    cancelButton.clipsToBounds = YES;
    picker.layer.cornerRadius = 4;
    picker.clipsToBounds = YES;
    picker.backgroundColor = [UIColor whiteColor];
    if (maxDate)
        picker.maximumDate = maxDate;
    if (minDate)
        picker.minimumDate = minDate;
    
    if (!selectedDate) {
        picker.date = [NSDate date];
    }else{
        picker.date = selectedDate;
    }
    if (_isfromhabit) {
        noSetTimeButton.hidden = false;
    }else{
        noSetTimeButton.hidden = true;
    }
    picker.datePickerMode = datePickerMode;
    if (@available(iOS 13.4, *)) {
        picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        picker.backgroundColor=UIColor.whiteColor;
    } else {
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
