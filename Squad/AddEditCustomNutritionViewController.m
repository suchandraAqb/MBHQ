//
//  AddEditCustomNutritionViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 04/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AddEditCustomNutritionViewController.h"
#import "AddIngredientsTableViewCell.h"
#import "AddInstructionTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Calorie.h"
#import "NutritionalInfoViewController.h"
#import "MealAddViewController.h"
#import "foodPrepSearchTableViewCell.h"

//chayan 18/10/2017
#import "ProgressBarViewController.h"

@interface AddEditCustomNutritionViewController (){
    
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIImageView *mealImage;
    IBOutlet UIButton *addImage;
    IBOutlet UITextField *recipeName;
    IBOutlet UITextField *recipePrepTime;
    IBOutlet UIButton *breakfast;
    IBOutlet UIButton *lunch;
    IBOutlet UIButton *dinner;
    IBOutlet UIButton *snack;
    IBOutlet UIButton *drink;
    
    IBOutlet UITableView *recipeIngredientTable;
    IBOutlet NSLayoutConstraint *recipeIngredientTableHeightConstraints;
    
    IBOutlet UITableView *recipeInstructionTable;
    IBOutlet NSLayoutConstraint *recipeInstructionTableHeightConstraints;
    
    
    IBOutlet UIButton *addIngredientsButton;
    IBOutlet UIButton *addInstructionsButton;
    IBOutlet UIButton *saveAndUseButton;
    
    //aahh
    IBOutlet UILabel *energy1Label;
    IBOutlet UILabel *proteinPercentageLabel;
    IBOutlet UILabel *proteinGramLabel;
    IBOutlet UILabel *proteinCalsLabel;
    IBOutlet UILabel *carbPercentageLabel;
    IBOutlet UILabel *carbGramLabel;
    IBOutlet UILabel *carbCalsLabel;
    IBOutlet UILabel *fatPercentageLabel;
    IBOutlet UILabel *fatGramLabel;
    IBOutlet UILabel *fatCalsLabel;
    IBOutlet UILabel *dieatInfoLabel;
    IBOutletCollection(UILabel) NSArray *mainUnitLabel;
    
    IBOutlet UIButton *saveButton;      //ah ux
    IBOutlet UIButton *cancelButton;
    
    NSArray *ingredientsAllList;
    UIView *contentView;
    NSMutableDictionary *mealDetailsDictionary;
    NSMutableDictionary *mealData;
    
    NSMutableArray *ingredientsArray;
    NSMutableArray *instructionArray;
    NSDictionary *unit;
    int apiCount;
    NSArray *unitPreferenceArray;
    UITextField *activeTextField;
    UITextView *activeTextView;
    UIToolbar *toolBar;
    UIImage *selectedImage;
    
    IBOutlet UIView *protineContainer;
    IBOutlet UIView *carbsContainer;
    IBOutlet UIView *fatContainer;
    BOOL isSaveButtonClicked;
    
    //chayan 18/10/2017
    BOOL multipartPop;
   
    int editingRow;
    int viewRow;
    BOOL ischanged; //Nutrition_Local_catch

    __weak IBOutlet UIView *showHideView;
    __weak IBOutlet UITableView *filterTable;
    __weak IBOutlet UITextField *filterTextField;
    NSArray *tempMealArray;
    BOOL saveViewPressed;
    BOOL uploadImage;
    BOOL dontUpdateVIew;
}


@end

@implementation AddEditCustomNutritionViewController
@synthesize mealId,mealSessionId,dateString,add,delegate,fromMealView;
#pragma mark -Private Methods

