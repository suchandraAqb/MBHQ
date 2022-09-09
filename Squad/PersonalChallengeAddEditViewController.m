//
//  PersonalChallengeAddEditViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 17/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "PersonalChallengeAddEditViewController.h"

@interface PersonalChallengeAddEditViewController (){
    
    __weak IBOutlet UIScrollView *mainScroll;
    __weak IBOutlet UITextField *challengeNameTextField;
    __weak IBOutlet UIButton *calendarButton;
    __weak IBOutlet UITextField *dayNumberTextField;
    __weak IBOutlet UIButton *privateButton;
    __weak IBOutlet UIButton *publicButton;
    __weak IBOutlet UIButton *reminderButton;
    __weak IBOutlet UISwitch *reminderSwitch;
//    __weak IBOutlet UIStackView *reminderView;
//    __weak IBOutlet UIButton *frequencyButton;
//    __weak IBOutlet UIStackView *specificDaysStackView;
//    IBOutletCollection(UIButton) NSArray *specificDaysButtonCollection;
//    __weak IBOutlet UIStackView *selectDayStackView;
//    __weak IBOutlet UIButton *selectDayButton;
//    IBOutletCollection(UIButton) NSArray *reminderButtonCollection;
//    __weak IBOutlet UIStackView *secondReminderStackView;
    
    //    NSMutableDictionary *addDict;
    NSDateFormatter *formatter;
    UITextField *activeTextField;
    UITextView *activeTextView;
//    NSArray *habitTypeIdArray;
//    NSArray *ReminderOptionArray;
//    NSArray *timeArray;
//    NSArray *dayArray;
    NSMutableDictionary *resultDict;
    UIView *contentView;
    IBOutlet UIButton *backButton;
    __weak IBOutlet UITextView *descriptionTextView;
    UIToolbar *toolBar;
}

@end

@implementation PersonalChallengeAddEditViewController
@synthesize isAdd,delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    resultDict = [NSMutableDictionary new];
    UIView *paddingViewMinCal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, challengeNameTextField.frame.size.height)];
    challengeNameTextField.leftView = paddingViewMinCal;
    challengeNameTextField.leftViewMode = UITextFieldViewModeAlways;
    paddingViewMinCal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, dayNumberTextField.frame.size.height)];
    dayNumberTextField.leftView = paddingViewMinCal;
    dayNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    
    challengeNameTextField.layer.borderWidth = 1;
    challengeNameTextField.layer.borderColor = [UIColor colorWithRed:88/255.0f green:88/255.0f blue:91/255.0f alpha:1.0f].CGColor;
    dayNumberTextField.layer.borderWidth = 1;
    dayNumberTextField.layer.borderColor = [UIColor colorWithRed:88/255.0f green:88/255.0f blue:91/255.0f alpha:1.0f].CGColor;
    descriptionTextView.layer.borderWidth = 1;
    descriptionTextView.layer.borderColor = [UIColor colorWithRed:88/255.0f green:88/255.0f blue:91/255.0f alpha:1.0f].CGColor;
    calendarButton.layer.borderWidth = 1;
    calendarButton.layer.borderColor = [UIColor colorWithRed:88/255.0f green:88/255.0f blue:91/255.0f alpha:1.0f].CGColor;
    reminderButton.layer.borderWidth = 1;
    reminderButton.layer.borderColor = [UIColor colorWithRed:88/255.0f green:88/255.0f blue:91/255.0f alpha:1.0f].CGColor;
    
    publicButton.layer.borderWidth = 1;
    publicButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    publicButton.selected = false;
    
    privateButton.layer.borderWidth = 1;
    privateButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    [privateButton setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f]];
    privateButton.selected = true;
    
    backButton.layer.borderWidth = 1;
    backButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    
    formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    [calendarButton setTitle:[formatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *keyBoardDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(keyBoardDoneButtonClicked:)];
    [toolBar setItems:[NSArray arrayWithObject:keyBoardDone]];
    [self registerForKeyboardNotifications];
    reminderButton.enabled = false;
    reminderButton.alpha = 0.6;
    reminderSwitch.on = false;
    [reminderSwitch setOnTintColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
}
-(void)checkForChange:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"backButtonPressed"]) {
        [delegate didChangePersonalChallengeAddEdit:false];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -IBAction
- (IBAction)keyBoardDoneButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [delegate didChangePersonalChallengeAddEdit:false];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)calendarButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    CalendarPopUpViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CalendarPopUp"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    
    [formatter setDateFormat:@"dd-MM-yyyy"];
    controller.selectedDate = [formatter dateFromString:calendarButton.currentTitle];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)privateButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender == publicButton) {
        publicButton.selected = true;
        privateButton.selected = false;
        [publicButton setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f]];
        [privateButton setBackgroundColor:[UIColor whiteColor]];
    } else if (sender == privateButton) {
        privateButton.selected = true;
        publicButton.selected = false;
        [privateButton setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f]];
        [publicButton setBackgroundColor:[UIColor whiteColor]];
    }
}
- (IBAction)reminderSwitchValueChanged:(UISwitch *)sender {//switchClick
    [self.view endEditing:YES];
    if ([reminderSwitch isOn]) {
        reminderButton.enabled = true;
        reminderButton.alpha = 1.0;
        SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
        if (![Utility isEmptyCheck:resultDict])
            controller.defaultSettingsDict = resultDict;
        controller.reminderDelegate = self;
        controller.fromController = @"PersonalChallenge";
        //gami_badge_popup
//        if (isFirstTimeReminderSet) {
//            controller.isFirstTime = isFirstTimeReminderSet;
//            isFirstTimeReminderSet = false;
//        }//gami_badge_popup
        controller.view.backgroundColor = [UIColor clearColor];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        [reminderSwitch setOn:YES];
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Edit Reminder"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self reminderButtonPressed:0];
                                   }];
        UIAlertAction *turnOff = [UIAlertAction
                                  actionWithTitle:@"Turn Off Reminder"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      [self->reminderSwitch setOn:NO];
                                      self->reminderButton.enabled = false;
                                      self->reminderButton.alpha = 0.6;

                                      [self->resultDict removeAllObjects];
                                  }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:turnOff];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (IBAction)reminderButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
