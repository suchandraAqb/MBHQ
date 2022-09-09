//
//  CustomNutritionPlanListCollectionViewController.m
//  Squad
//
//  Created by aqbsol iPhone on 22/01/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "CustomNutritionPlanListCollectionViewController.h"
#import "CustomNutritionPlanListDateCollectionViewCell.h"
#import "CustomNutritionPlanListNewCollectionViewCell.h"
#import "CustomNutritionPlanListNewCollectionViewCell.h"
#import "CustomNutritionPlanListBlankCollectionViewCell.h"
#import "SquadUserDailySessionsPopUpViewController.h"
#import "ShoppingCartPopUpViewController.h"
#import "ShoppingListViewController.h"


@interface CustomNutritionPlanListCollectionViewController (){
    
    //IBOutlet UICollectionView *collection;
    
    NSTimer *countDownTimer;
    
    NSMutableArray *nutritionPlanListArray;
    UIView *contentView;
    
    NSDate *beginningOfWeekDate;
    NSDate *joiningDate;
    int apiCount;
    NSDateFormatter *dailyDateformatter;
    NSArray *squadUserDailySessionsArray;
    NSDictionary *mealFrequencyDict;
    BOOL haveToCallGenerateMeal;
    NSMutableArray *squadCustomMealSessionList;
    NSArray *tempShoppingList;
    int rowNumber;
    int sectionNumber;
    int state;
    int numberOfMeal;
    CGFloat cX,cY;
    UIImageView *triangleImageView;
    NSIndexPath *myIndexPath;
    NSMutableArray *selectedMealArray;
    
    BOOL isChanged;
    BOOL isFirstTime;
    NSString *programName; //SetProgram_In
    NSString *weekNumber;//SetProgram_In
    NSString *UserProgramIdStr;//Today_SetProgram_In
    NSString *ProgramIdStr;//Today_SetProgram_In
}
@end

@implementation CustomNutritionPlanListCollectionViewController
@synthesize isComplete,stepnumber,weekDate,delegate,isMultipleSwap,swapMealDict,isCustom;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    nutritionPlanListArray = [[NSMutableArray alloc]init];
    tempShoppingList = [[NSArray alloc]init];
    squadCustomMealSessionList = [[NSMutableArray alloc]init];
    selectedMealArray = [NSMutableArray new];
    
    _collection.hidden = false;
    apiCount = 0;
    NSDate* today = [NSDate date] ;
    
    dailyDateformatter = [[NSDateFormatter alloc]init];
    [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dailyDateformatter stringFromDate:today];
    today = [dailyDateformatter dateFromString:dateString];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //[gregorian setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question. (If today is Sunday, subtract 0 days.)
     */
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:today];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    
    if (beginningOfWeek) {
        beginningOfWeekDate = beginningOfWeek;
    }
    if (!weekDate) {
        weekDate = beginningOfWeekDate;
    }
    isChanged = true;
    isFirstTime = true;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        if(!_isFromShoppingList){
    //            [self.view bringSubviewToFront:countDownView];
    //            countDownView.hidden = false;
    //            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    //        }
    //    });
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: YES];
    if (!isChanged) {
        return;
    }
    if (isFirstTime) {
        isFirstTime = false;
        isChanged = false;
    }
    _collection.hidden = true;
    haveToCallGenerateMeal = YES;
    tempShoppingList = [[NSArray alloc]init];
    [nutritionPlanListArray removeAllObjects];
    [squadCustomMealSessionList removeAllObjects];
    state = 0;
    rowNumber = -1;
    sectionNumber = -1;
    myIndexPath = [[NSIndexPath alloc]init];
    //saveCustomShoppingList.hidden = true;
    //[Utility stopFlashingbutton:saveCustomShoppingList];
    
    if(isMultipleSwap){
        _applyMultipleSwapButton.hidden = false;
    }else{
        _applyMultipleSwapButton.hidden = true;
    }
//    [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
//    BOOL showIsFirst = false;
//    NSString *firstDate = [dailyDateformatter stringFromDate:beginningOfWeekDate];
//    NSString *date = @"";
//    if (![Utility isEmptyCheck:[defaults objectForKey:@"NourishWeekFirst"]]) {
//        date = [@"" stringByAppendingFormat:@"%@",[defaults objectForKey:@"NourishWeekFirst"]];
//    }
//    if (![Utility isEmptyCheck:date]) {
//        if ([Utility date:[dailyDateformatter dateFromString:date] isBetweenDate:[dailyDateformatter dateFromString:firstDate] andDate:[[dailyDateformatter dateFromString:firstDate]dateByAddingDays:6]]) {
//            if (![date isEqualToString:firstDate]) {
//                showIsFirst = true;
//            }
//        }else{
//            showIsFirst = true;
//        }
//    }else{
//        showIsFirst = true;
//    }
//    if (showIsFirst) {
//        isCustom = true;
//    }
//    [defaults setObject:firstDate forKey:@"NourishWeekFirst"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getSquadMealPlanWithSettings];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -IBAction

- (IBAction)userDailySessionButtonPressed:(UIButton *)sender {
    
    if(isMultipleSwap) return;
    
    SquadUserDailySessionsPopUpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SquadUserDailySessionsPopUp"];
    controller.delegate = self;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    NSDictionary *dict = nutritionPlanListArray[sender.tag];
    NSString *dateString = dict[@"day"];
    NSDate *date = [formatter dateFromString:dateString];
    if (date) {
        controller.sessionDate = date;
    }
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];
}

