//
//  CustomProgramSetupViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 16/01/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CustomProgramSetupViewController.h"
#import "ChooseGoalViewController.h"
#import "TrainHomeViewController.h"
#import "ViewPersonalSessionViewController.h"
#import "CustomExerciseSettingsViewController.h"

@interface CustomProgramSetupViewController (){
    IBOutlet NSLayoutConstraint *footerConstant;
    IBOutlet UIButton *menuButton;
    IBOutlet UIScrollView *scroll;
    IBOutlet UITextField *heightInch;
    IBOutlet UITextField *heightFt;
    IBOutlet UITextField *weight;
    IBOutlet UITextField *bodyFatPencentage;
    IBOutlet UIPickerView *unitPicker;  //ah new
    IBOutlet UIView *pickerSuperView;
    IBOutlet UIVisualEffectView *pickerVisualEffectView;
    IBOutlet UIButton *unitPreferenceButton;
    IBOutlet UIButton *imperialButton;
    IBOutlet UIView *ftView;
    IBOutlet UIView *inchView;
    IBOutlet UIView *cmView;
    IBOutlet UILabel *kgLbLabel;
    IBOutlet UITextField *heightcm;
    
    

    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *backButton;
    
    IBOutlet UIButton *backToExSettingsButton;
    IBOutlet NSLayoutConstraint *backExButtonHeightConstraint;
    IBOutlet UIStackView *heightVerticalStackView;
    IBOutlet UIStackView *heightHorizentalStackView;
    IBOutlet UIView *weightView;
    IBOutlet UIView *bodyPercentageview;
    IBOutlet UIButton *applyButton;
    IBOutlet UILabel *applyTextLabel;
    IBOutlet UIView *applyLineView;
    
    
    UITextField *activeTextField;
    UIView *contentView;
    UIToolbar* numberToolbar;
}

@end

@implementation CustomProgramSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
    if(![Utility isSubscribedUser]){
        menuButton.hidden = true;
        footerConstant.constant = 0;
    }else{
        menuButton.hidden = false;
        footerConstant.constant = 75;
    }
    [self registerForKeyboardNotifications];
//    [unitPreferenceButton setTitle:@"IMPERIAL" forState:UIControlStateNormal];

    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(doneWithFirstResponder)],nil];
    [numberToolbar sizeToFit];
    heightcm.inputAccessoryView = numberToolbar;
    heightInch.inputAccessoryView = numberToolbar;
    heightFt.inputAccessoryView = numberToolbar;
    weight.inputAccessoryView = numberToolbar;
    bodyFatPencentage.inputAccessoryView = numberToolbar;
    
    nextButton.hidden = true;
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]] || [defaults boolForKey:@"IsNonSubscribedUser"]){
    if(![Utility isSubscribedUser]){
        backToExSettingsButton.hidden = true;
        backExButtonHeightConstraint.constant = 0;
        backButton.hidden = true;
    }else{
        if ([defaults integerForKey:@"CustomExerciseStepNumber"] == 0) {
            backToExSettingsButton.hidden=false;
        }else {
            backToExSettingsButton.hidden = true;
            backExButtonHeightConstraint.constant = 0;
        }
        backButton.hidden = false;
    }
    unitPreferenceButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    unitPreferenceButton.layer.borderWidth = 1;
    
    imperialButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    imperialButton.layer.borderWidth = 1;
    
    cmView.layer.borderColor = [Utility colorWithHexString:@"929497"].CGColor;
    cmView.layer.borderWidth=1;
    
    weightView.layer.borderColor = [Utility colorWithHexString:@"929497"].CGColor;
    weightView.layer.borderWidth=1;
    
    bodyPercentageview.layer.borderColor = [Utility colorWithHexString:@"929497"].CGColor;
    bodyPercentageview.layer.borderWidth=1;
    
    applyButton.userInteractionEnabled = false;
    applyTextLabel.textColor = [Utility colorWithHexString:@"f087cb"];
    applyLineView.backgroundColor = [Utility colorWithHexString:@"f087cb"];
    
    ftView.layer.borderColor = [Utility colorWithHexString:@"929497"].CGColor;
    ftView.layer.borderWidth=1;

    inchView.layer.borderColor = [Utility colorWithHexString:@"929497"].CGColor;
    inchView.layer.borderWidth=1;
    
    [self getData];
}
#pragma -mark IBAction
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

