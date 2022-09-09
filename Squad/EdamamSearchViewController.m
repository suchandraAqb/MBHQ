//
//  EdamamSearchViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 25/01/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "EdamamSearchViewController.h"
#import "MealMatchTableViewCell.h"

@interface EdamamSearchViewController (){
    
    __weak IBOutlet UITextField *searchTextField;
    __weak IBOutlet UITableView *searchTable;
    __weak IBOutlet UILabel *noData;
    UIView *contentView;
    int apiCount;
    
    BOOL GetMeals;
    BOOL GetIngredients;
    NSString *EdamamNextPageUrl;
    
    UITextField *activeTextField;
    UIToolbar *toolBar;
    NSMutableArray *mealArray;
    int pageNo;
}

@end

@implementation EdamamSearchViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GetMeals = true;
    GetIngredients = true;
    EdamamNextPageUrl = @"";
    searchTextField.text = @"";
    apiCount = 0;
    noData.text = @"No meal found";
    noData.hidden = false;
    mealArray = [NSMutableArray new];
    searchTable.hidden = true;
    pageNo = 1;
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    UIView *paddingViewMinCal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, searchTextField.frame.size.height)];
    searchTextField.leftView = paddingViewMinCal;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    [self registerForKeyboardNotifications];
    if (![Utility isEmptyCheck:_requestDict]) {
        searchTextField.text = [@""stringByAppendingFormat:@"%@",[_requestDict objectForKey:@"SearchText"]];
        pageNo = [[_requestDict objectForKey:@"PageNo"]intValue];//@"PageNo";
        GetMeals = [[_requestDict objectForKey:@"GetMeals"]boolValue];//@"GetMeals";
        GetIngredients = [[_requestDict objectForKey:@"GetIngredients"]boolValue];//@"GetIngredients";
        EdamamNextPageUrl = [@""stringByAppendingFormat:@"%@",[_requestDict objectForKey:@"EdamamNextPageUrl"]];
        if (![Utility isEmptyCheck:[_requestDict objectForKey:@"mealArray"]]) {
            mealArray = [[_requestDict objectForKey:@"mealArray"]mutableCopy];
            noData.hidden = true;
            searchTable.hidden = false;
            [searchTable reloadData];
        }
    }
}

#pragma mark - IBAction
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
-(IBAction)searchButtonPressed:(UIButton *)sender{
    [self.view endEditing:YES];
    if ([Utility isEmptyCheck:searchTextField.text]) {
        [Utility msg:@"Please enter a keyword to search." title:nil controller:self haveToPop:NO];
        return;
    }
    GetMeals = true;
    GetIngredients = true;
    EdamamNextPageUrl = @"";
    pageNo = 1;
    [mealArray removeAllObjects];
    searchTable.hidden = true;
    [self searchAllFood];
}
-(IBAction)lodeMorePressed:(UIButton *)sender{
    pageNo++;
    [self searchAllFood];
}

#pragma mark - End