-(IBAction)mealSelected:(UIButton *)sender{
    if (isCustom) {
        return;
    }
    if (!isMultipleSwap) {
        NSDictionary *dict = nutritionPlanListArray[sender.accessibilityHint.integerValue];
        NSArray *mealDataArray = dict[@"mealData"];
        NSDictionary *mealData = mealDataArray[sender.tag-1];
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
                controller.mealId = [mealData objectForKey:@"MealId"];
                controller.mealSessionId = [mealData objectForKey:@"MealSessionId"];
                controller.dateString = dateString;
                controller.fromController = @"Meal";    //ah ux
                controller.delegate = self;
                [self.navigationController pushViewController:controller animated:YES];
            }
            
        }
    }
}
-(IBAction)cartButtonPressed:(UIButton *)sender{
    if (!isMultipleSwap) {
        isCustom = true;
        [delegate closeShopView];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.intValue];
        CustomNutritionPlanListNewCollectionViewCell *cell = (CustomNutritionPlanListNewCollectionViewCell *)[_collection cellForItemAtIndexPath:indexPath];
        
        if (sender == cell.cartButton){
            state = 1;
            rowNumber = (int)indexPath.row;
            sectionNumber = (int)indexPath.section;
            myIndexPath = indexPath;
            
            NSDictionary *dict = nutritionPlanListArray[indexPath.section];
            NSArray *mealDataArray = dict[@"mealData"];
            NSDictionary *mealData = mealDataArray[indexPath.row-1];
            int noofServe = 0;
            int oldServe = 0;
            if (![Utility isEmptyCheck:mealData]) {
                if (squadCustomMealSessionList.count > 0){
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
                    NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
                    if (![Utility isEmptyCheck:filteredArray]){
                        NSMutableDictionary *temp = [filteredArray[0] mutableCopy];
                        oldServe = [temp[@"NoofServe"] intValue];
                        noofServe = [temp[@"NoofServe"] intValue];
                    }else{
                        NSMutableDictionary *temp = [mealData mutableCopy];
                        noofServe = 1;
                        [temp setObject:[NSNumber numberWithInt:noofServe] forKey:@"NoofServe"];
                        [self->squadCustomMealSessionList addObject:temp];
                    }
                }else{
                    NSMutableDictionary *temp = [mealData mutableCopy];
                    noofServe = 1;
                    [temp setObject:[NSNumber numberWithInt:noofServe] forKey:@"NoofServe"];
                    [self->squadCustomMealSessionList addObject:temp];
                }
            }
            
            if (oldServe == 0) {
                [self checkCustomShoppinListChange];
                [_collection reloadData];
            } else {
                
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:nil
                                                      message:nil
                                                      preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:@"ADJUST SERVINGS"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               CGSize hh = cell.frame.size;
                                               int h1 = hh.height;
                                               int y1 = cell.frame.origin.y;
                                               self->cX = self->_collection.contentOffset.x;
                                               self->cY = self->_collection.contentOffset.y;
                                               self->triangleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pink_triangle.png"]];
                                               self->triangleImageView.frame = CGRectMake(cell.center.x-8, h1, 16, 10);
                                               [self.view addSubview:self->triangleImageView];
                                               CGRect frame = [self.view convertRect:self->triangleImageView.frame toView:self.view.superview.superview];
                                               [self.collection setContentOffset:CGPointMake(self->_collection.contentOffset.x, y1) animated:YES];
                                               
                                               ShoppingCartPopUpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingCartPopUp"];
                                               controller.delegate = self;
                                               controller.noOfServe = noofServe;
                                               controller.indexPath = self->myIndexPath;
                                               if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                                                   CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                                                   if (screenSize.height >= 812){
                                                       controller.top = frame.origin.y + frame.size.height - 44; //20 added for safe area iphoneX
                                                   }else{
                                                       controller.top = frame.origin.y + frame.size.height;
                                                   }
                                                   
                                               }
                                               controller.modalPresentationStyle = UIModalPresentationCustom;
                                               [self presentViewController:controller animated:YES completion:nil];
                                               
                                               [self checkCustomShoppinListChange];
                                               [self->_collection reloadData];
                                           }];
                UIAlertAction *removeAction = [UIAlertAction
                                               actionWithTitle:@"REMOVE"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action)
                                               {
                                                   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
                                                   NSArray *filteredArray = [self->squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
                                                   if (![Utility isEmptyCheck:filteredArray]){
                                                       NSMutableDictionary *temp = [filteredArray[0] mutableCopy];
                                                       [self->squadCustomMealSessionList removeObject:temp];
                                                   }
                                                   
                                                   [self checkCustomShoppinListChange];
                                                   [self->_collection reloadData];
                                               }];
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:@"CANCEL"
                                               style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction *action)
                                               {
                                                   
                                               }];
                [alertController addAction:okAction];
                [alertController addAction:removeAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
            
//            [self updateShoplistButton];
//            cell.cartButton.selected = false;
//            cell.circleImage.hidden = true;
//            cell.circleLabel.hidden = true;
//            cell.cartBigSelectedImageButton.hidden = false;
//            cell.cartBigSelectedImage.hidden = false;
//            cell.selectedCircleImage.hidden = false;
//            cell.selectedCircleLabel.hidden = false;
            
        }
    }
}
-(void)collectionCartSelected:(int)numberOfMeals index:(NSIndexPath *)indexPath{
    numberOfMeal = numberOfMeals;
    
    [self shoppingPlusMinus:numberOfMeals index:indexPath];
    [delegate selectedCartOPtion:numberOfMeal row:rowNumber section:sectionNumber];
}
-(void)saveCartPressed:(int)numberOfMeals index:(NSIndexPath *)indexPath{
    numberOfMeal = numberOfMeals;
    NSDictionary *dict = nutritionPlanListArray[indexPath.section];
    NSArray *mealDataArray = dict[@"mealData"];
    NSDictionary *mealData = mealDataArray[indexPath.row-1];
    if (numberOfMeal == 0) {
        if (![Utility isEmptyCheck:mealData]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
            if (squadCustomMealSessionList.count>0) {
                NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
                if (filteredArray.count > 0){
                    [squadCustomMealSessionList removeObject:filteredArray[0]];
                }
            }
        }
    }
    
    [self checkCustomShoppinListChange];
    [_collection reloadData];
    [triangleImageView removeFromSuperview];
    [self.collection setContentOffset:CGPointMake(cX,cY) animated:YES];
    
//    [self saveCustomShoppingListButtonPressed:indexPath];
    //[delegate selectedSaveOption:myTotal row:rowNumber section:sectionNumber];
}
-(void)cancelPressed:(int)oldNoOfMeals index:(NSIndexPath *)indexPath{
    numberOfMeal = oldNoOfMeals;
    if (oldNoOfMeals != 0) {
        NSDictionary *dict = nutritionPlanListArray[indexPath.section];
        NSArray *mealDataArray = dict[@"mealData"];
        NSDictionary *mealData = mealDataArray[indexPath.row-1];
        
        if (![Utility isEmptyCheck:mealData]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
            NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
            if (filteredArray.count > 0){
                NSMutableDictionary *temp = [filteredArray[0] mutableCopy];
                [temp setObject:[NSNumber numberWithInt:oldNoOfMeals] forKey:@"NoofServe"];
                [squadCustomMealSessionList removeObject:filteredArray[0]];
                [squadCustomMealSessionList addObject:temp];
                
            }
        }
    } else {
        NSDictionary *dict = nutritionPlanListArray[indexPath.section];
        NSArray *mealDataArray = dict[@"mealData"];
        NSDictionary *mealData = mealDataArray[indexPath.row-1];
        if (![Utility isEmptyCheck:mealData]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
            if (squadCustomMealSessionList.count>0) {
                NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
                if (filteredArray.count > 0){
                    [squadCustomMealSessionList removeObject:filteredArray[0]];
//                    [self saveCustomShoppingListButtonPressed:indexPath];
                }
            }
        }
    }
    
    [self checkCustomShoppinListChange];
    [triangleImageView removeFromSuperview];
    [_collection reloadData];
    [self.collection setContentOffset:CGPointMake(cX,cY) animated:YES];
}

-(IBAction)applyMultipleSwapButtonPressed:(UIButton *)sender{
    
    if(!selectedMealArray.count){
        [Utility msg:@"Please select meal(s) to swap" title:@"" controller:self haveToPop:NO];
        return;
    }
    [self updateMultipleSwap];
    
}

