//
//  CreateMyHealthyHabitListViewController.m
//  Squad
//
//  Created by MAC 6- AQB SOLUTIONS on 27/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CreateMyHealthyHabitListViewController.h"

@interface CreateMyHealthyHabitListViewController (){
    IBOutlet UIButton *saveButton;
    IBOutlet UITextField *nameTextField;
    IBOutlet UIButton *goalButton;
    IBOutlet UIButton *categoryButton;
    IBOutlet UIButton *checkTypeButton;
    IBOutlet UIView *specificDaysView;
    IBOutlet UIButton *selectDayButton;
    IBOutlet UIView *selectDayView;
    IBOutletCollection(UIButton) NSArray *daysButtons;
    IBOutlet UIScrollView *mainScroll;
    IBOutlet NSLayoutConstraint *saveButtonTopConstraint;
    
    UIView *contentView;
    
    
     NSArray *dayArray;
//    NSMutableDictionary *dayDict;
    NSMutableDictionary *resultDict;
    NSArray *goalArray;
    NSArray*categoryArray;
    NSMutableArray *selectDayArray;
    NSMutableArray *checkTypeArray;
    int apiCount;
     UIToolbar* numberToolbar;
    UITextField *activeTextField;
    int checkTypeIndex;
    int selectDayIndex;
    
    
    //AY 29112017
    IBOutletCollection(UIButton) NSArray *habitTypeButtons; //AY 29112017
    
    IBOutlet UIView *squadActionView; //AY 29112017
    IBOutlet UIButton *squadActionButton; //AY 29112017
    NSArray *squadHabitListArray;
    int actionTypeId;
    
    IBOutlet NSLayoutConstraint *habitLabelTopConstraint;
    //End
    

}

@end

@implementation CreateMyHealthyHabitListViewController
@synthesize delegate;

#pragma mark view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    dayArray = [[NSArray alloc]init];
    resultDict=[[NSMutableDictionary alloc] init];
    goalArray=[[NSArray alloc] init];
    categoryArray=[[NSArray alloc]init];
    selectDayArray=[[NSMutableArray alloc] init];
    checkTypeArray=[[NSMutableArray alloc] init];
    checkTypeIndex=-1;
    selectDayIndex=-1;
    
    for (UIButton  *daysButton in daysButtons) {
        daysButton.layer.cornerRadius = daysButton.frame.size.height/2;
        [daysButton setBackgroundImage:[UIImage imageNamed:@"ash_circle.png"] forState:UIControlStateNormal];
        [daysButton setBackgroundImage:[UIImage imageNamed:@"blue_circle.png"] forState:UIControlStateSelected];
    }
    
    NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
    dayArray = [newDateformatter weekdaySymbols];
    
    
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(doneWithFirstResponder)],nil];
    [numberToolbar sizeToFit];
    nameTextField.inputAccessoryView = numberToolbar;
    selectDayView.hidden=true;
    specificDaysView.hidden=true;
    saveButtonTopConstraint.constant=-60;

    [self habitTypeButtonPressed:habitTypeButtons[0]];
    
    [self registerForKeyboardNotifications];
    
    
}

-(void) viewDidAppear:(BOOL)animated{
    for (int i = 0; i < dayArray.count; i++) {
        [resultDict setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
    }
    
    for (int i=1;i<=30;i++) {
        [selectDayArray addObject:[NSString stringWithFormat:@"%d Day of Month",i]];
    }
    
    checkTypeArray = [@[@"Daily",@"Twice Daily",@"Weekly",@"Fortnightly",@"Monthly"] mutableCopy];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
       apiCount= 0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getGoalValueApiCAll];
        [self getCategoryApiCall];
        
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark End


#pragma mark - Private Methods
- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {
    BOOL hasSelectData = NO;
    NSString *nameStr = nameTextField.text;
    //NSString *goalStr=goalButton.titleLabel.text;
    NSString *categoryStr=categoryButton.titleLabel.text;
    NSString *checkTypeStr=checkTypeButton.titleLabel.text;
    NSString *selectDayStr=selectDayButton.titleLabel.text;
    
    
    if (![Utility isEmptyCheck:nameStr]) {
        hasSelectData = YES;
    }
//    else if (!([Utility isEmptyCheck:goalStr]||[goalStr isEqualToString:@"Select Goal"])) {
//        hasSelectData = YES;
//    }
    else if (!([Utility isEmptyCheck:categoryStr]||[categoryStr isEqualToString:@"Select Category"])) {
        hasSelectData = YES;
    }else if (!([Utility isEmptyCheck:checkTypeStr]||[checkTypeStr isEqualToString:@"Select Frequency"])) {
        hasSelectData = YES;
    }else if (!([Utility isEmptyCheck:selectDayStr] || [selectDayStr isEqualToString:@"Select Day"])) {
        hasSelectData = YES;
    }
    if (hasSelectData) {
        [Utility startFlashingbutton:saveButton];
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Save Changes"
                                              message:@"Your changes will be lost if you don’t save them."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Save"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       if ([self formvalidate]) {
                                           [self AddHabitListApiCall];
                                       }
                                       response(NO);
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Don't Save"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           response(YES);
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        response(YES);
    }
}
-(void)doneWithFirstResponder{
    [self.view endEditing:YES];
}

