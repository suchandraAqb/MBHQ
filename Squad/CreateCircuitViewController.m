//
//  CreateCircuitViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 02/05/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CreateCircuitViewController.h"
#import "DropdownViewController.h"
#import "Utility.h"

@interface CreateCircuitViewController () {
    IBOutlet UITextField *titleTextField;
    IBOutlet UIButton *circuitTypeButton;
    IBOutlet UIScrollView *mainScroll;
    
    UITextField *activeTextField;
    UIView *contentView;

    NSMutableArray *circuitTypeArray;
}

@end

@implementation CreateCircuitViewController
@synthesize createCircuitDelegate;
//ah 2.5
- (void)viewDidLoad {
    [super viewDidLoad];

    circuitTypeArray = [[NSMutableArray alloc] init];
    
    titleTextField.text = [NSString stringWithFormat:@"%@'s - ",[defaults objectForKey:@"FirstName"]];
    
    [circuitTypeButton setTitle:@"Hiit" forState:UIControlStateNormal];
    [circuitTypeButton setTag:2];
    
    [self registerForKeyboardNotifications];    //ah 4.5
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    circuitTypeArray = [@[
                          @{
                              @"name" : @"Hiit",
                              @"id" : @2
                              },
                          @{
                              @"name" : @"Pilates",
                              @"id" : @3
                              },
                          @{
                              @"name" : @"Yoga",
                              @"id" : @4
                              },
                          @{
                              @"name" : @"Cardio",
                              @"id" : @5
                              },
                          @{
                              @"name" : @"Weights",
                              @"id" : @1
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
    NSString *defaultStr = [NSString stringWithFormat:@"%@'s - ",[defaults objectForKey:@"FirstName"]];
    if (titleTextField.text.length == 0 || [[titleTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] caseInsensitiveCompare:[defaultStr stringByReplacingOccurrencesOfString:@" " withString:@""]] == NSOrderedSame) {
        [Utility msg:@"Please enter circuit name" title:@"Oops!" controller:self haveToPop:NO];
    } else {
        [self saveData];
    }
}

-(IBAction)backButtonPressed:(id)sender{
    //Local_catch
    if ([createCircuitDelegate respondsToSelector:@selector(didCheckAnyChangeForCreateCircuit:)]) {
        [createCircuitDelegate didCheckAnyChangeForCreateCircuit:false];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)circuitTypeButtonTapped:(UIButton *)sender {
    int selectedIndex = -1;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id == %d)",sender.tag];
    NSArray *filteredArray = [circuitTypeArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        NSDictionary *dict1 = [filteredArray objectAtIndex:0];
        selectedIndex = (int)[circuitTypeArray indexOfObject:dict1];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = circuitTypeArray;
        controller.mainKey = @"name";
        controller.apiType = @"CircuitType";
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
        [mainDict setObject:[NSNumber numberWithInteger:0] forKey:@"CircuitId"];
        [mainDict setObject:titleTextField.text forKey:@"CircuitTitle"];
        [mainDict setObject:[NSNumber numberWithInteger:circuitTypeButton.tag] forKey:@"CircuitType"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadAddCircuit" append:@""forAction:@"POST"];
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
                                                                         
                                                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
                                                                         
                                                                         int cktID = [[responseDict objectForKey:@"CircuitId"] intValue];
                                                                         
                                                                         EditCircuitViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditCircuit"];
                                                                         controller.cktID = cktID;
                                                                         controller.exSessionId = _exSessionId;
                                                                         controller.isNewCkt = YES;
                                                                         controller.oldCktID = -1;
                                                                         controller.sequence = -1;
                                                                         controller.dt = _dt;
                                                                         controller.fromController = _fromController;   //ah 4.5
                                                                         controller.editCktDelegate = self; //Local_catch
                                                                         [self presentViewController:controller animated:YES completion:nil];
                                                                     }else{
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
    if (![Utility isEmptyCheck:selectedData]) {
        if ([type caseInsensitiveCompare:@"CircuitType"] == NSOrderedSame) {
            [sender setTitle:[selectedData objectForKey:@"name"] forState:UIControlStateNormal];
            [sender setTag:[[selectedData objectForKey:@"id"] integerValue]];
        }
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
#pragma mark - End

#pragma mark - EdirCircuitDelegate
//Local_catch
-(void)didCheckAnyChange:(BOOL)ischanged{
    if ([createCircuitDelegate respondsToSelector:@selector(didCheckAnyChangeForCreateCircuit:)]) {
        [createCircuitDelegate didCheckAnyChangeForCreateCircuit:ischanged];
    }
}
//Local_catch
@end
