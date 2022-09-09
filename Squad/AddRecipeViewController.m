//
//  AddRecipeViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 21/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AddRecipeViewController.h"
#import "Utility.h"

@interface AddRecipeViewController ()
{
    IBOutlet UITextField *recipeName;
    IBOutlet UITextField *recipePrepTime;
    IBOutlet UIButton *breakfast;
    IBOutlet UIButton *lunch;
    IBOutlet UIButton *dinner;
    IBOutlet UIButton *snack;
    IBOutlet UIButton *drink;
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIButton *saveButton;
    
    UITextField *activeTextField;
    UIToolbar *toolBar;
    UITextView *activeTextView;
    UIView *contentView;
    NSMutableDictionary *mealData;
    NSMutableArray *ingredientsArray;
    NSMutableArray *instructionArray;
    BOOL isChanged;
}
@end

@implementation AddRecipeViewController
@synthesize currentDate,isFromMealMatch,delegate;
#pragma mark - IBAction
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
-(IBAction)logoTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)cheekUncheckButtonPressed:(UIButton*)sender{
    [self.view endEditing:YES];
    if([sender isEqual:breakfast] ){
        breakfast.selected = !breakfast.isSelected;
    }else if([sender isEqual:lunch]){
        lunch.selected = !lunch.isSelected;
    }else if([sender isEqual:dinner]){
        dinner.selected = !dinner.isSelected;
    }else if([sender isEqual:snack]){
        snack.selected = !snack.isSelected;
    }else if([sender isEqual:drink]){
        drink.selected = !drink.isSelected;
    }
//    if (sender.isSelected) {
//        [sender setBackgroundColor:squadMainColor];
//    } else {
//        [sender setBackgroundColor:[UIColor whiteColor]];
//    }
    [mealData setObject:[NSNumber numberWithBool:breakfast.isSelected] forKey:@"IsBreakfast"];
    [mealData setObject:[NSNumber numberWithBool:dinner.isSelected] forKey:@"IsDinner"];
    [mealData setObject:[NSNumber numberWithBool:lunch.isSelected] forKey:@"IsLunch"];
    [mealData setObject:[NSNumber numberWithBool:snack.isSelected] forKey:@"IsSnack"];
    [mealData setObject:[NSNumber numberWithBool:drink.isSelected] forKey:@"IsDrink"];
    
}

-(IBAction)saveButtonClicked:(id)sender{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    if ([Utility isEmptyCheck:recipeName.text]) {
        [Utility msg:@"Recipe Name cannot be blank." title:@"Warning !" controller:self haveToPop:NO];
        return;
        
    }else if ([Utility isEmptyCheck:recipePrepTime.text]) {
        [Utility msg:@"Please enter Preparation Time." title:@"Warning !" controller:self haveToPop:NO];
        return;
        
    }else if([Utility isEmptyCheck:[formatter numberFromString:recipePrepTime.text]]){
        [Utility msg:@"Please enter valid Preparation Time." title:@"Warning !" controller:self haveToPop:NO];
        return;
        
    }
    
    [self webservicecall_GetUserRecipeByName];
}
#pragma mark - End

#pragma mark - Private Function

