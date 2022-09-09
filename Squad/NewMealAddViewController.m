//
//  NewMealAddViewController.m
//  Squad
//
//  Created by AQB Solutions Private Limited on 09/11/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "NewMealAddViewController.h"
#import "FoodScanViewController.h"
#import "MealAddHeaderCollectionViewCell.h"
#import "MealListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AddRecipeViewController.h"
#import "AddToPlanViewController.h"
#import "EdamamSearchViewController.h"
#import "MealMatchTableViewCell.h"

@interface NewMealAddViewController ()
{
    __weak IBOutlet UIButton *addButton;
    __weak IBOutlet UIButton *headerButton;
    IBOutlet UICollectionView *allHeaderListCollection;
    IBOutlet UIButton *leftDot;
    IBOutlet UIButton *rightDot;
    IBOutlet UITableView *mealTable;
    IBOutlet UITableView *personalTable;
    IBOutlet UITableView *searchTable;
    IBOutlet UILabel *blankMsgLabel;
    IBOutlet UILabel *noData;
    IBOutlet UIScrollView *mainScroll;
    
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *servingSizeTextField;
    IBOutlet UITextField *calTextField;
    IBOutlet UITextField *carbTextField;
    IBOutlet UITextField *fatTextField;
    IBOutlet UITextField *proteinTextField;
    IBOutletCollection(UITextField) NSArray *textFieldsCollection;
    IBOutlet UITextField *searchTextField;
    
    IBOutlet UILabel *carbLabel;
    IBOutlet UILabel *fatLabel;
    IBOutlet UILabel *proteinLabel;
    IBOutlet UIButton *squadSearchButton;
    IBOutlet UIView *saveView;
    
    IBOutlet UIButton *breakfast;
    IBOutlet UIButton *dinner;
    IBOutlet UIButton *lunch;
    IBOutlet UIButton *snack;
    IBOutlet UITextField *recipeName;
    IBOutlet UITextField *recipePrepTime;
    
    UITextField *activeTextField;
    UIToolbar *toolBar;
    
    BOOL GetMeals;
    BOOL GetIngredients;
    NSString *EdamamNextPageUrl;
    NSMutableArray *mealArray;
    int pageNo;
    __weak IBOutlet UIView *searchView;
    
    IBOutlet UIView *quickAddView;
    IBOutletCollection(UIButton) NSArray *searchButtons;
    IBOutlet UIView *collectionSuperView;
    
    NSArray *mealListArray;
    NSArray *recentMealArray;
    NSArray *frequentMealArray;
    
    NSArray *allHeaderListArr;
    NSUInteger selectedIndex;
    
    int apiCount;
    UIView *contentView;
//    NSDate *currentDate;
    NSDateFormatter *dailyDateformatter;
    BOOL isChanged;
    BOOL isEdit;
    NSDictionary *searchDict;
    NSArray *ingredientsAllList;
    NSArray *dietaryPreferenceArray;
    NSArray *mealTypeArray;
    
    NSDictionary *edamamRequestDict;
    NSArray *advanceMealList;
    int searchPage;//1 edamam, 2 squad
    NSArray *personalFoodArray;
    NSArray *filteredPersonalFoodArray;
}
@end

@implementation NewMealAddViewController
@synthesize delegate,currentDate;
#pragma mark-View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    GetMeals = true;
    GetIngredients = true;
    EdamamNextPageUrl = @"";
    searchTextField.text = @"";
    apiCount = 0;
    noData.text = @"No meal found";
    noData.hidden = false;
    mealArray = [NSMutableArray new];
    searchTable.hidden = true;
    pageNo = 1;
    searchView.hidden = true;
    
    searchPage = 0;
    mealTypeArray = [[NSArray alloc]initWithObjects:@"MEAL",@"BREAKFAST",@"LUNCH",@"DINNER",@"SNACKS", nil];
    [headerButton setTitle:[@"ADD "stringByAppendingFormat:@"%@",[mealTypeArray objectAtIndex:_mealType]] forState:UIControlStateNormal];
    mainScroll.hidden = true;
    saveView.hidden = true;
    apiCount = 0;
    if (![Utility isEmptyCheck:[defaults objectForKey:@"SelectMealAddIndex"]]) { //SB_TEST
        selectedIndex = [[defaults objectForKey:@"SelectMealAddIndex"] intValue];
    }else{
        selectedIndex = 0;
    }//SB_TEST
    if(selectedIndex == 0){
        squadSearchButton.hidden = false;
    }else{
        squadSearchButton.hidden = true;
    }
    personalTable.hidden = true;
    isChanged = true;
//    currentDate = [NSDate date];
    allHeaderListArr = @[@"MY PLAN",@"RECENT",@"FREQUENT",@"CREATE RECIPE"];
    mealTable.estimatedRowHeight = 60;
    mealTable.rowHeight = UITableViewAutomaticDimension;
    personalTable.estimatedRowHeight = 45;
    personalTable.rowHeight = UITableViewAutomaticDimension;
    searchTable.estimatedRowHeight = UITableViewAutomaticDimension;
    searchTable.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    UIView *paddingViewMinCal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, calTextField.frame.size.height)];
    calTextField.leftView = paddingViewMinCal;
    calTextField.leftViewMode = UITextFieldViewModeAlways;
    paddingViewMinCal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, carbTextField.frame.size.height)];
    carbTextField.leftView = paddingViewMinCal;
    carbTextField.leftViewMode = UITextFieldViewModeAlways;
    paddingViewMinCal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, fatTextField.frame.size.height)];
    fatTextField.leftView = paddingViewMinCal;
    fatTextField.leftViewMode = UITextFieldViewModeAlways;
    paddingViewMinCal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, proteinTextField.frame.size.height)];
    proteinTextField.leftView = paddingViewMinCal;
    proteinTextField.leftViewMode = UITextFieldViewModeAlways;
    paddingViewMinCal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, nameTextField.frame.size.height)];
    nameTextField.leftView = paddingViewMinCal;
    nameTextField.leftViewMode = UITextFieldViewModeAlways;
    paddingViewMinCal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, servingSizeTextField.frame.size.height)];
    servingSizeTextField.leftView = paddingViewMinCal;
    servingSizeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {    //add24
        recipeName.text =[@"" stringByAppendingFormat:@"%@'s - ",[defaults objectForKey:@"FirstName"]];
    }else{
        recipeName.text = @"";
    }
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, recipeName.frame.size.height)];
    recipeName.leftView = paddingView;
    recipeName.leftViewMode = UITextFieldViewModeAlways;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, recipePrepTime.frame.size.height)];
    recipePrepTime.leftView = paddingView;
    recipePrepTime.leftViewMode = UITextFieldViewModeAlways;
    recipeName.layer.borderWidth = 1.0;
    recipeName.layer.borderColor = squadSubColor.CGColor;
    recipePrepTime.layer.borderWidth = 1.0;
    recipePrepTime.layer.borderColor = squadSubColor.CGColor;
    recipeName.layer.cornerRadius = 10.0;
    recipeName.layer.masksToBounds = YES;
    recipePrepTime.layer.cornerRadius = 10.0;
    recipePrepTime.layer.masksToBounds = YES;
    saveView.layer.cornerRadius = 15.0;
    saveView.layer.masksToBounds = YES;
    
    [self registerForKeyboardNotifications];
    
    squadSearchButton.layer.borderWidth = 1;
    squadSearchButton.layer.borderColor = squadMainColor.CGColor;
    for (UITextField *tField in textFieldsCollection) {
        tField.layer.borderWidth = 1;
        tField.layer.borderColor = squadSubColor.CGColor;
        tField.layer.cornerRadius = 10.0;
        tField.layer.masksToBounds = YES;
    }
    
    int unitPrefererence = [[defaults objectForKey:@"UnitPreference"] intValue];
    NSString *weight;//, *measurements;
    if (unitPrefererence ==0 || unitPrefererence ==1) {
        weight = @"(g)";
//        measurements = @"cm";
    }else{
        weight = @"(oz)";
//        measurements = @"inches";
    }
    carbLabel.text = [@"Carbohydrates " stringByAppendingFormat:@"%@",weight];
    fatLabel.text = [@"Fat " stringByAppendingFormat:@"%@",weight];
    proteinLabel.text = [@"Protein " stringByAppendingFormat:@"%@",weight];
    quickAddView.hidden = true;
    for (UIView *view in searchButtons) {
        view.layer.cornerRadius = 15.0;
        view.layer.masksToBounds = YES;
    }
    addButton.layer.cornerRadius = 15.0;
    addButton.layer.masksToBounds = YES;
    collectionSuperView.hidden = false;
    [nameTextField addTarget:self action:@selector(textValueChange:) forControlEvents:UIControlEventEditingChanged];
