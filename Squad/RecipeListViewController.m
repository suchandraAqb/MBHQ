//
//  RecipeListViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 19/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "RecipeListViewController.h"
#import "RecipeListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RecipeListViewController (){
    IBOutlet UILabel *blankMsgLabel;
    IBOutlet UILabel *mealType;
    IBOutlet UITextField *searchTextField;
    IBOutlet UIButton *searchButton;
    IBOutlet UIButton *showImagesButton;
    IBOutlet UIScrollView *scrollview;
    IBOutlet UITableView *table;
    IBOutletCollection(UIButton) NSArray *mealTypeButton;
    IBOutlet UIButton *saveAll;

    IBOutlet UILabel *swapMealLabel;
    IBOutlet UIButton *advanceSearchButton;
    IBOutlet UIButton *myPreferenceButton;
    IBOutlet UIButton *createRecipeButton;
    
    IBOutlet UIButton *saveAvoidOrNotButton;

    
    int apiCount;
    UIView *contentView;
    NSMutableArray *recipeList;
    NSDictionary *filterDict;
    NSArray *dietaryPreferenceArray;
    NSMutableArray *avoidAllArray;
 
    //shabbir
    IBOutlet UIButton *arrowButton;
    IBOutlet UIView *mealTypeView;
    int editRowNumber;
    BOOL isFav;
    NSArray *favrtDict;
    BOOL isChanged;
    BOOL isFirstTime;
    
    __weak IBOutlet UIView *animationView;
    __weak IBOutlet UIImageView *animationImage;
    __weak IBOutlet UILabel *msgLabel;
    NSArray *ingredientList;
//    NSArray *dietaryPreferenceArray;
}

@end

@implementation RecipeListViewController
@synthesize mealId,mealSessionId,mealDate;

