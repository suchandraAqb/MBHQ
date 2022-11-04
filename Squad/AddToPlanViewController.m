//
//  AddToPlanViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 13/11/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "AddToPlanViewController.h"
#import "Calorie.h"
#import "MealMatchViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
//chayan 23/10/2017
#import "ProgressBarViewController.h"
#import "foodPrepSearchTableViewCell.h"

@interface AddToPlanViewController (){
    IBOutlet UIView *mealTypeView;
    IBOutlet UITextField *mealTypeNameLabel;
    IBOutlet UITextField *brandTextField;
    IBOutlet UIButton *mealNameButton;
    IBOutlet UIImageView *mealImage;
    
    IBOutletCollection(UIButton) NSArray *mealTypeButton;
    IBOutlet UIView *beforeEatingMealView;
    IBOutlet UIView *afterEatingMealView;
    
    IBOutletCollection(UIButton) NSArray *beforeMealEnergyButtons;
    
    IBOutletCollection(UIButton) NSArray *beforeMealCravingsButtons;
    
    IBOutletCollection(UIButton) NSArray *moodPresentButtons;
    
    IBOutletCollection(UIButton) NSArray *afterMealEnergyButtons;
    
    IBOutletCollection(UIButton) NSArray *afterMealCravingsButtons;
    
    IBOutletCollection(UIButton) NSArray *bloatButtons;
    
    IBOutlet UIButton *mealQuantityButton;
    
    IBOutlet UIView *caloriView;
//    IBOutlet UITextField *caloryTextField;
    IBOutlet UIImageView *previewImageView;
    IBOutlet UITextField *furtherNotesTextField;
    
    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *saveButton;
    
    IBOutlet UIScrollView *scroll;
    
    UIView *contentView;
    int apiCount;
    NSArray *mealQuantityArray;
    
    UITextField *activeTextField;
    UIToolbar *toolBar;
    
    
    IBOutletCollection(UIView) NSArray *viewsArray;
    
    IBOutlet UIButton *ingredientButton;
    NSMutableArray *unitListArray;
    
    //Variables For Save/Update
    
    NSDateFormatter *dailyDateformatter;
    UIImage *selectedImage;
    int BeforeEnergy;
    int BeforeCravings;
    int AfterEnergy;
    int AfterCravings;
    int AfterBloat;
//    int MealType;
    NSString *MealName;
    
    int QuantityId;
    float Calories;
    float mealQuantity;
    float ingredientCalori;
    
    //chayan
    bool isNextButtonPressed;
    int savedMealId;
    //chayan 23/10/2017
    BOOL isNextMultiPart;
    
    //End
    //03/05/18
    __weak IBOutlet UIView *showHideView;
    __weak IBOutlet UITableView *mealTable;
    __weak IBOutlet UIButton *cancelButton;
    //    NSMutableArray *mealListArray;
    int pageNo;
    BOOL isClick;
    BOOL isChanged;
    __weak IBOutlet UITextField *filterTextField;
    
    IBOutlet UITextField *caloriesTextField;
    IBOutlet UITextField *proteinTextField;
    IBOutlet UITextField *carbsTextField;
    IBOutlet UITextField *fatTextField;
    IBOutlet UIButton *uploadButton;
    IBOutlet UIButton *noButton;
    BOOL isEdit;
    
    NSArray *tempMealArray;
    NSDictionary *searchDict;
    NSArray *ingredientsAllList;
    NSArray *dietaryPreferenceArray;
    
    __weak IBOutlet UIView *trackView;
    __weak IBOutlet UIView *addToPlanView;
    __weak IBOutlet UIView *updatePlanView;
    
    IBOutlet UITextField *serveTextField;
    IBOutlet UIButton *unitsButton;
    IBOutlet UITextField *ingredientTextfield;//quantity
    IBOutlet UILabel *caloriLabel;
    IBOutlet UIView *mealServeView;
    IBOutlet UIView *ingQuantityView;
    float serveMultiplier;
    IBOutlet UIView *previewImageContainer;
    IBOutlet UIView *previewImageContainer1;
    
    IBOutlet UIStackView *nutritionStackView;
    IBOutletCollection(UIStackView) NSArray *pcfStackViews;
    IBOutlet UIView *calView;
    IBOutlet UIButton *arrButton;
    IBOutlet UIView *editButtonView;
    IBOutlet UIButton *editButton;
    IBOutlet UIView *servingSizeView;
    IBOutlet UIButton *planButton;
    IBOutlet UILabel *unitLabel;
}
@end

@implementation AddToPlanViewController
@synthesize isStatic,isAdd,mealTypeData,mealListArray,mealDetails,isStaticIngredient,currentDate,MealId,mealCategory,delegate;

#pragma mark -View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //chayan
    serveMultiplier = 1.0;
    serveTextField.text = @"1";
    brandTextField.text = @"";
//    mealServeView.layer.borderWidth = 1.0;
//    mealServeView.layer.borderColor = squadMainColor.CGColor;
//    serveTextField.layer.borderWidth = 1.0;
//    serveTextField.layer.borderColor = squadMainColor.CGColor;
//    if (_fromMyPlan) {
//        serveTextField.userInteractionEnabled = false;
//        serveTextField.alpha = 0.5;
//    }else{
//        serveTextField.alpha = 1.0;
//        serveTextField.userInteractionEnabled = true;
//    }
//    ingQuantityView.layer.borderWidth = 1.0;
//    ingQuantityView.layer.borderColor = squadMainColor.CGColor;
    planButton.hidden = true;
    [arrButton setImage:nil forState:UIControlStateSelected];
    [unitsButton setTitleColor:squadMainColor forState:UIControlStateNormal];
    editButtonView.hidden = true;
    isNextButtonPressed = NO;
    savedMealId = 0;
    ingredientCalori = 0.0;
    pageNo = 1;
    showHideView.hidden = true;
    mealTable.estimatedRowHeight = 50;
    mealTable.rowHeight = UITableViewAutomaticDimension;
    mealTable.hidden = false;
    cancelButton.layer.cornerRadius = 3.0f;
    cancelButton.layer.masksToBounds = YES;
    mealTable.layer.cornerRadius = 3.0f;
    mealTable.layer.masksToBounds = YES;
    uploadButton.layer.cornerRadius = 15.0;
    uploadButton.layer.masksToBounds = YES;
    nextButton.layer.cornerRadius = 15.0;
    nextButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 15.0;
    saveButton.layer.masksToBounds = YES;
    editButton.layer.cornerRadius = 15.0;
    editButton.layer.masksToBounds = YES;
    editButton.layer.borderWidth = 1.0;
    editButton.layer.borderColor = squadMainColor.CGColor;
    if((isStatic && !isStaticIngredient && (mealTypeData == 1 || mealTypeData == 2)) || (![Utility isEmptyCheck:mealDetails] && [mealDetails[@"Quantity"] intValue] == 1)){
        
        mealQuantityArray = @[/*@{
                               @"id" : @-2,
                               @"name" : @"------Portion Size I consumed for this meal------"
                               
                               },*/@{
                                       @"id" : @1,
                                       @"name" : @"As per Recipe"
                                       },
                                   @{
                                       @"id" : @-1,
                                       @"name" : @"As per Meal Plan"
                                       
                                       },
                                   @{
                                       @"id" : @0,
                                       @"name" : @"Enter Exact Calories Consumed"
                                       
                                       }
                                   ];
        
    }else{
        mealQuantityArray = @[/*@{
                               @"id" : @-2,
                               @"name" : @"------Portion Size I consumed for this meal------"
                               
                               },*/
                              @{
                                  @"id" : @-1,
                                  @"name" : @"As per Meal Plan"
                                  
                                  },
                              @{
                                  @"id" : @0,
                                  @"name" : @"Enter Exact Calories Consumed"
                                  
                                  }
                              ];
    }
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
//    [caloryTextField setInputAccessoryView:toolBar];
    [ingredientTextfield setInputAccessoryView:toolBar];
    [self registerForKeyboardNotifications];
    
//    currentDate = [NSDate date];
    dailyDateformatter = [[NSDateFormatter alloc]init];
    [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
    currentDate = [dailyDateformatter dateFromString:dateString];
    mealNameButton.tag= -1;
    ingredientButton.tag=-1;
    unitsButton.tag=-1;
//    [self setup_view];
    if (isStaticIngredient && isAdd) {
        int tMealId = ![Utility isEmptyCheck:[mealDetails objectForKey:@"MealId"]]?[[mealDetails objectForKey:@"MealId"]intValue]:0;
        if (tMealId == 0) {
            tMealId = ![Utility isEmptyCheck:[mealDetails objectForKey:@"IngredientId"]]?[[mealDetails objectForKey:@"IngredientId"]intValue]:0;
        }
        [self getMyMealListById:tMealId isSavePer100:_quickRecentFreq];//for ingredient
    }else{
        if (isStaticIngredient) {
            int tMealId = ![Utility isEmptyCheck:[mealDetails objectForKey:@"MealId"]]?[[mealDetails objectForKey:@"MealId"]intValue]:0;
            if (tMealId == 0) {
                tMealId = ![Utility isEmptyCheck:[mealDetails objectForKey:@"IngredientId"]]?[[mealDetails objectForKey:@"IngredientId"]intValue]:0;
            }
            [self getMyMealListById:tMealId isSavePer100:YES];
        } else {
            if([[mealDetails objectForKey:@"IsEdamam"]boolValue]){
                NSString *mealStringId = [mealDetails objectForKey:@"MealId"];
                if (![Utility isEmptyCheck:mealStringId]) {
                    [self getNutritionixMealDetailsById:mealStringId];
                }else{
                    [self setup_view];
                }
            } else {
                
                [self setup_view];
            }
        }
    }
//    if (mealTypeData != 3) {
//        if (!isStaticIngredient) {
//            [self getSquadMealList:mealTypeData mealName:mealDetails isStatic:isStatic];
//        } else {
//            [self getIngredientList:mealTypeData mealName:mealDetails isStatic:isStatic];
//        }
//    }
    
    [filterTextField addTarget:self action:@selector(textValueChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -End

#pragma mark -Private Method
-(BOOL)formValidation{
    BOOL isValidated =  true;
    
//    if (MealId <= 0){
//
//        [Utility msg:(!isStaticIngredient)?@"Please choose your meal.":@"Please choose your ingredient." title:@"" controller:self haveToPop:false];
//        isValidated = false;
//    }
    
    if(!isStaticIngredient){
        if ([Utility isEmptyCheck:MealName]){
            
            [Utility msg:@"Please enter meal name" title:@"" controller:self haveToPop:false];
            isValidated = false;
        }else if (_MealType < 0){
            
            [Utility msg:@"Please select meal type" title:@"" controller:self haveToPop:false];
            isValidated = false;
        } else if ([serveTextField.text floatValue] <= 0.0) {
            if (_fromMyPlan) {
                if (planButton.isHidden) {
                    [Utility msg:@"Please enter number of serve greater than 0" title:nil controller:self haveToPop:NO];
                    isValidated = false;
                } else {
                    
                }
            } else {
                [Utility msg:@"Please enter number of serve greater than 0" title:nil controller:self haveToPop:NO];
                isValidated = false;
            }
        }
    }
    
    if(isStaticIngredient){
        if ([unitsButton.titleLabel.text isEqualToString:@"--Units--"]){
            [Utility msg:@"Please choose ingredient unit." title:@"" controller:self haveToPop:false];
            isValidated = false;
            
        }else  if ([ingredientTextfield.text floatValue] <= 0.0){
            [Utility msg:@"Serving size cannot be zero." title:@"" controller:self haveToPop:false];
            isValidated = false;
        }
    }
    
    if(!servingSizeView.isHidden && !ingQuantityView.isHidden){
        
        if ([ingredientTextfield.text floatValue] <= 0.0){
            [Utility msg:@"Serving size cannot be zero." title:@"" controller:self haveToPop:false];
            isValidated = false;
        }
        
    }
    
    return isValidated;
}

-(void)setup_view {
    
    if (!mealListArray){
        mealListArray = [[NSMutableArray alloc]init];
    }
    
    if (!unitListArray){
        unitListArray = [[NSMutableArray alloc]init];
    }
    
//    mealTypeView.layer.cornerRadius = 5.0 ;
//    mealTypeView.clipsToBounds = YES;
    caloriView.hidden = YES;
    beforeEatingMealView.hidden = YES;
    afterEatingMealView.hidden = YES;
    self->previewImageContainer.hidden = true;
    if ([Utility isEmptyCheck:mealDetails] && isAdd){
        //quick add
        trackView.hidden = false;
        addToPlanView.hidden = false;
        updatePlanView.hidden = true;
        noButton.hidden = true;
        calView.hidden = true;
    } else if (![Utility isEmptyCheck:mealDetails] && isAdd){
        //normal add
        trackView.hidden = false;
        addToPlanView.hidden = false;
        updatePlanView.hidden = true;
        noButton.hidden = true;
        calView.hidden = true;
    } else {
        //edit
        trackView.hidden = true;
        addToPlanView.hidden = false;
        updatePlanView.hidden = false;
        calView.hidden = false;
    }
    if (![Utility isEmptyCheck:mealDetails]){
        if(!isStaticIngredient){
            MealId = ![Utility isEmptyCheck:mealDetails[@"MealId"]] ? [mealDetails[@"MealId"] intValue]:0;
            if (MealId == 0){
                MealId = ![Utility isEmptyCheck:mealDetails[@"Id"]] ? [mealDetails[@"Id"] intValue]:0;
            }
            mealServeView.hidden = false;
            ingQuantityView.hidden = true;
            if (![Utility isEmptyCheck:[mealDetails objectForKey:@"Quantity"]]) {
                float quantity = [[mealDetails objectForKey:@"Quantity"]floatValue];
                if (quantity == 0.0 || quantity == -1) {
                    quantity = 1.0;
                }
                serveTextField.text = [@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:quantity]];
                serveMultiplier = quantity;
            }
        }else{
            MealId = ![Utility isEmptyCheck:mealDetails[@"IngredientId"]] ? [mealDetails[@"IngredientId"] intValue]:0;
            if (MealId == 0) {
                MealId = ![Utility isEmptyCheck:mealDetails[@"MealId"]] ? [mealDetails[@"MealId"] intValue]:0;
            }
            if (![Utility isEmptyCheck:[mealDetails objectForKey:@"Quantity"]]) {
                float quantity = [[mealDetails objectForKey:@"Quantity"]floatValue];
                if (quantity == 0.0 || quantity == -1) {
                    quantity = 1.0;
                }
                serveTextField.text = [@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:quantity]];
                serveMultiplier = quantity;
            }
            [self getIngredientUnit];
            ingQuantityView.hidden = false;
            mealServeView.hidden = true;
        }
        NSPredicate *predicate;
        if (isStaticIngredient){
            predicate = [NSPredicate predicateWithFormat:@"(IngredientId = %@)", [NSNumber numberWithInt:MealId]];
            if (!isStatic && ![Utility isEmptyCheck:mealDetails[@"MealId"]] ) {
                predicate = [NSPredicate predicateWithFormat:@"(MealId = %@)", [NSNumber numberWithInt:MealId]];
            }
        }else{
            predicate = [NSPredicate predicateWithFormat:@"(Id = %@)", [NSNumber numberWithInt:MealId]];
            if (!isStatic && ![Utility isEmptyCheck:mealDetails[@"MealId"]] ) {
                predicate = [NSPredicate predicateWithFormat:@"(MealId = %@)", [NSNumber numberWithInt:MealId]];
            }
        }
        NSArray *filteredMealListArray = [mealListArray filteredArrayUsingPredicate:predicate];
        if ([Utility isEmptyCheck:filteredMealListArray]) {
            if (isStaticIngredient){
                predicate = [NSPredicate predicateWithFormat:@"(IngredientId = %d)", MealId];
                if (!isStatic && ![Utility isEmptyCheck:mealDetails[@"MealId"]] ) {
                    predicate = [NSPredicate predicateWithFormat:@"(MealId = %d)", MealId];
                }
            }else{
                predicate = [NSPredicate predicateWithFormat:@"(Id = %d)", MealId];
                if (!isStatic && ![Utility isEmptyCheck:mealDetails[@"MealId"]] ) {
                    predicate = [NSPredicate predicateWithFormat:@"(MealId = %d)", MealId];
                }
            }
            filteredMealListArray = [mealListArray filteredArrayUsingPredicate:predicate];
        }
//        if (filteredMealListArray.count>0){
//            NSDictionary *dict = [filteredMealListArray lastObject];
//            [mealDetails addEntriesFromDictionary:dict];
//        }
//        if (filteredMealListArray.count>0){
//            NSDictionary *dict = [filteredMealListArray lastObject];
//            mealNameButton.tag = [mealListArray indexOfObject:dict];
//            int mealType = [dict[@"MealType"] intValue];
////            if(mealType == 0){
////                [self mealTypeButtonPressed:mealTypeButton[0]];
////            }else
//                if(mealType == 4 || _MealType == 4){
//                [self mealTypeButtonPressed:mealTypeButton[1]];
//            }else{
////                _MealType = 0;
//                [self mealTypeButtonPressed:mealTypeButton[0]];
//            }
////            _MealType = mealType; //Su_chng
//            if(!isStaticIngredient){
//                MealName =![Utility isEmptyCheck:dict[@"MealName"]] ? dict[@"MealName"] :@"";
//            }else{
//                ingredientButton.tag= [mealListArray indexOfObject:dict];
//                MealName =![Utility isEmptyCheck:dict[@"IngredientName"]] ? dict[@"IngredientName"] :@"";
//                if ([Utility isEmptyCheck:MealName]) {
//                    MealName =![Utility isEmptyCheck:dict[@"MealName"]] ? dict[@"MealName"] :@"";
//                }
//                [ingredientButton setTitle:MealName forState:UIControlStateNormal];
//
//            }
//            if (!isEdit) {
//                caloriesTextField.userInteractionEnabled = false;
//                proteinTextField.userInteractionEnabled = false;
//                carbsTextField.userInteractionEnabled= false;
//                fatTextField.userInteractionEnabled = false;
//
//                caloriesTextField.text = ![Utility isEmptyCheck:[mealDetails objectForKey:@"CalsTotal"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"CalsTotal"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"Calories"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"Calories"]floatValue]]]:@"0");
//                proteinTextField.text = ![Utility isEmptyCheck:[mealDetails objectForKey:@"Protein"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"Protein"]floatValue]]]:@"0";
//                carbsTextField.text = ![Utility isEmptyCheck:[mealDetails objectForKey:@"CarbCals"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"CarbCals"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"Carb"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"Carb"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"Carbohydrates"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"Carbohydrates"]floatValue]]]:@"0"));
//                fatTextField.text = ![Utility isEmptyCheck:[dict objectForKey:@"FatCals"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"FatCals"]floatValue]]]:(![Utility isEmptyCheck:[dict objectForKey:@"Fat"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"Fat"]floatValue]]]:@"0");
//            }
//        }else{
        if(!isStaticIngredient){
            MealName =![Utility isEmptyCheck:mealDetails[@"MealName"]] ? [@"" stringByAppendingFormat:@"%@",mealDetails[@"MealName"]] :@"";
            caloriesTextField.text = ![Utility isEmptyCheck:[mealDetails objectForKey:@"CalsTotal"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"CalsTotal"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"TotalCalories"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"TotalCalories"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"Calories"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"Calories"]floatValue]]]:@"0"));
            proteinTextField.text = ![Utility isEmptyCheck:[mealDetails objectForKey:@"Protein"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"Protein"]floatValue]]]:@"0";
            carbsTextField.text = ![Utility isEmptyCheck:[mealDetails objectForKey:@"CarbCals"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"CarbCals"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"Carbohydrates"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"Carbohydrates"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"Carb"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"Carb"]floatValue]]]:@"0"));
            fatTextField.text = ![Utility isEmptyCheck:[mealDetails objectForKey:@"FatCals"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"FatCals"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"Fat"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"Fat"]floatValue]]]:@"0");
        }else{
            ingredientButton.tag= [mealListArray indexOfObject:mealDetails];
            MealName =![Utility isEmptyCheck:mealDetails[@"IngredientName"]] ? mealDetails[@"IngredientName"] :@"";
            if ([Utility isEmptyCheck:MealName]) {
                MealName =![Utility isEmptyCheck:mealDetails[@"MealName"]] ? mealDetails[@"MealName"] :@"";
            }
            [ingredientButton setTitle:MealName forState:UIControlStateNormal];
            caloriesTextField.text = ![Utility isEmptyCheck:[mealDetails objectForKey:@"CalsTotal"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"CalsTotal"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"TotalCalories"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"TotalCalories"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"Calories"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"Calories"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"CalsPer100"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"CalsPer100"]floatValue]]]:@"0")));
            proteinTextField.text = ![Utility isEmptyCheck:[mealDetails objectForKey:@"Protein"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"Protein"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"ProteinPer100"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"ProteinPer100"]floatValue]]]:@"0");
            carbsTextField.text = ![Utility isEmptyCheck:[mealDetails objectForKey:@"CarbCals"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"CarbCals"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"Carbohydrates"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"Carbohydrates"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"Carb"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"Carb"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"CarbsPer100"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"CarbsPer100"]floatValue]]]:@"0")));
            fatTextField.text = ![Utility isEmptyCheck:[mealDetails objectForKey:@"FatCals"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"FatCals"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"Fat"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"Fat"]floatValue]]]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"FatPer100"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"FatPer100"]floatValue]]]:@"0"));
        }
