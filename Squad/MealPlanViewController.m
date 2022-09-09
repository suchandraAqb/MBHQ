//
//  MealPlanViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 03/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "MealPlanViewController.h"
#import "Utility.h"
#import "MealVarietyViewController.h"
#import "MealPlanTableViewCell.h"
#import "NutritionSettingHomeViewController.h"
#import "MasterMenuViewController.h"
#import "CustomNutritionPlanListViewController.h"
#import "CongratulationViewController.h"
@interface MealPlanViewController ()
{
    IBOutlet NSLayoutConstraint *footerConstant;
    IBOutlet UIButton *menuButton;
    UIView *contentView;
    int apiCount;
    NSMutableDictionary *customMealPlanDict;
    NSMutableDictionary *getRecommendedMealPlan;
    NSMutableDictionary *getCustomMealPlan;
    NSMutableArray *getMealPlansArray;
    NSDate *customMealPlanDate;
    NSDate *recommendedDate;
    int SelectedPlanId;
    bool personalise;
    int mealPlanId;
    int recommendedMealPlanId;
    int stepnumber;
    int selectedMealIndex;
    NSString *selectedMealName;
    
    IBOutlet UITableView *mealPlanTable;
    IBOutlet UIButton *backToNutritionSettings;
    IBOutlet NSLayoutConstraint *backToNutritionSettingsButtonHeightConstant;

    IBOutlet NSLayoutConstraint *customPlanHeight;
    //add_su_new
    IBOutlet UITextField *nWorkCal;
    IBOutlet UITextField *nMinCarb;
    IBOutlet UITextField *nMaxCarb;
    
    IBOutlet UITextField *sWorkCal;
    IBOutlet UITextField *sMinCarb;
    IBOutlet UITextField *sMaxCarb;
    
    IBOutlet UITextField *dWorkCal;
    IBOutlet UITextField *dMinCarb;
    IBOutlet UITextField *dMaxCarb;
    
    IBOutlet UIView *workoutView;
    
    IBOutlet UIView *noWorkout;
    IBOutlet NSLayoutConstraint *noWorkoutHeight;
    
    IBOutlet UIView *singleWorkout;
    IBOutlet NSLayoutConstraint *singleWorkoutHeight;
    
    IBOutlet UIView *doubleWorkout;
    IBOutlet NSLayoutConstraint *doubleWorkoutHeight;
    
    IBOutlet UIScrollView *mainScroll;
    
    IBOutlet NSLayoutConstraint *mealPlanTableHeight;
    IBOutlet UIView *customView;
    IBOutlet UIView *custommainView;
    IBOutlet UIButton *customplanButton;
    UIView *activeTextField;
    UIToolbar *toolBar;
    //
    IBOutletCollection(UITextField) NSArray *textFieldNeedToBorder;
    IBOutletCollection(UIView) NSArray *noWorkoutCarbViews;
    IBOutletCollection(UIView) NSArray *singleWorkoutCarbViews;
    IBOutletCollection(UIView) NSArray *doubleWorkoutCarbViews;
    IBOutletCollection(UIView) NSArray *nMinMaxCarbsViews;
    IBOutletCollection(UIView) NSArray *sMinMaxCarbsViews;
    IBOutletCollection(UIView) NSArray *dMinMaxCarbsViews;
    IBOutlet UILabel *weightlabel;
    IBOutlet UIView *blankView;
    IBOutlet UIButton *resetButton;
    IBOutlet UIView *bmrView;
    IBOutlet UITextField *weightTextField;
    IBOutlet UIButton *dobButton;
    NSDate *selectedDate;
    BOOL isnext;
    int selectedIndex;
    BOOL isCmp;
}
@end

@implementation MealPlanViewController
@synthesize stepNumber,delegate;

#pragma mark - IBAction

-(IBAction)customPlanButtonTapped:(UIButton*)sender{ //add_su_new
    workoutView.hidden = !workoutView.isHidden;
    //[self customMealSave];
    
    if(workoutView.isHidden){
        if(customplanButton.isSelected){
           [customplanButton setImage:[UIImage imageNamed:@"plus_setprogram.png"] forState:UIControlStateSelected];
        }else{
          [customplanButton setImage:[UIImage imageNamed:@"plus_in_w.png"] forState:UIControlStateNormal];
        }
        
    }else{
        if(customplanButton.isSelected){
            [customplanButton setImage:[UIImage imageNamed:@"minus_setprogram.png"] forState:UIControlStateSelected];
        }else{
           [customplanButton setImage:[UIImage imageNamed:@"meal_minus.png"] forState:UIControlStateNormal];
        }
        if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeCustom"]] || _isFromMyplan) {
            [defaults setBool:YES forKey:@"isFirstTimeCustom"];
            _isFromMyplan = false;
            [self resetButtonPressed:nil];
        }else{
            [defaults setBool:YES forKey:@"isFirstTimeCustom"];
            isCmp = true;
        }
        [self customMealSave];
    }

}

- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}

- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (IBAction)previousbuttonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextbuttonPressed:(id)sender {
    //FIREBASELOG
    
    if(!workoutView.isHidden){
        int cal1 = [nWorkCal.text intValue];
        int cal2 = [sWorkCal.text intValue];
        int cal3 = [dWorkCal.text intValue];
        
        if(cal1 <= 0 && cal2 <= 0 && cal3 <= 0){
            [Utility msg:@"Please enter required calories" title:@"Alert" controller:self haveToPop:NO];
            return;
        }else if(cal1 <= 0){
            [Utility msg:@"Please enter No Workout Day calorie" title:@"Alert" controller:self haveToPop:NO];
            return;
        }else if(cal2 <= 0){
            [Utility msg:@"Please enter Single Workout Day calorie" title:@"Alert" controller:self haveToPop:NO];
            return;
        }else if(cal3 <= 0){
            [Utility msg:@"Please enter Double Workout Day calorie" title:@"Alert" controller:self haveToPop:NO];
            return;
        }
    }
    
    [FIRAnalytics logEventWithName:@"unlock_achievement" parameters:@{
                                                                      @"nutrition_plan":@"completed"
                                                                      }];
    if (!(stepnumber == 0)) {
        isnext=false;
        
        [self webSerViceCall_UpdateNutrationStep:0];
    }else{
        //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
        if(![Utility isEmptyCheck:[defaults objectForKey:@"SendToCustomPlan"]]){
            if ([[defaults objectForKey:@"SendToCustomPlan"] isEqualToString:@"Train"]) {
                [defaults setObject:nil forKey:@"SendToCustomPlan"];
                ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [defaults setObject:nil forKey:@"SendToCustomPlan"];
                CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
                controller.isComplete =true;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else{
            CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
            controller.isComplete =true;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

-(IBAction)backToNutritionSettings:(id)sender{
    BOOL isexist=false;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[NutritionSettingHomeViewController class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            isexist=true;
            break;
            
        }
    }
    if (!isexist) {
        NutritionSettingHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionSettingHomeView"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(IBAction)showHideCarbsButtonPressed:(UIButton *)sender{
    
}

-(void)customMealSave{ //add_su_new
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
   /* if ([nWorkCal.text isEqualToString: @""] || [nWorkCal.text isEqualToString: @"Any"]) {
        [dict setObject:[NSNumber numberWithInt:-1] forKey:@"Session0Cal"];
    }else{
        [dict setObject:[NSNumber numberWithInt:[nWorkCal.text intValue]] forKey:@"Session0Cal"];
    }
    
    if ([nMinCarb.text isEqualToString:@""] || [nMinCarb.text isEqualToString: @"Any"]) {
        [dict setObject:[NSNumber numberWithInt:-1] forKey:@"Session0MinCarb"];
    }else{
        [dict setObject:[NSNumber numberWithInt:[nMinCarb.text intValue]] forKey:@"Session0MinCarb"];
    }
    
    if ([nMaxCarb.text isEqualToString:@""] || [nMaxCarb.text isEqualToString: @"Any"]) {
        [dict setObject:[NSNumber numberWithInt:-1] forKey:@"Session0MaxCarb"];
    }else{
        [dict setObject:[NSNumber numberWithInt:[nMaxCarb.text intValue]] forKey:@"Session0MaxCarb"];
    }*/
    
    int cal1 = [nWorkCal.text intValue];
    if(cal1 <= 0){
        cal1 = 1200;
    }
    [dict setObject:[NSNumber numberWithInt:cal1] forKey:@"Session0Cal"];
    
    int nMinCarbPer = [nMinCarb.text intValue];
    int nMaxCarbPer = [nMaxCarb.text intValue];
    
    if(nMinCarbPer > 0 && nMaxCarbPer > 0){
        [dict setObject:[NSNumber numberWithInt:nMinCarbPer] forKey:@"Session0MinCarb"];
        [dict setObject:[NSNumber numberWithInt:nMaxCarbPer] forKey:@"Session0MaxCarb"];
    }else if(nMinCarbPer > 0){
        [dict setObject:[NSNumber numberWithInt:nMinCarbPer] forKey:@"Session0MinCarb"];
        [dict setObject:[NSNumber numberWithInt:100] forKey:@"Session0MaxCarb"];
    }else if(nMaxCarbPer > 0){
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"Session0MinCarb"];
        [dict setObject:[NSNumber numberWithInt:nMaxCarbPer] forKey:@"Session0MaxCarb"];
    }else{
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"Session0MinCarb"];
        [dict setObject:[NSNumber numberWithInt:100] forKey:@"Session0MaxCarb"];
    }
    
    
    /*if ([sWorkCal.text isEqualToString:@""] || [sWorkCal.text isEqualToString: @"Any"]) {
        [dict setObject:[NSNumber numberWithInt:-1] forKey:@"Session1Cal"];
    }else{
        [dict setObject:[NSNumber numberWithInt:[sWorkCal.text intValue]] forKey:@"Session1Cal"];
    }
    if ([sMinCarb.text isEqualToString:@""] || [sMinCarb.text isEqualToString: @"Any"]) {
        [dict setObject:[NSNumber numberWithInt:-1] forKey:@"Session1MinCarb"];
    }else{
        [dict setObject:[NSNumber numberWithInt:[sMinCarb.text intValue]] forKey:@"Session1MinCarb"];
    }
    if ([sMaxCarb.text isEqualToString:@""] || [sMaxCarb.text isEqualToString: @"Any"]) {
        [dict setObject:[NSNumber numberWithInt:-1] forKey:@"Session1MaxCarb"];
    }else{
        [dict setObject:[NSNumber numberWithInt:[sMaxCarb.text intValue]] forKey:@"Session1MaxCarb"];
    }*/
    
    int cal2 = [sWorkCal.text intValue];
    if(cal2 <= 0){
        cal2 = 1500;
    }
    
    [dict setObject:[NSNumber numberWithInt:cal2] forKey:@"Session1Cal"];
    
    int sMinCarbPer = [sMinCarb.text intValue];
    int sMaxCarbPer = [sMaxCarb.text intValue];
    
    if(sMinCarbPer > 0 && sMaxCarbPer > 0){
        [dict setObject:[NSNumber numberWithInt:sMinCarbPer] forKey:@"Session1MinCarb"];
        [dict setObject:[NSNumber numberWithInt:sMaxCarbPer] forKey:@"Session1MaxCarb"];
    }else if(sMinCarbPer > 0){
        [dict setObject:[NSNumber numberWithInt:sMinCarbPer] forKey:@"Session1MinCarb"];
        [dict setObject:[NSNumber numberWithInt:100] forKey:@"Session1MaxCarb"];
    }else if(sMaxCarbPer > 0){
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"Session1MinCarb"];
        [dict setObject:[NSNumber numberWithInt:sMaxCarbPer] forKey:@"Session1MaxCarb"];
    }else{
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"Session1MinCarb"];
        [dict setObject:[NSNumber numberWithInt:100] forKey:@"Session1MaxCarb"];
    }
    
    /*if ([dWorkCal.text isEqualToString:@""] || [dWorkCal.text isEqualToString: @"Any"]) {
        [dict setObject:[NSNumber numberWithInt:-1] forKey:@"Session2Cal"];
    }else{
        [dict setObject:[NSNumber numberWithInt:[dWorkCal.text intValue]] forKey:@"Session2Cal"];
    }
    
    if ([dMinCarb.text isEqualToString:@""] || [dMinCarb.text isEqualToString: @"Any"]) {
        [dict setObject:[NSNumber numberWithInt:-1] forKey:@"Session2MinCarb"];
    }else{
        [dict setObject:[NSNumber numberWithInt:[dMinCarb.text intValue]] forKey:@"Session2MinCarb"];
    }
    
    if ([dMaxCarb.text isEqualToString:@""] || [dMaxCarb.text isEqualToString: @"Any"]) {
        [dict setObject:[NSNumber numberWithInt:-1] forKey:@"Session2MaxCarb"];
    }else{
        [dict setObject:[NSNumber numberWithInt:[dMaxCarb.text intValue]] forKey:@"Session2MaxCarb"];
    }*/
    
    int cal3 = [dWorkCal.text intValue];
    if(cal3 <= 0){
        cal3 = 2000;
    }
    
    [dict setObject:[NSNumber numberWithInt:cal3] forKey:@"Session2Cal"];
    
    int dMinCarbPer = [dMinCarb.text intValue];
    int dMaxCarbPer = [dMaxCarb.text intValue];
    
    if(dMinCarbPer > 0 && dMaxCarbPer > 0){
        [dict setObject:[NSNumber numberWithInt:dMinCarbPer] forKey:@"Session2MinCarb"];
        [dict setObject:[NSNumber numberWithInt:dMaxCarbPer] forKey:@"Session2MaxCarb"];
    }else if(dMinCarbPer > 0){
        [dict setObject:[NSNumber numberWithInt:dMinCarbPer] forKey:@"Session2MinCarb"];
        [dict setObject:[NSNumber numberWithInt:100] forKey:@"Session2MaxCarb"];
    }else if(dMaxCarbPer > 0){
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"Session2MinCarb"];
        [dict setObject:[NSNumber numberWithInt:dMaxCarbPer] forKey:@"Session2MaxCarb"];
    }else{
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"Session2MinCarb"];
        [dict setObject:[NSNumber numberWithInt:100] forKey:@"Session2MaxCarb"];
    }
    
    [self webServiceCall_CreateCustomMealPlan:dict];
    
}

