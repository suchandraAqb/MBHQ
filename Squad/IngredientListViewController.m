//
//  IngredientListViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 27/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "IngredientListViewController.h"
#import "IngredientListTableViewCell.h"
#import "AddEditIngredientViewController.h"

@interface IngredientListViewController (){
    
    IBOutlet UITableView *table;
    IBOutlet UILabel *blankMsgLabel;
    IBOutlet UIButton *squadIngredientButton;
    IBOutlet UIButton *myIngredientButton;
    IBOutlet UIImageView *buttonBg;
    
    IBOutlet UILabel *mealType;
    IBOutlet UITextField *searchTextField;
    IBOutlet UIButton *searchButton;
    
    NSArray *ingredientArray;
    UIView *contentView;
    int apiCount;
    
    //shabbir
    IBOutlet UIButton *headerText;
    IBOutlet UIButton *editIngredient;
    IBOutlet UIButton *viewAllIngredients;
    IBOutlet UIButton *addIngredients;
    IBOutlet UIStackView *ingredientStackView;
    IBOutlet UIButton *allIngredientButton;
    
}

@end

@implementation IngredientListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    contentView.layer.cornerRadius = 5.0;
    contentView.layer.masksToBounds = YES;
    table.estimatedRowHeight = 56;
    table.rowHeight = UITableViewAutomaticDimension;
    squadIngredientButton.selected=false;
    myIngredientButton.selected=false;
    
    viewAllIngredients.layer.borderWidth = 2;
    viewAllIngredients.layer.borderColor = [UIColor colorWithRed:228.0f/255.0f green:39.0f/255.0f blue:160.0f/255.0f alpha:1].CGColor;
    addIngredients.layer.borderWidth = 2;
    addIngredients.layer.borderColor = [UIColor colorWithRed:228.0f/255.0f green:39.0f/255.0f blue:160.0f/255.0f alpha:1].CGColor;
    editIngredient.layer.borderWidth = 2;
    editIngredient.layer.borderColor = [UIColor colorWithRed:228.0f/255.0f green:39.0f/255.0f blue:160.0f/255.0f alpha:1].CGColor;
    
    [self setBackgroundWhite:squadIngredientButton];
    [self setBackgroundWhite:myIngredientButton];
    [self setBackgroundWhite:allIngredientButton];
    [allIngredientButton setBackgroundColor:[UIColor colorWithRed:228.0f/255.0f green:39.0f/255.0f blue:160.0f/255.0f alpha:1]];
    [allIngredientButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    buttonBg.image = [UIImage imageNamed:@"sq_tab_bar.png"];
    ingredientStackView.hidden = true;
    mealType.text = @"Squad Ingredients";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    apiCount = 0;
    [self getMyIngredientsApiCall];
}
#pragma -mark Private Methods

