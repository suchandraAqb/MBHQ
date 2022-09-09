//
//  DietaryPreferenceViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 28/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "DietaryPreferenceViewController.h"
#import "MasterMenuViewController.h"
#import "ChooseGoalViewController.h"
#import "MealVarietyViewController.h"
#import "DietaryCollectionReusableView.h"
#import "DietaryCollectionViewCell.h"
#import "NutritionSettingHomeViewController.h"
#import "PopoverViewController.h"
#import "MealFrequencyViewController.h"
#import "MovePersonalSessionViewController.h"
#import "DietaryTableViewCell.h"

//#define vegetarianType  @{@"2":@"Lacto-Ovo Vegetarian - consumes eggs and dairy",@"3":@"Vegan (no egg or dairy)",@"4":@"Pescatarian (Consumes eggs, dairy and fish"} //not needed
#define vegetarianType  @{@0:@"2",@1:@"3",@2:@"4"}

@interface DietaryPreferenceViewController ()
{
    NSArray *vegArray;
    IBOutlet NSLayoutConstraint *footerConstant;
    IBOutlet UIButton *menuButton;

    IBOutlet UICollectionView *collection;
    IBOutlet UIButton *backToNutritionSettings;
    IBOutlet NSLayoutConstraint *backToNutritionSettingsButtonHeightConstant;


    UIView *contentView;
    NSMutableArray *dietaryPreferenceFoodArray;
    NSMutableArray *dietaryHealthArray;
    int vegetarianIndex;
    int vegetarianOption;
    int ischeckUncheckValue;
    int index;
    int stepnumber;
    int apiCount;

    //shabbir 020518
    __weak IBOutlet UIScrollView *mainScroll;
    __weak IBOutlet NSLayoutConstraint *collectionHeight;
    __weak IBOutlet UITableView *ingredientTable;
    __weak IBOutlet NSLayoutConstraint *ingredientTableHeight;
    __weak IBOutlet UITextField *searchTextField;
    __weak IBOutlet UITableView *searchTable;
    __weak IBOutlet UIView *cancelView;
    UITextField *activeTextField;
    UIToolbar *toolBar;
    NSArray *ingredientList;
    NSMutableArray *myIngredientList;
    NSArray *tempSearchArray;
}
@end

@implementation DietaryPreferenceViewController

