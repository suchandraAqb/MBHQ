//
//  MealSwapDropDownViewController.m
//  Squad
//
//  Created by AQB Solutions Private Limited on 15/05/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "MealSwapDropDownViewController.h"
#import "MealSwapDropDownTableViewCell.h"
#import "MealSwapDropDownHeaderView.h"
#import "FoodPrepSearchViewController.h"
static NSString *SectionHeaderViewIdentifier = @"MealSwapDropDownHeaderView";

@interface MealSwapDropDownViewController (){
    
    __weak IBOutlet UILabel *headerTitleLabel;
    __weak IBOutlet UITableView *listTable;
    
    __weak IBOutlet UIButton *saveButton;
    __weak IBOutlet UIButton *applyToAllButton;
    __weak IBOutlet UIButton *advancedSearchButton;
    __weak IBOutlet UIButton *cancelButton;
    NSMutableArray *mealListArray;
    NSMutableArray *selectedMealArray;
    NSMutableArray *sectionCollaped;
    NSArray *dietaryPreferenceArray;
    UIView *contentView;
    int apiCount;
    
}

@end

@implementation MealSwapDropDownViewController
@synthesize mealSessionIdToReplace,delegate;
#pragma mark-View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    apiCount = 0;
    [self setupView];
    //[self getUnitPreference];
    [self getMealList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-End

#pragma mark-Private Method
-(void)setupView{
    cancelButton.layer.borderColor = [Utility colorWithHexString:@"e425a0"].CGColor;
    cancelButton.layer.borderWidth = 1.0;
    if(_isFromFoodPrep){
        applyToAllButton.hidden = true;
        headerTitleLabel.text = @"SELECT MEAL TO PREP";
    }
    
    listTable.sectionHeaderHeight = UITableViewAutomaticDimension;
    listTable.estimatedSectionHeaderHeight = 60;
    
    if(!sectionCollaped){
      sectionCollaped = [NSMutableArray new];
    }
    
    if(!mealListArray){
        mealListArray = [NSMutableArray new];
    }
    
    if(!selectedMealArray){
        selectedMealArray = [NSMutableArray new];
    }
        
    listTable.sectionHeaderHeight = 50;
    listTable.sectionFooterHeight = 10;
    //listTable.estimatedSectionHeaderHeight = 60;
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:SectionHeaderViewIdentifier bundle:nil];
    [listTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
        
}

-(void)createCustomMeallist:(NSMutableArray *)tempRecipeList{
    
    if (![Utility isEmptyCheck:tempRecipeList] && tempRecipeList.count > 0) {
        
        if(!mealListArray){
            mealListArray = [NSMutableArray new];
        }else{
            [mealListArray removeAllObjects];
        }
        
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"MealDetail.MealName"  ascending:YES selector:@selector(caseInsensitiveCompare:)];
        
        NSPredicate *breakfast =
        [NSPredicate predicateWithFormat:@"self.MealDetail.IsBreakfast == YES"];
        NSArray *breakfastArray = [tempRecipeList filteredArrayUsingPredicate:breakfast];
        if(breakfastArray.count){
            
            breakfastArray = [breakfastArray sortedArrayUsingDescriptors:@[descriptor]];
            NSMutableDictionary *dict=[NSMutableDictionary new];
            [dict setObject:@"Breakfast" forKey:@"MealType"];
            [dict setObject:breakfastArray forKey:@"MealList"];
            [mealListArray addObject:dict];
        }
        
        NSPredicate *lunch =
        [NSPredicate predicateWithFormat:@"self.MealDetail.IsLunch == YES"];
        NSArray *lunchArray = [tempRecipeList filteredArrayUsingPredicate:lunch];
        if(lunchArray.count){
            lunchArray = [lunchArray sortedArrayUsingDescriptors:@[descriptor]];
            NSMutableDictionary *dict=[NSMutableDictionary new];
            [dict setObject:@"Lunch" forKey:@"MealType"];
            [dict setObject:lunchArray forKey:@"MealList"];
            [mealListArray addObject:dict];
        }
        
        NSPredicate *dinner =
        [NSPredicate predicateWithFormat:@"self.MealDetail.IsDinner == YES"];
        NSArray *dinnerArray = [tempRecipeList filteredArrayUsingPredicate:dinner];
        if(dinnerArray.count){
            dinnerArray = [dinnerArray sortedArrayUsingDescriptors:@[descriptor]];
            NSMutableDictionary *dict=[NSMutableDictionary new];
            [dict setObject:@"Dinner" forKey:@"MealType"];
            [dict setObject:dinnerArray forKey:@"MealList"];
            [mealListArray addObject:dict];
        }
        
        NSPredicate *snack =
        [NSPredicate predicateWithFormat:@"self.MealDetail.IsSnack == YES"];
        NSArray *snackArray = [tempRecipeList filteredArrayUsingPredicate:snack];
        if(snackArray.count){
            snackArray = [snackArray sortedArrayUsingDescriptors:@[descriptor]];
            NSMutableDictionary *dict=[NSMutableDictionary new];
            [dict setObject:@"Snack" forKey:@"MealType"];
            [dict setObject:snackArray forKey:@"MealList"];
            [mealListArray addObject:dict];
        }
        
        //NSLog(@"MealList:%@",mealListArray);
        
        if(sectionCollaped.count == 0){
            for(int i=0 ;i<mealListArray.count;i++){
                
                if(i==0) continue;
                
                if(![sectionCollaped containsObject:[NSNumber numberWithInteger:i]]){
                    [sectionCollaped addObject:[NSNumber numberWithInteger:i]];
                }
            }
        }
        
        [listTable reloadData];
        
       // NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"MealName"  ascending:YES selector:@selector(caseInsensitiveCompare:)];
        
        
        //mealListArray;
    }
    
}