-(IBAction)selectMealButtonPressed:(UIButton *)sender{
    
    NSDictionary *dict = nutritionPlanListArray[sender.accessibilityHint.integerValue];
    NSArray *mealDataArray = dict[@"mealData"];
    NSDictionary *mealData = mealDataArray[sender.tag-1];
    
    if([selectedMealArray containsObject:mealData]){
        [selectedMealArray removeObject:mealData];
    }else{
        [selectedMealArray addObject:mealData];
    }
    
    [_collection reloadData];
}
- (IBAction)singleSwapButtonPressed:(UIButton *)sender {
    _isListView = false;
    [delegate didCheckAnyChangeForCollection:NO];
    NSDictionary *dict = nutritionPlanListArray[sender.accessibilityHint.integerValue];
    NSArray *mealDataArray = dict[@"mealData"];
    NSDictionary *mealData = mealDataArray[sender.tag-1];
    /*MealSwapDropDownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealSwapDropDownView"];
    controller.isFromFoodPrep = NO;
    controller.delegate = self;
    controller.controllerNeedToUpdate = self;
    controller.mealSessionIdToReplace = [[mealData objectForKey:@"MealSessionId"] intValue];
    [self.navigationController pushViewController:controller animated:YES];*/
    
    FoodPrepSearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrepSearch"];
    controller.delegate = self;
    controller.isFromFoodPrep = NO;
    controller.mealSessionIdToReplace = [[mealData objectForKey:@"MealSessionId"] intValue];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -End
-(void)saveCustomShoppingListButtonPressed{
    if(!isCustom){
        ShoppingListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingListView"];
        controller.isCustom = YES;
        controller.weekdate = self->weekDate;
        controller.delegate = self.parentViewController;
        [self.parentViewController.navigationController pushViewController:controller animated:YES];
        return;
    }
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (weekDate) {
            [mainDict setObject:[dailyDateformatter stringFromDate:weekDate ] forKey:@"SessionDate"];
        }
        NSMutableArray *mealSessionArray = [[NSMutableArray alloc]init];
        for (NSDictionary *temp in squadCustomMealSessionList) {
            NSString *sessionIds = [NSString stringWithFormat:@"%@-%@",temp[@"MealSessionId"],temp[@"NoofServe"]];
            [mealSessionArray addObject:sessionIds];
        }
        [mainDict setObject:mealSessionArray forKey:@"ArrayMealSessionId"];
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
//            [self.view bringSubviewToFront:countDownView];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddCustomShoppingList" append:@""forAction:@"POST"];
        
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
                                                                         self->isCustom = false;
                                                                         
                                                                         int myTotal = 0;
                                                                         for (NSDictionary *temp in self->squadCustomMealSessionList) {
                                                                             myTotal += [temp[@"NoofServe"]intValue];
                                                                         }
                                                                         [self getSquadCustomMealSession];
                                                                         [self->delegate selectedSaveOption:myTotal row:self->rowNumber section:self->sectionNumber];
                                                                         
                                                                         ShoppingListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingListView"];
                                                                         controller.isCustom = YES;
                                                                         controller.weekdate = self->weekDate;
                                                                         controller.delegate = self.parentViewController;
                                                                         [self.parentViewController.navigationController pushViewController:controller animated:YES];
                                                                         
                                                                         [self->delegate shoppingButtonFlashCheck:false];
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

-(void)shoppingPlusMinus:(int)numberOfMeals index:(NSIndexPath *)indexPath{
    NSDictionary *dict = nutritionPlanListArray[indexPath.section];
    NSArray *mealDataArray = dict[@"mealData"];
    NSDictionary *mealData = mealDataArray[indexPath.row-1];
    if (![Utility isEmptyCheck:mealData]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
        NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
        if (filteredArray.count > 0){
            NSMutableDictionary *temp = [filteredArray[0] mutableCopy];
            int noofServe = numberOfMeals;
            [temp setObject:[NSNumber numberWithInt:noofServe] forKey:@"NoofServe"];
            [squadCustomMealSessionList removeObject:filteredArray[0]];
            [squadCustomMealSessionList addObject:temp];
        }
    }
    [self checkCustomShoppinListChange];
    [_collection reloadData];
}

- (void)nextButton{
    
    squadCustomMealSessionList = [[NSMutableArray alloc]init];
    tempShoppingList = [[NSArray alloc]init];
    NSTimeInterval sixmonth =0;
    weekDate = [weekDate
                dateByAddingTimeInterval:sixmonth];
    //apiCount =0;
    haveToCallGenerateMeal = YES;
    [self getSquadMealPlanWithSettings];
    
}
- (void)previousButton{
    
    squadCustomMealSessionList = [[NSMutableArray alloc]init];
    tempShoppingList = [[NSArray alloc]init];
    NSTimeInterval sixmonth =0;
    weekDate = [weekDate
                dateByAddingTimeInterval:sixmonth];
    //apiCount =0;
    haveToCallGenerateMeal = YES;
    [self getSquadMealPlanWithSettings];
}
-(void)didChooseOption:(int)index sessionDate:(NSDate *)sessionDate{
    NSLog(@"..........%d",index);
    [self saveSquadUserSessionCountApiCall:index sessionDate:sessionDate];
}
- (void)reloadMyCollection{
    
    [self.collection reloadData];
    [self getSquadMealPlanWithSettings];
}
#pragma mark -Private Method
-(void)save:(NSMutableArray *)avoidAllArray{
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
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            _collection.hidden = true;
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
                                                                         [self getSquadMealPlanWithSettings];
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
//-(void)updateView{
//    to show or hide previous next button
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"dd/MM/yyyy"];
//        if ([[formatter stringFromDate:beginningOfWeekDate] isEqualToString:[formatter stringFromDate:weekDate]]) {
//            weekDateLabel.text = @"Current Week";
//        }else{
//            weekDateLabel.text = [@"Week - " stringByAppendingFormat:@"%@",[formatter stringFromDate:weekDate] ];
//        }
//    NSTimeInterval sixmonth = 13*24*60*60;
//    NSDate *endDate = [beginningOfWeekDate
//                       dateByAddingTimeInterval:sixmonth];
//    NSDate *nxtDate = [weekDate dateByAddingTimeInterval:7*24*60*60];
//        if ([endDate compare:nxtDate] == NSOrderedDescending || [endDate compare:nxtDate] == NSOrderedSame) {
//            nextButton.hidden = false;
//        }else{
//            nextButton.hidden = true;
//        }
//    NSDate *prevDate = [weekDate dateByAddingTimeInterval:-7*24*60*60];
//        if ([joiningDate compare:prevDate] == NSOrderedAscending || [joiningDate compare:prevDate] == NSOrderedSame) {
//            previousButton.hidden = false;
//        }else{
//            previousButton.hidden = true;
//        }
//}
-(NSArray*)daysInWeek:(int)weekOffset fromDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    // [formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    //create date on week start
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:(0 - ([comps weekday] - weekOffset))];
    NSDate *weekstart = [calendar dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    //add 7 days
    NSMutableArray* week=[NSMutableArray arrayWithCapacity:7];
    for (int i=0; i<7; i++) {
        NSDateComponents *compsToAdd = [[NSDateComponents alloc] init];
        compsToAdd.day=i;
        NSDate *nextDate = [calendar dateByAddingComponents:compsToAdd toDate:weekstart options:0];
        [week addObject:[formatter stringFromDate:nextDate ]];
        
    }
    return [NSArray arrayWithArray:week];
}
-(void)saveSquadUserSessionCountApiCall:(int)index sessionDate:(NSDate *)sessionDate{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (sessionDate) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *dateString = [formatter stringFromDate:sessionDate];
            if (![Utility isEmptyCheck:dateString]) {
                [mainDict setObject:dateString forKey:@"SessionDate"];
            }
        }
        [mainDict setObject:[NSNumber numberWithInt:index] forKey:@"NoOfSessions"];
        
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
            //            [self.view bringSubviewToFront:countDownView];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SaveSquadUserSessionCountApiCall" append:@""forAction:@"POST"];
        
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
                                                                         [self getSquadMealPlanWithSettings];
                                                                         
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


-(void)deleteMealApiCall:(NSNumber *)mealSessionId{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealSessionId forKey:@"MealSessionId"];
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
            //            [self.view bringSubviewToFront:countDownView];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadRemoveUserMealSessionApiCall" append:@""forAction:@"POST"];
        
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
                                                                         [self getSquadMealPlanWithSettings];
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
-(void)repeatMealApiCall:(NSNumber *)mealSessionId repeat:(NSNumber *)repeat{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealSessionId forKey:@"MealSessionId"];
        [mainDict setObject:repeat forKey:@"Repeat"];
        
        
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
            //contentView = [Utility activityIndicatorView:self withMsg:@"Don’t forget to watch the Nourish ‘How To’ video to learn how to get the most of your custom plan." font:[UIFont fontWithName:@"Raleway-SemiBold" size:16] color:[UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1]];
            
            //            [self.view bringSubviewToFront:countDownView];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadRepeatMealNextWeekApiCall" append:@""forAction:@"POST"];
        
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
                                                                         [self getSquadMealPlanWithSettings];
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
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GenerateSquadUserMealPlansApiCall" append:@""forAction:@"POST"];
        
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
                                                                         haveToCallGenerateMeal = NO;
                                                                         [self getSquadMealPlanWithSettings];
                                                                         
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
        dailyDateformatter = [[NSDateFormatter alloc]init];
        [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
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
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            _collection.hidden = true;
            //            blankMsgLabel.hidden = false;
            
            
            
            //contentView = [Utility activityIndicatorView:self withMsg:@"Don’t forget to watch the Nourish ‘How To’ video to learn how to get the most of your custom plan." font:[UIFont fontWithName:@"Raleway-SemiBold" size:16] color:[UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1]];
            contentView = [Utility activityIndicatorView:self];
           
            //            if(_isFromShoppingList)
            //                blankMsgLabel.text = @"";
            //            else
            //                blankMsgLabel.text = @"Don’t forget to watch the Nourish ‘How To’ video to learn how to get the most of your custom plan.";
            //            [self.view bringSubviewToFront:countDownView];
            
        });
        [nutritionPlanListArray removeAllObjects];
        [squadCustomMealSessionList removeAllObjects];
