//
//  AddDetailsViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 21/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AddDetailsViewController.h"
#import "MasterMenuViewController.h"
#define  AllFields @[@"BodyWeight",@"BodyFatPercentage",@"BodyFatKgs",@"MuscleKg",@"Chest",@"Stomach",@"Hips",@"Leg",@"Arm",@"Total",@"Brand",@"PantSize",@"Feel"]

@interface AddDetailsViewController ()
{
    IBOutlet UILabel *addEditHeader;
    IBOutlet UIScrollView *mainscroll;
    IBOutlet UILabel *resultTypeLabel;
    IBOutlet UIView *dateContainerView;
    IBOutlet UIButton *dateAddedButton;
    IBOutlet UIStackView *containerStackView;
    IBOutletCollection(UIView) NSArray *container;
    IBOutletCollection(UITextField) NSArray *textFieldCollection;
    IBOutlet UIButton *feelButton;
    UIToolbar *toolBar;


    
    NSDictionary *keyFieldDict;
    NSDate *selectedDate;
    NSDictionary *selectedSizeDict;
    UITextField *activeTextField;
    UIView *contentView;
    
     IBOutletCollection(UILabel) NSArray *weightNmeasurementLabelArray;
    
}
@end

@implementation AddDetailsViewController
@synthesize selectedFields,type,dataDict,prevWeight;

#pragma mark - IBAction
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
- (IBAction)save:(id)sender {
    [self saveData];
}
- (IBAction)howDoTheyFeelButton:(id)sender {
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = feelTypeArray;
    controller.mainKey = @"value";
    controller.apiType = type;
    if (![Utility isEmptyCheck:selectedSizeDict]) {
        controller.selectedIndex = (int)[feelTypeArray indexOfObject:selectedSizeDict];
    }else{
        controller.selectedIndex =0;
    }
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)dateAddedButtonPressed:(UIButton *)sender {
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.maxDate = [NSDate date];
    //NSTimeInterval sixmonth = -6*30*24*60*60;
//    controller.minDate = [[NSDate date]
//                                 dateByAddingTimeInterval:sixmonth];
    controller.selectedDate = selectedDate;
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}

- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - End

#pragma mark - PrivateMethod
-(void)updateTotalTextField{
    
    if ([type isEqualToString:@"Body Measurement Composition"] && ![Utility isEmptyCheck:keyFieldDict]) {
        
        
            NSArray *allKeys =[keyFieldDict allKeys];
            float totalValue = 0.0;
        
            for (int i = 0; i< allKeys.count; i++) {
                
                if(![allKeys[i] isEqualToString:@"Total"]){
                    NSLog(@"%lu",(unsigned long)[AllFields indexOfObject:allKeys[i]]);
                    UITextField *textField =textFieldCollection[[AllFields indexOfObject:allKeys[i]]];
                    if (textField) {
                        totalValue += [textField.text floatValue];
                    }
                }
            }
        
        if(totalValue>0){
            UITextField *textField =textFieldCollection[[AllFields indexOfObject:@"Total"]];
            if (textField) {
                textField.text = [@"" stringByAppendingFormat:@"%.2f",totalValue];
            }
        }
        
    }
    
}//AY 04042018