#pragma mark -Private Method
-(void)save{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:avoidAllArray forKey:@"AvoidMealData"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            recipeList = [[NSMutableArray alloc]init];
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            table.hidden = true;
            blankMsgLabel.hidden = false;
            contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AvoidMealDataApiCall" append:@""forAction:@"POST"];
        
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
                                                                         avoidAllArray = [[NSMutableArray alloc]init];
                                                                         saveAll.hidden = true;
                                                                         [self getRecipeList:NO];
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
- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {
    if (avoidAllArray.count >0) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Save Changes"
                                              message:@"Your changes will be lost if you don’t save them."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Save"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self save];
                                       response(NO);
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Don't Save"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           avoidAllArray = [[NSMutableArray alloc]init];
                                           response(YES);
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        response(YES);
    }
}
-(IBAction)saveAvoidMealData:(UIButton *)sender{
    if (![Utility isEmptyCheck:avoidAllArray]) {
        [self save];
    }
}
-(void)setDefaultSearchParameter{
    
    if([defaults boolForKey:@"MyPreference"])
    {
        NSMutableDictionary *searchDict = [[NSMutableDictionary alloc]initWithDictionary:filterDict];
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
        filterDict = searchDict;
    }else{
        NSMutableDictionary *searchDict = [[NSMutableDictionary alloc]initWithDictionary:filterDict];
        [searchDict removeObjectForKey:@"GlutenFree"];
        [searchDict removeObjectForKey:@"DairyFree"];
        [searchDict removeObjectForKey:@"NoRedMeat"];
        [searchDict removeObjectForKey:@"NoSeaFood"];
        [searchDict removeObjectForKey:@"FodmapFriendly"];
        [searchDict removeObjectForKey:@"NoEggs"];
        [searchDict removeObjectForKey:@"NoNuts"];
        [searchDict removeObjectForKey:@"NoLegumes"];
        [searchDict removeObjectForKey:@"Vegetarian"];
        filterDict = searchDict;

    }
}
-(void)getRecipeList:(BOOL)isFromAdvanceSearch{
    if (Utility.reachable) {
        recipeList = [[NSMutableArray alloc]init];
        NSError *error;
        if (!isFromAdvanceSearch) {
            [self setDefaultSearchParameter];
        }
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:filterDict];

        [mainDict setObject:[NSNumber numberWithBool:YES] forKey:@"OnlySquad"];
        [mainDict setObject:[NSNumber numberWithBool:NO] forKey:@"OnlyAbbbcOnline"];        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
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
            self->table.hidden = true;
            self->blankMsgLabel.hidden = false;
            self->contentView = [Utility activityIndicatorView:self];
            
            self->animationView.hidden = false;
            [self.view bringSubviewToFront:self->animationView];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetFoodPrepMealsWithUserFlags" append:@""forAction:@"POST"]; //GetMealsWithUserFlagsApiCall
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 self->animationView.hidden = true;
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->recipeList = [responseDict[@"Meals"] mutableCopy];
                                                                         if (![Utility isEmptyCheck:self->recipeList] && self->recipeList.count > 0) {
                                                                             NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"mealdetail.MealName"  ascending:YES selector:@selector(caseInsensitiveCompare:)];
                                                                             
                                                                             self->recipeList=[[self->recipeList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]] mutableCopy];
                                                                             //
                                                                             NSArray *tempFavDict = [[recipeList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(UserFavoriteMealdetail.IsFavorite == true)"]]mutableCopy];
                                                                             self->favrtDict = tempFavDict;                                                                             //
                                                                             if (self->apiCount == 0) {
                                                                                 [self->table reloadData];
                                                                                 self->table.hidden = false;
                                                                                 self->blankMsgLabel.hidden = true;
                                                                                 self->mealTypeView.hidden = true;    //shabbir
                                                                                 self->arrowButton.selected = false;
                                                                                 if(self->isFav && self->favrtDict.count == 0){
                                                                                     self->table.hidden = true;
                                                                                     self->blankMsgLabel.hidden = false;
                                                                                 }
                                                                                 
                                                                             }
                                                                         }else{
                                                                             self->table.hidden = true;
                                                                             self->blankMsgLabel.hidden = false;
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
                                                                             [self getRecipeList:NO];
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
-(void)squadUpdateMealForSessionApiCall:(NSDictionary *)selectedMealDict{
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
                                                                             [Utility msg:@"Meal swapped successfully." title:@"Success" controller:self haveToPop:YES];
                                                                             ;
                                                                             
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
-(void)updateMealTypeButtons:(UIButton *)sender{
    for (UIButton *button in mealTypeButton) {
        
        if ([button isEqual:sender]) {
            if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"] && ([mealTypeButton.lastObject isEqual:sender] || [mealTypeButton[mealTypeButton.count - 2] isEqual:sender])) {
                [Utility showTrailLoginAlert:self ofType:self];
                return;
            }
            NSString *mealTypeString =[button.titleLabel.text capitalizedString];
            mealType.text = mealTypeString;
            mealTypeString = [mealTypeString stringByReplacingOccurrencesOfString:@" " withString:@""];
            button.selected = true;
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1].CGColor;
            button.layer.borderWidth = 2;
//            filterDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],mealTypeString, nil];

        }else{
            button.selected = false;
            [button setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }

    }
}
-(void)favoriteMealToggleApiCall:(NSNumber *)mealId{
    if (Utility.reachable) {
        
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
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"FavoriteMealToggle" append:@""forAction:@"POST"];
        
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
                                                                         
                                                                         NSLog(@"%@", responseDict);
                                                                         [self getRecipeList:NO];
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

-(void)goToAdvancedSearch{
    FoodPrepSearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrepSearch"];
    controller.delegate=self;
    controller.isFromRecipe = YES;
    if (![Utility isEmptyCheck:filterDict]) {
        controller.defaultSearchDict = [filterDict mutableCopy];
    }
    if (![Utility isEmptyCheck:ingredientList]) {
        controller.ingredientsAllList = ingredientList;
    }
    if (![Utility isEmptyCheck:dietaryPreferenceArray]) {
        controller.dietaryPreferenceArray = dietaryPreferenceArray;
    }
    [self.navigationController pushViewController:controller animated:NO];
    
}
#pragma mark -End
#pragma mark -IBAction
-(IBAction)mypreferenceCheckUncheckButtonPressed:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    [defaults setBool:sender.selected forKey:@"MyPreference"];
    if(myPreferenceButton.isSelected){
        [myPreferenceButton setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1]];
    }else{
        [myPreferenceButton setBackgroundColor:[UIColor whiteColor]];
    }
    [self getRecipeList:NO];

}
-(IBAction)advanceSearchButtonPressed:(UIButton *)sender{
    NutritionAdvanceSearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionAdvanceSearchView"];
    controller.delegate=self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)editButtonPressed:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        editRowNumber = (int)sender.tag;
    } else {
        editRowNumber = -1;
    }
    [table reloadData];
}
-(IBAction)updateMealSettingPressed:(UIButton *)sender{
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            NSDictionary *dict;
            if (isFav) {
                dict = favrtDict[sender.tag];
            } else {
                dict = recipeList[sender.tag];
            }
            NSDictionary *mealDetails = dict[@"mealdetail"];
            CustomNutritionMealSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionMealSettingsViewController"];
            controller.mealId = [mealDetails objectForKey:@"Id"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
}
-(IBAction)editRecipePressed:(UIButton *)sender{
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            NSDictionary *dict;
            if (isFav) {
                dict = favrtDict[sender.tag];
            } else {
                dict = recipeList[sender.tag];
            }
            if (![Utility isEmptyCheck:dict]) {
                NSDictionary *mealDetails = dict[@"mealdetail"];
                if (![Utility isEmptyCheck:mealDetails]) {
                    AddEditCustomNutritionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddEditCustomNutrition"];
                    controller.mealId = mealDetails[@"Id"];
                    controller.fromController = @"Recipe";        //ah ux
                    controller.delegate = self;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }
    }];
}
-(IBAction)avoidAllOrNotButtonPressed:(UIButton *)sender{
    NSMutableDictionary *dict = [recipeList[sender.tag] mutableCopy];
    if (![Utility isEmptyCheck:dict]) {
        NSMutableDictionary *mealDetails = [dict[@"mealdetail"] mutableCopy];
        if (![Utility isEmptyCheck:mealDetails]) {
            sender.selected = !sender.isSelected;
            CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:table];
            NSIndexPath *indexPath = [table indexPathForRowAtPoint:buttonPosition];
            RecipeListTableViewCell *cell = (RecipeListTableViewCell *)[table cellForRowAtIndexPath:indexPath];
            cell.breakfastButton.selected =!sender.selected;
            cell.lunchButton.selected =!sender.selected;
            cell.dinnerButton.selected =!sender.selected;
            cell.snackButton.selected =!sender.selected;
            NSMutableDictionary *userMealFlagdetail = [dict[@"UserMealFlagdetail"] mutableCopy];
            if ([Utility isEmptyCheck:userMealFlagdetail]) {
                userMealFlagdetail = [[NSMutableDictionary alloc]init];
            }
            [userMealFlagdetail setObject:[NSNumber numberWithBool:sender.isSelected] forKey:@"AvoidBreakfast"];
            [userMealFlagdetail setObject:[NSNumber numberWithBool:sender.isSelected] forKey:@"AvoidDinner"];
            [userMealFlagdetail setObject:[NSNumber numberWithBool:sender.isSelected] forKey:@"AvoidLunch"];
            [userMealFlagdetail setObject:[NSNumber numberWithBool:sender.isSelected] forKey:@"AvoidSnack"];
            [userMealFlagdetail setObject:[NSNumber numberWithBool:sender.isSelected] forKey:@"AvoidAll"];
            [dict setObject:userMealFlagdetail forKey:@"UserMealFlagdetail"];
            [recipeList replaceObjectAtIndex:sender.tag withObject:dict];
            [table reloadData];
            

            for (int i=0; i<4; i++) {
                NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
                [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
                [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
                [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
                [mainDict setObject:[NSNumber numberWithInt:i+1] forKey:@"MealType"];
                [mainDict setObject:mealDetails[@"Id"] forKey:@"MealId"];
                [mainDict setObject:[NSNumber numberWithBool:sender.isSelected] forKey:@"Avoid"];
                if (avoidAllArray.count >0) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"MealId == %@ AND MealType==%@",mealDetails[@"Id"],[NSNumber numberWithInt:i+1]];
                    NSArray *filteredArray = [avoidAllArray filteredArrayUsingPredicate:predicate];
                    if (filteredArray.count > 0) {
                        [avoidAllArray removeObject:filteredArray[0]];
                    }
                    [avoidAllArray addObject:mainDict];
                }else{
                    [avoidAllArray addObject:mainDict];
                }
            }
            if (avoidAllArray.count >0) {
                saveAll.hidden = false;
            }

        }
    }
}
-(IBAction)activeInactiveButtonPressed:(UIButton *)sender{
    int i=[sender.accessibilityHint intValue];
    NSMutableDictionary *dict = [recipeList[i] mutableCopy];
    if (![Utility isEmptyCheck:dict]) {
        NSDictionary *mealDetails = dict[@"mealdetail"];
        if (![Utility isEmptyCheck:mealDetails]) {
            NSMutableDictionary *userMealFlagdetail = [dict[@"UserMealFlagdetail"] mutableCopy];
            if ([Utility isEmptyCheck:userMealFlagdetail]) {
                userMealFlagdetail = [[NSMutableDictionary alloc]init];
            }
            int k=(int)sender.tag;
            sender.selected = !sender.isSelected;
            switch (k) {
                case 0:
                    [userMealFlagdetail setObject:[NSNumber numberWithBool:!sender.selected] forKey:@"AvoidBreakfast"];
                    break;
                case 1:
                    [userMealFlagdetail setObject:[NSNumber numberWithBool:!sender.selected] forKey:@"AvoidLunch"];
                    break;
                case 2:
                    [userMealFlagdetail setObject:[NSNumber numberWithBool:!sender.selected] forKey:@"AvoidDinner"];
                    break;
                case 3:
                    [userMealFlagdetail setObject:[NSNumber numberWithBool:!sender.selected] forKey:@"AvoidSnack"];
                    break;
                default:
                    break;
            }
            [userMealFlagdetail setObject:[NSNumber numberWithBool:false] forKey:@"AvoidAll"];
            [dict setObject:userMealFlagdetail forKey:@"UserMealFlagdetail"];
            [recipeList replaceObjectAtIndex:i withObject:dict];
            [table reloadData];
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            
            [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
            [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
            [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
            [mainDict setObject:[NSNumber numberWithInt:(int)sender.tag+1] forKey:@"MealType"];
            [mainDict setObject:mealDetails[@"Id"] forKey:@"MealId"];
            [mainDict setObject:[NSNumber numberWithBool:!sender.isSelected] forKey:@"Avoid"];
            if (avoidAllArray.count >0) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"MealId == %@ AND MealType==%@",mealDetails[@"Id"],[NSNumber numberWithInt:(int)sender.tag+1]];
                NSArray *filteredArray = [avoidAllArray filteredArrayUsingPredicate:predicate];
                if (filteredArray.count > 0) {
                    [avoidAllArray removeObject:filteredArray[0]];
                }
                [avoidAllArray addObject:mainDict];
            }else{
                [avoidAllArray addObject:mainDict];
            }
            if (avoidAllArray.count >0) {
                saveAll.hidden = false;
            }
        }
    }
}
-(IBAction)swapWithMealButtonPressed:(UIButton *)sender{
    if (![Utility isEmptyCheck:mealId] && ![Utility isEmptyCheck:mealSessionId] && ![Utility isEmptyCheck:mealDate]) {
        NSDictionary *dict = recipeList[sender.tag];
        if (![Utility isEmptyCheck:dict]) {
            NSDictionary *mealDetails = dict[@"mealdetail"];
            if (![Utility isEmptyCheck:mealDetails]) {
                [self squadUpdateMealForSessionApiCall:mealDetails];
            }
        }
    }
}
-(IBAction)cancelButtonPressed:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)submittedButtonPressed:(UIButton *)sender{
    NSDictionary *dict = recipeList[sender.tag];
    if (![Utility isEmptyCheck:dict]) {
        NSDictionary *mealDetails = dict[@"mealdetail"];
        if (![Utility isEmptyCheck:mealDetails]) {
            if (Utility.reachable) {
                sender.selected = !sender.isSelected;
                NSError *error;
                NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
                
                [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
                [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
                [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
                [mainDict setObject:mealDetails[@"Id"] forKey:@"MealId"];
                
                
                NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
                if (error) {
                    [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    recipeList = [[NSMutableArray alloc]init];
                    apiCount++;
                    if (contentView) {
                        [contentView removeFromSuperview];
                    }
                    table.hidden = true;
                    blankMsgLabel.hidden = false;
                    contentView = [Utility activityIndicatorView:self];
                });
                NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
                
                NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SubmitMealApiCall" append:@""forAction:@"POST"];
                
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
                                                                                 [Utility msg:@"Your recipe has been submitted and will be reviewed by our team soon" title:@"" controller:self haveToPop:NO];
                                                                                 
                                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup_nourish

                                                                                 
                                                                                 [self getRecipeList:NO];
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
}
-(IBAction)showImagesButtonPressed:(UIButton *)sender{
    showImagesButton.selected= !showImagesButton.isSelected;
    [table reloadData];
}
-(IBAction)addRecipeButtonPressed:(UIButton *)sender{
    AddRecipeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddRecipeView"];
    controller.delegate =self;
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)mealTypeButtonPressed:(UIButton *)sender{
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"] && ([mealTypeButton.lastObject isEqual:sender] || [mealTypeButton[mealTypeButton.count - 2] isEqual:sender])) {
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    
    if(sender.tag == 6){
        [self goToAdvancedSearch];
        return;
    }
    
    if (sender.tag == 5) {
        isFav = true;
    }else{
        isFav = false;
    }
    [self updateMealTypeButtons:sender];
//    CGRect frame = [scrollview convertRect:sender.frame fromView:sender.superview];
//    if ((frame.origin.x > (scrollview.frame.size.width/2 - frame.size.width/2))) {
//        CGPoint middleOffset = CGPointMake(frame.origin.x - (scrollview.frame.size.width/2 - frame.size.width/2),0);
//        if (middleOffset.x <(scrollview.contentSize.width - scrollview.frame.size.width)) {
//        }else{
//            middleOffset = CGPointMake((scrollview.contentSize.width - scrollview.frame.size.width),0);
//        }
//        [scrollview setContentOffset:middleOffset animated:YES];
//
//    }
    [self getRecipeList:NO];
}
- (IBAction)searchButtonPressed:(UIButton *)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                //shabbir   19/03/18
//                searchTextField.hidden = !searchTextField.hidden;
                [self.view endEditing:YES];
//                if (searchTextField.hidden) {
//                    [self.view endEditing:YES];
//                }else{
//                    [searchTextField becomeFirstResponder];
//                }
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
    
}


- (IBAction)showMenu:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.slidingViewController anchorTopViewToRightAnimated:YES];
            [self.slidingViewController resetTopViewAnimated:YES];
        }
    }];
}
-(IBAction)logoTapped:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}
- (IBAction)back:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
-(IBAction)filterButtonPressed:(UIButton *)sender{
    mealTypeView.hidden = !mealTypeView.isHidden;
    if (mealTypeView.isHidden) {
        arrowButton.selected = false;
    } else {
        arrowButton.selected = true;
    }
}
- (IBAction)favrtButtonPressed:(UIButton *)sender {
    NSLog(@"favrt pressed");
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    NSDictionary *dict;
    if (isFav) {
        dict = favrtDict[sender.tag];
    } else {
        dict = recipeList[sender.tag];
    }
    NSDictionary *mealDetails = dict[@"mealdetail"];
    if (sender.isSelected) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Alert!"
                                      message:@"This meal will be removed from your favorite meal list, continue?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Yes"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self favoriteMealToggleApiCall:mealDetails[@"Id"]];
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                 }];
        
        [alert addAction:cancel];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self favoriteMealToggleApiCall:mealDetails[@"Id"]];
    }
}