-(void)setQuantity{
    NSMutableArray *tempIngredientsArray = [[NSMutableArray alloc]init];
    for( NSDictionary *ing in ingredientsArray){
        NSMutableDictionary *dict = [ing mutableCopy];
        [dict setObject:@"" forKey:@"Brand"];
        if ([[defaults objectForKey:@"UnitPreference"] intValue] == 2)
        {
            //imperial
            if ([dict[@"UnitImperial"] isEqualToString:@"inch"]){
                dict[@"UnitMetric"] = @"cm";
                dict[@"QuantityMetric"] = [NSNumber numberWithFloat:[dict[@"QuantityImperial"] floatValue]* (float)2.54];
            }else if ([dict[@"UnitImperial"] isEqualToString:@"oz"]){
                dict[@"UnitMetric"] = @"gram";
                dict[@"QuantityMetric"] = [NSNumber numberWithFloat:[dict[@"QuantityImperial"] floatValue]* (float)28.3495];
            }else if ([dict[@"UnitImperial"] isEqualToString:@"fl.oz"]){
                dict[@"UnitMetric"] = @"ml";
                dict[@"QuantityMetric"] = [NSNumber numberWithFloat:[dict[@"QuantityImperial"] floatValue]* (float)29.5735];
            }else{
                dict[@"UnitMetric"] = dict[@"UnitImperial"] ;
                dict[@"QuantityMetric"] = dict[@"QuantityImperial"];
                
            }
        }else{
            //metric
            if ([dict[@"UnitMetric"] isEqualToString:@"cm"])
            {
                dict[@"UnitImperial"] = @"inch";
                dict[@"QuantityImperial"] = [NSNumber numberWithFloat:[dict[@"QuantityMetric"] floatValue]* (float)0.39];
            }
            else if ([dict[@"UnitMetric"] isEqualToString:@"gram"])
            {
                dict[@"UnitImperial"] = @"oz";
                dict[@"QuantityImperial"] = [NSNumber numberWithFloat:[dict[@"QuantityMetric"] floatValue]* (float)0.0353];
            }
            else if([dict[@"UnitMetric"] isEqualToString:@"ml"])
            {
                dict[@"UnitImperial"] = @"fl.oz";
                dict[@"QuantityImperial"] = [NSNumber numberWithFloat:[dict[@"QuantityMetric"] floatValue]* (float)0.0338];
            }
            else
            {
                dict[@"UnitImperial"] = dict[@"UnitMetric"];
                dict[@"QuantityImperial"] = dict[@"QuantityMetric"];
            }
        }
        [tempIngredientsArray addObject:dict];
    }
    ingredientsArray = tempIngredientsArray;
    
    
}  
- (IBAction)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = selectedImage;
    controller.keepingCropAspectRatio = YES;
    controller.cropAspectRatio = 2.0/3.0;
    
    /* UIImage *image = selectedImage;
     CGFloat width = image.size.width;
     CGFloat height = image.size.height;
     CGFloat length = MIN(width, height);
     controller.imageCropRect = CGRectMake((width - length) / 2,
     (height - length) / 2,
     length/2,
     length);*/
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}
-(void)openPhotoAlbum{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:controller animated:YES completion:NULL];
}
-(void)showCamera{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:controller animated:YES completion:NULL];
    }else{
        [Utility msg:@"Camera Not Available." title:@"Warning !" controller:self haveToPop:NO];
    }
    
}
-(void)toggleButtonBackground:(UIButton *)sender{
    sender.layer.borderWidth = 1;
    sender.layer.borderColor = [UIColor colorWithRed:230/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
//    if (sender.isSelected) {
//        [sender setBackgroundColor:[UIColor colorWithRed:230/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
//    } else {
//        [sender setBackgroundColor:[UIColor whiteColor]];
//    }
}
-(void)prepareView{
    if (![Utility isEmptyCheck:mealData]) {
        if ([Utility isEmptyCheck:mealData[@"UserId"]] && ![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            recipeName.text = ![Utility isEmptyCheck:[mealData objectForKey:@"MealName"]] ? [@"" stringByAppendingFormat:@"%@'s - %@",[defaults objectForKey:@"FirstName"],[mealData objectForKey:@"MealName"]] : @"";
        }else{
            recipeName.text = ![Utility isEmptyCheck:[mealData objectForKey:@"MealName"]] ? [mealData objectForKey:@"MealName"] : @"";
        }
        if (![Utility isEmptyCheck:recipeName.text]) {
            [mealData setObject:recipeName.text forKey:@"MealName"];
        }else{
            [Utility msg:@"Recipe Name cannot be blank." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
        
        
        if (![Utility isEmptyCheck:mealData[@"MealClassifiedID"]] && [mealData[@"MealClassifiedID"] intValue] == 2) {
            protineContainer.hidden = true;
            carbsContainer.hidden = true;
            fatContainer.hidden = true;
            //[mealData setObject:[NSNumber numberWithInt:0] forKey:@"PreparationMinutes"];
        }else{
            protineContainer.hidden = false;
            carbsContainer.hidden = false;
            fatContainer.hidden = false;
            //[mealData setObject:![Utility isEmptyCheck:[mealData objectForKey:@"PreparationMinutes"]] ? [@"" stringByAppendingFormat:@"%@",[mealData objectForKey:@"PreparationMinutes"]] :[NSNumber numberWithInt:0] forKey:@"PreparationMinutes"];
        }
        
        recipePrepTime.text = ![Utility isEmptyCheck:[mealData objectForKey:@"PreparationMinutes"]] ? [@"" stringByAppendingFormat:@"%@",[mealData objectForKey:@"PreparationMinutes"]] : @"0";
        
        breakfast.selected = [mealData[@"IsBreakfast"] boolValue];
        dinner.selected = [mealData[@"IsDinner"] boolValue];
        lunch.selected = [mealData[@"IsLunch"] boolValue];
        snack.selected = [mealData[@"IsSnack"] boolValue];
        drink.selected = [mealData[@"IsDrink"] boolValue];
        
        //aahh
        float totalCals = ![Utility isEmptyCheck:[mealData objectForKey:@"TotalCalories"]] ? [[mealData objectForKey:@"TotalCalories"] floatValue] :0.0f;
        energy1Label.text=[@"" stringByAppendingFormat:@"%ldcal (%.0fkj)",lroundf(totalCals),lroundf(totalCals)*4.184]; //4.184 to covert caliry to kilojule
        
        //Protein
        
        NSString *proteinKey = @"";
        NSString *proteinUnit = @"";
        NSString *carbsKey = @"";
        NSString *fatKey = @"";
        
//        if ([[defaults objectForKey:@"UnitPreference"] intValue] == 2) {
//            proteinKey = @"ProteinOz";
//            proteinUnit = @" oz";
//            carbsKey = @"CarbohydratesOz";
//            fatKey = @"FatOz";
//            
//            for (UILabel  *unitLabel in mainUnitLabel) {
//                unitLabel.text = @"-oz";
//            }
//        }else {
            proteinKey = @"Protein";
            proteinUnit = @" g";
            carbsKey = @"Carbohydrates";
            fatKey = @"Fat";
            
            for (UILabel  *unitLabel in mainUnitLabel) {
                unitLabel.text = @"-gram";
            }
//        }
        
        proteinGramLabel.text=![Utility isEmptyCheck:[mealData objectForKey:proteinKey]] ? [@"" stringByAppendingFormat:@"%.2f%@",[[mealData objectForKey:proteinKey] floatValue],proteinUnit] : @"" ;
        
        proteinPercentageLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"ProteinPercentage"]] ? [@"" stringByAppendingFormat:@"%.0f%%",[[mealData objectForKey:@"ProteinPercentage"] floatValue]] : @"" ;
        
        proteinCalsLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"ProtCals"]] ? [@"" stringByAppendingFormat:@"%.2f",[[mealData objectForKey:@"ProtCals"] floatValue]] : @"" ;
        
        //End
        //Carbs
        
        carbGramLabel.text=![Utility isEmptyCheck:[mealData objectForKey:carbsKey]] ? [@"" stringByAppendingFormat:@"%.2f%@",[[mealData objectForKey:carbsKey] floatValue],proteinUnit] : @"" ;
        
        carbPercentageLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"CarbPercentage"]] ? [@"" stringByAppendingFormat:@"%.0f%%",[[mealData objectForKey:@"CarbPercentage"] floatValue]] : @"" ;
        
        carbCalsLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"CarbCals"]] ? [@"" stringByAppendingFormat:@"%.2f",[[mealData objectForKey:@"CarbCals"] floatValue]] : @"" ;
        
        //End
        //Fat
        
        fatGramLabel.text=![Utility isEmptyCheck:[mealData objectForKey:fatKey]] ? [@"" stringByAppendingFormat:@"%.2f%@",[[mealData objectForKey:fatKey] floatValue],proteinUnit] : @"" ;
        
        fatPercentageLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"FatPercentage"]] ? [@"" stringByAppendingFormat:@"%.0f%%",[[mealData objectForKey:@"FatPercentage"] floatValue]] : @"" ;
        
        fatCalsLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"FatCals"]] ? [@"" stringByAppendingFormat:@"%.2f",[[mealData objectForKey:@"FatCals"] floatValue]] : @"" ;
        
        //End
        
        int isVegetarian=![Utility isEmptyCheck:[mealData objectForKey:@"IsVegetarian"]] ? [[mealData objectForKey:@"IsVegetarian"] intValue] : 0 ;
        
        NSString *dietInfo=@"";
        //        if(isVegetarian>0){
        
        
        if(isVegetarian == 2){
            dietInfo=@"Vegetarian, Pescatarian, ";
        }
        
        if(isVegetarian == 3){
            dietInfo=@"Vegan, Vegetarian, Pescatarian, ";
        }
        
        if(isVegetarian == 3){
            dietInfo=@"Pescatarian, ";
        }
        
        if([[mealData objectForKey:@"IsDairyFree"] boolValue] && ![Utility isEmptyCheck:[mealData objectForKey:@"IsDairyFree"]]){
            dietInfo=[dietInfo stringByAppendingFormat:@"Dairy Free, "];
        }
        
        if([[mealData objectForKey:@"IsFodmapFriendly"] boolValue] && ![Utility isEmptyCheck:[mealData objectForKey:@"IsFodmapFriendly"]]){
            dietInfo=[dietInfo stringByAppendingFormat:@"FODMAP Friendly, "];
        }
        
        if([[mealData objectForKey:@"IsGlutenFree"] boolValue] && ![Utility isEmptyCheck:[mealData objectForKey:@"IsGlutenFree"]]){
            dietInfo=[dietInfo stringByAppendingFormat:@"Gluten Free, "];
        }
        
        if([[mealData objectForKey:@"IsPaleo"] boolValue] && ![Utility isEmptyCheck:[mealData objectForKey:@"IsPaleo"]]){
            dietInfo=[dietInfo stringByAppendingFormat:@"Paleo Friendly, "];
        }
        
        if([[mealData objectForKey:@"HasWhiteMeat"] boolValue] && ![Utility isEmptyCheck:[mealData objectForKey:@"HasWhiteMeat"]]){
            dietInfo=[dietInfo stringByAppendingFormat:@"No Red Meat, "];
        }
        
        if([[mealData objectForKey:@"IsAntiInflam"] boolValue] && ![Utility isEmptyCheck:[mealData objectForKey:@"IsAntiInflam"]]){
            dietInfo=[dietInfo stringByAppendingFormat:@"No Nuts, "];
        }
        
        if([[mealData objectForKey:@"IsAntiOx"] boolValue] && ![Utility isEmptyCheck:[mealData objectForKey:@"IsAntiOx"]]){
            dietInfo=[dietInfo stringByAppendingFormat:@"No Chicken, "];
        }
        
        if([[mealData objectForKey:@"IsKETO"] boolValue] && ![Utility isEmptyCheck:[mealData objectForKey:@"IsKETO"]]){
            dietInfo=[dietInfo stringByAppendingFormat:@"No Eggs, "];
        }
        
        if([[mealData objectForKey:@"NoSeaFood"] boolValue] && ![Utility isEmptyCheck:[mealData objectForKey:@"NoSeaFood"]]){
            dietInfo=[dietInfo stringByAppendingFormat:@"No Seafood, "];
        }
        
        dietInfo=[dietInfo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![Utility isEmptyCheck:dietInfo] && dietInfo.length > 1)
            dietInfo=[dietInfo substringWithRange:NSMakeRange(0, dietInfo.length-1)];
        
        //}
        
        dieatInfoLabel.text=dietInfo;
        //aahh end
    }
    [self setQuantity];
    [recipeIngredientTable reloadData];
    [recipeInstructionTable reloadData];
    
}