//    if (![Utility isEmptyCheck:_quickMeal]) {
//        [self addManuallyButtonPressed:0];
//        [addButton setTitle:@"UPDATE" forState:UIControlStateNormal];
//        nameTextField.text = ![Utility isEmptyCheck:[_quickMeal objectForKey:@"PersonalFoodName"]]?[@"" stringByAppendingFormat:@"%@",[_quickMeal objectForKey:@"PersonalFoodName"]]:@"";
//        servingSizeTextField.text = ![Utility isEmptyCheck:[_quickMeal objectForKey:@"Quantity"]]?[@"" stringByAppendingFormat:@"%@",[_quickMeal objectForKey:@"Quantity"]]:@"1";
//        calTextField.text = ![Utility isEmptyCheck:[_quickMeal objectForKey:@"Calories"]]?[@"" stringByAppendingFormat:@"%@",[_quickMeal objectForKey:@"Calories"]]:@"0";
//        proteinTextField.text = ![Utility isEmptyCheck:[_quickMeal objectForKey:@"Protein"]]?[@"" stringByAppendingFormat:@"%@",[_quickMeal objectForKey:@"Protein"]]:@"0";
//        carbTextField.text = ![Utility isEmptyCheck:[_quickMeal objectForKey:@"Carb"]]?[@"" stringByAppendingFormat:@"%@",[_quickMeal objectForKey:@"Carb"]]:@"0";
//        fatTextField.text = ![Utility isEmptyCheck:[_quickMeal objectForKey:@"Fat"]]?[@"" stringByAppendingFormat:@"%@",[_quickMeal objectForKey:@"Fat"]]:@"0";
//    }
//    [self getUserPersonalFoods];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [allHeaderListCollection addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
    if (isChanged) {
        isChanged = false;
        [self getListData];
    }
//    if (searchPage == 1) {
//        UIButton *btn = [UIButton new];
//        btn.tag = 0;
//        [self searchButtonPressed:btn];
//    } else
    if (searchPage == 2) {
        UIButton *btn = [UIButton new];
        btn.tag = 1;
        [self searchButtonPressed:btn];
    }
    searchPage = 0;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    @try {
        [allHeaderListCollection removeObserver:self forKeyPath:@"contentSize"];
    } @catch (NSException *exception) {
        //
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if(object == allHeaderListCollection){
        CGFloat totalWidth = allHeaderListCollection.contentSize.width;
        CGFloat xOffset = allHeaderListCollection.contentOffset.x;
        if (xOffset > 0) {
            leftDot.hidden = false;
        }else{
            leftDot.hidden = true;
        }
        if (totalWidth - xOffset - allHeaderListCollection.frame.size.width > 0) {
            rightDot.hidden = false;
        }else{
            rightDot.hidden = true;
        }
        
    }
}
#pragma mark-End
#pragma mark-IBAction
-(IBAction)backPressed:(id)sender{
    if (activeTextField != nil) {
        [self btnClickedDone:0];
        return;
    }
    [self btnClickedDone:0];
    if (!searchView.isHidden) {
        searchView.hidden = true;
        searchTextField.text = @"";
    }
//    else if (!mainScroll.isHidden) {
//        if (!personalTable.isHidden) {
//            personalTable.hidden = true;
//            return;
//        }else if (![Utility isEmptyCheck:_quickMeal]) {
//            [self.navigationController popViewControllerAnimated:NO];
//            return;
//        }
//        collectionSuperView.hidden = false;
//        for (UIView *view in searchButtons) {
//            view.hidden = false;
//        }
//        quickAddView.hidden = false;
//
//        mainScroll.hidden = true;
//        mealTable.hidden = false;
//        if(selectedIndex == 0){
//            squadSearchButton.hidden = false;
//        }else{
//            squadSearchButton.hidden = true;
//        }
//
//    }
    else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
- (IBAction)searchButtonPressed:(UIButton *)sender {
    
    if (sender.tag == 0) {//0 EDAMAM
//        EdamamSearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EdamamSearch"];
//        if (![Utility isEmptyCheck:edamamRequestDict]) {
//            controller.requestDict = [edamamRequestDict mutableCopy];
//        }
//        controller.delegate = self;
//        [self.navigationController pushViewController:controller animated:NO];
        
        if ([Utility isEmptyCheck:searchTextField.text]) {
            [Utility msg:@"Please enter a keyword to search." title:nil controller:self haveToPop:NO];
            return;
        }
        GetMeals = true;
        GetIngredients = true;
        EdamamNextPageUrl = @"";
        pageNo = 1;
        [mealArray removeAllObjects];
        searchTable.hidden = true;
        [self searchAllFood];
        
    } else if (sender.tag == 1) {//1 SQUAD
        FoodPrepSearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrepSearch"];
        controller.delegate=self;
        controller.sender = sender;
        controller.isFromMealMatch = YES;
        //    if(mealTypeData == 2){
        //        controller.isMyRecipe = YES;
        //    }else{
        //        controller.isMyRecipe = NO;
        //    }
        if (![Utility isEmptyCheck:searchDict]) {
            controller.defaultSearchDict = [searchDict mutableCopy];
        }
        if (![Utility isEmptyCheck:ingredientsAllList]) {
            controller.ingredientsAllList = ingredientsAllList;
        }
        if (![Utility isEmptyCheck:dietaryPreferenceArray]) {
            controller.dietaryPreferenceArray = dietaryPreferenceArray;
        }
        if (![Utility isEmptyCheck:advanceMealList]) {
            controller.allMealArray = advanceMealList;
        }
        controller.delegate = self;
        //controller.modalPresentationStyle = UIModalPresentationCustom;
        [self.navigationController pushViewController:controller animated:NO];
    }
    
}
-(IBAction)lodeMorePressed:(UIButton *)sender{
    pageNo++;
    [self searchAllFood];
}
- (IBAction)scanButtonPressed:(UIButton *)sender {
    FoodScanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodScanView"];
    controller.currentDate = currentDate;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)addCaloriesPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    BOOL apiCall = true;
    NSString *message = @"";
    if ([Utility isEmptyCheck:nameTextField.text]) {
        apiCall = false;
        message = @"Please enter name.";
    } else if (servingSizeTextField.text.floatValue<=0.0) {
        apiCall = false;
        message = @"Please enter serving size greater than 0.";
    }
    if (!apiCall) {
        [Utility msg:message title:nil controller:self haveToPop:NO];
        return;
    }
    apiCall = false;
    if (carbTextField.text.floatValue>0.0) {
        apiCall = true;
    } else if (proteinTextField.text.floatValue>0.0) {
        apiCall = true;
    } else if (fatTextField.text.floatValue>0.0) {
        apiCall = true;
    } else if (calTextField.text.floatValue>0.0) {
        apiCall = true;
    }
    if (apiCall) {
        [self quickAddSquadUserActualMealWithPhoto];
    } else {
        message = @"Please enter calorie, protein, carbohydrate, fat.";
        [Utility msg:message title:nil controller:self haveToPop:NO];
    }
}
- (IBAction)quickAddButtonPressed:(UIButton *)sender {
//    quickAddView.hidden = !quickAddView.isHidden;
    
}
- (IBAction)addManuallyButtonPressed:(UIButton *)sender {
    //    mainScroll.hidden = false;
    //    mealTable.hidden = true;
    //    squadSearchButton.hidden = true;
    //    collectionSuperView.hidden = true;
    //    for (UIView *view in searchButtons) {
    //        view.hidden = true;
    //    }
    //    quickAddView.hidden = true;
//    if(currentDate)return;//remove before sending
    AddToPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddToPlanView"];
    controller.MealType = _mealType;
    controller.actualMealType = Quick;
    controller.currentDate = currentDate;
    controller.isAdd = true;
    controller.isStatic = false;
    controller.mealTypeData = 3;
    controller.mealDetails = [NSMutableDictionary new];//empty for quick add
    controller.mealListArray = [NSMutableArray new];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:NO];
    
}
-(IBAction)cheekUncheckButtonPressed:(UIButton*)sender{
    [self.view endEditing:YES];
    if([sender isEqual:breakfast] ){
        breakfast.selected = !breakfast.isSelected;
    }else if([sender isEqual:lunch]){
        lunch.selected = !lunch.isSelected;
    }else if([sender isEqual:dinner]){
        dinner.selected = !dinner.isSelected;
    }else if([sender isEqual:snack]){
        snack.selected = !snack.isSelected;
    }
//    else if([sender isEqual:drink]){
//        drink.selected = !drink.isSelected;
//    }
    //    if (sender.isSelected) {
    //        [sender setBackgroundColor:squadMainColor];
    //    } else {
    //        [sender setBackgroundColor:[UIColor whiteColor]];
    //    }
//    [mealData setObject:[NSNumber numberWithBool:breakfast.isSelected] forKey:@"IsBreakfast"];
//    [mealData setObject:[NSNumber numberWithBool:dinner.isSelected] forKey:@"IsDinner"];
//    [mealData setObject:[NSNumber numberWithBool:lunch.isSelected] forKey:@"IsLunch"];
//    [mealData setObject:[NSNumber numberWithBool:snack.isSelected] forKey:@"IsSnack"];
//    [mealData setObject:[NSNumber numberWithBool:drink.isSelected] forKey:@"IsDrink"];
    
}

-(IBAction)saveButtonClicked:(id)sender{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    if ([Utility isEmptyCheck:recipeName.text]) {
        [Utility msg:@"Recipe Name cannot be blank." title:@"Warning !" controller:self haveToPop:NO];
        return;
        
    }else if ([Utility isEmptyCheck:recipePrepTime.text]) {
        [Utility msg:@"Please enter Preparation Time." title:@"Warning !" controller:self haveToPop:NO];
        return;
        
    }else if([Utility isEmptyCheck:[formatter numberFromString:recipePrepTime.text]]){
        [Utility msg:@"Please enter valid Preparation Time." title:@"Warning !" controller:self haveToPop:NO];
        return;
        
    }
    
    [self webservicecall_GetUserRecipeByName];
}
#pragma mark-End