- (IBAction)minMaxexpandButtonPressed:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    
    if(sender.tag == 0){
        
        for(UIView *view in nMinMaxCarbsViews){
            view.hidden = !sender.isSelected;
        }
        
    }else if(sender.tag == 1){
        for(UIView *view in sMinMaxCarbsViews){
            view.hidden = !sender.isSelected;
        }
        
    }else if(sender.tag == 2){
        for(UIView *view in dMinMaxCarbsViews){
            view.hidden = !sender.isSelected;
        }
    }
}

- (IBAction)cellExpandCollapse:(UIButton *)sender {
    if (selectedIndex == sender.tag) {
        selectedIndex = -1;
    }else{
        selectedIndex = (int)sender.tag;
    }
    [mealPlanTable reloadData];
//    [mealPlanTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

}
-(IBAction)resetButtonPressed:(id)sender{
    [self webSerViceCall_GetLatestWeightData];
}
-(IBAction)dobButtonPressed:(id)sender{
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    if (![Utility isEmptyCheck:selectedDate]) {
        controller.selectedDate = selectedDate;
    }
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)crossButtonPressed:(id)sender{
    bmrView.hidden = true;
}
-(IBAction)saveBmrButtonPressed:(id)sender{
    [self.view endEditing:YES];
    if ([self formvalidation]) {
        [self webSerViceCall_SetBMRData];
    }
}
#pragma mark - End