//        }
     
    }else{//quick add or add manually
        if(MealId > 0){
            
            NSPredicate *predicate;
            if (isStaticIngredient){
                predicate = [NSPredicate predicateWithFormat:@"(IngredientId == %d)", MealId];
            }else{
                predicate = [NSPredicate predicateWithFormat:@"(Id == %d)", MealId];
            }
            
            NSArray *filteredMealListArray = [mealListArray filteredArrayUsingPredicate:predicate];
            
            if (filteredMealListArray.count>0){
                NSDictionary *dict = [filteredMealListArray lastObject];
                mealNameButton.tag = [mealListArray indexOfObject:dict];
                int mealType = [dict[@"MealType"] intValue];
//                if(mealType == 0){
//                    [self mealTypeButtonPressed:mealTypeButton[0]];
//                }else
                    if(mealType == 4 || _MealType == 4){
                    [self mealTypeButtonPressed:mealTypeButton[1]];
                }else{
//                    MealType = 0;
                    [self mealTypeButtonPressed:mealTypeButton[0]];
                }
                
                if(!isStaticIngredient){
                    MealName =![Utility isEmptyCheck:dict[@"MealName"]] ? dict[@"MealName"] :@"";
                    [mealNameButton setTitle:MealName forState:UIControlStateNormal];
                }else{
                    ingredientButton.tag= [mealListArray indexOfObject:dict];
                    MealName =![Utility isEmptyCheck:dict[@"IngredientName"]] ? dict[@"IngredientName"] :@"";
                    [ingredientButton setTitle:MealName forState:UIControlStateNormal];
                    [self getIngredientUnit];
                }
                
                
            }
            
            
        }else{
            MealName = @"";
            MealId = 0;
        }
        
    }
    if (_fromMyPlan && ![Utility isEmptyCheck:_planMealData]) {
        caloriesTextField.text = ![Utility isEmptyCheck:[_planMealData objectForKey:@"Calories"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[_planMealData objectForKey:@"Calories"]floatValue]]]:@"0";
        proteinTextField.text = ![Utility isEmptyCheck:[_planMealData objectForKey:@"Protein"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[_planMealData objectForKey:@"Protein"]floatValue]]]:@"0";
        carbsTextField.text = ![Utility isEmptyCheck:[_planMealData objectForKey:@"Carbohydrates"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[_planMealData objectForKey:@"Carbohydrates"]floatValue]]]:@"0";
        fatTextField.text = ![Utility isEmptyCheck:[_planMealData objectForKey:@"Fat"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[_planMealData objectForKey:@"Fat"]floatValue]]]:@"0";
    }
    mealTypeNameLabel.text = MealName;
    //
    if (![Utility isEmptyCheck:[mealDetails objectForKey:@"PhotoSmallPath"]]) {
        NSString *imageString= [@"" stringByAppendingFormat:@"%@",[mealDetails objectForKey:@"PhotoSmallPath"]];
        if (![Utility isEmptyCheck:imageString]) {
            [mealImage sd_setImageWithURL:[NSURL URLWithString:imageString]
                            placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages];  //ah 17.5
        } else {
            mealImage.image = [UIImage imageNamed:@"meal_no_img.png"];
        }
    }else{
        mealImage.image = [UIImage imageNamed:@"meal_no_img.png"];
    }
    //
    uploadButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    uploadButton.layer.borderWidth= 1;
    
    nextButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    nextButton.layer.borderWidth = 1;
    
    noButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    noButton.layer.borderWidth = 1;
    
    //
    