-(IBAction)backButtonPressed:(id)sender{
    //    [self.navigationController popViewControllerAnimated:YES];
//    BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
    if(![Utility isSubscribedUser]){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
//    else if(isAllTaskCompleted){
//        TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
//        [self.navigationController pushViewController:controller animated:NO];
//    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(IBAction)nextButtonPressed:(id)sender{
    [self updatedUserProgramSetupStep];
    ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)saveButtonPressed:(id)sender{
    if ([self validationCheck]) {
        [activeTextField resignFirstResponder];
        [self saveData];
    }
}
-(IBAction)unitPreferenceButtonPressed:(id)sender{
    [activeTextField resignFirstResponder];
    UIButton *button = (UIButton *)sender;
    if (![button isSelected]) {
        [self metricImperialSetupView:0];
    }
//    pickerSuperView.hidden = false;
//    pickerVisualEffectView.hidden = false;
//    unitPicker.delegate = self;
//    unitPicker.dataSource = self;
}
-(IBAction)imperialButtonPressed:(id)sender{
    [activeTextField resignFirstResponder];
    UIButton *button = (UIButton *)sender;
    if (![button isSelected]) {
        [self metricImperialSetupView:2];
    }
}
/*
-(IBAction)pickerDoneButtonTapped:(id)sender {
    pickerSuperView.hidden = true;
    pickerVisualEffectView.hidden = true;
    NSInteger selectedRow = 1;
    if (sender != nil) {
        selectedRow = [unitPicker selectedRowInComponent:0];
    }
    NSString *titleStr = [unitPreferenceButton titleForState:UIControlStateNormal];
//    NSLog(@"title %@ | tf %@ | ts %@",unitPreferenceButton.titleLabel.text, unitPreferenceButton.currentTitle, [unitPreferenceButton titleForState:UIControlStateNormal]);
    switch (selectedRow) {
        case 0:
            if ([titleStr caseInsensitiveCompare:@"IMPERIAL"] == NSOrderedSame) {
                [unitPreferenceButton setTitle:@"METRIC" forState:UIControlStateNormal];
                ftView.hidden = YES;
                inchView.hidden = YES;
                cmView.hidden = NO;
                
                [heightVerticalStackView addArrangedSubview:cmView];
                [heightVerticalStackView removeArrangedSubview:heightHorizentalStackView];
                [heightHorizentalStackView removeFromSuperview];
                
                kgLbLabel.text = @"kgs";
                if (heightFt.text.length > 0) {
                    if (heightInch.text.length < 1) {
                        heightInch.text = @"0";
                    }
                    CGFloat inch = ([heightFt.text floatValue] * 12) + [heightInch.text floatValue];
                    CGFloat cm = inch * 2.54;
                    
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.numberStyle = NSNumberFormatterDecimalStyle;
                    formatter.maximumFractionDigits = 2;
                    heightcm.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cm]];
                }
                if (weight.text.length > 0) {
                    CGFloat kg = roundf([weight.text floatValue]/2.2046);
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.numberStyle = NSNumberFormatterDecimalStyle;
                    formatter.maximumFractionDigits = 2;
                    weight.text = [formatter stringFromNumber:[NSNumber numberWithFloat:kg]];
                }
            }
            break;
        case 1:
            if ([titleStr caseInsensitiveCompare:@"METRIC"] == NSOrderedSame) {
                [unitPreferenceButton setTitle:@"IMPERIAL" forState:UIControlStateNormal];
                ftView.hidden = NO;
                inchView.hidden = NO;
                cmView.hidden = YES;
                
                [heightVerticalStackView removeArrangedSubview:cmView];
                [cmView removeFromSuperview];
                [heightVerticalStackView addArrangedSubview:heightHorizentalStackView];
                
                kgLbLabel.text = @"lb";
                if (heightcm.text.length > 0) {
                    CGFloat inchFloat = [heightcm.text floatValue] * 0.3937008;
                    CGFloat ftFloat = inchFloat/12;
                    CGFloat ft = floorf(ftFloat);
                    CGFloat inch = (ftFloat - ft) * 12;
                    
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.numberStyle = NSNumberFormatterDecimalStyle;
                    formatter.maximumFractionDigits = 2;
                    heightFt.text = [formatter stringFromNumber:[NSNumber numberWithFloat:ft]];
                    heightInch.text = [formatter stringFromNumber:[NSNumber numberWithFloat:inch]];
                }
                if (weight.text.length > 0) {
                    CGFloat lb = roundf([weight.text floatValue] * 2.2046);
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.numberStyle = NSNumberFormatterDecimalStyle;
                    formatter.maximumFractionDigits = 2;
                    weight.text = [formatter stringFromNumber:[NSNumber numberWithFloat:lb]];
                }
            }
            break;
            
        default:
            break;
    }
}
-(IBAction)pickerCancelButtonTapped:(id)sender {
    pickerSuperView.hidden = true;
    pickerVisualEffectView.hidden = true;
}
 */
-(IBAction)backToExerciseSettings:(id)sender {
    BOOL isexist=false;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[CustomExerciseSettingsViewController class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            isexist=true;
            break;
            
        }
    }
    if (!isexist) {
        CustomExerciseSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionSettingHomeView"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
#pragma -mark End
#pragma mark - API Call
-(void) saveData {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        int heightInt = 0;
        int weightInt = 0;
        CGFloat bodyFatPercentageFloat = 0.0;
        NSString *titleStr;
        
        if (!cmView.hidden) {
            titleStr = [unitPreferenceButton.titleLabel.text uppercaseString];
        }else{
            titleStr = [imperialButton.titleLabel.text uppercaseString];
        }
        
        if ([titleStr caseInsensitiveCompare:@"IMPERIAL"] == NSOrderedSame) {
            CGFloat inch = ([heightFt.text floatValue] * 12) + [heightInch.text floatValue];
            CGFloat cm = inch * 2.54;
            heightInt = roundf(cm);
            weightInt = roundf([weight.text floatValue]/2.2046);
        } else {
            heightInt = [heightcm.text intValue];
            weightInt = [weight.text intValue];
        }
        
        bodyFatPercentageFloat = [bodyFatPencentage.text floatValue];
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        NSMutableDictionary *subDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"abbbcUserId"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"squadUserId"];
        [subDict setObject:[NSNumber numberWithInt:heightInt] forKey:@"Height"];
        [subDict setObject:[NSNumber numberWithInt:weightInt] forKey:@"Weight"];
        [subDict setObject:[NSNumber numberWithFloat:bodyFatPercentageFloat] forKey:@"BodyFatPercentage"];
        
        NSString *unitKeyValue=@"";
       
        if ([titleStr isEqualToString:@"METRIC"]){
            unitKeyValue=@"1";
        }else if ([titleStr isEqualToString:@"IMPERIAL"]){
            unitKeyValue=@"2";
        }
        int unitValue =[unitKeyValue intValue];
        [subDict setObject:[NSNumber numberWithInt:unitValue] forKey:@"UnitPreference"];
        [mainDict setObject:subDict forKey:@"BodyDataWithUnitPref"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateBodyDataWithUnitPref" append:@""forAction:@"POST"];  // UpdateSquadUserBodyData
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         [defaults setObject:unitKeyValue forKey:@"UnitPreference"];
                                                                         [self updatedUserProgramSetupStep];
                                                                         ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
                                                                         [self.navigationController pushViewController:controller animated:YES];
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

-(void) getData {   //ah 02
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetSquadUserData" append:[[defaults objectForKey:@"ABBBCOnlineUserId"] stringValue] forAction:@"GET"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
//                                                                         [unitPreferenceButton setTitle:@"METRIC" forState:UIControlStateNormal];
                                                                         self->unitPreferenceButton.selected = true;
                                                                         self->unitPreferenceButton.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                         self->imperialButton.selected = false;
                                                                         self->imperialButton.backgroundColor = [UIColor whiteColor];
                                                                         
                                                                         self->ftView.hidden = YES;
                                                                         self->inchView.hidden = YES;
                                                                         self->cmView.hidden = NO;
                                                                         
                                                                         [self->heightVerticalStackView addArrangedSubview:self->cmView];
                                                                         [self->heightVerticalStackView removeArrangedSubview:self->heightHorizentalStackView];
                                                                         [self->heightHorizentalStackView removeFromSuperview];
                                                                         
                                                                         self->kgLbLabel.text = @"kgs";
                                                                         self->weight.placeholder = @"kgs";
                                                                         
                                                                         self->heightcm.text = [[responseDict objectForKey:@"Height"] stringValue];
                                                                         self->weight.text = [[responseDict objectForKey:@"Weight"] stringValue];
                                                                         self->bodyFatPencentage.text = [[responseDict objectForKey:@"BodyFatPercent"] stringValue];
                                                                         
                                                                         if ([[responseDict objectForKey:@"Height"] floatValue] > 0.0 && [[responseDict objectForKey:@"Weight"] floatValue] > 0.0) {
                                                                             self->nextButton.hidden = false;
                                                                         }
                                                                         @try{
                                                                             if ([[responseDict objectForKey:@"UnitPreference"] intValue] == 2) {
                                                                                 [self metricImperialSetupView:[[responseDict objectForKey:@"UnitPreference"] intValue]];
                                                                             }
                                                                         }@catch(NSException *ex){
                                                                             
                                                                         }

                                                                     
//                                                                         switch ([[responseDict objectForKey:@"UnitPreference"] intValue]) {
//                                                                             case 0:
//
//                                                                                 break;
//
//                                                                             case 1:
//                                                                                 [self metricImperialSetupView:[[responseDict objectForKey:@"UnitPreference"] intValue]];
//
//                                                                                 break;
//
//                                                                             case 2:
//                                                                               //  [self pickerDoneButtonTapped:nil];
//                                                                                 break;
//
//                                                                             default:
//                                                                                 break;
//                                                                         }
                                                                     }
                                                                     else{
//                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
-(void) updatedUserProgramSetupStep {
    if ([defaults integerForKey:@"CustomExerciseStepNumber"] > 0) {
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
            [mainDict setObject:[NSNumber numberWithInteger:2] forKey:@"StepNumber"];
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
-(void)doneWithFirstResponder{
    [self.view endEditing:YES];
    if([self validationCheck]){
        applyButton.userInteractionEnabled = true;
        applyTextLabel.textColor = [UIColor whiteColor];
        applyLineView.backgroundColor = [UIColor whiteColor];
    }else{
        applyButton.userInteractionEnabled = false;
        applyTextLabel.textColor = [Utility colorWithHexString:@"f087cb"];
        applyLineView.backgroundColor = [Utility colorWithHexString:@"f087cb"];
    }
}
-(BOOL) validationCheck {
    BOOL isValid = NO;
    NSString *heightInchStr = heightInch.text;
    NSString *heightFtStr = heightFt.text;
    NSString *heightcmStr = heightcm.text;
    NSString *weightStr = weight.text;
    //    NSString *bodyFatPencentageStr = bodyFatPencentage.text;
    NSString *unitPreferenceStr=@"";
    
    if (!cmView.hidden) {
        unitPreferenceStr = unitPreferenceButton.titleLabel.text;
    }else{
        unitPreferenceStr = imperialButton.titleLabel.text;
    }
    
    if ([unitPreferenceStr caseInsensitiveCompare:@"METRIC"] == NSOrderedSame) {
        if (heightcmStr.length < 1 || [heightcmStr floatValue] == 0.0) {        //ah edit
//            [Utility msg:@"Please enter Height." title:@"Oops!" controller:self haveToPop:NO];
            return isValid;
        }
    } else if ([unitPreferenceStr caseInsensitiveCompare:@"IMPERIAL"] == NSOrderedSame) {
        if (heightInchStr.length < 1) {
            heightInch.text = @"0";
        }
        if (heightFtStr.length < 1 || [heightFtStr floatValue] == 0.0) {
//            [Utility msg:@"Please enter Height." title:@"Oops!" controller:self haveToPop:NO];
            return isValid;
        }
    }
    
    if (weightStr.length < 1 || [weightStr floatValue] == 0.0) {
//        [Utility msg:@"Please enter Weight." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    }
    //    } else if (bodyFatPencentageStr.length < 1) {
    //        [Utility msg:@"Please enter Body Fat Pencentage." title:@"Oops!" controller:self haveToPop:NO];
    //        return isValid;
    //    }
    
    return YES;
}

-(void)metricImperialSetupView:(int)index{
    if (index == 0 || index == 1) {
        //        [unitPreferenceButton setTitle:@"METRIC" forState:UIControlStateNormal];
        unitPreferenceButton.selected = true;
        unitPreferenceButton.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        
        imperialButton.selected = false;
        imperialButton.backgroundColor = [UIColor whiteColor];
        
        ftView.hidden = YES;
        inchView.hidden = YES;
        cmView.hidden = NO;
        
        [heightVerticalStackView addArrangedSubview:cmView];
        [heightVerticalStackView removeArrangedSubview:heightHorizentalStackView];
        [heightHorizentalStackView removeFromSuperview];
        weight.placeholder = @"kgs";
        kgLbLabel.text = @"kgs";
        if (heightFt.text.length > 0) {
            if (heightInch.text.length < 1) {
                heightInch.text = @"0";
            }
            CGFloat inch = ([heightFt.text floatValue] * 12) + [heightInch.text floatValue];
            CGFloat cm = inch * 2.54;
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 2;
            heightcm.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cm]];
        }
        if (weight.text.length > 0) {
            CGFloat kg = roundf([weight.text floatValue]/2.2046);
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 2;
            weight.text = [formatter stringFromNumber:[NSNumber numberWithFloat:kg]];
        }
    }else{
        //            [unitPreferenceButton setTitle:@"IMPERIAL" forState:UIControlStateNormal];
        imperialButton.selected = true;
        imperialButton.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        
        unitPreferenceButton.selected = false;
        unitPreferenceButton.backgroundColor = [UIColor whiteColor];
        
        ftView.hidden = NO;
        inchView.hidden = NO;
        cmView.hidden = YES;
        
        [heightVerticalStackView removeArrangedSubview:cmView];
        [cmView removeFromSuperview];
        [heightVerticalStackView addArrangedSubview:heightHorizentalStackView];
        weight.placeholder = @"lb";
        kgLbLabel.text = @"lb";
        if (heightcm.text.length > 0) {
            CGFloat inchFloat = [heightcm.text floatValue] * 0.3937008;
            CGFloat ftFloat = inchFloat/12;
            CGFloat ft = floorf(ftFloat);
            CGFloat inch = (ftFloat - ft) * 12;
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 2;
            heightFt.text = [formatter stringFromNumber:[NSNumber numberWithFloat:ft]];
            heightInch.text = [formatter stringFromNumber:[NSNumber numberWithFloat:inch]];
        }
        if (weight.text.length > 0) {
            CGFloat lb = roundf([weight.text floatValue] * 2.2046);
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 2;
            weight.text = [formatter stringFromNumber:[NSNumber numberWithFloat:lb]];
        }
    }
    if([self validationCheck]){
        applyButton.userInteractionEnabled = true;
        applyTextLabel.textColor = [UIColor whiteColor];
        applyLineView.backgroundColor = [UIColor whiteColor];
    }else{
        applyButton.userInteractionEnabled = false;
        applyTextLabel.textColor = [Utility colorWithHexString:@"f087cb"];
        applyLineView.backgroundColor = [Utility colorWithHexString:@"f087cb"];
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height-150, 0.0);
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

#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    // Store the data
    //    if (activeTextField == emailTextField) {
    //        [passwordTextField becomeFirstResponder];
    //    }
    //    else if (activeTextField == passwordTextField){
    //        //[self loginButtonPress:nil];
    //        [textField resignFirstResponder];
    //    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    if ([textField.text floatValue] == 0.0) {   //ah edit
        textField.text = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
}
#pragma mark - End

#pragma mark - PickerView DataSource/Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (row) {
        case 0:
            return @"METRIC";
            break;
            
        case 1:
            return @"IMPERIAL";
            break;
            
        default:
            break;
    }
    return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
