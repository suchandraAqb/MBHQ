//
//  AdvanceSearchForCircuitListViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 13/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AdvanceSearchForCircuitListViewController.h"

@interface AdvanceSearchForCircuitListViewController (){
    NSMutableDictionary *filterDictionary;
    NSArray *tagArray;
    UITextField *activeTextField;
    
    
    
    IBOutlet UIScrollView *scroll;
    IBOutlet UITextField *searchByCircuitNameTextField;
    IBOutlet UIButton *includeTagsButton;
    IBOutlet UIButton *excludeTagsButton;
    IBOutlet UIButton *withEquipmentOrBodyWeightRadioButton;
    IBOutlet UIButton *withEquipmentRadioButton;
    IBOutlet UIButton *bodyWeightOnlyRadioButton;
    IBOutlet UIButton *coreCheckButton;
    IBOutlet UIButton *fullBodyCheckButton;
    IBOutlet UIButton *upperBodyCheckButton;
    IBOutlet UIButton *lowerBodyCheckButton;
    
    
    
    
}


@end

@implementation AdvanceSearchForCircuitListViewController
@synthesize delegate;

#pragma -mark ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    [filterDictionary setObject:@"" forKey:@"CircuitName"];
    
    NSArray *unSortedArray = [NSJSONSerialization JSONObjectWithData:[jsonTags dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    tagArray = [unSortedArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    filterDictionary = [[NSMutableDictionary alloc]init];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, searchByCircuitNameTextField.frame.size.height)];
    searchByCircuitNameTextField.leftView = paddingView;
    searchByCircuitNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    withEquipmentOrBodyWeightRadioButton.selected =true;
    withEquipmentRadioButton.selected =false;
    bodyWeightOnlyRadioButton.selected =false;
    coreCheckButton.selected =true;
    fullBodyCheckButton.selected =true;
    upperBodyCheckButton.selected =true;
    lowerBodyCheckButton.selected =true;
    
    [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Core"];
    [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Fullbody"];
    [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Upperbody"];
    [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Lowerbody"];
    [filterDictionary removeObjectForKey:@"EquipmentRequired"];
    
}
#pragma -mark End


#pragma -mark IBAction


- (IBAction)searchByTagButtonPressed:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = tagArray;
        controller.selectedIndex = -1;
        controller.mainKey = nil;
        controller.apiType = nil;
        controller.delegate = self;
        controller.sender = sender;
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSArray *titleArray = [sender.titleLabel.text componentsSeparatedByString:@", "];
        for (int i =0;i<titleArray.count;i++) {
            NSString *title = [titleArray objectAtIndex:i];
            if ([tagArray containsObject:title]) {
                [array addObject:[NSNumber numberWithInteger:[tagArray indexOfObject:title]]];
            }
        }
        
        controller.multiSelect = true;
        controller.selectedIndexes=array;
        [self presentViewController:controller animated:YES completion:nil];
    });
    
}
- (IBAction)radioButtonPressed:(UIButton *)sender {
    
    if ([sender isEqual:withEquipmentOrBodyWeightRadioButton]) {
        withEquipmentOrBodyWeightRadioButton.selected = true;
        withEquipmentRadioButton.selected = false;
        bodyWeightOnlyRadioButton.selected = false;
        [filterDictionary removeObjectForKey:@"EquipmentRequired"];
    }else if([sender isEqual:withEquipmentRadioButton]){
        withEquipmentOrBodyWeightRadioButton.selected = false;
        withEquipmentRadioButton.selected = true;
        bodyWeightOnlyRadioButton.selected = false;
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"EquipmentRequired"];
    }else if([sender isEqual:bodyWeightOnlyRadioButton]){
        withEquipmentOrBodyWeightRadioButton.selected = false;
        withEquipmentRadioButton.selected = false;
        bodyWeightOnlyRadioButton.selected = true;
        [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"EquipmentRequired"];
    }else{
        withEquipmentOrBodyWeightRadioButton.selected = false;
        withEquipmentRadioButton.selected = false;
        bodyWeightOnlyRadioButton.selected = false;
        [filterDictionary removeObjectForKey:@"EquipmentRequired"];
        
    }
}
- (IBAction)coreCheckButtonPressed:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = false;
        [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"Core"];
    }else{
        sender.selected = true;
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Core"];
    }
    
}
- (IBAction)fullBodyCheckButtonPressed:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = false;
        [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"Fullbody"];
    }else{
        sender.selected = true;
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Fullbody"];
    }
}
- (IBAction)upperBodyCheckButtonPressed:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = false;
        [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"Upperbody"];
    }else{
        sender.selected = true;
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Upperbody"];
    }
}
- (IBAction)lowerBodyCheckButtonPressed:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = false;
        [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"Lowerbody"];
    }else{
        sender.selected = true;
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Lowerbody"];
    }
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)applyButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([delegate respondsToSelector:@selector(applyForCircuitFilter:)]) {
            [delegate applyForCircuitFilter:filterDictionary];
        }
    }];
}
#pragma -mark End
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
    scroll.contentInset = contentInsets;
    scroll.scrollIndicatorInsets = contentInsets;
    
    if (activeTextField !=nil) {
        CGRect aRect = scroll.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            [scroll scrollRectToVisible:activeTextField.frame animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scroll.contentInset = contentInsets;
    scroll.scrollIndicatorInsets = contentInsets;
    
}
#pragma mark - End -
#pragma -mark DropDownViewDelegate
-(void)dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{
    if(![Utility isEmptyCheck:selectedValue]){
        [sender setTitle:selectedValue forState:UIControlStateNormal];
        if ([sender isEqual:includeTagsButton]) {
            [filterDictionary setObject:[selectedValue componentsSeparatedByString:@", "] forKey:@"IncludeExerciseTags"];
        }else if ([sender isEqual:excludeTagsButton]) {
            [filterDictionary setObject:[selectedValue componentsSeparatedByString:@", "] forKey:@"ExcludeExerciseTags"];
        }
    }else{
        [sender setTitle:@"" forState:UIControlStateNormal];
        if ([sender isEqual:includeTagsButton]) {
            [filterDictionary removeObjectForKey:@"IncludeExerciseTags"];
        }else if ([sender isEqual:excludeTagsButton]) {
            [filterDictionary removeObjectForKey:@"ExcludeExerciseTags"];
        }
    }
    
}
#pragma -mark End
#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    /*if (textField == searchByCircuitNameTextField) {
     [textField resignFirstResponder];
     NSString *searchString = textField.text;
     textField.text = @"";
     NSLog(@"%@",searchString);
     
     return NO;
     }*/
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
    [textField resignFirstResponder];
    NSString *searchString = textField.text;
    
    if (![Utility isEmptyCheck:searchString]) {
        [filterDictionary setObject:searchString forKey:@"CircuitName"];
    }else{
        [filterDictionary setObject:@"" forKey:@"CircuitName"];
    }
    
}
#pragma -mark End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