//        isCustom = true;
        //            saveCustomShoppingList.hidden = true;
        //            [Utility stopFlashingbutton:saveCustomShoppingList];
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadMealPlanWithSettingsApiCall" append:@""forAction:@"POST"];
        
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
                                                                         if (![Utility isEmptyCheck:responseDict[@"WeekStartDate"] ]) {
                                                                             NSDate *date = [dailyDateformatter dateFromString:responseDict[@"WeekStartDate"]];
                                                                             if (date) {
                                                                                 joiningDate = date;
                                                                                 //SetProgram_In
                                                                                 if (![Utility isEmptyCheck:responseDict[@"MealPlanResponse"]]) {
                                                                                     NSDictionary *dict = responseDict[@"MealPlanResponse"];
                                                                                     if (![Utility isEmptyCheck:[dict objectForKey:@"ProgramName"]]) {
                                                                                         self->programName = [dict objectForKey:@"ProgramName"];
                                                                                     }else{
                                                                                         self->programName = @"";
                                                                                     }
                                                                                     if (![Utility isEmptyCheck:[dict objectForKey:@"WeekNumber"]]) {
                                                                                         self->weekNumber = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"WeekNumber"]];
                                                                                     }else{
                                                                                         self->weekNumber =@"";
                                                                                     }
                                                                                     //Today_SetProgram_In
                                                                                     if (![Utility isEmptyCheck:[dict objectForKey:@"UserProgramId"]]) {
                                                                                         self->UserProgramIdStr = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"UserProgramId"]];
                                                                                     }else{
                                                                                         self->UserProgramIdStr = @"";
                                                                                     }
                                                                                     if (![Utility isEmptyCheck:[dict objectForKey:@"ProgramId"]]) {
                                                                                         self->ProgramIdStr = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ProgramId"]];
                                                                                     }else{
                                                                                         self->ProgramIdStr = @"";
                                                                                     }
                                                                                 }//SetProgram_In
