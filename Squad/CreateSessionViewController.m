//
//  CreateSessionViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 04/05/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CreateSessionViewController.h"
#import "DropdownViewController.h"
#import "Utility.h"
#import "EditExerciseSessionViewController.h"

@interface CreateSessionViewController () {
    IBOutlet UITextField *titleTextField;
    IBOutlet UIButton *sessionTypeButton;
    IBOutlet UIButton *bodyTypeButton;
    IBOutlet UIButton *equipmentTypeButton;
    IBOutlet UIScrollView *mainScroll;
    
    NSMutableArray *sessionTypeArray;
    NSMutableArray *bodyTypeArray;
    NSMutableArray *equipmentTypeArray;
    
    UITextField *activeTextField;
    UIView *contentView;
}

@end

@implementation CreateSessionViewController
//ah 4.5
- (void)viewDidLoad {
    [super viewDidLoad];

    sessionTypeArray = [[NSMutableArray alloc] init];
    bodyTypeArray = [[NSMutableArray alloc] init];
    equipmentTypeArray = [[NSMutableArray alloc] init];
    
    [bodyTypeButton setTag:100];
    
    [self registerForKeyboardNotifications];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    sessionTypeArray = [@[
                          @{
                              @"name" : @"Weights",
                              @"id" : @1
                              },
                          @{
                              @"name" : @"HIIT Session",
                              @"id" : @2
                              },
                          @{
                              @"name" : @"Pilates/Core",
                              @"id" : @3
                              },
                          @{
                              @"name" : @"Yoga",
                              @"id" : @4
                              },
                          @{
                              @"name" : @"Cardio",
                              @"id" : @5
                              }
                          ] mutableCopy];
    
    bodyTypeArray = [@[
                          @{
                              @"name" : @"FullBody",
                              @"id" : @1
                              },
                          @{
                              @"name" : @"LowerBody",
                              @"id" : @2
                              },
                          @{
                              @"name" : @"UpperBody",
                              @"id" : @3
                              },
                          @{
                              @"name" : @"Core",
                              @"id" : @4
                              },
                          @{
                              @"name" : @"Other",
                              @"id" : @0
                              }
                          ] mutableCopy];
    
    equipmentTypeArray = [@[
                          @{
                              @"name" : @"Equipment Required",
                              @"id" : @1
                              },
                          @{
                              @"name" : @"Body Weight",
                              @"id" : @2
                              },
                          @{
                              @"name" : @"Squad Straps",
                              @"id" : @3
                              }
                          ] mutableCopy];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)doneButtonTapped:(id)sender {
    if (titleTextField.text.length == 0) {
        [Utility msg:@"Please enter Session name" title:@"Oops!" controller:self haveToPop:NO];
    } else {
        if ([self formValidation]) {
            [self saveData];
        }
    }
}

-(IBAction)backButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)sessionTypeButtonTapped:(UIButton *)sender {
    int selectedIndex = -1;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id == %d)",sender.tag];
    NSArray *filteredArray = [sessionTypeArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        NSDictionary *dict1 = [filteredArray objectAtIndex:0];
        selectedIndex = (int)[sessionTypeArray indexOfObject:dict1];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = sessionTypeArray;
        controller.mainKey = @"name";
        controller.apiType = @"SessionType";
        controller.selectedIndex = selectedIndex;
        controller.sender = sender;
        controller.delegate = self;
        controller.shouldScrollToIndexpath = YES;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
-(IBAction)bodyTypeButtonTapped:(UIButton *)sender {
    int selectedIndex = -1;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id == %d)",sender.tag];
    NSArray *filteredArray = [bodyTypeArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        NSDictionary *dict1 = [filteredArray objectAtIndex:0];
        selectedIndex = (int)[bodyTypeArray indexOfObject:dict1];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = bodyTypeArray;
        controller.mainKey = @"name";
        controller.apiType = @"BodyType";
        controller.selectedIndex = selectedIndex;
        controller.sender = sender;
        controller.delegate = self;
        controller.shouldScrollToIndexpath = YES;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
-(IBAction)equipmentTypeButtonTapped:(UIButton *)sender {
    int selectedIndex = -1;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id == %d)",sender.tag];
    NSArray *filteredArray = [equipmentTypeArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        NSDictionary *dict1 = [filteredArray objectAtIndex:0];
        selectedIndex = (int)[equipmentTypeArray indexOfObject:dict1];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = equipmentTypeArray;
        controller.mainKey = @"name";
        controller.apiType = @"EquipmentType";
        controller.selectedIndex = selectedIndex;
        controller.sender = sender;
        controller.delegate = self;
        controller.shouldScrollToIndexpath = YES;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
#pragma mark - APICall
- (void) saveData {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[NSNumber numberWithInteger:0] forKey:@"Duration"];
        [mainDict setObject:titleTextField.text forKey:@"SessionName"];
        [mainDict setObject:[NSNumber numberWithInteger:sessionTypeButton.tag] forKey:@"SessionTypeId"];
        [mainDict setObject:[NSNumber numberWithInteger:bodyTypeButton.tag] forKey:@"BodyAreaId"];
        [mainDict setObject:[NSNumber numberWithInteger:equipmentTypeButton.tag] forKey:@"EquipmentRequiredId"];

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddSession" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         EditExerciseSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditExerciseSession"];
                                                                         controller.exSessionId = [[responseDict objectForKey:@"SavedSessionId"] intValue];
                                                                         
                                                                         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                         [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                                                                         NSString *dateDt = [formatter stringFromDate:[NSDate date]];
                                                                         
                                                                         controller.dt = dateDt;
                                                                         controller.fromController = @"list";
                                                                         controller.presentingVC = _presentingVC;
                                                                         [self presentViewController:controller animated:YES completion:nil];
                                                                     } else{
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
#pragma mark - DropDownViewDelegate
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData sender:(UIButton *)sender {
    [sender setTitle:[selectedData objectForKey:@"name"] forState:UIControlStateNormal];
    [sender setTag:[[selectedData objectForKey:@"id"] integerValue]];
//    if ([type caseInsensitiveCompare:@"SessionType"] == NSOrderedSame){
//        
//    } else if ([type caseInsensitiveCompare:@"BodyType"] == NSOrderedSame){
//        
//    } else if ([type caseInsensitiveCompare:@"EquipmentType"] == NSOrderedSame){
//        
//    }
}

#pragma mark - Private Method
-(BOOL) formValidation {
    if (titleTextField.text.length == 0) {
        [Utility msg:@"Please add Session Name" title:@"Oops!" controller:self haveToPop:NO];
        return false;
    } else if (sessionTypeButton.tag == 0) {
        [Utility msg:@"Please select Session Type" title:@"Oops!" controller:self haveToPop:NO];
        return false;
    } else if (bodyTypeButton.tag == 100) {
        [Utility msg:@"Please select Body Type" title:@"Oops!" controller:self haveToPop:NO];
        return false;
    } else if (equipmentTypeButton.tag == 0) {
        [Utility msg:@"Please add Equipment Type" title:@"Oops!" controller:self haveToPop:NO];
        return false;
    }
    return true;
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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    CGRect aRect = mainScroll.frame;
    float x;
    if (activeTextField !=nil) {
        x=aRect.size.height-activeTextField.frame.origin.y-activeTextField.frame.size.height;
        aRect.size.height -= kbSize.height;
        if (x < kbSize.height) {
            CGPoint scrollPoint = CGPointMake(0.0, kbSize.height+5-x);
            [mainScroll setContentOffset:scrollPoint animated:YES];
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
    activeTextField = nil;
    [textField resignFirstResponder];
}
@end
