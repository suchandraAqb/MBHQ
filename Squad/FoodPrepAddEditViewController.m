//
//  FoodPrepAddEditViewController.m
//  Squad
//
//  Created by aqbsol iPhone on 05/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "FoodPrepAddEditViewController.h"
#import "FoodPrepAddEditTableViewCell.h"
#import "Utility.h"
#import "foodPrepSearchTableViewCell.h"



@interface FoodPrepAddEditViewController (){

    IBOutlet UIButton *headerButton;
    IBOutlet UITextField *foodPrepName;
    IBOutlet UITableView *addTable;
    IBOutlet UIButton *saveNextButton;
    IBOutlet UIView *mealTableView;
    IBOutlet UITableView *mealTable;
    
    UIView *contentView;
    int apiCount;
    UIToolbar *toolBar;
    UITextField *activeTextField;
    NSMutableArray *mealArray;
    NSMutableArray *myMealsData;
    NSDateFormatter *dailyDateformatter;
    NSDate *weekDate;
    BOOL isEditing;
    NSNumber *mId;
    int pageNo;
    int selectMealPos;
    BOOL isChanged;
}
@end

@implementation FoodPrepAddEditViewController
@synthesize mealNameArray,isEdit,delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    apiCount = 0;
    pageNo = 1;
    isEditing = false;
    mealTableView.hidden = true;
    mealArray = [[NSMutableArray alloc]init];
    myMealsData = [[NSMutableArray alloc]init];
    mId = [[NSNumber alloc]init];
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [self registerForKeyboardNotifications];
    [addTable reloadData];
    if (!isEdit) {
        NSDictionary *tempFood = [[NSDictionary alloc]init];
        [myMealsData addObject:tempFood];
        [headerButton setTitle:@"ADD FOOD PREP" forState:UIControlStateNormal];
        foodPrepName.text = @"";
        mId = @0;
    }else{
        myMealsData = [mealNameArray mutableCopy];
        mId = myMealsData[0][@"Id"];
        [headerButton setTitle:@"EDIT FOOD PREP" forState:UIControlStateNormal];
        foodPrepName.text = [myMealsData objectAtIndex:0][@"FoodPrepName"];
    }
    NSDate* today = [NSDate date] ;
    weekDate = [[NSDate alloc]init];
    dailyDateformatter = [[NSDateFormatter alloc]init];
    [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dailyDateformatter stringFromDate:today];
    today = [dailyDateformatter dateFromString:dateString];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //[gregorian setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question. (If today is Sunday, subtract 0 days.)
     */
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:today];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    weekDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    //addTable.hidden = true;
    addTable.estimatedRowHeight = 135;
    addTable.rowHeight = UITableViewAutomaticDimension;
    mealTable.estimatedRowHeight = 45;
    mealTable.rowHeight = UITableViewAutomaticDimension;
    //[self getMealList];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitList:) name:@"backButtonPressed" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
}
#pragma mark - Local Notification Observer and delegate

-(void)quitList:(NSNotification *)notification{
    
    NSString *text = notification.object;
    
    
    if([text isEqualToString:@"homeButtonPressed"]){
        [self homeButtonPressed:0];
    }else{
        [self backButtonPressed:0];
    }
    
}
-(IBAction)homeButtonPressed:(UIButton*)sender{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    //add_new_7/8/17
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            if(([Utility isSubscribedUser] && [Utility isOfflineMode]) || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
                if (!isAllTaskCompleted ){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
//                    TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//                    GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                    AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Achievements"];
                    
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }
    }];
}
-(IBAction)backButtonPressed:(id)sender{
    // [self.navigationController popViewControllerAnimated:YES];
    //add_new_7/8/17
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            if ([delegate respondsToSelector:@selector(didCheckAnyChange:)]) {
                [delegate didCheckAnyChange:isChanged];
            }
            [self.navigationController  popViewControllerAnimated:YES];
        }
    }];
}
- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {
    if (isEditing) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Save Changes"
                                              message:@"Your changes will be lost if you don’t save them."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Save"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       BOOL valid = [self validateMealData:NO];
                                       if (!valid) {
                                           return;
                                       }
                                       
                                       [self save:[self prepareForSave]];
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
    }else {
        //iOS 8 specific code here
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }else if (UIDeviceOrientationIsPortrait(orientation)){
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }
    }

