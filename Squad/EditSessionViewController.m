//
//  EditSessionViewController.m
//  ABBBCOnline
//
//  Created by AQB Mac 4 on 25/11/16.
//  Copyright © 2016 Aqb. All rights reserved.
//

#import "EditSessionViewController.h"
#import "DropdownViewController.h"

@interface EditSessionViewController ()

@end

@implementation EditSessionViewController{
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UILabel *sessionCategory;
    IBOutlet UIView *sessionTypeContainer;
    IBOutlet NSLayoutConstraint *sessionTypeHeightConstraint;
    IBOutlet UILabel *sessionType;
    IBOutlet UIView *sessionFlowContainer;
    IBOutlet NSLayoutConstraint *sessionFlowHeightConstraint;
    IBOutlet UILabel *sessionFlow;
    IBOutlet NSLayoutConstraint *workoutSessionHeightConstraint;
    
    IBOutlet UIView *workoutSessionContainer;
    IBOutlet UILabel *workoutSession;
    IBOutlet UIView *personalizeContainer;
    IBOutlet NSLayoutConstraint *personalizeHeightConstraint;
    
    IBOutlet UIView *durationContainer;
    IBOutlet UITextField *duration;
    IBOutlet UIButton *repeat;
    
    IBOutlet UIView *locationContainer;
    IBOutlet UILabel *location;
    
    IBOutlet UILabel *exerciseSessionTitle;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *cancelButton;
    
    UITextField *activeTextField;
    NSArray *sessionCategoryArray;
    NSArray *sessionTypeArray;
    NSArray *sessionFlowArray;
    NSArray *workoutSessionArray;
    NSArray *locationArray;
    UIView *contentView;

}
@synthesize sessionData,weekNumber,day,isEdit,startDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    if ([Utility isEmptyCheck:sessionData] && !isEdit) {
        sessionData = [[NSMutableDictionary alloc]init];
    }
    [self setupDropdown];
   
}