-(void)swapCompleteAction{
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Success"
                                  message:@"Meal swapped successfully."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             if([self->delegate respondsToSelector:@selector(didSwapComplete:)]){
                                 [self->delegate didSwapComplete:YES];
                             }
                             
                             [self.navigationController popViewControllerAnimated:YES];
                         }];
    
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(NSDictionary *)setUserPreference{
    NSMutableDictionary *searchDict = [[NSMutableDictionary alloc]init];
    NSArray *filterArray =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"Gluten Free"]];
    if (filterArray.count > 0) {
        NSDictionary *dict = filterArray[0];
        if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
            [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"GlutenFree"];
        }else{
            [searchDict removeObjectForKey:@"GlutenFree"];
        }
    }
    NSArray *filterArray1 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"Dairy Free"]];
    if (filterArray1.count > 0) {
        NSDictionary *dict = filterArray1[0];
        if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
            [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"DairyFree"];
        }else{
            [searchDict removeObjectForKey:@"DairyFree"];
        }
    }
    NSArray *filterArray2 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"No Red Meat"]];
    if (filterArray2.count > 0) {
        NSDictionary *dict = filterArray2[0];
        if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
            [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"NoRedMeat"];
        }else{
            [searchDict removeObjectForKey:@"NoRedMeat"];
        }
    }
    NSArray *filterArray3 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"No Seafood"]];
    if (filterArray3.count > 0) {
        NSDictionary *dict = filterArray3[0];
        if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
            [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"NoSeaFood"];
        }else{
            [searchDict removeObjectForKey:@"NoSeaFood"];
        }
    }
    NSArray *filterArray10 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"No Sea Food"]];
    if (filterArray10.count > 0) {
        NSDictionary *dict = filterArray10[0];
        if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
            [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"NoSeaFood"];
        }else{
            [searchDict removeObjectForKey:@"NoSeaFood"];
        }
    }
    NSArray *filterArray4 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"FODMAP Friendly"]];
    if (filterArray4.count > 0) {
        NSDictionary *dict = filterArray4[0];
        if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
            [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"FodmapFriendly"];
        }else{
            [searchDict removeObjectForKey:@"FodmapFriendly"];
        }
    }
    //        NSArray *filterArray5 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"Paleo Friendly"]];
    //        if (filterArray5.count > 0) {
    //            NSDictionary *dict = filterArray5[0];
    //            if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
    //                [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"PaleoFriendly"];
    //            }else{
    //                [searchDict removeObjectForKey:@"PaleoFriendly"];
    //            }
    //        }
    NSArray *filterArray6 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"No Eggs"]];
    if (filterArray6.count > 0) {
        NSDictionary *dict = filterArray6[0];
        if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
            [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"NoEggs"];
        }else{
            [searchDict removeObjectForKey:@"NoEggs"];
        }
    }
    NSArray *filterArray7 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"No Nuts"]];
    if (filterArray7.count > 0) {
        NSDictionary *dict = filterArray7[0];
        if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
            [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"NoNuts"];
        }else{
            [searchDict removeObjectForKey:@"NoNuts"];
        }
    }
    NSArray *filterArray8 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"No Legumes"]];
    if (filterArray8.count > 0) {
        NSDictionary *dict = filterArray8[0];
        if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
            [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"NoLegumes"];
        }else{
            [searchDict removeObjectForKey:@"NoLegumes"];
        }
    }
    NSArray *filterArray9 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"Vegetarian"]];
    if (filterArray9.count > 0) {
        NSDictionary *dict = filterArray9[0];
        if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
            [searchDict setObject:[NSNumber numberWithInt:[dict[@"Value"] intValue]] forKey:@"Vegetarian"];
        }else{
            [searchDict removeObjectForKey:@"Vegetarian"];
        }
    }
    return  searchDict;
}
#pragma mark-End