//    CGPoint pointInTable = [activeTextField.superview convertPoint:activeTextField.frame.origin toView:addTable];
//    CGPoint contentOffset = addTable.contentOffset;
//
//    contentOffset.y = (pointInTable.y - activeTextField.inputAccessoryView.frame.size.height);
//
//    NSLog(@"contentOffset is: %@", NSStringFromCGPoint(contentOffset));
//
//    [addTable setContentOffset:contentOffset animated:YES];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height<50?kbSize.height:kbSize.height-120, 0.0);
    addTable.contentInset = contentInsets;
    addTable.scrollIndicatorInsets = contentInsets;

    if (activeTextField !=nil) {
        CGRect aRect = addTable.frame;
        CGRect frame = [addTable convertRect:activeTextField.frame fromView:activeTextField.superview];
        aRect.size.height -= kbSize.height-150;
        if (!CGRectContainsPoint(aRect,frame.origin) ) {
            [addTable scrollRectToVisible:frame animated:YES];
        }
    }
//    else if (activeTextView !=nil) {
//        CGRect aRect = addTable.frame;
//        CGRect frame = [addTable convertRect:activeTextView.frame fromView:activeTextView.superview];
//        aRect.size.height -= kbSize.height;
//        if (!CGRectContainsPoint(aRect,frame.origin) ) {
//            [addTable scrollRectToVisible:frame animated:YES];
//        }
//    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    addTable.contentInset = contentInsets;
    addTable.scrollIndicatorInsets = contentInsets;
    
}
#pragma mark - End

#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField setInputAccessoryView:toolBar];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    isEditing = true;
    activeTextField = textField;
