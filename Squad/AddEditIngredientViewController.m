//
//  AddEditIngredientViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 28/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AddEditIngredientViewController.h"
#import "MealAddViewController.h"

@interface AddEditIngredientViewController (){
    IBOutlet UILabel  *mealTypeLabel;
    IBOutlet UIScrollView  *mainScroll;
    IBOutlet UITextField  *ingredientName;
    IBOutlet UIButton  *ingredientUnit;
    IBOutlet UIButton  *ingredientCategory;
    
    
    IBOutlet UITextField  *ingredientProtein;
    IBOutlet UITextField  *ingredientFat;
    IBOutlet UITextField  *ingredientCarbs;
    IBOutlet UITextField  *ingredientAlcohol;

    IBOutlet UIButton *glutenFreeButton;
    IBOutlet UIButton *dairyFreeButton;
    IBOutlet UIButton *noRedMeatButton;
    IBOutlet UIButton *pescatarinButton;
    IBOutlet UIButton *vegetarianVeganButton;
    IBOutlet UIButton *noSeafoodButton;
    IBOutlet UIButton *fodmapFriendlyButton;
    IBOutlet UIButton *paleoFriendlyButton;
    IBOutlet UIButton *noEggsButton;
    IBOutlet UIButton *noNutsButton;
    IBOutlet UIButton *noLegumesButton;
    //shabbir
    IBOutlet UIButton *lactoOvoButton;
    IBOutlet UIButton *noChicken;
    
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *cancelButton;
    
    IBOutlet UIStepper *protien100Stepper;
    IBOutlet UIStepper *fat100Stepper;
    IBOutlet UIStepper *carbs100Stepper;
    IBOutlet UIStepper *alcohol100Stepper;
    
    IBOutlet UIButton *protien100MinusButton;
    IBOutlet UIButton *protien100PlusButton;
    IBOutlet UIButton *fat100MinusButton;
    IBOutlet UIButton *fat100PlusButton;
    IBOutlet UIButton *carbs100MinusButton;
    IBOutlet UIButton *carbs100PlusButton;
    IBOutlet UIButton *alcohol100MinusButton;
    IBOutlet UIButton *alcohol100PlusButton;
    
    UIView *contentView;
    int apiCount;
    NSArray *ingredientCategoryArray;
    NSArray *ingredientUnitArray;
    NSDictionary *ingredientDetails;
    NSDictionary *selectedIngredientUnit;
    NSDictionary *selectedIngredientCategory;
    NSNumberFormatter *numbeFormatter;
    UITextField *activeTextField;
    UIToolbar *toolBar;
    
    BOOL isEdited;  //ah ux
}

@end

