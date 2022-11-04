//
//  DailyGoodnessDetailViewController.m
//  Squad
//
//  Created by MAC 6- AQB SOLUTIONS on 15/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "DailyGoodnessDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <math.h>
#import "ingredientsView.h"
#import "Methods.h"
#import "AddEditCustomNutritionViewController.h"

@interface DailyGoodnessDetailViewController (){
   
    IBOutlet UILabel *goodnessName;
    IBOutlet UILabel *goodnessDate;
    IBOutlet UILabel *servesLabel;
    IBOutlet UIButton *minutesPrepButton;
    IBOutlet UIButton *caloriesButton;
    IBOutlet UILabel *caloriesLabel;
    IBOutlet UIImageView *caloriesIcon;     //shabbir
    
    IBOutlet UILabel *mealInfo;
    IBOutlet UIImageView *dataImage;
    IBOutlet UILabel *energyLabel;
    IBOutlet UILabel *proteinUnitLabel;
    IBOutlet UILabel *proteinLabel;
    IBOutlet UILabel *carbTotalLabel;
    IBOutlet UILabel *fatTotalLabel;
    IBOutlet UILabel *energy1Label;
    IBOutlet UILabel *proteinPercentageLabel;
    IBOutlet UILabel *proteinGramLabel;
    IBOutlet UILabel *proteinCalsLabel;
    IBOutlet UILabel *carbPercentageLabel;
    IBOutlet UILabel *carbGramLabel;
    IBOutlet UILabel *carbUnitLabel;
    IBOutlet UILabel *carbCalsLabel;
    IBOutlet UILabel *fatPercentageLabel;
    IBOutlet UILabel *fatUnitLabel;
    IBOutlet UILabel *fatGramLabel;
    IBOutlet UILabel *fatCalsLabel;
    IBOutlet UILabel *dieatInfoLabel;
    
    IBOutlet UIStackView *ingredientsStackView;
    IBOutlet UIStackView *methodStackView;
    IBOutlet UIButton *serveButton;
    
    //shabbir 11/01
    IBOutlet UIButton *editMealButton;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *mealInfoView;
    
    IBOutlet NSLayoutConstraint *imageViewHeightConstraint;     //ah ux(storyboard)
    
    UIView *contentView;
    NSDictionary *mealDetailsDictionary;
    NSDictionary *unit;
    int apiCount;
    NSArray *unitPreferenceArray;
    NSDictionary *selectedServe;
    
    IBOutlet UIView *energyContainer;
    IBOutlet UIView *protineContainer;
    IBOutlet UIView *carbsContainer;
    IBOutlet UIView *fatContainer;
    BOOL isChanged;
    BOOL isFirstTime;
    __weak IBOutlet UIView *tabContainer;
}

@end

@implementation DailyGoodnessDetailViewController
@synthesize mealId,dateString,mealSessionId,delegate;
#pragma -mark ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    unit = @{
            @"0" : @"ALL",
            @"1" : @"METRIC",
            @"2" :  @"IMPERIAL"
            };
    apiCount = 0;
    //shabbir 11/01
    editMealButton.layer.borderWidth = 1.0f;
    editMealButton.layer.borderColor = [UIColor colorWithRed:235.0 / 255.0 green:92.0 / 255.0 blue:182.0 / 255.0 alpha:1.0].CGColor;    //#EB5CB6
    serveButton.layer.borderWidth = 1.0f;
    serveButton.layer.borderColor = [UIColor colorWithRed:235.0 / 255.0 green:92.0 / 255.0 blue:182.0 / 255.0 alpha:1.0].CGColor;    //#EB5CB6
    isChanged = YES;
    isFirstTime = YES;
    tabContainer.hidden = !_showTab;
    
    [self addMealViewPoints];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];
    
    if (!isChanged) {
        return;
    }
    if(isFirstTime){
        isFirstTime = NO;
        isChanged = NO;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getUnitPreference];