-(void)setupDropdown{
    sessionCategoryArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"Key",@"ABBBC Created Sessions",@"Value", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"Key",@"Class I Attend",@"Value", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"3",@"Key",@"Sport",@"Value", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"4",@"Key",@"My Personalised Session",@"Value", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"5",@"Key",@"FBW",@"Value", nil], nil];
    
    sessionTypeArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"Key",@"Weights",@"Value", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"Key",@"HIIT Session",@"Value", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"3",@"Key",@"PilatesCore",@"Value", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"4",@"Key",@"Yoga",@"Value", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"5",@"Key",@"Cardio",@"Value", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"Key",@"Cardio Based Class",@"Value", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"7",@"Key",@"Resistance Based Class",@"Value", nil], nil];
    if (sessionData.count == 0 && !isEdit) {
        sessionTypeContainer.hidden = true;
        sessionFlowContainer.hidden = true;
        workoutSessionContainer.hidden = true;
        personalizeContainer.hidden = true;
        durationContainer.hidden = true;
        locationContainer.hidden = true;
        exerciseSessionTitle.hidden = true;
        saveButton.hidden = true;
        cancelButton.hidden = true;
        return;
    }else{
        sessionTypeContainer.hidden = false;
        sessionFlowContainer.hidden = false;
        workoutSessionContainer.hidden = false;
        personalizeContainer.hidden = false;
        durationContainer.hidden = false;
        locationContainer.hidden = false;
        exerciseSessionTitle.hidden = false;
        saveButton.hidden = false;
        cancelButton.hidden = false;
    }
    
    if (([[sessionData objectForKey:@"SessionCategory"] intValue] == 1) && ([[sessionData objectForKey:@"SessionType"] intValue] == 2 || [[sessionData objectForKey:@"SessionType"] intValue] == 4 || [[sessionData objectForKey:@"SessionType"] intValue] == 5)) {
        sessionFlowArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"Key",@"Flow Along",@"Value", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"Key",@"Standard",@"Value", nil], nil];
    }else{
        sessionFlowArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"Key",@"Standard",@"Value", nil], nil];
    }
    locationArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"Key",@"Gym",@"Value", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"3",@"Key",@"Park",@"Value", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"Key",@"Home",@"Value", nil], nil];
    NSString *sessionDurationString = [[sessionData objectForKey:@"Duration"] stringValue];
    if (![Utility isEmptyCheck:sessionDurationString]) {
        duration.text = sessionDurationString;
    }else{
        duration.text = @"";
    }
    
    repeat.selected = [[sessionData objectForKey:@"RepeatNextWeek"] boolValue];
    
    NSString *sessionCategoryString = [[sessionData objectForKey:@"SessionCategory"] stringValue];
    if (![Utility isEmptyCheck:sessionCategoryString]) {
        NSDictionary *selectedSessionCategoryDict = [self getDictByValue:sessionCategoryArray value:sessionCategoryString type:@"Key"];
        if (![Utility isEmptyCheck:selectedSessionCategoryDict]) {
            sessionCategory.text = [selectedSessionCategoryDict valueForKey:@"Value"];
        }else{
            sessionCategory.text = @"Select Session Category";
        }
    }else{
        sessionCategory.text = @"Select Session Category";
    }
    
    NSString *sessionTypeString = [[sessionData objectForKey:@"SessionType"] stringValue];
    if (![Utility isEmptyCheck:sessionTypeString]) {
        NSDictionary *selectedSessionTypeDict = [self getDictByValue:sessionTypeArray value:sessionTypeString type:@"Key"];
        if (![Utility isEmptyCheck:selectedSessionTypeDict]) {
            sessionType.text = [selectedSessionTypeDict valueForKey:@"Value"];
        }else{
            sessionType.text = @"Select Session Type";
        }
    }else{
        sessionType.text = @"Select Session Type";
    }

    NSString *sessionFlowString = [[sessionData objectForKey:@"SessionFlow"] stringValue];
    
    if ([Utility isEmptyCheck:sessionFlowString]) {
        sessionFlowString = @"2";
        [sessionData setObject:[numberFormatter numberFromString:@"2"] forKey:@"SessionFlow"];

    }
    NSDictionary *selectedSessionFlowDict = [self getDictByValue:sessionFlowArray value:sessionFlowString type:@"Key"];
    if (![Utility isEmptyCheck:selectedSessionFlowDict]) {
        sessionFlow.text = [selectedSessionFlowDict valueForKey:@"Value"];
    }else{
        sessionFlow.text = @"Select Session Flow";
    }

    if ([[sessionData objectForKey:@"SessionCategory"] intValue] == 1 || [[sessionData objectForKey:@"SessionCategory"] intValue] == 4) {
        sessionTypeHeightConstraint.constant = 60;
        sessionFlowHeightConstraint.constant = 60;
        sessionTypeContainer.hidden = false;
        sessionFlowContainer.hidden = false;

    }else{
        sessionTypeHeightConstraint.constant = 0;
        sessionFlowHeightConstraint.constant = 0;
        sessionTypeContainer.hidden = true;
        sessionFlowContainer.hidden = true;
        sessionTypeContainer.clipsToBounds = true;
        sessionFlowContainer.clipsToBounds = true;
    }
    [self getExerciseSessions];
    NSString *locationString = [[sessionData objectForKey:@"ExerciseLocation"] stringValue];
    if (![Utility isEmptyCheck:locationString]) {
        NSDictionary *selectedExerciseLocationDict = [self getDictByValue:locationArray value:locationString type:@"Key"];
        if (![Utility isEmptyCheck:selectedExerciseLocationDict]) {
            location.text = [selectedExerciseLocationDict valueForKey:@"Value"];
        }else{
            location.text = @"Select a Location";
        }
    }else{
        location.text = @"Select a Location";
    }
}
-(NSDictionary *)getDictByValue:(NSArray *)filterArray value:(id)value type:(NSString *)type{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",type, value];
    NSArray *filteredSessionCategoryArray = [filterArray filteredArrayUsingPredicate:predicate];
    if (filteredSessionCategoryArray.count > 0) {
        NSDictionary *dict = [filteredSessionCategoryArray objectAtIndex:0];
        return dict;
    }
    return  nil;
}
-(void)getExerciseSessions{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetExerciseSessionsApiCall" append:[@"?" stringByAppendingFormat:@"userId=%@&courseId=%@&weekNum=%@&category=%@&sessionTypeId=%@&sessionFlowId=%@", [defaults objectForKey:@"ABBBCOnlineUserId"],[defaults objectForKey:@"CourseID"],[NSNumber numberWithInt: weekNumber ],[Utility isEmptyCheck:[sessionData objectForKey:@"SessionCategory"]]? @"" :[sessionData objectForKey:@"SessionCategory"],[Utility isEmptyCheck:[sessionData objectForKey:@"SessionType"]]? @"" :[sessionData objectForKey:@"SessionType"],[Utility isEmptyCheck:[sessionData objectForKey:@"SessionFlow"]]? @"" :[sessionData objectForKey:@"SessionFlow"]] forAction:@"GET"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
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
                                                                         workoutSessionArray = [responseDictionary objectForKey:@"obj"];
                                                                         if (workoutSessionArray.count > 0) {
                                                                             NSString *workoutSessionString = [[sessionData objectForKey:@"ExerciseSessionId"] stringValue];
                                                                             if (![Utility isEmptyCheck:workoutSessionString]) {
                                                                                 NSDictionary *selectedWorkoutSessionDict = [self getDictByValue:workoutSessionArray value:[sessionData objectForKey:@"ExerciseSessionId"] type:@"ExerciseSessionId"];
                                                                                 if (![Utility isEmptyCheck:selectedWorkoutSessionDict]) {
                                                                                     workoutSession.text = [selectedWorkoutSessionDict valueForKey:@"SessionTitle"];
                                                                                     if ([[sessionData objectForKey:@"SessionCategory"] intValue] == 1 || [[sessionData objectForKey:@"SessionCategory"] intValue] == 4) {
                                                                                         personalizeHeightConstraint.constant = 60;
                                                                                         personalizeContainer.hidden = false;
                                                                                     }else{
                                                                                         personalizeHeightConstraint.constant = 0;
                                                                                         personalizeContainer.hidden = true;
                                                                                     }
                                                                                 }else{
                                                                                     workoutSession.text = @"Select a Workout Session";
                                                                                     personalizeHeightConstraint.constant = 0;
                                                                                     personalizeContainer.hidden = true;
                                                                                 }
                                                                             }else{
                                                                                 workoutSession.text = @"Select a Workout Session";
                                                                                 personalizeHeightConstraint.constant = 0;
                                                                                 personalizeContainer.hidden = true;
                                                                             }
                                                                         }else{
                                                                             workoutSession.text = @"Select a Workout Session";
                                                                             personalizeHeightConstraint.constant = 0;
                                                                             personalizeContainer.hidden = true;
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
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
#pragma mark - IBAction -
- (IBAction)sessionCategoryButtonPressed:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = sessionCategoryArray;
        NSString *string = [[sessionData objectForKey:@"SessionCategory"] stringValue];
        if (![Utility isEmptyCheck:string]) {
            NSDictionary *selectedSessionCategoryDict = [self getDictByValue:sessionCategoryArray value:string type:@"Key"];
            if (![Utility isEmptyCheck:selectedSessionCategoryDict]) {
                controller.selectedIndex = (int)[sessionCategoryArray indexOfObject:selectedSessionCategoryDict];
            }else{
                controller.selectedIndex = -1;
            }
        }else{
            controller.selectedIndex = -1;
        }
        controller.mainKey = @"Value";
        controller.apiType = @"SessionCategory";
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
- (IBAction)sessionTypeButtonPressed:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = sessionTypeArray;
        NSString *string = [[sessionData objectForKey:@"SessionType"] stringValue];
        if (![Utility isEmptyCheck:string]) {
            NSDictionary *selectedSessionTypeDict = [self getDictByValue:sessionTypeArray value:string type:@"Key"];
            if (![Utility isEmptyCheck:selectedSessionTypeDict]) {
                controller.selectedIndex = (int)[sessionTypeArray indexOfObject:selectedSessionTypeDict];
            }else{
                controller.selectedIndex = -1;
            }
        }else{
            controller.selectedIndex = -1;
        }
        
        controller.mainKey = @"Value";
        controller.apiType = @"SessionType";
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
- (IBAction)sessionFlowButtonPressed:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = sessionFlowArray;
        NSString *string = [[sessionData objectForKey:@"SessionFlow"] stringValue];
        if (![Utility isEmptyCheck:string]) {
            NSDictionary *selectedSessionTypeDict = [self getDictByValue:sessionFlowArray value:string type:@"Key"];
            if (![Utility isEmptyCheck:selectedSessionTypeDict]) {
                controller.selectedIndex = (int)[sessionFlowArray indexOfObject:selectedSessionTypeDict];
            }else{
                controller.selectedIndex = -1;
            }
        }else{
            controller.selectedIndex = -1;
        }
        
        controller.mainKey = @"Value";
        controller.apiType = @"SessionFlow";
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
- (IBAction)workoutSessionButtonPressed:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = workoutSessionArray;
        NSString *string = [[sessionData objectForKey:@"ExerciseSessionId"] stringValue];
        if (![Utility isEmptyCheck:string]) {
            NSDictionary *selectedSessionCategoryDict = [self getDictByValue:workoutSessionArray value:[sessionData objectForKey:@"ExerciseSessionId"] type:@"ExerciseSessionId"];
            if (![Utility isEmptyCheck:selectedSessionCategoryDict]) {
                controller.selectedIndex = (int)[workoutSessionArray indexOfObject:selectedSessionCategoryDict];
            }else{
                controller.selectedIndex = -1;
            }
        }else{
            controller.selectedIndex = -1;
        }
        controller.mainKey = @"SessionTitle";
        controller.apiType = @"SessionTitle";
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
- (IBAction)locationButtonPressed:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = locationArray;
        NSString *string = [[sessionData objectForKey:@"ExerciseLocation"] stringValue];
        if (![Utility isEmptyCheck:string]) {
            NSDictionary *selectedExerciseLocationDict = [self getDictByValue:locationArray value:string type:@"Key"];
            if (![Utility isEmptyCheck:selectedExerciseLocationDict]) {
                controller.selectedIndex = (int)[locationArray indexOfObject:selectedExerciseLocationDict];
            }else{
                controller.selectedIndex = -1;
            }
        }else{
            controller.selectedIndex = -1;
        }
        
        controller.mainKey = @"Value";
        controller.apiType = @"ExerciseLocation";
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
- (IBAction)saveButtonPressed:(id)sender {

    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSError *error;

        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        if (isEdit) {
            [mainDict setObject:[sessionData objectForKey:@"Id"] forKey:@"UserExerciseSessionId"];
        }else{
            [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"UserExerciseSessionId"];
        }
        [mainDict setObject:[NSNumber numberWithInt:weekNumber] forKey:@"WeekNumber"];
        [mainDict setObject:[sessionData objectForKey:@"ExerciseSessionId"] forKey:@"ExerciseSessionId"];
        [mainDict setObject:startDate forKey:@"StartDate"];
        [mainDict setObject:[NSNumber numberWithInt:day+1] forKey:@"Day"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"CourseID"] forKey:@"CourseId"];

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateUserExerciseSessionApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
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
                                                                         if (isEdit) {
                                                                             [Utility msg:@"Session Updated Successfully" title:@"Error !" controller:self haveToPop:YES];
                                                                         }else{
                                                                             [Utility msg:@"New session Added Successfully." title:@"Error !" controller:self haveToPop:YES];
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
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)personalizeButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)viewDetailsButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)repeatButtonPressed:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = false;
    }else{
        sender.selected = true;
    }
    [sessionData setObject:[NSNumber numberWithBool:sender.selected] forKey:@"RepeatNextWeek"];
}
#pragma mark - End

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
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
        [mainScroll scrollRectToVisible:activeTextField.frame animated:YES];
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
    activeTextField = nil;
}

