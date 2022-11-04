//
//  FoodPrepShoppingListViewController.m
//  Squad
//
//  Created by aqbsol iPhone on 05/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "FoodPrepShoppingListViewController.h"
#import "FoodPrepShoppingListTableViewCell.h"
#import "FoodPrepMealTableViewCell.h"
#import "ShoppingList.h"
#import "DailyGoodnessDetailViewController.h"

static NSString *SectionHeaderViewIdentifierForShoppingList = @"ShoppingList";
@interface FoodPrepShoppingListViewController (){

    IBOutlet UIButton *headerText;
    IBOutlet UIImageView *arrowImage;
    IBOutlet UITableView *mealTable;
    IBOutlet UITableView *shoppingTable;
    IBOutlet NSLayoutConstraint *mealtableHeightConstraints;
    IBOutlet NSLayoutConstraint *shoppingTableHeightConstraints;
    IBOutlet UIScrollView *mainScroll;
    
    int apiCount;
    UIView *contentView;
    int shoppingPref;
    NSDate *weekDate;
    NSDateFormatter *dailyDateformatter;
    NSArray *mealNameArray;
    NSMutableArray *shoppingListArray;
    NSMutableArray *catagoryarray;
    NSArray *initialShoppingListArray;
    NSMutableArray *saveAll;
    
    BOOL isShowCompleted;
    BOOL isShowUntracked;
    __weak IBOutlet UIButton *showCompletedButton;
    __weak IBOutlet UIButton *showIngredientButton;
    NSString *valueString;
    BOOL value;
    IBOutlet UIView *mealNameView;
    IBOutlet UITableView *nameTable;
    NSArray *nameArray;
    BOOL isChanged;
    BOOL isFirstTime;
}
@end

@implementation FoodPrepShoppingListViewController
@synthesize foodPrepId,delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    apiCount = 0;
    shoppingPref = 0;
    mealTable.hidden = true;
    shoppingTable.hidden = true;
    isShowCompleted = true;
    isShowUntracked = true;
    mealNameView.hidden = true;
    [showCompletedButton setTitle:@"HIDE COMPLETED" forState:UIControlStateNormal];
    [showIngredientButton setTitle:@"HIDE UNTRACKED INGREDIENTS" forState:UIControlStateNormal];
    saveAll = [[NSMutableArray alloc]init];
    catagoryarray = [[NSMutableArray alloc]init];
    mealNameArray = [[NSArray alloc]init];
    shoppingListArray = [[NSMutableArray alloc]init];
    nameArray = [NSArray new];
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ShoppingList" bundle:nil];
    [shoppingTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifierForShoppingList];
    [nameTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifierForShoppingList];
    shoppingTable.estimatedSectionHeaderHeight = 35;
    shoppingTable.sectionHeaderHeight = UITableViewAutomaticDimension;
    mealTable.estimatedSectionHeaderHeight = 0;
    mealTable.sectionHeaderHeight = UITableViewAutomaticDimension;
    nameTable.estimatedRowHeight = 45;
    nameTable.rowHeight = UITableViewAutomaticDimension;
    nameTable.estimatedSectionHeaderHeight = 0;
    nameTable.sectionHeaderHeight = UITableViewAutomaticDimension;
    
    NSDate* today = [NSDate date] ;
    weekDate = [[NSDate alloc]init];
    dailyDateformatter = [[NSDateFormatter alloc]init];
    [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dailyDateformatter stringFromDate:today];
    today = [dailyDateformatter dateFromString:dateString];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:today];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    weekDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    isChanged = true;
    isFirstTime = true;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [mealTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [shoppingTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChnage:) name:@"backButtonPressed" object:nil];

    if (!isChanged) {
        return;
    }
    if (isFirstTime) {
        isFirstTime = false;
        isChanged = false;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self GetSquadUserWeeklyFoodPrepMealList];
        [self GetFoodPerpSquadShoppingList];
    });
}
-(void)viewWillDisappear:(BOOL)animated{
    [mealTable removeObserver:self forKeyPath:@"contentSize"];
    [shoppingTable removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];

}
#pragma mark -IB Action