-(void)getUnitPreference{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSString *userId =[@"" stringByAppendingFormat:@"%@",[defaults objectForKey:@"ABBBCOnlineUserId"]];
        
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetUserFlags" append:userId forAction:@"GET"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 self->apiCount--;
                                                                 if (self->apiCount == 0 && self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else {
                                                                             self->unitPreferenceArray = [responseDictionary objectForKey:@"obj"];
                                                                             if (self->apiCount == 0) {
                                                                                 [self prepareView];
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

-(void)getIngredientsApiCall{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(),^ {
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetIngredientsApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 self->apiCount --;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else{
                                                                             self->ingredientsAllList = [responseDictionary objectForKey:@"Ingredients"];
                                                                             if (self->apiCount==0 && !self->dontUpdateVIew) {
                                                                                 [self prepareView];
                                                                             }
                                                                             self->dontUpdateVIew = false;
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
-(void)getGoodnessDetails{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealId forKey:@"MealId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(),^ {
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMealDetailsApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 self->apiCount --;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else {
                                                                             self->mealDetailsDictionary = [[responseDictionary objectForKey:@"Meal"]mutableCopy];
                                                                             self->mealData = [self->mealDetailsDictionary[@"MealData"]mutableCopy];
                                                                             self->ingredientsArray = [self->mealDetailsDictionary[@"Ingredients"] mutableCopy];
                                                                             self->instructionArray= [self->mealDetailsDictionary[@"Instructions"] mutableCopy];
                                                                             if (![Utility isEmptyCheck:self->mealDetailsDictionary]) {
                                                                                 NSString *imageString=![Utility isEmptyCheck:[self->mealData objectForKey:@"PhotoPath"]] ? [@"" stringByAppendingFormat:@"%@",[self->mealData objectForKey:@"PhotoPath"]] : @"" ;
                                                                                 if (![Utility isEmptyCheck:imageString]) {
                                                                                     self->mealImage.image = [UIImage imageNamed:@"new_image_loading.png"];   //ah 17.5
                                                                                     SDWebImageManager *manager = [SDWebImageManager sharedManager];
                                                                                     [manager loadImageWithURL:[NSURL URLWithString:imageString]
                                                                                                           options:0
                                                                                                      progress:^(NSInteger receivedSize, NSInteger expectedSize ,NSURL * targetURL) {
                                                                                                          // progression tracking code
                                                                                                      }
                                                                                                     completed:^(UIImage *image,NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                                                                         
                                                                                                         if (image) {
                                                                                                             self->mealImage.hidden = false;
                                                                                                             self->mealImage.image = image;
                                                                                                             [self->addImage setTitle:@"CHANGE" forState:UIControlStateNormal];
                                                                                                             [self->addImage setImage:Nil forState:UIControlStateNormal];
                                                                                                         } else {
                                                                                                             self->mealImage.image = [UIImage imageNamed:@"image_loading.png"];
                                                                                                             [self->addImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
                                                                                                             [self->addImage setImage:[UIImage imageNamed:@"plus_challenge.png"] forState:UIControlStateNormal];
                                                                                                             self->mealImage.hidden = true;
                                                                                                         }
                                                                                                     }];
                                                                                 }else {
                                                                                     self->mealImage.image = [UIImage imageNamed:@"image_loading.png"];
                                                                                     [self->addImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
                                                                                     [self->addImage setImage:[UIImage imageNamed:@"plus_challenge.png"] forState:UIControlStateNormal];
                                                                                     self->mealImage.hidden = true;
                                                                                 }
                                                                                 
                                                                                 
                                                                                 
                                                                             }
                                                                             if (self->apiCount==0) {
                                                                                 [self prepareView];
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
-(void)validateMealData:(BOOL)withImage pop:(BOOL)pop{
    [self.view endEditing:YES];
    if ([Utility isEmptyCheck:recipeName.text]) {
        [Utility msg:@"Please enter recipe name." title:@"Message" controller:self haveToPop:NO];
        return;
    }
    if (![Utility isEmptyCheck:mealData[@"CanBePersonalised"]]) {
        if (![mealData[@"CanBePersonalised"] boolValue]) {
            [Utility msg:@"This meal cannot be personalized." title:@"Message" controller:self haveToPop:YES];
            return;
        }
    }
    for (NSDictionary *instruction in instructionArray) {
        if ([Utility isEmptyCheck:instruction[@"InstructionText"]]) {
            [Utility msg:@"Instruction can not be blank" title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
    }
    for (NSDictionary *ingredient in ingredientsArray) {
        if (![Utility isEmptyCheck:ingredient]) {
            BOOL valid = true;
            if ([Utility isEmptyCheck:ingredient[@"IngredientId"]]) {
                valid = false;
                break;
            }else if([Utility isEmptyCheck:ingredient[@"IngredientName"]]){
                valid = false;
                break;
            }else if([Utility isEmptyCheck:ingredient[@"UnitImperial"]]){
                valid = false;
                break;
            }else if([Utility isEmptyCheck:ingredient[@"UnitMetric"]]){
                valid = false;
                break;
            }else if([Utility isEmptyCheck:ingredient[@"IngredientUnits"]]){
                valid = false;
                break;
            }else if([Utility isEmptyCheck:ingredient[@"IngredientImperialUnits"]]){
                valid = false;
                break;
            }else if([Utility isEmptyCheck:ingredient[@"IngredientDetails"]]){
                valid = false;
                break;
            }
            if (!valid) {
                [Utility msg:@"Please enter all ingredients details." title:@"Warning !" controller:self haveToPop:NO];
                return;
            }
        }else{
            [Utility msg:@"Please enter all ingredients details." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
    }
    if ([Utility isEmptyCheck:mealData[@"UserId"]]){
        [self webservicecall_GetUserRecipeByName:withImage pop:pop];
    }else{
        //chayan 18/10/2017 -- method name changed
        [self saugataMultipart:withImage pop:pop];
    }
    
}

-(void)saugata:(BOOL)withImage pop:(BOOL)pop{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mealData setObject:[NSNumber numberWithBool:YES] forKey:@"IsSquad"];
        [mealData setObject:[NSNumber numberWithBool:NO] forKey:@"IsAbbbc"];
        //[mealData setObject:[NSNumber numberWithBool:YES] forKey:@"AllowSubmit"];
        if (withImage) {
            if (![Utility isEmptyCheck:selectedImage]) {
                selectedImage =[Utility scaleImage:selectedImage width:selectedImage.size.width height:selectedImage.size.height];
                selectedImage = [UIImage imageWithData:UIImageJPEGRepresentation(selectedImage, 0.2)];
                NSString *imgBase64Str = [UIImagePNGRepresentation(selectedImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                [mealData setObject:imgBase64Str forKey:@"PhotoPath"];
            }else{
                [mealData setObject:@"" forKey:@"PhotoPath"];
            }
        }else{
            [mealData setObject:@"" forKey:@"PhotoPath"];
            [mealData setObject:@"" forKey:@"PhotoSmallPath"];
        }
        
        [mainDict setObject:@{@"MealData" : mealData, @"Ingredients": ingredientsArray, @"Instructions" : instructionArray} forKey:@"MealDetails"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(),^ {
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateMealRecipeApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 self->apiCount --;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else {
                                                                             NSLog(@"nourish save :\n%@",responseDictionary);
                                                                             
                                                                             
                                                                             if (pop) {
                                                                                 self->mealId = responseDictionary[@"MealId"];
                                                                                 [self squadUpdateMealForSessionApiCall];;
                                                                             }else{
                                                                                 self->mealId = responseDictionary[@"MealId"];
                                                                                 
                                                                                 [self getGoodnessDetails];
                                                                                 if(self->_isFromMealMatch && self->isSaveButtonClicked){
                                                                                     self->isSaveButtonClicked = false;
                                                                                     [self getSquadMealList:2 mealName:nil isStatic:true];
                                                                                 }else{
                                                                                     [Utility msg:@"Recipe saved successfully." title:@"Success" controller:self haveToPop:NO];
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
-(void)squadUpdateMealForSessionApiCall{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealSessionId forKey:@"MealSessionId"];
        [mainDict setObject:mealId forKey:@"NewMealId"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(),^ {
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadUpdateMealForSessionApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 self->apiCount --;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else {
                                                                             if ([self->delegate respondsToSelector:@selector(didCheckAnyChange:)]) {
                                                                                 [self->delegate didCheckAnyChange:self->ischanged];
                                                                             }
                                                                             [Utility msg:@"Recipe saved successfully." title:@"Success" controller:self haveToPop:YES];
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


-(void)webservicecall_GetUserRecipeByName:(BOOL)withImage pop:(BOOL)pop{
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
//                                                                          [self webserviceCall_IsMealNameExisting:[responseDict objectForKey:@"MealId"] withImage:withImage pop:pop];
                                                                          //shabbir
                                                                          NSNumber *newMealId = [responseDict objectForKey:@"MealId"];
                                                                          if (![Utility isEmptyCheck:newMealId] && [newMealId intValue] > 0) {
                                                                              UIAlertController * alert=   [UIAlertController
                                                                                                            alertControllerWithTitle:@"Alert"
                                                                                                            message:@"You have already personalised this recipe earlier, do you wish to edit the personalised one? if yes, click here. if not, please enter a new name for this recipe before saving."
                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                                              
                                                                              UIAlertAction* ok = [UIAlertAction
                                                                                                   actionWithTitle:@"Confirm"
                                                                                                   style:UIAlertActionStyleDefault
                                                                                                   handler:^(UIAlertAction * action)
                                                                                                   {
                                                                                                       self->mealId = newMealId;
                                                                                                       [self getGoodnessDetails];
                                                                                                   }];
                                                                              UIAlertAction* cancel = [UIAlertAction
                                                                                                       actionWithTitle:@"No"
                                                                                                       style:UIAlertActionStyleCancel
                                                                                                       handler:^(UIAlertAction * action)
                                                                                                       {
                                                                                                           self->recipeName.text = @"";
                                                                                                       }];
                                                                              [alert addAction:cancel];
                                                                              [alert addAction:ok];
                                                                              [self presentViewController:alert animated:YES completion:nil];
                                                                          }else{
                                                                              if (![Utility isEmptyCheck:self->selectedImage]) {
                                                                                  [self webserviceCall_IsMealNameExisting:[responseDict objectForKey:@"MealId"] withImage:true pop:pop];
                                                                              } else {
                                                                                  [self webserviceCall_IsMealNameExisting:[responseDict objectForKey:@"MealId"] withImage:false pop:pop];
                                                                              }
                                                                              
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

-(void) webserviceCall_IsMealNameExisting:(NSNumber*)mealIdNew withImage:(BOOL)withImage pop:(BOOL)pop{
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
        [mainDict setObject:mealIdNew forKey:@"MealId"];
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
                                                                          bool isExisting =[[responseDict objectForKey:@"IsExisting"]boolValue];
                                                                          if (isExisting) {
                                                                              // this is of no use, cause in both the case of existing and non-existing it returns only false :) :p
//                                                                              UIAlertController * alert=   [UIAlertController
//                                                                                                            alertControllerWithTitle:@"Alert"
//                                                                                                            message:@"You have already personalised this recipe earlier, do you wish to edit the personalised one? if yes, click here if not, please enter a new name for this recipe before saving."
//                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
//
//                                                                              UIAlertAction* ok = [UIAlertAction
//                                                                                                   actionWithTitle:@"Confirm"
//                                                                                                   style:UIAlertActionStyleDefault
//                                                                                                   handler:^(UIAlertAction * action)
//                                                                                                   {
//                                                                                                       mealId = mealIdNew;
//                                                                                                       [self getGoodnessDetails];
//                                                                                                   }];
//                                                                              UIAlertAction* cancel = [UIAlertAction
//                                                                                                       actionWithTitle:@"No"
//                                                                                                       style:UIAlertActionStyleCancel
//                                                                                                       handler:^(UIAlertAction * action)
//                                                                                                       {
//
//                                                                                                           recipeName.text = @"";                        NSLog(@"Resolving UIAlertActionController for tapping cancel button");
//
//                                                                                                       }];
//                                                                              [alert addAction:cancel];
//                                                                              [alert addAction:ok];
//                                                                              [self presentViewController:alert animated:YES completion:nil];
                                                                              [self saugataMultipart:withImage pop:pop];

                                                                          }else{
                                                                              //chayan 18/10/2017 -- method name changed
                                                                              [self saugataMultipart:withImage pop:pop];
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

-(void)getSquadMealList:(int)mealTypeData mealName:(NSDictionary *)mealdetails isStatic:(BOOL)isStatic{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:mealTypeData] forKey:@"RecipeMealTracker"];
        
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
            
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadUserActualMealList" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         NSLog(@"%@",responseDict);
                                                                         
                                                                         if(![Utility isEmptyCheck:responseDict[@"SquadUserActualMealList"]]){
                                                                             
                                                                             
//                                                                             MealAddViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MealAddView"];
                                                                             AddToPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddToPlanView"];
                                                                             NSDateFormatter *df = [NSDateFormatter new];
                                                                             [df setDateFormat:@"dd MM yyyy"];
                                                                             if ([df dateFromString:self->dateString] != nil) {
                                                                                 controller.currentDate = [df dateFromString:self->dateString];
                                                                             } else if (self->_currentDate != nil) {
                                                                                 controller.currentDate = self->_currentDate;
                                                                             }
                                                                             controller.MealType = self->_MealType;
                                                                             controller.actualMealType = SqMeal;
                                                                             controller.MealId=[self->mealId intValue];
                                                                             controller.isAdd = true;
                                                                             controller.isStatic = isStatic;
                                                                             controller.mealTypeData = mealTypeData;
                                                                             controller.mealDetails = [mealdetails mutableCopy];
                                                                             controller.mealListArray = [responseDict[@"SquadUserActualMealList"] mutableCopy];
                                                                             [self.navigationController pushViewController:controller animated:true];
                                                                             
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
-(void)checkForChange:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"backButtonPressed"]) {
        if ([delegate respondsToSelector:@selector(didCheckAnyChange:)]) {
            [delegate didCheckAnyChange:ischanged];
        }
        [self back:nil];
    }
}
#pragma mark -End



#pragma mark -IBAction
-(IBAction)ingredientSaveButtonPressed:(UIButton *)sender{
    [self validateMealData:false pop:NO];
}
-(IBAction)checkButtonClick:(UIButton *)sender{
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
//        [sender setBackgroundColor:[UIColor colorWithRed:230/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
//    } else {
//        [sender setBackgroundColor:[UIColor whiteColor]];
//    }
    [mealData setObject:[NSNumber numberWithBool:breakfast.isSelected] forKey:@"IsBreakfast"];
    [mealData setObject:[NSNumber numberWithBool:dinner.isSelected] forKey:@"IsDinner"];
    [mealData setObject:[NSNumber numberWithBool:lunch.isSelected] forKey:@"IsLunch"];
    [mealData setObject:[NSNumber numberWithBool:snack.isSelected] forKey:@"IsSnack"];
    [mealData setObject:[NSNumber numberWithBool:drink.isSelected] forKey:@"IsDrink"];
    [mealData setObject:@"" forKey:@"PhotoSmallPath"];
    [mealData setObject:@"" forKey:@"PhotoPath"];
    
    //[mealData removeObjectForKey:@"PhotoSmallPath"];
    //[mealData removeObjectForKey:@"PhotoPath"];
    
    [self validateMealData:false pop:NO];
    
}
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
- (IBAction)editIngredientPressed:(UIButton *)sender {
    
    if (!sender.isSelected) {
        editingRow = (int)sender.tag;
        viewRow = -1;
    } else {
        editingRow = -1;
    }
    [recipeIngredientTable reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
//    AddIngredientsTableViewCell *cell = (AddIngredientsTableViewCell *)[recipeIngredientTable cellForRowAtIndexPath:indexPath];
//    cell.editIngredientButton.selected = !cell.editIngredientButton.isSelected;
//
//    if (cell.editIngredientButton.isSelected) {
//        cell.ingredientSaveView.hidden = false;
//        cell.ingredientDetailsView.hidden = false;
//    } else {
//        cell.ingredientSaveView.hidden = false;
//        cell.ingredientDetailsView.hidden = false;
//    }
    //show the hidden views
}
- (IBAction)editInstructionPressed:(UIButton *)sender {
    
//    if (editingRow != sender.tag) {
//        editingRow = (int)sender.tag;
//    } else {
//        editingRow = -1;
//    }
    editingRow = (int)sender.tag;
    [recipeInstructionTable reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
//    AddInstructionTableViewCell *cell = (AddInstructionTableViewCell *)[recipeInstructionTable cellForRowAtIndexPath:indexPath];
//
//    cell.editInstructionButton.selected = !cell.editInstructionButton.isSelected;
//
//    if (cell.editInstructionButton.isSelected) {
//        cell.ingredientSaveView.hidden = false;
//    } else {
//        cell.ingredientSaveView.hidden = true;
//    }
    //show the hidden views
}
- (IBAction)ingredientNameButtonPressed:(UIButton *)sender {
    if (!sender.isSelected) {
        
        viewRow = (int)sender.tag;
        editingRow = -1;
        [recipeIngredientTable reloadData];
        return;
    }else{
        viewRow = -1;
    }
//    NSMutableDictionary *ingredientDict = [ingredientsArray[sender.tag] mutableCopy];
    if (ingredientsAllList.count > 0) {
        
        filterTextField.text = @"";
        tempMealArray = [NSArray arrayWithArray:ingredientsAllList];
        showHideView.hidden = false;
        showHideView.tag = sender.tag;
        [filterTable reloadData];
        
//        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
//        controller.modalPresentationStyle = UIModalPresentationCustom;
//        controller.dropdownDataArray = ingredientsAllList;
//        controller.mainKey = @"IngredientName";
//        controller.apiType = @"IngredientName";
//        if (![Utility isEmptyCheck:ingredientDict]) {
//            NSDictionary *selectedIngredientDict =[Utility getDictByValue:ingredientsAllList value:ingredientDict[@"IngredientId"] type:@"IngredientId"];
//
//            if (![Utility isEmptyCheck:selectedIngredientDict]) {
//                controller.selectedIndex = (int)[ingredientsAllList indexOfObject:selectedIngredientDict];
//            }else{
//                controller.selectedIndex =-1;
//            }
//        }else{
//            controller.selectedIndex =-1;
//        }
//
//        controller.sender = sender;
//        controller.delegate = self;
//        [self presentViewController:controller animated:YES completion:nil];
        
    }
    
    
}
- (IBAction)addImageButtonPressed:(UIButton *)sender {
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  //  UIAlertController will automatically dismiss the view
                              }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Take photo"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [self showCamera];
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"Open Gallery"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [self openPhotoAlbum];
                              }];
    
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)saveInstructionButtonPressed:(UIButton *)sender {
    [self validateMealData:NO pop:NO];
}
- (IBAction)addInstructionButtonPressed:(UIButton *)sender {
    for (NSDictionary *instruction in instructionArray) {
        if ([Utility isEmptyCheck:instruction[@"InstructionText"]]) {
            return;
        }
    }
    NSDictionary *tempInstruction = [[NSDictionary alloc]initWithObjectsAndKeys:@-1,@"InstructionNo",@"",@"InstructionText",@-1,@"MealInstructionId", nil];
    [instructionArray addObject:tempInstruction];
    editingRow = (int)instructionArray.count - 1;
    [recipeInstructionTable reloadData];
    
    
}
- (IBAction)saveAndUseButtonPressed:(UIButton *)sender {
    if(_isFromMealMatch){
        isSaveButtonClicked = true;
        [self validateMealData:false pop:NO];
        return;
    }
    [self validateMealData:false pop:YES];
}
- (IBAction)saveButtonPressed:(UIButton *)sender {
    if(_isFromMealMatch){
        isSaveButtonClicked = true;
        [self validateMealData:false pop:NO];
        return;
    }else if([_fromController isEqualToString:@"Meal"]){
        [self validateMealData:false pop:YES];
        return;
    }
    
    saveViewPressed = true;
    [self validateMealData:false pop:NO];
}
- (IBAction)saveAndViewPressed:(UIButton *)sender {
//    if ([delegate respondsToSelector:@selector(reloadWithNewMeal:)]) {
//        [delegate reloadWithNewMeal:00];
//    }
//    if (fromMealView) {
//        //
//    } else {
//        //
//    }
    saveViewPressed = true;
    [self validateMealData:false pop:NO];
}
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    if ([delegate respondsToSelector:@selector(didCheckAnyChange:)]) {
        [delegate didCheckAnyChange:ischanged];
    }
    if (add) {
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:[self.navigationController viewControllers].count-3] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)deleteInstructionButtonPressed:(UIButton *)sender {
    [instructionArray removeObjectAtIndex:sender.tag];
    [recipeInstructionTable reloadData];
    [self validateMealData:false pop:NO];
}

- (IBAction)addIngredientsButtonPressed:(UIButton *)sender {
    for (NSDictionary *ingredient in ingredientsArray) {
        if (![Utility isEmptyCheck:ingredient]) {
            BOOL valid = true;
            if ([Utility isEmptyCheck:ingredient[@"IngredientId"]]) {
                valid = false;
                break;
            }else if([Utility isEmptyCheck:ingredient[@"IngredientName"]]){
                valid = false;
                break;
            }else if([Utility isEmptyCheck:ingredient[@"UnitImperial"]]){
                valid = false;
                break;
            }else if([Utility isEmptyCheck:ingredient[@"UnitMetric"]]){
                valid = false;
                break;
            }else if([Utility isEmptyCheck:ingredient[@"IngredientUnits"]]){
                valid = false;
                break;
            }else if([Utility isEmptyCheck:ingredient[@"IngredientImperialUnits"]]){
                valid = false;
                break;
            }else if([Utility isEmptyCheck:ingredient[@"IngredientDetails"]]){
                valid = false;
                break;
            }
            if (!valid) {
                return;
            }
        }else{
            return;
        }
    }
    NSDictionary *tempInstruction = [[NSDictionary alloc]init];
    [ingredientsArray addObject:tempInstruction];

    if (![Utility isEmptyCheck:mealData[@"MealClassifiedID"]] && [mealData[@"MealClassifiedID"] intValue] == 2) {
        editingRow = -1;
    }else{
        editingRow = (int)ingredientsArray.count - 1;
    }
    [recipeIngredientTable reloadData];
    
}
- (IBAction)deleteIngredientsButtonPressed:(UIButton *)sender {
    [ingredientsArray removeObjectAtIndex:sender.tag];
    [recipeIngredientTable reloadData];
    [self validateMealData:false pop:NO];
}

-(IBAction)ingredientQuantityInfoPressed:(UIButton *)sender{
    NSDictionary *ingredientDict = ingredientsArray[sender.tag];
    if (![Utility isEmptyCheck:ingredientDict] && ![Utility isEmptyCheck:ingredientDict[@"ConversionHint"]]) {
        [Utility msg:ingredientDict[@"ConversionHint"] title:@"" controller:self haveToPop:NO];
    }
    
}
-(IBAction)ingredientUnitPressed:(UIButton *)sender{
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    NSMutableDictionary *dict = ingredientsArray[sender.tag];
    if (![Utility isEmptyCheck:dict]) {
        if ([[defaults objectForKey:@"UnitPreference"] intValue] == 2)
        {
            NSArray *unitArray = dict[@"IngredientImperialUnits"];
            controller.dropdownDataArray = unitArray;
            if ([unitArray containsObject:dict[@"UnitImperial"]]) {
                controller.selectedIndex = (int)[unitArray indexOfObject:dict[@"UnitImperial"]];
            }else{
                controller.selectedIndex = -1;
            }
        }else{
            NSArray *unitArray = dict[@"IngredientUnits"];
            controller.dropdownDataArray = unitArray;
            if ([unitArray containsObject:dict[@"UnitMetric"]]) {
                controller.selectedIndex = (int)[unitArray indexOfObject:dict[@"UnitMetric"]];
            }else{
                controller.selectedIndex = -1;
            }
        }
    }
    
    controller.mainKey = nil;
    controller.apiType = nil;
    controller.delegate = self;
    controller.sender = sender;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)ingredientCalorieInfoButtonPressed:(UIButton*)sender{
    NutritionalInfoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionalInfoView"];
    controller.ingredientDict =ingredientsArray[sender.tag];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
-(IBAction)logoTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)back:(id)sender {
    if (add) {
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:[self.navigationController viewControllers].count-3] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(IBAction)noMeasureMealPresed:(UIButton *)sender{
    //popUp
    if (sender.isSelected) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@" "
                                      message:@"Hi, You are in view mode, click edit button to make changes."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    } else {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@" "
                                      message:@"Hi, This is an Unmeasure meal. Because these meals have no ingredient totals, they can not be edited. All Standard meals can be edited and personalised."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
- (IBAction)crossPressed:(UIButton *)sender {
    if(activeTextField){
        [self.view endEditing:YES];
    }else{
        showHideView.hidden = true;
    }
}
- (IBAction)addNewIngredientPressed:(UIButton *)sender {
    AddEditIngredientViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddEditIngredient"];
    controller.mealType = @"ADD INGREDIENT";
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    showHideView.hidden = true;
}
#pragma mark -End

#pragma mark -ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    uploadImage = false;
    showHideView.hidden = true;
    mealDetailsDictionary = [[NSMutableDictionary alloc]init];
    mealData = [[NSMutableDictionary alloc]init];
    ingredientsArray = [[NSMutableArray alloc]init];
    instructionArray = [[NSMutableArray alloc]init];
//    saveAndUseButton.hidden=[Utility isEmptyCheck:mealSessionId];
    
    if(_isFromMealMatch){
//        saveAndUseButton.hidden = false;
    }
    
    addImage.layer.borderWidth = 1;
    addImage.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    
    unit = @{
             @"0" : @"ALL",
             @"1" : @"METRIC",
             @"2" :  @"IMPERIAL"
             };
    apiCount = 0;
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [self registerForKeyboardNotifications];
    
    [self toggleButtonBackground:addIngredientsButton];
    [self toggleButtonBackground:addInstructionsButton];
//    [self toggleButtonBackground:lunch];
//    [self toggleButtonBackground:snack];
//    [self toggleButtonBackground:drink];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getIngredientsApiCall];
        [self getUnitPreference];
        [self getGoodnessDetails];
    });
//    addIngredientsButton.layer.cornerRadius = 7;
//    addIngredientsButton.clipsToBounds = YES;
    
//    addInstructionsButton.layer.cornerRadius = 7;
//    addIngredientsButton.clipsToBounds = YES;
    
//    recipeInstructionTable.estimatedRowHeight=45;
//    recipeInstructionTable.rowHeight=UITableViewAutomaticDimension;
    [filterTextField addTarget:self action:@selector(textValueChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)viewWillAppear:(BOOL)animated{

    editingRow = -1;
    viewRow = -1;
    saveViewPressed = false;
    [recipeIngredientTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [recipeInstructionTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];// 29032018

    //ah ux
//    NSString *title = @"Save";
//    if (![Utility isEmptyCheck:_fromController]) {
//        title = [title stringByAppendingFormat:@" %@",_fromController];
//    }
//    [saveButton setTitle:title forState:UIControlStateNormal];
}
-(void)viewWillDisappear:(BOOL)animated{
    [recipeIngredientTable removeObserver:self forKeyPath:@"contentSize"];
    [recipeInstructionTable removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];// 29032018

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    recipeIngredientTableHeightConstraints.constant=recipeIngredientTable.contentSize.height;
    recipeInstructionTableHeightConstraints.constant=recipeInstructionTable.contentSize.height;
    
    
}
#pragma mark -End
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:filterTable]) {
        return tempMealArray.count;
    }else if ([tableView isEqual:recipeIngredientTable]) {
        return ingredientsArray.count;
    }else{
        return instructionArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == recipeInstructionTable) {
        return 45;
    }
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell;
    if ([tableView isEqual:filterTable]) {
        foodPrepSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodPrepSearchTableViewCell"];
        
        //    cell.mealNameLabel.text = ![Utility isEmptyCheck:mealListArray[indexPath.row][@"MealName"]]?mealListArray[indexPath.row][@"MealName"]:@"";
        NSString *ingredientName = ![Utility isEmptyCheck:tempMealArray[indexPath.row][@"IngredientName"]]?tempMealArray[indexPath.row][@"IngredientName"]:@"";
        cell.mealNameLabel.text = ingredientName;
        
        tableCell = cell;
    } else if ([tableView isEqual:recipeIngredientTable]) {
        NSString *CellIdentifier = @"AddIngredientsTableViewCell";
        AddIngredientsTableViewCell *cell;
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[AddIngredientsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
//        cell.mainContainerView.layer.masksToBounds = YES;
//        cell.mainContainerView.layer.cornerRadius = 3;
        
        cell.ingredientNameButton.tag = indexPath.row;
        cell.ingredientQuantityInfo.tag = indexPath.row;
        cell.ingredientUnit.tag = indexPath.row;
        cell.ingredientCalorieInfoButton.tag = indexPath.row;
        cell.deleteIngredient.tag = indexPath.row;
        cell.ingredientSave.tag = indexPath.row;
        cell.ingredientQuantity.tag = indexPath.row;
        
        cell.ingredientSave.layer.borderWidth = 1;
        cell.ingredientSave.layer.borderColor = [UIColor colorWithRed:228/255.0f green:42/255.0f blue:161/255.0f alpha:1.0].CGColor;
        cell.deleteIngredient.layer.borderWidth = 1;
        cell.deleteIngredient.layer.borderColor = [UIColor colorWithRed:228/255.0f green:42/255.0f blue:161/255.0f alpha:1.0].CGColor;
        
        cell.editIngredientButton.tag = indexPath.row;
        if (editingRow != -1 && editingRow == indexPath.row) {
            cell.editIngredientButton.selected = true;

            if (cell.editIngredientButton.isSelected) {
                cell.ingredientSaveView.hidden = false;
                cell.ingredientDetailsView.hidden = false;
                cell.ingredientNameButton.selected = true;
            } else {
                cell.ingredientSaveView.hidden = true;
                cell.ingredientDetailsView.hidden = true;
                cell.ingredientNameButton.selected = false;
            }
            if ([Utility isEmptyCheck:ingredientsArray[indexPath.row]]) {
                cell.editIngredientButton.selected = true;
                cell.ingredientSaveView.hidden = false;
                cell.ingredientDetailsView.hidden = false;
                cell.ingredientNameButton.selected = true;
            }
        }else{
            cell.editIngredientButton.selected = false;
            cell.ingredientDetailsView.hidden = true;
            cell.ingredientSaveView.hidden = true;
            cell.ingredientNameButton.selected = false;
        }
        
        if (![Utility isEmptyCheck:mealData[@"MealClassifiedID"]] && [mealData[@"MealClassifiedID"] intValue] == 2) {
            //no measure
            cell.ingredientUnit.enabled = false;
            cell.ingredientQuantity.enabled = false;
            //cell.editIngredientButton.hidden = true;
            cell.popUpButton.hidden = false;
            cell.popUpButton.selected = false;
        }else{
            cell.ingredientUnit.enabled = true;
            cell.ingredientQuantity.enabled = true;
            //cell.editIngredientButton.hidden = false;
            cell.popUpButton.hidden = true;
            cell.popUpButton.selected = false;
        }
        if (viewRow == indexPath.row) {
            cell.editIngredientButton.selected = false;
            cell.ingredientSaveView.hidden = true;
            cell.ingredientDetailsView.hidden = false;
            cell.ingredientNameButton.selected = false;
            cell.popUpButton.selected = true;
            cell.popUpButton.hidden = false;
        }else{
            cell.popUpButton.selected = false;
        }
        NSDictionary *ingredientDict = ingredientsArray[indexPath.row];
        if (![Utility isEmptyCheck:ingredientDict]) {
            [cell.ingredientNameButton setImage:nil forState:UIControlStateNormal];
            if (ingredientsAllList.count > 0) {
                NSDictionary *d =[Utility getDictByValue:ingredientsAllList value:ingredientDict[@"IngredientId"] type:@"IngredientId"];
                if (![Utility isEmptyCheck:d]) {
                    [cell.ingredientNameButton setTitle:d[@"IngredientName"] forState:UIControlStateNormal];
                    if([[defaults objectForKey:@"UnitPreference"] intValue] == 2){
                        [cell.ingredientUnit setTitle:ingredientDict[@"UnitImperial"] forState:UIControlStateNormal];
                        cell.ingredientQuantity.text =[@"" stringByAppendingFormat:@"%g", [ingredientDict[@"QuantityImperial"]floatValue]];
                    }else{
                        [cell.ingredientUnit setTitle:ingredientDict[@"UnitMetric"] forState:UIControlStateNormal];
                        cell.ingredientQuantity.text =[@"" stringByAppendingFormat:@"%g",[ingredientDict[@"QuantityMetric"]floatValue]];
                    }
                }else{
                    cell.ingredientUnit.enabled = false;
                    cell.ingredientQuantity.enabled = false;
                }
                
            }
            NSDictionary *ingredientDetails = ingredientDict[@"IngredientDetails"];
            float quantity = 0;
            NSString *unitString = @"";
//            quantity = [ingredientDict[@"QuantityImperial"] floatValue];
            if ([[defaults objectForKey:@"UnitPreference"] intValue] == 2)
            {
                 quantity = [ingredientDict[@"QuantityImperial"] floatValue];
                //quantity = [ingredientDict[@"QuantityMetric"] floatValue];
                unitString = ingredientDict[@"UnitImperial"];
                //unitString = ingredientDict[@"UnitMetric"];
            }else
            {
                quantity = [ingredientDict[@"QuantityMetric"] floatValue];
                unitString = ingredientDict[@"UnitMetric"];
            }
            quantity = [ingredientDict[@"QuantityMetric"] floatValue];

            if ([unitString isEqualToString:@"as needed"] || [unitString isEqualToString:@"to taste"])
            {
                quantity = 0;
            }
            
            if (quantity > 0 && quantity != 0 && ![unitString isEqualToString:@""])
            {
                Calorie *cal =[Utility ingredientCalorieCalculation:quantity proteinPer100:[ingredientDetails[@"ProteinPer100"] floatValue] fatPer100:[ingredientDetails[@"FatPer100"] floatValue] carbPer100:[ingredientDetails[@"CarbsPer100"] floatValue] alcoholPer100:[ingredientDetails[@"AlcoholPer100"] floatValue] unit:unitString conversionUnit:ingredientDetails[@"ConversionUnit"] conversionFactor:[ingredientDetails[@"ConversionNum"] floatValue]];
                cell.ingredientCalorie.text = [Utility totalCalories:cal];
            }else{
                cell.ingredientCalorie.text =@"0";
            }
        }else{
            //14/03/18 shabbir
//            [cell.mainStackView removeArrangedSubview:cell.quantityView];
//            [cell.quantityView removeFromSuperview];
//            [cell.mainStackView insertArrangedSubview:cell.quantityView atIndex:2];
            [cell.ingredientNameButton setTitle:@"Search ingredient name" forState:UIControlStateNormal];
            [cell.ingredientNameButton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
            cell.ingredientQuantity.text =@"";
            [cell.ingredientUnit setTitle:@"" forState:UIControlStateNormal];
            cell.ingredientCalorie.text =@"";
            cell.ingredientUnit.enabled = false;
            cell.ingredientQuantity.enabled = false;
        }
        tableCell = cell;
    }else{
        NSString *CellIdentifier = @"AddInstructionTableViewCell";
        AddInstructionTableViewCell *cell;
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[AddInstructionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.instructionNumber.text = [@"" stringByAppendingFormat:@"%d.",(int)indexPath.row+1];
        cell.saveInstructionButton.layer.borderWidth = 1;
        cell.saveInstructionButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:42/255.0f blue:161/255.0f alpha:1.0].CGColor;
        cell.deleteInstruction.layer.borderWidth = 1;
        cell.deleteInstruction.layer.borderColor = [UIColor colorWithRed:228/255.0f green:42/255.0f blue:161/255.0f alpha:1.0].CGColor;
        cell.ingredientSaveView.hidden = true;
        cell.editInstructionButton.tag = indexPath.row;
        if (editingRow != -1 && editingRow == indexPath.row) {
            cell.editInstructionButton.selected = !cell.editInstructionButton.isSelected;
            editingRow = -1;
            if (cell.editInstructionButton.isSelected) {
                cell.ingredientSaveView.hidden = false;
                cell.instruction.userInteractionEnabled = true;
            } else {
                cell.ingredientSaveView.hidden = true;
                cell.instruction.userInteractionEnabled = false;
            }
        }else{
            cell.editInstructionButton.selected = false;
            cell.instruction.userInteractionEnabled = false;
        }
        
        NSDictionary *instructionDict = instructionArray[indexPath.row];
        if (![Utility isEmptyCheck:instructionDict]) {
            if (![Utility isEmptyCheck:instructionDict[@"InstructionText"]]) {
                cell.instruction.alpha = 1.0;
            } else {
                cell.instruction.alpha = 0.5;
            }
            cell.instruction.text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:instructionDict[@"InstructionText"]]?instructionDict[@"InstructionText"]:@"Type instruction."];
            if ([instructionDict[@"InstructionNo"] isEqual:@-1] && [instructionDict[@"MealInstructionId"] isEqual:@-1]) {
                cell.saveInstructionButton.hidden = false;
            }else{
                cell.saveInstructionButton.hidden = true;
            }
            cell.instruction.tag = indexPath.row;
            cell.deleteInstruction.tag = indexPath.row;
            cell.saveInstructionButton.tag = indexPath.row;
        }
        tableCell = cell;
    }
    
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:filterTable]) {
        showHideView.hidden = true;
//        NSDictionary *data = tempMealArray[indexPath.row];
//        [ingredientButton setTitle:![Utility isEmptyCheck:data[@"IngredientName"]] ? data[@"IngredientName"] :@"" forState:UIControlStateNormal];
//        MealName = ![Utility isEmptyCheck:data[@"IngredientName"]] ? data[@"IngredientName"] :@"";
//        MealId = ![Utility isEmptyCheck:data[@"IngredientId"]] ? [data[@"IngredientId"] intValue] :0;
//        ingredientButton.tag = [mealListArray indexOfObject:data];
//        [self getIngredientUnit];
        
        NSDictionary *selectedData = tempMealArray[indexPath.row];
        NSMutableDictionary *ingredientDict = [ingredientsArray[showHideView.tag] mutableCopy];
        if ([Utility isEmptyCheck:ingredientDict]) {
            ingredientDict = [[NSMutableDictionary alloc]init];
        }
        [ingredientDict setObject:@"" forKey:@"Brand"];
        [ingredientDict setObject:selectedData[@"IngredientId"] forKey:@"IngredientId"];
        [ingredientDict setObject:selectedData[@"IngredientName"] forKey:@"IngredientName"];
        [ingredientDict setObject:selectedData[@"ConversionHint"] forKey:@"ConversionHint"];
        [ingredientDict setObject:selectedData[@"UnitImperial"] forKey:@"UnitImperial"];
        [ingredientDict setObject:@0 forKey:@"TotalCalories"];
        [ingredientDict setObject:selectedData[@"UnitMetric"] forKey:@"UnitMetric"];
        [ingredientDict setObject:@0 forKey:@"QuantityImperial"];
        [ingredientDict setObject:@0 forKey:@"QuantityMetric"];
        [ingredientDict setObject:@[selectedData[@"UnitMetric"],selectedData[@"ConversionUnit"],@"as needed",@"to taste",@"pinch"] forKey:@"IngredientUnits"];
        [ingredientDict setObject:@[selectedData[@"UnitImperial"],selectedData[@"ConversionUnit"],@"as needed",@"to taste",@"pinch"] forKey:@"IngredientImperialUnits"];
        [ingredientDict setObject:@0 forKey:@"MealIngredientId"];
        [ingredientDict setObject:selectedData forKey:@"IngredientDetails"];
        [ingredientsArray replaceObjectAtIndex:showHideView.tag withObject:ingredientDict];
        [self setQuantity];
        [recipeIngredientTable reloadData];
        
        [self.view endEditing:YES];
//        [sender setTitle:[selectedData objectForKey:@"IngredientName"] forState:UIControlStateNormal];
        
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
    if (!showHideView.isHidden) {
        filterTable.contentInset = contentInsets;
        filterTable.scrollIndicatorInsets = contentInsets;
    }
    
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
    if (!showHideView.isHidden) {
        filterTable.contentInset = contentInsets;
        filterTable.scrollIndicatorInsets = contentInsets;
    }
}
#pragma mark - End -
-(void)textValueChange:(UITextField *)textField{
    NSLog(@"search for %@", textField.text);
    if (textField.text.length > 0) {
        tempMealArray = [ingredientsAllList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IngredientName CONTAINS[c] %@)", textField.text]];
    } else {
        tempMealArray = ingredientsAllList;
    }
    [filterTable reloadData];
}
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
    if ([textField isEqual:filterTextField]) {
        return;
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    if ([textField isEqual:recipeName]) {
        if (![Utility isEmptyCheck:textField.text]) {
            [mealData setObject:textField.text forKey:@"MealName"];
            [self validateMealData:false pop:NO];
        }else{
            [Utility msg:@"Recipe Name cannot be blank." title:@"Warning !" controller:self haveToPop:NO];
            return;
            
        }
    }else if ([textField isEqual:recipePrepTime]) {
        if (![Utility isEmptyCheck:[formatter numberFromString:textField.text]]) {
            [mealData setObject:[formatter numberFromString:textField.text] forKey:@"PreparationMinutes"];
            [self validateMealData:false pop:NO];
        }else{
            [Utility msg:@"Please enter  valid Preparation Time." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
    }else{
        NSMutableDictionary *ingredientDict = [ingredientsArray[textField.tag] mutableCopy];
        if ([Utility isEmptyCheck:ingredientDict]) {
            ingredientDict = [[NSMutableDictionary alloc]init];
        }
        NSLog(@"%@",[defaults objectForKey:@"UnitPreference"]);
        if (![Utility isEmptyCheck:[formatter numberFromString:textField.text]]) {
            if ([[defaults objectForKey:@"UnitPreference"] intValue] == 2)
            {
                [ingredientDict setObject:[formatter numberFromString:textField.text] forKey:@"QuantityImperial"];
            }else{
                [ingredientDict setObject:[formatter numberFromString:textField.text] forKey:@"QuantityMetric"];
            }
            [ingredientsArray replaceObjectAtIndex:textField.tag withObject:ingredientDict];
            [self setQuantity];
            [recipeIngredientTable reloadData];
        }else{
            [Utility msg:@"Please enter  valid quantity." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
        
        
    }
}
#pragma mark - End

#pragma mark - textView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    [recipeInstructionTable beginUpdates];
    [recipeInstructionTable endUpdates];
}
- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Type instruction."]) {
        textView.text = @"";
    }
    textView.alpha = 1.0;
    [textView setInputAccessoryView:toolBar];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    activeTextView = textView;
    activeTextField = nil;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSMutableDictionary *dict = [instructionArray[textView.tag] mutableCopy];
    [dict setObject:textView.text forKey:@"InstructionText"];
    [instructionArray replaceObjectAtIndex:textView.tag withObject:dict];
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Type instruction.";
        textView.alpha = 0.5;
    }else{
        textView.alpha = 1.0;
    }
    activeTextView = nil;
}


#pragma mark - End
#pragma -mark DropDownViewDelegate
-(void)dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{
    
    NSMutableDictionary *ingredientDict = [ingredientsArray[sender.tag] mutableCopy];
    if ([Utility isEmptyCheck:ingredientDict]) {
        ingredientDict = [[NSMutableDictionary alloc]init];
    }
    if ([[defaults objectForKey:@"UnitPreference"] intValue] == 2)
    {
        [ingredientDict setObject:selectedValue forKey:@"UnitImperial"];
    }else{
        [ingredientDict setObject:selectedValue forKey:@"UnitMetric"];
    }
    
    [ingredientsArray replaceObjectAtIndex:sender.tag withObject:ingredientDict];
    [self setQuantity];
    [recipeIngredientTable reloadData];
    
    [sender setTitle:selectedValue forState:UIControlStateNormal];
}
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData sender:(UIButton *)sender{
    
    if ([type caseInsensitiveCompare:@"IngredientName"] == NSOrderedSame) {
        NSMutableDictionary *ingredientDict = [ingredientsArray[sender.tag] mutableCopy];
        if ([Utility isEmptyCheck:ingredientDict]) {
            ingredientDict = [[NSMutableDictionary alloc]init];
        }
        [ingredientDict setObject:@"" forKey:@"Brand"];
        [ingredientDict setObject:selectedData[@"IngredientId"] forKey:@"IngredientId"];
        [ingredientDict setObject:selectedData[@"IngredientName"] forKey:@"IngredientName"];
        [ingredientDict setObject:selectedData[@"ConversionHint"] forKey:@"ConversionHint"];
        [ingredientDict setObject:selectedData[@"UnitImperial"] forKey:@"UnitImperial"];
        [ingredientDict setObject:@0 forKey:@"TotalCalories"];
        [ingredientDict setObject:selectedData[@"UnitMetric"] forKey:@"UnitMetric"];
        [ingredientDict setObject:@0 forKey:@"QuantityImperial"];
        [ingredientDict setObject:@0 forKey:@"QuantityMetric"];
        [ingredientDict setObject:@[selectedData[@"UnitMetric"],selectedData[@"ConversionUnit"],@"as needed",@"to taste",@"pinch"] forKey:@"IngredientUnits"];
        [ingredientDict setObject:@[selectedData[@"UnitImperial"],selectedData[@"ConversionUnit"],@"as needed",@"to taste",@"pinch"] forKey:@"IngredientImperialUnits"];
        [ingredientDict setObject:@0 forKey:@"MealIngredientId"];
        [ingredientDict setObject:selectedData forKey:@"IngredientDetails"];
        [ingredientsArray replaceObjectAtIndex:sender.tag withObject:ingredientDict];
        [self setQuantity];
        [recipeIngredientTable reloadData];
        
        [sender setTitle:[selectedData objectForKey:@"IngredientName"] forState:UIControlStateNormal];
    }
}
#pragma -mark End
#pragma mark - UIImagePickerControllerDelegate methods

/*
 Open PECropViewController automattically when image selected.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image =[Utility scaleImage:image width:image.size.width height:image.size.height];
    mealImage.image = image;
    mealImage.hidden = false;
    selectedImage = image;
    [addImage setTitle:@"CHANGE" forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditor:nil];
    }];
}
#pragma mark - End
#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    uploadImage = true;
    [controller dismissViewControllerAnimated:YES completion:NULL];
    //    userImageView.image = croppedImage;
    //    UIImage *image=[self scaleImage:croppedImage];
    mealImage.image = croppedImage;
    selectedImage = croppedImage;
    [addImage setTitle:@"CHANGE" forState:UIControlStateNormal];
    [self validateMealData:YES pop:NO];
    
    //    [self writeImageInDocumentsDirectory:chosenImage];
    //    [self webservicecallForUploadImage];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //[self updateEditButtonEnabled];
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //[self updateEditButtonEnabled];
    }
    
    uploadImage = true;
    [controller dismissViewControllerAnimated:YES completion:NULL];
    [self validateMealData:YES pop:NO];
    
}
#pragma mark -End

#pragma mark -Memory Issue

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -End





#pragma mark apiCall

//chayan 18/10/2017
-(void)saugataMultipart:(BOOL)withImage pop:(BOOL)pop{
    if (Utility.reachable) {
        multipartPop=pop;
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mealData setObject:[NSNumber numberWithBool:YES] forKey:@"IsSquad"];
        [mealData setObject:[NSNumber numberWithBool:NO] forKey:@"IsAbbbc"];
        //[mealData setObject:[NSNumber numberWithBool:YES] forKey:@"AllowSubmit"];
//        if (withImage) {
//            if (![Utility isEmptyCheck:selectedImage]) {
//                selectedImage =[Utility scaleImage:selectedImage width:selectedImage.size.width height:selectedImage.size.height];
//                selectedImage = [UIImage imageWithData:UIImageJPEGRepresentation(selectedImage, 0.2)];
//                NSString *imgBase64Str = [UIImagePNGRepresentation(selectedImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//                [mealData setObject:imgBase64Str forKey:@"PhotoPath"];
//            }else{
//                [mealData setObject:@"" forKey:@"PhotoPath"];
//            }
//        }else{
//            [mealData setObject:@"" forKey:@"PhotoPath"];
//            [mealData setObject:@"" forKey:@"PhotoSmallPath"];
//        }

        if (!uploadImage) {
            selectedImage = nil;
        }
        [mainDict setObject:@{@"MealData" : mealData, @"Ingredients": ingredientsArray, @"Instructions" : instructionArray} forKey:@"MealDetails"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateMealRecipeWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.chosenImage=selectedImage;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
        
        
    }
    else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}


#pragma mark End




//chayan 18/10/2017
#pragma mark - progressbar delegate

- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //29/03/18
        self->editingRow = -1;
        self->viewRow = -1;
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"] boolValue]) {
            NSLog(@"nourish save :\n%@",responseDict);
            self->uploadImage = false;
            self->ischanged = true; //Nutrition_local_catch
            
            if (self->multipartPop) {
                self->mealId = responseDict[@"MealId"];
                [self squadUpdateMealForSessionApiCall];;
            }else{
                self->mealId = responseDict[@"MealId"];
                
                [self getGoodnessDetails];
                if((self->_MealType>0 && !self->_isFromMealMatch) || (self->_isFromMealMatch && self->isSaveButtonClicked)){
                    self->isSaveButtonClicked = false;
                    [self getSquadMealList:2 mealName:self->mealData isStatic:true];
                }else{
//                    [Utility msg:@"Recipe saved successfully." title:@"Success" controller:self haveToPop:NO];
                    if (self->saveViewPressed) {
                        [self handlePushView];
                    }
                }
                
            }
        }
        else{
            [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
            return;
        }
    });
}


- (void) completedWithError:(NSError *)error{
    
    editingRow = -1;
    viewRow = -1;
    [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
}

-(void)handlePushView{
    
    if (fromMealView) {
        if ([delegate respondsToSelector:@selector(reloadWithNewMeal:)]) {
            [delegate reloadWithNewMeal:mealId];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        DailyGoodnessDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyGoodnessDetail"];
        controller.mealId = mealId;
        controller.delegate=self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - End

#pragma mark - Ingredient Add Delegate
-(void)didCheckAnyChangeIngredient:(BOOL)isChanged{
    if(isChanged){
        dontUpdateVIew = true;
        [self getIngredientsApiCall];
    }
}
#pragma mark - End
@end















