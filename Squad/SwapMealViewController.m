//
//  SwapMealViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 13/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "SwapMealViewController.h"

@interface SwapMealViewController (){
    IBOutlet UIButton *mealNameButton;
    IBOutlet UIView *containerView;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *advanceSearchButton;
    NSArray *dietaryPreferenceArray;


    NSDictionary *selectedMealDict;
    NSArray *mealListArray;
    UIView *contentView;
    int apiCount;

}

@end

@implementation SwapMealViewController
@synthesize mealId,mealSessionId,delegate,mealDate;

#pragma mark -PrivateMethod
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
//        NSError *error;
//        if (!isFromAdvanceSearch) {
//            [self setDefaultSearchParameter];
//        }
        NSDictionary *filterDict = [self setUserPreference];
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:filterDict];
        //NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMealsWithUserFlagsApiCall" append:@""forAction:@"POST"];
        
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
                                                                         if (![Utility isEmptyCheck:tempRecipeList] && tempRecipeList.count > 0) {
                                                                             NSMutableArray *allUserCreatedRecipesArray=[[NSMutableArray alloc]init];
                                                                             NSMutableArray *otherRecipesArray=[[NSMutableArray alloc]init];

                                                                             for (NSDictionary *dict in tempRecipeList) {
                                                                                 NSDictionary *mealDetails = dict[@"mealdetail"];
                                                                                 if (![Utility isEmptyCheck:mealDetails]) {
                                                                                     if (![Utility isEmptyCheck:mealDetails[@"UserId"]] && [mealDetails[@"UserId"] isEqualToNumber:[defaults objectForKey:@"ABBBCOnlineUserId"]]) {
                                                                                         [allUserCreatedRecipesArray addObject:mealDetails];
                                                                                     }else{
                                                                                         [otherRecipesArray addObject:mealDetails];
                                                                                     }
                                                                                 }
                                                                                 
                                                                             }
                                                                             NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"MealName"  ascending:YES selector:@selector(caseInsensitiveCompare:)];
                                                                             
                                                                             allUserCreatedRecipesArray=[[allUserCreatedRecipesArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]] mutableCopy];
                                                                             otherRecipesArray=[[otherRecipesArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]] mutableCopy];
                                                                             NSMutableArray *mixedArray = [[NSMutableArray  alloc]init];
                                                                             [mixedArray addObjectsFromArray:allUserCreatedRecipesArray];
                                                                             [mixedArray addObjectsFromArray:otherRecipesArray];
                                                                             mealListArray=mixedArray;
                                                                             if (apiCount == 0) {
                                                                             }
                                                                         }else{
                                                                             [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                                                                             return;
                                                                         }
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
-(void)squadUpdateMealForSessionApiCall{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealSessionId forKey:@"MealSessionId"];
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
                                                                             [self dismissViewControllerAnimated:YES completion:^{
                                                                                 if ([delegate respondsToSelector:@selector(didCancel)]) {
                                                                                     [delegate didCancel];
                                                                                 }
                                                                             }];

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
#pragma mark -End

#pragma mark -IBAction
- (IBAction)advanceSearchButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([delegate respondsToSelector:@selector(didSelectAdvanceSearch:mealSessionId:mealDate:)]) {
            [delegate didSelectAdvanceSearch:mealId mealSessionId:mealSessionId mealDate:mealDate];
        }
    }];
}
- (IBAction)saveButtonPressed:(UIButton *)sender {
    if (selectedMealDict) {
        [self squadUpdateMealForSessionApiCall];
    }else{
        [Utility msg:@"Please select Meal first." title:@"Warning !" controller:self haveToPop:NO];
        return;
    }
}
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)mealButtonPressed:(UIButton *)sender {
    if (mealListArray.count > 0) {
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = mealListArray;
        controller.mainKey = @"MealName";
        controller.apiType = @"MealName";
        controller.selectedIndex =-1;
        controller.sender = sender;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];

    }
}
#pragma mark -End


#pragma mark -ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    containerView.layer.cornerRadius = 5;
    containerView.clipsToBounds = YES;
    saveButton.layer.cornerRadius = 5;
    saveButton.clipsToBounds = YES;
    cancelButton.layer.cornerRadius = 5;
    cancelButton.clipsToBounds = YES;
    advanceSearchButton.layer.cornerRadius = 5;
    advanceSearchButton.clipsToBounds = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getUnitPreference];
    });
}
#pragma mark -End
#pragma -mark DropDownViewDelegate
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData sender:(UIButton *)sender{
    if ([type caseInsensitiveCompare:@"MealName"] == NSOrderedSame) {
        selectedMealDict = selectedData;
        [sender setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sender setTitle:[selectedData objectForKey:@"MealName"] forState:UIControlStateNormal];
    }
}
#pragma -mark End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
