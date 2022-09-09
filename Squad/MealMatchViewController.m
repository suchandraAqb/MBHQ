//
//  MealMatchViewController.m
//  Squad
//
//  Created by AQB-Mac-Mini 3 on 11/09/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "MealMatchViewController.h"
#import "MealMatchTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Calorie.h"
#import "ProgressBarViewController.h"
#import "AnalyzeSearchViewController.h"
#import "AddToPlanViewController.h"
#import "MealPlanViewController.h"
const static NSString *quickAdd = @"Quick Add";

@interface MealMatchViewController (){
    
    IBOutlet UILabel *blankMsgLabel;
    IBOutlet UILabel *dayLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *waterLabel;
    IBOutlet UILabel *myPlanLabel;
    IBOutlet UILabel *myIntakeLabel;
    IBOutlet UILabel *differenceLabel;
    IBOutlet UITableView *mealTable;
    IBOutlet UITableView *ingredientTable;
    
    __weak IBOutlet UIView *hideMyPlanView;
    
    __weak IBOutlet UIButton *myIntakeButton;
    __weak IBOutlet UIButton *myIntakeBottomArrow;
    __weak IBOutlet UIButton *myplanButton;
    __weak IBOutlet UIButton *myplanBottomArrow;
    
    __weak IBOutlet UIView *myPlanNutriInfoView;
    __weak IBOutlet UIView *myIntakeNutriInfoView;
    __weak IBOutlet UIView *caloriesRemainingView;
    
    __weak IBOutlet UILabel *myPlanProteinLabel;
    __weak IBOutlet UILabel *myPlanCarbsLabel;
    __weak IBOutlet UILabel *myPlanFatLabel;
    
    __weak IBOutlet UILabel *myIntakeProteinLabel;
    __weak IBOutlet UILabel *myIntakeCarbsLabel;
    __weak IBOutlet UILabel *myIntakeFatLabel;
    
    __weak IBOutlet UIView *waterView;
    __weak IBOutlet UIButton *prevButton;
    __weak IBOutlet UIButton *nextBotton;
    __weak IBOutlet UIButton *calenderBotton;
    
    NSArray *planMealListArray;
    NSArray *myMealListArray;
    NSArray *myIngredientListArray;
    NSDate *weekDate;
    NSDate *currentDate;
    NSDateFormatter *dailyDateformatter;
    float totalCal;
    float intakeCal;
    float ingredientCal;
    NSDictionary *mealFrequencyDict;
    NSString *mealCatagory;
    NSString *mealCatagoryCount;
    int currentRow;
    
    
    UIView *contentView;
    int apiCount;
    BOOL isOnlyMyMeal;
    BOOL isSwap;
    BOOL isChanged;
    BOOL isFirstTime;
    
    IBOutlet NSLayoutConstraint *ingredientTableHeight;
    IBOutlet NSLayoutConstraint *mealTableHeight;
    NSNumber *nourishStep;
    NSDate *joiningDate;
    NSString *pieChartStr;//Pie-Chart JS
    
    UIImageView *ViewMain;
    __weak IBOutlet UIScrollView *mainScroll;
    IBOutlet UIView *myIntakeLeftView;
    IBOutlet UIView *myPlanLeftView;
    IBOutlet NSLayoutConstraint *calorieLabelHeightConstant;
    IBOutlet NSLayoutConstraint *proteinLabelheightConstant;
    IBOutlet NSLayoutConstraint *carbsLabelHeightConstant;
    IBOutlet NSLayoutConstraint *fatLabelHeightConstant;
    IBOutlet UIView *analyseView;
    IBOutlet UIView *nutritionSettingsView;
    IBOutlet UIButton *nutritionSettingButton;
    IBOutlet UIButton *analyseButton;
    IBOutlet UIButton *hideMyplanButton;
    IBOutlet UIView *intakePlanView;
    IBOutlet NSLayoutConstraint *intakePlanHeightConstant;
    IBOutlet NSLayoutConstraint *rightArrowDetailsViewHeightConstant;
    IBOutlet UIView *rightArraowView;
    IBOutlet UIButton *rightArrow;
    IBOutlet UIView *righArrowDetailsView;
    IBOutlet UILabel *remainPlanLabel;
    IBOutlet UILabel *remainCaloriesLabel;
    IBOutlet UILabel *remainingLabel;
    IBOutlet UIView *hidemyPlanSuperView;
    IBOutlet UIButton *macroTickButton;
    IBOutlet UIButton *calorieTickButton;
    IBOutlet UIButton *planVsIntakeTickButton;
    IBOutlet UIButton *adjustIntakeTickButton;
    IBOutlet UIButton *editButton;
    CGFloat yOffset;
    NSString *scrollDirection;
}

@end

@implementation MealMatchViewController
@synthesize delegate;
#pragma mark -View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    joiningDate = [NSDate date];
    prevButton.hidden = true;
    nextBotton.hidden = false;
    mealTable.estimatedRowHeight = 200;
    mealTable.rowHeight = UITableViewAutomaticDimension;
    currentDate = [NSDate date];
    isOnlyMyMeal = false;
    isSwap = false;
    currentRow = -1;
    nourishStep = [NSNumber numberWithInt:0];
    isChanged = true;
    isFirstTime = true;
    waterView.hidden = true;
    yOffset = 0.0;
    //Pie-chart JS
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    //
//    if ([defaults boolForKey:@"myPlanPressed"]) {
//        [self myPlanIntakeViewChangeButtonPressed:myplanButton];
//    } else {
//        [self myPlanIntakeViewChangeButtonPressed:myIntakeButton];
//    }
    if (![Utility isEmptyCheck:[defaults objectForKey:@"myPlanClicked"]]) {
        if ([[defaults objectForKey:@"myPlanClicked"]isEqualToString:@"myintake"]) {
            [self myPlanIntakeViewChangeButtonPressed:myIntakeButton];
        }else if ([[defaults objectForKey:@"myPlanClicked"]isEqualToString:@"myplan"]){
            [self myPlanIntakeViewChangeButtonPressed:myplanButton];
        }else if ([[defaults objectForKey:@"myPlanClicked"]isEqualToString:@"calorieremaining"]){
            [self myPlanIntakeViewChangeButtonPressed:nil];
        }else{
            [self myPlanIntakeViewChangeButtonPressed:myIntakeButton];
        }
    }else{
         [self myPlanIntakeViewChangeButtonPressed:myIntakeButton];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [mealTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [ingredientTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadView:) name:@"savedumble" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMealmatch:) name:@"NutritionSettingsUpdate" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadFromFooter:) name:@"NutritionUpdateFromFooter" object:nil];
    righArrowDetailsView.hidden = true;
    rightArrowDetailsViewHeightConstant.constant = 0;
    if (!isChanged) {
        return;
    }
    if (isFirstTime) {
        isFirstTime = false;
        isChanged = false;
    }
    isChanged = false;
    totalCal = 0.0;
    intakeCal = 0.0;
    ingredientCal=0.0;
    [self getListData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [mealTable removeObserver:self forKeyPath:@"contentSize"];
    [ingredientTable removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -End

#pragma mark -Private Method
-(void)getListData{
    dailyDateformatter = [[NSDateFormatter alloc]init];
    [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
    currentDate = [dailyDateformatter dateFromString:dateString];
    NSString *todayStr = [dailyDateformatter stringFromDate:[NSDate date]];
    if ([dateString isEqualToString:todayStr]) {
        dayLabel.text =@"";
        dateLabel.text = @"";
        [calenderBotton setTitle:@"Today" forState:UIControlStateNormal];
    }else{
        [calenderBotton setTitle:@"" forState:UIControlStateNormal];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"EEEE"];
        dayLabel.text = [formatter stringFromDate:currentDate];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        dateLabel.text = [formatter stringFromDate:currentDate];
    }
   
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //[gregorian setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question. (If today is Sunday, subtract 0 days.)
     */
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:currentDate];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:currentDate options:0];
    
    if (beginningOfWeek) {
        weekDate = beginningOfWeek;
    }
    differenceLabel.text = @"0.00";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getSquadMealPlanWithSettings];    //shabbir
        [self getMealPlanList];
//        [self getMyMealList];
//        [self getMyIngedientList]; //new design
        [self getWaterData];
    });
    if (_fromToday) {
        _fromToday = false;
        [self addWaterButtonPressed:0];
    }
}

-(void)plotDifferenceCal{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    if(totalCal == 0 && intakeCal == 0){
        differenceLabel.text = @"0.00";
        return;
    }
    
    float diff = 0.0;
    
    NSString *diffStr = @"";
    
    if (intakeCal > totalCal){
       diffStr = @"+";
        diff = intakeCal - totalCal;
    }else if (totalCal > intakeCal){
       diffStr = @"-";
       diff = totalCal - intakeCal;
    }
    
    //diffStr = [diffStr stringByAppendingFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithFloat:diff]]];
    diffStr = [diffStr stringByAppendingFormat:@"%.2f",diff];

    
    differenceLabel.text = diffStr;
    
    [self setUpCaloriesRemaimingView];
    
}

-(void)checkForChange:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"backButtonPressed"]) {
        if ([delegate respondsToSelector:@selector(didCheckAnyChangeForMealMatch:)]) {
            [delegate didCheckAnyChangeForMealMatch:isChanged];
        }
        [self backButtonPressed:nil];
    }
}

//Pie-chart JS

-(void)calculateCarbsFatProteinPercentage:(float)carbs fat:(float)fat protein:(float)protein{
    
    NSLog(@"%f",carbs/(carbs+fat+protein));
    
    float total = carbs + fat + protein;
    float other = 0.0;
    
    if(ceil(total) < 100.0 && ceil(total) > 0.0){
        other = 100.0 - total;
    }
    
    NSString *appendString = [@"" stringByAppendingFormat:@"%f},{name:'Fat',color:'#f8b3c1',y:%f},{name:'Protein',color:'#d6bfdb',y:%f}]}]}",carbs,fat,protein];
    
    if(other>0.0){
        appendString = [@"" stringByAppendingFormat:@"%f},{name:'Fat',color:'#f8b3c1',y:%f},{name:'Protein',color:'#d6bfdb',y:%f},{name:'Other',color:'#eab4d7',y:%f}]}]}",carbs,fat,protein,other];
    }
    
    pieChartStr = [@"{chart:{spacing:[5,5,5,5],plotBackgroundColor:null,plotBorderWidth:null,plotShadow:false,type:'pie'},credits:{enabled:false},title:{text:''},legend:{align:'right',verticalAlign:'top',layout:'vertical',itemMarginTop:5,itemMarginBottom:5,x:0,y:50,labelFormat:'{name}:  <b>{percentage:.0f}%</b>',itemStyle:{fontSize:'12px',color:'#E425A0'}},tooltip:{pointFormat:'<b>{point.percentage:.0f}%</b>'},plotOptions:{pie:{ size:'100%',center:['50%','50%'],allowPointSelect:true,cursor:'pointer',dataLabels:{enabled:true,format:'<b>{point.percentage:.0f}%</b>',distance:-30,style:{fontSize:'14px',color:'white',textOutline: null},},showInLegend:true,point:{events:{legendItemClick:function(e){e.preventDefault();}}}}},series:[{name:'',colorByPoint:true,data:[{name:'Carbohydrates',color:'#89d5d5',y:" stringByAppendingFormat:@"%@",appendString];
    
    [self loadContent];
}
- (void)loadContent {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index111.html" ofType:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}
#pragma mark - WebView Methods

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->contentView) {
            [self->contentView removeFromSuperview];
        }
        //[webView stringByEvaluatingJavaScriptFromString:[@"" stringByAppendingFormat:@"document.getElementById('container').setAttribute(\"style\",\"height:%dpx\");",(int)self.webView.frame.size.height-15]];
        
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"Highcharts.chart('container', %@)", self->pieChartStr]];
        
    });
    
}
#pragma mark -End
//