-(void)webservicecall_GetUserRecipeByName{
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:recipeName.text forKey:@"RecipeName"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserRecipeByName" append:@""forAction:@"POST"];
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
                                                                          [self webserviceCall_IsMealNameExisting:[responseDict objectForKey:@"MealId"]];
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

-(void) webserviceCall_IsMealNameExisting:(NSNumber*)mealId; {
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealId forKey:@"MealId"];
        [mainDict setObject:recipeName.text forKey:@"RecipeName"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"IsMealNameExisting" append:@""forAction:@"POST"];
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
                                                                          
                                                                         BOOL isExisting =[[responseDict objectForKey:@"IsExisting"]boolValue];
                                                                          if (isExisting) {
                                                                              UIAlertController * alert=   [UIAlertController
                                                                                                            alertControllerWithTitle:@"Alert"
                                                                                                            message:@"You have already personalised this recipe earlier, do you wish to edit the personalised one? if yes, click Confirm. If not, please enter a new name for this recipe before saving."
                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                                              
                                                                              UIAlertAction* ok = [UIAlertAction
                                                                                                   actionWithTitle:@"Confirm"
                                                                                                   style:UIAlertActionStyleDefault
                                                                                                   handler:^(UIAlertAction * action)
                                                                                                   {
                                                                                                       
                                                                                                       AddEditCustomNutritionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddEditCustomNutrition"];
                                                                                                       controller.mealId = mealId;
                                                                                                       controller.fromController = @"Recipe";        //ah ux
                                                                                                       controller.currentDate = self->currentDate;
                                                                                                       controller.isFromMealMatch = self->isFromMealMatch;
                                                                                                       controller.delegate = self;
                                                                                                       [self.navigationController pushViewController:controller animated:YES];
                                                                                                       
                                                                                                   }];
                                                                              UIAlertAction* cancel = [UIAlertAction
                                                                                                       actionWithTitle:@"No"
                                                                                                       style:UIAlertActionStyleCancel
                                                                                                       handler:^(UIAlertAction * action)
                                                                                                       {
                                                                                                           
                                                                                   self->recipeName.text = @"";                        NSLog(@"Resolving UIAlertActionController for tapping cancel button");
                                                                                                           
                                                                                                       }];
                                                                              [alert addAction:cancel];
                                                                              [alert addAction:ok];
                                                                              [self presentViewController:alert animated:YES completion:nil];
                                                                          }else{
                                                                              [self saveMealData];
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
-(void) saveMealData {
    if (Utility.reachable) {
        
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if ([Utility isEmptyCheck:mealData]) {
            mealData = [[NSMutableDictionary alloc]init];
        }
        
        if ([Utility isEmptyCheck:mealData[@"MealName"]]) {
            [Utility msg:@"MealName required." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
        if ([Utility isEmptyCheck:mealData[@"PreparationMinutes"]]) {
            [Utility msg:@"Preparation time required." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
        [mealData setObject:[NSNumber numberWithBool:breakfast.isSelected] forKey:@"IsBreakfast"];
        [mealData setObject:[NSNumber numberWithBool:dinner.isSelected] forKey:@"IsDinner"];
        [mealData setObject:[NSNumber numberWithBool:lunch.isSelected] forKey:@"IsLunch"];
        [mealData setObject:[NSNumber numberWithBool:snack.isSelected] forKey:@"IsSnack"];
        [mealData setObject:[NSNumber numberWithBool:drink.isSelected] forKey:@"IsDrink"];
        
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"TotalCalories" ];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Calories" ];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Fat" ];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"FatOz" ];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"FatSaturated"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"FatCals"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"FatPercentage"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Protein"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"ProteinOz"];
        [mealData setObject:@"" forKey:@"ProteinSource"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"ProtCals"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"ProteinPercentage"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Carbohydrates"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"CarbohydratesOz"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"CarbCals"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"CarbPercentage"];
        
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Fibre"];
        
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Mg"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Zn"];
        
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Se"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Fe"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"K"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Na"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Ca"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Sugar"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Serves"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"ServeSize"];
        
        
        [mealData setObject:@"" forKey:@"Region"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsGlutenFree"];
        [mealData setObject:[NSNumber numberWithInt:0] forKey:@"IsVegetarian"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsDairyFree"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsFodmapFriendly"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsKETO"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsPaleo"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsAntiOx"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsAntiInflam"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"HasWhiteMeat"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"NoSeaFood"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"NoEggs"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"NoNuts"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"NoLegumes"];
        
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"BBP_A"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"BBP_B"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"BBP_C"];
        
        [mealData setObject:@"" forKey:@"PhotoSmallPath"];
        [mealData setObject:@"" forKey:@"PhotoPath"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Cals"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"CalsTotal"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"MonoSaturated"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Omega6"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Omega3"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Trans"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Omega6"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"TotalPercentage"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"AllowSubmit"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"CanBePersonalised"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"CanBePersonalised"];
        [mealData setObject:[NSNumber numberWithBool:YES] forKey:@"IsSquad"];
        [mealData setObject:[NSNumber numberWithBool:NO] forKey:@"IsAbbbc"];
        [mealData setObject:[NSNumber numberWithInt:0] forKey:@"MealClassifiedID"];
        // [mealData setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:@{@"MealData" : mealData, @"Ingredients": [NSArray array], @"Instructions" : [NSArray array]} forKey:@"MealDetails"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateMealRecipeApiCall" append:@""forAction:@"POST"];
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
                                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup_nourish

                                                                          
                                                                          AddEditCustomNutritionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddEditCustomNutrition"];
                                                                          controller.MealType = self->_MealType;
                                                                          controller.mealId = responseDict[@"MealId"];
                                                                          controller.add = YES;
                                                                          controller.fromController = @"Recipe";        //ah ux
                                                                          controller.currentDate = self->currentDate;
                                                                          controller.isFromMealMatch = self->isFromMealMatch;
                                                                          controller.delegate = self;
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
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
#pragma mark - End

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    mealData = [[NSMutableDictionary alloc]init];
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {    //add24
        recipeName.text =[@"" stringByAppendingFormat:@"%@'s - ",[defaults objectForKey:@"FirstName"]];
    }else{
        recipeName.text = @"";
    }

    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [self registerForKeyboardNotifications];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, recipeName.frame.size.height)];
    recipeName.leftView = paddingView;
    recipeName.leftViewMode = UITextFieldViewModeAlways;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, recipePrepTime.frame.size.height)];
    recipePrepTime.leftView = paddingView;
    recipePrepTime.leftViewMode = UITextFieldViewModeAlways;
    
    recipeName.layer.borderWidth = 1.0;
    recipeName.layer.borderColor = squadSubColor.CGColor;
    recipePrepTime.layer.borderWidth = 1.0;
    recipePrepTime.layer.borderColor = squadSubColor.CGColor;
    recipeName.layer.cornerRadius = 10.0;
    recipeName.layer.masksToBounds = YES;
    recipePrepTime.layer.cornerRadius = 10.0;
    recipePrepTime.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 15.0;
    saveButton.layer.masksToBounds = YES;
}

#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height-130, 0.0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
    if (activeTextField !=nil) {
        CGRect aRect = mainScroll.frame;
        CGRect frame = [mainScroll convertRect:activeTextField.frame fromView:activeTextField.superview];
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect,frame.origin) ) {
            [mainScroll scrollRectToVisible:frame animated:YES];
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField setInputAccessoryView:toolBar];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    activeTextView = nil;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    if ([textField isEqual:recipeName]) {
        if (![Utility isEmptyCheck:textField.text]) {
            [mealData setObject:textField.text forKey:@"MealName"];
        }else{
            [Utility msg:@"Recipe Name cannot be blank." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
    }else if ([textField isEqual:recipePrepTime]) {
        if (![Utility isEmptyCheck:[formatter numberFromString:textField.text]]) {
            [mealData setObject:[formatter numberFromString:textField.text] forKey:@"PreparationMinutes"];
            // [self saveMealData:false pop:NO];
        }else{
            [Utility msg:@"Please enter valid Preparation Time." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
    }
}
#pragma mark - End

#pragma mark - AddEditCustomNutritionDelegate
-(void)didCheckAnyChange:(BOOL)ischanged{
    isChanged =ischanged;
    if ([delegate respondsToSelector:@selector(didCheckAnyChangeForAddRecipe:)]) {
        [delegate didCheckAnyChangeForAddRecipe:ischanged];
    }
}
@end