#pragma mark - IBAction
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}
- (IBAction)previousbuttonPressed:(id)sender {
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]] || [defaults boolForKey:@"IsNonSubscribedUser"]){
    if(![Utility isSubscribedUser]){
//        MovePersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MovePersonalSession"];
//        //    controller.responseObjArray = responseObjArray;
//        [self.navigationController pushViewController:controller animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSArray *arr = [self.navigationController viewControllers];
        
        if(arr.count>1){
            UIViewController *controller = [arr objectAtIndex:arr.count-2];
            
            if([controller isKindOfClass:[ChooseGoalViewController class]]){
                ChooseGoalViewController *choose = (ChooseGoalViewController *)controller;
                choose.isNutritionSettings=true;
                [self.navigationController popToViewController:choose animated:YES];
            }else{
                ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
                controller.isNutritionSettings=true;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else{
            ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
            controller.isNutritionSettings=true;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }
    
}
- (IBAction)nextbuttonPressed:(id)sender {
    if (!(stepnumber == 0)) {
        [self webSerViceCall_UpdateNutrationStep:true];
    }else{
        MealFrequencyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealFrequencyView"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(IBAction)checkUncheckButtonPressed:(UIButton*)sender{
    if (!sender.selected) {
        ischeckUncheckValue = 1;
        sender.selected = true;
//        [sender setImage:[UIImage imageNamed:@"tick_ExDetails.png"] forState:UIControlStateNormal];
    }else{
        ischeckUncheckValue =0;
        sender.selected = false;
//        [sender setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    if ([sender.accessibilityHint isEqualToString:@"0"]) {
        if (!(sender.tag == vegetarianIndex)){
            NSMutableDictionary *dict = [dietaryPreferenceFoodArray[sender.tag]mutableCopy];
            int ischeckPrevValue = [[dict objectForKey:@"Value"]intValue];
            if (ischeckPrevValue!=ischeckUncheckValue) {
                [dict setValue:[NSNumber numberWithInteger:ischeckUncheckValue]forKey:@"Value"];
            }
            [dietaryPreferenceFoodArray replaceObjectAtIndex:sender.tag withObject:dict];
            NSLog(@"updatedietaryPreferenceFoodArray-%@",dietaryPreferenceFoodArray);
            [self webSerViceCall_AddUpateUserFlags];
        }else if (vegetarianOption>0 && (sender.tag == vegetarianIndex) && vegetarianIndex>=0) {
            NSMutableDictionary *dict = [dietaryPreferenceFoodArray[sender.tag]mutableCopy];
            int ischeckPrevValue = [[dict objectForKey:@"Value"]intValue];
            if (ischeckPrevValue!=ischeckUncheckValue) {
                [dict setValue:[NSNumber numberWithInteger:ischeckUncheckValue]forKey:@"Value"];
            }
            [dietaryPreferenceFoodArray replaceObjectAtIndex:sender.tag withObject:dict];
            NSLog(@"updatedietaryPreferenceFoodArray-%@",dietaryPreferenceFoodArray);
            [self webSerViceCall_AddUpateUserFlags];
        }else if (!(vegetarianOption>0) && (sender.tag == vegetarianIndex) && vegetarianIndex>=0 ){
            if ([sender.currentImage isEqual:[UIImage imageNamed:@"tick_ExDetails.png"]]) {
                NSDictionary *dict =dietaryPreferenceFoodArray[sender.tag];
                if (![Utility isEmptyCheck:dict]) {
                    NSDictionary *temp = [Utility getDictByValue:vegArray value:dict[@"Value"] type:@"value"];
                    if (![Utility isEmptyCheck:temp]) {
                        int selectedIndex=(int) [vegArray indexOfObject:temp];
                        [self setupView:selectedIndex];
                    }else{
                        [self setupView:0];
                    }
                }
            }else{
                    [self webSerViceCall_AddUpateUserFlags];
                }
        }
        
    }else if ([sender.accessibilityHint isEqualToString:@"1"]) {
        NSMutableDictionary *dict = [dietaryHealthArray[sender.tag]mutableCopy];
        int ischeckPrevValue = [[dict objectForKey:@"Value"]intValue];
        
        if (ischeckPrevValue!=ischeckUncheckValue) {
            [dict setValue:[NSNumber numberWithInteger:ischeckUncheckValue]forKey:@"Value"];
        }
        
        [dietaryHealthArray replaceObjectAtIndex:sender.tag withObject:dict];
        NSLog(@"dietaryHealthArray-%@",dietaryHealthArray);
        [self webSerViceCall_AddUpateUserFlags];
    }
}

-(IBAction)backToNutritionSettings:(id)sender{
    BOOL isexist=false;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[NutritionSettingHomeViewController class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            isexist=true;
            break;
            
        }
    }
    if (!isexist) {
        NutritionSettingHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionSettingHomeView"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (IBAction)deleteIngredientPressed:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Are you sure want to remove this ingredient ?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self removeAvoidIngredientGroup:myIngredientList[sender.tag][@"Group"]];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)startTypingButtonPressed:(UIButton *)sender {
    searchTable.hidden = false;
    cancelView.hidden = false;
    [searchTextField becomeFirstResponder];
    searchTextField.text = @"";
    tempSearchArray = ingredientList;
    [searchTable reloadData];
    [searchTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
- (IBAction)cancelPressed:(UIButton *)sender {
    searchTable.hidden = true;
    cancelView.hidden = true;
}

#pragma mark - End

#pragma mark  -Private Function

-(void)webSerViceCall_SquadNutritionSettingStep{
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
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadNutritionSettingStep" append:@""forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         stepnumber=[[responseDict objectForKey:@"StepNumber"]intValue];
                                                                         //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]] || [defaults boolForKey:@"IsNonSubscribedUser"]){
                                                                         if(![Utility isSubscribedUser]){
                                                                             backToNutritionSettings.hidden = true;
                                                                             backToNutritionSettingsButtonHeightConstant.constant = 0;
                                                                         }else{
                                                                             if (stepnumber==0) {
                                                                                 backToNutritionSettings.hidden=false;
                                                                                 backToNutritionSettingsButtonHeightConstant.constant = 40;
                                                                             }else{
                                                                                 backToNutritionSettings.hidden=true;
                                                                                 backToNutritionSettingsButtonHeightConstant.constant = 0;
                                                                                 
                                                                             }
                                                                         }
                                                                         if (apiCount == 0) {
                                                                             [collection reloadData];
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

-(void)webSerViceCall_UpdateNutrationStep:(BOOL)isSave{
    if (stepnumber != 0) {// < stepNumber) {

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
            
            [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
            [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
            
            [mainDict setObject:[NSNumber numberWithInteger:3] forKey:@"StepNumber"];
            [mainDict setObject:AccessKey forKey:@"Key"];
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateNutrationStep" append:@""forAction:@"POST"];
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
                                                                             if (isSave) {
                                                                                 MealFrequencyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealFrequencyView"];
                                                                           
                                                                                 [self.navigationController pushViewController:controller animated:YES];
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
}

-(void)setupView:(int)selectedIndex {
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = vegArray;
    controller.mainKey = @"name";
    controller.apiType = @"Veg";
    controller.selectedIndex = selectedIndex;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
-(void)webSerViceCall_AddUpateUserFlags{
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
        NSMutableArray *mainArray = [[NSMutableArray alloc]init];
        for (int i= 0; i<dietaryPreferenceFoodArray.count; i++) {
            NSDictionary *dict = [dietaryPreferenceFoodArray objectAtIndex:i];
            if (![Utility isEmptyCheck:dict]) {
                [mainArray addObject:dict];
            }
        }
        for (int i =0; i<dietaryHealthArray.count; i++) {
            NSDictionary *dict = [dietaryHealthArray objectAtIndex:i];
            if (![Utility isEmptyCheck:dict]) {
                [mainArray addObject:dict];
            }
        }
        NSLog(@"%@",mainArray);
        [mainDict setObject:mainArray forKey:@"Values"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserID"];
     
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpateUserFlags" append:@""forAction:@"POST"];
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
                                                                         if (stepnumber == 0)
                                                                             [Utility msg:@"Saved Successful! Meals from yesterday and older will not be updated with the new settings" title:@"Success!" controller:self haveToPop:NO];
                                                                         if (!(stepnumber == 0)) {
                                                                             [self webSerViceCall_UpdateNutrationStep:false];
                                                                         }
                                                                         [self webSerViceCall_GetUserFlags];
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

-(void)webSerViceCall_GetUserFlags{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetUserFlags" append:[@"" stringByAppendingFormat:@"%@", [defaults objectForKey:@"ABBBCOnlineUserId"]] forAction:@"GET"];
        
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
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
                                                                         NSMutableArray *dietaryPreference =[responseDictionary objectForKey:@"obj"];
                                                                         if (![Utility isEmptyCheck:dietaryPreference]) {
                                                                                 dietaryPreferenceFoodArray = [[dietaryPreference filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagCategory == %@)", @"Dietary_Preference"]]mutableCopy];
                                                                                 NSLog(@"Dietary_PreferenceArray-%@",dietaryPreferenceFoodArray);
                                                                             
                                                                                 dietaryHealthArray = [[dietaryPreference filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagCategory == %@)", @"Dietary_Health"]]mutableCopy];
                                                                                 NSLog(@"dietaryHealthArray-%@",dietaryHealthArray);
                                                                             if (apiCount == 0) {
                                                                                  [collection reloadData];
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
//s 020518
-(void)getFoodPrepIngredients{
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
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetFoodPrepIngredients" append:@""forAction:@"POST"];
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
                                                                         if (![Utility isEmptyCheck:responseDict[@"Ingredients"]]) {
                                                                             [self makeIngrdientGroup:responseDict[@"Ingredients"]];
                                                                         }
                                                                         if (apiCount == 0) {
                                                                             [collection reloadData];
                                                                             [ingredientTable reloadData];
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
-(void)getSquadUserAvoidIngredientGroup{
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
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadUserAvoidIngredientGroup" append:@""forAction:@"POST"];
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
                                                                         
                                                                         if (![Utility isEmptyCheck:responseDict[@"SquadUserAvoidIngredientGroupList"]]) {
                                                                             myIngredientList = [responseDict[@"SquadUserAvoidIngredientGroupList"] mutableCopy];
                                                                         }else{
                                                                             
                                                                             if(myIngredientList.count>0)[myIngredientList removeAllObjects];
                                                                         }
                                                                         if (apiCount == 0) {
                                                                             [collection reloadData];
                                                                             [ingredientTable reloadData];
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
-(void)saveAvoidIngredientGroup:(NSString *)Group{
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
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:Group forKey:@"Group"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AvoidIngredientGroup" append:@""forAction:@"POST"];
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
                                                                         
                                                                         if (apiCount == 0) {
                                                                             [self getSquadUserAvoidIngredientGroup];
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
-(void)makeIngrdientGroup:(NSArray *)listArray{
    
    ingredientList = listArray;
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    [tempArray addObjectsFromArray:[ingredientList valueForKeyPath:@"@distinctUnionOfObjects.Group1"]];
    [tempArray addObjectsFromArray:[ingredientList valueForKeyPath:@"@distinctUnionOfObjects.Group2"]];
    tempArray = [tempArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
    tempArray = [[tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self != %@)",@""]]mutableCopy];
    [tempArray removeObjectIdenticalTo:[NSNull null]];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    tempArray = [[tempArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]]mutableCopy];
    
    ingredientList = tempArray;
    
}
-(void)removeAvoidIngredientGroup:(NSString *)Group{
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
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:Group forKey:@"Group"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"RemoveAvoidIngredientGroup" append:@""forAction:@"POST"];
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
                                                                         
                                                                         if (apiCount == 0) {
                                                                             [self getSquadUserAvoidIngredientGroup];
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
#pragma mark - End

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    vegArray = @[
                 @{
                     @"name" : @"Lacto-Ovo Vegetarian - consumes eggs and dairy",
                     @"key" : @"Lacto-Ovo",
                     @"value" : @2
                     },@{
                     @"name" : @"Vegan (no egg or dairy)",
                     @"key" : @"Vegan",
                     @"value" : @3
                     },@{
                     @"name" : @"Pescatarian (Consumes eggs, dairy and fish)",
                     @"key" : @"Pescatarian",
                     @"value" : @4
                     }
                 ];


    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
    if(![Utility isSubscribedUser]){
        menuButton.hidden = true;
        footerConstant.constant = 0;
    }else{
        menuButton.hidden = false;
        footerConstant.constant = 75;
    }
//    backToNutritionSettings.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
//    backToNutritionSettings.layer.borderWidth = 1;
    
    ingredientList = [[NSArray alloc]init];
    myIngredientList = [[NSMutableArray alloc]init];
    tempSearchArray = [[NSArray alloc]init];
    searchTable.hidden = true;
    cancelView.hidden = true;
    ingredientTable.estimatedRowHeight = 55;
    ingredientTable.rowHeight = UITableViewAutomaticDimension;
    searchTable.estimatedRowHeight = 45;
    searchTable.rowHeight = UITableViewAutomaticDimension;
    mainScroll.layer.cornerRadius = 7;
    mainScroll.layer.masksToBounds = YES;
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    searchTextField.layer.cornerRadius=3.0f;
    searchTextField.layer.masksToBounds=YES;
    searchTextField.layer.borderColor=[[Utility colorWithHexString:@"f1f1f1"]CGColor];
    searchTextField.layer.borderWidth= 1.0f;
    UIView *paddingViewMinCal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    searchTextField.leftView = paddingViewMinCal;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    [self registerForKeyboardNotifications];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    apiCount= 0;
    [collection addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [ingredientTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self webSerViceCall_SquadNutritionSettingStep];
        [self webSerViceCall_GetUserFlags];
        [self getSquadUserAvoidIngredientGroup];
        [self getFoodPrepIngredients];
    });
}

-(void)viewWillDisappear:(BOOL)animated{
    [collection removeObserver:self forKeyPath:@"contentSize"];
    [ingredientTable removeObserver:self forKeyPath:@"contentSize"];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == collection){
        collectionHeight.constant=collection.contentSize.height;
    }else if (object == ingredientTable){
        ingredientTableHeight.constant=ingredientTable.contentSize.height;
    }
    
}
#pragma mark  -End
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
    
    if (activeTextField != nil) {
        CGRect aRect = mainScroll.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            //          [mainScroll scrollRectToVisible:activeTextField.frame animated:YES];
            
        }
    }
    //    else if (activeTextView !=nil) {
    //        CGRect aRect = mainScroll.frame;
    //        CGRect frame = [mainScroll convertRect:activeTextView.frame fromView:activeTextView.superview];
    //        aRect.size.height -= kbSize.height;
    //        if (!CGRectContainsPoint(aRect,frame.origin) ) {
    //            [mainScroll scrollRectToVisible:frame animated:YES];
    //        }
    //    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
}
#pragma mark - End -
-(void)changeText:(UITextField *)textField{
    NSLog(@"search for %@", textField.text);
    if (textField.text.length > 0) {
        tempSearchArray = [ingredientList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self CONTAINS[c] %@)", textField.text]];
    } else {
        tempSearchArray = ingredientList;
    }
    [searchTable reloadData];
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
    [textField setInputAccessoryView:toolBar];
    textField.layer.cornerRadius=3.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[Utility colorWithHexString:@"e427a0"]CGColor];
    textField.layer.borderWidth= 1.0f;
    [textField addTarget:self
                  action:@selector(changeText:)
        forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
    textField.layer.cornerRadius=3.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[Utility colorWithHexString:@"f1f1f1"]CGColor];
    textField.layer.borderWidth= 1.0f;
    
    if ([textField isEqual:searchTextField]) {
        
    }
    [searchTextField resignFirstResponder];
}
#pragma mark - End
#pragma mark - Memeory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End

#pragma mark - CollectionViewDatasource & Delegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        DietaryCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DietaryCollectionReusableView" forIndexPath:indexPath];
        reusableview = headerView;
        if (indexPath.section ==0) {
             headerView.DieatrySectionLabel.text=@"Food";
        }else if (indexPath.section == 1){
            headerView.DieatrySectionLabel.text=@"Health";
        }
    }
    
    return reusableview;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
       return dietaryPreferenceFoodArray.count;
    }else if(section == 1){
        return dietaryHealthArray.count;
    }else{
        return 0;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"DietaryCollectionViewCell";
    
    DietaryCollectionViewCell *cell = (DietaryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.collectionMainView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    cell.collectionMainView.layer.borderWidth=1;
    
    if (indexPath.section == 0) {
        NSDictionary *dict =dietaryPreferenceFoodArray[indexPath.row];
        cell.dietaryFlagTitle.text=[dict objectForKey:@"FlagTitle"];
        
        if ([[dict objectForKey:@"FlagTitle"] isEqualToString:@"Vegetarian"]) {
                vegetarianIndex =(int)indexPath.row;
                vegetarianOption= [[dict objectForKey:@"Value"]intValue];
            
            if ([[dict objectForKey:@"Value"]intValue]>0) {
                NSDictionary *vegDict = [Utility getDictByValue:vegArray value:[dict objectForKey:@"Value"] type:@"value"];
                cell.dietaryFlagTitle.text=[NSString stringWithFormat:@"%@ (%@)",dict[@"FlagTitle"],vegDict[@"key"]];
//                [cell.checkUncheckButton setImage:[UIImage imageNamed:@"tick_ExDetails.png"]forState:UIControlStateNormal];
                cell.checkUncheckButton.selected = true;
                cell.collectionMainView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
            }else{
                cell.checkUncheckButton.selected = false;
//                [cell.checkUncheckButton setImage:[UIImage imageNamed:@""]forState:UIControlStateNormal];
                cell.collectionMainView.backgroundColor = [UIColor whiteColor];
            }
        }
        if ([[dict objectForKey:@"Value"]intValue]>0) {
            cell.checkUncheckButton.selected = true;
//            [cell.checkUncheckButton setImage:[UIImage imageNamed:@"tick_ExDetails.png"]forState:UIControlStateNormal];
            cell.collectionMainView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
            cell.dietaryFlagTitle.textColor = [UIColor whiteColor];

        }else{
            cell.checkUncheckButton.selected = false;
//            [cell.checkUncheckButton setImage:[UIImage imageNamed:@""]forState:UIControlStateNormal];
            cell.collectionMainView.backgroundColor = [UIColor whiteColor];
            cell.dietaryFlagTitle.textColor = [Utility colorWithHexString:@"E425A0"];
        }
        
    }else if(indexPath.section ==1){
         NSDictionary *dict =dietaryHealthArray[indexPath.row];
        
        cell.dietaryFlagTitle.text=[dict objectForKey:@"FlagTitle"];
        
        if (([[dict objectForKey:@"Value"]intValue]>0)) {
            cell.checkUncheckButton.selected = true;
//            [cell.checkUncheckButton setImage:[UIImage imageNamed:@"tick_ExDetails.png"]forState:UIControlStateNormal];
            cell.collectionMainView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
            cell.dietaryFlagTitle.textColor = [UIColor whiteColor];

        }else{
            cell.checkUncheckButton.selected = false;
//            [cell.checkUncheckButton setImage:[UIImage imageNamed:@""]forState:UIControlStateNormal];
            cell.collectionMainView.backgroundColor = [UIColor whiteColor];
            cell.dietaryFlagTitle.textColor = [Utility colorWithHexString:@"E425A0"];
        }

    }
    cell.checkUncheckButton.tag=indexPath.row;
    cell.checkUncheckButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
    //NSLog(@"%@",cell.checkUncheckButton.accessibilityHint);
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DietaryCollectionViewCell *cell = (DietaryCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (cell) {
            NSDictionary *dict =dietaryPreferenceFoodArray[indexPath.row];
            if ([[dict objectForKey:@"FlagTitle"] isEqualToString:@"Vegetarian"]) {
                if ([cell.checkUncheckButton.currentImage isEqual:[UIImage imageNamed:@""]]) {
                    [self setupView:-1];
                }else{
                    NSDictionary *temp = [Utility getDictByValue:vegArray value:dict[@"Value"] type:@"value"];
                    if (![Utility isEmptyCheck:temp]) {
                        int selectedIndex=(int) [vegArray indexOfObject:temp];
                        [self setupView:selectedIndex];
                    }else{
                        [self setupView:0];
                    }
                }
            }else{
                cell.checkUncheckButton.tag=indexPath.row;
                cell.checkUncheckButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
                [self checkUncheckButtonPressed:cell.checkUncheckButton];
            }
        }
    }else {
        if (cell) {
            cell.checkUncheckButton.tag=indexPath.row;
            cell.checkUncheckButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
            [self checkUncheckButtonPressed:cell.checkUncheckButton];
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat divisor = 2.0;
//    if (screenWidth > 320) {
//        divisor = 3.0;
//    }
    float cellWidth = (screenWidth-10) / divisor; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(cellWidth,40);
    
    return size;
}

#pragma mark - End
#pragma mark - TableViewDatasource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:ingredientTable]) {
        return myIngredientList.count;
    } else if ([tableView isEqual:searchTable]) {
        return tempSearchArray.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell;
    DietaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DietaryTableViewCell"];
    if ([tableView isEqual:ingredientTable]) {
        cell.ingredientName.text = ![Utility isEmptyCheck:myIngredientList[indexPath.row][@"Group"]]?myIngredientList[indexPath.row][@"Group"]:@"";
        cell.deleteButton.tag = indexPath.row;
        tableCell = cell;
    } else if([tableView isEqual:searchTable]){
        cell.ingredientName.text = ![Utility isEmptyCheck:tempSearchArray[indexPath.row]]?tempSearchArray[indexPath.row]:@"";
        tableCell = cell;
    }
    return tableCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:searchTable]) {
        searchTable.hidden = true;
        cancelView.hidden = true;
        NSArray *temp = [myIngredientList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Group == %@)",tempSearchArray[indexPath.row]]];
        if (temp.count>0) {
            //
        }else{
            [self saveAvoidIngredientGroup:tempSearchArray[indexPath.row]];
        }
        [searchTextField resignFirstResponder];
    }
    
}

#pragma mark - End
#pragma mark - PopoverViewDelegate
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData{
    if ([type caseInsensitiveCompare:@"Veg"] == NSOrderedSame) {
        NSMutableDictionary *dict =[[dietaryPreferenceFoodArray objectAtIndex:vegetarianIndex]mutableCopy];
        [dict setValue:selectedData[@"value"] forKey:@"Value"];
        [dietaryPreferenceFoodArray replaceObjectAtIndex:vegetarianIndex withObject:dict];
        [self webSerViceCall_AddUpateUserFlags];
    }
}

    
-(void)didCancelDropdownOption{
//    [self dismissViewControllerAnimated:YES completion:^{
//        NSMutableDictionary *dict =[[dietaryPreferenceFoodArray objectAtIndex:vegetarianIndex]mutableCopy];
//        [dict setValue:[NSNumber numberWithInt:2] forKey:@"Value"];
//        [dietaryPreferenceFoodArray replaceObjectAtIndex:vegetarianIndex withObject:dict];
//        [self webSerViceCall_AddUpateUserFlags];
//    }];
    [collection reloadData];
}
#pragma mark - End


@end