#pragma mark - Private Method
-(void)getListData{
    dailyDateformatter = [[NSDateFormatter alloc]init];
    [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
    currentDate = [dailyDateformatter dateFromString:dateString];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getMealPlanList];
        [self getFrequentMeals:NO];//for frequent
        [self getFrequentMeals:YES];//for recent
     });
    
}
#pragma mark - End

#pragma mark  - WebService Call
-(void)getMealPlanList{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];

        if (![Utility isEmptyCheck:currentDate]) {
            NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
            //[mainDict setObject:dateString forKey:@"RunDate"];
            [mainDict setObject:dateString forKey:@"Datetime"];
        }
        
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
            self->mealTable.hidden = true;
            self->blankMsgLabel.hidden = false;
            self->mealListArray = [[NSArray alloc]init];
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadMealPlanCalories" append:@""forAction:@"POST"];
        
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
                                                                         NSArray *rawNutritionDataArray = responseDict[@"SquadMealSessions"];
                                                                         if (![Utility isEmptyCheck:rawNutritionDataArray ] && ![Utility isEmptyCheck:self->currentDate]) {
                                                                             NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                                                                             formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
                                                                             
                                                                             NSString *dateString = [formatter stringFromDate:self->currentDate];
                                                                             NSArray *filteredarray = [rawNutritionDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(MealDate == %@)", dateString]];
                                                                             if (filteredarray.count > 0) {
                                                                                 self->mealListArray = filteredarray;
                                                                                 if (self->selectedIndex == 3) {
                                                                                     self->mealTable.hidden = true;
                                                                                 }else{
                                                                                     self->mealTable.hidden = false;
                                                                                 }
                                                                                 self->blankMsgLabel.hidden = true;
                                                                                 
                                                                                 if (self->mealListArray.count>0){
                                                                                     [self->mealTable reloadData];
                                                                                 }
                                                                             }else{
                                                                                 
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
-(void)getFrequentMeals:(BOOL)isRecent{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        if (isRecent) {
            NSDate *date = [currentDate dateByAddingDays:-30];
            NSString *dateString = [dailyDateformatter stringFromDate:date];
            //[mainDict setObject:dateString forKey:@"RunDate"];
            [mainDict setObject:dateString forKey:@"FromDate"];
        }
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetFrequentMeals" append:@""forAction:@"POST"];
        
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
                                                                         NSArray *mealArray1 = [responseDict objectForKey:@"FrequentMeals"];
                                                                         if (![Utility isEmptyCheck:mealArray1]) {
                                                                             if (isRecent) {
                                                                                 self->recentMealArray = mealArray1;
                                                                             } else {
                                                                                 self->frequentMealArray = mealArray1;
                                                                             }
                                                                             [self->mealTable reloadData];
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
-(void)getMealDetailsById:(int)Id{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:Id] forKey:@"MealId"];
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMealDetailsApiCall" append:@""forAction:@"POST"];
        
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
                                                                     //                                                                    NSLog(@"%@",responseDict);
                                                                     
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:responseDict[@"Meal"]]) {
                                                                             NSDictionary *meal = responseDict[@"Meal"];
                                                                             NSDictionary *mealDetails = meal[@"MealData"];
                                                                             if (![Utility isEmptyCheck:mealDetails]){
                                                                                 NSMutableArray *temp = [[NSMutableArray alloc]init];
                                                                                 temp[0] = mealDetails;
                                                                                 AddToPlanViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddToPlanView"];
                                                                                 controller.MealType = self->_mealType;
                                                                                 controller.actualMealType = SqMeal;
                                                                                 controller.currentDate = self->currentDate;
                                                                                 controller.isAdd = true;
                                                                                 controller.isStatic = false;
                                                                                 controller.mealTypeData = 3;
                                                                                 controller.mealDetails = [mealDetails mutableCopy];
                                                                                 controller.delegate = self;
                                                                                 controller.mealListArray = [temp mutableCopy];
                                                                                 [self.navigationController pushViewController:controller animated:true];
                                                                                 
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
-(void)quickAddSquadUserActualMealWithPhoto{
    
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[dailyDateformatter stringFromDate:currentDate] forKey:@"Datetime"];
        [mainDict setObject:[NSNumber numberWithInt:3] forKey:@"RecipeMealTracker"];
        [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"MealOrder"];
        
        NSMutableDictionary *dict = [NSMutableDictionary new];//IsCalorieOnly
        [dict setObject:nameTextField.text forKey:@"MealName"];
        [dict setObject:nameTextField.text forKey:@"PersonalFoodName"];
        
        if (![Utility isEmptyCheck:_quickMeal]) {//Id
            int mId = ![Utility isEmptyCheck:[_quickMeal objectForKey:@"Id"]]?[[_quickMeal objectForKey:@"Id"]intValue]:0;
            if(mId>0){
                [dict setObject:[NSNumber numberWithInt:mId] forKey:@"Id"];
            }
        }
        
        [dict setObject:[NSNumber numberWithFloat:[servingSizeTextField.text floatValue]] forKey:@"Quantity"];
        [dict setObject:[NSNumber numberWithInt:_mealType] forKey:@"MealType"];
        [dict setObject:[NSNumber numberWithFloat:carbTextField.text.floatValue] forKey:@"Carb"];
        [dict setObject:[NSNumber numberWithFloat:proteinTextField.text.floatValue] forKey:@"Protein"];
        [dict setObject:[NSNumber numberWithFloat:fatTextField.text.floatValue] forKey:@"Fat"];
        [dict setObject:[NSNumber numberWithFloat:calTextField.text.floatValue] forKey:@"Calories"];
        [dict setObject:[dailyDateformatter stringFromDate:currentDate] forKey:@"DateAdded"];
        [dict setObject:[dailyDateformatter stringFromDate:currentDate] forKey:@"DateTime"];
        
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"BeforeCravings"];
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"BeforeEnergy"];
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"AfterEnergy"];
        [dict setObject:[NSNumber numberWithBool:0] forKey:@"IsPositive"];
        [dict setObject:[NSNumber numberWithBool:0] forKey:@"IsStressed"];
        [dict setObject:[NSNumber numberWithBool:0] forKey:@"IsBadAboutMyself"];
        [dict setObject:[NSNumber numberWithBool:0] forKey:@"IsDepressed"];
        
        [dict setObject:[NSNumber numberWithBool:0] forKey:@"IsEnergizedAndFocused"];
        [dict setObject:[NSNumber numberWithBool:0] forKey:@"IsAnxious"];
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"AfterCravings"];
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"AfterBloat"];
        [dict setObject:[NSNumber numberWithBool:0] forKey:@"IsTired"];
        [dict setObject:[NSNumber numberWithBool:0] forKey:@"IsAngry"];
        [dict setObject:[NSNumber numberWithBool:0] forKey:@"IsHappy"];
        [dict setObject:@"" forKey:@"Photo"];
        [dict setObject:[NSNumber numberWithBool:0] forKey:@"IsUpset"];
        [dict setObject:[NSNumber numberWithBool:0] forKey:@"IsBored"];
        
        [mainDict setObject:dict forKey:@"SquadUserActualMealModel"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddSquadUserActualMealWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.chosenImage=nil;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    //[Utility msg:@"Successfully saved" title:nil controller:self haveToPop:YES];
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
                                                                         //                                                                         NSLog(@"%@",responseDict);
                                                                         
                                                                         AddToPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddToPlanView"];
                                                                         controller.isAdd = true;
                                                                         controller.isStatic = false;
                                                                         controller.isStaticIngredient = true;
                                                                         controller.mealTypeData = mealTypeData;
                                                                         controller.mealDetails = [mealdetails mutableCopy];
                                                                         controller.mealListArray = [responseDict objectForKey:@"Ingredients"];
                                                                         controller.delegate =self;
                                                                         controller.currentDate = self->currentDate;
                                                                         controller.MealType = self->_mealType;
                                                                         controller.actualMealType = SqIngredient;
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
-(void)getNutritionixMealDetailsById:(NSString *)mealStringId mealDict:(NSMutableDictionary *)mealDict{   //ah 02
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
                                                                         NSArray *food = [responseDict objectForKey:@"foods"];
                                                                         if (![Utility isEmptyCheck:food]) {
                                                                             NSMutableDictionary *myMeal = [[food objectAtIndex:0] mutableCopy];
                                                                             if (![Utility isEmptyCheck:myMeal]) {
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"food_name"]]?[myMeal objectForKey:@"food_name"]:@"" forKey:@"MealName"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"food_name"]]?[myMeal objectForKey:@"food_name"]:@"" forKey:@"EdamamFoodName"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nix_item_id"]]?[myMeal objectForKey:@"nix_item_id"]:@"" forKey:@"EdamamdFoodId"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nix_item_id"]]?[myMeal objectForKey:@"nix_item_id"]:@"" forKey:@"MealId"];
                                                                                 [myMeal setObject:[NSNumber numberWithBool:true] forKey:@"IsEdamam"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"brand_name"]]?[myMeal objectForKey:@"brand_name"]:@"" forKey:@"Brand"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_total_carbohydrate"]]?[myMeal objectForKey:@"nf_total_carbohydrate"]:@"0" forKey:@"Carbohydrates"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_total_carbohydrate"]]?[myMeal objectForKey:@"nf_total_carbohydrate"]:@"0" forKey:@"CarbohydratesPer100"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_calories"]]?[myMeal objectForKey:@"nf_calories"]:@"" forKey:@"EdamamCalories"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_calories"]]?[myMeal objectForKey:@"nf_calories"]:@"" forKey:@"EdamamCaloriesPer100"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"serving_weight_grams"]]?[myMeal objectForKey:@"serving_weight_grams"]:@"" forKey:@"EdamamServeGrams"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_total_fat"]]?[myMeal objectForKey:@"nf_total_fat"]:@"" forKey:@"Fat"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_total_fat"]]?[myMeal objectForKey:@"nf_total_fat"]:@"" forKey:@"FatPer100"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_protein"]]?[myMeal objectForKey:@"nf_protein"]:@"" forKey:@"Protein"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_protein"]]?[myMeal objectForKey:@"nf_protein"]:@"" forKey:@"ProteinPer100"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_calories"]]?[myMeal objectForKey:@"nf_calories"]:@"" forKey:@"TotalCalories"];
                                                                                 
                                                                                 [self foodScanData:myMeal];
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
-(void)getUserPersonalFoods{
    
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
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserPersonalFoods" append:@""forAction:@"POST"];
        
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
                                                                         
                                                                         self->personalFoodArray = [responseDict objectForKey:@"UserPersonalFoods"];
                                                                         self->filteredPersonalFoodArray = [responseDict objectForKey:@"UserPersonalFoods"];
                                                                         
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
-(void)searchAllFood{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        [mainDict setObject:searchTextField.text forKey:@"SearchText"];
        [mainDict setObject:[NSNumber numberWithInt:pageNo] forKey:@"PageNo"];
        [mainDict setObject:[NSNumber numberWithBool:GetMeals] forKey:@"GetMeals"];
        [mainDict setObject:[NSNumber numberWithBool:GetIngredients] forKey:@"GetIngredients"];
        [mainDict setObject:EdamamNextPageUrl forKey:@"EdamamNextPageUrl"];
        [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"GetUserPersonalFoods"];
        
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
            //            self->noData.hidden = false;
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SearchAllFood" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 BOOL gotData = false;
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->GetMeals = [[responseDict objectForKey:@"MoreSquadMealsAvailable"]boolValue];
                                                                         self->GetIngredients = [[responseDict objectForKey:@"MoreSquadIngredientsAvailable"]boolValue];
                                                                         self->EdamamNextPageUrl = ![Utility isEmptyCheck:[responseDict objectForKey:@"EdamamNextPageUrl"]]?[responseDict objectForKey:@"EdamamNextPageUrl"]:@"";
                                                                         NSLog(@"\n%@%@%@\n",[NSNumber numberWithBool:self->GetMeals],[NSNumber numberWithBool:self->GetIngredients],self->EdamamNextPageUrl);
                                                                         NSArray *meal = [responseDict objectForKey:@"MealList"];
                                                                         if (![Utility isEmptyCheck:meal]) {
                                                                             gotData = true;
                                                                             [self->mealArray addObjectsFromArray:meal];
                                                                             [self->searchTable reloadData];
                                                                         }
                                                                         
                                                                         self->searchView.hidden = false;
                                                                         self->noData.hidden = ![Utility isEmptyCheck:self->mealArray];
                                                                         self->searchTable.hidden = [Utility isEmptyCheck:self->mealArray];
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                                 if (!gotData) {
                                                                     self->pageNo--;
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
-(void)webservicecall_GetUserRecipeByName{
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
                                                                          [self webserviceCall_IsMealNameExisting:[responseDict objectForKey:@"MealId"]];
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

-(void) webserviceCall_IsMealNameExisting:(NSNumber*)mealId; {
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
        [mainDict setObject:mealId forKey:@"MealId"];
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
                                                                          
                                                                          BOOL isExisting =[[responseDict objectForKey:@"IsExisting"]boolValue];
                                                                          if (isExisting) {
                                                                              UIAlertController * alert=   [UIAlertController
                                                                                                            alertControllerWithTitle:@"Alert"
                                                                                                            message:@"You have already personalised this recipe earlier, do you wish to edit the personalised one? if yes, click Confirm. If not, please enter a new name for this recipe before saving."
                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                                              
                                                                              UIAlertAction* ok = [UIAlertAction
                                                                                                   actionWithTitle:@"Confirm"
                                                                                                   style:UIAlertActionStyleDefault
                                                                                                   handler:^(UIAlertAction * action)
                                                                                                   {
                                                                                                       
                                                                                                       AddEditCustomNutritionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddEditCustomNutrition"];
                                                                                                       controller.mealId = mealId;
                                                                                                       controller.fromController = @"Recipe";        //ah ux
                                                                                                       controller.currentDate = self->currentDate;
                                                                                                       controller.isFromMealMatch = true;
                                                                                                       controller.delegate = self;
                                                                                                       [self.navigationController pushViewController:controller animated:YES];
                                                                                                       
                                                                                                   }];
                                                                              UIAlertAction* cancel = [UIAlertAction
                                                                                                       actionWithTitle:@"No"
                                                                                                       style:UIAlertActionStyleCancel
                                                                                                       handler:^(UIAlertAction * action)
                                                                                                       {
                                                                                                           
                                                                                                           self->recipeName.text = @"";                        NSLog(@"Resolving UIAlertActionController for tapping cancel button");
                                                                                                           
                                                                                                       }];
                                                                              [alert addAction:cancel];
                                                                              [alert addAction:ok];
                                                                              [self presentViewController:alert animated:YES completion:nil];
                                                                          }else{
                                                                              [self saveMealData];
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
-(void) saveMealData {
    if (Utility.reachable) {
        
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
//        if ([Utility isEmptyCheck:mealData]) {
        NSMutableDictionary *mealData = [[NSMutableDictionary alloc]init];
//        }
        
        if ([Utility isEmptyCheck:recipeName.text]) {
            [Utility msg:@"MealName required." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
        if ([Utility isEmptyCheck:recipePrepTime.text]) {
            [Utility msg:@"Preparation time required." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
        
        [mealData setObject:recipeName.text forKey:@"MealName"];
        [mealData setObject:[NSNumber numberWithFloat:[recipePrepTime.text floatValue]] forKey:@"PreparationMinutes"];
        [mealData setObject:[NSNumber numberWithBool:breakfast.isSelected] forKey:@"IsBreakfast"];
        [mealData setObject:[NSNumber numberWithBool:dinner.isSelected] forKey:@"IsDinner"];
        [mealData setObject:[NSNumber numberWithBool:lunch.isSelected] forKey:@"IsLunch"];
        [mealData setObject:[NSNumber numberWithBool:snack.isSelected] forKey:@"IsSnack"];
//        [mealData setObject:[NSNumber numberWithBool:drink.isSelected] forKey:@"IsDrink"];
        
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"TotalCalories" ];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Calories" ];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Fat" ];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"FatOz" ];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"FatSaturated"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"FatCals"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"FatPercentage"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Protein"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"ProteinOz"];
        [mealData setObject:@"" forKey:@"ProteinSource"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"ProtCals"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"ProteinPercentage"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Carbohydrates"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"CarbohydratesOz"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"CarbCals"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"CarbPercentage"];
        
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Fibre"];
        
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Mg"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Zn"];
        
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Se"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Fe"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"K"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Na"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Ca"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Sugar"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Serves"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"ServeSize"];
        
        
        [mealData setObject:@"" forKey:@"Region"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsGlutenFree"];
        [mealData setObject:[NSNumber numberWithInt:0] forKey:@"IsVegetarian"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsDairyFree"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsFodmapFriendly"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsKETO"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsPaleo"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsAntiOx"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"IsAntiInflam"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"HasWhiteMeat"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"NoSeaFood"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"NoEggs"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"NoNuts"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"NoLegumes"];
        
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"BBP_A"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"BBP_B"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"BBP_C"];
        
        [mealData setObject:@"" forKey:@"PhotoSmallPath"];
        [mealData setObject:@"" forKey:@"PhotoPath"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Cals"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"CalsTotal"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"MonoSaturated"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Omega6"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Omega3"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Trans"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"Omega6"];
        [mealData setObject:[NSNumber numberWithFloat:0.00] forKey:@"TotalPercentage"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"AllowSubmit"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"CanBePersonalised"];
        [mealData setObject:[NSNumber numberWithBool:false] forKey:@"CanBePersonalised"];
        [mealData setObject:[NSNumber numberWithBool:YES] forKey:@"IsSquad"];
        [mealData setObject:[NSNumber numberWithBool:NO] forKey:@"IsAbbbc"];
        [mealData setObject:[NSNumber numberWithInt:0] forKey:@"MealClassifiedID"];
        // [mealData setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:@{@"MealData" : mealData, @"Ingredients": [NSArray array], @"Instructions" : [NSArray array]} forKey:@"MealDetails"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateMealRecipeApiCall" append:@""forAction:@"POST"];
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
                                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup_nourish
                                                                          
                                                                          AddEditCustomNutritionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddEditCustomNutrition"];
                                                                          controller.MealType = self->_mealType;
                                                                          controller.mealId = responseDict[@"MealId"];
                                                                          controller.add = YES;
                                                                          controller.fromController = @"Recipe";        //ah ux
                                                                          controller.currentDate = self->currentDate;
                                                                          controller.isFromMealMatch = true;
                                                                          controller.delegate = self;
                                                                          [self.navigationController pushViewController:controller animated:YES];
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
-(void)getRecentlyAddedMeal:(NSString *)foodId foodType:(int)foodType{//"FoodId": "25",
    //"FoodType": 4,
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        [mainDict setObject:foodId forKey:@"FoodId"];
        [mainDict setObject:[NSNumber numberWithInt:foodType] forKey:@"FoodType"];
        
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
            //            self->noData.hidden = false;
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetRecentlyAddedMeal" append:@""forAction:@"POST"];
        
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
                                                                         
                                                                         NSMutableDictionary *searchDict = [responseDict objectForKey:@"RecentMeal"];
                                                                         if (![Utility isEmptyCheck:searchDict]) {
                                                                             searchDict = [searchDict mutableCopy];
                                                                             [searchDict setObject:@"" forKey:@"Id"];
                                                                             [searchDict setObject:searchDict[@"PersonalFoodName"] forKey:@"MealName"];
                                                                             
                                                                             NSMutableArray *temp = [[NSMutableArray alloc]init];
                                                                             temp[0] = searchDict;
                                                                             AddToPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddToPlanView"];
                                                                             //                                                                             if ([[searchDict objectForKey:@"IsSquadIngredient"]boolValue]) {
                                                                             //                                                                                 controller.isStaticIngredient = true;
                                                                             //                                                                             }
                                                                             controller.MealType = self->_mealType;
                                                                             //                                                                             if ([[searchDict objectForKey:@"IsUserPersonalFood"]boolValue]) {
                                                                             controller.actualMealType = Quick;
                                                                             controller.quickRecentFreq = true;
                                                                             //                                                                             } else if ([[searchDict objectForKey:@"IsEdamam"]boolValue]) {
                                                                             //                                                                                 controller.actualMealType = Nutritionix;
                                                                             //                                                                             } else if ([[searchDict objectForKey:@"IsSquadIngredient"]boolValue]) {
                                                                             //                                                                                 controller.actualMealType = SqIngredient;
                                                                             //                                                                             } else {
                                                                             //                                                                                 controller.actualMealType = SqMeal;
                                                                             //                                                                             }
                                                                             controller.currentDate = self->currentDate;
                                                                             controller.isAdd = true;
                                                                             controller.isStatic = false;
                                                                             controller.mealTypeData = 3;
                                                                             controller.mealDetails = [searchDict mutableCopy];
                                                                             controller.mealListArray = [temp mutableCopy];
                                                                             controller.delegate = self;
                                                                             [self.navigationController pushViewController:controller animated:NO];
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
#pragma mark progressbar delegate
- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"] boolValue]) {
            if ([self->delegate respondsToSelector:@selector(checkChangeMealAdd:)]) {
                [self->delegate checkChangeMealAdd:true];
            }
            [Utility msg:@"Successfully saved" title:nil controller:self haveToPop:YES];
        }else{
            [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
            return;
        }
    });
}

- (void) completedWithError:(NSError *)error{
    [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
}
#pragma Mark End

#pragma mark - CollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return allHeaderListArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MealAddHeaderCollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MealAddHeaderCollectionViewCell" forIndexPath:indexPath];
    cell.mealHeaderLabel.text = allHeaderListArr[indexPath.row];
    if (selectedIndex == indexPath.row) {
        cell.mealHeaderLabel.textColor  = [Utility colorWithHexString:@"E425A0"];
    }else{
        cell.mealHeaderLabel.textColor = [Utility colorWithHexString:@"333333"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (isEdit) {
        return;
    }
//    BOOL send = false;
    selectedIndex = indexPath.row;
    if(indexPath.row == allHeaderListArr.count-1){
//        send = true;
        mealTable.hidden = true;
        mainScroll.hidden = false;
        saveView.hidden = false;
    }else{
        mealTable.hidden = false;
        mainScroll.hidden = true;
        saveView.hidden = true;
        [mealTable reloadData];
    }
    [allHeaderListCollection reloadData];
    [allHeaderListCollection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
//    if(send){
//        AddRecipeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddRecipeView"];
//        controller.MealType = _mealType;
//        controller.currentDate = currentDate;
//        controller.isFromMealMatch = true;
//        [self.navigationController pushViewController:controller animated:NO];
//    }else{
//        if(indexPath.row == 3){
//            mealTable.hidden = true;
//            mainScroll.hidden = false;
//        }else{
//        mealTable.hidden = false;
//        mainScroll.hidden = true;
//        [mealTable reloadData];
//        }
//    }
    if(selectedIndex == 0){
        squadSearchButton.hidden = false;
    }else{
        squadSearchButton.hidden = true;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGSize frameSize = CGSizeMake(collectionView.bounds.size.width/3, 40);
    return frameSize;
    
}

#pragma mark - End

#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == personalTable) {
        return filteredPersonalFoodArray.count;
    }else if(tableView == searchTable){
        return mealArray.count;
    }
    
    if(selectedIndex == 0){
        return mealListArray.count;
    }else if (selectedIndex == 1){
        return recentMealArray.count;
    }else if (selectedIndex == 2){
        return frequentMealArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == searchTable) {
        BOOL showFooter = false;
        if (![Utility isEmptyCheck:EdamamNextPageUrl]) {
            showFooter = true;
        }else if (GetMeals || GetIngredients) {
            showFooter = true;
        }else{
            showFooter = false;
        }
        if (showFooter) {
            return 50;
        }else{
            return CGFLOAT_MIN;
        }
    } else {
        return CGFLOAT_MIN;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == searchTable) {
        BOOL showFooter = false;
        float height = 0.0;
        if (![Utility isEmptyCheck:EdamamNextPageUrl]) {
            showFooter = true;
            height = 50.0;
        }else if (GetMeals || GetIngredients) {
            showFooter = true;
            height = 50.0;
        }else{
            showFooter = false;
            height = CGFLOAT_MIN;
        }
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
        if (showFooter) {
            [myView setBackgroundColor:[UIColor whiteColor]];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect frame = myView.frame;
            frame.size.height = myView.frame.size.height - 10;
            button.frame = frame;
            [button addTarget:self action:@selector(lodeMorePressed:) forControlEvents:UIControlEventTouchUpInside];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:squadMainColor forState:UIControlStateNormal];
            [button setTitle:@"Load more" forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"Oswald-Light" size:17]];
            //    [button setImage:[UIImage imageNamed:@"fp_plus.png"] forState:UIControlStateNormal];
            //    [button setContentEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
            
            [myView addSubview:button];
        }
        
        return myView;
    }else{
        return nil;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == searchTable) {
        NSString *CellIdentifier = @"MealMatchTableSingleViewCell";
        MealMatchTableViewCell *cell = (MealMatchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MealMatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (![Utility isEmptyCheck:mealArray]) {
            NSDictionary *mealDetails = [mealArray objectAtIndex:indexPath.row];
            cell.headerView.hidden = true;
            if (![Utility isEmptyCheck:mealDetails]) {
                
                //            cell.myMealName.text = ![Utility isEmptyCheck:[mealDetails objectForKey:@"MealName"]]?[[mealDetails objectForKey:@"MealName"]capitalizedString]:@"";
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",![Utility isEmptyCheck:[mealDetails objectForKey:@"MealName"]]?[[mealDetails objectForKey:@"MealName"]capitalizedString]:@""]];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-SemiBold" size:16] range:NSMakeRange(0, [attributedString length])];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"58595B"] range:NSMakeRange(0, [attributedString length])];
                
                BOOL IsSquadIngredient = [[mealDetails objectForKey:@"IsSquadIngredient"] boolValue];
                
                if(IsSquadIngredient){
                    
                    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  (per 100)"]];
                    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:16] range:NSMakeRange(0, [attributedString2 length])];
                    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"58595B"] range:NSMakeRange(0, [attributedString2 length])];
                    
                    [attributedString appendAttributedString:attributedString2];
                }
                
                NSString *brand = [mealDetails objectForKey:@"Brand"];
                NSString *txt = ![Utility isEmptyCheck:brand]?[@"" stringByAppendingFormat:@"%@",brand]:@"";
                NSString *weightGrams = [mealDetails objectForKey:@"EdamamServeGrams"];
                
                if(![Utility isEmptyCheck:weightGrams]){
                    txt = ![Utility isEmptyCheck:txt]?[txt stringByAppendingFormat:@", %@ G",[Utility customRoundNumber:[weightGrams floatValue]]]:[txt stringByAppendingFormat:@"%@ G",[Utility customRoundNumber:[weightGrams floatValue]]];
                }
                
                cell.brandLabel.text = ![Utility isEmptyCheck:txt]?[@"" stringByAppendingFormat:@"%@",txt]:@"";
                cell.myMealName.attributedText = attributedString;
                
                //            NSString *imageString = mealDetails[@"PhotoPath"];
                //            if (![Utility isEmptyCheck:imageString]) {
                //                [cell.myMealImage sd_setImageWithURL:[NSURL URLWithString:imageString]
                //                                      placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages];  //ah 17.5
                //            } else {
                //                cell.myMealImage.image = [UIImage imageNamed:@"meal_no_img.png"];
                //            }
                if ([[mealDetails objectForKey:@"IsSquadMeal"]boolValue]) {
                    cell.myMealImage.hidden = false;
                    [cell.myMealImage setImage:[UIImage imageNamed:@"squad_meal.png"]];
                } else if([[mealDetails objectForKey:@"IsSquadIngredient"]boolValue]){
                    cell.myMealImage.hidden = false;
                    [cell.myMealImage setImage:[UIImage imageNamed:@"squad_ing.png"]];
                } else {
                    cell.myMealImage.hidden = true;
                }
                cell.myMealCal.text = [@"" stringByAppendingFormat:@"%@ CAL",![Utility isEmptyCheck:[mealDetails objectForKey:@"TotalCalories"]]?[Utility customRoundNumber:[[mealDetails objectForKey:@"TotalCalories"]floatValue]]:@"0"];
                cell.pcfLabel.text = [@"" stringByAppendingFormat:@"P: %@ G     C: %@ G     F: %@ G",![Utility isEmptyCheck:[mealDetails objectForKey:@"Protein"]]?[Utility customRoundNumber:[[mealDetails objectForKey:@"Protein"]floatValue]]:@"0",![Utility isEmptyCheck:[mealDetails objectForKey:@"Carbohydrates"]]?[Utility customRoundNumber:[[mealDetails objectForKey:@"Carbohydrates"]floatValue]]:@"0",![Utility isEmptyCheck:[mealDetails objectForKey:@"Fat"]]?[Utility customRoundNumber:[[mealDetails objectForKey:@"Fat"]floatValue]]:@"0"];
            }
            
        }
        return cell;
    }
    
    NSString *CellIdentifier =@"MealListTableViewCell";
    MealListTableViewCell *cell = (MealListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MealListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict;
    if (tableView == personalTable) {
        if (![Utility isEmptyCheck:filteredPersonalFoodArray]) {
            dict = [filteredPersonalFoodArray objectAtIndex:indexPath.row];
            if (![Utility isEmptyCheck:dict]) {
                cell.mealDetails.text = ![Utility isEmptyCheck:[dict objectForKey:@"PersonalFoodName"]]?[@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"PersonalFoodName"]]:@"";
            }
        }
        return cell;
    }
    
    if(selectedIndex == 0){
        dict = mealListArray[indexPath.row];
    }else if (selectedIndex == 1){
        dict = recentMealArray[indexPath.row];
    }else if (selectedIndex == 2){
        dict = frequentMealArray[indexPath.row];
    }
    
    if(selectedIndex == 0){
        cell.mealpic.hidden = false;
//        cell.calorie.hidden = true;
    }else{
        cell.mealpic.hidden = true;
//        cell.calorie.hidden = false;
    }
//    cell.mealpic.hidden = true;
    cell.calorie.hidden = true;
//    NSString *cal = @"";
    
    if (![Utility isEmptyCheck:dict]) {
        NSDictionary *mealDetailsDict;//  = [dict objectForKey:@"MealDetails"];
        if (selectedIndex == 0) {
            mealDetailsDict  = [dict objectForKey:@"MealDetails"];
        } else {
            mealDetailsDict  = dict;
        }
        if (![Utility isEmptyCheck:mealDetailsDict]) {
            if (![Utility isEmptyCheck:[mealDetailsDict objectForKey:@"PhotoSmallPath"]]) {
                NSString *imageString= [@"" stringByAppendingFormat:@"%@",[mealDetailsDict objectForKey:@"PhotoSmallPath"]];
                if (![Utility isEmptyCheck:imageString]) {
                    [cell.mealpic sd_setImageWithURL:[NSURL URLWithString:imageString]
                                    placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages];  //ah 17.5
                } else {
                    cell.mealpic.image = [UIImage imageNamed:@"meal_no_img.png"];
                }
            }else{
                cell.mealpic.image = [UIImage imageNamed:@"meal_no_img.png"];
            }
            
            NSMutableAttributedString *attributedString;
            NSMutableAttributedString *attributedString2;
            
            if (![Utility isEmptyCheck:[mealDetailsDict objectForKey:@"MealName"]] ) {
                attributedString = [[NSMutableAttributedString alloc]initWithString:[mealDetailsDict objectForKey:@"MealName"]];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-SemiBold" size:14] range:NSMakeRange(0, [attributedString length])];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"333333"] range:NSMakeRange(0, [attributedString length])];
            }
//            if (selectedIndex == 0) {
            NSString *cal;
            if (selectedIndex == 0) {
                cal = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:[dict objectForKey:@"Calories"]]?[dict objectForKey:@"Calories"]:@"0"];
            } else {//Calories//RecentMeal
                cal = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:[[dict objectForKey:@"RecentMeal"]objectForKey:@"Calories"]]?[[dict objectForKey:@"RecentMeal"]objectForKey:@"Calories"]:@"0"];
                if ([cal floatValue]<=0) {
                    cal = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:[[dict objectForKey:@"RecentMeal"]objectForKey:@"TotalEnergy"]]?[[dict objectForKey:@"RecentMeal"]objectForKey:@"TotalEnergy"]:@"0"];
                }
            }
            if ([cal floatValue]<=0) {
                cal = @"0";
            }
            attributedString2 =[[NSMutableAttributedString alloc]initWithString:[@"" stringByAppendingFormat:@"\n %@ cal",[Utility customRoundNumber:[cal floatValue]]]];
            [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:11] range:NSMakeRange(0, [attributedString2 length])];
            [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"333333"] range:NSMakeRange(0, [attributedString2 length])];
            
            
            [attributedString appendAttributedString:attributedString2];
