//
//  NutritionAdvanceSearchViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 20/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "NutritionAdvanceSearchViewController.h"
#import "Utility.h"
#import "DropdownViewController.h"

@interface NutritionAdvanceSearchViewController ()
{
    IBOutlet UIButton *glutenFreeButton;
    IBOutlet UIButton *dairyFreeButton;
    IBOutlet UIButton *noRedMeatButton;
    IBOutlet UIButton *lectoOvoButton;
    IBOutlet UIButton *pescatarinButton;
    IBOutlet UIButton *vegetarianVeganButton;
    IBOutlet UIButton *noSeafoodButton;
    IBOutlet UIButton *fodmapFriendlyButton;
    IBOutlet UIButton *paleoFriendlyButton;
    IBOutlet UIButton *noEggsButton;
    IBOutlet UIButton *noNutsButton;
    IBOutlet UIButton *noLegumesButton;
    IBOutlet UIScrollView *mainScroll;
    
    IBOutlet UITextField *minCalorieTextField;
    IBOutlet UITextField *maxCalorieTextField;
    IBOutlet UITextField *timetoMakeTextField;
    IBOutlet UIButton *IngredientsButton;
    IBOutlet UIButton *searchButton;
    IBOutlet UITextView *IngredientsTextView;
    
    UITextField *activeTextField;
    UIToolbar *toolBar;
    UITextView *activeTextView;
    
    NSMutableDictionary *searchDict;
    NSArray *ingredientsAllList;
    NSMutableArray *ingredientsArray;
    UIView *contentView;
    int vegeterian;
}
@end

@implementation NutritionAdvanceSearchViewController
@synthesize delegate;
#pragma mark - IBAction