//    if (!isStatic && !isStaticIngredient){
//        [mealNameButton setTitle:MealName forState:UIControlStateNormal];
//        //mealNameButton.enabled = false;
//    }else if(isStatic && !isStaticIngredient && mealTypeData == 1){
//        mealTypeNameLabel.text = @"Squad Recipe List";
//    }else if(isStatic && !isStaticIngredient && mealTypeData == 2){
//        mealTypeNameLabel.text = @"My Recipe List";
//    }else if(isStaticIngredient && mealTypeData == 1){
//        mealTypeNameLabel.text = @"Squad Ingredient List";
//    }else if(isStaticIngredient && mealTypeData == 2){
//        mealTypeNameLabel.text = @"My Ingredient List";
//    }
    
    if (isStaticIngredient){
        
//        unitsButton.userInteractionEnabled = false;
//        ingredientTextfield.userInteractionEnabled = false;
//        caloriLabel.text= @"";
//        self->caloriesTextField.text = @"";
        
        for (UIView *view in viewsArray){
            
            if ([view.accessibilityHint isEqualToString:@"ingredient"]){
                view.hidden = false;
            }else{
                view.hidden = true;
            }
            
            if (!isAdd){
                if ([view.accessibilityHint isEqualToString:@"beforeeating"] || [view.accessibilityHint isEqualToString:@"aftereating"] || [view.accessibilityHint isEqualToString:@"ingredient"]){
                    view.hidden = false;
                }else{
                    view.hidden = true;
                }
            }
        }
    }
    
    mealQuantityButton.tag = 0;
    [mealQuantityButton setTitle:mealQuantityArray[0][@"name"] forState:UIControlStateNormal];
    QuantityId = [mealQuantityArray[0][@"id"] intValue]; // -1
    
    if (![Utility isEmptyCheck:mealDetails] && !isAdd){
        
        mealNameButton.enabled = true;
//        nextButton.enabled = false;
        
        if (!isStaticIngredient){
            
            for (UIView *view in viewsArray){
                
                if ([view.accessibilityHint isEqualToString:@"ingredient"] || [view.accessibilityHint isEqualToString:@"caloriview"]){
                    view.hidden = true;
                }else{
                    view.hidden = false;
                }
            }
            
//            MealType = [mealDetails[@"MealType"] intValue];
            
            for (UIButton *button in mealTypeButton){
                if (button.tag == _MealType){
                    button.selected = true;
                }else{
                    button.selected = false;
                }
            }
            
            
            QuantityId = [mealDetails[@"Quantity"] intValue];
            
            if (QuantityId == 0){
                //mealQuantityButton.tag = 2;
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d",QuantityId];
                NSArray *arr = [mealQuantityArray filteredArrayUsingPredicate:predicate];
                [mealQuantityButton setTitle:[arr firstObject][@"name"] forState:UIControlStateNormal];
                caloriView.hidden = false;
                
//                caloryTextField.text = [@"" stringByAppendingFormat:@"%.2f",![Utility isEmptyCheck:mealDetails[@"Calories"]] ? [mealDetails[@"Calories"] floatValue] :0.0];
                
                mealQuantityButton.tag = [mealQuantityArray indexOfObject:[arr firstObject]];
            }else if (QuantityId == -1){
                //mealQuantityButton.tag = 1;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d",QuantityId];
                NSArray *arr = [mealQuantityArray filteredArrayUsingPredicate:predicate];
                [mealQuantityButton setTitle:[arr firstObject][@"name"] forState:UIControlStateNormal];
                mealQuantityButton.tag = [mealQuantityArray indexOfObject:[arr firstObject]];
            }else if (QuantityId == 1){
                //mealQuantityButton.tag = 0;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d",QuantityId];
                NSArray *arr = [mealQuantityArray filteredArrayUsingPredicate:predicate];
                [mealQuantityButton setTitle:[arr firstObject][@"name"] forState:UIControlStateNormal];
                mealQuantityButton.tag = [mealQuantityArray indexOfObject:[arr firstObject]];
            }
            
        }else{
            
            if(![Utility isEmptyCheck:mealDetails[@"MetricUnit"]]){
                [unitsButton setTitle:mealDetails[@"MetricUnit"] forState:UIControlStateNormal];
            }
            
            if(![Utility isEmptyCheck:mealDetails[@"QtyMetric"]]){
                ingredientTextfield.text = [@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[mealDetails[@"QtyMetric"] floatValue]]];
            }
            
            
            
            //            [dataDict setObject:[NSNumber numberWithDouble:[ingredientTextfield.text floatValue]] forKey:@"QtyMetric"];
            //            [dataDict setObject:unitsButton.titleLabel.text forKey:@"MetricUnit"];
            //            [dataDict setObject:[NSNumber numberWithInt:MealId] forKey:@"IngredientId"];
            //            [dataDict setObject:[NSNumber numberWithDouble:[ingredientTextfield.text floatValue]] forKey:@"IngredientQuantity"];
            //            [dataDict setObject:MealName forKey:@"IngredientName"];
        }
        
        
        
        BeforeEnergy = ![Utility isEmptyCheck:mealDetails[@"BeforeEnergy"]]?[mealDetails[@"BeforeEnergy"] intValue]:0;
        
        for (UIButton *button in beforeMealEnergyButtons){
            
            if (BeforeEnergy == button.tag){
                
                button.selected = YES;
                
            }else{
                
                button.selected = NO;
            }
        }
        
        BeforeCravings = ![Utility isEmptyCheck:mealDetails[@"BeforeCravings"]]?[mealDetails[@"BeforeCravings"] intValue]:0;
        
        for (UIButton *button in beforeMealCravingsButtons){
            
            if (BeforeCravings == button.tag){
                
                button.selected = YES;
                
            }else{
                
                button.selected = NO;
            }
        }
        
        AfterEnergy = ![Utility isEmptyCheck:mealDetails[@"AfterEnergy"]]?[mealDetails[@"AfterEnergy"] intValue]:0;
        
        for (UIButton *button in afterMealEnergyButtons){
            
            if (AfterEnergy == button.tag){
                
                button.selected = YES;
                
            }else{
                
                button.selected = NO;
            }
        }
        
        AfterCravings = ![Utility isEmptyCheck:mealDetails[@"AfterCravings"]]?[mealDetails[@"AfterCravings"] intValue]:0;
        
        for (UIButton *button in afterMealCravingsButtons){
            
            if (AfterCravings == button.tag){
                
                button.selected = YES;
                
            }else{
                
                button.selected = NO;
            }
        }
        
        AfterBloat = ![Utility isEmptyCheck:mealDetails[@"AfterBloat"]]?[mealDetails[@"AfterBloat"] intValue]:0;
        
        for (UIButton *button in bloatButtons){
            
            if (AfterBloat == button.tag){
                
                button.selected = YES;
                
            }else{
                button.selected = NO;
            }
        }
        
        for (UIButton *button in moodPresentButtons){
            button.selected = [[mealDetails objectForKey:button.accessibilityHint] boolValue];
        }
        
        
        
        if(![Utility isEmptyCheck:mealDetails[@"Description"]]){
            furtherNotesTextField.text = mealDetails[@"Description"];
        }
        
        if(![Utility isEmptyCheck:mealDetails[@"Photo"]]){
            
            [previewImageView sd_setImageWithURL:[NSURL URLWithString:mealDetails[@"Photo"]]
                                placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    //                                    selectedImage = previewImageView.image;
                                    
                                    [self loadPreviewImageWithImage:image isNewPic:NO];
                                }];
            [mealImage sd_setImageWithURL:[NSURL URLWithString:mealDetails[@"Photo"]]
                                placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    //                                    selectedImage = previewImageView.image;
                                }];
            
        }
    }
    [self setStackAllignment:YES];
    if(![Utility isEmptyCheck:mealDetails[@"Photo"]]){
        
        [previewImageView sd_setImageWithURL:[NSURL URLWithString:mealDetails[@"Photo"]]
                            placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                //                                    selectedImage = previewImageView.image;
                                
                                [self loadPreviewImageWithImage:image isNewPic:NO];
                                [self setStackAllignment:NO];
                            }];
        
    }else if(![Utility isEmptyCheck:mealDetails[@"PhotoSmallPath"]]){
        
        [previewImageView sd_setImageWithURL:[NSURL URLWithString:mealDetails[@"PhotoSmallPath"]]
                            placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                //                                self->selectedImage = self->previewImageView.image;
                                
                                [self loadPreviewImageWithImage:image isNewPic:NO];
                                [self setStackAllignment:NO];
                            }];
        
    }else if(![Utility isEmptyCheck:mealDetails[@"PhotoPath"]]){
        [previewImageView sd_setImageWithURL:[NSURL URLWithString:mealDetails[@"PhotoPath"]]
                            placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                //                                self->selectedImage = self->previewImageView.image;
                                [self loadPreviewImageWithImage:image isNewPic:NO];
                                [self setStackAllignment:NO];
                            }];
        
    }
    
    NSString *brand = @"";
    if(![Utility isEmptyCheck:mealDetails]){
        brand = ![Utility isEmptyCheck:[mealDetails objectForKey:@"Brand"]]?[@"" stringByAppendingFormat:@"%@",[mealDetails objectForKey:@"Brand"]]:@"";
        if ([Utility isEmptyCheck:brand] && isAdd) {
            if(_actualMealType == Nutritionix){
                brand = @"";
            }else{
                brand = @"Squad";
            }
        }
    }else{
        if(_actualMealType == Quick){
            brand = @"";
        }else{
            brand = @"Squad";
        }
    }
    brandTextField.text = brand;
    if(!isStaticIngredient){
        if (([[mealDetails objectForKey:@"IsEdamam"]boolValue] || _actualMealType == Nutritionix) && ![Utility isEmptyCheck:[mealDetails objectForKey:@"serving_weight_grams"]]) {
            if([Utility isEmptyCheck:[mealDetails objectForKey:@"MetricUnit"]]){
                [unitsButton setTitle:@"gram" forState:UIControlStateNormal];
                ingredientTextfield.text = [@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"serving_weight_grams"]floatValue]]];
                ingQuantityView.hidden = false;
                caloriLabel.text = caloriesTextField.text;
                
                [unitListArray removeAllObjects];
                [unitListArray addObject:@"gram"];
            }
        }else if(_actualMealType == Quick){
            BOOL isMetric;
            if (![Utility isEmptyCheck:[defaults objectForKey:@"UnitPreference"]] && [[defaults objectForKey:@"UnitPreference"]intValue] == 2) {//imperial
                isMetric = false;
            } else {//metric
                isMetric = true;
            }
            if (isAdd && !_quickRecentFreq) {
                if(isMetric){
                    unitListArray = [[NSMutableArray alloc]initWithObjects:@"Grams",@"Mls",@"Cups",@"Tsp",@"tbsp", nil];
                }else{
                    unitListArray = [[NSMutableArray alloc]initWithObjects:@"oz",@"fl.oz",@"Cups",@"Tsp",@"tbsp", nil];
                }
            }else{
                if(isMetric){
                    unitListArray = [[NSMutableArray alloc]initWithObjects:![Utility isEmptyCheck:[mealDetails objectForKey:@"MetricUnit"]]?[@"" stringByAppendingFormat:@"%@",[mealDetails objectForKey:@"MetricUnit"]]:@"Grams", nil];
                }else{
                    unitListArray = [[NSMutableArray alloc]initWithObjects:![Utility isEmptyCheck:[mealDetails objectForKey:@"MetricUnit"]]?[@"" stringByAppendingFormat:@"%@",[mealDetails objectForKey:@"MetricUnit"]]:@"oz", nil];
                }
            }
            
            if(![Utility isEmptyCheck:[mealDetails objectForKey:@"UnitMetric"]]){
                [self->unitsButton setTitle:[@"" stringByAppendingFormat:@"%@",[mealDetails objectForKey:@"UnitMetric"]] forState:UIControlStateNormal];
                self->unitsButton.tag = [unitListArray indexOfObject:[@"" stringByAppendingFormat:@"%@",[mealDetails objectForKey:@"UnitMetric"]]];
                self->ingredientTextfield.userInteractionEnabled = true;
            }else{
                [self->unitsButton setTitle:self->unitListArray[0] forState:UIControlStateNormal];
                self->unitsButton.tag = 0;
                self->ingredientTextfield.userInteractionEnabled = true;
            }
            
        }
    }else{
        
    }
    mealTypeNameLabel.userInteractionEnabled = true;
    brandTextField.userInteractionEnabled = true;
    serveTextField.userInteractionEnabled = true;
    ingredientTextfield.userInteractionEnabled = true;
    
    caloriesTextField.userInteractionEnabled = true;
    proteinTextField.userInteractionEnabled = true;
    carbsTextField.userInteractionEnabled = true;
    fatTextField.userInteractionEnabled = true;
    
    mealTypeNameLabel.textColor = squadMainColor;
    brandTextField.textColor = squadMainColor;
    serveTextField.textColor = squadMainColor;
    ingredientTextfield.textColor = squadMainColor;
    
    caloriesTextField.textColor = squadMainColor;
    proteinTextField.textColor = squadMainColor;
    carbsTextField.textColor = squadMainColor;
    fatTextField.textColor = squadMainColor;
    
    if(_actualMealType == Quick){
        if (!isAdd || _quickRecentFreq) {
            mealTypeNameLabel.userInteractionEnabled = false;
            brandTextField.userInteractionEnabled = false;
            
            caloriesTextField.userInteractionEnabled = false;
            proteinTextField.userInteractionEnabled = false;
            carbsTextField.userInteractionEnabled = false;
            fatTextField.userInteractionEnabled = false;
            
            mealTypeNameLabel.textColor = [Utility colorWithHexString:@"333333"];
            brandTextField.textColor = [Utility colorWithHexString:@"333333"];
            
            caloriesTextField.textColor = [Utility colorWithHexString:@"333333"];
            proteinTextField.textColor = [Utility colorWithHexString:@"333333"];
            carbsTextField.textColor = [Utility colorWithHexString:@"333333"];
            fatTextField.textColor = [Utility colorWithHexString:@"333333"];
            
            editButtonView.hidden = false;
        } else {
            
            serveTextField.userInteractionEnabled = false;
            serveTextField.textColor = [Utility colorWithHexString:@"333333"];
            editButtonView.hidden = true;
        }
        
    }else if(_actualMealType == Nutritionix){
        
        mealTypeNameLabel.userInteractionEnabled = false;
        brandTextField.userInteractionEnabled = false;
        serveTextField.userInteractionEnabled = true;
        ingredientTextfield.userInteractionEnabled = true;
        
        caloriesTextField.userInteractionEnabled = false;
        proteinTextField.userInteractionEnabled = false;
        carbsTextField.userInteractionEnabled = false;
        fatTextField.userInteractionEnabled = false;
        
        mealTypeNameLabel.textColor = [Utility colorWithHexString:@"333333"];
        brandTextField.textColor = [Utility colorWithHexString:@"333333"];
        serveTextField.textColor = squadMainColor;
        ingredientTextfield.textColor = squadMainColor;
        
        caloriesTextField.textColor = [Utility colorWithHexString:@"333333"];
        proteinTextField.textColor = [Utility colorWithHexString:@"333333"];
        carbsTextField.textColor = [Utility colorWithHexString:@"333333"];
        fatTextField.textColor = [Utility colorWithHexString:@"333333"];
    }else if(_actualMealType == SqMeal){
        
        mealTypeNameLabel.userInteractionEnabled = false;
        brandTextField.userInteractionEnabled = false;
        serveTextField.userInteractionEnabled = true;//_fromMyPlan?false:true;
        ingredientTextfield.userInteractionEnabled = false;
        
        caloriesTextField.userInteractionEnabled = false;
        proteinTextField.userInteractionEnabled = false;
        carbsTextField.userInteractionEnabled = false;
        fatTextField.userInteractionEnabled = false;
        
        mealTypeNameLabel.textColor = [Utility colorWithHexString:@"333333"];
        brandTextField.textColor = [Utility colorWithHexString:@"333333"];
        serveTextField.textColor = squadMainColor;//_fromMyPlan?[Utility colorWithHexString:@"333333"]:squadMainColor;
        ingredientTextfield.textColor = [Utility colorWithHexString:@"333333"];
        
        caloriesTextField.textColor = [Utility colorWithHexString:@"333333"];
        proteinTextField.textColor = [Utility colorWithHexString:@"333333"];
        carbsTextField.textColor = [Utility colorWithHexString:@"333333"];
        fatTextField.textColor = [Utility colorWithHexString:@"333333"];
    }else if(_actualMealType == SqIngredient){
        
        mealTypeNameLabel.userInteractionEnabled = false;
        brandTextField.userInteractionEnabled = false;
        serveTextField.userInteractionEnabled = true;
        ingredientTextfield.userInteractionEnabled = true;
        
        caloriesTextField.userInteractionEnabled = false;
        proteinTextField.userInteractionEnabled = false;
        carbsTextField.userInteractionEnabled = false;
        fatTextField.userInteractionEnabled = false;
        
        mealTypeNameLabel.textColor = [Utility colorWithHexString:@"333333"];
        brandTextField.textColor = [Utility colorWithHexString:@"333333"];
        serveTextField.textColor = squadMainColor;
        ingredientTextfield.textColor = squadMainColor;
        
        caloriesTextField.textColor = [Utility colorWithHexString:@"333333"];
        proteinTextField.textColor = [Utility colorWithHexString:@"333333"];
        carbsTextField.textColor = [Utility colorWithHexString:@"333333"];
        fatTextField.textColor = [Utility colorWithHexString:@"333333"];
    }else{
        mealTypeNameLabel.userInteractionEnabled = false;
        brandTextField.userInteractionEnabled = false;
        
        caloriesTextField.userInteractionEnabled = false;
        proteinTextField.userInteractionEnabled = false;
        carbsTextField.userInteractionEnabled = false;
        fatTextField.userInteractionEnabled = false;
        
        caloriesTextField.textColor = [Utility colorWithHexString:@"333333"];
        proteinTextField.textColor = [Utility colorWithHexString:@"333333"];
        carbsTextField.textColor = [Utility colorWithHexString:@"333333"];
        fatTextField.textColor = [Utility colorWithHexString:@"333333"];
        
        serveTextField.userInteractionEnabled = false;
        ingredientTextfield.userInteractionEnabled = false;//quantity
    }
    self->ingredientTextfield.text = ![Utility isEmptyCheck:[mealDetails objectForKey:@"QtyMetric"]]?[@""stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"QtyMetric"]floatValue]]]:@"0";
    if (ingredientTextfield.text.floatValue <= 0.0) {
        self->ingredientTextfield.text = ![Utility isEmptyCheck:[mealDetails objectForKey:@"serving_weight_grams"]]?[@""stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[mealDetails objectForKey:@"serving_weight_grams"]floatValue]]]:@"0";
    }else{
        [mealDetails setObject:[mealDetails objectForKey:@"QtyMetric"] forKey:@"serving_weight_grams"];
    }
    if(![Utility isEmptyCheck:mealDetails[@"MetricUnit"]]){
        [unitsButton setTitle:mealDetails[@"MetricUnit"] forState:UIControlStateNormal];
    }
    if (_actualMealType == Quick) {
        unitLabel.text = @"Serving unit:";
    } else {
        unitLabel.text = @"Unit:";
    }
    //show hide extra mandetory views
    if (_actualMealType == Quick) {
        ingQuantityView.hidden = false;
    } else if (_actualMealType == Nutritionix) {
        [mealDetails setObject:[NSNumber numberWithBool:true] forKey:@"IsEdamam"];
        if (![Utility isEmptyCheck:[mealDetails objectForKey:@"QtyMetric"]] || ![Utility isEmptyCheck:[mealDetails objectForKey:@"serving_weight_grams"]] || ![Utility isEmptyCheck:[mealDetails objectForKey:@"MetricUnit"]]){
            ingQuantityView.hidden = false;
        }
        if (![Utility isEmptyCheck:[mealDetails objectForKey:@"QtyMetric"]] || ![Utility isEmptyCheck:[mealDetails objectForKey:@"serving_weight_grams"]]) {
            servingSizeView.hidden = false;
        }else{
            servingSizeView.hidden = true;
        }
        if([Utility isEmptyCheck:[mealDetails objectForKey:@"serving_weight_grams"]] && ![Utility isEmptyCheck:[mealDetails objectForKey:@"QtyMetric"]]){
            [mealDetails setObject:[mealDetails objectForKey:@"QtyMetric"] forKey:@"serving_weight_grams"];
        }
        if(![Utility isEmptyCheck:[mealDetails objectForKey:@"serving_weight_grams"]] && [Utility isEmptyCheck:[mealDetails objectForKey:@"QtyMetric"]]){
            [mealDetails setObject:[mealDetails objectForKey:@"serving_weight_grams"] forKey:@"QtyMetric"];
        }
    } else if (_actualMealType == SqIngredient) {
        mealServeView.hidden = false;
        for (UIView *view in viewsArray) {
            if ([view.accessibilityHint isEqualToString:@"mealname"]) {
                view.hidden = false;
                break;
            }
        }
    }
    float planQuantity = ![Utility isEmptyCheck:[mealDetails objectForKey:@"Quantity"]]?[[mealDetails objectForKey:@"Quantity"]floatValue]:0;
    if (_fromMyPlan || planQuantity == -1) {
        serveMultiplier = planQuantity;
        serveTextField.text = @"as per meal plan";
        serveTextField.userInteractionEnabled = false;
        serveTextField.textColor = [Utility colorWithHexString:@"333333"];
        planButton.hidden = false;
    }
    if (self->unitListArray.count>1) {
        [self->arrButton setImage:[UIImage imageNamed:@"dropdown_arrow_left.png"] forState:UIControlStateNormal];
        [self->unitsButton setTitleColor:squadMainColor forState:UIControlStateNormal];
        self->unitsButton.userInteractionEnabled = true;
    }else{
        [self->arrButton setImage:nil forState:UIControlStateNormal];
        [self->unitsButton setTitleColor:squadSubColor forState:UIControlStateNormal];
        self->unitsButton.userInteractionEnabled = false;
    }
}
-(void)setStackAllignment:(BOOL)isAdd{//send isAdd = true, when there is no image
    if (isAdd) {
        nutritionStackView.axis = UILayoutConstraintAxisVertical;
        nutritionStackView.spacing = 20.0;
        for (UIStackView *stackView in pcfStackViews) {
            stackView.axis = UILayoutConstraintAxisHorizontal;
            stackView.spacing = 10.0;
        }
    } else {
        nutritionStackView.axis = UILayoutConstraintAxisHorizontal;
        nutritionStackView.spacing = 0.0;
        for (UIStackView *stackView in pcfStackViews) {
            stackView.axis = UILayoutConstraintAxisVertical;
            stackView.spacing = 0.0;
        }
    }
}
- (void)openEditor
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = selectedImage;
    controller.keepingCropAspectRatio = YES;
    controller.cropAspectRatio = 2.0/3.0;
    
    //        UIImage *image = selectedImage;
    //        CGFloat width = image.size.width;
    //        CGFloat height = image.size.height;
    //        CGFloat length = MIN(width, height);
    //        controller.imageCropRect = CGRectMake((width - length) / 2,
    //                                              (height - length) / 2,
    //                                              length/2,
    //                                              length);
    
    
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