//        if ([_fromController isEqualToString:@"Food Prep"]) {
//            if ([mealSessionId isEqualToNumber:@0]) {
//                [self getMealDetailsBySize];
//            } else {
//                [self squadGetMealSessionDetail];
//            }
//        }
    });
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
}
#pragma -mark End
#pragma -mark IBAction
-(IBAction)serveDropdownButtonPressed:(id)sender{
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = serveArray;
    controller.mainKey = @"value";
    controller.apiType = @"Serve";
    if (![Utility isEmptyCheck:selectedServe]) {
        controller.selectedIndex = (int)[serveArray indexOfObject:selectedServe];
    }else{
        controller.selectedIndex = -1;
    }
    controller.delegate = self;
    controller.sender = sender;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)editButtonPressed:(id)sender{
    
    NSArray *controllers = [self.navigationController viewControllers];
    if (controllers.count>2) {
        if([[controllers objectAtIndex:controllers.count-2] isKindOfClass:[AddEditCustomNutritionViewController class]]){
            [self.navigationController popToViewController:(AddEditCustomNutritionViewController *)[controllers objectAtIndex:controllers.count-2] animated:YES];
            return;
        }
    }
    AddEditCustomNutritionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddEditCustomNutrition"];
    controller.MealType = _MealType;
    controller.isFromMealMatch = _isFromMealMatch;
    controller.fromMealView = true;
    controller.delegate =self;
    controller.mealId = mealId;
    controller.mealSessionId = mealSessionId;
    controller.dateString = dateString;
    controller.fromController = _fromController;
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
- (IBAction)imageButtonTapped:(UIButton *)sender {
    if ([Utility compareImage:dataImage.image isEqualTo:[UIImage imageNamed:@"image_loading.png"]]) {     //ah 26.5
        [Utility msg:@"No image available!" title:@"Oops!" controller:self haveToPop:NO];
    } else {
        ShowImageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShowImage"];
        controller.goodnessName = goodnessName.text;
        controller.goodnessDate = goodnessDate.text;
        controller.image = dataImage.image;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}
#pragma mark - End

#pragma -mark APICall
-(void)prepareView{
    NSDictionary *mealData = [mealDetailsDictionary objectForKey:@"MealData"];
    if (![Utility isEmptyCheck:mealData]) {
        [methodStackView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];    //ah 16.5
        [ingredientsStackView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];    //ah 16.5
        
        goodnessName.text = ![Utility isEmptyCheck:[mealData objectForKey:@"MealName"]] ? [mealData objectForKey:@"MealName"] : @"";
        goodnessDate.text = ![Utility isEmptyCheck:dateString] ? dateString : @"";
        float totalCals = ![Utility isEmptyCheck:[mealData objectForKey:@"CalsTotal"]] ? [[mealData objectForKey:@"CalsTotal"] floatValue] :0.0f;
        if (![Utility isEmptyCheck:mealData[@"MealClassifiedID"]] && [mealData[@"MealClassifiedID"] intValue] == 2) {
            energyContainer.hidden = true;
            protineContainer.hidden = true;
            carbsContainer.hidden = true;
            fatContainer.hidden = true;
            [caloriesButton setTitle:@"" forState:UIControlStateNormal];
            caloriesLabel.text = @""; //@"NO MEASURE"
//            [caloriesButton setImage:[UIImage imageNamed:@"no-measure-meal.png"] forState:UIControlStateNormal];
            [caloriesButton setImage:nil forState:UIControlStateNormal];
            caloriesIcon.hidden = false;

            mealInfo.text = @"\u2022  This is an Ashy Bines ‘No Measure’ meal.\n\u2022  A simple, tasty and clean meal designed so that even the least confident cook can make it without having to measure, weight or count a thing.\n\u2022  Creating healthy meals that get you results has never been easier.";
            mealInfo.font = [UIFont fontWithName:@"Oswald-Extra-LightItalic" size:17];    //shabbir
            mealInfo.textAlignment = NSTextAlignmentLeft;
        }else{
            energyContainer.hidden = false;
            protineContainer.hidden = false;
            carbsContainer.hidden = false;
            fatContainer.hidden = false;
            [caloriesButton setTitle:[@"" stringByAppendingFormat:@"%ld",lroundf(totalCals) ] forState:UIControlStateNormal];
            caloriesLabel.text = @"CAL";    //shabbir
            [caloriesButton setImage:nil forState:UIControlStateNormal];
            caloriesIcon.hidden = true;
            mealInfo.text = @"Please note that this meal size and nutrition info has been adjusted to meet your calorie requirements";
            mealInfo.font = [UIFont fontWithName:@"Oswald-Extra-LightItalic" size:17];    //shabbir
            mealInfo.textAlignment = NSTextAlignmentCenter;
        }
//        [minutesPrepButton setTitle: ![Utility isEmptyCheck:[mealData objectForKey:@"PreparationMinutes"]] ? [@"" stringByAppendingFormat:@"%@",[mealData objectForKey:@"PreparationMinutes"]] : @"0" forState:UIControlStateNormal];
        int prepMins = [mealData[@"PreparationMinutes"] intValue]*60;
        
        [minutesPrepButton setTitle:[NSString stringWithFormat:@"%@",prepMins>0 ? [Utility formatTimeFromSeconds:prepMins] : @"0 MIN"] forState:UIControlStateNormal];
        
        if ([Utility isEmptyCheck:selectedServe]) {
            if (![Utility isEmptyCheck:[mealData objectForKey:@"Serves"]]) {
                selectedServe = [Utility getDictByValue:serveArray value:mealData[@"Serves"] type:@"key"];
            }else{
                selectedServe = serveArray[0];
            }
        }
        servesLabel.text=[@"" stringByAppendingFormat:@"%@",selectedServe[@"key"]];

        [serveButton setTitle:[selectedServe[@"value"]capitalizedString] forState:UIControlStateNormal];
        
        NSString *imageString=![Utility isEmptyCheck:[mealData objectForKey:@"PhotoPath"]] ? [@"" stringByAppendingFormat:@"%@",[mealData objectForKey:@"PhotoPath"]] : @"" ;
        
        if (![Utility isEmptyCheck:imageString]) {      //ah ux
            [dataImage sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"new_image_loading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                if (image) {
                    CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                    imageViewHeightConstraint.constant = imageViewHeight;
                }
            }];
        } else {
            dataImage.image = [UIImage imageNamed:@"image_loading.png"];
        }
        
        energyLabel.text=[@"" stringByAppendingFormat:@"%ldcal (%.0fkj)",lroundf(totalCals),lroundf(totalCals)*4.184]; //4.184 to covert caliry to kilojule
        energy1Label.text=[@"" stringByAppendingFormat:@"%ldcal (%.0fkj)",lroundf(totalCals),lroundf(totalCals)*4.184]; //4.184 to covert caliry to kilojule
        
        //Protein
        
//        proteinLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"Protein"]] ? [@"" stringByAppendingFormat:@"%.2f",[[mealData objectForKey:@"Protein"] floatValue]] : @"" ;
//        if ([[defaults objectForKey:@"UnitPreference"] intValue] == 2) {
//            proteinUnitLabel.text = @"- oz";
//            proteinLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"ProteinOz"]] ? [@"" stringByAppendingFormat:@"%.2foz",[[mealData objectForKey:@"ProteinOz"] floatValue]] : @"" ;
//
//            proteinGramLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"ProteinOz"]] ? [@"" stringByAppendingFormat:@"%.2foz",[[mealData objectForKey:@"ProteinOz"] floatValue]] : @"" ;
//        }else{
            proteinUnitLabel.text = @"- gram";
            proteinLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"Protein"]] ? [@"" stringByAppendingFormat:@"%.2fg",[[mealData objectForKey:@"Protein"] floatValue]] : @"" ;
            
            proteinGramLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"Protein"]] ? [@"" stringByAppendingFormat:@"%.2fg",[[mealData objectForKey:@"Protein"] floatValue]] : @"" ;