-(BOOL) formvalidate{
    BOOL isValid = NO;
    NSString *nameStr = nameTextField.text;
    //NSString *goalStr=goalButton.titleLabel.text;
    NSString *categoryStr=categoryButton.titleLabel.text;
    NSString *checkTypeStr=checkTypeButton.titleLabel.text;
    NSString *selectDayStr=selectDayButton.titleLabel.text;
    
    
    if ([Utility isEmptyCheck:nameStr]) {
        [Utility msg:@"Please enter Habit Name." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    }
//    else if ([Utility isEmptyCheck:goalStr]||[goalStr isEqualToString:@"Select Goal"] ) {
//        [Utility msg:@"Please select Goal." title:@"Oops!" controller:self haveToPop:NO];
//        return isValid;
//    }
    else if ([Utility isEmptyCheck:categoryStr]||[categoryStr isEqualToString:@"Select Category"] ) {
        [Utility msg:@"Please select Category." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    }else if ([Utility isEmptyCheck:checkTypeStr]||[checkTypeStr isEqualToString:@"Select Frequency"] ) {
        [Utility msg:@"Please select Frequency." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    }
    else if ([checkTypeStr isEqualToString:@"Monthly"] && [selectDayStr isEqualToString:@"Select Day"]) {
        [Utility msg:@"Please select Day." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    }
    return YES;
    
}

-(void)resetFormData{
   nameTextField.text = @"";
    checkTypeIndex = -1;
    selectDayIndex = -1;
    [Utility stopFlashingbutton:saveButton];
    
    for (UIButton *button in daysButtons){
        
        [button setSelected:NO];
        [resultDict setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:button.tag-1]];
    }
    
    
    if(![Utility isEmptyCheck:resultDict[@"CategoryId"]]){
        [resultDict removeObjectForKey:@"CategoryId"];
        [categoryButton setTitle:@"Select Category" forState:UIControlStateNormal];
    }
    
    if(![Utility isEmptyCheck:resultDict[@"GoalId"]]){
        [resultDict removeObjectForKey:@"GoalId"];
        [goalButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    if(![Utility isEmptyCheck:resultDict[@"DayNumber"]]){
        [resultDict removeObjectForKey:@"DayNumber"];
        [selectDayButton setTitle:@"Select Day" forState:UIControlStateNormal];
    }
    
    if(![Utility isEmptyCheck:resultDict[@"HabitTypeId"]]){
        [resultDict removeObjectForKey:@"HabitTypeId"];
        [checkTypeButton setTitle:@"Select Frequency" forState:UIControlStateNormal];
    }
    
    if(![Utility isEmptyCheck:resultDict[@"ActionId"]]){
        [resultDict removeObjectForKey:@"ActionId"];
        [squadActionButton setTitle:@"Choose Squad Action" forState:UIControlStateNormal];
        
    }
    
    selectDayView.hidden=true;
    specificDaysView.hidden=true;
    saveButtonTopConstraint.constant=-60;
}

#pragma mark End



#pragma mark IBAction

- (IBAction)cancelButtonPressed:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)daysButtonTapped:(UIButton *)sender {
   // if(actionTypeId == 0) return;
    
    [nameTextField resignFirstResponder];
    if (sender.isSelected) {
        [sender setSelected:NO];
        [resultDict setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:sender.tag-1]];
    } else {
        [sender setSelected:YES];
        [resultDict setObject:[NSNumber numberWithBool:true] forKey:[dayArray objectAtIndex:sender.tag-1]];
    }
    NSLog(@"\n resultDict: \n%@",resultDict);
}


- (IBAction)goalButtonPressed:(UIButton *)sender {
    //if(actionTypeId == 0) return;
    int goalId = [[resultDict objectForKey:@"GoalId"] intValue];
    int selectedIndex = -1;
    for (int i = 0; i < goalArray.count; i++) {
        int gid = [[[goalArray objectAtIndex:i] objectForKey:@"id"] intValue];
        if (gid == goalId) {
            selectedIndex = i;
        }
    }

    
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = goalArray;
    controller.mainKey = @"Name";
    controller.apiType = @"goalValue";
    controller.selectedIndex = selectedIndex;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)categoryButtonPressed:(UIButton *)sender {
   // if(actionTypeId == 0) return;
    [nameTextField resignFirstResponder];
    int catID = [[resultDict objectForKey:@"CategoryId"] intValue];
    int selectedIndex = -1;
    for (int i = 0; i < categoryArray.count; i++) {
        int cid = [[[categoryArray objectAtIndex:i] objectForKey:@"id"] intValue];
        if (cid == catID) {
            selectedIndex = i;
        }
    }
    
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = categoryArray;
    controller.mainKey = @"CategoryName";
    controller.apiType = @"Category";
    controller.selectedIndex = selectedIndex;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}


- (IBAction)checkTypeButtonPressed:(UIButton *)sender {
    //if(actionTypeId == 0) return;
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = checkTypeArray;
    controller.apiType = @"CheckType";
    controller.selectedIndex = checkTypeIndex;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}



- (IBAction)selectDayButtonPressed:(UIButton *)sender {
    //if(actionTypeId == 0) return;
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = selectDayArray;
    controller.apiType = @"SelectDay";
    controller.selectedIndex = selectDayIndex;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    if ([self formvalidate]) {
        [self AddHabitListApiCall];
    }
}

- (IBAction)chooseSquadActionPressed:(UIButton *)sender {
   
    [nameTextField resignFirstResponder];
    int saId = [[resultDict objectForKey:@"ActionId"] intValue];
    int selectedIndex = -1;
    for (int i = 0; i < squadHabitListArray.count; i++) {
        int sid = [[[squadHabitListArray objectAtIndex:i] objectForKey:@"Id"] intValue];
        if (sid == saId) {
            selectedIndex = i;
        }
    }
    
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = squadHabitListArray;
    controller.mainKey = @"ActionName";
    controller.apiType = @"SquadAction";
    controller.selectedIndex = selectedIndex;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}//AY 29112017

- (IBAction)habitTypeButtonPressed:(UIButton *)sender {
    
    if (sender.isSelected){
        return;
    }
    
    for(UIButton *button in habitTypeButtons){
       
        if(button == sender){
            button.selected = true;
            actionTypeId = (int)sender.tag;
        }else{
            button.selected = false;
        }
    }
    
    [self resetFormData];
    
    if(sender.tag == 0){
        
        if(!squadHabitListArray && squadHabitListArray.count == 0){
            [self getSquadActionHabitList_WebServiceCall];
        }
        
        //nameTextField.userInteractionEnabled = false;
        habitLabelTopConstraint.constant = 10.0;
        squadActionView.hidden = false;
        
    }else if(sender.tag == 1){
        //nameTextField.userInteractionEnabled = true;
        habitLabelTopConstraint.constant = -65.0;
        squadActionView.hidden = true;
        
        
    }else{
        
    }
    
}//AY 29112017



#pragma mark End

#pragma mark API Call
- (void) getGoalValueApiCAll {     //ahln
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetGoalListAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   apiCount--;
                                                                   if (contentView && apiCount == 0) {
                                                                       [contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           goalArray = [responseDictionary objectForKey:@"Details"];
                                                      

                                                                           
                                                                       }
                                                                                                                                            else{
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


-(void) getCategoryApiCall {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        //        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetCategoryAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   apiCount--;
                                                                   if (contentView && apiCount == 0) {
                                                                       [contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           
                                                                           categoryArray = [responseDictionary objectForKey:@"Details"];
                                                                           
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


-(void) AddHabitListApiCall {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        [resultDict setObject:nameTextField.text forKey:@"HabitName"];
//        [resultDict setObject:[NSNumber numberWithInt:1] forKey:@"HabitTypeId"];
        
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"AbbbcSessionId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserID"];
        [mainDict setObject:resultDict forKey:@"HabitDetail"];
        //[mainDict setObject:[NSNumber numberWithInt:actionTypeId] forKey:@"Type"];
        [mainDict setObject:[NSNumber numberWithInt:1] forKey:@"Type"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddHabitList" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   apiCount--;
                                                                   if (contentView && apiCount == 0) {
                                                                       [contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                           [Utility stopFlashingbutton:saveButton];
                                                                           UIAlertController* alert = [UIAlertController
                                                                                                       alertControllerWithTitle:@"Success !"
                                                                                                       message:@"Habit created successfully."
                                                                                                       preferredStyle:UIAlertControllerStyleAlert];
                                                                           UIAlertAction* button1 = [UIAlertAction
                                                                                                     actionWithTitle:@"Ok"
                                                                                                     style:UIAlertActionStyleDefault
                                                                                                     handler:^(UIAlertAction * action)
                                                                                                     {
                                                                                                         [self dismissViewControllerAnimated:YES completion:^{
                                                                                                                                                        if ([delegate respondsToSelector:@selector         (creationCompleted)]) {
                                                                                                                 [delegate creationCompleted];
                                                                                                             }
                                                                                                         }];
                                                                                                         
                                                                                                      }];
                                                                           [alert addAction:button1];
                                                                           [self presentViewController:alert animated:YES completion:nil];
                                                                           
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

-(void)getSquadActionHabitList_WebServiceCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadActionList" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   apiCount--;
                                                                   if (contentView && apiCount == 0) {
                                                                       [contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           
                                                                           squadHabitListArray = [responseDictionary objectForKey:@"Details"];
                                                                           
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


#pragma mark End

#pragma mark - Dropdown Delegate

- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData{
    NSLog(@"ty %@ \ndata %@",type,selectedData);
//    isChanged = YES;
    
    if ([type caseInsensitiveCompare:@"Category"] == NSOrderedSame) {
        [categoryButton setTitle:[selectedData objectForKey:@"CategoryName"] forState:UIControlStateNormal];
        [resultDict setObject:[selectedData objectForKey:@"id"] forKey:@"CategoryId"];
        [Utility startFlashingbutton:saveButton];
        
    }
    else if ([type caseInsensitiveCompare:@"goalValue"] == NSOrderedSame){
        [goalButton setTitle:[selectedData objectForKey:@"Name"] forState:UIControlStateNormal];
        [resultDict setObject:[[selectedData objectForKey:@"id"] stringValue] forKey:@"GoalId"];
        [Utility startFlashingbutton:saveButton];
        
    }else if ([type caseInsensitiveCompare:@"SquadAction"] == NSOrderedSame){
        [squadActionButton setTitle:[selectedData objectForKey:@"ActionName"] forState:UIControlStateNormal];
        [resultDict setObject:[[selectedData objectForKey:@"Id"] stringValue] forKey:@"ActionId"];
        [Utility startFlashingbutton:saveButton];
        
        int frequencyId = [[selectedData objectForKey:@"FrequencyId"] intValue];
        
        int categoryId = [[selectedData objectForKey:@"CategoryId"] intValue];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %d",categoryId];
        NSArray *filterArray = [categoryArray filteredArrayUsingPredicate:predicate];
        
        
        if(![Utility isEmptyCheck:filterArray]){
            NSDictionary *catDict = [filterArray firstObject];
            [categoryButton setTitle:[catDict objectForKey:@"CategoryName"] forState:UIControlStateNormal];
            [resultDict setObject:[catDict objectForKey:@"id"] forKey:@"CategoryId"];
        }
        
        
        
        
        if (![Utility isEmptyCheck:selectedData[@"ActionName"]]){
            nameTextField.text = selectedData[@"ActionName"];
        }
        [self tagSelected:frequencyId-1 type:@"CheckType"];
        
        if (frequencyId == 3 || frequencyId == 4){
            
            for (UIButton *button in daysButtons){
                
                if(![Utility isEmptyCheck:[selectedData objectForKey:button.accessibilityHint]]){
                    button.selected = [[selectedData objectForKey:button.accessibilityHint] boolValue];
                }else{
                    button.selected = false;
                }
            }
            
        }else if (frequencyId == 5){
            int dayNumber = [[selectedData objectForKey:@"DayNumber"] intValue];
            [self tagSelected:dayNumber-1 type:@"SelectDay"];
        }
        
    }
    
    NSLog(@"\n%@",resultDict);
}


- (void) tagSelected:(int)index type:(NSString *)type{

    if ([type caseInsensitiveCompare:@"CheckType"] == NSOrderedSame) {
        checkTypeIndex=index;
        [checkTypeButton setTitle:[checkTypeArray objectAtIndex:index] forState:UIControlStateNormal];
        [resultDict setObject:[NSNumber numberWithInt:index+1] forKey:@"HabitTypeId"];
        
        if (index==0 || index==1) {
            selectDayView.hidden=true;
            specificDaysView.hidden=true;
            saveButtonTopConstraint.constant=-60;
        }
        else if (index==2 || index==3){
            selectDayView.hidden=true;
            specificDaysView.hidden=false;
            saveButtonTopConstraint.constant=10;
        }
        else if (index==4){
            specificDaysView.hidden=true;
            selectDayView.hidden=false;
            saveButtonTopConstraint.constant=10;
        }
    }
    else if ([type caseInsensitiveCompare:@"SelectDay"] == NSOrderedSame){
        selectDayIndex=index;
        [selectDayButton setTitle:[selectDayArray objectAtIndex:index] forState:UIControlStateNormal];
        [resultDict setObject:[NSNumber numberWithInt:index+1] forKey:@"DayNumber"];
    }
        NSLog(@"\n index = %d",index);
    //    NSLog(@"\n \n selected tag \n %@",[filteredTagListArray objectAtIndex:index]);
    NSLog(@"\n%@",resultDict);
}
#pragma mark End


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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    return YES;
}
#pragma Mark End





@end