-(NSMutableDictionary *)createAddUpdateData{
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
    
    //chayan 23/10/2017 selected image part not needed as multipart
    //    if (![Utility isEmptyCheck:selectedImage]) {
    //        NSString *imgBase64Str = [UIImagePNGRepresentation(selectedImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //        [dataDict setObject:imgBase64Str forKey:@"Photo"];
    //    }else{
    //        [dataDict setObject:@"" forKey:@"Photo"];
    //    }
    [dataDict setObject:@"" forKey:@"Photo"];
    
    
    if(!isStaticIngredient){//meal
        
        if ([[mealDetails objectForKey:@"IsEdamam"]boolValue] || _actualMealType == Nutritionix) {
            if (![Utility isEmptyCheck:[mealDetails objectForKey:@"MealId"]]) {
                [dataDict setObject:[mealDetails objectForKey:@"MealId"] forKey:@"EdamamdFoodId"];
            }else if(![Utility isEmptyCheck:[mealDetails objectForKey:@"EdamamdFoodId"]]){
                [dataDict setObject:[mealDetails objectForKey:@"EdamamdFoodId"] forKey:@"EdamamdFoodId"];
            }
            [dataDict setObject:MealName forKey:@"EdamamFoodName"];
            [dataDict setObject:MealName forKey:@"MealName"];
            
            if (isAdd) {//only for edamam on adding ... used back in recent frequent
//                [dataDict setObject:[NSDecimalNumber decimalNumberWithString:[Utility customRoundNumber:(carbsTextField.text.floatValue/serveMultiplier)]] forKey:@"CarbsPer100"];
//                [dataDict setObject:[NSDecimalNumber decimalNumberWithString:[Utility customRoundNumber:(fatTextField.text.floatValue/serveMultiplier)]] forKey:@"FatPer100"];
//                [dataDict setObject:[NSDecimalNumber decimalNumberWithString:[Utility customRoundNumber:(proteinTextField.text.floatValue/serveMultiplier)]] forKey:@"ProteinPer100"];
                //TODO:nutritionix per100 at add time
                [dataDict setObject:[NSNumber numberWithFloat:([carbsTextField.text stringByReplacingOccurrencesOfString:@"," withString:@""].floatValue/serveMultiplier)] forKey:@"CarbsPer100"];
                [dataDict setObject:[NSNumber numberWithFloat:([fatTextField.text stringByReplacingOccurrencesOfString:@"," withString:@""].floatValue/serveMultiplier)] forKey:@"FatPer100"];
                [dataDict setObject:[NSNumber numberWithFloat:([proteinTextField.text stringByReplacingOccurrencesOfString:@"," withString:@""].floatValue/serveMultiplier)] forKey:@"ProteinPer100"];
                
                [dataDict setObject:[NSNumber numberWithFloat:([caloriesTextField.text stringByReplacingOccurrencesOfString:@"," withString:@""].floatValue/serveMultiplier)] forKey:@"CaloriesPer100"];
            }
        }else if (_actualMealType == Quick){
            
            [dataDict setObject:MealName forKey:@"MealName"];
        }else{
            if (MealId>0) {
                [dataDict setObject:[NSNumber numberWithInt:MealId] forKey:@"MealId"];
            }
            [dataDict setObject:MealName forKey:@"MealName"];
        }
        
//        if(QuantityId == -1){
//        [dataDict setObject:[NSDecimalNumber decimalNumberWithString:[Utility customRoundNumber:(carbsTextField.text.floatValue/serveMultiplier)]] forKey:@"Carb"];
//        [dataDict setObject:[NSDecimalNumber decimalNumberWithString:[Utility customRoundNumber:(proteinTextField.text.floatValue/serveMultiplier)]] forKey:@"Protein"];
//        [dataDict setObject:[NSDecimalNumber decimalNumberWithString:[Utility customRoundNumber:(fatTextField.text.floatValue/serveMultiplier)]] forKey:@"Fat"];
        
        //TODO:always for meal
        [dataDict setObject:[NSNumber numberWithFloat:([carbsTextField.text stringByReplacingOccurrencesOfString:@"," withString:@""].floatValue/serveMultiplier)] forKey:@"Carb"];
        [dataDict setObject:[NSNumber numberWithFloat:([proteinTextField.text stringByReplacingOccurrencesOfString:@"," withString:@""].floatValue/serveMultiplier)] forKey:@"Protein"];
        [dataDict setObject:[NSNumber numberWithFloat:([fatTextField.text stringByReplacingOccurrencesOfString:@"," withString:@""].floatValue/serveMultiplier)] forKey:@"Fat"];
        
        NSLog(@"Calorie:%f",caloriesTextField.text.floatValue);
        [dataDict setObject:[NSNumber numberWithFloat:([caloriesTextField.text stringByReplacingOccurrencesOfString:@"," withString:@""].floatValue/serveMultiplier)] forKey:@"Calories"];
            //            [dataDict setObject:[NSNumber numberWithInt:-1] forKey:@"Quantity"];
//        }
        [dataDict setObject:[NSNumber numberWithDouble:[ingredientTextfield.text floatValue]] forKey:@"QuantityMetric"];
        [dataDict setObject:[NSNumber numberWithDouble:[ingredientTextfield.text floatValue]] forKey:@"QtyMetric"];
        if ([ingredientTextfield.text floatValue]>0.0 && ![Utility isEmptyCheck:unitsButton.titleLabel.text]) {
            [dataDict setObject:unitsButton.titleLabel.text forKey:@"MetricUnit"];
        }
//        [dataDict setObject:[NSNumber numberWithInt:QuantityId] forKey:@"Quantity"];
        
//        if (QuantityId == 0){
//            NSString *calori = caloriesTextField.text;//caloryTextField.text;
//            [dataDict setObject:[NSNumber numberWithFloat:[calori floatValue]] forKey:@"Calories"];
//        }
        
        [dataDict setObject:[NSNumber numberWithFloat:serveMultiplier] forKey:@"Quantity"];
        if (_actualMealType == SqMeal) {
            [dataDict setObject:MealName forKey:@"MealName"];
        } else if (_actualMealType == Quick) {
            if(!isAdd && ![Utility isEmptyCheck:[mealDetails objectForKey:@"PersonalFoodId"]]){
                [dataDict setObject:[mealDetails objectForKey:@"PersonalFoodId"] forKey:@"PersonalFoodId"];
            } else if(!isAdd && ![Utility isEmptyCheck:[mealDetails objectForKey:@"MealId"]]){
                [dataDict setObject:[mealDetails objectForKey:@"MealId"] forKey:@"PersonalFoodId"];
            }
            [dataDict setObject:MealName forKey:@"PersonalFoodName"];
            [dataDict setObject:MealName forKey:@"MealName"];
        } else if (_actualMealType == Nutritionix) {
            [dataDict setObject:MealName forKey:@"EdamamFoodName"];
            [dataDict setObject:MealName forKey:@"MealName"];
        }
    }else{//ingredient
        
        [dataDict setObject:[NSNumber numberWithDouble:[ingredientTextfield.text floatValue]] forKey:@"QtyMetric"];
        [dataDict setObject:unitsButton.titleLabel.text forKey:@"MetricUnit"];
        [dataDict setObject:[NSNumber numberWithInt:MealId] forKey:@"IngredientId"];
//        [dataDict setObject:[NSNumber numberWithDouble:[ingredientTextfield.text floatValue]] forKey:@"IngredientQuantity"];
        [dataDict setObject:MealName forKey:@"IngredientName"];
        
//        [dataDict setObject:[NSDecimalNumber decimalNumberWithString:[Utility customRoundNumber:(carbsTextField.text.floatValue/serveMultiplier)]] forKey:@"Carb"];
//        [dataDict setObject:[NSDecimalNumber decimalNumberWithString:[Utility customRoundNumber:(proteinTextField.text.floatValue/serveMultiplier)]] forKey:@"Protein"];
//        [dataDict setObject:[NSDecimalNumber decimalNumberWithString:[Utility customRoundNumber:(fatTextField.text.floatValue/serveMultiplier)]] forKey:@"Fat"];
        
        //TODO:always for ing
        [dataDict setObject:[NSNumber numberWithFloat:([carbsTextField.text stringByReplacingOccurrencesOfString:@"," withString:@""].floatValue/serveMultiplier)] forKey:@"Carb"];
        [dataDict setObject:[NSNumber numberWithFloat:([proteinTextField.text stringByReplacingOccurrencesOfString:@"," withString:@""].floatValue/serveMultiplier)] forKey:@"Protein"];
        [dataDict setObject:[NSNumber numberWithFloat:([fatTextField.text stringByReplacingOccurrencesOfString:@"," withString:@""].floatValue/serveMultiplier)] forKey:@"Fat"];
        
        [dataDict setObject:[NSNumber numberWithFloat:([caloriesTextField.text stringByReplacingOccurrencesOfString:@"," withString:@""].floatValue/serveMultiplier)] forKey:@"Calories"];
        
        [dataDict setObject:[NSNumber numberWithFloat:serveMultiplier] forKey:@"Quantity"];
    }
    
    [dataDict setObject:brandTextField.text forKey:@"Brand"];
    [dataDict setObject:[NSNumber numberWithInt:_MealType] forKey:@"MealType"];
    
    //    [dataDict setObject:[NSNumber numberWithInt:mealCategory] forKey:@"MealCatagory"];
    [dataDict setObject:[NSNumber numberWithInt:BeforeEnergy] forKey:@"BeforeEnergy"];
    [dataDict setObject:[NSNumber numberWithInt:BeforeCravings] forKey:@"BeforeCravings"];
    [dataDict setObject:[NSNumber numberWithInt:AfterEnergy] forKey:@"AfterEnergy"];
    [dataDict setObject:[NSNumber numberWithInt:AfterCravings] forKey:@"AfterCravings"];
    [dataDict setObject:[NSNumber numberWithInt:AfterBloat] forKey:@"AfterBloat"];
//    [dataDict setObject:furtherNotesTextField.text forKey:@"Description"]; //Su_Chng
    NSDateFormatter *df = [NSDateFormatter new];
    NSString *timeString = @"00:00:00";
    [df setDateFormat:@"HH:mm:ss"];
    timeString = [df stringFromDate:[NSDate date]];
    [df setDateFormat:@"yyyy-MM-dd"];
    if (isAdd){
        
        if (![Utility isEmptyCheck:currentDate]) {
            NSString *dateString = [[df stringFromDate:currentDate] stringByAppendingFormat:@" %@",timeString];
            [dataDict setObject:dateString forKey:@"DateTime"];
//            [dataDict setObject:dateString forKey:@"DateAdded"];
            
        }
        
    }else{
        //chayan
        if (isNextButtonPressed) {
            [dataDict setObject:[NSNumber numberWithInt:savedMealId] forKey:@"Id"];
        } else if (![Utility isEmptyCheck:mealDetails]){
            [dataDict setObject:[NSNumber numberWithInt:[mealDetails[@"Id"] intValue]] forKey:@"Id"];
            
//            NSString *dateAdded = mealDetails[@"DateAdded"];
//            [dataDict setObject:dateAdded forKey:@"DateTime"];
        }
        if (![Utility isEmptyCheck:currentDate]) {
            NSString *dateString = [[df stringFromDate:currentDate] stringByAppendingFormat:@" %@",timeString];
            [dataDict setObject:dateString forKey:@"DateTime"];
        }
    }
    
    for (UIButton *button in moodPresentButtons){
            [dataDict setObject:[NSNumber numberWithBool:button.isSelected] forKey:button.accessibilityHint];
    }
    if (_fromMyPlan) {
//        [dataDict removeObjectForKey:@"Calories"];
        if (planButton.isHidden) {
            [dataDict setObject:[NSNumber numberWithFloat:serveMultiplier] forKey:@"Quantity"];
        }else{
            [dataDict setObject:[NSNumber numberWithInt:-1] forKey:@"Quantity"];
        }
    }
    if([[dataDict objectForKey:@"Quantity"]intValue] == -1){
        [dataDict removeObjectForKey:@"Calories"];
        [dataDict removeObjectForKey:@"Carb"];
        [dataDict removeObjectForKey:@"Protein"];
        [dataDict removeObjectForKey:@"Fat"];
    }
    
    if(!selectedImage){
        if([[mealDetails objectForKey:@"IsEdamam"]boolValue]){
            
            if (![Utility isEmptyCheck:mealDetails[@"PhotoPath"]]) {
               [dataDict setObject:[@"" stringByAppendingFormat:@"%@",mealDetails[@"PhotoPath"]] forKey:@"EdamamPhotoPath"];
            }
        }
    }
    
    
    return dataDict;
    
}
-(void)backToMealMatch{
    NSArray *controllers = [self.navigationController viewControllers];
    if (delegate == nil && isChanged) {
        for (UIViewController *mealCont in controllers) {
            if ([mealCont isKindOfClass:[MealMatchViewController class]]) {
                delegate = (MealMatchViewController *)mealCont;
            }
        }
    }
    if ([delegate respondsToSelector:@selector(didCheckAnyChangeForMealAdd:with:)]) {
        [delegate didCheckAnyChangeForMealAdd:isChanged with:YES];
    }
    if(controllers.count > 3 && [[controllers objectAtIndex:controllers.count-3] isKindOfClass:[MealMatchViewController class]]){
        [self.navigationController popToViewController:[controllers objectAtIndex:controllers.count-3] animated:true];
    }else if(controllers.count > 4 &&[[controllers objectAtIndex:controllers.count-4] isKindOfClass:[MealMatchViewController class]]){
        [self.navigationController popToViewController:[controllers objectAtIndex:controllers.count-4] animated:true];
    }
    else if(controllers.count > 5 && [[controllers objectAtIndex:controllers.count-5] isKindOfClass:[MealMatchViewController class]]){
        [self.navigationController popToViewController:[controllers objectAtIndex:controllers.count-5] animated:true];
    }
    else if(controllers.count > 6 && [[controllers objectAtIndex:controllers.count-6] isKindOfClass:[MealMatchViewController class]]){
        [self.navigationController popToViewController:[controllers objectAtIndex:controllers.count-6] animated:true];
    }
    else {
        [self.navigationController popViewControllerAnimated:true];
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
        [mainDict setObject:[NSNumber numberWithInt:pageNo] forKey:@"PageNo"];
        [mainDict setObject:[NSNumber numberWithInt:15] forKey:@"ItemsPerPage"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        if (!isClick) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->apiCount++;
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
                
                self->contentView = [Utility activityIndicatorView:self];
                //contentView.backgroundColor = [UIColor clearColor];
                
            });
        }
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
                                                                         if(![Utility isEmptyCheck:responseDict[@"SquadUserActualMealList"]]){
                                                                             
                                                                             //                                                                             MealAddViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MealAddView"];
                                                                             //
                                                                             //                                                                             controller.currentDate = currentDate;
                                                                             //                                                                             controller.isAdd = true;
                                                                             //                                                                             controller.isStatic = isStatic;
                                                                             //                                                                             controller.mealTypeData = mealTypeData;
                                                                             //                                                                             controller.mealDetails = mealdetails;
                                                                             //                                                                             controller.mealListArray = responseDict[@"SquadUserActualMealList"];
                                                                             //                                                                             //                                                                             controller.mealCategory = mealCategory;
                                                                             //                                                                             [self.navigationController pushViewController:controller animated:true];
                                                                             if (!self->mealListArray) {
                                                                                 self->mealListArray = [[NSMutableArray alloc]init];
                                                                             }
                                                                             NSArray *tempArray = [responseDict objectForKey:@"SquadUserActualMealList"];
                                                                             if(![Utility isEmptyCheck:tempArray])[self->mealListArray addObjectsFromArray: tempArray];
                                                                             self->mealTable.hidden = false;
                                                                             [self->mealTable reloadData];
                                                                             [self setup_view];
                                                                         }
                                                                         
                                                                     }
                                                                     else{
                                                                         self->pageNo--;
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     self->pageNo--;
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

-(void)getIngredientList:(int)mealTypeData mealName:(NSDictionary *)mealdetails isStatic:(BOOL)isStatic{
    
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
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetIngredientsApiCall" append:@""forAction:@"POST"];
        
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
                                                                         
                                                                         
                                                                         //                                                                         MealAddViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MealAddView"];
                                                                         //                                                                         controller.currentDate = currentDate;
                                                                         //                                                                         controller.isAdd = true;
                                                                         //                                                                         controller.isStatic = isStatic;
                                                                         //                                                                         controller.isStaticIngredient = true;
                                                                         //                                                                         controller.mealTypeData = mealTypeData;
                                                                         //                                                                         controller.mealDetails = mealdetails;
                                                                         //                                                                         controller.mealListArray = [responseDict objectForKey:@"Ingredients"];
                                                                         //                                                                         [self.navigationController pushViewController:controller animated:true];
                                                                         if (!self->mealListArray) {
                                                                             self->mealListArray = [[NSMutableArray alloc]init];
                                                                         }
                                                                         NSArray *tempArray = [responseDict objectForKey:@"Ingredients"];
                                                                         if(![Utility isEmptyCheck:tempArray])[self->mealListArray addObjectsFromArray: tempArray];
                                                                         [self setup_view];
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
        if ([delegate respondsToSelector:@selector(didCheckAnyChangeForMealAdd:with:)]) {
            [delegate didCheckAnyChangeForMealAdd:isChanged with:NO];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)loadPreviewImageWithImage:(UIImage *)image isNewPic:(BOOL)isNewPic{
    
    [uploadButton setTitle:@"UPLOAD" forState:UIControlStateNormal];
    if(isNewPic){
        self->previewImageContainer.hidden = false;
        self->previewImageContainer1.hidden = false;
        [uploadButton setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
        return;
    }
    
    if(!image){
        self->previewImageContainer.hidden = true;
        self->previewImageContainer1.hidden = true;
    }else if(image && self->isAdd){
        self->previewImageContainer.hidden = false;
        self->previewImageContainer1.hidden = true;
    }else{
        self->previewImageContainer.hidden = false;
        self->previewImageContainer1.hidden = false;
        [uploadButton setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
    }
    
}
#pragma mark -End

#pragma mark -Webservice Call
-(void)addUpdateActualMealMatch:(bool)isNext{
    
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (![Utility isEmptyCheck:currentDate] && isAdd) {
            NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
            [mainDict setObject:dateString forKey:@"Datetime"];
        }
        
        [mainDict setObject:[NSNumber numberWithInt:mealTypeData] forKey:@"RecipeMealTracker"];
        [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"MealOrder"];
        
        [mainDict setObject:[self createAddUpdateData] forKey:@"SquadUserActualMealModel"];
        
        
        
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddSquadUserActualMeal" append:@""forAction:@"POST"];
        
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
                                                                     
                                                                     NSLog(@"%@",responseDict);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         //chayan
                                                                         if (isNext) {
                                                                             self->savedMealId=[responseDict[@"Id"] intValue];
                                                                             self->isAdd=NO;
                                                                             self->isNextButtonPressed=YES;
                                                                             self->beforeEatingMealView.hidden = NO;
                                                                             self->afterEatingMealView.hidden = NO;
//                                                                             nextButton.enabled = NO;
                                                                             self->mealNameButton.enabled = true;
                                                                         }
                                                                         else{
                                                                             [self backToMealMatch];
                                                                             
                                                                         }
                                                                         
                                                                         
                                                                         
                                                                         
                                                                         //                                                                         [Utility msg:@"Meal added successfully" title:@"Success" controller:self haveToPop:NO];
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


//chayan 23/10/2017
-(void)addUpdateActualMealMatchMultiPart:(bool)isNext{
    
    if (Utility.reachable) {
        
        isNextMultiPart=isNext;
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (![Utility isEmptyCheck:currentDate]){// && isAdd) {
//            NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
            NSDateFormatter *df = [NSDateFormatter new];
            NSString *timeString = @"00:00:00";
            [df setDateFormat:@"HH:mm:ss"];
            timeString = [df stringFromDate:[NSDate date]];
            [df setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [[df stringFromDate:currentDate] stringByAppendingFormat:@" %@",timeString];
            [mainDict setObject:dateString forKey:@"Datetime"];
        }
        
//        if (caloriesTextField.text.length>0 && [caloriesTextField.text floatValue]>0) {
//            [mainDict setObject:[NSNumber numberWithFloat:[caloriesTextField.text floatValue]] forKey:@"TotalCalorie"];
//        }
//        if (fatTextField.text.length>0 && [fatTextField.text floatValue]>0) {
//            [mainDict setObject:[NSNumber numberWithFloat:[fatTextField.text floatValue]] forKey:@"TotalFat"];
//        }
//        if (carbsTextField.text.length>0 && [carbsTextField.text floatValue]>0) {
//            [mainDict setObject:[NSNumber numberWithFloat:[carbsTextField.text floatValue]] forKey:@"TotalCarb"];
//        }
//        if (proteinTextField.text.length>0 && [proteinTextField.text floatValue]>0) {
//            [mainDict setObject:[NSNumber numberWithFloat:[proteinTextField.text floatValue]] forKey:@"TotalProtein"];
//        }
        
        [mainDict setObject:[NSNumber numberWithInt:mealTypeData] forKey:@"RecipeMealTracker"];
        [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"MealOrder"];
        [mainDict setObject:[self createAddUpdateData] forKey:@"SquadUserActualMealModel"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddSquadUserActualMealWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.chosenImage=selectedImage;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}



-(void)getActualMealMatchData{
    
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (![Utility isEmptyCheck:currentDate]) {
            NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
            [mainDict setObject:dateString forKey:@"Datetime"];
        }
        
        [mainDict setObject:[NSNumber numberWithInt:mealTypeData] forKey:@"RecipeMealTracker"];
        [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"MealOrder"];
        
        [mainDict setObject:[self createAddUpdateData] forKey:@"SquadUserActualMealModel"];
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMyDaySquadUserActualMeal" append:@""forAction:@"POST"];
        
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
                                                                     
                                                                     NSLog(@"%@",responseDict);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         [self backToMealMatch];
                                                                         
                                                                         //                                                                         [Utility msg:@"Meal added successfully" title:@"Success" controller:self haveToPop:NO];
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

-(void)getIngredientUnit{
    
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:MealId] forKey:@"IngredientId"];
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetIngredientById" append:@""forAction:@"POST"];
        
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
                                                                     
//                                                                     NSLog(@"%@",responseDict);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         if (![Utility isEmptyCheck:responseDict[@"IngredientDetail"]]){
                                                                             
                                                                             NSDictionary *dict = responseDict[@"IngredientDetail"];
                                                                             int unitPrefererence = [[defaults objectForKey:@"UnitPreference"] intValue];
                                                                             
                                                                             [self->unitListArray removeAllObjects];
                                                                             self->unitsButton.userInteractionEnabled = true;
                                                                             
                                                                             if (unitPrefererence == 0 || unitPrefererence == 1){
                                                                                 
                                                                                 if (![Utility isEmptyCheck:dict[@"UnitMetric"]]){
                                                                                     [self->unitListArray addObject:dict[@"UnitMetric"]] ;                                                                }
                                                                                 
                                                                                 
                                                                                 if (![Utility isEmptyCheck:dict[@"ConversionUnit"]]){
                                                                                     [self->unitListArray addObject:dict[@"ConversionUnit"]] ;                                                                }
                                                                                 
                                                                                 
                                                                             }else{
                                                                                 if (![Utility isEmptyCheck:dict[@"UnitImperial"]]){
                                                                                     [self->unitListArray addObject:dict[@"UnitImperial"]] ;                                                                }
                                                                                 
                                                                                 
                                                                                 if (![Utility isEmptyCheck:dict[@"ConversionUnit"]]){
                                                                                     [self->unitListArray addObject:dict[@"ConversionUnit"]] ;                                                                }
                                                                                 
                                                                             }
                                                                             
                                                                             if (self->unitListArray.count >= 1){
                                                                                 [self->unitsButton setTitle:self->unitListArray[0] forState:UIControlStateNormal];
                                                                                 self->unitsButton.tag = 0;
                                                                                 self->ingredientTextfield.userInteractionEnabled = true;
                                                                                 if([Utility isEmptyCheck:[self->mealDetails objectForKey:@"QtyMetric"]]){
                                                                                     int unitPrefererence = [[defaults objectForKey:@"UnitPreference"] intValue];
                                                                                     if (unitPrefererence ==0 || unitPrefererence ==1) {
                                                                                         self->ingredientTextfield.text = @"100";
                                                                                         [self->mealDetails setObject:[NSNumber numberWithFloat:100.0] forKey:@"QtyMetric"];
                                                                                     }else{
                                                                                         self->ingredientTextfield.text = @"3.53";
                                                                                         [self->mealDetails setObject:[NSNumber numberWithFloat:3.53] forKey:@"QtyMetric"];
                                                                                     }
                                                                                 }
                                                                             }
                                                                             
                                                                             if (self->unitListArray.count>1) {
                                                                                 [self->arrButton setImage:[UIImage imageNamed:@"dropdown_arrow_left.png"] forState:UIControlStateNormal];
                                                                                 [self->unitsButton setTitleColor:squadMainColor forState:UIControlStateNormal];
                                                                                 self->unitsButton.userInteractionEnabled = true;
                                                                             }else{
                                                                                 [self->arrButton setImage:nil forState:UIControlStateNormal];
                                                                                 [self->unitsButton setTitleColor:squadSubColor forState:UIControlStateNormal];
                                                                                 self->unitsButton.userInteractionEnabled = false;
                                                                             }
                                                                             if(![Utility isEmptyCheck:self->mealDetails[@"MetricUnit"]]){
                                                                                 [self->unitsButton setTitle:self->mealDetails[@"MetricUnit"] forState:UIControlStateNormal];
                                                                             }
//                                                                             if([self->ingredientTextfield.text floatValue]>0.0){
                                                                                 [self getCaloriUnit];
//                                                                             }
                                                                             
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

-(void)getCaloriUnit{
    
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:MealId] forKey:@"IngredientId"];
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetIngredientDetailsApiCall" append:@""forAction:@"POST"];
        
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
                                                                     
                                                                     NSLog(@"%@",responseDict);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         NSDictionary *dict = responseDict[@"IngredientDetail"];
                                                                         
                                                                         float quantity = [self->ingredientTextfield.text floatValue];
                                                                         float CalsPer100 = [dict[@"CalsPer100"] floatValue];
                                                                         
                                                                         NSString *calories = @"";//Calories: ";
                                                                         NSString *unit = self->unitsButton.titleLabel.text;
                                                                         
                                                                         if (quantity > 0){
                                                                             if(CalsPer100 > 0){
//                                                                                 self->ingredientCalori = CalsPer100*quantity/100;
//                                                                                 calories = [calories stringByAppendingFormat:@"%.2f",self->ingredientCalori];
                                                                                 Calorie *cal =[Utility ingredientCalorieCalculation:quantity proteinPer100:[dict[@"ProteinPer100"] floatValue] fatPer100:[dict[@"FatPer100"] floatValue] carbPer100:[dict[@"CarbsPer100"] floatValue] alcoholPer100:[dict[@"AlcoholPer100"] floatValue] unit:unit conversionUnit:dict[@"ConversionUnit"] conversionFactor:[dict[@"ConversionNum"] floatValue]];
                                                                                 self->ingredientCalori = [[Utility totalCalories:cal] floatValue];
                                                                                 calories  = [calories stringByAppendingFormat:@"%.2f",self->ingredientCalori];
                                                                             }else{
                                                                                 Calorie *cal =[Utility ingredientCalorieCalculation:quantity proteinPer100:[dict[@"ProteinPer100"] floatValue] fatPer100:[dict[@"FatPer100"] floatValue] carbPer100:[dict[@"CarbsPer100"] floatValue] alcoholPer100:[dict[@"AlcoholPer100"] floatValue] unit:unit conversionUnit:dict[@"ConversionUnit"] conversionFactor:[dict[@"ConversionNum"] floatValue]];
                                                                                 self->ingredientCalori = [[Utility totalCalories:cal] floatValue];
                                                                                 calories  = [calories stringByAppendingFormat:@"%.2f",self->ingredientCalori];
                                                                                 
                                                                             }
                                                                             float quant = 1;
                                                                             if (![Utility isEmptyCheck:[self->mealDetails objectForKey:@"Quantity"]] && [[self->mealDetails objectForKey:@"Quantity"]floatValue]>0) {
                                                                                 quant = [[self->mealDetails objectForKey:@"Quantity"]floatValue];
                                                                             }
                                                                             self->caloriLabel.text = [Utility customRoundNumber:([calories floatValue]*quant)];
                                                                             self->caloriesTextField.text = [Utility customRoundNumber:([calories floatValue]*quant)];
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
-(void)deleteMyMeal:(UIButton *)sender{
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[mealDetails objectForKey:@"Id"] forKey:@"Id"];//MealId
        
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteSquadUserActualMeal" append:@""forAction:@"POST"];
        
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
                                                                     //                                                                     NSLog(@"%@",responseDict);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->isChanged = true;
                                                                         [self backToMealMatch];
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
-(void)getMyMealListById:(int)Id isSavePer100:(BOOL)isSavePer100{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:Id] forKey:@"IngredientId"];
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetIngredientDetailsApiCall" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];//meal/GetIngredientDetails
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
                                                                     //                                                                     NSLog(@"%@",responseDict);
                                                                     
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         if (![Utility isEmptyCheck:responseDict[@"IngredientDetail"]]){
                                                                             if (isSavePer100) {
                                                                                 
                                                                                 NSMutableDictionary *dict = [NSMutableDictionary new];
                                                                                 [dict setObject:responseDict[@"IngredientDetail"][@"ProteinPer100"] forKey:@"ProteinPer100"];
                                                                                 [dict setObject:responseDict[@"IngredientDetail"][@"FatPer100"] forKey:@"FatPer100"];
                                                                                 [dict setObject:responseDict[@"IngredientDetail"][@"CarbsPer100"] forKey:@"CarbsPer100"];
                                                                                 [dict setObject:responseDict[@"IngredientDetail"][@"AlcoholPer100"] forKey:@"AlcoholPer100"];
                                                                                 [dict setObject:responseDict[@"IngredientDetail"][@"ConversionUnit"] forKey:@"ConversionUnit"];
                                                                                 [dict setObject:responseDict[@"IngredientDetail"][@"ConversionNum"] forKey:@"ConversionNum"];
                                                                                 NSMutableDictionary *neew = [NSMutableDictionary new];
                                                                                 [neew addEntriesFromDictionary:self->mealDetails];
                                                                                 [neew addEntriesFromDictionary:dict];
                                                                                 self->mealDetails = neew;
                                                                             } else {
                                                                                 self->mealDetails = [responseDict[@"IngredientDetail"] mutableCopy];
                                                                             }
                                                                             [self setup_view];
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
-(void)getNutritionixMealDetailsById:(NSString *)mealStringId{   //ah 02
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequestForNutritionix:@"" api:@"NutritionixMealSearchById" append:mealStringId forAction:@"GET"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                         NSString *weight = @"";
                                                                         NSArray *food = [responseDict objectForKey:@"foods"];
                                                                         if (![Utility isEmptyCheck:food]) {
                                                                             NSDictionary *fMeal = [food objectAtIndex:0];
                                                                             if (![Utility isEmptyCheck:fMeal]) {
                                                                                 weight = ![Utility isEmptyCheck:[fMeal objectForKey:@"serving_weight_grams"]]?[@""stringByAppendingFormat:@"%@",[fMeal objectForKey:@"serving_weight_grams"]]:@"";
                                                                                 if(![Utility isEmptyCheck:[fMeal objectForKey:@"serving_qty"]]){
                                                                                     [self->mealDetails setObject:[@""stringByAppendingFormat:@"%@",[fMeal objectForKey:@"serving_qty"]] forKey:@"Quantity"];
                                                                                     self->serveTextField.text = [@""stringByAppendingFormat:@"%@",[Utility customRoundNumber:[[fMeal objectForKey:@"serving_qty"]floatValue]]];
                                                                                 }
                                                                                 
                                                                                 
                                                                                 if(![Utility isEmptyCheck:[fMeal objectForKey:@"serving_unit"]]){
                                                                                     [self->mealDetails setObject:[@""stringByAppendingFormat:@"%@",[fMeal objectForKey:@"serving_unit"]] forKey:@"MetricUnit"];
                                                                                     NSString *units = [fMeal objectForKey:@"serving_unit"];
                                                                                     NSArray *untArr = [units componentsSeparatedByString:@","];
                                                                                     
                                                                                     if (!self->unitListArray){
                                                                                         self->unitListArray = [[NSMutableArray alloc]init];
                                                                                     }
                                                                                     [self->unitListArray removeAllObjects];
                                                                                     [self->unitListArray addObjectsFromArray:untArr];
                                                                                 }
                                                                             }
                                                                         }
                                                                         if ([Utility isEmptyCheck:[self->mealDetails objectForKey:@"QtyMetric"]]) {
                                                                             if (![Utility isEmptyCheck:weight]) {
                                                                                 [self->mealDetails setObject:weight forKey:@"serving_weight_grams"];
                                                                                 [self->mealDetails setObject:weight forKey:@"QtyMetric"];
                                                                             }
                                                                         }
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                     [self setup_view];
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
- (IBAction)backButtonPressed:(UIButton *)sender {
    if ([delegate respondsToSelector:@selector(didCheckAnyChangeForMealAdd:with:)]) {
        [delegate didCheckAnyChangeForMealAdd:isChanged with:NO];
    }
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    if ([self formValidation]){
        [self addUpdateActualMealMatchMultiPart:NO];
    }
}

- (IBAction)nextButtonPressed:(UIButton *)sender {
    [self.view endEditing:true];
    if (!beforeEatingMealView.isHidden) {
        return;
    }
    if (isAdd) {
        if ([self formValidation]){
            [self addUpdateActualMealMatchMultiPart:YES];
        }
    } else {
        afterEatingMealView.hidden = false;
        beforeEatingMealView.hidden = false;
    }
    // chayan
//    if ([self formValidation]){
//        [self addUpdateActualMealMatchMultiPart:YES];
//    }
    
}

- (IBAction)cameraButtonPressed:(UIButton *)sender {
    
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

- (IBAction)mealQuantityButtonPressed:(UIButton *)sender {
    
    mealQuantityButton.accessibilityHint = @"quantity";
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = mealQuantityArray;
    controller.mainKey = @"name";
    controller.delegate = self;
    controller.sender = sender;
    controller.selectedIndex = (int)sender.tag;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)bloatButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in bloatButtons){
        
        if (sender.tag == button.tag){
            
            button.selected = YES;
            AfterBloat = (int)sender.tag;
            
        }else{
            
            button.selected = NO;
        }
    }
}

- (IBAction)afterMealCravingsButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in afterMealCravingsButtons){
        
        if (sender.tag == button.tag){
            
            button.selected = YES;
            AfterCravings = (int)sender.tag;
            
        }else{
            
            button.selected = NO;
        }
    }
}

- (IBAction)afterMealEnergyButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in afterMealEnergyButtons){
        
        if (sender.tag == button.tag){
            
            button.selected = YES;
            AfterEnergy = (int)sender.tag;
            
        }else{
            
            button.selected = NO;
        }
    }
}

- (IBAction)moodPresentButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in moodPresentButtons){
        
        if (sender.tag == button.tag){
            
            if (button.isSelected){
                button.selected = NO;
            }else{
                button.selected = YES;
            }
            
        }
    }
}

- (IBAction)beforeMealCravingsButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in beforeMealCravingsButtons){
        
        if (sender.tag == button.tag){
            
            button.selected = YES;
            BeforeCravings = (int)sender.tag;
            
        }else{
            
            button.selected = NO;
        }
    }
}