//    reminderView.hidden = !reminderView.isHidden;
    SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
    if (![Utility isEmptyCheck:resultDict])
        controller.defaultSettingsDict = resultDict;
     controller.reminderDelegate = self;
    controller.fromController = @"PersonalChallenge";
     controller.view.backgroundColor = [UIColor clearColor];
     controller.modalPresentationStyle = UIModalPresentationCustom;
     [self presentViewController:controller animated:YES completion:nil];
}
//- (IBAction)frequencyButtonPressed:(UIButton *)sender {
//    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
//    controller.modalPresentationStyle = UIModalPresentationCustom;
//    controller.dropdownDataArray = habitTypeIdArray;
//    controller.selectedIndex = -1;
//    controller.mainKey = @"name";
//    controller.apiType = @"HabitType";
//    controller.delegate = self;
//    controller.sender = sender;
//    [self presentViewController:controller animated:YES completion:nil];
//}
//- (IBAction)specificDayButtonPressed:(UIButton *)sender {
//    if (sender == selectDayButton) {
//        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
//        controller.modalPresentationStyle = UIModalPresentationCustom;
//        controller.dropdownDataArray = dayArray;
//        controller.selectedIndex = -1;
//        controller.mainKey = @"name";
//        controller.apiType = @"Day";
//        controller.delegate = self;
//        controller.sender = sender;
//        [self presentViewController:controller animated:YES completion:nil];
//    } else {
//        //SMTWTFS   tag 1....7
//        //specificDaysButtonCollection[]
//        sender.selected = !sender.isSelected;
//        if (sender.isSelected) {
//            [sender setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f]];
//        } else {
//            [sender setBackgroundColor:[UIColor whiteColor]];
//        }
//    }
//}
//- (IBAction)atAndTimeButtonPressed:(UIButton *)sender {
    //reminderButtonCollection[]
