//
//  NourishViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 26/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "NourishViewController.h"
#import "DailyGoodnessViewController.h"
#import "CustomNutritionPlanListViewController.h"
#import "Utility.h"
#import "DietaryPreferenceViewController.h"
#import "MealFrequencyViewController.h"
#import "MealVarietyViewController.h"
#import "MealPlanViewController.h"
#import "RecipeListViewController.h"
#import "IngredientListViewController.h"
#import "ShoppingListViewController.h"
#import "BlankListViewController.h"
#import "NutritionSettingHomeViewController.h"
#import "ChooseGoalViewController.h"
#import "MealMatchViewController.h"
#import "FoodPrepViewController.h"
#import "AddRecipeViewController.h"
#import "SavedNutritionPlanViewController.h"

@interface NourishViewController (){
    UIView *contentView;
    NSArray *unitPreferenceArray;
    int stepnumber;
    NSDictionary *currprogram;
    int apiCount;
    //Chayan
    IBOutlet UIButton *helpButton;
    IBOutletCollection(UIButton) NSArray *actionButtons;
    IBOutlet UIView *headerContainerView;
    IBOutlet UIView *nutritionPlan;
    IBOutlet UIView *shoppingList;
    IBOutlet UIView *calorieCounter;
    IBOutlet UIView *recipeList;
    IBOutlet UIView *ingredientList;
    IBOutlet UIView *dailyGoodness;
    IBOutlet UIView *todoList;
    IBOutlet UIView *shoppingDetailsView;
    IBOutlet UIView *myCustomshoppingListView;
    IBOutlet UIButton *editButton;
    IBOutlet UIButton *viewButton;
    IBOutlet UIButton *myWeeklyShoppingListButton;
    //shabbir
    IBOutlet UIView *recipeView;
    IBOutlet UIButton *recipeButton;
    IBOutlet UIButton *addRecipeButton;
    __weak IBOutlet UIView *savedNutritionPlan;
    __weak IBOutlet UIView *mealPrep;
    
    __weak IBOutlet UIView *blankView;
    BOOL isFirstLoad;
}

@end
//ah ux(no storyboard ??)
@implementation NourishViewController
@synthesize isFromNotification,fromTodayPage;
- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstLoad = YES;
    if (fromTodayPage) {
        blankView.hidden = false;
    }else{
        blankView.hidden = true;
    }
    blankView.hidden = false;
    if([Utility isSubscribedUser] || [defaults boolForKey:@"IsNonSubscribedUser"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self webSerViceCall_GetSquadCurrentProgram];
            
        });
    }
}