#pragma mark -End

#pragma mark -ViewLifeCycle

- (void)viewDidLoad {
    isFav = false;
    [super viewDidLoad];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Hey %@,\n%@\nHold tight, we're just finding your meals.",[defaults objectForKey:@"FirstName"],@"Let food be thy medicine and medicine be thy food"]];
    NSRange foundRange = [text.mutableString rangeOfString:@"Let food be thy medicine and medicine be thy food"];
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:20.0],
                               NSForegroundColorAttributeName : [UIColor colorWithRed:(228/255.0f) green:(39/255.0f) blue:(160/255.0f) alpha:1.0f]
                               
                               };
    [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
    [text addAttributes:@{
                          NSFontAttributeName : [UIFont fontWithName:@"Oswald-Bold" size:30.0]
                          
                          }
                  range:foundRange];
    
    msgLabel.attributedText = text;
    animationImage.image = [UIImage animatedImageNamed:@"animation-" duration:1.0f];
    
    if ([defaults boolForKey:@"isMyPreferenceSaved"]) {
       myPreferenceButton.selected = [defaults boolForKey:@"MyPreference"];
    }else{
        myPreferenceButton.selected = true;
        [defaults setBool:true forKey:@"MyPreference"];
        [defaults setBool:true forKey:@"isMyPreferenceSaved"];
    }
    if(myPreferenceButton.isSelected){
        [myPreferenceButton setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1]];
    }else{
        [myPreferenceButton setBackgroundColor:[UIColor whiteColor]];
    }
    myPreferenceButton.layer.borderWidth = 1;
    myPreferenceButton.layer.borderColor = [UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1].CGColor;
    avoidAllArray = [[NSMutableArray alloc]init];
    UIButton *lunchButton = mealTypeButton[1];
    [self updateMealTypeButtons:lunchButton];
    
    showImagesButton.layer.borderColor = [UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1].CGColor;
    showImagesButton.layer.borderWidth = 2;
    table.rowHeight = UITableViewAutomaticDimension;
    table.estimatedRowHeight = 457 ;
    if (![Utility isEmptyCheck:mealId] && ![Utility isEmptyCheck:mealSessionId] && ![Utility isEmptyCheck:mealDate]) {
        swapMealLabel.hidden = false;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"dd-MM-yyyy [EEEE]";
        NSString *dateString = [formatter stringFromDate:mealDate];
        swapMealLabel.text = [NSString stringWithFormat:@"You are swapping Meal for %@.",dateString];
    }else{
        swapMealLabel.hidden = true;
    }
    advanceSearchButton.layer.masksToBounds = YES;
    advanceSearchButton.layer.cornerRadius = 15.0;
    advanceSearchButton.layer.borderWidth = 1;
    advanceSearchButton.layer.borderColor = squadMainColor.CGColor;
    createRecipeButton.layer.masksToBounds = YES;
    createRecipeButton.layer.cornerRadius = 15.0;
    createRecipeButton.layer.borderWidth = 1;
    createRecipeButton.layer.borderColor = squadMainColor.CGColor;
    
    isChanged = true;
    isFirstTime = true;
}
-(void)viewWillAppear:(BOOL)animated{
    mealTypeView.hidden = true;
    arrowButton.selected = false;
    saveAll.hidden=true;
    editRowNumber = -1;
    //favrtDict = [[NSArray alloc]init];
    if (!isChanged) {
        return;
    }
    if (isFirstTime) {
        isFirstTime = false;
        isChanged = false;
        UIButton *btn = [UIButton new];
        btn.tag = 6;
        [self mealTypeButtonPressed:btn];
    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self getUnitPreference];
//    });
    
    
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isFav) {
        return (![Utility isEmptyCheck:favrtDict])?favrtDict.count:0;
    } else {
        return (![Utility isEmptyCheck:recipeList])?recipeList.count:0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
    if(indexPath.row == editRowNumber){
        return 280;
    }else{
        return 230;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"RecipeListTableViewCell";
    RecipeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[RecipeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
//    cell.containerView.layer.masksToBounds = NO;
//    cell.containerView.layer.shadowColor = [Utility colorWithHexString:@"#2e312d"].CGColor;
//    cell.containerView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
//    cell.containerView.layer.shadowOpacity = 0.4f;
//    cell.containerView.layer.shadowRadius = 5;
//    cell.containerView.layer.cornerRadius = 3;
    
    cell.swapWithMealButton.layer.borderColor = [UIColor colorWithRed:235/255.0f green:92/255.0f blue:192/255.0f alpha:1.0].CGColor;
    cell.swapWithMealButton.layer.borderWidth = 2;
    
    cell.cancelButton.layer.borderColor = [UIColor colorWithRed:235/255.0f green:92/255.0f blue:192/255.0f alpha:1.0].CGColor;
    cell.cancelButton.layer.borderWidth = 2;
    
    cell.submittedButton.layer.borderColor = [UIColor colorWithRed:235/255.0f green:92/255.0f blue:192/255.0f alpha:1.0].CGColor;
    cell.submittedButton.layer.borderWidth = 2;
    
    cell.updateMealSetting.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.updateMealSetting.layer.borderWidth = 1;
    cell.editRecipe.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.editRecipe.layer.borderWidth = 1;
    
    cell.avoidOrNotButton.tag = indexPath.row;
    cell.recipeEditButton.tag = indexPath.row;
    cell.swapWithMealButton.tag = indexPath.row;
    cell.cancelButton.tag = indexPath.row;
    cell.submittedButton.tag = indexPath.row;
    
    cell.favrtButton.tag = indexPath.row;
    cell.updateMealSetting.tag = indexPath.row;
    cell.editRecipe.tag = indexPath.row;
    
    cell.breakfastButton.accessibilityHint = [NSString stringWithFormat:@"%d",(int) indexPath.row];
    cell.lunchButton.accessibilityHint = [NSString stringWithFormat:@"%d",(int) indexPath.row];
    cell.dinnerButton.accessibilityHint = [NSString stringWithFormat:@"%d",(int) indexPath.row];
    cell.snackButton.accessibilityHint = [NSString stringWithFormat:@"%d",(int) indexPath.row];

    cell.submittedButton.hidden = false;
    NSDictionary *dict;
    if (isFav) {
        dict = favrtDict[indexPath.row];
    } else {
        dict = recipeList[indexPath.row];
    }
    if (![Utility isEmptyCheck:dict]) {
        if (editRowNumber == indexPath.row) {
            cell.editMealView.hidden = false;
            cell.recipeEditButton.selected = true;
            cell.editMealViewHeight.constant = 55;
            cell.editRecipeButtonHeight.constant = 50;
        } else {
            cell.editMealView.hidden = true;
            cell.recipeEditButton.selected = false;
            cell.editMealViewHeight.constant = 0;
            cell.editRecipeButtonHeight.constant = 40;
        }
        NSDictionary *userMealFavorite = dict[@"UserFavoriteMealdetail"];
        if (![Utility isEmptyCheck:userMealFavorite]) {
            cell.favrtButton.selected = [userMealFavorite[@"IsFavorite"] boolValue];
        }
        NSDictionary *userMealFlagdetail = dict[@"UserMealFlagdetail"];
        if (![Utility isEmptyCheck:userMealFlagdetail]) {
            cell.breakfastButton.selected = ![userMealFlagdetail[@"AvoidBreakfast"] boolValue];
            cell.dinnerButton.selected = ![userMealFlagdetail[@"AvoidDinner"] boolValue];
            cell.lunchButton.selected = ![userMealFlagdetail[@"AvoidLunch"] boolValue];
            cell.snackButton.selected = ![userMealFlagdetail[@"AvoidSnack"] boolValue];
            cell.avoidOrNotButton.selected =[userMealFlagdetail[@"AvoidAll"] boolValue];
        }
        
        NSDictionary *mealDetails = dict[@"mealdetail"];
        if (![Utility isEmptyCheck:mealDetails]) {
            cell.recipeName.text = ![Utility isEmptyCheck:mealDetails[@"MealName"]] ? mealDetails[@"MealName"] : @"";
//            if (showImagesButton.isSelected) {
//                  //shabbir
//            }
            NSString *imageString = mealDetails[@"PhotoSmallPath"];
            if (![Utility isEmptyCheck:imageString]) {      //ah ux2
                [cell.recipeImage sd_setImageWithURL:[NSURL URLWithString:imageString]
                                    placeholderImage:[UIImage imageNamed:@"new_image_loading.png"] options:SDWebImageScaleDownLargeImages];
            } else {
                cell.recipeImage.image = [UIImage imageNamed:@"image_loading.png"];
            }
//            cell.recipeImage.hidden = !showImagesButton.isSelected;
            if (![Utility isEmptyCheck:mealDetails[@"MealClassifiedID"]] && [mealDetails[@"MealClassifiedID"] intValue] == 2) {
                cell.noMeasureMeal.hidden = false;
//                cell.caloriesButton.hidden = true;
                [cell.caloriesButton setTitle:[NSString stringWithFormat:@"Unmeasured"] forState:UIControlStateNormal];
            }else{
                 cell.noMeasureMeal.hidden = true;
//                 cell.caloriesButton.hidden = false;
                [cell.caloriesButton setTitle:[NSString stringWithFormat:@"%@ Calories",![Utility isEmptyCheck:mealDetails[@"CalsTotal"]] ? mealDetails[@"CalsTotal"] : @"0.00"] forState:UIControlStateNormal];
             }
            
            int prepMins = [mealDetails[@"PreparationMinutes"] intValue]*60;
            
            [cell.prepTimeButton setTitle:[NSString stringWithFormat:@"%@",prepMins>0 ? [Utility formatTimeFromSeconds:prepMins] : @"0 MIN"] forState:UIControlStateNormal];
            
            //[cell.prepTimeButton setTitle:[NSString stringWithFormat:@"%@ MIN",![Utility isEmptyCheck:mealDetails[@"PreparationMinutes"]] ? mealDetails[@"PreparationMinutes"] : @"0.00"] forState:UIControlStateNormal];

//            [cell.caloriesButton setTitle:[NSString stringWithFormat:@"%@ Calories",![Utility isEmptyCheck:mealDetails[@"CalsTotal"]] ? mealDetails[@"CalsTotal"] : @"0.00"] forState:UIControlStateNormal];
            if (![Utility isEmptyCheck:mealId] && ![Utility isEmptyCheck:mealSessionId] && ![Utility isEmptyCheck:mealDate]) {
                cell.submittedButton.hidden = true;
                cell.swapWithMealStackView.hidden = false;
                
            }else{
                if([mealDetails[@"CanBePersonalised"] boolValue]){
                    if([[defaults objectForKey:@"ABBBCOnlineUserId"] isEqual:mealDetails[@"UserId"]]){
                        cell.submittedButton.hidden = false;
                        if ([mealDetails[@"AllowSubmit"]boolValue]) {
                            [cell.submittedButton setTitle:@"Submit Recipe" forState:UIControlStateNormal];
                        }else{
                            [cell.submittedButton setTitle:@"Submit Again" forState:UIControlStateNormal];
                        }
                    }else{
                        cell.submittedButton.hidden = true;
                    }
                }else{
                    cell.submittedButton.hidden = true;
                }
                cell.swapWithMealStackView.hidden = true;

            }
            
            
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            NSDictionary *dict;
            if (isFav) {
                dict = favrtDict[indexPath.row];
            } else {
                dict = recipeList[indexPath.row];
            }
            if (![Utility isEmptyCheck:dict]) {
                NSDictionary *mealDetails = dict[@"mealdetail"];
                if (![Utility isEmptyCheck:mealDetails]) {
                    DailyGoodnessDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyGoodnessDetail"];
                    controller.mealId = mealDetails[@"Id"];
                    controller.fromController = @"Recipe";    //ah ux
                    controller.delegate=self;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }
    }];
}
#pragma mark -End
#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length > 0){
        filterDict = [NSDictionary dictionaryWithObjectsAndKeys:searchTextField.text,@"SearchText",[NSNumber numberWithBool:true],@"OnlySquad", nil ];
        searchTextField.text=@"";
        [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            searchTextField.hidden = true;
            [self.view endEditing:YES];
            
        } completion:^(BOOL finished) {
            
        }];
        [self getRecipeList:NO];
    }
    
}
#pragma mark - End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - End