//    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
//    controller.modalPresentationStyle = UIModalPresentationCustom;
//    if (sender.tag == 0) {
//        controller.dropdownDataArray = ReminderOptionArray;
//    } else {
//        controller.dropdownDataArray = timeArray;
//    }
//    controller.selectedIndex = -1;
//    controller.mainKey = @"name";
//    controller.apiType = @"Time";
//    controller.delegate = self;
//    controller.sender = sender;
//    [self presentViewController:controller animated:YES completion:nil];
//}
- (IBAction)saveButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    [self addPersonalChallenge];
//    [self.navigationController popViewControllerAnimated:YES];
    // in success
    /*{
     NSMutableDictionary *extraData = [[NSMutableDictionary alloc] init];
     [extraData setObject:detailsDict forKey:@"selectedChallangeDict"];
     [extraData setObject:[self->activeDict objectForKey:@"ActionId"] forKey:@"Id"];
     [SetReminderViewController setOldLocalNotificationFromDictionary:[detailsDict mutableCopy] ExtraData:extraData FromController:(NSString *)@"PersonalChallenge" Title:[self->activeDict objectForKey:@"HabitName"] Type:@"PersonalChallenge" Id:[[self->activeDict objectForKey:@"ActionId"] intValue]];
     }*/
}
#pragma mark -End
#pragma mark - Private Method
-(void)addPersonalChallenge{
    if (Utility.reachable) {
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"AbbbcUserSessionId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"dd-MM-yyyy"];
        NSDate *dateC = [df dateFromString:calendarButton.currentTitle];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSMutableDictionary *detailsDict;
        if (resultDict.count>0) {
            detailsDict = [[[NSMutableDictionary alloc]initWithDictionary:resultDict]mutableCopy];
            
            [detailsDict setObject:[NSNumber numberWithBool:true] forKey:@"HasReminder"];
            [detailsDict setObject:[resultDict objectForKey:@"FrequencyId"] forKey:@"HabitTypeId"];
        } else {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"January"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"February"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"March"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"April"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"May"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"June"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"July"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"August"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"September"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"October"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"November"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"December"];
            
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Email"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"PushNotification"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Notification"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"HasReminder"];//HasReminder//Reminder
            
            [dict setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
            [dict setObject:[NSNumber numberWithInt:1] forKey:@"HabitTypeId"];
            
            [dict setObject:[NSNumber numberWithInt:0] forKey:@"MonthReminder"];
            [dict setObject:[NSNumber numberWithInt:0] forKey:@"ReminderAt1"];
            [dict setObject:[NSNumber numberWithInt:0] forKey:@"ReminderAt2"];
            [dict setObject:[NSNumber numberWithInt:0] forKey:@"ReminderOption"];
            
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Friday"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Monday"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Saturday"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Sunday"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Thursday"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Tuesday"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Wednesday"];
            detailsDict = [[[NSMutableDictionary alloc]initWithDictionary:dict]mutableCopy];
        }
        if (challengeNameTextField.text.length>0) {
            [detailsDict setObject:challengeNameTextField.text forKey:@"HabitName"];
        } else {
            [Utility msg:@"Enter challenge name." title:@"" controller:self haveToPop:NO];
            return;
        }
        if (descriptionTextView.text.length>0) {
            [detailsDict setObject:descriptionTextView.text forKey:@"Description"];
        } else {
            [Utility msg:@"Enter description." title:@"" controller:self haveToPop:NO];
            return;
        }
        if (calendarButton.currentTitle.length>0) {
            [detailsDict setObject:[df stringFromDate:dateC] forKey:@"CreatedAt"];
        } else {
            [Utility msg:@"Enter challenge start date." title:@"" controller:self haveToPop:NO];
            return;
        }
        if ([dayNumberTextField.text intValue]>0) {
            [detailsDict setObject:[NSNumber numberWithInt:[dayNumberTextField.text intValue]] forKey:@"DayNumber"];
        } else {
            [Utility msg:@"Enter number of days greater than 0." title:@"" controller:self haveToPop:NO];
            return;
        }
        if (publicButton.isSelected) {
            [detailsDict setObject:[NSNumber numberWithBool:true] forKey:@"Shareable"];
        } else {
            [detailsDict setObject:[NSNumber numberWithBool:false] forKey:@"Shareable"];
        }
        [df setDateFormat:@"dd-MM-yyyy"];
        NSDate *dateE = [[df dateFromString:calendarButton.currentTitle] dateByAddingDays:[dayNumberTextField.text intValue]];
        [df setDateFormat:@"yyyy-MM-dd"];
        [detailsDict setObject:[df stringFromDate:dateE] forKey:@"Enddate"];
        [detailsDict setObject:[NSNumber numberWithInt:0] forKey:@"HabitId"];
        [detailsDict setObject:[NSNumber numberWithInt:0] forKey:@"ActionId"];
        [detailsDict setObject:[NSNumber numberWithInt:0] forKey:@"TaskId"];
        
        [detailsDict setObject:[NSNumber numberWithInt:1] forKey:@"IsPersonalized"];
        [detailsDict setObject:[NSNumber numberWithBool:false] forKey:@"IsSquadCreated"];
        [detailsDict setObject:[NSNumber numberWithBool:true] forKey:@"Status"];
        
        [mainDict setObject:detailsDict forKey:@"HabitData"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddPersonalChallenge" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
//                                                                  self->apiCount--;
                                                                  if (self->contentView) {
                                                                      [self->contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          NSLog(@"%@",responseDict);
                                                                          [self->delegate didChangePersonalChallengeAddEdit:true];
                                                                          [Utility msg:@"Saved Successfully" title:@"" controller:self haveToPop:YES];
                                                                      }
                                                                      else{
                                                                          [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                          return;
                                                                      }
                                                                  }else{
                                                                      [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                  }
                                                              });
                                                              
                                                          }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
#pragma mark -End
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height-75-45, 0.0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
    if (activeTextField != nil) {
        CGRect aRect = mainScroll.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            [mainScroll scrollRectToVisible:activeTextField.frame animated:YES];
            
        }
    }
    if (activeTextView != nil) {
        CGRect aRect = mainScroll.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextView.frame.origin) ) {
            [mainScroll scrollRectToVisible:activeTextView.frame animated:YES];
            
        }
    }
    //    else if (activeTextView !=nil) {
    //        CGRect aRect = mainScroll.frame;
    //        CGRect frame = [mainScroll convertRect:activeTextView.frame fromView:activeTextView.superview];
    //        aRect.size.height -= kbSize.height;
    //        if (!CGRectContainsPoint(aRect,frame.origin) ) {
    //            [mainScroll scrollRectToVisible:frame animated:YES];
    //        }
    //    }
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
    [activeTextField setInputAccessoryView:toolBar];