//chayan
-(void) viewDidAppear:(BOOL)animated {  //ah ux
    [super viewDidAppear:YES];
    
    
//    if(!_redirectBackToTodayPage){
//        if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeNourish"] boolValue]) {
//            [self animateHelp];
//        }
//        //    [self showInstructionOverlays];
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"InstructionOverlays"]]){
//            NSMutableArray *insArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"InstructionOverlays"]];
//            if (![insArray containsObject:@"Nourish"]) {
//                //[self helpButtonPressed:helpButton];
//                [self showInstructionOverlays];
//                [insArray addObject:@"Nourish"];
//                [defaults setObject:insArray forKey:@"InstructionOverlays"];
//            }
//        }else {
//            //[self helpButtonPressed:helpButton];
//            [self showInstructionOverlays];
//            NSMutableArray *insArray = [[NSMutableArray alloc] init];
//            [insArray addObject:@"Nourish"];
//            [defaults setObject:insArray forKey:@"InstructionOverlays"];
//        }
//    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if(!isFirstLoad && _redirectBackToTodayPage){
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    shoppingDetailsView.hidden = true;
    myCustomshoppingListView.layer.borderColor = [Utility colorWithHexString:@"b7b7b7"].CGColor;
    myCustomshoppingListView.layer.borderWidth = 2.0f;
    myCustomshoppingListView.layer.cornerRadius = 10;
    
    myWeeklyShoppingListButton.layer.borderColor = [Utility colorWithHexString:@"b7b7b7"].CGColor;
    myWeeklyShoppingListButton.layer.borderWidth = 2.0f;
    myWeeklyShoppingListButton.layer.cornerRadius = 10;
    
    recipeView.hidden = true;
    recipeButton.layer.borderColor = [Utility colorWithHexString:@"b7b7b7"].CGColor;
    recipeButton.layer.borderWidth = 2.0f;
    recipeButton.layer.cornerRadius = 10;
    addRecipeButton.layer.borderColor = [Utility colorWithHexString:@"b7b7b7"].CGColor;
    addRecipeButton.layer.borderWidth = 2.0f;
    addRecipeButton.layer.cornerRadius = 10;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    blankView.hidden = true;
    fromTodayPage = false;
    isFirstLoad = NO;
}
#pragma mark -IBAction
-(void)checkNutritionStep:(int)tag{
    //        if (stepnumber == 0 || stepnumber == 6) {
    //            CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
    //            controller.isComplete =false;
    //            [self.navigationController pushViewController:controller animated:YES];
    
    if ((stepnumber == -1 || stepnumber == 1) && [Utility isEmptyCheck:currprogram] )   {//add1
        ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
        controller.isNutritionSettings=true;
        [self.navigationController pushViewController:controller animated:YES];
    }else if((stepnumber == -1 && ![Utility isEmptyCheck:currprogram])){//add1
        DietaryPreferenceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DietaryPreferenceView"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (stepnumber == 1 || stepnumber == 2) {
        DietaryPreferenceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DietaryPreferenceView"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (stepnumber == 3) {
        MealFrequencyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealFrequencyView"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (stepnumber == 4){
        MealVarietyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealVarietyView"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (stepnumber == 5){
        MealPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealPlanView"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        if (tag == 1) {
            CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
            controller.isComplete =false;
            controller.stepnumber = stepnumber;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(tag == 2){
            ShoppingListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingListView"];
            [self.navigationController pushViewController:controller animated:YES];
        }else if(tag == 3){
            CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
            controller.isFromShoppingList = YES;
            //    controller.weekDate = weekdate;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(tag == 4){
            MealMatchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealMatchView"];
            [self.navigationController pushViewController:controller animated:YES];
        }else if(tag == 5){
            ShoppingListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingListView"];
            controller.isCustom = true;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }
}
//chayan
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)notificationButtonTapped:(id)sender {
    
}

//chayan : questionHelpButtonPressed
- (IBAction)helpButtonPressed:(id)sender {
    NSString *urlString=@"https://player.vimeo.com/external/220933018.m3u8?s=ec878c58bd2e8675af4994335feb49789319b5b6";
    if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeNourish"] boolValue]) {
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
        NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeNourish"];
        [defaults setObject:dict forKey:@"firstTimeHelpDict"];
    }
    else{
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
    }
}