//            } else {
//                cal = ![Utility isEmptyCheck:[dict objectForKey:@"Calories"]]?[@"" stringByAppendingFormat:@"%@ CALORIES",[Utility customRoundNumber:[[dict objectForKey:@"Calories"]floatValue]]]:@"";
//            }
            cell.calorie.text = @"";
            cell.mealDetails.attributedText = attributedString;
        }
        
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *mealDict;
    [self btnClickedDone:0];
    if (tableView == personalTable) {
        if (![Utility isEmptyCheck:filteredPersonalFoodArray]) {
            mealDict = [filteredPersonalFoodArray objectAtIndex:indexPath.row];
            if (![Utility isEmptyCheck:mealDict]) {
                nameTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"PersonalFoodName"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"PersonalFoodName"]]:@"";
                servingSizeTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"Quantity"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"Quantity"]]:@"1";
                calTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"Calories"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"Calories"]]:@"0";
                proteinTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"Protein"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"Protein"]]:@"0";
                carbTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"Carbs"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"Carbs"]]:@"0";
                fatTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"Fat"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"Fat"]]:@"0";
            }
        }
        
        personalTable.hidden = true;
        return;
    }else if(tableView == searchTable){
        NSMutableDictionary *dict = [mealArray[indexPath.row]mutableCopy];
        
        NSString *weightGrams = [dict objectForKey:@"EdamamServeGrams"];
        if (![Utility isEmptyCheck:weightGrams]) {
            [dict setObject:weightGrams forKey:@"serving_weight_grams"];
        }
        [self getSearchedMeal:dict requestDict:nil];
        return;
    }
    
    [defaults setObject:[NSNumber numberWithInt:(int)selectedIndex] forKey:@"SelectMealAddIndex"];//SB_TEST
    
    if(selectedIndex == 1){//recent
        mealDict = recentMealArray[indexPath.row];//MealId
        int mealType = [[mealDict objectForKey:@"ActualMealType"]intValue];
        NSString *mealId = ![Utility isEmptyCheck:[mealDict objectForKey:@"MealId"]]?[mealDict objectForKey:@"MealId"]:@"0";
        if([[mealDict objectForKey:@"IsCalorieOnly"]boolValue]){
//            if (![Utility isEmptyCheck:mealDict]) {
//                nameTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"MealName"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"MealName"]]:@"";
//                servingSizeTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"Quantity"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"Quantity"]]:@"1";
//                calTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"Calories"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"Calories"]]:@"0";
//                proteinTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"ProteinPer100"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"ProteinPer100"]]:@"0";
//                carbTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"CarbsPer100"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"CarbsPer100"]]:@"0";
//                fatTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"FatPer100"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"FatPer100"]]:@"0";
//            }
            
            if (![Utility isEmptyCheck:mealDict]){
                NSMutableDictionary *mealDetails = [mealDict[@"RecentMeal"]mutableCopy];
                [mealDetails setObject:@"" forKey:@"Id"];
                [mealDetails setObject:mealDict[@"MealName"] forKey:@"MealName"];
                
                NSMutableArray *temp = [[NSMutableArray alloc]init];
                temp[0] = mealDetails;
                AddToPlanViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddToPlanView"];
                controller.MealType = self->_mealType;
                controller.actualMealType = Quick;
                controller.quickRecentFreq = true;
                controller.currentDate = self->currentDate;
                controller.isAdd = true;
                controller.isStatic = false;
                controller.mealTypeData = 3;
                controller.mealDetails = mealDetails;
                controller.delegate = self;
                controller.mealListArray = [temp mutableCopy];
                [self.navigationController pushViewController:controller animated:true];
            }
            return;
        }
        if (mealType == 1) {//meal
            if ([mealId intValue]>0) {
//                [self getMealDetailsById:[mealId intValue]];
                if (![Utility isEmptyCheck:mealDict]){
                    NSMutableDictionary *mealDetails = [mealDict[@"RecentMeal"]mutableCopy];
                    [mealDetails setObject:@"" forKey:@"Id"];
                    
                    NSMutableArray *temp = [[NSMutableArray alloc]init];
                    temp[0] = mealDetails;
                    AddToPlanViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddToPlanView"];
                    controller.MealType = self->_mealType;
                    controller.actualMealType = SqMeal;
                    controller.currentDate = self->currentDate;
                    controller.isAdd = true;
                    controller.isStatic = false;
                    controller.mealTypeData = 3;
                    controller.mealDetails = mealDetails;
                    controller.delegate = self;
                    controller.mealListArray = [temp mutableCopy];
                    [self.navigationController pushViewController:controller animated:true];
                }
            }
        } else if (mealType == 2) {//ing
//            [self getIngredientList:3 mealName:mealDict isStatic:false];
            if (![Utility isEmptyCheck:mealDict]){
                NSMutableDictionary *mealDetails = [mealDict[@"RecentMeal"]mutableCopy];
                [mealDetails setObject:@"" forKey:@"Id"];
                
                NSMutableArray *temp = [[NSMutableArray alloc]init];
                temp[0] = mealDetails;
                AddToPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddToPlanView"];
                controller.isAdd = true;
                controller.isStatic = false;
                controller.isStaticIngredient = true;
                controller.mealTypeData = 3;
                controller.mealDetails = mealDetails;
                controller.mealListArray = temp;
                controller.delegate =self;
                controller.currentDate = self->currentDate;
                controller.MealType = self->_mealType;
                controller.actualMealType = SqIngredient;
                controller.quickRecentFreq = true;
                [self.navigationController pushViewController:controller animated:true];
            }
        } else if (mealType == 3) {//nutritionix
            NSMutableDictionary *mealDetails = [mealDict[@"RecentMeal"]mutableCopy];
            [mealDetails setObject:@"" forKey:@"Id"];
            
//            NSMutableDictionary *myMeal = [NSMutableDictionary new];//[mealDict mutableCopy];
            [mealDetails setObject:![Utility isEmptyCheck:[mealDict objectForKey:@"MealName"]]?[mealDict objectForKey:@"MealName"]:@"" forKey:@"EdamamFoodName"];
            [mealDetails setObject:![Utility isEmptyCheck:[mealDict objectForKey:@"MealId"]]?[mealDict objectForKey:@"MealId"]:@"" forKey:@"EdamamdFoodId"];
            [mealDetails setObject:![Utility isEmptyCheck:[mealDict objectForKey:@"MealName"]]?[mealDict objectForKey:@"MealName"]:@"" forKey:@"MealName"];
            [mealDetails setObject:![Utility isEmptyCheck:[mealDict objectForKey:@"MealId"]]?[mealDict objectForKey:@"MealId"]:@"" forKey:@"MealId"];
            [mealDetails setObject:[NSNumber numberWithBool:true] forKey:@"IsEdamam"];
            
            //                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"CarbsPer100"]]?[myMeal objectForKey:@"CarbsPer100"]:@"0" forKey:@"CarbsPer100"];
            //                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"CarbsPer100"]]?[myMeal objectForKey:@"CarbsPer100"]:@"0" forKey:@"Carbohydrates"];
            //                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"FatPer100"]]?[myMeal objectForKey:@"FatPer100"]:@"0" forKey:@"Fat"];
            //                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"FatPer100"]]?[myMeal objectForKey:@"FatPer100"]:@"0" forKey:@"FatPer100"];
            //                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"ProteinPer100"]]?[myMeal objectForKey:@"ProteinPer100"]:@"0" forKey:@"Protein"];
            //                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"ProteinPer100"]]?[myMeal objectForKey:@"ProteinPer100"]:@"0" forKey:@"ProteinPer100"];
            //
            //                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"CaloriesPer100"]]?[myMeal objectForKey:@"CaloriesPer100"]:@"0" forKey:@"EdamamCaloriesPer100"];
            //                //                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"Calories"]]?[myMeal objectForKey:@"Calories"]:@"" forKey:@"EdamamCalories"];
            //                //                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"Calories"]]?[myMeal objectForKey:@"Calories"]:@"" forKey:@"TotalCalories"];
            //                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"CaloriesPer100"]]?[myMeal objectForKey:@"CaloriesPer100"]:@"0" forKey:@"EdamamCalories"];
            //                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"CaloriesPer100"]]?[myMeal objectForKey:@"CaloriesPer100"]:@"0" forKey:@"TotalCalories"];
            
            [self foodScanData:mealDetails];
        }
        return;
    }else if (selectedIndex == 2){//frequent
        mealDict = frequentMealArray[indexPath.row];//MealId
        int mealType = [[mealDict objectForKey:@"ActualMealType"]intValue];
        NSString *mealId = ![Utility isEmptyCheck:[mealDict objectForKey:@"MealId"]]?[mealDict objectForKey:@"MealId"]:@"0";
        if([[mealDict objectForKey:@"IsCalorieOnly"]boolValue]){
//            if (![Utility isEmptyCheck:mealDict]) {
//                nameTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"MealName"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"MealName"]]:@"";
//                servingSizeTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"Quantity"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"Quantity"]]:@"1";
//                calTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"Calories"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"Calories"]]:@"0";
//                proteinTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"ProteinPer100"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"ProteinPer100"]]:@"0";
//                carbTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"CarbsPer100"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"CarbsPer100"]]:@"0";
//                fatTextField.text = ![Utility isEmptyCheck:[mealDict objectForKey:@"FatPer100"]]?[@"" stringByAppendingFormat:@"%@",[mealDict objectForKey:@"FatPer100"]]:@"0";
//            }
            
            if (![Utility isEmptyCheck:mealDict]){
                NSMutableDictionary *mealDetails = [mealDict[@"RecentMeal"]mutableCopy];
                [mealDetails setObject:@"" forKey:@"Id"];
                [mealDetails setObject:mealDict[@"MealName"] forKey:@"MealName"];
                
                NSMutableArray *temp = [[NSMutableArray alloc]init];
                temp[0] = mealDetails;
                AddToPlanViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddToPlanView"];
                controller.MealType = self->_mealType;
                controller.actualMealType = Quick;
                controller.quickRecentFreq = true;
                controller.currentDate = self->currentDate;
                controller.isAdd = true;
                controller.isStatic = false;
                controller.mealTypeData = 3;
                controller.mealDetails = mealDetails;
                controller.delegate = self;
                controller.mealListArray = [temp mutableCopy];
                [self.navigationController pushViewController:controller animated:true];
            }
            return;
        }
        if (mealType == 1) {//meal
            if ([mealId intValue]>0) {
//                [self getMealDetailsById:[mealId intValue]];
                if (![Utility isEmptyCheck:mealDict]){
                    NSMutableDictionary *mealDetails = [mealDict[@"RecentMeal"]mutableCopy];
                    [mealDetails setObject:@"" forKey:@"Id"];
                    
                    NSMutableArray *temp = [[NSMutableArray alloc]init];
                    temp[0] = mealDetails;
                    AddToPlanViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddToPlanView"];
                    controller.MealType = self->_mealType;
                    controller.actualMealType = SqMeal;
                    controller.currentDate = self->currentDate;
                    controller.isAdd = true;
                    controller.isStatic = false;
                    controller.mealTypeData = 3;
                    controller.mealDetails = mealDetails;
                    controller.delegate = self;
                    controller.mealListArray = [temp mutableCopy];
                    [self.navigationController pushViewController:controller animated:true];
                }
            }
        } else if (mealType == 2) {//ing
//            [self getIngredientList:3 mealName:mealDict isStatic:false];
            if (![Utility isEmptyCheck:mealDict]){
                NSMutableDictionary *mealDetails = [mealDict[@"RecentMeal"]mutableCopy];
                [mealDetails setObject:@"" forKey:@"Id"];
                
                NSMutableArray *temp = [[NSMutableArray alloc]init];
                temp[0] = mealDetails;
                AddToPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddToPlanView"];
                controller.isAdd = true;
                controller.isStatic = false;
                controller.isStaticIngredient = true;
                controller.mealTypeData = 3;
                controller.mealDetails = mealDetails;
                controller.mealListArray = temp;
                controller.delegate =self;
                controller.currentDate = self->currentDate;
                controller.MealType = self->_mealType;
                controller.actualMealType = SqIngredient;
                controller.quickRecentFreq = true;
                [self.navigationController pushViewController:controller animated:true];
            }
        } else if (mealType == 3) {//nutritionix
//            if ([mealId isEqualToString:@"0"]) {
//
//                NSMutableDictionary *myMeal = [mealDict mutableCopy];
//                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"MealName"]]?[myMeal objectForKey:@"MealName"]:@"" forKey:@"EdamamFoodName"];
//                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"MealId"]]?[myMeal objectForKey:@"MealId"]:@"" forKey:@"EdamamdFoodId"];
//                [myMeal setObject:[NSNumber numberWithBool:true] forKey:@"IsEdamam"];
//
//                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"CarbsPer100"]]?[myMeal objectForKey:@"CarbsPer100"]:@"0" forKey:@"CarbsPer100"];
//                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"CarbsPer100"]]?[myMeal objectForKey:@"CarbsPer100"]:@"0" forKey:@"Carbohydrates"];
//                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"FatPer100"]]?[myMeal objectForKey:@"FatPer100"]:@"0" forKey:@"Fat"];
//                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"FatPer100"]]?[myMeal objectForKey:@"FatPer100"]:@"0" forKey:@"FatPer100"];
//                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"ProteinPer100"]]?[myMeal objectForKey:@"ProteinPer100"]:@"0" forKey:@"Protein"];
//                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"ProteinPer100"]]?[myMeal objectForKey:@"ProteinPer100"]:@"0" forKey:@"ProteinPer100"];
//
//                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"CaloriesPer100"]]?[myMeal objectForKey:@"CaloriesPer100"]:@"0" forKey:@"EdamamCaloriesPer100"];
//                //                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"Calories"]]?[myMeal objectForKey:@"Calories"]:@"" forKey:@"EdamamCalories"];
//                //                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"Calories"]]?[myMeal objectForKey:@"Calories"]:@"" forKey:@"TotalCalories"];
//                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"CaloriesPer100"]]?[myMeal objectForKey:@"CaloriesPer100"]:@"0" forKey:@"EdamamCalories"];
//                [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"CaloriesPer100"]]?[myMeal objectForKey:@"CaloriesPer100"]:@"0" forKey:@"TotalCalories"];
//
//                [self foodScanData:myMeal];
//            }else{
//                [self getNutritionixMealDetailsById:mealId mealDict:[mealDict mutableCopy]];
//            }
            
            NSMutableDictionary *mealDetails = [mealDict[@"RecentMeal"]mutableCopy];
            [mealDetails setObject:@"" forKey:@"Id"];
            
            [mealDetails setObject:![Utility isEmptyCheck:[mealDict objectForKey:@"MealName"]]?[mealDict objectForKey:@"MealName"]:@"" forKey:@"EdamamFoodName"];
            [mealDetails setObject:![Utility isEmptyCheck:[mealDict objectForKey:@"MealId"]]?[mealDict objectForKey:@"MealId"]:@"" forKey:@"EdamamdFoodId"];
            [mealDetails setObject:![Utility isEmptyCheck:[mealDict objectForKey:@"MealName"]]?[mealDict objectForKey:@"MealName"]:@"" forKey:@"MealName"];
            [mealDetails setObject:![Utility isEmptyCheck:[mealDict objectForKey:@"MealId"]]?[mealDict objectForKey:@"MealId"]:@"" forKey:@"MealId"];
            [mealDetails setObject:[NSNumber numberWithBool:true] forKey:@"IsEdamam"];
            
            [self foodScanData:mealDetails];
        }
        return;
    }
    
    if (mealListArray.count > 0 && mealListArray.count >indexPath.row) {
        mealDict = mealListArray[indexPath.row];
    }
    
    NSString *mealTypeName = @"";
    if (![Utility isEmptyCheck:mealDict]){
        NSDictionary *mealDetails = mealDict[@"MealDetails"];
        if (![Utility isEmptyCheck:mealDetails]) {
            
            mealTypeName =![Utility isEmptyCheck:mealDetails[@"MealName"]] ? mealDetails[@"MealName"] :@"";
        }
        AddToPlanViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddToPlanView"];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        temp[0] = mealDetails;
        controller.planMealData = mealDict;
        controller.fromMyPlan = true;
        controller.MealType = _mealType;
        controller.actualMealType = SqMeal;
        controller.currentDate = currentDate;
        controller.isAdd = true;
        controller.isStatic = false;
        controller.mealTypeData = 3;
        controller.mealDetails = [mealDetails mutableCopy];
        controller.delegate = self;
        controller.mealListArray = [temp mutableCopy];//responseDict[@"SquadUserActualMealList"];
        //                                                                             controller.mealCategory = mealCategory;
        [self.navigationController pushViewController:controller animated:true];
    }
    
}
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height-75, 0.0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
    if (activeTextField != nil) {
        CGRect aRect = mainScroll.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            [mainScroll scrollRectToVisible:activeTextField.frame animated:YES];
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
#pragma mark - textField Delegate
-(void)textValueChange:(UITextField *)textField{
    NSLog(@"search for %@", textField.text);
    filteredPersonalFoodArray = personalFoodArray;
    if (textField.text.length > 0) {
        if (![Utility isEmptyCheck:personalFoodArray]) {
            filteredPersonalFoodArray = [personalFoodArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(PersonalFoodName CONTAINS[c] %@)", textField.text]];
        }
    }
    if (![Utility isEmptyCheck:filteredPersonalFoodArray]) {
        personalTable.hidden = false;
        [personalTable reloadData];
    } else {
        personalTable.hidden = true;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    if (textField == nameTextField || textField == searchTextField || textField == recipeName) {
        [textField setKeyboardType:UIKeyboardTypeDefault];
    } else {
        [textField setKeyboardType:UIKeyboardTypeDecimalPad];
    }
    
    [textField setInputAccessoryView:toolBar];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
    if (textField == searchTextField) {
        UIButton *btn = [UIButton new];
        btn.tag = 0;
        [self searchButtonPressed:btn];
    }
    [textField resignFirstResponder];
}
#pragma mark - End
#pragma mark - Advance Search Delegate

-(void)didSelectSearchOption:(NSMutableDictionary *)searchDict sender:(UIButton *)sender{
    searchPage = 2;
    if (![Utility isEmptyCheck:searchDict]) {
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        temp[0] = searchDict;
        AddToPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddToPlanView"];
        controller.MealType = _mealType;
        controller.actualMealType = SqMeal;
        controller.currentDate = currentDate;
        controller.isAdd = true;
        controller.isStatic = false;
        controller.mealTypeData = 3;
        controller.mealDetails = searchDict;
        controller.mealListArray = [temp mutableCopy];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:NO];
    }
}
-(void)mealSerachWithFilterData:(NSDictionary *)dict ingredientsAllList:(NSArray *)ingredientsAllList dietaryPreferenceArray:(NSArray *)dietaryPreferenceArray{
    self->searchDict = dict;
    self->ingredientsAllList = ingredientsAllList;
    self->dietaryPreferenceArray = dietaryPreferenceArray;
}
-(void)getAllMealArray:(NSArray *)mealList{
    advanceMealList = mealList;
}
#pragma mark - End
#pragma mark - EdamamDelegate
-(void)getSearchedMeal:(NSDictionary *)searchDict requestDict:(NSMutableDictionary *)requestDict{
//    searchPage = 1;
    edamamRequestDict = requestDict;
    if (![Utility isEmptyCheck:searchDict]) {
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        temp[0] = searchDict;
        AddToPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddToPlanView"];
        if ([[searchDict objectForKey:@"IsSquadIngredient"]boolValue]) {
            controller.isStaticIngredient = true;
        }
        controller.MealType = _mealType;
        if ([[searchDict objectForKey:@"IsUserPersonalFood"]boolValue]) {
            controller.actualMealType = Quick;
//            [self getRecentlyAddedMeal:[searchDict objectForKey:@"MealId"] foodType:4];
//            return;
        } else if ([[searchDict objectForKey:@"IsEdamam"]boolValue]) {
            controller.actualMealType = Nutritionix;
        } else if ([[searchDict objectForKey:@"IsSquadIngredient"]boolValue]) {
            controller.actualMealType = SqIngredient;
        } else {
            controller.actualMealType = SqMeal;
        }
        controller.currentDate = currentDate;
        controller.quickRecentFreq = true;
        controller.isAdd = true;
        controller.isStatic = false;
        controller.mealTypeData = 3;
        controller.mealDetails = [searchDict mutableCopy];
        controller.mealListArray = [temp mutableCopy];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:NO];
    }
}
#pragma mark - End
#pragma mark - FoodScanDelegate
-(void)foodScanData:(NSDictionary *)foodDict{
    if (![Utility isEmptyCheck:foodDict]) {
        if ([[foodDict objectForKey:@"QuickAddOpen"]boolValue]) {
            [self addManuallyButtonPressed:0];
            return;
        }
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        temp[0] = foodDict;
        AddToPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddToPlanView"];
        controller.MealType = _mealType;
        controller.actualMealType = Nutritionix;
        controller.currentDate = currentDate;
        controller.isAdd = true;
        controller.isStatic = false;
        controller.mealTypeData = 3;
        controller.mealDetails = [foodDict mutableCopy];
        controller.mealListArray = [temp mutableCopy];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:NO];
    }
}
#pragma mark - End
#pragma mark - MealAddViewDelegate
-(void)didCheckAnyChangeForMealAdd:(BOOL)ischanged with:(BOOL)isFrom{
    isChanged = ischanged;
    if (isFrom) {
        if ([delegate respondsToSelector:@selector(checkChangeMealAdd:)]) {
            [delegate checkChangeMealAdd:isChanged];
        }
    }
}
@end
