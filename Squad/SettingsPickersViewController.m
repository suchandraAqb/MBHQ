//
//  SettingsPickersViewController.m
//  Ashy Bines Super Circuit
//
//  Created by AQB SOLUTIONS on 01/11/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "SettingsPickersViewController.h"

@interface SettingsPickersViewController () {
    IBOutlet UIPickerView *timePicker;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *doneButton;
    IBOutlet UIButton *cancelButton;
    NSString *selectedValue;
}

@end

@implementation SettingsPickersViewController
@synthesize pickerArray,selectRow,key;
#pragma mark - ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    titleLabel.text = [_titleName uppercaseString];
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:30];
    
    doneButton.layer.cornerRadius = 15;
    doneButton.layer.masksToBounds = YES;
    
    cancelButton.layer.cornerRadius = 15;
    cancelButton.layer.masksToBounds = YES;
    
    timePicker.layer.cornerRadius = 15;
    timePicker.layer.masksToBounds = YES;

}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [timePicker selectRow:selectRow inComponent:0 animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IBAction
-(IBAction)backTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)doneTapped:(id)sender {
    NSInteger selectedRow = [timePicker selectedRowInComponent:0];
    selectedValue = [pickerArray objectAtIndex:selectedRow];
    [_settingsCustomPickerDelegate updateSettingsCustomPickerValue:key withValue:selectedValue];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UIPicker Delegate & DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickerArray.count;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    //    UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 50.0, 20.0)] ;
    //    [label setBackgroundColor:[UIColor clearColor]];
    //    [label setTextColor:[UIColor blueColor]];
    //    [label setFont:[UIFont boldSystemFontOfSize:20.0]];
    //    [label setText:[timerArray objectAtIndex:row]];
    //    return label;
    
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, timePicker.frame.size.width, 50.0)];
        [tView setFont:[UIFont fontWithName:@"Raleway-Semibold" size:30]];
        [tView setTextColor:[Utility colorWithHexString:mbhqBaseColor]]; ; //[UIColor whiteColor] //AY 05012018
        [tView setTextAlignment:NSTextAlignmentCenter];
        tView.numberOfLines=3;
    }
    // Fill the label text here
    tView.text=[[pickerArray objectAtIndex:row] uppercaseString];
    return tView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50.0;
}

@end