-(IBAction)itemButtonPressed:(UIButton *)sender{
    if (sender.tag == 0) {
        DailyGoodnessViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyGoodness"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (sender.tag == 1) {
        [self checkNutritionStep:1];
    }else if (sender.tag == 2) {//add27
        [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            if (shoppingDetailsView.hidden) {
                shoppingDetailsView.hidden = false;
                recipeView.hidden = true;
            }else{
                shoppingDetailsView.hidden = true;
            }
        } completion:^(BOOL finished) {

        }];

    }else if (sender.tag == 3) {//add27
        BlankListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BlankList"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (sender.tag == 4) {
        //        RecipeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RecipeList"];
        //        [self.navigationController pushViewController:controller animated:YES];
        [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            if (recipeView.isHidden) {
                recipeView.hidden = false;
                shoppingDetailsView.hidden = true;
            }else{
                recipeView.hidden = true;
            }
        } completion:^(BOOL finished) {
            
        }];
    }else if (sender.tag == 5) {
        IngredientListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IngredientList"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (sender.tag == 6){
        [self checkNutritionStep:4];
//        MealMatchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealMatchView"];
//        [self.navigationController pushViewController:controller animated:YES];
    }else if (sender.tag == 7){
        //05/04/18
        //        [Utility msg:@"Coming in April 2018" title:@"Alert" controller:self haveToPop:NO];
        if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
            [Utility showTrailLoginAlert:self ofType:self];
            return;
        }
        FoodPrepViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrep"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (sender.tag == 8){
        //26/06/18
        if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
            [Utility showTrailLoginAlert:self ofType:self];
            return;
        }
        SavedNutritionPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SavedNutritionPlan"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(IBAction)recipeButtonPressed:(UIButton *)sender{
    if (sender.tag == 0) {
        RecipeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RecipeList"];
        [self.navigationController pushViewController:controller animated:NO];
    } else if (sender.tag == 1) {
        AddRecipeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddRecipeView"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(IBAction)customShoppingListViewButtonTapped:(id)sender{
    //26/03/18 shabbir
    //    ShoppingListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingListView"];
    //    controller.isCustom = YES;
    //    //controller.weekdate = weekDate;
    //    [self.navigationController pushViewController:controller animated:YES];
    [self checkNutritionStep:5];
}
-(IBAction)customShoppingListEditButtonTapped:(id)sender{
    [self checkNutritionStep:3];
}
-(IBAction)myWeeklyShoppingListButtonTapped:(id)sender{
    [self checkNutritionStep:2];
}
#pragma mark - End
-(void)webSerViceCall_GetSquadCurrentProgram{
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadCurrentProgram" append:@""forAction:@"POST"];
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
                                                                         currprogram=[responseDict objectForKey:@"SquadProgram"];
                                                                     }
                                                                     else{
                                                                         //                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         //return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                                 
                                                                 [self webSerViceCall_SquadNutritionSettingStep];
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}


-(void)webSerViceCall_SquadNutritionSettingStep{
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
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadNutritionSettingStep" append:@""forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         self->stepnumber=[[responseDict objectForKey:@"StepNumber"]intValue];
                                                                         
                                                                         //ah ux
                                                                         if (self.isCustom) {
                                                                             self.isCustom=false;
                                                                             [self checkNutritionStep:3];
                                                                         }
                                                                         if (self->isFromNotification) {
                                                                             self->isFromNotification=false;
                                                                             [self checkNutritionStep:1];
                                                                         }
                                                                         
                                                                         if (self->_isFromMealMatchNotification) {
                                                                             self->_isFromMealMatchNotification=false;
                                                                             [self checkNutritionStep:4];
                                                                         }//AY 21032018
                                                                         
                                                                         if (self->_isFromShoppingListNotification) {
                                                                             self->_isFromShoppingListNotification=false;
                                                                             [self checkNutritionStep:5];
                                                                         }//AY 21032018
                                                                         if (self->_isWeeklyShopping) {
                                                                             self->_isWeeklyShopping = false;
                                                                             [self checkNutritionStep:2];
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


#pragma mark -End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Method

//chayan
-(void) animateHelp {   //ah ux
    [UIView animateWithDuration:1.5 animations:^{
        helpButton.alpha = 0.2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            helpButton.alpha = 1;
        } completion:^(BOOL finished) {
            UIViewController *vc = [self.navigationController visibleViewController];
            if (vc == self)
                [self animateHelp];
        }];
    }];
}
//- (void)showInstructionOverlays {
//    NSMutableArray *overlayViews = [[NSMutableArray alloc] init];
//    NSArray *messageArray = @[
//                              @"Click here for tools and tips to get the most out of the NOURISH section.",
//                              @"Create your PERSONALISED NUTRITION PLAN",
//                              @"The shopping list that accompanies your plan",
//                              @"Calorie Counter",
//                              @"Weekly Meal prep",
//                              @"View Squad recipes and create or view your own recipes",
//                              @"Add an ingredient that isn't in the Squad clean foods list",
//                              @"See our Squad meal of the day",
//                              @"A TO DO list you can add anything to"
//                              ];
//    for (int i = 0;i<actionButtons.count;i++) {
//        UIButton *button =actionButtons[i];
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//        [dict setObject:button forKey:@"view"];
//        [dict setObject:@NO forKey:@"onTop"];
//        [dict setObject:messageArray[i] forKey:@"insText"];
//        [dict setObject:@YES forKey:@"isCustomFrame"];
//        NSLog(@"%@",NSStringFromCGRect([self.view convertRect:button.frame fromView:button.superview]));
//        CGRect tempRect=[self.view convertRect:button.frame fromView:button.superview];
////        tempRect.cen
//        CGRect rect = CGRectMake(tempRect.origin.x, tempRect.origin.y-tempRect.size.height/2, tempRect.size.width, tempRect.size.height);
//        [dict setObject:[NSValue valueWithCGRect:rect] forKey:@"frame"];
//        [overlayViews addObject:dict];
//    }
//    [Utility initializeInstructionAt:self OnViews:overlayViews];
//}