#pragma mark -Table View Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == mealTable) {
        mealTableHeight.constant=mealTable.contentSize.height;
    }else if (object == ingredientTable){
        ingredientTableHeight.constant=ingredientTable.contentSize.height;
    }
}
#pragma mark -End

#pragma mark -IBAction


- (IBAction)mealDetailsButtonPressed:(UIButton *)sender {
//    NSDictionary *mealData = planMealListArray[sender.tag];
    NSDictionary *meal = [planMealListArray objectAtIndex:[sender.accessibilityHint intValue]];
    NSArray *mealList = [meal objectForKey:@"meals"];
    NSDictionary *mealData = mealList[sender.tag];
    
    //NSDictionary *mealDetails = mealData[@"MealDetails"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    NSString *dateStr = mealData[@"MealDate"];
    if (![Utility isEmptyCheck:dateStr]) {
        NSDate *dailyDate = [formatter dateFromString:dateStr];
        if (dailyDate) {
            [formatter setDateFormat:@"dd MM yyyy"];
            NSString *dateString = [formatter stringFromDate:dailyDate];
            DailyGoodnessDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyGoodnessDetail"];
            controller.MealType = ![Utility isEmptyCheck:[mealData objectForKey:@"MealType"]]?[[mealData objectForKey:@"MealType"]intValue]:1;
            controller.isFromMealMatch = true;
            controller.mealId = [mealData objectForKey:@"MealId"];
            controller.mealSessionId = [mealData objectForKey:@"MealSessionId"];
            controller.dateString = dateString;
            controller.fromController = @"Meal";    //ah ux
            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }
}

- (IBAction)myIngredientButtonPressed:(UIButton *)sender {
    
    NSDictionary *dict = [myIngredientListArray objectAtIndex:sender.tag];
    [self getMyMealListById:[dict[@"Id"] intValue] isIngredient:true mealDetails:[dict mutableCopy]];
}

- (IBAction)myMealDetailsButtonPressed:(UIButton *)sender {
    //    BOOL isClick = false;
    //    NSDictionary *t;
    //    for (NSDictionary *temp in myMealListArray) {
    //        t=temp;
    //        int mealC = ![Utility isEmptyCheck:temp[@"MealCatagory"]]?[temp[@"MealCatagory"]intValue]:0;
    //        if (mealC == sender.tag) {
    //            isClick = true;
    //        }
    //    }
    //    if (isClick) {
    ////        NSDictionary *dict = [myMealListArray objectAtIndex:sender.tag];
    //        [self getMyMealListById:[t[@"Id"] intValue] isIngredient:false];
    //    } else {
    //        return;
    //    }
    int section = [sender.accessibilityHint intValue];
    NSDictionary *meal = [myMealListArray objectAtIndex:section];
    NSArray *mealList = [meal objectForKey:@"meals"];
    NSDictionary *dict = [mealList objectAtIndex:sender.tag];
    BOOL isIngredient;
    //    if([[dict objectForKey:@"IsCalorieOnly"]boolValue]){
    //        NewMealAddViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewMealAddView"];
    //        controller.delegate = self;
    //        controller.currentDate = currentDate;
    //        controller.mealType = [[dict objectForKey:@"MealType"]intValue];
    //        controller.quickMeal = dict;
    //        [self.navigationController pushViewController:controller animated:YES];
    //        return;
    //    }
    if (![Utility isEmptyCheck:[dict objectForKey:@"IngredientId"]]) {
        isIngredient = true;
    } else {
        isIngredient = false;
    }
    
    NSString *mealName = ![Utility isEmptyCheck:[dict objectForKey:@"MealName"]]?[dict objectForKey:@"MealName"]:@"";
    if ([Utility isEmptyCheck:mealName]) {
        mealName = ![Utility isEmptyCheck:[dict objectForKey:@"EdamamFoodName"]]?[dict objectForKey:@"EdamamFoodName"]:@"";
        if (![Utility isEmptyCheck:mealName]) {
            NSMutableDictionary *cnvrtDict = [NSMutableDictionary new];
            cnvrtDict = [dict mutableCopy];
            [cnvrtDict setObject:[dict objectForKey:@"EdamamFoodName"] forKey:@"MealName"];
            dict = cnvrtDict;
        }
    }
    if([Utility isEmptyCheck:mealName]){
        mealName = ![Utility isEmptyCheck:[dict objectForKey:@"PersonalFoodName"]]?[dict objectForKey:@"PersonalFoodName"]:@"";
        if (![Utility isEmptyCheck:mealName]) {
            NSMutableDictionary *cnvrtDict = [NSMutableDictionary new];
            cnvrtDict = [dict mutableCopy];
            [cnvrtDict setObject:[dict objectForKey:@"PersonalFoodName"] forKey:@"MealName"];
            dict = cnvrtDict;
        }
    }
    
    if(mealName.length<=0){
        return;
    }
    
    
    [self getMyMealListById:[dict[@"Id"] intValue] isIngredient:isIngredient mealDetails:[dict mutableCopy]];
    
    
}
- (IBAction)addWaterButtonPressed:(UIButton *)sender {
    WaterTrackerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WaterTrackerView"];
    controller.isFromTodayOrMealMatch = true;
    controller.waterTrackerdelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
//    UIAlertController *alertController = [UIAlertController
//                                          alertControllerWithTitle:@"Add Water"
//                                          message:@""
//                                          preferredStyle:UIAlertControllerStyleAlert];
//
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
//     {
//         textField.placeholder = @"Enter water in ml";
//         textField.keyboardType = UIKeyboardTypeNumberPad;
//
//     }];
//
//
//    UIAlertAction *cancelAction = [UIAlertAction
//                                   actionWithTitle:@"Cancel"
//                                   style:UIAlertActionStyleCancel
//                                   handler:^(UIAlertAction *action)
//                                   {
//
//                                   }];
//
//    UIAlertAction *okAction = [UIAlertAction
//                               actionWithTitle:@"Add"
//                               style:UIAlertActionStyleDefault
//                               handler:^(UIAlertAction *action)
//                               {
//                                   UITextField *water = alertController.textFields.firstObject;
//                                   [self saveWater:[water.text intValue]];
//
//                               }];
//
//    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
//
//    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)addMyDayButtonPressed:(UIButton *)sender {
    /* MealTypeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealTypeView"];
     controller.mealTypeArray = planMealListArray;
     controller.currentDate = currentDate;
     controller.delegate = self;
     //    controller.mealCategory = (int)sender.tag;
     [self.navigationController pushViewController:controller animated:YES];*/
    
    NewMealAddViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewMealAddView"];
    controller.delegate = self;
    controller.currentDate = currentDate;
    controller.mealType = (int)sender.tag;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)downArrowPressed:(UIButton *)sender {
    
    NSDictionary *mealDict = [myMealListArray objectAtIndex:sender.tag];
    
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealDict[@"Id"] forKey:@"Id"];
        
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SetSquadUserActualMealOrderDown" append:@""forAction:@"POST"];
        
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
//                                                                      NSLog(@"%@",responseDict);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         [self getMyMealList];
//                                                                          [self getMyIngedientList];
                                                                        
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

- (IBAction)upArrowPressed:(UIButton *)sender {
    
    NSDictionary *mealDict = [myMealListArray objectAtIndex:sender.tag];
    
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealDict[@"Id"] forKey:@"Id"];
        
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SetSquadUserActualMealOrderUp" append:@""forAction:@"POST"];
        
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
                                                                         
                                                                         [self getMyMealList];
//                                                                          [self getMyIngedientList];
                                                                         
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

- (IBAction)deleteButtonPressed:(UIButton *)sender {
    
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

- (IBAction)previousDateButtonPressed:(UIButton *)sender {
    NSTimeInterval prvDate = -24*60*60;
    currentDate = [currentDate
                dateByAddingTimeInterval:prvDate];
    ingredientCal = 0.0;
    [self getListData];
}

- (IBAction)nextDateButtonPressed:(UIButton *)sender {
    
    NSTimeInterval nextDay = 24*60*60;
    currentDate = [currentDate
                dateByAddingTimeInterval:nextDay];
    ingredientCal = 0.0;
    [self getListData];
}

- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)hideShowMyPlan:(UIButton *)sender{
    hideMyplanButton.selected=true;
    hideMyplanButton.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    
    nutritionSettingButton.selected = false;
    nutritionSettingButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    analyseButton.selected= false;
    analyseButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    NSLog(@"%@ pressed", sender.titleLabel.text);        //
    if ([sender.titleLabel.text isEqualToString:@"HIDE MY PLAN"]) {
        [sender setTitle:@"SHOW MY PLAN" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"HIDE MY PLAN" forState:UIControlStateNormal];
    }
    isOnlyMyMeal = !isOnlyMyMeal;
    [mealTable reloadData];
}
-(IBAction)analyzeButtonPressed:(UIButton *)sender{
    NSLog(@"%@ pressed", sender.titleLabel.text);
    analyseButton.selected= true;
    analyseButton.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    
    hideMyplanButton.selected= false;
    hideMyplanButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    nutritionSettingButton.selected= false;
    nutritionSettingButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    AnalyzeSearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AnalyzeSearchView"];
    [self.navigationController pushViewController:controller animated:YES];
    
    
}
-(IBAction)swapButtonPressed:(UIButton *)sender{
    NSLog(@"swap pressed");
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.intValue];
//    MealMatchTableViewCell *cell = (MealMatchTableViewCell *)[mealTable cellForRowAtIndexPath:indexPath];
//    if (sender == cell.swap) {
//        isSwap = true;
//        currentRow = (int)indexPath.row;
//        [mealTable reloadData];
//    } else if(sender == cell.swapButton) {
//        isSwap = false;
//        currentRow = -1;
//        [mealTable reloadData];
//    }
}
-(NSDate *)getFirstLastWeekDate:(NSDate *)currentDate isWeekStartDate:(BOOL)isWeekStartDate{
    NSDate *requestedDate = [NSDate date];
    
    if (!currentDate) {
        return requestedDate;
    }
    
    NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
    [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
    currentDate = [dailyDateformatter dateFromString:dateString];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:currentDate];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:currentDate options:0];
    if (isWeekStartDate) {
        requestedDate = beginningOfWeek;
    }else{
        NSTimeInterval twoWeeks = 13*24*60*60;
        NSDate *endDate = [beginningOfWeek dateByAddingTimeInterval:twoWeeks];
        requestedDate = endDate;
    }
    
    return requestedDate;
}
-(IBAction)calenderButtonPressed:(UIButton *)sender{
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.minDate = joiningDate;
    controller.maxDate = [self getFirstLastWeekDate:[NSDate date] isWeekStartDate:NO];
    controller.selectedDate = currentDate;
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}