- (IBAction)beforeMealEnergyButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in beforeMealEnergyButtons){
        
        if (sender.tag == button.tag){
            
            button.selected = YES;
            BeforeEnergy = (int)sender.tag;
            
        }else{
            
            button.selected = NO;
        }
    }
}

- (IBAction)mealTypeButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in mealTypeButton){
        
        if (sender.tag == button.tag){
            
            button.selected = YES;
//            _MealType = (int)sender.tag;
//            if ((int)sender.tag == 4) {
//                _MealType = (int)sender.tag;
//            } else {
////                MealType = (int)sender.tag;
//            }
        }else{
            
            button.selected = NO;
        }
    }
}

- (IBAction)mealNameButtonPressed:(UIButton *)sender {
    if (mealListArray.count == 0) {
        
        if(mealTypeData == 2){
            [Utility msg:@"No Meal found.Please create one." title:@"Oops! " controller:self haveToPop:NO];
        }
        return;
    }
    if(mealTypeData == 3){
        return;
    }
    if (mealListArray.count > 0){
        //        isClick = true;
        //        mealNameButton.accessibilityHint = @"mealname";
        //        showHideView.hidden = false;
        //        [mealTable reloadData];
        
        //        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        //        controller.modalPresentationStyle = UIModalPresentationCustom;
        //        controller.dropdownDataArray = mealListArray;
        //        controller.mainKey = @"MealName";
        //        controller.delegate = self;
        //        controller.sender = sender;
        //        controller.selectedIndex = (int)sender.tag;
        //        [self presentViewController:controller animated:YES completion:nil];
        
        FoodPrepSearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrepSearch"];
        controller.delegate=self;
        controller.sender = sender;
        controller.isFromMealMatch = YES;
        if(mealTypeData == 2){
            controller.isMyRecipe = YES;
        }else{
            controller.isMyRecipe = NO;
        }
        if (![Utility isEmptyCheck:searchDict]) {
            controller.defaultSearchDict = [searchDict mutableCopy];
        }
        if (![Utility isEmptyCheck:ingredientsAllList]) {
            controller.ingredientsAllList = ingredientsAllList;
        }
        if (![Utility isEmptyCheck:dietaryPreferenceArray]) {
            controller.dietaryPreferenceArray = dietaryPreferenceArray;
        }
        controller.delegate = self;
        //controller.modalPresentationStyle = UIModalPresentationCustom;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else{
        [Utility msg:@"No Meal name found" title:@"Oops! " controller:self haveToPop:NO];
    }
    
}

