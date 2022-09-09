//
//  CustomNutritionMealSettingsViewController.m
//  Squad
//
//  Created by aqbsol iPhone on 02/02/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "CustomNutritionMealSettingsViewController.h"
#import "ProgressBarViewController.h"
#import "MealSettingInfoPopUpViewController.h"

@interface CustomNutritionMealSettingsViewController ()
{
    UIView *contentView;
    int apiCount;
    NSMutableArray *nutritionPlanListArray;
    NSArray *ingredientsAllList;
    NSMutableDictionary *mealDetailsDictionary;
    NSMutableDictionary *mealData;
    NSMutableDictionary *tempMealData;
    NSMutableArray *ingredientsArray;
    NSMutableArray *instructionArray;
    NSDictionary *unit;
    NSArray *unitPreferenceArray;
    UITextField *activeTextField;
    UITextView *activeTextView;
    UIToolbar *toolBar;
    UIImage *selectedImage;
    BOOL isSaveButtonClicked;
    BOOL multipartPop;
    NSDateFormatter *dailyDateformatter;
    NSMutableArray *avoidAllArray;
    NSMutableDictionary *myMeal;
    NSMutableArray *recipeList;
    
    BOOL isEditing;
    BOOL isChanged;
}
@property (weak, nonatomic) IBOutlet UILabel *mealNameText;
@property (weak, nonatomic) IBOutlet UIButton *breakfastButton;
@property (weak, nonatomic) IBOutlet UIButton *bCrossButton;
@property (weak, nonatomic) IBOutlet UIButton *lunchButton;
@property (weak, nonatomic) IBOutlet UIButton *lCrossButton;
@property (weak, nonatomic) IBOutlet UIButton *dinnerButton;
@property (weak, nonatomic) IBOutlet UIButton *dCrossButton;
@property (weak, nonatomic) IBOutlet UIButton *snackButton;
@property (weak, nonatomic) IBOutlet UIButton *sCrossButton;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *allCrossButton;
@property (weak, nonatomic) IBOutlet UIButton *saveSettingButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation CustomNutritionMealSettingsViewController
@synthesize mealId,mealSessionId,dateString,fromController,weekDate,mealData,delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mealDetailsDictionary = [[NSMutableDictionary alloc]init];
    mealData = [[NSMutableDictionary alloc]init];
    tempMealData = [[NSMutableDictionary alloc]init];
    ingredientsArray = [[NSMutableArray alloc]init];
    instructionArray = [[NSMutableArray alloc]init];
    nutritionPlanListArray = [[NSMutableArray alloc]init];
    apiCount = 0;
    dailyDateformatter = [[NSDateFormatter alloc]init];
    [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
    recipeList = [[NSMutableArray alloc]init];
    myMeal = [[NSMutableDictionary alloc]init];
    avoidAllArray = [[NSMutableArray alloc]init];
    
    [self makeButtonBorderPink:_breakfastButton];
    [self makeButtonBorderPink:_lunchButton];
    [self makeButtonBorderPink:_dinnerButton];
    [self makeButtonBorderPink:_snackButton];
    [self makeButtonBorderPink:_allButton];
    [self makeButtonBorderPink:_cancelButton];
    
}
-(void)viewWillAppear:(BOOL)animated{
    isEditing = false;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitList:) name:@"backButtonPressed" object:nil];// 29032018
    [self getRecipeList:NO];
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];// 29032018
}
-(void)makeButtonBorderPink:(UIButton *)button{
    button.layer.borderWidth = 2.0f;
    button.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
}

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
            myMeal = [[NSMutableDictionary alloc]init];
            recipeList = [[NSMutableArray alloc]init];
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
//            table.hidden = true;
//            blankMsgLabel.hidden = false;
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
                                                                         isChanged = true;
                                                                         avoidAllArray = [[NSMutableArray alloc]init];