//                                                                                 [self updateView];
                                                                                 //add_su_3/8/17
                                                                                 NSTimeInterval secondWeekStart = 14*24*60*60;
                                                                                 NSDate *secondJoiningStart = [joiningDate
                                                                                                               dateByAddingTimeInterval:secondWeekStart];
                                                                                 
                                                                                 NSDate *secondJoiningEnd = [joiningDate
                                                                                                             dateByAddingTimeInterval:secondWeekStart+6*24*60*60];
                                                                                 
                                                                                 
                                                                                 NSTimeInterval fifthWeek = 35*24*60*60;
                                                                                 NSDate *fifthJoiningStart = [joiningDate
                                                                                                              dateByAddingTimeInterval:fifthWeek];
                                                                                 
                                                                                 NSDate *fifthJoiningEnd = [joiningDate
                                                                                                            dateByAddingTimeInterval:fifthWeek+6*24*60*60];
                                                                                 
                                                                                 if ([weekDate compare:secondJoiningStart] == NSOrderedDescending && [weekDate compare:secondJoiningEnd] == NSOrderedAscending) {
                                                                                    
                                                                                 }else if ([weekDate compare:fifthJoiningStart] == NSOrderedDescending && [weekDate compare:fifthJoiningEnd] == NSOrderedAscending){
                                                                                     
                                                                                 }
                                                                                 //
                                                                                 if (![Utility isEmptyCheck:responseDict[@"UserMealFrequency"]]) {
                                                                                     mealFrequencyDict=responseDict[@"UserMealFrequency"];
                                                                                 }
                                                                                 
                                                                                 
                                                                                 if (![Utility isEmptyCheck:responseDict[@"UserSessionCountList"]]) {
                                                                                     squadUserDailySessionsArray = responseDict[@"UserSessionCountList"];
                                                                                     
                                                                                 }
                                                                                 if (![Utility isEmptyCheck:responseDict[@"MealPlanResponse"]]) {
                                                                                     
                                                                                     if(nutritionPlanListArray.count>0){
                                                                                         [nutritionPlanListArray removeAllObjects];
                                                                                     }
                                                                                     
                                                                                     NSDictionary *mealPlanResponse = responseDict[@"MealPlanResponse"];
                                                                                     if (![Utility isEmptyCheck:mealPlanResponse] && [mealPlanResponse[@"Success"] boolValue]) {
                                                                                         NSArray *rawNutritionDataArray = [mealPlanResponse[@"SquadMealSessions"] mutableCopy];
                                                                                         if (![Utility isEmptyCheck:rawNutritionDataArray] && rawNutritionDataArray.count > 0) {
                                                                                             NSArray *uniqueDates = [rawNutritionDataArray valueForKeyPath:@"@distinctUnionOfObjects.MealDate"];
                                                                                             NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"self"
                                                                                                                                                          ascending:YES];
                                                                                             NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
                                                                                             NSArray *sortedArray = [uniqueDates sortedArrayUsingDescriptors:sortDescriptors];
                                                                                             NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                                                                                             formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
                                                                                             //[formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
                                                                                             if (sortedArray.count > 0) {
                                                                                                 NSString *sessionDate =[sortedArray objectAtIndex:0];
                                                                                                 if (![Utility isEmptyCheck:sessionDate]) {
                                                                                                     NSDate *fstDate = [formatter dateFromString:sessionDate ];
                                                                                                     NSArray *weekDayArray = [self daysInWeek:2 fromDate:fstDate];
                                                                                                     for (NSString *date in weekDayArray) {
                                                                                                         NSArray *filteredarray = [rawNutritionDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(MealDate == %@)", date]];
                                                                                                         if (filteredarray.count > 0) {
                                                                                                             [nutritionPlanListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredarray,@"mealData",date,@"day", nil]];
                                                                                                         }else{
                                                                                                             [nutritionPlanListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[[NSArray alloc]init],@"mealData",date,@"day", nil]];
                                                                                                         }
                                                                                                     }
                                                                                                     if (nutritionPlanListArray.count > 0){
                                                                                                         _collection.hidden = false;
                                                                                                         //                                                                                                         blankMsgLabel.hidden = true;
                                                                                                         
                                                                                                         [self getSquadCustomMealSession];
                                                                                           [_collection reloadData];
                                                                                                     }
                                                                                                     if (apiCount == 0) {
                                                                                                         [_collection reloadData];
                                                                                                         if (_isFromShoppingList) {
                                                                                                             _isFromShoppingList = false;
//                                                                                                             [self getSquadCustomMealSession];
                                                                                                         }
                                                                                                     }
                                                                                                 }else{
                                                                                                     [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                                                                                                     return;
                                                                                                 }
                                                                                             }else{
                                                                                                 [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                                                                                                 return;
                                                                                             }
                                                                                             
                                                                                         }else{
                                                                                             if (![Utility isEmptyCheck:[responseDict objectForKey:@"NourishSettingsStep"]] && [[responseDict objectForKey:@"NourishSettingsStep"] isEqual:@0]) {
                                                                                                 if (haveToCallGenerateMeal) {
                                                                                                     [self generateSquadUserMealPlans:[responseDict objectForKey:@"NourishSettingsStep"]];
                                                                                                 }
                                                                                             }else{
                                                                                                 [Utility msg:@"Please setup your Meal Plan" title:@"Warning!" controller:self haveToPop:NO];
                                                                                                 return;
                                                                                             }
                                                                                         }
                                                                                     }else{
                                                                                         [_collection reloadData];                        [Utility msg:mealPlanResponse[@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                                         return;
                                                                                     }
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
-(void)getSquadCustomMealSession{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (weekDate) {
            [mainDict setObject:[dailyDateformatter stringFromDate:weekDate ] forKey:@"SessionDate"];
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
            //            [self.view bringSubviewToFront:countDownView];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadCustomMealSessionApiCall" append:@""forAction:@"POST"];
        
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
                                                                         
                                                                         NSArray *shoppings = responseDict[@"SquadCustomMealSessionList"];
                                                                         if(![Utility isEmptyCheck:shoppings]){//it is because duplicate is coming from android
                                                                             NSMutableArray *tempControllers = [NSMutableArray new];
                                                                             NSMutableArray *uniqueController = [NSMutableArray new];
                                                                             for (NSDictionary *controller in [shoppings reverseObjectEnumerator]) {
                                                                                 int noServe = ![Utility isEmptyCheck:[controller objectForKey:@"NoofServe"]]?[[controller objectForKey:@"NoofServe"]intValue]:0;
                                                                                 NSString *stringVC = [controller objectForKey:@"MealSessionId"];
                                                                                 if (![tempControllers containsObject:stringVC] && noServe>0) {
                                                                                     [tempControllers addObject:stringVC];
                                                                                     [uniqueController addObject:controller];
                                                                                 }
                                                                             }
                                                                             shoppings = [[uniqueController reverseObjectEnumerator] allObjects];
                                                                         }
                                                                         
                                                                         self->squadCustomMealSessionList = [shoppings mutableCopy];
                                                                         self->tempShoppingList = shoppings;
                                                                         if (self->nutritionPlanListArray.count>0) {
                                                                             [self->_collection reloadData];
                                                                         }
                                                                         [self->delegate shoppingButtonFlashCheck:false];
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

-(BOOL)checkCustomShoppinListChange{
    BOOL notMatched = false;
    if (tempShoppingList.count == squadCustomMealSessionList.count) {
        for (NSDictionary *mealData in squadCustomMealSessionList) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
            NSArray *filteredArray = [tempShoppingList filteredArrayUsingPredicate:predicate];
            if (filteredArray.count >0) {
                if (![filteredArray[0][@"NoofServe"] isEqualToNumber:mealData[@"NoofServe"]]) {
                    notMatched = true;
                    break;
                }
            }else{
                notMatched = true;
                break;
            }
        }
    }else{
        notMatched = true;
    }
//    if (notMatched) {
//        saveCustomShoppingList.hidden = false;
//        [Utility startFlashingbutton:saveCustomShoppingList];
//    }else{
//        saveCustomShoppingList.hidden = true;
//        [Utility stopFlashingbutton:saveCustomShoppingList];
//    }
    [delegate shoppingButtonFlashCheck:notMatched];
    return notMatched;
}
//- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {
//    if (true) {
//        UIAlertController *alertController = [UIAlertController
//                                              alertControllerWithTitle:@"Save Changes"
//                                              message:@"Your changes will be lost if you don’t save them."
//                                              preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction
//                                   actionWithTitle:@"Save"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction *action)
//                                   {
////                                       [saveCustomShoppingList sendActionsForControlEvents:UIControlEventTouchUpInside];
//                                       response(NO);
//                                   }];
//        UIAlertAction *cancelAction = [UIAlertAction
//                                       actionWithTitle:@"Don't Save"
//                                       style:UIAlertActionStyleDefault
//                                       handler:^(UIAlertAction *action)
//                                       {
//                                           squadCustomMealSessionList = [[NSMutableArray alloc]init];
//                                           tempShoppingList = [[NSArray alloc]init];
//                                           response(YES);
//                                       }];
//        [alertController addAction:okAction];
//        [alertController addAction:cancelAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    } else {
//        squadCustomMealSessionList = [[NSMutableArray alloc]init];
//        tempShoppingList = [[NSArray alloc]init];
//        response(YES);
//    }
//}

-(void)updateMultipleSwap{
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        NSArray *arr = [self populateMultipleSwapList];
        if(arr.count>0){
           [mainDict setObject:arr forKey:@"updateMealList"];
        }
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadMultipleUpdateMealForSession" append:@""forAction:@"POST"];
        
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
                                                                         [selectedMealArray removeAllObjects];
                                                                         [self swapCompleteAction];
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

-(NSArray *)populateMultipleSwapList{
    NSMutableArray *list = [NSMutableArray new];
    if(![Utility isEmptyCheck:swapMealDict]){
        int NewMealId = 0;
        if(![Utility isEmptyCheck:[swapMealDict objectForKey:@"Id"]]){
           NewMealId = [[swapMealDict objectForKey:@"Id"] intValue];
        }else if (![Utility isEmptyCheck:swapMealDict[@"MealDetail"][@"Id"]]){
            NewMealId = [swapMealDict[@"MealDetail"][@"Id"] intValue];
        }
        
        for(NSDictionary *dataDict in selectedMealArray){
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[NSNumber numberWithBool:1] forKey:@"IsSelected"];
            [dict setObject:[NSNumber numberWithInt:NewMealId] forKey:@"NewMealId"];
            int MealSessionId = [[dataDict objectForKey:@"MealSessionId"] intValue];
            [dict setObject:[NSNumber numberWithInt:MealSessionId] forKey:@"MealSessionId"];
            [list addObject:dict];
        }
    }
    
    return list;
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
                             /*if (self->_isListView) {
                                 if([self.parentViewController isKindOfClass:[CustomNutritionPlanListViewController class]]){
                                     self->isMultipleSwap = NO;
                                     self->_applyMultipleSwapButton.hidden = true;
                                     CustomNutritionPlanListViewController *controller = (CustomNutritionPlanListViewController *)self.parentViewController;
                                     controller.multipleSwapHeaderView.hidden = true;
                                     [controller listButtonPressed:0];
                                 }
                             }else{
                                 self->isMultipleSwap = NO;
                                 self->_applyMultipleSwapButton.hidden = true;
                                 [self->delegate swapMealHeaderName:nil active:false];
                                 [self getSquadMealPlanWithSettings];
                             }*/
                             self->isMultipleSwap = NO;
                             self->_applyMultipleSwapButton.hidden = true;
                             CustomNutritionPlanListViewController *controller = (CustomNutritionPlanListViewController *)self.parentViewController;
                             controller.multipleSwapHeaderView.hidden = true;
                             [controller listButtonPressed:0];
                             
                         }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark -End
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark -Collection View Delegates and Datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return nutritionPlanListArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int max = 0;
    NSArray *mealDataArray;
//    NSDictionary *dict = nutritionPlanListArray[section];
    for (NSDictionary *temp in nutritionPlanListArray) {
        mealDataArray = temp[@"mealData"];
        if (mealDataArray.count>max) {
            max = (int)mealDataArray.count;
        }
    }
//    NSArray *mealDataArray = dict[@"mealData"];
//    return mealDataArray.count+1;
    return max+1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int max = 0;
    NSArray *mealDataArray;
    //    NSDictionary *dict = nutritionPlanListArray[section];
    for (NSDictionary *temp in nutritionPlanListArray) {
        mealDataArray = temp[@"mealData"];
        if (mealDataArray.count>max) {
            max = (int)mealDataArray.count;
        }
    }
//    NSDictionary *dict = nutritionPlanListArray[indexPath.section];
//    NSArray *mealDataArray = dict[@"mealData"];
    CGFloat height = (CGRectGetHeight(_collection.bounds))/nutritionPlanListArray.count;
    NSLog(@"%f",CGRectGetHeight(_collection.frame));
    int h,w,mWidth;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            w = 40;
            h = (int)height+20+40;
        }else{
            mWidth = CGRectGetWidth(_collection.bounds);
//            w = (mWidth-40)/(float)mealDataArray.count;
            w = (int)(mWidth-40)/max;
            h = (int)height+20+40;
        }
    }else{

        if (indexPath.row == 0) {
            w = 40;
            h = height+40;
        }else{
            mWidth = CGRectGetWidth(_collection.bounds);
//            w = (mWidth-40)/(float)mealDataArray.count;
            w = (int)(mWidth-40)/max;
            h = (int)height+20+40;
        }
    }
    h = 130;
    if (isCustom) {
        h = 170;
    }
    return CGSizeMake(w, h);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0,0,0,0);
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
    
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell *collectionViewCell;
    NSString *CellIdentifier =@"CustomNutritionPlanListNewCollectionViewCell";
    CustomNutritionPlanListNewCollectionViewCell *cell = (CustomNutritionPlanListNewCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    [[cell.cartButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [[cell.cartBigSelectedImageButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    cell.cartButton.hidden = true;
    cell.cartHeightConstraint.constant = 0;
    
    NSString *CellIdentifier2 =@"CustomNutritionPlanListDateCollectionViewCell";
    CustomNutritionPlanListDateCollectionViewCell *dateCell = (CustomNutritionPlanListDateCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier2 forIndexPath:indexPath];
    if (indexPath.section==0) {
        cell.mealTypeLabel.hidden=false;
        [cell.mealTypeLabel setFont:[UIFont systemFontOfSize:17]];
        dateCell.emptyLabel.hidden=false;
        dateCell.emptyLabel.text=@" ";
        [dateCell.emptyLabel setFont:[UIFont systemFontOfSize:17]];
        dateCell.viewMiddleConstraint.constant = 20;
    } else {
        dateCell.emptyLabel.hidden=true;
        dateCell.emptyLabel.text=@"";
        [dateCell.emptyLabel setFont:[UIFont systemFontOfSize:0]];
        cell.mealTypeLabel.hidden=true;
        cell.mealTypeLabel.text=@"";
        [cell.mealTypeLabel setFont:[UIFont systemFontOfSize:0]];
        dateCell.viewMiddleConstraint.constant = 0;
    }
    if(indexPath.row==0){
        if(nutritionPlanListArray.count>0){
            NSDictionary *dict = nutritionPlanListArray[indexPath.section];
            NSString *sDate=dict[@"day"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
            NSDate *date = [formatter dateFromString:sDate];
            formatter.dateFormat = @"EEEE";
            NSString *dayName=[formatter stringFromDate:date].uppercaseString;
            
            NSArray *mealData=dict[@"mealData"];
            if(mealData.count<6){
                dayName=[dayName substringToIndex:3];
            }else{
                dayName=[dayName substringToIndex:1];
            }
            formatter.dateFormat = @"d";
            NSString *dateStr = [formatter stringFromDate:date];
            
            if (date) {
                dateCell.dayLabel.text=dayName;
                dateCell.dateLabel.text=dateStr;
                dateCell.dayButton.tag=indexPath.row;
                dateCell.dumbleButton.tag=indexPath.section;
                
                if(![Utility isEmptyCheck:squadUserDailySessionsArray]){
                    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
                    NSString *sessionDateString = [formatter stringFromDate:date];
                    NSArray *filteredarray = [squadUserDailySessionsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SessionDate == %@)", sessionDateString]];
                    NSLog(@"%@",filteredarray);
                    if (![Utility isEmptyCheck:filteredarray]) {
                        //====
                        if (![Utility isEmptyCheck:programName] && ![Utility isEmptyCheck:ProgramIdStr] && ![Utility isEmptyCheck:UserProgramIdStr]) {
                            
                            if (![Utility isEmptyCheck:mealData]) {
//                                NSArray *mealdataArr = [dict objectForKey:@"mealData"];
                                if (![Utility isEmptyCheck:[mealData objectAtIndex:0]]) {
                                    NSDictionary *mealdatadict = [mealData objectAtIndex:0];
                                    if ([Utility isEmptyCheck:[mealdatadict objectForKey:@"CalorieType"]] || [[mealdatadict objectForKey:@"CalorieType"]intValue] == 0) {
                                        dateCell.dumbleImage.hidden = false;
                                        dateCell.dumbleButton.hidden = false;
                                        dateCell.dumbleText.hidden = false;
                                        NSDictionary *dailySessionDict = filteredarray[0];
                                        if ([dailySessionDict[@"NoOfSessions"] isEqualToNumber:@2])
                                        {
                                            dateCell.dumbleText.text = @"2";
                                        }else if ([dailySessionDict[@"NoOfSessions"] isEqualToNumber:@0]){
                                            dateCell.dumbleText.text = @"X";
                                        }else if ([dailySessionDict[@"NoOfSessions"] isEqualToNumber:@-1]){
                                            dateCell.dumbleText.text = @"C";
                                        }else{
                                            dateCell.dumbleText.text = @"1";
                                            
                                        }
                                    }else{
                                        dateCell.dumbleButton.hidden = true;
                                        dateCell.dumbleImage.hidden = true;
                                        dateCell.dumbleText.hidden = true;
                                    }
                                }
                            }
                        }else{
                            NSDictionary *dailySessionDict = filteredarray[0];
                            if ([dailySessionDict[@"NoOfSessions"] isEqualToNumber:@2])
                            {
                                dateCell.dumbleText.text = @"2";
                            }else if ([dailySessionDict[@"NoOfSessions"] isEqualToNumber:@0]){
                                dateCell.dumbleText.text = @"X";
                            }else if ([dailySessionDict[@"NoOfSessions"] isEqualToNumber:@-1]){
                                dateCell.dumbleText.text = @"C";
                            }else{
                                dateCell.dumbleText.text = @"1";
                                
                            }
                        }
                    }
                }
            }
            
        }
        
        collectionViewCell = dateCell;
    }else{
        if (nutritionPlanListArray.count>0) {
            NSDictionary *dict = nutritionPlanListArray[indexPath.section];
            NSArray *mealDataArray = dict[@"mealData"];
            if (![Utility isEmptyCheck:mealFrequencyDict]) {
//                int totalMeal = ![Utility isEmptyCheck:mealFrequencyDict[@"TotalMeals"]] ? [mealFrequencyDict[@"TotalMeals"] intValue] : 0;
//                int mealCount = ![Utility isEmptyCheck:mealFrequencyDict[@"MealCount"]] ? [mealFrequencyDict[@"MealCount"] intValue] : 0;
                int snackCount = ![Utility isEmptyCheck:mealFrequencyDict[@"SnackCount"]] ? [mealFrequencyDict[@"SnackCount"] intValue] : 0;
                if (snackCount > 0){
                    if (indexPath.row == 1) {
                        cell.mealTypeLabel.text = @"B";
                    }else if (indexPath.row == 2) {
                        cell.mealTypeLabel.text = @"L";
                    }else if (indexPath.row == 3) {
                        cell.mealTypeLabel.text = @"D";
                    }else {
                        cell.mealTypeLabel.text = [@"" stringByAppendingFormat:@"M%d",(int)indexPath.row-3];
                    }
                }else{
                    cell.mealTypeLabel.text = [@"" stringByAppendingFormat:@"M%d",(int)indexPath.row];
                }
            }else{
                cell.mealTypeLabel.text = [@"" stringByAppendingFormat:@"M%d",(int)indexPath.row];
            }
            if (indexPath.row <= mealDataArray.count) {
                cell.addView.hidden = true;
                NSDictionary *mealData = mealDataArray[indexPath.row-1];
                NSDictionary *mealDetails = mealData[@"MealDetails"];
                if (![Utility isEmptyCheck:mealData]) {
                    
                    [cell.mealTypeLabel setBackgroundColor:[UIColor colorWithRed:241.0/255.0f green:241.0/255.0f blue:241.0/255.0f alpha:1.0]];
                    cell.mealNameLabel.text=![Utility isEmptyCheck:mealDetails[@"MealName"]] ? mealDetails[@"MealName"] :@"";
                    
                    cell.mealNameButton.tag = indexPath.row;
                    cell.cartButton.tag = indexPath.row;
                    cell.circleImage.tag = indexPath.row;
                    cell.circleLabel.tag = indexPath.row;
                    cell.cartBigSelectedImageButton.tag = indexPath.row;
                    cell.cartBigSelectedImage.tag = indexPath.row;
                    cell.selectedCircleImage.tag = indexPath.row;
                    cell.selectedCircleLabel.tag = indexPath.row;
                    cell.swapSelectedButton.tag = indexPath.row;
                    cell.mealNameButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
                    cell.cartButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
                    cell.circleImage.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
                    cell.circleLabel.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
                    cell.cartBigSelectedImageButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
                    cell.cartBigSelectedImage.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
                    cell.selectedCircleImage.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
                    cell.selectedCircleLabel.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
                    cell.swapSelectedButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
                    
                    cell.singleSwapButton.tag = indexPath.row;
                    cell.singleSwapButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
                    
//                    cell.cartButton.selected = false;
//                    cell.circleImage.hidden = true;
//                    cell.circleLabel.hidden = true;
//                    cell.cartBigSelectedImageButton.hidden = true;
//                    cell.cartBigSelectedImage.hidden = true;
//                    cell.selectedCircleImage.hidden = true;
//                    cell.selectedCircleLabel.hidden = true;
//                    if (squadCustomMealSessionList.count>0) {
//                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
//                        NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
//                        if (filteredArray.count > 0){
//                            cell.cartButton.selected = true;
//                            cell.circleImage.hidden = false;
//                            cell.circleLabel.hidden = false;
//                            cell.circleLabel.text = [NSString stringWithFormat:@"%@", filteredArray[0][@"NoofServe"]];
//                            cell.cartBigSelectedImageButton.hidden = true;
//                            cell.cartBigSelectedImage.hidden = true;
//                            cell.selectedCircleImage.hidden = true;
//                            cell.selectedCircleLabel.hidden = true;
//                        }
//                    }
                    
                    if(isMultipleSwap){
                        cell.swapSelectionView.hidden = false;
                        cell.singleSwapButton.hidden = true;
                        if([selectedMealArray containsObject:mealData]){
                            [cell.swapSelectedButton setSelected:YES];
                        }else{
                            [cell.swapSelectedButton setSelected:NO];
                        }
                    } else if (isCustom){
                        cell.cartButton.hidden = false;
                        cell.cartHeightConstraint.constant = 40;
                        cell.singleSwapButton.hidden = true;
                        cell.swapSelectionView.hidden = true;
                    } else {
                        cell.singleSwapButton.hidden = false;
                        cell.swapSelectionView.hidden = true;
                        [cell.swapSelectedButton setSelected:NO];
                    }
                    
                    
                    
                    [cell.cartButton setImage:[UIImage imageNamed:@"cart_new.png"] forState:UIControlStateNormal];
                    cell.circleImage.hidden = true;
                    cell.circleLabel.hidden = true;
                    cell.cartBigSelectedImageButton.hidden = true;
                    cell.cartBigSelectedImage.hidden = true;
                    cell.selectedCircleImage.hidden = true;
                    cell.selectedCircleLabel.hidden = true;
                    if(isCustom){
                        [cell.cartButton setImage:[UIImage imageNamed:@"sL_uncheck.png"] forState:UIControlStateNormal];
                        if (squadCustomMealSessionList.count>0) {
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
                            NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
                            int noOfServe = 0;
                            if (![Utility isEmptyCheck:filteredArray]) {
                                noOfServe = [filteredArray[0][@"NoofServe"]intValue];
                                if (noOfServe <= 0) {
                                    [cell.cartButton setImage:[UIImage imageNamed:@"sL_uncheck.png"] forState:UIControlStateNormal];
                                } else if (noOfServe == 1) {
                                    [cell.cartButton setImage:[UIImage imageNamed:@"sL_check.png"] forState:UIControlStateNormal];
                                } else {
                                    [cell.cartButton setImage:[UIImage imageNamed:@"cart_pink_background.png"] forState:UIControlStateNormal];
                                    cell.circleImage.hidden = false;
                                    cell.circleLabel.hidden = false;
                                    cell.circleLabel.text = [NSString stringWithFormat:@"%d", noOfServe];
                                }
                            }
                        }
                    }else{
//                        if (squadCustomMealSessionList.count>0) {
//                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
//                            NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
//                            if (filteredArray.count > 0){
//                                [cell.cartButton setImage:[UIImage imageNamed:@"cart_pink_background.png"] forState:UIControlStateNormal];
//                                cell.circleImage.hidden = false;
//                                cell.circleLabel.hidden = false;
//                                cell.circleLabel.text = [NSString stringWithFormat:@"%@", filteredArray[0][@"NoofServe"]];
//                                cell.cartBigSelectedImageButton.hidden = true;
//                                cell.cartBigSelectedImage.hidden = true;
//                                cell.selectedCircleImage.hidden = true;
//                                cell.selectedCircleLabel.hidden = true;
//                            }
//                        }
                    }
                }
            } else {
                cell.swapSelectionView.hidden = true;
                cell.addView.hidden = false;
            }
            
            collectionViewCell=cell;
        } else{
            NSString *CellIdentifier =@"CustomNutritionPlanListBlankCollectionViewCell";
            CustomNutritionPlanListBlankCollectionViewCell *cell = (CustomNutritionPlanListBlankCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            collectionViewCell = cell;
            
        }
    }
    
    return collectionViewCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    /*if (indexPath.row==0) {
     return;
     }
     if (!isCustom) {
     NSDictionary *dict = nutritionPlanListArray[indexPath.section];
     NSArray *mealDataArray = dict[@"mealData"];
     NSDictionary *mealData = mealDataArray[indexPath.row-1];
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
     controller.mealId = [mealData objectForKey:@"MealId"];
     controller.mealSessionId = [mealData objectForKey:@"MealSessionId"];
     controller.dateString = dateString;
     controller.fromController = @"Meal";    //ah ux
     [self.navigationController pushViewController:controller animated:YES];
     }
     
     }
     }
*/}
#pragma mark -End

#pragma mark - DailyGoodnessDetailsDelegate

-(void)didCheckAnyChangeForDailyGoodness:(BOOL)ischanged{
    isChanged = ischanged;
    [delegate didCheckAnyChangeForCollection:isChanged];
}
#pragma mark - MealSwapDropDown Delegate
-(void)didSwapComplete:(BOOL)isComplete{
    [self getSquadMealPlanWithSettings];
    [delegate swapMealHeaderName:nil active:false];
}
-(void)didMultiSwapCompleteWithDropdown:(NSDictionary *)swapDict{
    isMultipleSwap = true;
    swapMealDict = swapDict;
    _applyMultipleSwapButton.hidden = false;
    NSDictionary *mealDetailDict = swapDict[@"MealDetail"];
    [delegate swapMealHeaderName:mealDetailDict active:true];
    [_collection reloadData];
    
}


#pragma mark - End
#pragma mark-FoodPrepSearch Delegate
- (void)didSwapCompleteWithSearchedMeal:(BOOL)isComplete{
    [self getSquadMealPlanWithSettings];
    [delegate swapMealHeaderName:nil active:false];
    
}
- (void)didMultipleSwap:(NSDictionary *)swapDict{
    isMultipleSwap = true;
    swapMealDict = swapDict;
    _applyMultipleSwapButton.hidden = false;
    
    NSDictionary *mealDetailDict = swapDict[@"MealDetail"];
    if ([Utility isEmptyCheck:mealDetailDict]) {
        mealDetailDict = swapDict;
    }
    [delegate swapMealHeaderName:mealDetailDict active:true];
    [_collection reloadData];
}

#pragma mark - End

@end