- (void) showInstructionOverlays {
    NSMutableArray *overlayViews = [[NSMutableArray alloc] init];
    overlayViews = [@[@{
                          @"view" : headerContainerView,
                          @"onTop" : @NO,
                          @"insText" :  @"Click here for tools and tips to get the most out of the NOURISH section.",
                          @"isCustomFrame" : @true,
                          @"isFromHeader" :@true,
                          @"frame" : headerContainerView
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [nutritionPlan convertRect:nutritionPlan.bounds toView:self.view]],
                          @"onTop" :@NO,
                          @"insText" : @"Create your PERSONALISED NUTRITION PLAN",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [shoppingList convertRect:shoppingList.bounds toView:self.view]],
                          @"onTop" : @NO,
                          @"insText" : @"The shopping list that accompanies your plan",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [calorieCounter convertRect:calorieCounter.bounds toView:self.view]],
                          @"onTop" : @NO,
                          @"insText" : @"Match your Meal with the nutrition plan",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [mealPrep convertRect:mealPrep.bounds toView:self.view]],
                          @"onTop" : @NO,
                          @"insText" : @"View and create meal prep",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [savedNutritionPlan convertRect:savedNutritionPlan.bounds toView:self.view]],
                          @"onTop" : @NO,
                          @"insText" : @"View your saved nutrition plan",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [recipeList convertRect:recipeList.bounds toView:self.view]],
                          @"onTop" : @NO,
                          @"insText" : @"View Squad recipes and create or view your own recipes",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [ingredientList convertRect:ingredientList.bounds toView:self.view]],
                          @"onTop" : @NO,
                          @"insText" : @"Add an ingredient that isn't in the Squad clean foods list",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [dailyGoodness convertRect:dailyGoodness.bounds toView:self.view]],
                          @"onTop" : @NO,
                          @"insText" : @"See our Squad meal of the day",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          },
                      @{
                          @"view" : [[UIView alloc]initWithFrame: [todoList convertRect:todoList.bounds toView:self.view]],
                          @"onTop" : @NO,
                          @"insText" : @"A TO DO list you can add anything to",
                          @"isCustomFrame" : @false,
                          @"isFromHeader" :@false,
                          @"frame" : [NSValue valueWithCGRect:CGRectZero]
                          }
                      ] mutableCopy];
    
    int multiplierX = 1;
    for (int i = 0; i < overlayViews.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:overlayViews[i]];
        if ([[dict objectForKey:@"isCustomFrame"] boolValue] && [[dict objectForKey:@"isFromHeader"]boolValue]) {
            CGRect newFrame = headerContainerView.frame;
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            newFrame.origin.x = (screenWidth/2.0)*multiplierX;
            newFrame.size.width = (screenWidth/2.0);
            [dict setObject:[NSValue valueWithCGRect:newFrame] forKey:@"frame"];
            [overlayViews replaceObjectAtIndex:i withObject:dict];
            multiplierX++;
        }
    }
    [Utility initializeInstructionAt:self OnViews:overlayViews];
}

#pragma mark - End

@end