//                                                                         saveAll.hidden = true;
//                                                                         [self getRecipeList:NO];
                                                                         if ([delegate respondsToSelector:@selector(didCheckAnyChangeForMealSettings:)]) {
                                                                             [delegate didCheckAnyChangeForMealSettings:isChanged];
                                                                         }
                                                                         [self.navigationController popViewControllerAnimated:YES];
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
-(void)getRecipeList:(BOOL)isFromAdvanceSearch{
    if (Utility.reachable) {
        recipeList = [[NSMutableArray alloc]init];
        NSError *error;
//        if (!isFromAdvanceSearch) {
//            [self setDefaultSearchParameter];
//        }
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];//WithDictionary:filterDict];
        
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
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
//            table.hidden = true;
//            blankMsgLabel.hidden = false;
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         recipeList = [responseDict[@"Meals"] mutableCopy];
                                                                         if (![Utility isEmptyCheck:recipeList] && recipeList.count > 0) {
                                                                             NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"mealdetail.MealName"  ascending:YES selector:@selector(caseInsensitiveCompare:)];
                                                                             
                                                                             recipeList=[[recipeList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]] mutableCopy];
                                                                             myMeal = [[NSMutableDictionary alloc]init];
                                                                             for (NSDictionary *temp in recipeList) {
                                                                                 NSDictionary *mealdetail = temp[@"mealdetail"];
                                                                                 NSNumber *myId = mealdetail[@"Id"];
                                                                                 if (mealId == myId) {
                                                                                     myMeal = [temp mutableCopy];
                                                                                     _mealNameText.text = mealdetail[@"MealName"];
                                                                                 }
                                                                             }
                                                                             if (apiCount == 0) {
//                                                                                 [table reloadData];
//                                                                                 table.hidden = false;
//                                                                                 blankMsgLabel.hidden = true;
                                                                                 [self updateView];
                                                                             }
                                                                         }else{
//                                                                             [table reloadData];
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
//-(void)getGoodnessDetails{
//    if (Utility.reachable) {
//        NSError *error;
//        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
//        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
//        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
//        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
//        [mainDict setObject:mealId forKey:@"MealId"];
//        
//        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
//        if (error) {
//            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
//            return;
//        }
//        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
//        dispatch_async(dispatch_get_main_queue(),^ {
//            apiCount++;
//            if (contentView) {
//                [contentView removeFromSuperview];
//            }
//            contentView = [Utility activityIndicatorView:self];
//        });
//        NSURLSession *dailySession = [NSURLSession sharedSession];
//        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMealDetailsApiCall" append:@"" forAction:@"POST"];
//        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
//                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                             dispatch_async(dispatch_get_main_queue(),^ {
//                                                                 apiCount --;
//                                                                 if (contentView && apiCount == 0) {
//                                                                     [contentView removeFromSuperview];
//                                                                 }
//                                                                 if(error == nil)
//                                                                 {
//                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
//                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
//                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
//                                                                         } else {
//                                                                             mealDetailsDictionary = [[responseDictionary objectForKey:@"Meal"]mutableCopy];
//                                                                             mealData = [mealDetailsDictionary[@"MealData"]mutableCopy];
//                                                                             tempMealData = [mealDetailsDictionary[@"MealData"]mutableCopy];
//                                                                             ingredientsArray = [mealDetailsDictionary[@"Ingredients"] mutableCopy];
//                                                                             instructionArray= [mealDetailsDictionary[@"Instructions"] mutableCopy];
//                                                                             if(mealData){
//                                                                                 [self updateView];
//                                                                             }
//                                                                             if (![Utility isEmptyCheck:mealDetailsDictionary]) {
//                                                                                 NSString *imageString=![Utility isEmptyCheck:[mealData objectForKey:@"PhotoPath"]] ? [@"" stringByAppendingFormat:@"%@",[mealData objectForKey:@"PhotoPath"]] : @"" ;
//                                                                                 if (![Utility isEmptyCheck:imageString]) {
////                                                                                     mealImage.image = [UIImage imageNamed:@"new_image_loading.png"];   //ah 17.5
////                                                                                     SDWebImageManager *manager = [SDWebImageManager sharedManager];
////                                                                                     [manager downloadImageWithURL:[NSURL URLWithString:imageString]
////                                                                                                           options:0
////                                                                                                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {
////                                                                                                              // progression tracking code
////                                                                                                          }
////                                                                                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
////
////                                                                                                             if (image) {
////                                                                                                                 selectedImage = image;
////                                                                                                                 mealImage.image = image;
////                                                                                                             }
////                                                                                                             else {
////                                                                                                                 selectedImage = nil;
////                                                                                                                 mealImage.image = [UIImage imageNamed:@"image_loading.png"];
////                                                                                                             }
////                                                                                                         }];
//                                                                                 }else {
////                                                                                     mealImage.image = [UIImage imageNamed:@"image_loading.png"];
////                                                                                     selectedImage = nil;
//                                                                                 }
//
//
//                                                                                 
//                                                                             }
//                                                                             if (apiCount==0) {
////                                                                                 [self prepareView];
//                                                                             }
//                                                                         }
//                                                                     }else{
//                                                                         [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
//                                                                         return;
//                                                                     }
//
//                                                                 }else{
//                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
//                                                                 }
//                                                             });
//                                                         }];
//        [dataTask resume];
//        
//    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
//    }
//    
//}
//-(void)saveMealType:(BOOL)withImage pop:(BOOL)pop{
//    if (Utility.reachable) {
//        multipartPop=pop;
//        NSError *error;
//        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
//        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
//        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
//        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
//        [mealData setObject:[NSNumber numberWithBool:YES] forKey:@"IsSquad"];
//        [mealData setObject:[NSNumber numberWithBool:NO] forKey:@"IsAbbbc"];
//        //[mealData setObject:[NSNumber numberWithBool:YES] forKey:@"AllowSubmit"];
//        //        if (withImage) {
//        //            if (![Utility isEmptyCheck:selectedImage]) {
//        //                selectedImage =[Utility scaleImage:selectedImage width:selectedImage.size.width height:selectedImage.size.height];
//        //                selectedImage = [UIImage imageWithData:UIImageJPEGRepresentation(selectedImage, 0.2)];
//        //                NSString *imgBase64Str = [UIImagePNGRepresentation(selectedImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        //                [mealData setObject:imgBase64Str forKey:@"PhotoPath"];
//        //            }else{
//        //                [mealData setObject:@"" forKey:@"PhotoPath"];
//        //            }
//        //        }else{
//        //            [mealData setObject:@"" forKey:@"PhotoPath"];
//        //            [mealData setObject:@"" forKey:@"PhotoSmallPath"];
//        //        }
//
//        [mainDict setObject:@{@"MealData" : mealData, @"Ingredients": ingredientsArray, @"Instructions" : instructionArray} forKey:@"MealDetails"];
//
//        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
//        if (error) {
//            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
//            return;
//        }
//        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
//        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
//        controller.delegate=self;
//        controller.apiName=@"AddUpdateMealRecipeWithPhoto";
//        controller.appendString=@"";
//        controller.jsonString=jsonString;
//        controller.chosenImage=selectedImage;
//        controller.modalPresentationStyle = UIModalPresentationCustom;
//        [self presentViewController:controller animated:YES completion:nil];
//
//    }
//    else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
//    }
//
//}
//-(void)webservicecall_GetUserRecipeByName:(BOOL)withImage pop:(BOOL)pop{
//    if (Utility.reachable) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (contentView) {
//                [contentView removeFromSuperview];
//            }
//            contentView = [Utility activityIndicatorView:self];
//        });
//
//        NSURLSession *customSession = [NSURLSession sharedSession];
//
//        NSError *error;
//
//        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
//        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
//        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
//        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
//        [mainDict setObject:_mealNameText.text forKey:@"RecipeName"];
//
//
//        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
//        if (error) {
//            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
//            return;
//        }
//        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
//
//        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserRecipeByName" append:@""forAction:@"POST"];
//        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
//                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                              dispatch_async(dispatch_get_main_queue(), ^{
//                                                                  if (contentView) {
//                                                                      [contentView removeFromSuperview];
//                                                                  }
//                                                                  if(error == nil)
//                                                                  {
//                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
//                                                                          [self webserviceCall_IsMealNameExisting:[responseDict objectForKey:@"MealId"] withImage:withImage pop:pop];
//                                                                      }
//                                                                      else{
//                                                                          [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
//                                                                          return;
//                                                                      }
//                                                                  }else{
//                                                                      [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
//                                                                  }
//                                                              });
//
//                                                          }];
//        [dataTask resume];
//
//    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
//    }
//
//}
//-(void) webserviceCall_IsMealNameExisting:(NSNumber*)mealIdNew withImage:(BOOL)withImage pop:(BOOL)pop{
//    if (Utility.reachable) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (contentView) {
//                [contentView removeFromSuperview];
//            }
//            contentView = [Utility activityIndicatorView:self];
//        });
//
//        NSURLSession *customSession = [NSURLSession sharedSession];
//
//        NSError *error;
//
//        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
//        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
//        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
//        [mainDict setObject:mealIdNew forKey:@"MealId"];
//        [mainDict setObject:_mealNameText.text forKey:@"RecipeName"];
//        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
//        if (error) {
//            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
//            return;
//        }
//        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
//
//        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"IsMealNameExisting" append:@""forAction:@"POST"];
//        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
//                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                              dispatch_async(dispatch_get_main_queue(), ^{
//                                                                  if (contentView) {
//                                                                      [contentView removeFromSuperview];
//                                                                  }
//                                                                  if(error == nil)
//                                                                  {
//                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
//
//                                                                          bool isExisting =[[responseDict objectForKey:@"IsExisting"]boolValue];
//                                                                          if (isExisting) {
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
//                                                                                                           _mealNameText.text = @"";                        NSLog(@"Resolving UIAlertActionController for tapping cancel button");
//
//                                                                                                       }];
//                                                                              [alert addAction:cancel];
//                                                                              [alert addAction:ok];
//                                                                              [self presentViewController:alert animated:YES completion:nil];
//                                                                          }else{
//                                                                              //chayan 18/10/2017 -- method name changed
//                                                                              [self saveMealType:false pop:NO];
//                                                                          }
//
//                                                                      }
//                                                                      else{
//                                                                          [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
//                                                                          return;
//                                                                      }
//                                                                  }else{
//                                                                      [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
//                                                                  }
//                                                              });
//
//                                                          }];
//        [dataTask resume];
//
//    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
//    }
//}
#pragma mark -END

#pragma mark -IBAction
-(IBAction)mealTypeButtonPressed:(UIButton *)sender{
    isEditing = true;
    if (sender == _breakfastButton) {
        [self setBackgroundPink:_breakfastButton];
        _bCrossButton.selected = true;
    } else if(sender == _lunchButton){
        [self setBackgroundPink:_lunchButton];
        _lCrossButton.selected = true;
    } else if(sender == _dinnerButton){
        [self setBackgroundPink:_dinnerButton];
        _dCrossButton.selected = true;
    } else if(sender == _snackButton){
        [self setBackgroundPink:_snackButton];
        _sCrossButton.selected = true;
    }
    
    if (!_allCrossButton.isSelected) {
        [self setBackgroundWhite:_allButton];
        _allCrossButton.selected = false;
    }
    NSMutableDictionary *dict = myMeal;
    if (![Utility isEmptyCheck:dict]) {
        NSDictionary *mealDetails = dict[@"mealdetail"];
        if (![Utility isEmptyCheck:mealDetails]) {
            NSMutableDictionary *userMealFlagdetail = [dict[@"UserMealFlagdetail"] mutableCopy];
            if ([Utility isEmptyCheck:userMealFlagdetail]) {
                userMealFlagdetail = [[NSMutableDictionary alloc]init];
            }
            //            int k=(int)sender.tag;
            //            sender.selected = !sender.isSelected;
            int mtag = -1;
            if (sender == _breakfastButton) {
                [userMealFlagdetail setObject:[NSNumber numberWithBool:true] forKey:@"AvoidBreakfast"];
                mtag = 0;
            } else if(sender == _lunchButton){
                [userMealFlagdetail setObject:[NSNumber numberWithBool:true] forKey:@"AvoidLunch"];
                mtag = 1;
            } else if(sender == _dinnerButton){
                [userMealFlagdetail setObject:[NSNumber numberWithBool:true] forKey:@"AvoidDinner"];
                mtag = 2;
            } else if(sender == _snackButton){
                [userMealFlagdetail setObject:[NSNumber numberWithBool:true] forKey:@"AvoidSnack"];
                mtag = 3;
            }
            
            [userMealFlagdetail setObject:[NSNumber numberWithBool:false] forKey:@"AvoidAll"];
            [dict setObject:userMealFlagdetail forKey:@"UserMealFlagdetail"];
            myMeal = dict;
            //            [recipeList replaceObjectAtIndex:i withObject:dict];
            //            [table reloadData];
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            
            [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
            [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
            [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
            [mainDict setObject:[NSNumber numberWithInt:mtag+1] forKey:@"MealType"];
            [mainDict setObject:mealDetails[@"Id"] forKey:@"MealId"];
            [mainDict setObject:[NSNumber numberWithBool:!sender.isSelected] forKey:@"Avoid"];
            if (avoidAllArray.count >0) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"MealId == %@ AND MealType==%@",mealDetails[@"Id"],[NSNumber numberWithInt:mtag+1]];
                NSArray *filteredArray = [avoidAllArray filteredArrayUsingPredicate:predicate];
                if (filteredArray.count > 0) {
                    [avoidAllArray removeObject:filteredArray[0]];
                }
                [avoidAllArray addObject:mainDict];
            }else{
                [avoidAllArray addObject:mainDict];
            }
            if (avoidAllArray.count >0) {
                //                saveAll.hidden = false;
            }
        }
    }
}
-(void)setBackgroundPink:(UIButton *)button{
    [button setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
-(void)setBackgroundWhite:(UIButton *)button{
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
}
-(IBAction)mealCrossButtonPressed:(UIButton *)sender{
    isEditing = true;
    if (sender == _bCrossButton) {
        [self setBackgroundWhite:_breakfastButton];
        _bCrossButton.selected = false;
    } else if(sender == _lCrossButton){
        [self setBackgroundWhite:_lunchButton];
        _lCrossButton.selected = false;
    } else if(sender == _dCrossButton){
        [self setBackgroundWhite:_dinnerButton];
        _dCrossButton.selected = false;
    } else if(sender == _sCrossButton){
        [self setBackgroundWhite:_snackButton];
        _sCrossButton.selected = false;
    } else if(sender == _allCrossButton){
        [self setBackgroundWhite:_allButton];
        _allCrossButton.selected = false;
        
        [self setBackgroundWhite:_breakfastButton];
        _bCrossButton.selected = false;
        [self setBackgroundWhite:_lunchButton];
        _lCrossButton.selected = false;
        [self setBackgroundWhite:_dinnerButton];
        _dCrossButton.selected = false;
        [self setBackgroundWhite:_snackButton];
        _sCrossButton.selected = false;

        //
        NSMutableDictionary *dict = myMeal;
        if (![Utility isEmptyCheck:dict]) {
            NSMutableDictionary *mealDetails = [dict[@"mealdetail"] mutableCopy];
            if (![Utility isEmptyCheck:mealDetails]) {
                //            sender.selected = !sender.isSelected;
                //            CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:table];
                //            NSIndexPath *indexPath = [table indexPathForRowAtPoint:buttonPosition];
                //            RecipeListTableViewCell *cell = (RecipeListTableViewCell *)[table cellForRowAtIndexPath:indexPath];
                //            cell.breakfastButton.selected =!sender.selected;
                //            cell.lunchButton.selected =!sender.selected;
                //            cell.dinnerButton.selected =!sender.selected;
                //            cell.snackButton.selected =!sender.selected;
                NSMutableDictionary *userMealFlagdetail = [dict[@"UserMealFlagdetail"] mutableCopy];
                if ([Utility isEmptyCheck:userMealFlagdetail]) {
                    userMealFlagdetail = [[NSMutableDictionary alloc]init];
                }
                [userMealFlagdetail setObject:[NSNumber numberWithBool:false] forKey:@"AvoidBreakfast"];
                [userMealFlagdetail setObject:[NSNumber numberWithBool:false] forKey:@"AvoidDinner"];
                [userMealFlagdetail setObject:[NSNumber numberWithBool:false] forKey:@"AvoidLunch"];
                [userMealFlagdetail setObject:[NSNumber numberWithBool:false] forKey:@"AvoidSnack"];
                [userMealFlagdetail setObject:[NSNumber numberWithBool:false] forKey:@"AvoidAll"];
                [dict setObject:userMealFlagdetail forKey:@"UserMealFlagdetail"];
                myMeal = dict;
                //            [recipeList replaceObjectAtIndex:sender.tag withObject:dict];
                //            [table reloadData];
                
                for (int i=0; i<4; i++) {
                    NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
                    [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
                    [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
                    [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
                    [mainDict setObject:[NSNumber numberWithInt:i+1] forKey:@"MealType"];
                    [mainDict setObject:mealDetails[@"Id"] forKey:@"MealId"];
                    [mainDict setObject:[NSNumber numberWithBool:false] forKey:@"Avoid"];
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
                    //                saveAll.hidden = false;
                }
                
            }
        }
        return;
        //
    }
//    int i=[sender.accessibilityHint intValue];
    [self setBackgroundWhite:_allButton];
    _allCrossButton.selected = false;
    NSMutableDictionary *dict = myMeal;
    if (![Utility isEmptyCheck:dict]) {
        NSDictionary *mealDetails = dict[@"mealdetail"];
        if (![Utility isEmptyCheck:mealDetails]) {
            NSMutableDictionary *userMealFlagdetail = [dict[@"UserMealFlagdetail"] mutableCopy];
            if ([Utility isEmptyCheck:userMealFlagdetail]) {
                userMealFlagdetail = [[NSMutableDictionary alloc]init];
            }
//            int k=(int)sender.tag;
//            sender.selected = !sender.isSelected;
            int mtag = -1;
            if (sender == _bCrossButton) {
                [userMealFlagdetail setObject:[NSNumber numberWithBool:false] forKey:@"AvoidBreakfast"];
                mtag = 0;
            } else if(sender == _lCrossButton){
                [userMealFlagdetail setObject:[NSNumber numberWithBool:false] forKey:@"AvoidLunch"];
                mtag = 1;
            } else if(sender == _dCrossButton){
                [userMealFlagdetail setObject:[NSNumber numberWithBool:false] forKey:@"AvoidDinner"];
                mtag = 2;
            } else if(sender == _sCrossButton){
                [userMealFlagdetail setObject:[NSNumber numberWithBool:false] forKey:@"AvoidSnack"];
                mtag = 3;
            }
           
            [userMealFlagdetail setObject:[NSNumber numberWithBool:false] forKey:@"AvoidAll"];
            [dict setObject:userMealFlagdetail forKey:@"UserMealFlagdetail"];
            myMeal = dict;
//            [recipeList replaceObjectAtIndex:i withObject:dict];
//            [table reloadData];
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            
            [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
            [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
            [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
            [mainDict setObject:[NSNumber numberWithInt:mtag+1] forKey:@"MealType"];
            [mainDict setObject:mealDetails[@"Id"] forKey:@"MealId"];
            [mainDict setObject:[NSNumber numberWithBool:false] forKey:@"Avoid"];
            if (avoidAllArray.count >0) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"MealId == %@ AND MealType==%@",mealDetails[@"Id"],[NSNumber numberWithInt:mtag+1]];
                NSArray *filteredArray = [avoidAllArray filteredArrayUsingPredicate:predicate];
                if (filteredArray.count > 0) {
                    [avoidAllArray removeObject:filteredArray[0]];
                }
                [avoidAllArray addObject:mainDict];
            }else{
                [avoidAllArray addObject:mainDict];
            }
            if (avoidAllArray.count >0) {
//                saveAll.hidden = false;
            }
        }
    }
}

-(IBAction)avoidAllOrNotButtonPressed:(UIButton *)sender{
    isEditing = true;
    [self setBackgroundPink:_allButton];
    _allCrossButton.selected = true;
    
    [self setBackgroundPink:_breakfastButton];
    _bCrossButton.selected = true;
    [self setBackgroundPink:_lunchButton];
    _lCrossButton.selected = true;
    [self setBackgroundPink:_dinnerButton];
    _dCrossButton.selected = true;
    [self setBackgroundPink:_snackButton];
    _sCrossButton.selected = true;
    
    NSMutableDictionary *dict = myMeal;
    if (![Utility isEmptyCheck:dict]) {
        NSMutableDictionary *mealDetails = [dict[@"mealdetail"] mutableCopy];
        if (![Utility isEmptyCheck:mealDetails]) {
            
            NSMutableDictionary *userMealFlagdetail = [dict[@"UserMealFlagdetail"] mutableCopy];
            if ([Utility isEmptyCheck:userMealFlagdetail]) {
                userMealFlagdetail = [[NSMutableDictionary alloc]init];
            }
            [userMealFlagdetail setObject:[NSNumber numberWithBool:true] forKey:@"AvoidBreakfast"];
            [userMealFlagdetail setObject:[NSNumber numberWithBool:true] forKey:@"AvoidDinner"];
            [userMealFlagdetail setObject:[NSNumber numberWithBool:true] forKey:@"AvoidLunch"];
            [userMealFlagdetail setObject:[NSNumber numberWithBool:true] forKey:@"AvoidSnack"];
            [userMealFlagdetail setObject:[NSNumber numberWithBool:true] forKey:@"AvoidAll"];
            [dict setObject:userMealFlagdetail forKey:@"UserMealFlagdetail"];
            myMeal = dict;
//            [recipeList replaceObjectAtIndex:sender.tag withObject:dict];
//            [table reloadData];
            
            for (int i=0; i<4; i++) {
                NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
                [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
                [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
                [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
                [mainDict setObject:[NSNumber numberWithInt:i+1] forKey:@"MealType"];
                [mainDict setObject:mealDetails[@"Id"] forKey:@"MealId"];
                [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"Avoid"];
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
//                saveAll.hidden = false;
            }
            
        }
    }
}
-(IBAction)saveSettingButtonPressed:(UIButton *)sender{
    if (![Utility isEmptyCheck:avoidAllArray]) {
        [self save];
    }
//    if (_allCrossButton.isSelected) {
//        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsBreakfast"];
//        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsLunch"];
//        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsDinner"];
//        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsSnack"];
//        [mealData setObject:@"" forKey:@"PhotoSmallPath"];
//        [mealData setObject:@"" forKey:@"PhotoPath"];
//    }else{
////        [mealData setObject:[NSNumber numberWithBool:!_bCrossButton.isSelected] forKey:@"IsBreakfast"];
////        [mealData setObject:[NSNumber numberWithBool:!_lCrossButton.isSelected] forKey:@"IsLunch"];
////        [mealData setObject:[NSNumber numberWithBool:!_dCrossButton.isSelected] forKey:@"IsDinner"];
////        [mealData setObject:[NSNumber numberWithBool:!_sCrossButton.isSelected] forKey:@"IsSnack"];
//        [mealData setObject:@"" forKey:@"PhotoSmallPath"];
//        [mealData setObject:@"" forKey:@"PhotoPath"];
//    }
    
//    if (![Utility isEmptyCheck:_mealNameText.text]) {
//        if ([Utility isEmptyCheck:mealData[@"UserId"]]){
//            [self webservicecall_GetUserRecipeByName:false pop:NO];
//        }else{
//            [self saveMealType:false pop:NO];
//        }
//    } else {
//        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Meal name should not be empty" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//
//        }];
//        [controller addAction:okAction];
//        [self presentViewController:controller animated:YES completion:nil];
//    }
    
}
-(IBAction)cancelButtonPressed:(UIButton *)sender{
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            if ([delegate respondsToSelector:@selector(didCheckAnyChangeForMealSettings:)]) {
                [delegate didCheckAnyChangeForMealSettings:isChanged];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
-(IBAction)infoButtonPressed:(UIButton *)sender{
    MealSettingInfoPopUpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealSettingInfoPopUp"];
    
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];

}
-(void)updateView{
    int avoidCount = 0;
    NSDictionary *avoidFlagDict = myMeal[@"UserMealFlagdetail"];
    if ([avoidFlagDict[@"AvoidBreakfast"]boolValue]) {
        [self setBackgroundPink:_breakfastButton];
        _bCrossButton.selected = true;
        avoidCount++;
    }
    if ([avoidFlagDict[@"AvoidDinner"]boolValue]) {
        [self setBackgroundPink:_dinnerButton];
        _dCrossButton.selected = true;
        avoidCount++;
    }
    if ([avoidFlagDict[@"AvoidLunch"]boolValue]) {
        [self setBackgroundPink:_lunchButton];
        _lCrossButton.selected = true;
        avoidCount++;
    }
    if ([avoidFlagDict[@"AvoidSnack"]boolValue]) {
        [self setBackgroundPink:_snackButton];
        _sCrossButton.selected = true;
        avoidCount++;
    }
    if (avoidCount == 4) {
        [self setBackgroundPink:_allButton];
        _allCrossButton.selected = true;
    }
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
                                       if (![Utility isEmptyCheck:avoidAllArray]) {
                                           [self save];
                                       }
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
#pragma mark -END
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
                    GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
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
            if ([delegate respondsToSelector:@selector(didCheckAnyChangeForMealSettings:)]) {
                [delegate didCheckAnyChangeForMealSettings:isChanged];
            }
            [self.navigationController  popViewControllerAnimated:YES];
        }
    }];
}
#pragma mark -End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