@implementation AddEditIngredientViewController
@synthesize IngredientId,currentDate,isFromMealMatch;
- (void)viewDidLoad {
    [super viewDidLoad];
//    saveButton.layer.cornerRadius = 3.0f;
//    saveButton.clipsToBounds = YES;
//    cancelButton.layer.cornerRadius = 3.0f;
//    cancelButton.clipsToBounds = YES;
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, ingredientName.frame.size.height)];
    ingredientName.leftView = paddingView;
    ingredientName.leftViewMode = UITextFieldViewModeAlways;
    
    isEdited = NO;  //ah ux

    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [self registerForKeyboardNotifications];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getIngredientUnitApiCall];
        [self getIngredientCategoryListApiCall];
        if (self->IngredientId) {
            [self getIngredientDetailsApiCall];
        }
    });
    numbeFormatter = [[NSNumberFormatter alloc] init];
    [numbeFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numbeFormatter setMaximumFractionDigits:2];
    [numbeFormatter setRoundingMode: NSNumberFormatterRoundUp];
    
    
    //ah 19.5
    noLegumesButton.selected = true;
    glutenFreeButton.selected = true;
    vegetarianVeganButton.selected = true;
    pescatarinButton.selected = true;
    dairyFreeButton.selected = true;
    fodmapFriendlyButton.selected = true;
    noEggsButton.selected = true;
    paleoFriendlyButton.selected = true;
    noNutsButton.selected = true;
    noRedMeatButton.selected = true;
    noSeafoodButton.selected = true;
    lactoOvoButton.selected = true;
    noChicken.selected = true;
    
    [noLegumesButton setBackgroundColor:[UIColor colorWithRed:229/255.0f green:43/255.0f blue:163/255.0f alpha:1.0]];
    [glutenFreeButton setBackgroundColor:[UIColor colorWithRed:229/255.0f green:43/255.0f blue:163/255.0f alpha:1.0]];
    [vegetarianVeganButton setBackgroundColor:[UIColor colorWithRed:229/255.0f green:43/255.0f blue:163/255.0f alpha:1.0]];
    [pescatarinButton setBackgroundColor:[UIColor colorWithRed:229/255.0f green:43/255.0f blue:163/255.0f alpha:1.0]];
    [dairyFreeButton setBackgroundColor:[UIColor colorWithRed:229/255.0f green:43/255.0f blue:163/255.0f alpha:1.0]];
    [fodmapFriendlyButton setBackgroundColor:[UIColor colorWithRed:229/255.0f green:43/255.0f blue:163/255.0f alpha:1.0]];
    [noEggsButton setBackgroundColor:[UIColor colorWithRed:229/255.0f green:43/255.0f blue:163/255.0f alpha:1.0]];
    [paleoFriendlyButton setBackgroundColor:[UIColor colorWithRed:229/255.0f green:43/255.0f blue:163/255.0f alpha:1.0]];
    [noNutsButton setBackgroundColor:[UIColor colorWithRed:229/255.0f green:43/255.0f blue:163/255.0f alpha:1.0]];
    [noRedMeatButton setBackgroundColor:[UIColor colorWithRed:229/255.0f green:43/255.0f blue:163/255.0f alpha:1.0]];
    [noSeafoodButton setBackgroundColor:[UIColor colorWithRed:229/255.0f green:43/255.0f blue:163/255.0f alpha:1.0]];
    [lactoOvoButton setBackgroundColor:[UIColor colorWithRed:229/255.0f green:43/255.0f blue:163/255.0f alpha:1.0]];
    [noChicken setBackgroundColor:[UIColor colorWithRed:229/255.0f green:43/255.0f blue:163/255.0f alpha:1.0]];
    
    mealTypeLabel.text = _mealType;
}
#pragma -mark Private Methods
-(void)prepareView{
    if (![Utility isEmptyCheck:ingredientUnitArray] && ![Utility isEmptyCheck:ingredientCategoryArray] && ![Utility isEmptyCheck:ingredientDetails]) {
        if (ingredientUnitArray.count > 0) {
            selectedIngredientUnit =[Utility getDictByValue:ingredientUnitArray value:ingredientDetails[@"UnitMetric"] type:@"MetricUnitName"];
        }
        if (ingredientCategoryArray.count > 0) {
            selectedIngredientCategory =[Utility getDictByValue:ingredientCategoryArray value:ingredientDetails[@"IngredientCategoryId"] type:@"Id"];
        }
        if ([[defaults objectForKey:@"UnitPreference"] isEqualToNumber:@2]) {
            [ingredientUnit setTitle:selectedIngredientUnit[@"ImperialUnitName"] forState:UIControlStateNormal];
        }else{
            [ingredientUnit setTitle:selectedIngredientUnit[@"MetricUnitName"] forState:UIControlStateNormal];
        }
        [ingredientCategory setTitle:selectedIngredientCategory[@"Name"] forState:UIControlStateNormal];
        ingredientName.text = ![Utility isEmptyCheck:ingredientDetails[@"IngredientName"]] ? ingredientDetails[@"IngredientName"] : @"";
        ingredientProtein.text = ![Utility isEmptyCheck:ingredientDetails[@"ProteinPer100"]] ? [numbeFormatter stringFromNumber: ingredientDetails[@"ProteinPer100"]] : @"0.00";
        protien100Stepper.value = [numbeFormatter numberFromString:ingredientProtein.text].doubleValue;
        
        ingredientFat.text = ![Utility isEmptyCheck:ingredientDetails[@"FatPer100"]] ? [numbeFormatter stringFromNumber:ingredientDetails[@"FatPer100"]] : @"0.00";
        fat100Stepper.value = [numbeFormatter numberFromString:ingredientFat.text].doubleValue;
        
        ingredientCarbs.text = ![Utility isEmptyCheck:ingredientDetails[@"CarbsPer100"]] ? [numbeFormatter stringFromNumber:ingredientDetails[@"CarbsPer100"]] : @"0.00";
        carbs100Stepper.value = [numbeFormatter numberFromString:ingredientCarbs.text].doubleValue;
        
        ingredientAlcohol.text = ![Utility isEmptyCheck:ingredientDetails[@"AlcoholPer100"]] ? [numbeFormatter stringFromNumber:ingredientDetails[@"AlcoholPer100"]] : @"0.00";
        alcohol100Stepper.value = [numbeFormatter numberFromString:ingredientAlcohol.text].doubleValue;
        
        noLegumesButton.selected = [ingredientDetails[@"NoLegumes"] boolValue];
        glutenFreeButton.selected = [ingredientDetails[@"GlutenFree"] boolValue];
        vegetarianVeganButton.selected = [ingredientDetails[@"Vegan"] boolValue];
        pescatarinButton.selected = [ingredientDetails[@"Pescatarian"] boolValue];
        dairyFreeButton.selected = [ingredientDetails[@"DairyFree"] boolValue];
        fodmapFriendlyButton.selected = [ingredientDetails[@"Fodmap"] boolValue];
        noEggsButton.selected = [ingredientDetails[@"NoEggs"] boolValue];
        paleoFriendlyButton.selected = [ingredientDetails[@"PaleoFriendly"] boolValue];
        noNutsButton.selected = [ingredientDetails[@"NoNuts"] boolValue];
        noRedMeatButton.selected = [ingredientDetails[@"NoRedMeat"] boolValue];
        noSeafoodButton.selected = [ingredientDetails[@"NoSeaFood"] boolValue];
        lactoOvoButton.selected = [ingredientDetails[@"Vegetarian"] boolValue];
        noChicken.selected = [ingredientDetails[@"NoChicken"] boolValue];
        
        [self toggleBackgroungColor:noLegumesButton];
        [self toggleBackgroungColor:glutenFreeButton];
        [self toggleBackgroungColor:vegetarianVeganButton];
        [self toggleBackgroungColor:pescatarinButton];
        [self toggleBackgroungColor:dairyFreeButton];
        [self toggleBackgroungColor:fodmapFriendlyButton];
        [self toggleBackgroungColor:noEggsButton];
        [self toggleBackgroungColor:paleoFriendlyButton];
        [self toggleBackgroungColor:noNutsButton];
        [self toggleBackgroungColor:noRedMeatButton];
        [self toggleBackgroungColor:noSeafoodButton];
        [self toggleBackgroungColor:lactoOvoButton];
        [self toggleBackgroungColor:noChicken];
        
        //"Vegetarian": true,
        //"NoChicken": true,
        //"SourceOrDressing": true,

    }
 }