#pragma mark - APICall
-(void)searchAllFood{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        [mainDict setObject:searchTextField.text forKey:@"SearchText"];
        [mainDict setObject:[NSNumber numberWithInt:pageNo] forKey:@"PageNo"];
        [mainDict setObject:[NSNumber numberWithBool:GetMeals] forKey:@"GetMeals"];
        [mainDict setObject:[NSNumber numberWithBool:GetIngredients] forKey:@"GetIngredients"];
        [mainDict setObject:EdamamNextPageUrl forKey:@"EdamamNextPageUrl"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
//            self->noData.hidden = false;
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SearchAllFood" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 BOOL gotData = false;
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->GetMeals = [[responseDict objectForKey:@"MoreSquadMealsAvailable"]boolValue];
                                                                         self->GetIngredients = [[responseDict objectForKey:@"MoreSquadIngredientsAvailable"]boolValue];
                                                                         self->EdamamNextPageUrl = ![Utility isEmptyCheck:[responseDict objectForKey:@"EdamamNextPageUrl"]]?[responseDict objectForKey:@"EdamamNextPageUrl"]:@"";
                                                                         NSLog(@"\n%@%@%@\n",[NSNumber numberWithBool:self->GetMeals],[NSNumber numberWithBool:self->GetIngredients],self->EdamamNextPageUrl);
                                                                         NSArray *meal = [responseDict objectForKey:@"MealList"];
                                                                         if (![Utility isEmptyCheck:meal]) {
                                                                             gotData = true;
                                                                             [self->mealArray addObjectsFromArray:meal];
                                                                             [self->searchTable reloadData];
                                                                         }
                                                                         
                                                                         self->noData.hidden = ![Utility isEmptyCheck:self->mealArray];
                                                                         self->searchTable.hidden = [Utility isEmptyCheck:self->mealArray];
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                                 if (!gotData) {
                                                                     self->pageNo--;
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
#pragma mark - End

#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return mealArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    BOOL showFooter = false;
    if (![Utility isEmptyCheck:EdamamNextPageUrl]) {
        showFooter = true;
    }else if (GetMeals || GetIngredients) {
        showFooter = true;
    }else{
        showFooter = false;
    }
    if (showFooter) {
        return 50;
    }else{
        return CGFLOAT_MIN;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    BOOL showFooter = false;
    float height = 0.0;
    if (![Utility isEmptyCheck:EdamamNextPageUrl]) {
        showFooter = true;
        height = 50.0;
    }else if (GetMeals || GetIngredients) {
        showFooter = true;
        height = 50.0;
    }else{
        showFooter = false;
        height = CGFLOAT_MIN;
    }
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    if (showFooter) {
        [myView setBackgroundColor:[UIColor whiteColor]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = myView.frame;
        frame.size.height = myView.frame.size.height - 10;
        button.frame = frame;
        [button addTarget:self action:@selector(lodeMorePressed:) forControlEvents:UIControlEventTouchUpInside];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:squadMainColor forState:UIControlStateNormal];
        [button setTitle:@"Load more" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Oswald-Light" size:17]];
        //    [button setImage:[UIImage imageNamed:@"fp_plus.png"] forState:UIControlStateNormal];
        //    [button setContentEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
        
        [myView addSubview:button];
    }
    
    return myView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"MealMatchTableSingleViewCell";
    MealMatchTableViewCell *cell = (MealMatchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MealMatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (![Utility isEmptyCheck:mealArray]) {
        NSDictionary *mealDetails = [mealArray objectAtIndex:indexPath.row];
        cell.headerView.hidden = true;
        if (![Utility isEmptyCheck:mealDetails]) {
            
//            cell.myMealName.text = ![Utility isEmptyCheck:[mealDetails objectForKey:@"MealName"]]?[[mealDetails objectForKey:@"MealName"]capitalizedString]:@"";
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",![Utility isEmptyCheck:[mealDetails objectForKey:@"MealName"]]?[[mealDetails objectForKey:@"MealName"]capitalizedString]:@""]];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:18] range:NSMakeRange(0, [attributedString length])];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"58595B"] range:NSMakeRange(0, [attributedString length])];
            
            BOOL IsSquadIngredient = [[mealDetails objectForKey:@"IsSquadIngredient"] boolValue];
            
            if(IsSquadIngredient){
                
                NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  (per 100)"]];
                [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Light" size:17] range:NSMakeRange(0, [attributedString2 length])];
                [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"58595B"] range:NSMakeRange(0, [attributedString2 length])];
                
                [attributedString appendAttributedString:attributedString2];
            }
            
            NSString *brand = [mealDetails objectForKey:@"Brand"];
            NSString *txt = ![Utility isEmptyCheck:brand]?[@"" stringByAppendingFormat:@"%@",brand]:@"";
            NSString *weightGrams = [mealDetails objectForKey:@"EdamamServeGrams"];
            
            if(![Utility isEmptyCheck:weightGrams]){
                txt = ![Utility isEmptyCheck:txt]?[txt stringByAppendingFormat:@", %@ G",[Utility customRoundNumber:[weightGrams floatValue]]]:[txt stringByAppendingFormat:@"%@ G",[Utility customRoundNumber:[weightGrams floatValue]]];
            }
            
            cell.brandLabel.text = ![Utility isEmptyCheck:txt]?[@"" stringByAppendingFormat:@"%@",txt]:@"";
            cell.myMealName.attributedText = attributedString;
            
//            NSString *imageString = mealDetails[@"PhotoPath"];
//            if (![Utility isEmptyCheck:imageString]) {
//                [cell.myMealImage sd_setImageWithURL:[NSURL URLWithString:imageString]
//                                      placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages];  //ah 17.5
//            } else {
//                cell.myMealImage.image = [UIImage imageNamed:@"meal_no_img.png"];
//            }
            if ([[mealDetails objectForKey:@"IsSquadMeal"]boolValue]) {
                cell.myMealImage.hidden = false;
                [cell.myMealImage setImage:[UIImage imageNamed:@"squad_meal.png"]];
            } else if([[mealDetails objectForKey:@"IsSquadIngredient"]boolValue]){
                cell.myMealImage.hidden = false;
                [cell.myMealImage setImage:[UIImage imageNamed:@"squad_ing.png"]];
            } else {
                cell.myMealImage.hidden = true;
            }
            cell.myMealCal.text = [@"" stringByAppendingFormat:@"%@ CAL",![Utility isEmptyCheck:[mealDetails objectForKey:@"TotalCalories"]]?[Utility customRoundNumber:[[mealDetails objectForKey:@"TotalCalories"]floatValue]]:@"0"];
            cell.pcfLabel.text = [@"" stringByAppendingFormat:@"P: %@ G     C: %@ G     F: %@ G",![Utility isEmptyCheck:[mealDetails objectForKey:@"Protein"]]?[Utility customRoundNumber:[[mealDetails objectForKey:@"Protein"]floatValue]]:@"0",![Utility isEmptyCheck:[mealDetails objectForKey:@"Carbohydrates"]]?[Utility customRoundNumber:[[mealDetails objectForKey:@"Carbohydrates"]floatValue]]:@"0",![Utility isEmptyCheck:[mealDetails objectForKey:@"Fat"]]?[Utility customRoundNumber:[[mealDetails objectForKey:@"Fat"]floatValue]]:@"0"];
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict = [mealArray[indexPath.row]mutableCopy];
    
    NSString *weightGrams = [dict objectForKey:@"EdamamServeGrams"];
    if (![Utility isEmptyCheck:weightGrams]) {
        [dict setObject:weightGrams forKey:@"serving_weight_grams"];
    }
    if ([Utility isEmptyCheck:_requestDict]) {
        _requestDict = [NSMutableDictionary new];
    }
    [_requestDict setObject:searchTextField.text forKey:@"SearchText"];
    [_requestDict setObject:[NSNumber numberWithInt:pageNo] forKey:@"PageNo"];
    [_requestDict setObject:[NSNumber numberWithBool:GetMeals] forKey:@"GetMeals"];
    [_requestDict setObject:[NSNumber numberWithBool:GetIngredients] forKey:@"GetIngredients"];
    [_requestDict setObject:EdamamNextPageUrl forKey:@"EdamamNextPageUrl"];
    [_requestDict setObject:mealArray forKey:@"mealArray"];
    
    [self.navigationController popViewControllerAnimated:NO];
    if ([self->delegate respondsToSelector:@selector(getSearchedMeal:requestDict:)]) {
        [self->delegate getSearchedMeal:dict requestDict:_requestDict];
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height-75, 0.0);
    searchTable.contentInset = contentInsets;
    searchTable.scrollIndicatorInsets = contentInsets;
    
    if (activeTextField != nil) {
        CGRect aRect = searchTable.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            //          [mainScroll scrollRectToVisible:activeTextField.frame animated:YES];
            
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    searchTable.contentInset = contentInsets;
    searchTable.scrollIndicatorInsets = contentInsets;
    
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
    [textField setInputAccessoryView:toolBar];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
    
    [searchTextField resignFirstResponder];
    [self searchButtonPressed:0];
}
#pragma mark - End
@end