- (IBAction)ingredientButtonPressed:(UIButton *)sender {
    if(mealTypeData == 3){
        return;
    }
    if (mealListArray.count > 0){
        
        ingredientButton.accessibilityHint = @"ingredient";
        filterTextField.text = @"";
        tempMealArray = [NSArray arrayWithArray:mealListArray];
        showHideView.hidden = false;
        [mealTable reloadData];
        //        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        //        controller.modalPresentationStyle = UIModalPresentationCustom;
        //        controller.dropdownDataArray = mealListArray;
        //        controller.mainKey = @"IngredientName";
        //        controller.delegate = self;
        //        controller.sender = sender;
        //        controller.selectedIndex = (int)sender.tag;
        //        [self presentViewController:controller animated:YES completion:nil];
        
    }else{
        [Utility msg:@"No Ingredient data found" title:@"Oops! " controller:self haveToPop:NO];
    }
}

- (IBAction)unitButtonPressed:(UIButton *)sender {
    
    if (unitListArray.count > 0){
        
        unitsButton.accessibilityHint = @"unit";
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = unitListArray;
        controller.delegate = self;
        controller.sender = sender;
        controller.selectedIndex = -1;
        [self presentViewController:controller animated:YES completion:nil];
        
    }else{
        [Utility msg:@"No Unit data found" title:@"Oops! " controller:self haveToPop:NO];
    }
}
- (IBAction)donePressed:(UIButton *)sender {
    if(activeTextField){
        [self.view endEditing:YES];
    }else{
        showHideView.hidden = true;
    }
}
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    showHideView.hidden = true;
}