-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
-(IBAction)serachButtonPressed:(id)sender{
    if (vegetarianVeganButton.isSelected) {
        [searchDict setObject:[NSNumber numberWithInt:3] forKey:@"Vegetarian"];
    }else if (lectoOvoButton.isSelected){
        [searchDict setObject:[NSNumber numberWithInt:2] forKey:@"Vegetarian"];
    }else if (pescatarinButton.isSelected){
        vegeterian =4;
        [searchDict setObject:[NSNumber numberWithInt:4] forKey:@"Vegetarian"];
    }else{
        [searchDict removeObjectForKey:@"Vegetarian"];
    }
    if (![Utility isEmptyCheck:searchDict]){
        [self dismissViewControllerAnimated:YES completion:^{
            if ([delegate respondsToSelector:@selector(didSelectSearchOption:)]) {
                [delegate didSelectSearchOption:searchDict];
            }
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)ingredientNameButtonPressed:(UIButton *)sender {
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = ingredientsAllList;
    controller.mainKey = @"IngredientName";
    controller.apiType = @"IngredientName";
    controller.selectedIndex = -1;
    NSLog(@"%d",controller.selectedIndex);
    controller.delegate = self;
    controller.sender = sender;
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if ([IngredientsTextView.text caseInsensitiveCompare:@""] != NSOrderedSame) {
        NSArray *titleArray = [IngredientsTextView.text componentsSeparatedByString:@", "];
        for (int i =0;i<titleArray.count;i++) {
            NSString *title = [titleArray objectAtIndex:i];
            for (int j = 0; j < ingredientsAllList.count; j++) {
                NSDictionary *dict = [ingredientsAllList objectAtIndex:j];
                if ([[dict objectForKey:@"IngredientName"] caseInsensitiveCompare:title] == NSOrderedSame) {
                    [array addObject:[NSNumber numberWithInteger:j]];
                }
            }
        }
        controller.selectedIndexes=array;
    }
    controller.multiSelect = true;
    [self presentViewController:controller animated:YES completion:nil];
}

-(IBAction)checkUncheckButtonPressed:(UIButton*)sender{
    if([sender isEqual:glutenFreeButton] ){
        glutenFreeButton.selected = !glutenFreeButton.isSelected;
        if (glutenFreeButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:glutenFreeButton.isSelected] forKey:@"GlutenFree"];
        }else{
            [searchDict removeObjectForKey:@"GlutenFree"];
        }
    }else if([sender isEqual:dairyFreeButton]){
        dairyFreeButton.selected = !dairyFreeButton.isSelected;
        if (dairyFreeButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:dairyFreeButton.isSelected] forKey:@"DairyFree"];
        }else{
            [searchDict removeObjectForKey:@"DairyFree"];
        }
    }else if([sender isEqual:noRedMeatButton]){
        noRedMeatButton.selected = !noRedMeatButton.isSelected;
        if (noRedMeatButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:noRedMeatButton.isSelected] forKey:@"NoRedMeat"];
        }else{
            [searchDict removeObjectForKey:@"NoRedMeat"];
        }
    }else if([sender isEqual:lectoOvoButton]){
        lectoOvoButton.selected = !lectoOvoButton.isSelected;
    }else if([sender isEqual:pescatarinButton]){
        pescatarinButton.selected = !pescatarinButton.isSelected;
    }
    else if([sender isEqual:vegetarianVeganButton]){
        vegetarianVeganButton.selected = !vegetarianVeganButton.isSelected;
    }
    else if([sender isEqual:noSeafoodButton]){
        noSeafoodButton.selected = !noSeafoodButton.isSelected;
        if (noSeafoodButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:noSeafoodButton.isSelected] forKey:@"NoSeaFood"];
        }else{
            [searchDict removeObjectForKey:@"NoSeaFood"];
        }
    }
    else if([sender isEqual:fodmapFriendlyButton]){
        fodmapFriendlyButton.selected = !fodmapFriendlyButton.isSelected;
        if (fodmapFriendlyButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:fodmapFriendlyButton.isSelected] forKey:@"FodmapFriendly"];
        }else{
            [searchDict removeObjectForKey:@"FodmapFriendly"];
        }
    }
    else if([sender isEqual:paleoFriendlyButton]){
        paleoFriendlyButton.selected = !paleoFriendlyButton.isSelected;
        if (paleoFriendlyButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:paleoFriendlyButton.isSelected] forKey:@"PaleoFriendly"];
        }else{
            [searchDict removeObjectForKey:@"PaleoFriendly"];
        }

    }
    else if([sender isEqual:noEggsButton]){
        noEggsButton.selected = !noEggsButton.isSelected;
        if (noEggsButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:noEggsButton.isSelected] forKey:@"NoEggs"];
        }else{
            [searchDict removeObjectForKey:@"NoEggs"];
        }
    }
    else if([sender isEqual:noNutsButton]){
        noNutsButton.selected = !noNutsButton.isSelected;
        if (noNutsButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:noNutsButton.isSelected] forKey:@"NoNuts"];
        }else{
            [searchDict removeObjectForKey:@"NoNuts"];
        }
    }
    else if([sender isEqual:noLegumesButton]){
        noLegumesButton.selected = !noLegumesButton.isSelected;
        if (noLegumesButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:noLegumesButton.isSelected] forKey:@"NoLegumes"];
        }else{
            [searchDict removeObjectForKey:@"NoLegumes"];
        }
    }

}
-(IBAction)crossButtonPressed:(id)sender{
     [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - End

#pragma mark - Private function


-(void)getIngredientsApiCall{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(),^ {
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetIngredientsApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else{
                                                                             ingredientsAllList = [responseDictionary objectForKey:@"Ingredients"];
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

-(void)setUpView{
    searchButton.layer.cornerRadius=5;
    
    minCalorieTextField.layer.cornerRadius=3.0f;
    minCalorieTextField.layer.masksToBounds=YES;
    minCalorieTextField.layer.borderColor=[[Utility colorWithHexString:@"c3c1c1"]CGColor];
    minCalorieTextField.layer.borderWidth= 1.0f;
    
    maxCalorieTextField.layer.cornerRadius=3.0f;
    maxCalorieTextField.layer.masksToBounds=YES;
    maxCalorieTextField.layer.borderColor=[[Utility colorWithHexString:@"c3c1c1"]CGColor];
    maxCalorieTextField.layer.borderWidth= 1.0f;
    
    timetoMakeTextField.layer.cornerRadius=3.0f;
    timetoMakeTextField.layer.masksToBounds=YES;
    timetoMakeTextField.layer.borderColor=[[Utility colorWithHexString:@"c3c1c1"]CGColor];
    timetoMakeTextField.layer.borderWidth= 1.0f;
    
    IngredientsButton.layer.cornerRadius=3.0f;
    IngredientsButton.layer.masksToBounds=YES;
    IngredientsButton.layer.borderColor=[[Utility colorWithHexString:@"c3c1c1"]CGColor];
    IngredientsButton.layer.borderWidth= 1.0f;
    
    UIView *paddingViewMinCal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    minCalorieTextField.leftView = paddingViewMinCal;
    minCalorieTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingViewMaxCal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    maxCalorieTextField.leftView = paddingViewMaxCal;
    maxCalorieTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    timetoMakeTextField.leftView = paddingView;
    timetoMakeTextField.leftViewMode = UITextFieldViewModeAlways;
    
}
#pragma mark - End

#pragma mark - view Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    mainScroll.layer.cornerRadius = 7;
    mainScroll.layer.masksToBounds = YES;
    searchDict =[[NSMutableDictionary alloc]init];
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];

    [self registerForKeyboardNotifications];
    [self getIngredientsApiCall];
}

#pragma mark - End

#pragma mark - Memory warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
    if (activeTextField !=nil) {
        CGRect aRect = mainScroll.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            [mainScroll scrollRectToVisible:activeTextField.frame animated:YES];
        }
    }else if (activeTextView !=nil) {
        CGRect aRect = mainScroll.frame;
        CGRect frame = [mainScroll convertRect:activeTextView.frame fromView:activeTextView.superview];
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect,frame.origin) ) {
            [mainScroll scrollRectToVisible:frame animated:YES];
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
    activeTextView = nil;
    textField.layer.cornerRadius=3.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[Utility colorWithHexString:@"88a9e0"]CGColor];
    textField.layer.borderWidth= 1.0f;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
    textField.layer.cornerRadius=3.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[Utility colorWithHexString:@"c3c1c1"]CGColor];
    textField.layer.borderWidth= 1.0f;
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    if ([textField isEqual:minCalorieTextField]) {
        if (minCalorieTextField.text.length > 0) {
            if (![Utility isEmptyCheck:[formatter numberFromString:textField.text]]) {
                [searchDict setObject:[formatter numberFromString:textField.text] forKey:@"MinCalories"];
            }else{
                [Utility msg:@"Please enter valid Min Calories." title:@"Warning !" controller:self haveToPop:NO];
                return;
            }
        }else{
            [searchDict removeObjectForKey:@"MinCalories"];
        }
    }else if ([textField isEqual:maxCalorieTextField]) {
        if (maxCalorieTextField.text.length > 0) {
            if (![Utility isEmptyCheck:[formatter numberFromString:textField.text]]) {
                [searchDict setObject:[formatter numberFromString:textField.text] forKey:@"MaxCalories"];
            }else{
                [Utility msg:@"Please enter valid Max Calories." title:@"Warning !" controller:self haveToPop:NO];
                return;
            }
        }else{
            [searchDict removeObjectForKey:@"MaxCalories"];
        }
    }else if ([textField isEqual:timetoMakeTextField]) {
        if (timetoMakeTextField.text.length > 0) {
            if (![Utility isEmptyCheck:[formatter numberFromString:textField.text]]) {
                [searchDict setObject:[formatter numberFromString:textField.text] forKey:@"MaxTimeToPrepare"];
            }else{
                [Utility msg:@"Please enter valid Max time to prepare." title:@"Warning !" controller:self haveToPop:NO];
                return;
            }
        }else{
            [searchDict removeObjectForKey:@"MaxTimeToPrepare"];
        }
    }

}
#pragma mark - End