#pragma mark - Private Function
-(void)gotoHome{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
    HomePageViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
    NavigationViewController *nav = [[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
    slider.topViewController = nav;
    [slider resetTopViewAnimated:YES];
    [self.navigationController pushViewController:slider animated:YES];
}

-(void)customPlan{ //add_su_new
    
        nWorkCal.text = @"";
    
        if(![Utility isEmptyCheck:customMealPlanDict] && [[customMealPlanDict objectForKey:@"Session0Cal"]intValue] > 0){
            nWorkCal.text = [@"" stringByAppendingFormat:@"%@",[customMealPlanDict objectForKey:@"Session0Cal"]];
        }else if(![Utility isEmptyCheck:getRecommendedMealPlan] && [[getRecommendedMealPlan objectForKey:@"Session0Cal"]intValue] > 0){
            nWorkCal.text = [@"" stringByAppendingFormat:@"%@",[getRecommendedMealPlan objectForKey:@"Session0Cal"]];
        }
        
        nMinCarb.text = @"0";
    
        if(![Utility isEmptyCheck:customMealPlanDict] && [[customMealPlanDict objectForKey:@"Session0MinCarb"]intValue] >= 0){
            nMinCarb.text = [@"" stringByAppendingFormat:@"%@",[customMealPlanDict objectForKey:@"Session0MinCarb"]];
        }/*else if(![Utility isEmptyCheck:getRecommendedMealPlan] &&[[getRecommendedMealPlan objectForKey:@"Session0MinCarb"]intValue] >= 0){
            nMinCarb.text = [@"" stringByAppendingFormat:@"%@",[getRecommendedMealPlan objectForKey:@"Session0MinCarb"]];
        }*/
        
        nMaxCarb.text = @"100";
    
        if(![Utility isEmptyCheck:customMealPlanDict] && [[customMealPlanDict objectForKey:@"Session0MaxCarb"]intValue] >= 0){
            nMaxCarb.text = [@"" stringByAppendingFormat:@"%@",[customMealPlanDict objectForKey:@"Session0MaxCarb"]];
        }/*else if(![Utility isEmptyCheck:getRecommendedMealPlan] && [[getRecommendedMealPlan objectForKey:@"Session0MaxCarb"]intValue] >= 0){
            nMaxCarb.text = [@"" stringByAppendingFormat:@"%@",[getRecommendedMealPlan objectForKey:@"Session0MaxCarb"]];
        }*/

    
        sWorkCal.text = @"";
    
        if(![Utility isEmptyCheck:customMealPlanDict] && [[customMealPlanDict objectForKey:@"Session1Cal"]intValue] > 0){
            sWorkCal.text = [@"" stringByAppendingFormat:@"%@",[customMealPlanDict objectForKey:@"Session1Cal"]];
        }else if(![Utility isEmptyCheck:getRecommendedMealPlan] && [[getRecommendedMealPlan objectForKey:@"Session1Cal"]intValue] > 0){
            sWorkCal.text = [@"" stringByAppendingFormat:@"%@",[getRecommendedMealPlan objectForKey:@"Session1Cal"]];
        }

    
        sMinCarb.text = @"0";
    
        if(![Utility isEmptyCheck:customMealPlanDict] && [[customMealPlanDict objectForKey:@"Session1MinCarb"]intValue] >= 0){
            sMinCarb.text = [@"" stringByAppendingFormat:@"%@",[customMealPlanDict objectForKey:@"Session1MinCarb"]];
        }/*else if(![Utility isEmptyCheck:getRecommendedMealPlan] &&[[getRecommendedMealPlan objectForKey:@"Session1MinCarb"]intValue] >= 0){
            sMinCarb.text = [@"" stringByAppendingFormat:@"%@",[getRecommendedMealPlan objectForKey:@"Session1MinCarb"]];
        }*/
        
        sMaxCarb.text = @"100";
    
        if(![Utility isEmptyCheck:customMealPlanDict] && [[customMealPlanDict objectForKey:@"Session1MaxCarb"]intValue] >= 0){
            sMaxCarb.text = [@"" stringByAppendingFormat:@"%@",[customMealPlanDict objectForKey:@"Session1MaxCarb"]];
        }/*else if(![Utility isEmptyCheck:getRecommendedMealPlan] &&[[getRecommendedMealPlan objectForKey:@"Session1MaxCarb"]intValue] >= 0){
            sMaxCarb.text = [@"" stringByAppendingFormat:@"%@",[getRecommendedMealPlan objectForKey:@"Session1MaxCarb"]];
        }*/
        
    
        dWorkCal.text = @"";
    
        if(![Utility isEmptyCheck:customMealPlanDict] && [[customMealPlanDict objectForKey:@"Session2Cal"]intValue] > 0){
            dWorkCal.text = [@"" stringByAppendingFormat:@"%@",[customMealPlanDict objectForKey:@"Session2Cal"]];
        }else if(![Utility isEmptyCheck:getRecommendedMealPlan] &&[[getRecommendedMealPlan objectForKey:@"Session2Cal"]intValue] > 0){
            dWorkCal.text = [@"" stringByAppendingFormat:@"%@",[getRecommendedMealPlan objectForKey:@"Session2Cal"]];
        }
        
    
        dMinCarb.text = @"0";
    
        if(![Utility isEmptyCheck:customMealPlanDict] && [[customMealPlanDict objectForKey:@"Session2MinCarb"]intValue] >= 0){
            dMinCarb.text = [@"" stringByAppendingFormat:@"%@",[customMealPlanDict objectForKey:@"Session2MinCarb"]];
        }/*else if(![Utility isEmptyCheck:getRecommendedMealPlan] && [[getRecommendedMealPlan objectForKey:@"Session2MinCarb"]intValue] >= 0){
            dMinCarb.text = [@"" stringByAppendingFormat:@"%@",[getRecommendedMealPlan objectForKey:@"Session2MinCarb"]];
        }*/
        
        dMaxCarb.text = @"100";
    
        if(![Utility isEmptyCheck:customMealPlanDict] && [[customMealPlanDict objectForKey:@"Session2MaxCarb"]intValue] >= 0){
            dMaxCarb.text = [@"" stringByAppendingFormat:@"%@",[customMealPlanDict objectForKey:@"Session2MaxCarb"]];
        }/*else if(![Utility isEmptyCheck:getRecommendedMealPlan] && [[getRecommendedMealPlan objectForKey:@"Session2MaxCarb"]intValue] >= 0){
            dMaxCarb.text = [@"" stringByAppendingFormat:@"%@",[getRecommendedMealPlan objectForKey:@"Session2MaxCarb"]];
        }*/
//    if (![Utility isEmptyCheck:customMealPlanDict] && ![Utility isEmptyCheck:getRecommendedMealPlan]) {
//        if (!([[customMealPlanDict objectForKey:@"Session0Cal"]intValue] == [[getRecommendedMealPlan objectForKey:@"Session0Cal"]intValue])||(!([[customMealPlanDict objectForKey:@"Session1Cal"]intValue] == [[getRecommendedMealPlan objectForKey:@"Session1Cal"]intValue])) || (!([[customMealPlanDict objectForKey:@"Session2Cal"]intValue] == [[getRecommendedMealPlan objectForKey:@"Session2Cal"]intValue]))) {
//            resetButton.hidden = false;
//        }else{
//            resetButton.hidden = true;
//        }
//    }else{
//        resetButton.hidden = true;
//    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary  *)change context:(void *)context
{
    //Whatever you do here when the reloadData finished
    float newHeight = mealPlanTable.contentSize.height;
    mealPlanTableHeight.constant=newHeight;
}
-(void)webServiceCall_CreateCustomMealPlan:(NSMutableDictionary*)dict{ //add_su_new
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:dict forKey:@"CustomMealPlan"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"CreateCustomMealPlan" append:@""forAction:@"POST"];
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
                                                                         BOOL isreload=false;
                                                                         if ([defaults boolForKey:@"isFirstTimeCustom"] && !isCmp) {
                                                                             isreload = false;
                                                                         }else{
                                                                             isreload = true;
                                                                         }
//                                                                         [Utility msg:@"Saved Successfully" title:@"Success !" controller:self haveToPop:NO];
                                                                         [self webServiceCall_SquadGetRecommendedMealPlanForUser:isreload];
                                                                         
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
                                                                 self->apiCount--;
                                                                 if (self->contentView && apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         stepnumber=[[responseDict objectForKey:@"StepNumber"]intValue];
                                                                         if (self->stepnumber==0) {
                                                                             //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]] || [defaults boolForKey:@"IsNonSubscribedUser"]){
                                                                             if(![Utility isSubscribedUser]){
                                                                                 self->backToNutritionSettings.hidden=true;
                                                                                 backToNutritionSettingsButtonHeightConstant.constant = 0;
                                                                                 customPlanHeight.constant = 0;
                                                                                 customView.hidden = true;
                                                                             }else{
                                                                                 backToNutritionSettings.hidden=false;
                                                                                 backToNutritionSettingsButtonHeightConstant.constant = 40;
                                                                                 customPlanHeight.constant = 40;
                                                                                 customView.hidden = false;
                                                                             }
                                                                             
                                                                         }else{
                                                                             backToNutritionSettings.hidden=true;
                                                                             backToNutritionSettingsButtonHeightConstant.constant = 0;
                                                                             customPlanHeight.constant = 0;
                                                                             customView.hidden = true;
                                                                         }
                                                                      
                                                                         if (self->apiCount == 0) {
                                                                             [self->mealPlanTable reloadData];
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

-(void)setUpView{
    if ([customMealPlanDate compare:recommendedDate] == NSOrderedDescending && stepnumber == 0 && [Utility isSubscribedUser]
/*[[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]*/){
        selectedMealName=@"My Choice (100% custom)";//Custom
        SelectedPlanId =-1;
        personalise=false;
        [defaults setObject:selectedMealName forKey:@"selectedMealName"];
        [customplanButton setImage:[UIImage imageNamed:@"minus_setprogram.png"] forState:UIControlStateSelected];
        [customplanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [customplanButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
        customplanButton.selected = true;
      //  [self webservicecall_CreateSquadUserMealPlan:recommendedMealPlanId with:personalise with:false];
    }
}
-(BOOL)formvalidation{
    BOOL isvalided = true;
    if ([Utility isEmptyCheck:dobButton.titleLabel.text]) {
        [Utility msg:@"Please enter your date of birth" title:@"" controller:self haveToPop:NO];
        isvalided = false;
    }
    if ([Utility isEmptyCheck:weightTextField.text]) {
        [Utility msg:@"Please enter your weight" title:@"" controller:self haveToPop:NO];
        isvalided = false;
    }
    return isvalided;
}
-(void)webSerViceCall_UpdateNutrationStep:(int)step{
    if (stepnumber != 0) {// < stepNumber) {
        if (Utility.reachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
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
            
            [mainDict setObject:[NSNumber numberWithInteger:step] forKey:@"StepNumber"];
            [mainDict setObject:AccessKey forKey:@"Key"];
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateNutrationStep" append:@""forAction:@"POST"];
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
                                                                             [defaults setObject:[NSNumber numberWithBool:true] forKey:@"IsAllStepComplete"];
                                                                             if (!self->isnext) {
                                                                                 if(![Utility isEmptyCheck:[defaults objectForKey:@"SendToCustomPlan"]]){
                                                                                     if ([[defaults objectForKey:@"SendToCustomPlan"] isEqualToString:@"Train"]) {
                                                                                         [defaults setObject:nil forKey:@"SendToCustomPlan"];
                                                                                         ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
                                                                                         [self.navigationController pushViewController:controller animated:YES];
                                                                                     }else{
                                                                                         [defaults setObject:nil forKey:@"SendToCustomPlan"];
                                                                                         CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
                                                                                         controller.isComplete =true;
                                                                                         [self.navigationController pushViewController:controller animated:YES];
                                                                                     }
                                                                                 }else{
                                                                                     CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
                                                                                     controller.isComplete =true;
                                                                                     [self.navigationController pushViewController:controller animated:YES];
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
}

-(void)webservicecall_CreateSquadUserMealPlan:(int)mealPlanIdValue with:(BOOL)personaliseBoolValue with:(BOOL)isReloadView{
    {
        if (Utility.reachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                apiCount++;
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
                self->contentView = [Utility activityIndicatorView:self];
            });
            
            NSURLSession *loginSession = [NSURLSession sharedSession];
            NSError *error;
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            
            [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
            [mainDict setObject:[NSNumber numberWithInteger:mealPlanIdValue] forKey:@"MealPlanId"];
            [mainDict setObject:[NSNumber numberWithBool:personaliseBoolValue] forKey:@"IsPersonalised"];
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"CreateSquadUserMealPlan" append:@""forAction:@"POST"];
            NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                    // apiCount--;
                                                                     if (self->contentView) {
                                                                         [self->contentView removeFromSuperview];
                                                                     }
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                             if (isReloadView) {
//                                                                                 [Utility msg:@"Your Base Meal Plan Saved Successful!" title:@"" controller:self haveToPop:NO];
                                                                             }
                                                                             if (self->stepNumber <6) {
                                                                                 if (![[defaults objectForKey:@"IsAllStepComplete"]boolValue] && ![[defaults objectForKey:@"IsRedoDone"]boolValue]) {
                                                                                     self->isnext=false;
                                                                                 }else{
                                                                                     self->isnext=true;
                                                                                 }
                                                                                 [self webSerViceCall_UpdateNutrationStep:0];
                                                                             }
                                                                             if (isReloadView) {
                                                                                 [self webServiceCall_SquadGetRecommendedMealPlanForUser:isReloadView];
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
}
-(void)webservicecall_GetMealPlans:(BOOL)isreload{
    {
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
            [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMealPlans" append:@""forAction:@"POST"];
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
                                                                         //NSLog(@"GetMealPlans- %@",responseDict);

                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                             self->getMealPlansArray=[[NSMutableArray alloc]init];
                                                                             self->getMealPlansArray = [[responseDict objectForKey:@"MealPlans"]mutableCopy];
                                                                             [self webServiceCall_SquadGetRecommendedMealPlanForUser:isreload];
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
}

-(void)webServiceCall_SquadGetRecommendedMealPlanForUser:(BOOL)isReload{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"SquadGetRecommendedMealPlanForUser" append:[@"" stringByAppendingFormat:@"%@", [defaults objectForKey:@"ABBBCOnlineUserId"]] forAction:@"GET"];
        
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
//                                                                 apiCount--;
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     NSLog(@"SquadGetRecommendedMealPlanForUser- %@",responseDictionary);

                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                         self->getRecommendedMealPlan = [responseDictionary objectForKey:@"obj"];
                                                                         
                                                                         if (![Utility isEmptyCheck:self->getRecommendedMealPlan]) {
                                                                             
                                                                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                             [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
//                                                                             NSLog(@"%@",[getRecommendedMealPlan objectForKey:@"DateUpdated"]);
                                                                             
                                                                             NSDate *recommendedPlanDate = [formatter dateFromString:[self->getRecommendedMealPlan objectForKey:@"DateUpdated"]];
                                                                             
                                                                             self->recommendedDate = recommendedPlanDate;
                                                                             
                                                                             self->mealPlanId= [[self->getRecommendedMealPlan objectForKey:@"MealPlanId"]intValue];
                                                                             self->recommendedMealPlanId=[[self->getRecommendedMealPlan objectForKey:@"RecommendedMealPlanId"]intValue];
                                                                             
                                                                             [self customPlan];
                                                                             [self webServiceCall_GetUserCustomMealPlan:isReload];
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

-(void)webServiceCall_GetUserCustomMealPlan:(BOOL)isreload{
    {
        if (Utility.reachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //apiCount++;
                if (contentView) {
                    [contentView removeFromSuperview];
                }
                contentView = [Utility activityIndicatorView:self];
            });
            
            NSURLSession *loginSession = [NSURLSession sharedSession];
            NSError *error;
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
            [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
            [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserCustomMealPlan" append:@""forAction:@"POST"];
            NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
//                                                                     apiCount--;
                                                                     if (contentView) {
                                                                         [contentView removeFromSuperview];
                                                                     }
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         NSLog(@"CustomMealPlan- %@",responseDict);
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                            
                                                                             customMealPlanDict =[responseDict objectForKey:@"userCustomMealPlanData"];
                                                                             if (![Utility isEmptyCheck:customMealPlanDict]) {
                                                                                 [self customPlan]; //add_su_new

                                                                                 NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                                                                 [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                                                                                 NSDate *customPlanDate = [df dateFromString: [customMealPlanDict objectForKey:@"DateUpdated"]];
                                                                                 customMealPlanDate = customPlanDate;
                                                                                 [self setUpView];
                                                                             }
                                                                             if (mealPlanId == recommendedMealPlanId && !(SelectedPlanId == -1)) {
                                                                                 NSLog(@"SelectedPlanId-%d",SelectedPlanId);
                                                                                 personalise=false;
                                                                                 [self webservicecall_CreateSquadUserMealPlan:recommendedMealPlanId with:personalise with:false];
                                                                             }
                                                                             if (isreload){
                                                                                 [Utility msg:@"Your Base Meal Plan Saved Successful!" title:@"" controller:self haveToPop:NO];
                                                                                  [[NSNotificationCenter defaultCenter]postNotificationName:@"customNutritionview" object:self];
                                                                                 if ([self->delegate respondsToSelector:@selector(didCheckAnyChangeForMealPlan:)]) {
                                                                                     [self->delegate didCheckAnyChangeForMealPlan:true];
                                                                                 }
                                                                                
                                                                             }
                                                                             [self->mealPlanTable reloadData];
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
}


-(void)webSerViceCall_GetLatestWeightData{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"AbbbcUserSessionId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetLatestWeightData" append:@""forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         self->bmrView.hidden = false;
                                                                         
                                                                         int unitPrefererence = [[defaults objectForKey:@"UnitPreference"] intValue];
                                                                         NSString *weight, *measurements;
                                                                         if (unitPrefererence ==0 || unitPrefererence ==1) {
                                                                             weight = @"kg";
                                                                             measurements = @"cm";
                                                                         }else{
                                                                             weight = @"lb";
                                                                             measurements = @"inches";
                                                                         }
                                                                         self->weightlabel.text=[@"" stringByAppendingFormat:@"Weight ( %@ )",weight];
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"DateOfBirth"]]) {
                                                                             static NSDateFormatter *dateFormatter;
                                                                             dateFormatter = [NSDateFormatter new];
                                                                             [dateFormatter setDateFormat:@"YYYY-MM-dd"];
                                                                             NSDate *date = [dateFormatter dateFromString:[responseDict objectForKey:@"DateOfBirth"]];
                                                                             dateFormatter = [NSDateFormatter new];
                                                                             [dateFormatter setDateFormat:@"dd/MM/YYYY"];
                                                                             self->selectedDate = date;
                                                                             [self->dobButton setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
                                                                         }
                                                                         if (![Utility isEmptyCheck:[[responseDict objectForKey:@"BodyData"]objectForKey:@"Weight"]]) {
                                                                             self->weightTextField.text =[@"" stringByAppendingFormat:@"%@",[[responseDict objectForKey:@"BodyData"]objectForKey:@"Weight"]];
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
-(void)webSerViceCall_SetBMRData{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"AbbbcUserSessionId"];
        [mainDict setObject:[NSNumber numberWithInt:[weightTextField.text intValue]] forKey:@"GoalWeight"];
        [mainDict setObject:dobButton.titleLabel.text forKey:@"DateOfBirth"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SetBMRData" append:@""forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         self->bmrView.hidden = true;
                                                                         [self webservicecall_GetMealPlans:true];
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
#pragma mark  -End

#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{//add9
    if (![Utility isEmptyCheck:getMealPlansArray] && ![Utility isEmptyCheck:getRecommendedMealPlan]) {
        NSArray *filteredarray = [getMealPlansArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(MealPlanId == %@)", [getRecommendedMealPlan objectForKey:@"MealPlanId"]]];
        if (filteredarray.count > 0) {
            [getMealPlansArray removeObject:filteredarray[0]];
            [getMealPlansArray insertObject:filteredarray[0] atIndex:0];
        }
        
    }
    return getMealPlansArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"MealPlanTableViewCell";
    MealPlanTableViewCell *cell = (MealPlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[MealPlanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
  
    NSDictionary *dict = [getMealPlansArray objectAtIndex:indexPath.row];
    int mealPlanIdValue= [[dict objectForKey:@"MealPlanId"]intValue];
    NSString *mealPlanTitle = [dict objectForKey:@"MealPlanTitle"];
    cell.topLabel.text = [dict objectForKey:@"MealPlanTitle"];
    int mealPlan =[[getRecommendedMealPlan objectForKey:@"MealPlanId"]intValue];
    
    /*
    cell.shadowView.layer.masksToBounds = NO;
    cell.shadowView.layer.shadowColor = [Utility colorWithHexString:@"2e312d"].CGColor;
    cell.shadowView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    cell.shadowView.layer.shadowOpacity = 0.4f;
    cell.shadowView.layer.shadowRadius = 5;
     */
    //add_su_new
    cell.shadowView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    cell.shadowView.layer.borderWidth = 1;
   
    [customplanButton setBackgroundColor:[UIColor whiteColor]];
    [customplanButton setImage:[UIImage imageNamed:@"plus_in_w.png"] forState:UIControlStateNormal];
    [customplanButton setTitleColor:[Utility colorWithHexString:@"E425A0"] forState:UIControlStateNormal];
    customplanButton.selected = false;
    if (selectedIndex == indexPath.row){
        [cell.expandButton setTitle:@"-" forState:UIControlStateNormal];
        [cell.stack insertArrangedSubview:cell.bottonView atIndex:1];
    }else{
        [cell.expandButton setTitle:@"+" forState:UIControlStateNormal];
        [cell.stack removeArrangedSubview:cell.bottonView];
        [cell.bottonView removeFromSuperview];
    }

    if (!(mealPlanIdValue>0)) {
        [cell.shadowView.layer setBorderColor:[UIColor clearColor].CGColor];
        [cell.shadowView.layer setBorderWidth:0.0f];
        [cell.expandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.topView.backgroundColor = [Utility colorWithHexString:@"90D1D8"]; //E425A0
        
        cell.topLabel.textColor = [UIColor whiteColor];
        cell.topViewCheckUncheckButton.selected=true;
        selectedMealName=mealPlanTitle;
        [defaults setObject:selectedMealName forKey:@"selectedMealName"];
    }else{
        if ([customMealPlanDate compare:recommendedDate] == NSOrderedDescending && stepnumber == 0 && [Utility isSubscribedUser]/*([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]] || [defaults boolForKey:@"IsNonSubscribedUser"])*/){
        
            workoutView.hidden = false;
            [customplanButton setImage:[UIImage imageNamed:@"minus_setprogram.png"] forState:UIControlStateSelected];
            [customplanButton setBackgroundColor:[Utility colorWithHexString:@"90D1D8"]]; //E425A0
            [customplanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            customplanButton.selected = true;
            
            [cell.expandButton setTitleColor:[Utility colorWithHexString:@"E425A0"] forState:UIControlStateNormal];
            cell.topView.backgroundColor = [UIColor whiteColor];
            cell.topLabel.textColor = [Utility colorWithHexString:@"E425A0"];
            cell.topViewCheckUncheckButton.selected=false;
            
            selectedMealName=@"My Choice (100% custom)";//Custom
            SelectedPlanId =-1;
            personalise=false;
            [defaults setObject:selectedMealName forKey:@"selectedMealName"];
          
      }else if (mealPlan == mealPlanIdValue) {
          
            [cell.shadowView.layer setBorderColor:[UIColor clearColor].CGColor];
            [cell.shadowView.layer setBorderWidth:0.0f];
            [cell.expandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.topView.backgroundColor = [Utility colorWithHexString:@"90D1D8"]; //E425A0
            cell.topLabel.textColor = [UIColor whiteColor];
            cell.topViewCheckUncheckButton.selected=true;
          
            selectedMealName=mealPlanTitle;
            [defaults setObject:selectedMealName forKey:@"selectedMealName"];
            workoutView.hidden = true;
            [customplanButton setImage:[UIImage imageNamed:@"plus_in_w.png"] forState:UIControlStateNormal];
          
            
        }else{
            [cell.expandButton setTitleColor:[Utility colorWithHexString:@"E425A0"] forState:UIControlStateNormal];
            cell.topView.backgroundColor = [UIColor whiteColor];
            cell.topLabel.textColor = [Utility colorWithHexString:@"E425A0"];
            cell.topViewCheckUncheckButton.selected=false;
            workoutView.hidden = true;
            [customplanButton setImage:[UIImage imageNamed:@"plus_in_w.png"] forState:UIControlStateNormal];
            
        }
        //
    }
    if ([[getRecommendedMealPlan objectForKey:@"RecommendedMealPlanId"]intValue] == mealPlanIdValue) {
       // cell.recommendedLabel.hidden=false;
       // cell.recommendedLabel.text = @"REC";
        cell.recommendedButton.hidden =false;
        
        if ([cell.topLabel.textColor isEqual:[UIColor whiteColor]]) {
            cell.recommendedButton.selected =true;
        }else{
            cell.recommendedButton.selected =false;
        }
    }
    else{
        cell.recommendedLabel.text=@"";
        //cell.recommendedLabel.hidden =true;
        cell.recommendedButton.hidden =true;
    }

    if (mealPlanIdValue == 1) {
        cell.detailsLabel.text=@"Optimised for Maximum Fat Loss\nFor people who struggle to lose/burn Fat";

    }else if (mealPlanIdValue == 2) {
        cell.detailsLabel.text=@"For clients looking to drop fat and tone up at the same time\nSlower fat loss than clean results and slower muscle gain than tone up\nThe perfect intermediate plan for girls with a long term focus or who find they are a little\nto hungry on the Clean Results Plan.";
        
    }
    else if (mealPlanIdValue == 3) {
        cell.detailsLabel.text=@"For Clients who struggle to add lean muscle or whose number one goal is muscle growth\nHigher carb and energy intake to boost performance\nExcellent for fit, highly trained clients looking to take results to the next level";
        
    }else if (mealPlanIdValue == 4) {
        cell.detailsLabel.text=@"The perfect maintenance plan\nEnergy and Mood Stabilisation\nThe plan for when nothing else is working";
        
    }
    else if (mealPlanIdValue == 5) {
        cell.detailsLabel.text=@"For Mums at least 6 weeks post pregnancy who are looking to get their figure back.\nGreat for when you are still breastfeeding and need to get results but prioritise your bub first.";
    }
    cell.expandButton.tag = indexPath.row;
    [cell.expandButton addTarget:self
                            action:@selector(cellExpandCollapse:)
                  forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"MealPlanTableViewCell";
    MealPlanTableViewCell *cell = (MealPlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[MealPlanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    selectedMealIndex=(int)indexPath.row;

    NSMutableDictionary *dict = [getMealPlansArray objectAtIndex:indexPath.row];
     if (![Utility isEmptyCheck:dict]) {
         int mealId = [[dict objectForKey:@"MealPlanId"]intValue];
         [self webservicecall_CreateSquadUserMealPlan:mealId with:false with:true];

         
//    if ([customMealPlanDate compare:recommendedDate] == NSOrderedDescending) {
//         if (indexPath.row>= 0 && indexPath.row<=4) {
//            [self webservicecall_CreateSquadUserMealPlan:mealId with:false with:true];
//    }
//    else{
//            [self webServiceCall_CreateCustomMealPlan:dict];
//        }
    }
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    getMealPlansArray=[[NSMutableArray alloc]init];
    NSLog(@"=====%d",[[defaults objectForKey:@"IsAllStepComplete"]boolValue]);
    NSLog(@"=====%d",[[defaults objectForKey:@"IsRedoDone"]boolValue]);
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
    if(![Utility isSubscribedUser]){
        menuButton.hidden = true;
        footerConstant.constant = 0;
    }else{
        menuButton.hidden = false;
        footerConstant.constant = 75;
    }
    selectedIndex = -1;
    workoutView.hidden = true;
    custommainView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    custommainView.layer.borderWidth = 1;
    customPlanHeight.constant = 0;
    customView.hidden = true;
    
    for(UITextField *field in textFieldNeedToBorder){
        field.layer.borderColor = [[Utility colorWithHexString:@"333333"] colorWithAlphaComponent:0.5].CGColor;
        field.layer.borderWidth = 1;
    }
    dobButton.layer.borderColor = [[Utility colorWithHexString:@"333333"] colorWithAlphaComponent:0.5].CGColor;
    dobButton.layer.borderWidth=1;
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *keyBoardDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(keyBoardDoneButtonClicked:)];
    [toolBar setItems:[NSArray arrayWithObject:keyBoardDone]];
    [self registerForKeyboardNotifications];
    //

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    isnext=false;
    mealPlanTable.estimatedRowHeight = 145;
    mealPlanTable.rowHeight = UITableViewAutomaticDimension;
    apiCount= 0;
    resetButton.layer.cornerRadius = 8;
    resetButton.layer.masksToBounds = YES;
    resetButton.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    
    if ([delegate isKindOfClass:[MealMatchViewController class]]) {
        blankView.hidden = true;
    }else{
        if (![[defaults objectForKey:@"IsAllStepComplete"]boolValue] && ![[defaults objectForKey:@"IsRedoDone"]boolValue]) {
            blankView.hidden = false;
        }else{
            blankView.hidden = true;
        }
    }
    //add_su_new
    [mealPlanTable addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld context:NULL];
    if (_isFromMyplan) {
        [self customPlanButtonTapped:nil];
    }
    
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self webservicecall_GetMealPlans:false];
        [self webSerViceCall_SquadNutritionSettingStep];
    });
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [customplanButton setImageEdgeInsets:UIEdgeInsetsMake(0, customplanButton.frame.size.width - 50, 0, 0)];
}

-(void)viewWillDisappear:(BOOL)animated{ //add_su_new
    [mealPlanTable removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -End

//add_su_new
#pragma mark - KeyboardNotifications -
// Call this method somewhere in your view controller setup code.
-(void)keyBoardDoneButtonClicked:(UIButton *)sender{
    [activeTextField resignFirstResponder];
}
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
        CGPoint tempPoint = CGPointMake(frame.origin.x, frame.origin.y+frame.size.height);
        if (!CGRectContainsPoint(aRect,tempPoint) ) {
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

#pragma mark - textField Delegate


/*- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    BOOL isValidated = NO;
    if (textField.tag == 0) {
        if (![Utility isEmptyCheck:nWorkCal.text] && !([nWorkCal.text intValue] > 100 && [nWorkCal.text intValue]<5000)) {
            [Utility msg:@"Cal must be between 100 and 5000" title:@"Alert" controller:self haveToPop:NO];
                return isValidated;
            }
        }else if (textField.tag == 1){
            if(![Utility isEmptyCheck:nMinCarb.text] && !([nMinCarb.text intValue] > 0 && [nMinCarb.text intValue]<60)){
                [Utility msg:@"Min carb must be between 0 and 60" title:@"Alert" controller:self haveToPop:NO];
                     return isValidated;
            }
        }else if (textField.tag == 2){
                if(![Utility isEmptyCheck:nMaxCarb.text] && !([nMaxCarb.text intValue] > 0 && [nMaxCarb.text intValue]<60)){
                    [Utility msg:@"Max carb must be between 0 and 100" title:@"Alert" controller:self haveToPop:NO];
                     return isValidated;
                }
        }else if (textField.tag == 3){
                if(![Utility isEmptyCheck:sWorkCal.text] && !([sWorkCal.text intValue] > 0 && [sWorkCal.text intValue]<60)){
                    [Utility msg:@"Cal must be between 100 and 5000" title:@"Alert" controller:self haveToPop:NO];
                     return isValidated;
                }
        }else if (textField.tag == 4){
                if(![Utility isEmptyCheck:sMinCarb.text] && !([sMinCarb.text intValue] > 0 && [sMinCarb.text intValue]<60)){
                    [Utility msg:@"Min carb must be between 0 and 60" title:@"Alert" controller:self haveToPop:NO];
                     return isValidated;
                }
        }else if (textField.tag == 5){
                if(![Utility isEmptyCheck:sMaxCarb.text] && !([sMaxCarb.text intValue] > 0 && [sMaxCarb.text intValue]<60)){
                    [Utility msg:@"Max carb must be between 0 and 100" title:@"Alert" controller:self haveToPop:NO];
                     return isValidated;
                }
        }else if (textField.tag == 6){
               if(![Utility isEmptyCheck:dWorkCal.text] && !([dWorkCal.text intValue] > 0 && [dWorkCal.text intValue]<60)){
                   [Utility msg:@"Cal must be between 100 and 5000" title:@"Alert" controller:self haveToPop:NO];
                    return isValidated;
               }
        }else if (textField.tag == 7){
                if(![Utility isEmptyCheck:dMinCarb.text] && !([dMinCarb.text intValue] > 0 && [dMinCarb.text intValue]<60)){
                    [Utility msg:@"Min carb must be between 0 and 60" title:@"Alert" controller:self haveToPop:NO];
                     return isValidated;
                }
        }else if (textField.tag == 8){
                if(![Utility isEmptyCheck:dMaxCarb.text] && !([dMaxCarb.text intValue] > 0 && [dMaxCarb.text intValue]<60)){
                    [Utility msg:@"Max carb must be between 0 and 100" title:@"Alert" controller:self haveToPop:NO];
                     return isValidated;
                }
        }
    [self customMealSave];
    return YES;
}*/

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setInputAccessoryView:toolBar];
    activeTextField = textField;
    //[addShoppingTable reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
    
    BOOL isValidated = YES;
    if (textField.tag == 0) {
        if (![Utility isEmptyCheck:nWorkCal.text] && !([nWorkCal.text intValue] > 100 && [nWorkCal.text intValue]<5000)) {
            [Utility msg:@"Cal must be between 100 and 5000" title:@"Alert" controller:self haveToPop:NO];
            isValidated = NO;
        }
    }else if (textField.tag == 1){
        if(![Utility isEmptyCheck:nMinCarb.text] && !([nMinCarb.text intValue] > 0 && [nMinCarb.text intValue]<60)){
            //[Utility msg:@"Min carb must be between 0 and 60" title:@"Alert" controller:self haveToPop:NO];
            //isValidated = NO;
        }else if(![Utility isEmptyCheck:nMinCarb.text] && [nMinCarb.text intValue] > [nMaxCarb.text intValue]){
            [Utility msg:@"Min carb cannot greater than Max carb" title:@"Alert" controller:self haveToPop:NO];
            isValidated = NO;
            
        }
    }else if (textField.tag == 2){
        if(![Utility isEmptyCheck:nMaxCarb.text] && !([nMaxCarb.text intValue] > 0 && [nMaxCarb.text intValue]<=100)){
            [Utility msg:@"Max carb must be between 0 and 100" title:@"Alert" controller:self haveToPop:NO];
            isValidated = NO;
        }else if(![Utility isEmptyCheck:nMaxCarb.text] && [nMinCarb.text intValue] > [nMaxCarb.text intValue]){
            [Utility msg:@"Max carb cannot less than Min carb" title:@"Alert" controller:self haveToPop:NO];
            isValidated = NO;
            
        }
    }else if (textField.tag == 3){
        if(![Utility isEmptyCheck:sWorkCal.text] && !([sWorkCal.text intValue] > 0 && [sWorkCal.text intValue]<5000)){
            [Utility msg:@"Cal must be between 100 and 5000" title:@"Alert" controller:self haveToPop:NO];
            isValidated = NO;
        }
    }else if (textField.tag == 4){
        if(![Utility isEmptyCheck:sMinCarb.text] && !([sMinCarb.text intValue] > 0 && [sMinCarb.text intValue]<60)){
            //[Utility msg:@"Min carb must be between 0 and 60" title:@"Alert" controller:self haveToPop:NO];
            //isValidated = NO;
        }else if(![Utility isEmptyCheck:sMinCarb.text] && [sMinCarb.text intValue] > [sMaxCarb.text intValue]){
            [Utility msg:@"Min carb cannot greater than Max carb" title:@"Alert" controller:self haveToPop:NO];
            isValidated = NO;
            
        }
    }else if (textField.tag == 5){
        if(![Utility isEmptyCheck:sMaxCarb.text] && !([sMaxCarb.text intValue] > 0 && [sMaxCarb.text intValue]<=100)){
            [Utility msg:@"Max carb must be between 0 and 100" title:@"Alert" controller:self haveToPop:NO];
            isValidated = NO;
        }else if(![Utility isEmptyCheck:sMaxCarb.text] && [sMinCarb.text intValue] > [sMaxCarb.text intValue]){
            [Utility msg:@"Max carb cannot less than Min carb" title:@"Alert" controller:self haveToPop:NO];
            isValidated = NO;
            
        }
    }else if (textField.tag == 6){
        if(![Utility isEmptyCheck:dWorkCal.text] && !([dWorkCal.text intValue] > 0 && [dWorkCal.text intValue]<5000)){
            [Utility msg:@"Cal must be between 100 and 5000" title:@"Alert" controller:self haveToPop:NO];
            isValidated = NO;
        }
    }else if (textField.tag == 7){
        if(![Utility isEmptyCheck:dMinCarb.text] && !([dMinCarb.text intValue] > 0 && [dMinCarb.text intValue]<60)){
            //[Utility msg:@"Min carb must be between 0 and 60" title:@"Alert" controller:self haveToPop:NO];
            //isValidated = NO;
        }else if(![Utility isEmptyCheck:dMinCarb.text] && [dMinCarb.text intValue] > [dMaxCarb.text intValue]){
            [Utility msg:@"Min carb cannot greater than Max carb" title:@"Alert" controller:self haveToPop:NO];
            isValidated = NO;
            
        }
    }else if (textField.tag == 8){
        if(![Utility isEmptyCheck:dMaxCarb.text] && !([dMaxCarb.text intValue] > 0 && [dMaxCarb.text intValue]<=100)){
            [Utility msg:@"Max carb must be between 0 and 100" title:@"Alert" controller:self haveToPop:NO];
            isValidated = NO;
        }else if(![Utility isEmptyCheck:dMaxCarb.text] && [dMinCarb.text intValue] > [dMaxCarb.text intValue]){
            [Utility msg:@"Max carb cannot less than Min carb" title:@"Alert" controller:self haveToPop:NO];
            isValidated = NO;
            
        }
    }
    if (!bmrView.hidden) {
        return;
    }
    if(isValidated){
        isCmp = true;
        [self customMealSave];
    }else{
        textField.text = @"";
    }
    
}
#pragma mark - End

#pragma  mark -DatePickerViewControllerDelegate
-(void)didSelectDate:(NSDate *)date{
    NSLog(@"%@",date);
    if (date) {
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        selectedDate = date;
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];// MMM d yyyy
        NSString *dateString = [dateFormatter stringFromDate:date];
        [dobButton setTitle:dateString forState:UIControlStateNormal];
    }
}

@end