-(NSDictionary *)setFilter{
    NSMutableDictionary *filterDict = [[NSMutableDictionary alloc]init];
    if (myIngredientButton.selected) {
        [filterDict setObject:[NSNumber numberWithInt:MyIngredient] forKey:@"IngredientFilter"];
    }else if(squadIngredientButton.selected){
        [filterDict setObject:[NSNumber numberWithInt:SquadIngredient] forKey:@"IngredientFilter"];
    }else{
        [filterDict setObject:[NSNumber numberWithInt:AllIngredient] forKey:@"IngredientFilter"];
    }
    [filterDict setObject:searchTextField.text forKey:@"searchIngredient"];
    return filterDict;
}
-(void)getMyIngredientsApiCall{
    if (myIngredientButton.selected && (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"])) {
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    dispatch_async(dispatch_get_main_queue(),^ {
        table.hidden = true;
        blankMsgLabel.hidden = false;
    });
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:[self setFilter]];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(),^ {
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMyIngredientsApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 apiCount --;
                                                                 if (contentView && apiCount == 0) {
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
                                                                             if(![Utility isEmptyCheck:[responseDictionary objectForKey:@"Ingredients"]]){
                                                                                 ingredientArray = [responseDictionary objectForKey:@"Ingredients"];
                                                                                 table.hidden = false;
                                                                                 blankMsgLabel.hidden = true;
                                                                                 if (apiCount==0) {
                                                                                     if (ingredientArray.count>0) {
                                                                                         [table reloadData];
                                                                                     }
                                                                                 }
                                                                             }else{
                                                                                 table.hidden = true;
                                                                                 blankMsgLabel.hidden = false;
                                                                                 if (myIngredientButton.isSelected) {
                                                                                     return;
                                                                                 }
                                                                                 
                                                                             }
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
#pragma -mark End

#pragma -mark IBAction
- (IBAction)searchButtonPressed:(UIButton *)sender {
    ingredientStackView.hidden = true;
    [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        searchTextField.hidden = !searchTextField.hidden;
//        if (searchTextField.hidden) {
            [self.view endEditing:YES];
//        }else{
//            [searchTextField becomeFirstResponder];
//        }
        
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)setBackgroundWhite:(UIButton *)sender{
    [sender setBackgroundColor:[UIColor whiteColor]];
    [sender setTitleColor:[UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1] forState:UIControlStateNormal];
    sender.layer.borderColor = [UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1].CGColor;
    sender.layer.borderWidth = 2;
}
-(IBAction)squadIngredintsOrIngredintsListButtonPressed:(UIButton *)sender{
    if (sender == squadIngredientButton) {
        squadIngredientButton.selected = true;
        myIngredientButton.selected = false;
        [headerText setTitle:@"INGREDIENT LIST" forState:UIControlStateNormal];
        [viewAllIngredients setTitle:@"SQUAD INGREDIENTS" forState:UIControlStateNormal];
        mealType.text = @"Squad Ingredients";
        
    }else if (sender == myIngredientButton){
        if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
            [Utility showTrailLoginAlert:self ofType:self];
            return;
        }
        myIngredientButton.selected = true;
        squadIngredientButton.selected = false;
        [headerText setTitle:@"EDIT INGREDIENTS" forState:UIControlStateNormal];
        [viewAllIngredients setTitle:@"MY INGREDIENTS" forState:UIControlStateNormal];
        mealType.text = @"My Ingredients";
    }else{
        myIngredientButton.selected = false;
        squadIngredientButton.selected = false;
        [headerText setTitle:@"INGREDIENT LIST" forState:UIControlStateNormal];
        [viewAllIngredients setTitle:@"ALL INGREDIENTS" forState:UIControlStateNormal];
        mealType.text = @"All Ingredients";
    }
    [self setBackgroundWhite:squadIngredientButton];
    [self setBackgroundWhite:myIngredientButton];
    [self setBackgroundWhite:allIngredientButton];
    [sender setBackgroundColor:[UIColor colorWithRed:228.0f/255.0f green:39.0f/255.0f blue:160.0f/255.0f alpha:1]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ingredientStackView.hidden = true;
    [self getMyIngredientsApiCall];
    
}
-(IBAction)submittedButtonPressed:(UIButton *)sender{
    NSDictionary *ingredientDict = ingredientArray[sender.tag];
    if (![Utility isEmptyCheck:ingredientDict]) {
        if (Utility.reachable) {
            sender.selected = !sender.isSelected;
            NSError *error;
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            
            [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
            [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
            [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
            [mainDict setObject:ingredientDict[@"IngredientId"] forKey:@"IngredientId"];
            
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                ingredientArray = [NSArray array];
                apiCount++;
                if (contentView) {
                    [contentView removeFromSuperview];
                }
                table.hidden = true;
                blankMsgLabel.hidden = false;
                contentView = [Utility activityIndicatorView:self];
            });
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SubmitIngredientApiCall" append:@""forAction:@"POST"];
            
            NSURLSession *loginSession = [NSURLSession sharedSession];
            NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     apiCount--;
                                                                     if (contentView && apiCount == 0){
                                                                         [contentView removeFromSuperview];
                                                                     }
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                             [Utility msg:@"Your Ingredient has been submitted and will be reviewed by our team soon" title:@"" controller:self haveToPop:NO];
                                                                             
                                                                         }
                                                                         else{
                                                                             [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                     }else{
                                                                         [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                     }
                                                                     [self getMyIngredientsApiCall];
                                                                 });
                                                                 
                                                             }];
            [dataTask resume];
            
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
}
- (IBAction)addIngredientButtonPressed:(UIButton *)sender {
    AddEditIngredientViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddEditIngredient"];
    controller.mealType = @"ADD INGREDIENT";
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)editIngredientButtonPressed:(UIButton *)sender {
    NSDictionary *dict = ingredientArray[sender.tag];
    AddEditIngredientViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddEditIngredient"];
    controller.IngredientId = [dict objectForKey:@"IngredientId"];
    controller.mealType=[NSString stringWithFormat:@"EDIT %@",dict[@"IngredientName"]]; //mealType.text;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)logoTapped:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)editIngredientToggle:(UIButton *)sender{
    if(sender == editIngredient){
        if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
            [Utility showTrailLoginAlert:self ofType:self];
            return;
        }
        editIngredient.hidden = true;
        addIngredients.hidden = false;
        ingredientStackView.hidden = true;
        
        [headerText setTitle:@"EDIT INGREDIENTS" forState:UIControlStateNormal];
        [viewAllIngredients setTitle:@"MY INGREDIENTS" forState:UIControlStateNormal];
        squadIngredientButton.selected = false;
        myIngredientButton.selected = true;
        [self setBackgroundWhite:squadIngredientButton];
        [self setBackgroundWhite:myIngredientButton];
        [self setBackgroundWhite:allIngredientButton];
        [myIngredientButton setBackgroundColor:[UIColor colorWithRed:228.0f/255.0f green:39.0f/255.0f blue:160.0f/255.0f alpha:1]];
        [myIngredientButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self getMyIngredientsApiCall];
    }else if (sender == viewAllIngredients){
        ingredientStackView.hidden = !ingredientStackView.isHidden;
        
//        [headerText setTitle:@"INGREDIENT LIST" forState:UIControlStateNormal];
//        squadIngredientButton.selected = true;
//        myIngredientButton.selected = false;
//        [self getMyIngredientsApiCall];
    }
}
#pragma -mark End
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ingredientArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"IngredientListTableViewCell";
    IngredientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[IngredientListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.submittedButton.tag = indexPath.row;
    cell.ingredientEditButton.tag = indexPath.row;
    NSDictionary *dict = ingredientArray[indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        cell.ingredientName.text = ![Utility isEmptyCheck:dict[@"IngredientName"]] ? [NSString stringWithFormat:@"%@: 100g",dict[@"IngredientName"]] : @"";
        if (myIngredientButton.selected) {
            [cell.ingredientNameContainer addArrangedSubview:cell.submittedButton];
            [cell.ingredientNameContainer addArrangedSubview:cell.ingredientEditButton];
            if ([dict[@"AllowSubmit"]boolValue]) {
                [cell.submittedButton setTitle:@"Submit" forState:UIControlStateNormal];
            }else{
                [cell.submittedButton setTitle:@"Re Submit" forState:UIControlStateNormal];
            }
            cell.submittedButton.layer.borderColor = [UIColor colorWithRed:228.0f/255.0f green:39.0f/255.0f blue:160.0f/255.0f alpha:1].CGColor;
            cell.submittedButton.layer.borderWidth = 2;
            cell.submittedButton.layer.cornerRadius = 5;
            cell.submittedButton.layer.masksToBounds = YES;
            cell.submittedButton.hidden=false;
            cell.ingredientEditButton.hidden= false;
        }else{
            cell.submittedButton.hidden=true;
            cell.ingredientEditButton.hidden= true;
        }
        if (![Utility isEmptyCheck: dict[@"UnitMetric"]]) {
            NSString *unit =dict[@"UnitMetric"];
            cell.calsPer100Label.text = [@"" stringByAppendingFormat:@"CALS"];//    /100 %@",unit];
            cell.carbsPer100Label.text = [@"" stringByAppendingFormat:@"CARBS"];///100 %@",unit];
            cell.protinePer100Label.text = [@"" stringByAppendingFormat:@"PROTEIN"];///100 %@",unit];
            cell.fatPer100Label.text = [@"" stringByAppendingFormat:@"FAT"];///100 %@",unit];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 2;
            cell.calsPer100.text = ![Utility isEmptyCheck:dict[@"CalsPer100"]] ? [@"" stringByAppendingFormat:@"%@",[formatter stringFromNumber:dict[@"CalsPer100"]]] : @"0";
            cell.protinePer100.text = ![Utility isEmptyCheck:dict[@"ProteinPer100"]] ? [@"" stringByAppendingFormat:@"%@%@",[formatter stringFromNumber:dict[@"ProteinPer100"]],unit] : [@"0" stringByAppendingString:unit];
            cell.fatPer100.text = ![Utility isEmptyCheck:dict[@"FatPer100"]] ? [@"" stringByAppendingFormat:@"%@%@",[formatter stringFromNumber:dict[@"FatPer100"]],unit] : [@"0" stringByAppendingString:unit];
            cell.carbsPer100.text = ![Utility isEmptyCheck:dict[@"CarbsPer100"]] ? [@"" stringByAppendingFormat:@"%@%@",[formatter stringFromNumber:dict[@"CarbsPer100"]],unit] : [@"0" stringByAppendingString:unit];
            
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark -End

#pragma mark - textField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.text.length > 0){
        [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view endEditing:YES];
            
        } completion:^(BOOL finished) {
            
        }];
        [self getMyIngredientsApiCall];
    }
    
}
#pragma mark - End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