#pragma mark - AdvanceSearch Delegate

-(void)didSelectSearchOption:(NSMutableDictionary*)dict{ //addnew24
    NSLog(@"Result-%@",dict);
    filterDict = [NSDictionary dictionaryWithDictionary:dict];
    [self getRecipeList:YES];
}

#pragma mark - End

#pragma mark - DailyGoodNessViewDelegate
-(void)didCheckAnyChangeForDailyGoodness:(BOOL)ischanged{
    isChanged =ischanged;
}
#pragma mark - End

#pragma mark - AddEditCustomNutritionDelegate
-(void)didCheckAnyChange:(BOOL)ischanged{
    isChanged = ischanged;
}
#pragma mark - End

#pragma mark - CustomNutritionMealSettingsDelegate

-(void)didCheckAnyChangeForMealSettings:(BOOL)ischanged{
    isChanged = ischanged;
}
#pragma mark - End

#pragma mark - FoodPrepSearchViewDelegate
-(void)didCheckAnyChangeForFoodPrepSearch:(BOOL)ischanged{
    isChanged= ischanged;
}

-(void)mealSerachWithFilterData:(NSDictionary *)dict ingredientsAllList:(NSArray *)ingredientsAllList dietaryPreferenceArray:(NSArray *)dietaryPreferenceArray{
    self->filterDict = [NSDictionary dictionaryWithDictionary:dict];
    self->ingredientList = ingredientsAllList;
    self->dietaryPreferenceArray = dietaryPreferenceArray;
    [self getRecipeList:YES];
}

-(void)isBackToNourish:(BOOL)isBack{
    if(isBack)[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- End

#pragma mark - RecipeListViewDelegate
-(void)didCheckAnyChangeForAddRecipe:(BOOL)ischanged{
    isChanged = ischanged;
}
@end