- (IBAction)foodPrepMealPressed:(UIButton *)sender {
    mealTable.hidden = !mealTable.isHidden;
    if (mealTable.isHidden) {
        [arrowImage setImage:[UIImage imageNamed:@"down_arr.png"]];
    } else {
        [arrowImage setImage:[UIImage imageNamed:@"fp_up_arr.png"]];
        [mealTable reloadData];
    }
}
- (IBAction)mealNamePressed:(UIButton *)sender {
    NSDictionary *dict = mealNameArray[sender.tag];
    DailyGoodnessDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyGoodnessDetail"];
    controller.mealId = dict[@"MealId"];
    controller.mealSessionId = dict[@"MealSessionId"];
    controller.fromController = @"Food Prep";
    controller.Calorie = dict[@"Calories"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)editMealPressed:(UIButton *)sender {
    FoodPrepAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrepAddEdit"];
    controller.isEdit = YES;
    controller.mealNameArray = mealNameArray;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)checkUncheckButtonPressed:(UIButton *)sender {

    NSString *sectionIndexString = [@"" stringByAppendingFormat:@"%@",sender.accessibilityHint];
    NSArray *SectionDetails = [sectionIndexString componentsSeparatedByString: @"-"];
    NSString *sectionString = [SectionDetails objectAtIndex:0];
    NSString *buttonIndexString =[SectionDetails objectAtIndex:1];
    int sectionIndex = [sectionString intValue];
    NSDictionary *dict =shoppingListArray[sectionIndex];
    NSArray *shoppingData = [dict objectForKey:@"shoppingData"];
    
    if(!isShowCompleted){
        shoppingData = [shoppingData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPurchased == %@)", [NSNumber numberWithBool:isShowCompleted]]];
    }
    
    int valueIndex = (int)sender.tag;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:sectionIndex];
        FoodPrepShoppingListTableViewCell *cell = (FoodPrepShoppingListTableViewCell *)[self->shoppingTable cellForRowAtIndexPath:indexPath];
        
        
        if([sender isEqual:cell.purchasedButton] ){
            cell.purchasedButton.selected = !cell.purchasedButton.isSelected;
            
            if(cell.purchasedButton.isSelected){
                cell.ingredientName.alpha = 0.3;
                cell.quantityLabel.alpha = 0.3;
            }else{
                cell.ingredientName.alpha = 1.0;
                cell.quantityLabel.alpha = 1.0;
            }
            
        }
//        else if([sender isEqual:cell.alreadyhaveItButton] ){
//            cell.alreadyhaveItButton.selected = !cell.alreadyhaveItButton.isSelected;
//        }
        
        NSDictionary *updateDict = [[shoppingData objectAtIndex:valueIndex]mutableCopy];
        if ([buttonIndexString isEqualToString:@"1"]) {
            self->valueString =@"P";
            if (cell.purchasedButton.selected) {
                self->value =true;
            }else{
                self->value=false;
            }
            
        }
//        else if ([buttonIndexString isEqualToString:@"2"]) {
//            valueString=@"A";
//            if (cell.alreadyhaveItButton.selected) {
//                value =true;
//            }else{
//                value=false;
//            }
//        }
        NSArray *filteredarray = [self->saveAll filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(ShoppingId == %@) AND (PurOrAlr == %@)", [updateDict objectForKey:@"Id"],self->valueString]];
        if (filteredarray.count >0) {
            [self->saveAll removeObject:filteredarray[0]];
        }else{
            NSMutableDictionary *mainDict = [[NSMutableDictionary alloc]init];
            [mainDict setObject:[updateDict objectForKey:@"Id"] forKey:@"ShoppingId"];
            [mainDict setObject:self->valueString forKey:@"PurOrAlr"];
            [mainDict setObject:[NSNumber numberWithBool:self->value] forKey:@"PurOrAlrValue"];
//            [mainDict setValue:[NSNumber numberWithBool:cell.purchasedButton.isSelected] forKey:@"isSelected"];
            [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
            [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
            [self->saveAll addObject:mainDict];
        }
        
        [self webserviceCall_UpdateSquadShoppingList];
    });
    
//    [self webserviceCall_UpdateSquadShopping:valueString with:value with:updateDict];
}
- (IBAction)hideShowCompletedPressed:(UIButton *)sender {
    isShowCompleted = !isShowCompleted;
    if(isShowCompleted){
        [sender setTitle:@"HIDE COMPLETED" forState:UIControlStateNormal];
        [showCompletedButton setTitle:@"HIDE COMPLETED" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"SHOW COMPLETED" forState:UIControlStateNormal];
        [showCompletedButton setTitle:@"SHOW COMPLETED" forState:UIControlStateNormal];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self->shoppingTable reloadData];
    });
}
- (IBAction)hideShowUntrackedPressed:(UIButton *)sender {
    isShowUntracked = !isShowUntracked;
    if(isShowUntracked){
        [sender setTitle:@"HIDE UNTRACKED INGREDIENTS" forState:UIControlStateNormal];
        [showIngredientButton setTitle:@"HIDE UNTRACKED INGREDIENTS" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"SHOW UNTRACKED INGREDIENTS" forState:UIControlStateNormal];
        [showIngredientButton setTitle:@"SHOW UNTRACKED INGREDIENTS" forState:UIControlStateNormal];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->shoppingTable reloadData];
    });
}
-(IBAction)ingredientButtonPressed:(UIButton *)sender{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:foodPrepId forKey:@"FoodPerpId"];
        int section = [sender.accessibilityHint intValue];
        NSDictionary *dict = [shoppingListArray objectAtIndex:section];
        NSArray *shoppingDataArray = [dict objectForKey:@"shoppingData"];
        dict = [shoppingDataArray objectAtIndex:sender.tag];
        [mainDict setObject:[dict objectForKey:@"IngredientId"] forKey:@"IngredientId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetFoodPrepIngredientMeal" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:responseDict[@"GetSquadUserWeeklyFoodPrepList"]]) {
                                                                             self->nameArray = responseDict[@"GetSquadUserWeeklyFoodPrepList"];
                                                                             self->mealNameView.hidden = false;
                                                                             [self->nameTable reloadData];
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
-(IBAction)crossButtonPressed:(UIButton *)sender{
    mealNameView.hidden = true;
}
#pragma mark -End
#pragma mark -Private Methods
-(void)GetSquadUserWeeklyFoodPrepMealList{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;

        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:foodPrepId forKey:@"FoodPerpId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];

        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadUserWeeklyFoodPrep" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         if(![Utility isEmptyCheck:responseDict[@"GetSquadUserWeeklyFoodPrepList"]]){
                                                                             
                                                                             [self->headerText setTitle:[responseDict[@"GetSquadUserWeeklyFoodPrepList"] objectAtIndex:0][@"FoodPrepName"] forState:UIControlStateNormal];
                                                                             self->mealNameArray = responseDict[@"GetSquadUserWeeklyFoodPrepList"];
                                                                             if (self->apiCount == 0) {
                                                                                 self->mealTable.hidden = false;
                                                                                 self->shoppingTable.hidden = false;
                                                                                 [self->mealTable reloadData];
                                                                                 [self->shoppingTable reloadData];
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
-(void)GetFoodPerpSquadShoppingList{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        /*
         */
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:shoppingPref] forKey:@"ShoppingPref"];
        [mainDict setObject:[dailyDateformatter stringFromDate:weekDate] forKey:@"WeekStartDate"];
        [mainDict setObject:foodPrepId forKey:@"FoodPrepId"];
        [mainDict setObject:[defaults objectForKey:@"ApplyRounding"] forKey:@"ApplyRounding"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetFoodPerpSquadShoppingList" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         //shoppingListArray =[[NSMutableArray alloc]init];
                                                                         if (apiCount == 0) {
                                                                             mealTable.hidden = false;
                                                                             shoppingTable.hidden = false;
//                                                                             [mealTable reloadData];
//                                                                             [shoppingTable reloadData];
                                                                         }
                                                                         [self prepareMyShoppingListData:responseDict];
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
-(void)webserviceCall_UpdateSquadShoppingList{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
//        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
//
//        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
//        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
//        [mainDict setObject:saveAll forKey:@"ShoppingData"];
//        [mainDict setObject:[NSNumber numberWithBool:isCustom] forKey:@"IsCustom"];
        
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:[saveAll objectAtIndex:0] options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateFoodPrepShopping" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         saveAll = [[NSMutableArray alloc]init];
                                                                         [self GetFoodPerpSquadShoppingList];
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
-(void)prepareMyShoppingListData:(NSDictionary *)responseDict{
    
    if(!shoppingListArray){
        shoppingListArray =[[NSMutableArray alloc]init];
    }else{
        [shoppingListArray removeAllObjects];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
//    NSArray *catagoryTotalArray =[responseDict objectForKey:@"ShoppingIngredient"];
//    catagoryarray = [[NSMutableArray alloc]init];
//    if (![Utility isEmptyCheck:responseDict[@"ShoppingIngredient"]]) {
//        for (int i=0; i<catagoryTotalArray.count; i++) {
//            NSDictionary *dict = [catagoryTotalArray objectAtIndex:i];
//            [catagoryarray addObject:[dict objectForKey:@"IngredientCategory"]];// no work
//        }
//    }
    NSArray *rawShoppingDataArray = responseDict[@"ShoppingList"];
    if (![Utility isEmptyCheck:rawShoppingDataArray] && rawShoppingDataArray.count > 0) {
        NSArray *uniqueCategory = [rawShoppingDataArray valueForKeyPath:@"@distinctUnionOfObjects.IngredientCategory"];
        NSLog(@"Category-%@",uniqueCategory);
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES selector:@selector(caseInsensitiveCompare:)];
        
        uniqueCategory = [uniqueCategory sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        for (NSString *category in uniqueCategory) {
            
            NSArray *filteredarray = [rawShoppingDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IngredientCategory == %@)", category]];
            
            //                    NSArray *filterPersonalTrueArray = [filteredarray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPersonal == %@)", [NSNumber numberWithBool:1]]];
            
            NSArray *filterPersonalFalseArray = [filteredarray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPersonal == %@)", [NSNumber numberWithBool:0]]];
            
            //                    if (filterPersonalTrueArray.count > 0) {
            //                        NSArray *filteredNotNoMeasureArray = [filterPersonalTrueArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsNoMeasure == %@)", [NSNumber numberWithBool:0]]];
            //                        NSArray *filteredNoMeasureArray = [filterPersonalTrueArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsNoMeasure == %@)", [NSNumber numberWithBool:1]]];
            //                        if (filteredNotNoMeasureArray.count > 0) {
            //                            [otherListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNotNoMeasureArray,@"shoppingData",category,@"category",nil]];
            //                        }else{
            //                            [otherListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNotNoMeasureArray,@"shoppingData",category,@"category",nil]];
            //                        }
            //
            //                        if (filteredNoMeasureArray.count > 0) {
            //                            [otherListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNoMeasureArray,@"shoppingData",@"No Measure",@"category",nil]];
            //                        }
            //
            //                    }
            
            if (filterPersonalFalseArray.count > 0) {
                NSArray *filteredNotNoMeasureArray = [filterPersonalFalseArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsNoMeasure == %@)", [NSNumber numberWithBool:0]]];
                NSArray *filteredNoMeasureArray = [filterPersonalFalseArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsNoMeasure == %@)", [NSNumber numberWithBool:1]]];
                if (filteredNotNoMeasureArray.count > 0) {
                    [shoppingListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNotNoMeasureArray,@"shoppingData",category,@"category", nil]];
                }else{
                    [shoppingListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNotNoMeasureArray,@"shoppingData",category,@"category", nil]];
                }
                
                if (filteredNoMeasureArray.count > 0) {
                    [shoppingListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNoMeasureArray,@"shoppingData",@"No Measure",@"category", nil]];
                }
                
            }
        }
        
        initialShoppingListArray = shoppingListArray;
        
    }else{
        [Utility msg:@"Shopping ingredients not found" title:@"Warning!" controller:self haveToPop:YES];
        return;
    }
    
    [mealTable reloadData];
    [shoppingTable reloadData];
    
}
- (NSString *)getQuantity:(CGFloat) quantity {  //ah 25.5
    NSString *showquantity = @"";
    if (quantity < 1)
    {
        if(quantity <= 0){
            showquantity = @"0";
        }else if (quantity <= 0.25){
            showquantity = @"¼";
        }else if (quantity > 0.25 && quantity <= 0.50){
            showquantity = @"½";
        }else if (quantity > 0.50 && quantity <= 0.75){
            showquantity = @"¾";
        }else{
            showquantity = @"1";
        }
    }else{
        //showquantity = [NSString stringWithFormat:@"%d",(int)roundf(quantity)];
        showquantity = [NSString stringWithFormat:@"%g",quantity];
    }
    return showquantity;
}
-(void)checkForChnage:(NSNotification*)notifictaion{
    if ([notifictaion.name isEqualToString:@"backButtonPressed"]) {
        if ([delegate respondsToSelector:@selector(didCheckAnyChange:)]) {
            [delegate didCheckAnyChange:isChanged];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
}
#pragma mark -End
#pragma mark -TableView Delegate & DataSource
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == mealTable) {
        mealtableHeightConstraints.constant=mealTable.contentSize.height;
    }else if (object == shoppingTable){
        shoppingTableHeightConstraints.constant=shoppingTable.contentSize.height;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:shoppingTable]) {
        
        if(initialShoppingListArray && !isShowUntracked){
            
            NSString *category = @"No Measure";
            NSPredicate *filter = [NSPredicate predicateWithFormat:[@"" stringByAppendingFormat:@"(category != '%@')", category]];
            NSArray *filteredArray = [initialShoppingListArray filteredArrayUsingPredicate:filter];
            shoppingListArray = [filteredArray mutableCopy];
            
        }else{
            shoppingListArray = [initialShoppingListArray mutableCopy];
        }
        
        return shoppingListArray.count;
        
    } else  {
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView isEqual:shoppingTable]) {
        NSDictionary *tempDict = [shoppingListArray objectAtIndex:section];
        NSArray *tempArray = [tempDict objectForKey:@"shoppingData"];
        
        if(!isShowCompleted){
            
            tempArray = [tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPurchased == %@)", [NSNumber numberWithBool:isShowCompleted]]];
        }
        
        return tempArray.count ;
    } else if(tableView == mealTable) {
        return mealNameArray.count;
    }else{
        return nameArray.count;
    }
    
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if ([tableView isEqual:shoppingTable]) {
//        return UITableViewAutomaticDimension;
//    } else {
//        return 0;
//    }
//}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
//    if ([tableView isEqual:shoppingTable]) {
//        return 35;
//    } else {
//        return 0;
//    }
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *tempDict =[[NSDictionary alloc]init];
    ShoppingList *sectionHeaderView;
    if (tableView == shoppingTable) {
        tempDict = [shoppingListArray objectAtIndex:section];
        sectionHeaderView = ( ShoppingList *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifierForShoppingList];
    }else{
        return nil;
    }
    
    sectionHeaderView.headerLabel.text =[[tempDict objectForKey:@"category"] uppercaseString];
    if ([[tempDict objectForKey:@"category"] isEqualToString:@"No Measure"]) {
        sectionHeaderView.headerLabel.text = @"UNMEASURED";
        sectionHeaderView.headerBg.hidden = true;
        sectionHeaderView.bottomLineView.hidden = false;
        //sectionHeaderView.bottomLineView.backgroundColor = [UIColor lightGrayColor];
        sectionHeaderView.headerLabel.textColor = [UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1];
    }else{
        //sectionHeaderView.bottomLineView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1];
        sectionHeaderView.headerBg.hidden = false;
        sectionHeaderView.bottomLineView.hidden = true;
        sectionHeaderView.headerLabel.textColor = [UIColor whiteColor];
    }
    return sectionHeaderView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell;
    if (tableView == mealTable) {
        FoodPrepMealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodPrepMealTableViewCell"];
        NSString *name = [NSString stringWithFormat:@"%@ - X %@", mealNameArray[indexPath.row][@"MealName"],mealNameArray[indexPath.row][@"Quantity"]];
        [cell.mealNameButton setTitle:name forState:UIControlStateNormal];
        if (indexPath.row == mealNameArray.count-1) {
            cell.editMealButton.hidden = false;
        } else {
            cell.editMealButton.hidden = true;
        }
        cell.mealNameButton.tag = indexPath.row;
        
        tableCell = cell;
    } else if(tableView == shoppingTable){
        FoodPrepShoppingListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodPrepShoppingListTableViewCell"];
        // Configure the cell...
        if (cell == nil) {
            cell = [[FoodPrepShoppingListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FoodPrepShoppingListTableViewCell"];
        }
        NSMutableDictionary *dict = [shoppingListArray objectAtIndex:indexPath.section];
        
        if (![Utility isEmptyCheck:dict]) {
            
            NSMutableArray *shoppingDataArray=[[dict objectForKey:@"shoppingData"]mutableCopy];
            if(!isShowCompleted){
                
                shoppingDataArray = [[shoppingDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPurchased == %@)", [NSNumber numberWithBool:isShowCompleted]]] mutableCopy];
            }
            
            
            
            NSMutableDictionary *shoppingDataDict = [[shoppingDataArray objectAtIndex:indexPath.row]mutableCopy];
            
            // NSString *conversionNumString = [@"" stringByAppendingFormat:@"%@",[shoppingDataDict objectForKey:@"ConversionNum"]];
            NSString *conversionUnitString = [shoppingDataDict objectForKey:@"ConversionUnit"];
            NSString *unitMetricString = [shoppingDataDict objectForKey:@"UnitMetric"];
            
            
            float conversionNum = [[shoppingDataDict objectForKey:@"ConversionNum"] floatValue];
            
            //NSLog(@"%@",[defaults objectForKey:@"UnitPreference"]);
            
            NSString *setConditional=@"";
            
            if ([[shoppingDataDict objectForKey:@"IsNoMeasure"]boolValue]) {
                setConditional = @"*";
                cell.ingredientName.text=[shoppingDataDict objectForKey:@"Ingredient"];
                cell.quantityLabel.text= @"";
            }else{
                cell.ingredientName.text=[shoppingDataDict objectForKey:@"Ingredient"];
                int noOfServe = 1;//[selectedServe[@"key"] intValue];
                float quantityMetric = [[shoppingDataDict objectForKey:@"QuantityMetric"] floatValue]*noOfServe;
                float quantityImperial = [[shoppingDataDict objectForKey:@"QuantityImperial"] floatValue]*noOfServe;
                if ( conversionNum == 0 || [conversionUnitString isEqualToString:unitMetricString] ){
                    if ([[defaults objectForKey:@"UnitPreference"] intValue] == 0) {
                        NSString *detailString =@"";
                        
                        //                        detailString =[@"" stringByAppendingFormat:@"%g %@",quantityMetric,[shoppingDataDict objectForKey:@"UnitMetric"]];
                        detailString =[@"" stringByAppendingFormat:@"%@ %@",[self getQuantity:quantityMetric],[shoppingDataDict objectForKey:@"UnitMetric"]];
                        if (![[shoppingDataDict objectForKey:@"UnitImperial"] isEqualToString:[shoppingDataDict objectForKey:@"UnitMetric"]]) {
                            detailString = [detailString stringByAppendingFormat:@" (%@ %@)",[@"" stringByAppendingFormat:@"%.2f",quantityImperial],[shoppingDataDict objectForKey:@"UnitImperial"]];
                        }
                        if (quantityMetric>0) {
                            cell.quantityLabel.text = detailString;
                        } else {
                            cell.quantityLabel.text = @"as needed";
                        }
                        //                        cell.quantityLabel.text = detailString;
                        
                    }else if([[defaults objectForKey:@"UnitPreference"] intValue] == 1){
                        //                        if ([shoppingDataDict[@"ConvertedQuantity"]floatValue]>0) {
                        if (quantityMetric>0) {
                            cell.quantityLabel.text=[@"" stringByAppendingFormat:@"%@ %@",[@"" stringByAppendingFormat:@"%@",[self getQuantity:quantityMetric]],[shoppingDataDict objectForKey:@"UnitMetric"]];
                        } else {
                            cell.quantityLabel.text = @"as needed";
                        }
                        //                        cell.quantityLabel.text=[@"" stringByAppendingFormat:@"%@ %@",[@"" stringByAppendingFormat:@"%g",quantityMetric],[shoppingDataDict objectForKey:@"UnitMetric"]];
                        
                        
                    }else{
                        if (quantityImperial>0) {
                            cell.quantityLabel.text=[@"" stringByAppendingFormat:@"%@ %@",[@"" stringByAppendingFormat:@"%@",[self getQuantity:quantityImperial]],[shoppingDataDict objectForKey:@"UnitImperial"]];
                        } else {
                            cell.quantityLabel.text = @"as needed";
                        }
                        //                        cell.quantityLabel.text=[@"" stringByAppendingFormat:@"%@ %@",[@"" stringByAppendingFormat:@"%.2f",quantityImperial],[shoppingDataDict objectForKey:@"UnitImperial"]];
                    }
                }else{
                    if ([[defaults objectForKey:@"UnitPreference"] intValue] == 0) {
                        NSString *detailString =@"";
                        //                        float conversionNum = [[shoppingDataDict objectForKey:@"ConversionNum"] floatValue];
                        //                        CGFloat cal = ((quantityMetric *conversionNum)/100);
                        //shabbir 03/04/18
                        detailString= [@"" stringByAppendingFormat:@"%@",[self getQuantity:[shoppingDataDict[@"ConvertedQuantity"]floatValue]*noOfServe]] ;//cal]];
                        
                        detailString = [detailString stringByAppendingFormat:@" %@ ( %@ %@ )",[shoppingDataDict objectForKey:@"ConversionUnit"],[@"" stringByAppendingFormat:@"%g",quantityMetric],[shoppingDataDict objectForKey:@"UnitMetric"]];
                        
                        if (![[shoppingDataDict objectForKey:@"UnitImperial"] isEqualToString:[shoppingDataDict objectForKey:@"UnitMetric"]]) {
                            detailString = [detailString stringByAppendingFormat:@" or (%@ %@)",[@"" stringByAppendingFormat:@"%.2f",quantityImperial],[shoppingDataDict objectForKey:@"UnitImperial"]];
                        }
                        if ([shoppingDataDict[@"ConvertedQuantity"]floatValue]>0) {
                            cell.quantityLabel.text = detailString;
                        } else {
                            cell.quantityLabel.text = @"as needed";
                        }
                        //                        cell.quantityLabel.text = detailString;
                        
                    }else if(([[defaults objectForKey:@"UnitPreference"] intValue] == 1)){
                        NSString *detailString =@"";
                        //                        float conversionNum = [[shoppingDataDict objectForKey:@"ConversionNum"] floatValue];
                        
                        //                        CGFloat cal = ((quantityMetric *conversionNum)/100);
                        
                        detailString= [@"" stringByAppendingFormat:@"%@",[self getQuantity:[shoppingDataDict[@"ConvertedQuantity"]floatValue]*noOfServe]];
                        
                        detailString = [detailString stringByAppendingFormat:@" %@ ( %@ %@ )",[shoppingDataDict objectForKey:@"ConversionUnit"],[@"" stringByAppendingFormat:@"%g",quantityMetric],[shoppingDataDict objectForKey:@"UnitMetric"]];
                        
                        if ([shoppingDataDict[@"ConvertedQuantity"]floatValue]>0) {
                            cell.quantityLabel.text = detailString;
                        } else {
                            cell.quantityLabel.text = @"as needed";
                        }
                        //                        cell.quantityLabel.text = detailString;
                        
                    }else{
                        NSString *detailString =@"";
                        //                        float conversionNum = [[shoppingDataDict objectForKey:@"ConversionNum"] floatValue];
                        //                        CGFloat cal = ((quantityMetric *conversionNum)/100);
                        detailString= [@"" stringByAppendingFormat:@"%@",[self getQuantity:[shoppingDataDict[@"ConvertedQuantity"]floatValue]*noOfServe]];
                        
                        detailString = [detailString stringByAppendingFormat:@" %@ ( %@ %@ )",[shoppingDataDict objectForKey:@"ConversionUnit"],[@"" stringByAppendingFormat:@"%.2f",quantityImperial],[shoppingDataDict objectForKey:@"UnitImperial"]];
                        detailString = [detailString stringByAppendingString:setConditional];
                        if ([shoppingDataDict[@"ConvertedQuantity"]floatValue]>0) {
                            cell.quantityLabel.text = detailString;
                        } else {
                            cell.quantityLabel.text = @"as needed";
                        }
                        //                        cell.quantityLabel.text = detailString;
                    }
                }
            }
            
            NSArray *filteredarray = [saveAll filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(ShoppingId == %@)", [shoppingDataDict objectForKey:@"Id"]]];
            
            
            if ([[shoppingDataDict objectForKey:@"IsPurchased"]boolValue] && filteredarray.count == 0) {
                cell.purchasedButton.selected=true;
                cell.ingredientName.alpha = 0.3;
                cell.quantityLabel.alpha = 0.3;
                
            }else if(filteredarray.count>0){
                NSDictionary *filterDict = filteredarray[0];
                cell.purchasedButton.selected=[filterDict[@"isSelected"] boolValue];
                
                if(cell.purchasedButton.isSelected){
                    cell.ingredientName.alpha = 0.3;
                    cell.quantityLabel.alpha = 0.3;
                }else{
                    cell.ingredientName.alpha = 1.0;
                    cell.quantityLabel.alpha = 1.0;
                }
                
            }else{
                cell.purchasedButton.selected=false;
                cell.ingredientName.alpha = 1.0;
                cell.quantityLabel.alpha = 1.0;
            }
//            if ([[shoppingDataDict objectForKey:@"IsAlreadyHave"]boolValue]) {
//                cell.alreadyhaveItButton.selected=true;
//            }
//            else{
//                cell.alreadyhaveItButton.selected=false;
//            }
            
            if(indexPath.row == shoppingDataArray.count-1){
                cell.showCompletedButton.hidden = false;
                cell.showIngredientButton.hidden = false;
//                cell.separatorView.hidden=true;
            }else{
                cell.showCompletedButton.hidden = true;
                cell.showIngredientButton.hidden = true;
//                cell.separatorView.hidden=false;
            }// AY 12032018
            
            if(isShowCompleted){
                [cell.showCompletedButton setTitle:@"HIDE COMPLETED" forState:UIControlStateNormal];
            }else{
                [cell.showCompletedButton setTitle:@"SHOW COMPLETED" forState:UIControlStateNormal];
            }
            
            if(isShowUntracked){
                [cell.showIngredientButton setTitle:@"HIDE UNTRACKED INGREDIENTS" forState:UIControlStateNormal];
            }else{
                [cell.showIngredientButton setTitle:@"SHOW UNTRACKED INGREDIENTS" forState:UIControlStateNormal];
            }
            
            
        }
        cell.purchasedButton.tag=indexPath.row;
        cell.purchasedButton.accessibilityHint=[@"" stringByAppendingFormat:@"%ld-%@",(long)indexPath.section,@"1"];
        cell.ingredientButton.tag = indexPath.row;
        cell.ingredientButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
//        cell.alreadyhaveItButton.tag=indexPath.row;
//        cell.alreadyhaveItButton.accessibilityHint=[@"" stringByAppendingFormat:@"%ld-%@",(long)indexPath.section,@"2"];
        
        tableCell = cell;
    }else{
        FoodPrepShoppingListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodPrepShoppingListTableViewCell"];
        // Configure the cell...
        if (cell == nil) {
            cell = [[FoodPrepShoppingListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FoodPrepShoppingListTableViewCell"];
        }
        NSMutableDictionary *dict = [nameArray objectAtIndex:indexPath.section];
        cell.ingredientName.text = dict[@"MealName"];
        
        tableCell = cell;
    }
    return tableCell;
}
#pragma mark -End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - FoodPrepAddEditViewDelegate

-(void)didCheckAnyChange:(BOOL)ischanged{
    isChanged = ischanged;
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