-(IBAction)editButtonPressed:(id)sender{
    isEdit = !isEdit;
    
    BOOL isMetric;
    if (![Utility isEmptyCheck:[defaults objectForKey:@"UnitPreference"]] && [[defaults objectForKey:@"UnitPreference"]intValue] == 2) {//imperial
        isMetric = false;
    } else {//metric
        isMetric = true;
    }
    if (isEdit) {
        if(isMetric){
            unitListArray = [[NSMutableArray alloc]initWithObjects:@"Grams",@"Mls",@"Cups",@"Tsp",@"tbsp", nil];
        }else{
            unitListArray = [[NSMutableArray alloc]initWithObjects:@"oz",@"fl.oz",@"Cups",@"Tsp",@"tbsp", nil];
        }
    }else{
        if(isMetric){
            unitListArray = [[NSMutableArray alloc]initWithObjects:![Utility isEmptyCheck:[mealDetails objectForKey:@"MetricUnit"]]?[@"" stringByAppendingFormat:@"%@",[mealDetails objectForKey:@"MetricUnit"]]:@"Grams", nil];
        }else{
            unitListArray = [[NSMutableArray alloc]initWithObjects:![Utility isEmptyCheck:[mealDetails objectForKey:@"MetricUnit"]]?[@"" stringByAppendingFormat:@"%@",[mealDetails objectForKey:@"MetricUnit"]]:@"oz", nil];
        }
    }
    if (self->unitListArray.count>1) {
        [self->arrButton setImage:[UIImage imageNamed:@"dropdown_arrow_left.png"] forState:UIControlStateNormal];
        [self->unitsButton setTitleColor:squadMainColor forState:UIControlStateNormal];
        self->unitsButton.userInteractionEnabled = true;
    }else{
        [self->arrButton setImage:nil forState:UIControlStateNormal];
        [self->unitsButton setTitleColor:squadSubColor forState:UIControlStateNormal];
        self->unitsButton.userInteractionEnabled = false;
    }
    
    mealTypeNameLabel.userInteractionEnabled = isEdit;
    brandTextField.userInteractionEnabled = isEdit;
    serveTextField.userInteractionEnabled = false;
    ingredientTextfield.userInteractionEnabled = true;
    
    caloriesTextField.userInteractionEnabled = isEdit;
    proteinTextField.userInteractionEnabled = isEdit;
    carbsTextField.userInteractionEnabled = isEdit;
    fatTextField.userInteractionEnabled = isEdit;
    
    mealTypeNameLabel.textColor = isEdit?squadMainColor:[Utility colorWithHexString:@"333333"];
    brandTextField.textColor = isEdit?squadMainColor:[Utility colorWithHexString:@"333333"];
    serveTextField.textColor = [Utility colorWithHexString:@"333333"];
    ingredientTextfield.textColor = squadMainColor;
    
    caloriesTextField.textColor = isEdit?squadMainColor:[Utility colorWithHexString:@"333333"];
    proteinTextField.textColor = isEdit?squadMainColor:[Utility colorWithHexString:@"333333"];
    carbsTextField.textColor = isEdit?squadMainColor:[Utility colorWithHexString:@"333333"];
    fatTextField.textColor = isEdit?squadMainColor:[Utility colorWithHexString:@"333333"];
    
    serveTextField.text = @"1";
    serveMultiplier = 1;
    [mealDetails setObject:[NSNumber numberWithInt:1] forKey:@"Quantity"];
    editButtonView.hidden = true;
}
-(IBAction)noButtonPressed:(id)sender{
    [self.view endEditing:YES];
    afterEatingMealView.hidden = true;
    beforeEatingMealView.hidden = true;
}
- (IBAction)updateDeletePressed:(UIButton *)sender {
    if (sender.tag == 0) {
        [self saveButtonPressed:0];
    } else if (sender.tag == 1) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Delete My Day Meal"
                                              message:@"Are you sure to want to delete My Day Meal?"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Confirm"
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self deleteMyMeal:sender];
                                       
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(IBAction)planButtonPressed:(id)sender{
    NSString *qntyKey;
    if (isAdd) {
        qntyKey = @"Quantity";
        if (_fromMyPlan && ![Utility isEmptyCheck:_planMealData]) {
            [mealDetails setObject:[_planMealData objectForKey:@"Quantity"] forKey:@"Quantity"];
        }
    } else {
        qntyKey = @"QuantityAsPerPlan";
    }
    if (![Utility isEmptyCheck:[mealDetails objectForKey:qntyKey]]) {
        
        [mealDetails setObject:[mealDetails objectForKey:qntyKey] forKey:@"Quantity"];
        
        planButton.hidden = true;
        serveTextField.text = [Utility customRoundNumber:[[mealDetails objectForKey:@"Quantity"]floatValue]];
        serveMultiplier = [[mealDetails objectForKey:@"Quantity"]floatValue];
        serveTextField.userInteractionEnabled = true;
        serveTextField.textColor = squadMainColor;
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
    scroll.contentInset = contentInsets;
    scroll.scrollIndicatorInsets = contentInsets;
    if (!showHideView.isHidden) {
        mealTable.contentInset = contentInsets;
        mealTable.scrollIndicatorInsets = contentInsets;
    }
    
    if (activeTextField !=nil) {
        CGRect aRect = scroll.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            [scroll scrollRectToVisible:activeTextField.frame animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scroll.contentInset = contentInsets;
    scroll.scrollIndicatorInsets = contentInsets;
    if (!showHideView.isHidden) {
        mealTable.contentInset = contentInsets;
        mealTable.scrollIndicatorInsets = contentInsets;
    }
}

-(void)btnClickedDone:(id)sender{
    if (activeTextField == serveTextField) {
        if ([serveTextField.text floatValue] <= 0.0) {
            serveTextField.tag = 1;
            [Utility msg:@"Please enter number of serve greater than 0" title:nil controller:self haveToPop:NO];
            return;
        }
    }
    [self.view endEditing:YES];
}

#pragma mark - End -
-(void)textValueChange:(UITextField *)textField{
    NSLog(@"search for %@", textField.text);
    if (textField.text.length > 0) {
        tempMealArray = [mealListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IngredientName CONTAINS[c] %@)", textField.text]];
    } else {
        tempMealArray = mealListArray;
    }
    [mealTable reloadData];
}
#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if (textField == serveTextField || textField == ingredientTextfield || textField == mealTypeNameLabel) {
        return YES;
//    }
//    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    if(textField == serveTextField){
        textField.tag = 0;
        if (_fromMyPlan && isAdd) {
            textField.accessibilityHint = textField.text;
        }
    }
    
    if (textField == caloriesTextField || textField == proteinTextField || textField == carbsTextField || textField == fatTextField || textField == serveTextField || textField == ingredientTextfield) {
        if (textField.text.floatValue <= 0.0) {
            textField.text = @"";
        }
    }
    [textField setInputAccessoryView:toolBar];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_actualMealType == Quick && ((isAdd && !_quickRecentFreq) || isEdit)) {
        if(textField == mealTypeNameLabel){
            if (textField.text.length>0) {
                MealName = textField.text;
            } else {
                MealName = @"";
            }
        }else if(textField == serveTextField){
            float mult = [textField.text floatValue];
            if (mult <= 0.0) {
                [Utility msg:@"Number of serve should be greater than 0" title:nil controller:self haveToPop:NO];
                textField.text = @"0.1";
            }
            serveMultiplier = [textField.text floatValue];
        }
        activeTextField = nil;
        return;
    }
    if (textField == ingredientTextfield){
        if([ingredientTextfield.text floatValue]<=0){
            ingredientTextfield.text = @"0.1";
            [Utility msg:@"Serving size cannot be zero." title:nil controller:self haveToPop:NO];
        }
        if ([ingredientTextfield.text floatValue]>0){
//            [self getCaloriUnit];
            float quantity = [ingredientTextfield.text floatValue];
            NSString *unitString = unitsButton.currentTitle;
            
            if ([unitString isEqualToString:@"as needed"] || [unitString isEqualToString:@"to taste"])
            {
                quantity = 0;
            }
            if (_actualMealType == Quick) {
                if (serveMultiplier>0.0) {
                    caloriesTextField.text = [Utility customRoundNumber:serveMultiplier * ([[mealDetails objectForKey:@"Calories"]floatValue] / ([[mealDetails objectForKey:@"QtyMetric"]floatValue] * [[mealDetails objectForKey:@"Quantity"]floatValue])) * [ingredientTextfield.text floatValue]];
                    proteinTextField.text = [Utility customRoundNumber:serveMultiplier * ([[mealDetails objectForKey:@"Protein"]floatValue] / ([[mealDetails objectForKey:@"QtyMetric"]floatValue] * [[mealDetails objectForKey:@"Quantity"]floatValue])) * [ingredientTextfield.text floatValue]];
                    carbsTextField.text = [Utility customRoundNumber:serveMultiplier * ([[mealDetails objectForKey:@"Carb"]floatValue] / ([[mealDetails objectForKey:@"QtyMetric"]floatValue] * [[mealDetails objectForKey:@"Quantity"]floatValue])) * [ingredientTextfield.text floatValue]];
                    fatTextField.text = [Utility customRoundNumber:serveMultiplier * ([[mealDetails objectForKey:@"Fat"]floatValue] / ([[mealDetails objectForKey:@"QtyMetric"]floatValue] * [[mealDetails objectForKey:@"Quantity"]floatValue])) * [ingredientTextfield.text floatValue]];
                }
            } else if (quantity > 0 && quantity != 0 && ![unitString isEqualToString:@""]) {
                if(!isStaticIngredient){
                    if ([[mealDetails objectForKey:@"IsEdamam"]boolValue] && ![Utility isEmptyCheck:[mealDetails objectForKey:@"serving_weight_grams"]]) {
                        caloriLabel.text = [Utility customRoundNumber:(serveMultiplier * ([[mealDetails objectForKey:@"EdamamCalories"]floatValue] / [[mealDetails objectForKey:@"serving_weight_grams"]floatValue]) * [ingredientTextfield.text floatValue])];
                        if (serveMultiplier>0.0) {
                            float cal = [[mealDetails objectForKey:@"EdamamCalories"]floatValue];
                            if (cal<=0.0) {
                                cal = [[mealDetails objectForKey:@"Calories"]floatValue];
                            }
                            float carb = [[mealDetails objectForKey:@"Carbohydrates"]floatValue];
                            if (carb<=0.0) {
                                carb = [[mealDetails objectForKey:@"Carb"]floatValue];
                            }
                            caloriesTextField.text = [Utility customRoundNumber:(serveMultiplier * (cal / ([[mealDetails objectForKey:@"serving_weight_grams"]floatValue] * [[mealDetails objectForKey:@"Quantity"]floatValue])) * [ingredientTextfield.text floatValue])];
                            proteinTextField.text = [Utility customRoundNumber:(serveMultiplier * ([[mealDetails objectForKey:@"Protein"]floatValue] / ([[mealDetails objectForKey:@"serving_weight_grams"]floatValue] * [[mealDetails objectForKey:@"Quantity"]floatValue])) * [ingredientTextfield.text floatValue])];
                            carbsTextField.text = [Utility customRoundNumber:(serveMultiplier * (carb / ([[mealDetails objectForKey:@"serving_weight_grams"]floatValue] * [[mealDetails objectForKey:@"Quantity"]floatValue])) * [ingredientTextfield.text floatValue])];
                            fatTextField.text = [Utility customRoundNumber:(serveMultiplier * ([[mealDetails objectForKey:@"Fat"]floatValue] / ([[mealDetails objectForKey:@"serving_weight_grams"]floatValue] * [[mealDetails objectForKey:@"Quantity"]floatValue])) * [ingredientTextfield.text floatValue])];
                        }
                    }
                }else{
                    Calorie *cal = [Utility ingredientCalorieCalculation:quantity proteinPer100:[mealDetails[@"ProteinPer100"] floatValue] fatPer100:[mealDetails[@"FatPer100"] floatValue] carbPer100:[mealDetails[@"CarbsPer100"] floatValue] alcoholPer100:[mealDetails[@"AlcoholPer100"] floatValue] unit:unitString conversionUnit:mealDetails[@"ConversionUnit"] conversionFactor:[mealDetails[@"ConversionNum"] floatValue]];
                    caloriLabel.text = [Utility totalCalories:cal];
                    self->caloriesTextField.text = [Utility customRoundNumber:([serveTextField.text floatValue] * [[Utility totalCalories:cal] floatValue])];
                    [self calcPCFforSqIng:caloriesTextField.text.floatValue];
                }
            }else{
                caloriLabel.text =@"0";
                self->caloriesTextField.text = @"0";
            }
        }
    }else if(textField == serveTextField){
        
        if (_fromMyPlan && isAdd) {
            if (textField.text != textField.accessibilityHint) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:_planMealData];
                if (![Utility isEmptyCheck:_planMealData[@"MealDetails"][@"TotalCalories"]]) {
                    [dict setObject:_planMealData[@"MealDetails"][@"TotalCalories"] forKey:@"Calories"];
                    _planMealData = dict;
                    caloriesTextField.text = [@"" stringByAppendingFormat:@"%@", _planMealData[@"MealDetails"][@"TotalCalories"]];
                    serveMultiplier = 1.0;
                }
            }
        }
        BOOL adjust = false;
        float mult = [textField.text floatValue];
        if (mult <= 0.0) {
            [Utility msg:@"Number of serve should be greater than 0" title:nil controller:self haveToPop:NO];
        }
        if (mult <= 0.0) {
            mult = 0.1;
            serveTextField.text = @"0.1";
            ingredientTextfield.text = [Utility customRoundNumber:[![Utility isEmptyCheck:[mealDetails objectForKey:@"serving_weight_grams"]]?[mealDetails objectForKey:@"serving_weight_grams"]:(![Utility isEmptyCheck:[mealDetails objectForKey:@"QtyMetric"]]?[mealDetails objectForKey:@"QtyMetric"]:@"1.0") floatValue]];
            adjust = true;
        }
        if(textField.tag != 1){
            if (serveMultiplier>0.0 && mult>0.0) {
                if(!isStaticIngredient && [[mealDetails objectForKey:@"IsEdamam"]boolValue] && ![Utility isEmptyCheck:[mealDetails objectForKey:@"serving_weight_grams"]]) {
                    NSString *cal = [Utility customRoundNumber:((caloriesTextField.text.floatValue / serveMultiplier) * mult)];
                    caloriLabel.text = cal;
                    if (serveMultiplier>0.0) {
                        caloriesTextField.text = cal;
                        proteinTextField.text = [Utility customRoundNumber:((proteinTextField.text.floatValue / serveMultiplier) * mult)];
                        carbsTextField.text = [Utility customRoundNumber:((carbsTextField.text.floatValue / serveMultiplier) * mult)];
                        fatTextField.text = [Utility customRoundNumber:((fatTextField.text.floatValue / serveMultiplier) * mult)];
                    }
                    
                } else {
                    caloriesTextField.text = [Utility customRoundNumber:((caloriesTextField.text.floatValue / serveMultiplier) * mult)];
                    proteinTextField.text = [Utility customRoundNumber:((proteinTextField.text.floatValue / serveMultiplier) * mult)];
                    carbsTextField.text = [Utility customRoundNumber:((carbsTextField.text.floatValue / serveMultiplier) * mult)];
                    fatTextField.text = [Utility customRoundNumber:((fatTextField.text.floatValue / serveMultiplier) * mult)];
                }
                serveMultiplier = mult;
                
                if (adjust) {
                    if(!isStaticIngredient){
                        if ([[mealDetails objectForKey:@"IsEdamam"]boolValue] && ![Utility isEmptyCheck:[mealDetails objectForKey:@"serving_weight_grams"]]) {
                            NSString *cal = [Utility customRoundNumber:(serveMultiplier * ([[mealDetails objectForKey:@"EdamamCalories"]floatValue] / [[mealDetails objectForKey:@"serving_weight_grams"]floatValue]) * [ingredientTextfield.text floatValue])];
                            caloriLabel.text = cal;
                            if (serveMultiplier>0.0) {
                                caloriesTextField.text = cal;
                                proteinTextField.text = [Utility customRoundNumber:(serveMultiplier * ([[mealDetails objectForKey:@"Protein"]floatValue] / [[mealDetails objectForKey:@"serving_weight_grams"]floatValue]) * [ingredientTextfield.text floatValue])];
                                carbsTextField.text = [Utility customRoundNumber:(serveMultiplier * ([[mealDetails objectForKey:@"Carbohydrates"]floatValue] / [[mealDetails objectForKey:@"serving_weight_grams"]floatValue]) * [ingredientTextfield.text floatValue])];
                                fatTextField.text = [Utility customRoundNumber:(serveMultiplier * ([[mealDetails objectForKey:@"Fat"]floatValue] / [[mealDetails objectForKey:@"serving_weight_grams"]floatValue]) * [ingredientTextfield.text floatValue])];
                            }
                        }
                    }else{
                        float quantity = [ingredientTextfield.text floatValue];
                        NSString *unitString = unitsButton.currentTitle;
                        
                        if ([unitString isEqualToString:@"as needed"] || [unitString isEqualToString:@"to taste"])
                        {
                            quantity = 0;
                        }
                        
                        if (quantity > 0 && quantity != 0 && ![unitString isEqualToString:@""])
                        {
                        Calorie *cal = [Utility ingredientCalorieCalculation:quantity proteinPer100:[mealDetails[@"ProteinPer100"] floatValue] fatPer100:[mealDetails[@"FatPer100"] floatValue] carbPer100:[mealDetails[@"CarbsPer100"] floatValue] alcoholPer100:[mealDetails[@"AlcoholPer100"] floatValue] unit:unitString conversionUnit:mealDetails[@"ConversionUnit"] conversionFactor:[mealDetails[@"ConversionNum"] floatValue]];
                        caloriLabel.text = [Utility customRoundNumber:(serveMultiplier * [[Utility totalCalories:cal] floatValue])];
                            caloriesTextField.text = [Utility customRoundNumber:(serveMultiplier * [[Utility totalCalories:cal] floatValue])];
                            [self calcPCFforSqIng:caloriesTextField.text.floatValue];
                        }else{
                            caloriesTextField.text = @"0";
                            [self calcPCFforSqIng:0];
                        }
                    }
                }
                
            }
            
        }
    }else if(textField == mealTypeNameLabel){
        if (textField.text.length>0) {
            MealName = textField.text;
        } else {
            textField.text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:MealName]?MealName:@""];
            [Utility msg:@"Meal name should not be empty." title:nil controller:self haveToPop:NO];
        }
    }
    
    activeTextField = nil;
}
#pragma mark - End
#pragma mark -TableView Datasource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tempMealArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell;
    foodPrepSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodPrepSearchTableViewCell"];
    
    //    cell.mealNameLabel.text = ![Utility isEmptyCheck:mealListArray[indexPath.row][@"MealName"]]?mealListArray[indexPath.row][@"MealName"]:@"";
    NSString *ingredientName = ![Utility isEmptyCheck:tempMealArray[indexPath.row][@"IngredientName"]]?tempMealArray[indexPath.row][@"IngredientName"]:@"";
    cell.mealNameLabel.text = ingredientName;
    //    if ([ingredientButton.currentTitle isEqualToString:ingredientName]) {
    //        [cell.mealNameLabel setTextColor:[UIColor whiteColor]];
    //        [cell.mealNameLabel setBackgroundColor:[UIColor colorWithRed:(228/255.0f) green:(39/255.0f) blue:(160/255.0f) alpha:1.0f]];
    //    } else {
    //        [cell.mealNameLabel setTextColor:[UIColor colorWithRed:(228/255.0f) green:(39/255.0f) blue:(160/255.0f) alpha:1.0f]];
    //        [cell.mealNameLabel setBackgroundColor:[UIColor whiteColor]];
    //    }
    tableCell = cell;
    
    return tableCell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if(![Utility isEmptyCheck:mealListArray] && mealListArray.count>0){
    //        if (!isStaticIngredient && mealTypeData != 3) {
    //            if(indexPath.row == mealListArray.count-1){
    //                pageNo=pageNo+1;
    //                [self getSquadMealList:mealTypeData mealName:mealDetails isStatic:isStatic];
    //            }
    //        }
    //    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if ([tableView isEqual:mealTable]) {
    //        NSDictionary *data = mealListArray[indexPath.row];
    //        [mealNameButton setTitle:![Utility isEmptyCheck:data[@"MealName"]] ? data[@"MealName"] :@"" forState:UIControlStateNormal];
    //        MealName = ![Utility isEmptyCheck:data[@"MealName"]] ? data[@"MealName"] :@"";
    //        MealId = ![Utility isEmptyCheck:data[@"Id"]] ? [data[@"Id"] intValue] :0;
    //        mealNameButton.tag = [mealListArray indexOfObject:data];
    //
    //        int mealType = [data[@"MealType"] intValue];
    //        if(mealType == 0){
    //            MealType = 0;
    //            [self mealTypeButtonPressed:mealTypeButton[0]];
    //        }else if(mealType == 4){
    //            MealType = 4;
    //            [self mealTypeButtonPressed:mealTypeButton[1]];
    //        }else{
    //            MealType = 0;
    //            [self mealTypeButtonPressed:mealTypeButton[0]];
    //        }
    //
    //        if (!isStatic && !isStaticIngredient){
    //            mealTypeNameLabel.text = MealName;
    //        }
    //
    //        if(![Utility isEmptyCheck:data[@"Photo"]]){
    //
    //            [previewImageView sd_setImageWithURL:[NSURL URLWithString:data[@"Photo"]]
    //                                placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //                                    //                                        selectedImage = previewImageView.image;
    //                                }];
    //
    //        }
    //    }
    if ([tableView isEqual:mealTable]) {
        showHideView.hidden = true;
        NSDictionary *data = tempMealArray[indexPath.row];
        [ingredientButton setTitle:![Utility isEmptyCheck:data[@"IngredientName"]] ? data[@"IngredientName"] :@"" forState:UIControlStateNormal];
        MealName = ![Utility isEmptyCheck:data[@"IngredientName"]] ? data[@"IngredientName"] :@"";
        MealId = ![Utility isEmptyCheck:data[@"IngredientId"]] ? [data[@"IngredientId"] intValue] :0;
        ingredientButton.tag = [mealListArray indexOfObject:data];
        [self getIngredientUnit];
        [self.view endEditing:YES];
    }
}
#pragma mark - End
#pragma mark -Dropdown Delegate
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)data sender:(UIButton *)sender{
    
    
    if (![Utility isEmptyCheck:data]){
        
        if ([sender.accessibilityHint isEqualToString:@"mealname"]){
            
            [sender setTitle:![Utility isEmptyCheck:data[@"MealName"]] ? data[@"MealName"] :@"" forState:UIControlStateNormal];
            MealName = ![Utility isEmptyCheck:data[@"MealName"]] ? data[@"MealName"] :@"";
            MealId = ![Utility isEmptyCheck:data[@"Id"]] ? [data[@"Id"] intValue] :0;
            sender.tag = [mealListArray indexOfObject:data];
            
            int mealType = [data[@"MealType"] intValue];
//            if(mealType == 0){
//                MealType = 0;
//                [self mealTypeButtonPressed:mealTypeButton[0]];
//            }else
                if(mealType == 4 || _MealType == 4){
//                MealType = 4;
                [self mealTypeButtonPressed:mealTypeButton[1]];
            }else{
//                MealType = 0;
                [self mealTypeButtonPressed:mealTypeButton[0]];
            }
            
            if (!isStatic && !isStaticIngredient){
                mealTypeNameLabel.text = MealName;
            }
            
            
        }else if ([sender.accessibilityHint isEqualToString:@"quantity"]){
            
            [sender setTitle:![Utility isEmptyCheck:data[@"name"]] ? data[@"name"] :@"" forState:UIControlStateNormal];
            int quantityId = [data[@"id"] intValue];
            
            QuantityId = quantityId;
            
            if (quantityId == 0){
                caloriView.hidden = false;
            }else{
                caloriView.hidden = true;
            }
            
            sender.tag = [mealQuantityArray indexOfObject:data];
            
        }else if ([sender.accessibilityHint isEqualToString:@"ingredient"]){
            
            [sender setTitle:![Utility isEmptyCheck:data[@"IngredientName"]] ? data[@"IngredientName"] :@"" forState:UIControlStateNormal];
            MealName = ![Utility isEmptyCheck:data[@"IngredientName"]] ? data[@"IngredientName"] :@"";
            MealId = ![Utility isEmptyCheck:data[@"IngredientId"]] ? [data[@"IngredientId"] intValue] :0;
            sender.tag = [mealListArray indexOfObject:data];
            [self getIngredientUnit];
        }
    }
}