- (IBAction)myPlanIntakeViewChangeButtonPressed:(UIButton *)sender {
    
//    if(sender.isSelected)
//        return;
    hideMyPlanView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    hideMyPlanView.layer.borderWidth=1;
    hideMyPlanView.layer.cornerRadius=hideMyPlanView.frame.size.height/2;
    hideMyPlanView.layer.masksToBounds=YES;
    
    analyseView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    analyseView.layer.borderWidth=1;
    analyseView.layer.cornerRadius=analyseView.frame.size.height/2;
    analyseView.layer.masksToBounds = YES;
    
    nutritionSettingsView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    nutritionSettingsView.layer.borderWidth=1;
    nutritionSettingsView.layer.cornerRadius=nutritionSettingsView.frame.size.height/2;
    nutritionSettingsView.layer.masksToBounds= YES;
    
    if(sender == myIntakeButton){
        [defaults setBool:NO forKey:@"myPlanPressed"];
        [defaults setObject:@"myintake" forKey:@"myPlanClicked"];
        [myIntakeButton setSelected:YES];
        [myplanButton setSelected:NO];
        [myIntakeBottomArrow setImage:[UIImage imageNamed:@"arrow_active.png"] forState:UIControlStateNormal];
        [myplanBottomArrow setImage:nil forState:UIControlStateNormal];
        myPlanNutriInfoView.hidden = true;
        myIntakeNutriInfoView.hidden = false;
        hideMyPlanView.hidden = true;
        waterView.hidden = false;
        myIntakeLeftView.hidden = true;
        myPlanLeftView.hidden =true;
        calorieLabelHeightConstant.constant=15.5;
        proteinLabelheightConstant.constant = 15.5;
        carbsLabelHeightConstant.constant = 15.5;
        fatLabelHeightConstant.constant = 15.5;
        analyseView.hidden = false;
        nutritionSettingsView.hidden = false;
        rightArraowView.hidden = false;
        caloriesRemainingView.hidden = true;
        hidemyPlanSuperView.hidden = true;
        
        macroTickButton.selected = true;
        calorieTickButton.selected = false;
        planVsIntakeTickButton.selected = false;
        adjustIntakeTickButton.selected = false;
        editButton.hidden =true;
    }else if(sender == myplanButton){
        [defaults setBool:YES forKey:@"myPlanPressed"];
        [defaults setObject:@"myplan" forKey:@"myPlanClicked"];

        [myIntakeButton setSelected:NO];
        [myplanButton setSelected:YES];
        [myIntakeBottomArrow setImage:nil forState:UIControlStateNormal];
        [myplanBottomArrow setImage:[UIImage imageNamed:@"arrow_active.png"] forState:UIControlStateNormal];
        myPlanNutriInfoView.hidden = false;
        myIntakeNutriInfoView.hidden = false;
        hideMyPlanView.hidden = true;
        analyseView.hidden = false;
        nutritionSettingsView.hidden = true;
        waterView.hidden = true;
        myIntakeLeftView.hidden = false;
        myPlanLeftView.hidden =false;
        calorieLabelHeightConstant.constant=0;
        proteinLabelheightConstant.constant = 0;
        carbsLabelHeightConstant.constant = 0;
        fatLabelHeightConstant.constant = 0;
        rightArraowView.hidden = false;
        caloriesRemainingView.hidden = true;
        hidemyPlanSuperView.hidden =false;
        
        macroTickButton.selected = false;
        calorieTickButton.selected = false;
        planVsIntakeTickButton.selected = true;
        adjustIntakeTickButton.selected = false;
        editButton.hidden =false;
    }else{
        [defaults setObject:@"calorieremaining" forKey:@"myPlanClicked"];
        [myIntakeButton setSelected:YES];
        [myplanButton setSelected:NO];
        [myIntakeBottomArrow setImage:[UIImage imageNamed:@"arrow_active.png"] forState:UIControlStateNormal];
        [myplanBottomArrow setImage:nil forState:UIControlStateNormal];
        myPlanNutriInfoView.hidden = true;
        myIntakeNutriInfoView.hidden = true;
        hideMyPlanView.hidden = true;
        analyseView.hidden = false;
        nutritionSettingsView.hidden = false;
        waterView.hidden = true;
        myIntakeLeftView.hidden = true;
        myPlanLeftView.hidden =true;
        calorieLabelHeightConstant.constant=0;
        proteinLabelheightConstant.constant = 0;
        carbsLabelHeightConstant.constant = 0;
        fatLabelHeightConstant.constant = 0;
        rightArraowView.hidden = false;
        caloriesRemainingView.hidden = false;
        hidemyPlanSuperView.hidden = true;
        
        macroTickButton.selected = false;
        calorieTickButton.selected = true;
        planVsIntakeTickButton.selected = false;
        adjustIntakeTickButton.selected = false;
        editButton.hidden =true;
        [self setUpCaloriesRemaimingView];
    }
    [self->mealTable reloadData];
    @try {
        [mainScroll setContentOffset:CGPointMake(0, mealTable.bounds.origin.y)];
    } @catch (NSException *exception) {
        
    }
}
-(IBAction)planEditButtonPressed:(id)sender{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Alert"
                                          message:@"Would you like to adjust your daily calorie and carb amount?"
                                          preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"NO"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"YES"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   MealPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealPlanView"];
                                   controller.isFromMyplan = true;
                                   controller.delegate = self;
                                   [self.navigationController pushViewController:controller animated:YES];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(IBAction)nutritionSettingsButtonPressed:(id)sender{
//    macroTickButton.selected = false;
//    calorieTickButton.selected = false;
//    planVsIntakeTickButton.selected = false;
//    adjustIntakeTickButton.selected = true;
    
    nutritionSettingButton.selected = true;
    nutritionSettingButton.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    
    analyseButton.selected= false;
    analyseButton.backgroundColor = [UIColor whiteColor];
    
    hideMyplanButton.selected= false;
    hideMyplanButton.backgroundColor = [UIColor whiteColor];
    
    MealPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealPlanView"];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)rightarrowButtonPressed:(UIButton*)sender{
    if (rightArrowDetailsViewHeightConstant.constant == 0) {
         righArrowDetailsView.hidden = false;
         rightArrowDetailsViewHeightConstant.constant = 130;
    }else{
         righArrowDetailsView.hidden = true;
         rightArrowDetailsViewHeightConstant.constant = 0;
    }
}
-(IBAction)rightArrowPressed:(UIButton*)sender{
    if (sender.tag == 0) {
        [self myPlanIntakeViewChangeButtonPressed:myIntakeButton];
    }else if (sender.tag == 1){
        [self myPlanIntakeViewChangeButtonPressed:nil];
    }else if (sender.tag == 2){
         [self myPlanIntakeViewChangeButtonPressed:myplanButton];
    }else{
        [self nutritionSettingsButtonPressed:nil];
    }
    righArrowDetailsView.hidden = true;
    rightArrowDetailsViewHeightConstant.constant = 0;
}

#pragma mark -End

#pragma mark- Web Service Call
-(void)getMyMealList{
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
//            self->mealTable.hidden = true;
            self->blankMsgLabel.hidden = false;
            
            if (!self->myMealListArray){
                self->myMealListArray = [[NSArray alloc]init];
            }
            
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMyDaySquadUserActualMealCalories" append:@""forAction:@"POST"];
        
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
                                                                         
                                                                         self->myMealListArray = responseDict[@"SquadUserActualMealList"];

                                                                         NSMutableArray *myFilteredPlanList = [[NSMutableArray alloc]init];
                                                                         NSMutableArray *breakfast = [[NSMutableArray alloc]init];
                                                                         NSMutableArray *lunch = [[NSMutableArray alloc]init];
                                                                         NSMutableArray *dinner = [[NSMutableArray alloc]init];
                                                                         NSMutableArray *snacks = [[NSMutableArray alloc]init];
                                                                         float cal[] = {0.0, 0.0, 0.0, 0.0};
                                                                         float protein[] = {0.0, 0.0, 0.0, 0.0};
                                                                         float carb[] = {0.0, 0.0, 0.0, 0.0};
                                                                         float fat[] = {0.0, 0.0, 0.0, 0.0};
                                                                         if (self->myMealListArray.count>0) {
                                                                             for (NSDictionary *temp in self->myMealListArray) {
                                                                                 int mealType = ![Utility isEmptyCheck:temp[@"MealType"]]?[temp[@"MealType"]intValue]:1;
                                                                                 if (mealType == 1) {
                                                                                     cal[0] += [[temp objectForKey:@"TotalEnergy"]floatValue];
                                                                                     protein[0] += [[temp objectForKey:@"Protein"]floatValue];
                                                                                     carb[0] += [[temp objectForKey:@"Carb"]floatValue];
                                                                                     fat[0] += [[temp objectForKey:@"Fat"]floatValue];
                                                                                     [breakfast addObject:temp];
                                                                                 }else if (mealType == 2) {
                                                                                     cal[1] += [[temp objectForKey:@"TotalEnergy"]floatValue];
                                                                                     protein[1] += [[temp objectForKey:@"Protein"]floatValue];
                                                                                     carb[1] += [[temp objectForKey:@"Carb"]floatValue];
                                                                                     fat[1] += [[temp objectForKey:@"Fat"]floatValue];
                                                                                     [lunch addObject:temp];
                                                                                 }else if (mealType == 3) {
                                                                                     cal[2] += [[temp objectForKey:@"TotalEnergy"]floatValue];
                                                                                     protein[2] += [[temp objectForKey:@"Protein"]floatValue];
                                                                                     carb[2] += [[temp objectForKey:@"Carb"]floatValue];
                                                                                     fat[2] += [[temp objectForKey:@"Fat"]floatValue];
                                                                                     [dinner addObject:temp];
                                                                                 }else{
                                                                                     cal[3] += [[temp objectForKey:@"TotalEnergy"]floatValue];
                                                                                     protein[3] += [[temp objectForKey:@"Protein"]floatValue];
                                                                                     carb[3] += [[temp objectForKey:@"Carb"]floatValue];
                                                                                     fat[3] += [[temp objectForKey:@"Fat"]floatValue];
                                                                                     [snacks addObject:temp];
                                                                                 }
                                                                             }
                                                                             
                                                                         }
                                                                         if (![Utility isEmptyCheck:self->planMealListArray]){
                                                                             for (NSDictionary *temp in self->planMealListArray) {
                                                                                 NSString *mealtype = [@"" stringByAppendingFormat:@"%@",[temp objectForKey:@"mealType"]];
                                                                                 if ([mealtype caseInsensitiveCompare:@"BREAKFAST"] == NSOrderedSame) {
                                                                                     [myFilteredPlanList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"BREAKFAST",@"mealType", breakfast,@"meals", [NSNumber numberWithFloat:cal[0]],@"TotalEnergy", [NSNumber numberWithFloat:protein[0]],@"Protein", [NSNumber numberWithFloat:carb[0]],@"Carb", [NSNumber numberWithFloat:fat[0]],@"Fat", nil]];
                                                                                 }else if ([mealtype caseInsensitiveCompare:@"LUNCH"] == NSOrderedSame){
                                                                                     [myFilteredPlanList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"LUNCH",@"mealType",lunch,@"meals", [NSNumber numberWithFloat:cal[1]],@"TotalEnergy", [NSNumber numberWithFloat:protein[1]],@"Protein", [NSNumber numberWithFloat:carb[1]],@"Carb", [NSNumber numberWithFloat:fat[1]],@"Fat", nil]];
                                                                                 }else if ([mealtype caseInsensitiveCompare:@"DINNER"] == NSOrderedSame){
                                                                                     [myFilteredPlanList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"DINNER",@"mealType",dinner,@"meals", [NSNumber numberWithFloat:cal[2]],@"TotalEnergy", [NSNumber numberWithFloat:protein[2]],@"Protein", [NSNumber numberWithFloat:carb[2]],@"Carb", [NSNumber numberWithFloat:fat[2]],@"Fat", nil]];
                                                                                 }else if ([mealtype caseInsensitiveCompare:@"SNACKS"] == NSOrderedSame){
                                                                                     [myFilteredPlanList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"SNACKS",@"mealType",snacks,@"meals", [NSNumber numberWithFloat:cal[3]],@"TotalEnergy", [NSNumber numberWithFloat:protein[3]],@"Protein", [NSNumber numberWithFloat:carb[3]],@"Carb", [NSNumber numberWithFloat:fat[3]],@"Fat", nil]];
                                                                                 }
                                                                             }
                                                                         }
                                                                         
                                                                         self->myMealListArray = myFilteredPlanList;
                                                                         
                                                                         [self->mealTable reloadData];
                                                                         self->mealTable.hidden = false;
                                                                         self->blankMsgLabel.hidden = true;