-(void) saveData {
    [self.view endEditing:true];
    if (Utility.reachable) {
        if (![Utility isEmptyCheck:keyFieldDict]) {
            if (selectedDate) {
                static NSDateFormatter *dateFormatter;
                dateFormatter = [NSDateFormatter new];
                
                //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString = [dateFormatter stringFromDate:selectedDate];
                if ([type isEqualToString:@"Body Measurement Composition"]) {
                    [dataDict setObject:dateString forKey:@"DateAddedMeasurement"];
                }else
                    [dataDict setObject:dateString forKey:@"DateAdded"];

                if ([type isEqualToString:@"Body Weight Composition"]) {
                    [dataDict setObject:dateString forKey:@"DateAdded"];
                }else if ([type isEqualToString:@"Body Measurement Composition"]) {
                    [dataDict setObject:dateString forKey:@"DateAddedMeasurement"];
                }else if ([type isEqualToString:@"Refrence Top"]) {
                    [dataDict setObject:dateString forKey:@"DateAddedTop"];
                }else if ([type isEqualToString:@"Refrence Pant Composition"]) {
                    [dataDict setObject:dateString forKey:@"DateAddedPant"];
                }

            }else{
                [Utility msg:@"Please select a valid date." title:@"Oops" controller:self haveToPop:NO];
                return;
  
            }
            
            NSArray *allKeys =[keyFieldDict allKeys];
            for (int i = 0; i< allKeys.count; i++) {
                if([allKeys[i] isEqualToString:@"Feel"] && feelTypeArray.count > 0){
                    if (![Utility isEmptyCheck:selectedSizeDict]) {
                        [dataDict setObject:selectedSizeDict[@"key"] forKey:allKeys[i]];
                    }
                }else{
                    UITextField *textField =textFieldCollection[[AllFields indexOfObject:allKeys[i]]];
                    if (textField) {
                        if ([allKeys[i] isEqualToString:@"Brand"] || [allKeys[i] isEqualToString:@"PantSize"]) {
                            [dataDict setObject:textField.text forKey:allKeys[i]];
                        }else{
                            NSString *s=textField.text;
                            [dataDict setObject:[NSNumber numberWithDouble:s.doubleValue] forKey:allKeys[i]];
                        }
                    }
                }
                
            }
            
            if ([type isEqualToString:@"Body Weight Composition"] || [type isEqualToString:@"Body Measurement Composition"]) {
                for (int i = 0; i< allKeys.count; i++) {
                    bool check = true;
                    if(![Utility isEmptyCheck:dataDict[allKeys[i]]] && [dataDict[allKeys[i]] intValue] >= 0){
                        check = false;
                    }
                    if (check) {
                        [Utility msg:@"Please provide at least one value" title:@"Oops" controller:self haveToPop:NO];
                        return;
                    }
                }
                if ([Utility isEmptyCheck:dataDict[@"BodyCompositionId"]]) {
                    [dataDict setObject:[NSNumber numberWithInt:-1] forKey:@"BodyCompositionId"];
                }
            }else if ([type isEqualToString:@"Refrence Top"] || [type isEqualToString:@"Refrence Pant Composition"]) {
                for (int i = 0; i< allKeys.count; i++) {
                    bool check = true;
                    if(![Utility isEmptyCheck:dataDict[allKeys[i]]]){
                        check = false;
                    }
                    if (check) {
                        [Utility msg:@"Please provide at least one value" title:@"Oops" controller:self haveToPop:NO];
                        return;
                    }
                }
                if ([Utility isEmptyCheck:dataDict[@"ReferenceClothDataId"]]) {
                    [dataDict setObject:[NSNumber numberWithInt:-1] forKey:@"ReferenceClothDataId"];
                }
            }
            
            
            NSError *error;
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            [mainDict setObject:AccessKey forKey:@"Key"];
            [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
            [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
            [mainDict setObject:[defaults objectForKey:@"UnitPreference"] forKey:@"UnitPreference"];

            NSString *api = @"";
            if ([type isEqualToString:@"Body Weight Composition"]) {
                api = @"SaveBodyWeight";
                [mainDict setObject:dataDict forKey:@"BodyCompostionData"];

            }else if ([type isEqualToString:@"Body Measurement Composition"]) {
                api = @"SaveBodyMeasurements";
                [mainDict setObject:dataDict forKey:@"BodyCompostionData"];

            }else if ([type isEqualToString:@"Refrence Top"]) {
                api = @"SaveBodyRefrenceTop";
                [dataDict setObject:[NSNumber numberWithInt:1] forKey:@"ReferenceClothTypeId"];
                [mainDict setObject:dataDict forKey:@"BodyRefrenceData"];
            }else if ([type isEqualToString:@"Refrence Pant Composition"]) {
                api = @"SaveBodyRefrencePant";
                [dataDict setObject:[NSNumber numberWithInt:2] forKey:@"ReferenceClothTypeId"];
                [mainDict setObject:dataDict forKey:@"BodyRefrenceData"];

            }
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                if (contentView) {
                    [contentView removeFromSuperview];
                }
                contentView = [Utility activityIndicatorView:self];
            });
            
            NSURLSession *achieveSession = [NSURLSession sharedSession];
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:api append:@"" forAction:@"POST"];
            
            NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                   dispatch_async(dispatch_get_main_queue(),^ {
                                                                       if (contentView) {
                                                                           [contentView removeFromSuperview];
                                                                       }
                                                                       if(error == nil)
                                                                       {
                                                                           NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                           NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                           if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                               [Utility msg:@"Saved Successfully. " title:@"Success !" controller:self haveToPop:YES];
                                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
                                                                               
                                                                               if ([NSNumber numberWithDouble:prevWeight] != nil && ![Utility isEmptyCheck:[dataDict objectForKey:@"BodyWeight"]]) {
                                                                                   if ([[dataDict objectForKey:@"BodyWeight"]doubleValue]<prevWeight) {
                                                                                       
                                                                                   }
                                                                               }
                                                                               
                                                                           }else{
                                                                               [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                               return;
                                                                           }
                                                                           
                                                                       }else{
                                                                           [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                       }
                                                                   });
                                                               }];
            [dataTask resume];

            
            

        }else{
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }


        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