#pragma mark - Dropdown Deegate

- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)data{
    if ([type isEqualToString:@"SessionCategory"]) {
        [sessionData setObject:[numberFormatter numberFromString:[data valueForKey:@"Key"]] forKey:@"SessionCategory"];
        [sessionData removeObjectForKey:@"SessionType"];
        [sessionData removeObjectForKey:@"ExerciseSession"];
        [sessionData removeObjectForKey:@"ExerciseSessionId"];

        [self setupDropdown];
    }else if([type isEqualToString:@"SessionType"]){
        [sessionData setObject:[numberFormatter numberFromString:[data valueForKey:@"Key"]] forKey:@"SessionType"];
        [self setupDropdown];
    }else if([type isEqualToString:@"SessionFlow"]){
        [sessionData setObject:[numberFormatter numberFromString:[data valueForKey:@"Key"]] forKey:@"SessionFlow"];
        [self setupDropdown];
    }else if([type isEqualToString:@"SessionTitle"]){
        workoutSession.text = [data valueForKey:@"SessionTitle"];
        [sessionData setObject:[data valueForKey:@"SessionTitle"] forKey:@"SessionTitle"];
        [sessionData setObject:[data valueForKey:@"SessionTitle"] forKey:@"ExerciseSession"];
        [sessionData setObject:[data valueForKey:@"ExerciseSessionId"] forKey:@"ExerciseSessionId"];
        if ([[sessionData objectForKey:@"SessionCategory"] intValue] == 1 || [[sessionData objectForKey:@"SessionCategory"] intValue] == 4) {
            personalizeHeightConstraint.constant = 60;
            personalizeContainer.hidden = false;
        }else{
            personalizeHeightConstraint.constant = 0;
            personalizeContainer.hidden = true;
        }

    }else if([type isEqualToString:@"ExerciseLocation"]){
        location.text = [data valueForKey:@"Value"];
        [sessionData setObject:[numberFormatter numberFromString:[data valueForKey:@"Key"]] forKey:@"ExerciseLocation"];
    }


}

#pragma mark - End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