//                                                                         NSLog(@"%@",responseDict);
                                                                         
                                                                         self->intakeCal = [responseDict[@"TotalCalorie"] floatValue]+self->ingredientCal;
//                                                                         self->myIntakeLabel.text = [@"" stringByAppendingFormat:@"%.2f",self->intakeCal];
                                                                         NSLog(@"=========%@",[Utility customRoundNumber:self->intakeCal]);
                                                                         self->myIntakeLabel.text = [Utility customRoundNumber:self->intakeCal];
                                                                         self->myIntakeFatLabel.text = ![Utility isEmptyCheck:responseDict[@"TotalFat"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[responseDict[@"TotalFat"] floatValue]]]:@"0";
                                                                         self->myIntakeCarbsLabel.text = ![Utility isEmptyCheck:responseDict[@"TotalCarb"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[responseDict[@"TotalCarb"]floatValue]]]:@"0";
                                                                         self->myIntakeProteinLabel.text = ![Utility isEmptyCheck:responseDict[@"TotalProtein"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[responseDict[@"TotalProtein"] floatValue]]]:@"0";
                                                                         //Pie-chart JS
                                                                         [self calculateCarbsFatProteinPercentage:[responseDict[@"TotalCarbPercentage"]floatValue] fat:[responseDict[@"TotalFatPercentage"]floatValue] protein:[responseDict[@"TotalProteinPercentage"]floatValue]];
                                                                         //
                                                                         [self plotDifferenceCal];
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