#pragma mark - End

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    keyFieldDict = [[NSMutableDictionary alloc]init];
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [self registerForKeyboardNotifications];
    for (int i=0; i < container.count; i++) {
        UIView *containerView = container[i];
        if ([selectedFields containsObject:AllFields[i]]) {
            containerView.hidden= false;
            [keyFieldDict setValue:container[i] forKey:AllFields[i]];
        }else{
            containerView.hidden= true;
            [containerStackView removeArrangedSubview:containerView];
            [containerView removeFromSuperview];
        }
    }
    resultTypeLabel.text = [type stringByAppendingString:@" : "];
    static NSDateFormatter *dateFormatter;
    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    if (![Utility isEmptyCheck:dataDict]) {
        if (![Utility isEmptyCheck:[dataDict objectForKey:@"DateAdded"]]) {
            NSDate *date = [dateFormatter dateFromString:[dataDict objectForKey:@"DateAdded"]];
            selectedDate = date;
            [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
            NSString *mdateString = [dateFormatter stringFromDate:date];
            [dateAddedButton setTitle:mdateString forState:UIControlStateNormal];
        }
        addEditHeader.text = @"Edit Details";
        if (![Utility isEmptyCheck:keyFieldDict]) {
            NSArray *allKeys =[keyFieldDict allKeys];
            for (int i = 0; i< allKeys.count; i++) {
                if([allKeys[i] isEqualToString:@"Feel"] && feelTypeArray.count > 0){
                    if (![Utility isEmptyCheck:dataDict[@"Feel"]]) {
                        NSDictionary *selectedDict = [Utility getDictByValue:feelTypeArray value:dataDict[@"Feel"] type:@"key"];
                        selectedSizeDict = selectedDict;
                    }else{
                        NSDictionary *selectedDict = feelTypeArray[0];
                        selectedSizeDict = selectedDict;
                    }
                    [feelButton setTitle:selectedSizeDict[@"value"] forState:UIControlStateNormal];
                }else{
                    NSLog(@"%lu",(unsigned long)[AllFields indexOfObject:allKeys[i]]);
                    UITextField *textField =textFieldCollection[[AllFields indexOfObject:allKeys[i]]];
                    if (textField && ![Utility isEmptyCheck:dataDict[allKeys[i]]]) {
                        textField.text = [@"" stringByAppendingFormat:@"%@",dataDict[allKeys[i]]];
                    }
                    
                    if ([type isEqualToString:@"Body Measurement Composition"] && [allKeys[i] isEqualToString:@"Total"]) {
                        UITextField *textField =textFieldCollection[[AllFields indexOfObject:allKeys[i]]];
                        if (textField){
                            textField.enabled = false;
                        }
                    }//AY 04042018
                }
                
            }
        }
    }else{
        addEditHeader.text = @"Add Details";
        dataDict = [[NSMutableDictionary alloc]init];
        NSDate *date = [NSDate date];
        selectedDate = date;
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        NSString *mdateString = [dateFormatter stringFromDate:date];
        [dateAddedButton setTitle:mdateString forState:UIControlStateNormal];
        if (feelTypeArray.count > 0) {
            NSDictionary *selectedDict = feelTypeArray[0];
            selectedSizeDict = selectedDict;
            [feelButton setTitle:selectedSizeDict[@"value"] forState:UIControlStateNormal];
        }
    }
    
    
    int unitPrefererence = [[defaults objectForKey:@"UnitPreference"] intValue];
    
    for(UILabel *label in weightNmeasurementLabelArray){
        
        
        if(unitPrefererence == 0 || unitPrefererence == 1){
            // Tag 1: Weight Tag 2:Measurements
            if(label.tag == 1){
                label.text = @"kg";
            }else{
                label.text = @"cm";
            }
            
        }else {
            // Tag 1: Weight Tag 2:Measurements
            if(label.tag == 1){
                label.text = @"lb";
            }else{
                label.text = @"inches";
            }
        }
        
    }//AY 04042018

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - End
#pragma  mark -DatePickerViewControllerDelegate
-(void)didSelectDate:(NSDate *)date{
    NSLog(@"%@\n%@",date,[defaults objectForKey:@"Timezone"]);
    if (date) {
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
        
        //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        selectedDate = date;
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        [dateAddedButton setTitle:dateString forState:UIControlStateNormal];
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
    mainscroll.contentInset = contentInsets;
    mainscroll.scrollIndicatorInsets = contentInsets;
    
    if (activeTextField !=nil) {
        CGRect aRect = mainscroll.frame;
        CGRect frame = [mainscroll convertRect:activeTextField.frame fromView:activeTextField.superview];
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect,frame.origin) ) {
            [mainscroll scrollRectToVisible:frame animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainscroll.contentInset = contentInsets;
    mainscroll.scrollIndicatorInsets = contentInsets;
    
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
    [textField setInputAccessoryView:toolBar];
    activeTextField = textField;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
    [self updateTotalTextField];//AY 04042018
}
#pragma mark - End

- (void) didSelectAnyDropdownOption:(NSString *)type1 data:(NSDictionary *)selectedData{
    
    if ([type1 caseInsensitiveCompare:type] == NSOrderedSame) {
        selectedSizeDict =selectedData;
        [feelButton setTitle:selectedData[@"value"] forState:UIControlStateNormal];
    }
}
#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