- (void) dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{
    
    if ([sender.accessibilityHint isEqualToString:@"unit"]){
        
        if(!isStaticIngredient){
            if ([[mealDetails objectForKey:@"IsEdamam"]boolValue] && ![Utility isEmptyCheck:[mealDetails objectForKey:@"serving_weight_grams"]]) {
                return;
            }
        }
        
        [sender setTitle:selectedValue forState:UIControlStateNormal];
        sender.tag = [unitListArray indexOfObject:selectedValue];
        ingredientTextfield.userInteractionEnabled = true;
        
        [self setQuantity];
        if (_actualMealType == Quick) {
            return;
        }
        float quantity = 0;
        NSString *unitString = @"";
        //            quantity = [ingredientDict[@"QuantityImperial"] floatValue];
        if ([[defaults objectForKey:@"UnitPreference"] intValue] == 2)
        {
            quantity = [mealDetails[@"QuantityImperial"] floatValue];
            //quantity = [ingredientDict[@"QuantityMetric"] floatValue];
            unitString = mealDetails[@"UnitImperial"];
            //unitString = ingredientDict[@"UnitMetric"];
        }else
        {
            quantity = [mealDetails[@"QuantityMetric"] floatValue];
            unitString = mealDetails[@"UnitMetric"];
        }
        quantity = [ingredientTextfield.text floatValue];
        unitString = selectedValue;
        
        if ([unitString isEqualToString:@"as needed"] || [unitString isEqualToString:@"to taste"])
        {
            quantity = 0;
        }
        
        if (quantity > 0 && quantity != 0 && ![unitString isEqualToString:@""])
        {
            Calorie *cal =[Utility ingredientCalorieCalculation:quantity proteinPer100:[mealDetails[@"ProteinPer100"] floatValue] fatPer100:[mealDetails[@"FatPer100"] floatValue] carbPer100:[mealDetails[@"CarbsPer100"] floatValue] alcoholPer100:[mealDetails[@"AlcoholPer100"] floatValue] unit:unitString conversionUnit:mealDetails[@"ConversionUnit"] conversionFactor:[mealDetails[@"ConversionNum"] floatValue]];
            caloriLabel.text = [Utility totalCalories:cal];
            self->caloriesTextField.text = [Utility customRoundNumber:([serveTextField.text floatValue] * [[Utility totalCalories:cal] floatValue])];
            [self calcPCFforSqIng:[caloriesTextField.text floatValue]];
        }else{
            caloriLabel.text =@"0";
            self->caloriesTextField.text = @"0";
            [self calcPCFforSqIng:0];
        }
    }
}
-(void)setQuantity{
//    NSMutableArray *tempIngredientsArray = [[NSMutableArray alloc]init];
//    for( NSDictionary *ing in mealListArray){
    NSMutableDictionary *dict = [mealDetails mutableCopy];//[ing mutableCopy];
//        [dict setObject:@"" forKey:@"Brand"];
//        if ([[defaults objectForKey:@"UnitPreference"] intValue] == 2)
//        {
//            //imperial
//            if ([dict[@"UnitImperial"] isEqualToString:@"inch"]){
//                dict[@"UnitMetric"] = @"cm";
//                dict[@"QuantityMetric"] = [NSNumber numberWithFloat:[dict[@"QuantityImperial"] floatValue]* (float)2.54];
//            }else if ([dict[@"UnitImperial"] isEqualToString:@"oz"]){
//                dict[@"UnitMetric"] = @"gram";
//                dict[@"QuantityMetric"] = [NSNumber numberWithFloat:[dict[@"QuantityImperial"] floatValue]* (float)28.3495];
//            }else if ([dict[@"UnitImperial"] isEqualToString:@"fl.oz"]){
//                dict[@"UnitMetric"] = @"ml";
//                dict[@"QuantityMetric"] = [NSNumber numberWithFloat:[dict[@"QuantityImperial"] floatValue]* (float)29.5735];
//            }else{
//                dict[@"UnitMetric"] = dict[@"UnitImperial"] ;
//                dict[@"QuantityMetric"] = dict[@"QuantityImperial"];
//
//            }
//        }else{
            //metric
    /*
     @"QtyMetric"
     @"IngredientQuantity"
     @"MetricUnit"
     */
            if ([dict[@"UnitMetric"] isEqualToString:@"cm"])
            {
                dict[@"UnitImperial"] = @"inch";
                dict[@"QuantityImperial"] = [NSNumber numberWithFloat:[ingredientTextfield.text floatValue]* (float)0.39];
            }
            else if ([dict[@"UnitMetric"] isEqualToString:@"gram"])
            {
                dict[@"UnitImperial"] = @"oz";
                dict[@"QuantityImperial"] = [NSNumber numberWithFloat:[ingredientTextfield.text floatValue]* (float)0.0353];
            }
            else if([dict[@"UnitMetric"] isEqualToString:@"ml"])
            {
                dict[@"UnitImperial"] = @"fl.oz";
                dict[@"QuantityImperial"] = [NSNumber numberWithFloat:[ingredientTextfield.text floatValue]* (float)0.0338];
            }
            else
            {
                dict[@"UnitImperial"] = dict[@"UnitMetric"];
                dict[@"QuantityImperial"] = [NSNumber numberWithFloat:[ingredientTextfield.text floatValue]];
            }
//        }
    mealDetails = dict;
//        [tempIngredientsArray addObject:dict];
//    }
//    mealListArray = tempIngredientsArray;
//    [mealListArray replaceObjectAtIndex:unitsButton.tag withObject:mealDetails];
}
-(void)calcPCFforSqIng:(float)cal{
    if (cal>0.0) {
        
        
        float quantity = 0;
        NSString *unitString = @"";
        //            quantity = [ingredientDict[@"QuantityImperial"] floatValue];
        if ([[defaults objectForKey:@"UnitPreference"] intValue] == 2)
        {
            quantity = [mealDetails[@"QuantityImperial"] floatValue];
            //quantity = [ingredientDict[@"QuantityMetric"] floatValue];
            unitString = mealDetails[@"UnitImperial"];
            //unitString = ingredientDict[@"UnitMetric"];
        }else
        {
            quantity = [mealDetails[@"QuantityMetric"] floatValue];
            unitString = mealDetails[@"UnitMetric"];
        }
        quantity = [ingredientTextfield.text floatValue];
        unitString = unitsButton.titleLabel.text;
        
        if ([unitString isEqualToString:@"as needed"] || [unitString isEqualToString:@"to taste"])
        {
            quantity = 0;
        }
        float quantityGrams = 0.0;
        if (quantity > 0 && quantity != 0 && ![unitString isEqualToString:@""])
        {
            quantityGrams = quantity;
            if ([unitString isEqualToString:mealDetails[@"ConversionUnit"]])
                quantityGrams = quantity * 100 / [mealDetails[@"ConversionNum"] floatValue];
            
        }
        if (quantityGrams > 0.0) {
            carbsTextField.text = [Utility customRoundNumber:([serveTextField.text floatValue] * [mealDetails[@"CarbsPer100"] floatValue] * quantityGrams) / 100];
            proteinTextField.text = [Utility customRoundNumber:([serveTextField.text floatValue] * [mealDetails[@"ProteinPer100"] floatValue] * quantityGrams) / 100];
            fatTextField.text = [Utility customRoundNumber:([serveTextField.text floatValue] * [mealDetails[@"FatPer100"] floatValue] * quantityGrams) / 100];
        } else {
            carbsTextField.text = @"0";
            proteinTextField.text = @"0";
            fatTextField.text = @"0";
        }
    } else {
        carbsTextField.text = @"0";
        proteinTextField.text = @"0";
        fatTextField.text = @"0";
    }
}
#pragma mark -End

#pragma mark - UIImagePickerControllerDelegate methods

/*
 Open PECropViewController automattically when image selected.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image =[Utility scaleImage:image width:image.size.width height:image.size.height];
    previewImageView.image = image;
    selectedImage=image;
    
    [self setStackAllignment:NO];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditor];
    }];
}
#pragma mark - End
#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    //    userImageView.image = croppedImage;
    //    UIImage *image=[self scaleImage:croppedImage];
    previewImageView.image = croppedImage;
    selectedImage = croppedImage;
    
    
    
    //    [self writeImageInDocumentsDirectory:chosenImage];
    //    [self webservicecallForUploadImage];
    
    [self loadPreviewImageWithImage:selectedImage isNewPic:YES];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //[self updateEditButtonEnabled];
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //[self updateEditButtonEnabled];
    }
    [self loadPreviewImageWithImage:selectedImage isNewPic:YES];
    [controller dismissViewControllerAnimated:YES completion:NULL];
}



//chayan 23/10/2017
#pragma mark progressbar delegate

- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"] boolValue]) {
            if (self->isNextMultiPart) {
                self->savedMealId=[responseDict[@"Id"] intValue];
                self->isAdd=NO;
                self->isNextButtonPressed=true;
                self->beforeEatingMealView.hidden = NO;
                self->afterEatingMealView.hidden = NO;
//                self->nextButton.enabled = NO;
                self->mealNameButton.enabled = true;
                self->trackView.hidden = true;
//                self->addToPlanView.hidden = true;
//                self->updatePlanView.hidden = false;
                
            }
            else{
                self->isChanged = true;
                [self backToMealMatch];
                
            }
            
        }
        else{
            [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
            return;
        }
    });
}


- (void) completedWithError:(NSError *)error{
    
    [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
}



#pragma Mark End

#pragma mark - Advance Search Delegate

-(void)didSelectSearchOption:(NSMutableDictionary *)searchDict sender:(UIButton *)sender{
    
    if (![Utility isEmptyCheck:searchDict]) {
        
        NSDictionary *data = searchDict;
        
        [mealNameButton setTitle:![Utility isEmptyCheck:data[@"MealName"]] ? data[@"MealName"] :@"" forState:UIControlStateNormal];
        MealName = ![Utility isEmptyCheck:data[@"MealName"]] ? data[@"MealName"] :@"";
        MealId = ![Utility isEmptyCheck:data[@"Id"]] ? [data[@"Id"] intValue] :0;
        mealNameButton.tag = [mealListArray indexOfObject:data];
        
        int mealType = [data[@"MealType"] intValue];
//        if(mealType == 0){
//            MealType = 0;
//            [self mealTypeButtonPressed:mealTypeButton[0]];
//        }else
            if(mealType == 4 || _MealType == 4){
//            MealType = 4;
            [self mealTypeButtonPressed:mealTypeButton[1]];
        }else{
//            MealType = 0;
            [self mealTypeButtonPressed:mealTypeButton[0]];
        }
        
        if (!isStatic && !isStaticIngredient){
            mealTypeNameLabel.text = MealName;
        }
        
        if(![Utility isEmptyCheck:data[@"Photo"]]){
            
            [previewImageView sd_setImageWithURL:[NSURL URLWithString:data[@"Photo"]]
                                placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    //                                        selectedImage = previewImageView.image;
                                }];
            [mealImage sd_setImageWithURL:[NSURL URLWithString:data[@"Photo"]]
                                placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    //                                        selectedImage = previewImageView.image;
                                }];
            
        }else if(![Utility isEmptyCheck:data[@"PhotoPath"]]){
            
            [previewImageView sd_setImageWithURL:[NSURL URLWithString:data[@"PhotoPath"]]
                                placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    //                                        selectedImage = previewImageView.image;
                                }];
            [mealImage sd_setImageWithURL:[NSURL URLWithString:data[@"PhotoPath"]]
                                placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    //                                        selectedImage = previewImageView.image;
                                }];
        }
    }
}
-(void)mealSerachWithFilterData:(NSDictionary *)dict ingredientsAllList:(NSArray *)ingredientsAllList dietaryPreferenceArray:(NSArray *)dietaryPreferenceArray{
    self->searchDict = dict;
    self->ingredientsAllList = ingredientsAllList;
    self->dietaryPreferenceArray = dietaryPreferenceArray;
}
#pragma mark - End

@end

