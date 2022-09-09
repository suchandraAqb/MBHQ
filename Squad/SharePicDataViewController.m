//
//  SharePicDataViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 03/08/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "SharePicDataViewController.h"

@interface SharePicDataViewController () {
    IBOutlet UILabel *leftWeightLabel;
    IBOutlet UILabel *rightWeightLabel;
    IBOutlet UITextField *leftWeightTextField;
    IBOutlet UITextField *rightWeightTextField;
    IBOutlet UIButton *leftDateButton;
    IBOutlet UIButton *rightDateButton;
    IBOutlet UIScrollView *mainScroll;
    
    UIButton *activeButton;
    NSDate *leftDate;
    NSDate *rightDate;
    UITextField *activeTextField;
    UIToolbar* numberToolbar;
}

@end

@implementation SharePicDataViewController
//ah ph 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerForKeyboardNotifications];
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(doneWithFirstResponder)],nil];
    [numberToolbar sizeToFit];
    leftWeightTextField.inputAccessoryView = numberToolbar;
    rightWeightTextField.inputAccessoryView = numberToolbar;
    
    leftDate = rightDate = [NSDate date];
    
    leftWeightTextField.text = ![Utility isEmptyCheck:_prevLeftWeight] ? _prevLeftWeight : @"";
    rightWeightTextField.text = ![Utility isEmptyCheck:_prevRightWeight] ? _prevRightWeight : @"";
    [leftDateButton setTitle:![Utility isEmptyCheck:_prevLeftDate] ? _prevLeftDate : @"" forState:UIControlStateNormal];
    [rightDateButton setTitle:![Utility isEmptyCheck:_prevRightDate] ? _prevRightDate : @"" forState:UIControlStateNormal];
    
    
    if ([[defaults objectForKey:@"UnitPreference"] intValue] == 0 || [[defaults objectForKey:@"UnitPreference"] intValue] == 1) {
        leftWeightLabel.text = @"WEIGHT (kg):";
        rightWeightLabel.text = @"WEIGHT (kg):";
    }else{
        leftWeightLabel.text = @"WEIGHT (lb):";
        rightWeightLabel.text = @"WEIGHT (lb):";
    }//AY 02042018
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}
- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)dropDownButtonTapped:(UIButton *)sender {
    if (activeTextField) {
        [activeTextField resignFirstResponder];
    }
    activeButton = sender;
    
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.selectedDate = (sender == leftDateButton) ? leftDate : rightDate;
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    controller.maxDate = [NSDate date];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)saveButtonTapped:(id)sender {
    NSString *leftWeight =@"";
     NSString *rightWeight =@"";
    
    if ([[defaults objectForKey:@"UnitPreference"] intValue] == 0 || [[defaults objectForKey:@"UnitPreference"] intValue] == 1) {
        leftWeight = [@"" stringByAppendingFormat:@"%@ kg",leftWeightTextField.text];
        rightWeight =[@"" stringByAppendingFormat:@"%@ kg",rightWeightTextField.text];
    }else{
        leftWeight = [@"" stringByAppendingFormat:@"%@ lb",leftWeightTextField.text];
        rightWeight =[@"" stringByAppendingFormat:@"%@ lb",rightWeightTextField.text];
    }//AY 02042018
    
    
    [_picDataDelegate getPicDataLeftWeight:leftWeight RightWeight:rightWeight LeftDate:[leftDateButton titleForState:UIControlStateNormal] RightDate:[rightDateButton titleForState:UIControlStateNormal]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods
-(void)doneWithFirstResponder{
    [self.view endEditing:YES];
}
#pragma  mark - DatePickerViewControllerDelegate

-(void)didSelectDate:(NSDate *)date{    
    if (date) {
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
//        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        if (activeButton == leftDateButton) {
            leftDate = date;
        } else {
            rightDate = date;
        }
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        [activeButton setTitle:dateString forState:UIControlStateNormal];

//        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZZ"];
//        NSString *currentDateStr = [dateFormatter stringFromDate:date];
//        [resultDict setObject:currentDateStr forKey:@"DueDate"];
    }
}

#pragma mark - KeyboardNotifications -
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSInteger orientation=[UIDevice currentDevice].orientation;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        //ios7
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            kbSize=CGSizeMake(kbSize.height, kbSize.width);
        }else if (UIDeviceOrientationIsPortrait(orientation)){
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }
    }
    else {
        //iOS 8 specific code here
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }else if (UIDeviceOrientationIsPortrait(orientation)){
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }
    }
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
    if (activeTextField !=nil) {
        CGRect aRect = mainScroll.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            [mainScroll scrollRectToVisible:activeTextField.frame animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
}
#pragma mark - End -

#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [activeTextField resignFirstResponder];
    activeTextField = nil;
}
@end