//        }
        proteinPercentageLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"ProteinPercentage"]] ? [@"" stringByAppendingFormat:@"%.0f%%",[[mealData objectForKey:@"ProteinPercentage"] floatValue]] : @"" ;
        
        proteinCalsLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"ProtCals"]] ? [@"" stringByAppendingFormat:@"%.2f",[[mealData objectForKey:@"ProtCals"] floatValue]] : @"" ;
        
        //End
        //Carbs
//        if ([[defaults objectForKey:@"UnitPreference"] intValue] == 2){
//            carbUnitLabel.text = @"- oz";
//            carbTotalLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"Carbohydrates"]] ? [@"" stringByAppendingFormat:@"%.2foz",[[mealData objectForKey:@"CarbohydratesOz"] floatValue]] : @"" ;
//            carbGramLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"Carbohydrates"]] ? [@"" stringByAppendingFormat:@"%.2foz",[[mealData objectForKey:@"CarbohydratesOz"] floatValue]] : @"" ;
//
//        }else{
            carbUnitLabel.text = @"- gram";
            carbTotalLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"Carbohydrates"]] ? [@"" stringByAppendingFormat:@"%.2fg",[[mealData objectForKey:@"Carbohydrates"] floatValue]] : @"" ;
            carbGramLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"Carbohydrates"]] ? [@"" stringByAppendingFormat:@"%.2fg",[[mealData objectForKey:@"Carbohydrates"] floatValue]] : @"" ;
            
//        }
        carbPercentageLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"CarbPercentage"]] ? [@"" stringByAppendingFormat:@"%.0f%%",[[mealData objectForKey:@"CarbPercentage"] floatValue]] : @"" ;
        
        carbCalsLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"CarbCals"]] ? [@"" stringByAppendingFormat:@"%.2f",[[mealData objectForKey:@"CarbCals"] floatValue]] : @"" ;
        
        //End
        //Fat
//        if ([[defaults objectForKey:@"UnitPreference"] intValue] == 2){
//            carbUnitLabel.text = @"- oz";
//            fatTotalLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"FatOz"]] ? [@"" stringByAppendingFormat:@"%.2foz",[[mealData objectForKey:@"FatOz"] floatValue]] : @"" ;
//
//            fatGramLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"FatOz"]] ? [@"" stringByAppendingFormat:@"%.2foz",[[mealData objectForKey:@"FatOz"] floatValue]] : @"" ;
//        }else{
            carbUnitLabel.text = @"- gram";
            fatTotalLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"Fat"]] ? [@"" stringByAppendingFormat:@"%.2fg",[[mealData objectForKey:@"Fat"] floatValue]] : @"" ;
            fatGramLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"Fat"]] ? [@"" stringByAppendingFormat:@"%.2fg",[[mealData objectForKey:@"Fat"] floatValue]] : @"" ;