#pragma mark-WebServiceCall


-(void)getUnitPreference{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSString *userId =[@"" stringByAppendingFormat:@"%@",[defaults objectForKey:@"ABBBCOnlineUserId"]];
        
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetUserFlags" append:userId forAction:@"GET"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 apiCount--;
                                                                 if (apiCount == 0 && contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     //NSLog(@"data by chayan: \n\n %@",responseString);
                                                                     
                                                                     
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else {
                                                                             NSArray *preferenceAll = [responseDictionary objectForKey:@"obj"];
                                                                             dietaryPreferenceArray = [preferenceAll filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagCategory == %@)", @"Dietary_Preference"]];
                                                                             [self getMealList];
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
-(void)getMealList{
    if (Utility.reachable) {
        
        //NSDictionary *filterDict = [self setUserPreference];
        //NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:filterDict];
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[NSNumber numberWithBool:YES] forKey:@"OnlySquad"];
        [mainDict setObject:[NSNumber numberWithBool:NO] forKey:@"OnlyAbbbcOnline"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetQuickMealsWithUserFlags" append:@""forAction:@"POST"];
        
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]){
                                                                         NSMutableArray *tempRecipeList = [responseDict[@"Meals"] mutableCopy];
                                                                        
                                                                         [self createCustomMeallist:tempRecipeList];
                                                                         
                                                                     }else{
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

-(void)squadUpdateMealForSessionApiCall:(NSDictionary *)selectedMealDict{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:mealSessionIdToReplace] forKey:@"MealSessionId"];
        [mainDict setObject:selectedMealDict[@"Id"] forKey:@"NewMealId"];
        
        
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
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadUpdateMealForSessionApiCall" append:@"" forAction:@"POST"];
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
                                                                         } else {
                                                                             [self swapCompleteAction];
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



#pragma mark-End

#pragma mark-IBAction

- (IBAction)selectButtonPressed:(UIButton *)sender {
    
    int selectedSection = (int)sender.tag;
    int selectedRow = [sender.accessibilityHint intValue];
    
    NSDictionary *dict = mealListArray[selectedSection];
    if (![Utility isEmptyCheck:dict]) {
        NSArray *list = dict[@"MealList"];
        NSDictionary *dataDict = list[selectedRow];
        
        if([selectedMealArray containsObject:dataDict]){
            [selectedMealArray removeObject:dataDict];
            
        }else{
            if(!selectedMealArray){
                selectedMealArray = [NSMutableArray new];
            }else{
                [selectedMealArray removeAllObjects];
            }
            
            [selectedMealArray addObject:dataDict];
        }
        
        [listTable reloadData];
        
    }
}


- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    if(!selectedMealArray.count){
        [Utility msg:@"Please select meal first" title:@"" controller:self haveToPop:NO];
    }else{
        if(_isFromFoodPrep){
            
            if ([delegate respondsToSelector:@selector(didSelectMeal:)]) {
                [delegate didSelectMeal:[selectedMealArray firstObject]];
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            NSDictionary *mealDict = [selectedMealArray firstObject];
            if(![Utility isEmptyCheck:mealDict[@"MealDetail"]]){
                [self squadUpdateMealForSessionApiCall:mealDict[@"MealDetail"]];
            }
        }
        
    }
}

- (IBAction)applyMultipleButtonPressed:(UIButton *)sender {
    
    if(!selectedMealArray.count){
        [Utility msg:@"Please select meal first" title:@"" controller:self haveToPop:NO];
        return;
    }
    
    NSDictionary *mealDict = [selectedMealArray firstObject];
    if(![Utility isEmptyCheck:mealDict[@"MealDetail"]]){
        if ([delegate respondsToSelector:@selector(didMultiSwapCompleteWithDropdown:)]) {
            [delegate didMultiSwapCompleteWithDropdown:[selectedMealArray firstObject]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)advancedSearchButtonPressed:(UIButton *)sender {
    FoodPrepSearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrepSearch"];
    controller.delegate = _controllerNeedToUpdate;
    controller.sender = sender;
    controller.isFromFoodPrep = _isFromFoodPrep;
    controller.mealSessionIdToReplace = mealSessionIdToReplace;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)expandCollapseButtonPressed:(UIButton *)sender{
    
    if([sectionCollaped containsObject:[NSNumber numberWithInteger:sender.tag]]){
        [sectionCollaped removeObject:[NSNumber numberWithInteger:sender.tag]];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:sender.tag];
        [listTable reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
        [listTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }else{
        [sectionCollaped addObject:[NSNumber numberWithInteger:sender.tag]];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:sender.tag];
        [listTable reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
        [listTable setContentOffset:CGPointZero animated:NO];
    }
    
}

#pragma mark-End

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return mealListArray.count;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MealSwapDropDownHeaderView *sectionHeaderView = (MealSwapDropDownHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    NSDictionary *dict = mealListArray[section];
    if (![Utility isEmptyCheck:dict]) {
        
            //sectionHeaderView.dataTypeLabel.text = model[@"headerTitle"];
            sectionHeaderView.dataTypeLabel.text = [dict[@"MealType"] uppercaseString];
            sectionHeaderView.expandCollapseButton.tag = section;
            [sectionHeaderView.expandCollapseButton addTarget:self
                                                       action:@selector(expandCollapseButtonPressed:)
                                             forControlEvents:UIControlEventTouchUpInside];
            
            if([sectionCollaped containsObject:[NSNumber numberWithInteger:section]]){
                [sectionHeaderView.expandCollapseButton setImage:[UIImage imageNamed:@"plus_setprogram"] forState:UIControlStateNormal];
            }else{
                [sectionHeaderView.expandCollapseButton setImage:[UIImage imageNamed:@"minus_setprogram"] forState:UIControlStateNormal];
            }
        
    }
    
    
    
    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, tableView.sectionFooterHeight)];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        // Return the number of rows in the section
        
        if([sectionCollaped containsObject:[NSNumber numberWithInteger:section]]){
            return 0;
        }
        NSDictionary *dict = mealListArray[section];
        NSArray *list = dict[@"MealList"];
        return list.count;
}
    
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"MealSwapDropDownTableViewCell";
    MealSwapDropDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MealSwapDropDownTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = mealListArray[indexPath.section];
    if (![Utility isEmptyCheck:dict]) {
        NSArray *list = dict[@"MealList"];
        NSDictionary *dataDict = list[indexPath.row];
        
        if(![Utility isEmptyCheck:dataDict]){
            
            if([selectedMealArray containsObject:dataDict]){
                
                [cell.selectButton setImage:[[UIImage imageNamed:@"ex_edit_tick.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                [cell.selectButton setTintColor:[Utility colorWithHexString:@"e425a0"]];
                [cell.selectButton setTitle:@"" forState:UIControlStateNormal];
            }else{
                [cell.selectButton setImage:nil forState:UIControlStateNormal];
                [cell.selectButton setTintColor:[UIColor clearColor]];
                [cell.selectButton setTitle:@"SELECT" forState:UIControlStateNormal];
            }
            
        }
        
        if(![Utility isEmptyCheck:dataDict[@"MealDetail"]]){
            NSDictionary *mealDetailDict = dataDict[@"MealDetail"];
            NSString *dataStr = @"";
            if(![Utility isEmptyCheck:mealDetailDict[@"MealName"]]){
                dataStr = mealDetailDict[@"MealName"];
            }
            
            cell.mealNameLabel.text = dataStr;
            
            int clasifiedId = [mealDetailDict[@"MealClassifiedID"] intValue];
            if(clasifiedId == 2){
                cell.unmeasuredButton.hidden = false;
            }else{
                cell.unmeasuredButton.hidden = true;
            }
            
            if(![Utility isEmptyCheck:mealDetailDict[@"UserId"]]){
                cell.myMealButton.hidden = false;
            }else{
                cell.myMealButton.hidden = true;
            }
        }
        
        if(![Utility isEmptyCheck:dataDict[@"UserFavoriteMealdetail"]]){
            NSDictionary *favDict = dataDict[@"UserFavoriteMealdetail"];
            BOOL isFav = [favDict[@"IsFavorite"] boolValue];
            
            if(isFav){
               cell.myfavButton.hidden = false;
            }else{
               cell.myfavButton.hidden = true;
            }
        }
        
        
    }
    
    
    cell.selectButton.tag = (int)indexPath.section;
    cell.selectButton.accessibilityHint = [@"" stringByAppendingFormat:@"%@",[NSNumber numberWithInteger:indexPath.row]];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 60;
}


#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark End

@end