//    activeTextView = nil;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    [formatter setMaximumFractionDigits:2];
//    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    if ([textField isEqual:foodPrepName]) {
        if (![Utility isEmptyCheck:textField.text]) {
            [self.view endEditing:true];
            return;
        }else{
            [Utility msg:@"Food Prep Title cannot be blank." title:@"Warning !" controller:self haveToPop:NO];
            return;
            
        }
    }else if([textField.accessibilityHint isEqualToString:@"quantity"]){
        if (![Utility isEmptyCheck:textField.text]){
            if ([textField.text intValue] < 1) {
                textField.text = @"";
                [Utility msg:@"Please enter valid quantity." title:@"Warning !" controller:self haveToPop:NO];
                return;
            } else {
                [self.view endEditing:true];
                NSMutableDictionary *dict = [myMealsData[textField.tag]mutableCopy];
                [dict setValue:[NSNumber numberWithInt:[textField.text intValue]] forKey:@"Quantity"];
                [myMealsData removeObjectAtIndex:textField.tag];
                [myMealsData insertObject:dict atIndex:textField.tag];
                [addTable reloadData];
                return;
            }
        }
//        else{
//            [Utility msg:@"Please enter valid quantity." title:@"Warning !" controller:self haveToPop:NO];
//            return;
//        }
    }else if([textField.accessibilityHint isEqualToString:@"calorie"]){
        if (![Utility isEmptyCheck:textField.text]){
            if ([textField.text floatValue] <= 0) {
                textField.text = @"";
                [Utility msg:@"Please enter valid calorie." title:@"Warning !" controller:self haveToPop:NO];
                return;
            } else {
                [self.view endEditing:true];
                NSMutableDictionary *dict = [myMealsData[textField.tag]mutableCopy];
                [dict setValue:[NSNumber numberWithFloat:[textField.text floatValue]] forKey:@"Calories"];
                [myMealsData removeObjectAtIndex:textField.tag];
                [myMealsData insertObject:dict atIndex:textField.tag];
                [addTable reloadData];
                return;
            }
        }
//        else{
//            [Utility msg:@"Please enter valid calorie." title:@"Warning !" controller:self haveToPop:NO];
//            return;
//        }
    }
    
}
#pragma mark - End
#pragma mark -IB Action
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
- (IBAction)mealNamePressed:(UIButton *)sender {
    [self.view endEditing:true];
   /* mealTableView.hidden = false;
    mealTableView.accessibilityHint = [NSString stringWithFormat:@"%d",(int)sender.tag];
    [mealTable reloadData];*/
//    if(mealArray.count > 0){
//        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
//        controller.modalPresentationStyle = UIModalPresentationCustom;
//        controller.dropdownDataArray = mealArray;
//        controller.mainKey = @"MealName";
//        controller.apiType = @"MealName";
////        if ([sender.titleLabel.text isEqualToString:@"Select Meal"]) {
////            controller.selectedIndex =-1;
////        } else {
////            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealName == %@)",myMealsData[sender.tag][@"MealName"] ];
////            NSArray *filteredArray = [mealArray filteredArrayUsingPredicate:predicate];
////            NSLog(@"%lu",(unsigned long)[mealArray indexOfObject:filteredArray]);
////            controller.selectedIndex = (int)[mealArray indexOfObject:filteredArray];
////        }
//        controller.selectedIndex =-1;
//        controller.sender = sender;
//        controller.delegate = self;
//        [self presentViewController:controller animated:YES completion:nil];
//
//    }
    isEditing = true;
    selectMealPos = (int)sender.tag;
    MealSwapDropDownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealSwapDropDownView"];
    controller.isFromFoodPrep = YES;
    controller.delegate = self;
    controller.controllerNeedToUpdate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (IBAction)deleteButtonPressed:(UIButton *)sender {
     isEditing = true;
    [myMealsData removeObjectAtIndex:sender.tag];
    [addTable reloadData];
}
- (IBAction)viewButtonPressed:(UIButton *)sender {
    NSDictionary *dict = myMealsData[sender.tag];
    if (![Utility isEmptyCheck:dict]) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
        FoodPrepAddEditTableViewCell *cell = (FoodPrepAddEditTableViewCell *)[addTable cellForRowAtIndexPath:indexPath];
        NSNumber *cal = ![Utility isEmptyCheck:[NSNumber numberWithInt:[cell.mealCalorie.text intValue]]]?[NSNumber numberWithInt:[cell.mealCalorie.text intValue]]:@0;
        
        DailyGoodnessDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyGoodnessDetail"];
        if (!isEdit) {
            controller.mealId = dict[@"Id"];
        }else{
            controller.mealId = dict[@"MealId"];
        }
//        controller.mealId = dict[@"Id"];
        controller.mealSessionId = ![Utility isEmptyCheck:dict[@"MealSessionId"]]?dict[@"MealSessionId"]:@0;
        controller.fromController = @"Food Prep";
        controller.Calorie = cal;
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [Utility msg:@"Select meal first" title:@" " controller:self haveToPop:NO];
    } 
}
- (IBAction)searchButtonPressed:(UIButton *)sender {
    selectMealPos = (int)sender.tag;
    FoodPrepSearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrepSearch"];
    controller.delegate=self;
    controller.sender = sender;
    controller.isFromFoodPrep = YES;
    controller.delegate = self;
    //controller.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (IBAction)addMealPressed:(UIButton *)sender {

    BOOL valid = [self validateMealData:NO];
    if (!valid) {
        return;
    }
    NSDictionary *tempFood = [[NSDictionary alloc]init];
    [myMealsData addObject:tempFood];
    
    [addTable reloadData];
    
}
- (IBAction)cancelPressed:(UIButton *)sender {
    mealTableView.hidden = true;
}
- (IBAction)saveAndNextPressed:(UIButton *)sender {
    BOOL valid = [self validateMealData:NO];
    if (!valid) {
        return;
    }
    
    [self save:[self prepareForSave]];
}
-(NSDictionary *)prepareForSave{

    NSMutableDictionary *mainDict = [[NSMutableDictionary alloc]init];
    NSMutableArray *MealQuantityArray = [[NSMutableArray alloc]init];
    NSMutableArray *FoodPrepMealSessionCalorieArray = [[NSMutableArray alloc]init];
    NSNumber *fpId;
    if (!isEdit) {
        fpId = @-1;
    }else{
        fpId = mId;
    }
    
    [mainDict setObject:fpId forKey:@"Id"];
    [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
    [mainDict setObject:[NSNumber numberWithInt:1] forKey:@"NoOfMeal"];
    [mainDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"Calories"];
    [mainDict setObject:[dailyDateformatter stringFromDate:weekDate] forKey:@"WeekDate"];
    [mainDict setObject:[dailyDateformatter stringFromDate:[NSDate date]] forKey:@"Datetime"];
    [mainDict setObject:@"" forKey:@"MealName"];
    [mainDict setObject:[NSNumber numberWithInt:1] forKey:@"MealId"];
    [mainDict setObject:[NSNumber numberWithInt:1] forKey:@"Quantity"];
    [mainDict setObject:[NSNumber numberWithInt:1] forKey:@"PrepId"];
    [mainDict setObject:[NSString stringWithFormat:@"%@",foodPrepName.text] forKey:@"FoodPrepName"];
    [mainDict setObject:[NSNumber numberWithInt:1] forKey:@"NoOfMealType"];
    [mainDict setObject:[NSNumber numberWithInt:1] forKey:@"MealClassifiedId"];
    [mainDict setObject:[NSNumber numberWithInt:1] forKey:@"MealSessionId"];
    int i = 1;
    for (NSDictionary *temp in myMealsData) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//        [dict setValue:temp[@"Id"] forKey:@"MealId"];
        if (!isEdit) {
            [dict setValue:temp[@"Id"] forKey:@"MealId"];
        }else{
            [dict setValue:temp[@"MealId"] forKey:@"MealId"];
        }
        [dict setValue:temp[@"Quantity"] forKey:@"Quantity"];
        [dict setValue:temp[@"Calories"] forKey:@"Calories"];
        [MealQuantityArray addObject:dict];
        [FoodPrepMealSessionCalorieArray addObject:[NSNumber numberWithInt:i]];
        i++;
    }
    [mainDict setObject:MealQuantityArray forKey:@"MealQuantity"];
    [mainDict setObject:FoodPrepMealSessionCalorieArray forKey:@"FoodPrepMealSessionCalorie"];
    
    return mainDict;
}
#pragma mark -End
#pragma -mark DropDownViewDelegate
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData sender:(UIButton *)sender{
    if ([type caseInsensitiveCompare:@"MealName"] == NSOrderedSame) {
        isEditing = true;
//        [sender setTitle:[selectedData objectForKey:@"MealName"] forState:UIControlStateNormal];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [selectedData mutableCopy];
        [dict setObject:dict[@"Id"] forKey:@"MealId"];
        [myMealsData replaceObjectAtIndex:sender.tag withObject:dict];
//        [myMealsData removeObjectAtIndex:sender.tag];
//        [myMealsData addObject:dict];
        [addTable reloadData];
    }
}

