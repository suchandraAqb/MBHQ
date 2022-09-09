//
//  AddPersonalSessionViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 10/02/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AddPersonalSessionViewController.h"
#import "Utility.h"

@interface AddPersonalSessionViewController () {    //ah new
    IBOutlet UILabel *sessionTitleLabel;
    IBOutlet UIButton *sportSessionButton;
    IBOutlet UIButton *gymClassSessionButton;
    IBOutlet UIButton *timeButton;
    IBOutlet UIButton *amPmButton;
    IBOutlet UIButton *sessionTypeButton;
    IBOutlet UIButton *durationButton;
    IBOutlet UITextField *sessionNameTextField;
    IBOutlet UIView *nameView;
    IBOutlet UIView *timeView;
    IBOutlet UIView *typeView;
    IBOutlet UIView *durationView;
    IBOutlet UIView *saveView;
    IBOutlet UILabel *firstSelectLabel;
    IBOutlet UIPickerView *currentPickerView;
    IBOutlet UIView *pickerSuperView;
    IBOutlet UIVisualEffectView *pickerVisualEffectView;
    
    UIView *contentView;
    NSMutableArray *dataArray;
    NSArray *responseArray;
    NSMutableArray *timeArray;
    NSMutableArray *durationArray;
    NSMutableArray *pickerArray;
    int selectedNo;
    int sessionTypeInt;
    //shabbir 190618 design change
    __weak IBOutlet UIButton *pmButton;
    
}

@end

@implementation AddPersonalSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc]init];
    nameView.hidden = true;
    timeView.hidden = true;
    typeView.hidden = true;
    durationView.hidden = true;
    saveView.hidden = true;
    firstSelectLabel.hidden = false;
    responseArray = [[NSArray alloc]init];
    timeArray = [[NSMutableArray alloc]init];
    durationArray = [[NSMutableArray alloc]init];
    pickerArray = [[NSMutableArray alloc]init];
    selectedNo = -1;
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setLocale: [NSLocale currentLocale]];
    NSArray *weekdays = [df weekdaySymbols];