- (void) didSelectAnyDropdownOptionMultiSelect:(NSString *)type data:(NSDictionary *)selectedData isAdd:(BOOL)isAdd {
    if ([type caseInsensitiveCompare:@"IngredientName"] == NSOrderedSame) {
        NSString *title = IngredientsTextView.text;
        if (![Utility isEmptyCheck:selectedData] && selectedData.count > 0) {
            if (isAdd) {
                if ([IngredientsTextView.text isEqualToString:@""]) {
                    IngredientsTextView.text =[selectedData objectForKey:@"IngredientName"];
                }else{
                    IngredientsTextView.text =[NSString stringWithFormat:@"%@, %@",title,[selectedData objectForKey:@"IngredientName"]];
                }
            } else {
                NSArray *titleArr = [title componentsSeparatedByString:@", "];
                NSMutableArray *titleMutableArr = [titleArr mutableCopy];
                for (int i = 0; i < titleMutableArr.count; i++) {
                    if ([titleMutableArr containsObject:[selectedData objectForKey:@"IngredientName"]]) {
                        [titleMutableArr removeObject:[selectedData objectForKey:@"IngredientName"]];
                    }
                }
                if (titleMutableArr.count > 0)
                    IngredientsTextView.text =[titleMutableArr componentsJoinedByString:@", "];
                else
                    IngredientsTextView.text =@"";
            }
        }
        if (IngredientsTextView.text.length > 0) {
            [searchDict setObject:IngredientsTextView.text forKey:@"SearchIngredients"];
        }
    }
}

#pragma mark - End
@end