-(void)getMyIngedientList{
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
            self->ingredientTable.hidden = true;
            
            
            if (!self->myIngredientListArray){
                self->myIngredientListArray = [[NSArray alloc]init];
            }
            
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMyDayIngredientSquadUserActualMeal" append:@""forAction:@"POST"];
        
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
                                                                         self->myIngredientListArray = responseDict[@"SquadUserActualMealList"];
                                                                         [self->ingredientTable reloadData];
                                                                         self->ingredientTable.hidden = false;
//                                                                         NSLog(@"%@",responseDict);
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

-(void)getMyMealListById:(int)Id isIngredient:(BOOL)isIngredient mealDetails:(NSMutableDictionary *)mealDetails{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:Id] forKey:@"Id"];
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadUserActualMeal" append:@""forAction:@"POST"];
        
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
                                                                         
                                                                         if (![Utility isEmptyCheck:responseDict[@"SquadUserActualMeal"]]){
                                                                             
                                                                             if (isIngredient){
                                                                                 [self getIngredientList:3 mealName:responseDict[@"SquadUserActualMeal"] isStatic:false];
                                                                                 //                                                                                 NSMutableArray *temp = [[NSMutableArray alloc]init];
                                                                                 //                                                                                 temp[0] = mealDetails;
                                                                                 //                                                                                 MealAddViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealAddView"];
                                                                                 //
                                                                                 //                                                                                 controller.isAdd = false;
                                                                                 //                                                                                 controller.isStatic = false;
                                                                                 //                                                                                 controller.isStaticIngredient = true;
                                                                                 //                                                                                 controller.mealTypeData = 3;
                                                                                 //                                                                                 controller.mealDetails = mealDetails;
                                                                                 //                                                                                 controller.mealListArray = [temp mutableCopy];
                                                                                 //                                                                                 controller.delegate =self;
                                                                                 //                                                                                 [self.navigationController pushViewController:controller animated:true];
                                                                                 
                                                                             }else{
                                                                                 //                                                                                 [self getSquadMealList:3 mealName:responseDict[@"SquadUserActualMeal"] isStatic:false];
                                                                                 NSDictionary *meal = [responseDict objectForKey:@"SquadUserActualMeal"];
                                                                                 
                                                                                 //                                                                                 NSString *mealName = ![Utility isEmptyCheck:[meal objectForKey:@"MealName"]]?[meal objectForKey:@"MealName"]:@"";
                                                                                 if(![Utility isEmptyCheck:[mealDetails objectForKey:@"EdamamFoodName"]]){
                                                                                     NSMutableDictionary *cnvrtDict = [NSMutableDictionary new];
                                                                                     cnvrtDict = [meal mutableCopy];
                                                                                     [cnvrtDict setObject:[mealDetails objectForKey:@"EdamamFoodName"] forKey:@"MealName"];
                                                                                     [cnvrtDict setObject:[NSNumber numberWithBool:true] forKey:@"IsEdamam"];
                                                                                     meal = cnvrtDict;
                                                                                 } else if (![Utility isEmptyCheck:[mealDetails objectForKey:@"PersonalFoodName"]]) {
                                                                                     NSMutableDictionary *cnvrtDict = [NSMutableDictionary new];
                                                                                     cnvrtDict = [meal mutableCopy];
                                                                                     [cnvrtDict setObject:[mealDetails objectForKey:@"PersonalFoodName"] forKey:@"MealName"];
                                                                                     meal = cnvrtDict;
                                                                                 }
                                                                                 
                                                                                 NSMutableArray *temp = [[NSMutableArray alloc]init];
                                                                                 temp[0] = meal;
                                                                                 AddToPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddToPlanView"];
                                                                                 controller.currentDate = self->currentDate;
                                                                                 controller.MealType = [[mealDetails objectForKey:@"MealType"]intValue];
                                                                                 if ([[mealDetails objectForKey:@"IsCalorieOnly"]boolValue]) {
                                                                                     controller.actualMealType = Quick;
                                                                                 } else if(![Utility isEmptyCheck:[mealDetails objectForKey:@"EdamamFoodName"]]){
                                                                                     controller.actualMealType = Nutritionix;//
                                                                                 } else {
                                                                                     controller.actualMealType = SqMeal;
                                                                                 }
                                                                                 
                                                                                 controller.isAdd = false;
                                                                                 controller.isStatic = false;
                                                                                 controller.mealTypeData = 3;
                                                                                 controller.mealDetails = [meal mutableCopy];
                                                                                 controller.mealListArray = [temp mutableCopy];
                                                                                 controller.delegate = self;
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
//                                                                         NSLog(@"%@",responseDict);
                                                                         
                                                                         if(![Utility isEmptyCheck:responseDict[@"SquadUserActualMealList"]]){
                                                                             
                                                                             
                                                                             MealAddViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealAddView"];
                                                                             
                                                                             controller.isAdd = false;
                                                                             controller.isStatic = isStatic;
                                                                             controller.mealTypeData = mealTypeData;
                                                                             controller.mealDetails = mealdetails;
                                                                             controller.mealListArray = [responseDict[@"SquadUserActualMealList"] mutableCopy];
                                                                             controller.delegate = self;
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
                                                                         controller.isAdd = false;
                                                                         controller.isStatic = false;
                                                                         controller.isStaticIngredient = true;
                                                                         controller.mealTypeData = mealTypeData;
                                                                         controller.mealDetails = [mealdetails mutableCopy];
                                                                         controller.mealListArray = [responseDict objectForKey:@"Ingredients"];
                                                                         controller.delegate =self;
                                                                         controller.currentDate = self->currentDate;
                                                                         controller.MealType = [[mealdetails objectForKey:@"MealType"]intValue];
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

-(void)getMealPlanList{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
//        if (weekDate) {
//            [mainDict setObject:[dailyDateformatter stringFromDate:weekDate ] forKey:@"WeekDate"];
//        }
        
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
            self->planMealListArray = [[NSArray alloc]init];
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
                                                                 BOOL callForMyMeal = false;
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
//                                                                         NSLog(@"%@",responseDict);
                                                                         NSArray *rawNutritionDataArray = responseDict[@"SquadMealSessions"];
                                                                         if (![Utility isEmptyCheck:rawNutritionDataArray ] && ![Utility isEmptyCheck:self->currentDate]) {
                                                                             callForMyMeal = true;
                                                                             NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                                                                             formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
                                                                             NSString *dateString = [formatter stringFromDate:self->currentDate];
                                                                             NSArray *filteredarray = [rawNutritionDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(MealDate == %@)", dateString]];
                                                                             if (filteredarray.count > 0) {
                                                                                 
                                                                                 self->myPlanFatLabel.text = ![Utility isEmptyCheck:responseDict[@"TotalFat"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[responseDict[@"TotalFat"] floatValue]]]:@"0";
                                                                                 self->myPlanCarbsLabel.text = ![Utility isEmptyCheck:responseDict[@"TotalCarb"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[responseDict[@"TotalCarb"]floatValue]]]:@"0";
                                                                                 self->myPlanProteinLabel.text = ![Utility isEmptyCheck:responseDict[@"TotalProtein"]]?[@"" stringByAppendingFormat:@"%@",[Utility customRoundNumber:[responseDict[@"TotalProtein"] floatValue]]]:@"0";
                                                                                 
                                                                                 
                                                                                 NSMutableArray *myFilteredPlanList = [[NSMutableArray alloc]init];
                                                                                 NSMutableArray *breakfast = [[NSMutableArray alloc]init];
                                                                                 NSMutableArray *lunch = [[NSMutableArray alloc]init];
                                                                                 NSMutableArray *dinner = [[NSMutableArray alloc]init];
                                                                                 NSMutableArray *snacks = [[NSMutableArray alloc]init];
                                                                                 for (NSDictionary *temp in filteredarray) {
                                                                                     int mealType = ![Utility isEmptyCheck:temp[@"MealType"]]?[temp[@"MealType"]intValue]:1;
                                                                                     if (mealType == 1) {
                                                                                         [breakfast addObject:temp];
                                                                                     }else if (mealType == 2) {
                                                                                         [lunch addObject:temp];
                                                                                     }else if (mealType == 3) {
                                                                                         [dinner addObject:temp];
                                                                                     }else{
                                                                                         [snacks addObject:temp];
                                                                                     }
                                                                                 }
                                                                                 if(breakfast.count>0){
                                                                                     [myFilteredPlanList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"BREAKFAST",@"mealType", breakfast,@"meals", nil]];
                                                                                 }
                                                                                 if(lunch.count>0){
                                                                                     [myFilteredPlanList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"LUNCH",@"mealType",lunch,@"meals", nil]];
                                                                                 }
                                                                                 if(dinner.count>0){
                                                                                     [myFilteredPlanList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"DINNER",@"mealType",dinner,@"meals", nil]];
                                                                                 }
                                                                                 if(snacks.count>0){
                                                                                     [myFilteredPlanList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"SNACKS",@"mealType",snacks,@"meals", nil]];
                                                                                 }
                                                                                 
                                                                                 
                                                                                 self->planMealListArray = myFilteredPlanList;
                                                                                 
//                                                                                 self->planMealListArray = filteredarray;
                                                                                 self->mealTable.hidden = false;
                                                                                 self->blankMsgLabel.hidden = true;
                                                                                 
                                                                                 [self->mealTable reloadData];
                                                                             }
                                                                         }else{
                                                                             [self generateSquadUserMealPlans:self->nourishStep];
                                                                             return;
                                                                         }
                                                                         self->totalCal = [responseDict[@"DayTotalEnergy"] floatValue];
//                                                                         self->myPlanLabel.text = [@"" stringByAppendingFormat:@"%.2f",self->totalCal];
                                                                         self->myPlanLabel.text = [Utility customRoundNumber:self->totalCal];

                                                                         [self plotDifferenceCal];
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                                 if (callForMyMeal) {
                                                                     [self getMyMealList];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}


-(void)getWaterData{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:@"" forKey:@"FacebookToken"];
        
        if (![Utility isEmptyCheck:currentDate]) {
            NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
            [mainDict setObject:dateString forKey:@"WaterIntakeDate"];
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetWaterData" append:@""forAction:@"POST"];
        
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         
                                                                         if (![Utility isEmptyCheck:responseDict[@"WaterData"]]){
                                                                             
                                                                             self->waterLabel.text = [@"" stringByAppendingFormat:@"%dmL",[responseDict[@"WaterData"][@"amount"] intValue]];
                                                                             self->waterLabel.accessibilityHint = [@"" stringByAppendingFormat:@"%d",[responseDict[@"WaterData"][@"id"] intValue]];
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


-(void)saveWater:(int)water{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:@"" forKey:@"FacebookToken"];
        [mainDict setObject:[NSNumber numberWithInt:water] forKey:@"WaterTrackAmount"];
        [mainDict setObject:[NSNumber numberWithBool:1] forKey:@"isAdd"];
        [mainDict setObject:[NSNumber numberWithInt:[waterLabel.accessibilityHint intValue]] forKey:@"Id"];
        
        if (![Utility isEmptyCheck:currentDate]) {
            NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
            [mainDict setObject:dateString forKey:@"WaterIntakeDate"];
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SaveWaterData" append:@""forAction:@"POST"];
        
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         
                                                                         [Utility msg:@"Water data saved successfully" title:@"Success" controller:self haveToPop:NO];
                                                                         
                                                                         if (![Utility isEmptyCheck:responseDict[@"WaterData"]]){
                                                                             self->waterLabel.text = [@"" stringByAppendingFormat:@"%dmL",[responseDict[@"WaterData"][@"amount"] intValue]];
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
    int section = [sender.accessibilityHint intValue];
    NSDictionary *meal = [myMealListArray objectAtIndex:section];
    NSArray *mealList = [meal objectForKey:@"meals"];
    NSDictionary *mealDict = [mealList objectAtIndex:sender.tag];
//    if ([sender.accessibilityHint  isEqualToString:@"meal"]){
////        BOOL isDelete = false;
////        NSDictionary *t;
////        for (NSDictionary *temp in myMealListArray) {
////            t=temp;
////            int mealC = ![Utility isEmptyCheck:temp[@"MealCatagory"]]?[temp[@"MealCatagory"]intValue]:0;
////            if (mealC == sender.tag) {
////                isDelete = true;
////            }
////        }
////        if (isDelete) {
////            mealDict = t;
////        } else {
////            return;
////        }
//        mealDict = [myMealListArray objectAtIndex:sender.tag];
//    }else{
//        mealDict = [myIngredientListArray objectAtIndex:sender.tag];
//    }
    
    
    
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealDict[@"Id"] forKey:@"Id"];
        
        
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
                                                                         
                                                                         [self getMyMealList];
//                                                                         [self getMyIngedientList];
                                                                         
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

-(void)getSquadMealPlanWithSettings{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (weekDate) {
            [mainDict setObject:[dailyDateformatter stringFromDate:weekDate ] forKey:@"WeekDate"];
            [mainDict setObject:[dailyDateformatter stringFromDate:weekDate ] forKey:@"UserSessionStartSessionDate"];
            NSDate *nxtDate = [weekDate dateByAddingTimeInterval:6*24*60*60];
            [mainDict setObject:[dailyDateformatter stringFromDate:nxtDate ] forKey:@"UserSessionEndSessionDate"];
            
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
            self->blankMsgLabel.hidden = false;
            
            //contentView = [Utility activityIndicatorView:self withMsg:@"Don’t forget to watch the Nourish ‘How To’ video to learn how to get the most of your custom plan." font:[UIFont fontWithName:@"Raleway-SemiBold" size:16] color:[UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1]];
            self->contentView = [Utility activityIndicatorView:self];
//            if(_isFromShoppingList)
//                blankMsgLabel.text = @"";
//            else
//                blankMsgLabel.text = @"Don’t forget to watch the Nourish ‘How To’ video to learn how to get the most of your custom plan.";
//            contentView.backgroundColor = [UIColor clearColor];
//            [self.view bringSubviewToFront:countDownView];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadMealPlanWithSettingsApiCall" append:@""forAction:@"POST"];
        
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
                                                                         if (![Utility isEmptyCheck:responseDict[@"WeekStartDate"] ]) {
                                                                             NSDate *date = [self->dailyDateformatter dateFromString:responseDict[@"WeekStartDate"]];
                                                                             if (date) {
                                                                                 self->nourishStep = ![Utility isEmptyCheck:[responseDict objectForKey:@"NourishSettingsStep"]]?[responseDict objectForKey:@"NourishSettingsStep"]:@0;
                                                                                 self->joiningDate = date;
                                                                                 if([self->joiningDate isSameDay:self->currentDate]){
                                                                                     self->prevButton.hidden = true;
                                                                                 }else{
                                                                                     self->prevButton.hidden = false;
                                                                                 }
                                                                                 if([[self getFirstLastWeekDate:[NSDate date] isWeekStartDate:NO] isSameDay:self->currentDate]){
                                                                                     self->nextBotton.hidden = true;
                                                                                 }else{
                                                                                     self->nextBotton.hidden = false;
                                                                                 }
                                                                                 if (![Utility isEmptyCheck:responseDict[@"UserMealFrequency"]]) {
                                                                                     self->mealFrequencyDict = responseDict[@"UserMealFrequency"];
                                                                                 }
                                                                                 if (self->mealFrequencyDict.count>0) {
                                                                                     [self->mealTable reloadData];
                                                                                 }
                                                                                 
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
-(void)generateSquadUserMealPlans:(NSNumber *)stepNumberForGenerateMeal{
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (weekDate) {
            [mainDict setObject:[dailyDateformatter stringFromDate:weekDate ] forKey:@"RunDate"];
        }
        [mainDict setObject:stepNumberForGenerateMeal forKey:@"exerciseStep"];
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
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GenerateSquadUserMealPlansApiCall" append:@""forAction:@"POST"];
        
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
                                                                         [self getMealPlanList];
                                                                         
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
-(void)setUpCaloriesRemaimingView{
    remainPlanLabel.text=[Utility customRoundNumber:self->totalCal];
    remainCaloriesLabel.text = [Utility customRoundNumber:self->intakeCal];
//    int remainingValue = totalCal - intakeCal;
    remainingLabel.text = [Utility customRoundNumber:totalCal - intakeCal];
}
#pragma mark -End
#pragma mark -Tableview Delegate and Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(myIntakeButton.isSelected){
        return myMealListArray.count;
    }else{
        return planMealListArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == mealTable){
        if (myIntakeButton.isSelected) {
            if ([Utility isEmptyCheck:myMealListArray]) {
                return 0;
            }
            NSDictionary *meal = [myMealListArray objectAtIndex:section];
            NSArray *mealList = [meal objectForKey:@"meals"];
            return mealList.count;
        }else{
            if ([Utility isEmptyCheck:planMealListArray]) {
                return 0;
            }
            NSArray *mealList;
            NSArray *myMealList;
            if (planMealListArray.count > section) {
                NSDictionary *meal = [planMealListArray objectAtIndex:section];
                if (![Utility isEmptyCheck:meal]) {
                    mealList = [meal objectForKey:@"meals"];
                }
            }
            if (myMealListArray.count > section) {
                NSDictionary *myMeal = [myMealListArray objectAtIndex:section];
                if (![Utility isEmptyCheck:myMeal]) {
                    myMealList = [myMeal objectForKey:@"meals"];
                }
            }
            if(isOnlyMyMeal){
                return myMealList.count > 0 ? myMealList.count + 1 : 1;
            }
            return myMealList.count >= mealList.count ? myMealList.count + 1 : mealList.count;
        }
        
    }else{
        return myIngredientListArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == mealTable){//} && myIntakeButton.isSelected){
        return 40;
    }
    //    else if(tableView == mealTable && myplanButton.isSelected){
    //        return 250;
    //    }
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // Removes extra padding in Grouped style
    if (tableView == mealTable && myIntakeButton.isSelected){
        return 50;
    }
//    else if(tableView == mealTable && myplanButton.isSelected){
//        return 250;
//    }
    return CGFLOAT_MIN;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == mealTable){//} && myIntakeButton.isSelected) {
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width-8, 40)];
        [myView setBackgroundColor:squadMainColor];//squadSubColor
        
        if ([Utility isEmptyCheck:myMealListArray]) {
            return nil;
        }
        NSDictionary *meal = [myMealListArray objectAtIndex:section];
        
        CGRect screen = [[UIScreen mainScreen] bounds];
//        CGFloat width = CGRectGetWidth(screen);
        CGFloat height = CGRectGetHeight(screen);
        if (height <= 667) {
            height = 10.0;
        } else {
            height = 13.0;//13
        }
        UILabel *typeLabel = [UILabel new];
        [typeLabel setBackgroundColor:[UIColor clearColor]];
        [typeLabel setTextColor:[UIColor whiteColor]];
        [typeLabel setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:height]];
        CGRect frame1 = myView.frame;
        frame1.origin.x = 15;
        typeLabel.frame = frame1;
        typeLabel.textAlignment = NSTextAlignmentLeft;
        typeLabel.numberOfLines=0;
        
        UILabel *calorieLabel = [UILabel new];
        [calorieLabel setBackgroundColor:[UIColor clearColor]];
        
        [calorieLabel setTextColor:[UIColor whiteColor]];
        [calorieLabel setFont:[UIFont fontWithName:@"Raleway-Bold" size:13]];
        frame1 = myView.frame;
        frame1.size.width = frame1.size.width-10;
        calorieLabel.frame = frame1;
        calorieLabel.textAlignment = NSTextAlignmentRight;
        
         NSString *calString = [@"" stringByAppendingFormat:@"P: %@ G   C: %@ G   F: %@ G",![Utility isEmptyCheck:[meal objectForKey:@"Protein"]]?[Utility customRoundNumber:[[meal objectForKey:@"Protein"]floatValue]]:@"0",![Utility isEmptyCheck:[meal objectForKey:@"Carb"]]?[Utility customRoundNumber:[[meal objectForKey:@"Carb"]floatValue]]:@"0",![Utility isEmptyCheck:[meal objectForKey:@"Fat"]]?[Utility customRoundNumber:[[meal objectForKey:@"Fat"]floatValue]]:@"0"];
        
        NSString *typeStr= ![Utility isEmptyCheck:[meal objectForKey:@"mealType"]]?[meal objectForKey:@"mealType"]:@"";
        NSString *pcfStr = ![Utility isEmptyCheck:calString]?calString:@"P: 0 G   C: 0 G   F: 0 G";
        
//        calorieLabel.text = ![Utility isEmptyCheck:calString]?calString:@"P: 0 G   C: 0 G   F: 0 G";
        calorieLabel.text = ![Utility isEmptyCheck:[meal objectForKey:@"TotalEnergy"]]?[@"" stringByAppendingFormat:@"%@ cal",[Utility customRoundNumber:[[meal objectForKey:@"TotalEnergy"]floatValue]]]:@"0 cal";
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:typeStr];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-SemiBold" size:13] range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])];
        
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[@""stringByAppendingFormat:@"\n%@",pcfStr]];
        [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:11] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString appendAttributedString:attributedString2];
        typeLabel.attributedText = attributedString;
        [myView addSubview:typeLabel];
        [myView addSubview:calorieLabel];
        
        return myView;
    }
    return nil;
}
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (tableView == mealTable && myIntakeButton.isSelected) {
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
        [myView setBackgroundColor:[UIColor whiteColor]];
        
        NSDictionary *meal = [myMealListArray objectAtIndex:section];
        NSString *mealtype = [@"" stringByAppendingFormat:@"%@",[meal objectForKey:@"mealType"]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        CGRect frame = myView.frame;
        [button setFrame:CGRectMake(15, 0, tableView.frame.size.width, 50)];
        [button addTarget:self action:@selector(addMyDayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [button setTitleEdgeInsets:UIEdgeInsetsMake(40, 100, 0, 0)];
//        [button setTitle:@"Add" forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"plus_challenge.png"] forState:UIControlStateNormal];//fp_plus.png
//        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
        
//        [button setTitle:@"Add" forState:UIControlStateNormal];
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        button.titleLabel.font =[UIFont fontWithName:@"Raleway-SemiBold" size:17];
//        [button setTitleColor:squadMainColor forState:UIControlStateNormal];
//        [button setBackgroundColor:[UIColor whiteColor]];
//        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        
        NSMutableAttributedString *newString =[[NSMutableAttributedString alloc] init];
        NSDictionary *attrsDictionary = @{
                                          NSFontAttributeName :myPlanProteinLabel.font,
                                          NSForegroundColorAttributeName :squadMainColor
                                          };
        NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:@"   Add" attributes:attrsDictionary];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"plus_challenge.png"];
        textAttachment.bounds = CGRectMake(0, -3, textAttachment.image.size.width, textAttachment.image.size.height);
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [newString appendAttributedString:attrStringWithImage];
        [newString appendAttributedString:attributedString];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setAttributedTitle:newString forState:UIControlStateNormal];
        
        int mealTag;
        if ([mealtype caseInsensitiveCompare:@"BREAKFAST"] == NSOrderedSame) {
            mealTag = 1;
        }else if ([mealtype caseInsensitiveCompare:@"LUNCH"] == NSOrderedSame){
            mealTag = 2;
        }else if ([mealtype caseInsensitiveCompare:@"DINNER"] == NSOrderedSame){
            mealTag = 3;
        }else{
            mealTag = 4;
        }
        button.tag = mealTag;
        [myView addSubview:button];
        
        return myView;
    }