//    NSLog(@"wds %@",weekdays);
    if (_dayIndex == 6) {
        sessionTitleLabel.text = [NSString stringWithFormat:@"%@",[weekdays objectAtIndex:0]];
    } else {
        sessionTitleLabel.text = [NSString stringWithFormat:@"%@",[weekdays objectAtIndex:_dayIndex+1]];
    }
    sportSessionButton.layer.borderWidth = 1;
    sportSessionButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    gymClassSessionButton.layer.borderWidth = 1;
    gymClassSessionButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    sessionNameTextField.leftView = paddingView;
    sessionNameTextField.leftViewMode = UITextFieldViewModeAlways;
    sessionNameTextField.layer.borderWidth = 1;
    sessionNameTextField.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    timeButton.layer.borderWidth = 1;
    timeButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    amPmButton.layer.borderWidth = 1;
    amPmButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    pmButton.layer.borderWidth = 1;
    pmButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    sessionTypeButton.layer.borderWidth = 1;
    sessionTypeButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    durationButton.layer.borderWidth = 1;
    durationButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    
    saveView.alpha = 0.5;
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    for (int i = 1; i <= 12;i++ ) {
        for(int j=0;j<=45;j+=15) {
            [timeArray addObject:[NSString stringWithFormat:@"%d:%02d",i,j]];
        }
    }
    
    for (int j = 15; j <= 120; j += 15) {
        [durationArray addObject:[NSString stringWithFormat:@"%d mins",j]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
-(IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)logoTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(IBAction)sportSessionButtonTapped:(id)sender {
    [sportSessionButton setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    [sportSessionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gymClassSessionButton setBackgroundColor:[UIColor whiteColor]];
    [gymClassSessionButton setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
    [sessionTypeButton setTitle:@"" forState:UIControlStateNormal];
    sessionTypeButton.titleLabel.text = nil;
    sessionTypeInt = 8;
    [self getDataFromApi:@"GetSports"];
}

-(IBAction)gymClassSessionButtonTapped:(id)sender {
    [gymClassSessionButton setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    [gymClassSessionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sportSessionButton setBackgroundColor:[UIColor whiteColor]];
    [sportSessionButton setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
    [sessionTypeButton setTitle:@"" forState:UIControlStateNormal];
    sessionTypeButton.titleLabel.text = nil;
    sessionTypeInt = 11;
    [self getDataFromApi:@"GetGymClasses"];
}

-(IBAction)timeButtonTapped:(id)sender {
    [pickerArray removeAllObjects];
    [pickerArray addObjectsFromArray:timeArray];
    [self openPickerNo:0 PreviousValue:timeButton.titleLabel.text];
}

-(IBAction)amPmButtonTapped:(UIButton *)sender {
//    [pickerArray removeAllObjects];
//    [pickerArray addObject:@"AM"];
//    [pickerArray addObject:@"PM"];
//    [self openPickerNo:1 PreviousValue:amPmButton.titleLabel.text];
    if (sender == amPmButton) {
        pmButton.selected = false;
        [pmButton setBackgroundColor:[UIColor whiteColor]];
        [pmButton setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
    } else if(sender == pmButton){
        amPmButton.selected = false;
        [amPmButton setBackgroundColor:[UIColor whiteColor]];
        [amPmButton setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
    }
    sender.selected = true;
    [sender setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveView.alpha = 1;
}

-(IBAction)sessionTypeButtonTapped:(id)sender {
    [pickerArray removeAllObjects];
    [pickerArray addObjectsFromArray:responseArray];
    [self openPickerNo:2 PreviousValue:sessionTypeButton.titleLabel.text];
}

-(IBAction)durationButtonTapped:(id)sender {
    [pickerArray removeAllObjects];
    [pickerArray addObjectsFromArray:durationArray];
    [self openPickerNo:3 PreviousValue:durationButton.titleLabel.text];
}

-(IBAction)saveButtonTapped:(id)sender {
    if ([self validationCheck]) {
        [self saveData];
    }
}
-(IBAction)pickerDoneButtonTapped:(id)sender {
    pickerSuperView.hidden = true;
    pickerVisualEffectView.hidden = true;
    NSInteger selectedRow = [currentPickerView selectedRowInComponent:0];
    
    switch (selectedNo) {
            
        case 0:
            [timeButton setTitle:[timeArray objectAtIndex:selectedRow] forState:UIControlStateNormal];
            break;
            
        case 1:
            [amPmButton setTitle:[pickerArray objectAtIndex:selectedRow] forState:UIControlStateNormal];
            break;
            
        case 2:
            [sessionTypeButton setTitle:[responseArray objectAtIndex:selectedRow] forState:UIControlStateNormal];
            break;
            
        case 3:
            [durationButton setTitle:[durationArray objectAtIndex:selectedRow] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    saveView.alpha = 1;
}
-(IBAction)pickerCancelButtonTapped:(id)sender {
    pickerSuperView.hidden = true;
    pickerVisualEffectView.hidden = true;
}
-(IBAction)backButtonPressed:(id)sender{
    //    [self.navigationController popViewControllerAnimated:YES];
    RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
    controller.isRateFitness = false;
    controller.isWeeklySession = true;
    [self.navigationController pushViewController:controller animated:NO];
}
-(IBAction)nextButtonPressed:(id)sender{
    [self updatedUserProgramSetupStepNo:7];
    MovePersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MovePersonalSession"];
    //    controller.responseObjArray = responseObjArray;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - API Calls
- (void) getDataFromApi:(NSString *)apiName {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:apiName append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     self->responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:self->responseArray]) {
                                                                         self->nameView.hidden = false;
                                                                         self->timeView.hidden = false;
                                                                         self->typeView.hidden = false;
                                                                         self->durationView.hidden = false;
                                                                         self->saveView.hidden = false;
                                                                         self->firstSelectLabel.hidden = true;
                                                                         self->firstSelectLabel.text = @"";
//                                                                         dataArray addObjectsFromArray:[response]
                                                                     }
                                                                     else{
                                                                         //[Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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

-(void)saveData {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSString *sessionName = sessionNameTextField.text;
        NSString *time = timeButton.titleLabel.text;
        NSArray *timeArr = [time componentsSeparatedByString:@":"];
        NSString *hour = [timeArr objectAtIndex:0];
        NSString *Minute = [timeArr objectAtIndex:1];
//        NSString *amPmStr = amPmButton.titleLabel.text;
        NSString *sessionType = sessionTypeButton.titleLabel.text;
        NSString *duration = durationButton.titleLabel.text;
        NSArray *durArr = [duration componentsSeparatedByString:@" "];
        duration = [durArr objectAtIndex:0];
        
        NSMutableDictionary *personalSessionDict = [[NSMutableDictionary alloc]init];
        [personalSessionDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [personalSessionDict setObject:[NSNumber numberWithInt:sessionTypeInt] forKey:@"SessionType"];
        [personalSessionDict setObject:[NSString stringWithFormat:@"%d",_dayIndex] forKey:@"SessionDay"];
        [personalSessionDict setObject:hour forKey:@"Hour"];
        [personalSessionDict setObject:Minute forKey:@"Minute"];
        [personalSessionDict setObject:sessionName forKey:@"SessionTitle"];
        [personalSessionDict setObject:duration forKey:@"Duration"];
        [personalSessionDict setObject:sessionType forKey:@"NewSessionType"];
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        //        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
//        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        //        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        [mainDict setObject:personalSessionDict forKey:@"UserPersonalSession"];
        [mainDict setObject:[NSNumber numberWithBool:YES] forKey:@"ResetThisWeek"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadCreateUserPersonalSession" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self.navigationController popViewControllerAnimated:YES];
//                                                                         [self dismissViewControllerAnimated:YES completion:nil];
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
-(void) updatedUserProgramSetupStepNo:(int) stepNumber{
    if ([defaults integerForKey:@"CustomExerciseStepNumber"] > 0) {// < stepNumber) {
        if (Utility.reachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
                self->contentView = [Utility activityIndicatorView:self];
            });
            
            NSURLSession *customSession = [NSURLSession sharedSession];
            
            NSError *error;
            
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            [mainDict setObject:AccessKey forKey:@"Key"];
            [mainDict setObject:[NSNumber numberWithInteger:stepNumber] forKey:@"StepNumber"];
            [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
            [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdatedUserProgramSetupStep" append:@""forAction:@"POST"];
            NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                              completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      if (self->contentView) {
                                                                          [self->contentView removeFromSuperview];
                                                                      }
                                                                      if(error == nil)
                                                                      {
                                                                          NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                          NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                          if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                              
                                                                          }
                                                                          else{
                                                                              [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
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
}
#pragma mark - Private Methods
-(void)openPickerNo:(int)number PreviousValue:(NSString *)previousValue {
    [sessionNameTextField resignFirstResponder];
    pickerSuperView.hidden = false;
    pickerVisualEffectView.hidden = false;
    currentPickerView.delegate = self;
    currentPickerView.dataSource = self;
    selectedNo = number;
    if (previousValue.length > 0) {
        if ([pickerArray containsObject:previousValue]) {
            NSInteger newIndex = [pickerArray indexOfObject:previousValue];
            [currentPickerView selectRow:newIndex inComponent:0 animated:NO];
        } else {
            [currentPickerView selectRow:0 inComponent:0 animated:NO];
        }
    } else {
        [currentPickerView selectRow:0 inComponent:0 animated:NO];
    }
}
-(BOOL) validationCheck {
    BOOL isValid = NO;
    NSString *sessionName = sessionNameTextField.text;
    NSString *time = timeButton.titleLabel.text;
    NSString *amPmStr = amPmButton.titleLabel.text;
    NSString *sessionType = sessionTypeButton.titleLabel.text;
    NSString *duration = durationButton.titleLabel.text;
    
    if (sessionName.length < 1) {
        [Utility msg:@"Please enter Session Name." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    } else if (time.length < 1 || [time caseInsensitiveCompare:@"Select Time"] == NSOrderedSame) {
        [Utility msg:@"Please enter Time." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    } if (amPmStr.length < 1 || !(amPmButton.isSelected || pmButton.isSelected)) {
        [Utility msg:@"Please enter AM/PM." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    } else if (sessionType.length < 1 || ![responseArray containsObject:sessionType]) {
        [Utility msg:@"Please enter Session Type." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    } else if (duration.length < 1 || [duration caseInsensitiveCompare:@"Select Duration"] == NSOrderedSame) {
        [Utility msg:@"Please enter Duration." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    }
    
    return YES;
}
#pragma mark - PickerView DataSource/Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //NSLog(@"sel -> %@",listArray[row]);
    //[selectedButton setTitle:[[listArray objectAtIndex:row] valueForKey:@"label"] forState:UIControlStateNormal];
    //    [submitArray setValue:[[listArray objectAtIndex:row] valueForKey:@"value"] forKey:selectedID];
    //    [selectedButton setAttributedTitle:[util htmlParseWithString:[[listArray objectAtIndex:row] valueForKey:@"label"]] forState:UIControlStateNormal];
}
#pragma mark - TextField Delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>0) {
        saveView.alpha = 1;
    }
}
@end