-(void)getIngredientUnitApiCall{
    
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
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
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetIngredientUnitApiCall" append:@"" forAction:@"POST"];
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
                                                                             if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"IngredientUnitList"]]) {
                                                                                 ingredientUnitArray = [responseDictionary objectForKey:@"IngredientUnitList"];
                                                                                 
                                                                                 if (apiCount==0) {
                                                                                     [self prepareView];
                                                                                 }
                                                                             }else{
                                                                                 [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                                                                                 return;
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
-(void)getIngredientCategoryListApiCall{
    
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
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
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetIngredientCategoryListApiCall" append:@"" forAction:@"POST"];
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
                                                                             if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"IngredientCategoryList"]]) {
                                                                                 ingredientCategoryArray = [responseDictionary objectForKey:@"IngredientCategoryList"];
                                                                                 
                                                                                 if (apiCount==0) {
                                                                                     [self prepareView];
                                                                                 }
                                                                             }else{
                                                                                 [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                                                                                 return;
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

-(void)getIngredientDetailsApiCall{

    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:IngredientId forKey:@"IngredientId"];

        
        
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
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetIngredientDetailsApiCall" append:@"" forAction:@"POST"];
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
                                                                             if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"IngredientDetail"]]) {
                                                                                 ingredientDetails = [responseDictionary objectForKey:@"IngredientDetail"];
                                                                                 if (apiCount==0) {
                                                                                     [self prepareView];
                                                                                 }
                                                                             }else{
                                                                                 [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                                                                                 return;
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

-(void)saveIngredients{
    
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        NSMutableDictionary *ingredientSaveDataDict;
        if (IngredientId) {
            ingredientSaveDataDict = [[NSMutableDictionary alloc]initWithDictionary:ingredientDetails];
        }else{
            ingredientSaveDataDict = [[NSMutableDictionary alloc]init];
            [ingredientSaveDataDict setObject:@0 forKey:@"IngredientId"];
        }
        [ingredientSaveDataDict setObject:[NSNumber numberWithBool:true] forKey:@"AllowSubmit"];
        if (ingredientName.text.length > 0) {
            [ingredientSaveDataDict setObject:ingredientName.text forKey:@"IngredientName"];
        }else{
            [Utility msg:@"Ingredient Name cannot be blank." title:@"Warning" controller:self haveToPop:NO];
            return;
        }
        [ingredientSaveDataDict setObject:[NSNumber numberWithBool:noLegumesButton.isSelected] forKey:@"NoLegumes"];
        [ingredientSaveDataDict setObject:[NSNumber numberWithBool:glutenFreeButton.isSelected] forKey:@"GlutenFree"];
        [ingredientSaveDataDict setObject:[NSNumber numberWithBool:vegetarianVeganButton.isSelected] forKey:@"Vegan"];
        [ingredientSaveDataDict setObject:[NSNumber numberWithBool:pescatarinButton.isSelected] forKey:@"Pescatarian"];
        [ingredientSaveDataDict setObject:[NSNumber numberWithBool:dairyFreeButton.isSelected] forKey:@"DairyFree"];
        [ingredientSaveDataDict setObject:[NSNumber numberWithBool:fodmapFriendlyButton.isSelected] forKey:@"Fodmap"];
        [ingredientSaveDataDict setObject:[NSNumber numberWithBool:noEggsButton.isSelected] forKey:@"NoEggs"];
        [ingredientSaveDataDict setObject:[NSNumber numberWithBool:paleoFriendlyButton.isSelected] forKey:@"PaleoFriendly"];
        [ingredientSaveDataDict setObject:[NSNumber numberWithBool:noNutsButton.isSelected] forKey:@"NoNuts"];
        [ingredientSaveDataDict setObject:[NSNumber numberWithBool:noRedMeatButton.isSelected] forKey:@"NoRedMeat"];
        [ingredientSaveDataDict setObject:[NSNumber numberWithBool:noSeafoodButton.isSelected] forKey:@"NoSeaFood"];
        [ingredientSaveDataDict setObject:[NSNumber numberWithBool:lactoOvoButton.isSelected] forKey:@"Vegetarian"];    //sahbbir
        [ingredientSaveDataDict setObject:[NSNumber numberWithBool:noChicken.isSelected] forKey:@"NoChicken"];
        
        if (![Utility isEmptyCheck:ingredientProtein.text]) {
            if (![Utility isEmptyCheck:[numbeFormatter numberFromString:ingredientProtein.text]]) {
                [ingredientSaveDataDict setObject:[numbeFormatter numberFromString:ingredientProtein.text] forKey:@"ProteinPer100"];
            }else{
                [Utility msg:@"Please enter valid Protein grams/mls per 100g." title:@"Warning !" controller:self haveToPop:NO];
                return;
            }
        }else{
            [ingredientSaveDataDict setObject:[NSNumber numberWithInt:0] forKey:@"ProteinPer100"];
        }
        
        if (![Utility isEmptyCheck:ingredientFat.text]) {
            if (![Utility isEmptyCheck:[numbeFormatter numberFromString:ingredientFat.text]]) {
                [ingredientSaveDataDict setObject:[numbeFormatter numberFromString:ingredientFat.text] forKey:@"FatPer100"];
            }else{
                [Utility msg:@"Please enter valid Fat grams/mls per 100g." title:@"Warning !" controller:self haveToPop:NO];
                return;
            }
        }else{
            [ingredientSaveDataDict setObject:[NSNumber numberWithInt:0] forKey:@"FatPer100"];
        }
        if (![Utility isEmptyCheck:ingredientCarbs.text]) {
            if (![Utility isEmptyCheck:[numbeFormatter numberFromString:ingredientCarbs.text]]) {
                [ingredientSaveDataDict setObject:[numbeFormatter numberFromString:ingredientCarbs.text] forKey:@"CarbsPer100"];
            }else{
                [Utility msg:@"Please enter valid Carbs grams/mls per 100g." title:@"Warning !" controller:self haveToPop:NO];
                return;
            }
        }else{
            [ingredientSaveDataDict setObject:[NSNumber numberWithInt:0] forKey:@"CarbsPer100"];
        }
        if (![Utility isEmptyCheck:ingredientAlcohol.text]) {
            if (![Utility isEmptyCheck:[numbeFormatter numberFromString:ingredientAlcohol.text]]) {
                [ingredientSaveDataDict setObject:[numbeFormatter numberFromString:ingredientAlcohol.text] forKey:@"AlcoholPer100"];
            }else{
                [Utility msg:@"Please enter valid Alcohol grams/mls per 100g." title:@"Warning !" controller:self haveToPop:NO];
                return;
            }
        }else{
            [ingredientSaveDataDict setObject:[NSNumber numberWithInt:0] forKey:@"AlcoholPer100"];
        }
        
        
        double total = ingredientProtein.text.doubleValue + ingredientCarbs.text.doubleValue + ingredientFat.text.doubleValue + ingredientAlcohol.text.doubleValue;
        if (total > 100){
            [Utility msg:@"Please check your ingredient totals per 100g/ml. They should always less or equal 100" title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
        if (![Utility isEmptyCheck:selectedIngredientCategory]) {
            [ingredientSaveDataDict setObject:selectedIngredientCategory[@"Id"] forKey:@"IngredientCategoryId"];
        }else{
            [Utility msg:@"Please select Category" title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
        if (![Utility isEmptyCheck:selectedIngredientUnit]) {
            [ingredientSaveDataDict setObject:selectedIngredientUnit[@"MetricUnitName"] forKey:@"UnitMetric"];
            [ingredientSaveDataDict setObject:selectedIngredientUnit[@"ImperialUnitName"] forKey:@"UnitImperial"];
        }else{
            [Utility msg:@"Please select Unit" title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
        [mainDict setObject:ingredientSaveDataDict forKey:@"IngredientDetails"];
        
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
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddIngredientApiCall" append:@"" forAction:@"POST"];
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
                                                                             isEdited = NO;
                                                                         } else{
                                                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup_nourish

                                                                             if(self->isFromMealMatch){
                                                                                 [self getIngredientList:2 mealName:nil isStatic:true ingredientId:[responseDictionary[@"Id"] intValue]];
                                                                             }else{
                                                                                 if (self->_delegate && [self->_delegate respondsToSelector:@selector(didCheckAnyChangeIngredient:)]) {
                                                                                     [self->_delegate didCheckAnyChangeIngredient:true];
                                                                                 }
                                                                                [Utility msg:@"Ingredient saved Successfully." title:@"Success" controller:self haveToPop:YES];
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

-(void)getIngredientList:(int)mealTypeData mealName:(NSDictionary *)mealdetails isStatic:(BOOL)isStatic ingredientId:(int)ingredientId{
    
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:mealTypeData] forKey:@"IngredientFilter"];
        
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
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetIngredientsApiCall" append:@""forAction:@"POST"];
        
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
                                                                         NSLog(@"%@",responseDict);
                                                                         
                                                                         
                                                                         MealAddViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MealAddView"];
                                                                         controller.currentDate = currentDate;
                                                                         controller.MealId = ingredientId;
                                                                         controller.isAdd = true;
                                                                         controller.isStatic = isStatic;
                                                                         controller.isStaticIngredient = true;
                                                                         controller.mealTypeData = mealTypeData;
                                                                         controller.mealDetails = mealdetails;
                                                                         controller.mealListArray = [[responseDict objectForKey:@"Ingredients"] mutableCopy];
                                                                         [self.navigationController pushViewController:controller animated:true];
                                                                         
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

- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {    //ah ux0
    if (isEdited) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Save Changes"
                                              message:@"Your changes will be lost if you don’t save them."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Save"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self saveIngredients];
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
#pragma -mark End

#pragma -mark IBAction
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
-(void)toggleBackgroungColor:(UIButton*)sender{
    if (sender.isSelected) {
        [sender setBackgroundColor:[UIColor colorWithRed:229/255.0f green:43/255.0f blue:163/255.0f alpha:1.0]];
    } else {
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
}
-(IBAction)checkUncheckButtonPressed:(UIButton*)sender{
    isEdited = YES;
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        [sender setBackgroundColor:[UIColor colorWithRed:229/255.0f green:43/255.0f blue:163/255.0f alpha:1.0]];
    } else {
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
}
- (IBAction)stepperValueChange:(UIStepper *)sender {
    isEdited = YES;
    if ([sender isEqual:protien100Stepper]) {
        ingredientProtein.text = [numbeFormatter stringFromNumber:[NSNumber numberWithDouble:sender.value ]];
    }else if ([sender isEqual:fat100Stepper]) {
        ingredientFat.text = [numbeFormatter stringFromNumber:[NSNumber numberWithDouble:sender.value ]];
    }else if ([sender isEqual:carbs100Stepper]) {
        ingredientCarbs.text = [numbeFormatter stringFromNumber:[NSNumber numberWithDouble:sender.value ]];
    }else if ([sender isEqual:alcohol100Stepper]) {
        ingredientAlcohol.text = [numbeFormatter stringFromNumber:[NSNumber numberWithDouble:sender.value ]];
    }
}
- (IBAction)minusPlusButtonPressed:(UIButton *)sender {
    isEdited = YES;
    
    if ([sender isEqual:protien100MinusButton]) {
        if (ingredientProtein.text.doubleValue >= 0.01) {
            ingredientProtein.text = [numbeFormatter stringFromNumber:[NSNumber numberWithDouble:[ingredientProtein.text doubleValue] - 0.01 ]];
        }
    }else if ([sender isEqual:protien100PlusButton]) {
        ingredientProtein.text = [numbeFormatter stringFromNumber:[NSNumber numberWithDouble:[ingredientProtein.text doubleValue] + 0.01 ]];
    }else if ([sender isEqual:fat100MinusButton]) {
        if (ingredientFat.text.doubleValue >= 0.01) {
            ingredientFat.text = [numbeFormatter stringFromNumber:[NSNumber numberWithDouble:[ingredientFat.text doubleValue] - 0.01 ]];
        }
    }else if ([sender isEqual:fat100PlusButton]) {
        ingredientFat.text = [numbeFormatter stringFromNumber:[NSNumber numberWithDouble:[ingredientFat.text doubleValue] + 0.01 ]];
    }else if ([sender isEqual:carbs100MinusButton]) {
        if (ingredientCarbs.text.doubleValue >= 0.01) {
            ingredientCarbs.text = [numbeFormatter stringFromNumber:[NSNumber numberWithDouble:[ingredientCarbs.text doubleValue] - 0.01 ]];
        }
    }else if ([sender isEqual:carbs100PlusButton]) {
        ingredientCarbs.text = [numbeFormatter stringFromNumber:[NSNumber numberWithDouble:[ingredientCarbs.text doubleValue] + 0.01 ]];
    }else if ([sender isEqual:alcohol100MinusButton]) {
        if (ingredientAlcohol.text.doubleValue >= 0.01) {
            ingredientAlcohol.text = [numbeFormatter stringFromNumber:[NSNumber numberWithDouble:[ingredientAlcohol.text doubleValue] - 0.01 ]];
        }
    }else if ([sender isEqual:alcohol100PlusButton]) {
        ingredientAlcohol.text = [numbeFormatter stringFromNumber:[NSNumber numberWithDouble:[ingredientAlcohol.text doubleValue] + 0.01 ]];
    }
}
- (IBAction)ingredientUnitButtonPressed:(UIButton *)sender {
    isEdited = YES;
    [self.view endEditing:true];
    if(ingredientUnitArray.count >0){
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = ingredientUnitArray;
        if ([[defaults objectForKey:@"UnitPreference"] isEqualToNumber:@2]) {
            controller.mainKey = @"ImperialUnitName";
        }else{
            controller.mainKey = @"MetricUnitName";
        }
        controller.apiType = @"IngredientUnit";
        if (![Utility isEmptyCheck:selectedIngredientUnit]) {
            controller.selectedIndex = (int)[ingredientUnitArray indexOfObject:selectedIngredientUnit];

        }else{
            controller.selectedIndex =-1;
        }
        controller.shouldScrollToIndexpath = true;
        controller.sender = sender;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}
- (IBAction)ingredientCategoryButtonPressed:(UIButton *)sender {
    isEdited = YES;
    [self.view endEditing:true];
    if(ingredientCategoryArray.count >0){
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = ingredientCategoryArray;
        controller.mainKey = @"Name";
        controller.apiType = @"IngredientCategory";
        if (![Utility isEmptyCheck:selectedIngredientCategory]) {
            controller.selectedIndex = (int)[ingredientCategoryArray indexOfObject:selectedIngredientCategory];
            
        }else{
            controller.selectedIndex =-1;
        }
        controller.shouldScrollToIndexpath = true;
        controller.sender = sender;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}
- (IBAction)cancelButtonPressed:(UIButton *)sender {
   [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
       if (shouldPop) {
           [self.navigationController popViewControllerAnimated:YES];
       }
   }];
}
- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    [self saveIngredients];
    
    /*[self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self saveIngredients];
        }
    }];*/
}
- (IBAction)logoTapped:(UIButton *)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.navigationController popToRootViewControllerAnimated:YES];
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
- (IBAction)back:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
#pragma -mark End
#pragma -mark DropdownDelegate
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData sender:(UIButton *)sender{
    if ([type caseInsensitiveCompare:@"IngredientUnit"] == NSOrderedSame) {
        selectedIngredientUnit = selectedData;
        if ([[defaults objectForKey:@"UnitPreference"] isEqualToNumber:@2]) {
            [sender setTitle:selectedIngredientUnit[@"ImperialUnitName"] forState:UIControlStateNormal];
        }else{
            [sender setTitle:selectedIngredientUnit[@"MetricUnitName"] forState:UIControlStateNormal];
        }
    }else if ([type caseInsensitiveCompare:@"IngredientCategory"] == NSOrderedSame) {
        selectedIngredientCategory = selectedData;
        [sender setTitle:selectedIngredientCategory[@"Name"] forState:UIControlStateNormal];
    }
}
#pragma -mark End
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
        CGRect frame = [mainScroll convertRect:activeTextField.frame fromView:activeTextField.superview];
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
    isEdited = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    if ([textField isEqual:ingredientProtein]) {
        if (![Utility isEmptyCheck:textField.text]) {
            if (![Utility isEmptyCheck:[formatter numberFromString:textField.text]]) {
                if ([formatter numberFromString:textField.text].doubleValue <= 100) {
                    protien100Stepper.value = [formatter numberFromString:textField.text].doubleValue;
                }else{
                    [Utility msg:@"Please check your ingredient totals per 100g/ml. They should always less or equal 100" title:@"Warning !" controller:self haveToPop:NO];
                    return;
                }
            }else{
                [Utility msg:@"Please enter valid Protein grams/mls per 100g." title:@"Warning !" controller:self haveToPop:NO];
                return;
            }
        }else{
            [Utility msg:@"Protein grams/mls per 100g Name cannot be blank." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
    }else if ([textField isEqual:ingredientFat]) {
        if (![Utility isEmptyCheck:textField.text]) {
            if (![Utility isEmptyCheck:[formatter numberFromString:textField.text]]) {
                if ([formatter numberFromString:textField.text].doubleValue <= 100) {
                    fat100Stepper.value = [formatter numberFromString:textField.text].doubleValue;
                }else{
                    [Utility msg:@"Please check your ingredient totals per 100g/ml. They should always less or equal 100" title:@"Warning !" controller:self haveToPop:NO];
                    return;
                }
            }else{
                [Utility msg:@"Please enter valid Fat grams/mls per 100g." title:@"Warning !" controller:self haveToPop:NO];
                return;
            }
        }else{
            [Utility msg:@"Fat grams/mls per 100g Name cannot be blank." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
    }else if ([textField isEqual:ingredientCarbs]) {
        if (![Utility isEmptyCheck:textField.text]) {
            if (![Utility isEmptyCheck:[formatter numberFromString:textField.text]]) {
                if ([formatter numberFromString:textField.text].doubleValue <= 100) {
                    carbs100Stepper.value = [formatter numberFromString:textField.text].doubleValue;
                }else{
                    [Utility msg:@"Please check your ingredient totals per 100g/ml. They should always less or equal 100" title:@"Warning !" controller:self haveToPop:NO];
                    return;
                }
            }else{
                [Utility msg:@"Please enter valid Carbs grams/mls per 100g." title:@"Warning !" controller:self haveToPop:NO];
                return;
            }
        }else{
            [Utility msg:@"Carbs grams/mls per 100g Name cannot be blank." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
    }else if ([textField isEqual:ingredientAlcohol]) {
        if (![Utility isEmptyCheck:textField.text]) {
            if (![Utility isEmptyCheck:[formatter numberFromString:textField.text]]) {
                if ([formatter numberFromString:textField.text].doubleValue <= 100) {
                    alcohol100Stepper.value = [formatter numberFromString:textField.text].doubleValue;
                }else{
                    [Utility msg:@"Please check your ingredient totals per 100g/ml. They should always less or equal 100" title:@"Warning !" controller:self haveToPop:NO];
                    return;
                }
            }else{
                [Utility msg:@"Please enter valid Alcohol grams/mls per 100g." title:@"Warning !" controller:self haveToPop:NO];
                return;
            }
        }else{
            [Utility msg:@"Alcohol grams/mls per 100g Name cannot be blank." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
    }
}
#pragma mark - End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