#pragma -mark End
#pragma mark - AdvanceSearch Delegate

-(void)didSelectSearchOption:(NSMutableDictionary *)searchDict sender:(UIButton *)sender{
    isEditing = true;
    if (![Utility isEmptyCheck:searchDict]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [searchDict mutableCopy];
        [dict setObject:dict[@"Id"] forKey:@"MealId"];
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"Quantity"];
        [dict setObject:dict[@"CalsTotal"] forKey:@"Calories"];
        [myMealsData replaceObjectAtIndex:selectMealPos withObject:dict];
        [addTable reloadData];
    }
}
#pragma mark - End

#pragma mark - MealSwapDropDown Delegate
-(void)didSelectMeal:(NSDictionary *)mealDict{
    if(![Utility isEmptyCheck:mealDict[@"MealDetail"]]){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [mealDict[@"MealDetail"] mutableCopy];
        [dict setObject:dict[@"Id"] forKey:@"MealId"];
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"Quantity"];
        [myMealsData replaceObjectAtIndex:selectMealPos withObject:dict];
        //[addTable reloadData];
        [self getMealCalorie:dict[@"Id"] pos:selectMealPos];
    }
    
    
}
#pragma mark - End

#pragma mark -Private Methods
-(void)getMealList{
    if (Utility.reachable) {
        apiCount++;
        if (pageNo == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (contentView) {
                    [contentView removeFromSuperview];
                }
                contentView = [Utility activityIndicatorView:self];
            });
        }
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:pageNo] forKey:@"PageNo"];
        [mainDict setObject:[NSNumber numberWithInt:20] forKey:@"ItemsPerPage"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMealList" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:responseDict[@"GetSquadUserWeeklyFoodPrepList"]]) {
                                                                             NSArray *tempMealArray = responseDict[@"GetSquadUserWeeklyFoodPrepList"];
                                                                             tempMealArray = [[tempMealArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(MealName != %@ and MealName != %@)",@"",@" "]]mutableCopy];
                                                                             [mealArray addObjectsFromArray:tempMealArray];
                                                                             if (mealArray.count>0) {
                                                                                 [mealTable reloadData];
                                                                             }
                                                                             [addTable reloadData];
                                                                             addTable.hidden = false;
                                                                         } else {
                                                                             
                                                                         }
                                                                     }
                                                                     else{
                                                                         pageNo--;
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     pageNo--;
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
-(void)getMealCalorie:(NSNumber *)mealId pos:(int)pos{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealId forKey:@"MealId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMealCalorie" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:responseDict[@"MealCalorie"]]) {
                                                                             NSMutableDictionary *dict = [myMealsData[pos]mutableCopy];
                                                                             [dict setObject:responseDict[@"MealCalorie"] forKey:@"Calories"];
                                                                             [myMealsData replaceObjectAtIndex:pos withObject:dict];
                                                                             [addTable reloadData];
                                                                             mealTableView.hidden = true;
                                                                         }
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
-(void)save:(NSDictionary *)myDict{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
//        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:myDict forKey:@"SquadUserWeeklyFoodPrepModel"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddSquadUserWeeklyFoodPrep" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->isChanged = true;
                                                                         if ([delegate respondsToSelector:@selector(didCheckAnyChange:)]) {
                                                                             [delegate didCheckAnyChange:isChanged];
                                                                         }
                                                                         [Utility msg:@"Saved Successfully" title:@" " controller:self haveToPop:YES];
                                                                         
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
-(BOOL)validateMealData:(BOOL)pop{
    [self.view endEditing:YES];
    if ([Utility isEmptyCheck:foodPrepName.text]) {
        [Utility msg:@"Food Prep Title cannot be blank." title:@"Warning !" controller:self haveToPop:NO];
        return false;
    }
    for (NSDictionary *tempMealData in myMealsData) {
        if (![Utility isEmptyCheck:tempMealData]) {
            BOOL valid = true;
            int clasifiedId = [tempMealData[@"MealClassifiedID"] intValue];
            if ([Utility isEmptyCheck:tempMealData[@"MealName"]]) {
                valid = false;
            }else if(([Utility isEmptyCheck:tempMealData[@"Calories"]] || [tempMealData[@"Calories"]floatValue]<=0) && clasifiedId !=2){
                valid = false;
            }else if([Utility isEmptyCheck:tempMealData[@"Quantity"]] || [tempMealData[@"Quantity"]intValue]<1){
                valid = false;
            }
            if (!valid) {
                [Utility msg:@"Please fill all the required fields first." title:@"Warning !" controller:self haveToPop:NO];
                return false;
            }
        }else{
            [Utility msg:@"Please fill all the required fields first." title:@"Warning !" controller:self haveToPop:NO];
            return false;
        }
    }
    return true;
}
#pragma mark -End
#pragma mark -TableView DataSource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:mealTable]) {
        return mealArray.count;
    } else {
        return myMealsData.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell;
    if ([tableView isEqual:mealTable]) {
        foodPrepSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodPrepSearchTableViewCell"];
        NSDictionary *dict = mealArray[indexPath.row];
        cell.mealNameLabel.text = ![Utility isEmptyCheck:dict[@"MealName"]]?dict[@"MealName"]:@"";
        
        tableCell = cell;
    } else {
        FoodPrepAddEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodPrepAddEditTableViewCell"];
        NSDictionary *dict = myMealsData[indexPath.row];
        NSString *mealName = ![Utility isEmptyCheck:dict[@"MealName"]]?dict[@"MealName"]:@"Select Meal";
        [cell.mealName setTitle:@"" forState:UIControlStateNormal];
        cell.mealNameLabel.text = mealName;
        cell.mealQuantity.text = [NSString stringWithFormat:@"%d",![Utility isEmptyCheck:dict[@"Quantity"]] ? [dict[@"Quantity"] intValue]:0];
        cell.mealCalorie.text = [NSString stringWithFormat:@"%g",![Utility isEmptyCheck:dict[@"Calories"]]?[dict[@"Calories"]floatValue]:0];
        
        if (myMealsData.count > 1) {
            cell.deleteButton.hidden = false;
        }else{
            cell.deleteButton.hidden = true;
        }
        int clasifiedId = 0;
        if(![Utility isEmptyCheck:dict[@"MealClassifiedID"]]){
            clasifiedId = [dict[@"MealClassifiedID"] intValue];
        }else if(![Utility isEmptyCheck:dict[@"MealClassifiedId"]]){
            clasifiedId = [dict[@"MealClassifiedId"] intValue];
        }
        
        if(clasifiedId == 2){
            cell.unmeasuredButton.hidden = false;
            cell.mealCalorie.userInteractionEnabled = false;
            cell.mealCalorie.text = @"";
            cell.mealCalorie.placeholder = @"";
        }else{
            cell.unmeasuredButton.hidden = true;
            cell.mealCalorie.userInteractionEnabled = true;
            cell.mealCalorie.placeholder = @"0";
        }
        
        cell.mealName.tag = indexPath.row;
        cell.mealQuantity.tag = indexPath.row;
        cell.mealCalorie.tag = indexPath.row;
        cell.mealViewButton.tag = indexPath.row;
        cell.searchButton.tag = indexPath.row;
        cell.deleteButton.tag = indexPath.row;
        cell.mealQuantity.accessibilityHint = @"quantity";
        cell.mealCalorie.accessibilityHint = @"calorie";
        tableCell = cell;
    }
    
    return tableCell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![Utility isEmptyCheck:mealArray] && mealArray.count>0){
        if(indexPath.row == mealArray.count-1){
            pageNo=pageNo+1;
            [self getMealList];
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:mealTable]) {
        isEditing = true;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [mealArray[indexPath.row] mutableCopy];
        [dict setObject:dict[@"Id"] forKey:@"MealId"];
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"Quantity"];
        [myMealsData replaceObjectAtIndex:[mealTableView.accessibilityHint intValue] withObject:dict];
        [self getMealCalorie:dict[@"Id"] pos:[mealTableView.accessibilityHint intValue]];
//        [addTable reloadData];
    }
}
#pragma mark -End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End

#pragma mark - DailyGoodnessViewDelegate

-(void)didCheckAnyChangeForDailyGoodness:(BOOL)ischanged{
    isChanged = ischanged;
}
#pragma mark - End

#pragma mark - FoodPrepSearchViewDelegate

-(void)didCheckAnyChangeForFoodPrepSearch:(BOOL)ischanged{
    isChanged= ischanged;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