//    activeTextField.returnKeyType = UIReturnKeyDone;
//    [textField setInputAccessoryView:toolBar];
//    [textField addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    activeTextField = nil;
}
#pragma mark - End
#pragma mark - TextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    activeTextView = textView;
    [textView setInputAccessoryView:toolBar];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [textView resignFirstResponder];
    activeTextView = nil;
}
#pragma mark - End
#pragma mark - DropDown ViewDelegate
//- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)data sender:(UIButton *)sender{

//    if ([type caseInsensitiveCompare:@"HabitType"] == NSOrderedSame) {
//        [sender setTitle:data[@"name"] forState:UIControlStateNormal];
//        UIButton *btn = reminderButtonCollection[0];
//        if ([btn.currentTitle isEqualToString:@"AT"]) {
//            secondReminderStackView.hidden = true;
//        }else{
//            secondReminderStackView.hidden = false;
//        }
//        if ([data[@"value"] isEqual:@1]) {
//            specificDaysStackView.hidden = true;
//            selectDayStackView.hidden = true;
////            secondReminderStackView.hidden = true;
//        }else if ([data[@"value"] isEqual:@2]) {
//            specificDaysStackView.hidden = true;
//            selectDayStackView.hidden = true;
//            secondReminderStackView.hidden = false;
//        }else if ([data[@"value"] isEqual:@3]) {
//            specificDaysStackView.hidden = false;
//            selectDayStackView.hidden = true;
////            secondReminderStackView.hidden = true;
//        }else if ([data[@"value"] isEqual:@4]) {
//            specificDaysStackView.hidden = false;
//            selectDayStackView.hidden = true;
////            secondReminderStackView.hidden = true;
//        }else if ([data[@"value"] isEqual:@5]) {
//            specificDaysStackView.hidden = true;
//            selectDayStackView.hidden = false;
////            secondReminderStackView.hidden = true;
//        }
//    } else if ([type caseInsensitiveCompare:@"Time"] == NSOrderedSame) {
//        [sender setTitle:data[@"name"] forState:UIControlStateNormal];
//        if (sender.tag == 0) {
//            if ([data[@"value"] isEqual:@1]) {
//                secondReminderStackView.hidden = true;
//                if ([frequencyButton.currentTitle isEqualToString:@"TWICE DAILY"]) {
//                    secondReminderStackView.hidden = false;
//                }
//            } else {
//                secondReminderStackView.hidden = false;
//            }
//        }
//    } else if ([type caseInsensitiveCompare:@"Day"] == NSOrderedSame) {
//        [sender setTitle:data[@"name"] forState:UIControlStateNormal];
//
//    }
//}
#pragma mark -DatePicker Delegate
-(void)didSelectDate:(NSDate *)date{
    NSLog(@"%@",date);
    if (date) {
        [calendarButton setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    }
}
#pragma mark -Reminder Delegate
-(void) reminderSettingsValue:(NSMutableDictionary *)reminderDict {
    reminderButton.enabled = true;
    reminderButton.alpha = 1.0;
    [reminderDict setObject:[NSNumber numberWithBool:[[reminderDict objectForKey:@"PushNotification"]boolValue]] forKey:@"Notification"];
    resultDict = reminderDict;
    NSLog(@"%@",resultDict);
}
-(void) cancelReminder {
        if (![Utility isEmptyCheck:resultDict]) {
            
        } else {
            [reminderSwitch setOn:false];
            reminderButton.enabled = false;
            reminderButton.alpha = 0.6;
        }
}
#pragma mark -End
#pragma mark -PopUpdelegate
-(void)didSelectDateInPopUp:(NSDate *)date{
    [formatter setDateFormat:@"dd-MM-yyyy"];
    [calendarButton setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
}
-(void)cancelInPopUp{
    
}
#pragma mark -End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