//        }
        fatPercentageLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"FatPercentage"]] ? [@"" stringByAppendingFormat:@"%.0f%%",[[mealData objectForKey:@"FatPercentage"] floatValue]] : @"" ;
        
        fatCalsLabel.text=![Utility isEmptyCheck:[mealData objectForKey:@"FatCals"]] ? [@"" stringByAppendingFormat:@"%.2f",[[mealData objectForKey:@"FatCals"] floatValue]] : @"" ;
        
        //End
        
        int isVegetarian=![Utility isEmptyCheck:[mealData objectForKey:@"IsVegetarian"]] ? [[mealData objectForKey:@"IsVegetarian"] intValue] : 0 ;
        
        NSString *dietInfo=@"";
        //        if(isVegetarian>0){       //aahh
        
        
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"FlagCategory ==[c] %@ AND FlagTitle ==[c] %@", @"UI_PREFERENCES",@"UNIT_PREFERENCE"];
        NSArray *filteredArray = [unitPreferenceArray filteredArrayUsingPredicate:predicate];
        if (filteredArray.count > 0) {
            NSDictionary *unitPreferenceDict = [filteredArray objectAtIndex:0];
            NSString *unitKey = [@"" stringByAppendingFormat:@"%@",[unitPreferenceDict objectForKey:@"Value"]];
            if ([Utility isEmptyCheck:unitKey]) {
                unitKey =@"0";
            }
            if (![Utility isEmptyCheck:unitKey]) {
                NSString *unitValue = [unit objectForKey:unitKey];
                NSArray *ingredientsArray  = [mealDetailsDictionary objectForKey:@"Ingredients"];
                NSSortDescriptor *IngredientNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"IngredientName" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:IngredientNameDescriptor];
                ingredientsArray = [ingredientsArray sortedArrayUsingDescriptors:sortDescriptors];
                if (![Utility isEmptyCheck:ingredientsArray] && ingredientsArray.count > 0) {
                    for (NSDictionary *ingredient in ingredientsArray) {
                        NSArray *ingredientsViewObjects = [[NSBundle mainBundle] loadNibNamed:@"ingredientsView" owner:self options:nil];
                        
                        ingredientsView *ingredientsView = [ingredientsViewObjects objectAtIndex:0];
                        if (![Utility isEmptyCheck:[ingredient objectForKey:@"IngredientName"]] ) {
                            NSString *ingredientString = [ingredient objectForKey:@"IngredientName"];
                            if (![Utility isEmptyCheck:mealData[@"MealClassifiedID"]] && [mealData[@"MealClassifiedID"]intValue] == 2)
                            {
                                ingredientsView.ingredients.text = ingredientString;
                            }else{
                                ///////////////////////
                                
                                if ([[[ingredient objectForKey:@"IngredientDetails"] valueForKey:@"ConversionUnit"] isEqualToString:@"cups"]) {
                                    NSLog(@"%f",[[[ingredient objectForKey:@"IngredientDetails"] valueForKey:@"ConversionNum"]floatValue]);
                                }
                                if (([[[ingredient objectForKey:@"IngredientDetails"] valueForKey:@"ConversionNum"]floatValue] == 0.0 || [[[ingredient objectForKey:@"IngredientDetails"] valueForKey:@"ConversionUnit"] isEqualToString:[ingredient valueForKey:@"UnitMetric"]])
                                    || [[[ingredient valueForKey:@"UnitMetric"] lowercaseString] isEqualToString:@"as needed"]
                                    || [[[ingredient valueForKey:@"UnitMetric"] lowercaseString] isEqualToString:@"pinch"])
                                {
                                    if ([[[ingredient valueForKey:@"UnitMetric"] lowercaseString] isEqualToString:@"pinch"])
                                    {
                                        if ([[ingredient objectForKey:@"QuantityMetric"]floatValue]< 1) {
                                            ingredientString = [ingredientString stringByAppendingFormat:@" - %g",1.0];
                                        }else{
                                            ingredientString = [ingredientString stringByAppendingFormat:@" - %g",[[ingredient objectForKey:@"QuantityMetric"]floatValue]];
                                        }
                                        ingredientString = [ingredientString stringByAppendingFormat:@" %@ ",[ingredient objectForKey:@"UnitMetric"] ];
                                        
                                    }
                                    else if ([[[ingredient valueForKey:@"UnitMetric"] lowercaseString] isEqualToString:@"as needed"])
                                    {
                                        ingredientString = [ingredientString stringByAppendingFormat:@" - %@",[ingredient objectForKey:@"UnitMetric"]];
                                        
                                    }
                                    else
                                    {
                                        if ([unitValue isEqualToString:@"ALL"])
                                        {
                                            ingredientString = [ingredientString stringByAppendingFormat:@" - %g %@",[[ingredient objectForKey:@"QuantityMetric"]floatValue], [ingredient objectForKey:@"UnitMetric"]];
                                            if (![[ingredient objectForKey:@"UnitImperial"] isEqualToString:[ingredient objectForKey:@"UnitMetric"]]) {
                                                ingredientString = [ingredientString stringByAppendingFormat:@"(%@ %@)",[self ImperialRoundTripConversionValue:[[ingredient objectForKey:@"QuantityImperial"]floatValue]], [ingredient objectForKey:@"UnitImperial"]];
                                            }
                                            
                                        }
                                        else if ([unitValue isEqualToString:@"METRIC"])
                                        {
                                            ingredientString = [ingredientString stringByAppendingFormat:@" - %g %@",[[ingredient objectForKey:@"QuantityMetric"]floatValue], [ingredient objectForKey:@"UnitMetric"]];
                                            
                                        }
                                        else
                                        {
                                            ingredientString = [ingredientString stringByAppendingFormat:@"( %@ %@ )",[self ImperialRoundTripConversionValue:[[ingredient objectForKey:@"QuantityImperial"]floatValue]], [ingredient objectForKey:@"UnitImperial"]];
                                        }
                                    }
                                }
                                else
                                {
                                    if ([[[ingredient valueForKey:@"UnitMetric"] lowercaseString] isEqualToString:@"pinch"])
                                    {
                                        if ([[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConvertedQuantity"]floatValue] <= 1) {
                                            ingredientString = [ingredientString stringByAppendingFormat:@" - %@ %@ ",[self getQuantity:[[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConvertedQuantity"]floatValue] conversionNumbeType:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"Con_U1"]],[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"]];
                                        } else {
                                            ingredientString = [ingredientString stringByAppendingFormat:@" - %@ %@ ",[self getQuantity:[[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConvertedQuantity"]floatValue] conversionNumbeType:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"Con_O1"]],[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"]];
                                        }
//                                        ingredientString = [ingredientString stringByAppendingFormat:@" - %@ %@ ",[self getQuantity:[[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConvertedQuantity"]floatValue] conversionNumbeType:@""],[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"]];
                                        if ([[ingredient objectForKey:@"QuantityMetric"]floatValue] < 1) {
//                                            ingredientString = [ingredientString stringByAppendingFormat:@"( %g %@ )", 1.0, [ingredient objectForKey:@"UnitMetric"] ];
                                            ingredientString = [ingredientString stringByAppendingFormat:@"( %@ %@ )",[self UnitNumberType:[[ingredient objectForKey:@"QuantityMetric"]floatValue] conversionNumbeType:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"Unit_U1"]], [ingredient objectForKey:@"UnitMetric"]];
                                        }else{
//                                            ingredientString = [ingredientString stringByAppendingFormat:@"( %g %@ )", [[ingredient objectForKey:@"QuantityMetric"]floatValue], [ingredient objectForKey:@"UnitMetric"] ];
                                            ingredientString = [ingredientString stringByAppendingFormat:@"( %@ %@ )",[self UnitNumberType:[[ingredient objectForKey:@"QuantityMetric"]floatValue] conversionNumbeType:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"Unit_O1"]], [ingredient objectForKey:@"UnitMetric"]];
                                        }
                                        
                                    }else{
                                        if ([unitValue isEqualToString:@"ALL"])
                                        {
//                                            ingredientString = [ingredientString stringByAppendingFormat:@" - %g %@",[[ingredient objectForKey:@"QuantityMetric"]floatValue], [ingredient objectForKey:@"UnitMetric"]];
//                                            if (![[ingredient objectForKey:@"UnitImperial"] isEqualToString:[ingredient objectForKey:@"UnitMetric"]]) {
//                                                ingredientString = [ingredientString stringByAppendingFormat:@"( %@ %@ )",[self ImperialRoundTripConversionValue:[[ingredient objectForKey:@"QuantityImperial"]floatValue]], [ingredient objectForKey:@"UnitImperial"]];
//                                            }
                                            //**********//
                                            //27-08 feedback
                                            if (![Utility isEmptyCheck:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"]] &&  ![[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"] isEqualToString:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"UnitMetric"]]) {
                                                if ([[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConvertedQuantity"]floatValue] <= 1) {
                                                    ingredientString = [ingredientString stringByAppendingFormat:@" - %@ %@ ",[self getQuantity:[[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConvertedQuantity"]floatValue] conversionNumbeType:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"Con_U1"]], [[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"]];
                                                    ingredientString = [ingredientString stringByAppendingFormat:@"( %@ %@ )",[self UnitNumberType:[[ingredient objectForKey:@"QuantityMetric"]floatValue] conversionNumbeType:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"Unit_U1"]], [ingredient objectForKey:@"UnitMetric"]];
                                                } else {
                                                    ingredientString = [ingredientString stringByAppendingFormat:@" - %@ %@ ",[self getQuantity:[[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConvertedQuantity"]floatValue] conversionNumbeType:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"Con_O1"]], [[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"]];
                                                    ingredientString = [ingredientString stringByAppendingFormat:@"( %@ %@ )",[self UnitNumberType:[[ingredient objectForKey:@"QuantityMetric"]floatValue] conversionNumbeType:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"Unit_O1"]], [ingredient objectForKey:@"UnitMetric"]];
                                                }
                                                if (![[ingredient objectForKey:@"UnitImperial"] isEqualToString:[ingredient objectForKey:@"UnitMetric"]]) {
                                                    ingredientString = [ingredientString stringByAppendingFormat:@" or ( %@ %@ )",[self ImperialRoundTripConversionValue:[[ingredient objectForKey:@"QuantityImperial"]floatValue]], [ingredient objectForKey:@"UnitImperial"]];
                                                }
                                            }
                                            //**********//
                                        }
                                        else if ([unitValue isEqualToString:@"METRIC"])
                                        {
                                            if (![Utility isEmptyCheck:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"]] &&  ![[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"] isEqualToString:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"UnitMetric"]]) {
                                                if ([[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConvertedQuantity"]floatValue] <= 1) {
                                                    ingredientString = [ingredientString stringByAppendingFormat:@" - %@ %@ ",[self getQuantity:[[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConvertedQuantity"]floatValue] conversionNumbeType:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"Con_U1"]], [[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"]];
                                                    ingredientString = [ingredientString stringByAppendingFormat:@"( %@ %@ )",[self UnitNumberType:[[ingredient objectForKey:@"QuantityMetric"]floatValue] conversionNumbeType:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"Unit_U1"]], [ingredient objectForKey:@"UnitMetric"]];
                                                } else {
                                                    ingredientString = [ingredientString stringByAppendingFormat:@" - %@ %@ ",[self getQuantity:[[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConvertedQuantity"]floatValue] conversionNumbeType:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"Con_O1"]], [[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"]];
                                                    ingredientString = [ingredientString stringByAppendingFormat:@"( %@ %@ )",[self UnitNumberType:[[ingredient objectForKey:@"QuantityMetric"]floatValue] conversionNumbeType:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"Unit_O1"]], [ingredient objectForKey:@"UnitMetric"]];
                                                }
//                                                ingredientString = [ingredientString stringByAppendingFormat:@" - %@ %@ ",[self getQuantity:[[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConvertedQuantity"]floatValue]], [[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"]];
                                            }
//                                            ingredientString = [ingredientString stringByAppendingFormat:@"( %g %@ )",[[ingredient objectForKey:@"QuantityMetric"]floatValue], [ingredient objectForKey:@"UnitMetric"]];
                                            
                                        }
                                        else
                                        {
                                            if (![Utility isEmptyCheck:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"]] &&  ![[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"] isEqualToString:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"UnitMetric"]]) {
                                                if ([[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConvertedQuantity"]floatValue] <= 1) {
                                                    ingredientString = [ingredientString stringByAppendingFormat:@" - %@ %@ ",[self getQuantity:[[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConvertedQuantity"]floatValue] conversionNumbeType:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"Con_U1"]], [[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"]];
                                                } else {
                                                    ingredientString = [ingredientString stringByAppendingFormat:@" - %@ %@ ",[self getQuantity:[[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConvertedQuantity"]floatValue] conversionNumbeType:[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"Con_O1"]], [[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"]];
                                                }
//                                                ingredientString = [ingredientString stringByAppendingFormat:@" - %@ %@ ",[self getQuantity:[[[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConvertedQuantity"]floatValue]], [[ingredient objectForKey:@"IngredientDetails"] objectForKey:@"ConversionUnit"]];
                                            }
                                            ingredientString = [ingredientString stringByAppendingFormat:@"( %@ %@ )",[self ImperialRoundTripConversionValue:[[ingredient objectForKey:@"QuantityImperial"]floatValue]], [ingredient objectForKey:@"UnitImperial"]];
                                            
                                        }
                                    }
                                }
                                
                                
                                ///////////////////////
                                
                                
                                if ([ingredientString rangeOfString:@"to taste" options:NSCaseInsensitiveSearch].location == NSNotFound){
                                    NSLog(@"string does not contain to taste");
                                }else{
                                    NSLog(@"string contains to taste!");
                                    ingredientString = [NSString stringWithFormat:@"%@ - To Taste",[ingredient objectForKey:@"IngredientName"]];
                                }
                                NSAttributedString *ingredientName = [[NSAttributedString alloc] initWithString:[@"" stringByAppendingFormat:@"%@",ingredientString]];
                                ingredientsView.ingredients.attributedText = ingredientName;
                            }
                            
                        }else{
                            ingredientsView.ingredients.text =  @"";
                            
                        }
                        [ingredientsStackView addArrangedSubview:ingredientsView];
                        
                    }
                }
            }
            
            
        }
        
        NSArray *methodsArray  = [mealDetailsDictionary objectForKey:@"Instructions"];
        if (![Utility isEmptyCheck:methodsArray] && methodsArray.count > 0) {
            for (NSDictionary *method in methodsArray) {
                NSArray *methodViewObjects = [[NSBundle mainBundle] loadNibNamed:@"Methods" owner:self options:nil];
                
                Methods *methodView = [methodViewObjects objectAtIndex:0];
                methodView.methodNo.text = ![Utility isEmptyCheck:[method objectForKey:@"InstructionNo"]] ? [@"" stringByAppendingFormat:@"%@", [method objectForKey:@"InstructionNo"]] : @"";
                methodView.merhodName.text = ![Utility isEmptyCheck:[method objectForKey:@"InstructionText"]] ? [method objectForKey:@"InstructionText"] : @"";
                [methodStackView addArrangedSubview:methodView];
            }
            
        }
        
        
        
        
        
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
                                                                             NSLog(@"%@",responseDictionary);
                                                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup_nourish

                                                                             unitPreferenceArray = [responseDictionary objectForKey:@"obj"];
                                                                             if ([_fromController isEqualToString:@"Food Prep"]) {
                                                                                 if ([mealSessionId isEqualToNumber:@0]) {
                                                                                     [self getMealDetailsBySize];
                                                                                 } else {
                                                                                     [self squadGetMealSessionDetail];
                                                                                 }
                                                                                 return ;
                                                                             }
                                                                             if (mealSessionId) {
                                                                                 [self squadGetMealSessionDetail];
                                                                             }else{
                                                                                 [self getGoodnessDetails];
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

-(void)squadGetMealSessionDetail{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        if ([_fromController isEqualToString:@"Food Prep"]) {
            //
        } else {
            [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        }
//        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealSessionId forKey:@"MealSessionId"];
        [mainDict setObject:[defaults objectForKey:@"ApplyRounding"] forKey:@"ApplyRounding"];

        //ah ux
        NSInteger overrideServes = 1;
        if (![Utility isEmptyCheck:selectedServe]) {
            overrideServes = [[selectedServe objectForKey:@"key"] integerValue];
        }
        [mainDict setObject:[NSNumber numberWithInteger:overrideServes] forKey:@"OverrideServes"];
        //end
        
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
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadGetMealSessionDetailApiCall" append:@"" forAction:@"POST"];
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
                                                                             NSLog(@"%@",responseDictionary);
                                                                             NSDictionary *squadMealSession = responseDictionary[@"SquadMealSession"];
                                                                             if (![Utility isEmptyCheck:squadMealSession]) {
                                                                                 mealDetailsDictionary = [squadMealSession objectForKey:@"Meal"];
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
-(void)getGoodnessDetails{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealId forKey:@"MealId"];
        
        //ah ux
        NSInteger overrideServes = 1;
        if (![Utility isEmptyCheck:selectedServe]) {
            overrideServes = [[selectedServe objectForKey:@"key"] integerValue];
        }
        [mainDict setObject:[NSNumber numberWithInteger:overrideServes] forKey:@"OverrideServes"];
        //end

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
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMealDetailsApiCall" append:@"" forAction:@"POST"];
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
                                                                             NSLog(@"%@",responseDictionary);
                                                                             mealDetailsDictionary = [responseDictionary objectForKey:@"Meal"];
                                                                             [self prepareView];
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
-(void)getMealDetailsBySize{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealId forKey:@"MealId"];
        [mainDict setObject:[defaults objectForKey:@"ApplyRounding"] forKey:@"ApplyRounding"];
        [mainDict setObject:_Calorie forKey:@"Calorie"];
        
        NSInteger overrideServes = 1;
        if (![Utility isEmptyCheck:selectedServe]) {
            overrideServes = [[selectedServe objectForKey:@"key"] integerValue];
        }
        [mainDict setObject:[NSNumber numberWithInteger:overrideServes] forKey:@"OverrideServes"];
        
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
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMealDetailsBySize" append:@"" forAction:@"POST"];
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
                                                                     
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else {
                                                                             NSLog(@"%@",responseDictionary);
                                                                             mealDetailsDictionary = [responseDictionary objectForKey:@"Meal"];
                                                                             [self prepareView];
                                                                             
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
//03/04/18 shabbir
- (NSString *)getQuantity:(float) quantity conversionNumbeType:(NSString *)conversionNumbeType{  //ah 23.5
    NSString *showquantity = @"";
    if ([[defaults objectForKey:@"ApplyRounding"]boolValue]) {
        //do rounding
        float conversionQuantity = 0.0;
        if (quantity <= 1) {
            if ([conversionNumbeType isEqualToString:@"QHW"]) {
                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"QHW"];
            }
            if ([conversionNumbeType isEqualToString:@"HW"]) {
                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"HW"];
            }
            if ([conversionNumbeType isEqualToString:@"W"]) {
                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W"];
            }
        } else {
            if ([conversionNumbeType isEqualToString:@"QHW"]) {
                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"QHW"];
            }
            if ([conversionNumbeType isEqualToString:@"HW"]) {
                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"HW"];
            }
            if ([conversionNumbeType isEqualToString:@"W"]) {
                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W"];
            }
            if ([conversionNumbeType isEqualToString:@"W2.5"]) {
                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W2.5"];
            }
            if ([conversionNumbeType isEqualToString:@"W5"]) {
                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W5"];
            }
            
        }
        // ¼ ½ ¾
        showquantity = [NSString stringWithFormat:@"%g",conversionQuantity];
        if (conversionQuantity <= 0.25) {
            showquantity = @"¼";
        }else if (conversionQuantity <= 0.5) {
            showquantity = @"½";
        }else if (conversionQuantity <= 0.75) {
            showquantity = @"¾";
        }
        
    } else {
        //dont round, just show as it is
        showquantity = [NSString stringWithFormat:@"%g",quantity];
    }
    
    return showquantity;
}
- (float )RoundTripConversionValue:(float) quantity conversionNumbeType:(NSString *)conversionNumbeType{
    float floorValue = 0.0;
    
    // for QWH round trip calculation
    if ([conversionNumbeType isEqualToString:@"QHW"])
    {
        if (quantity == 0)
        {
            quantity = 0.0;
        }
        else if (quantity <= 1)
        {
            if (quantity <= 0.37)
            {
                quantity = 0.25;
            }
            else if (quantity > 0.37 && quantity <= 0.62)
            {
                quantity = 0.5;
            }
            else if (quantity > 0.62 && quantity <= 0.87)
            {
                quantity = 0.75;
            }
            else
            {
                quantity = 1;
            }
            if (quantity <= 0)
            {
                quantity = 0.25;
            }
        }
        
        else
        {
            //2.61
            floorValue = quantity - floor(quantity); //.61
            quantity = quantity - floorValue; //2
            if (floorValue > 0)
            {
                if (floorValue <= 0.37)
                {
                    quantity = quantity + 0.25;
                }
                else if (floorValue > 0.37 && floorValue <= 0.62)
                {
                    quantity = quantity + 0.5;
                }
                else if (floorValue > 0.62 && floorValue <= 0.87)
                {
                    quantity = quantity + 0.75;
                }
                
                else //if (floorValue > Convert.ToDecimal(0.87) && floorValue < Convert.ToDecimal(quantity))
                {
                    quantity = quantity + 1;
                }
            }
        }
    }
    
    // for HW round trip calculation
    else if ([conversionNumbeType isEqualToString:@"HW"])
    {
        if (quantity == 0)
        {
            quantity = 0.0;
        }
        else if (quantity <= 1)
        {
            if (quantity < 0.75)
            {
                quantity = 0.50;
            }
            else //if (quantity >= Convert.ToDecimal(0.75))
            {
                quantity = 1;
            }
        }
        else
        {
            floorValue = quantity - floor(quantity);
            quantity = quantity - floorValue;
            if (floorValue > 0)
            {
                if (floorValue < 0.75)
                {
                    quantity = quantity + 0.50;
                }
                else //if (floorValue >= Convert.ToDecimal(0.75) && floorValue < quantity)
                {
                    quantity = quantity + 1;
                }
            }
        }
    }

    // for W2.5 round trip calculation
    else if ([conversionNumbeType isEqualToString:@"W2.5"])
    {
        int a = quantity / 2.5;
        floorValue = quantity - (2.5 * a);
//        floorValue = quantity % 2.5;
        quantity = quantity - floorValue;
        // quantity = quantity + Convert.ToDecimal(2.50);
        
        if (floorValue < 1.25)
        {
            quantity = quantity + 0.0;
        }
        else
        {
            quantity = quantity + 2.5;
        }
        
        if (quantity <= 0)
        {
            quantity = 2.50;
        }
        
    }
    
    // for W5 round trip calculation
    else if ([conversionNumbeType isEqualToString:@"W5"])
    {
        int a = quantity / 5.0;
        floorValue = quantity - (5.0 * a);
//        floorValue = quantity % 5.0;
        quantity = quantity - floorValue;
        // quantity = quantity + Convert.ToDecimal(5);
        if (floorValue < 2.50)
        {
            quantity = quantity + 0.0;
        }
        else
        {
            quantity = quantity + 5.0;
        }
        if (quantity <= 0)
        {
            quantity = 5.0;
        }
    }
    
    // for W round trip calculation
    else if ([conversionNumbeType isEqualToString:@"W"])
    {
        quantity = [[NSString stringWithFormat:@"%.0f",quantity]floatValue];
        NSLog(@"%f",quantity);
    }
    return quantity;
}
//
- (NSString *)UnitNumberType:(float) quantity conversionNumbeType:(NSString *)conversionNumbeType{

    //for Unit_O1 and Unit_U1
    float conversionQuantity = 0.0;

    if (quantity <= 1)
    {
        if ([conversionNumbeType isEqualToString:@"QHW"]) {
            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"QHW"];
        }
        if ([conversionNumbeType isEqualToString:@"HW"]) {
            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"HW"];
        }
        if ([conversionNumbeType isEqualToString:@"W"]) {
            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W"];
        }
        
    }
    else
    {
        if ([conversionNumbeType isEqualToString:@"QHW"]) {
            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"QHW"];
        }
        if ([conversionNumbeType isEqualToString:@"HW"]) {
            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"HW"];
        }
        if ([conversionNumbeType isEqualToString:@"W"]) {
            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W"];
        }
        if ([conversionNumbeType isEqualToString:@"W2.5"]) {
            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W2.5"];
        }
        if ([conversionNumbeType isEqualToString:@"W5"]) {
            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W5"];
        }
        
    }
    NSString *showquantity = [NSString stringWithFormat:@"%g",conversionQuantity];
    return showquantity;
}

- (NSString *)ImperialRoundTripConversionValue:(float) quantity{

    float floorValue = 0.0;
    int a = quantity / 0.1;
    floorValue = quantity - (0.1 * a);
    
//    floorValue = quantity % 0.1;
    quantity = quantity - floorValue;

    if (floorValue < 0.05)
    {
        quantity = quantity + 0;
    }
    else
    {
        quantity = quantity + 0.1;
    }

    if (quantity <= 0)
    {
        quantity = 0.1;
    }

    NSString *showquantity = [NSString stringWithFormat:@"%g",quantity];
    return showquantity;
}
//
//- (NSString *)getQuantity:(CGFloat) quantity {  //ah 23.5
//    NSString *showquantity = @"";
//    if (quantity < 1)
//    {
//        if (quantity == 0)
//        {
//         showquantity = @"0";
//        }else if (quantity <= 0.25 && quantity > 0 )
//        {
//            showquantity = @"¼";
//        }
//        else if (quantity > 0.25 && quantity <= 0.50)
//        {
//            showquantity = @"½";
//        }
//        else if (quantity > 0.50 && quantity <= 0.75)
//        {
//            showquantity = @"¾";
//        }
//        else
//        {
//            showquantity = @"1";
//        }
//    }
//    else
//    {
//        showquantity = [NSString stringWithFormat:@"%g",quantity];
//    }
//    return showquantity;
//}
#pragma -mark End

#pragma mark - Private Function
-(void)checkForChange:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"backButtonPressed"]) {
        if ([delegate respondsToSelector:@selector(didCheckAnyChangeForDailyGoodness:)]) {
            [delegate didCheckAnyChangeForDailyGoodness:isChanged];
        }
        [self back:nil];
    }
}
-(void)addMealViewPoints{
    if(!mealId) return;
    NSMutableDictionary *dataDict = [NSMutableDictionary new];
    [dataDict setObject:[NSNumber numberWithInt:42] forKey:@"UserActionId"];
    [dataDict setObject:mealId forKey:@"ReferenceEntityId"];
    [dataDict setObject:@"Meal" forKey:@"ReferenceEntityType"];
    
    [Utility addGamificationPointWithData:dataDict];
}
#pragma mark - End

#pragma mark -DropdownViewDelegate
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData sender:(UIButton *)sender{
    if ([type caseInsensitiveCompare:@"Serve"] == NSOrderedSame) {
        //shabbir 11/01
        //[sender setTitle:[selectedData objectForKey:@"value"] forState:UIControlStateNormal];
        selectedServe = selectedData;
        //ah ux
        //        [self prepareView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getUnitPreference];
//            if ([_fromController isEqualToString:@"Food Prep"]) {
//                if ([mealSessionId isEqualToNumber:@0]) {
//                    [self getMealDetailsBySize];
//                } else {
//                    [self squadGetMealSessionDetail];
//                }
//            }
        });
    }
}

//shabbir 12/01
-(IBAction)goToBottomPressed{
    [scrollView setContentOffset:CGPointMake(0, mealInfoView.frame.origin.y) animated:YES];
}

-(IBAction)goToTopPressed{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark -End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - AddEditCustomDelegate

-(void)didCheckAnyChange:(BOOL)ischanged{
    isChanged = ischanged;
}
-(void)reloadWithNewMeal:(NSNumber *)mealId{
    isChanged = true;
    self->mealSessionId = nil;
    self->mealId = mealId;
}
#pragma mark - End

#pragma mark - ShowImageViewDelegate

-(void)didCheckAnyChangeForShowImage:(BOOL)ischanged{
    isChanged= ischanged;
}
@end