//    else if (tableView == mealTable && myplanButton.isSelected) {
//        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(tableView.frame.size.width/2 + 10, 0, tableView.frame.size.width/2 - 20, 250)];
//        [myView setBackgroundColor:[UIColor whiteColor]];
//
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        CGRect frame = myView.frame;
//        button.frame = frame;
//        [button addTarget:self action:@selector(addMyDayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
////        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        [button setImage:[UIImage imageNamed:@"add_meal.png"] forState:UIControlStateNormal];
////        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
//        button.layer.borderColor = squadMainColor.CGColor;
//        button.layer.borderWidth = 1.0f;
//        button.tag = section;
//        [myView addSubview:button];
//
//        return myView;
//    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"MealMatchTableViewCell";
    
    MealMatchTableViewCell *cell = (MealMatchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MealMatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    NSString *planMealCal = @"";
    NSString *myMealCal = @"";
    NSDictionary *mealDict;
    NSDictionary *myMealDict;
    
    
    
        if (tableView == mealTable){
    
            if (myIntakeButton.isSelected) {
                CellIdentifier = @"MealMatchTableSingleViewCell";
                MealMatchTableViewCell *cell = (MealMatchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[MealMatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                if (![Utility isEmptyCheck:myMealListArray]) {
                    NSDictionary *meal = [myMealListArray objectAtIndex:indexPath.section];
//                    if (indexPath.row == 0) {
//                        cell.headerView.hidden = false;
//                    } else {
//                        cell.headerView.hidden = true;
//                    }
                    cell.headerView.hidden = true;
//                    cell.mealTypeLabel.text = [meal objectForKey:@"mealType"];
                    if (![Utility isEmptyCheck:meal]) {
                        NSArray *mealList = [meal objectForKey:@"meals"];
                        NSDictionary *mealDetails = [mealList objectAtIndex:indexPath.row];
                        NSString *quantity = [@"" stringByAppendingFormat:@"%d",![Utility isEmptyCheck:[mealDetails objectForKey:@"Quantity"]]?([[mealDetails objectForKey:@"Quantity"]intValue]>0?[[mealDetails objectForKey:@"Quantity"]intValue]:1):1];
                        cell.quantity.text = quantity;
                        NSString *mealName = ![Utility isEmptyCheck:[mealDetails objectForKey:@"MealName"]]?[[mealDetails objectForKey:@"MealName"]capitalizedString]:@"";
                        if ([Utility isEmptyCheck:mealName]) {
                            mealName = ![Utility isEmptyCheck:[mealDetails objectForKey:@"EdamamFoodName"]]?[[mealDetails objectForKey:@"EdamamFoodName"]capitalizedString]:@"";
                        }
                        if ([Utility isEmptyCheck:mealName]) {
                            mealName = ![Utility isEmptyCheck:[mealDetails objectForKey:@"PersonalFoodName"]]?[[mealDetails objectForKey:@"PersonalFoodName"]capitalizedString]:@"";
                        }
                        cell.myMealName.text = ![Utility isEmptyCheck:mealName]?[mealName capitalizedString]:quickAdd;
                        cell.myMealImage.hidden = ![[mealDetails objectForKey:@"IsSquadRecipe"]boolValue];
                        if([Utility isEmptyCheck:[mealDetails objectForKey:@"MealId"]]){
                            cell.myMealImage.hidden = true;
                        }
                        cell.myMealCal.text = [@"" stringByAppendingFormat:@"%@ C",![Utility isEmptyCheck:[mealDetails objectForKey:@"TotalEnergy"]]?[Utility customRoundNumber:[[mealDetails objectForKey:@"TotalEnergy"]floatValue]]:@"0"];
                        
                        if (![Utility isEmptyCheck:[mealDetails objectForKey:@"QtyMetric"]] && [[mealDetails objectForKey:@"QtyMetric"]floatValue]>0.0 && ![Utility isEmptyCheck:[mealDetails objectForKey:@"MetricUnit"]]) {
                            cell.metricQuantyDetails.text =[@"" stringByAppendingFormat:@"%@ %@",[Utility customRoundNumber:[[mealDetails objectForKey:@"QtyMetric"]floatValue]],[mealDetails objectForKey:@"MetricUnit"]];
                        }else{
                            cell.metricQuantyDetails.text=@"";
                        }
                        
                        if (![Utility isEmptyCheck:[mealDetails objectForKey:@"DateAddedUtc"]]) {
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            NSDate *date = [formatter dateFromString:[mealDetails objectForKey:@"DateAddedUtc"]];
                            NSLog(@"%@",[mealDetails objectForKey:@"DateAddedUtc"]);
                            formatter.dateFormat = @"HH";
                            NSString *hour = [formatter stringFromDate:date];
                            formatter.dateFormat = @"mm";
                            NSString *min = [formatter stringFromDate:date];
//                            formatter.dateFormat = @"ss";
//                            NSString *sec = [formatter stringFromDate:date];
                            formatter.dateFormat = @"a";
                            NSString *amPmStr = [formatter stringFromDate:date];
                            NSString *dateStr=@"";
                            if ([hour intValue]>0) {
                                dateStr = [@"" stringByAppendingFormat:@"%@",hour];
                            }
                            if ([min intValue]>0) {
                                if (![dateStr isEqualToString:@""]) {
                                    dateStr = [dateStr stringByAppendingFormat:@":%@",min];
                                }else{
                                    dateStr = [dateStr stringByAppendingFormat:@"%@",min];
                                }
                               
                            }
//                            if ([sec intValue]>0) {
//                                if (![dateStr isEqualToString:@""]) {
//                                    dateStr = [dateStr stringByAppendingFormat:@":%@",sec];
//                                }else{
//                                    dateStr = [dateStr stringByAppendingFormat:@"%@",sec];
//                                }
//                            }
                            if (![dateStr isEqualToString:@""]) {
                                 cell.intakeDate.text = [@"" stringByAppendingFormat:@"%@%@",dateStr,[amPmStr lowercaseString]];
                            }else{
                                 cell.intakeDate.text=@"";
                            }
                            
                        }else{
                            cell.intakeDate.text=@"";
                        }
                    
//                        cell.pcfLabel.text = [@"" stringByAppendingFormat:@"P: %@ G     C: %@ G     F: %@ G",![Utility isEmptyCheck:[mealDetails objectForKey:@"Protein"]]?[Utility customRoundNumber:[[mealDetails objectForKey:@"Protein"]floatValue]]:@"0",![Utility isEmptyCheck:[mealDetails objectForKey:@"Carb"]]?[Utility customRoundNumber:[[mealDetails objectForKey:@"Carb"]floatValue]]:@"0",![Utility isEmptyCheck:[mealDetails objectForKey:@"Fat"]]?[Utility customRoundNumber:[[mealDetails objectForKey:@"Fat"]floatValue]]:@"0"];
                        
                    }
                    cell.deleteButton.tag = indexPath.row;
                    cell.deleteButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
                    return cell;
                }
            }
            
            BOOL showAddButton = false;
           if (planMealListArray.count > 0 && planMealListArray.count >indexPath.section) {
               NSDictionary *meal = [planMealListArray objectAtIndex:indexPath.section];
               NSArray *mealList = [meal objectForKey:@"meals"];
               cell.mealAddButton.tag = [[[mealList objectAtIndex:0] objectForKey:@"MealType"]intValue];
               if (mealList.count > 0 && mealList.count >indexPath.row) {
                   mealDict = mealList[indexPath.row];
               }
            }
            if (myMealListArray.count > 0 && myMealListArray.count >indexPath.section) {
                NSDictionary *meal = [myMealListArray objectAtIndex:indexPath.section];
                NSArray *mealList = [meal objectForKey:@"meals"];
                if (mealList.count == indexPath.row) {
                    showAddButton = true;
                }
                if (mealList.count > 0 && mealList.count >indexPath.row) {
                    myMealDict = mealList[indexPath.row];
                }
            }
            
            if (![Utility isEmptyCheck:mealDict]){
                NSDictionary *mealDetails = mealDict[@"MealDetails"];
                if (![Utility isEmptyCheck:mealDetails]) {
                    cell.planMealView.hidden = false;
                    NSString *mealTypeStr = @"";
                    
                    NSDictionary *meal = [planMealListArray objectAtIndex:indexPath.section];
                    cell.mealTypeLabel.text = [[mealTypeStr stringByAppendingFormat:@"%@",![Utility isEmptyCheck:[meal objectForKey:@"mealType"]]?[meal objectForKey:@"mealType"]:@""] uppercaseString];
                    
                    cell.planMealName.text =![Utility isEmptyCheck:mealDetails[@"MealName"]] ? mealDetails[@"MealName"] :@"";
                    NSString *imageString = mealDetails[@"PhotoSmallPath"];
                    if (![Utility isEmptyCheck:imageString]) {
                        [cell.planMealImage sd_setImageWithURL:[NSURL URLWithString:imageString]
                                              placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages];  //ah 17.5
                    } else {
                        cell.planMealImage.image = [UIImage imageNamed:@"meal_no_img.png"];
                    }
                    
                    planMealCal = ![Utility isEmptyCheck:[mealDict objectForKey:@"Calories"]] ? [formatter stringFromNumber:[mealDict objectForKey:@"Calories"]] :[formatter stringFromNumber:@(0)]; //CalsTotal
                    
                    NSString *fat =![Utility isEmptyCheck:[mealDict objectForKey:@"Fat"]] ? [@"" stringByAppendingFormat:@"%.2fG",[[mealDict objectForKey:@"Fat"] floatValue]] : [formatter stringFromNumber:@(0)] ;
                    NSString *carbs = ![Utility isEmptyCheck:[mealDict objectForKey:@"Carbohydrates"]] ? [@"" stringByAppendingFormat:@"%.2fG",[[mealDict objectForKey:@"Carbohydrates"] floatValue]] : [formatter stringFromNumber:@(0)] ;
                    NSString *protien = ![Utility isEmptyCheck:[mealDict objectForKey:@"Protein"]] ? [@"" stringByAppendingFormat:@"%.2fG",[[mealDict objectForKey:@"Protein"] floatValue]] : [formatter stringFromNumber:@(0)] ;
                    
//                    cell.planMealCal.text = [@"PLAN : " stringByAppendingFormat:@"%@ C\nP: %@  C: %@  F: %@",planMealCal,protien,carbs,fat];
                    cell.planMealCal.text = [@"" stringByAppendingFormat:@"%@ cal",planMealCal];
                    
                }else{
                    cell.planMealView.hidden = true;
                }

            }else{
                cell.planMealView.hidden = true;
            }
            
            
            if (![Utility isEmptyCheck:myMealListArray]){
                
                if (![Utility isEmptyCheck:myMealDict]) {
//                    NSDictionary *mealDetails = myMealDict[@"MealDetails"];
                    cell.myMealView.hidden = false;
                    cell.myMealAddView.hidden = true;
                    NSString *imageString = myMealDict[@"Photo"];
                    if(![Utility isEmptyCheck:imageString]) {
                        [cell.myMealImage sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages];  //ah 17.5
                    }else {
                        cell.myMealImage.image = [UIImage imageNamed:@"meal_no_img.png"];
                    }

                    NSString *mealName = ![Utility isEmptyCheck:[myMealDict objectForKey:@"MealName"]]?[[myMealDict objectForKey:@"MealName"]capitalizedString]:@"";
                    if ([Utility isEmptyCheck:mealName]) {
                        mealName = ![Utility isEmptyCheck:[myMealDict objectForKey:@"EdamamFoodName"]]?[[myMealDict objectForKey:@"EdamamFoodName"]capitalizedString]:@"";
                    }
                    if ([Utility isEmptyCheck:mealName]) {
                        mealName = ![Utility isEmptyCheck:[myMealDict objectForKey:@"PersonalFoodName"]]?[[myMealDict objectForKey:@"PersonalFoodName"]capitalizedString]:@"";
                    }
                    cell.myMealName.text = ![Utility isEmptyCheck:mealName]?[mealName capitalizedString]:quickAdd;
                    myMealCal = ![Utility isEmptyCheck:[myMealDict objectForKey:@"TotalEnergy"]] ? [formatter stringFromNumber:[myMealDict objectForKey:@"TotalEnergy"]] :[formatter stringFromNumber:@(0)];
                    
                    NSString *fat =![Utility isEmptyCheck:[myMealDict objectForKey:@"Fat"]] ? [@"" stringByAppendingFormat:@"%.2f",[[myMealDict objectForKey:@"Fat"] floatValue]] : [formatter stringFromNumber:@(0)] ;
                    NSString *carbs = ![Utility isEmptyCheck:[myMealDict objectForKey:@"Carb"]] ? [@"" stringByAppendingFormat:@"%.2f",[[myMealDict objectForKey:@"Carb"] floatValue]] : [formatter stringFromNumber:@(0)] ;
                    NSString *protien = ![Utility isEmptyCheck:[myMealDict objectForKey:@"Protein"]] ? [@"" stringByAppendingFormat:@"%.2f",[[myMealDict objectForKey:@"Protein"] floatValue]] : [formatter stringFromNumber:@(0)] ;
                    
//                    cell.myMealCal.text = [@"INTAKE : " stringByAppendingFormat:@"%@ C\nP: %@G  C: %@G  F: %@G",myMealCal,protien,carbs,fat];//
                    cell.myMealCal.text = [@"" stringByAppendingFormat:@"%@ cal",myMealCal];
                }else{
                    cell.myMealView.hidden = false;
                    cell.myMealAddView.hidden = false;
                }
                
//                if (myMealListArray.count > 1){
//
//                    if(indexPath.row == 0){
//                        cell.upArrow.hidden = true;
//                        cell.downArrow.hidden = false;
//
//                    }else if (indexPath.row == myMealListArray.count-1) {
//                        cell.downArrow.hidden = true;
//                        cell.upArrow.hidden = false;
//
//                    }else{
//                        cell.downArrow.hidden = false;
//                        cell.upArrow.hidden = false;
//                    }
//
//                }else{
//
//                    cell.downArrow.hidden = true;
//                    cell.upArrow.hidden = true;
//                }
                
            }else{
                cell.myMealView.hidden = false;//true;
                cell.myMealAddView.hidden = false;
            }
            cell.mealAddButton.hidden = !showAddButton;
            
            cell.matchButton.hidden = true;
            
            if (myMealCal.length>0 && planMealCal.length>0){
                
                if ([planMealCal floatValue] == [myMealCal floatValue]){
                    cell.matchButton.hidden = false;
                }
            }
            
            cell.deleteButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
            
            if (indexPath.row == 0) {
                cell.extraSectionHiddenView.hidden = true;
                cell.mealTypeLabelHeight.constant = 0;
                cell.mealTypeLabel.hidden = true;
                cell.myIntakeLabel.hidden = false;
                cell.myPlanLabel.hidden = false;
            } else {
                if (mealDict) {
                    cell.extraSectionHiddenView.hidden = true;
                } else {
                    cell.extraSectionHiddenView.hidden = false;
                }
                cell.mealTypeLabel.hidden = true;
                cell.mealTypeLabelHeight.constant = 0;
                cell.myIntakeLabel.hidden = true;
                cell.myPlanLabel.hidden = true;
            }
            
            if (isOnlyMyMeal) {
                cell.planMealView.hidden = true;
            }else{
                cell.planMealView.hidden = false;
            }
            if (isSwap) {
                if (currentRow == indexPath.row) {
                    cell.swapView.hidden = true;
                } else {
                    cell.swapView.hidden = false;
                }
            } else {
                cell.swapView.hidden = true;
            }
            cell.swap.tag = indexPath.row;
            cell.swap.accessibilityHint = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
            cell.swapButton.tag = indexPath.row;
            cell.swapButton.accessibilityHint = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
            
            //meal table end
            
        }else{
            
            if (myIngredientListArray.count > 0 && myIngredientListArray.count >indexPath.row) {
                myMealDict = myIngredientListArray[indexPath.row];
             }
            
            cell.upArrow.enabled = false;
            cell.downArrow.enabled = false;
            
            cell.otherFoodView.hidden = true;
            if (indexPath.row == 0){
                cell.otherFoodView.hidden = false;
            }
            
            if (![Utility isEmptyCheck:myMealDict]){
                cell.myMealView.hidden = false;
                NSString *imageString = myMealDict[@"Photo"];
                    if(![Utility isEmptyCheck:imageString]) {
                        [cell.myMealImage sd_setImageWithURL:[NSURL URLWithString:imageString]
                                            placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages];  //ah 17.5
                    }else {
                        cell.myMealImage.image = [UIImage imageNamed:@"meal_no_img.png"];
                    }
                
                    cell.myMealName.text =![Utility isEmptyCheck:myMealDict[@"IngredientName"]] ? myMealDict[@"IngredientName"] :@"";
                
                NSDictionary *IngredientDetail = myMealDict[@"IngredientDetail"];
                myMealCal =@"";
                if(![Utility isEmptyCheck:IngredientDetail]){
                    
                    float QtyMetric = ![Utility isEmptyCheck:[myMealDict objectForKey:@"QtyMetric"]]? [[myMealDict objectForKey:@"QtyMetric"] floatValue] : 0.0;
                    
                    float CalsPer100 = [IngredientDetail[@"CalsPer100"] floatValue];
                    
                    float ingredientCalori;
                    
                    if (QtyMetric > 0){
                        
                        if(CalsPer100 > 0){
                            ingredientCalori = CalsPer100*QtyMetric/100;
                            myMealCal = [@"" stringByAppendingFormat:@"%.2f",ingredientCalori];
                            
                        }else{
                            
                            Calorie *cal =[Utility ingredientCalorieCalculation:QtyMetric proteinPer100:[IngredientDetail[@"ProteinPer100"] floatValue] fatPer100:[IngredientDetail[@"FatPer100"] floatValue] carbPer100:[IngredientDetail[@"CarbsPer100"] floatValue] alcoholPer100:[IngredientDetail[@"AlcoholPer100"] floatValue] unit:myMealDict[@"MetricUnit"] conversionUnit:IngredientDetail[@"ConversionUnit"] conversionFactor:[IngredientDetail[@"ConversionNum"] floatValue]];
                            
                            ingredientCalori = [[Utility totalCalories:cal] floatValue];
                        }
                    
                        myMealCal = [@"" stringByAppendingFormat:@"%.2f",ingredientCalori];
                    }
                }
                
                ingredientCal += [myMealCal floatValue];
                
                if(indexPath.row == myIngredientListArray.count-1){
                    intakeCal=ingredientCal+intakeCal;
//                    myIntakeLabel.text = [@"" stringByAppendingFormat:@"%.2f",intakeCal];
                    self->myIntakeLabel.text = [Utility customRoundNumber:self->intakeCal];
                    [self plotDifferenceCal];
                }
                
                if([myMealCal floatValue]>0.0){
                    NSString *fat =![Utility isEmptyCheck:[IngredientDetail objectForKey:@"FatPer100"]] ? [@"" stringByAppendingFormat:@"%.2fG",[[IngredientDetail objectForKey:@"FatPer100"] floatValue]] : [formatter stringFromNumber:@(0)] ;
                    NSString *carbs = ![Utility isEmptyCheck:[IngredientDetail objectForKey:@"CarbsPer100"]] ? [@"" stringByAppendingFormat:@"%.2fG",[[IngredientDetail objectForKey:@"CarbsPer100"] floatValue]] : [formatter stringFromNumber:@(0)] ;
                    NSString *protien = ![Utility isEmptyCheck:[IngredientDetail objectForKey:@"ProteinPer100"]] ? [@"" stringByAppendingFormat:@"%.2fG",[[IngredientDetail objectForKey:@"ProteinPer100"] floatValue]] : [formatter stringFromNumber:@(0)] ;
                    
//                    cell.myMealCal.text = [@"INTAKE : " stringByAppendingFormat:@"%@ C\nP: %@  C: %@  F: %@",myMealCal,protien,carbs,fat];//
                    cell.myMealCal.text = [@"" stringByAppendingFormat:@"%@ cal",myMealCal];
                }else{
                    cell.myMealCal.text = [@"" stringByAppendingFormat:@"%@",myMealCal];
                }
                
                    
//                if (myIngredientListArray.count > 1){
//
//                    if(indexPath.row == 0){
//                        cell.upArrow.hidden = true;
//                        cell.downArrow.hidden = false;
//
//                    }else if (indexPath.row == myIngredientListArray.count-1) {
//                        cell.downArrow.hidden = true;
//                        cell.upArrow.hidden = false;
//
//                    }else{
//                        cell.downArrow.hidden = false;
//                        cell.upArrow.hidden = false;
//                    }
//
//                }else{
//
//                    cell.downArrow.hidden = true;
//                    cell.upArrow.hidden = true;
//                }

                
                
            }else{
                cell.myMealView.hidden = false;// true;
            }
            
            cell.deleteButton.accessibilityHint = @"ingredient";
//            cell.deleteButton.tag = indexPath.row;
//            cell.myMealDetailsButton.tag = indexPath.row;

        }
    
//    cell.upArrow.hidden = true;
//    cell.downArrow.hidden = true;
    cell.upArrow.tag = indexPath.row;
    cell.downArrow.tag = indexPath.row;
    cell.deleteButton.tag = indexPath.row;
    cell.myMealDetailsButton.tag = indexPath.row;
    cell.mealDetailsButton.tag = indexPath.row;
    
    cell.myMealDetailsButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
    cell.mealDetailsButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
    
    cell.upArrow.hidden = true; //Su_chng
    cell.downArrow.hidden = true;//Su_chng
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == mealTable && myIntakeButton.isSelected){
        UIButton *btn = [UIButton new];
        btn.tag = indexPath.row;
        btn.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
        [self myMealDetailsButtonPressed:btn];
    }
}

#pragma mark - DailyGoodnessViewDelegate
-(void)didCheckAnyChangeForDailyGoodness:(BOOL)ischanged{
    isChanged = ischanged;
}
#pragma mark - End
#pragma mark - MealTypeDelgate
-(void)didCheckAnyChangeForMealType:(BOOL)ischanged{
    isChanged= ischanged;
}
#pragma mark - MealAddViewDelegate
-(void)didCheckAnyChangeForMealAdd:(BOOL)ischanged with:(BOOL)isFrom{
    isChanged = ischanged;
}
#pragma mark - End
#pragma mark - MealAddViewDelegate
-(void)checkChangeMealAdd:(BOOL)ischanged{
    isChanged = ischanged;
}
#pragma mark - End
#pragma mark  - Water Tracker Delegte
-(void)didCheckAnyChangeInWaterTracker:(BOOL)ischanged{
    isChanged = ischanged;
}
-(void)didCheckAnyChangeForMealPlan:(BOOL)ischanged{
    isChanged = ischanged;
}
#pragma mark - End

#pragma mark - Text Field Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"did end");
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    textField.text = ([waterLabel.text intValue]>=[textField.text intValue])?textField.text:@"0";
    return YES;
}
- (IBAction)substractWaterButtonPressed:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Substract Water"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Enter water in ml";
         textField.keyboardType = UIKeyboardTypeNumberPad;
         textField.delegate = self;
     }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Substract"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *water = alertController.textFields.firstObject;
                                   
                                   [self saveWater:(0 - [water.text intValue])];
                                   
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark - End

#pragma mark - Date Picker View Delegate
-(void)didSelectDate:(NSDate *)date{
    NSLog(@"%@",date);
    if (date) {
        if([date isSameDay:currentDate]){
            return;
        }
        currentDate = date;
        
        ingredientCal = 0.0;
        [self getListData];
    }
}
#pragma mark - End

-(void)reloadView:(NSNotification*)notification{
    isChanged = true;
}
-(void)reloadMealmatch:(NSNotification*)notification{
    isChanged = true;
}
-(void)reloadFromFooter:(NSNotification*)notification{
    isChanged = true;
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//        if (scrollView.contentOffset.y < yOffset) {
//            // scrolls down.
//            yOffset = scrollView.contentOffset.y;
//            scrollDirection = @"down";
//            intakePlanView.hidden =true;
//            intakePlanHeightConstant.constant = 0;
//        }
//        else {
//            // scrolls up.
//            yOffset = scrollView.contentOffset.y;
//            scrollDirection = @"up";
//            intakePlanView.hidden = false;
//            intakePlanHeightConstant.constant = 70;
//        }
//}
@end
